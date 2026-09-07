// homes-chambers.js — a chamber is her mechanism, CONDITIONED BY HER WORLD.
// The same mechanism in a different āvaraṇa is a different room, because the
// gem is the light and the dhātu is the material. Eight authored mechanisms;
// her seat's interior is the floor every un-authored Śakti inherits.

import * as THREE from 'three';
import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';
import { CARDS, BIJA as CARD_BIJA, findCard } from './homes-cards.js?v=5';
import { buildAttribute } from './homes-attribute.js?v=1';
import { buildFromCard } from './homes-grammar.js?v=8';

// each āvaraṇa's gem, as light
// ── HER LIGHT, EXACTLY AS THE APP DERIVES IT ─────────────────────────────
// A verbatim port of Atmosphere.swift. Every number here is the repo's, not a
// design choice: ringHue, clusterHue, the ±7° per-Śakti jitter keyed off her
// khaḍgamālā position, and the 20% ground blend. Ring 2 seeds from her CLUSTER,
// never from a ring hue — sisters of a cluster share a light as well as a corridor.
//
// The gem's own word ("pearl — milky, diffuse, sourceless") is kept, but only as
// the light's BEHAVIOUR: how diffuse it is, how far it falls. Hue, saturation and
// lightness belong to the app.
const RING_HSL = {
  1: [35, 58, 54], 2: [43, 78, 52], 3: [341, 45, 58], 4: [353, 55, 48],
  5: [18, 62, 55], 6: [194, 42, 46], 7: [322, 38, 50], 8: [2, 68, 50], 9: [46, 72, 66],
};
const CLUSTER_HSL = {
  inner: [43, 78, 52], tanmatra: [13, 47, 56], citta: [180, 49, 32],
  stability: [140, 24, 38], selfBody: [270, 26, 48],
};
// the gem as behaviour only
const GEM_BEHAVIOUR = {
  1: { diffuse: 0.20, name: 'Topaz' }, 2: { diffuse: 0.30, name: 'Sapphire' },
  3: { diffuse: 0.45, name: 'Coral' }, 4: { diffuse: 0.15, name: 'Diamond' },
  5: { diffuse: 0.25, name: 'Emerald' }, 6: { diffuse: 0.55, name: 'Ruby' },
  7: { diffuse: 0.95, name: 'Pearl' }, 8: { diffuse: 0.10, name: "Cat's eye" },
  9: { diffuse: 0.70, name: 'All gems' },
};
const wrapHue = (h) => ((h % 360) + 360) % 360;
const clampN = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
// Atmosphere.jitter — deterministic per Śakti, stable across launches
export function atmosphereJitter(kp, range) {
  const frac = ((((kp * 2654435761) % 1000) + 1000) % 1000) / 1000;
  return (frac - 0.5) * range;
}
function hslHex(h, s, l) {
  const c = new THREE.Color();
  c.setHSL(wrapHue(h) / 360, clampN(s, 0, 100) / 100, clampN(l, 0, 100) / 100);
  return c.getHex();
}
// Ring 2's cluster, by khaḍgamālā position — the same five the app uses
function clusterKey(pos) {
  if (pos < 29 || pos > 44) return null;
  if (pos <= 31) return 'inner';
  if (pos <= 36) return 'tanmatra';
  if (pos === 37) return 'citta';
  if (pos <= 41) return 'stability';
  return 'selfBody';
}

// Her light. Pass her khaḍgamālā position for the jitter and the cluster seed —
// omit it and you get her ring's unjittered seed, which is the world shown empty.
export function gemFor(ring, kp) {
  const ck = kp != null ? clusterKey(kp) : null;
  const seed = (ring === 2 && ck) ? CLUSTER_HSL[ck] : RING_HSL[ring] || RING_HSL[2];
  const h = kp != null ? wrapHue(seed[0] + atmosphereJitter(kp, 14)) : seed[0];
  const beh = GEM_BEHAVIOUR[ring] || GEM_BEHAVIOUR[2];
  return {
    c: hslHex(h, seed[1], seed[2]),
    ink: hslHex(h, seed[1] * 0.55, 12),
    bright: hslHex(h, Math.min(seed[1] + 10, 88), Math.min(seed[2] + 18, 78)),
    hue: h, sat: seed[1] / 100, light: seed[2],
    diffuse: beh.diffuse, gem: beh.name, cluster: ck,
  };
}

// the nine worlds shown empty — no Śakti in them yet
export const GEM = {};
for (let r = 1; r <= 9; r++) GEM[r] = gemFor(r);

// the seat's plan, per ring — you stand inside her actual seat in the yantra
// Her clock: the first adaptation, a long hold, then the second — which only a
// returning practitioner ever reaches. The second adaptation is never "more of
// the same": in every room it REVERSES the room's own premise.
const HOLD_END = 227, SECOND = 120;
const deep = (t) => smooth((t - HOLD_END) / SECOND);

const SEAT = { 1: 'square', 2: 'petal', 3: 'petal', 4: 'tri', 5: 'tri', 6: 'tri', 7: 'tri', 8: 'tri', 9: 'circle' };

function seatShape(kind) {
  if (kind === 'square') return [[-1, -1], [1, -1], [1, 1], [-1, 1]];
  if (kind === 'tri') return [[0, 1], [0.95, -0.62], [-0.95, -0.62]];
  if (kind === 'petal') {
    const P = [];
    for (let i = 0; i <= 12; i++) { const t = i / 12; P.push([Math.pow(Math.sin(Math.PI * t), 1.4) * 0.62, -Math.cos(Math.PI * t)]); }
    for (let i = 11; i > 0; i--) { const t = i / 12; P.push([-Math.pow(Math.sin(Math.PI * t), 1.4) * 0.62, -Math.cos(Math.PI * t)]); }
    return P;
  }
  return Array.from({ length: 30 }, (_, i) => {
    const a = (i / 30) * Math.PI * 2; return [Math.cos(a), Math.sin(a)];
  });
}

