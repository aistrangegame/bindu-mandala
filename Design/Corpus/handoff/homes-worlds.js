// homes-worlds.js — the nine āvaraṇas as WEATHER, not palette. One continuous
// vertical world: the body from Feet to Totality. Each band has its own air,
// its own light physics, its own material and its own clock. Shown empty —
// a world must be felt before any Śakti is set inside it.

import * as THREE from 'three';
import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';

const SPACING = 30;
const lerp = (a, b, t) => a + (b - a) * t;

// ── 1 · FEET · topaz · rasa · day–night ─────────────────────────────────────
// Weather: low warm light raking a vast floor, swinging horizon to horizon.
function bandFeet(y) {
  const g = new THREE.Group();
  const floor = new THREE.Mesh(
    new THREE.PlaneGeometry(120, 120, 60, 60),
    new THREE.MeshStandardMaterial({ color: 0x8a6330, roughness: 0.96, metalness: 0.03 })
  );
  floor.material.name = 'topaz-ground';
  floor.rotation.x = -Math.PI / 2; floor.position.y = y - 3.2; floor.receiveShadow = true;
  g.add(floor);

  // things that exist only to be raked — long shadows are the weather
  const slabMat = new THREE.MeshStandardMaterial({ color: 0x6b4a24, roughness: 0.92 });
  slabMat.name = 'standing-stone';
  const slabs = new THREE.Group();
  for (let i = 0; i < 11; i++) {
    const a = (i / 11) * Math.PI * 2 + 0.4;
    const r = 11 + (i % 3) * 6;
    const h = 3 + (i % 4) * 2.2;
    const s = new THREE.Mesh(new THREE.BoxGeometry(1.1, h, 1.1), slabMat);
    s.position.set(Math.cos(a) * r, y - 3.2 + h / 2, Math.sin(a) * r);
    s.castShadow = true; s.receiveShadow = true;
    slabs.add(s);
  }
  g.add(slabs);

  const sun = new THREE.DirectionalLight(0xffc367, 6.4);
  sun.castShadow = true;
  sun.shadow.mapSize.set(1024, 1024);
  const sc = sun.shadow.camera;
  sc.left = -46; sc.right = 46; sc.top = 46; sc.bottom = -46; sc.near = 0.5; sc.far = 140;
  g.add(sun); g.add(sun.target);
  sun.target.position.set(0, y - 3.2, 0);
  const disc = sprite(glow('w1', 'rgba(255,226,150,1)', 'rgba(180,110,30,0)'), 0xffc367, 22, 0.6);
  g.add(disc);
  const amb = new THREE.HemisphereLight(0xffd28a, 0x2a1608, 1.8); amb.position.y = y; g.add(amb);
  const dust = motes(90, { x: 60, y: 12, z: 60 }, 0xffe0b0, 0.16); dust.position.y = y - 3; g.add(dust);

  return {
    group: g,
    update(t) {
      const day = (t * 0.05) % 1;                    // the day–night cycle, visible
      const ang = day * Math.PI * 2;
      const alt = Math.sin(ang);
      sun.position.set(Math.cos(ang) * 60, y - 3.2 + Math.max(-4, alt * 34), Math.sin(ang * 0.6) * 26);
      disc.position.copy(sun.position);
      const night = clamp01(-alt * 2);
      sun.intensity = 6.4 * clamp01(alt * 1.6 + 0.2);
      disc.material.opacity = 0.6 * clamp01(alt + 0.4);
      amb.intensity = lerp(1.8, 0.3, night);
      driftMotes(dust, t, 0.5);
    },
  };
}

