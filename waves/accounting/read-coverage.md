# Bindu Mandala project: what source material was actually read

Read-only audit, 2026-10-12. Evidence: the session transcripts on disk. Every number below was computed by `coverage.py` from tool calls and the text their results put in front of the model. The per-file table is `read-coverage.csv`, next to this file.

## How "read" was measured

- **Transcripts parsed (46).** Two main-thread files and 44 subagent files were parsed.
  - **Early phase.** The `/root/.claude/projects/-home-claude/…` main thread plus 20 subagents, 12:25–13:58 UTC. This was the "read everything" phase.
  - **Late phase.** The `/root/.claude/projects/-home-claude-bindu-mandala/…` main thread plus 24 subagents, 15:00 UTC to 01:36 UTC (13 Oct), covering Waves 1–6, the gap sweeps and the audits.
  - **Excluded.** Three audit agents started at 01:24 UTC are left out, this one included.
- **Content-based, not command-based.** A source line counts as read only when its text appears in a tool result that is tied to that file. A result is tied to a file when the call named the file, its folder, or an earlier output that was saved or redirected from it (including persisted `tool-results/*.txt` and `> scratch.txt` files that were read later). A result is also tied to a file when it contains at least 3 lines found nowhere else, which catches glob and loop reads.
  - `Read` results are checked line by line against the current file, so a file changed mid-session is not over-credited.
  - `grep`/`rg` output is **not** counted as reading. Only its hit-line count is reported, in the `grep_hit_lines` column.
  - `ls`, `wc`, `find` and `du` show names only.
- **Two measures; coverage is the higher of them.**
  - `line_coverage`: share of the file's distinctive lines (12+ characters with a word in them) whose text was shown.
  - `text_coverage`: share of its natural-text runs (30+ characters) that were shown. This credits HTML-to-text and string-extraction passes such as `h2t.py`/`txt.py`, which strip markup.
  - Images count as read only if the image itself was opened with `Read`.
- **Glimpse.** A file with coverage below 5% is listed as "glimpse", not as read.
- **What the measure cannot see:**
  - **Missing main-thread history.** The bindu-mandala main transcript on disk starts at its compaction boundary (20:36 UTC). The main thread's own tool calls from about 14:00 to 20:36 UTC are gone. The subagents for that window are intact. The compaction summary's task list marks "Read the Chakra Game corpus — All 69 files" as **pending** at compaction. The subagents shown below did read most of that corpus earlier, at 13:32–13:40 UTC.
  - **Reformatted output.** Output that a script printed in a changed form (JSON dumps, `repr`) is under-counted.
  - **Duplicate copies.** Identical copies of a file (handoff/, prototype/, repo copies) are flagged in `duplicate_of` and `identical_copy_read`. A file shown as unread may have an identical copy that was read.
- **Scope.** iOS source code is out of scope. `/home/claude/aistrangegame` is **not a site repo**: it holds an older clone of `github.com/aistrangegame/bindu-mandala`. Reads through that clone and through the Mac path `/Users/ashrey/Bindu Mandala` were mapped onto the repo docs. `ARRIVAL.md` exists only in that clone; `history/ARRIVAL-2026-09-23.md` is an identical copy.

## Counts by category

| Category | Files | Text lines | Size | Byte-weighted coverage | ≥95% | 50–95% | 5–50% | Glimpse <5% | No content seen |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| design | 162 | 46741 | 4.67 MB | 45% | 65 | 15 | 35 | 18 | 29 |
| chakra | 69 | 42142 | 7.14 MB | 75% | 55 | 0 | 12 | 0 | 2 |
| repo-doc | 135 | 41881 | 3.74 MB | 43% | 75 | 7 | 15 | 8 | 30 |
| repo-doc(clone-only) | 1 | 113 | 5.1 KB | 100% | 1 | 0 | 0 | 0 | 0 |
| skill | 683 | 258717 | 17.39 MB | 45% | 387 | 73 | 118 | 21 | 84 |
| **all** | 1050 | 389594 | 32.95 MB | 51% | 583 | 95 | 180 | 47 | 145 |

How each file was read (main method):

| Category | Read full | Read partial | bash full | bash partial | Read (image viewed) | glimpse only (<5% of content shown) | grep only | named in a command, no content seen | folder listed/scanned only | never touched |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| design | 18 | 0 | 33 | 50 | 14 | 18 | 2 | 0 | 27 | 0 |
| chakra | 46 | 1 | 1 | 12 | 7 | 0 | 0 | 1 | 1 | 0 |
| repo-doc | 38 | 2 | 36 | 21 | 0 | 8 | 7 | 5 | 18 | 0 |
| repo-doc(clone-only) | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| skill | 181 | 10 | 206 | 181 | 0 | 21 | 13 | 10 | 61 | 0 |

## Skills, one row per skill

The "references" columns count only files under `references/`. "Other" means the skill's further folders: builds/, scores/, scripts/, elements/, archetypes/ and the like.

| Skill | SKILL.md | refs: files | refs: size | refs: byte-weighted cov | refs <50% | other: files | other: cov | files with no content seen |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| bindu-mandala-app | rewritten this session; prior version read in full | 0 | 0.0 KB | – | 0 | 0 | – | 0 |
| asg-airtable | rewritten this session; prior version read in full | 1 | 6.5 KB | 100% | 0 | 0 | – | 0 |
| chakra-maps | 100% (Read full) | 30 | 1.36 MB | 37% | 17 | 2 | 6% | 0 |
| chakra-practices | 100% (Read full) | 37 | 1.85 MB | 19% | 16 | 0 | – | 1 |
| tree-of-life | 100% (Read full) | 78 | 2.05 MB | 20% | 48 | 0 | – | 31 |
| a-strange-game | 100% (Read full) | 41 | 547.7 KB | 72% | 3 | 2 | 100% | 1 |
| aistrangegame | 100% (Read full) | 21 | 259.1 KB | 75% | 4 | 2 | 5% | 1 |
| bindu-chakras-app | 100% (bash full) | 4 | 53.4 KB | 100% | 0 | 1 | 100% | 0 |
| bindu-field | 100% (Read full) | 38 | 1.01 MB | 53% | 9 | 125 | 21% | 46 |
| bindu-feed | 91% (Read partial) | 3 | 38.2 KB | 100% | 0 | 0 | – | 0 |
| bindu-being-app | 100% (bash full) | 37 | 345.3 KB | 90% | 2 | 0 | – | 0 |
| bindu-learning-app | 100% (Read full) | 0 | 0.0 KB | – | 0 | 0 | – | 0 |
| the-mirror | 100% (Read full) | 1 | 56.3 KB | 100% | 0 | 0 | – | 0 |
| the-field | 100% (Read full) | 2 | 26.8 KB | 100% | 0 | 54 | 100% | 0 |
| lalita-family | 100% (Read full) | 4 | 32.4 KB | 100% | 0 | 0 | – | 0 |
| rupakarshini | 100% (Read full) | 25 | 835.0 KB | 100% | 0 | 61 | 43% | 4 |
| padakarshini | 100% (Read full) | 27 | 1024.0 KB | 89% | 1 | 58 | 43% | 0 |
| shabdakarshini | 100% (bash full) | 9 | 51.4 KB | 100% | 0 | 0 | – | 0 |
| atlas-emergence | 100% (Read full) | 1 | 25.2 KB | 100% | 0 | 0 | – | 0 |

## Files never read at all (145)

These are files whose content never reached the model. Each was at most listed in a folder, named in a command, or matched by grep. Text and code files come first, then images.

### design: 29 never read (4 text/code, 25 images)

| File | Lines | Size | How |
|---|---:|---:|---|
| `design/.thumbnail` | 0 | 12.2 KB | folder listed/scanned only |
| `design/design_handoff_living_rite/prototype/shakti-data.js` | 310 | 14.7 KB | grep only |
| `design/shakti-data.js` | 310 | 14.7 KB | grep only |
| `design/uploads/homes-shakti-cards-rings-1-2-978c247c.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md, repo/Claude Chat/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | folder listed/scanned only |

Images never opened: `scratch/01-r3-gather.png`, `scratch/01-r3-states.png`, `scratch/02-r3-gather.png`, `scratch/02-r3-states.png`, `scratch/03-r3-gather.png`, `scratch/03-r3-states.png`, `scratch/r3-live.png`, `scratch/r3-r4-v2.png`, `scratch/r4-live.png`, `scratch/r5-flood.png`, `scratch/r6-one.png`, `scratch/r7-twelve.png`, `scratch/r8-check.png`, `scratch/ring1-focus.png`, `scratch/ring1-overview.png`, `scratch/ring1-v2.png`, `scratch/ring1-v3.png`, `scratch/ring2-fix.png`, `scratch/ring8-fix.png`, `scratch/veil-descent.png`, `screenshots/02-mandala-chime.png`, `screenshots/02-ring.png`, `screenshots/02-seat.png`, `screenshots/chime-flash.png`, `uploads/Screenshot 2026-05-27 at 6.58.45 PM.png`

### chakra: 2 never read (2 text/code, 0 images)

| File | Lines | Size | How |
|---|---:|---:|---|
| `chakra/.thumbnail` | 0 | 2.6 KB | folder listed/scanned only |
| `chakra/uploads/bindu-chakras-app.skill` | 0 | 32.1 KB | named in a command, not viewed |

### repo-doc: 30 never read (25 text/code, 5 images)

| File | Lines | Size | How |
|---|---:|---:|---|
| `repo/Claude Design Round 2/homes/_superseded/all-shaktis-data.js` | 332 | 21.2 KB | named in a command, no content seen |
| `repo/Claude Design Round 2/homes/homes-cards.js` | 266 | 29.9 KB | folder listed/scanned only |
| `repo/Claude Design Round 2/homes/homes-chambers.js` *(identical copy read: design/homes-chambers.js, design/handoff/homes-chambers.js)* | 769 | 37.5 KB | grep only |
| `repo/Claude Design Round 2/homes/homes-grammar.js` *(identical copy read: design/homes-grammar.js, design/handoff/homes-grammar.js)* | 831 | 37.5 KB | folder listed/scanned only |
| `repo/Claude Design Round 2/homes/homes-verify.js` *(identical copy read: design/homes-verify.js, design/handoff/homes-verify.js)* | 113 | 4.4 KB | folder listed/scanned only |
| `repo/Claude Design Round 2/prototype/_superseded/all-shaktis-data.js` | 332 | 21.2 KB | named in a command, no content seen |
| `repo/Claude Design Round 2/prototype/living-rite-mandala.jsx` *(identical copy read: design/living-rite-mandala.jsx, design/design_handoff_living_rite/prototype/living-rite-mandala.jsx)* | 480 | 33.7 KB | grep only |
| `repo/Claude Design Round 2/prototype/shakti-data.js` | 310 | 14.7 KB | folder listed/scanned only |
| `repo/Claude Design Round 2/prototype/tweaks-panel.jsx` | 542 | 24.2 KB | folder listed/scanned only |
| `repo/Claude Designs/.design-canvas.state.json` | 1 | 0.1 KB | named in a command, no content seen |
| `repo/Claude Designs/.thumbnail` | 0 | 2.8 KB | folder listed/scanned only |
| `repo/Claude Designs/DESIGN_SPEC.md` *(identical copy read: design/DESIGN_SPEC.md)* | 223 | 9.8 KB | folder listed/scanned only |
| `repo/Claude Designs/Mandala App.html` *(identical copy read: design/Mandala App.html)* | 176 | 6.9 KB | folder listed/scanned only |
| `repo/Claude Designs/Ring Worlds II.html` *(identical copy read: design/Ring Worlds II.html)* | 222 | 11.5 KB | grep only |
| `repo/Claude Designs/Ring Worlds.html` *(identical copy read: design/Ring Worlds.html)* | 190 | 9.9 KB | grep only |
| `repo/Claude Designs/The Memory Layer.html` *(identical copy read: design/The Memory Layer.html)* | 157 | 9.1 KB | grep only |
| `repo/Claude Designs/The Relationship Field.html` *(identical copy read: design/The Relationship Field.html)* | 132 | 5.6 KB | named in a command, no content seen |
| `repo/Claude Designs/The Temporal Layer.html` *(identical copy read: design/The Temporal Layer.html)* | 269 | 14.4 KB | grep only |
| `repo/Claude Designs/all-shaktis-data.js` | 332 | 21.2 KB | named in a command, no content seen |
| `repo/Claude Designs/design-canvas.jsx` | 966 | 48.5 KB | folder listed/scanned only |
| `repo/Claude Designs/relationship.jsx` *(identical copy read: design/relationship.jsx)* | 994 | 39.2 KB | grep only |
| `repo/Claude Designs/screens-v2.jsx` *(identical copy read: design/screens-v2.jsx)* | 872 | 34.4 KB | folder listed/scanned only |
| `repo/Claude Designs/screens.jsx` *(identical copy read: design/screens.jsx)* | 1161 | 45.0 KB | folder listed/scanned only |
| `repo/Claude Designs/shakti-data.js` | 310 | 14.7 KB | folder listed/scanned only |
| `repo/history/ARRIVAL-2026-09-23.md` *(identical copy read: repo/ARRIVAL.md)* *(session-authored)* | 113 | 5.1 KB | folder listed/scanned only |

Images never opened: `Claude Designs/scratch/ring2-fix.png`, `Claude Designs/scratch/ring8-fix.png`, `Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png`, `Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.45 PM.png`, `Claude Designs/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png`

### skill: 84 never read (71 text/code, 13 images)

| File | Lines | Size | How |
|---|---:|---:|---|
| `skill/a-strange-game/references/the-playing-side/a-strange-game-sketchbook.html` | 678 | 63.8 KB | grep only |
| `skill/aistrangegame/references/v6-framework.md` | 281 | 17.2 KB | grep only |
| `skill/bindu-field/references/dance/worked-examples/cross-data.json` | 1 | 30.2 KB | named in a command, no content seen |
| `skill/bindu-field/scores/abide-data-fresh.json` | 1 | 29.1 KB | named in a command, no content seen |
| `skill/bindu-field/scores/ache-data.json` | 1 | 23.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/ascend-data.json` | 1 | 32.5 KB | folder listed/scanned only |
| `skill/bindu-field/scores/believe-data.json` | 1 | 31.8 KB | folder listed/scanned only |
| `skill/bindu-field/scores/brave-data.json` | 1 | 36.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/build-data.json` | 1 | 27.9 KB | folder listed/scanned only |
| `skill/bindu-field/scores/cherish-data.json` | 1 | 25.4 KB | folder listed/scanned only |
| `skill/bindu-field/scores/confront-data.json` | 1 | 22.4 KB | folder listed/scanned only |
| `skill/bindu-field/scores/crash-data.json` | 1 | 29.9 KB | folder listed/scanned only |
| `skill/bindu-field/scores/crave-data.json` | 1 | 32.6 KB | folder listed/scanned only |
| `skill/bindu-field/scores/cross-data.json` | 1 | 30.2 KB | named in a command, no content seen |
| `skill/bindu-field/scores/dissolve-data.json` | 1 | 26.2 KB | folder listed/scanned only |
| `skill/bindu-field/scores/dream-data.json` | 1 | 42.2 KB | folder listed/scanned only |
| `skill/bindu-field/scores/ember-data.json` | 1 | 38.5 KB | named in a command, no content seen |
| `skill/bindu-field/scores/enough-data.json` | 1 | 26.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/fade-data.json` | 1 | 35.1 KB | folder listed/scanned only |
| `skill/bindu-field/scores/follow-data.json` | 1 | 32.5 KB | folder listed/scanned only |
| `skill/bindu-field/scores/glow-data.json` | 1 | 31.9 KB | folder listed/scanned only |
| `skill/bindu-field/scores/ground-data.json` | 1 | 27.8 KB | folder listed/scanned only |
| `skill/bindu-field/scores/hold-data.json` | 1 | 36.2 KB | folder listed/scanned only |
| `skill/bindu-field/scores/howl-data.json` | 1 | 42.8 KB | folder listed/scanned only |
| `skill/bindu-field/scores/inshadow-data.json` | 1 | 93.3 KB | folder listed/scanned only |
| `skill/bindu-field/scores/journey-data.json` | 1 | 421.6 KB | named in a command, no content seen |
| `skill/bindu-field/scores/kingdom-data.json` | 1 | 87.3 KB | folder listed/scanned only |
| `skill/bindu-field/scores/lift-data.json` | 1 | 26.9 KB | folder listed/scanned only |
| `skill/bindu-field/scores/light-data.json` | 1 | 34.1 KB | folder listed/scanned only |
| `skill/bindu-field/scores/lose-data.json` | 1 | 31.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/melt-data.json` | 1 | 36.1 KB | folder listed/scanned only |
| `skill/bindu-field/scores/miss-data.json` | 1 | 42.7 KB | folder listed/scanned only |
| `skill/bindu-field/scores/move-data.json` | 1 | 27.4 KB | folder listed/scanned only |
| `skill/bindu-field/scores/open-data.json` | 1 | 31.8 KB | folder listed/scanned only |
| `skill/bindu-field/scores/press-data.json` | 1 | 27.2 KB | named in a command, no content seen |
| `skill/bindu-field/scores/receive-data.json` | 1 | 26.4 KB | folder listed/scanned only |
| `skill/bindu-field/scores/release-data.json` | 1 | 34.1 KB | folder listed/scanned only |
| `skill/bindu-field/scores/remember-data.json` | 1 | 22.7 KB | folder listed/scanned only |
| `skill/bindu-field/scores/return-data.json` | 1 | 28.7 KB | folder listed/scanned only |
| `skill/bindu-field/scores/rise-data.json` | 1 | 60.2 KB | folder listed/scanned only |
| `skill/bindu-field/scores/search-data.json` | 1 | 27.6 KB | folder listed/scanned only |
| `skill/bindu-field/scores/speak-data.json` | 1 | 31.3 KB | folder listed/scanned only |
| `skill/bindu-field/scores/still-ajna-data.json` | 1 | 38.5 KB | named in a command, no content seen |
| `skill/bindu-field/scores/trace-data.json` | 1 | 34.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/unfold-data.json` | 1 | 62.7 KB | folder listed/scanned only |
| `skill/bindu-field/scores/wake-data.json` | 1 | 29.1 KB | folder listed/scanned only |
| `skill/bindu-field/scores/want-data.json` | 1 | 27.0 KB | folder listed/scanned only |
| `skill/bindu-field/scores/wild-data.json` | 1 | 26.8 KB | folder listed/scanned only |
| `skill/chakra-practices/references/lakota-research/Mitakuye_Oyasin_The_Grammar_of_a_Kin-Cosmos.pdf` | 0 | 107.8 KB | named in a command, not viewed |
| `skill/tree-of-life/references/aatma-dance.html` | 279 | 33.7 KB | grep only |
| `skill/tree-of-life/references/ajna-dance.html` | 288 | 33.2 KB | grep only |
| `skill/tree-of-life/references/anahata-dance.html` | 487 | 79.2 KB | grep only |
| `skill/tree-of-life/references/anahata-extraction-data.json` | 1 | 34.7 KB | named in a command, no content seen |
| `skill/tree-of-life/references/anahata-layer1.html` | 874 | 66.3 KB | grep only |
| `skill/tree-of-life/references/anahata-layer2.html` | 530 | 50.4 KB | folder listed/scanned only |
| `skill/tree-of-life/references/anahata-layer3.html` | 253 | 9.6 KB | folder listed/scanned only |
| `skill/tree-of-life/references/anahata-layer4.html` | 330 | 16.3 KB | folder listed/scanned only |
| `skill/tree-of-life/references/manipura-dance.html` | 883 | 73.1 KB | grep only |
| `skill/tree-of-life/references/manipura-extraction-data.json` | 1 | 26.4 KB | named in a command, no content seen |
| `skill/tree-of-life/references/manipura-layer1.html` | 649 | 51.0 KB | grep only |
| `skill/tree-of-life/references/manipura-layer2.html` | 469 | 42.5 KB | folder listed/scanned only |
| `skill/tree-of-life/references/manipura-layer3.html` | 240 | 9.0 KB | folder listed/scanned only |
| `skill/tree-of-life/references/manipura-layer4.html` | 429 | 17.5 KB | folder listed/scanned only |
| `skill/tree-of-life/references/maya-dance.html` | 318 | 28.6 KB | grep only |
| `skill/tree-of-life/references/sahasrara-dance.html` | 307 | 27.8 KB | grep only |
| `skill/tree-of-life/references/svadhisthana-dance.html` *(identical copy read: chakra/uploads/svadhisthana-dance(3).html)* | 1081 | 70.9 KB | grep only |
| `skill/tree-of-life/references/vishuddha-dance.html` | 279 | 73.4 KB | grep only |
| `skill/tree-of-life/references/vishuddha-layer1.html` | 449 | 56.3 KB | grep only |
| `skill/tree-of-life/references/vishuddha-layer2.html` | 239 | 23.0 KB | folder listed/scanned only |
| `skill/tree-of-life/references/vishuddha-layer3.html` | 209 | 6.6 KB | folder listed/scanned only |
| `skill/tree-of-life/references/vishuddha-layer4.html` | 395 | 16.1 KB | folder listed/scanned only |

