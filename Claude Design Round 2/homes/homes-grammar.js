// homes-grammar.js — the mechanism grammar. Her ring gives the archetype; her
// own card fields tune it. This is how 58 seats become 58 rooms with a RULE,
// rather than 58 hand-builds — and how the room could never belong to anyone else.
//
//   ring 3 · the Anaṅgas   → BODILESS   effect with no source
//   ring 4 · Sampradāya    → COSMIC     one gesture at the scale of worlds
//   ring 5 · Kulottīrṇa    → GIVING     something arrives, from beyond
//   ring 6 · Nigarbha      → REVEALING  it was already here; the veil thins
//   ring 7 · Vāsinīs       → SOUNDING   the room is made of her syllable
//   ring 8 · the Triad     → SOURCING   will, act, form at the origin
//   ring 9 · the Bindu     → its own room, authored
//
// Her tattva sets the physics; her body-location sets the altitude; her position
// sets the phase, so no two neighbours move alike.

import * as THREE from 'three';
import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';
import { bodyAltitude, R1_FAMILY, SYLLABLE, CROSSED } from './homes-cards.js?v=5';

const HOLD_END = 227, SECOND = 120;
// Her quality, spoken in the room's own voice. Derived from her card, so no two
// siblings ever read alike — the uniqueness test applied to language.
const low = (q) => String(q || '').toLowerCase();
const deep = (t) => smooth((t - HOLD_END) / SECOND);
const TAU = Math.PI * 2;

// Her tattva, read for physics. Not decoration — it decides how things move.
//
// An audit found 78 of 102 falling through to one generic motion: the classifier
// knew a dozen words and the cards speak a whole vocabulary. It now reads the
// five elements, the three powers, the senses, and the recurring principles, so
// a room's motion comes from HER tattva rather than from a default.
const PHYSICS = [
  [/stambha|paralyz|cosmic stillness/, 'arrest'],
  [/vik[āa]sa|jṛmbha|yawn|expansion/, 'expand'],
  [/mahat|vastness/, 'widen'],
  [/aṇu|atomic|smallness/, 'shrink'],
  [/dravat|liquef|melting|fluid/, 'flow'],
  [/apaḥ|\bjala\b|water/, 'well'],
  [/pṛthiv|pṛthv|bh[ūu]mi|earth|weighted/, 'settle'],
  [/tejas|agni|\bfire\b|fierce/, 'flare'],
  [/v[āa]yu|\bair\b|lightness/, 'lift'],
  [/[āa]k[āa][śs]a|\bkhe\b|ether|sky|void|freedom/, 'open'],
  [/kṣobha|agitat|stir/, 'stir'],
  [/[āa]karṣaṇa|karṣaṇa|magnet|attract/, 'draw'],
  [/moha|bewilder|unm[āa]da|intoxicat|\bmada\b/, 'waver'],
  [/advaita|non-dual/, 'merge'],
  [/vega|veloc|impulse|lightning|kriy[āa]/, 'dart'],
  [/p[āa][śs]a|\bbind\b|mekhal|embrace|encircl|rakṣa|protect/, 'encircle'],
  [/aṅku[śs]a|goad|hook|direct/, 'point'],
  [/virah|longing|separation/, 'reach'],
  [/rekh|outline|suggest/, 'trace'],
  [/pralaya|kṣaya|\blaya\b|vin[āa][śs]|dissolution|liberation/, 'dissolve'],
  [/p[ūu]rṇa|sampat|abundance|fullness|wholeness/, 'fill'],
  [/b[īi]ja|seed|potential/, 'compress'],
  [/yoni|source|bhaga/, 'spring'],
  [/sthiti|sustenance|preserv/, 'sustain'],
  [/v[āa]c|[śs]abda|mantra|speech|sound/, 'sound'],
  [/jñ[āa]na|buddhi|sarvajñ|knowing|knowledge|insight/, 'clarify'],
  [/ahaṅk[āa]ra|\bego\b|i-mak/, 'assert'],
  [/[śs]rotra|tvak|cakṣus|jihv|ghr[āa]ṇa|indriya|sense|touch|taste|scent|form\b/, 'lean'],
  [/[āa]nanda|bliss|joy|āhl[āa]da/, 'swell'],
  [/[āa]dh[āa]ra|support|foundation/, 'ground'],
  [/icch|saṅkalpa|\bwill\b|willing/, 'incline'],
  [/siddhi|phala|pr[āa]pti|attain|fulfil|accomplish/, 'arrive'],
  [/saundarya|sundarat|puṣpa|beauty|adornment/, 'bloom'],
  [/smṛti|smaraṇa|memory|recollect/, 'recur'],
  [/n[āa]ma|\bname\b/, 'call'],
  [/[āa]tm|\bself\b|witness/, 'turn'],
  [/amṛta|deathless|immortal|upastha/, 'persist'],
  [/[śs]ar[īi]ra|\bmanas\b|\bbody\b/, 'land'],
  [/dhairya|courage|steadi|fortitude/, 'stand'],
  [/citta|mind-sub/, 'rest'],
  [/\bkula\b|lineage/, 'thread'],
  [/[īi][śs]vara|ai[śs]varya|sovereign|lordship/, 'rise'],
  [/saṃyama|integrat|va[śs]ya|yield/, 'align'],
  [/maṅgala|auspicious/, 'brighten'],
  [/duḥkha|p[āa]pa|sorrow|error|obstacle|vighna/, 'unbind'],
  [/[āa]rogya|healing|whole/, 'mend'],
  [/rañjana|colour|color|aesthetic/, 'tint'],
  [/tri-eka|three-as-one|trinity/, 'converge'],
  [/para-bindu|totality|source-beauty/, 'centre'],
  [/[śs]akti|s[āa]marthya|power|capacity/, 'surge'],
];
function physics(card) {
  const s = ((card.tattva || '') + ' ' + (card.quality || '')).toLowerCase();
  for (const [re, kind] of PHYSICS) if (re.test(s)) return kind;
  return 'breathe';
}

