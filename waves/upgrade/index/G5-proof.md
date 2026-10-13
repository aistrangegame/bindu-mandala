# G5 proof — index of register files 12, 13, 14

Output: `waves/upgrade/index/G5.jsonl`, 1,216 rows, ids G5-0001 to G5-1216. Before indexing I read `READER-BRIEF-2.md` (42 lines) in full, along with rulings 11–17 in `INDEX-BRIEF.md`.

## Files read

| file | wc -l | ranges read (Read tool) | md5 (8) | rows citing it | rows with it as first source |
|---|---|---|---|---|---|
| `12-padakarshini-field.md` | 1602 | 1–400, 400–799, 800–1099, 1100–1359, 1360–1602 | 88003aee | 844 | 841 |
| `13-rupakarshini.md` | 1165 | 1–300, 300–579, 580–879, 880–1165 | 1a05057d | 366 | 202 |
| `14-aistrangegame.md` | 1320 | 1–330, 330–659, 660–999, 1000–1320 | a417bcbc | 183 | 173 |

Notes:
- An item that appears in more than one place or file is written once, with every source listed. That is why the "citing" counts add up to more than 1,216.
- **The 511 topic rows.** File 12 Appendix A12 (lines 1091–1601) is the per-topic placement table. After reading it in full, I turned it into one row per topic with a parser: 511 rows, each titled "Topic: …", kind `data`, sourced to its own line.
  - The topic's world code is mapped to the world list, and its E/S/E-S mark sets `nature`.
  - Topics marked L (Bindu Learning) or H (held) use `nature: "n/a"`. If no app world applies, they use `worlds: ["data"]`.
  - Their placements are reader 12's judgements for Ashrey to rule on, not settled placements; each row's notes say so.
- **File 13 visual rows** (as instructed):
  - The B1 per-world language map is 15 rows, one per world, titled "Visual language for …". Each has world `visual` plus that world.
  - The B2 SwiftUI token port is one row per token family, titled "Token family …". There are 19: slot grammar/Chassis enum, Mandala, ChakraTable, Lalita, Leela, Play, Ascent, Field, Being, Learning, Feed, Candle, Blink, Linen, Motion, Pace, Space and scales, Spine roles, and Fonts. Haptics is folded into the "Haptic family" row.
  - Each token row merges every A5 token value with its B2 Swift values.

## Rows

- **Total:** 705 item rows + 511 topic rows = 1,216.
- **By kind:**

  | kind | rows |
  |---|---|
  | data | 623 |
  | design-element | 262 |
  | mechanism | 176 |
  | verification | 32 |
  | conflict | 29 |
  | floor | 28 |
  | ruling | 27 |
  | gift | 23 |
  | defect | 14 |
  | asset | 2 |

- **By world** (a row can sit in several worlds):

  | world | rows |
  |---|---|
  | data | 379 |
  | the-33 | 159 |
  | bindu-feed | 149 |
  | visual | 112 |
  | spine | 86 |
  | modes | 78 |
  | climb | 73 |
  | verification | 70 |
  | today-rite | 68 |
  | home | 66 |
  | game | 61 |
  | beneath | 60 |
  | memory | 52 |
  | relationship | 51 |
  | well | 45 |
  | mandala | 39 |
  | time | 38 |
  | sound | 36 |
  | her-home | 33 |
  | rings | 27 |
  | her-presence | 21 |

- **Validation:** no errors. Every world, kind, status and nature value is from the allowed sets, and every cited line number is inside its file.
