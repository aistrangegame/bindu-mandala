// homes-sound.js — the instrument's voice. Her bīja is the carrier; her
// āvaraṇa's drone is the ground. Climbing crossfades the ground; entering
// brings her carrier up; her adaptation opens the filter. The fifth is
// withheld until the ninth world, or until a very long stay.

// One root per āvaraṇa, ascending the body — feet to totality. The absolute
// pitch is a design choice and nothing more; what is canonical is the ORDER.
const ROOTS = [55.0, 61.74, 69.30, 73.42, 82.41, 92.50, 98.00, 110.00, 123.47];

// Her carrier is derived from HER SYLLABLE, not invented.
//
// The varṇamālā is an ordered series, and that order is the canon. Each bīja the
// cards name is located in it, and its position becomes a just interval above
// her āvaraṇa's root. So Kaumārī's Caṃ stands in a fixed relation to Brāhmī's Aṃ
// because the alphabet puts them there — the pitch is ours, the interval is hers.
// Where the cards name no syllable, the carrier is simply the root: silence about
// what we do not know, rather than a plausible number.
const VARNA = [
  'a', 'ā', 'i', 'ī', 'u', 'ū', 'ṛ', 'ṝ', 'ḷ', 'ḹ', 'e', 'ai', 'o', 'au', 'aṃ', 'aḥ',
  'ka', 'kha', 'ga', 'gha', 'ṅa', 'ca', 'cha', 'ja', 'jha', 'ña',
  'ṭa', 'ṭha', 'ḍa', 'ḍha', 'ṇa', 'ta', 'tha', 'da', 'dha', 'na',
  'pa', 'pha', 'ba', 'bha', 'ma', 'ya', 'ra', 'la', 'va', 'śa', 'ṣa', 'sa', 'ha',
];
// just intervals within the octave, indexed by position in the series
const JUST = [1, 16 / 15, 9 / 8, 6 / 5, 5 / 4, 4 / 3, 45 / 32, 3 / 2, 8 / 5, 5 / 3, 16 / 9, 15 / 8];

function stem(syllable) {
  if (!syllable) return null;
  let x = String(syllable).toLowerCase().replace(/[ṃṁ]$/, '').replace(/ḥ$/, '');
  if (!x) x = 'a';
  return x;
}

export function carrierFor(root, syllable) {
  const x = stem(syllable);
  if (!x) return root;
  let ix = VARNA.indexOf(x);
  if (ix < 0) {
    // a compound bīja (Aim, Klīm, Sauḥ, Hrīm) — take its first letter's place
    const first = VARNA.findIndex((v) => x.startsWith(v[0]));
    ix = first < 0 ? 0 : first;
  }
  // fold into one octave above her root: the interval is hers, the register is
  // ours, and a drone must sit low enough to be felt rather than heard.
  return root * JUST[ix % JUST.length] * 2;
}

// The brief names an existing technique per ring — keep and extend:
//   1 ground drone · 2 home breath · 3 & 6 sustained breathy voice
//   4 & 5 stepped notes · 8 triad collapse · 9 Shepard tone
// (7 is the witness — left sourceless.) Each ring's ground is voiced its own way.
const TECHNIQUE = {
  1: 'drone', 2: 'breath', 3: 'breathy', 4: 'stepped', 5: 'stepped',
  6: 'breathy', 7: 'sourceless', 8: 'triad', 9: 'shepard',
};

