# PR-0 · kp-ordering findings

Run: `AIRTABLE_PAT=… node prototype/kp-order-check.mjs` (102 Airtable Shakti rows fetched).
Compares prototype per-ring `pos` against native `perRingIndex(khadgamalaPosition)`, joined on
`(ring, NFC(name))`.

## Verdict: **NOT ALIGNED → engines seed off stored `khadgamalaPosition`, never prototype `pos`.**

PR-4 already keys off `khadgamalaPosition ?? position` by construction, so the engine is safe.
This finding **hardens that into a rule** and adds a second, bigger one (below).

| Ring | Verdict | Detail |
|---|---|---|
| 1 | **DIVERGED** | Real ordering swaps: Laghimā (proto 2 / AT 3), Mahimā (proto 3 / AT 2), Icchā (proto 8 / AT 9). Plus 18 name-set differences. |
| 3 | name-set differs | AT hyphenates (`Anaṅga-Mālinī`); no by-name match, ordering not confirmable. |
| 4 | name-set differs | AT `Sarva-…` hyphenated + `(Devī)` suffixes; ordering not confirmable. |
| 5 | name-set differs | spelling/macron differences; ordering not confirmable. |
| 6 | **DIVERGED** | Sarvajñānamayī (proto 1 / AT 4); plus name-set differences. |
| 7 | **name-set DIFFERS substantially** | AT has the weapon-śaktis (Aṅkuśinī, Pāśinī, Cāpinī, Bāṇinī, Vasinī…); prototype has a different set (Vāśinī, Sarveśvarī…). |
| 8 | spelling | `Vajreśvarī` (proto) vs `Vajreśī` (AT). |
| 9 | ALIGNED | Lalitā. |

## Two rulings for the rebuild

1. **Engine key = stored `khadgamalaPosition`.** Jitter/mood/day-selection seed off it (never
   prototype `pos`, and never `perRingIndex` for rings 1,3–9 where ordering diverges). Ring 2's
   `position+28` bridge remains proven and may keep using `perRingIndex`.

2. **Airtable is the source of truth for names/content of the 86 — the prototype is NOT.** The
   prototype `all-shaktis-data.js` names, ordering, and (sparse) qualities diverge from the live
   Airtable base for most rings — most starkly Ring 7 (entirely different name sets) and Ring 1
   (different Siddhi/Mudrā members: AT has `Garimā`, `Aṇimā`, the `(Mudrā)` set). **The rebuild must
   render the 86 from Airtable/`Shakti` records, using the prototype only for look/motion/behavior —
   never porting its 86-Śakti data as canon.** (Consistent with the reconciled brief; this makes it a
   hard rule.)

## Airtable data-side prep (base `app248ZTWhYJlvQj2`, table `tblrRwXJD0uP8HU8G`)
- ✅ **`Descent Ring` Number field created** — `fld225xgYl2Rs3TP6` (precision 0, 1–9). Backs the
  crossing row's ring.
- **`Crossing` Row-Type option: created on first write via `typecast: true`** — not pre-created.
  The connected PAT has data-write but the metadata field-choice PATCH was rejected
  (`INVALID_REQUEST_UNKNOWN` — no `schema.bases:write`). This is fine and matches the App Activity
  ledger precedent: `typecast: true` on the create call auto-creates a missing single-select option
  using data scope. **PR-2's `recordCrossing` MUST send `typecast: true`** (same as the ledger writes),
  so the first crossing creates the option cleanly rather than degrading to a dropped write. No probe
  row is written (avoids a stray record).
