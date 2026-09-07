// homes-verify.js — the V3 verification pass.
//
// Not "does it load". This runs BACKWARDS from what has been claimed, in six
// registers, against the real modules — and it is built to FAIL loudly.
//
//   CANON        every datum traces to the user's files; nothing invented
//   COVERAGE     all 102 resolve to a room, correct card, correct ring
//   DISTINCTION  the brief's own test, measured: could this room be another's?
//   LEGIBILITY   every room actually renders, at both adaptations
//   PROMISE      every written claim asserted against the code
//   FELT         nothing measures you out loud; no cuts; depth stays hidden

import * as THREE from 'three';

const R = [];
let cur = null;
export function register(name) { cur = { name, checks: [] }; R.push(cur); return cur; }
export function check(id, fn, note) {
  let pass = false, detail = '';
  try {
    const r = fn();
    if (r === true) pass = true;
    else if (r && typeof r === 'object' && 'pass' in r) { pass = !!r.pass; detail = r.detail || ''; }
    else { pass = false; detail = String(r); }
  } catch (e) { pass = false; detail = 'threw: ' + e.message; }
  cur.checks.push({ id, pass, detail, note: note || '' });
  return pass;
}
export const results = () => R;

// ── an offscreen stage, so every chamber can be rendered for real ──────────
export function makeStage() {
  const renderer = new THREE.WebGLRenderer({ antialias: false, preserveDrawingBuffer: true });
  renderer.setSize(240, 200, false);
  renderer.outputColorSpace = THREE.SRGBColorSpace;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.04;
  const c = document.createElement('canvas');
  c.width = 64; c.height = 32;
  const x = c.getContext('2d');
  const g = x.createLinearGradient(0, 0, 0, 32);
  g.addColorStop(0, '#3a3a44'); g.addColorStop(0.5, '#1a1a20'); g.addColorStop(1, '#0a0a0c');
  x.fillStyle = g; x.fillRect(0, 0, 64, 32);
  const env = new THREE.CanvasTexture(c);
  env.mapping = THREE.EquirectangularReflectionMapping;
  env.colorSpace = THREE.SRGBColorSpace;

  const camera = new THREE.PerspectiveCamera(60, 240 / 200, 0.1, 400);

  // Luminance grid of a chamber at a given moment on her clock.
  return function shoot(chamber, t, fogDensity, fogColor) {
    const scene = new THREE.Scene();
    scene.environment = env;
    scene.fog = new THREE.FogExp2(fogColor == null ? 0x0a0508 : fogColor, fogDensity == null ? 0.02 : fogDensity);
    scene.background = new THREE.Color(0x000000);
    scene.add(chamber.group);
    chamber.update(t);
    camera.position.set(0, 0, 0);
    camera.lookAt(0, -0.3, -9);
    renderer.render(scene, camera);
    const gl = renderer.getContext();
    const w = gl.drawingBufferWidth, h = gl.drawingBufferHeight;
    const px = new Uint8Array(4);
    const vals = [];
    for (let j = 1; j <= 4; j++) {
      for (let i = 1; i <= 4; i++) {
        gl.readPixels(Math.round(w * i / 5), Math.round(h * j / 5), 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, px);
        vals.push(Math.round(px[0] * 0.2126 + px[1] * 0.7152 + px[2] * 0.0722));
      }
    }
    scene.remove(chamber.group);
    return {
      max: Math.max(...vals), min: Math.min(...vals),
      mean: Math.round(vals.reduce((a, b) => a + b, 0) / vals.length),
      spread: Math.max(...vals) - Math.min(...vals),
      vals,
    };
  };
}

// A geometric fingerprint: where everything in her room actually is.
export function fingerprint(chamber, t) {
  chamber.update(t);
  const v = [];
  chamber.group.traverse((o) => {
    if (o === chamber.group) return;
    v.push(
      o.position.x.toFixed(2) + ',' + o.position.y.toFixed(2) + ',' + o.position.z.toFixed(2) +
      '|' + o.scale.x.toFixed(2) + '|' + (o.material && o.material.opacity != null ? o.material.opacity.toFixed(2) : '-')
    );
  });
  return v;
}

export function divergence(a, b) {
  const n = Math.min(a.length, b.length);
  if (!n) return 0;
  let d = 0;
  for (let i = 0; i < n; i++) if (a[i] !== b[i]) d++;
  return d / n;
}

// Text that would measure the walker out loud — forbidden by the method.
export const MEASURING = [
  /\b\d+\s*(?:of|\/)\s*\d+\b/i,      // "3 of 9"
  /\b\d+\s*%/,                        // a percentage
  /\bvisit(?:s)?\s*[:=]\s*\d+/i,      // a visit count
  /\bstreak\b/i, /\bprogress\b/i, /\blevel\s*\d/i, /\bscore\b/i,
  /\bday\s*\d+\b/i, /\b\d+\s*(?:times|visits)\b/i,
];
export function measuresOutLoud(text) {
  return MEASURING.filter((re) => re.test(text)).map((re) => String(re));
}