// how her physics moves a thing, in her own phase
function displace(kind, t, phase, amp) {
  const p = phase * TAU;
  const s = (f) => Math.sin(t * f + p), c = (f) => Math.cos(t * f + p);
  const pulse = (f) => Math.abs(Math.sin(t * f + p));
  switch (kind) {
    case 'arrest': return [0, 0, 0];
    case 'expand': return [0, s(0.09) * amp * 1.6, 0];
    case 'widen': return [s(0.06) * amp * 2.2, 0, c(0.06) * amp * 2.2];
    case 'shrink': return [s(0.14) * amp * 0.2, 0, pulse(0.1) * -amp * 1.4];
    case 'flow': return [s(0.21) * amp, s(0.13) * amp * 0.5, 0];
    case 'well': return [0, pulse(0.11) * amp * 1.5, 0];
    case 'settle': return [0, -pulse(0.07) * amp * 1.3, 0];
    case 'flare': return [s(0.6) * amp * 0.4, pulse(0.5) * amp * 0.9, 0];
    case 'lift': return [s(0.12) * amp * 0.4, (0.5 + 0.5 * s(0.1)) * amp * 1.7, 0];
    case 'open': return [s(0.05) * amp * 1.8, c(0.04) * amp * 1.2, s(0.045) * amp * 1.8];
    case 'stir': return [c(0.42) * amp, s(0.51) * amp * 0.4, s(0.33) * amp];
    case 'draw': return [0, 0, s(0.11) * amp * 1.4];
    case 'waver': return [s(0.16) * amp * 1.3, s(0.09) * amp * 0.6, 0];
    case 'merge': return [-s(0.08) * amp * 0.3, 0, 0];
    case 'dart': return [s(0.9) * amp * 0.5, 0, s(1.3) * amp * 0.4];
    case 'encircle': return [c(0.24) * amp, 0, s(0.24) * amp];
    case 'point': return [0, 0, -pulse(0.17) * amp];
    case 'reach': return [0, pulse(0.13) * amp * 1.2, -pulse(0.13) * amp];
    case 'trace': return [s(0.19) * amp * 1.5, c(0.19) * amp * 0.7, 0];
    case 'dissolve': return [s(0.3) * amp * 0.6, -pulse(0.09) * amp * 0.8, c(0.27) * amp * 0.6];
    case 'fill': return [0, (0.5 + 0.5 * s(0.055)) * amp * 1.4, 0];
    case 'compress': return [s(0.2) * amp * 0.15, 0, -pulse(0.06) * amp * 0.5];
    case 'spring': return [0, pulse(0.16) * amp * 1.8, -pulse(0.16) * amp * 0.5];
    case 'sustain': return [0, s(0.045) * amp * 0.35, 0];
    case 'sound': return [0, s(1.6) * amp * 0.3 + s(0.2) * amp * 0.5, 0];
    case 'clarify': return [s(0.1) * amp * 0.25, 0, -(0.5 + 0.5 * s(0.08)) * amp];
    case 'assert': return [0, pulse(0.19) * amp * 0.9, pulse(0.19) * amp * 0.5];
    case 'lean': return [s(0.13) * amp * 1.1, 0, -pulse(0.13) * amp * 0.7];
    case 'swell': return [s(0.07) * amp * 0.8, (0.5 + 0.5 * c(0.07)) * amp, s(0.07) * amp * 0.8];
    case 'ground': return [0, -amp * 0.5 - pulse(0.04) * amp * 0.3, 0];
    case 'incline': return [s(0.1) * amp * 0.5, s(0.1) * amp * 0.4, -pulse(0.1) * amp * 0.9];
    case 'arrive': return [0, 0, -amp * (0.5 + 0.5 * s(0.075))];
    case 'bloom': return [c(0.09) * amp * 1.3, pulse(0.09) * amp * 0.5, s(0.09) * amp * 1.3];
    case 'recur': return [s(0.24) * amp * 0.9, 0, s(0.12) * amp * 0.9];
    case 'call': return [0, s(0.3) * amp * 0.4, -s(0.15) * amp * 1.1];
    case 'turn': return [c(0.055) * amp * 1.2, 0, s(0.055) * amp * 1.2];
    case 'persist': return [0, s(0.033) * amp * 0.5, 0];
    case 'land': return [0, -(0.5 + 0.5 * c(0.06)) * amp * 1.2, 0];
    case 'stand': return [0, s(0.03) * amp * 0.18, 0];
    case 'rest': return [s(0.04) * amp * 0.3, s(0.035) * amp * 0.2, 0];
    case 'thread': return [s(0.1) * amp * 0.6, c(0.05) * amp * 0.4, s(0.2) * amp * 0.8];
    case 'rise': return [0, (0.5 + 0.5 * s(0.05)) * amp * 1.5, 0];
    case 'align': return [s(0.12) * amp * (0.5 + 0.5 * c(0.03)), 0, 0];
    case 'brighten': return [0, s(0.11) * amp * 0.6, 0];
    case 'unbind': return [s(0.17) * amp * 1.2, pulse(0.085) * amp * 0.7, 0];
    case 'mend': return [s(0.14) * amp * 0.5, s(0.07) * amp * 0.5, s(0.21) * amp * 0.5];
    case 'tint': return [s(0.18) * amp * 0.9, c(0.14) * amp * 0.9, 0];
    case 'converge': return [c(0.1) * amp * (1 - pulse(0.05)), s(0.1) * amp * (1 - pulse(0.05)), 0];
    case 'centre': return [0, 0, 0];
    case 'surge': return [0, pulse(0.28) * amp * 1.3, 0];
    default: return [0, s(0.14) * amp * 0.7, 0];
  }
}

