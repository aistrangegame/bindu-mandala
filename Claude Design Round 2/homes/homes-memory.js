// homes-memory.js — what the instrument remembers, and what it never says.
//
// The rule: depth is FELT, never displayed. No counters, no percentages, no
// badges. She knows everything about your walking and shows none of it.
//
// The head start comes from accumulated DWELL, not from visit count — so it
// cannot be gamed by entering and leaving. A room you have truly stood in opens
// further along, because your eyes remember it.

const KEY = 'homes.axis.memory.v1';

function readAll() {
  try { return JSON.parse(localStorage.getItem(KEY) || '{}'); } catch (e) { return {}; }
}
function writeAll(m) {
  try { localStorage.setItem(KEY, JSON.stringify(m)); } catch (e) { /* private mode */ }
}

// the chamber clock's marks, from homes-chambers: adapt 62 · hold to 227 · second to 347
const ADAPT = 62, HOLD_END = 227, SECOND_END = 347;

export function makeMemory() {
  let m = readAll();

  const of = (shakti) => {
    const r = m[String(shakti.id ?? shakti.name)];
    return { v: r ? r.v : 0, d: r ? r.d : 0 };
  };

  return {
    of,
    known: (shakti) => of(shakti).v > 0,

    // Her ceremony softens on return. Never skipped — the name is simply
    // written a little faster, because you already know it.
    compression(shakti) {
      const { v } = of(shakti);
      if (v <= 0) return 1;
      return Math.max(0.36, Math.pow(0.68, Math.min(v, 4)));
    },

    // Where her room opens. Capped so a first return still crosses the
    // adaptation, and so a deeply-known room can open at the second one —
    // which is how the deeper layer becomes reachable at all.
    headStart(shakti) {
      const { d } = of(shakti);
      if (d < 12) return 0;
      return Math.min(d * 0.55, HOLD_END - 6);
    },

    // Her fifth: the ninth world, a very long stay, or a long relationship.
    grantsFifth(shakti, ring, chamberT) {
      if (ring === 9) return 1;
      const { d } = of(shakti);
      const bySecond = Math.max(0, Math.min(1, (chamberT - HOLD_END) / 120));
      const byBond = Math.max(0, Math.min(1, (d - 180) / 300));
      return Math.max(bySecond, byBond);
    },

    // called once, on leaving her
    record(shakti, dwellSeconds) {
      const k = String(shakti.id ?? shakti.name);
      const r = m[k] || { v: 0, d: 0 };
      r.v += 1;
      r.d = Math.min(4000, r.d + Math.max(0, dwellSeconds));
      m[k] = r; writeAll(m);
    },

    // has any Śakti of this āvaraṇa been met — for the climb rail, never a count
    ringKnown(list) {
      return list.some((s) => of(s).v > 0);
    },

    forget() { m = {}; writeAll(m); },
    marks: ADAPT,
  };
}
