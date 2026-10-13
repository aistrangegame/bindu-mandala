# Airtable corrections — 13 Oct 2026 (U0-A)

Base `app248ZTWhYJlvQj2`. Spec: `waves/upgrade/worlds/data.md` §4.2. Before-image: raw export taken immediately before the edits (`waves/upgrade/snapshot/raw-before-2026-10-13/`, gitignored); after-image: raw export taken immediately after (`raw-after-2026-10-13/`, gitignored). Every line below was verified by diffing the two full exports (every record, every field, by id) and the two schema reads: the only differences between them are exactly the cells and descriptions listed here. No record, field or select choice was deleted or added.

## Summary

| # | Cells / descriptions changed | Note |
|---|---|---|
| C01 | 3 cells (Etymology fldXypzqrhVILCqgh, kp 58, 59, 62) | only the misspelled word replaced |
| C02 | 1 cell (Function fldzT3dAhsAK75rKN, kp 59; 2 occurrences in it) | |
| C03 | 9 cells (Mudra of Avarana fld1C14f4MsVIrA9F, all nine Āvaraṇa rows) | parenthetical glosses kept |
| C04 | 65 cells (Avarana Name fldXTUBJTDlkKEzEV) of 111 rows in scope | 46 already equal to the IAST name (ring 1 ×29, ring 7 ×13, ring 8 ×4 — their ASCII and IAST spellings coincide); ring 2 Śakti rows carried "Sarvāśā-Paripūraka Cakra" and were set to "Sarvāśāparipūraka" with the rest; ring taken from the Avarana select |
| C08 | 2 cells (The Map, Maya recMyqKSqwRnimgvy: Signature Phrase, Panel Seed Message) | Bindu Reflection untouched |
| C09 | 1 description (Seed Verb fldVgkRZmbc7STB7S) | |
| C10 | 1 description (Function fldzT3dAhsAK75rKN) | appended |
| C11 | **not made** | the Airtable field-update tool (and the Web API it wraps) changes only a field's name, description or formula; select choices cannot be added without either a schema tool that does not exist here or a typecast record write (creating App Activity rows), which this step must not do. The app's typecast keeps working meanwhile. Needs Ashrey (or a later session with a choice-capable tool) to add the 21 Activity Types and 8 Gesture Sources in the Airtable UI. |
| C13 | 11 descriptions (The Map) | appended "walk-canon key: …" |

## Cell edits, before → after