const wallMat = (ink) => {
  const m = new THREE.MeshStandardMaterial({ color: ink, roughness: 0.9, metalness: 0.05, side: THREE.BackSide });
  m.name = 'dhatu'; return m;
};

// ══ RING 3 · BODILESS — you feel it, and there is nothing there to feel ═════
// Her effect is fully present; her cause is empty. The room's light comes from a
// point that visibly holds nothing.
function bodiless(world, card, G) {
  const g = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 8) / 8;
  const y = (0.5 - alt) * 9;

  const shell = new THREE.Mesh(new THREE.SphereGeometry(15, 40, 28), wallMat(G.ink));
  g.add(shell);

  // the effect: petals of her ring, moved by her physics, orbiting nothing
  const petals = [];
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * TAU;
    const p = new THREE.Group();
    p.add(sprite(glow('bl' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 4.2, 0.8));
    p.position.set(Math.cos(a) * 5.4, y, Math.sin(a) * 5.4 - 3);
    p.userData = { a, base: p.position.clone() };
    petals.push(p); g.add(p);
  }
  // and the absence at the centre — a rim of light around nothing
  const rim = new THREE.Mesh(
    new THREE.TorusGeometry(1.5, 0.02, 8, 64),
    new THREE.MeshBasicMaterial({ color: G.c, transparent: true, opacity: 0.5, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
  );
  rim.position.set(0, y, -6.5); g.add(rim);

  const key = new THREE.PointLight(G.c, 2200, 46, 2); key.position.set(0, y, -6.5); g.add(key);
  const wash = new THREE.PointLight(G.c, 500, 30, 2); wash.position.set(0, y + 2, 3); g.add(wash);
  g.add(new THREE.AmbientLight(G.c, 2.2));
  const dust = motes(90, { x: 14, y: 12, z: 18 }, G.c, 0.1); g.add(dust);

  const out = {
    group: g, label: `${low(card.quality)} · and nothing there to feel`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      petals.forEach((p, i) => {
        const d = displace(kind, t, ph + i / 8, 2.6);
        p.position.set(p.userData.base.x + d[0], p.userData.base.y + d[1], p.userData.base.z + d[2]);
        p.children[0].material.opacity = (0.42 + 0.5 * k) * (1 - b * 0.4);
        p.scale.setScalar(1 + b * 1.6);
      });
      rim.material.opacity = (0.3 + 0.3 * k) * (1 - b);
      rim.rotation.z = t * 0.05;
      key.intensity = 1400 + 1100 * k;
      // the second adaptation: the effect is the whole room; there was never a centre
      shell.material.transparent = b > 0.01;
      shell.material.opacity = 1 - b * 0.8;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'the effect was the only body' : `${low(card.quality)} · and nothing there to feel`;
    },
  };
  return out;
}

// ══ RING 4 · COSMIC — her one gesture, at the scale of worlds ══════════════
// The same movement repeated outward through fourteen shells until it is weather.
function cosmic(world, card, G) {
  const g = new THREE.Group();
  const grp0 = g;
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 14) / 14;
  const y = (0.5 - alt) * 8;

  const shells = [];
  for (let i = 0; i < 14; i++) {
    const r = 3.4 + i * 2.1;
    const tri = loop([[0, r], [r * 0.92, -r * 0.6], [-r * 0.92, -r * 0.6]], 0, G.c, 0.5);
    tri.position.set(0, y, -2 - i * 1.5);
    tri.userData = { base: tri.position.clone(), i };
    shells.push(tri); g.add(tri);
  }
  const shell = new THREE.Mesh(new THREE.SphereGeometry(26, 32, 22), wallMat(G.ink));
  grp0.add(shell);
  const heart = new THREE.Group();
  heart.add(sprite(glow('cs' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 5, 0.8));
  heart.position.set(0, y, -3); g.add(heart);
  const key = new THREE.PointLight(G.c, 1200, 60, 2); key.position.set(0, y, -3); g.add(key);
  g.add(new THREE.AmbientLight(G.c, 0.9));
  const dust = motes(150, { x: 30, y: 22, z: 40 }, G.c, 0.12); dust.position.z = -12; g.add(dust);

  const out = {
    group: g, label: `${low(card.quality)} · at the scale of worlds`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      shells.forEach((s) => {
        const i = s.userData.i;
        // the SAME displacement, delayed outward — one movement becoming cosmic
        const d = displace(kind, t - i * 0.42, ph, 1 + i * 0.22);
        s.position.set(s.userData.base.x + d[0], s.userData.base.y + d[1], s.userData.base.z + d[2] * 0.5);
        s.rotation.z = Math.sin(t * 0.05 + i * 0.3) * 0.04 * (1 + b * 3);
        s.material.opacity = (0.14 + 0.4 * k) * (1 - i / 20) * (1 + b * 0.8);
        s.scale.setScalar(1 + b * (0.22 + i * 0.03));
      });
      heart.scale.setScalar(1 + 0.2 * Math.sin(t * 0.2) - b * 0.34);
      key.intensity = 700 + 700 * k + b * 600;
      driftMotes(dust, t, 0.6);
      out.label = b > 0.45 ? 'the gesture had no centre to leave' : `${low(card.quality)} · at the scale of worlds`;
    },
  };
  return out;
}

