// homes-3d-rooms-2.js — four more homes, each on a technique the others don't use.
// Laghimā: GLSL vertex displacement · Garimā: displacement mapping + real shadow
// Sarva-Yoni: physical transmission · Trikhaṇḍā: multi-pass render targets

import * as THREE from 'three';
import { glow, sprite, motes, driftMotes, loop, smooth, clamp01 } from './homes-3d-core.js';

// ══════════════════════════════════════════════════════════════════════════
// 5 · LAGHIMĀ — the floor has let go. Her walls end before the ground, their
// hems lifting though there is no wind. Nothing in this room falls.
// TECHNIQUE: vertex-shader displacement on hanging cloth walls + a GPU field
// whose only motion is upward.
// ══════════════════════════════════════════════════════════════════════════
function roomLaghima() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x121821, 0.03), bg: 0x080b10 };

  const wallUniforms = {
    uTime: { value: 0 }, uLift: { value: 0 }, uOpacity: { value: 0.86 },
  };
  const wallMat = new THREE.ShaderMaterial({
    uniforms: wallUniforms,
    transparent: true, side: THREE.DoubleSide, depthWrite: false,
    vertexShader: `
      uniform float uTime; uniform float uLift;
      varying vec2 vUv; varying float vHem;
      void main(){
        vUv = uv;
        vec3 p = position;
        float hem = smoothstep(0.62, 0.0, uv.y);
        vHem = hem;
        p.y += hem * (uLift * 2.4 + sin(uTime * 0.42 + p.x * 0.55) * 0.42 * hem);
        p.z += hem * sin(uTime * 0.31 + p.x * 0.42 + uv.y * 3.0) * 0.34;
        p.x += hem * cos(uTime * 0.27 + uv.y * 2.4) * 0.12;
        gl_Position = projectionMatrix * modelViewMatrix * vec4(p, 1.0);
      }`,
    fragmentShader: `
      uniform float uOpacity; uniform float uLift;
      varying vec2 vUv; varying float vHem;
      void main(){
        float fade = smoothstep(0.0, 0.34, vUv.y);
        float grad = pow(vUv.y, 1.5);
        float weave = 0.94 + 0.06 * sin(vUv.y * 260.0);
        vec3 col = mix(vec3(0.05,0.07,0.10), vec3(0.92,0.96,1.0), grad) * weave;
        gl_FragColor = vec4(col, fade * uOpacity * (1.0 - vHem * 0.45 * uLift));
      }`,
  });
  wallMat.name = 'released-cloth';

  // four hanging walls — they stop in mid-air; there is no floor mesh at all
  const walls = new THREE.Group(); walls.name = 'hanging-walls';
  const geo = new THREE.PlaneGeometry(17, 11, 30, 44);
  [[0, -8.2, 0], [0, 8.2, Math.PI], [-8.2, 0, Math.PI / 2], [8.2, 0, -Math.PI / 2]].forEach(([x, z, ry], i) => {
    const m = new THREE.Mesh(geo, wallMat);
    m.name = 'wall-' + i;
    m.position.set(x, 1.4, z); m.rotation.y = ry;
    walls.add(m);
  });
  g.add(walls);

  // the ceiling opening — brightness is overhead, not ahead
  const lid = new THREE.Mesh(
    new THREE.RingGeometry(2.2, 9.4, 48, 1),
    new THREE.MeshBasicMaterial({ color: 0xdce7f2, transparent: true, opacity: 0.16, side: THREE.DoubleSide, depthWrite: false, fog: false })
  );
  lid.name = 'ceiling-opening'; lid.rotation.x = -Math.PI / 2; lid.position.y = 7.1; g.add(lid);
  const sky = sprite(glow('lg', 'rgba(255,255,255,1)', 'rgba(160,190,225,0)'), 0xffffff, 26, 0.3);
  sky.position.set(0, 8.6, 0); g.add(sky);

  const above = new THREE.DirectionalLight(0xeaf2fb, 3.4);
  above.position.set(0.5, 12, 1.5); g.add(above);
  g.add(new THREE.AmbientLight(0x33414f, 1.1));

  // everything loose is already on its way up
  const N = 420, SPAN = 26;
  const rise = new THREE.BufferGeometry();
  const rp = new Float32Array(N * 3), rs = new Float32Array(N), rz = new Float32Array(N);
  for (let i = 0; i < N; i++) {
    rp[i * 3] = (Math.random() - 0.5) * 13;
    rp[i * 3 + 1] = (Math.random() - 0.5) * SPAN;
    rp[i * 3 + 2] = (Math.random() - 0.5) * 13;
    rs[i] = Math.random() * 6.28; rz[i] = 1.4 + Math.random() * 3.6;
  }
  rise.setAttribute('position', new THREE.BufferAttribute(rp, 3));
  rise.setAttribute('aSeed', new THREE.BufferAttribute(rs, 1));
  rise.setAttribute('aSize', new THREE.BufferAttribute(rz, 1));
  const riseU = { uTime: { value: 0 }, uSpan: { value: SPAN }, uLift: { value: 0 } };
  const riseMat = new THREE.ShaderMaterial({
    uniforms: riseU, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending,
    vertexShader: `
      attribute float aSeed; attribute float aSize;
      uniform float uTime; uniform float uSpan; uniform float uLift;
      varying float vA;
      void main(){
        vec3 p = position;
        float y = p.y + uTime * (0.34 + uLift * 1.5) + aSeed * 0.9;
        p.y = mod(y + uSpan * 0.5, uSpan) - uSpan * 0.5;
        p.x += sin(uTime * 0.24 + aSeed * 7.0) * 0.5;
        p.z += cos(uTime * 0.19 + aSeed * 5.0) * 0.5;
        vA = smoothstep(uSpan * 0.5, 0.0, abs(p.y)) * 0.6 + 0.4;
        vec4 mv = modelViewMatrix * vec4(p, 1.0);
        gl_PointSize = aSize * (300.0 / max(0.001, -mv.z));
        gl_Position = projectionMatrix * mv;
      }`,
    fragmentShader: `
      varying float vA;
      void main(){
        float d = length(gl_PointCoord - vec2(0.5));
        float a = smoothstep(0.5, 0.02, d);
        gl_FragColor = vec4(vec3(1.0), a * vA * 0.85);
      }`,
  });
  riseMat.name = 'rising-field';
  const field = new THREE.Points(rise, riseMat);
  field.name = 'nothing-falls'; g.add(field);

  // her seat — untethered, drifting up off its own ground
  const seat = new THREE.Mesh(
    new THREE.TorusGeometry(1.6, 0.045, 8, 64),
    new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.6, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
  );
  seat.name = 'unmoored-seat'; seat.rotation.x = Math.PI / 2; g.add(seat);

  return {
    group: g, scene, camera: { pos: [0, 0.2, 3.2], look: [0, 3.4, -6] },
    label: 'the floor has let go',
    update(t) {
      const lift = smooth(t / 62);
      wallUniforms.uTime.value = t;
      wallUniforms.uLift.value = lift;
      riseU.uTime.value = t;
      riseU.uLift.value = lift;
      seat.position.y = -3.4 + lift * 4.2 + Math.sin(t * 0.21) * 0.22;
      seat.material.opacity = 0.6 - lift * 0.28;
      lid.material.opacity = 0.16 + lift * 0.2;
      sky.scale.setScalar(26 + lift * 12);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 6 · GARIMĀ — her ceiling lowers the whole time you are in it and the floor
// thickens into strata beneath you. Leaving costs effort no other room asks.
// TECHNIQUE: procedural displacement mapping for true geometric relief, plus a
// real shadow that grows as the mass descends.
// ══════════════════════════════════════════════════════════════════════════
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

function roomGarima() {
  const g = new THREE.Group();
  const fog = new THREE.FogExp2(0x0b0806, 0.03);
  const scene = { fog, bg: 0x050302 };

  const strata = strataTexture();
  const groundMat = new THREE.MeshStandardMaterial({
    color: 0x8a6636, roughness: 0.95, metalness: 0.05,
    displacementMap: strata, displacementScale: 0.5, displacementBias: -0.2,
    bumpMap: strata, bumpScale: 0.9,
  });
  groundMat.name = 'strata';
  const ground = new THREE.Mesh(new THREE.PlaneGeometry(46, 46, 220, 220), groundMat);
  ground.name = 'thickening-ground';
  ground.rotation.x = -Math.PI / 2; ground.position.y = -5.2;
  ground.receiveShadow = true; g.add(ground);

  // the mass overhead. Real geometry, real shadow, and it is coming down.
  const slabMat = new THREE.MeshStandardMaterial({ color: 0x241a10, roughness: 0.98, metalness: 0.02 });
  slabMat.name = 'descending-mass';
  const slab = new THREE.Mesh(new THREE.BoxGeometry(46, 4.4, 46), slabMat);
  slab.name = 'ceiling'; slab.position.y = 11; slab.castShadow = true; g.add(slab);
  const underMat = new THREE.MeshStandardMaterial({
    color: 0x6b4e2c, roughness: 0.97, metalness: 0.02,
    displacementMap: strata, displacementScale: 0.7, displacementBias: -0.35,
    bumpMap: strata, bumpScale: 1.1,
  });
  underMat.name = 'mass-relief';
  const underside = new THREE.Mesh(new THREE.PlaneGeometry(46, 46, 90, 90), underMat);
  underside.name = 'mass-underside'; underside.rotation.x = Math.PI / 2; g.add(underside);
  const rim = new THREE.Mesh(
    new THREE.BoxGeometry(46.4, 0.16, 46.4),
    new THREE.MeshBasicMaterial({ color: 0xc08a3e, transparent: true, opacity: 0.5, fog: false })
  );
  rim.name = 'mass-rim'; g.add(rim);

  // side walls, so the squeeze is legible
  const wallMat = new THREE.MeshStandardMaterial({ color: 0x50381c, roughness: 0.94, metalness: 0.04, side: THREE.DoubleSide });
  wallMat.name = 'pressed-stone';
  [[-1, 0], [1, 0], [0, -1]].forEach(([sx, sz], i) => {
    const w = new THREE.Mesh(new THREE.PlaneGeometry(46, 22), wallMat);
    w.name = 'wall-' + i;
    if (sx) { w.position.set(sx * 15, 0, 0); w.rotation.y = -sx * Math.PI / 2; }
    else { w.position.set(0, 0, sz * 20); }
    w.receiveShadow = true; g.add(w);
  });

  // the palm-press set into the ground, still glowing
  const press = new THREE.Mesh(
    new THREE.CylinderGeometry(2.1, 2.5, 0.42, 48),
    new THREE.MeshStandardMaterial({ color: 0x8b1a2a, roughness: 0.7, emissive: 0x40060e, emissiveIntensity: 1.2 })
  );
  press.material.name = 'palm-press';
  press.name = 'press'; press.position.set(0, -5.3, -7); press.receiveShadow = true; g.add(press);
  const emberSprite = sprite(glow('gr', 'rgba(232,101,74,1)', 'rgba(139,26,42,0)'), 0xd8452c, 9, 0.42);
  emberSprite.position.set(0, -4.8, -7); g.add(emberSprite);

  const ember = new THREE.PointLight(0xd8452c, 1300, 34, 2);
  ember.position.set(0, -4.2, -7); g.add(ember);
  const raking = new THREE.DirectionalLight(0xffcf92, 3.6);
  raking.position.set(9, 6, 4);
  raking.castShadow = true;
  raking.shadow.mapSize.set(1024, 1024);
  raking.shadow.camera.left = -24; raking.shadow.camera.right = 24;
  raking.shadow.camera.top = 24; raking.shadow.camera.bottom = -24;
  raking.shadow.camera.near = 0.5; raking.shadow.camera.far = 60;
  g.add(raking);
  g.add(new THREE.AmbientLight(0x6b4c2e, 3.2));

  const dust = motes(120, { x: 24, y: 12, z: 26 }, 0xd8b98a, 0.12);
  dust.position.set(0, -1, -4); g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, -0.4, 9.6], look: [0, -2.4, -6] },
    label: 'the ceiling is coming down',
    shadows: true,
    update(t) {
      const k = smooth(t / 62);
      slab.position.y = 11 - k * 7.4;                 // it descends, and holds
      underside.position.y = slab.position.y - 2.21;
      rim.position.y = slab.position.y - 2.2;
      rim.material.opacity = 0.32 + k * 0.4;
      groundMat.displacementScale = 0.5 + k * 1.9;    // the floor thickens
      groundMat.bumpScale = 0.9 + k * 1.6;
      fog.density = 0.03 + k * 0.028;                 // the air thickens too
      ember.intensity = 1300 + Math.sin(t * 0.5) * 130;
      emberSprite.scale.setScalar(9 + Math.sin(t * 0.5) * 0.5 + k * 2);
      raking.intensity = 3.6 - k * 2.0;               // the light is squeezed out
      driftMotes(dust, t, 0.3, 1);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 7 · SARVA-YONI — no entrance. The ceremony finds you already within, because
// no position exists from which you could have arrived.
// TECHNIQUE: MeshPhysicalMaterial transmission + thickness — real refractive
// translucency, with every light source OUTSIDE the membrane.
// ══════════════════════════════════════════════════════════════════════════
function roomYoni() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x1e0708, 0.02), bg: 0x150507 };

  // the vessel. You are inside it, and it has no opening you could pass through.
  const prof = [];
  for (let i = 0; i <= 40; i++) {
    const u = i / 40;
    const r = 7.6 * Math.pow(Math.sin(Math.PI * (0.10 + 0.82 * u)), 0.82);
    prof.push(new THREE.Vector2(Math.max(0.06, r), -9 + 18.4 * u));
  }
  const memMat = new THREE.MeshPhysicalMaterial({
    color: 0xd4795c, roughness: 0.42, metalness: 0,
    transmission: 0.94, thickness: 3.4, ior: 1.38,
    attenuationColor: new THREE.Color(0x8c2e1e), attenuationDistance: 2.6,
    sheen: 0.7, sheenColor: new THREE.Color(0xffc9a8), sheenRoughness: 0.6,
    clearcoat: 0.34, clearcoatRoughness: 0.5,
    side: THREE.DoubleSide, transparent: true, opacity: 1,
  });
  memMat.name = 'membrane';
  const membrane = new THREE.Mesh(new THREE.LatheGeometry(prof, 72), memMat);
  membrane.name = 'vessel'; g.add(membrane);

  // veins, running down the inside — they were always there
  const veins = new THREE.Group(); veins.name = 'veins';
  for (let i = 0; i < 9; i++) {
    const a0 = (i / 9) * Math.PI * 2;
    const pts = [];
    for (let k = 0; k <= 12; k++) {
      const u = k / 12;
      const r = 7.2 * Math.pow(Math.sin(Math.PI * (0.12 + 0.78 * (1 - u))), 0.82) * 0.94;
      const a = a0 + Math.sin(u * 3.1 + i) * 0.16;
      pts.push(new THREE.Vector3(Math.cos(a) * r, 8.4 - 17 * u, Math.sin(a) * r));
    }
    const tube = new THREE.Mesh(
      new THREE.TubeGeometry(new THREE.CatmullRomCurve3(pts), 44, 0.035 + Math.random() * 0.03, 6, false),
      new THREE.MeshBasicMaterial({ color: 0xffb894, transparent: true, opacity: 0.42, blending: THREE.AdditiveBlending, depthWrite: false, fog: false })
    );
    tube.name = 'vein-' + i; veins.add(tube);
  }
  g.add(veins);

  // her aperture — the downward triangle, low in the vessel
  const tri = new THREE.Shape();
  tri.moveTo(-2.4, 1.5); tri.lineTo(2.4, 1.5); tri.lineTo(0, -2.6); tri.closePath();
  const yoni = new THREE.Mesh(
    new THREE.ShapeGeometry(tri),
    new THREE.MeshBasicMaterial({ color: 0xfff2e4, transparent: true, opacity: 0.86, side: THREE.DoubleSide, fog: false })
  );
  yoni.name = 'source-aperture'; yoni.position.set(0, -3.4, -5.4); g.add(yoni);
  const yoniGlow = sprite(glow('yo', 'rgba(255,226,200,1)', 'rgba(200,84,56,0)'), 0xffd9bc, 15, 0.5);
  yoniGlow.position.set(0, -3.2, -5.2); g.add(yoniGlow);

  // every source is beyond the membrane — that is what makes it read as flesh
  const outside = new THREE.Group(); outside.name = 'light-beyond';
  const lamps = [
    [0, 6, -13, 0xffc79e, 900], [-12, 1, -6, 0xff9a70, 700],
    [12, 1, -6, 0xff9a70, 700], [0, -8, -11, 0xffd9bc, 520], [0, 3, 13, 0xe8845c, 420],
  ].map(([x, y, z, c, p]) => {
    const l = new THREE.PointLight(c, p * 0.6, 48, 2);
    l.position.set(x, y, z); outside.add(l); return l;
  });
  g.add(outside);
  const inner = new THREE.PointLight(0xffd9bc, 130, 20, 2);
  inner.position.set(0, -2.4, -3.4); g.add(inner);
  g.add(new THREE.AmbientLight(0x4a1a14, 1.6));

  const dust = motes(90, { x: 11, y: 14, z: 11 }, 0xffe8d4, 0.11);
  g.add(dust);

  return {
    group: g, scene, camera: { pos: [0, 0.6, 5.2], look: [0, -2.4, -5.4] },
    label: 'no door · you were always inside',
    update(t) {
      // it moves with your own breath
      const br = Math.sin(t * 0.28);
      membrane.scale.set(1 + br * 0.032, 1 - br * 0.02, 1 + br * 0.032);
      veins.scale.copy(membrane.scale);
      memMat.thickness = 3.4 + br * 0.7;
      memMat.attenuationDistance = 2.6 + br * 0.35;
      const k = smooth(t / 62);
      lamps.forEach((l, i) => { l.intensity = (i === 0 ? 900 : i === 4 ? 420 : 700) * 0.6 * (0.62 + 0.5 * k) * (1 + br * 0.06); });
      yoni.material.opacity = 0.5 + 0.4 * k;
      yoniGlow.scale.setScalar(15 + k * 7 + br * 0.6);
      veins.children.forEach((v, i) => { v.material.opacity = 0.16 + 0.36 * k * (0.7 + 0.3 * Math.sin(t * 0.3 + i)); });
      driftMotes(dust, t, 0.36);
    },
  };
}

