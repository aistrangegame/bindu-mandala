// homes-descent.js — going deeper, as travel.
//
// The old Rite had a descent that the Axis lost in the fold. It returns here as
// what it should always have been: not a screen and not a sheet of facts, but
// the same inward movement continued. You do not leave her room — you keep going.
//
// Five stations, each ONE field of her card rendered as motion, drawn in her
// āvaraṇa's gem light. Self-paced: a touch carries you the next stretch.

import * as THREE from 'three';
import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';

const TAU = Math.PI * 2;
export const STATION_Z = [-16, -34, -52, -70, -88];

export function buildDescent(card, G) {
  const g = new THREE.Group();
  g.name = 'descent';
  const col = G.c;

  // the shaft: her seat repeating inward, so the falling is legible
  const rungs = [];
  for (let i = 0; i < 46; i++) {
    const r = 5.4 * Math.pow(0.985, i);
    const l = loop(Array.from({ length: 32 }, (_, k) => {
      const a = (k / 32) * TAU;
      return [Math.cos(a) * r, Math.sin(a) * r];
    }), 0, col, 0.2);
    l.position.z = -8 - i * 2.2;
    rungs.push(l); g.add(l);
  }

  const stations = [];

  // 1 · her tattva — the element modifier, as one turning solid
  {
    const s = new THREE.Group();
    const core = new THREE.Mesh(
      new THREE.TorusKnotGeometry(1.5, 0.34, 128, 16, 2, 3),
      new THREE.MeshStandardMaterial({
        color: col, roughness: 0.32, metalness: 0.18,
        emissive: new THREE.Color(col), emissiveIntensity: 1.8,
      })
    );
    core.material.name = 'tattva';
    s.add(core);
    s.add(sprite(glow('d1', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 9, 0.3));
    s.userData = { spin: core };
    stations.push(s);
  }

  // 2 · her bodily location — the body as horizontal registers, hers alight
  {
    const s = new THREE.Group();
    const bars = [];
    for (let i = 0; i < 13; i++) {
      const w = 3.4 - Math.abs(i - 6) * 0.16;
      const m = new THREE.Mesh(
        new THREE.BoxGeometry(w, 0.055, 0.055),
        new THREE.MeshBasicMaterial({ color: col, transparent: true, opacity: 0.2, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
      );
      m.position.y = 4.4 - i * 0.74;
      bars.push(m); s.add(m);
    }
    s.userData = { bars };
    stations.push(s);
  }

  // 3 · her etymology — the roots orbiting inward until they are one word
  {
    const s = new THREE.Group();
    const n = Math.max(2, Math.min(4, (card.roots || []).length));
    const marks = [];
    for (let i = 0; i < n; i++) {
      const grp = new THREE.Group();
      grp.add(sprite(glow('d3', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 2.2, 0.7));
      grp.userData = { a: (i / n) * TAU };
      marks.push(grp); s.add(grp);
    }
    s.add(sprite(glow('d3c', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 1.4, 0));
    s.userData = { marks, one: s.children[s.children.length - 1] };
    stations.push(s);
  }

  // 4 · her quality — one form, turning, saying nothing else
  {
    const s = new THREE.Group();
    const m = new THREE.Mesh(
      new THREE.IcosahedronGeometry(2.1, 1),
      new THREE.MeshStandardMaterial({
        color: col, roughness: 0.5, metalness: 0.1, flatShading: true,
        emissive: new THREE.Color(col), emissiveIntensity: 1.2,
      })
    );
    m.material.name = 'quality';
    s.add(m);
    s.userData = { spin: m };
    stations.push(s);
  }

  // 5 · her phrase — the inscription, and the floor of the descent
  {
    const s = new THREE.Group();
    for (let i = 0; i < 3; i++) {
      const r = new THREE.Mesh(
        new THREE.TorusGeometry(2.4 + i * 1.1, 0.02, 8, 72),
        new THREE.MeshBasicMaterial({ color: col, transparent: true, opacity: 0.34 - i * 0.08, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
      );
      r.rotation.x = Math.PI / 2 + i * 0.06;
      s.add(r);
    }
    s.add(sprite(glow('d5', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 3.4, 0.6));
    stations.push(s);
  }

  stations.forEach((s, i) => { s.position.z = STATION_Z[i]; s.name = 'station-' + i; g.add(s); });

  const key = new THREE.PointLight(col, 900, 70, 2);
  key.position.set(0, 0, -20); g.add(key);
  g.add(new THREE.AmbientLight(col, 0.9));
  const dust = motes(160, { x: 12, y: 12, z: 96 }, col, 0.1);
  dust.position.z = -48; g.add(dust);

  const WORDS = [
    card.tattva,
    card.loc,
    (card.roots || []).join(' + '),
    card.quality,
    card.phrase,
  ];

  return {
    group: g, stations: STATION_Z.length, words: WORDS,
    // `at` is the station you have reached (0..4), `p` the travel within it
    update(t, at, p) {
      const depth = STATION_Z[Math.min(at, 4)] * (p == null ? 1 : p) || 0;
      rungs.forEach((l, i) => {
        // the shaft breathes past you
        const near = 1 - clamp01(Math.abs(l.position.z - depth) / 34);
        l.material.opacity = 0.05 + near * 0.34;
      });
      key.position.z = depth - 6;

      stations.forEach((s, i) => {
        const d = Math.abs(STATION_Z[i] - depth);
        const near = 1 - clamp01(d / 22);
        s.visible = near > 0.02;
        if (!near) return;
        const u = s.userData;
        if (u.spin) {
          u.spin.rotation.set(t * 0.13 + i, t * 0.09, 0);
          u.spin.material.emissiveIntensity = (i === 0 ? 1.8 : 1.2) * (0.4 + near);
        }
        if (u.bars) {
          u.bars.forEach((b, k) => {
            const mine = Math.round(6 + (0.5 - 0.5) * 6);
            const breath = 0.5 + 0.5 * Math.sin(t * 0.22 + k * 0.4);
            b.material.opacity = (0.08 + 0.16 * breath) * near;
            b.scale.x = 1 + 0.06 * breath;
          });
        }
        if (u.marks) {
          const draw = clamp01((t % 14) / 14);
          u.marks.forEach((m, k) => {
            const rad = 3.4 * (1 - draw);
            const a = m.userData.a + t * 0.12;
            m.position.set(Math.cos(a) * rad, Math.sin(a) * rad, 0);
            m.children[0].material.opacity = 0.5 * near * (1 - draw * 0.6);
          });
          if (u.one) u.one.material.opacity = Math.pow(draw, 3) * 0.9 * near;
        }
      });
      driftMotes(dust, t, 0.5);
    },
  };
}
