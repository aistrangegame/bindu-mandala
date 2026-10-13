// bindu-engine.js — the two instruments of the immersive Bindu build.
// SilenceEngine: the OM stack that lives at gain zero and learns to sound.
// DotStage: one full-screen canvas, one dot, never unmounted.
// Plus: haptics, wake lock, breath clock.
(function () {
  'use strict';

  // ── Breath clock — the room's only unit of time ──
  function pace() {
    try { return (window.BINDU_TWEAKS && window.BINDU_TWEAKS.pace) || 1; } catch (e) { return 1; }
  }
  const BREATH = () => 5000 * pace();           // one breath ≈ 5s at pace 1 (the slow one)
  const wait = (ms, signal) => new Promise((res) => {
    const t = setTimeout(res, ms);
    if (signal) signal.addEventListener('abort', () => { clearTimeout(t); }, { once: true });
  });

  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
  const easeInOut = (t) => (t < .5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);
  const easeOut = (t) => 1 - Math.pow(1 - t, 3);
  const easeIn = (t) => t * t * t;

  function haptic(ms) { try { if (navigator.vibrate) navigator.vibrate(ms); } catch (e) {} }

  let wakeLock = null;
  async function requestWakeLock() {
    try {
      if ('wakeLock' in navigator) {
        wakeLock = await navigator.wakeLock.request('screen');
        wakeLock.addEventListener('release', () => { wakeLock = null; });
      }
    } catch (e) {}
  }
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible' && !wakeLock) requestWakeLock();
  });

  // ── SilenceEngine ──
  const Silence = {
    ctx: null, master: null, partials: {}, lfoGain: null, unlocked: false,
    enabled: () => { try { return !(window.BINDU_TWEAKS && window.BINDU_TWEAKS.sound === false); } catch (e) { return true; } },

    unlock() {
      if (this.unlocked) return;
      try {
        this.ctx = new (window.AudioContext || window.webkitAudioContext)();
        if (this.ctx.state === 'suspended') this.ctx.resume();
        this.master = this.ctx.createGain();
        this.master.gain.value = 0;
        this.master.connect(this.ctx.destination);
        // The OM stack — silent from birth
        const defs = { sub: [68.05, 0.15], fund: [136.1, 1.0], oct: [272.2, 0.3] };
        Object.entries(defs).forEach(([name, [freq, mix]]) => {
          const osc = this.ctx.createOscillator();
          osc.type = 'sine'; osc.frequency.value = freq;
          const g = this.ctx.createGain(); g.gain.value = mix;
          osc.connect(g); g.connect(this.master); osc.start();
          this.partials[name] = { osc, gain: g, mix };
        });
        // Breathing LFO on the master — 0.05 Hz, the room's lungs
        const lfo = this.ctx.createOscillator();
        lfo.type = 'sine'; lfo.frequency.value = 0.05;
        this.lfoGain = this.ctx.createGain();
        this.lfoGain.gain.value = 0.004;
        lfo.connect(this.lfoGain); this.lfoGain.connect(this.master.gain); lfo.start();
        this.unlocked = true;
      } catch (e) {}
    },

    // master gain moves like weather — never a cut
    breathe(target, seconds = 3) {
      if (!this.unlocked || !this.enabled()) return;
      this.master.gain.setTargetAtTime(target, this.ctx.currentTime, Math.max(0.4, seconds / 3));
    },
    // one partial's presence within the stack
    partial(name, mixTarget, seconds = 2) {
      const p = this.partials[name];
      if (!p || !this.unlocked) return;
      p.gain.gain.setTargetAtTime(mixTarget, this.ctx.currentTime, Math.max(0.3, seconds / 3));
    },
    suspendBreath() { if (this.unlocked) this.lfoGain.gain.setTargetAtTime(0, this.ctx.currentTime, 0.5); },
    resumeBreath() { if (this.unlocked) this.lfoGain.gain.setTargetAtTime(0.004, this.ctx.currentTime, 2); },
    // absolute stillness — mid-LFO, everything
    ceaseAll(seconds = 1.5) {
      if (!this.unlocked) return;
      this.suspendBreath();
      this.master.gain.setTargetAtTime(0, this.ctx.currentTime, seconds / 3);
    },
    // one discrete musical event (bell-like, additive decay)
    bell(freq, dur = 4, gain = 0.02) {
      if (!this.unlocked || !this.enabled()) return;
      try {
        const t = this.ctx.currentTime;
        const osc = this.ctx.createOscillator(); osc.type = 'sine'; osc.frequency.value = freq;
        const g = this.ctx.createGain();
        g.gain.setValueAtTime(0, t);
        g.gain.linearRampToValueAtTime(gain, t + 0.15);
        g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
        osc.connect(g); g.connect(this.ctx.destination);
        osc.start(t); osc.stop(t + dur + 0.1);
      } catch (e) {}
    },
  };

  // ── DotStage — the one living dot ──
  function DotStage(canvas) {
    const ctx = canvas.getContext('2d');
    let W = 0, H = 0, dpr = 1;
    const dot = {
      x: 0.5, y: 0.42,          // fractions of viewport
      r: 7, alpha: 0,
      breathing: true, breathT: 0, breathSecs: 6,
      trail: [], trailMax: 0,
      wanderAmp: 0, wanderT: Math.random() * 100,
      blinkA: 1,                 // 1 = open
    };
    let target = null;           // {fx,fy,tx,ty,t0,dur,ease,resolve}
    let motes = null;            // condensation particles
    let lean = { x: 0, y: 0, tx: 0, ty: 0 };
    let running = true;

    function resize() {
      dpr = window.devicePixelRatio || 1;
      W = window.innerWidth; H = window.innerHeight;
      canvas.width = W * dpr; canvas.height = H * dpr;
      canvas.style.width = W + 'px'; canvas.style.height = H + 'px';
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
    }
    resize();
    window.addEventListener('resize', resize);

    window.addEventListener('pointermove', (e) => {
      const dx = e.clientX - dot.x * W, dy = e.clientY - dot.y * H;
      const len = Math.hypot(dx, dy) || 1, pull = Math.min(5, len * 0.02);
      lean.tx = (dx / len) * pull; lean.ty = (dy / len) * pull;
    });
    window.addEventListener('pointerleave', () => { lean.tx = 0; lean.ty = 0; });

    function px() { return { x: dot.x * W + lean.x, y: dot.y * H + lean.y }; }

    function drawDot(x, y, r, alpha, glow = 1) {
      if (alpha <= 0) return;
      ctx.save();
      ctx.globalAlpha = alpha;
      ctx.shadowColor = 'rgba(201,168,76,.65)';
      ctx.shadowBlur = 18 * glow;
      const g = ctx.createRadialGradient(x - r * 0.2, y - r * 0.25, r * 0.1, x, y, r);
      g.addColorStop(0, '#E8C568'); g.addColorStop(1, '#C9A84C');
      ctx.fillStyle = g;
      ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fill();
      ctx.restore();
    }

    let lastNow = 0;
    function loop(now) {
      if (!running) return;
      const dt = Math.min((now - lastNow) / 1000, 0.05); lastNow = now;
      ctx.clearRect(0, 0, W, H);

      // motion toward target
      if (target) {
        const p = clamp((now - target.t0) / target.dur, 0, 1);
        const e = (target.ease || easeInOut)(p);
        dot.x = target.fx + (target.tx - target.fx) * e;
        dot.y = target.fy + (target.ty - target.fy) * e;
        if (p >= 1) { const r = target.resolve; target = null; r && r(); }
      }
      // wander — alive, not mechanical
      dot.wanderT += dt * 0.35;
      const wx = Math.sin(dot.wanderT * 1.3) * Math.cos(dot.wanderT * 0.7) * dot.wanderAmp;
      const wy = Math.cos(dot.wanderT * 1.1) * Math.sin(dot.wanderT * 0.5) * dot.wanderAmp;
      // lean easing
      lean.x += (lean.tx - lean.x) * dt * 2.2;
      lean.y += (lean.ty - lean.y) * dt * 2.2;
      // breath
      dot.breathT += dt;
      const br = dot.breathing ? 1 + Math.sin((dot.breathT / dot.breathSecs) * Math.PI * 2) * 0.09 : 1;

      // condensation motes
      if (motes) {
        const mp = clamp((now - motes.t0) / motes.dur, 0, 1);
        const e = easeInOut(mp);
        motes.pts.forEach((m) => {
          const mx = m.x + (dot.x * W - m.x) * e;
          const my = m.y + (dot.y * H - m.y) * e;
          const a = (1 - e * 0.7) * m.a * clamp(mp * 4, 0, 1);
          drawDot(mx, my, m.r * (1 - e * 0.6), a, 0.3);
        });
        dot.alpha = easeIn(mp);
        if (mp >= 1) { const r = motes.resolve; motes = null; r && r(); }
      }

      // trail
      const P = px();
      if (dot.trailMax > 0 && dot.alpha > 0.1) {
        dot.trail.push({ x: P.x + wx, y: P.y + wy });
        while (dot.trail.length > dot.trailMax) dot.trail.shift();
        if (dot.trail.length > 2) {
          ctx.save();
          for (let i = 1; i < dot.trail.length; i++) {
            const a = (i / dot.trail.length) * 0.35;
            ctx.strokeStyle = 'rgba(201,168,76,' + a.toFixed(3) + ')';
            ctx.lineWidth = 1.6;
            ctx.beginPath();
            ctx.moveTo(dot.trail[i - 1].x, dot.trail[i - 1].y);
            ctx.lineTo(dot.trail[i].x, dot.trail[i].y);
            ctx.stroke();
          }
          ctx.restore();
        }
      } else if (dot.trailMax === 0) { dot.trail.length = 0; }

      drawDot(P.x + wx, P.y + wy, dot.r * br * dot.blinkA, dot.alpha * (0.35 + 0.65 * dot.blinkA), dot.glowMul || 1);
      requestAnimationFrame(loop);
    }
    requestAnimationFrame((n) => { lastNow = n; loop(n); });

    return {
      dot,
      // glide — duration in ms, promise resolves on arrival
      moveTo(x, y, dur, ease) {
        return new Promise((resolve) => {
          target = { fx: dot.x, fy: dot.y, tx: x, ty: y, t0: performance.now(), dur: dur || 2600, ease, resolve };
        });
      },
      // the first act of life
      async blink() {
        const steps = 14;
        for (let i = 0; i <= steps; i++) { dot.blinkA = 1 - easeInOut(i / steps); await wait(26); }
        await wait(140);
        for (let i = 0; i <= steps; i++) { dot.blinkA = easeInOut(i / steps); await wait(30); }
      },
      condense(dur) {
        return new Promise((resolve) => {
          const pts = Array.from({ length: 90 }, () => ({
            x: Math.random() * W, y: Math.random() * H,
            r: 0.6 + Math.random() * 1.6, a: 0.15 + Math.random() * 0.5,
          }));
          dot.alpha = 0;
          motes = { pts, t0: performance.now(), dur: dur || 12000, resolve };
        });
      },
      set(props) { Object.assign(dot, props); },
      show(secs = 2) { dot.alpha = 1; },
      pxOf(fx, fy) { return { x: fx * W, y: fy * H }; },
      stop() { running = false; },
    };
  }

  window.BinduEngine = { Silence, DotStage, BREATH, wait, haptic, requestWakeLock, easeInOut, easeOut, easeIn, clamp, pace };
})();