// ── 2 · PELVIS · sapphire · rakta · the hour ────────────────────────────────
// Weather: the air pulses. Blood-warm waves travel out through cold blue.
function bandPelvis(y) {
  const g = new THREE.Group();
  const rings = [];
  for (let i = 0; i < 7; i++) {
    const r = loop(Array.from({ length: 72 }, (_, k) => {
      const a = (k / 72) * Math.PI * 2; return [Math.cos(a), Math.sin(a)];
    }), 0, 0xff5c6e, 0.5);
    r.rotation.x = -Math.PI / 2; r.position.y = y - 2.8;
    r.userData.phase = i / 7;
    rings.push(r); g.add(r);
  }
  const pool = new THREE.Mesh(
    new THREE.CircleGeometry(30, 64),
    new THREE.MeshStandardMaterial({ color: 0x1c3059, roughness: 0.3, metalness: 0.3 })
  );
  pool.material.name = 'rakta-floor';
  pool.rotation.x = -Math.PI / 2; pool.position.y = y - 3.2; g.add(pool);

  const beat = new THREE.PointLight(0xff4d5e, 400, 44, 2);
  beat.position.set(0, y - 2, 0); g.add(beat);
  const heart = sprite(glow('w2', 'rgba(255,120,130,1)', 'rgba(120,20,40,0)'), 0xff5c6e, 12, 0.4);
  heart.position.set(0, y - 2, 0); g.add(heart);
  const cold = new THREE.HemisphereLight(0x6f9dff, 0x0a1430, 2.6); cold.position.y = y; g.add(cold);
  const dust = motes(120, { x: 30, y: 16, z: 30 }, 0xbfd8ff, 0.13); dust.position.y = y; g.add(dust);

  return {
    group: g,
    update(t) {
      const bpm = t * 1.05;                          // the hour, felt as pulse
      const sys = Math.pow(Math.max(0, Math.sin(bpm * Math.PI)), 6);
      rings.forEach((r) => {
        const p = (bpm * 0.5 + r.userData.phase) % 1;
        const s = 1.4 + p * 27;
        r.scale.set(s, s, 1);
        r.material.opacity = (1 - p) * 0.62 * (0.4 + 0.6 * sys);
      });
      beat.intensity = 120 + sys * 900;
      heart.scale.setScalar(10 + sys * 9);
      heart.material.opacity = 0.24 + sys * 0.5;
      driftMotes(dust, t, 0.4);
    },
  };
}

// ── 3 · NAVEL · coral · māṃsa · the day ─────────────────────────────────────
// Weather: churn. Sarvasaṅkṣobhaṇa — the all-agitating. The air will not settle.
function bandNavel(y) {
  const g = new THREE.Group();
  const N = 2600;
  const geo = new THREE.BufferGeometry();
  const pos = new Float32Array(N * 3), seed = new Float32Array(N), size = new Float32Array(N);
  for (let i = 0; i < N; i++) {
    const r = Math.pow(Math.random(), 0.6) * 20;
    const a = Math.random() * Math.PI * 2;
    pos[i * 3] = Math.cos(a) * r;
    pos[i * 3 + 1] = (Math.random() - 0.5) * 22;
    pos[i * 3 + 2] = Math.sin(a) * r;
    seed[i] = Math.random() * 6.28; size[i] = 1.6 + Math.random() * 4.4;
  }
  geo.setAttribute('position', new THREE.BufferAttribute(pos, 3));
  geo.setAttribute('aSeed', new THREE.BufferAttribute(seed, 1));
  geo.setAttribute('aSize', new THREE.BufferAttribute(size, 1));
  const u = { uTime: { value: 0 } };
  const mat = new THREE.ShaderMaterial({
    uniforms: u, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending,
    vertexShader: `
      attribute float aSeed; attribute float aSize;
      uniform float uTime; varying float vA;
      // a cheap curl: three offset sines that never repeat cleanly
      vec3 flow(vec3 p, float t){
        return vec3(
          sin(p.y * 0.19 + t * 0.5) + cos(p.z * 0.14 - t * 0.31),
          sin(p.z * 0.16 + t * 0.42) + cos(p.x * 0.12 - t * 0.27),
          sin(p.x * 0.17 - t * 0.36) + cos(p.y * 0.13 + t * 0.29));
      }
      void main(){
        vec3 p = position;
        vec3 v = flow(p, uTime + aSeed);
        p += v * 2.6 + flow(p * 2.1, uTime * 0.7) * 0.9;
        vA = 0.35 + 0.65 * (0.5 + 0.5 * sin(uTime * 0.6 + aSeed * 4.0));
        vec4 mv = modelViewMatrix * vec4(p, 1.0);
        gl_PointSize = aSize * (240.0 / max(0.001, -mv.z));
        gl_Position = projectionMatrix * mv;
      }`,
    fragmentShader: `
      varying float vA;
      void main(){
        float d = length(gl_PointCoord - vec2(0.5));
        float a = smoothstep(0.5, 0.05, d);
        gl_FragColor = vec4(vec3(1.0, 0.46, 0.32), a * vA * 0.34);
      }`,
  });
  mat.name = 'churn';
  const churn = new THREE.Points(geo, mat); churn.position.y = y; g.add(churn);
  const hemi3 = new THREE.HemisphereLight(0xff7a52, 0x2a0a06, 1.6); hemi3.position.set(0, y, 0); g.add(hemi3);
  const core = new THREE.PointLight(0xff6a44, 320, 40, 2); core.position.set(0, y, 0); g.add(core);

  return { group: g, update(t) { u.uTime.value = t; core.intensity = 280 + Math.sin(t * 0.4) * 90; } };
}