// A shell whose cross-section is her seat, extruded away from you.
function seatShell(ring, r = 6, depth = 26, mat) {
  const pts = seatShape(SEAT[ring] || 'square').map(([x, y]) => new THREE.Vector2(x * r, y * r));
  const shape = new THREE.Shape(pts);
  const geo = new THREE.ExtrudeGeometry(shape, { depth, bevelEnabled: false, steps: 1 });
  geo.translate(0, 0, -depth * 0.62);
  const m = new THREE.Mesh(geo, mat);
  m.name = 'seat-shell';
  return m;
}

const gemLight = (ring, i, dist = 40) => new THREE.PointLight(GEM[ring].c, i, dist, 2);

// ── the aperture: hers alone, on the far wall ───────────────────────────────
function aperture(ring, kind, scale = 1) {
  const g = new THREE.Group(); g.name = 'aperture';
  const col = GEM[ring].c;
  const core = new THREE.Mesh(new THREE.SphereGeometry(0.16 * scale, 20, 14), new THREE.MeshBasicMaterial({ color: 0xffffff }));
  g.add(core);
  g.add(sprite(glow('ap' + ring, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 4.4 * scale, 0.9));
  g.add(sprite(glow('ap2' + ring, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 13 * scale, 0.28));
  if (kind === 'tri-down') {
    const s = new THREE.Shape(); s.moveTo(-2.2, 1.4); s.lineTo(2.2, 1.4); s.lineTo(0, -2.4); s.closePath();
    const m = new THREE.Mesh(new THREE.ShapeGeometry(s), new THREE.MeshBasicMaterial({ color: 0xfff2e4, transparent: true, opacity: 0.8, side: THREE.DoubleSide, fog: false }));
    m.name = 'womb-seal'; g.add(m);
  } else if (kind === 'triad') {
    for (let i = 0; i < 3; i++) {
      const a = (i / 3) * Math.PI * 2 - Math.PI / 2;
      const d = new THREE.Mesh(new THREE.SphereGeometry(0.42, 16, 12), new THREE.MeshBasicMaterial({ color: 0xffffff }));
      d.position.set(Math.cos(a) * 1.5, Math.sin(a) * 1.5, 0);
      d.name = 'seal-' + i; g.add(d);
    }
  }
  return g;
}

// ══ DEFAULT · her seat's interior, lit by her world's gem ═══════════════════
function chamberSeat(world, shakti) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const mat = new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.9, metalness: 0.05, side: THREE.BackSide });
  mat.name = 'dhatu';
  g.add(seatShell(ring, 6.4, 28, mat));
  const ap = aperture(ring, 'point'); ap.position.z = -15.6; g.add(ap);
  const key = gemLight(ring, 1500, 52); key.position.set(0, 0, -15); g.add(key);
  const fill = gemLight(ring, 260, 30); fill.position.set(0, 1.2, -3); g.add(fill);
  g.add(new THREE.AmbientLight(G.c, 1.1));
  const dust = motes(90, { x: 10, y: 10, z: 22 }, G.c, 0.11); g.add(dust);
  const seams = new THREE.LineSegments(
    new THREE.EdgesGeometry(seatShell(ring, 6.4, 28, mat).geometry),
    new THREE.LineBasicMaterial({ color: G.c, transparent: true, opacity: 0.3, blending: THREE.AdditiveBlending, depthWrite: false })
  );
  seams.name = 'seams'; g.add(seams);
  return {
    group: g, label: 'her seat, from inside',
    update(t) {
      const a = smooth(t / 62);
      key.intensity = 700 + 1500 * a;
      seams.material.opacity = 0.16 + 0.34 * a;
      ap.scale.setScalar(0.6 + 0.6 * a);
      driftMotes(dust, t, 0.4);
    },
  };
}

