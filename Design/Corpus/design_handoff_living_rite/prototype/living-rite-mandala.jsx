// living-rite-mandala.jsx — The Śrī Yantra Mandala Universe (home).
// A single continuous space you fall through: zoom out to the whole instrument;
// zoom in until each of the 102 energies names herself and reveals her
// significance. Pan · pinch · wheel · double-tap. Tap any energy to fly into
// her — camera glides in, her meaning blooms, her bīja can be sounded, and
// "her presence" opens the full detail. Built on the real 102 seated in their
// true enclosures, floating in a starfield.

const SY_R = 320;                 // yantra radius in local px
const SY_BOX = 760;               // wrapper size (local)
const SY_C = SY_BOX / 2;          // local center

// ─── The nine interlocking triangles (5 Śakti down · 4 Śiva up) ──────────────
const SY_DOWN = [
  { topY: -0.30, apexY: 1.00, hw: 0.98 },
  { topY: -0.48, apexY: 0.80, hw: 0.80 },
  { topY: -0.64, apexY: 0.58, hw: 0.62 },
  { topY: -0.79, apexY: 0.36, hw: 0.45 },
  { topY: -0.91, apexY: 0.16, hw: 0.29 },
];
const SY_UP = [
  { botY: 0.33, apexY: -0.99, hw: 0.92 },
  { botY: 0.51, apexY: -0.77, hw: 0.75 },
  { botY: 0.67, apexY: -0.55, hw: 0.57 },
  { botY: 0.81, apexY: -0.31, hw: 0.41 },
];
function syTriPaths(r) {
  const out = [];
  SY_DOWN.forEach(t => out.push(`M ${(-t.hw*r).toFixed(1)} ${(t.topY*r).toFixed(1)} L ${(t.hw*r).toFixed(1)} ${(t.topY*r).toFixed(1)} L 0 ${(t.apexY*r).toFixed(1)} Z`));
  SY_UP.forEach(t => out.push(`M ${(-t.hw*r).toFixed(1)} ${(t.botY*r).toFixed(1)} L ${(t.hw*r).toFixed(1)} ${(t.botY*r).toFixed(1)} L 0 ${(t.apexY*r).toFixed(1)} Z`));
  return out;
}

// ─── Seat layout — all 102 in their enclosures ───────────────────────────────
const SY_RING_R = { 1: 306, 2: 268, 3: 224, 4: 178, 5: 145, 6: 116, 7: 88, 8: 52, 9: 0 };
function sySquarePerimeter(t, H) {
  const p = (((t % 1) + 1) % 1) * 4;
  if (p < 1) return { x: -H + p * 2 * H, y: -H };
  if (p < 2) return { x: H, y: -H + (p - 1) * 2 * H };
  if (p < 3) return { x: H - (p - 2) * 2 * H, y: H };
  return { x: -H, y: H - (p - 3) * 2 * H };
}
function sySeats() {
  const seats = [];
  LR_ALL.forEach(s => {
    const list = LR_ALL.filter(x => x.ring === s.ring);
    const idx = list.findIndex(x => x.kp === s.kp), n = list.length;
    if (s.ring === 1) { const pt = sySquarePerimeter((idx + 0.5) / n, SY_RING_R[1]); seats.push({ s, x: pt.x, y: pt.y }); }
    else if (s.ring === 9) seats.push({ s, x: 0, y: 0 });
    else { const a = (idx / n) * 2 * Math.PI - Math.PI / 2, r = SY_RING_R[s.ring]; seats.push({ s, x: r * Math.cos(a), y: r * Math.sin(a) }); }
  });
  return seats;
}
const SY_SEATS = sySeats();
const SY_POS = (() => { const m = {}; SY_SEATS.forEach(({ s, x, y }) => { m[s.kp] = { x, y }; }); return m; })();
const LR_LALITA = LR_ALL.find(x => x.ring === 9) || LR_ALL[LR_ALL.length - 1];

// Her family — the energies she is threaded to. Ring 2 gathers by cluster
// (Inner Instrument, Sense Streams, …); every other ring is its own family.
function syFamily(s) {
  const fam = s.ring === 2
    ? LR_ALL.filter(x => x.ring === 2 && x.cluster === s.cluster)
    : LR_ALL.filter(x => x.ring === s.ring);
  return fam.filter(x => x.kp !== s.kp);
}

// ─── Starfield (the space the yantra floats in) ──────────────────────────────
const SY_STARS = (() => {
  const stars = [];
  let seed = 20260711;
  const rnd = () => { seed = (seed * 1664525 + 1013904223) >>> 0; return seed / 4294967296; };
  for (let i = 0; i < 150; i++) {
    const a = rnd() * Math.PI * 2, rr = 120 + rnd() * 620;
    stars.push({ x: Math.cos(a) * rr, y: Math.sin(a) * rr, s: 0.5 + rnd() * 1.8, o: 0.12 + rnd() * 0.5, tw: rnd() > 0.6, d: rnd() * 6 });
  }
  return stars;
})();

