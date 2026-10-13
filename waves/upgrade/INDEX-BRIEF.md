# Index brief — every item in the register, placed (stage 1 of the upgrade map)

The register (`waves/register/01…22-*.md`, ~25,800 lines) is the full reading of everything for Bindu Mandala. Before the upgrade map can be written world by world, every item in it has to be pulled into one index, so that nothing is compressed or lost. You are one of seven indexers. Read `waves/register/READER-BRIEF-2.md` first (the foundation, the fifteen worlds, the rulings), then the rulings 11–17 below, then your assigned register files **in full, line 1 to the end, with the Read tool**.

Rulings 11–17 (12 Oct night): 11 Relationship Field built from Design + the three existing connections (Gaia·Ahaṅkāra kp31, Ashrey·Nāma kp40, Ram·Ātmā kp42), no new Airtable fields. 12 Songs come from his own recordings on GitHub (`waves/register/audio-on-github.md`: 44 unique mp3s, incl. tree-of-life/<chakra>.mp3 for the nine chakra rooms). 13 Positions stay; the Mind section is walked in the Map's own sequence (Innocence first from Armin … Integration last). 14 Vision: mirror door → Manipura; sounds OM (Ajna). 15 After-effect felt, never named (drop "her siddhi is still on the instrument"); "you have stood here before" returns once inside her room, with floor traces as light; Climb's 102 lights stay alike. 16 App-added limits lifted (closing stations, twice-daily opening, grace's rest, Leela "never in the first days"); his own stay (dissolutions once a day; Leela ≥3 days apart then 30%). 17 Everything shown word for word, revealed through each room's form, never as a page; only chakra 32's Reveal stays sealed. Also settled: App Activity is the single ledger; no counts about him; Recognition lines verbatim; Design's lines count as authored; Mandala/Map colours win; Maya 30, Ātma 31; Ring 7 mudrā Khecharī; bījas may sit in the yantra; no generated voice; each room keeps its fixed tone and a song's drone plays only during its dance; one tuning (Design's ring roots); story material goes to Bindu Feed.

## What to extract

Every distinct item: each gift, each Design element and its build status, each mechanism with numbers, each conflict, each floor, each data source, each verification idea, each defect. If an item appears in several places in your files, write it once and list all sources. Do not summarise several items into one row. Err on more rows.

## Output

Write `waves/upgrade/index/<your group>.jsonl` — one JSON object per line:

```
{"id":"G3-0412",
 "title":"short name",
 "worlds":["the-33"],            // from: spine, home, today-rite, mandala, rings, her-home, her-presence, climb, the-33, game, modes, time, memory, well, beneath, relationship, sound, visual, data, verification, bindu-feed
 "kind":"gift|design-element|mechanism|conflict|floor|ruling|data|defect|verification|asset",
 "what":"exact description with every number, timing, colour, Hz, count, verbatim line as written in the register",
 "how":"how it works in the app (mechanism, not mood)",
 "needs":"data fields / assets / code / permissions",
 "status":"built|partial|not-built|wrong|n/a",
 "code":"file:line refs if the register gives them",
 "frames":"F-ids if any",
 "nature":"energy|story|both",
 "sources":["05-chakra-corpus.md:1622-1640", "..."],
 "notes":"conflicts, open questions, which ruling applies"}
```

Then a short `waves/upgrade/index/<your group>-proof.md`: each assigned file, its line count, the ranges you read, and the number of rows you extracted from it. Return: the jsonl path, row count, rows per world.