// ══ CONTRACT · Aṇimā ════════════════════════════════════════════════════════
function chamberContract(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const shell = new THREE.Group();
  const mat = new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.92, metalness: 0.04, side: THREE.BackSide });
  mat.name = 'dhatu';
  shell.add(seatShell(ring, 6.4, 26, mat));
  const edge = new THREE.LineSegments(
    new THREE.EdgesGeometry(seatShell(ring, 6.4, 26, mat).geometry),
    new THREE.LineBasicMaterial({ color: G.c, transparent: true, opacity: 0.36, blending: THREE.AdditiveBlending, depthWrite: false })
  );
  shell.add(edge);
  const ap = aperture(ring, 'point'); ap.position.z = -14.5; shell.add(ap);
  const key = gemLight(ring, 900, 46); key.position.set(0, 0, -14); shell.add(key);
  g.add(shell);
  g.add(new THREE.AmbientLight(G.c, 0.45));
  const dust = motes(110, { x: 9, y: 9, z: 20 }, G.c, 0.1); g.add(dust);
  const beyond = new THREE.Group();
  beyond.add(sprite(glow('cb1', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 30, 0));
  beyond.add(sprite(glow('cb2' + ring, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 72, 0));
  beyond.position.z = -18; beyond.name = 'the-beyond'; g.add(beyond);
  const out = {
    group: g, label: 'the walls close while you stand still',
    update(t) {
      const b = deep(t);
      const k = 0.34 + 0.66 * (1 - smooth(t / 62));
      shell.scale.set(k, k, 1 - (1 - k) * 0.4);
      ap.scale.setScalar((0.5 + 0.5 / k) * (1 + b * 11));
      key.intensity = 900 / (k * k);
      edge.material.opacity = (0.2 + 0.4 * (1 - k)) * (1 - b);
      mat.transparent = b > 0.01; mat.opacity = 1 - b * 0.94;
      dust.scale.set(k, k, 1);
      driftMotes(dust, t, 0.4);
      // she grants entry into any place however confined — so the point widens,
      // and what you took for the far wall is the way through.
      beyond.children[0].material.opacity = b * 0.9;
      beyond.children[1].material.opacity = b * 0.45;
      beyond.position.z = -18 + b * 13;
      out.label = b > 0.45 ? 'the point was a door all along' : 'the walls close while you stand still';
    },
  };
  return out;
}

// ══ ENDLESS · Mahimā ═══════════════════════════════════════════════════════
function chamberEndless(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const SPAN = 120, N = 24, frames = [];
  const pts = seatShape(SEAT[ring] || 'square');
  for (let i = 0; i < N; i++) {
    const r = 6 + i * 0.52;
    const l = loop(pts.map(([x, y]) => [x * r, y * r]), 0, G.c, 0.95);
    l.position.z = -SPAN + (i / N) * SPAN;
    frames.push(l); g.add(l);
  }
  g.add(new THREE.AmbientLight(G.c, 1.4));
  const haze = sprite(glow('mz' + ring, 'rgba(255,255,255,1)', 'rgba(0,0,0,0)'), G.c, 60, 0.16);
  haze.position.z = -58; g.add(haze);
  const near = gemLight(ring, 900, 46); near.position.set(0, 0, -14); g.add(near);
  const dust = motes(140, { x: 20, y: 20, z: 100 }, G.c, 0.12); dust.position.z = -44; g.add(dust);
  const behind = [];
  for (let i = 0; i < 10; i++) {
    const r = 6 + i * 0.52;
    const l = loop(pts.map(([x, y]) => [x * r, y * r]), 0, G.c, 0);
    l.position.z = 6 + (i / 10) * 60;
    behind.push(l); g.add(l);
  }
  const out = {
    group: g, label: 'no far wall · it never arrives',
    update(t) {
      const flow = t * 3.4, b = deep(t);
      frames.forEach((f, i) => {
        const z = ((-SPAN + (i / N) * SPAN + flow) % SPAN + SPAN) % SPAN - SPAN + 6;
        f.position.z = z;
        f.material.opacity = Math.sin(Math.PI * clamp01((z + SPAN) / SPAN)) * 0.95 + 0.06;
      });
      // there was no near wall either. They continue behind you.
      behind.forEach((f, i) => {
        const z = 6 + (((i / 10) * 60 + flow) % 60);
        f.position.z = z;
        f.material.opacity = b * Math.sin(Math.PI * clamp01(1 - (z - 6) / 60)) * 0.75;
      });
      driftMotes(dust, t, 0.7);
      out.label = b > 0.45 ? 'you were never inside anything' : 'no far wall · it never arrives';
    },
  };
  return out;
}

// ══ RELEASE · Laghimā ══════════════════════════════════════════════════════
function chamberRelease(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const c = new THREE.Color(G.c);
  const u = { uTime: { value: 0 }, uLift: { value: 0 }, uCol: { value: c } };
  const mat = new THREE.ShaderMaterial({
    uniforms: u, transparent: true, side: THREE.DoubleSide, depthWrite: false,
    vertexShader: `
      uniform float uTime; uniform float uLift;
      varying vec2 vUv; varying float vHem;
      void main(){
        vUv = uv; vec3 p = position;
        float hem = smoothstep(0.62, 0.0, uv.y); vHem = hem;
        p.y += hem * (uLift * 2.4 + sin(uTime * 0.42 + p.x * 0.55) * 0.42 * hem);
        p.z += hem * sin(uTime * 0.31 + p.x * 0.42 + uv.y * 3.0) * 0.34;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(p, 1.0);
      }`,
    fragmentShader: `
      uniform vec3 uCol; uniform float uLift;
      varying vec2 vUv; varying float vHem;
      void main(){
        float fade = smoothstep(0.0, 0.34, vUv.y);
        float grad = pow(vUv.y, 1.4);
        vec3 col = mix(uCol * 0.05, mix(uCol, vec3(1.0), 0.3), grad) * (0.94 + 0.06 * sin(vUv.y * 240.0));
        // the walls are cloth, not light — the brightness in this room is overhead
        gl_FragColor = vec4(col * 0.52, fade * 0.78 * (1.0 - vHem * 0.45 * uLift));
      }`,
  });
  mat.name = 'released-cloth';
  const geo = new THREE.PlaneGeometry(26, 13, 26, 40);
  [[0, -13, 0], [0, 13, Math.PI], [-13, 0, Math.PI / 2], [13, 0, -Math.PI / 2]].forEach(([x, z, ry]) => {
    const m = new THREE.Mesh(geo, mat); m.position.set(x, 1.4, z); m.rotation.y = ry; g.add(m);
  });
  const lid = new THREE.Mesh(new THREE.RingGeometry(2, 12.4, 40, 1),
    new THREE.MeshBasicMaterial({ color: G.c, transparent: true, opacity: 0.18, side: THREE.DoubleSide, depthWrite: false, fog: false }));
  lid.rotation.x = -Math.PI / 2; lid.position.y = 8.4; g.add(lid);
  const sky = sprite(glow('lg' + ring, 'rgba(255,255,255,1)', 'rgba(0,0,0,0)'), G.c, 16, 0.32);
  sky.position.y = 8.4; g.add(sky);
  // the ground it has let go of, far below — so there is a dark to rise from
  const gone = new THREE.Mesh(
    new THREE.CircleGeometry(16, 36),
    new THREE.MeshBasicMaterial({ color: 0x000000, transparent: true, opacity: 0.55, side: THREE.DoubleSide, depthWrite: false })
  );
  gone.name = 'the-released-ground';
  gone.rotation.x = -Math.PI / 2; gone.position.y = -9.5; g.add(gone);
  const above = new THREE.DirectionalLight(G.c, 3.0); above.position.set(0.5, 12, 1.5); g.add(above);
  g.add(new THREE.AmbientLight(G.c, 0.5));

  const N = 340, SPAN = 24;
  const rg = new THREE.BufferGeometry();
  const rp = new Float32Array(N * 3), rs = new Float32Array(N), rz = new Float32Array(N);
  for (let i = 0; i < N; i++) {
    // never inside the eye: the field begins a little way out
    const a = Math.random() * Math.PI * 2, rad = 4 + Math.random() * 14;
    rp[i * 3] = Math.cos(a) * rad; rp[i * 3 + 1] = (Math.random() - 0.5) * SPAN;
    rp[i * 3 + 2] = Math.sin(a) * rad; rs[i] = Math.random() * 6.28; rz[i] = 1.4 + Math.random() * 3.4;
  }
  rg.setAttribute('position', new THREE.BufferAttribute(rp, 3));
  rg.setAttribute('aSeed', new THREE.BufferAttribute(rs, 1));
  rg.setAttribute('aSize', new THREE.BufferAttribute(rz, 1));
  const ru = { uTime: { value: 0 }, uSpan: { value: SPAN }, uLift: { value: 0 }, uCol: { value: c } };
  const field = new THREE.Points(rg, new THREE.ShaderMaterial({
    uniforms: ru, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending,
    vertexShader: `
      attribute float aSeed; attribute float aSize;
      uniform float uTime; uniform float uSpan; uniform float uLift; varying float vA;
      void main(){
        vec3 p = position;
        p.y = mod(p.y + uTime * (0.34 + uLift * 1.5) + aSeed * 0.9 + uSpan * 0.5, uSpan) - uSpan * 0.5;
        p.x += sin(uTime * 0.24 + aSeed * 7.0) * 0.5;
        vA = 0.4 + 0.6 * smoothstep(uSpan * 0.5, 0.0, abs(p.y));
        vec4 mv = modelViewMatrix * vec4(p, 1.0);
        // clamped: additive motes at arm's length otherwise stack to pure white
        gl_PointSize = clamp(aSize * (90.0 / max(0.001, -mv.z)), 1.0, 9.0);
        gl_Position = projectionMatrix * mv;
      }`,
    fragmentShader: `
      uniform vec3 uCol; varying float vA;
      void main(){
        float d = length(gl_PointCoord - vec2(0.5));
        gl_FragColor = vec4(mix(uCol, vec3(1.0), 0.5), smoothstep(0.5, 0.02, d) * vA * 0.3);
      }`,
  }));
  field.name = 'nothing-falls'; g.add(field);
  const hangs = g.children.filter((c) => c.isMesh && c.material === mat);
  const out = {
    group: g, label: 'the floor has let go',
    update(t) {
      const lift = smooth(t / 62), b = deep(t);
      u.uTime.value = t; u.uLift.value = lift;
      ru.uTime.value = t; ru.uLift.value = lift;
      // nothing in this room falls — including the room.
      hangs.forEach((w, i) => { w.position.y = 1.4 + b * (15 + i * 2.4); w.rotation.x = -b * 0.17; });
      // as the walls go, the opening they were hanging from takes the whole room
      lid.position.y = 8.4 - b * 5.4;
      lid.material.opacity = 0.18 + lift * 0.2 + b * 0.3;
      lid.scale.setScalar(1 + b * 1.5);
      sky.position.y = 8.4 - b * 7.4;
      sky.scale.setScalar(16 + lift * 8 + b * 30);
      sky.material.opacity = 0.32 + b * 0.34;
      above.intensity = 3.0 + b * 3.4;
      gone.material.opacity = 0.55 * (1 - b);
      out.label = b > 0.45 ? 'the room has let go of itself' : 'the floor has let go';
    },
  };
  return out;
}

// ══ KNOWN · Vaśitā ═════════════════════════════════════════════════════════
function chamberKnown(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const stone = new THREE.MeshStandardMaterial({ color: 0x9c8ad0, roughness: 0.8, metalness: 0.06, side: THREE.BackSide });
  stone.name = 'known-stone';
  const room = new THREE.Mesh(new THREE.BoxGeometry(16, 10, 30), stone);
  room.receiveShadow = true; g.add(room);
  const pil = new THREE.MeshStandardMaterial({ color: 0xb2a0e0, roughness: 0.62, metalness: 0.1 });
  pil.name = 'pillar-stone';
  for (let i = 0; i < 6; i++) {
    const p = new THREE.Mesh(new THREE.CylinderGeometry(0.42, 0.5, 10, 20), pil);
    p.position.set(i % 2 ? 5.6 : -5.6, 0, -3 - Math.floor(i / 2) * 7);
    p.castShadow = true; p.receiveShadow = true; g.add(p);
  }
  const seat = new THREE.Mesh(new THREE.CylinderGeometry(1.9, 2.3, 0.5, 32), pil);
  seat.position.set(0, -4.7, -11); seat.castShadow = true; g.add(seat);
  const ring2 = new THREE.Mesh(new THREE.TorusGeometry(1.5, 0.035, 8, 48),
    new THREE.MeshBasicMaterial({ color: 0xe4d8ff, transparent: true, opacity: 0.7, blending: THREE.AdditiveBlending, depthWrite: false }));
  ring2.position.set(0, -4.4, -11); ring2.rotation.x = Math.PI / 2; g.add(ring2);
  const pool = new THREE.SpotLight(0xd8caff, 2400, 44, 0.4, 0.88, 1.55);
  pool.position.set(0, 3.2, -4); pool.target.position.set(0, -3.4, -11);
  pool.castShadow = true; pool.shadow.mapSize.set(1024, 1024);
  pool.shadow.camera.near = 0.6; pool.shadow.camera.far = 40;
  g.add(pool); g.add(pool.target);
  const halo = sprite(glow('v' + ring, 'rgba(205,187,239,1)', 'rgba(0,0,0,0)'), 0x9a86c4, 14, 0.14); g.add(halo);
  g.add(new THREE.AmbientLight(0x2e2650, 2.4));
  const dust = motes(100, { x: 14, y: 9, z: 26 }, 0xd6c8ff, 0.11); dust.position.z = -8; g.add(dust);
  const out = {
    group: g, label: 'the room exists only where attention rests',
    update(t) {
      const b = deep(t);
      const wx = Math.sin(t * 0.16) * 5.2 + Math.sin(t * 0.058) * 1.8;
      const wz = -11 + Math.cos(t * 0.125) * 5.4;
      const wy = -2.4 + Math.sin(t * 0.093) * 2.1;
      // mastery is not holding attention. It is being found by it.
      const x = wx * (1 - b), y = wy * (1 - b) - b * 0.4, z = wz * (1 - b) + b * 0.8;
      pool.target.position.set(x, y, z);
      pool.position.set(x * 0.42 * (1 - b), 3.2 - b * 2.4, z + 5.2 - b * 9.8);
      pool.angle = 0.4 - b * 0.17;
      pool.intensity = 2400 * (1 + b * 0.7);
      halo.position.set(x, y + 0.9, z + b * 1.6);
      halo.scale.setScalar(14 + b * 10);
      ring2.material.opacity = (0.28 + 0.5 * Math.max(0, 1 - Math.hypot(wx, wz + 11) / 7)) * (1 - b * 0.72);
      driftMotes(dust, t, 0.4);
      out.label = b > 0.45 ? 'it has turned, and it rests on you' : 'the room exists only where attention rests';
    },
  };
  return out;
}

// ══ MEMBRANE · Sarva-Yoni ══════════════════════════════════════════════════
function chamberMembrane(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const prof = [];
  for (let i = 0; i <= 36; i++) {
    const u = i / 36;
    prof.push(new THREE.Vector2(Math.max(0.06, 7.6 * Math.pow(Math.sin(Math.PI * (0.10 + 0.82 * u)), 0.82)), -9 + 18.4 * u));
  }
  const mat = new THREE.MeshPhysicalMaterial({
    color: 0xd4795c, roughness: 0.42, metalness: 0, transmission: 0.94, thickness: 3.4, ior: 1.38,
    attenuationColor: new THREE.Color(0x8c2e1e), attenuationDistance: 2.6,
    sheen: 0.7, sheenColor: new THREE.Color(0xffc9a8), sheenRoughness: 0.6,
    clearcoat: 0.34, clearcoatRoughness: 0.5, side: THREE.DoubleSide,
  });
  mat.name = 'membrane';
  const vessel = new THREE.Mesh(new THREE.LatheGeometry(prof, 64), mat); g.add(vessel);
  const veins = new THREE.Group();
  for (let i = 0; i < 8; i++) {
    const a0 = (i / 8) * Math.PI * 2, p = [];
    for (let k = 0; k <= 10; k++) {
      const u = k / 10;
      const r = 7.2 * Math.pow(Math.sin(Math.PI * (0.12 + 0.78 * (1 - u))), 0.82) * 0.94;
      const a = a0 + Math.sin(u * 3.1 + i) * 0.16;
      p.push(new THREE.Vector3(Math.cos(a) * r, 8.4 - 17 * u, Math.sin(a) * r));
    }
    veins.add(new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(p), 34, 0.04, 6, false),
      new THREE.MeshBasicMaterial({ color: 0xffb894, transparent: true, opacity: 0.4, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })));
  }
  g.add(veins);
  const ap = aperture(ring, 'tri-down'); ap.position.set(0, -3.4, -5.4); g.add(ap);
  const lamps = [[0, 6, -13, 540], [-12, 1, -6, 420], [12, 1, -6, 420], [0, -8, -11, 320], [0, 3, 13, 250]].map(([x, y, z, p]) => {
    const l = new THREE.PointLight(0xffb08a, p, 48, 2); l.position.set(x, y, z); g.add(l); return l;
  });
  const inner = new THREE.PointLight(0xffd9bc, 130, 20, 2); inner.position.set(0, -2.4, -3.4); g.add(inner);
  g.add(new THREE.AmbientLight(0x4a1a14, 1.6));
  const dust = motes(80, { x: 11, y: 14, z: 11 }, 0xffe8d4, 0.11); g.add(dust);
  // vessels beyond the vessel — dormant until the second adaptation
  const NEST = [1.55, 2.3, 3.2];
  const nested = NEST.map((sc, i) => {
    const m = new THREE.Mesh(new THREE.LatheGeometry(prof, 40), new THREE.MeshBasicMaterial({
      color: 0xffb894, transparent: true, opacity: 0, side: THREE.DoubleSide,
      depthWrite: false, blending: THREE.AdditiveBlending, fog: false,
    }));
    m.name = 'vessel-beyond-' + i; m.scale.setScalar(sc); g.add(m); return m;
  });
  const out = {
    group: g, label: 'no door · you were always inside',
    update(t) {
      const br = Math.sin(t * 0.28), k = smooth(t / 62), b = deep(t);
      vessel.scale.set(1 + br * 0.032, 1 - br * 0.02, 1 + br * 0.032);
      veins.scale.copy(vessel.scale);
      mat.thickness = (3.4 + br * 0.7) * (1 - b * 0.72);
      mat.attenuationDistance = 2.6 + br * 0.35 + b * 5.4;
      ap.scale.setScalar(0.7 + 0.4 * k + b * 0.5);
      lamps.forEach((l, i) => { l.intensity = [540, 420, 420, 320, 250][i] * (0.62 + 0.5 * k) * (1 + b * 0.5); });
      veins.children.forEach((v, i) => { v.material.opacity = (0.16 + 0.34 * k * (0.7 + 0.3 * Math.sin(t * 0.3 + i))) * (1 - b * 0.5); });
      // the membrane clears, and she is inside a source of her own.
      // It was never one womb.
      nested.forEach((m, i) => {
        m.material.opacity = clamp01(b * 2 - i * 0.5) * (0.12 - i * 0.024);
        m.scale.setScalar(NEST[i] * (1 + br * 0.02));
      });
      driftMotes(dust, t, 0.36);
      out.label = b > 0.45 ? 'source within source · it was never one womb' : 'no door · you were always inside';
    },
  };
  return out;
}

