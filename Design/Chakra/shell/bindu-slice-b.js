// bindu-slice-b.js — THE STORY, wordless. Motion carries meaning.
// The full narrative text lives in the separate reading module — NOT here.
// Five movements, one canvas, one being that behaves like a character:
//   I    Uncertain existence — it flickers, nearly winks out, recovers.
//   II   Trying on forms — becomes place / body / thought; each fails; each failure leaves it more solid.
//   III  It feels you — awareness of the warmth AND of the walker; it looks at you, approaches, recoils; then strains.
//   IV   The covenant — everything freezes; it turns fully to you and beckons; you touch; it crosses to meet your hand.
//   V    Dawn — the world floods cream from the contact. One word, earned: "Go."
(function () {
  'use strict';
  const { Silence, BREATH, wait, haptic, pace } = window.BinduEngine;
  const $ = (id) => document.getElementById(id);
  const easeInOut = (t) => (t < .5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);
  const easeOut = (t) => 1 - Math.pow(1 - t, 3);
  const easeIn = (t) => t * t * t;
  const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

  // ── scene state ──
  let S = null, raf = null, cvs = null, ctx = null, W = 0, H = 0, dpr = 1;
  let tweens = [];

  function freshState() {
    return {
      t0: performance.now(),
      bgWarm: 0,                 // 0 = void · 1 = full cream
      d: { x: .5, y: .44, r: 2.2, glow: .5, alpha: .40, flicker: 1, elong: 0, elongAngle: -Math.PI / 2, gx: 0, gy: 0, trail: [], trailMax: 0 },
      dust: Array.from({ length: 64 }, () => ({
        x: Math.random(), y: Math.random(),
        vx: (Math.random() - .5) * .00016, vy: (Math.random() - .5) * .00016,
        a: .04 + Math.random() * .1, r: .5 + Math.random() * 1.1, gold: 0,
      })),
      dustMode: 'drift',         // drift · stream · frozen · dawn
      aurora: 0,
      form: null,                // { type, p, jitter, collapse, fade }
      ripples: [],               // thought rings + contact blooms {x,y,r,a,vr}
      thread: 0,                 // descending light 0-1
      sakshi: 0,
      pool: null,                // { x, y, r } — dawn pool
      bloom: 0,
      cursor: { x: .5, y: .72, active: false, last: 0 },
      awareness: 0,              // 0 = unaware of walker · 1 = gaze fully tracks cursor
      behavior: 'none',          // none · curious · beckon
    };
  }

  function tween(obj, props, dur, ease = easeInOut) {
    return new Promise((res) => {
      tweens.push({ obj, list: Object.keys(props).map(k => ({ k, from: obj[k], to: props[k] })), t0: performance.now(), dur, ease, res });
    });
  }

  function resize() {
    dpr = window.devicePixelRatio || 1;
    W = window.innerWidth; H = window.innerHeight;
    cvs.width = W * dpr; cvs.height = H * dpr;
    cvs.style.width = W + 'px'; cvs.style.height = H + 'px';
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  // ── drawing ──
  function drawBg(t) {
    const b = S.bgWarm;
    const breathe = 1 + Math.sin(t * .22) * .04;
    const r0 = Math.max(W, H);
    const g = ctx.createRadialGradient(W / 2, H * .42, 0, W / 2, H * .42, r0 * breathe);
    g.addColorStop(0, b < 1 ? `rgb(${9 + b * 239},${6 + b * 229},${12 + b * 200})` : '#F8F1DF');
    g.addColorStop(1, b < 1 ? `rgb(${4 + b * 230},${3 + b * 217},${6 + b * 180})` : '#EADCBA');
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, W, H);
  }

  function drawAurora(t) {
    if (S.aurora <= 0) return;
    const I = S.aurora, hgt = H * .26;
    const g = ctx.createLinearGradient(0, 0, 0, hgt);
    g.addColorStop(0, `rgba(232,197,104,${.30 * I})`);
    g.addColorStop(.5, `rgba(201,168,76,${.10 * I})`);
    g.addColorStop(1, 'rgba(201,168,76,0)');
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, W, hgt);
    for (let i = 0; i < 3; i++) {
      const sx = W * (.5 + .38 * Math.sin(t * .07 + i * 2.1));
      const rg = ctx.createRadialGradient(sx, -hgt * .2, 0, sx, -hgt * .2, hgt * 1.2);
      rg.addColorStop(0, `rgba(240,214,140,${(.14 * I).toFixed(3)})`);
      rg.addColorStop(1, 'rgba(240,214,140,0)');
      ctx.fillStyle = rg;
      ctx.fillRect(0, 0, W, hgt * 1.2);
    }
  }

  function drawDust(dt) {
    S.dust.forEach(m => {
      if (S.dustMode === 'drift') { m.x += m.vx * dt * 60; m.y += m.vy * dt * 60; }
      else if (S.dustMode === 'stream') {
        m.y -= (.00035 + m.r * .0002) * dt * 60;
        m.x += m.vx * dt * 40;
        if (m.y < -.02) { m.y = 1.02; m.x = Math.random(); }
      } else if (S.dustMode === 'dawn') {
        m.y += .00012 * dt * 60;
        if (S.pool) {
          const dx = (m.x - S.pool.x) * W, dy = (m.y - S.pool.y) * H;
          if (Math.hypot(dx, dy) < S.pool.r) m.gold = Math.min(1, m.gold + dt * .8);
        }
      }
      if (m.x < 0) m.x = 1; if (m.x > 1) m.x = 0;
      if (m.y < 0 && S.dustMode !== 'stream') m.y = 1; if (m.y > 1 && S.dustMode !== 'stream') m.y = 0;
      const cream = S.bgWarm;
      const col = m.gold > 0 ? `rgba(201,168,76,${(m.a * 2.4 * m.gold).toFixed(3)})`
        : cream > .5 ? `rgba(120,96,50,${(m.a * .8).toFixed(3)})`
        : `rgba(216,206,190,${m.a.toFixed(3)})`;
      ctx.fillStyle = col;
      ctx.beginPath(); ctx.arc(m.x * W, m.y * H, m.r, 0, Math.PI * 2); ctx.fill();
    });
  }

  // a place · a body · a thought — the void tries each form and cannot hold it
  function drawForm(t) {
    const f = S.form; if (!f) return;
    const dx = S.d.x * W, dy = S.d.y * H;
    ctx.save();
    if (f.type === 'place') {
      const w = 170, h = 120;
      const jx = () => (Math.random() - .5) * f.jitter * 7;
      const per = 2 * (w + h), drawn = per * clamp(f.p, 0, 1);
      const c = clamp(f.collapse, 0, 1);
      const corners = [[-w / 2, -h / 2], [w / 2, -h / 2], [w / 2, h / 2], [-w / 2, h / 2]]
        .map(([x, y]) => [dx + x * (1 - c) + jx(), dy + y * (1 - c) + jx()]);
      ctx.strokeStyle = `rgba(214,196,160,${(.4 * f.fade).toFixed(3)})`;
      ctx.lineWidth = 1;
      ctx.setLineDash([drawn, per]);
      ctx.beginPath();
      ctx.moveTo(corners[0][0], corners[0][1]);
      corners.slice(1).concat([corners[0]]).forEach(p => ctx.lineTo(p[0], p[1]));
      ctx.stroke(); ctx.setLineDash([]);
    } else if (f.type === 'body') {
      const c = clamp(f.collapse, 0, 1);
      const rx = 34 * (1 + .1 * Math.sin(t * 2.6)) * (1 - c * .4), ry = 62 * (1 - .06 * Math.sin(t * 2.6)) * (1 - c * .4);
      const a = .30 * f.fade * clamp(f.p, 0, 1);
      const g = ctx.createRadialGradient(dx, dy, 4, dx, dy, ry);
      g.addColorStop(0, `rgba(226,206,166,${a})`);
      g.addColorStop(.75, `rgba(226,206,166,${a * .35})`);
      g.addColorStop(1, 'rgba(226,206,166,0)');
      ctx.fillStyle = g;
      ctx.save(); ctx.translate(dx, dy); ctx.scale(rx / ry, 1);
      ctx.beginPath(); ctx.arc(0, 0, ry, 0, Math.PI * 2); ctx.fill(); ctx.restore();
      if (c > 0) {
        for (let i = 0; i < 16; i++) {
          const ang = (i / 16) * Math.PI * 2;
          const rr = c * 90;
          ctx.fillStyle = `rgba(226,206,166,${(.3 * (1 - c) * f.fade).toFixed(3)})`;
          ctx.beginPath(); ctx.arc(dx + Math.cos(ang) * rr, dy + Math.sin(ang) * rr * 1.4, 1.1, 0, Math.PI * 2); ctx.fill();
        }
      }
    }
    ctx.restore();
  }

  function drawRipples(dt) {
    S.ripples = S.ripples.filter(r => r.a > .004);
    S.ripples.forEach(r => {
      r.r += r.vr * dt * 60; r.a *= Math.pow(.975, dt * 60);
      ctx.strokeStyle = `rgba(${r.gold ? '232,197,104' : '210,200,180'},${r.a.toFixed(3)})`;
      ctx.lineWidth = r.gold ? 1.2 : .8;
      ctx.beginPath(); ctx.arc(r.x * W, r.y * H, r.r, 0, Math.PI * 2); ctx.stroke();
    });
  }

  function drawThread(t) {
    if (S.thread <= 0) return;
    const x = W / 2, top = 0, bottom = H * .34 * S.thread;
    const g = ctx.createLinearGradient(x, top, x, bottom);
    g.addColorStop(0, `rgba(240,214,140,${.5 * S.thread})`);
    g.addColorStop(1, 'rgba(240,214,140,0)');
    ctx.strokeStyle = g; ctx.lineWidth = 1.1;
    ctx.beginPath(); ctx.moveTo(x, top); ctx.lineTo(x + Math.sin(t * 1.7) * 3, bottom); ctx.stroke();
    for (let i = 0; i < 5; i++) {
      const p = ((t * .12 + i * .2) % 1);
      ctx.fillStyle = `rgba(240,214,140,${(.5 * S.thread * (1 - p)).toFixed(3)})`;
      ctx.beginPath(); ctx.arc(x + Math.sin((t + i) * 1.7) * 2, p * bottom, 1.1, 0, Math.PI * 2); ctx.fill();
    }
  }

  function drawPool() {
    if (!S.pool || S.pool.r <= 0) return;
    const { x, y, r } = S.pool;
    const g = ctx.createRadialGradient(x * W, y * H, 0, x * W, y * H, r);
    g.addColorStop(0, 'rgba(248,241,223,1)');
    g.addColorStop(.8, 'rgba(244,235,212,.92)');
    g.addColorStop(1, 'rgba(244,235,212,0)');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(x * W, y * H, r, 0, Math.PI * 2); ctx.fill();
  }

  function drawSakshi() {
    if (S.sakshi <= 0) return;
    const x = W * .91, y = H * .30;
    ctx.fillStyle = `rgba(250,248,242,${S.sakshi.toFixed(3)})`;
    ctx.shadowColor = 'rgba(250,248,242,.8)'; ctx.shadowBlur = 7;
    ctx.beginPath(); ctx.arc(x, y, 1.6, 0, Math.PI * 2); ctx.fill();
    ctx.shadowBlur = 0;
  }

  function drawBeing(t, dt) {
    const d = S.d;
    const fl = d.flicker > 0 ? (1 - d.flicker * (.45 + .45 * Math.sin(t * 7.3) * Math.sin(t * 3.1) + (Math.random() - .5) * .2)) : 1;
    const a = clamp(d.alpha * fl, 0, 1);
    const px = d.x * W, py = d.y * H;
    if (d.trailMax > 0) {
      d.trail.push({ x: px, y: py });
      while (d.trail.length > d.trailMax) d.trail.shift();
      for (let i = 1; i < d.trail.length; i++) {
        ctx.strokeStyle = `rgba(224,186,98,${((i / d.trail.length) * .3 * a).toFixed(3)})`;
        ctx.lineWidth = 1.4;
        ctx.beginPath(); ctx.moveTo(d.trail[i - 1].x, d.trail[i - 1].y); ctx.lineTo(d.trail[i].x, d.trail[i].y); ctx.stroke();
      }
    } else d.trail.length = 0;
    // body
    ctx.save();
    ctx.translate(px, py);
    ctx.rotate(d.elongAngle + Math.PI / 2);
    ctx.scale(1, 1 + d.elong * .9);       // straining / leaning
    ctx.shadowColor = 'rgba(224,186,98,.75)';
    ctx.shadowBlur = 16 * d.glow;
    const g = ctx.createRadialGradient(0, 0, d.r * .1, 0, 0, d.r);
    g.addColorStop(0, '#EFD188'); g.addColorStop(1, '#C9A84C');
    ctx.fillStyle = g; ctx.globalAlpha = a;
    ctx.beginPath(); ctx.arc(0, 0, d.r, 0, Math.PI * 2); ctx.fill();
    ctx.restore();
    // gaze — a bright specular that shifts to where the being is looking (reads as an eye)
    const hx = px + d.gx * d.r * .5, hy = py + d.gy * d.r * .5;
    const hg = ctx.createRadialGradient(hx, hy, 0, hx, hy, d.r * .75);
    hg.addColorStop(0, `rgba(255,248,224,${(.95 * a).toFixed(3)})`);
    hg.addColorStop(1, 'rgba(255,248,224,0)');
    ctx.fillStyle = hg;
    ctx.beginPath(); ctx.arc(hx, hy, d.r * .75, 0, Math.PI * 2); ctx.fill();
  }

  // ── the being's behavior: it feels the walker and reacts (this is what makes it a character) ──
  function updateBehavior(t, dt) {
    const d = S.d, cur = S.cursor;
    const fresh = cur.active && (performance.now() - cur.last < 2600);
    // gaze target: look at the walker if aware & present, else wander slowly (looking around)
    let tgx, tgy;
    if (S.awareness > .02 && fresh) {
      const ang = Math.atan2(cur.y - d.y, cur.x - d.x);
      const grip = clamp(S.awareness, 0, 1);
      tgx = Math.cos(ang) * grip; tgy = Math.sin(ang) * grip;
    } else {
      tgx = Math.cos(t * .5) * .5; tgy = Math.sin(t * .37) * .5;
    }
    const k = Math.min(1, dt * 2.4);
    d.gx += (tgx - d.gx) * k; d.gy += (tgy - d.gy) * k;

    if (S.behavior === 'curious' && fresh) {
      // approach when far, recoil when too near — shy curiosity, hovers at a comfortable distance
      const dist = Math.hypot(cur.x - d.x, cur.y - d.y);
      const ang = Math.atan2(cur.y - d.y, cur.x - d.x);
      const comfort = .17;
      const pull = (dist - comfort) * .010 * S.awareness;
      d.x += Math.cos(ang) * pull * dt * 60;
      d.y += Math.sin(ang) * pull * dt * 60;
      d.x = clamp(d.x, .18, .82); d.y = clamp(d.y, .30, .64);
    }

    if (S.behavior === 'beckon') {
      const dist = fresh ? Math.hypot(cur.x - d.x, cur.y - d.y) : 1;
      const near = clamp(1 - dist / .5, 0, 1);
      d.glow += ((1 + near * .8) - d.glow) * Math.min(1, dt * 2);   // brightens as you approach
      if (fresh) {
        const ang = Math.atan2(cur.y - d.y, cur.x - d.x);
        let da = ang - d.elongAngle;
        while (da > Math.PI) da -= Math.PI * 2; while (da < -Math.PI) da += Math.PI * 2;
        d.elongAngle += da * Math.min(1, dt * 1.6);                 // turns its body toward you
        d.elong += (near * .4 - d.elong) * Math.min(1, dt * 1.6);   // leans toward you
      }
    }
  }

  let lastNow = 0;
  function loop(now) {
    if (!S) return;
    const dt = Math.min((now - lastNow) / 1000, .05); lastNow = now;
    const t = (now - S.t0) / 1000;
    tweens = tweens.filter(tw => {
      const p = clamp((now - tw.t0) / tw.dur, 0, 1);
      const e = tw.ease(p);
      tw.list.forEach(({ k, from, to }) => { tw.obj[k] = from + (to - from) * e; });
      if (p >= 1) { tw.res(); return false; }
      return true;
    });
    drawBg(t);
    drawAurora(t);
    drawDust(dt);
    drawPool();
    drawForm(t);
    drawRipples(dt);
    drawThread(t);
    drawSakshi();
    updateBehavior(t, dt);
    drawBeing(t, dt);
    raf = requestAnimationFrame(loop);
  }

  // ── the ONLY text of the piece — placed in whichever band is farther from the being ──
  async function engrave(text, signal, opts = {}) {
    if (signal.aborted) return;
    const el = $('engrave');
    el.textContent = text;
    el.className = 'engrave' + (opts.italic ? ' it' : '') + (opts.big ? ' big' : '') + (S.bgWarm > .5 ? ' on-cream' : '');
    el.style.top = (opts.top != null ? opts.top : (S.d.y < .5 ? 78 : 22)) + '%';
    el.classList.add('on');
    await wait((opts.hold != null ? opts.hold : 1.2) * BREATH(), signal);
    el.classList.remove('on');
    await wait(1900 * pace(), signal);
  }

  // ── the piece ──
  async function start() {
    const { ctl, stage: stageOf, markThread, roomScene } = window.__bindu;
    const stage = stageOf();
    const signal = ctl.newScene();
    ctl.show('scene-story');

    cvs = $('storyCanvas'); ctx = cvs.getContext('2d');
    resize();
    const onResize = () => resize();
    window.addEventListener('resize', onResize);
    S = freshState(); tweens = [];
    lastNow = performance.now();
    raf = requestAnimationFrame(loop);
    stage.set({ alpha: 0 });                        // the being lives on THIS canvas now

    // pointer awareness — the being can feel where you are, the whole way through
    const scene = $('scene-story');
    const onMove = (e) => { S.cursor.x = e.clientX / W; S.cursor.y = e.clientY / H; S.cursor.active = true; S.cursor.last = performance.now(); };
    scene.addEventListener('pointermove', onMove);

    const cleanup = () => {
      window.removeEventListener('resize', onResize);
      scene.removeEventListener('pointermove', onMove);
      cancelAnimationFrame(raf);
      S = null;
      $('engrave').classList.remove('on');
      $('reachHint').classList.remove('on');
      stage.set({ alpha: 1 });
    };
    signal.addEventListener('abort', cleanup, { once: true });

    try {
      // ═══ I · UNCERTAIN EXISTENCE ═══  (wordless — a thing not sure it exists)
      Silence.ceaseAll(1);
      await wait(BREATH() * 1.2, signal); if (signal.aborted) return;
      for (let i = 0; i < 2; i++) {                 // two near-extinctions, each recovered
        await tween(S.d, { alpha: .07, glow: .12 }, 1000 * pace(), easeIn); if (signal.aborted) return;
        await wait(500 * pace(), signal); if (signal.aborted) return;
        await tween(S.d, { alpha: .42, glow: .5 }, 1300 * pace(), easeOut); if (signal.aborted) return;
        await wait(800 * pace(), signal); if (signal.aborted) return;
      }
      await wait(BREATH() * .6, signal); if (signal.aborted) return;

      // ═══ II · TRYING ON FORMS ═══  (wordless — three failures, each leaves it more solid)
      const sag = async () => {                     // disappointment: dims, sinks, recovers a little steadier
        await tween(S.d, { glow: .35, y: S.d.y + .016 }, 800 * pace()); if (signal.aborted) return;
        await tween(S.d, { y: S.d.y - .016 }, 600 * pace());
        S.d.alpha = Math.min(1, S.d.alpha + .12); S.d.r += .8;
      };
      // a place — a room draws itself, trembles, cannot hold
      S.form = { type: 'place', p: 0, jitter: 0, collapse: 0, fade: 1 };
      await tween(S.form, { p: 1 }, 3400 * pace()); if (signal.aborted) return;
      Silence.bell(151, 2.2, .012);
      await tween(S.d, { glow: .95 }, 900 * pace());          // hope
      await tween(S.form, { jitter: 1 }, 1500 * pace()); if (signal.aborted) return;
      await tween(S.form, { collapse: 1, fade: 0 }, 1900 * pace(), easeIn);
      S.form = null; await sag(); if (signal.aborted) return;
      await wait(700 * pace(), signal); if (signal.aborted) return;
      // a body — a cocoon breathes wrong, disperses
      S.form = { type: 'body', p: 0, jitter: 0, collapse: 0, fade: 1 };
      await tween(S.form, { p: 1 }, 3000 * pace()); if (signal.aborted) return;
      Silence.bell(97, 2.6, .012);
      await tween(S.d, { glow: .95 }, 900 * pace());
      await wait(1200 * pace(), signal); if (signal.aborted) return;
      await tween(S.form, { collapse: 1, fade: 0 }, 2100 * pace(), easeOut);
      S.form = null; await sag(); if (signal.aborted) return;
      await wait(700 * pace(), signal); if (signal.aborted) return;
      // a thought — rings interfere and cancel
      Silence.bell(211, 1.8, .010);
      for (let i = 0; i < 5; i++) {
        S.ripples.push({ x: S.d.x + (i % 2 ? .012 : -.012), y: S.d.y, r: 6, a: .5, vr: 1.5 + i * .35 });
        await wait(420 * pace(), signal); if (signal.aborted) return;
      }
      await tween(S.d, { glow: .5 }, 700 * pace());
      S.d.alpha = 1; S.d.r += .8;
      await wait(BREATH() * .5, signal); if (signal.aborted) return;

      // JUST: HERE — the flicker stops. steadiness is the event. (long, wordless dwell)
      await tween(S.d, { flicker: 0, glow: 1, r: 6.5 }, 3400 * pace()); if (signal.aborted) return;
      Silence.resumeBreath(); Silence.breathe(.006, 4);
      await wait(BREATH() * 1.8, signal); if (signal.aborted) return;

      // ═══ III · IT FEELS YOU ═══  (interactive — awareness of the warmth AND of the walker)
      tween(S, { aurora: 1 }, 6000 * pace());
      S.dustMode = 'stream';
      tween(S, { awareness: 1 }, 4000 * pace());       // its gaze begins to find you
      await wait(BREATH() * 1.1, signal); if (signal.aborted) return;
      // a curious, shy beat — it approaches you, pulls back, hovers close. LET THE WALKER PLAY.
      S.behavior = 'curious';
      await wait(BREATH() * 2.6, signal); if (signal.aborted) return;
      S.behavior = 'none';
      await tween(S.d, { x: .5, y: .44 }, 1600 * pace(), easeInOut); if (signal.aborted) return;  // settle for the leaning

      // straining toward the warmth (wordless wanting)
      const baseY = .44;
      S.d.trailMax = 34;
      const strain = async (upY, elong, breatheTo) => {
        Silence.breathe(breatheTo, 2);
        await tween(S.d, { elong }, 1700 * pace(), easeIn); if (signal.aborted) return;
        await tween(S.d, { y: upY }, 2100 * pace(), easeIn); if (signal.aborted) return;
        Silence.breathe(.005, 2);
        await tween(S.d, { y: baseY + .012, elong: 0 }, 1500 * pace(), easeOut); if (signal.aborted) return;
        await tween(S.d, { y: baseY }, 900 * pace());
      };
      await strain(baseY - .09, .35, .010); if (signal.aborted) return;
      await strain(baseY - .15, .55, .014); if (signal.aborted) return;
      S.d.trailMax = 60;
      await strain(baseY - .21, .80, .018); if (signal.aborted) return;

      // ═══ IV · THE COVENANT ═══  (interactive heart — wordless. everything stops. it beckons. you touch.)
      S.dustMode = 'frozen';
      Silence.suspendBreath();
      tween(S, { aurora: .35 }, 4000 * pace());
      S.d.trailMax = 0;
      await wait(BREATH(), signal); if (signal.aborted) return;
      tween(S, { sakshi: .3 }, 6000 * pace());
      await tween(S, { thread: 1 }, 5000 * pace()); if (signal.aborted) return;

      // wordless invitation: it turns fully to you, leans, brightens as you near. a faint seed pulses low.
      S.behavior = 'beckon';
      const hint = $('reachHint');
      hint.classList.add('on');
      const touch = await new Promise((res) => {
        const onDown = (e) => { scene.removeEventListener('pointerdown', onDown); res({ x: e.clientX / W, y: e.clientY / H }); };
        scene.addEventListener('pointerdown', onDown);
        signal.addEventListener('abort', () => { scene.removeEventListener('pointerdown', onDown); res(null); }, { once: true });
      });
      if (signal.aborted || !touch) return;
      hint.classList.remove('on'); S.behavior = 'none';

      // it crosses the whole distance to meet your hand — the piece's largest motion
      S.d.elongAngle = Math.atan2(touch.y * H - S.d.y * H, touch.x * W - S.d.x * W);
      S.d.trailMax = 40;
      await tween(S.d, { elong: .5 }, 900 * pace()); if (signal.aborted) return;
      await tween(S.d, { x: touch.x, y: touch.y }, 2800 * pace()); if (signal.aborted) return;
      await tween(S.d, { elong: 0 }, 500 * pace());
      // CONTACT — wordless; the touch itself is the covenant
      haptic(40);
      Silence.resumeBreath(); Silence.breathe(.025, 3); Silence.bell(272.2, 7, .028);
      for (let i = 0; i < 4; i++) S.ripples.push({ x: touch.x, y: touch.y, r: 8, a: .55, vr: 2.2 + i * .9, gold: true });
      S.pool = { x: touch.x, y: touch.y, r: 0 };
      tween(S.pool, { r: 90 }, 4000 * pace());
      tween(S.d, { r: 7.5, glow: 1.6 }, 2000 * pace());
      await wait(BREATH() * 1.6, signal); if (signal.aborted) return;   // hold the contact — the longest silence
      Silence.breathe(.008, 5);

      // ═══ V · DAWN ═══  (the world arrives because contact happened — ONE word, earned)
      S.dustMode = 'dawn';
      const RMAX = Math.hypot(W, H) * 1.1;
      tween(S, { bgWarm: 1 }, 9000 * pace(), easeInOut);
      await tween(S.pool, { r: RMAX }, 9000 * pace(), easeInOut); if (signal.aborted) return;
      tween(S, { sakshi: 0, aurora: 0, thread: 0 }, 2500 * pace());
      await engrave('Go.', signal, { big: true, hold: 2 }); if (signal.aborted) return;

      // hand the being back to the room, where your hand left it
      markThread('story');
      haptic(20);
      stage.set({ x: S.d.x, y: S.d.y, alpha: 1, breathing: true, trailMax: 0, r: 7 });
      stage.moveTo(.5, .26, 3400);
      cleanup();
      Silence.breathe(.004, 4);
      roomScene();
    } catch (e) {
      console.error('[bindu-story]', e);
      cleanup();
    }
  }

  window.BinduStory = {
    start,
    _dbg: () => ({
      hasS: !!S, tweens: tweens.length,
      d: S ? { x: +S.d.x.toFixed(3), y: +S.d.y.toFixed(3), alpha: S.d.alpha, flicker: S.d.flicker, gx: +S.d.gx.toFixed(2), gy: +S.d.gy.toFixed(2) } : null,
      bgWarm: S ? S.bgWarm : null, form: S ? (S.form && S.form.type) : null,
      behavior: S ? S.behavior : null, awareness: S ? +S.awareness.toFixed(2) : null,
      thread: S ? S.thread : null, canvas: cvs ? [cvs.width, cvs.height] : null,
    }),
  };
})();