| C | Table | Record | kp / ring | Field | Before | After |
|---|---|---|---|---|---|---|
| C01 | Mandala | recD8hZhpyOoXWS68 | kp 58 (4th) | Etymology `fldXypzqrhVILCqgh` | "Sarva + Sthambhinī (paralyzer / stabilizer) — 'she who stabilizes all.' The pause that is also strength." | "Sarva + Stambhinī (paralyzer / stabilizer) — 'she who stabilizes all.' The pause that is also strength." |
| C01 | Mandala | recXaybSBwdlsBIT7 | kp 59 (4th) | Etymology `fldXypzqrhVILCqgh` | "Sarva + Jṛmbha (yawn / stretch / expansion) + inī — 'she who expands all,' the yawning-open. Counterpart to Sthambhinī." | "Sarva + Jṛmbha (yawn / stretch / expansion) + inī — 'she who expands all,' the yawning-open. Counterpart to Stambhinī." |
| C01 | Mandala | recF2oZhbPZ8QOdsS | kp 62 (4th) | Etymology `fldXypzqrhVILCqgh` | "Sarva + Onmādinī (the intoxicator) — 'she who intoxicates all.' Devi-form of the 5th-opening Mudra." | "Sarva + Unmādinī (the intoxicator) — 'she who intoxicates all.' Devi-form of the 5th-opening Mudra." |
| C02 | Mandala | recXaybSBwdlsBIT7 | kp 59 (4th) | Function `fldzT3dAhsAK75rKN` | "Counterpart to Sthambhinī — Her expansion balances Sthambhinī's stillness." | "Counterpart to Stambhinī — Her expansion balances Stambhinī's stillness." |
| C03 | Mandala | rec0XhDKfxW8UVyaB | Āvaraṇa 1st | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Sankshobhini Mudra (All-Agitating)" | "Sarva-Saṅkṣobhiṇī Mudrā (All-Agitating)" |
| C03 | Mandala | recspOpR95DVcOEvn | Āvaraṇa 2nd | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Vidravini Mudra (All-Liquefying)" | "Sarva-Vidrāviṇī Mudrā (All-Liquefying)" |
| C03 | Mandala | recp4X5tuGdLuHCVw | Āvaraṇa 3rd | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Akarshini Mudra (All-Attracting)" | "Sarva-Ākarṣiṇī Mudrā (All-Attracting)" |
| C03 | Mandala | reck0o3CUIpc1Fc3p | Āvaraṇa 4th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Vashankari Mudra (All-Subjugating)" | "Sarva-Vaśaṅkarī Mudrā (All-Subjugating)" |
| C03 | Mandala | recXWmYtaMBafQTg0 | Āvaraṇa 5th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Onmadini Mudra (All-Intoxicating)" | "Sarva-Unmādinī Mudrā (All-Intoxicating)" |
| C03 | Mandala | recAoU8p9NZHlqVBA | Āvaraṇa 6th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Mahankusha Mudra (All Great-Goading)" | "Sarva-Mahāṅkuśā Mudrā (All Great-Goading)" |
| C03 | Mandala | recpHi1ydFrb3bLH6 | Āvaraṇa 7th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Khechari Mudra (All Sky-Walking)" | "Sarva-Khecarī Mudrā (All Sky-Walking)" |
| C03 | Mandala | rec3sxt1ZQ3T036sZ | Āvaraṇa 8th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Beeja Mudra (All-Seed)" | "Sarva-Bīja Mudrā (All-Seed)" |
| C03 | Mandala | recqdC3D38TWFkf1M | Āvaraṇa 9th | Mudra of Avarana `fld1C14f4MsVIrA9F` | "Sarva-Yoni Mudra and Trikhanda Mudra" | "Sarva-Yoni Mudrā and Trikhaṇḍā Mudrā" |
| C04 | Mandala | reci0BzVSkohuZfoz | kp 102 (9th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvanandamaya" | "Sarvānandamaya" |
| C04 | Mandala | recVTjgXCpARyvRGN | kp 29 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recap8JSVoddYXaKd | kp 30 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | reckPADJbqMnyFjXL | kp 31 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recU9ziofCtiEat1Z | kp 32 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recrt4BXZlT9f8gKu | kp 33 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recFYMK6cmtwgsChZ | kp 34 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recPb0uRoAK7r5jMs | kp 35 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | reclBDgaECxn1v3Ih | kp 36 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | reccxg6YdaOe7NVHN | kp 37 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recLyAS9LAYt18Yfi | kp 38 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | rec2iQRUZuiwWgtTo | kp 39 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recJX5TCNHmicMDhh | kp 40 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recQdvLIHlKLUbxIg | kp 41 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recw0vkYYOPa1vcBL | kp 42 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recJK36R2jK5qVOCQ | kp 43 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recVjJTPkaNHajJK0 | kp 44 (2nd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvāśā-Paripūraka Cakra" | "Sarvāśāparipūraka" |
| C04 | Mandala | recJiNakDCJaDJyot | kp 45 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recT0MykzVdg5kZEQ | kp 46 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | rec6woq9l7rksMn0K | kp 47 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recV9r1MTrMj4NZ9Y | kp 48 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recMEM11wK3X3H8ZZ | kp 49 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recJkpYPJN2bvE1yZ | kp 50 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recLLf3yU7GeI0xw8 | kp 51 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | rec6q414oCvDG5RTc | kp 52 (3rd) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | recookwVJWiLej7y3 | kp 53 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recaWLWmaWTfvi8fs | kp 54 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | reczzCOB3d56PSNdl | kp 55 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | rec0OqWpYSieV9GmP | kp 56 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recQZyO4hqU26eD31 | kp 57 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recD8hZhpyOoXWS68 | kp 58 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recXaybSBwdlsBIT7 | kp 59 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | rec8Uz1S0OhxrdrT2 | kp 60 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recgJqvLJ42w8TXAv | kp 61 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recF2oZhbPZ8QOdsS | kp 62 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recCJV9cVEdYPanZD | kp 63 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recjaW9afQhInwat7 | kp 64 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recltZAaDd0UdfjFT | kp 65 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recPkcjATHYrcGnrU | kp 66 (4th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recQjI5GfERS78nK7 | kp 67 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recPa3kJZupLAXDL1 | kp 68 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recOd2lzI8Mus9QUr | kp 69 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | reciamxH4pCermB53 | kp 70 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recCmLEv0tULOMnxu | kp 71 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recaRbB6OIbmtx8q0 | kp 72 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recjV24TdQsfOQ4v9 | kp 73 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recG8I9KyOfZC1Rwr | kp 74 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recRfWFeZJDazfifM | kp 75 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | rec0j57A4mexRk9sS | kp 76 (5th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | rec4VTNL4ad3dzcnZ | kp 77 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | reck7AE33V5sOatH7 | kp 78 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recT70dKmBmSxzDbp | kp 79 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | rec1cRwJnGrzQISFm | kp 80 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | rechcv8QLaPt7cwY1 | kp 81 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recKKqvC77cwWkd6E | kp 82 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | rech4Yf1Za9yXpCGZ | kp 83 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recFxL9NPl7aEohyG | kp 84 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recU5miADNDkRNR4m | kp 85 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recYfygfxeHxIvkGZ | kp 86 (6th) | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recspOpR95DVcOEvn | Āvaraṇa 2nd | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaparipuraka" | "Sarvāśāparipūraka" |
| C04 | Mandala | recp4X5tuGdLuHCVw | Āvaraṇa 3rd | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasankshobhana" | "Sarvasaṅkṣobhaṇa" |
| C04 | Mandala | reck0o3CUIpc1Fc3p | Āvaraṇa 4th | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvasaubhagyadayaka" | "Sarvasaubhāgyadāyaka" |
| C04 | Mandala | recXWmYtaMBafQTg0 | Āvaraṇa 5th | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarthasadhaka" | "Sarvārthasādhaka" |
| C04 | Mandala | recAoU8p9NZHlqVBA | Āvaraṇa 6th | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvarakshakara" | "Sarvarakṣākara" |
| C04 | Mandala | recqdC3D38TWFkf1M | Āvaraṇa 9th | Avarana Name `fldXTUBJTDlkKEzEV` | "Sarvanandamaya" | "Sarvānandamaya" |
| C08 | The Map | recMyqKSqwRnimgvy | Maya | Signature Phrase `flddjDTJBa0o4KyLS` | "There was never anything to fear. There was only the Bindu, playing." | "There was never anything to fear. There was only You, playing." |
| C08 | The Map | recMyqKSqwRnimgvy | Maya | Panel Seed Message `fldwFamC9FndA94if` | "There was never anything to fear. There was only the Bindu, playing." | "There was never anything to fear. There was only You, playing." |

## Field descriptions, before → after

### C10 — Function `fldzT3dAhsAK75rKN` (Mandala)

Before:

```
Her cosmic role. What She does in the dynamics of creation/sustenance/dissolution. E.g. for Kameshvari: 'Holds the will-to-create at the source. Without her, no movement begins.'
```

After:

```
Her cosmic role. What She does in the dynamics of creation/sustenance/dissolution. E.g. for Kameshvari: 'Holds the will-to-create at the source. Without her, no movement begins.'

kp 29–44: drafted by Claude (12 Oct 2026), kept by Ashrey's ruling 7.
```

### C09 — Seed Verb `fldVgkRZmbc7STB7S` (Mandala)

Before:

```
Wave 6 · her one verb in the seed ledger: no two of the 102 share a verb. Written by Ashrey; empty until he writes it. Read by Bindu Mandala.
```

After:

```
Wave 6 · her one verb in the seed ledger: no two of the 102 share a verb. Drafted by Claude from her name, etymology and Function, approved by Ashrey; live only once he accepts it. Read by Bindu Mandala.
```

### C13 — Story Thread `fldIOc83AOzSiDmgi` (The Map)

Before:

```
The narrative voice traveling from Bindu to Lalita — the story passage that lives between chakras
```

After:

```
The narrative voice traveling from Bindu to Lalita — the story passage that lives between chakras

walk-canon key: leela_story
```

### C13 — Act 1 Voice `fldopinrnQ5W0T8kE` (The Map)

Before:

```
Act 1 content — Gaia journey-voice, tap-to-advance. The walker moves through the experience.
```

After:

```
Act 1 content — Gaia journey-voice, tap-to-advance. The walker moves through the experience.

walk-canon key: story_thread
```

### C13 — Act 2 Voice `fldnALQ6e9iF7fmnO` (The Map)

Before:

```
Act 2 content — Sakshi witness-voice, auto-paced. The witness reflects what was walked.
```

After:

```
Act 2 content — Sakshi witness-voice, auto-paced. The witness reflects what was walked.

walk-canon key: interlude
```

### C13 — Shakti Practice `fldJqK4zLO7CNiWRu` (The Map)

Before:

```
The Sri Yantra-informed practice for this chakra — how the Shakti's intelligence enriches the experience
```

After:

```
The Sri Yantra-informed practice for this chakra — how the Shakti's intelligence enriches the experience

walk-canon key: app_build_note
```

### C13 — Hero Threshold `fldMA4kqwUTYsGFBs` (The Map)

Before:

```
The poetic sub-line under the verb on the hero screen. First thing the walker reads after the verb — sets the register before anything else.
```

After:

```
The poetic sub-line under the verb on the hero screen. First thing the walker reads after the verb — sets the register before anything else.

walk-canon key: seed_message
```

### C13 — Story Portal Headline `fldX55ru3s5OByoXd` (The Map)

Before:

```
The invitation text inside the Story Portal — the specific voice of each chakra's entry point into Story Mode.
```

After:

```
The invitation text inside the Story Portal — the specific voice of each chakra's entry point into Story Mode.

walk-canon key: threshold_hint
```

### C13 — Bindu Reflection `fldGfgZtoGNZTqIEM` (The Map)

Before:

```
Bindu's own integrative voice after passing through the chakra — speaking about the experience from inside it, after it has happened. Distinct from Act 1 Voice (Bindu in the moment) and Act 2 Voice (Sakshi watching).
```

After:

```
Bindu's own integrative voice after passing through the chakra — speaking about the experience from inside it, after it has happened. Distinct from Act 1 Voice (Bindu in the moment) and Act 2 Voice (Sakshi watching).

walk-canon key: after_story
```

### C13 — Leela Story `flduxpB6EM5tFRxUe` (The Map)

Before:

```
The Leela story for this chakra — filled on all 33. Shown in Bindu Mandala's chakra room after its gate is walked, and drawn on for Leela drops.
```

After:

```
The Leela story for this chakra — filled on all 33. Shown in Bindu Mandala's chakra room after its gate is walked, and drawn on for Leela drops.

walk-canon key: gate_text
```

### C13 — Post-Engagement Teaching `fldC2OAa6NYrxrxWC` (The Map)

Before:

```
The deeper-recognition essay that appears AFTER the walker has engaged with the writing prompt — titled 'What the [Heart / Throat / Third Eye / etc] Knows That You Forgot' on the page. Distinct from Teaching Text (which is the entry recognition). This is the load-bearing reframe that lands only after the walker has done something. Voice is direct, sometimes confrontational, always returning the walker to what their faculty actually is. Example (Ajna): 'You have not been a failed intuitive. You have been a highly successful prevention-of-intuition, operating so consistently that the data was being filtered out before it could register as data...'
```

After:

```
The deeper-recognition essay that appears AFTER the walker has engaged with the writing prompt — titled 'What the [Heart / Throat / Third Eye / etc] Knows That You Forgot' on the page. Distinct from Teaching Text (which is the entry recognition). This is the load-bearing reframe that lands only after the walker has done something. Voice is direct, sometimes confrontational, always returning the walker to what their faculty actually is. Example (Ajna): 'You have not been a failed intuitive. You have been a highly successful prevention-of-intuition, operating so consistently that the data was being filtered out before it could register as data...'

walk-canon key: bindu_reflection
```

### C13 — Three Ways In `fldrlqps5wS0lWxd5` (The Map)

Before:

```
Three concrete practice variations — different entry points for the same chakra register, for walkers whose bodies call to different modes. Always three, distinct in approach but converging in effect.

ENERGY CHAKRAS — Three Ways In: inward practices toward stillness, inner sensation, and the subtle register. Each option starts with a bold instruction.

BODY CHAKRAS — Three Ways Out: outward practices through the specific body part into physical reality and feeling. Three-part pattern per chakra: (1) The body part as instrument — using the physical surface deliberately with full specificity. (2) What the body feels through that part — the sensation register as data, not metaphor. (3) Taking it into a real-world engagement — walking the activated practice into an actual conversation, decision, or moment today.

The HTML renders these under the heading 'Three Ways In' (Energy) or 'Three Ways Out' (Body).
```

After:

```
Three concrete practice variations — different entry points for the same chakra register, for walkers whose bodies call to different modes. Always three, distinct in approach but converging in effect.

ENERGY CHAKRAS — Three Ways In: inward practices toward stillness, inner sensation, and the subtle register. Each option starts with a bold instruction.

BODY CHAKRAS — Three Ways Out: outward practices through the specific body part into physical reality and feeling. Three-part pattern per chakra: (1) The body part as instrument — using the physical surface deliberately with full specificity. (2) What the body feels through that part — the sensation register as data, not metaphor. (3) Taking it into a real-world engagement — walking the activated practice into an actual conversation, decision, or moment today.

The HTML renders these under the heading 'Three Ways In' (Energy) or 'Three Ways Out' (Body).

walk-canon key: go_deeper
```

### C13 — Gate Text `fld1rj2QuUuuGvvqc` (The Map)

Before:

```
The physical action instruction that appears in the gate section BEFORE the walker unlocks the content. Contains the full gate-sub text plus the gate button label. This is what the walker actually DOES first — the practice that precedes the teaching. Example (Soles): 'Stand up. Take your shoes off if you can. Feel the ground under your feet. Press down. When you feel the earth press back — tap. | Button: I feel the ground'. Example (Sonar): 'Find the precise word for how you’re feeling right now. Not “tired” — depleted, heavy, fading, wrung? Say it out loud. | Button: I said it'.
```

After:

```
The physical action instruction that appears in the gate section BEFORE the walker unlocks the content. Contains the full gate-sub text plus the gate button label. This is what the walker actually DOES first — the practice that precedes the teaching. Example (Soles): 'Stand up. Take your shoes off if you can. Feel the ground under your feet. Press down. When you feel the earth press back — tap. | Button: I feel the ground'. Example (Sonar): 'Find the precise word for how you’re feeling right now. Not “tired” — depleted, heavy, fading, wrung? Say it out loud. | Button: I said it'.

walk-canon key: gate_interaction
```