const SY_ORDINAL = ['', 'First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Ninth'];

// ─── Static yantra geometry ──────────────────────────────────────────────────
function SriYantraGeometry() {
  const gold = LR_BASE.gold;
  const line = (d, w, o) => <path d={d} fill="none" stroke={gold} strokeWidth={w} opacity={o} strokeLinejoin="round" />;
  const els = []; let k = 0;
  const push = (el) => els.push(React.cloneElement(el, { key: k++ }));
  [1.0, 0.94, 0.88].forEach((f, i) => { const h = SY_R * f; push(line(`M ${-h} ${-h} H ${h} V ${h} H ${-h} Z`, 1.1, 0.5 - i * 0.1)); });
  const hg = SY_R, gw = SY_R * 0.11, gd = SY_R * 0.05;
  [[0,-1],[1,0],[0,1],[-1,0]].forEach(([dx,dy]) => {
    const gx = dx*hg, gy = dy*hg, px = dy !== 0 ? 1 : 0, py = dx !== 0 ? 1 : 0;
    push(line(`M ${gx-px*gw} ${gy-py*gw} L ${gx-px*gw-dx*gd} ${gy-py*gw-dy*gd} L ${gx+px*gw-dx*gd} ${gy+py*gw-dy*gd} L ${gx+px*gw} ${gy+py*gw}`, 1, 0.45));
  });
  [0.90, 0.80, 0.70, 0.615].forEach((f, i) => push(<circle cx="0" cy="0" r={SY_R*f} fill="none" stroke={gold} strokeWidth="0.8" opacity={0.3 - i*0.02} />));
  for (let i = 0; i < 16; i++) push(line(lrPetalPath(0,0, SY_R*0.80, SY_R*0.90, 360/16/2.4, i*360/16), 0.9, 0.34));
  for (let i = 0; i < 8; i++) push(line(lrPetalPath(0,0, SY_R*0.615, SY_R*0.70, 360/8/2.5, i*360/8 + 22.5), 0.9, 0.36));
  push(<circle cx="0" cy="0" r={SY_R*0.60} fill="none" stroke={gold} strokeWidth="1" opacity="0.4" />);
  syTriPaths(SY_R*0.585).forEach(d => push(line(d, 1, 0.5)));
  push(<circle cx="0" cy="0" r={SY_R*0.10} fill="url(#syBinduGlow)" style={{ animation: 'syBinduBreath 5.5s ease-in-out infinite', transformOrigin: 'center' }} />);
  return <g style={{ animation: 'syShimmer 8s ease-in-out infinite' }}>{els}</g>;
}

function syInfo(s) {
  const av = LR_AVARANA_BY_RING[s.ring];
  const cl = s.cluster && window.CLUSTER_INFO ? window.CLUSTER_INFO[s.cluster] : null;
  const sig = s.description || (av && av.personalConnection) || (av ? av.subtitle : '');
  return { quality: lrQuality(s), bija: s.bija, cluster: cl ? cl.label : (av ? av.form : ''), av, sig, phonetic: s.phonetic };
}

