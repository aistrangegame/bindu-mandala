# RULINGS QUEUE

Questions the laws, the rulings, the brief and Design's handoff could not answer. Each carries a recommended answer, which the build **proceeded with** as a reversible decision (charter §6). Ashrey reads this when the final build ships; anything he changes becomes a follow-up.

---

## 1 · Neev was locked, so the letters gate ran on the sealed container

**2026-09-21.** The charter makes a fresh container pull the gate for the letters migration, and the one hard stop. Neev is paired and the tunnel connects, but the developer disk image will not mount — `kAMDMobileImageMounterDeviceLocked`. The phone has been locked through every attempt.

**Recommended answer, and what the build did:** proceed on the sealed pristine container of 2026-09-06, which is a real V1 store holding his real letters. The migration passed against it byte-identically, hash-verified, with nothing else in the store disturbed. Retry the fresh pull before the final ship and re-run the gate for real if the phone is reachable.

**What depends on it:** everything downstream of Phase 2.1 — which is the whole queue, since the letters re-key is the schema those phases build on.

**If you want it done properly:** unlock Neev and leave it connected by cable for two minutes. The pull and the re-run take about that long.

**Resolved by Ashrey, 2026-09-21 — downgraded.** He ruled that the letters are not precious ("I haven't really recorded much there, so even if we lost the information, it is alright"), which releases charter §7's letters hard stop. This item stays open only as a nicety: the gate still runs on the sealed container, and the fresh pull is still retried before the ship so the check runs against real current data if the phone is reachable. Nothing waits on it. His recognitions, crossings and ledger rows remain sacred and are **not** covered by this release — see `DECISIONS.md` for why that reading is deliberately narrow.
