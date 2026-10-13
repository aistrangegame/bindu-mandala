# Reader brief — the second reading (12 Oct 2026, night)

You are one reader of several. Together you finish reading everything that was not yet read for **Bindu Mandala**, Ashrey's devotional iOS app of the Śrī Yantra (102 Śaktis at their seats, the 33 chakras, nine rings, rooms, games, rites, memory). The first reading is in `waves/register/01-…07-*.md` (every Design export and all 40 frames, the chakra corpus, the chakra skills, all 352 Codex entries). The foundation is `waves/foundation/` plus the rulings below.

## Why we read

Not to fix a bug list. Ashrey wants an **upgrade, not an update**: we read everything that exists across his skills, apps and data to find **every space, element, interaction and gift that could be brought into the app**, the same way the Bindu Feed app was upgraded. The last build failed because material was compressed: worlds flattened into one screen, rooms reduced to text pages, Design's craft never ported. So read in full, hold everything, and report generously. Nothing is cut because it seems too much. Abundance is the rule.

## The foundation (settled)

Home is the Bindu, the centre. Fifteen worlds, each in its own space, never laid over another:
Home · Today/the Rite · the Mandala (held yantra + Veil) · the nine rings · Her Home (her room) · Her Presence (portrait) · the Climb (Axis) · the 33 (the braid: story told by a moving point, practice, wake-up, dance, gate) · A Strange Game (Leela + every game its own world) · the Modes · Time · Memory · the Well · Beneath · the Relationship Field.
Three threads join them: her position (kp 1–102), the chakra (1–33), the day.
Getting around: the point (home), an always-available menu, doors along the threads, search, the Veil, gestures, back-to-where-you-were, crossings through the point.

## His rulings (12 Oct)

1. Launch arrives at the Bindu; Today is the first door. 2. Chakra 32 = the Ego Reveal (Gaia); its words stay sealed. 3. Axis 18, Crow 19. 4. Elements: Ahaṅ fire, Nāma air, Ātma light, Amṛta water. 5. **This app is energies, not stories.** Games stay; each Leela landing opens the chakra's energy (room). Story material is valuable but may belong in **Bindu Feed** (the story app) — flag it, don't drop it. 6. The dance draws on every archetype, all named (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey, Lalita…). 7. The 16 Karṣiṇī Functions stay (drafted by Claude). 8. Maya's last line: "only You, playing". 9. Deep zoom into the Bindu stays. 10. The Relationship Field is built in full. Restrictions such as "no menu", "one sound at a time", "three controls" are lifted.

Floors that stay: practice data never lost; position is identity; App Activity is the single ledger; the two Recognition lines verbatim ("she was felt here" / "and she felt you back"); no generated voice; nothing invented (bījas, baked text verbatim); his journals and letters private; no figure of a Śakti; nothing scores him; accessibility.

## How to read

- **Read every assigned file in full with the Read tool, line 1 to the end** (page with offset/limit where long). grep/ls/wc are not reading. For a minified or very long-line file, pretty-print a copy into your scratch directory and read that in full.
- Pure numeric data (e.g. audio-feature arrays in `*-data.json`) may be read structurally with `python3 -I`: print every key, its type, length and value range, and every non-numeric string in full. Say so in the proof.
- Images: open them with Read and describe them.
- Do not modify any code, skill, Airtable record or file outside your one output file. Read-only. Never print secrets.
- Privacy: in personal journal tables (Daily, SJ, Emotions, Anger, Gratitude, Health, Relationships, etc.) record field names, types and counts — not the private content — unless the field is design material (e.g. a person's name and the Śakti they carry).

## What to write

One file, `waves/register/NN-<slug>.md` (your number is in your task). Sections:

**A · Inventory** — everything the material contains, file by file, in enough detail that a builder never has to reopen the source: mechanisms, numbers (timings, Hz, colours, durations, counts), structures, data contracts, verbatim key lines (quoted exactly, with file:line).

**B · Gifts for the upgrade** — every element that could enrich the app, each as a row: *what it is · source (file:line) · which world(s) it lives in · how it would work there (mechanism, not mood) · what it needs (data, assets, new code) · energy or story* (story = candidate for Bindu Feed; say why). Be generous — list everything, including things that seem large.

**C · Conflicts and gaps** — where this material disagrees with the register, the rulings or the Airtable, or where something is designed but unbuilt.

**D · Coverage proof** — a table: file · total lines (`wc -l`) · lines read (ranges) · method · md5 (first 8). Every assigned file must appear. Anything not read in full is listed as such, with why.

Finish with a short return message: the file path, the line count, and the ten most valuable gifts you found.
