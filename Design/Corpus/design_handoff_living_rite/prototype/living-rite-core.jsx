// living-rite-core.jsx — data assembly, day cycle, per-shakti atmosphere engine,
// sigil geometry, motes, shared atoms. Exports to window.

// ─── Assemble the full 102 with global positions ─────────────────────────────

const LR_RING_ORDER = [1,2,3,4,5,6,7,8,9];

function lrBuildAll() {
  let kp = 0;
  const all = [];
  LR_RING_ORDER.forEach(ring => {
    const list = window.SHAKTIS_BY_RING[ring] || [];
    list.forEach(s => {
      kp += 1;
      all.push({ ...s, ring, kp });
    });
  });
  return all;
}

const LR_ALL = lrBuildAll(); // 102 entries
const LR_AVARANA_BY_RING = {};
window.AVARANAS.forEach(a => { LR_AVARANA_BY_RING[a.ring] = a; });

const LR_ORDINALS = ['','First','Second','Third','Fourth','Fifth','Sixth','Seventh','Eighth','Ninth'];

// ─── Palette derivation ──────────────────────────────────────────────────────

const LR_BASE = {
  ground: '#0D0508',
  gold:   '#C9963F',
  cream:  '#F2E8D9',
  red:    '#8B1A2A',
};

const LR_CLUSTER_HUES = {
  inner:     { h: 43,  s: 78, l: 52 },   // #D4A017
  tanmatra:  { h: 13,  s: 47, l: 56 },   // #C4725A
  citta:     { h: 180, s: 49, l: 32 },   // #2A7A7A
  stability: { h: 140, s: 24, l: 38 },   // #4A7A5A
  self:      { h: 270, s: 26, l: 48 },   // #7A5A9A
};

const LR_RING_HUES = {
  1: { h: 35,  s: 58, l: 54 },  // bhūpura amber
  3: { h: 341, s: 45, l: 58 },  // anaṅga rose
  4: { h: 353, s: 55, l: 48 },  // auspicious crimson
  5: { h: 18,  s: 62, l: 55 },  // accomplishment coral
  6: { h: 194, s: 42, l: 46 },  // protection teal-blue
  7: { h: 322, s: 38, l: 50 },  // vāk wine
  8: { h: 2,   s: 68, l: 50 },  // mūla red
  9: { h: 46,  s: 72, l: 66 },  // bindu white-gold
};

// Element per shakti: ring 2 from tattva, else per-ring temperament.
const LR_RING_ELEMENTS = { 1:'earth', 3:'air', 4:'water', 5:'fire', 6:'ether', 7:'air', 8:'fire', 9:'light' };

function lrElement(s) {
  if (s.ring === 2 && s.tattva) {
    const t = s.tattva.toLowerCase();
    if (t.includes('fire') || t.includes('agni'))   return 'fire';
    if (t.includes('air')  || t.includes('vāyu') || t.includes('vayu')) return 'air';
    if (t.includes('water')|| t.includes('jala') || t.includes('apas')) return 'water';
    if (t.includes('earth')|| t.includes('pṛthvī')|| t.includes('prithvi')) return 'earth';
    if (t.includes('ether')|| t.includes('ākāśa') || t.includes('space') || t.includes('akasha')) return 'ether';
    return 'ether';
  }
  return LR_RING_ELEMENTS[s.ring] || 'ether';
}

function lrHsl({h,s,l}, alpha) {
  return alpha == null ? `hsl(${h} ${s}% ${l}%)` : `hsl(${h} ${s}% ${l}% / ${alpha})`;
}