Images never opened: `rupakarshini/builds/evidence/asg-guide-laptop-full.png`, `rupakarshini/builds/evidence/asg-guide-phone-fold.png`, `rupakarshini/builds/evidence/wazoodle-brand-home-laptop-full.png`, `rupakarshini/builds/evidence/wazoodle-brand-home-phone-fold.png`, `tree-of-life/references/aatma-wakeup-qr.png`, `tree-of-life/references/ajna-wakeup-qr.png`, `tree-of-life/references/anahata-wakeup-qr.png`, `tree-of-life/references/manipura-wakeup-qr.png`, `tree-of-life/references/maya-sleep-qr.png`, `tree-of-life/references/muladhara-wakeup-qr.png`, `tree-of-life/references/sahasrara-wakeup-qr.png`, `tree-of-life/references/svadhisthana-wakeup-qr.png`, `tree-of-life/references/vishuddha-wakeup-qr.png`

## Glimpse only, under 5% shown (47)

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `design/Bindu Mandala - The Field.html` | 218 | 16.5 KB | 4% | glimpse only (<5% of content shown) | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/design-canvas.jsx` | 966 | 48.5 KB | 3% | glimpse only (<5% of content shown) | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/tweaks-panel.jsx` | 542 | 24.2 KB | 1% | glimpse only (<5% of content shown) | E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/doc-page.js` | 325 | 14.3 KB | 1% | glimpse only (<5% of content shown) |  |
| `design/github.md` | 83 | 5.3 KB | 2% | glimpse only (<5% of content shown) |  |
| `design/handoff/Bindu Mandala - the method.md` *(identical copy read: design/Bindu Mandala - the method.md)* | 172 | 8.3 KB | 3% | glimpse only (<5% of content shown) |  |
| `design/handoff/Claude Code Handoff - The Homes.md` *(identical copy read: design/Claude Code Handoff - The Homes.md, repo/Claude Design Round 2/homes/Claude Code Handoff - The Homes.md)* | 411 | 18.8 KB | 1% | glimpse only (<5% of content shown) | L-a9f312c1 |
| `design/handoff/The Homes - the thread.md` *(identical copy read: design/The Homes - the thread.md, repo/Claude Design Round 2/homes/The Homes - the thread.md)* | 407 | 29.9 KB | 4% | glimpse only (<5% of content shown) | L-a87c421a |
| `design/handoff/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/handoff/homes-cards.js` | 266 | 29.9 KB | 2% | glimpse only (<5% of content shown) | L-ae8963e6 |
| `design/handoff/source/homes-design-package.md` *(identical copy read: repo/Claude Chat/homes-design-package.md)* | 132 | 14.1 KB | 2% | glimpse only (<5% of content shown) |  |
| `design/handoff/source/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `design/homes-cards.js` | 266 | 29.9 KB | 2% | glimpse only (<5% of content shown) | L-ae8963e6 |
| `design/tweaks-panel.jsx` | 542 | 24.2 KB | 1% | glimpse only (<5% of content shown) | E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/uploads/homes-design-package.md` *(identical copy read: repo/Claude Chat/homes-design-package.md)* | 132 | 14.1 KB | 2% | glimpse only (<5% of content shown) |  |
| `design/uploads/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `repo/Claude Chat/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/The Homes - Verification V3.html` | 648 | 35.6 KB | 3% | glimpse only (<5% of content shown) | E-af02fce0 |
| `repo/Claude Design Round 2/homes/source/homes-design-package.md` *(identical copy read: repo/Claude Chat/homes-design-package.md)* | 132 | 14.1 KB | 0% | glimpse only (<5% of content shown) |  |
| `repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `repo/Claude Design Round 2/prototype/index.html` | 132 | 7.6 KB | 2% | glimpse only (<5% of content shown) |  |
| `repo/Claude Design Round 2/prototype/kp-order-check.mjs` | 89 | 4.6 KB | 1% | glimpse only (<5% of content shown) |  |
| `repo/Claude Designs/Mandala Veil.html` *(identical copy read: design/Mandala Veil.html)* | 138 | 9.0 KB | 1% | glimpse only (<5% of content shown) |  |
| `repo/waves/foundation/HANDOFF-2026-10-12.md` *(session-authored)* | 34 | 4.6 KB | 3% | glimpse only (<5% of content shown) |  |
| `skill/a-strange-game/references/the-playing-side/a-strange-game-play.html` | 666 | 57.6 KB | 1% | glimpse only (<5% of content shown) |  |
| `skill/a-strange-game/references/the-playing-side/leela-on-the-33.html` | 346 | 30.1 KB | 0% | glimpse only (<5% of content shown) |  |
| `skill/aistrangegame/builds/Default.html` | 5156 | 202.6 KB | 5% | glimpse only (<5% of content shown) | E-a5968a56 |
| `skill/aistrangegame/builds/Default_immersive.html` | 5156 | 202.6 KB | 5% | glimpse only (<5% of content shown) | E-a5968a56 |
| `skill/aistrangegame/references/elements-library.md` | 331 | 19.1 KB | 1% | glimpse only (<5% of content shown) | E-afae141d |
| `skill/aistrangegame/references/v5-content-generation.md` | 381 | 16.1 KB | 3% | glimpse only (<5% of content shown) | E-a5968a56 |
| `skill/aistrangegame/references/v7-framework.md` | 152 | 12.6 KB | 1% | glimpse only (<5% of content shown) | L-af569ed2 |
| `skill/bindu-field/references/dance/worked-examples/anahata-dance.html` | 487 | 79.2 KB | 1% | glimpse only (<5% of content shown) | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/cross.html` | 3488 | 152.1 KB | 5% | glimpse only (<5% of content shown) | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/muladhara-dance.html` *(identical copy read: skill/tree-of-life/references/muladhara-dance.html)* | 1139 | 66.6 KB | 3% | glimpse only (<5% of content shown) | E-ab063fdb |
| `skill/chakra-maps/assets/chakra-map-vx.html` | 1046 | 60.8 KB | 3% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-maps/references/chakra-map-framework.md` *(identical copy read: skill/aistrangegame/references/chakra-map-framework.md)* | 390 | 20.2 KB | 1% | glimpse only (<5% of content shown) |  |
| `skill/chakra-practices/references/reference-implementations/interlude.html` | 1165 | 58.9 KB | 5% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-welcome.html` | 950 | 31.7 KB | 3% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/vishuddha-practice.html` | 3531 | 125.5 KB | 4% | glimpse only (<5% of content shown) | E-aa63b7e7, E-ad637078 |
| `skill/padakarshini/generators/gen_practice.py` | 651 | 47.0 KB | 2% | glimpse only (<5% of content shown) | E-aab3d514 |
| `skill/tree-of-life/references/awakening-sounds-all-chakras.html` | 447 | 13.0 KB | 4% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/pointe-animation-v2.html` | 869 | 26.6 KB | 3% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/tree-gate-prototype.html` | 870 | 25.6 KB | 2% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/tree-of-life-v2-panel2.html` | 2001 | 65.4 KB | 2% | glimpse only (<5% of content shown) | E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel9.html` *(identical copy read: chakra/uploads/maya-sleep.html)* | 3066 | 99.0 KB | 3% | glimpse only (<5% of content shown) | E-a152e294, E-aa9a2bd2, L-af569ed2 |