// ─── The Bindu opens — Lalitā, the source ────────────────────────────────────
// Not a card: an arrival. The field recedes, the red point blooms to fill, and
// She — the ground from which all 102 emerge — settles into presence. The 102
// gather as a faint returning field around Her.
function LalitaSource({ onEnter, onReturn }) {
  const s = LR_LALITA;
  const gold = LR_BASE.gold, cream = LR_BASE.cream;
  const [snd, setSnd] = React.useState(false);
  const soundSource = () => { try { lrPlayBija && lrPlayBija('ॐ — Oṁ'); } catch (e) {} setSnd(true); setTimeout(() => setSnd(false), 1400); };
  const em = (d) => ({ animation: `syEmerge 1.1s ${d}s both cubic-bezier(0.2,0.85,0.3,1)` });
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 40, overflow: 'hidden',
      fontFamily: LR_SERIF, color: cream,
      background: 'radial-gradient(ellipse 90% 70% at 50% 42%, #2a0a12, #12060b 55%, #060205)',
    }}>
      {/* the red point blooming to fill, then settling */}
      <div style={{ position: 'absolute', left: '50%', top: '42%', width: 1400, height: 1400, transform: 'translate(-50%,-50%)', pointerEvents: 'none', background: `radial-gradient(circle, ${LR_BASE.red} 0%, rgba(139,26,42,0.35) 22%, transparent 60%)`, animation: 'syDescendBloom 1.6s cubic-bezier(0.2,0.8,0.3,1) both' }} />
      {/* the returning field — the 102 gathered around Her, slowly turning */}
      <div style={{ position: 'absolute', left: '50%', top: '42%', transform: 'translate(-50%,-50%)', pointerEvents: 'none', animation: 'syEmerge 2.4s 0.4s both' }}>
        <div style={{ position: 'relative', width: 620, height: 620, animation: 'syOrbit 160s linear infinite' }}>
          {SY_SEATS.map(({ s: ss, x, y }, i) => (
            <span key={i} style={{ position: 'absolute', left: 310 + x * 0.82, top: 310 + y * 0.82, width: 2.4, height: 2.4, borderRadius: '50%', background: gold, opacity: 0.22, boxShadow: `0 0 4px ${gold}` }} />
          ))}
        </div>
      </div>
      {/* Her presence — a luminous point that contains all points */}
      <div style={{ position: 'absolute', left: '50%', top: '42%', transform: 'translate(-50%,-50%)', pointerEvents: 'none' }}>
        <div style={{ width: 172, height: 172, borderRadius: '50%', background: `radial-gradient(circle, ${cream} 0%, ${gold} 34%, rgba(139,26,42,0.5) 62%, transparent 78%)`, animation: 'syPresenceIn 1.6s cubic-bezier(0.2,0.8,0.3,1) both, syBinduBreath 6.5s 1.6s ease-in-out infinite', filter: 'blur(0.4px)' }} />
      </div>

      {/* words — emerging from the light */}
      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-end', textAlign: 'center', padding: '0 30px 30px', zIndex: 2 }}>
        <div style={{ ...em(1.5) }}>
          <LrLabel size={10.5} color={gold} tracking="0.34em">Ninth Āvaraṇa · The Bindu</LrLabel>
        </div>
        <div style={{ ...em(1.7), fontStyle: 'italic', fontSize: 15, color: 'rgba(242,232,217,0.62)', marginTop: 12 }}>the point that contains all points</div>
        <div style={{ ...em(1.95), fontWeight: 300, fontSize: 68, lineHeight: 1, letterSpacing: '0.05em', marginTop: 18, textShadow: `0 0 60px ${gold}` }}>{s.short || 'Lalitā'}</div>
        <div style={{ ...em(2.15), fontWeight: 300, fontSize: 22, letterSpacing: '0.14em', color: 'rgba(242,232,217,0.82)', marginTop: 12 }}>{s.name}</div>
        <div style={{ ...em(2.4), margin: '20px 0' }}><LrHairline width={48} color={`color-mix(in oklab, ${gold} 70%, transparent)`} /></div>
        <div style={{ ...em(2.55), fontSize: 20, lineHeight: 1.5, color: gold, maxWidth: 320, textWrap: 'pretty' }}>{s.quality}</div>
        <div style={{ ...em(2.8), fontStyle: 'italic', fontSize: 16, lineHeight: 1.62, color: 'rgba(242,232,217,0.72)', maxWidth: 320, marginTop: 18, textWrap: 'pretty' }}>
          There is nothing else here. The whole yantra breathes outward from this point — and every energy you have met is Her, turned for a moment toward you.
        </div>
        <button onClick={soundSource} aria-label="sound the source" style={{ ...em(3.0), background: 'none', border: 'none', cursor: 'pointer', marginTop: 18, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5 }}>
          <span style={{ fontFamily: LR_SERIF, fontSize: 30, color: gold, opacity: snd ? 1 : 0.85, textShadow: snd ? `0 0 26px ${gold}` : 'none', transition: 'all 0.4s ease' }}>ॐ</span>
          <span style={{ fontFamily: 'ui-sans-serif,sans-serif', fontSize: 8, letterSpacing: '0.2em', textTransform: 'uppercase', color: 'rgba(242,232,217,0.4)' }}>sound the source</span>
        </button>
        <button onClick={() => onEnter(s)} style={{ ...em(3.15), width: '100%', maxWidth: 360, marginTop: 22, height: 54, border: 'none', borderRadius: 27, cursor: 'pointer', background: `linear-gradient(135deg, ${LR_BASE.red}, color-mix(in oklab, ${LR_BASE.red} 60%, ${gold} 40%))`, boxShadow: `0 6px 44px rgba(139,26,42,0.6)`, fontFamily: LR_SERIF, fontSize: 20, letterSpacing: '0.1em', color: cream }}>enter her presence</button>
        <button onClick={onReturn} style={{ ...em(3.3), background: 'none', border: 'none', cursor: 'pointer', marginTop: 14, fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 15, color: 'rgba(242,232,217,0.55)', letterSpacing: '0.05em' }}>↑ return to the field</button>
      </div>
    </div>
  );
}