// ─── Bīja sound — her seed-syllable given a voice ────────────────────────────
// The bīja is the Śakti's sonic body; sounding it is the point of "tap to hear."
// A soft sine drone with a fifth + octave and a slow swell, pitched from the
// syllable itself so each of the 102 has her own tone. Pure Web Audio, offline.
let _lrAudioCtx = null;
function lrPlayBija(bija) {
  try {
    const AC = window.AudioContext || window.webkitAudioContext;
    if (!AC) return 0;
    _lrAudioCtx = _lrAudioCtx || new AC();
    const ac = _lrAudioCtx;
    if (ac.state === 'suspended') ac.resume();

    // Deep, meditative scale (a low pentatonic drone register).
    const scale = [130.81, 146.83, 174.61, 196.0, 220.0, 261.63, 293.66];
    const s = (bija || '').split(' — ')[0];
    let h = 0; for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) >>> 0;
    const base = scale[h % scale.length];

    const now = ac.currentTime;
    const master = ac.createGain();
    master.gain.setValueAtTime(0.0001, now);
    master.gain.exponentialRampToValueAtTime(0.26, now + 0.35);
    master.gain.exponentialRampToValueAtTime(0.0001, now + 3.6);

    const warm = ac.createBiquadFilter();
    warm.type = 'lowpass';
    warm.frequency.setValueAtTime(1200, now);
    warm.frequency.exponentialRampToValueAtTime(600, now + 3.2);
    master.connect(warm); warm.connect(ac.destination);

    // subtle vibrato shared across partials
    const lfo = ac.createOscillator(); lfo.frequency.value = 5.2;
    const lfoGain = ac.createGain(); lfoGain.gain.value = base * 0.006;
    lfo.connect(lfoGain); lfo.start(now); lfo.stop(now + 3.7);

    [[base, 1], [base * 1.5, 0.38], [base * 2, 0.2]].forEach(([f, g]) => {
      const o = ac.createOscillator(); o.type = 'sine'; o.frequency.value = f;
      lfoGain.connect(o.frequency);
      const og = ac.createGain(); og.gain.value = g;
      o.connect(og); og.connect(master);
      o.start(now); o.stop(now + 3.7);
    });
    return 3.6;
  } catch (e) { return 0; }
}

// ─── Ring-entry chime — a soft bell as you cross each enclosure inward ────────
// Deeper rings ring lower and rounder — falling inward descends in pitch. Quiet,
// bell-like, distinct from the 3.6s bīja drone. Gated by the sound toggle.
const LR_RING_FREQ = { 1: 392.0, 2: 349.2, 3: 329.6, 4: 293.7, 5: 261.6, 6: 246.9, 7: 220.0, 8: 196.0 };
function lrRingChime(ring) {
  try {
    const AC = window.AudioContext || window.webkitAudioContext;
    if (!AC) return;
    _lrAudioCtx = _lrAudioCtx || new AC();
    const ac = _lrAudioCtx;
    if (ac.state === 'suspended') ac.resume();
    const base = LR_RING_FREQ[ring] || 262;
    const now = ac.currentTime, dur = 1.7;

    const master = ac.createGain();
    master.gain.setValueAtTime(0.0001, now);
    master.gain.exponentialRampToValueAtTime(0.085, now + 0.012);
    master.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    const warm = ac.createBiquadFilter();
    warm.type = 'lowpass';
    warm.frequency.setValueAtTime(2400, now);
    warm.frequency.exponentialRampToValueAtTime(700, now + dur * 0.8);
    master.connect(warm); warm.connect(ac.destination);

    // bell partials — fundamental + shimmering overtones, each decaying on its own
    [[base, 1, dur], [base * 2.0, 0.3, dur * 0.7], [base * 2.76, 0.16, dur * 0.5], [base * 0.5, 0.22, dur * 0.9]].forEach(([f, g, d]) => {
      const o = ac.createOscillator(); o.type = 'sine'; o.frequency.value = f;
      const og = ac.createGain();
      og.gain.setValueAtTime(0.0001, now);
      og.gain.exponentialRampToValueAtTime(g, now + 0.012);
      og.gain.exponentialRampToValueAtTime(0.0001, now + d);
      o.connect(og); og.connect(master);
      o.start(now); o.stop(now + d + 0.05);
    });
  } catch (e) {}
}

