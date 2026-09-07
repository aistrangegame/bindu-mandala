// PR-0 · kp-ordering audit.
// Does the prototype's per-ring `pos` match native `perRingIndex(khadgamalaPosition)`
// for rings 1,3–9? If every ring aligns, engines may seed jitter/mood off
// perRingIndex; if any diverges, seed off stored `khadgamalaPosition` (which PR-4
// does by construction, so the engine is safe either way — this only records the fact).
//
// Run:  AIRTABLE_PAT=pat... node kp-order-check.mjs
// Join is on (ring, NFC(name)) — Sanskrit names repeat ACROSS rings, so name-alone
// would false-positive; collisions/unmatched are printed explicitly, never dropped.

import { readFileSync } from 'node:fs'
import vm from 'node:vm'

// ── 1. Load the prototype data (eval in a sandbox; Ring 2 comes from shakti-data.js
//       which we don't load here — Ring 2's +28 bridge is already proven).
const src = readFileSync(new URL('./_superseded/all-shaktis-data.js', import.meta.url), 'utf8')
const sandbox = { window: {}, SHAKTIS: [], CLUSTER_INFO: {}, console }
vm.createContext(sandbox)
vm.runInContext(src, sandbox)
const byRing = sandbox.window.SHAKTIS_BY_RING

// ── 2. Native KhadgamalaMap (mirrors Models/KhadgamalaMap.swift).
const ringOf = (kp) => kp <= 28 ? 1 : kp <= 44 ? 2 : kp <= 52 ? 3 : kp <= 66 ? 4
  : kp <= 76 ? 5 : kp <= 86 ? 6 : kp <= 98 ? 7 : kp <= 101 ? 8 : kp === 102 ? 9 : 0
const OFFSET = { 1: 0, 2: 28, 3: 44, 4: 52, 5: 66, 6: 76, 7: 86, 8: 98, 9: 101 }
const perRing = (kp) => { const r = ringOf(kp); return r ? kp - OFFSET[r] : 0 }
const nfc = (s) => (s || '').normalize('NFC').trim()

// ── 3. Fetch Airtable Shakti rows (khadgamalaPosition + sanskritName).
const PAT = process.env.AIRTABLE_PAT
if (!PAT) { console.error('FATAL: AIRTABLE_PAT not set'); process.exit(1) }
const BASE = 'app248ZTWhYJlvQj2', TABLE = 'tblrRwXJD0uP8HU8G'
const F_KP = 'fldI0aV1sfOeNybHI', F_NAME = 'fldJOatnYrw9l6tff', F_TYPE = 'fldw33m8YqrINlvrN'

const rows = []
let offset = null
do {
  const u = new URL(`https://api.airtable.com/v0/${BASE}/${TABLE}`)
  u.searchParams.set('pageSize', '100')
  u.searchParams.set('filterByFormula', `{${F_TYPE}}='Shakti'`)
  u.searchParams.set('returnFieldsByFieldId', 'true')
  u.searchParams.append('fields[]', F_KP)
  u.searchParams.append('fields[]', F_NAME)
  if (offset) u.searchParams.set('offset', offset)
  const res = await fetch(u, { headers: { Authorization: `Bearer ${PAT}` } })
  if (!res.ok) { console.error('Airtable error', res.status, await res.text()); process.exit(1) }
  const j = await res.json()
  rows.push(...j.records)
  offset = j.offset
} while (offset)

// ── 4. Per-ring Airtable maps (name → perRingIndex), tracking duplicates.
const at = {}, dupAT = []
for (const rec of rows) {
  const kp = rec.fields[F_KP], nm = nfc(rec.fields[F_NAME])
  if (kp == null || !nm) continue
  const r = ringOf(kp); if (!r) continue
  ;(at[r] ??= new Map())
  if (at[r].has(nm)) dupAT.push(`r${r}:${nm}`); else at[r].set(nm, perRing(kp))
}

// ── 5. Compare rings 1,3–9.
console.log(`Fetched ${rows.length} Airtable Shakti rows.\n`)
let allAligned = true
for (const r of [1, 3, 4, 5, 6, 7, 8, 9]) {
  const proto = byRing[r] || []
  const protoMap = new Map(), dupProto = []
  for (const s of proto) { const nm = nfc(s.name); protoMap.has(nm) ? dupProto.push(nm) : protoMap.set(nm, s.pos) }
  const atMap = at[r] || new Map()
  const diverged = [], unmatched = []
  for (const [nm, pos] of protoMap) {
    if (!atMap.has(nm)) { unmatched.push(nm); continue }
    if (atMap.get(nm) !== pos) diverged.push(`${nm}: proto ${pos} vs airtable ${atMap.get(nm)}`)
  }
  const extraAT = [...atMap.keys()].filter((nm) => !protoMap.has(nm))
  const verdict = diverged.length ? 'DIVERGED'
    : (unmatched.length || extraAT.length) ? 'MATCH-GAP (names differ; ordering not disproved)'
    : 'ALIGNED'
  if (verdict !== 'ALIGNED') allAligned = false
  console.log(`Ring ${r}: ${verdict}  [proto ${protoMap.size} · airtable ${atMap.size} · diverged ${diverged.length} · unmatchedProto ${unmatched.length} · extraAirtable ${extraAT.length}]`)
  for (const d of diverged) console.log(`   ✗ ${d}`)
  if (unmatched.length) console.log(`   proto→(no airtable match): ${unmatched.join(' · ')}`)
  if (extraAT.length) console.log(`   airtable→(no proto match): ${extraAT.join(' · ')}`)
  if (dupProto.length) console.log(`   DUP proto names in ring: ${dupProto.join(' · ')}`)
}
if (dupAT.length) console.log(`\nDUP airtable names in ring: ${dupAT.join(' · ')}`)
console.log(`\nOVERALL: ${allAligned
  ? 'ALL ALIGNED — engines may seed off perRingIndex(khadgamalaPosition).'
  : 'NOT ALL ALIGNED — seed engines off stored khadgamalaPosition (PR-4 does this by construction).'}`)