// ══ RING 5 · GIVING — something arrives, and it is already yours ═══════════
// Her gift travels in from beyond the room and settles into your hands.
function giving(world, card, G) {
  const g = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 10) / 10;
  const y = (0.5 - alt) * 8;

  const shell = new THREE.Mesh(new THREE.CylinderGeometry(11, 11, 22, 40, 1, true), wallMat(G.ink));
  g.add(shell);
  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(11, 48),
    new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.7, metalness: 0.2 })
  );
  floor.material.name = 'dhatu';
  floor.rotation.x = -Math.PI / 2; floor.position.y = -5.4; g.add(floor);

  // the gifts, arriving. They come from outside and cross into her room.
  const gifts = [];
  for (let i = 0; i < 12; i++) {
    const s = sprite(glow('gv' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 1.5, 0.7);
    s.userData = { phase: i / 12, a: (i / 12) * TAU };
    gifts.push(s); g.add(s);
  }
  // your hands: where they land
  const cup = new THREE.Mesh(
    new THREE.TorusGeometry(1.9, 0.03, 8, 56),
    new THREE.MeshBasicMaterial({ color: G.c, transparent: true, opacity: 0.4, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
  );
  cup.rotation.x = Math.PI / 2; cup.position.set(0, y - 1.4, -2.6); g.add(cup);

  const key = new THREE.PointLight(G.c, 800, 40, 2); key.position.set(0, y + 4, -8); g.add(key);
  g.add(new THREE.AmbientLight(G.c, 0.9));
  const dust = motes(90, { x: 16, y: 16, z: 16 }, G.c, 0.1); g.add(dust);

  const out = {
    group: g, label: `${low(card.quality)} · arriving, unasked`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      gifts.forEach((s, i) => {
        // a slow fall inward from beyond the wall to her cup
        const u = ((t * 0.055 + s.userData.phase) % 1);
        const r = 16 * (1 - u) + 1.4 * u;
        const d = displace(kind, t, ph + i / 12, 0.9);
        s.position.set(
          Math.cos(s.userData.a + u * 1.2) * r + d[0],
          y + 7 - u * 9 + d[1],
          Math.sin(s.userData.a + u * 1.2) * r - 2.6 + d[2]
        );
        s.scale.setScalar((0.9 + u * 0.9) * (1 + b));
        s.material.opacity = Math.sin(Math.PI * u) * (0.4 + 0.4 * k);
      });
      cup.material.opacity = (0.2 + 0.35 * k) * (1 - b * 0.8);
      cup.scale.setScalar(1 + b * 4.2);
      key.intensity = 500 + 500 * k;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'the giving and the given are one' : `${low(card.quality)} · arriving, unasked`;
    },
  };
  return out;
}

// ══ RING 6 · REVEALING — it was already here ═══════════════════════════════
// Nothing arrives. A veil thins, and what was always in the room becomes visible.
function revealing(world, card, G) {
  const g = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 10) / 10;
  const y = (0.5 - alt) * 8;

  // what is already here, at full strength from the first instant
  const truth = new THREE.Group();
  for (let i = 0; i < 10; i++) {
    const a = (i / 10) * TAU;
    const m = new THREE.Mesh(
      new THREE.IcosahedronGeometry(1.4, 0),
      new THREE.MeshStandardMaterial({
        color: G.c, roughness: 0.4, metalness: 0.1,
        emissive: new THREE.Color(G.c), emissiveIntensity: 3.2,
      })
    );
    m.material.name = 'already-here';
    m.position.set(Math.cos(a) * 6, y + Math.sin(i * 1.7) * 2.6, Math.sin(a) * 6 - 3);
    m.userData = { base: m.position.clone(), i };
    truth.add(m);
  }
  g.add(truth);

  // the veil: it is what you are actually looking at, and it thins
  const veil = new THREE.Mesh(
    new THREE.SphereGeometry(9.4, 36, 24),
    new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.86, metalness: 0.04, transparent: true, opacity: 0.72, side: THREE.BackSide, depthWrite: false })
  );
  veil.material.name = 'the-veil';
  g.add(veil);

  const inner = new THREE.PointLight(G.c, 1800, 34, 2); inner.position.set(0, y, -3); g.add(inner);
  g.add(new THREE.AmbientLight(G.c, 2.0));
  const dust = motes(90, { x: 14, y: 14, z: 14 }, G.c, 0.1); g.add(dust);

  const out = {
    group: g, label: `${low(card.quality)} · already here, behind the veil`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      veil.material.opacity = Math.max(0, 0.72 - k * 0.46 - b * 0.26);
      truth.children.forEach((m, i) => {
        const d = displace(kind, t, ph + i / 10, 0.8);
        m.position.set(m.userData.base.x + d[0], m.userData.base.y + d[1], m.userData.base.z + d[2]);
        m.rotation.set(t * 0.05 + i, t * 0.04, 0);
        m.material.emissiveIntensity = 3.2 + k * 1.4 + b * 2.2;
      });
      truth.scale.setScalar(1 + b * 0.5);
      inner.intensity = 1200 + 900 * k + b * 900;
      driftMotes(dust, t, 0.36);
      out.label = b > 0.45 ? 'it was never hidden · you were the veil' : `${low(card.quality)} · already here, behind the veil`;
    },
  };
  return out;
}