export function makeVoice() {
  let ctx = null, ready = false;
  let master, ground = [], carrier = null, fifth = null, filt = null, air = null;

  function build() {
    ctx = new (window.AudioContext || window.webkitAudioContext)();
    master = ctx.createGain(); master.gain.value = 0;

    filt = ctx.createBiquadFilter();
    filt.type = 'lowpass'; filt.frequency.value = 220; filt.Q.value = 0.7;
    filt.connect(master); master.connect(ctx.destination);

    // nine grounds, all running, all silent but the one you are in — each
    // voiced by its own ring's technique rather than nine copies of one drone
    ground = ROOTS.map((hz, i) => {
      const ring = i + 1, tech = TECHNIQUE[ring];
      const g = ctx.createGain(); g.gain.value = 0;
      g.connect(filt);
      const osc = (type, f, gain, target) => {
        const o = ctx.createOscillator(); o.type = type; o.frequency.value = f;
        const og = ctx.createGain(); og.gain.value = gain;
        o.connect(og); og.connect(target || g); o.start();
        return { o, og };
      };
      if (tech === 'drone') {
        osc('sine', hz, 1); osc('sine', hz * 1.0035, 0.8); osc('triangle', hz * 2, 0.16);
      } else if (tech === 'breath') {
        // the home ring breathes: an LFO on its own amplitude
        const inner = ctx.createGain(); inner.gain.value = 1; inner.connect(g);
        osc('sine', hz, 1, inner); osc('sine', hz * 1.5, 0.3, inner);
        const lfo = ctx.createOscillator(); lfo.type = 'sine'; lfo.frequency.value = 0.14;
        const la = ctx.createGain(); la.gain.value = 0.55;
        lfo.connect(la); la.connect(inner.gain); lfo.start();
      } else if (tech === 'breathy') {
        // a sustained voice with air in it
        osc('sine', hz, 0.7); osc('sawtooth', hz * 1.002, 0.1);
        const bp = ctx.createBiquadFilter(); bp.type = 'bandpass'; bp.frequency.value = hz * 4; bp.Q.value = 1.6;
        bp.connect(g);
        osc('sawtooth', hz * 2.01, 0.05, bp);
      } else if (tech === 'stepped') {
        // notes that step rather than glide
        const st = osc('sine', hz, 1);
        const steps = [1, 9 / 8, 5 / 4, 3 / 2];
        let k = 0;
        setInterval(() => {
          if (!ctx) return;
          k = (k + 1) % steps.length;
          st.o.frequency.setValueAtTime(hz * steps[k], ctx.currentTime);
        }, ring === 4 ? 5200 : 3400);
        osc('sine', hz / 2, 0.4);
      } else if (tech === 'triad') {
        // three that collapse toward one
        const t1 = osc('sine', hz, 0.7), t2 = osc('sine', hz * 1.26, 0.6), t3 = osc('sine', hz * 1.5, 0.6);
        let phase = 0;
        setInterval(() => {
          if (!ctx) return;
          phase = (phase + 1) % 2;
          const now2 = ctx.currentTime;
          t2.o.frequency.setTargetAtTime(phase ? hz : hz * 1.26, now2, 3.4);
          t3.o.frequency.setTargetAtTime(phase ? hz : hz * 1.5, now2, 3.4);
        }, 14000);
      } else if (tech === 'shepard') {
        // a rising that never arrives
        for (let k = 0; k < 5; k++) {
          const v = osc('sine', hz * Math.pow(2, k - 1), 0);
          const lfo = ctx.createOscillator(); lfo.type = 'sine';
          lfo.frequency.value = 0.021; lfo.detune.value = k * 40;
          const la = ctx.createGain(); la.gain.value = 0.22;
          lfo.connect(la); la.connect(v.og.gain); lfo.start();
          v.og.gain.value = 0.22;
          v.o.detune.setValueAtTime(k * 3, ctx.currentTime);
        }
      } else {
        // sourceless: no fundamental at all, only its overtones
        osc('sine', hz * 2, 0.42); osc('sine', hz * 3, 0.26); osc('sine', hz * 5, 0.14);
      }
      return g;
    });

    // her carrier — silent until you enter her
    const cg = ctx.createGain(); cg.gain.value = 0;
    const co = ctx.createOscillator(); co.type = 'sine'; co.frequency.value = 136.1;
    co.connect(cg); cg.connect(filt); co.start();
    carrier = { g: cg, o: co };

    // the withheld fifth
    const fg = ctx.createGain(); fg.gain.value = 0;
    const fo = ctx.createOscillator(); fo.type = 'sine'; fo.frequency.value = 204.15;
    fo.connect(fg); fg.connect(filt); fo.start();
    fifth = { g: fg, o: fo };

    // air — filtered noise, the room's own breath
    const len = ctx.sampleRate * 4;
    const buf = ctx.createBuffer(1, len, ctx.sampleRate);
    const d = buf.getChannelData(0);
    for (let i = 0; i < len; i++) d[i] = (Math.random() * 2 - 1) * 0.5;
    const src = ctx.createBufferSource(); src.buffer = buf; src.loop = true;
    const ag = ctx.createGain(); ag.gain.value = 0;
    const ab = ctx.createBiquadFilter(); ab.type = 'bandpass'; ab.frequency.value = 460; ab.Q.value = 0.6;
    src.connect(ab); ab.connect(ag); ag.connect(master); src.start();
    air = { g: ag, f: ab };

    ready = true;
  }

  return {
    get on() { return ready && master && master.gain.value > 0.001; },
    start() {
      try { if (!ctx) build(); if (ctx.state === 'suspended') ctx.resume(); } catch (e) { ready = false; }
    },
    stop() {
      if (!ready) return;
      master.gain.setTargetAtTime(0, ctx.currentTime, 0.5);
    },
    wake() {
      if (!ready) return;
      master.gain.setTargetAtTime(0.5, ctx.currentTime, 1.2);
    },
    // climb: which ground, and how much of the next one
    setGround(i0, i1, k) {
      if (!ready) return;
      const now = ctx.currentTime;
      ground.forEach((g, i) => {
        const want = i === i0 ? (1 - k) * 0.16 : i === i1 ? k * 0.16 : 0;
        g.gain.setTargetAtTime(want, now, 0.9);
      });
    },
    // entering her: the carrier comes up, the ground recedes
    setCarrier(ring, amount, syllable) {
      if (!ready) return;
      const now = ctx.currentTime;
      const root = ROOTS[Math.max(0, Math.min(8, ring - 1))];
      carrier.o.frequency.setTargetAtTime(carrierFor(root, syllable), now, 0.6);
      carrier.g.gain.setTargetAtTime(amount * 0.1, now, 0.7);
    },
    // her adaptation opens the filter; the second adaptation grants the fifth
    setRoom(a, b, ring, syllable) {
      if (!ready) return;
      const now = ctx.currentTime;
      const root = ROOTS[Math.max(0, Math.min(8, ring - 1))];
      filt.frequency.setTargetAtTime(220 + 1500 * a, now, 1.4);
      const allow = ring === 9 ? 1 : b;
      fifth.o.frequency.setTargetAtTime(carrierFor(root, syllable) * 1.5, now, 0.8);
      fifth.g.gain.setTargetAtTime(allow * 0.05, now, 2.0);
      air.g.gain.setTargetAtTime(0.006 + 0.012 * a, now, 1.5);
      air.f.frequency.setTargetAtTime(380 + 700 * a, now, 1.6);
    },
    // one struck tone as a beat of the rite lands
    strike(ring, beat, syllable) {
      if (!ready) return;
      const now = ctx.currentTime;
      const root = ROOTS[Math.max(0, Math.min(8, ring - 1))];
      const o = ctx.createOscillator(); o.type = 'sine';
      o.frequency.value = carrierFor(root, syllable) * [1, 1.5, 2][beat - 1];
      const g = ctx.createGain();
      g.gain.setValueAtTime(0, now);
      g.gain.linearRampToValueAtTime(0.05, now + 0.02);
      g.gain.exponentialRampToValueAtTime(0.0001, now + 3.4);
      o.connect(g); g.connect(master); o.start(now); o.stop(now + 3.6);
    },
  };
}
