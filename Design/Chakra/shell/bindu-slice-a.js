// bindu-slice-a.js — Slice A: the Gate, the Arrival, the Room.
// Scored to the breath clock. Canon text from Walk Canon v1.0.
(function () {
  'use strict';
  const { Silence, BREATH, wait, haptic, requestWakeLock, easeOut } = window.BinduEngine;
  const B = () => window.WALK_CANON.rooms.find(r => r.identity.book_position === 1);

  const $ = (id) => document.getElementById(id);
  let stage = null;                 // DotStage — created at boot
  let abort = null;                 // AbortController per scene

  // ── state ──
  const KEY = 'bindu-immersive-state';
  function loadState() {
    try { return JSON.parse(localStorage.getItem(KEY)) || { arrived: false, threads: {}, gate_given: false }; }
    catch (e) { return { arrived: false, threads: {}, gate_given: false }; }
  }
  let state = loadState();
  let debugNoSave = false;                             // set by __bindu debug calls — never persist verification walks
  function save() { if (debugNoSave) return; try { localStorage.setItem(KEY, JSON.stringify(state)); } catch (e) {} }

  // ── scene plumbing ──
  function show(id) {
    document.querySelectorAll('.scene').forEach(s => {
      const on = s.id === id;
      s.classList.toggle('active', on);
    });
  }
  function newScene() {
    if (abort) abort.abort();
    abort = new AbortController();
    return abort.signal;
  }
  // word-spoken text into an element
  async function speak(el, text, signal, msPerWord = 120) {
    el.innerHTML = '';
    el.classList.add('visible');
    const words = text.split(' ');
    for (const w of words) {
      if (signal.aborted) return;
      const span = document.createElement('span');
      span.className = 'word';
      span.textContent = w + ' ';
      el.appendChild(span);
      await wait(msPerWord * window.BinduEngine.pace(), signal);
    }
  }
  function unspeak(el) { el.classList.remove('visible'); setTimeout(() => { el.innerHTML = ''; }, 1600); }

  // still-touch: rest one finger, be still, for `ms`
  function stillTouch(surface, ms, onProgress, signal) {
    return new Promise((resolve) => {
      let x0 = 0, y0 = 0, t0 = 0, iv = null;
      const stop = () => { clearInterval(iv); iv = null; onProgress(0); };
      const down = (e) => {
        x0 = e.clientX; y0 = e.clientY; t0 = Date.now();
        iv = setInterval(() => {
          const p = Math.min(1, (Date.now() - t0) / ms);
          onProgress(p);
          if (p >= 1) { cleanup(); resolve(); }
        }, 50);
      };
      const move = (e) => { if (iv && Math.hypot(e.clientX - x0, e.clientY - y0) > 24) stop(); };
      const up = () => stop();
      function cleanup() {
        clearInterval(iv);
        surface.removeEventListener('pointerdown', down);
        surface.removeEventListener('pointermove', move);
        surface.removeEventListener('pointerup', up);
        surface.removeEventListener('pointerleave', up);
      }
      surface.addEventListener('pointerdown', down);
      surface.addEventListener('pointermove', move);
      surface.addEventListener('pointerup', up);
      surface.addEventListener('pointerleave', up);
      if (signal) signal.addEventListener('abort', cleanup, { once: true });
    });
  }

  // ═══ ACT 0 · THE HELD THRESHOLD ═══
  function sceneGate() {
    const signal = newScene();
    show('scene-gate');
    const seed = $('gateSeed'), rings = $('gateRings'), inst = $('gateInst'), fill = $('gateFill'), bar = $('gateBar');
    setTimeout(() => $('gateHead').classList.add('visible'), 600);
    setTimeout(() => inst.classList.add('visible'), 2600);

    let holding = false, prog = 0, raf = null;
    const HOLD = BREATH();                             // 5s — one full breath
    const surface = $('scene-gate');

    function tick() {
      if (!holding) return;
      prog += 16 / HOLD;
      fill.style.width = Math.min(prog * 100, 100) + '%';
      rings.classList.add('growing');
      if (prog >= 1) { complete(); return; }
      raf = requestAnimationFrame(tick);
    }
    const down = () => { holding = true; bar.classList.add('visible'); raf = requestAnimationFrame(tick); };
    const up = () => { holding = false; prog = 0; fill.style.width = '0%'; rings.classList.remove('growing'); bar.classList.remove('visible'); };
    surface.addEventListener('pointerdown', down);
    surface.addEventListener('pointerup', up);
    surface.addEventListener('pointerleave', up);

    async function complete() {
      surface.removeEventListener('pointerdown', down);
      surface.removeEventListener('pointerup', up);
      surface.removeEventListener('pointerleave', up);
      Silence.unlock();
      requestWakeLock();
      haptic(30);
      Silence.breathe(0.006, 3);                       // the room now has a body
      document.body.classList.add('settle');           // the screen exhales
      seed.classList.add('done');
      await wait(1800, signal);
      sceneArrival();
    }
  }

  // ═══ ACT I · ARRIVAL ═══
  async function sceneArrival() {
    const signal = newScene();
    show('scene-arrival');
    const hint = $('arrHint'), question = $('arrQuestion'), aff = $('arrAff');
    const returning = state.arrived;

    if (returning) {
      // single-breath version — the dot is already theirs
      stage.set({ x: 0.5, y: 0.42, alpha: 1, breathing: true });
      await wait(BREATH(), signal); if (signal.aborted) return;
      sceneRoom();
      return;
    }

    stage.set({ x: 0.5, y: 0.42 });
    await wait(BREATH() * 2, signal); if (signal.aborted) return;   // two breaths of empty cream
    await stage.condense(BREATH() * 2.4);                            // ~12s condensation
    if (signal.aborted) return;
    await wait(BREATH(), signal); if (signal.aborted) return;        // a long stillness

    hint.textContent = B().arrival.threshold_hint;
    hint.classList.add('visible');
    await wait(BREATH() * 1.6, signal); if (signal.aborted) return;

    question.textContent = B().arrival.core_question;
    question.classList.add('visible');
    await wait(BREATH() * 1.4, signal); if (signal.aborted) return;

    aff.classList.add('visible');

    // rest one finger on the glass, and be still — one full breath
    const baseX = stage.dot.x, baseY = stage.dot.y;
    await stillTouch($('scene-arrival'), BREATH(), (p) => {
      // the dot leans toward the covenant; the room leans in with sound
      stage.set({ wanderAmp: 0 });
      if (p > 0) {
        Silence.breathe(0.004 + p * 0.008, 1);
        aff.classList.remove('visible');
      } else {
        Silence.breathe(0.004, 2);
        if (!signal.aborted) aff.classList.add('visible');
      }
    }, signal);
    if (signal.aborted) return;

    haptic(20);
    unspeak(hint); question.classList.remove('visible'); aff.classList.remove('visible');
    await wait(900, signal); if (signal.aborted) return;
    await stage.blink();                                // the first act of life
    await wait(BREATH() * 0.6, signal); if (signal.aborted) return;

    state.arrived = true; save();
    sceneRoom();
  }

  // ═══ ACT I · THE ROOM ═══
  async function sceneRoom() {
    const signal = newScene();
    show('scene-room');
    Silence.breathe(0.004, 4);                          // resting presence
    stage.set({ breathing: true, trailMax: 0, alpha: 1 });
    stage.moveTo(0.5, 0.26, 3200);
    stage.set({ wanderAmp: 3 });                        // idle micro-drift — alive

    const seedEl = $('roomSeed'), doorsEl = $('roomDoors'), sealEl = $('roomSeal'), footEl = $('roomFoot');
    seedEl.textContent = state.gate_given ? B().story.signature_phrase : B().arrival.seed_message;
    setTimeout(() => seedEl.classList.add('visible'), 2400);
    setTimeout(() => footEl.classList.add('visible'), 4200);

    // the three doors, one full breath apart
    const TH = state.threads;
    const doors = [
      { key: 'story',    title: 'The story',    sub: 'in Bindu\u2019s voice' },
      { key: 'practice', title: 'The practice', sub: 'one line at a time' },
      { key: 'wakeup',   title: 'One sound.',   sub: 'there is no sound yet' },
    ];
    doorsEl.innerHTML = '';
    doors.forEach((d, i) => {
      const btn = document.createElement('button');
      btn.className = 'door' + (TH[d.key] ? ' walked' : '');
      btn.innerHTML = '<span class="slit"></span><span class="door-text"><span class="door-title">' + d.title +
        '</span>' + (TH[d.key] ? '<span class="door-sub">walked</span>' : (d.sub ? '<span class="door-sub">' + d.sub + '</span>' : '')) + '</span>';
      btn.style.transitionDelay = '0s';
      btn.style.animationDelay = (2.5 + i * (BREATH() / 1000)) + 's';   // one breath apart
      btn.addEventListener('click', () => enterDoor(d));
      doorsEl.appendChild(btn);
    });

    // the gate — warm or waiting, always shown as shape
    const warm = TH.story && TH.practice && TH.wakeup && !state.gate_given;
    sealEl.innerHTML = '';
    if (state.gate_given) {
      sealEl.innerHTML = '<span class="walked-mark">walked</span>';
    } else if (warm) {
      const btn = document.createElement('button');
      btn.className = 'door gate-door';
      btn.innerHTML = '<span class="ember"></span><span class="door-text"><span class="door-title">The gate</span><span class="door-sub">The gate is warm.</span></span>';
      btn.style.animationDelay = (2.5 + 3 * (BREATH() / 1000)) + 's';
      btn.addEventListener('click', () => enterDoor({ key: 'gate', title: 'The gate' }));
      sealEl.appendChild(btn);
    } else if (TH.story || TH.practice || TH.wakeup) {
      sealEl.innerHTML = '<div class="seal-row"><span class="seal-glyph"></span><span class="seal-note">The gate knows how to wait too.</span></div>';
      sealEl.querySelector('.seal-row').style.animationDelay = (2.5 + 3 * (BREATH() / 1000)) + 's';
    }
  }

  // the dot enters every moment ahead of the walker
  async function enterDoor(d) {
    const signal = newScene();
    Silence.breathe(0.010, 2);                          // one breath of crossing
    await stage.moveTo(0.12, stage.dot.y, 2000);
    if (signal.aborted) return;
    if (d.key === 'story' && window.BinduStory) { window.BinduStory.start(); return; }
    scenePlaceholder(d);
  }

  // ═══ Slice B/C doors — honest held state ═══
  async function scenePlaceholder(d) {
    const signal = newScene();
    show('scene-hold');
    Silence.breathe(0.004, 3);
    stage.set({ wanderAmp: 2 });
    stage.moveTo(0.5, 0.36, 3000);
    const t = $('holdTitle'), n = $('holdNote');
    t.textContent = d.title;
    n.innerHTML = 'This door opens in the next slice. <span class="nc">interface · held</span>';
    t.classList.add('visible');
    setTimeout(() => n.classList.add('visible'), 1600);
    // way back — drag from the left edge, or the quiet word
    const back = $('holdBack');
    back.classList.add('visible');
    back.onclick = () => { t.classList.remove('visible'); n.classList.remove('visible'); back.classList.remove('visible'); sceneRoom(); };
  }

  // ── the leaving gesture — drag from the left edge, everywhere ──
  (function edgeReturn() {
    let startX = null;
    window.addEventListener('pointerdown', (e) => { if (e.clientX < 24) startX = e.clientX; });
    window.addEventListener('pointerup', (e) => {
      if (startX !== null && e.clientX - startX > 70 && !$('scene-room').classList.contains('active') && state.arrived) {
        sceneRoom();
      }
      startX = null;
    });
  })();

  // ── boot ──
  function boot() {
    stage = window.BinduEngine.DotStage($('dotCanvas'));
    const skipGate = window.BINDU_TWEAKS && window.BINDU_TWEAKS.skipGate;
    if (skipGate) { Silence.unlock(); Silence.breathe(0.005, 2); sceneArrival(); }
    else sceneGate();
  }
  window.addEventListener('bindu-reset', () => {
    state = { arrived: false, threads: {}, gate_given: false }; save();
    location.reload();
  });

  // debug/verification API — not part of the room. Never persists.
  window.__bindu = {
    toRoom: () => { debugNoSave = true; state.arrived = true; sceneRoom(); },
    toArrival: () => { debugNoSave = true; sceneArrival(); },
    state: () => state,
    silence: Silence,
    stage: () => stage,
    markThread: (k) => { state.threads[k] = true; save(); },
    roomScene: () => sceneRoom(),
    ctl: { show, newScene },
  };

  // The tweaks island is Babel-transformed and assigns window.BINDU_TWEAKS after
  // DOMContentLoaded — wait briefly for it so persisted tweaks (skipGate) apply on load.
  function bootWhenReady(deadline) {
    if (window.BINDU_TWEAKS || performance.now() > deadline) boot();
    else setTimeout(() => bootWhenReady(deadline), 50);
  }
  const arm = () => bootWhenReady(performance.now() + 3000);
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', arm);
  else arm();
})();