// ── 4 · HEART · diamond · medas · lunar fortnight ───────────────────────────
// Weather: light split. Caustics crawl over glossy ground in three separated
// spectra — dispersion as the world's own condition.
function causticTexture(seedOffset) {
  const c = document.createElement('canvas');
  c.width = c.height = 256;
  const x = c.getContext('2d');
  x.fillStyle = '#000'; x.fillRect(0, 0, 256, 256);
  x.globalCompositeOperation = 'lighter';
  x.strokeStyle = 'rgba(255,255,255,0.42)';
  for (let i = 0; i < 46; i++) {
    x.lineWidth = 0.7 + Math.random() * 2.4;
    x.beginPath();
    let px = Math.random() * 256, py = Math.random() * 256;
    x.moveTo(px, py);
    for (let k = 0; k < 26; k++) {
      px += Math.cos(k * 0.5 + i + seedOffset) * 11 + (Math.random() - 0.5) * 7;
      py += Math.sin(k * 0.42 + i * 1.7 + seedOffset) * 11 + (Math.random() - 0.5) * 7;
      x.lineTo(px, py);
    }
    x.stroke();
  }
  const t = new THREE.CanvasTexture(c);
  t.wrapS = t.wrapT = THREE.RepeatWrapping;
  t.colorSpace = THREE.SRGBColorSpace;
  return t;
}

function bandHeart(y) {
  const g = new THREE.Group();
  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(34, 72),
    new THREE.MeshStandardMaterial({ color: 0x223040, roughness: 0.2, metalness: 0.35 })
  );
  floor.material.name = 'medas-gloss';
  floor.rotation.x = -Math.PI / 2; floor.position.y = y - 3.4; g.add(floor);

  // three spectra, three textures, three drifts — diamond splits what enters it
  const spectra = [[0xff4d4d, 0], [0x4dff8a, 2.1], [0x6a8cff, 4.2]].map(([col, off], i) => {
    const m = new THREE.Mesh(
      new THREE.PlaneGeometry(86, 86),
      new THREE.MeshBasicMaterial({
        map: causticTexture(off), color: col, transparent: true, opacity: 0.6,
        blending: THREE.AdditiveBlending, depthWrite: false, fog: false,
      })
    );
    m.material.name = 'caustic-' + i;
    m.rotation.x = -Math.PI / 2; m.position.y = y - 3.3 + i * 0.02;
    g.add(m); return m;
  });

  const prism = new THREE.Mesh(
    new THREE.OctahedronGeometry(2.4, 0),
    new THREE.MeshPhysicalMaterial({
      color: 0xffffff, roughness: 0.05, metalness: 0, transmission: 0.96,
      thickness: 2.2, ior: 2.4, dispersion: 4, clearcoat: 1,
    })
  );
  prism.material.name = 'diamond'; prism.position.set(0, y + 1.6, -3); g.add(prism);

  const key = new THREE.DirectionalLight(0xffffff, 5.2); key.position.set(6, y + 20, 8); g.add(key);
  const hemi4 = new THREE.HemisphereLight(0xdff0ff, 0x0a1018, 2.0); hemi4.position.set(0, y, 0); g.add(hemi4);

  return {
    group: g,
    update(t) {
      const fort = 0.5 + 0.5 * Math.sin(t * 0.0398);   // the lunar fortnight
      spectra.forEach((m, i) => {
        const s = 1 + i * 0.11;
        m.material.map.offset.set(Math.sin(t * 0.037 * s + i) * 0.4, Math.cos(t * 0.029 * s + i * 2) * 0.4);
        m.material.map.repeat.set(s, s);
        m.material.opacity = 0.42 + 0.4 * fort;
      });
      prism.rotation.set(t * 0.07, t * 0.11, 0);
      key.intensity = 2.6 + fort * 4.4;
    },
  };
}