// ─── Time of day — the same energy, lit by the hour ──────────────────────────
// The practitioner meets her at 6am, but returns through the day; the light
// should move. Each variant shifts her hue, luminance, saturation and glow, and
// tints the ground — so noon feels clarified and night feels deep.
const LR_TIME_VARIANTS = {
  dawn:  { key: 'dawn',  label: 'Dawn',  dh: 8,  lAdd: 6,  sMul: 1.02, glowMul: 1.15, tint: '#3a1c22', tintA: 0.12, moteMul: 1.0 },
  noon:  { key: 'noon',  label: 'Noon',  dh: -5, lAdd: 13, sMul: 0.88, glowMul: 0.8,  tint: '#242838', tintA: 0.07, moteMul: 0.7 },
  dusk:  { key: 'dusk',  label: 'Dusk',  dh: 3,  lAdd: 2,  sMul: 1.16, glowMul: 1.25, tint: '#331306', tintA: 0.14, moteMul: 1.15 },
  night: { key: 'night', label: 'Night', dh: -7, lAdd: -9, sMul: 1.06, glowMul: 1.05, tint: '#060716', tintA: 0.16, moteMul: 1.3 },
};

function lrTimeVariant(pref) {
  if (pref && pref !== 'auto' && LR_TIME_VARIANTS[pref]) return LR_TIME_VARIANTS[pref];
  const h = new Date().getHours();
  if (h >= 5 && h < 9)  return LR_TIME_VARIANTS.dawn;
  if (h >= 9 && h < 16) return LR_TIME_VARIANTS.noon;
  if (h >= 16 && h < 20) return LR_TIME_VARIANTS.dusk;
  return LR_TIME_VARIANTS.night;
}

const _lrClamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));

// Re-light an atmosphere for a time of day. Preserves geometry/element/avarana.
function lrApplyTime(atmo, tv) {
  if (!tv) return atmo;
  const hue = {
    h: (atmo.hue.h + tv.dh + 360) % 360,
    s: _lrClamp(atmo.hue.s * tv.sMul, 6, 90),
    l: _lrClamp(atmo.hue.l + tv.lAdd, 8, 82),
  };
  const glowA = _lrClamp(0.36 * tv.glowMul, 0.12, 0.5);
  return {
    ...atmo,
    hue,
    timeKey: tv.key,
    accent:      lrHsl(hue),
    accentBright:lrHsl({ ...hue, l: Math.min(hue.l + 18, 80), s: Math.min(hue.s + 10, 90) }),
    accentSoft:  lrHsl(hue, 0.62),
    accentFaint: lrHsl(hue, 0.24),
    ground:      `color-mix(in oklab, color-mix(in oklab, ${LR_BASE.ground} 80%, ${lrHsl(hue)} 20%) ${100 - Math.round(tv.tintA * 100)}%, ${tv.tint} ${Math.round(tv.tintA * 100)}%)`,
    groundDeep:  `color-mix(in oklab, color-mix(in oklab, #070205 88%, ${lrHsl(hue)} 12%) ${100 - Math.round(tv.tintA * 100)}%, ${tv.tint} ${Math.round(tv.tintA * 100)}%)`,
    glow:        lrHsl({ ...hue, l: Math.min(hue.l + 6, 72) }, glowA),
  };
}

// Small deterministic jitter so sisters in one cluster still differ.
function lrJitter(kp, range) { return ((kp * 2654435761 % 1000) / 1000 - 0.5) * range; }

function lrAtmosphere(s) {
  const base = s.ring === 2 && s.cluster ? LR_CLUSTER_HUES[s.cluster] : LR_RING_HUES[s.ring];
  const hue = { ...base, h: (base.h + lrJitter(s.kp, 14) + 360) % 360 };
  const element = lrElement(s);
  const av = LR_AVARANA_BY_RING[s.ring];
  return {
    hue,
    element,
    accent:      lrHsl(hue),
    accentBright:lrHsl({ ...hue, l: Math.min(hue.l + 18, 78), s: Math.min(hue.s + 10, 88) }),
    accentSoft:  lrHsl(hue, 0.62),
    accentFaint: lrHsl(hue, 0.24),
    ground:      `color-mix(in oklab, ${LR_BASE.ground} 80%, ${lrHsl(hue)} 20%)`,
    groundDeep:  `color-mix(in oklab, #070205 88%, ${lrHsl(hue)} 12%)`,
    glow:        lrHsl({ ...hue, l: Math.min(hue.l + 6, 70) }, 0.36),
    geometry:    av ? av.geometry : 'lotus16',
    avarana:     av,
    rotation:    Math.round(lrJitter(s.kp, 44)),
  };
}

// ─── The day cycle — deterministic shuffled walk through the 102 ─────────────

const LR_EPOCH = Date.UTC(2020, 0, 1);