// ══ RING 7 · SOUNDING — the room is made of her syllable ═══════════════════
// Standing waves in her own row of the alphabet; the geometry IS the vibration.
function sounding(world, card, G, bija) {
  const g = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card);
  const y = (0.5 - alt) * 8;
  const n = 2 + (card.pos % 8);           // her row's mode number

  const u = { uTime: { value: 0 }, uMode: { value: n }, uDeep: { value: 0 }, uCol: { value: new THREE.Color(G.c) } };
  const skin = new THREE.Mesh(
    new THREE.CylinderGeometry(9, 9, 24, 128, 64, true),
    new THREE.ShaderMaterial({
      uniforms: u, side: THREE.BackSide, transparent: true, depthWrite: false,
      vertexShader: `
        uniform float uTime; uniform float uMode; uniform float uDeep;
        varying float vA; varying vec2 vUv;
        void main(){
          vUv = uv;
          vec3 p = position;
          float ang = atan(p.z, p.x);
          // a standing wave: her syllable, held in the wall
          float w = sin(ang * uMode + uTime * 0.5) * cos(p.y * 0.5 + uTime * 0.3);
          float amp = 0.5 + uDeep * 1.6;
          p.xz *= 1.0 + w * 0.05 * amp;
          vA = 0.35 + 0.65 * abs(w);
          gl_Position = projectionMatrix * modelViewMatrix * vec4(p, 1.0);
        }`,
      fragmentShader: `
        uniform vec3 uCol; uniform float uDeep;
        varying float vA; varying vec2 vUv;
        void main(){
          float band = 0.5 + 0.5 * sin(vUv.y * 90.0);
          vec3 c = mix(uCol * 0.16, mix(uCol, vec3(1.0), 0.5), vA);
          gl_FragColor = vec4(c * (0.8 + 0.2 * band), 0.6 + 0.4 * vA);
        }`,
    })
  );
  skin.material.name = 'standing-wave';
  skin.position.y = y * 0.3; g.add(skin);

  // the nodes of her wave — where the syllable is silent
  const nodes = [];
  for (let i = 0; i < n; i++) {
    const a = (i / n) * TAU;
    const s = sprite(glow('sd' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 1.8, 0.6);
    s.position.set(Math.cos(a) * 8.4, y, Math.sin(a) * 8.4);
    nodes.push(s); g.add(s);
  }
  const key = new THREE.PointLight(G.c, 700, 40, 2); key.position.set(0, y, -3); g.add(key);
  g.add(new THREE.AmbientLight(G.c, 1.0));
  const dust = motes(90, { x: 14, y: 18, z: 14 }, G.c, 0.1); g.add(dust);

  const out = {
    group: g, label: bija ? `${low(card.quality)} · ${bija}` : `${low(card.quality)} · the room is her sound`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      u.uTime.value = t; u.uDeep.value = b;
      nodes.forEach((s, i) => {
        const d = displace(kind, t, i / n, 0.7);
        s.position.y = y + d[1];
        s.material.opacity = (0.24 + 0.4 * k) * (1 - b * 0.4);
        s.scale.setScalar(1.8 * (1 + b * 1.2));
      });
      key.intensity = 400 + 400 * k;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'you are inside the syllable' : (bija ? `${low(card.quality)} · ${bija}` : `${low(card.quality)} · the room is her sound`);
    },
  };
  return out;
}

// ══ RING 8 · SOURCING — will, act, form, at the origin ═════════════════════
// One corner of the innermost triangle. Her corner is lit; the other two are
// present but dark, because the three are inseparable.
function sourcing(world, card, G) {
  const g = new THREE.Group();
  const corner = (card.pos - 99);            // 0 icchā · 1 kriyā · 2 jñāna
  const kind = physics(card);

  const R = 4.6;
  const pts = [0, 1, 2].map((i) => {
    const a = -Math.PI / 2 + (i / 3) * TAU;
    return new THREE.Vector3(Math.cos(a) * R, Math.sin(a) * R, -9.5);
  });
  const tri = new THREE.Line(
    new THREE.BufferGeometry().setFromPoints([...pts, pts[0]]),
    new THREE.LineBasicMaterial({ color: G.c, transparent: true, opacity: 0.6, blending: THREE.AdditiveBlending, depthWrite: false })
  );
  tri.name = 'innermost-triangle'; g.add(tri);

  const lamps = pts.map((p, i) => {
    const grp = new THREE.Group();
    const mine = i === corner;
    grp.add(sprite(glow('sr' + i, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), mine ? 0xffffff : G.c, mine ? 6.4 : 2.4, mine ? 0.95 : 0.2));
    grp.position.copy(p); g.add(grp);
    const l = new THREE.PointLight(mine ? 0xffffff : G.c, mine ? 900 : 90, 40, 2);
    l.position.copy(p); g.add(l);
    return { grp, l, mine, base: p.clone() };
  });

  // the bindu they ring, not yet reached
  const bindu = sprite(glow('srb', 'rgba(255,255,255,1)', 'rgba(255,246,222,0)'), 0xfff6de, 2.6, 0.4);
  bindu.position.set(0, 0, -9.5); g.add(bindu);
  // a shell, so her light has something to fall on
  const shell = new THREE.Mesh(new THREE.SphereGeometry(15, 32, 22), wallMat(G.ink));
  g.add(shell);
  g.add(new THREE.AmbientLight(G.c, 1.2));
  const dust = motes(120, { x: 20, y: 20, z: 16 }, G.c, 0.1); g.add(dust);

  const LABEL = ['will, before there is anything to will', 'the act, before there is a deed', 'form, before there is a thing'];
  const DEEP = ['will was already act and form', 'the act was already will and form', 'form was already will and act'];
  const out = {
    group: g, label: LABEL[corner] || 'at the source',
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      lamps.forEach((L, i) => {
        const d = displace(kind, t, i / 3, 0.8);
        L.grp.position.set(L.base.x + d[0], L.base.y + d[1], L.base.z + d[2]);
        L.l.position.copy(L.grp.position);
        // her corner burns; past the second adaptation the other two answer
        const other = 0.2 + b * 0.7;
        L.grp.children[0].material.opacity = L.mine ? 0.95 : other;
        L.l.intensity = L.mine ? 900 : 90 + b * 700;
      });
      tri.material.opacity = 0.3 + 0.4 * k + b * 0.3;
      tri.rotation.z = t * 0.006;
      bindu.material.opacity = 0.16 + 0.3 * k + b * 0.5;
      bindu.scale.setScalar(2.2 * (1 + b * 2.4));
      driftMotes(dust, t, 0.45);
      out.label = b > 0.45 ? (DEEP[corner] || 'the three were never apart') : (LABEL[corner] || 'at the source');
    },
  };
  return out;
}