// ── 5 · THROAT · emerald · asthi · lunar month ──────────────────────────────
// Weather: the world has bones. Light arrives only in shafts between ribs.
function bandThroat(y) {
  const g = new THREE.Group();
  const ribGeo = new THREE.CylinderGeometry(0.34, 0.5, 20, 12, 1, false);
  const ribMat = new THREE.MeshStandardMaterial({ color: 0xd8e8d0, roughness: 0.78, metalness: 0.06 });
  ribMat.name = 'asthi';
  const COUNT = 72;
  const ribs = new THREE.InstancedMesh(ribGeo, ribMat, COUNT);
  ribs.name = 'colonnade';
  const m4 = new THREE.Matrix4(), q = new THREE.Quaternion(), v = new THREE.Vector3(), s = new THREE.Vector3();
  for (let i = 0; i < COUNT; i++) {
    const ringIx = Math.floor(i / 24), k = i % 24;
    const r = 12 + ringIx * 7;
    const a = (k / 24) * Math.PI * 2 + ringIx * 0.13;
    v.set(Math.cos(a) * r, y + (ringIx % 2 ? 0.8 : -0.8), Math.sin(a) * r);
    q.setFromEuler(new THREE.Euler(0, -a, 0.04 * (ringIx - 1)));
    s.set(1, 1 - ringIx * 0.1, 1);
    ribs.setMatrixAt(i, m4.compose(v, q, s));
  }
  ribs.castShadow = true; ribs.receiveShadow = true; g.add(ribs);

  // the shafts between them
  const shafts = new THREE.Group();
  for (let i = 0; i < 24; i++) {
    const a = (i / 24) * Math.PI * 2 + Math.PI / 24;
    const p = new THREE.Mesh(
      new THREE.PlaneGeometry(2.6, 22),
      new THREE.MeshBasicMaterial({
        color: 0x8ff2b8, transparent: true, opacity: 0.06,
        blending: THREE.AdditiveBlending, depthWrite: false, side: THREE.DoubleSide, fog: false,
      })
    );
    p.position.set(Math.cos(a) * 12.6, y, Math.sin(a) * 12.6);
    p.rotation.y = -a + Math.PI / 2;
    shafts.add(p);
  }
  g.add(shafts);

  const above = new THREE.DirectionalLight(0xd6ffe4, 4.6); above.position.set(2, y + 24, 3); g.add(above);
  const core = new THREE.PointLight(0x2fe08a, 700, 46, 2); core.position.set(0, y, 0); g.add(core);
  const hemi5 = new THREE.HemisphereLight(0x7fe0a8, 0x06180e, 1.2); hemi5.position.set(0, y, 0); g.add(hemi5);

  return {
    group: g,
    update(t) {
      const moon = 0.5 + 0.5 * Math.sin(t * 0.0199);   // the lunar month
      shafts.children.forEach((p, i) => {
        p.material.opacity = 0.06 + 0.16 * moon * (0.4 + 0.6 * Math.abs(Math.sin(t * 0.13 + i * 0.6)));
      });
      core.intensity = 380 + moon * 620;
      above.intensity = 2.2 + moon * 3.4;
    },
  };
}