function lrPracticeDayIndex(date) {
  const shifted = new Date(date.getTime() - 6 * 3600 * 1000);
  const local = new Date(shifted.getFullYear(), shifted.getMonth(), shifted.getDate());
  return Math.floor((local.getTime() - LR_EPOCH) / 86400000);
}

function lrSeededShuffle(count, seed) {
  const arr = Array.from({length: count}, (_, i) => i + 1);
  let st = (seed ^ 0xD192ED03) >>> 0;
  const rnd = () => {
    st = (st + 0x9E3779B9) >>> 0;
    let z = st;
    z = Math.imul(z ^ (z >>> 16), 0x45D9F3B) >>> 0;
    z = Math.imul(z ^ (z >>> 13), 0x45D9F3B) >>> 0;
    return ((z ^ (z >>> 16)) >>> 0) / 4294967296;
  };
  for (let i = count - 1; i >= 1; i--) {
    const j = Math.floor(rnd() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

function lrTodaysShakti(dayOffset) {
  const day = lrPracticeDayIndex(new Date()) + (dayOffset || 0);
  const cycle = Math.floor(day / 102);
  const slot = ((day % 102) + 102) % 102;
  const kp = lrSeededShuffle(102, cycle)[slot];
  return LR_ALL.find(s => s.kp === kp) || LR_ALL[0];
}

// ─── Moon + Nityā ─────────────────────────────────────────────────────────────

const LR_SYNODIC = 29.530588853;
const LR_NEWMOON_REF = Date.UTC(2000, 0, 6, 18, 14);

function lrMoon(dayOffset) {
  const now = Date.now() + (dayOffset || 0) * 86400000;
  const frac = (((now - LR_NEWMOON_REF) / 86400000 / LR_SYNODIC) % 1 + 1) % 1;
  const tithiDay = Math.min(30, Math.floor(frac * 30) + 1);   // 1–30
  const waxing = tithiDay <= 15;
  const isFull = frac >= 0.47 && frac <= 0.53;
  let pos = waxing ? tithiDay : 15 - (tithiDay - 15);
  if (pos < 1) pos = 1;
  const nitya = window.NITYA_DEVIS.find(n => n.tithi === pos);
  return {
    frac, waxing, isFull,
    tithiLabel: (waxing ? 'Śukla ' : 'Kṛṣṇa ') + (nitya ? nitya.tithiName : ''),
    nityaName: isFull ? 'Lalitā Mahātripurasundarī' : (nitya ? nitya.name : ''),
  };
}

// ─── Text helpers ─────────────────────────────────────────────────────────────

function lrNameSize(name, max) {
  const m = max || 60;
  const L = name.length;
  if (L <= 9)  return m;
  if (L <= 12) return Math.min(m, 56);
  if (L <= 15) return Math.min(m, 48);
  if (L <= 18) return Math.min(m, 42);
  return Math.min(m, 37);
}

function lrQuality(s) {
  if (s.quality) return s.quality;
  const av = LR_AVARANA_BY_RING[s.ring];
  return av ? `Of the ${LR_ORDINALS[s.ring].toLowerCase()} āvaraṇa — ${av.subtitle.toLowerCase()}` : '';
}

function lrPrompt(s) {
  if (s.somatic) return s.somatic;
  if (s.somaticPoetry) {
    const first = s.somaticPoetry.split('\n')[0].trim();
    if (first) return first;
  }
  return 'Where do you feel her, right now?';
}

// ─── Composition engine — each element reshapes the screen ────────────────────
// Element → structural archetype, so different days are structurally different,
// not merely recolored. A per-kp "mood" adds within-element variance (which
// side the axis leans, sigil scale + spin, name tier, gradient angle).

const LR_ARCHETYPE_BY_ELEMENT = {
  fire:  'ascension',   // she rises — bīja column up, name low-center, updraft
  water: 'descent',     // she settles — name high, prompt pools low, cool floor
  air:   'horizon',     // she drifts — asymmetric, name leans, sigil offset
  ether: 'veil',        // she pervades — name is the vast backdrop, prompt afloat
  earth: 'foundation',  // she grounds — wide low sigil base, centered + stable
  light: 'radiance',    // she is the point — name inside a dominant living sigil
};

function lrComposition(s) {
  const element = lrElement(s);
  const archetype = LR_ARCHETYPE_BY_ELEMENT[element] || 'foundation';
  const m = (s.kp * 2654435761) >>> 0;
  return {
    element,
    archetype,
    flip: (m & 1) === 1,                       // lean left/right
    spin: (m & 2) ? 1 : -1,                    // sigil rotation direction
    sigilScale: 0.86 + ((m >> 3) & 7) / 7 * 0.4,   // 0.86–1.26
    nameTier: (m >> 6) & 3,                     // 0–3 subtle size nudge
    gradAngle: ((m >> 8) & 15) * 24,            // 0–360 in 24° steps
  };
}

// ─── Recognition responses — how she moves when she is felt back ─────────────
// Focal point, ripple manner, and the sigil/bīja "response" animation vary by
// element so the ceremony itself takes on her nature.
const LR_RECOG = {
  fire:  { fx: '50%', fy: '60%', focal: '50% 96%', resp: 'lrRespFlare',    respDur: 5.5, respFill: 'infinite', ripple: 'lrRippleRise', rippleDur: 4.6, rippleN: 4, motes: 12 },
  water: { fx: '50%', fy: '50%', focal: '50% 62%', resp: 'lrRespPool',     respDur: 6.5, respFill: 'infinite', ripple: 'lrRipple',     rippleDur: 6.4, rippleN: 4, motes: 10 },
  air:   { fx: '50%', fy: '44%', focal: '50% 40%', resp: 'lrRespDisperse', respDur: 6.0, respFill: 'infinite', ripple: 'lrRippleWide', rippleDur: 4.0, rippleN: 5, motes: 14 },
  ether: { fx: '50%', fy: '45%', focal: '50% 45%', resp: 'lrRespBloom',    respDur: 4.8, respFill: '1 forwards', ripple: 'lrRipple',    rippleDur: 5.6, rippleN: 3, motes: 10 },
  earth: { fx: '50%', fy: '54%', focal: '50% 92%', resp: 'lrRespSettle',   respDur: 7.5, respFill: 'infinite', ripple: 'lrRipple',     rippleDur: 7.6, rippleN: 2, motes: 6 },
  light: { fx: '50%', fy: '44%', focal: '50% 44%', resp: 'lrRespRadiate',  respDur: 3.8, respFill: 'infinite', ripple: 'lrRipple',     rippleDur: 3.6, rippleN: 5, motes: 12 },
};

// Element-specific backdrop — where the light lives on the screen.
function lrBackdrop(atmo) {
  const g = atmo.glow, gd = atmo.groundDeep, gr = atmo.ground, af = atmo.accentFaint, as = atmo.accentSoft;
  switch (atmo.element) {
    case 'fire':
      return `radial-gradient(ellipse 95% 62% at 50% 104%, ${g}, transparent 62%), radial-gradient(ellipse 120% 40% at 50% -10%, ${af}, transparent 60%), linear-gradient(#080203, ${gd})`;
    case 'water':
      return `radial-gradient(ellipse 130% 52% at 50% 106%, ${as}, transparent 68%), linear-gradient(${gr}, ${gd})`;
    case 'air':
      return `radial-gradient(ellipse 78% 96% at ${atmo._flipLeft ? 82 : 18}% 40%, ${g}, transparent 60%), linear-gradient(120deg, ${gr}, ${gd})`;
    case 'ether':
      return `radial-gradient(circle at 50% 44%, ${g}, transparent 58%), radial-gradient(circle at 50% 44%, ${af}, transparent 42%), linear-gradient(${gr}, ${gd})`;
    case 'earth':
      return `radial-gradient(ellipse 140% 48% at 50% 96%, ${g}, transparent 66%), linear-gradient(${gr}, ${gd})`;
    case 'light':
      return `radial-gradient(circle at 50% 42%, ${as}, ${g} 26%, transparent 62%), linear-gradient(${gd}, #060305)`;
    default:
      return `radial-gradient(ellipse 120% 70% at 50% 30%, ${g}, transparent 70%), linear-gradient(${gr}, ${gd})`;
  }
}

// ─── Sigil geometry (SVG paths, stroke only) ──────────────────────────────────

function lrPolygonPath(cx, cy, r, sides, rotDeg) {
  const rot = (rotDeg || 0) * Math.PI / 180;
  let d = '';
  for (let i = 0; i < sides; i++) {
    const a = rot + (i * 2 * Math.PI) / sides - Math.PI / 2;
    const x = cx + r * Math.cos(a), y = cy + r * Math.sin(a);
    d += (i === 0 ? 'M' : 'L') + x.toFixed(1) + ' ' + y.toFixed(1);
  }
  return d + 'Z';
}

function lrTrianglePath(cx, cy, r, up) {
  return lrPolygonPath(cx, cy, r, 3, up ? 0 : 60);
}

function lrPetalPath(cx, cy, innerR, outerR, halfWidthDeg, angleDeg) {
  const a = angleDeg * Math.PI / 180;
  const w = halfWidthDeg * Math.PI / 180;
  const tip  = [cx + outerR * Math.sin(a), cy - outerR * Math.cos(a)];
  const base = [cx + innerR * Math.sin(a), cy - innerR * Math.cos(a)];
  const midR = innerR + (outerR - innerR) * 0.62;
  const c1 = [cx + midR * Math.sin(a - w), cy - midR * Math.cos(a - w)];
  const c2 = [cx + midR * Math.sin(a + w), cy - midR * Math.cos(a + w)];
  return `M${base[0].toFixed(1)} ${base[1].toFixed(1)} Q${c1[0].toFixed(1)} ${c1[1].toFixed(1)} ${tip[0].toFixed(1)} ${tip[1].toFixed(1)} Q${c2[0].toFixed(1)} ${c2[1].toFixed(1)} ${base[0].toFixed(1)} ${base[1].toFixed(1)}Z`;
}

// A ring of n triangles alternating orientation
function lrTriRingPaths(cx, cy, r, n, triR) {
  const out = [];
  for (let i = 0; i < n; i++) {
    const a = (i * 2 * Math.PI) / n - Math.PI / 2;
    const x = cx + r * Math.cos(a), y = cy + r * Math.sin(a);
    out.push(lrTrianglePath(x, y, triR, i % 2 === 0));
  }
  return out;
}

/** The full-screen sigil behind Today — geometry of her ring. */
function LrSigil({ atmo, size, opacity, spin, spinDir }) {
  const S = size || 760;
  const c = S / 2;
  const stroke = atmo.accent;
  const gold = LR_BASE.gold;
  const g = atmo.geometry;
  const els = [];
  const add = (d, w, o, col) => els.push(
    <path key={els.length} d={d} fill="none" stroke={col || stroke} strokeWidth={w} opacity={o * 1.7} />
  );

  if (g === 'square') {
    [0.94, 0.80, 0.66].forEach((f, i) => {
      const r = c * f;
      add(`M${c - r} ${c - r} H${c + r} V${c + r} H${c - r} Z`, 1, 0.30 - i * 0.06);
    });
    // T-gates on the middle square
    const r = c * 0.80, gw = c * 0.12, gd = c * 0.10;
    [[0,-1],[0,1],[-1,0],[1,0]].forEach(([dx,dy], i) => {
      const gx = c + dx * r, gy = c + dy * r;
      const px = dy !== 0 ? 1 : 0, py = dx !== 0 ? 1 : 0;
      add(`M${gx - px*gw} ${gy - py*gw} L${gx - px*gw + dx*gd} ${gy - py*gw + dy*gd} M${gx + px*gw} ${gy + py*gw} L${gx + px*gw + dx*gd} ${gy + py*gw + dy*gd}`, 1, 0.26, gold);
    });
  } else if (g === 'lotus16' || g === 'lotus8') {
    const n = g === 'lotus16' ? 16 : 8;
    for (let i = 0; i < n; i++) {
      add(lrPetalPath(c, c, c * 0.42, c * 0.88, 360 / n / 2.6, (i * 360) / n), 1, 0.24);
    }
    add(lrPolygonPath(c, c, c * 0.42, 48, 0), 0.8, 0.20, gold);
  } else if (g === 'tri14' || g === 'tri10o' || g === 'tri10i') {
    const n = g === 'tri14' ? 14 : 10;
    const ringR = g === 'tri10i' ? c * 0.52 : c * 0.66;
    lrTriRingPaths(c, c, ringR, n, c * 0.14).forEach(d => add(d, 1, 0.22));
    add(lrPolygonPath(c, c, ringR + c * 0.22, 64, 0), 0.8, 0.16, gold);
    add(lrPolygonPath(c, c, ringR - c * 0.22, 64, 0), 0.8, 0.14, gold);
  } else if (g === 'tri8') {
    lrTriRingPaths(c, c, c * 0.5, 8, c * 0.16).forEach(d => add(d, 1, 0.24));
  } else if (g === 'trikona') {
    add(lrTrianglePath(c, c, c * 0.72, false), 1.2, 0.34);
    add(lrTrianglePath(c, c, c * 0.5, false), 1, 0.22);
    add(lrTrianglePath(c, c, c * 0.3, false), 0.8, 0.16, gold);
  } else { // bindu
    add(lrPolygonPath(c, c, c * 0.62, 72, 0), 1, 0.28);
    add(lrPolygonPath(c, c, c * 0.44, 72, 0), 0.8, 0.18, gold);
    els.push(<circle key="b" cx={c} cy={c} r={5} fill={stroke} opacity={0.5} />);
  }

  return (
    <svg
      width={S} height={S} viewBox={`0 0 ${S} ${S}`}
      style={{
        position: 'absolute', left: '50%', top: '50%',
        transform: `translate(-50%,-50%) rotate(${atmo.rotation}deg)`,
        opacity: opacity == null ? 1 : opacity,
        pointerEvents: 'none',
        animation: spin ? `lrSpin${(spinDir || 1) > 0 ? 'CW' : 'CCW'} ${140 + (atmo.hue.h % 60)}s linear infinite` : 'none',
        transformOrigin: 'center',
      }}
    >
      {els}
    </svg>
  );
}

/** Depth overlay — vignette + faint grain, tinted to the day. */
function LrDepth({ atmo }) {
  return (
    <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', zIndex: 5 }}>
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 78% 82% at 50% 46%, transparent 52%, rgba(4,1,3,0.55) 100%)`,
      }} />
      <div style={{
        position: 'absolute', inset: 0, opacity: 0.22, mixBlendMode: 'overlay',
        backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2'/%3E%3C/filter%3E%3Crect width='120' height='120' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E")`,
      }} />
    </div>
  );
}