// ══ TRIPLE · Sarva-Trikhaṇḍā ═══════════════════════════════════════════════
// Three rooms in one place. In the axis this is done as three tinted shells that
// slide into register, so it stays single-pass and the travel never cuts.
function chamberTriple(world) {
  const ring = world.n;
  const g = new THREE.Group();
  const pts = seatShape(SEAT[ring] || 'square');
  const tints = [0xff5a52, 0x4fe0a8, 0x6f8fe0];
  const ghosts = tints.map((c) => {
    const gh = new THREE.Group();
    for (let k = 0; k < 5; k++) {
      const r = 6.4, z = -3 - k * 5.4;
      gh.add(loop(pts.map(([x, y]) => [x * r, y * r]), z, c, 0.5));
    }
    [[-1, 0], [1, 0], [0, -1], [0, 1]].forEach(([x, y]) => {
      const geo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(x * 6.4, y * 6.4, 2), new THREE.Vector3(x * 6.4, y * 6.4, -25),
      ]);
      gh.add(new THREE.Line(geo, new THREE.LineBasicMaterial({ color: c, transparent: true, opacity: 0.42, blending: THREE.AdditiveBlending, depthWrite: false })));
    });
    const seal = new THREE.Mesh(new THREE.SphereGeometry(0.4, 16, 12), new THREE.MeshBasicMaterial({ color: c, transparent: true, opacity: 0.85, blending: THREE.AdditiveBlending }));
    seal.position.z = -24; gh.add(seal);
    g.add(gh); return gh;
  });
  const one = sprite(glow('tk' + ring, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 3, 0);
  one.position.z = -24; g.add(one);
  g.add(new THREE.AmbientLight(0xb0b0d0, 0.8));
  const out = {
    group: g, label: 'three rooms · one seal, only in stillness',
    update(t) {
      const b = deep(t);
      // the trinity is one MOVEMENT, not a puzzle that resolves. Past the second
      // adaptation the seal stops arriving and begins to breathe.
      const settled = 1 - smooth(t / 62);
      const breath = (0.5 + 0.5 * Math.sin((t - HOLD_END) * 0.085)) * 0.58;
      const sep = settled * (1 - b) + breath * b;
      const off = [[-1, -0.42], [1, -0.22], [0.08, 1]];
      ghosts.forEach((gh, i) => {
        gh.position.set(off[i][0] * sep * 1.5, off[i][1] * sep * 1.4, 0);
        gh.rotation.z = off[i][0] * sep * 0.035;
        gh.children.forEach((ch) => { if (ch.material) ch.material.opacity = 0.28 + sep * 0.36; });
      });
      one.material.opacity = (1 - sep) * 0.95 + b * 0.3;
      one.scale.setScalar(3 + (1 - sep) * 5 + b * 2);
      out.label = b > 0.45 ? 'three and one, and always both' : 'three rooms · one seal, only in stillness';
    },
  };
  return out;
}

