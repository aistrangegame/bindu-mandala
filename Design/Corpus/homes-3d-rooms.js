// homes-3d-rooms.js — four homes as real interiors. Each room's MECHANISM is the
// scene: what it does to whoever stands in it. No decoration passing for design.

import * as THREE from 'three';

import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';

// ══════════════════════════════════════════════════════════════════════════
// 1 · AṆIMĀ — the room contracts while you stand still, and never reaches you.
// ══════════════════════════════════════════════════════════════════════════
function roomAnima() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x0a0602, 0.019), bg: 0x060301 };

  // The bhūpura, from inside. One box, back faces, lit from its own far wall.
  const shell = new THREE.Group(); shell.name = 'shell';
  const wall = new THREE.MeshStandardMaterial({
    color: 0x7a5322, roughness: 0.92, metalness: 0.04, side: THREE.BackSide,
  });
  wall.name = 'topaz-stone';
  const box = new THREE.Mesh(new THREE.BoxGeometry(9, 9, 26), wall);
  box.name = 'bhupura'; shell.add(box);

  // Her aperture: a single point of light in the far wall. Aṇimā is the atomic.
  const ap = new THREE.Group(); ap.name = 'aperture';
  const core = new THREE.Mesh(
    new THREE.SphereGeometry(0.12, 24, 16),
    new THREE.MeshBasicMaterial({ color: 0xfffdf2 })
  );
  core.name = 'bindu-point'; ap.add(core);
  ap.add(sprite(glow('a', 'rgba(255,236,190,1)', 'rgba(255,196,90,0)'), 0xffe1a4, 5.2, 0.95));
  ap.add(sprite(glow('a2', 'rgba(255,220,150,1)', 'rgba(200,130,40,0)'), 0xffcf80, 14, 0.4));
  ap.position.set(0, 0, -12.4);
  shell.add(ap);

  const key = new THREE.PointLight(0xffd18a, 900, 46, 2);
  key.position.set(0, 0, -12.2); shell.add(key);
  const fill = new THREE.PointLight(0xffb974, 150, 30, 2.2);
  fill.position.set(0, 1.4, -2); shell.add(fill);
  shell.add(new THREE.AmbientLight(0x4a2f10, 1.5));

  // The seams of her seat, catching the light — so the contraction is legible.
  const edge = new THREE.LineSegments(
    new THREE.EdgesGeometry(new THREE.BoxGeometry(9, 9, 26)),
    new THREE.LineBasicMaterial({ color: 0xffe0a8, transparent: true, opacity: 0.34, blending: THREE.AdditiveBlending, depthWrite: false })
  );
  edge.name = 'seams'; shell.add(edge);

  g.add(shell);
  const dust = motes(120, { x: 8, y: 8, z: 22 }, 0xfff0d0, 0.1);
  g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, 0, 8.6], look: [0, 0, -6] },
    label: 'the walls close while you stand still',
    update(t) {
      // 62s of closing, then it holds. It never reaches you: floor at 0.34.
      const k = 0.34 + 0.66 * (1 - smooth(t / 62));
      shell.scale.set(k, k, 1 - (1 - k) * 0.42);
      ap.scale.setScalar(0.5 + 0.5 / k);
      key.intensity = 900 / (k * k);
      edge.material.opacity = 0.2 + 0.34 * (1 - k);
      driftMotes(dust, t, 0.42);
      dust.scale.set(k, k, 1);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 2 · MAHIMĀ — no far wall. Depth is generated faster than you can cross it.
// ══════════════════════════════════════════════════════════════════════════
function roomMahima() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x02060f, 0.021), bg: 0x01040a };

  const SPAN = 130, N = 26;
  const frames = [];
  const mat = new THREE.LineBasicMaterial({
    color: 0x9cc8ff, transparent: true, opacity: 0.9, blending: THREE.AdditiveBlending, depthWrite: false,
  });
  mat.name = 'sapphire-edge';
  for (let i = 0; i < N; i++) {
    const f = new THREE.Group(); f.name = 'threshold-' + i;
    const w = 7 + i * 0.5, h = 7 + i * 0.5;
    const pts = [[-w, -h], [w, -h], [w, h], [-w, h]];
    f.add(loop(pts, 0, 0x9cc8ff, 0.85));
    const halo = sprite(glow('mh', 'rgba(156,200,255,1)', 'rgba(44,95,168,0)'), 0x9cc8ff, w * 2.4, 0.1);
    f.add(halo);
    f.position.z = -SPAN + (i / N) * SPAN;
    f.userData = { halo, line: f.children[0] };
    frames.push(f); g.add(f);
  }

  // The near edges you are between — proof you are inside, not looking at.
  const near = new THREE.Group(); near.name = 'here';
  [[-1, 0], [1, 0], [0, -1], [0, 1]].forEach(([x, y], i) => {
    const geo = new THREE.BufferGeometry().setFromPoints([
      new THREE.Vector3(x * 6.4, y * 6.4, 6), new THREE.Vector3(x * 6.4, y * 6.4, -SPAN),
    ]);
    const l = new THREE.Line(geo, new THREE.LineBasicMaterial({
      color: 0x6e9fe0, transparent: true, opacity: 0.16, blending: THREE.AdditiveBlending, depthWrite: false,
    }));
    l.name = 'rail-' + i; near.add(l);
  });
  g.add(near);

  g.add(new THREE.AmbientLight(0x2c5fa8, 0.7));
  const haze = sprite(glow('mz', 'rgba(124,180,242,1)', 'rgba(12,30,62,0)'), 0x5f92d8, 50, 0.05);
  haze.position.z = -70; g.add(haze);
  const dust = motes(150, { x: 22, y: 22, z: 110 }, 0xd6e8ff, 0.13);
  dust.position.z = -50; g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, 0, 5], look: [0, 0, -40] },
    label: 'no far wall · it never arrives',
    update(t) {
      const flow = t * 3.4;
      frames.forEach((f, i) => {
        const z = ((-SPAN + (i / N) * SPAN + flow) % SPAN + SPAN) % SPAN - SPAN + 6;
        f.position.z = z;
        const near01 = Math.max(0, Math.min(1, (z + SPAN) / SPAN));
        const o = Math.sin(Math.PI * near01) * 0.9;
        f.userData.line.material.opacity = o;
        f.userData.halo.material.opacity = o * 0.12;
      });
      driftMotes(dust, t, 0.7);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 3 · VAŚITVA — the room is not lit, it is KNOWN. Only what attention rests
// on exists; the rest is not dark, it is absent.
// ══════════════════════════════════════════════════════════════════════════
function roomVasitva() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x05040a, 0.02), bg: 0x05040a };

  const stone = new THREE.MeshStandardMaterial({ color: 0x9c8ad0, roughness: 0.8, metalness: 0.06, side: THREE.BackSide });
  stone.name = 'known-stone';
  const room = new THREE.Mesh(new THREE.BoxGeometry(16, 10, 30), stone);
  room.name = 'chamber'; room.receiveShadow = true; g.add(room);

  const pillarMat = new THREE.MeshStandardMaterial({ color: 0xb2a0e0, roughness: 0.62, metalness: 0.1 });
  pillarMat.name = 'pillar-stone';
  for (let i = 0; i < 6; i++) {
    const p = new THREE.Mesh(new THREE.CylinderGeometry(0.42, 0.5, 10, 24), pillarMat);
    p.name = 'pillar-' + i;
    p.position.set(i % 2 ? 5.6 : -5.6, 0, -3 - Math.floor(i / 2) * 7);
    p.castShadow = true; p.receiveShadow = true;
    g.add(p);
  }
  // her seat
  const seat = new THREE.Mesh(new THREE.CylinderGeometry(1.9, 2.3, 0.5, 40), pillarMat);
  seat.name = 'seat'; seat.position.set(0, -4.7, -11); seat.castShadow = true; g.add(seat);
  const ringMat = new THREE.MeshBasicMaterial({ color: 0xe4d8ff, transparent: true, opacity: 0.7, blending: THREE.AdditiveBlending, depthWrite: false });
  ringMat.name = 'attention-ring';
  const ring = new THREE.Mesh(new THREE.TorusGeometry(1.5, 0.035, 8, 60), ringMat);
  ring.name = 'seat-ring'; ring.position.set(0, -4.4, -11); ring.rotation.x = Math.PI / 2; g.add(ring);

  // The pool of knowing. A real travelling spotlight, with real shadows.
  const pool = new THREE.SpotLight(0xd8caff, 2400, 44, 0.4, 0.88, 1.55);
  pool.position.set(0, 3.2, -4);
  pool.target.position.set(0, -3.4, -11);
  pool.castShadow = true;
  pool.shadow.mapSize.set(1024, 1024);
  pool.shadow.camera.near = 0.6; pool.shadow.camera.far = 40;
  g.add(pool); g.add(pool.target);
  const poolGlow = sprite(glow('v', 'rgba(205,187,239,1)', 'rgba(90,70,140,0)'), 0x9a86c4, 14, 0.14);
  g.add(poolGlow);
  g.add(new THREE.AmbientLight(0x2e2650, 2.4));

  const dust = motes(110, { x: 14, y: 9, z: 26 }, 0xd6c8ff, 0.11);
  dust.position.z = -8; g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, 0.4, 9], look: [0, -1.4, -8] },
    label: 'the room exists only where attention rests',
    shadows: true,
    update(t) {
      // the pool of knowing travels; it grazes floor, pillars and her seat in turn
      const x = Math.sin(t * 0.16) * 5.2 + Math.sin(t * 0.058) * 1.8;
      const z = -11 + Math.cos(t * 0.125) * 5.4;
      const y = -2.4 + Math.sin(t * 0.093) * 2.1;
      pool.target.position.set(x, y, z);
      pool.position.set(x * 0.42, 3.2, z + 5.2);
      poolGlow.position.set(x, y + 0.9, z);
      ring.material.opacity = 0.28 + 0.5 * Math.max(0, 1 - Math.hypot(x, z + 11) / 7);
      driftMotes(dust, t, 0.4);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 4 · MAHĀTRIPURASUNDARĪ — no room. The enclosure is gone and the yantra you
// have been walking through all along is the thing you are standing inside.
// ══════════════════════════════════════════════════════════════════════════
function roomBindu() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x070604, 0.012), bg: 0x070604 };

  const yantra = new THREE.Group(); yantra.name = 'sri-yantra';
  const GOLD = 0xfff2cf;

  // the bhūpura, and the two lotus rings — real shells at real depths
  const sq = (r) => [[-r, -r], [r, -r], [r, r], [-r, r]];
  [[13, 0], [11.6, -0.9], [10.2, -1.8]].forEach(([r, z], i) => {
    const l = loop(sq(r), z, GOLD, 0.3 - i * 0.06);
    l.name = 'bhupura-' + i; yantra.add(l);
  });
  const circle = (r, n) => Array.from({ length: n }, (_, i) => {
    const a = (i / n) * Math.PI * 2;
    return [Math.cos(a) * r, Math.sin(a) * r];
  });
  [[9, 64, -2.6], [8.1, 64, -3.1]].forEach(([r, n, z], i) => {
    const l = loop(circle(r, n), z, GOLD, 0.34); l.name = 'ring-' + i; yantra.add(l);
  });
  // petals as real 3D lobes
  const petalRing = (count, rIn, rOut, z, w) => {
    const grp = new THREE.Group(); grp.name = `petals-${count}`;
    for (let i = 0; i < count; i++) {
      const a = (i / count) * Math.PI * 2;
      const pts = [];
      for (let k = 0; k <= 16; k++) {
        const u = k / 16, sp = Math.pow(Math.sin(Math.PI * u), 1.4) * w;
        const rr = rIn + (rOut - rIn) * u;
        pts.push([Math.cos(a) * rr - Math.sin(a) * sp, Math.sin(a) * rr + Math.cos(a) * sp]);
      }
      for (let k = 15; k > 0; k--) {
        const u = k / 16, sp = Math.pow(Math.sin(Math.PI * u), 1.4) * w;
        const rr = rIn + (rOut - rIn) * u;
        pts.push([Math.cos(a) * rr + Math.sin(a) * sp, Math.sin(a) * rr - Math.cos(a) * sp]);
      }
      grp.add(loop(pts, z, GOLD, 0.3));
    }
    return grp;
  };
  yantra.add(petalRing(16, 6.4, 8.9, -3.6, 0.62));
  yantra.add(petalRing(8, 4.9, 6.3, -4.4, 0.78));

  // the nine interlocking triangles, at nine depths — you are inside them
  const tris = new THREE.Group(); tris.name = 'nine-triangles';
  const up = [[5.5, -2.2], [4.4, -1.7], [3.4, -1.3], [2.3, -0.85]];
  const dn = [[5.5, -2.2], [4.7, -1.9], [3.9, -1.55], [3.0, -1.2], [1.9, -0.75]];
  up.forEach(([ay, base], i) => {
    const l = loop([[0, ay], [ay * 0.92, base], [-ay * 0.92, base]], -5 - i * 0.55, GOLD, 0.46);
    l.name = 'up-' + i; tris.add(l);
  });
  dn.forEach(([ay, base], i) => {
    const l = loop([[0, -ay], [ay * 0.92, -base], [-ay * 0.92, -base]], -5.3 - i * 0.55, GOLD, 0.46);
    l.name = 'down-' + i; tris.add(l);
  });
  yantra.add(tris);
  g.add(yantra);

  // the bindu
  const bindu = new THREE.Group(); bindu.name = 'bindu';
  bindu.add(sprite(glow('b', 'rgba(255,255,255,1)', 'rgba(201,150,63,0)'), 0xfff6de, 7.5, 0.95));
  bindu.add(sprite(glow('b2', 'rgba(255,246,222,1)', 'rgba(120,80,20,0)'), 0xffe9b8, 22, 0.3));
  const drop = new THREE.Mesh(new THREE.SphereGeometry(0.2, 24, 16), new THREE.MeshBasicMaterial({ color: 0xffffff }));
  drop.name = 'source'; bindu.add(drop);
  bindu.position.z = -8.4; g.add(bindu);

  g.add(new THREE.AmbientLight(0xfff0d0, 0.5));
  const dust = motes(200, { x: 26, y: 26, z: 26 }, 0xfff6de, 0.1);
  dust.position.z = -6; g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, 0, 6.4], look: [0, 0, -8.4] },
    label: 'there was never anyone here but Her',
    update(t) {
      const br = 0.94 + 0.07 * Math.sin(t * 0.115);
      yantra.scale.setScalar(br);
      yantra.rotation.z = t * 0.0075;
      tris.rotation.z = -t * 0.014;
      bindu.scale.setScalar(0.85 + 0.2 * Math.sin(t * 0.19));
      driftMotes(dust, t, 0.55);
    },
  };
}

export const ROOMS_1 = [
  { id: 'anima', name: 'Aṇimā', quality: 'Smallness', ring: 1, build: roomAnima,
    mech: 'The door is smaller than you. You are admitted anyway — and then it keeps closing, so the longer you stay the smaller you have become. It never reaches you.' },
  { id: 'mahima', name: 'Mahimā', quality: 'Vastness', ring: 1, build: roomMahima,
    mech: 'Her room has no far wall. Every edge you move toward proves to be the near edge of something larger, arriving out of the haze faster than you can cross it.' },
  { id: 'vasitva', name: 'Vaśitva', quality: 'Mastery', ring: 1, build: roomVasitva,
    mech: 'The room is not lit — it is known. Only what your attention rests on exists; walls, pillars and her seat resolve inside a travelling pool and fall back to nothing behind it.' },
  { id: 'bindu', name: 'Mahātripurasundarī', quality: 'Totality', ring: 9, build: roomBindu,
    mech: 'No room at all. The enclosure is gone, and the yantra you have been walking through the whole time stands revealed as the thing you are inside.' },
];