// ══ RING 1 · SIDDHI — the room grants her capacity, and asks nothing ═══════
// A power is not demonstrated at you; it is lent. Her one capacity operates on
// the room itself while you stand in it.
function siddhi(world, card, G) {
  const grp = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 10) / 10;
  const y = (0.5 - alt) * 9;

  const shell = new THREE.Mesh(new THREE.BoxGeometry(13, 11, 30), wallMat(G.ink));
  grp.add(shell);
  const seams = new THREE.LineSegments(
    new THREE.EdgesGeometry(new THREE.BoxGeometry(13, 11, 30)),
    new THREE.LineBasicMaterial({ color: G.c, transparent: true, opacity: 0.34, blending: THREE.AdditiveBlending, depthWrite: false })
  );
  grp.add(seams);

  // the capacity, lent: a single form that does her one thing, endlessly
  const lent = new THREE.Group();
  const core = new THREE.Mesh(
    new THREE.OctahedronGeometry(1.5, 1),
    new THREE.MeshStandardMaterial({
      color: G.c, roughness: 0.34, metalness: 0.1,
      emissive: new THREE.Color(G.c), emissiveIntensity: 2.4,
    })
  );
  core.material.name = 'the-capacity';
  lent.add(core);
  lent.add(sprite(glow('sd1' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 8, 0.5));
  lent.position.set(0, y, -9); grp.add(lent);

  // and the room's answer — it does the same thing, later
  const echo = [];
  for (let i = 0; i < 6; i++) {
    const r = 2.4 + i * 1.5;
    const l = loop(Array.from({ length: 4 }, (_, k) => {
      const a = (k / 4) * TAU + Math.PI / 4;
      return [Math.cos(a) * r, Math.sin(a) * r];
    }), 0, G.c, 0.3);
    l.position.set(0, y, -9 - i * 2.4);
    l.userData = { base: l.position.clone(), i };
    echo.push(l); grp.add(l);
  }

  const key = new THREE.PointLight(G.c, 1600, 46, 2); key.position.set(0, y, -9); grp.add(key);
  const fill = new THREE.PointLight(G.c, 320, 26, 2); fill.position.set(0, y + 1.6, 2); grp.add(fill);
  grp.add(new THREE.AmbientLight(G.c, 1.4));
  const dust = motes(100, { x: 12, y: 10, z: 24 }, G.c, 0.1); grp.add(dust);

  const out = {
    group: grp, label: `${low(card.quality)} · lent, not shown`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      const d = displace(kind, t, ph, 2.2);
      lent.position.set(d[0], y + d[1], -9 + d[2]);
      core.rotation.set(t * 0.06, t * 0.09, 0);
      core.material.emissiveIntensity = 2.4 + k * 1.6 + b * 2.4;
      echo.forEach((l) => {
        const e = displace(kind, t - 0.6 - l.userData.i * 0.5, ph, 2.2);
        l.position.set(l.userData.base.x + e[0], l.userData.base.y + e[1], l.userData.base.z + e[2] * 0.4);
        l.material.opacity = (0.1 + 0.3 * k) * (1 - l.userData.i / 8) * (1 + b * 1.4);
      });
      // the second adaptation: it was never lent. It is yours, and always was.
      seams.material.opacity = (0.2 + 0.3 * k) * (1 - b * 0.8);
      shell.material.transparent = b > 0.01;
      shell.material.opacity = 1 - b * 0.7;
      lent.scale.setScalar(1 - b * 0.8);
      key.intensity = 1000 + 700 * k + b * 900;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'the capacity was never lent' : `${low(card.quality)} · lent, not shown`;
    },
  };
  return out;
}