// ══ DISSOLVE · Mahātripurasundarī ══════════════════════════════════════════
function chamberDissolve() {
  const g = new THREE.Group();
  const GOLD = 0xfff2cf;
  const yantra = new THREE.Group();
  const sq = (r) => [[-r, -r], [r, -r], [r, r], [-r, r]];
  [[13, 0], [11.6, -0.9], [10.2, -1.8]].forEach(([r, z], i) => yantra.add(loop(sq(r), z, GOLD, 0.3 - i * 0.06)));
  const circle = (r, n) => Array.from({ length: n }, (_, i) => { const a = (i / n) * Math.PI * 2; return [Math.cos(a) * r, Math.sin(a) * r]; });
  [[9, 56, -2.6], [8.1, 56, -3.1]].forEach(([r, n, z]) => yantra.add(loop(circle(r, n), z, GOLD, 0.34)));
  const petalRing = (count, rIn, rOut, z, w) => {
    const grp = new THREE.Group();
    for (let i = 0; i < count; i++) {
      const a = (i / count) * Math.PI * 2, p = [];
      for (let k = 0; k <= 14; k++) {
        const u = k / 14, sp = Math.pow(Math.sin(Math.PI * u), 1.4) * w, rr = rIn + (rOut - rIn) * u;
        p.push([Math.cos(a) * rr - Math.sin(a) * sp, Math.sin(a) * rr + Math.cos(a) * sp]);
      }
      for (let k = 13; k > 0; k--) {
        const u = k / 14, sp = Math.pow(Math.sin(Math.PI * u), 1.4) * w, rr = rIn + (rOut - rIn) * u;
        p.push([Math.cos(a) * rr + Math.sin(a) * sp, Math.sin(a) * rr - Math.cos(a) * sp]);
      }
      grp.add(loop(p, z, GOLD, 0.3));
    }
    return grp;
  };
  yantra.add(petalRing(16, 6.4, 8.9, -3.6, 0.62));
  yantra.add(petalRing(8, 4.9, 6.3, -4.4, 0.78));
  const tris = new THREE.Group();
  [[5.5, -2.2], [4.4, -1.7], [3.4, -1.3], [2.3, -0.85]].forEach(([ay, base], i) =>
    tris.add(loop([[0, ay], [ay * 0.92, base], [-ay * 0.92, base]], -5 - i * 0.55, GOLD, 0.46)));
  [[5.5, -2.2], [4.7, -1.9], [3.9, -1.55], [3.0, -1.2], [1.9, -0.75]].forEach(([ay, base], i) =>
    tris.add(loop([[0, -ay], [ay * 0.92, -base], [-ay * 0.92, -base]], -5.3 - i * 0.55, GOLD, 0.46)));
  yantra.add(tris); g.add(yantra);
  const bindu = new THREE.Group();
  bindu.add(sprite(glow('b1', 'rgba(255,255,255,1)', 'rgba(201,150,63,0)'), 0xfff6de, 7.5, 0.95));
  bindu.add(sprite(glow('b2', 'rgba(255,246,222,1)', 'rgba(120,80,20,0)'), 0xffe9b8, 22, 0.3));
  bindu.add(new THREE.Mesh(new THREE.SphereGeometry(0.2, 20, 14), new THREE.MeshBasicMaterial({ color: 0xffffff })));
  bindu.position.z = -8.4; g.add(bindu);
  g.add(new THREE.AmbientLight(0xfff0d0, 0.5));
  const dust = motes(180, { x: 26, y: 26, z: 26 }, 0xfff6de, 0.1); dust.position.z = -6; g.add(dust);
  const out = {
    group: g, label: 'there was never anyone here but Her',
    update(t) {
      const b = deep(t), br = Math.sin(t * 0.115);
      // the whole yantra turns inside out: the point is not ahead of you.
      yantra.scale.setScalar((0.94 + 0.07 * br) * (1 + b * 2.1));
      yantra.position.z = b * 7.4;
      yantra.rotation.z = t * 0.0075;
      tris.rotation.z = -t * 0.014;
      bindu.position.z = -8.4 + b * 8.4;
      bindu.scale.setScalar((0.85 + 0.2 * Math.sin(t * 0.19)) * (1 + b * 2.8));
      bindu.children.forEach((c, i) => {
        if (i < 2 && c.material) c.material.opacity = [0.95, 0.3][i] * (1 - b * 0.55);
      });
      driftMotes(dust, t, 0.55 + b * 0.8);
      out.label = b > 0.45 ? 'the bindu is where you are standing' : 'there was never anyone here but Her';
    },
  };
  return out;
}