// ── 6 · FOREHEAD · ruby · majjā · season ────────────────────────────────────
// Weather: nothing is lit from outside. Every solid glows from within.
function bandForehead(y) {
  const g = new THREE.Group();
  const bodies = new THREE.Group();
  const shellMat = new THREE.MeshPhysicalMaterial({
    color: 0x5a0a16, roughness: 0.46, metalness: 0,
    transmission: 0.6, thickness: 2.6, ior: 1.76,
    attenuationColor: new THREE.Color(0x8b1a2a), attenuationDistance: 1.4,
    emissive: 0x8a0c1c, emissiveIntensity: 2.2,
  });
  shellMat.name = 'majja-shell';
  const geos = [new THREE.IcosahedronGeometry(2.6, 1), new THREE.DodecahedronGeometry(2.2, 0), new THREE.OctahedronGeometry(2.8, 1)];
  const inner = [];
  for (let i = 0; i < 9; i++) {
    const a = (i / 9) * Math.PI * 2;
    const r = 9 + (i % 3) * 4.6;
    const b = new THREE.Mesh(geos[i % 3], shellMat);
    b.position.set(Math.cos(a) * r, y + Math.sin(i * 1.7) * 5.4, Math.sin(a) * r);
    bodies.add(b);
    const l = new THREE.PointLight(0xff3a52, 420, 22, 2);   // the marrow itself
    l.position.copy(b.position); inner.push(l); g.add(l);
  }
  g.add(bodies);

  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(32, 64),
    new THREE.MeshStandardMaterial({ color: 0x1a0509, roughness: 0.86, metalness: 0.1 })
  );
  floor.material.name = 'marrow-ground';
  floor.rotation.x = -Math.PI / 2; floor.position.y = y - 3.6; g.add(floor);
  g.add(new THREE.AmbientLight(0x4a1018, 2.0));
  const dust = motes(90, { x: 30, y: 20, z: 30 }, 0xff8a9a, 0.13); dust.position.y = y; g.add(dust);

  return {
    group: g,
    update(t) {
      const season = 0.5 + 0.5 * Math.sin(t * 0.0066);      // the season, barely moving
      shellMat.emissiveIntensity = 1.5 + season * 1.6;
      shellMat.attenuationDistance = 1.1 + season * 0.9;
      bodies.children.forEach((b, i) => {
        b.rotation.set(t * 0.04 + i, t * 0.03 - i, 0);
        b.position.y = y + Math.sin(i * 1.7 + t * 0.07) * 5.4;
        inner[i].position.copy(b.position);
        inner[i].intensity = 240 + season * 420 * (0.6 + 0.4 * Math.sin(t * 0.21 + i));
      });
      driftMotes(dust, t, 0.34);
    },
  };
}

// ── 7 · CROWN · pearl · śukra · solar half-year ─────────────────────────────
// Weather: sourceless. Luminous fog and no shadow anywhere — light from
// everywhere at once, so there is nothing to orient by.
function bandCrown(y) {
  const g = new THREE.Group();
  // barely-there planes, only so the milk has something to be in front of
  for (let i = 0; i < 7; i++) {
    const a = (i / 7) * Math.PI * 2;
    const p = new THREE.Mesh(
      new THREE.PlaneGeometry(20, 20),
      new THREE.MeshBasicMaterial({ color: 0xf6f1e6, transparent: true, opacity: 0.035, side: THREE.DoubleSide, depthWrite: false })
    );
    p.position.set(Math.cos(a) * 17, y + Math.sin(i * 2.1) * 6, Math.sin(a) * 17);
    p.rotation.y = -a; g.add(p);
  }
  const veils = [];
  for (let i = 0; i < 5; i++) {
    const s = sprite(glow('w7', 'rgba(255,252,244,1)', 'rgba(220,210,190,0)'), 0xfbf6ec, 40 + i * 12, 0.13);
    s.position.set((i - 2) * 5, y + (i - 2) * 3.4, -4 - i * 3);
    veils.push(s); g.add(s);
  }
  g.add(new THREE.AmbientLight(0xf6f1e6, 2.6));
  g.add(new THREE.HemisphereLight(0xffffff, 0xe8e2d4, 1.7));
  const dust = motes(150, { x: 34, y: 24, z: 34 }, 0xfffaf0, 0.14); dust.position.y = y; g.add(dust);

  return {
    group: g,
    update(t) {
      const half = 0.5 + 0.5 * Math.sin(t * 0.0033);        // the solar half-year
      veils.forEach((s, i) => {
        s.material.opacity = 0.08 + 0.1 * half * (0.5 + 0.5 * Math.sin(t * 0.05 + i));
        s.scale.setScalar((40 + i * 12) * (1 + 0.05 * Math.sin(t * 0.04 + i)));
      });
      driftMotes(dust, t, 0.3);
    },
  };
}