// ─── Element motes ────────────────────────────────────────────────────────────

function LrMotes({ atmo, count, animate }) {
  const n = count || 14;
  const mode = atmo.element;
  const animName = { fire: 'lrRise', air: 'lrDrift', water: 'lrFall', earth: 'lrStill', ether: 'lrTwinkle', light: 'lrTwinkle' }[mode] || 'lrTwinkle';
  const motes = [];
  for (let i = 0; i < n; i++) {
    const seed = (i * 733 + 97) % 1000 / 1000;
    const seed2 = (i * 397 + 211) % 1000 / 1000;
    const sz = 1.5 + seed * 2.2;
    motes.push(
      <div key={i} style={{
        position: 'absolute',
        left: `${4 + seed * 92}%`,
        top: `${6 + seed2 * 88}%`,
        width: sz, height: sz, borderRadius: '50%',
        background: i % 3 === 0 ? LR_BASE.gold : atmo.accentBright,
        opacity: 0.20 + seed2 * 0.35,
        animation: animate ? `${animName} ${9 + seed * 14}s ${-seed2 * 20}s ease-in-out infinite` : 'none',
        pointerEvents: 'none',
      }} />
    );
  }
  return <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>{motes}</div>;
}

// ─── Moon glyph ───────────────────────────────────────────────────────────────