// ─── The Mandala Universe ─────────────────────────────────────────────────────
function MandalaHome({ dayAtmo, todayShakti, countByKp, onOpenShakti }) {
  const box = React.useRef(null);
  const [view, setView] = React.useState({ scale: 0.5, tx: 0, ty: 0, ready: false });
  const vref = React.useRef(view); vref.current = view;
  const [focus, setFocus] = React.useState(null);   // focused seat {s,x,y}
  const [descent, setDescent] = React.useState(false);   // fallen into the bindu → Lalitā
  const armed = React.useRef(true);                  // auto-descent re-arm guard
  const [sound, setSound] = React.useState(() => { try { return localStorage.getItem('lr_sound') === '1'; } catch (e) { return false; } });
  const [flash, setFlash] = React.useState(null);    // {ring,id} transient enclosure flash
  const enteredRef = React.useRef(0);                // deepest ring currently crossed
  const lastChime = React.useRef(0);
  const drag = React.useRef(null);
  const pinch = React.useRef(null);
  const raf = React.useRef(null);
  const animating = React.useRef(false);      // a programmatic camera move is running
  const moved = React.useRef(false);          // any pan/pinch this gesture — suppresses tap
  const lastTap = React.useRef(0);

  const clamp = (s) => Math.max(0.32, Math.min(5.5, s));

  const fit = React.useCallback(() => {
    const el = box.current; if (!el) return;
    const w = el.clientWidth, h = el.clientHeight;
    const scale = clamp(Math.min(w, h) / SY_BOX * 0.94);
    cancelAnimationFrame(raf.current);
    animating.current = false;
    setView({ scale, tx: (w - SY_BOX*scale)/2, ty: (h - SY_BOX*scale)/2, ready: true });
    setFocus(null);
  }, []);
  React.useEffect(() => { fit(); }, [fit]);
  React.useEffect(() => () => cancelAnimationFrame(raf.current), []);

  const animateTo = (target, cb) => {
    cancelAnimationFrame(raf.current);
    animating.current = true;
    const from = { ...vref.current }, t0 = performance.now(), dur = 720;
    const step = (now) => {
      const p = Math.min(1, (now - t0) / dur), e = 1 - Math.pow(1 - p, 3);
      setView({ ready: true,
        scale: from.scale + (target.scale - from.scale) * e,
        tx: from.tx + (target.tx - from.tx) * e,
        ty: from.ty + (target.ty - from.ty) * e });
      if (p < 1) raf.current = requestAnimationFrame(step); else { animating.current = false; if (cb) cb(); }
    };
    raf.current = requestAnimationFrame(step);
  };

  const zoomAt = (sx, sy, factor) => {
    const v = vref.current, ns = clamp(v.scale * factor), k = ns / v.scale;
    cancelAnimationFrame(raf.current); animating.current = false;
    setView({ ...v, scale: ns, tx: sx - (sx - v.tx) * k, ty: sy - (sy - v.ty) * k });
  };

  const flyToSeat = (seat) => {
    const el = box.current; if (!el) return;
    const w = el.clientWidth, h = el.clientHeight;
    const scale = clamp(3.0);
    const cx = w / 2, cy = h * 0.36;
    animateTo({ scale, tx: cx - (SY_C + seat.x) * scale, ty: cy - (SY_C + seat.y) * scale });
    setFocus(seat);
  };

  // Fall into the source — the bindu opens into Lalitā. The camera completes the
  // descent toward the point, then she emerges from the light.
  const openDescent = React.useCallback(() => {
    const el = box.current; if (!el) return;
    setFocus(null); armed.current = false;
    const w = el.clientWidth, h = el.clientHeight, scale = clamp(5.4);
    animateTo({ scale, tx: w / 2 - SY_C * scale, ty: h * 0.44 - SY_C * scale }, () => setDescent(true));
  }, []);

  const ascend = React.useCallback(() => { setDescent(false); armed.current = false; fit(); }, [fit]);

  const onWheel = (e) => { e.preventDefault(); const r = box.current.getBoundingClientRect(); zoomAt(e.clientX - r.left, e.clientY - r.top, e.deltaY < 0 ? 1.12 : 1/1.12); };
  const onPointerDown = (e) => { if (e.pointerType === 'touch') return; animating.current = false; moved.current = false; drag.current = { x: e.clientX, y: e.clientY, tx: view.tx, ty: view.ty }; };
  const onPointerMove = (e) => { if (!drag.current) return; const dx = e.clientX - drag.current.x, dy = e.clientY - drag.current.y; if (Math.abs(dx)+Math.abs(dy) > 4) moved.current = true; cancelAnimationFrame(raf.current); setView(v => ({ ...v, tx: drag.current.tx + dx, ty: drag.current.ty + dy })); };
  const onPointerUp = () => { drag.current = null; };
  const dist = (a, b) => Math.hypot(a.clientX - b.clientX, a.clientY - b.clientY);
  const onTouchStart = (e) => {
    animating.current = false;
    if (e.touches.length === 2) { pinch.current = { d: dist(e.touches[0], e.touches[1]), scale: view.scale }; moved.current = true; }
    else if (e.touches.length === 1) { moved.current = false; drag.current = { x: e.touches[0].clientX, y: e.touches[0].clientY, tx: view.tx, ty: view.ty }; }
  };
  const onTouchMove = (e) => {
    const r = box.current.getBoundingClientRect();
    if (e.touches.length === 2 && pinch.current) {
      e.preventDefault(); moved.current = true;
      const nd = dist(e.touches[0], e.touches[1]);
      const cx = (e.touches[0].clientX + e.touches[1].clientX)/2 - r.left, cy = (e.touches[0].clientY + e.touches[1].clientY)/2 - r.top;
      const v = vref.current, ns = clamp(pinch.current.scale * (nd / pinch.current.d)), k = ns / v.scale;
      cancelAnimationFrame(raf.current);
      setView({ ...v, scale: ns, tx: cx - (cx - v.tx) * k, ty: cy - (cy - v.ty) * k });
    } else if (e.touches.length === 1 && drag.current) {
      const dx = e.touches[0].clientX - drag.current.x, dy = e.touches[0].clientY - drag.current.y;
      if (Math.abs(dx)+Math.abs(dy) > 4) moved.current = true;
      cancelAnimationFrame(raf.current); setView(v => ({ ...v, tx: drag.current.tx + dx, ty: drag.current.ty + dy }));
    }
  };
  const onTouchEnd = (e) => {
    if (e.touches.length === 0) {
      // double-tap on empty space → zoom in toward the point
      if (!moved.current && e.changedTouches.length && !(e.target.closest && e.target.closest('button[title]'))) {
        const now = Date.now(), r = box.current.getBoundingClientRect();
        if (now - lastTap.current < 300) { zoomAt(e.changedTouches[0].clientX - r.left, e.changedTouches[0].clientY - r.top, 1.7); lastTap.current = 0; }
        else lastTap.current = now;
      }
      drag.current = null; pinch.current = null;
    }
  };

  const sc = view.scale;
  const tier = sc < 1.15 ? 0 : sc < 2.3 ? 1 : 2;     // 0 cosmic · 1 named · 2 significance
  const seatTapped = (seat) => { if (moved.current) return; if (seat.s.ring === 9) { openDescent(); return; } if (focus && focus.s.kp === seat.s.kp) onOpenShakti(seat.s); else flyToSeat(seat); };

  // Auto-descent — fall far enough into the center and the bindu opens on its own.
  React.useEffect(() => {
    if (descent || animating.current) return;
    const el = box.current; if (!el) return;
    const w = el.clientWidth, h = el.clientHeight;
    const bx = view.tx + SY_C * view.scale, by = view.ty + SY_C * view.scale;
    const near = Math.hypot(bx - w / 2, by - h / 2) < 64;
    if (view.scale < 2.8) armed.current = true;          // re-arm once pulled back
    if (armed.current && view.scale > 4.3 && near) openDescent();
  }, [view.scale, view.tx, view.ty, descent, openDescent]);

  // Ring-entry chimes — crossing each enclosure inward rings a soft bell and
  // flashes that ring. Zoom-driven (falling in); silent on the way out.
  const toggleSound = () => setSound(v => { const n = !v; try { localStorage.setItem('lr_sound', n ? '1' : '0'); } catch (e) {} return n; });
  React.useEffect(() => {
    const el = box.current; if (!el || descent) return;
    const reachLocal = (Math.min(el.clientWidth, el.clientHeight) * 0.5) / view.scale;
    let entered = 0;
    for (let r = 1; r <= 8; r++) { if (SY_RING_R[r] > reachLocal) entered = r; }
    if (entered !== enteredRef.current) {
      const prev = enteredRef.current;
      enteredRef.current = entered;
      if (entered > prev && entered >= 1) {                 // crossed inward
        setFlash({ ring: entered, id: Date.now() });
        const t = performance.now();
        if (sound && t - lastChime.current > 55) { lrRingChime(entered); lastChime.current = t; }
      }
    }
  }, [view.scale, view.tx, view.ty, descent, sound]);

  const info = focus ? syInfo(focus.s) : null;
  const focusAtmo = focus ? lrApplyTime(lrAtmosphere(focus.s), null) : dayAtmo;
  const family = React.useMemo(() => (focus ? syFamily(focus.s) : []), [focus]);
  const familySet = React.useMemo(() => new Set(family.map(x => x.kp)), [family]);
  const familyLabel = focus ? (focus.s.ring === 2 && window.CLUSTER_INFO && focus.s.cluster ? window.CLUSTER_INFO[focus.s.cluster].label : (LR_AVARANA_BY_RING[focus.s.ring] || {}).name) : '';

  return (
    <div data-screen-label="The Mandala — Śrī Yantra" style={{
      position: 'absolute', inset: 0, overflow: 'hidden',
      background: `radial-gradient(ellipse 80% 55% at 50% 44%, ${dayAtmo.glow}, transparent 66%), radial-gradient(circle at 50% 44%, #0a0611, #050308 60%, #030105)`,
      fontFamily: LR_SERIF, color: LR_BASE.cream, touchAction: 'none',
    }}>
      <div ref={box}
        onWheel={onWheel}
        onPointerDown={onPointerDown} onPointerMove={onPointerMove} onPointerUp={onPointerUp} onPointerLeave={onPointerUp}
        onTouchStart={onTouchStart} onTouchMove={onTouchMove} onTouchEnd={onTouchEnd}
        onDoubleClick={(e) => { const r = box.current.getBoundingClientRect(); zoomAt(e.clientX - r.left, e.clientY - r.top, 1.7); }}
        style={{ position: 'absolute', inset: 0, cursor: drag.current ? 'grabbing' : 'grab' }}
      >
        <div style={{ position: 'absolute', left: 0, top: 0, width: SY_BOX, height: SY_BOX, transformOrigin: '0 0', transform: `translate(${view.tx}px, ${view.ty}px) scale(${view.scale})`, visibility: view.ready ? 'visible' : 'hidden' }}>
          {/* starfield */}
          <div style={{ position: 'absolute', left: SY_C, top: SY_C, width: 0, height: 0, pointerEvents: 'none' }}>
            {SY_STARS.map((st, i) => (
              <span key={i} style={{ position: 'absolute', left: st.x, top: st.y, width: st.s, height: st.s, borderRadius: '50%', background: i % 5 === 0 ? LR_BASE.gold : '#F2E8D9', opacity: st.o, animation: st.tw ? `syTwinkle ${5+st.d}s ${st.d}s ease-in-out infinite` : 'none' }} />
            ))}
          </div>

          <svg width={SY_BOX} height={SY_BOX} viewBox={`${-SY_C} ${-SY_C} ${SY_BOX} ${SY_BOX}`} style={{ position: 'absolute', inset: 0, overflow: 'visible' }}>
            <defs>
              <radialGradient id="syBinduGlow"><stop offset="0%" stopColor={LR_BASE.red} stopOpacity="0.6" /><stop offset="100%" stopColor={LR_BASE.red} stopOpacity="0" /></radialGradient>
            </defs>
            {/* today's enclosure, softly lit */}
            {SY_RING_R[todayShakti.ring] > 0 ? (
              <circle cx="0" cy="0" r={SY_RING_R[todayShakti.ring]} fill="none" stroke={dayAtmo.accent} strokeWidth={2 / sc} opacity="0.5" strokeDasharray={`${2/sc} ${4/sc}`} />
            ) : null}
            {/* enclosure crossed — a brief threshold flash */}
            {flash && SY_RING_R[flash.ring] > 0 ? (
              <circle key={flash.id} cx="0" cy="0" r={SY_RING_R[flash.ring]} fill="none" stroke={LR_BASE.gold} strokeWidth={2.5 / sc} vectorEffect="non-scaling-stroke" style={{ animation: 'syRingFlash 1.5s ease-out forwards' }} />
            ) : null}
            <SriYantraGeometry />
            {/* constellation — her family threads to her */}
            {focus ? (
              <g>
                {family.map((m, i) => {
                  const p = SY_POS[m.kp]; if (!p) return null;
                  return (
                    <line key={m.kp} x1={focus.x} y1={focus.y} x2={p.x} y2={p.y}
                      stroke={focusAtmo.accentBright} strokeWidth="1" vectorEffect="non-scaling-stroke"
                      pathLength="1" strokeDasharray="1" strokeDashoffset="1"
                      style={{ animation: `syThread 0.7s ${(0.05 + i * 0.035).toFixed(2)}s ease forwards` }} />
                  );
                })}
              </g>
            ) : null}
          </svg>

          {/* enclosure names — appear as you enter (tier 1) */}
          {tier >= 1 ? [1,2,3,4,5,6,7,8,9].map(ring => {
            const av = LR_AVARANA_BY_RING[ring]; const r = SY_RING_R[ring];
            return (
              <div key={ring} style={{ position: 'absolute', left: SY_C, top: SY_C + (ring === 9 ? 18 : -r - 8), transform: 'translate(-50%,-50%)', pointerEvents: 'none', whiteSpace: 'nowrap' }}>
                <span style={{ fontFamily: 'ui-sans-serif,sans-serif', fontSize: 9 / Math.min(sc,2), letterSpacing: '0.22em', textTransform: 'uppercase', color: 'rgba(201,150,63,0.6)' }}>{SY_ORDINAL[ring]} · {av.form}</span>
              </div>
            );
          }) : null}

          {/* seats */}
          {SY_SEATS.map(({ s, x, y }) => {
            const isToday = s.kp === todayShakti.kp;
            const isFocus = focus && focus.s.kp === s.kp;
            const n = (countByKp || {})[s.kp] || 0, felt = n > 0;
            const sAtmo = lrAtmosphere(s);
            const inFamily = familySet.has(s.kp);
            const dimmed = focus && !isFocus && !inFamily;   // recede while a family is lit
            const dotR = isFocus ? 7 : isToday ? 6 : inFamily ? 5.5 : felt ? 4 + Math.min(n,6)*0.4 : 3;
            const col = isToday || isFocus ? LR_BASE.cream : inFamily ? focusAtmo.accentBright : felt ? sAtmo.accentBright : sAtmo.accent;
            const lit = felt || isToday || isFocus || inFamily;
            const showName = tier >= 1 || inFamily || isFocus;
            // each energy breathes and flares on her own rhythm — the field is alive
            const bDur = (3.4 + (s.kp % 7) * 0.7).toFixed(2);
            const bDelay = (-(s.kp % 11) * 0.6).toFixed(2);
            const fDur = (8 + (s.kp % 13)).toFixed(2);
            const fDelay = (-((s.kp * 1.7) % (8 + (s.kp % 13)))).toFixed(2);
            return (
              <button key={s.kp} onClick={() => seatTapped({ s, x, y })} title={s.name}
                style={{ position: 'absolute', left: SY_C + x, top: SY_C + y, transform: 'translate(-50%,-50%)', width: Math.max(26, dotR*2.8), height: Math.max(26, dotR*2.8), background: 'none', border: 'none', cursor: 'pointer', padding: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: isFocus ? 4 : inFamily ? 3 : 1, opacity: dimmed ? 0.28 : 1, transition: 'opacity 0.5s ease', pointerEvents: dimmed ? 'none' : 'auto' }}>
                {/* flare — an occasional soft bloom inviting the eye */}
                <span style={{ position: 'absolute', width: dotR * 2, height: dotR * 2, borderRadius: '50%', background: `radial-gradient(circle, ${lit ? col : sAtmo.accentSoft}, transparent 70%)`, opacity: 0, animation: `syFlare ${fDur}s ${fDelay}s ease-out infinite`, pointerEvents: 'none' }} />
                <span style={{ position: 'absolute', width: dotR*2, height: dotR*2, borderRadius: '50%', background: col, opacity: lit ? 1 : 0.5, boxShadow: lit ? `0 0 ${isFocus ? 16 : isToday ? 12 : 6 + n}px ${col}` : 'none', animation: isToday && !isFocus ? 'syPulse 2.6s ease-in-out infinite' : `syBreath ${bDur}s ${bDelay}s ease-in-out infinite` }} />
                {(isToday || isFocus) ? <span style={{ position: 'absolute', width: 22, height: 22, borderRadius: '50%', border: `1px solid ${col}`, opacity: 0.55, animation: 'syRing 2.6s ease-in-out infinite' }} /> : null}
                {showName ? (
                  <span style={{ position: 'absolute', top: '100%', marginTop: 3, whiteSpace: 'nowrap', fontFamily: LR_SERIF, fontSize: 9, color: lit ? 'rgba(242,232,217,0.82)' : 'rgba(242,232,217,0.4)', pointerEvents: 'none', transform: `scale(${1/Math.min(Math.max(sc,1),2.4)})`, transformOrigin: 'top center' }}>
                    {tier >= 2 || inFamily ? s.name : (s.short || s.name)}
                  </span>
                ) : null}
                {tier >= 2 && !isFocus ? (
                  <span style={{ position: 'absolute', top: '100%', marginTop: 15, whiteSpace: 'nowrap', maxWidth: 160, fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 7.5, color: sAtmo.accentBright, opacity: 0.85, pointerEvents: 'none', transform: `scale(${1/Math.min(Math.max(sc,1),2.4)})`, transformOrigin: 'top center', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {s.bija ? `bīja ${s.bija.split(' — ')[0]}` : ''}
                  </span>
                ) : null}
              </button>
            );
          })}
        </div>
      </div>

      {/* header */}
      <div style={{ position: 'absolute', top: LR_SAFE_TOP - 10, left: 0, right: 0, textAlign: 'center', pointerEvents: 'none', zIndex: 5 }}>
        <h1 style={{ margin: 0, fontWeight: 300, fontSize: 25, letterSpacing: '0.1em' }}>Śrī Yantra</h1>
        <LrLabel size={9.5} color="rgba(242,232,217,0.42)" style={{ marginTop: 5 }}>
          {tier === 0 ? 'the whole instrument · pinch to fall in' : tier === 1 ? 'the nine enclosures' : 'tap an energy · fall to the center for the source'}
        </LrLabel>
      </div>

      {/* significance card — blooms when an energy is focused */}
      {focus && info ? (
        <div style={{ position: 'absolute', left: 12, right: 12, bottom: 14, zIndex: 8, animation: 'syCardUp 0.5s cubic-bezier(0.2,0.9,0.3,1)' }}>
          <div style={{
            background: `radial-gradient(ellipse 120% 80% at 50% 0%, ${focusAtmo.glow}, transparent 70%), linear-gradient(160deg, rgba(20,10,14,0.92), rgba(8,4,7,0.95))`,
            border: `1px solid ${focusAtmo.accentSoft}`, borderRadius: 20, padding: '18px 20px 16px', backdropFilter: 'blur(10px)',
            boxShadow: `0 10px 50px rgba(0,0,0,0.6), 0 0 40px ${focusAtmo.glow}`,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
              <LrLabel size={9.5} color={focusAtmo.accentBright} tracking="0.24em">{SY_ORDINAL[focus.s.ring]} Āvaraṇa · {info.cluster}</LrLabel>
              <button onClick={() => { setFocus(null); fit(); }} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'rgba(242,232,217,0.5)', fontSize: 20, lineHeight: 1, padding: 4 }}>×</button>
            </div>
            <div style={{ display: 'flex', gap: 16, alignItems: 'flex-start' }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: LR_SERIF, fontWeight: 300, fontSize: lrNameSize(focus.s.name, 32), lineHeight: 1.08, letterSpacing: '0.03em' }}>{focus.s.name}</div>
                {info.phonetic ? <LrLabel size={10} color="rgba(242,232,217,0.5)" tracking="0.2em" style={{ marginTop: 8 }}>{info.phonetic}</LrLabel> : null}
                <div style={{ fontFamily: LR_SERIF, fontSize: 18, color: focusAtmo.accentBright, marginTop: 10, textWrap: 'pretty' }}>{info.quality}</div>
                {family.length ? (
                  <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 13, color: 'rgba(242,232,217,0.5)', marginTop: 8 }}>
                    threaded to {family.length} {family.length === 1 ? 'sister' : 'sisters'} · {familyLabel}
                  </div>
                ) : null}
              </div>
              {info.bija ? (
                <button onClick={() => lrPlayBija(info.bija)} aria-label={`sound bīja ${info.bija}`} style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, flexShrink: 0, padding: 4 }}>
                  <span style={{ fontFamily: LR_SERIF, fontSize: 42, lineHeight: 1, color: LR_BASE.gold, textShadow: `0 0 24px ${focusAtmo.glow}` }}>{info.bija.split(' — ')[0]}</span>
                  <span style={{ fontFamily: 'ui-sans-serif,sans-serif', fontSize: 8, letterSpacing: '0.18em', textTransform: 'uppercase', color: 'rgba(242,232,217,0.42)' }}>sound her</span>
                </button>
              ) : null}
            </div>
            {info.sig ? (
              <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 14, lineHeight: 1.5, color: 'rgba(242,232,217,0.72)', marginTop: 12, maxHeight: 84, overflow: 'hidden', textWrap: 'pretty' }}>{info.sig}</div>
            ) : null}
            <button onClick={() => onOpenShakti(focus.s)} style={{ width: '100%', marginTop: 14, height: 46, border: 'none', borderRadius: 23, cursor: 'pointer', background: `linear-gradient(135deg, ${LR_BASE.red}, color-mix(in oklab, ${LR_BASE.red} 66%, ${focusAtmo.accent} 34%))`, fontFamily: LR_SERIF, fontSize: 17, letterSpacing: '0.1em', color: LR_BASE.cream }}>enter her presence</button>
          </div>
        </div>
      ) : null}

      {/* zoom controls */}
      <div style={{ position: 'absolute', right: 16, bottom: focus ? 'auto' : 26, top: focus ? LR_SAFE_TOP + 30 : 'auto', zIndex: 9, display: 'flex', flexDirection: 'column', gap: 10 }}>
        <button onClick={toggleSound} aria-label={sound ? 'mute ring chimes' : 'enable ring chimes'} title="ring chimes"
          style={{ width: 46, height: 46, borderRadius: '50%', cursor: 'pointer', background: sound ? `color-mix(in oklab, ${LR_BASE.gold} 22%, rgba(13,5,8,0.6))` : 'rgba(13,5,8,0.55)', border: `1px solid ${sound ? LR_BASE.gold : dayAtmo.accentSoft}`, color: sound ? LR_BASE.gold : 'rgba(242,232,217,0.4)', fontFamily: LR_SERIF, fontSize: 20, lineHeight: 1, backdropFilter: 'blur(6px)', position: 'relative' }}>
          ♪{sound ? '' : <span style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 26, color: 'rgba(242,232,217,0.35)' }}>⁄</span>}
        </button>
        {[['+', 1.4], ['−', 1/1.4]].map(([lbl, f]) => (
          <button key={lbl} aria-label={lbl === '+' ? 'zoom in' : 'zoom out'} onClick={() => { const el = box.current; zoomAt(el.clientWidth/2, el.clientHeight/2, f); }}
            style={{ width: 46, height: 46, borderRadius: '50%', cursor: 'pointer', background: 'rgba(13,5,8,0.55)', border: `1px solid ${dayAtmo.accentSoft}`, color: LR_BASE.cream, fontFamily: LR_SERIF, fontSize: 24, lineHeight: 1, backdropFilter: 'blur(6px)' }}>{lbl}</button>
        ))}
        <button onClick={fit} aria-label="see the whole" title="the whole" style={{ width: 46, height: 46, borderRadius: '50%', cursor: 'pointer', background: 'rgba(13,5,8,0.55)', border: `1px solid ${dayAtmo.accentSoft}`, color: dayAtmo.accentBright, fontFamily: 'ui-sans-serif,sans-serif', fontSize: 15, backdropFilter: 'blur(6px)' }}>⤢</button>
      </div>

      {/* the bindu opens — Lalitā */}
      {descent ? <LalitaSource onEnter={onOpenShakti} onReturn={ascend} /> : null}
    </div>
  );
}

Object.assign(window, { MandalaHome });
