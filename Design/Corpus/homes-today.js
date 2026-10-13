// homes-today.js — who presides today.
//
// An exact port of the shipped `DailyEnergyService.swift`, so this instrument
// and the app always name the SAME energy on the same date. Do not "improve"
// the arithmetic: fidelity to the device is the whole point.
//
//   • the practice day turns at 6am local
//   • epoch 2020-01-01 00:00 UTC, fixed forever
//   • deterministic shuffled cycle — within any 102-day window each energy
//     appears exactly once, then the next cycle re-shuffles
//   • SplitMix64 over exact 64-bit arithmetic (BigInt), Fisher–Yates downward

const DAY_BOUNDARY_HOUR = 6;
const EPOCH_MS = 1577836800 * 1000;
const M64 = (1n << 64n) - 1n;

function splitmix64(state) {
  let s = state & M64;
  return () => {
    s = (s + 0x9E3779B97F4A7C15n) & M64;
    let z = s;
    z = ((z ^ (z >> 30n)) * 0xBF58476D1CE4E5B9n) & M64;
    z = ((z ^ (z >> 27n)) * 0x94D049BB133111EBn) & M64;
    return (z ^ (z >> 31n)) & M64;
  };
}

const floorDiv = (a, b) => Math.floor(a / b);
const floorMod = (a, b) => ((a % b) + b) % b;

// local start-of-day, matching Calendar.startOfDay
function startOfDayMs(ms) {
  const d = new Date(ms);
  d.setHours(0, 0, 0, 0);
  return d.getTime();
}

export function practiceDayIndex(date = new Date()) {
  const shift = DAY_BOUNDARY_HOUR * 3600 * 1000;
  const a = startOfDayMs(date.getTime() - shift);
  const b = startOfDayMs(EPOCH_MS - shift);
  return Math.round((a - b) / 86400000);
}

function shuffledPositions(count, seed) {
  const p = Array.from({ length: count }, (_, i) => i + 1);
  const rng = splitmix64(seed);
  for (let i = count - 1; i >= 1; i--) {
    const j = Number(rng() % BigInt(i + 1));
    const t = p[i]; p[i] = p[j]; p[j] = t;
  }
  return p;
}

function seedForCycle(cycle) {
  return (BigInt(cycle) ^ 0xD1B54A32D192ED03n) & M64;
}

export function positionForPracticeDay(day, count = 102) {
  if (count <= 0) return 1;
  const cycle = floorDiv(day, count);
  const slot = floorMod(day, count);
  return shuffledPositions(count, seedForCycle(cycle))[slot];
}

export function todaysPosition(date = new Date(), count = 102) {
  return positionForPracticeDay(practiceDayIndex(date), count);
}

// When the day turns — so the instrument can hand over without a reload.
export function nextTurnover(date = new Date()) {
  const d = new Date(date);
  d.setHours(DAY_BOUNDARY_HOUR, 0, 0, 0);
  if (d.getTime() <= date.getTime()) d.setDate(d.getDate() + 1);
  return d;
}

// The khaḍgamālā runs outward-in: the Bhūpura first, the Bindu last.
// position 1…102 → [ringIndex, indexWithinRing]
export function locate(position, ringLengths) {
  let p = Math.max(1, Math.min(102, position)) - 1;
  for (let i = 0; i < ringLengths.length; i++) {
    if (p < ringLengths[i]) return [i, p];
    p -= ringLengths[i];
  }
  return [ringLengths.length - 1, 0];
}