// ══════════════════════════════════════════════════════════════════════════
// 8 · SARVA-TRIKHAṆḌĀ — three rooms occupy the same place. Move and they part
// into three; hold still and they slide into one, and it was always one room.
// TECHNIQUE: the room is rendered three times from three vantages into three
// render targets, then composited one per channel. Convergence to a single
// white room is computed, not drawn.
// ══════════════════════════════════════════════════════════════════════════
function roomTrikhanda() {
  const g = new THREE.Group();
  const scene = { fog: new THREE.FogExp2(0x0a0a12, 0.022), bg: 0x040308 };

  // one neutral, bright room — so each pass yields a strong single-channel copy
  const stone = new THREE.MeshStandardMaterial({ color: 0x585874, roughness: 0.88, metalness: 0.04, side: THREE.BackSide });
  stone.name = 'seal-stone';
  const shell = new THREE.Mesh(new THREE.BoxGeometry(13, 11, 30), stone);
  shell.name = 'chamber'; g.add(shell);

  const edges = new THREE.LineSegments(
    new THREE.EdgesGeometry(new THREE.BoxGeometry(13, 11, 30)),
    new THREE.LineBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.95, depthWrite: false })
  );
  edges.name = 'seams'; g.add(edges);
  // the seat's own frame, so there is structure to mis-register
  const frame = new THREE.LineSegments(
    new THREE.EdgesGeometry(new THREE.BoxGeometry(6.4, 6.4, 0.1)),
    new THREE.LineBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.9, depthWrite: false })
  );
  frame.name = 'seat-frame'; frame.position.set(0, 0, -12.6); g.add(frame);
  const grid = new THREE.Group(); grid.name = 'floor-grid';
  for (let i = -6; i <= 6; i += 2) {
    const ln = new THREE.Line(
      new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(i, -5.4, 14), new THREE.Vector3(i, -5.4, -15)]),
      new THREE.LineBasicMaterial({ color: 0xdfe4ff, transparent: true, opacity: 0.5, depthWrite: false })
    );
    grid.add(ln);
  }
  g.add(grid);

  // the three seals that become one
  const seals = new THREE.Group(); seals.name = 'three-seals';
  for (let i = 0; i < 3; i++) {
    const s = new THREE.Group();
    s.add(sprite(glow('tk', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 2.4, 0.8));
    const core = new THREE.Mesh(new THREE.SphereGeometry(0.16, 20, 14), new THREE.MeshBasicMaterial({ color: 0xffffff }));
    core.name = 'seal-' + i; s.add(core);
    seals.add(s);
  }
  seals.position.set(0, 0, -11); g.add(seals);

  const far = new THREE.Mesh(
    new THREE.PlaneGeometry(5.2, 5.2),
    new THREE.MeshBasicMaterial({ color: 0xffffff, transparent: true, opacity: 0.14, fog: false })
  );
  far.name = 'far-light'; far.position.set(0, 0, -14.8); g.add(far);

  const key = new THREE.PointLight(0xffffff, 560, 40, 2);
  key.position.set(0, 1.2, -10); g.add(key);
  const wash = new THREE.PointLight(0xd8d8f0, 240, 34, 2);
  wash.position.set(0, 0, 4); g.add(wash);
  g.add(new THREE.AmbientLight(0xa8b0d8, 1.15));

  // ── the three exposures ───────────────────────────────────────────────
  const opts = { depthBuffer: true, stencilBuffer: false, samples: 0 };
  const rts = [0, 1, 2].map(() => {
    const rt = new THREE.WebGLRenderTarget(2, 2, opts);
    rt.texture.colorSpace = THREE.SRGBColorSpace;
    rt.texture.minFilter = THREE.LinearFilter;
    rt.texture.magFilter = THREE.LinearFilter;
    return rt;
  });
  const quadScene = new THREE.Scene();
  const quadCam = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
  const compMat = new THREE.ShaderMaterial({
    uniforms: { tA: { value: null }, tB: { value: null }, tC: { value: null }, uSep: { value: 1 } },
    vertexShader: `
      varying vec2 vUv;
      void main(){ vUv = uv; gl_Position = vec4(position.xy, 0.0, 1.0); }`,
    fragmentShader: `
      uniform sampler2D tA; uniform sampler2D tB; uniform sampler2D tC;
      uniform float uSep;
      varying vec2 vUv;
      void main(){
        vec3 a = texture2D(tA, vUv).rgb;
        vec3 b = texture2D(tB, vUv).rgb;
        vec3 c = texture2D(tC, vUv).rgb;
        // each exposure carries one channel: separated they are three coloured
        // rooms; identical they sum back to the one white room.
        vec3 sep = vec3(a.r, b.g, c.b);
        vec3 one = (a + b + c) / 3.0;
        gl_FragColor = vec4(mix(one, sep, uSep), 1.0);
      }`,
  });
  compMat.name = 'triple-exposure';
  const quad = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), compMat);
  quad.name = 'composite'; quad.frustumCulled = false;
  quadScene.add(quad);

  let sep = 1;
  const offs = [[-1, -0.42], [1, -0.22], [0.06, 1]];
  const p0 = new THREE.Vector3(), q0 = new THREE.Quaternion();

  return {
    group: g, scene, camera: { pos: [0, 0, 9], look: [0, 0, -8] },
    label: 'three rooms · one seal, only in stillness',
    update(t) {
      sep = 1 - smooth(t / 62);
      compMat.uniforms.uSep.value = sep;
      seals.children.forEach((s, i) => {
        const a = (i / 3) * Math.PI * 2 - Math.PI / 2;
        const d = sep * 1.5;
        s.position.set(Math.cos(a) * d, Math.sin(a) * d, 0);
        s.scale.setScalar(1 + (1 - sep) * 0.7);
      });
      far.material.opacity = 0.1 + (1 - sep) * 0.16;
      edges.material.opacity = 0.62 + (1 - sep) * 0.34;
      frame.material.opacity = 0.55 + (1 - sep) * 0.34;
    },
    render(renderer, sceneRef, camera) {
      const gl = renderer.getContext();
      const w = gl.drawingBufferWidth, h = gl.drawingBufferHeight;
      for (const rt of rts) if (rt.width !== w || rt.height !== h) rt.setSize(w, h);
      p0.copy(camera.position); q0.copy(camera.quaternion);
      for (let k = 0; k < 3; k++) {
        camera.position.set(p0.x + offs[k][0] * sep * 0.52, p0.y + offs[k][1] * sep * 0.46, p0.z);
        camera.quaternion.copy(q0);
        camera.rotateY(offs[k][0] * sep * 0.014);
        camera.rotateX(offs[k][1] * sep * 0.011);
        renderer.setRenderTarget(rts[k]);
        renderer.clear();
        renderer.render(sceneRef, camera);
      }
      renderer.setRenderTarget(null);
      camera.position.copy(p0); camera.quaternion.copy(q0);
      compMat.uniforms.tA.value = rts[0].texture;
      compMat.uniforms.tB.value = rts[1].texture;
      compMat.uniforms.tC.value = rts[2].texture;
      renderer.render(quadScene, quadCam);
    },
    dispose() {
      rts.forEach((rt) => rt.dispose());
      quad.geometry.dispose(); compMat.dispose();
    },
  };
}

export const ROOMS_2 = [
  { id: 'laghima', name: 'Laghimā', quality: 'Lightness', ring: 1, build: roomLaghima,
    mech: 'The floor has released. Her walls end before they reach the ground and their hems lift though there is no wind — everything loose is already on its way up. Nothing in this room falls.' },
  { id: 'garima', name: 'Garimā', quality: 'Weightedness', ring: 1, build: roomGarima,
    mech: 'Her ceiling lowers the entire time you are in it, casting its own weight as shadow, while the floor thickens into strata beneath you. Leaving costs effort no other room asks for.' },
  { id: 'yoni', name: 'Sarva-Yoni', quality: 'Source', ring: 1, build: roomYoni,
    mech: 'There is no entrance. The ceremony finds you already within, because no position exists from which you could have arrived. The walls are membrane rather than stone — lit from behind, veined, moving with your breath.' },
  { id: 'trikhanda', name: 'Sarva-Trikhaṇḍā', quality: 'Trinity-as-Unity', ring: 1, build: roomTrikhanda,
    mech: 'Three rooms occupy the same place, mis-registered like a triple exposure. Move and they part into three. Hold still and they slide into register — one white room, and it was always one room.' },
];