function LrMoonGlyph({ frac, size }) {
  const S = size || 20;
  const r = S / 2 - 1;
  // Illumination: 0 new → 0.5 full → 1 new
  const ill = (1 - Math.cos(frac * 2 * Math.PI)) / 2;
  const waxing = frac < 0.5;
  const k = (ill - 0.5) * 2; // -1..1
  const rx = Math.abs(k) * r;
  const cx = S / 2, cy = S / 2;
  const sweepOuter = waxing ? 1 : 0;
  const sweepInner = (k > 0 ? (waxing ? 1 : 0) : (waxing ? 0 : 1));
  const d = `M ${cx} ${cy - r} A ${r} ${r} 0 0 ${sweepOuter} ${cx} ${cy + r} A ${rx} ${r} 0 0 ${sweepInner} ${cx} ${cy - r} Z`;
  return (
    <svg width={S} height={S} viewBox={`0 0 ${S} ${S}`} style={{ display: 'block' }}>
      <circle cx={cx} cy={cy} r={r} fill="none" stroke="rgba(242,232,217,0.30)" strokeWidth="0.8" />
      <path d={d} fill="rgba(242,232,217,0.82)" />
    </svg>
  );
}

// ─── Shared atoms ─────────────────────────────────────────────────────────────

const LR_SERIF = "'Cormorant Garamond', Georgia, serif";
const LR_SAFE_TOP = 54;   // clearance below the iOS status bar / Dynamic Island