// ══ PRESS · Garimā ═════════════════════════════════════════════════════════
// Her ceiling descends the whole time you are in it and the floor thickens into
// strata beneath you. The brief's own paired example against Laghimā: one room
// must lift and the other must press.
function strataTexture() {
  const c = document.createElement('canvas');
  c.width = 32; c.height = 512;
  const x = c.getContext('2d');
  x.fillStyle = '#000'; x.fillRect(0, 0, 32, 512);
  let y = 0, v = 30;
  while (y < 512) {
    const h = 5 + Math.random() * 22;
    v = Math.max(14, Math.min(232, v + (Math.random() - 0.42) * 90));
    const grd = x.createLinearGradient(0, y, 0, y + h);
    grd.addColorStop(0, `rgb(${v},${v},${v})`);
    grd.addColorStop(1, `rgb(${Math.round(v * 0.55)},${Math.round(v * 0.55)},${Math.round(v * 0.55)})`);
    x.fillStyle = grd; x.fillRect(0, y, 32, h);
    y += h;
  }
  const t = new THREE.CanvasTexture(c);
  t.wrapS = t.wrapT = THREE.RepeatWrapping;
  t.repeat.set(3, 3);
  return t;
}

function chamberPress(world) {
  const ring = world.n, G = GEM[ring];
  const g = new THREE.Group();
  const strata = strataTexture();
  const groundMat = new THREE.MeshStandardMaterial({
    color: G.ink, roughness: 0.95, metalness: 0.05,
    displacementMap: strata, displacementScale: 0.5, displacementBias: -0.2,
    bumpMap: strata, bumpScale: 0.9,
  });
  groundMat.name = 'strata';
  const ground = new THREE.Mesh(new THREE.PlaneGeometry(46, 46, 180, 180), groundMat);
  ground.name = 'thickening-ground';
  ground.rotation.x = -Math.PI / 2; ground.position.y = -5.2;
  ground.receiveShadow = true; g.add(ground);

  const slabMat = new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.98, metalness: 0.02 });
  slabMat.name = 'descending-mass';
  const slab = new THREE.Mesh(new THREE.BoxGeometry(46, 4.4, 46), slabMat);
  slab.name = 'ceiling'; slab.position.y = 11; slab.castShadow = true; g.add(slab);
  const underMat = new THREE.MeshStandardMaterial({
    color: G.ink, roughness: 0.97, metalness: 0.02,
    displacementMap: strata, displacementScale: 0.7, displacementBias: -0.35,
    bumpMap: strata, bumpScale: 1.1,
  });
  underMat.name = 'mass-relief';
  const under = new THREE.Mesh(new THREE.PlaneGeometry(46, 46, 80, 80), underMat);
  under.name = 'mass-underside'; under.rotation.x = Math.PI / 2; g.add(under);
  const rim = new THREE.Mesh(
    new THREE.BoxGeometry(46.4, 0.16, 46.4),
    new THREE.MeshBasicMaterial({ color: G.c, transparent: true, opacity: 0.5, fog: false })
  );
  rim.name = 'mass-rim'; g.add(rim);

  const wallMat2 = new THREE.MeshStandardMaterial({ color: G.ink, roughness: 0.94, metalness: 0.04, side: THREE.DoubleSide });
  wallMat2.name = 'pressed-stone';
  [[-1, 0], [1, 0], [0, -1]].forEach(([sx, sz], i) => {
    const w = new THREE.Mesh(new THREE.PlaneGeometry(46, 22), wallMat2);
    w.name = 'wall-' + i;
    if (sx) { w.position.set(sx * 15, 0, 0); w.rotation.y = -sx * Math.PI / 2; }
    else { w.position.set(0, 0, sz * 20); }
    w.receiveShadow = true; g.add(w);
  });

  // one palm-press, set into the ground and still glowing
  const press = new THREE.Mesh(
    new THREE.CylinderGeometry(2.1, 2.5, 0.42, 40),
    new THREE.MeshStandardMaterial({ color: G.c, roughness: 0.7, emissive: new THREE.Color(G.c), emissiveIntensity: 1.4 })
  );
  press.material.name = 'palm-press';
  press.name = 'press'; press.position.set(0, -5.3, -7); press.receiveShadow = true; g.add(press);
  const ember = sprite(glow('gr' + ring, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), G.c, 9, 0.42);
  ember.position.set(0, -4.8, -7); g.add(ember);
  const emberLight = new THREE.PointLight(G.c, 1300, 34, 2);
  emberLight.position.set(0, -4.2, -7); g.add(emberLight);
  const raking = new THREE.DirectionalLight(G.c, 3.6);
  raking.position.set(9, 6, 4);
  raking.castShadow = true; raking.shadow.mapSize.set(1024, 1024);
  const sc = raking.shadow.camera;
  sc.left = -24; sc.right = 24; sc.top = 24; sc.bottom = -24; sc.near = 0.5; sc.far = 60;
  g.add(raking);
  g.add(new THREE.AmbientLight(G.c, 3.2));
  const dust = motes(110, { x: 24, y: 12, z: 26 }, G.c, 0.12);
  dust.position.set(0, -1, -4); g.add(dust);

  const out = {
    group: g, label: 'the ceiling is coming down', shadows: true,
    update(t) {
      const k = smooth(t / 62), b = deep(t);
      slab.position.y = 11 - k * 7.4;
      under.position.y = slab.position.y - 2.21;
      rim.position.y = slab.position.y - 2.2;
      rim.material.opacity = 0.32 + k * 0.4;
      groundMat.displacementScale = 0.5 + k * 1.9;
      groundMat.bumpScale = 0.9 + k * 1.6;
      emberLight.intensity = 1300 + Math.sin(t * 0.5) * 130;
      ember.scale.setScalar(9 + Math.sin(t * 0.5) * 0.5 + k * 2);
      raking.intensity = 3.6 - k * 2.0;
      // the second adaptation: the weight was never above you. It is what you
      // are standing on, and it has been holding you the whole time.
      slab.position.y = 11 - k * 7.4 + b * 5.2;
      under.position.y = slab.position.y - 2.21;
      press.material.emissiveIntensity = 1.4 + b * 3.4;
      press.scale.setScalar(1 + b * 1.8);
      groundMat.displacementScale = 0.5 + k * 1.9 + b * 1.4;
      driftMotes(dust, t, 0.3, 1);
      out.label = b > 0.45 ? 'the weight was holding you all along' : 'the ceiling is coming down';
    },
  };
  return out;
}