// ══ RING 1 · MĀTṚKĀ — the Mother of a row of the alphabet ═════════════════
// Her letters stand around you, unspoken. The room is the mouth before sound.
function matrka(world, card, G, syllable) {
  const grp = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 8) / 8;
  const y = (0.5 - alt) * 9;
  const n = 5 + ((card.pos - 11) % 4) * 3;   // how many letters her row governs

  const shell = new THREE.Mesh(new THREE.SphereGeometry(14, 36, 24), wallMat(G.ink));
  grp.add(shell);
  // a floor, so her light has somewhere to fall and the room has a bottom
  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(13, 40),
    new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.6, metalness: 0.22 })
  );
  floor.material.name = 'dhatu';
  floor.rotation.x = -Math.PI / 2; floor.position.y = y - 5.4; grp.add(floor);

  // her row, ringed and waiting to be spoken
  const letters = [];
  for (let i = 0; i < n; i++) {
    const a = (i / n) * TAU;
    const m = new THREE.Mesh(
      new THREE.BoxGeometry(0.16, 1.5, 0.16),
      new THREE.MeshStandardMaterial({
        color: G.c, roughness: 0.4, metalness: 0.06,
        emissive: new THREE.Color(G.c), emissiveIntensity: 2.2,
      })
    );
    m.material.name = 'letter';
    m.position.set(Math.cos(a) * 6.4, y, Math.sin(a) * 6.4 - 2);
    m.rotation.y = -a;
    m.userData = { base: m.position.clone(), i };
    letters.push(m); grp.add(m);
  }
  // the column of voice, rising from the chest
  const column = new THREE.Mesh(
    new THREE.CylinderGeometry(0.4, 1.5, 9, 24, 1, true),
    new THREE.MeshBasicMaterial({
      color: G.c, transparent: true, opacity: 0.12, side: THREE.DoubleSide,
      blending: THREE.AdditiveBlending, depthWrite: false, fog: false,
    })
  );
  column.position.set(0, y - 1, -2); grp.add(column);

  const key = new THREE.PointLight(G.c, 1900, 40, 2); key.position.set(0, y + 1.6, -2); grp.add(key);
  grp.add(new THREE.AmbientLight(G.c, 0.7));
  const dust = motes(90, { x: 13, y: 13, z: 13 }, G.c, 0.1); grp.add(dust);

  const out = {
    group: grp, label: syllable ? `${low(card.quality)} · ${syllable}` : `${low(card.quality)} · the mouth before sound`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      letters.forEach((m) => {
        const i = m.userData.i;
        const d = displace(kind, t - i * 0.22, ph, 1.1);
        m.position.set(m.userData.base.x + d[0], m.userData.base.y + d[1], m.userData.base.z + d[2]);
        // one letter at a time comes to the point of being spoken
        const turn = (t * 0.22 + i / n) % 1;
        m.material.emissiveIntensity = 1.4 + Math.pow(Math.max(0, Math.sin(Math.PI * turn)), 8) * 5 + b * 1.8;
        m.scale.y = 1 + b * 3.4;
      });
      column.material.opacity = 0.06 + 0.12 * k + b * 0.22;
      column.scale.setScalar(1 + b * 1.1);
      key.intensity = 900 + 700 * k;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'the letters were never separate from the voice'
        : (syllable ? `${low(card.quality)} · ${syllable}` : `${low(card.quality)} · the mouth before sound`);
    },
  };
  return out;
}

// ══ RING 1 · MUDRĀ — the room IS a gesture ════════════════════════════════
// Not a room containing a seal: a seal large enough to stand inside. It performs
// its one action continuously, and you are within the performing.
function mudra(world, card, G) {
  const grp = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 10) / 10;
  const y = (0.5 - alt) * 9;

  // five fingers of the seal, as vaults you stand between
  const digits = [];
  for (let i = 0; i < 5; i++) {
    const a = -0.9 + (i / 4) * 1.8;
    const pts = [];
    for (let k = 0; k <= 10; k++) {
      const u = k / 10;
      pts.push(new THREE.Vector3(
        Math.sin(a) * (5 + u * 4),
        y - 4 + u * 9 - Math.pow(u, 2) * 3.4,
        Math.cos(a) * (5 + u * 4) - 4 - u * 2
      ));
    }
    const tube = new THREE.Mesh(
      new THREE.TubeGeometry(new THREE.CatmullRomCurve3(pts), 32, 0.34, 8, false),
      new THREE.MeshStandardMaterial({
        color: G.c, roughness: 0.52, metalness: 0.08,
        emissive: new THREE.Color(G.c), emissiveIntensity: 0.9,
      })
    );
    tube.material.name = 'digit';
    tube.userData = { i, a };
    digits.push(tube); grp.add(tube);
  }
  const shell = new THREE.Mesh(new THREE.SphereGeometry(16, 32, 22), wallMat(G.ink));
  grp.add(shell);

  // what the gesture holds — the thing it is a seal OF
  const held = new THREE.Group();
  held.add(sprite(glow('mu' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 4.4, 0.7));
  held.position.set(0, y, -7); grp.add(held);

  const key = new THREE.PointLight(G.c, 1400, 42, 2); key.position.set(0, y, -7); grp.add(key);
  const rim = new THREE.PointLight(G.c, 400, 30, 2); rim.position.set(0, y + 3, 2); grp.add(rim);
  grp.add(new THREE.AmbientLight(G.c, 1.5));
  const dust = motes(90, { x: 14, y: 12, z: 14 }, G.c, 0.1); grp.add(dust);

  const out = {
    group: grp, label: `${low(card.quality)} · a seal you stand inside`,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      digits.forEach((d0) => {
        const i = d0.userData.i;
        const d = displace(kind, t - i * 0.3, ph, 1.4);
        d0.position.set(d[0], d[1], d[2] * 0.6);
        d0.rotation.z = Math.sin(t * 0.12 + i * 0.7) * 0.05 * (1 + b * 4);
        d0.material.emissiveIntensity = 0.7 + k * 0.8 + b * 2.2;
        // the seal opens: what it held is released
        d0.rotation.x = b * 0.42 * (1 + i * 0.1);
      });
      held.scale.setScalar(1 + 0.14 * Math.sin(t * 0.2) + b * 3.6);
      held.children[0].material.opacity = 0.5 + 0.3 * k - b * 0.2;
      key.intensity = 900 + 600 * k + b * 700;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'the seal has opened its hand' : `${low(card.quality)} · a seal you stand inside`;
    },
  };
  return out;
}

