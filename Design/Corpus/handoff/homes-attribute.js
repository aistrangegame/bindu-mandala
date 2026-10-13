// homes-attribute.js — her attribute, as the room's one actor.
//
// The brief: "every colour word, every held object, every posture is a design
// instruction." So her held object is not shown to you — it PERFORMS. A noose
// draws the vast into the tiny. A cup fills and is drunk. Five arrows strike the
// five gates in turn. A skull-cup receives what has ended. A sceptre barely moves.
//
// Aniconic throughout: these are shapes doing one thing, never figures.

import * as THREE from 'three';
import { glow, sprite, smooth, clamp01 } from './homes-3d-core.js';
import { ATTRIBUTE, ATTR_TINT, bodyAltitude } from './homes-cards.js?v=5';

const TAU = Math.PI * 2;
const HOLD_END = 227, SECOND = 120;
const deep = (t) => smooth((t - HOLD_END) / SECOND);

const lineMat = (col, o = 0.7) => new THREE.LineBasicMaterial({
  color: col, transparent: true, opacity: o, blending: THREE.AdditiveBlending, depthWrite: false,
});
const solidMat = (col, e = 1.6) => {
  const m = new THREE.MeshStandardMaterial({
    color: col, roughness: 0.38, metalness: 0.12,
    emissive: new THREE.Color(col), emissiveIntensity: e,
  });
  m.name = 'attribute';
  return m;
};
const addMat = (col, o = 0.6) => new THREE.MeshBasicMaterial({
  color: col, transparent: true, opacity: o, blending: THREE.AdditiveBlending, depthWrite: false, fog: false,
});