// Her mechanism, if she has one authored yet. Otherwise: her seat.
const BY_NAME = {
  'Animā': chamberContract,
  'Laghimā': chamberRelease,
  'Garimā': chamberPress,
  'Mahimā': chamberEndless,
  'Vaśitā': chamberKnown,
  'Sarvayoni': chamberMembrane,
  'Sarvatrikhaṇḍā': chamberTriple,
  'Mahātripurasundarī': chamberDissolve,
};

export const AUTHORED = Object.keys(BY_NAME);

// Is she a room yet? Either hand-authored, or covered by the grammar because
// her card exists. Everyone else inherits her seat.
export function isBuilt(shakti, ring, ix) {
  if (BY_NAME[shakti.name]) return true;
  const c = findCard(shakti, ring, ix);
  return !!(c && FAMILY_RINGS.has(c.ring));
}
const FAMILY_RINGS = new Set([1, 2, 3, 4, 5, 6, 7, 8]);

export function cardFor(shakti, ring, ix) {
  return findCard(shakti, ring, ix);
}

// Her attribute joins whatever room she has — hand-authored or grammar-built.
// The room is the mechanism; the attribute is the one thing acting inside it.
function withAttribute(chamber, world, card) {
  if (!card) return chamber;
  const attr = buildAttribute(card, gemFor(world.n, card.pos));
  if (!attr) return chamber;
  chamber.group.add(attr.group);
  const inner = chamber.update.bind(chamber);
  chamber.update = (t) => { inner(t); attr.update(t); };
  chamber.attribute = attr.key;
  return chamber;
}

export function buildChamber(world, shakti) {
  const card = findCard(shakti, world.n, shakti.__ix);
  // her own hand-authored mechanism first
  const fn = BY_NAME[shakti.name];
  if (fn) return withAttribute(fn(world, shakti), world, card);
  // then the grammar, in HER light — jittered off her khaḍgamālā position, and
  // seeded from her cluster if she is one of the sixteen
  if (card && FAMILY_RINGS.has(card.ring)) {
    const built = buildFromCard(world, card, gemFor(world.n, card.pos), CARD_BIJA[card.pos]);
    if (built) return withAttribute(built, world, card);
  }
  // otherwise: her seat, gem-lit
  return withAttribute(chamberSeat(world, shakti), world, card);
}