// ══ RING 2 · CROSSED — she draws one faculty and is given another organ ════
// The home ring's real design. Rūpa (form) carries Śrotra (the ear); Rasa
// (taste) carries Tvak (skin); Śarīra (body) carries Manas (mind) — marked in
// the base as THE KEY PAIRING. So: the room PRESENTS one sense and ANSWERS in
// the other, and the two halves are not aligned until the second adaptation.
function crossed(world, card, G, syllable, cross) {
  const grp = new THREE.Group();
  const kind = physics(card), alt = bodyAltitude(card), ph = (card.pos % 16) / 16;
  const y = (0.5 - alt) * 9;
  const isKey = card.pos === 44;

  // a petal of the sixteen, from inside
  const petal = new THREE.Mesh(
    new THREE.SphereGeometry(11, 36, 24, 0, TAU, 0.2, 2.2),
    wallMat(G.ink)
  );
  grp.add(petal);

  // THE PRESENTING half — what she draws. Near, formed, addressed to you.
  const presents = new THREE.Group();
  for (let i = 0; i < 7; i++) {
    const a = -0.8 + (i / 6) * 1.6;
    const m = new THREE.Mesh(
      new THREE.TorusGeometry(0.7 + i * 0.16, 0.028, 6, 40),
      new THREE.MeshBasicMaterial({ color: G.c, transparent: true, opacity: 0.5, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
    );
    m.position.set(Math.sin(a) * 2.6, y + 0.6, -5 + Math.cos(a) * 0.6);
    m.rotation.y = a;
    m.userData = { i, base: m.position.clone() };
    presents.add(m);
  }
  grp.add(presents);

  // THE ANSWERING half — the organ she was given. Offset, other, in counterpoint.
  const answers = new THREE.Group();
  for (let i = 0; i < 7; i++) {
    const s = sprite(glow('cx' + world.n, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 1.4, 0.4);
    const a = -0.8 + (i / 6) * 1.6;
    s.position.set(Math.sin(a) * 3.4, y - 0.8, -6.4 + Math.cos(a) * 0.8);
    s.userData = { i, base: s.position.clone() };
    answers.add(s);
  }
  grp.add(answers);

  const key = new THREE.PointLight(G.c, 1500, 44, 2); key.position.set(0, y, -7); grp.add(key);
  const counter = new THREE.PointLight(G.c, 500, 26, 2); counter.position.set(0, y - 2, -1); grp.add(counter);
  grp.add(new THREE.AmbientLight(G.c, 1.5));
  const dust = motes(100, { x: 12, y: 12, z: 16 }, G.c, 0.1); grp.add(dust);

  const near = cross ? cross[0] : low(card.quality);
  const far = cross ? cross[1] : 'her own organ';
  const shallowLab = cross
    ? `${near}, answered in ${far}`
    : `${low(card.quality)} · drawn toward the centre`;
  const deepLab = isKey
    ? 'body and mind were one point'
    : (cross ? `the ${near} and the ${far} were one sense` : 'the drawing and the drawn are one');

  const out = {
    group: grp, label: shallowLab,
    update(t) {
      const b = deep(t), k = smooth(t / 62);
      // the two halves run the same physics in OPPOSITE phase — that is the crossing
      presents.children.forEach((m) => {
        const d = displace(kind, t, ph + m.userData.i / 14, 1.2);
        m.position.set(m.userData.base.x + d[0], m.userData.base.y + d[1], m.userData.base.z + d[2] * 0.5);
        m.material.opacity = (0.26 + 0.34 * k) * (1 - b * 0.3);
      });
      answers.children.forEach((s) => {
        const d = displace(kind, t + 3.2, ph + 0.5 + s.userData.i / 14, 1.2);
        // they converge as the second adaptation arrives
        const pull = b;
        const tgt = presents.children[s.userData.i].position;
        s.position.set(
          s.userData.base.x * (1 - pull) + tgt.x * pull + d[0] * (1 - pull),
          s.userData.base.y * (1 - pull) + tgt.y * pull + d[1] * (1 - pull),
          s.userData.base.z * (1 - pull) + tgt.z * pull + d[2] * 0.5 * (1 - pull)
        );
        s.material.opacity = (0.24 + 0.34 * k) * (1 + b * 0.8);
        s.scale.setScalar(1.4 * (1 + b * (isKey ? 2.6 : 1.2)));
      });
      key.intensity = 900 + 700 * k + b * (isKey ? 1400 : 500);
      counter.intensity = 300 + 300 * k;
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? deepLab : shallowLab;
    },
  };
  return out;
}

export const FAMILY = { 3: bodiless, 4: cosmic, 5: giving, 6: revealing, 7: sounding, 8: sourcing };

export function buildFromCard(world, card, G, bija) {
  // Ring 1 has three families; Ring 2 turns on the crossing.
  if (card.ring === 1) {
    const fam = R1_FAMILY(card.pos);
    if (fam === 'siddhi') return siddhi(world, card, G);
    if (fam === 'matrka') return matrka(world, card, G, SYLLABLE[card.pos]);
    return mudra(world, card, G);
  }
  if (card.ring === 2) return crossed(world, card, G, SYLLABLE[card.pos], CROSSED[card.pos]);
  const fn = FAMILY[card.ring];
  return fn ? fn(world, card, G, bija) : null;
}