// ── 8 · ABOVE CROWN · cat's eye · ojas · year ───────────────────────────────
// Weather: one band of light, and only one. Chatoyancy — the whole world is a
// single travelling meridian; everything else waits in the dark.
function bandAboveCrown(y) {
  const g = new THREE.Group();
  const shellU = { uTime: { value: 0 }, uAngle: { value: 0 } };
  const shell = new THREE.Mesh(
    new THREE.SphereGeometry(30, 64, 48),
    new THREE.ShaderMaterial({
      uniforms: shellU, side: THREE.BackSide, transparent: true, depthWrite: false,
      vertexShader: `
        varying vec3 vP;
        void main(){ vP = position; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }`,
      fragmentShader: `
        uniform float uAngle; uniform float uTime;
        varying vec3 vP;
        void main(){
          vec3 n = normalize(vP);
          vec2 axis = vec2(cos(uAngle), sin(uAngle));
          float d = abs(dot(n.xz, axis));                    // one meridian
          float band = pow(1.0 - d, 22.0);
          float haze = pow(max(0.0, 1.0 - abs(n.y)), 2.0) * 0.16;
          vec3 col = mix(vec3(0.20,0.15,0.06), vec3(1.0,0.90,0.58), band);
          gl_FragColor = vec4(col, band * 0.95 + haze);
        }`,
    })
  );
  shell.material.name = 'chatoyance'; shell.position.y = y; g.add(shell);

  const ridge = new THREE.Mesh(
    new THREE.CylinderGeometry(0.14, 0.14, 54, 8),
    new THREE.MeshBasicMaterial({ color: 0xfff0c0, fog: false })
  );
  ridge.material.name = 'the-band';
  ridge.rotation.z = Math.PI / 2; ridge.position.y = y; g.add(ridge);
  const sweep = new THREE.PointLight(0xffe9a8, 900, 60, 2); sweep.position.y = y; g.add(sweep);
  const halo = sprite(glow('w8', 'rgba(255,240,200,1)', 'rgba(150,110,30,0)'), 0xffe9a8, 30, 0.28);
  halo.position.y = y; g.add(halo);
  g.add(new THREE.AmbientLight(0x4a3a1c, 2.0));

  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(30, 64),
    new THREE.MeshStandardMaterial({ color: 0x2a2110, roughness: 0.3, metalness: 0.4 })
  );
  floor.material.name = 'ojas-ground';
  floor.rotation.x = -Math.PI / 2; floor.position.y = y - 3.6; g.add(floor);

  return {
    group: g,
    update(t) {
      const yr = t * 0.062;                                  // the year
      shellU.uTime.value = t; shellU.uAngle.value = yr;
      ridge.rotation.y = -yr;
      const s = Math.abs(Math.sin(yr * 2.0));
      sweep.position.set(Math.cos(yr) * 16, y, Math.sin(yr) * 16);
      sweep.intensity = 500 + s * 900;
      halo.position.copy(sweep.position);
      halo.scale.setScalar(24 + s * 14);
    },
  };
}