// ─── Embodiment — the return loop ─────────────────────────────────────────────
// She deepens as she is felt: mapped → exploring → active → embodied. Readiness
// is sensed from the count of felt-moments; crossing is chosen (press-and-hold).
const LR_STATUS = [
  { key: 'mapped',    label: 'Mapped' },
  { key: 'exploring', label: 'Exploring' },
  { key: 'active',    label: 'Active' },
  { key: 'embodied',  label: 'Embodied' },
];
const LR_STATUS_THRESH = [0, 1, 3, 7];   // count needed to be READY for index i

function lrReachedIndex(count) {
  let i = 0;
  for (let k = 0; k < LR_STATUS.length; k++) if (count >= LR_STATUS_THRESH[k]) i = k;
  return i;
}
function lrCrossLevel(kp) {
  try { return parseInt(localStorage.getItem('lr_cross_' + kp) || '0', 10) || 0; }
  catch (e) { return 0; }
}
function lrSetCrossLevel(kp, lvl) {
  try { localStorage.setItem('lr_cross_' + kp, String(lvl)); } catch (e) {}
}

// Moon-phase name for a moment's timestamp (for Her Moments).
function lrMoonName(ts) {
  const frac = ((( ts - Date.UTC(2000,0,6,18,14)) / 86400000 / 29.530588853) % 1 + 1) % 1;
  if (frac < 0.03 || frac > 0.97) return 'new moon';
  if (frac < 0.22) return 'waxing crescent';
  if (frac < 0.28) return 'first quarter';
  if (frac < 0.47) return 'waxing gibbous';
  if (frac < 0.53) return 'full moon';
  if (frac < 0.72) return 'waning gibbous';
  if (frac < 0.78) return 'last quarter';
  return 'waning crescent';
}

