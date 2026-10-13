# G3 · proof of reading

Indexer G3. I read `INDEX-BRIEF.md` and `register/READER-BRIEF-2.md` (42 lines) in full first. Then I read both assigned register files in full, line 1 to the end, with the Read tool. I wrote nothing outside `waves/upgrade/index/G3.jsonl` and this file. Working chunks sit in my scratchpad.

| File | Lines (`wc -l`) | md5 (first 8) | Ranges read (Read tool) | Rows extracted |
|---|---|---|---|---|
| `register/06-chakra-skills.md` | 2616 | d85befa7 | 1–450, 450–849, 850–1249, 1250–1649, 1649–2048, 2048–2347, 2347–2616 | 325 |
| `register/07-codex.md` | 1386 | e802be59 | 1–350, 350–649, 650–929, 930–1179, 1180–1386 | 217 |
| **Total** | 4002 | | every line | **542** (G3-0001 … G3-0542) |

## How each file was split into rows

- **06 · the chakra skills.**
  - Each of the 33 rooms has one identity row (A.1) and one practice/sound/gate row (A.2).
  - Every per-chakra detail block in A.3 became its own rows: content and PBS lines, practice page, story acts (placed in bindu-feed), wake-up panel, Atlas, BCA room, build log and threshold.
  - Every B-section entry is its own row. That covers the V5 template, Story Mode, the Veil, Act 2, the gates, the lightbox, the 14 practice pages, the interlude and its 31 crossings, the trinity pages, the Practice Book and the daily practices.
  - It also covers the body gates, the shared panel template, P1–P10, the C-components, the dances, the layer pages L1–L4, the map pages, the Leela prototype and engine, The Draw, the Sakshi Pause, the 10 sketches, the BCA mechanics and the M-* cross-cutting mechanics.
  - Section C (the journey, Road Home tiers, the three pools, the bells, the Trinity of Guidance, K-W-A, Leela, the board rules, the laws and D1–D38) and the E must-not-miss items not already covered became rows too.
  - The coverage table in section D gave rows for the QR codes, the extraction JSON files and the Lakota sources.
- **07 · the Codex.**
  - All 198 §A entries (200 records) each have their own row. The kind is `ruling` for a LAW and `gift` for an ask or a place. Each row carries the C-number in its title and his words verbatim in `what`.
  - A script checked that the set of §A header C-numbers equals the set of C-numbers in the rows: 198 = 198, nothing missing.
  - The consolidated laws (§C.1), desires (§C.2) and must-not-miss items (§E) restate those records. Their line ranges were added to the `sources` of the matching C-row, not duplicated as new rows.
  - The C-1356 "batches" quote, which appears only inside law 17, was added to the C-1236 row.
  - Each §C.3 misread flag is its own `conflict` row. That covers C-1289, C-1350, C-1195, C-1307, C-1355, C-1284, C-1353 and C-1330, the unsourced "no menu", the C-1120 miscitation and "she was expecting you".
  - Other rows: the places vocabulary, the AI-written-records floor, the coverage measures, the word census and the three-app split.
  - The 152 non-relevant §B records are one `data` row, since none bears on the app.

## Rows per world (a row may carry several worlds)

the-33 280 · spine 121 · sound 64 · game 60 · memory 59 · today-rite 33 · climb 32 · data 31 · visual 30 · home 29 · her-home 21 · bindu-feed 16 · relationship 15 · mandala 14 · time 14 · verification 5 · rings 4 · her-presence 3 · beneath 3 · modes 2 · well 1

## Rows per kind

gift 182 · ruling 96 · mechanism 78 · design-element 78 · data 58 · conflict 34 · floor 9 · defect 3 · verification 3 · asset 1