// ── 9 · TOTALITY · all gems · tejas · kāla–akāla ────────────────────────────
// Weather: every gem's light at once, which is the same as no weather at all.
function bandTotality(y) {
  const g = new THREE.Group();
  const GEMS = [0xffc367, 0x6f9dff, 0xff6a44, 0xdff0ff, 0x2fe08a, 0xff3a52, 0xfbf6ec, 0xffe9a8, 0xffffff];
  const lamps = GEMS.map((c, i) => {
    const a = (i / 9) * Math.PI * 2;
    const l = new THREE.PointLight(c, 320, 54, 2);
    l.position.set(Math.cos(a) * 15, y + Math.sin(i * 2.3) * 8, Math.sin(a) * 15);
    g.add(l);
    const s = sprite(glow('w9_' + i, 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), c, 9, 0.42);
    s.position.copy(l.position); g.add(s);
    return { l, s, a };
  });

  const yantra = new THREE.Group();
  const circle = (r, n) => Array.from({ length: n }, (_, i) => {
    const a = (i / n) * Math.PI * 2; return [Math.cos(a) * r, Math.sin(a) * r];
  });
  [7, 9.4, 12].forEach((r, i) => {
    const l = loop(circle(r, 84), 0, 0xfff6de, 0.2 - i * 0.04);
    l.rotation.x = -Math.PI / 2; l.position.y = y - 1 + i * 0.5; yantra.add(l);
  });
  [[6.4, -2.6], [5.1, -2.1], [3.8, -1.5]].forEach(([ay, base], i) => {
    const up = loop([[0, ay], [ay * 0.92, base], [-ay * 0.92, base]], 0, 0xfff6de, 0.34);
    up.position.y = y + 1 + i * 0.6; yantra.add(up);
    const dn = loop([[0, -ay], [ay * 0.92, -base], [-ay * 0.92, -base]], 0, 0xfff6de, 0.34);
    dn.position.y = y + 1.3 + i * 0.6; yantra.add(dn);
  });
  g.add(yantra);

  const core = new THREE.Group();
  core.add(sprite(glow('w9c', 'rgba(255,255,255,1)', 'rgba(201,150,63,0)'), 0xfff6de, 16, 0.85));
  core.add(sprite(glow('w9d', 'rgba(255,246,222,1)', 'rgba(120,80,20,0)'), 0xffe9b8, 46, 0.24));
  core.position.y = y; g.add(core);
  g.add(new THREE.AmbientLight(0xfff0d0, 1.5));
  const dust = motes(220, { x: 40, y: 34, z: 40 }, 0xfff6de, 0.13); dust.position.y = y; g.add(dust);

  return {
    group: g,
    update(t) {
      lamps.forEach((L, i) => {
        const a = L.a + t * 0.014;
        const r = 15 + Math.sin(t * 0.05 + i) * 3.4;
        L.l.position.set(Math.cos(a) * r, y + Math.sin(i * 2.3 + t * 0.03) * 8, Math.sin(a) * r);
        L.s.position.copy(L.l.position);
        L.l.intensity = 240 + 180 * (0.5 + 0.5 * Math.sin(t * 0.19 + i * 0.7));
      });
      yantra.rotation.y = t * 0.008;
      core.scale.setScalar(0.9 + 0.16 * Math.sin(t * 0.13));
      driftMotes(dust, t, 0.5);
    },
  };
}


// Attributes the brief carries that the rooms had not yet been given.
//  · the Yoginī class is how VEILED the world is — secrecy deepens inward
//  · the mental state sets the world's TEMPO
//  · the Mudrā verb is what the ring DOES
//  · the presiding Form is who holds it
export const RING_CHARACTER = {
  1: { form: 'Tripurā', phase: 'Śṛṣṭi', yogini: 'Prakaṭa — manifest', veil: 0.00, state: 'Jāgrat — waking', tempo: 1.00, verb: 'AGITATE', bija: 'Aim' },
  2: { form: 'Tripureśī', phase: 'Śṛṣṭi', yogini: 'Gupta — secret', veil: 0.12, state: 'Svapna — dreaming', tempo: 0.82, verb: 'LIQUEFY', bija: 'Klīm' },
  3: { form: 'Tripurasundarī', phase: 'Śṛṣṭi', yogini: 'Guptatara — more secret', veil: 0.24, state: 'Suṣupti — deep sleep', tempo: 0.62, verb: 'DRAW', bija: 'Sauḥ' },
  4: { form: 'Tripuravāsinī', phase: 'Sthiti', yogini: 'Sampradāya — lineage', veil: 0.36, state: 'Turīya begins', tempo: 0.72, verb: 'OPEN', bija: 'Hrīm' },
  5: { form: 'Tripuraśrī', phase: 'Sthiti', yogini: 'Kulottīrṇa — beyond clan', veil: 0.48, state: 'Turīya deepening', tempo: 0.66, verb: 'VOICE', bija: 'Hsraim' },
  6: { form: 'Tripuramālinī', phase: 'Sthiti', yogini: 'Nigarbha — in the womb', veil: 0.60, state: 'Turīyātīta begins', tempo: 0.5, verb: 'STILL', bija: 'Hsklhrīm' },
  7: { form: 'Tripurasiddhā', phase: 'Saṃhāra', yogini: 'Rahasya — secret', veil: 0.72, state: 'Pure witness', tempo: 0.44, verb: 'WITNESS', bija: 'Hsauḥ' },
  8: { form: 'Tripurāmbā', phase: 'Saṃhāra', yogini: 'Atirahasya — most secret', veil: 0.86, state: 'Source-consciousness', tempo: 0.36, verb: 'SEED', bija: 'Aim Klīm Sauḥ' },
  9: { form: 'Mahātripurasundarī', phase: 'Saṃhāra', yogini: 'Parāparāraharasya', veil: 1.00, state: 'Pure being', tempo: 0.28, verb: 'ARRIVE', bija: 'Hrīm' },
};

