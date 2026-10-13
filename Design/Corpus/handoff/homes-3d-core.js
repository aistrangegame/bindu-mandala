// homes-3d-core.js — shared instrument for every home. Nothing here decides
// what a room IS; it only supplies light, dust and geometry primitives.

import * as THREE from 'three';

export const clamp01 = (t) => (t < 0 ? 0 : t > 1 ? 1 : t);
export const smooth = (t) => { t = clamp01(t); return t * t * (3 - 2 * t); };

// A soft radial sprite. Stands in for bloom (no postprocessing in the pinned set).
export function glowTexture(inner = 'rgba(255,255,255,1)', outer = 'rgba(255,255,255,0)') {
  const c = document.createElement('canvas');
  c.width = c.height = 128;
  const ctx = c.getContext('2d');
  const g = ctx.createRadialGradient(64, 64, 0, 64, 64, 64);
  g.addColorStop(0, inner);
  g.addColorStop(0.32, inner.replace(/[\d.]+\)$/, '0.55)'));
  g.addColorStop(1, outer);
  ctx.fillStyle = g; ctx.fillRect(0, 0, 128, 128);
  const t = new THREE.CanvasTexture(c);
  t.colorSpace = THREE.SRGBColorSpace;
  return t;
}
const GLOW = {};
export const glow = (key, inner, outer) => (GLOW[key] || (GLOW[key] = glowTexture(inner, outer)));

export function sprite(tex, color, size, opacity = 1, blending = THREE.AdditiveBlending) {
  const s = new THREE.Sprite(new THREE.SpriteMaterial({
    map: tex, color, transparent: true, opacity, blending, depthWrite: false, fog: false,
  }));
  s.scale.setScalar(size);
  return s;
}

// Dust suspended in the light. Real motes, not a texture.
export function motes(count, spread, color, size) {
  const pos = new Float32Array(count * 3);
  const seed = new Float32Array(count);
  for (let i = 0; i < count; i++) {
    pos[i * 3] = (Math.random() - 0.5) * spread.x;
    pos[i * 3 + 1] = (Math.random() - 0.5) * spread.y;
    pos[i * 3 + 2] = (Math.random() - 0.5) * spread.z;
    seed[i] = Math.random() * Math.PI * 2;
  }
  const geo = new THREE.BufferGeometry();
  geo.setAttribute('position', new THREE.BufferAttribute(pos, 3));
  const mat = new THREE.PointsMaterial({
    color, size, map: glow('m', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'),
    transparent: true, opacity: 0.85, depthWrite: false,
    blending: THREE.AdditiveBlending, sizeAttenuation: true, fog: false,
  });
  const p = new THREE.Points(geo, mat);
  p.userData = { seed, base: pos.slice(), count };
  p.name = 'motes';
  return p;
}

export function driftMotes(p, t, amp = 0.5, fall = 0) {
  const a = p.geometry.attributes.position, { seed, base, count } = p.userData;
  for (let i = 0; i < count; i++) {
    a.array[i * 3 + 1] = base[i * 3 + 1] + Math.sin(t * 0.14 + seed[i]) * amp - fall * t * 0.06;
    a.array[i * 3] = base[i * 3] + Math.cos(t * 0.09 + seed[i]) * amp * 0.5;
  }
  a.needsUpdate = true;
}

// A line loop from 2D points, on a plane at depth z.
export function loop(pts, z, color, opacity = 1, blending = THREE.AdditiveBlending) {
  const g = new THREE.BufferGeometry().setFromPoints(pts.map((p) => new THREE.Vector3(p[0], p[1], z)));
  return new THREE.LineLoop(g, new THREE.LineBasicMaterial({
    color, transparent: true, opacity, blending, depthWrite: false,
  }));
}