// ── the forms, each with its one action ───────────────────────────────────
const FORMS = {
  // draws the vast into the tiny
  noose(col) {
    const g = new THREE.Group();
    const ring = new THREE.Mesh(new THREE.TorusGeometry(1, 0.045, 8, 64), solidMat(col));
    g.add(ring);
    const caught = sprite(glow('at_n', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 1.6, 0.7);
    g.add(caught);
    return { g, act(t) {
      const u = (t * 0.09) % 1;                  // cast, close, draw home
      const cast = smooth(clamp01(u / 0.34));
      const close = smooth(clamp01((u - 0.34) / 0.3));
      const draw = smooth(clamp01((u - 0.62) / 0.38));
      const r = 0.6 + cast * 3.2 - close * 2.2;
      ring.scale.setScalar(r * (1 - draw * 0.82));
      ring.position.z = -cast * 3.4 + draw * 3.2;
      caught.position.z = ring.position.z;
      caught.scale.setScalar((0.4 + cast * 1.4) * (1 - draw * 0.7));
      caught.material.opacity = 0.2 + close * 0.6;
      ring.rotation.x = 0.3 + Math.sin(t * 0.2) * 0.1;
    } };
  },
  // hooks what wanders and steers it back
  goad(col) {
    const g = new THREE.Group();
    const shaft = new THREE.Mesh(new THREE.CylinderGeometry(0.035, 0.045, 2.6, 8), solidMat(col));
    shaft.rotation.z = 0.3; g.add(shaft);
    const curve = new THREE.CatmullRomCurve3([
      new THREE.Vector3(0.28, 1.3, 0), new THREE.Vector3(0.72, 1.6, 0),
      new THREE.Vector3(0.86, 1.16, 0), new THREE.Vector3(0.5, 1.0, 0),
    ]);
    const hook = new THREE.Mesh(new THREE.TubeGeometry(curve, 24, 0.04, 6, false), solidMat(col));
    g.add(hook);
    const pulled = sprite(glow('at_g', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 1, 0.5);
    g.add(pulled);
    return { g, act(t) {
      const u = (t * 0.13) % 1;
      const reach = smooth(clamp01(u / 0.4)), pull = smooth(clamp01((u - 0.45) / 0.55));
      g.rotation.z = -0.2 + reach * 0.34 - pull * 0.2;
      pulled.position.set(0.7, 1.3, -reach * 2.8 + pull * 2.6);
      pulled.material.opacity = 0.2 + reach * 0.5;
    } };
  },
  // fills, and is drunk
  cup(col) {
    const g = new THREE.Group();
    const bowl = new THREE.Mesh(new THREE.LatheGeometry(
      [[0.06, 0], [0.5, 0.06], [0.62, 0.36], [0.66, 0.62], [0.62, 0.64], [0.56, 0.4], [0.44, 0.1], [0.04, 0.04]]
        .map(([x, y]) => new THREE.Vector2(x, y)), 36), solidMat(col, 0.7));
    g.add(bowl);
    const nectar = new THREE.Mesh(new THREE.CircleGeometry(0.54, 32), addMat(col, 0.8));
    nectar.rotation.x = -Math.PI / 2; g.add(nectar);
    return { g, act(t) {
      const u = (t * 0.055) % 1;
      const fill = smooth(clamp01(u / 0.55)), drunk = smooth(clamp01((u - 0.62) / 0.38));
      const level = 0.1 + fill * 0.44 - drunk * 0.44;
      nectar.position.y = level;
      nectar.scale.setScalar(0.9 + level * 0.3);
      nectar.material.opacity = 0.3 + fill * 0.5 - drunk * 0.3;
      g.rotation.z = drunk * 0.34;
    } };
  },
  // strikes the five gates in turn
  arrows(col) {
    const g = new THREE.Group();
    const shafts = [];
    for (let i = 0; i < 5; i++) {
      const s = new THREE.Group();
      const rod = new THREE.Mesh(new THREE.CylinderGeometry(0.02, 0.02, 1.8, 6), solidMat(col));
      rod.rotation.x = Math.PI / 2; s.add(rod);
      const tip = sprite(glow('at_a', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 0.7, 0.8);
      tip.position.z = -0.95; s.add(tip);
      const a = -0.9 + (i / 4) * 1.8;
      s.userData = { a, i };
      s.position.set(Math.sin(a) * 0.42, Math.cos(a) * 0.2, 0);
      s.rotation.y = a * 0.5;
      shafts.push(s); g.add(s);
    }
    return { g, act(t) {
      shafts.forEach((s) => {
        const u = ((t * 0.16 + s.userData.i / 5) % 1);
        const fly = Math.pow(clamp01(u / 0.3), 0.6), back = smooth(clamp01((u - 0.42) / 0.58));
        s.position.z = -fly * 4.2 * (1 - back);
        s.children[1].material.opacity = (0.3 + fly * 0.6) * (1 - back * 0.7);
      });
    } };
  },
  // draws, holds the tension, releases
  bow(col) {
    const g = new THREE.Group();
    const pts = [];
    for (let i = 0; i <= 20; i++) {
      const u = i / 20;
      pts.push(new THREE.Vector3(Math.sin((u - 0.5) * 2.2) * 1.5, (u - 0.5) * 2.6, Math.cos((u - 0.5) * 2.2) * 0.4 - 0.4));
    }
    const stave = new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(pts), 30, 0.04, 6, false), solidMat(col, 0.9));
    g.add(stave);
    const str = new THREE.BufferGeometry().setFromPoints([pts[0], new THREE.Vector3(0, 0, 0), pts[20]]);
    const string = new THREE.Line(str, lineMat(col, 0.8));
    g.add(string);
    return { g, act(t) {
      const u = (t * 0.075) % 1;
      const draw = smooth(clamp01(u / 0.62)), loose = clamp01((u - 0.7) / 0.08);
      const z = draw * 1.5 * (1 - loose);
      string.geometry.setFromPoints([pts[0], new THREE.Vector3(0, 0, z), pts[20]]);
      g.rotation.y = Math.sin(t * 0.05) * 0.14;
      stave.scale.x = 1 - draw * 0.06 * (1 - loose);
    } };
  },
  // returns your own light to you
  mirror(col) {
    const g = new THREE.Group();
    const disc = new THREE.Mesh(new THREE.CircleGeometry(0.78, 48),
      new THREE.MeshStandardMaterial({ color: 0xffffff, roughness: 0.06, metalness: 1 }));
    disc.material.name = 'mirror'; g.add(disc);
    const rim = new THREE.Mesh(new THREE.TorusGeometry(0.8, 0.03, 8, 48), solidMat(col)); g.add(rim);
    const back = sprite(glow('at_m', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 2, 0);
    back.position.z = 0.5; g.add(back);
    return { g, act(t) {
      g.rotation.y = Math.sin(t * 0.06) * 0.7;
      const face = Math.pow(Math.max(0, Math.cos(g.rotation.y)), 6);
      back.material.opacity = face * 0.65;
      back.scale.setScalar(2 + face * 2.4);
    } };
  },
  // opens
  lotus(col) {
    const g = new THREE.Group();
    const petals = [];
    for (let i = 0; i < 8; i++) {
      const a = (i / 8) * TAU;
      const shape = new THREE.Shape();
      shape.moveTo(0, 0); shape.quadraticCurveTo(0.3, 0.5, 0, 1.05); shape.quadraticCurveTo(-0.3, 0.5, 0, 0);
      const p = new THREE.Mesh(new THREE.ShapeGeometry(shape), addMat(col, 0.4));
      p.material.side = THREE.DoubleSide;
      p.rotation.y = a; p.userData = { a };
      petals.push(p); g.add(p);
    }
    const heart = sprite(glow('at_l', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 0.9, 0.6);
    g.add(heart);
    return { g, act(t) {
      const open = 0.5 + 0.5 * Math.sin(t * 0.07);
      petals.forEach((p) => { p.rotation.x = -0.15 - open * 1.05; });
      heart.scale.setScalar(0.6 + open * 0.8);
      heart.material.opacity = 0.3 + open * 0.5;
    } };
  },
  // burns at the brow
  flame(col) {
    const g = new THREE.Group();
    const body = new THREE.Mesh(new THREE.ConeGeometry(0.3, 1.1, 16, 1, true), addMat(col, 0.55));
    body.position.y = 0.5; g.add(body);
    const halo = sprite(glow('at_f', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 2, 0.4);
    halo.position.y = 0.5; g.add(halo);
    return { g, act(t) {
      const f = Math.sin(t * 3.1) * 0.5 + Math.sin(t * 5.3) * 0.3 + Math.sin(t * 1.7) * 0.2;
      body.scale.set(1 + f * 0.08, 1 + f * 0.16, 1 + f * 0.08);
      body.rotation.z = f * 0.06;
      halo.scale.setScalar(2 + f * 0.4);
      halo.material.opacity = 0.34 + Math.abs(f) * 0.14;
    } };
  },
  // tells its own beads, one at a time
  rosary(col) {
    const g = new THREE.Group();
    const beads = [];
    const N = 27;
    for (let i = 0; i < N; i++) {
      const a = (i / N) * TAU;
      const b = new THREE.Mesh(new THREE.SphereGeometry(0.055, 10, 8), solidMat(col, 0.6));
      b.position.set(Math.cos(a) * 1.05, Math.sin(a) * 1.05, 0);
      b.userData = { i };
      beads.push(b); g.add(b);
    }
    return { g, act(t) {
      const at = (t * 0.6) % N;
      beads.forEach((b) => {
        const d = Math.min(Math.abs(b.userData.i - at), N - Math.abs(b.userData.i - at));
        const near = Math.max(0, 1 - d / 2);
        b.material.emissiveIntensity = 0.5 + near * 4;
        b.scale.setScalar(1 + near * 0.5);
      });
      g.rotation.z = -t * 0.012;
    } };
  },
  // holds three as one
  trident(col) {
    const g = new THREE.Group();
    const shaft = new THREE.Mesh(new THREE.CylinderGeometry(0.035, 0.04, 2.4, 8), solidMat(col)); g.add(shaft);
    const prongs = [-0.34, 0, 0.34].map((x, i) => {
      const p = new THREE.Mesh(new THREE.ConeGeometry(0.06, 0.8, 8), solidMat(col));
      p.position.set(x, 1.5, 0); g.add(p); return p;
    });
    return { g, act(t) {
      prongs.forEach((p, i) => {
        const u = ((t * 0.14 + i / 3) % 1);
        const lift = Math.pow(Math.max(0, Math.sin(Math.PI * u)), 3);
        p.position.y = 1.5 + lift * 0.24;
        p.material.emissiveIntensity = 1.2 + lift * 2.6;
      });
    } };
  },
  // strikes, and is irreversible
  vajra(col) {
    const g = new THREE.Group();
    const core = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.06, 1, 8), solidMat(col));
    core.rotation.z = Math.PI / 2; g.add(core);
    const ends = [-1, 1].map((s) => {
      const e = new THREE.Group();
      for (let i = 0; i < 4; i++) {
        const a = (i / 4) * TAU;
        const pr = new THREE.Mesh(new THREE.ConeGeometry(0.05, 0.5, 6), solidMat(col));
        pr.position.set(s * 0.75, Math.cos(a) * 0.16, Math.sin(a) * 0.16);
        pr.rotation.z = -s * Math.PI / 2;
        e.add(pr);
      }
      g.add(e); return e;
    });
    const strike = sprite(glow('at_v', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 3, 0);
    g.add(strike);
    return { g, act(t) {
      const u = (t * 0.11) % 1;
      const flash = Math.pow(clamp01(1 - u / 0.06), 2);
      strike.material.opacity = flash * 0.9;
      strike.scale.setScalar(2 + flash * 5);
      core.material.emissiveIntensity = 1.4 + flash * 6;
      ends.forEach((e, i) => { e.rotation.x = (i ? 1 : -1) * t * 0.2; });
    } };
  },
  // receives what has ended
  skullcup(col) {
    const g = new THREE.Group();
    const bowl = new THREE.Mesh(new THREE.SphereGeometry(0.62, 28, 18, 0, TAU, Math.PI * 0.52, Math.PI * 0.48),
      solidMat(col, 0.4));
    bowl.material.side = THREE.DoubleSide; g.add(bowl);
    const held = new THREE.Mesh(new THREE.CircleGeometry(0.5, 28), addMat(0x000000, 0.55));
    held.rotation.x = -Math.PI / 2; held.position.y = -0.06; g.add(held);
    const ring = new THREE.Mesh(new THREE.TorusGeometry(0.52, 0.02, 6, 40), addMat(col, 0.5));
    ring.rotation.x = Math.PI / 2; g.add(ring);
    return { g, act(t) {
      const u = (t * 0.048) % 1;
      held.scale.setScalar(0.6 + u * 0.5);
      held.material.opacity = 0.2 + u * 0.5;
      ring.material.opacity = 0.24 + (1 - u) * 0.4;
      g.rotation.y = t * 0.03;
    } };
  },
  // turns what is buried up into the light
  plough(col) {
    const g = new THREE.Group();
    const beam = new THREE.Mesh(new THREE.BoxGeometry(1.9, 0.07, 0.07), solidMat(col, 0.8));
    beam.rotation.z = -0.24; g.add(beam);
    const share = new THREE.Mesh(new THREE.ConeGeometry(0.2, 0.6, 4), solidMat(col, 0.9));
    share.position.set(-0.85, -0.4, 0); share.rotation.z = Math.PI * 0.6; g.add(share);
    const furrow = [];
    for (let i = 0; i < 9; i++) {
      const s = sprite(glow('at_p', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 0.5, 0);
      furrow.push(s); g.add(s);
    }
    return { g, act(t) {
      const u = (t * 0.07) % 1;
      g.position.x = -1.4 + u * 2.8;
      furrow.forEach((s, i) => {
        const age = (u - i / 12 + 1) % 1;
        s.position.set(-0.85 - (u * 2.8) + i * 0.3, -0.4 + age * 0.9, 0);
        s.material.opacity = Math.max(0, 0.5 - age * 0.5);
        s.scale.setScalar(0.4 + age * 0.5);
      });
    } };
  },
  // holds level, and is unhurried
  sceptre(col) {
    const g = new THREE.Group();
    const rod = new THREE.Mesh(new THREE.CylinderGeometry(0.05, 0.055, 2.2, 10), solidMat(col, 0.8));
    g.add(rod);
    const head = new THREE.Mesh(new THREE.OctahedronGeometry(0.22, 0), solidMat(col, 1.6));
    head.position.y = 1.24; g.add(head);
    return { g, act(t) {
      // the quiet authority of the one who need not raise her voice
      g.rotation.z = Math.sin(t * 0.022) * 0.012;
      head.rotation.y = t * 0.05;
      head.material.emissiveIntensity = 1.4 + 0.25 * Math.sin(t * 0.09);
    } };
  },
  // weaves, and lengthens
  garland(col) {
    const g = new THREE.Group();
    const flowers = [];
    for (let i = 0; i < 20; i++) {
      const f = sprite(glow('at_ga', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 0.42, 0.6);
      f.userData = { i };
      flowers.push(f); g.add(f);
    }
    return { g, act(t) {
      const grown = 6 + ((t * 0.5) % 15);
      flowers.forEach((f, i) => {
        const on = i < grown;
        const a = (i / 20) * TAU * 1.4;
        f.position.set(Math.cos(a) * 1.05, Math.sin(a) * 0.5 - i * 0.012, Math.sin(a) * 0.3);
        f.material.opacity = on ? 0.5 : 0;
        f.scale.setScalar(on ? 0.42 : 0.01);
      });
      g.rotation.z = Math.sin(t * 0.04) * 0.1;
    } };
  },
  // holds all potential, folded and unspent
  seed(col) {
    const g = new THREE.Group();
    const husk = new THREE.Mesh(new THREE.SphereGeometry(0.42, 28, 20), solidMat(col, 0.5));
    g.add(husk);
    const inner = sprite(glow('at_s', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 0.7, 0.35);
    g.add(inner);
    return { g, act(t) {
      // it never opens; it only becomes denser
      const b = 0.5 + 0.5 * Math.sin(t * 0.05);
      husk.scale.setScalar(1 - b * 0.06);
      inner.material.opacity = 0.2 + b * 0.34;
      inner.scale.setScalar(0.5 + b * 0.34);
      g.rotation.y = t * 0.02;
    } };
  },
  // grants, exactly what was asked
  gem(col) {
    const g = new THREE.Group();
    const stone = new THREE.Mesh(new THREE.OctahedronGeometry(0.44, 0),
      new THREE.MeshPhysicalMaterial({
        color: 0xffffff, roughness: 0.02, metalness: 0, transmission: 0.95,
        thickness: 1.1, ior: 2.2, dispersion: 6,
      }));
    stone.material.name = 'wish-gem'; g.add(stone);
    const grant = sprite(glow('at_ge', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 1.4, 0.3);
    g.add(grant);
    return { g, act(t) {
      stone.rotation.set(t * 0.08, t * 0.12, 0);
      const give = Math.pow(0.5 + 0.5 * Math.sin(t * 0.09), 3);
      grant.scale.setScalar(1.2 + give * 4);
      grant.material.opacity = 0.16 + give * 0.42;
    } };
  },
  // overflows, and cannot be contained
  grain(col) {
    const g = new THREE.Group();
    const heap = new THREE.Mesh(new THREE.ConeGeometry(0.7, 0.5, 24), solidMat(col, 0.5));
    heap.position.y = -0.5; g.add(heap);
    const falling = [];
    for (let i = 0; i < 26; i++) {
      const s = sprite(glow('at_gr', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 0.2, 0.7);
      s.userData = { seed: Math.random(), a: Math.random() * TAU };
      falling.push(s); g.add(s);
    }
    return { g, act(t) {
      falling.forEach((s) => {
        const u = ((t * 0.28 + s.userData.seed) % 1);
        const r = 0.14 + u * 0.7;
        s.position.set(Math.cos(s.userData.a) * r, 0.7 - u * 1.2, Math.sin(s.userData.a) * r);
        s.material.opacity = 0.7 * (1 - u * 0.7);
      });
    } };
  },
  // blesses whatever it touches
  lamp(col) {
    const g = new THREE.Group();
    const dish = new THREE.Mesh(new THREE.LatheGeometry(
      [[0.05, 0], [0.44, 0.04], [0.5, 0.2], [0.42, 0.2], [0.34, 0.06], [0.04, 0.02]]
        .map(([x, y]) => new THREE.Vector2(x, y)), 28), solidMat(col, 0.6));
    g.add(dish);
    const wick = sprite(glow('at_la', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffe2a8, 1, 0.85);
    wick.position.y = 0.34; g.add(wick);
    return { g, act(t) {
      const f = 1 + Math.sin(t * 2.6) * 0.05 + Math.sin(t * 4.1) * 0.03;
      wick.scale.setScalar(f);
      wick.position.x = Math.sin(t * 1.9) * 0.012;
      g.rotation.y = Math.sin(t * 0.03) * 0.24;
    } };
  },
  // unbinds, and the links fall open
  chain(col) {
    const g = new THREE.Group();
    const links = [];
    for (let i = 0; i < 7; i++) {
      const l = new THREE.Mesh(new THREE.TorusGeometry(0.16, 0.032, 8, 24), solidMat(col, 0.7));
      l.position.y = 0.9 - i * 0.3;
      l.rotation.y = i % 2 ? Math.PI / 2 : 0;
      l.userData = { i };
      links.push(l); g.add(l);
    }
    return { g, act(t) {
      const u = (t * 0.06) % 1;
      links.forEach((l) => {
        const i = l.userData.i;
        const gone = clamp01((u - i / 9) * 6);
        l.position.y = 0.9 - i * 0.3 - gone * gone * 3.4;
        l.rotation.z = gone * 2.2;
        l.material.opacity = 1 - gone;
        l.material.transparent = gone > 0.01;
      });
    } };
  },
  // mends what was broken
  herb(col) {
    const g = new THREE.Group();
    const stem = new THREE.Mesh(new THREE.CylinderGeometry(0.018, 0.024, 1.3, 6), solidMat(col, 0.8)); g.add(stem);
    const leaves = [];
    for (let i = 0; i < 6; i++) {
      const s = new THREE.Mesh(new THREE.CircleGeometry(0.17, 12), addMat(col, 0.5));
      s.material.side = THREE.DoubleSide;
      const y = -0.4 + i * 0.24;
      s.position.set((i % 2 ? 0.18 : -0.18), y, 0);
      s.rotation.set(0, 0, (i % 2 ? -0.6 : 0.6));
      s.userData = { i };
      leaves.push(s); g.add(s);
    }
    return { g, act(t) {
      leaves.forEach((l) => {
        const u = ((t * 0.2 + l.userData.i / 6) % 1);
        const heal = Math.pow(Math.max(0, Math.sin(Math.PI * u)), 4);
        l.material.opacity = 0.3 + heal * 0.5;
        l.scale.setScalar(1 + heal * 0.28);
      });
    } };
  },
  // bears everything without strain
  ground(col) {
    const g = new THREE.Group();
    const slab = new THREE.Mesh(new THREE.CylinderGeometry(1.1, 1.2, 0.16, 6), solidMat(col, 0.4));
    g.add(slab);
    const load = sprite(glow('at_gd', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 1.4, 0.3);
    load.position.y = 0.7; g.add(load);
    return { g, act(t) {
      // it does not yield; only the load breathes
      load.position.y = 0.7 + Math.sin(t * 0.09) * 0.1;
      load.material.opacity = 0.22 + 0.12 * Math.sin(t * 0.09);
      slab.scale.y = 1;
    } };
  },
  // she is the radiance; there is nothing held
  radiance(col) {
    const g = new THREE.Group();
    const core = sprite(glow('at_r1', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), 0xffffff, 1.2, 0.85);
    const halo = sprite(glow('at_r2', 'rgba(255,255,255,1)', 'rgba(255,255,255,0)'), col, 4, 0.3);
    g.add(core); g.add(halo);
    return { g, act(t) {
      const b = 0.5 + 0.5 * Math.sin(t * 0.075);
      core.scale.setScalar(1 + b * 0.4);
      halo.scale.setScalar(3.4 + b * 2.4);
      halo.material.opacity = 0.2 + b * 0.22;
    } };
  },
  // a gesture, when her card names a gesture and not an object
  seal(col) {
    const g = new THREE.Group();
    const digits = [];
    for (let i = 0; i < 5; i++) {
      const a = -0.7 + (i / 4) * 1.4;
      const d = new THREE.Mesh(new THREE.CapsuleGeometry(0.045, 0.72, 4, 8), solidMat(col, 0.7));
      d.position.set(Math.sin(a) * 0.5, 0.4 + Math.cos(a) * 0.16, 0);
      d.rotation.z = -a * 0.8;
      d.userData = { i, a };
      digits.push(d); g.add(d);
    }
    return { g, act(t) {
      digits.forEach((d) => {
        const u = ((t * 0.18 + d.userData.i / 5) % 1);
        const fold = Math.pow(Math.max(0, Math.sin(Math.PI * u)), 2);
        d.rotation.x = fold * 0.9;
        d.material.emissiveIntensity = 0.6 + fold * 1.6;
      });
      g.rotation.y = Math.sin(t * 0.05) * 0.2;
    } };
  },
  // an open palm, which is also an answer
  palm(col) {
    const g = new THREE.Group();
    const plate = new THREE.Mesh(new THREE.CircleGeometry(0.6, 32), addMat(col, 0.4));
    plate.material.side = THREE.DoubleSide;
    plate.rotation.x = -0.4; g.add(plate);
    const lines = new THREE.Group();
    for (let i = 0; i < 3; i++) {
      const geo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(-0.4 + i * 0.1, -0.3 + i * 0.24, 0.01),
        new THREE.Vector3(0.34 - i * 0.12, -0.1 + i * 0.26, 0.01),
      ]);
      lines.add(new THREE.Line(geo, lineMat(col, 0.5)));
    }
    lines.rotation.x = -0.4; g.add(lines);
    return { g, act(t) {
      const turn = 0.5 + 0.5 * Math.sin(t * 0.06);
      g.rotation.z = -0.3 + turn * 0.6;
      plate.material.opacity = 0.24 + turn * 0.28;
    } };
  },
  // the line that suggests without saying
  line(col) {
    const g = new THREE.Group();
    const geo = new THREE.BufferGeometry();
    const N = 60;
    geo.setAttribute('position', new THREE.BufferAttribute(new Float32Array(N * 3), 3));
    const l = new THREE.Line(geo, lineMat(col, 0.85));
    g.add(l);
    return { g, act(t) {
      const a = geo.attributes.position;
      const drawn = (t * 0.14) % 1;
      for (let i = 0; i < N; i++) {
        const u = (i / (N - 1)) * drawn;
        a.array[i * 3] = Math.sin(u * 3.2) * 1.1;
        a.array[i * 3 + 1] = (u - 0.5) * 1.6 + Math.sin(u * 6) * 0.16;
        a.array[i * 3 + 2] = Math.cos(u * 2.4) * 0.3;
      }
      a.needsUpdate = true;
      l.material.opacity = 0.3 + 0.55 * Math.sin(Math.PI * drawn);
    } };
  },
};

// forms that stand in for the rest, chosen by kinship rather than convenience
const KIN = {
  hook: 'goad', spear: 'trident', discus: 'trident', triangle: 'seal', triad: 'seal',
  hand: 'palm', gaze: 'radiance', spine: 'sceptre', syllable: 'radiance', ear: 'palm',
  drop: 'cup', flower: 'lotus', belt: 'garland', streamer: 'garland', churn: 'seal',
  molten: 'cup', pour: 'grain', veil: 'palm', stretch: 'sceptre', brush: 'line',
  boon: 'palm', fruit: 'gem', water: 'cup', banner: 'garland', cleanse: 'palm',
  shield: 'ground', radiance: 'radiance',
};

export function buildAttribute(card, G) {
  const key = ATTRIBUTE[card.pos];
  if (!key) return null;
  const name = FORMS[key] ? key : (KIN[key] && FORMS[KIN[key]] ? KIN[key] : 'seal');
  const col = ATTR_TINT[card.pos] || G.c;
  const built = FORMS[name](col);
  const holder = new THREE.Group();
  holder.name = 'attribute-' + key;
  holder.add(built.g);
  // she holds it at her own altitude, a little in front of her seat
  const alt = bodyAltitude(card);
  holder.position.set(0, (0.5 - alt) * 6.4 - 0.4, -4.6);
  holder.scale.setScalar(0.9);
  return {
    group: holder, key, form: name,
    update(t) {
      built.act(t);
      const b = deep(t);
      // past the second adaptation the attribute is no longer held apart from
      // the room — it grows into it, and stops being an object.
      holder.scale.setScalar(0.9 + b * 2.6);
      holder.position.z = -4.6 + b * 3.4;
      built.g.traverse((o) => {
        if (o.material && o.material.opacity !== undefined && o.material.transparent) {
          o.material.opacity = Math.min(1, o.material.opacity * (1 - b * 0.55));
        }
      });
    },
  };
}