function LrLabel({ children, color, size, tracking, style }) {
  return (
    <div style={{
      fontFamily: 'ui-sans-serif, -apple-system, sans-serif',
      fontSize: size || 12,
      letterSpacing: tracking || '0.22em',
      textTransform: 'uppercase',
      color: color || 'rgba(242,232,217,0.55)',
      ...style,
    }}>{children}</div>
  );
}

function LrHairline({ width, color, style }) {
  return <div style={{ width: width || 48, height: 1, background: color || 'rgba(201,150,63,0.45)', ...style }} />;
}

function LrClusterDot({ color, size }) {
  const s = size || 9;
  return <div style={{ width: s, height: s, borderRadius: '50%', background: color, boxShadow: `0 0 ${s}px ${color}` }} />;
}

Object.assign(window, {
  LR_ALL, LR_AVARANA_BY_RING, LR_ORDINALS, LR_BASE, LR_SERIF, LR_SAFE_TOP,
  LR_STATUS, LR_STATUS_THRESH, lrReachedIndex, lrCrossLevel, lrSetCrossLevel, lrMoonName,
  lrAtmosphere, lrTodaysShakti, lrPracticeDayIndex, lrMoon, LR_RECOG,
  lrTimeVariant, lrApplyTime, LR_TIME_VARIANTS,
  lrNameSize, lrQuality, lrPrompt, lrElement, lrComposition, lrBackdrop, lrPlayBija, lrRingChime,
  LrSigil, LrMotes, LrMoonGlyph, LrLabel, LrHairline, LrClusterDot, LrDepth,
});
