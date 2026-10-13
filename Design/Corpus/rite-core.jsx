// rite-core.jsx — tokens, the nine ring-worlds, the adaptation clock, stillness, audio.
// The Turrell mechanism lives here: one normalized value `a` advances so slowly that
// nothing appears to happen, and every surface in the room reads from it.

/* __iife */ (function () {
const RT = {
  ground: '#0D0508', gold: '#C9963F', cream: '#F2E8D9', red: '#8B1A2A',
  serif: "'Cormorant Garamond', Georgia, serif",
  mono: "ui-monospace, 'SF Mono', Menlo, monospace",
};

// The nine shared worlds. alt = vertical centre of the room's gravity (0 top, 1 floor).
// room = the seat's geometry in the Śrī Yantra — you stand inside it.
// hue/sat = the gem, at real saturation. wallHue = the dhātu the walls are made of.
const RITE_WORLDS = {
  1: { ord: 'first',   name: 'Trailokyamohana',    gem: 'Topaz',     dhatu: 'Rasa',  clock: 'day–night',       bija: 'Aim',           region: 'Feet',        alt: 0.72, room: 'square',    hue: 33,  sat: 86, wallHue: 26,  after: 'sharper' },
  2: { ord: 'second',  name: 'Sarvāśāparipūraka',  gem: 'Sapphire',  dhatu: 'Rakta', clock: 'the hour',        bija: 'Klīm',          region: 'Pelvis',      alt: 0.64, room: 'petal',     hue: 220, sat: 82, wallHue: 232, after: 'wider'   },
  3: { ord: 'third',   name: 'Sarvasaṅkṣobhaṇa',   gem: 'Coral',     dhatu: 'Māṃsa', clock: 'the day',         bija: 'Sauḥ',          region: 'Navel',       alt: 0.56, room: 'petal',     hue: 11,  sat: 78, wallHue: 8,   after: 'lighter' },
  4: { ord: 'fourth',  name: 'Sarvasaubhāgyadāyaka', gem: 'Diamond', dhatu: 'Medas', clock: 'lunar fortnight', bija: 'Hrīm',          region: 'Heart',       alt: 0.48, room: 'tri-up',    hue: 199, sat: 34, wallHue: 208, after: 'wider'   },
  5: { ord: 'fifth',   name: 'Sarvārthasādhaka',   gem: 'Emerald',   dhatu: 'Asthi', clock: 'lunar month',     bija: 'Hsraim',        region: 'Throat',      alt: 0.42, room: 'tri-down',  hue: 152, sat: 72, wallHue: 158, after: 'sharper' },
  6: { ord: 'sixth',   name: 'Sarvarakṣākara',     gem: 'Ruby',      dhatu: 'Majjā', clock: 'season',          bija: 'Hsklhrīm',      region: 'Forehead',    alt: 0.34, room: 'tri-up',    hue: 348, sat: 80, wallHue: 342, after: 'heavier' },
  7: { ord: 'seventh', name: 'Sarvarogahara',      gem: 'Pearl',     dhatu: 'Śukra', clock: 'solar half-year', bija: 'Hsauḥ',         region: 'Crown',       alt: 0.24, room: 'tri-down',  hue: 42,  sat: 26, wallHue: 36,  after: 'wider'   },
  8: { ord: 'eighth',  name: 'Sarvasiddhiprada',   gem: "Cat's eye", dhatu: 'Ojas',  clock: 'year',            bija: 'Aim Klīm Sauḥ', region: 'Above crown', alt: 0.20, room: 'tri-up',    hue: 44,  sat: 74, wallHue: 40,  after: 'lighter' },
  9: { ord: 'ninth',   name: 'Sarvānandamaya',     gem: 'All gems',  dhatu: 'Tejas', clock: 'kāla–akāla',      bija: 'Hrīm',          region: 'Totality',    alt: 0.46, room: 'circle',    hue: 46,  sat: 30, wallHue: 44,  after: 'wider'   },
};

// How fast the eye is made to adjust, and in what order surfaces cross into sight.
// This is the second uniqueness channel — two rooms in one world diverge here.
const RITE_RATES = {
  fast: { mul: 0.72, res: { edge: 0.10, membrane: 0.22, letter: 0.30, seam: 0.36, pool: 0.50 } },
  even: { mul: 1.00, res: { edge: 0.18, membrane: 0.34, letter: 0.44, seam: 0.50, pool: 0.62 } },
  slow: { mul: 1.38, res: { edge: 0.30, membrane: 0.52, letter: 0.60, seam: 0.70, pool: 0.84 } },
  late: { mul: 1.12, res: { edge: 0.44, membrane: 0.50, letter: 0.55, seam: 0.58, pool: 0.64 } },
};

// Three specimens, real card data, adjacent in khaḍgamālā order so the doors work
// and a return can be felt. Nothing here is designed for them — the grammar fills the slots.
const RITE_SPECIMENS = [
  {
    num: 27, ring: 1, name: 'Sarva-Yoni', dev: 'सर्वयोनि', family: 'Mudrā — the living hand-seals',
    quality: 'Source', tattva: 'Yoni (the source-aperture)', location: 'Lower belly / pelvic floor',
    alt: 0.72, shape: 'tri-down', rate: 'slow',
    phrase: 'Thank you for the womb that births all.',
    roots: ['Sarva', 'Yoni'], gloss: 'all-womb — the source of all',
    lines: [
      'The originating ground itself.',
      'The receptive aperture through which Bindu emanates.',
      'Lower belly opening. Pelvic floor receiving.',
      'The body remembering it is born from this.',
      'Hands joined into the downward triangle — the womb-seal.',
    ],
    letter: null,
    fn: 'The originating ground itself. The receptive aperture through which Bindu emanates.',
    somatic: 'Lower belly opening. Pelvic floor receiving. The body remembering it is born from this.',
    icon: 'Hands joined into the downward triangle, the womb-seal. The gesture of the origin from which all forms are born.',
  },
  {
    num: 28, ring: 1, name: 'Sarva-Trikhaṇḍā', dev: 'सर्वत्रिखण्डा', family: 'Mudrā — the living hand-seals',
    quality: 'Trinity-as-Unity', tattva: 'Tri-eka (three-as-one)', location: 'Crown opening to beyond',
    alt: 0.26, shape: 'triad', rate: 'late',
    phrase: 'Thank you for the three that becomes one.',
    roots: ['Sarva', 'Tri', 'Khaṇḍa', 'ā'], gloss: 'she of the three-fold section',
    lines: [
      'The final unlocking.',
      'The structural recognition that the trinity is one movement.',
      'Three breaths, three sensations, three thoughts collapsing into single awareness.',
      'The three-part seal gathering will, knowledge and action into one.',
      'The culminating gesture of the Bhūpura — the seal that closes the outer enclosure.',
    ],
    letter: 'The third time I sat here I stopped trying to hold the three apart, and there was nothing left to hold.',
    fn: 'The final unlocking. The structural recognition that the trinity is one movement.',
    somatic: 'Three things recognized as one — three breaths, three sensations, three thoughts collapsing into single awareness.',
    icon: 'The three-part seal gathering will, knowledge and action into one. The all-three-sectioned seal.',
  },
  {
    num: 1, ring: 1, name: 'Aṇimā', dev: 'अणिमा', family: 'Siddhi',
    quality: 'Smallness', tattva: 'Aṇu (the atomic)', location: 'Bindu point at crown / single point of attention',
    alt: 0.22, shape: 'point', rate: 'fast',
    phrase: 'Thank you for the smallness that contains all.',
    roots: ['Aṇu', 'imā'], gloss: 'atomic-ness — the power to become atomic',
    lines: [
      'Grants entry into any place no matter how confined.',
      'Awareness that becomes smaller than thought.',
      'Smaller than breath, smaller than the gap between two sensations.',
      'Fine as a dust-mote, pale and near-translucent.',
      'A noose, to draw the vast into the tiny.',
    ],
    letter: null,
    fn: 'Grants entry into any place no matter how confined. Without Her, no atomic-scale recognition is possible.',
    somatic: 'Awareness that becomes smaller than thought, smaller than breath, smaller than the gap between two sensations.',
    icon: 'A luminous goddess fine as a dust-mote, pale and near-translucent, holding a noose to draw the vast into the tiny.',
  },
];

// ── The clock ───────────────────────────────────────────────────────────────
// True durations, in seconds. Dilation multiplies elapsed time for review only.
const RITE_T = { beat1: 1.9, beat2: 3.7, beat3: 5.6, adapt: 90, hold: 165, second: 120 };
const RITE_T_REDUCED = { beat1: 2.6, beat2: 5.2, beat3: 7.8, adapt: 160, hold: 190, second: 150 };

const clamp01 = (n) => (n < 0 ? 0 : n > 1 ? 1 : n);
const ss = (t) => t * t * (3 - 2 * t);
const smooth2 = (t) => ss(ss(clamp01(t)));
const quant = (v, steps) => Math.round(clamp01(v) * (steps - 1)) / (steps - 1);
const lerp = (a, b, t) => a + (b - a) * t;

// Compression on return — Zero Gap. Never skipped, only softened.
function riteCompression(visits) {
  if (visits <= 1) return 1;
  return Math.max(0.36, Math.pow(0.66, Math.min(visits - 1, 3)));
}

function useRiteClock({ running, dilation, resetKey }) {
  const [t, setT] = React.useState(0);
  const raf = React.useRef(0);
  const last = React.useRef(0);
  React.useEffect(() => { setT(0); last.current = 0; }, [resetKey]);
  React.useEffect(() => {
    if (!running) return;
    let alive = true;
    const step = (now) => {
      if (!alive) return;
      if (!last.current) last.current = now;
      const dt = Math.min((now - last.current) / 1000, 0.25);
      last.current = now;
      setT((prev) => prev + dt * dilation);
      raf.current = requestAnimationFrame(step);
    };
    raf.current = requestAnimationFrame(step);
    return () => { alive = false; last.current = 0; cancelAnimationFrame(raf.current); };
  }, [running, dilation]);
  return t;
}

// Everything the room needs, derived from one elapsed value. The threshold is no
// longer on this clock — it is tap-advanced, and this clock starts when it ends.
function riteState({ t, spec, reduced }) {
  const T = reduced ? RITE_T_REDUCED : RITE_T;
  const rate = RITE_RATES[spec.rate] || RITE_RATES.even;
  const adaptDur = T.adapt * rate.mul;
  const holdEnd = adaptDur + T.hold;
  const secondEnd = holdEnd + T.second;

  let a = smooth2(t / adaptDur);
  let b = smooth2((t - holdEnd) / T.second);
  if (reduced) { a = quant(a, 4); b = quant(b, 3); }

  const phase = t >= secondEnd ? 'deep' : t >= holdEnd ? 'second' : t >= adaptDur ? 'settled' : 'adapting';
  return { a, b, phase, res: rate.res, marks: { adaptEnd: adaptDur, holdEnd, secondEnd } };
}

// The threshold's three beats, self-paced. Each beat's writing animates over its
// own duration; the tap moves on whenever you are ready.
const RITE_BEAT_DUR = { 1: 2.4, 2: 3.2, 3: 2.8 };
function riteBeatDur(beat, visits, reduced) {
  return (RITE_BEAT_DUR[beat] || 2.4) * riteCompression(visits) * (reduced ? 1.35 : 1);
}

// Stillness — the portrait surfaces only while you stay put.
function useStillness(t, active) {
  const [markT, setMarkT] = React.useState(0);
  const tRef = React.useRef(t);
  tRef.current = t;
  React.useEffect(() => {
    if (!active) return;
    // Touching her own objects is not restlessness — only leaving the room's stillness is.
    const bump = (e) => {
      const t = e.target;
      if (t && t.closest && t.closest('button')) return;
      setMarkT(tRef.current);
    };
    const opts = { passive: true };
    ['pointerdown', 'pointermove', 'wheel', 'touchmove', 'keydown'].forEach((e) => window.addEventListener(e, bump, opts));
    return () => ['pointerdown', 'pointermove', 'wheel', 'touchmove', 'keydown'].forEach((e) => window.removeEventListener(e, bump, opts));
  }, [active]);
  React.useEffect(() => { setMarkT(tRef.current); }, [active]);
  return Math.max(0, t - markT);
}

const RITE_LINE_GAP = 6.5;
const riteLinesShown = (still, a, count) =>
  a < 0.4 ? 0 : Math.min(count, Math.floor(Math.max(0, still - 4) / RITE_LINE_GAP));

// ── After-effect ────────────────────────────────────────────────────────────
// Her Siddhi lingers on the whole instrument. Decays over minutes. Never named.
const RITE_AFTER_DUR = 180;
function riteAfterStyle(kind, age) {
  if (!kind) return {};
  const k = 1 - clamp01(age / RITE_AFTER_DUR);
  if (k <= 0.001) return {};
  const e = k * k;
  switch (kind) {
    case 'lighter': return { filter: `brightness(${1 + 0.07 * e}) saturate(${1 - 0.06 * e})`, transform: `translateY(${-3 * e}px)` };
    case 'heavier': return { filter: `brightness(${1 - 0.06 * e}) contrast(${1 + 0.04 * e})`, transform: `scale(${1 + 0.01 * e})`, transformOrigin: 'bottom center' };
    case 'sharper': return { filter: `contrast(${1 + 0.1 * e}) saturate(${1 + 0.05 * e})`, transform: `scale(${1 - 0.014 * e})` };
    case 'wider':   return { filter: `brightness(${1 + 0.03 * e})`, transform: `scale(${1 + 0.018 * e})` };
    default: return {};
  }
}

// ── Sound (gates only, opt-in) ──────────────────────────────────────────────
const RITE_BIJA_HZ = { 'Aim': 136.1, 'Klīm': 144, 'Sauḥ': 126.2, 'Hrīm': 152.7, 'Hsraim': 160.4, 'Hsklhrīm': 118.6, 'Hsauḥ': 172.1, 'Aim Klīm Sauḥ': 136.1 };

function riteMakeAudio() {
  let ctx = null, nodes = null;
  const start = (hz) => {
    try {
      if (!ctx) ctx = new (window.AudioContext || window.webkitAudioContext)();
      if (ctx.state === 'suspended') ctx.resume();
      if (nodes) return;
      const g = ctx.createGain(); g.gain.value = 0;
      const lp = ctx.createBiquadFilter(); lp.type = 'lowpass'; lp.frequency.value = 200; lp.Q.value = 0.6;
      const mk = (f, gain) => { const o = ctx.createOscillator(); o.type = 'sine'; o.frequency.value = f; const og = ctx.createGain(); og.gain.value = gain; o.connect(og); og.connect(lp); o.start(); return { o, og }; };
      const sub = mk(hz / 2, 0.9), one = mk(hz, 0.55), two = mk(hz * 1.004, 0.45), fifth = mk(hz * 1.5, 0);
      lp.connect(g); g.connect(ctx.destination);
      nodes = { g, lp, sub, one, two, fifth };
    } catch (e) { /* audio unavailable */ }
  };
  const update = (a, b, on) => {
    if (!nodes || !ctx) return;
    const now = ctx.currentTime;
    nodes.g.gain.setTargetAtTime(on ? 0.028 + 0.022 * a : 0, now, 0.6);
    nodes.lp.frequency.setTargetAtTime(190 + 900 * a, now, 1.2);
    nodes.fifth.og.gain.setTargetAtTime(0.16 * b, now, 1.5);
  };
  const stop = () => {
    if (!nodes || !ctx) return;
    try { nodes.g.gain.setTargetAtTime(0, ctx.currentTime, 0.4); } catch (e) {}
  };
  return { start, update, stop };
}

Object.assign(window, {
  RT, RITE_WORLDS, RITE_RATES, RITE_SPECIMENS, RITE_T, RITE_T_REDUCED, RITE_AFTER_DUR, RITE_BIJA_HZ,
  clamp01, ss, smooth2, quant, lerp, riteCompression, useRiteClock, riteState, riteBeatDur,
  useStillness, riteLinesShown, riteAfterStyle, riteMakeAudio,
});

})();
