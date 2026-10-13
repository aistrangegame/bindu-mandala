# G6 · index proof

Indexer G6, 13 Oct 2026. The brief was `waves/upgrade/INDEX-BRIEF.md`, and `waves/register/READER-BRIEF-2.md` was read first. Output: `waves/upgrade/index/G6.jsonl`, **1,078 rows**, ids G6-0001 to G6-1078. Nothing outside these two files was modified.

## Files read

Each file was read with the Read tool, line 1 to the end, in contiguous pages.

| File | wc -l | md5 (8) | Ranges read | Rows extracted |
|---|---|---|---|---|
| `waves/register/15-airtable-map.md` | 1,632 | c7a5d066 | 1–200, 200–349, 350–549, 550–748, 749–947, 948–1146, 1147–1315, 1316–1633 | 624 |
| `waves/register/16-airtable-asg.md` | 396 | 2654c380 | 1–233, 234–397 | 157 |
| `waves/register/17-code-core.md` | 1,004 | e1399a2f | 1–250, 250–509, 510–769, 770–1005 | 178 |
| `waves/register/18-code-homes.md` | 236 | 5b50de32 | 1–237 | 119 |
| `waves/register/READER-BRIEF-2.md` (context, not indexed) | — | — | in full | 0 |

## How the rows were built

**15 · The Map.** There is one row per chakra for each Map field the app does not carry: Teaching Text, Post-Engagement Teaching, Shakti Function, Tree Caption, Story Portal Headline, Linked Builds, Shakti Practice (substrate), Gaia Voice (substrate), Dyad Description (12), Colour Dyad (10), Panel Verb (10), Panel Seed Message (9) and Mind Triad (9). There is also one row per chakra for each field that is carried but never shown: Subtle Mirror, Shakti Name, Shakti Mudra and Body Location. Each row gives the size, the paragraph count, the first and last line or the full text exactly as the register quotes it, and the register's hand lines.

Fields that are identical in shape across the chakras, or that are metadata, get one row each. Each such row lists where all 33 values sit in the register. These are Tree, Threshold Architecture, Build Status, URL, Linked Seed, Gaia, App Activity, OLD Pair Partner, Activation Mode, Codex References, and System / Stage / Primary Color / Avarana.

The rest of the register is also indexed:
- 32 "room dossier" rows hold the key lines of the fields that are carried and shown.
- The A.6 structures each get rows: the mudrā chain, the yantra facts per āvaraṇa, the glosses, the mirror graph, the body couples, the dyads, the Mind ring, the panels, the 20 portable practices, and the numbers and timings.
- There is a row for each of gifts #1–47 and for C1–C18.

Per-chakra values were parsed by script from the register's own dossier and table lines, so every source cites the exact register line.

**16 · ASG base.** Rows cover:
- each of the 33 tables, as a data source;
- the link map and the missing person-to-yantra link;
- the Relationships aggregates;
- Special Days and Timeline, by shape only;
- the 20 Walks, one row each with authored vow, exit and question lines;
- the Threshold Invitations;
- the Builds counts, the 9 Awakening Sounds (one row each), dances, songs and Play pages;
- the 10 Learning Page forms;
- the 9 Archetype Declarations (one row each), and Identity sets;
- App Activity usage, and what the app reads today;
- gifts #1–43 and C2–C14.

**17 · Code core.** There is one parity row for each file in the inventory (status built / partial / wrong, with file:line refs). There are separate defect rows, gifts #1–42 with their code refs, and the 11 code-level gaps. The conflicts are split into their parts: C-6 into its five restriction lines, C-10 into 3, C-12 into 4, C-13 into 3, and C-14 into 8 stale comments.

**18 · Code homes.** There is one row per file in the A.1 and A.2 tables (45 + metal) and one row per line of the 42-line parity table, with the status mapped as BUILT → built, PARTLY / BUILT DIFFERENTLY → partial, NOT BUILT → not-built, and BUILT WRONG / INVERTED → wrong. There are also rows for the 7 tap→render trace steps, the 4 "why it looks basic" causes, the 3 short answers, upgrade items C1–C10, Her Presence parity, and the 5 gaps.

## Rows per world (one row can name several worlds)

the-33 562 · her-home 269 · climb 199 · today-rite 159 · rings 134 · memory 105 · sound 95 · visual 91 · bindu-feed 82 · time 70 · relationship 64 · data 54 · modes 54 · her-presence 47 · well 46 · mandala 43 · game 34 · spine 31 · verification 27 · home 21 · beneath 18.

## Floors kept

- **Chakra 32.** Its rows give field names and sizes only. The only exceptions are the public identity cells (Bhagamalini, Sarva Beeja, practice-page title). No Reveal text is quoted, and a script asserts that the reveal strings 17 C-2 cites are absent from the output.
- **Author substrate.** Gaia Voice and Shakti Practice rows give sizes only.
- **Privacy.** Journal tables appear as schema and counts only. Family birthdays are cited by register line and not copied. The private Walks Entry rows are not copied. Individual friend names are left in the register (16:146–150).
- **Rulings 11–17.** Each is noted on the rows it touches. Examples: ruling 13 on the Mind order (C3), ruling 14 on Vision's mirror, ruling 15 on the after-effect and "stood here before", ruling 16 on the lifted limits, and the settled point "Ring 7 mudrā Khecharī" (C11).