## Read between 5% and 50% (179)

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `chakra/The World in a Box v1.html` | 432 | 20.3 KB | 48% | bash partial | E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/tweaks-panel.jsx` | 541 | 24.1 KB | 37% | bash partial | E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a593543c, L-a87c421a, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `chakra/shell/walk-canon.js` *(identical copy read: chakra/uploads/walk-canon-lite.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/uploads/bindu-practice(4).html` | 2906 | 96.6 KB | 38% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-a9f312c1, L-adbbbc7a |
| `chakra/uploads/maya-sleep.html` | 3066 | 99.0 KB | 24% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/muladhara-practice(6).html` | 3279 | 110.9 KB | 33% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/muladhara-wakeup(3).html` | 1785 | 58.4 KB | 48% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/svadhisthana-dance(3).html` | 1081 | 70.9 KB | 32% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/svadhisthana-practice(2).html` | 3455 | 122.1 KB | 25% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/svadhisthana-wakeup(1).html` | 2001 | 65.4 KB | 34% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/walk-canon-lite.js` *(identical copy read: chakra/shell/walk-canon.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/uploads/walk-canon.json` | 2475 | 540.8 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `design/Bindu Mandala - Claude Code Brief.md` | 296 | 20.8 KB | 26% | bash partial | E-a44018cc, L-a87c421a, L-add668d1 |
| `design/Bindu Mandala - The Living Axis.html` | 423 | 29.5 KB | 46% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Mandala App.html` | 176 | 6.9 KB | 37% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Ring Worlds II.html` | 222 | 11.5 KB | 36% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Ring Worlds.html` | 190 | 9.9 KB | 36% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/The Homes - Concept Board V3 (SVG).html` *(identical copy read: design/The Homes - Concept Board.html)* | 508 | 37.1 KB | 40% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Homes - Concept Board.html` *(identical copy read: design/The Homes - Concept Board V3 (SVG).html)* | 508 | 37.1 KB | 40% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Homes - Verification V3.html` *(identical copy read: design/handoff/The Homes - Verification V3.html)* | 648 | 35.6 KB | 10% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Memory Layer.html` | 157 | 9.1 KB | 44% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/The Temporal Layer.html` | 269 | 14.4 KB | 34% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/ios-frame.jsx` *(identical copy read: design/ios-frame.jsx, repo/Claude Design Round 2/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 29% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-mandala.jsx` *(identical copy read: design/living-rite-mandala.jsx)* | 480 | 33.7 KB | 5% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/handoff/The Homes - Verification V3.html` *(identical copy read: design/The Homes - Verification V3.html)* | 648 | 35.6 KB | 10% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/handoff/homes-attribute.js` *(identical copy read: design/homes-attribute.js, repo/Claude Design Round 2/homes/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-chambers.js` *(identical copy read: design/homes-chambers.js)* | 769 | 37.5 KB | 9% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-grammar.js` *(identical copy read: design/homes-grammar.js)* | 831 | 37.5 KB | 8% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/handoff/homes-verify.js` *(identical copy read: design/homes-verify.js)* | 113 | 4.4 KB | 16% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/source/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md, repo/Claude Chat/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `design/homes-3d-rooms-2.js` | 511 | 24.5 KB | 26% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-3d-rooms.js` | 291 | 14.2 KB | 7% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-attribute.js` *(identical copy read: design/handoff/homes-attribute.js, repo/Claude Design Round 2/homes/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-verify.js` *(identical copy read: design/handoff/homes-verify.js)* | 113 | 4.4 KB | 16% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/ios-frame.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/ios-frame.jsx, repo/Claude Design Round 2/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 29% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/legend-explorations.jsx` | 453 | 21.9 KB | 33% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/memory.jsx` *(identical copy read: repo/Claude Designs/memory.jsx)* | 1139 | 45.1 KB | 31% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/modes.jsx` *(identical copy read: repo/Claude Designs/modes.jsx)* | 1675 | 68.4 KB | 44% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/relationship.jsx` | 994 | 39.2 KB | 33% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/ring-worlds-2.jsx` *(identical copy read: repo/Claude Designs/ring-worlds-2.jsx)* | 538 | 23.3 KB | 21% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/ring-worlds-3.jsx` *(identical copy read: repo/Claude Designs/ring-worlds-3.jsx)* | 642 | 36.5 KB | 25% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/ring-worlds.jsx` *(identical copy read: repo/Claude Designs/ring-worlds.jsx)* | 974 | 41.3 KB | 31% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/rite-app.jsx` | 220 | 10.3 KB | 12% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/rite-descent.jsx` | 314 | 14.6 KB | 11% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/screens-v2.jsx` | 872 | 34.4 KB | 12% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/screens.jsx` | 1161 | 45.0 KB | 22% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/uploads/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md, repo/Claude Chat/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `repo/Claude Chat/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/homes-attribute.js` *(identical copy read: design/homes-attribute.js, design/handoff/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0 |
| `repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Chat/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `repo/Claude Design Round 2/prototype/ios-frame.jsx` *(identical copy read: design/ios-frame.jsx, design/design_handoff_living_rite/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 24% | bash partial | E-a68bbc1d |
| `repo/Claude Design Round 2/prototype/living-rite-detail.jsx` *(identical copy read: design/living-rite-detail.jsx, design/design_handoff_living_rite/prototype/living-rite-detail.jsx)* | 370 | 17.4 KB | 49% | bash partial | L-add668d1, L-ae8963e6 |
| `repo/Claude Designs/Home Mandala.html` *(identical copy read: design/Home Mandala.html)* | 322 | 16.1 KB | 45% | bash partial | L-a6b1a7ce |
| `repo/Claude Designs/home-mandala.jsx` *(identical copy read: design/home-mandala.jsx)* | 352 | 13.1 KB | 17% | bash partial | E-a44018cc |
| `repo/Claude Designs/mandala-v2.jsx` *(identical copy read: design/mandala-v2.jsx)* | 309 | 12.8 KB | 15% | bash partial | E-a44018cc |
| `repo/Claude Designs/memory.jsx` *(identical copy read: design/memory.jsx)* | 1139 | 45.1 KB | 18% | bash partial | E-a44018cc |
| `repo/Claude Designs/modes.jsx` *(identical copy read: design/modes.jsx)* | 1675 | 68.4 KB | 40% | bash partial | E-a44018cc, E-a68bbc1d, L-a87c421a, L-a9e91dd5, L-abb7159e |
| `repo/Claude Designs/ring-worlds-2.jsx` *(identical copy read: design/ring-worlds-2.jsx)* | 538 | 23.3 KB | 11% | bash partial | L-a87c421a |
| `repo/Claude Designs/ring-worlds-3.jsx` *(identical copy read: design/ring-worlds-3.jsx)* | 642 | 36.5 KB | 22% | bash partial | L-a87c421a, L-a9e91dd5 |
| `repo/Claude Designs/ring-worlds.jsx` *(identical copy read: design/ring-worlds.jsx)* | 974 | 41.3 KB | 26% | bash partial | L-a9e91dd5 |
| `repo/Claude Designs/veil-mandala.jsx` *(identical copy read: design/veil-mandala.jsx)* | 322 | 15.3 KB | 32% | bash partial | E-a44018cc |
| `repo/waves/wave-6/bake_game_structure.py` *(session-authored)* | 209 | 10.2 KB | 9% | bash partial |  |
| `skill/bindu-being-app/references/design/ios-frame.jsx` | 348 | 15.7 KB | 25% | bash partial | E-a68bbc1d |
| `skill/bindu-being-app/references/design/tweaks-panel.jsx` | 540 | 24.0 KB | 10% | bash partial | E-a68bbc1d, L-a593543c, L-a87c421a |
| `skill/bindu-field/builds/bindu-field.html` | 2788 | 176.6 KB | 15% | bash partial | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/cross-visual-upgrade-spec.md` | 1513 | 51.8 KB | 22% | bash partial | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/search.html` | 393 | 50.0 KB | 44% | bash partial | E-ab063fdb, E-ad637078 |
| `skill/bindu-field/references/dance/worked-examples/time-audio-data.js` | 27 | 32.0 KB | 38% | bash partial | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/time-temple-spec.md` | 479 | 18.5 KB | 25% | bash partial | E-ab063fdb |
| `skill/bindu-field/references/dance/worked-examples/time-visual-upgrade-spec.md` | 1725 | 62.1 KB | 11% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/abide-data.json` | 1 | 31.9 KB | 33% | bash partial |  |
| `skill/bindu-field/scores/ache.score.json` | 342 | 9.6 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/ascend.score.json` | 347 | 10.3 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/believe.score.json` | 348 | 9.8 KB | 48% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/brave.score.json` | 377 | 11.1 KB | 44% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/cherish.score.json` | 331 | 9.9 KB | 48% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/confront.score.json` | 344 | 10.4 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/crash.score.json` | 336 | 9.5 KB | 49% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/crave.score.json` | 361 | 10.6 KB | 46% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/enough.score.json` | 356 | 9.9 KB | 50% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/fade.score.json` | 347 | 9.9 KB | 49% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/glow.score.json` | 341 | 9.5 KB | 49% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/inshadow.score.json` | 400 | 11.8 KB | 41% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/journey.score.json` | 933 | 26.4 KB | 19% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/kingdom.score.json` | 494 | 14.2 KB | 34% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/lift.score.json` | 346 | 10.1 KB | 48% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/lose.score.json` | 382 | 10.7 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/melt.score.json` | 387 | 10.7 KB | 44% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/miss.score.json` | 377 | 11.1 KB | 45% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/move.score.json` | 356 | 9.8 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/remember.score.json` | 340 | 9.5 KB | 49% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/return.score.json` | 372 | 10.4 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/trace.score.json` | 337 | 9.5 KB | 48% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/unfold.score.json` | 373 | 11.0 KB | 44% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/wake.score.json` | 362 | 10.6 KB | 46% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/want.score.json` | 341 | 10.0 KB | 48% | bash partial | E-ab063fdb |
| `skill/bindu-field/scores/wild.score.json` | 341 | 9.4 KB | 49% | bash partial | E-ab063fdb |
| `skill/bindu-field/scripts/batch/assemble4.py` | 139 | 13.9 KB | 47% | bash partial | E-ab063fdb |
| `skill/bindu-field/scripts/batch/make_report.py` | 169 | 9.8 KB | 38% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/ajna.md` | 246 | 21.5 KB | 27% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/anahata.md` | 229 | 21.9 KB | 14% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/before.md` | 219 | 18.9 KB | 13% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/in_shadow.md` | 214 | 15.9 KB | 11% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/levelup.md` | 203 | 18.9 KB | 13% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/manipura.md` | 228 | 19.5 KB | 15% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/purity.md` | 255 | 25.6 KB | 13% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/sahasrara.md` | 246 | 20.6 KB | 30% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/speak.md` | 230 | 20.8 KB | 30% | bash partial | E-ab063fdb |
| `skill/bindu-field/songs/svadhisthana.md` | 185 | 11.9 KB | 14% | bash partial | E-ab063fdb |
| `skill/chakra-maps/assets/chakra-map-vx2.html` | 1603 | 117.7 KB | 7% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/04-emergence.md` | 585 | 85.9 KB | 47% | Read partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/03-svadhisthana.md` | 407 | 58.0 KB | 27% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/04-manipura.md` | 448 | 72.8 KB | 25% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/05-anahata.md` | 478 | 83.1 KB | 24% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/06-vishuddha.md` | 479 | 82.9 KB | 22% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/07-ajna.md` | 478 | 97.6 KB | 23% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/08-sahasrara.md` | 506 | 113.6 KB | 27% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/09-shadow.md` | 564 | 111.8 KB | 25% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/20-armin.md` | 500 | 70.5 KB | 30% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-map-content-document.md` | 821 | 48.9 KB | 14% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-map-strategy-framework.md` | 635 | 35.4 KB | 20% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/phase-4-frames.md` | 455 | 16.7 KB | 21% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-1-bindu-through-shadow.md` | 1202 | 66.8 KB | 29% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-2-soles-through-armin.md` | 1208 | 62.0 KB | 23% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-3-inception-through-lalita.md` | 1564 | 74.2 KB | 10% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/story-thread.md` | 639 | 31.7 KB | 29% | bash partial | E-ad637078, L-a96f1a89 |
| `skill/chakra-practices/references/practice-book-source/chakra-practice.html` | 2549 | 206.2 KB | 22% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/ajna-practice.html` | 3891 | 141.1 KB | 5% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/anahata-practice.html` | 3854 | 147.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/bindu-practice.html` | 3148 | 103.6 KB | 7% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/manipura-practice.html` | 3961 | 146.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/muladhara-practice.html` | 3523 | 117.9 KB | 13% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/sahasrara-practice.html` | 3681 | 136.4 KB | 6% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/shadow-practice.html` | 3369 | 99.9 KB | 7% | bash partial | E-ad637078, L-a87c421a |
| `skill/chakra-practices/references/reference-implementations/svadhisthana-practice.html` | 3699 | 129.1 KB | 6% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/index.html` | 115 | 3.4 KB | 5% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-one.html` | 1847 | 57.9 KB | 12% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-road-home.html` | 1723 | 58.4 KB | 6% | bash partial | E-ad637078 |
| `skill/padakarshini/engine/FIGURES.css` | 746 | 54.1 KB | 17% | bash partial | E-aab3d514 |
| `skill/padakarshini/engine/gate.js` | 204 | 10.2 KB | 43% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/calendar.html` | 192 | 15.7 KB | 25% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/fieldguide.html` | 166 | 12.0 KB | 26% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/index.html` | 90 | 10.7 KB | 46% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/portrait.html` | 195 | 15.4 KB | 25% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/practice.html` | 193 | 14.4 KB | 37% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/recipe.html` | 213 | 14.7 KB | 22% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/twochairs.html` | 207 | 14.9 KB | 24% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/verse.html` | 151 | 11.2 KB | 42% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/forms/walk.html` | 189 | 15.3 KB | 40% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/learning/icebreaker/neem-karoli-baba.html` | 258 | 21.5 KB | 17% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/learning/story/bashar-the-five-laws.html` | 218 | 20.3 KB | 19% | bash partial | E-aab3d514 |
| `skill/padakarshini/exemplars/teachings/a-mirror-not-a-master.html` | 227 | 16.6 KB | 20% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_door.py` | 114 | 13.2 KB | 11% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_forms.py` | 227 | 41.1 KB | 36% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_guide.py` | 73 | 6.3 KB | 23% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_guide3.py` | 193 | 20.9 KB | 34% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_guide_v1.py` | 235 | 31.2 KB | 27% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_learning.py` | 133 | 12.7 KB | 25% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_reading.py` | 138 | 12.0 KB | 10% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_register.py` | 78 | 10.8 KB | 27% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_research.py` | 124 | 39.7 KB | 7% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_teachings.py` | 121 | 14.6 KB | 15% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/gen_v2.py` | 283 | 17.1 KB | 23% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/guide_content.py` | 143 | 20.9 KB | 17% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/teachings_more.py` | 117 | 20.5 KB | 27% | bash partial | E-aab3d514 |
| `skill/padakarshini/generators/verify_walk.py` | 27 | 1.9 KB | 43% | bash partial | E-aab3d514 |
| `skill/padakarshini/references/design-pass/doors.json` | 5745 | 141.2 KB | 47% | bash partial | E-aab3d514 |
| `skill/tree-of-life/references/closing-architecture-all-panels.html` | 555 | 17.3 KB | 26% | bash partial |  |
| `skill/tree-of-life/references/gate-framework-all-chakras.html` | 724 | 21.6 KB | 17% | bash partial | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/guided-breaths-all-chakras.html` | 580 | 16.2 KB | 5% | bash partial |  |
| `skill/tree-of-life/references/muladhara-dance.html` | 1139 | 66.6 KB | 12% | Read partial | E-aa9a2bd2, E-ab063fdb |
| `skill/tree-of-life/references/tree-of-life-v2-panel1.html` | 1785 | 58.4 KB | 15% | Read partial | E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel3.html` | 1966 | 65.1 KB | 10% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel4.html` | 2100 | 69.6 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel5.html` | 2011 | 65.5 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel6.html` | 1902 | 59.8 KB | 6% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel7.html` | 1977 | 65.1 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel8.html` | 1788 | 56.9 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/verify-tree-of-life-v2-panel4.sh` | 300 | 18.0 KB | 8% | bash partial |  |

## The 40 biggest files and their coverage

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `chakra/uploads/Screenshot 2026-07-07 at 3.21.12 PM.png` | 0 | 2.38 MB | 100% | Read (image viewed) | E-aa63b7e7, L-a87c421a |
| `chakra/uploads/Screenshot 2026-07-07 at 3.57.04 PM.png` | 0 | 705.7 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `chakra/uploads/Screenshot 2026-07-07 at 3.57.35 PM.png` | 0 | 672.4 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `skill/rupakarshini/builds/evidence/wazoodle-brand-home-laptop-full.png` | 0 | 576.3 KB | 0% | folder listed/scanned only |  |
| `chakra/shell/walk-canon.js` *(identical copy read: chakra/uploads/walk-canon-lite.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/uploads/walk-canon-lite.js` *(identical copy read: chakra/shell/walk-canon.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/uploads/walk-canon.json` | 2475 | 540.8 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `skill/bindu-field/scores/journey-data.json` | 1 | 421.6 KB | 0% | named in a command, no content seen |  |
| `design/uploads/Screenshot 2026-05-27 at 6.58.45 PM.png` | 0 | 376.2 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.45 PM.png` | 0 | 376.2 KB | 0% | folder listed/scanned only |  |
| `design/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png` | 0 | 373.0 KB | 100% | Read (image viewed) | E-a44018cc |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png` *(identical copy read: design/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png)* | 0 | 373.0 KB | 0% | folder listed/scanned only |  |
| `skill/rupakarshini/builds/evidence/asg-guide-laptop-full.png` | 0 | 359.0 KB | 0% | folder listed/scanned only |  |
| `repo/DECISIONS.md` | 3828 | 343.7 KB | 100% | Read partial | E-a82bfa32, E-ab2b035a, E-af02fce0, E-main, L-a0f00f4f, L-a709debe, L-a87c421a, L-aa76ddad, L-abd797e3, L-add668d1, L-ae8963e6 |
| `skill/rupakarshini/references/lineages/elements-catalog-v2.md` | 2777 | 334.5 KB | 100% | Read full | E-a50a9800 |
| `design/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png` | 0 | 325.8 KB | 100% | Read (image viewed) | E-af02fce0 |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png` *(identical copy read: design/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png)* | 0 | 325.8 KB | 0% | folder listed/scanned only |  |
| `skill/rupakarshini/references/elements-corpus.md` | 2793 | 290.1 KB | 100% | Read full | E-a50a9800, E-a7e52e50, L-main |
| `chakra/uploads/Screenshot 2026-07-07 at 2.08.45 PM.png` | 0 | 254.6 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `skill/padakarshini/references/design-pass/routing.json` | 11930 | 253.8 KB | 95% | bash partial | E-aab3d514 |
| `skill/chakra-practices/references/practice-book-source/chakra-practice.html` | 2549 | 206.2 KB | 22% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/aistrangegame/builds/Default.html` | 5156 | 202.6 KB | 5% | glimpse only (<5% of content shown) | E-a5968a56 |
| `skill/aistrangegame/builds/Default_immersive.html` | 5156 | 202.6 KB | 5% | glimpse only (<5% of content shown) | E-a5968a56 |
| `skill/padakarshini/references/elements-2026-09-30.md` | 1966 | 182.5 KB | 100% | Read full | E-a7e52e50, E-aab3d514, L-a87c421a |
| `skill/bindu-field/builds/bindu-field.html` | 2788 | 176.6 KB | 15% | bash partial | E-ab063fdb |
| `skill/the-field/ashrey-codex/codex-log.md` | 1640 | 164.9 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/bindu-field/references/dance/worked-examples/cross.html` | 3488 | 152.1 KB | 5% | glimpse only (<5% of content shown) | E-ab063fdb |
| `skill/chakra-practices/references/reference-implementations/anahata-practice.html` | 3854 | 147.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/manipura-practice.html` | 3961 | 146.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/padakarshini/references/design-pass/doors.json` | 5745 | 141.2 KB | 47% | bash partial | E-aab3d514 |
| `skill/chakra-practices/references/reference-implementations/ajna-practice.html` | 3891 | 141.1 KB | 5% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/sahasrara-practice.html` | 3681 | 136.4 KB | 6% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/svadhisthana-practice.html` | 3699 | 129.1 KB | 6% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/vishuddha-practice.html` | 3531 | 125.5 KB | 4% | glimpse only (<5% of content shown) | E-aa63b7e7, E-ad637078 |
| `skill/padakarshini/references/asg-learning-register.json` | 4601 | 124.5 KB | 85% | bash partial | E-aab3d514 |
| `chakra/uploads/svadhisthana-practice(2).html` | 3455 | 122.1 KB | 25% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `skill/chakra-practices/references/reference-implementations/muladhara-practice.html` | 3523 | 117.9 KB | 13% | bash partial | E-ad637078 |
| `skill/chakra-maps/assets/chakra-map-vx2.html` | 1603 | 117.7 KB | 7% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/08-sahasrara.md` | 506 | 113.6 KB | 27% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/09-shadow.md` | 564 | 111.8 KB | 25% | bash partial | E-ad637078 |

## Flag: design exports (HTML/JSX/JS) in /home/claude/design-upload/extracted

Grand exports are the root-level `*.html` files. The `*.jsx`/`*.js` files are their sources. `handoff/` and `design_handoff_living_rite/` hold mostly identical copies.

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `design/Bindu Mandala - Audit II.html` | 279 | 10.5 KB | 94% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Bindu Mandala - Design Audit.html` | 419 | 21.3 KB | 72% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Bindu Mandala - Master Build Brief.html` | 311 | 31.2 KB | 62% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Bindu Mandala - Refinement Brief.html` | 282 | 25.7 KB | 65% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Bindu Mandala - The Field.html` | 218 | 16.5 KB | 4% | glimpse only (<5% of content shown) | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Bindu Mandala - The Living Axis.html` | 423 | 29.5 KB | 46% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Bindu Mandala - The Living Rite.html` *(identical copy read: design/design_handoff_living_rite/prototype/index.html)* | 132 | 7.6 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/Bindu Mandala - The Rite of Entering.html` | 42 | 2.5 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Codex.html` *(identical copy read: repo/Claude Designs/Codex.html)* | 1149 | 55.9 KB | 70% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-a9f312c1 |
| `design/Home Mandala.html` *(identical copy read: repo/Claude Designs/Home Mandala.html)* | 322 | 16.1 KB | 65% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/Mandala App v2.html` *(identical copy read: repo/Claude Designs/Mandala App v2.html)* | 328 | 17.5 KB | 60% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Mandala App.html` | 176 | 6.9 KB | 37% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Mandala Legend.html` | 163 | 9.5 KB | 74% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Mandala Veil.html` | 138 | 9.0 KB | 55% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5 |
| `design/Ring Worlds II.html` | 222 | 11.5 KB | 36% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/Ring Worlds.html` | 190 | 9.9 KB | 36% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/The Eight Modes.html` *(identical copy read: repo/Claude Designs/The Eight Modes.html)* | 288 | 14.8 KB | 78% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-ae8963e6 |
| `design/The Homes - Concept Board V3 (SVG).html` *(identical copy read: design/The Homes - Concept Board.html)* | 508 | 37.1 KB | 40% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Homes - Concept Board.html` *(identical copy read: design/The Homes - Concept Board V3 (SVG).html)* | 508 | 37.1 KB | 40% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Homes - Rooms in 3D.html` | 213 | 11.0 KB | 85% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/The Homes - The Axis.html` *(identical copy read: design/handoff/The Homes - The Axis.html)* | 842 | 42.2 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/The Homes - The Nine Worlds.html` | 226 | 11.6 KB | 63% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/The Homes - Verification V3.html` *(identical copy read: design/handoff/The Homes - Verification V3.html)* | 648 | 35.6 KB | 10% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/The Memory Layer.html` | 157 | 9.1 KB | 44% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/The Relationship Field.html` | 132 | 5.6 KB | 51% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-ae8963e6 |
| `design/The Temporal Layer.html` | 269 | 14.4 KB | 34% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/design-canvas.jsx` | 966 | 48.5 KB | 3% | glimpse only (<5% of content shown) | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/index.html` *(identical copy read: design/Bindu Mandala - The Living Rite.html)* | 132 | 7.6 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/design_handoff_living_rite/prototype/ios-frame.jsx` *(identical copy read: design/ios-frame.jsx, repo/Claude Design Round 2/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 29% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-app.jsx` *(identical copy read: design/living-rite-app.jsx, repo/Claude Design Round 2/prototype/living-rite-app.jsx)* | 201 | 8.0 KB | 100% | bash full | E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-core.jsx` *(identical copy read: design/living-rite-core.jsx, repo/Claude Design Round 2/prototype/living-rite-core.jsx)* | 614 | 27.1 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-detail.jsx` *(identical copy read: design/living-rite-detail.jsx, repo/Claude Design Round 2/prototype/living-rite-detail.jsx)* | 370 | 17.4 KB | 52% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-field.jsx` *(identical copy read: design/living-rite-field.jsx, repo/Claude Design Round 2/prototype/living-rite-field.jsx)* | 340 | 17.2 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-mandala.jsx` *(identical copy read: design/living-rite-mandala.jsx)* | 480 | 33.7 KB | 5% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-more.jsx` *(identical copy read: design/living-rite-more.jsx, repo/Claude Design Round 2/prototype/living-rite-more.jsx)* | 256 | 14.7 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/living-rite-today.jsx` *(identical copy read: design/living-rite-today.jsx, repo/Claude Design Round 2/prototype/living-rite-today.jsx)* | 215 | 11.6 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/design_handoff_living_rite/prototype/shakti-data.js` | 310 | 14.7 KB | 0% | grep only |  |
| `design/design_handoff_living_rite/prototype/tweaks-panel.jsx` | 542 | 24.2 KB | 1% | glimpse only (<5% of content shown) | E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/doc-page.js` | 325 | 14.3 KB | 1% | glimpse only (<5% of content shown) |  |
| `design/handoff/The Homes - The Axis.html` *(identical copy read: design/The Homes - The Axis.html)* | 842 | 42.2 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `design/handoff/The Homes - Verification V3.html` *(identical copy read: design/The Homes - Verification V3.html)* | 648 | 35.6 KB | 10% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/handoff/all-shaktis-data.js` | 332 | 21.2 KB | 2% | glimpse only (<5% of content shown) | E-af02fce0, L-add668d1, L-ae8963e6 |
| `design/handoff/homes-3d-core.js` *(identical copy read: design/homes-3d-core.js, repo/Claude Design Round 2/homes/homes-3d-core.js)* | 72 | 3.0 KB | 100% | bash full | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-attribute.js` *(identical copy read: design/homes-attribute.js, repo/Claude Design Round 2/homes/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-cards.js` | 266 | 29.9 KB | 2% | glimpse only (<5% of content shown) | L-ae8963e6 |
| `design/handoff/homes-chambers.js` *(identical copy read: design/homes-chambers.js)* | 769 | 37.5 KB | 9% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-descent.js` *(identical copy read: design/homes-descent.js, repo/Claude Design Round 2/homes/homes-descent.js)* | 176 | 6.1 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/handoff/homes-grammar.js` *(identical copy read: design/homes-grammar.js)* | 831 | 37.5 KB | 8% | bash partial | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/handoff/homes-memory.js` *(identical copy read: design/homes-memory.js, repo/Claude Design Round 2/homes/homes-memory.js)* | 77 | 2.6 KB | 100% | bash full | E-af02fce0, L-a9e91dd5 |
| `design/handoff/homes-sound.js` *(identical copy read: design/homes-sound.js, repo/Claude Design Round 2/homes/homes-sound.js)* | 218 | 9.6 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a9e91dd5, L-add668d1 |
| `design/handoff/homes-today.js` *(identical copy read: design/homes-today.js, repo/Claude Design Round 2/homes/homes-today.js)* | 87 | 2.8 KB | 100% | bash full | E-ab2b035a, L-a709debe, L-a9e91dd5, L-ae8963e6 |
| `design/handoff/homes-verify.js` *(identical copy read: design/homes-verify.js)* | 113 | 4.4 KB | 16% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/handoff/homes-worlds.js` *(identical copy read: design/homes-worlds.js, repo/Claude Design Round 2/homes/homes-worlds.js)* | 563 | 25.7 KB | 100% | bash full | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/home-mandala.jsx` *(identical copy read: repo/Claude Designs/home-mandala.jsx)* | 352 | 13.1 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/homes-3d-core.js` *(identical copy read: design/handoff/homes-3d-core.js, repo/Claude Design Round 2/homes/homes-3d-core.js)* | 72 | 3.0 KB | 100% | bash full | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-3d-rooms-2.js` | 511 | 24.5 KB | 26% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-3d-rooms.js` | 291 | 14.2 KB | 7% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-attribute.js` *(identical copy read: design/handoff/homes-attribute.js, repo/Claude Design Round 2/homes/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-cards.js` | 266 | 29.9 KB | 2% | glimpse only (<5% of content shown) | L-ae8963e6 |
| `design/homes-chambers.js` *(identical copy read: design/handoff/homes-chambers.js)* | 769 | 37.5 KB | 100% | Read full | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-descent.js` *(identical copy read: design/handoff/homes-descent.js, repo/Claude Design Round 2/homes/homes-descent.js)* | 176 | 6.1 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-ae8963e6 |
| `design/homes-grammar.js` *(identical copy read: design/handoff/homes-grammar.js)* | 831 | 37.5 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a6b1a7ce, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/homes-memory.js` *(identical copy read: design/handoff/homes-memory.js, repo/Claude Design Round 2/homes/homes-memory.js)* | 77 | 2.6 KB | 100% | bash full | E-af02fce0, L-a9e91dd5 |
| `design/homes-sound.js` *(identical copy read: design/handoff/homes-sound.js, repo/Claude Design Round 2/homes/homes-sound.js)* | 218 | 9.6 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a9e91dd5, L-add668d1 |
| `design/homes-today.js` *(identical copy read: design/handoff/homes-today.js, repo/Claude Design Round 2/homes/homes-today.js)* | 87 | 2.8 KB | 100% | bash full | E-ab2b035a, L-a709debe, L-a9e91dd5, L-ae8963e6 |
| `design/homes-verify.js` *(identical copy read: design/handoff/homes-verify.js)* | 113 | 4.4 KB | 16% | bash partial | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/homes-worlds.js` *(identical copy read: design/handoff/homes-worlds.js, repo/Claude Design Round 2/homes/homes-worlds.js)* | 563 | 25.7 KB | 100% | Read full | E-af02fce0, L-a9e91dd5, L-a9f312c1 |
| `design/ios-frame.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/ios-frame.jsx, repo/Claude Design Round 2/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 29% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/legend-explorations.jsx` | 453 | 21.9 KB | 33% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/living-rite-app.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-app.jsx, repo/Claude Design Round 2/prototype/living-rite-app.jsx)* | 201 | 8.0 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/living-rite-core.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-core.jsx, repo/Claude Design Round 2/prototype/living-rite-core.jsx)* | 614 | 27.1 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/living-rite-detail.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-detail.jsx, repo/Claude Design Round 2/prototype/living-rite-detail.jsx)* | 370 | 17.4 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/living-rite-field.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-field.jsx, repo/Claude Design Round 2/prototype/living-rite-field.jsx)* | 340 | 17.2 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/living-rite-mandala.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-mandala.jsx)* | 480 | 33.7 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/living-rite-more.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-more.jsx, repo/Claude Design Round 2/prototype/living-rite-more.jsx)* | 256 | 14.7 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/living-rite-today.jsx` *(identical copy read: design/design_handoff_living_rite/prototype/living-rite-today.jsx, repo/Claude Design Round 2/prototype/living-rite-today.jsx)* | 215 | 11.6 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/mandala-v2.jsx` *(identical copy read: repo/Claude Designs/mandala-v2.jsx)* | 309 | 12.8 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/memory.jsx` *(identical copy read: repo/Claude Designs/memory.jsx)* | 1139 | 45.1 KB | 31% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/modes.jsx` *(identical copy read: repo/Claude Designs/modes.jsx)* | 1675 | 68.4 KB | 44% | bash partial | E-a44018cc, E-a68bbc1d, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/relationship.jsx` | 994 | 39.2 KB | 33% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/ring-nine.jsx` *(identical copy read: repo/Claude Designs/ring-nine.jsx)* | 582 | 27.7 KB | 99% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/ring-worlds-2.jsx` *(identical copy read: repo/Claude Designs/ring-worlds-2.jsx)* | 538 | 23.3 KB | 21% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/ring-worlds-3.jsx` *(identical copy read: repo/Claude Designs/ring-worlds-3.jsx)* | 642 | 36.5 KB | 25% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/ring-worlds.jsx` *(identical copy read: repo/Claude Designs/ring-worlds.jsx)* | 974 | 41.3 KB | 31% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/rite-app.jsx` | 220 | 10.3 KB | 12% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/rite-core.jsx` | 238 | 13.8 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a9e91dd5, L-a9f312c1, L-add668d1, L-ae8963e6 |
| `design/rite-descent.jsx` | 314 | 14.6 KB | 11% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/rite-dwelling.jsx` | 210 | 9.8 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/rite-seat.jsx` | 248 | 11.8 KB | 100% | bash full | E-af02fce0, L-a9f312c1, L-ae8963e6 |
| `design/rite-threshold.jsx` | 118 | 5.4 KB | 100% | bash full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/screens-v2.jsx` | 872 | 34.4 KB | 12% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/screens.jsx` | 1161 | 45.0 KB | 22% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/shakti-data.js` | 310 | 14.7 KB | 0% | grep only |  |
| `design/temporal.jsx` *(identical copy read: repo/Claude Designs/temporal.jsx)* | 1068 | 43.5 KB | 67% | bash partial | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |
| `design/tweaks-panel.jsx` | 542 | 24.2 KB | 1% | glimpse only (<5% of content shown) | E-af02fce0, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `design/veil-mandala.jsx` *(identical copy read: repo/Claude Designs/veil-mandala.jsx)* | 322 | 15.3 KB | 100% | Read full | E-a44018cc, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-abb7159e, L-add668d1, L-ae8963e6 |

## Flag: chakra corpus in /home/claude/chakra-upload/extracted

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `chakra/.thumbnail` | 0 | 2.6 KB | 0% | folder listed/scanned only |  |
| `chakra/Bindu Experience Score.html` | 188 | 20.7 KB | 100% | Read full | E-aa63b7e7, E-ad637078, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a9e91dd5, L-adbbbc7a |
| `chakra/Bindu Immersive.html` | 194 | 11.8 KB | 100% | Read full | E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/Bindu.html` | 118 | 6.6 KB | 100% | Read full | E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/CLAUDE.md` *(identical copy read: skill/a-strange-game/references/the-playing-side/sources/chakra-game-build-principles.md)* | 15 | 1.5 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-main, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-adbbbc7a |
| `chakra/Chakra Game.html` | 457 | 17.5 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-abb7159e, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/Child Games.html` | 717 | 32.6 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/Hub.html` | 726 | 41.9 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/Living Mandala.html` | 545 | 25.1 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a, L-ae8963e6 |
| `chakra/Mini Games.html` | 167 | 10.0 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/Pairing Floor.html` | 98 | 15.2 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ad637078, E-af02fce0, L-a48b2df7, L-a6b1a7ce, L-a9e91dd5, L-adbbbc7a |
| `chakra/Sacred Experiences.html` | 640 | 43.1 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/Sanctuary.html` | 705 | 37.7 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Body as Scripture.html` | 376 | 20.6 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Child Space.html` | 984 | 50.5 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/The Correspondence v1.html` | 832 | 39.3 KB | 95% | Read partial | E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/The Correspondence.html` | 802 | 45.1 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Field.html` | 433 | 20.5 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ab2b035a, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Mirror.html` | 305 | 15.9 KB | 100% | Read full | E-a68bbc1d, E-a7e52e50, E-aa63b7e7, E-ab2b035a, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a709debe, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Record.html` | 432 | 20.9 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Seven Gates.html` | 423 | 21.8 KB | 100% | Read full | E-a7e52e50, E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The Shell.html` | 158 | 9.4 KB | 100% | Read full | E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The World in a Box v1.html` | 432 | 20.3 KB | 48% | bash partial | E-aa63b7e7, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/The World in a Box.html` | 701 | 35.0 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/chakra-data.js` | 120 | 4.9 KB | 100% | Read full | E-a6f94746, E-main, L-a3a3c4b0, L-a87c421a |
| `chakra/chakra-experiences.jsx` | 624 | 26.8 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-ab063fdb, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a593543c, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-abb7159e, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/games-body.jsx` | 353 | 16.4 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `chakra/games-core.js` *(identical copy read: skill/a-strange-game/references/the-playing-side/sources/chakra-game-registry.js)* | 39 | 4.2 KB | 100% | Read full | E-a6f94746, E-a7e52e50, L-a3a3c4b0, L-a87c421a, L-a89dc256 |
| `chakra/games-elements.jsx` | 288 | 12.0 KB | 100% | Read full | E-a6f94746, E-a7e52e50, E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/games-language.jsx` | 300 | 17.9 KB | 100% | Read full | E-a6f94746, E-a7e52e50, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/games-patience.jsx` | 274 | 12.2 KB | 100% | Read full | E-a6f94746, E-a7e52e50, L-a3a3c4b0, L-a48b2df7, L-a593543c, L-a87c421a, L-a89dc256 |
| `chakra/games-pattern.jsx` | 367 | 16.6 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, L-a3a3c4b0, L-a48b2df7, L-a593543c, L-a87c421a, L-a89dc256, L-adbbbc7a |
| `chakra/games-rhythm.jsx` | 315 | 14.9 KB | 100% | Read full | E-a6f94746, E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a |
| `chakra/games-utils.jsx` | 71 | 4.2 KB | 100% | Read full | E-a6f94746, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a |
| `chakra/screenshots/home.png` | 0 | 13.0 KB | 100% | Read (image viewed) | E-a6f94746, E-main, L-a87c421a |
| `chakra/screenshots/sacred-selection.png` | 0 | 15.4 KB | 100% | Read (image viewed) | E-a6f94746, E-main |
| `chakra/screenshots/story-void.png` | 0 | 8.5 KB | 100% | Read (image viewed) | E-a6f94746 |
| `chakra/shell/bindu-engine.js` | 251 | 10.1 KB | 100% | Read full | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/bindu-moments.jsx` | 266 | 12.8 KB | 100% | Read full | E-aa63b7e7, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a96f1a89, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/bindu-practice.jsx` | 550 | 30.9 KB | 100% | Read full | E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/bindu-room-canon.json` | 66 | 13.9 KB | 100% | Read full | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/shell/bindu-room.jsx` | 198 | 10.5 KB | 100% | Read full | E-aa63b7e7, L-a3a3c4b0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/bindu-slice-a.js` | 301 | 12.6 KB | 100% | Read full | E-aa63b7e7, L-a3a3c4b0, L-a9e91dd5, L-adbbbc7a |
| `chakra/shell/bindu-slice-b.js` | 496 | 22.8 KB | 100% | Read full | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a9e91dd5, L-a9f312c1, L-adbbbc7a |
| `chakra/shell/canon-adapter.js` | 77 | 3.1 KB | 100% | Read full | E-aa63b7e7, L-a9e91dd5, L-adbbbc7a |
| `chakra/shell/shell-ground.jsx` | 131 | 6.4 KB | 100% | Read full | E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-a9f312c1, L-adbbbc7a, L-ae8963e6 |
| `chakra/shell/shell-moments.jsx` | 242 | 12.9 KB | 100% | Read full | E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-add668d1, L-ae8963e6 |
| `chakra/shell/tweaks-panel.jsx` | 541 | 24.1 KB | 37% | bash partial | E-aa63b7e7, E-af02fce0, L-a3a3c4b0, L-a593543c, L-a87c421a, L-a9e91dd5, L-add668d1, L-ae8963e6 |
| `chakra/shell/walk-canon.js` *(identical copy read: chakra/uploads/walk-canon-lite.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/skill-extracted/bindu-chakras-app/SKILL.md` *(identical copy read: skill/bindu-chakras-app/SKILL.md)* | 53 | 6.8 KB | 100% | bash full | E-aa63b7e7, E-afae141d, L-a87c421a, L-a9f312c1, L-adbbbc7a |
| `chakra/skill-extracted/bindu-chakras-app/references/delta-map-v2.md` *(identical copy read: skill/bindu-chakras-app/references/delta-map-v2.md)* | 92 | 8.0 KB | 100% | Read full | E-a68bbc1d, E-aa63b7e7, L-adbbbc7a |
| `chakra/skill-extracted/bindu-chakras-app/references/experience-brief-v2.md` *(identical copy read: skill/bindu-chakras-app/references/experience-brief-v2.md)* | 158 | 10.5 KB | 100% | Read full | E-a68bbc1d, E-aa63b7e7, L-a37a316e, L-a87c421a, L-a96f1a89, L-adbbbc7a |
| `chakra/skill-extracted/bindu-chakras-app/references/gift-pairing.md` *(identical copy read: skill/bindu-chakras-app/references/gift-pairing.md)* | 69 | 8.9 KB | 100% | Read full | E-a68bbc1d, E-aa63b7e7 |
| `chakra/skill-extracted/bindu-chakras-app/references/room-registers-v1.md` *(identical copy read: skill/bindu-chakras-app/references/room-registers-v1.md)* | 220 | 26.0 KB | 100% | Read full | E-aa63b7e7, L-a37a316e |
| `chakra/skill-extracted/bindu-chakras-app/scripts/bake_walk_canon.py` *(identical copy read: skill/bindu-chakras-app/scripts/bake_walk_canon.py)* | 230 | 8.1 KB | 100% | Read full | E-a68bbc1d, E-aa63b7e7, E-aab3d514, E-ab063fdb |
| `chakra/uploads/Screenshot 2026-07-07 at 2.08.45 PM.png` | 0 | 254.6 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `chakra/uploads/Screenshot 2026-07-07 at 3.21.12 PM.png` | 0 | 2.38 MB | 100% | Read (image viewed) | E-aa63b7e7, L-a87c421a |
| `chakra/uploads/Screenshot 2026-07-07 at 3.57.04 PM.png` | 0 | 705.7 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `chakra/uploads/Screenshot 2026-07-07 at 3.57.35 PM.png` | 0 | 672.4 KB | 100% | Read (image viewed) | E-aa63b7e7 |
| `chakra/uploads/bindu-chakras-app.skill` | 0 | 32.1 KB | 0% | named in a command, not viewed |  |
| `chakra/uploads/bindu-practice(4).html` | 2906 | 96.6 KB | 38% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-a9f312c1, L-adbbbc7a |
| `chakra/uploads/maya-sleep.html` | 3066 | 99.0 KB | 24% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/muladhara-practice(6).html` | 3279 | 110.9 KB | 33% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/muladhara-wakeup(3).html` | 1785 | 58.4 KB | 48% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/svadhisthana-dance(3).html` | 1081 | 70.9 KB | 32% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/svadhisthana-practice(2).html` | 3455 | 122.1 KB | 25% | bash partial | E-aa63b7e7, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a |
| `chakra/uploads/svadhisthana-wakeup(1).html` | 2001 | 65.4 KB | 34% | bash partial | E-aa63b7e7, E-aa9a2bd2, E-ab063fdb, E-ad637078, E-af02fce0, E-afae141d, L-a3a3c4b0, L-a48b2df7, L-a6b1a7ce, L-a87c421a, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-af569ed2 |
| `chakra/uploads/walk-canon-lite.js` *(identical copy read: chakra/shell/walk-canon.js)* | 2477 | 541.1 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |
| `chakra/uploads/walk-canon.json` | 2475 | 540.8 KB | 17% | bash partial | E-aa63b7e7, E-aab3d514, E-ab063fdb, L-a87c421a, L-a96f1a89, L-abd797e3, L-af569ed2 |

## Flag: the repo's Claude Designs, Claude Design Round 2, Briefs, Chat and root docs

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `repo/ARRIVAL.md` | 113 | 5.1 KB | 100% | Read full | E-a44018cc, E-a82bfa32, E-ab2b035a, E-main |
| `repo/BUILD-CHARTER.md` | 85 | 6.4 KB | 100% | Read full | E-a82bfa32, E-af02fce0, E-main, L-a0f00f4f, L-a37a316e, L-a3a3c4b0, L-a48b2df7, L-a4a9da84, L-a593543c, L-a6172e76, L-a6b1a7ce, L-a709debe, L-a87c421a, L-a89dc256, L-a96f1a89, L-a9e91dd5, L-a9f312c1, L-aa76ddad, L-abb7159e, L-abd797e3, L-adbbbc7a, L-ae8963e6, L-af569ed2 |
| `repo/Claude Briefs/Bindu-Mandala-Final-Brief.md` | 1023 | 45.7 KB | 100% | Read full | E-a82bfa32, E-ab2b035a, L-a48b2df7, L-a89dc256, L-a9e91dd5, L-adbbbc7a, L-ae8963e6 |
| `repo/Claude Briefs/CLAUDE_CODE_BRIEF.md` | 304 | 14.4 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Briefs/UX-AUDIT.md` | 227 | 20.7 KB | 100% | Read full | E-a44018cc, E-a82bfa32 |
| `repo/Claude Chat/AUDIT-REPORT-DEVICE.md` | 169 | 28.4 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/AUDIT-REPORT.md` | 501 | 71.7 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/BINDU-MANDALA-AUDIT-BRIEF.md` | 221 | 13.7 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/BINDU-MANDALA-BUILD-BRIEF-V2.md` | 270 | 20.9 KB | 100% | Read full | E-a82bfa32, L-a87c421a |
| `repo/Claude Chat/BUILD-BRIEF-V2-ERRATA.md` | 184 | 17.0 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/CHAT-NOTE-TO-CODE-2026-09-20.md` | 93 | 7.0 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/DEVICE-AUDIT-BRIEF.md` | 137 | 19.7 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/PACKAGE-START-HERE.md` | 36 | 3.0 KB | 100% | bash full | E-a82bfa32 |
| `repo/Claude Chat/README.md` | 35 | 3.3 KB | 100% | bash full | E-a82bfa32 |
| `repo/Claude Chat/SESSION-HANDOFF-2026-09-06.md` | 105 | 9.6 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/bindu-mandala-expansion.md` | 140 | 14.5 KB | 100% | Read full | E-a82bfa32, L-a87c421a, L-abb7159e |
| `repo/Claude Chat/bindu-mandala-master-brief.md` | 203 | 29.1 KB | 100% | Read full | E-a82bfa32, L-a87c421a, L-af569ed2 |
| `repo/Claude Chat/homes-design-package.md` | 132 | 14.1 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Chat/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `repo/Claude Chat/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `repo/Claude Design Round 2/DESIGN_SPEC.md` *(identical copy read: design/Bindu Mandala - Final Handoff.md, design/design_handoff_living_rite/DESIGN_SPEC.md)* | 187 | 21.2 KB | 100% | Read full | E-a44018cc, E-a82bfa32 |
| `repo/Claude Design Round 2/KP-ORDERING-FINDINGS.md` | 46 | 3.1 KB | 100% | Read full | E-a82bfa32, L-a3a3c4b0 |
| `repo/Claude Design Round 2/README.md` | 163 | 9.7 KB | 100% | Read full | E-a44018cc, E-a82bfa32 |
| `repo/Claude Design Round 2/RECONCILED-BUILD-BRIEF.md` | 171 | 12.9 KB | 100% | Read full | E-a44018cc, E-a82bfa32 |
| `repo/Claude Design Round 2/homes/Bindu Mandala - the method.md` | 172 | 8.3 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/Claude Code Handoff - The Homes.md` *(identical copy read: design/Claude Code Handoff - The Homes.md)* | 411 | 18.8 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/READ ME FIRST.md` *(identical copy read: design/handoff/READ ME FIRST.md)* | 68 | 3.1 KB | 100% | Read full | E-a82bfa32, L-a9f312c1 |
| `repo/Claude Design Round 2/homes/The Homes - The Axis.html` | 842 | 42.2 KB | 100% | bash full | L-a9e91dd5, L-a9f312c1, L-add668d1 |
| `repo/Claude Design Round 2/homes/The Homes - Verification V3.html` | 648 | 35.6 KB | 3% | glimpse only (<5% of content shown) | E-af02fce0 |
| `repo/Claude Design Round 2/homes/The Homes - the thread.md` *(identical copy read: design/The Homes - the thread.md)* | 407 | 29.9 KB | 100% | Read full | E-a82bfa32, L-a87c421a |
| `repo/Claude Design Round 2/homes/_superseded/README.md` | 6 | 0.5 KB | 100% | bash full | E-af02fce0 |
| `repo/Claude Design Round 2/homes/_superseded/all-shaktis-data.js` | 332 | 21.2 KB | 0% | named in a command, no content seen |  |
| `repo/Claude Design Round 2/homes/github.md` | 87 | 5.6 KB | 100% | Read full | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/homes-3d-core.js` *(identical copy read: design/homes-3d-core.js, design/handoff/homes-3d-core.js)* | 72 | 3.0 KB | 100% | bash full | E-af02fce0, L-a9f312c1 |
| `repo/Claude Design Round 2/homes/homes-attribute.js` *(identical copy read: design/homes-attribute.js, design/handoff/homes-attribute.js)* | 587 | 23.5 KB | 40% | bash partial | E-af02fce0 |
| `repo/Claude Design Round 2/homes/homes-cards.js` | 266 | 29.9 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Design Round 2/homes/homes-chambers.js` *(identical copy read: design/homes-chambers.js, design/handoff/homes-chambers.js)* | 769 | 37.5 KB | 0% | grep only |  |
| `repo/Claude Design Round 2/homes/homes-descent.js` *(identical copy read: design/homes-descent.js, design/handoff/homes-descent.js)* | 176 | 6.1 KB | 100% | bash full | E-af02fce0 |
| `repo/Claude Design Round 2/homes/homes-grammar.js` *(identical copy read: design/homes-grammar.js, design/handoff/homes-grammar.js)* | 831 | 37.5 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Design Round 2/homes/homes-memory.js` *(identical copy read: design/homes-memory.js, design/handoff/homes-memory.js)* | 77 | 2.6 KB | 100% | bash full | E-af02fce0, L-a9e91dd5 |
| `repo/Claude Design Round 2/homes/homes-sound.js` *(identical copy read: design/homes-sound.js, design/handoff/homes-sound.js)* | 218 | 9.6 KB | 100% | bash full | L-a9e91dd5 |
| `repo/Claude Design Round 2/homes/homes-today.js` *(identical copy read: design/homes-today.js, design/handoff/homes-today.js)* | 87 | 2.8 KB | 100% | bash full | E-ab2b035a, L-a709debe, L-a9e91dd5 |
| `repo/Claude Design Round 2/homes/homes-verify.js` *(identical copy read: design/homes-verify.js, design/handoff/homes-verify.js)* | 113 | 4.4 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Design Round 2/homes/homes-worlds.js` *(identical copy read: design/homes-worlds.js, design/handoff/homes-worlds.js)* | 563 | 25.7 KB | 100% | bash full | L-a9f312c1 |
| `repo/Claude Design Round 2/homes/source/homes-design-package.md` *(identical copy read: repo/Claude Chat/homes-design-package.md)* | 132 | 14.1 KB | 0% | glimpse only (<5% of content shown) |  |
| `repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-1-2.md` *(identical copy read: design/uploads/homes-shakti-cards-rings-1-2.md, design/handoff/source/homes-shakti-cards-rings-1-2.md, repo/Claude Chat/homes-shakti-cards-rings-1-2.md)* | 367 | 33.2 KB | 15% | bash partial | E-a82bfa32 |
| `repo/Claude Design Round 2/homes/source/homes-shakti-cards-rings-3-9.md` | 511 | 42.1 KB | 3% | glimpse only (<5% of content shown) | E-a82bfa32 |
| `repo/Claude Design Round 2/prototype/_superseded/README.md` | 11 | 0.9 KB | 50% | bash partial | E-af02fce0 |
| `repo/Claude Design Round 2/prototype/_superseded/all-shaktis-data.js` | 332 | 21.2 KB | 0% | named in a command, no content seen |  |
| `repo/Claude Design Round 2/prototype/index.html` | 132 | 7.6 KB | 2% | glimpse only (<5% of content shown) |  |
| `repo/Claude Design Round 2/prototype/ios-frame.jsx` *(identical copy read: design/ios-frame.jsx, design/design_handoff_living_rite/prototype/ios-frame.jsx)* | 350 | 15.9 KB | 24% | bash partial | E-a68bbc1d |
| `repo/Claude Design Round 2/prototype/kp-order-check.mjs` | 89 | 4.6 KB | 1% | glimpse only (<5% of content shown) |  |
| `repo/Claude Design Round 2/prototype/living-rite-app.jsx` *(identical copy read: design/living-rite-app.jsx, design/design_handoff_living_rite/prototype/living-rite-app.jsx)* | 201 | 8.0 KB | 100% | bash full | L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/living-rite-core.jsx` *(identical copy read: design/living-rite-core.jsx, design/design_handoff_living_rite/prototype/living-rite-core.jsx)* | 614 | 27.1 KB | 100% | bash full | L-a6b1a7ce, L-add668d1, L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/living-rite-detail.jsx` *(identical copy read: design/living-rite-detail.jsx, design/design_handoff_living_rite/prototype/living-rite-detail.jsx)* | 370 | 17.4 KB | 49% | bash partial | L-add668d1, L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/living-rite-field.jsx` *(identical copy read: design/living-rite-field.jsx, design/design_handoff_living_rite/prototype/living-rite-field.jsx)* | 340 | 17.2 KB | 100% | bash full | L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/living-rite-mandala.jsx` *(identical copy read: design/living-rite-mandala.jsx, design/design_handoff_living_rite/prototype/living-rite-mandala.jsx)* | 480 | 33.7 KB | 0% | grep only |  |
| `repo/Claude Design Round 2/prototype/living-rite-more.jsx` *(identical copy read: design/living-rite-more.jsx, design/design_handoff_living_rite/prototype/living-rite-more.jsx)* | 256 | 14.7 KB | 100% | bash full | L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/living-rite-today.jsx` *(identical copy read: design/living-rite-today.jsx, design/design_handoff_living_rite/prototype/living-rite-today.jsx)* | 215 | 11.6 KB | 100% | bash full | L-ae8963e6 |
| `repo/Claude Design Round 2/prototype/shakti-data.js` | 310 | 14.7 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Design Round 2/prototype/tweaks-panel.jsx` | 542 | 24.2 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/.design-canvas.state.json` | 1 | 0.1 KB | 0% | named in a command, no content seen |  |
| `repo/Claude Designs/.thumbnail` | 0 | 2.8 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/Bindu-Mandala-Handoff-II.md` *(identical copy read: design/Bindu-Mandala-Handoff-II.md)* | 144 | 11.5 KB | 100% | bash full | E-a44018cc |
| `repo/Claude Designs/Bindu-Mandala-Handoff.md` *(identical copy read: design/Bindu-Mandala-Handoff.md)* | 224 | 12.0 KB | 100% | bash full | E-a44018cc |
| `repo/Claude Designs/Codex.html` *(identical copy read: design/Codex.html)* | 1149 | 55.9 KB | 69% | Read partial | E-a44018cc, L-a37a316e, L-a87c421a |
| `repo/Claude Designs/DESIGN_SPEC.md` *(identical copy read: design/DESIGN_SPEC.md)* | 223 | 9.8 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/Home Mandala.html` *(identical copy read: design/Home Mandala.html)* | 322 | 16.1 KB | 45% | bash partial | L-a6b1a7ce |
| `repo/Claude Designs/Mandala App v2.html` *(identical copy read: design/Mandala App v2.html)* | 328 | 17.5 KB | 54% | bash partial | L-a6b1a7ce |
| `repo/Claude Designs/Mandala App.html` *(identical copy read: design/Mandala App.html)* | 176 | 6.9 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/Mandala Veil.html` *(identical copy read: design/Mandala Veil.html)* | 138 | 9.0 KB | 1% | glimpse only (<5% of content shown) |  |
| `repo/Claude Designs/Ring Worlds II.html` *(identical copy read: design/Ring Worlds II.html)* | 222 | 11.5 KB | 0% | grep only |  |
| `repo/Claude Designs/Ring Worlds.html` *(identical copy read: design/Ring Worlds.html)* | 190 | 9.9 KB | 0% | grep only |  |
| `repo/Claude Designs/The Eight Modes.html` *(identical copy read: design/The Eight Modes.html)* | 288 | 14.8 KB | 76% | bash partial | L-a87c421a, L-a9e91dd5 |
| `repo/Claude Designs/The Memory Layer.html` *(identical copy read: design/The Memory Layer.html)* | 157 | 9.1 KB | 0% | grep only |  |
| `repo/Claude Designs/The Relationship Field.html` *(identical copy read: design/The Relationship Field.html)* | 132 | 5.6 KB | 0% | named in a command, no content seen |  |
| `repo/Claude Designs/The Temporal Layer.html` *(identical copy read: design/The Temporal Layer.html)* | 269 | 14.4 KB | 0% | grep only |  |
| `repo/Claude Designs/all-shaktis-data.js` | 332 | 21.2 KB | 0% | named in a command, no content seen |  |
| `repo/Claude Designs/design-canvas.jsx` | 966 | 48.5 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/home-mandala.jsx` *(identical copy read: design/home-mandala.jsx)* | 352 | 13.1 KB | 17% | bash partial | E-a44018cc |
| `repo/Claude Designs/mandala-v2.jsx` *(identical copy read: design/mandala-v2.jsx)* | 309 | 12.8 KB | 15% | bash partial | E-a44018cc |
| `repo/Claude Designs/memory.jsx` *(identical copy read: design/memory.jsx)* | 1139 | 45.1 KB | 18% | bash partial | E-a44018cc |
| `repo/Claude Designs/modes.jsx` *(identical copy read: design/modes.jsx)* | 1675 | 68.4 KB | 40% | bash partial | E-a44018cc, E-a68bbc1d, L-a87c421a, L-a9e91dd5, L-abb7159e |
| `repo/Claude Designs/relationship.jsx` *(identical copy read: design/relationship.jsx)* | 994 | 39.2 KB | 0% | grep only |  |
| `repo/Claude Designs/ring-nine.jsx` *(identical copy read: design/ring-nine.jsx)* | 582 | 27.7 KB | 99% | bash full | E-a44018cc, L-a87c421a, L-a9e91dd5 |
| `repo/Claude Designs/ring-worlds-2.jsx` *(identical copy read: design/ring-worlds-2.jsx)* | 538 | 23.3 KB | 11% | bash partial | L-a87c421a |
| `repo/Claude Designs/ring-worlds-3.jsx` *(identical copy read: design/ring-worlds-3.jsx)* | 642 | 36.5 KB | 22% | bash partial | L-a87c421a, L-a9e91dd5 |
| `repo/Claude Designs/ring-worlds.jsx` *(identical copy read: design/ring-worlds.jsx)* | 974 | 41.3 KB | 26% | bash partial | L-a9e91dd5 |
| `repo/Claude Designs/scratch/ring2-fix.png` | 0 | 41.7 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/scratch/ring8-fix.png` | 0 | 41.9 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/screens-v2.jsx` *(identical copy read: design/screens-v2.jsx)* | 872 | 34.4 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/screens.jsx` *(identical copy read: design/screens.jsx)* | 1161 | 45.0 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/shakti-data.js` | 310 | 14.7 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/temporal.jsx` *(identical copy read: design/temporal.jsx)* | 1068 | 43.5 KB | 66% | bash partial | E-a44018cc, L-a48b2df7, L-a6b1a7ce, L-a89dc256 |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png` *(identical copy read: design/uploads/Screenshot 2026-05-27 at 6.58.14 PM.png)* | 0 | 325.8 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 6.58.45 PM.png` | 0 | 376.2 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png` *(identical copy read: design/uploads/Screenshot 2026-05-27 at 7.59.20 PM.png)* | 0 | 373.0 KB | 0% | folder listed/scanned only |  |
| `repo/Claude Designs/veil-mandala.jsx` *(identical copy read: design/veil-mandala.jsx)* | 322 | 15.3 KB | 32% | bash partial | E-a44018cc |
| `repo/DECISIONS.md` | 3828 | 343.7 KB | 100% | Read partial | E-a82bfa32, E-ab2b035a, E-af02fce0, E-main, L-a0f00f4f, L-a709debe, L-a87c421a, L-aa76ddad, L-abd797e3, L-add668d1, L-ae8963e6 |
| `repo/PROGRESS.md` | 133 | 69.9 KB | 100% | Read full | E-a82bfa32, E-ab2b035a, E-main, L-a0f00f4f, L-a709debe, L-aa76ddad |
| `repo/RULINGS-QUEUE.md` | 67 | 9.4 KB | 100% | Read full | E-a44018cc, E-a82bfa32, E-ab2b035a, E-af02fce0, E-main, L-a0f00f4f, L-aa76ddad |

## Flag: skill `chakra-maps`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/chakra-maps/SKILL.md` | 338 | 21.6 KB | 100% | Read full | E-ad637078, L-a87c421a |
| `skill/chakra-maps/assets/chakra-map-vx.html` | 1046 | 60.8 KB | 3% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-maps/assets/chakra-map-vx2.html` | 1603 | 117.7 KB | 7% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/00-living-field.md` | 205 | 17.1 KB | 100% | Read full | E-ad637078, L-af569ed2 |
| `skill/chakra-maps/references/chakra-codex/01-registers.md` | 318 | 24.8 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/02-three-trees.md` | 235 | 16.8 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/03-structural-chakras.md` | 253 | 23.0 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/04-emergence.md` | 585 | 85.9 KB | 47% | Read partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/README.md` | 180 | 25.4 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/01-bindu.md` | 323 | 34.4 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/02-muladhara.md` | 393 | 43.9 KB | 74% | Read partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/03-svadhisthana.md` | 407 | 58.0 KB | 27% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/04-manipura.md` | 448 | 72.8 KB | 25% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/05-anahata.md` | 478 | 83.1 KB | 24% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/06-vishuddha.md` | 479 | 82.9 KB | 22% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/07-ajna.md` | 478 | 97.6 KB | 23% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/08-sahasrara.md` | 506 | 113.6 KB | 27% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/09-shadow.md` | 564 | 111.8 KB | 25% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-codex/atlas/20-armin.md` | 500 | 70.5 KB | 30% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-map-content-document.md` | 821 | 48.9 KB | 14% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/chakra-map-framework.md` *(identical copy read: skill/aistrangegame/references/chakra-map-framework.md)* | 390 | 20.2 KB | 1% | glimpse only (<5% of content shown) |  |
| `skill/chakra-maps/references/chakra-map-strategy-framework.md` | 635 | 35.4 KB | 20% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/per-chakra/muladhara/README.md` | 31 | 1.3 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-maps/references/practice-book/master-plan-v2.md` | 607 | 37.8 KB | 77% | Read partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/perspective-what-the-builder-saw.md` | 95 | 6.0 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-maps/references/practice-book/phase-4-frames.md` | 455 | 16.7 KB | 21% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-1-bindu-through-shadow.md` | 1202 | 66.8 KB | 29% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-2-soles-through-armin.md` | 1208 | 62.0 KB | 23% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/section-3-inception-through-lalita.md` | 1564 | 74.2 KB | 10% | bash partial | E-ad637078 |
| `skill/chakra-maps/references/practice-book/session-summary.md` | 122 | 6.0 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-maps/references/practice-book/story-thread.md` | 639 | 31.7 KB | 29% | bash partial | E-ad637078, L-a96f1a89 |
| `skill/chakra-maps/references/site-v3.md` | 12 | 1.0 KB | 100% | bash full | E-aab3d514, E-ad637078 |
| `skill/chakra-maps/references/voice-ii-framework.md` | 366 | 20.3 KB | 89% | Read partial | E-ad637078 |

## Flag: skill `chakra-practices`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/chakra-practices/SKILL.md` | 663 | 37.8 KB | 100% | Read full | E-ad637078, L-a87c421a |
| `skill/chakra-practices/references/build-logs/ajna.md` | 57 | 3.3 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/anahata.md` | 28 | 1.1 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/bindu-v4.md` | 62 | 4.9 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/lineage.md` | 142 | 12.9 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/manipura.md` | 17 | 0.6 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/muladhara-session-bridge.md` | 123 | 6.3 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/sahasrara.md` | 69 | 3.8 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/svadhisthana.md` | 27 | 1.4 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-logs/vishuddha.md` | 52 | 2.9 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/build-process.md` | 581 | 33.4 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-practices/references/color-system.md` | 225 | 8.6 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/full-map.md` | 318 | 25.8 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-practices/references/gaia-sakshi-source.md` | 436 | 24.0 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-practices/references/gate-designs.md` | 183 | 5.6 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/interlude-pattern.md` | 167 | 8.7 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/lakota-learning.md` | 164 | 9.8 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/lakota-research/Mitakuye_Oyasin_The_Grammar_of_a_Kin-Cosmos.pdf` | 0 | 107.8 KB | 0% | named in a command, not viewed |  |
| `skill/chakra-practices/references/lakota-research/pass-1-wakhan-thanka.md` | 61 | 19.3 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/operating-principles.md` | 177 | 8.8 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/page-inventory.md` | 204 | 12.3 KB | 100% | bash full | E-ad637078 |
| `skill/chakra-practices/references/practice-book-source/chakra-practice.html` | 2549 | 206.2 KB | 22% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/ajna-practice.html` | 3891 | 141.1 KB | 5% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/anahata-practice.html` | 3854 | 147.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/bindu-practice.html` | 3148 | 103.6 KB | 7% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/interlude.html` | 1165 | 58.9 KB | 5% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/manipura-practice.html` | 3961 | 146.9 KB | 7% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/muladhara-practice.html` | 3523 | 117.9 KB | 13% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/sahasrara-practice.html` | 3681 | 136.4 KB | 6% | bash partial | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/shadow-practice.html` | 3369 | 99.9 KB | 7% | bash partial | E-ad637078, L-a87c421a |
| `skill/chakra-practices/references/reference-implementations/svadhisthana-practice.html` | 3699 | 129.1 KB | 6% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/index.html` | 115 | 3.4 KB | 5% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-one.html` | 1847 | 57.9 KB | 12% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-road-home.html` | 1723 | 58.4 KB | 6% | bash partial | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/trinity/the-welcome.html` | 950 | 31.7 KB | 3% | glimpse only (<5% of content shown) | E-ad637078 |
| `skill/chakra-practices/references/reference-implementations/vishuddha-practice.html` | 3531 | 125.5 KB | 4% | glimpse only (<5% of content shown) | E-aa63b7e7, E-ad637078 |
| `skill/chakra-practices/references/second-pass-threads.md` | 462 | 22.3 KB | 100% | Read full | E-ad637078 |
| `skill/chakra-practices/references/site-v3.md` | 18 | 1.8 KB | 100% | bash full | E-aab3d514, E-ad637078 |

## Flag: skill `tree-of-life`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/tree-of-life/SKILL.md` | 419 | 30.4 KB | 100% | Read full | E-aa9a2bd2, L-a87c421a, L-af569ed2 |
| `skill/tree-of-life/references/aatma-dance.html` | 279 | 33.7 KB | 0% | grep only |  |
| `skill/tree-of-life/references/aatma-wakeup-qr.png` | 0 | 7.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/ajna-dance.html` | 288 | 33.2 KB | 0% | grep only |  |
| `skill/tree-of-life/references/ajna-wakeup-qr.png` | 0 | 7.5 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/anahata-build-log.md` | 96 | 4.7 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/anahata-dance.html` | 487 | 79.2 KB | 0% | grep only |  |
| `skill/tree-of-life/references/anahata-extraction-data.json` | 1 | 34.7 KB | 0% | named in a command, no content seen |  |
| `skill/tree-of-life/references/anahata-layer1.html` | 874 | 66.3 KB | 0% | grep only |  |
| `skill/tree-of-life/references/anahata-layer2.html` | 530 | 50.4 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/anahata-layer3.html` | 253 | 9.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/anahata-layer4.html` | 330 | 16.3 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/anahata-wakeup-qr.png` | 0 | 8.7 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/awakening-sounds-all-chakras.html` | 447 | 13.0 KB | 4% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/build-guard-rules.md` | 206 | 8.3 KB | 100% | Read full | E-a152e294, E-a5968a56, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/closing-architecture-all-panels.html` | 555 | 17.3 KB | 26% | bash partial |  |
| `skill/tree-of-life/references/cross-song-analysis.md` | 59 | 2.8 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/gate-framework-all-chakras.html` | 724 | 21.6 KB | 17% | bash partial | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/guided-breaths-all-chakras.html` | 580 | 16.2 KB | 5% | bash partial |  |
| `skill/tree-of-life/references/manipura-build-log.md` | 278 | 13.1 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/manipura-dance.html` | 883 | 73.1 KB | 0% | grep only |  |
| `skill/tree-of-life/references/manipura-extraction-data.json` | 1 | 26.4 KB | 0% | named in a command, no content seen |  |
| `skill/tree-of-life/references/manipura-layer1.html` | 649 | 51.0 KB | 0% | grep only |  |
| `skill/tree-of-life/references/manipura-layer2.html` | 469 | 42.5 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/manipura-layer3.html` | 240 | 9.0 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/manipura-layer4.html` | 429 | 17.5 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/manipura-wakeup-qr.png` | 0 | 8.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/maya-dance.html` | 318 | 28.6 KB | 0% | grep only |  |
| `skill/tree-of-life/references/maya-sleep-qr.png` | 0 | 7.5 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/mirror-dissolution-architecture.md` | 348 | 12.7 KB | 100% | Read full | E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/muladhara-dance.html` | 1139 | 66.6 KB | 12% | Read partial | E-aa9a2bd2, E-ab063fdb |
| `skill/tree-of-life/references/muladhara-wakeup-qr.png` | 0 | 8.7 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/panel9-prebuild-plan.md` | 371 | 14.1 KB | 100% | Read full | E-aa9a2bd2, L-a87c421a, L-af569ed2 |
| `skill/tree-of-life/references/pointe-animation-v2.html` | 869 | 26.6 KB | 3% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/sahasrara-dance.html` | 307 | 27.8 KB | 0% | grep only |  |
| `skill/tree-of-life/references/sahasrara-wakeup-qr.png` | 0 | 8.7 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/session-handoff-all-panels-hardened.md` | 141 | 6.9 KB | 100% | Read full | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-bindu-dances-complete.md` | 260 | 16.0 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-integration-pass.md` | 188 | 11.2 KB | 100% | Read full | E-aa9a2bd2, L-a87c421a |
| `skill/tree-of-life/references/session-handoff-panel9-lock-secondpass.md` | 187 | 10.5 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-tree-of-life-v2-panel2-build.md` | 163 | 7.5 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-tree-of-life-v2-panel3-build.md` | 172 | 8.1 KB | 100% | Read full | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-tree-of-life-v2-panel6-build.md` | 194 | 12.1 KB | 100% | Read full | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-tree-of-life-v2-panel8-build.md` | 201 | 13.4 KB | 100% | Read full | E-a152e294, E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-v3-muladhara-locked.md` | 144 | 5.3 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-vx-anahata.md` | 94 | 4.3 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-vx-manipura-phased.md` | 146 | 6.2 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-vx-muladhara.md` | 175 | 8.0 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-vx-svadhisthana.md` | 199 | 10.3 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/session-handoff-vx-vishuddha.md` | 91 | 4.3 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/site-v3.md` | 20 | 1.8 KB | 100% | Read full | E-aa9a2bd2, E-aab3d514, E-ad637078 |
| `skill/tree-of-life/references/svadhisthana-dance.html` *(identical copy read: chakra/uploads/svadhisthana-dance(3).html)* | 1081 | 70.9 KB | 0% | grep only |  |
| `skill/tree-of-life/references/svadhisthana-wakeup-qr.png` | 0 | 8.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/temple-guide-v2.html` | 532 | 17.6 KB | 61% | Read partial | E-aa9a2bd2 |
| `skill/tree-of-life/references/timeline-boards.md` | 322 | 26.1 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/tree-gate-prototype.html` | 870 | 25.6 KB | 2% | glimpse only (<5% of content shown) |  |
| `skill/tree-of-life/references/tree-of-life-design-notes.md` | 357 | 19.7 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/tree-of-life-game.md` | 532 | 59.1 KB | 100% | Read full | E-aa9a2bd2, L-a87c421a, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-experience-arch.md` | 417 | 18.2 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel1.html` | 1785 | 58.4 KB | 15% | Read partial | E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel2.html` | 2001 | 65.4 KB | 2% | glimpse only (<5% of content shown) | E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel3.html` | 1966 | 65.1 KB | 10% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel4.html` | 2100 | 69.6 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel5.html` | 2011 | 65.5 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel6.html` | 1902 | 59.8 KB | 6% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel7.html` | 1977 | 65.1 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel8.html` | 1788 | 56.9 KB | 7% | bash partial | E-aa63b7e7, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v2-panel9.html` *(identical copy read: chakra/uploads/maya-sleep.html)* | 3066 | 99.0 KB | 3% | glimpse only (<5% of content shown) | E-a152e294, E-aa9a2bd2, L-af569ed2 |
| `skill/tree-of-life/references/tree-of-life-v3-architecture.md` | 107 | 6.2 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/v3-dance-framework.md` | 299 | 15.9 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/verify-tree-of-life-v2-panel4.sh` | 300 | 18.0 KB | 8% | bash partial |  |
| `skill/tree-of-life/references/vishuddha-build-log.md` | 85 | 4.4 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/tree-of-life/references/vishuddha-dance.html` | 279 | 73.4 KB | 0% | grep only |  |
| `skill/tree-of-life/references/vishuddha-layer1.html` | 449 | 56.3 KB | 0% | grep only |  |
| `skill/tree-of-life/references/vishuddha-layer2.html` | 239 | 23.0 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/vishuddha-layer3.html` | 209 | 6.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/vishuddha-layer4.html` | 395 | 16.1 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/vishuddha-wakeup-qr.png` | 0 | 8.6 KB | 0% | folder listed/scanned only |  |
| `skill/tree-of-life/references/vx-build-protocol-v2.1.md` | 447 | 20.3 KB | 100% | Read full | E-aa9a2bd2 |

## Flag: skill `a-strange-game`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/a-strange-game/SKILL.md` | 361 | 23.1 KB | 100% | Read full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/protocols/seed-translation.md` | 301 | 13.1 KB | 100% | bash full | E-a5968a56, L-af569ed2 |
| `skill/a-strange-game/references/awakening-architecture.md` | 321 | 15.0 KB | 100% | Read full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/canonical-decisions.md` | 453 | 23.6 KB | 100% | Read full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/composition-protocols.md` | 240 | 13.7 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/dev-access.md` | 130 | 4.2 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/journey-flow.md` | 424 | 18.4 KB | 100% | Read full | E-a5968a56, L-af569ed2 |
| `skill/a-strange-game/references/journey-topology-v2.md` | 172 | 8.1 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/leela-architecture.md` | 176 | 8.5 KB | 100% | Read full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/readiness-architecture.md` | 109 | 5.0 KB | 100% | bash full | E-a5968a56, L-a87c421a |
| `skill/a-strange-game/references/site-v3.md` | 42 | 4.5 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/storage-pools.md` | 535 | 20.0 KB | 100% | Read full | E-a5968a56, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/00-recognition-document.md` | 70 | 5.4 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/01-intention-and-laws.md` | 65 | 7.0 KB | 100% | Read full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/02-eagle-eye-frame.md` | 46 | 4.1 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/03-the-house.md` | 50 | 6.6 KB | 100% | bash full | E-a5968a56, L-a87c421a |
| `skill/a-strange-game/references/the-playing-side/04-habits-routines-and-the-climb.md` | 50 | 4.7 KB | 100% | bash full | E-a5968a56, L-a87c421a |
| `skill/a-strange-game/references/the-playing-side/05-morning-and-evening.md` | 31 | 3.2 KB | 100% | bash full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/06-codex-and-gaia.md` | 42 | 3.5 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/07-seed-library.md` | 45 | 4.2 KB | 100% | bash full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/08-paradoxes-and-open-questions.md` | 62 | 5.4 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/09-source-map.md` | 39 | 2.7 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/10-codex-on-the-game.md` | 71 | 13.9 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/11-the-skills-walked.md` | 43 | 5.0 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/12-identity-goals-todo.md` | 71 | 11.7 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/13-daily-relationships-lalita.md` | 57 | 6.2 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/14-bindu-being.md` | 30 | 4.4 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/15-the-process.md` | 42 | 4.2 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/16-field-reading.md` | 465 | 33.6 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/17-site-gameplan.md` | 21 | 4.8 KB | 100% | bash full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/18-leela-on-the-33.md` | 20 | 3.2 KB | 100% | bash full | E-a5968a56, L-a87c421a, L-a89dc256, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/19-play-engine-v0.md` | 27 | 3.9 KB | 100% | bash full | E-a5968a56, L-a87c421a, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/20-sketchbook.md` | 27 | 3.6 KB | 100% | bash full | E-a5968a56, L-a87c421a, L-a89dc256, L-af569ed2 |
| `skill/a-strange-game/references/the-playing-side/README.md` | 53 | 3.9 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/a-strange-game-play.html` | 666 | 57.6 KB | 1% | glimpse only (<5% of content shown) |  |
| `skill/a-strange-game/references/the-playing-side/a-strange-game-sketchbook.html` | 678 | 63.8 KB | 0% | grep only |  |
| `skill/a-strange-game/references/the-playing-side/leela-on-the-33.html` | 346 | 30.1 KB | 0% | glimpse only (<5% of content shown) |  |
| `skill/a-strange-game/references/the-playing-side/research/research-pass1-bell-count-descent-return.md` | 326 | 46.0 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/research/research-pass2-bridge-pass.md` | 322 | 46.7 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/the-playing-side/sources/chakra-game-build-principles.md` *(identical copy read: chakra/CLAUDE.md)* | 15 | 1.5 KB | 100% | bash full | E-a5968a56, L-a87c421a |
| `skill/a-strange-game/references/the-playing-side/sources/chakra-game-registry.js` *(identical copy read: chakra/games-core.js)* | 39 | 4.2 KB | 100% | bash full | E-a5968a56, L-a87c421a |
| `skill/a-strange-game/references/the-playing-side/sources/make-morning-cascade-prompts.txt` | 281 | 12.2 KB | 100% | Read full | E-a5968a56 |
| `skill/a-strange-game/references/trinity-of-guidance.md` | 347 | 19.4 KB | 100% | Read full | E-a5968a56, L-af569ed2 |
| `skill/a-strange-game/walker-codex/README.md` | 104 | 3.8 KB | 100% | bash full | E-a5968a56 |

## Flag: skill `bindu-chakras-app`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/bindu-chakras-app/SKILL.md` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/SKILL.md)* | 53 | 6.8 KB | 100% | bash full | E-a68bbc1d, E-aa63b7e7, L-a87c421a, L-adbbbc7a |
| `skill/bindu-chakras-app/references/delta-map-v2.md` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/references/delta-map-v2.md)* | 92 | 8.0 KB | 100% | bash full | E-a68bbc1d, L-adbbbc7a |
| `skill/bindu-chakras-app/references/experience-brief-v2.md` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/references/experience-brief-v2.md)* | 158 | 10.5 KB | 100% | bash full | E-a68bbc1d, E-aa63b7e7, L-a87c421a, L-a96f1a89, L-adbbbc7a |
| `skill/bindu-chakras-app/references/gift-pairing.md` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/references/gift-pairing.md)* | 69 | 8.9 KB | 100% | bash full | E-a68bbc1d |
| `skill/bindu-chakras-app/references/room-registers-v1.md` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/references/room-registers-v1.md)* | 220 | 26.0 KB | 100% | Read full | E-a68bbc1d |
| `skill/bindu-chakras-app/scripts/bake_walk_canon.py` *(identical copy read: chakra/skill-extracted/bindu-chakras-app/scripts/bake_walk_canon.py)* | 230 | 8.1 KB | 100% | bash full | E-a68bbc1d |

## Flag: skill `the-mirror`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/the-mirror/SKILL.md` | 192 | 11.8 KB | 100% | Read full | E-a5968a56, E-a7e52e50, L-a87c421a |
| `skill/the-mirror/references/entries.md` | 526 | 56.3 KB | 100% | Read full | E-a5968a56 |

## Flag: skill `lalita-family`, every file

| File | Lines | Size | Cov | How | Read by |
|---|---:|---:|---:|---|---|
| `skill/lalita-family/SKILL.md` | 257 | 15.2 KB | 100% | Read full | E-aa9a2bd2, L-a87c421a |
| `skill/lalita-family/references/architecture.md` | 99 | 4.8 KB | 100% | Read full | E-a5f15a6f, E-aa9a2bd2 |
| `skill/lalita-family/references/field-contract.md` | 167 | 8.2 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/lalita-family/references/the-mirror-room.md` | 151 | 8.3 KB | 100% | Read full | E-aa9a2bd2 |
| `skill/lalita-family/references/the-walk.md` | 262 | 11.1 KB | 100% | Read full | E-aa9a2bd2 |

## Transcripts parsed

| Tag | Start (UTC) | End | Task |
|---|---|---|---|
| E-main | 2026-10-12 12:25 | 13:58 | main thread |
| E-a50a9800 | 2026-10-12 13:01 | 13:07 | Read rupakarshini entirely |
| E-aab3d514 | 2026-10-12 13:01 | 13:08 | Read padakarshini + shabdakarshini entirely |
| E-a5968a56 | 2026-10-12 13:02 | 13:08 | Read A Strange Game world entirely |
| E-a68bbc1d | 2026-10-12 13:02 | 13:09 | Read Bindu-tier siblings + ASG infra |
| E-aa9a2bd2 | 2026-10-12 13:02 | 13:10 | Read the-field, tree-of-life, lalita-family |
| E-ab063fdb | 2026-10-12 13:02 | 13:09 | Read bindu-field entirely |
| E-ad637078 | 2026-10-12 13:02 | 13:10 | Read dances + chakra skills entirely |
| E-a152e294 | 2026-10-12 13:03 | 13:09 | Read remaining story + art skills |
| E-a5f15a6f | 2026-10-12 13:03 | 13:10 | Read ARC work skills (part 2) |
| E-aa6b79da | 2026-10-12 13:03 | 13:10 | Read Wazoodle/AKAS story skills |
| E-ab2e4738 | 2026-10-12 13:03 | 13:09 | Read live Airtable Mandala data |
| E-afae141d | 2026-10-12 13:03 | 13:09 | Read ARC work skills (part 1) |
| E-a44018cc | 2026-10-12 13:12 | 13:21 | Design vs Code: Mandala, Rite, rest |
| E-a82bfa32 | 2026-10-12 13:12 | 13:17 | Catalogue DECISIONS.md + chat docs |
| E-af02fce0 | 2026-10-12 13:12 | 13:19 | Design vs Code: the Homes |
| E-a4a1747c | 2026-10-12 13:13 | 13:21 | Mine the full Codex for Mandala |
| E-ab2b035a | 2026-10-12 13:13 | 13:21 | Map the iOS code + encoded rules |
| E-a6f94746 | 2026-10-12 13:32 | 13:38 | Read the Chakra games corpus |
| E-a7e52e50 | 2026-10-12 13:32 | 13:39 | Read Living Mandala + scripture pages |
| E-aa63b7e7 | 2026-10-12 13:32 | 13:40 | Read Bindu Origin shell + practices |
| L-a6b1a7ce | 2026-10-12 15:00 | 15:23 | Wave 1A: the Mandala's light |
| L-a9f312c1 | 2026-10-12 15:01 | 15:33 | Wave 1D: the Homes' light |
| L-add668d1 | 2026-10-12 15:01 | 15:17 | Wave 1C: recognition natures |
| L-ae8963e6 | 2026-10-12 15:01 | 15:23 | Wave 1B: the day's light |
| L-a9e91dd5 | 2026-10-12 15:35 | 16:10 | Wave 2: one building |
| L-a3a3c4b0 | 2026-10-12 15:36 | 16:02 | Wave 4: play with the energies |
| L-a48b2df7 | 2026-10-12 15:36 | 16:07 | Wave 5: memory and words |
| L-adbbbc7a | 2026-10-12 15:36 | 16:01 | Wave 3: origin and the 33 |
| L-a4a9da84 | 2026-10-12 16:23 | 16:33 | Gap sweep: the whole Codex |
| L-a87c421a | 2026-10-12 16:23 | 16:34 | Gap sweep: skills and design corpora |
| L-abd797e3 | 2026-10-12 16:23 | 16:33 | Gap sweep: Airtable ASG base |
| L-a96f1a89 | 2026-10-12 16:36 | 19:12 | Wave 6A: the 33 alive |
| L-abb7159e | 2026-10-12 16:36 | 17:06 | Wave 6C: modes, rites, his laws |
| L-af569ed2 | 2026-10-12 16:36 | 17:02 | Wave 6B: the game's own structure |
| L-a593543c | 2026-10-12 16:37 | 17:09 | Wave 6D: memory and sister apps |
| L-a89dc256 | 2026-10-12 16:37 | 17:05 | Wave 6E: every game |
| L-a6172e76 | 2026-10-12 19:41 | 20:16 | Wave 6.1: coherence and decisions |
| L-a6401aef | 2026-10-12 20:18 | 20:21 | Draft the 102 seed verbs |
| L-afc251ab | 2026-10-12 20:18 | 20:21 | Research the Mudrā Śaktis' bījas |
| L-a0f00f4f | 2026-10-12 20:23 | 20:31 | Draft the updated skills |
| L-main | 2026-10-12 20:36 | 01:36 | main thread |
| L-a37a316e | 2026-10-13 00:42 | 00:47 | Audit app for compressed experiences |
| L-a32cdad3 | 2026-10-13 00:58 | 01:01 | Why Śakti Homes look basic |
| L-aa76ddad | 2026-10-13 00:58 | 01:04 | Inventory restrictive rules in app |
| L-a709debe | 2026-10-13 01:10 | 01:18 | Reading findings vs Waves 1–5 |

Skills loaded through the Skill tool (full SKILL.md injected): E-main→bindu-mandala-app, E-main→bindu-feed, E-main→bindu-field, E-main→rupakarshini, E-main→padakarshini, L-main→arc-action-center, L-main→computer-use, L-main→rupakarshini, L-abb7159e→bindu-mandala-app
