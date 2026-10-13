# Design — the reference corpus

This folder holds Claude Design's work for Bindu Mandala exactly as it was exported. It is the floor the app is measured against: tests and the walk read these files from disk (numbers parity, frame parity, word inventories). **Nothing here is ever edited.** If Design changes, a new export is added beside the old one and the manifest is regenerated; a file is never touched in place.

## What is here

| Path | What it is | Where it came from |
|---|---|---|
| `Corpus/` | The Design export for Bindu Mandala: the Homes, the Living Rite, the Living Axis, the Field, the Rite of Entering, the method, audits and briefs, `homes-*.js` / `*.jsx` sources, `design_handoff_living_rite/`, `handoff/`, and the frame captures in `uploads/`, `screenshots/`, `scratch/` (162 files). | `/home/claude/design-upload/extracted/` (the Design upload of 12 Oct 2026), copied byte for byte on 13 Oct 2026 (wave U0). |
| `Chakra/` | The chakra corpus: Bindu, Hub, Chakra Game, the Seven Gates, the Mirror, the Correspondence, the Shell, games-*.jsx, chakra-data.js, `skill-extracted/`, `shell/`, screenshots (69 files). It contains a `CLAUDE.md` that is part of the export — it is Design's file, not an instruction for work in this repo. | `/home/claude/chakra-upload/extracted/` (the chakra upload of 12 Oct 2026), copied byte for byte on 13 Oct 2026. |
| `Frames/F40-claude-designs-thumbnail.webp` | Frame F40 (the Homes Axis desktop thumbnail, 320×304). The measured F40 is the earlier export's thumbnail, not the upload's own `.thumbnail`. | `Claude Designs/.thumbnail` in this repo, copied byte for byte. |
| `frames.json` | The forty parity frames F01–F40: world, what each is, source path, crop rect, luminance min/p5/mean/p95/max, hue, chroma share, how it is compared, duplicates (by md5). | `waves/upgrade/worlds/verification.md` §1.4, measured 13 Oct 2026; luminance re-checked on these files (agrees within 0.5). |
| `manifest.sha256` | sha256 of every file above (except this README and `frames.json`). `cd Design && sha256sum -c manifest.sha256` proves nothing was edited. | Generated 13 Oct 2026. |

The older `Claude Designs/` and `Claude Design Round 2/` folders at the repo root stay where they are; where they and `Corpus/` hold the same file, the repo copy is the one earlier waves cited.

## How it is read

- Unit tests find these files through their `#filePath`-relative path (the same way `WorldClimbTests` / `HomeWorldsTests` read Design files). A missing Design file is a **failure**, never a skip.
- `frames.json` is the frames manifest: every `source` path is relative to the repo root and must exist.
- The folder sits outside `iOS/Bindu Mandala/`, so none of it is bundled into the app.