export const WORLDS = [
  { n: 1, name: 'Trailokyamohana', gem: 'Topaz', dhatu: 'Rasa', clock: 'day–night', region: 'Feet',
    weather: 'low light raking a vast floor, swinging horizon to horizon',
    fog: 0x1d1206, density: 0.0125, build: bandFeet },
  { n: 2, name: 'Sarvāśāparipūraka', gem: 'Sapphire', dhatu: 'Rakta', clock: 'the hour', region: 'Pelvis',
    weather: 'the air pulses — blood-warm waves through cold blue',
    fog: 0x0a1330, density: 0.017, build: bandPelvis },
  { n: 3, name: 'Sarvasaṅkṣobhaṇa', gem: 'Coral', dhatu: 'Māṃsa', clock: 'the day', region: 'Navel',
    weather: 'churn — the all-agitating. The air will not settle',
    fog: 0x2a0c06, density: 0.021, build: bandNavel },
  { n: 4, name: 'Sarvasaubhāgyadāyaka', gem: 'Diamond', dhatu: 'Medas', clock: 'lunar fortnight', region: 'Heart',
    weather: 'light split — three spectra crawling over glossy ground',
    fog: 0x0b1219, density: 0.014, build: bandHeart },
  { n: 5, name: 'Sarvārthasādhaka', gem: 'Emerald', dhatu: 'Asthi', clock: 'lunar month', region: 'Throat',
    weather: 'the world has bones; light arrives only in shafts between ribs',
    fog: 0x06180e, density: 0.018, build: bandThroat },
  { n: 6, name: 'Sarvarakṣākara', gem: 'Ruby', dhatu: 'Majjā', clock: 'season', region: 'Forehead',
    weather: 'nothing is lit from outside — every solid glows from within',
    fog: 0x1a0409, density: 0.022, build: bandForehead },
  { n: 7, name: 'Sarvarogahara', gem: 'Pearl', dhatu: 'Śukra', clock: 'solar half-year', region: 'Crown',
    weather: 'sourceless — luminous fog and no shadow anywhere',
    fog: 0xd8d2c4, density: 0.034, build: bandCrown },
  { n: 8, name: 'Sarvasiddhiprada', gem: "Cat's eye", dhatu: 'Ojas', clock: 'year', region: 'Above crown',
    weather: 'one travelling band of light; everything else waits in the dark',
    fog: 0x0f0b04, density: 0.015, build: bandAboveCrown },
  { n: 9, name: 'Sarvānandamaya', gem: 'All gems', dhatu: 'Tejas', clock: 'kāla–akāla', region: 'Totality',
    weather: 'every gem at once, which is the same as no weather at all',
    fog: 0x141008, density: 0.009, build: bandTotality },
];

// every world carries its character
WORLDS.forEach((x) => Object.assign(x, RING_CHARACTER[x.n]));

export const WORLD_SPACING = SPACING;
export const worldY = (i) => i * SPACING;
