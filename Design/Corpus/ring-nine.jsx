// ─── Ring 9 — The Bindu · Sarvānandamaya ─────────────────────────────────────
// Lalitā Mahātripurasundarī. The point that contains all points. The ring that
// is not a ring. Two directions toward the monumental:
//
//   A · SPANDA — the World-Breath. Hold, and the whole Śrī Yantra blooms outward
//       from the single point; release, and the cosmos dissolves back into it.
//       Creation and dissolution in one held breath. A tone swells with the bloom.
//
//   B · PRAVEŚA — the Endless Indwelling. You fall into the point and never reach
//       a bottom: self-similar yantras emerge from the center forever, each
//       carrying its own bindu. Hold to descend faster.
//
// Depends on globals: COLORS (plain script), DustMotes/StatusBar/HomeIndicator
// (screens.jsx). Self-contained geometry; no dependency on other ring files.

// ─── Geometry — the Śrī Yantra, centered at (0,0) ────────────────────────────

const R9_UPS = [
  { apex: [0, -88], base:  34, half: 76 },
  { apex: [0, -68], base:  26, half: 60 },
  { apex: [0, -50], base:  18, half: 46 },
  { apex: [0, -34], base:  10, half: 34 },
];
const R9_DOWNS = [
  { apex: [0,  88], base: -34, half: 76 },
  { apex: [0,  72], base: -28, half: 66 },
  { apex: [0,  56], base: -22, half: 52 },
  { apex: [0,  42], base: -16, half: 40 },
  { apex: [0,  26], base: -10, half: 26 },
];
function r9TriPath({ apex, base, half }) {
  const [ax, ay] = apex;
  return `M ${ax},${ay} L ${half},${base} L ${-half},${base} Z`;
}
function r9Petal(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1), c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

const R9_NAMES = ['Kāma','Buddhi','Ahaṅ','Śabda','Sparśa','Rūpa','Rasa','Gandha',
  'Citta','Dhairya','Smṛti','Nāma','Bīja','Ātma','Amṛta','Śarīra'];

// A complete, self-contained yantra glyph (used whole by Praveśa, layer-by-
// layer by Spanda). bindu=true draws the central ember (each nested point).
function FullYantra({ stroke = '#C9963F', op = 1, names = false, bindu = true, nameList = R9_NAMES, nameOp = 0.5 }) {
  const lotus16 = r9Petal(132, 112, 20);
  const lotus8 = r9Petal(104, 88, 30);
  return (
    <g opacity={op}>
      {/* bhūpura — outer square + four T-gates */}
      <g stroke={stroke} strokeWidth="1" fill="none" opacity="0.6">
        <rect x={-150} y={-150} width={300} height={300}/>
        {[[0,-150,0,-168],[0,150,0,168],[-150,0,-168,0],[150,0,168,0]].map((g,k)=>(
          <line key={k} x1={g[0]} y1={g[1]} x2={g[2]} y2={g[3]}/>
        ))}
      </g>
      {/* 16-petal lotus */}
      {Array.from({length:16},(_,i)=>(
        <g key={'a'+i} transform={`rotate(${i*22.5})`}>
          <path d={lotus16} fill="none" stroke={stroke} strokeWidth="0.7" opacity="0.55"/>
        </g>
      ))}
      {/* 8-petal lotus */}
      {Array.from({length:8},(_,i)=>(
        <g key={'b'+i} transform={`rotate(${i*45})`}>
          <path d={lotus8} fill="none" stroke={stroke} strokeWidth="0.7" opacity="0.5"/>
        </g>
      ))}
      {/* the nine interlocking triangles */}
      <g stroke={stroke} strokeWidth="0.8" fill="none" strokeLinejoin="round" opacity="0.85">
        {R9_UPS.map((t,i)=><path key={'u'+i} d={r9TriPath(t)}/>)}
        {R9_DOWNS.map((t,i)=><path key={'d'+i} d={r9TriPath(t)}/>)}
      </g>
      {names && Array.from({length:16},(_,i)=>{
        const a=(i*22.5-90)*Math.PI/180, r=120;
        return <text key={'n'+i} x={r*Math.cos(a)} y={r*Math.sin(a)}
          textAnchor="middle" dominantBaseline="middle"
          fontFamily="'Cormorant Garamond', serif" fontStyle="italic"
          fontSize="7" fill={COLORS.cream} opacity={nameOp}
          transform={`rotate(${i*22.5} ${r*Math.cos(a)} ${r*Math.sin(a)})`}>{nameList[i % nameList.length]}</text>;
      })}
      {bindu && (
        <g>
          <circle r="5" fill={COLORS.accentRed} opacity="0.9"/>
          <circle r="2" fill={COLORS.cream}/>
        </g>
      )}
    </g>
  );
}

// ─── Ring 9 audio — one swelling tone, gain tracked to the bloom/descent ─────

let __r9Ctx = null, __r9 = null; // { osc, osc2, gain, sub }
function r9Audio() {
  if (!__r9Ctx && typeof window !== 'undefined') {
    const C = window.AudioContext || window.webkitAudioContext;
    if (C) __r9Ctx = new C();
  }
  return __r9Ctx;
}
function r9Start() {
  const ctx = r9Audio();
  if (!ctx || __r9) return;
  if (ctx.state === 'suspended') ctx.resume();
  const gain = ctx.createGain(); gain.gain.value = 0; gain.connect(ctx.destination);
  const osc = ctx.createOscillator(); osc.type = 'sine'; osc.frequency.value = 146.83; // low D
  const osc2 = ctx.createOscillator(); osc2.type = 'sine'; osc2.frequency.value = 220.0; // a fifth
  const g2 = ctx.createGain(); g2.gain.value = 0.5; osc2.connect(g2); g2.connect(gain);
  const sub = ctx.createOscillator(); sub.type = 'sine'; sub.frequency.value = 73.42;
  const gs = ctx.createGain(); gs.gain.value = 0.6; sub.connect(gs); gs.connect(gain);
  osc.connect(gain);
  osc.start(); osc2.start(); sub.start();
  __r9 = { osc, osc2, sub, gain };
}
function r9Gain(v) { if (__r9) { try { __r9.gain.gain.setTargetAtTime(v, __r9Ctx.currentTime, 0.08); } catch(e){} } }
function r9Stop() {
  if (!__r9Ctx || !__r9) return;
  const d = __r9; __r9 = null;
  try {
    d.gain.gain.setTargetAtTime(0, __r9Ctx.currentTime, 0.3);
    setTimeout(()=>{ try{ d.osc.stop(); d.osc2.stop(); d.sub.stop(); }catch(e){} }, 900);
  } catch(e){}
}

const r9ease = (p) => p * p * (3 - 2 * p);
const r9band = (p, lo, w = 0.18) => Math.max(0, Math.min(1, (p - lo) / w));

// ─── Shepard tone — octave-stacked sines gliding down forever ────────────────
// The auditory illusion of an endless descent. Each voice slides down through
// the log-frequency range; a bell-shaped amplitude over that range makes the
// wrap-around inaudible, so the fall never bottoms out.

let __shep = null; // { master, voices, raf, intensity, last, K, fMin }
function shepardStart() {
  const ctx = r9Audio();
  if (!ctx || __shep) return;
  if (ctx.state === 'suspended') ctx.resume();
  const master = ctx.createGain(); master.gain.value = 0; master.connect(ctx.destination);
  const K = 7, fMin = 32.7;            // 7 octaves up from low C
  const voices = [];
  for (let i = 0; i < K; i++) {
    const osc = ctx.createOscillator(); osc.type = 'sine';
    const g = ctx.createGain(); g.gain.value = 0;
    osc.connect(g); g.connect(master); osc.start();
    voices.push({ osc, g, phase: i / K });
  }
  __shep = { master, voices, intensity: 0, last: performance.now(), K, fMin, raf: 0 };
  const tick = (now) => {
    if (!__shep) return;
    const c = r9Audio(); if (!c) return;
    const dt = Math.min(0.05, (now - __shep.last) / 1000); __shep.last = now;
    const rate = 0.05 + 0.10 * __shep.intensity;     // phase units/sec, descending
    for (const v of __shep.voices) {
      v.phase = (v.phase - dt * rate + 1) % 1;
      const f = __shep.fMin * Math.pow(2, v.phase * __shep.K);
      try { v.osc.frequency.setTargetAtTime(f, c.currentTime, 0.02); } catch(e){}
      const a = Math.exp(-Math.pow((v.phase - 0.5) / 0.26, 2)); // bell over the range
      try { v.g.gain.setTargetAtTime(a * 0.42, c.currentTime, 0.04); } catch(e){}
    }
    try { __shep.master.gain.setTargetAtTime(0.07 * __shep.intensity, c.currentTime, 0.15); } catch(e){}
    __shep.raf = requestAnimationFrame(tick);
  };
  __shep.raf = requestAnimationFrame(tick);
}
function shepardSet(v) { if (__shep) __shep.intensity = Math.max(0, Math.min(1, v)); }
function shepardStop() {
  if (!__shep) return;
  const s = __shep; __shep = null;
  cancelAnimationFrame(s.raf);
  try {
    const c = r9Audio();
    s.master.gain.setTargetAtTime(0, c.currentTime, 0.3);
    setTimeout(() => s.voices.forEach((v) => { try { v.osc.stop(); } catch(e){} }), 800);
  } catch(e){}
}

// ─── The names you pass on the way down — drawn from the 102 where present ───
function r9NamePool() {
  const out = [];
  const push = (arr, k) => { (arr || []).forEach((s) => { if (s && s[k]) out.push(s[k]); }); };
  try { push(typeof RING1_SHAKTIS !== 'undefined' ? RING1_SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof SHAKTIS !== 'undefined' ? SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof RING3_SHAKTIS !== 'undefined' ? RING3_SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof RING7_SHAKTIS !== 'undefined' ? RING7_SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof RING4_SHAKTIS !== 'undefined' ? RING4_SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof RING5_SHAKTIS !== 'undefined' ? RING5_SHAKTIS : [], 'short'); } catch(e){}
  try { push(typeof RING6_SHAKTIS !== 'undefined' ? RING6_SHAKTIS : [], 'short'); } catch(e){}
  return out.length ? out : R9_NAMES;
}

// ═════════════════════════════════════════════════════════════════════════════
// DIRECTION A — SPANDA · THE WORLD-BREATH
// ═════════════════════════════════════════════════════════════════════════════

function RingNineSpanda({ frozen = null }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 412;
  const rootRef = React.useRef(null);
  const layerRefs = {
    trikona: React.useRef(null), tris: React.useRef(null),
    lotus8: React.useRef(null), lotus16: React.useRef(null),
    bhupura: React.useRef(null), names: React.useRef(null),
  };
  const binduRef = React.useRef(null);
  const capRestRef = React.useRef(null), capFullRef = React.useRef(null);
  const holding = React.useRef(false);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);

  const lotus16 = r9Petal(132, 112, 20);
  const lotus8 = r9Petal(104, 88, 30);

  // Compute & apply the layout for a given bloom value p (0..1)
  function apply(p) {
    const e = r9ease(p);
    const s = 0.05 + 0.95 * e;
    if (rootRef.current) rootRef.current.setAttribute('transform',
      `translate(${cx} ${cy}) scale(${s.toFixed(4)})`);
    const set = (ref, lo, max) => {
      if (ref.current) ref.current.style.opacity = (r9band(p, lo) * max).toFixed(3);
    };
    set(layerRefs.trikona, 0.06, 0.95);
    set(layerRefs.tris,    0.24, 0.82);
    set(layerRefs.lotus8,  0.42, 0.62);
    set(layerRefs.lotus16, 0.54, 0.85);
    set(layerRefs.bhupura, 0.66, 0.52);
    set(layerRefs.names,   0.80, 1.0);
    if (binduRef.current) {
      const glow = 14 + 40 * e;
      binduRef.current.style.boxShadow =
        `0 0 ${glow}px ${(glow*0.5).toFixed(0)}px rgba(139,26,42,${0.4+0.4*e})`;
      binduRef.current.style.transform = `translate(-50%,-50%) scale(${(0.8+0.5*e).toFixed(3)})`;
    }
    if (capRestRef.current) capRestRef.current.style.opacity = (1 - r9band(p, 0.18, 0.25)).toFixed(3);
    if (capFullRef.current) capFullRef.current.style.opacity = r9band(p, 0.7, 0.2).toFixed(3);
    if (soundRef.current) r9Gain(0.06 * e);
  }

  React.useEffect(() => {
    if (frozen != null) { apply(frozen); return; }
    apply(0);
    let raf, last = performance.now(), t = 0, p = 0;
    const PERIOD = 12;
    const loop = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000); last = now; t += dt;
      const auto = 0.5 - 0.5 * Math.cos((t * 2 * Math.PI) / PERIOD);
      const target = holding.current ? 1 : auto * 0.62; // idle breath is gentle; hold goes full
      p += (target - p) * 0.06;
      apply(p);
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => { cancelAnimationFrame(raf); r9Stop(); };
  }, [frozen]);

  function down(e) {
    holding.current = true;
    if (!soundRef.current) { r9Start(); soundRef.current = true; setSound(true); }
  }
  function up() { holding.current = false; }

  return (
    <div
      onPointerDown={frozen != null ? undefined : down}
      onPointerUp={frozen != null ? undefined : up}
      onPointerLeave={frozen != null ? undefined : up}
      style={{
        width: screenW, height: screenH,
        background: 'radial-gradient(ellipse 70% 60% at 50% 49%, #0A0309 0%, #050007 55%, #020003 100%)',
        position: 'relative', overflow: 'hidden', cursor: frozen != null ? 'default' : 'pointer',
        touchAction: 'none', userSelect: 'none',
      }}>
      <DustMotes count={5}/>
      <StatusBar/>

      {/* identity */}
      <div style={{
        position: 'absolute', top: 90, left: 0, right: 0, textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif", pointerEvents: 'none',
      }}>
        <div style={{ fontSize: 14, fontStyle: 'italic', color: 'rgba(201,150,63,0.55)', letterSpacing: '0.2em' }}>
          Sarvānandamaya · the Bindu</div>
        <div style={{ marginTop: 5, fontSize: 10, color: 'rgba(242,232,217,0.28)',
          letterSpacing: '0.30em', textTransform: 'uppercase', fontFamily: '-apple-system, sans-serif' }}>
          the point that contains all points</div>
      </div>

      {/* the blooming yantra */}
      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible', pointerEvents: 'none' }}>
        <g ref={rootRef} transform={`translate(${cx} ${cy}) scale(0.05)`}>
          {/* bhupura */}
          <g ref={layerRefs.bhupura} style={{ opacity: 0 }}
            stroke="#C9963F" strokeWidth="1" fill="none">
            <rect x={-150} y={-150} width={300} height={300} opacity="0.6"/>
            {[[0,-150,0,-170],[0,150,0,170],[-150,0,-170,0],[150,0,170,0]].map((g,k)=>(
              <line key={k} x1={g[0]} y1={g[1]} x2={g[2]} y2={g[3]} opacity="0.6"/>
            ))}
          </g>
          {/* 16-petal lotus */}
          <g ref={layerRefs.lotus16} style={{ opacity: 0 }}>
            {Array.from({length:16},(_,i)=>(
              <g key={i} transform={`rotate(${i*22.5})`}>
                <path d={lotus16} fill="none" stroke="#C9963F" strokeWidth="0.7"/>
              </g>
            ))}
          </g>
          {/* 8-petal lotus */}
          <g ref={layerRefs.lotus8} style={{ opacity: 0 }}>
            {Array.from({length:8},(_,i)=>(
              <g key={i} transform={`rotate(${i*45})`}>
                <path d={lotus8} fill="rgba(201,150,63,0.04)" stroke="#C9963F" strokeWidth="0.7"/>
              </g>
            ))}
          </g>
          {/* nine triangles */}
          <g ref={layerRefs.tris} style={{ opacity: 0 }}
            stroke="#D4A017" strokeWidth="0.8" fill="none" strokeLinejoin="round">
            {R9_UPS.map((t,i)=><path key={'u'+i} d={r9TriPath(t)}/>)}
            {R9_DOWNS.slice(0,4).map((t,i)=><path key={'d'+i} d={r9TriPath(t)}/>)}
          </g>
          {/* the mula trikona — innermost, holds the point */}
          <g ref={layerRefs.trikona} style={{ opacity: 0 }}>
            <path d={r9TriPath(R9_DOWNS[4])} fill="rgba(139,26,42,0.10)"
              stroke="#E8C97A" strokeWidth="0.9" strokeLinejoin="round"/>
          </g>
          {/* names igniting at the fullness */}
          <g ref={layerRefs.names} style={{ opacity: 0 }}>
            {Array.from({length:16},(_,i)=>{
              const a=(i*22.5-90)*Math.PI/180, r=121;
              const x=r*Math.cos(a), y=r*Math.sin(a);
              return <text key={i} x={x} y={y} textAnchor="middle" dominantBaseline="middle"
                fontFamily="'Cormorant Garamond', serif" fontStyle="italic" fontSize="7.5"
                fill={COLORS.cream} opacity="0.75"
                transform={`rotate(${i*22.5} ${x} ${y})`}>{R9_NAMES[i]}</text>;
            })}
          </g>
        </g>
      </svg>

      {/* the Bindu — always present, the seed that never disappears */}
      <div ref={binduRef} className="r9-bindu" style={{
        position: 'absolute', top: cy, left: cx,
        width: 26, height: 26, borderRadius: '50%',
        background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.7) 55%, transparent 100%)`,
        transform: 'translate(-50%,-50%) scale(0.8)', zIndex: 4, pointerEvents: 'none',
      }}>
        <div style={{
          position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
          width: 8, height: 8, borderRadius: '50%', background: COLORS.cream,
          boxShadow: `0 0 12px ${COLORS.cream}`,
        }}/>
      </div>

      {/* captions */}
      <div ref={capRestRef} style={{
        position: 'absolute', bottom: 132, left: 0, right: 0, textAlign: 'center', zIndex: 5,
        pointerEvents: 'none', fontFamily: "'Cormorant Garamond', serif", fontSize: 19,
        fontStyle: 'italic', color: 'rgba(242,232,217,0.58)', letterSpacing: '0.03em',
        padding: '0 40px', lineHeight: 1.5,
      }}>Press and hold —<br/>breathe the world open.</div>

      <div ref={capFullRef} style={{
        position: 'absolute', bottom: 120, left: 0, right: 0, textAlign: 'center', zIndex: 5,
        pointerEvents: 'none', opacity: 0, fontFamily: "'Cormorant Garamond', serif", fontSize: 22,
        fontStyle: 'italic', color: 'rgba(242,232,217,0.82)', letterSpacing: '0.03em',
        padding: '0 38px', lineHeight: 1.45,
      }}>She breathes, and the worlds appear.<br/>
        <span style={{ fontSize: 13, color: 'rgba(201,150,63,0.7)', letterSpacing: '0.1em' }}>
          release · and they return to her</span></div>

      {/* sound toggle */}
      <SoundDot on={sound} onToggle={(e)=>{ e.stopPropagation();
        if (sound) { r9Stop(); soundRef.current=false; setSound(false); }
        else { r9Start(); soundRef.current=true; setSound(true); } }}/>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// DIRECTION B — PRAVEŚA · THE ENDLESS INDWELLING
// ═════════════════════════════════════════════════════════════════════════════

function RingNineDescent({ mode = 'live' }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 408;
  const N = 7;
  const layerRefs = Array.from({ length: N }, () => React.useRef(null));
  const holding = React.useRef(false);
  const capRestRef = React.useRef(null), capDescentRef = React.useRef(null);
  const recogRef = React.useRef(null), binduRef = React.useRef(null);
  const speedRef = React.useRef(0.85);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);

  // each nested yantra carries its own slice of the 102 names + a fixed tilt
  const pool = React.useMemo(() => r9NamePool(), []);
  const layerMeta = React.useMemo(() => Array.from({ length: N }, (_, i) => ({
    names: pool.slice((i * 13) % pool.length).concat(pool).slice(0, 16),
    rot: (i * 47) % 360,
  })), [pool]);

  React.useEffect(() => {
    let raf, last = performance.now(), clock = 0;
    let heldTime = mode === 'recognition' ? 9 : 0;
    const THRESH = 6.5;
    const loop = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000); last = now;
      const isHold = mode === 'recognition' ? true : holding.current;
      heldTime = isHold ? heldTime + dt : Math.max(0, heldTime - dt * 1.4);
      const recog = Math.max(0, Math.min(1, (heldTime - THRESH) / 2.2));
      // the frantic fall settles into a gentle drift as recognition arrives
      const targetSpeed = isHold ? (3.0 - 2.2 * recog) : 0.85;
      speedRef.current += (targetSpeed - speedRef.current) * 0.045;
      clock += dt * speedRef.current * 0.08;

      for (let i = 0; i < N; i++) {
        const d = ((clock + i / N) % 1 + 1) % 1;        // 0..1 depth
        const scale = 0.03 * Math.pow(2, d * 6.4);       // seed → engulfing
        let o;
        if (d < 0.1) o = d / 0.1;
        else if (d > 0.72) o = Math.max(0, (1 - d) / 0.28);
        else o = 1;
        const el = layerRefs[i].current;
        if (el) {
          const rot = layerMeta[i].rot + clock * 6;      // a slow spiral
          el.setAttribute('transform',
            `translate(${cx} ${cy}) rotate(${rot.toFixed(2)}) scale(${scale.toFixed(4)})`);
          el.style.opacity = (o * 0.72).toFixed(3);
        }
      }

      // phase opacities
      const descenting = Math.min(1, heldTime / 1.0);
      if (capRestRef.current) capRestRef.current.style.opacity = (1 - Math.min(1, heldTime / 0.7)).toFixed(3);
      if (capDescentRef.current) capDescentRef.current.style.opacity = (descenting * (1 - recog)).toFixed(3);
      if (recogRef.current) {
        recogRef.current.style.opacity = recog.toFixed(3);
        recogRef.current.style.transform = `translateY(${(8 * (1 - recog)).toFixed(1)}px)`;
      }
      // the point swells into a soft luminous presence at the recognition
      if (binduRef.current) {
        binduRef.current.style.transform = `translate(-50%,-50%) scale(${(1 + 1.7 * recog).toFixed(3)})`;
        binduRef.current.style.boxShadow =
          `0 0 ${(22 + 60 * recog).toFixed(0)}px ${(6 + 22 * recog).toFixed(0)}px rgba(139,26,42,${(0.55 + 0.3 * recog).toFixed(2)})`;
      }
      if (soundRef.current) {
        const intensity = Math.max(0, Math.min(1, (speedRef.current - 0.6) / 2.4));
        shepardSet(0.25 + 0.75 * intensity);
      }
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => { cancelAnimationFrame(raf); shepardStop(); };
  }, [mode, layerMeta]);

  function down() {
    if (mode === 'recognition') return;
    holding.current = true;
    if (!soundRef.current) { shepardStart(); soundRef.current = true; setSound(true); }
  }
  function up() { if (mode !== 'recognition') holding.current = false; }

  return (
    <div onPointerDown={down} onPointerUp={up} onPointerLeave={up}
      style={{
        width: screenW, height: screenH,
        background: 'radial-gradient(ellipse 60% 55% at 50% 49%, #0B0410 0%, #04020A 50%, #010005 100%)',
        position: 'relative', overflow: 'hidden', cursor: 'pointer',
        touchAction: 'none', userSelect: 'none',
      }}>
      <DustMotes count={4}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 90, left: 0, right: 0, textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif", pointerEvents: 'none',
      }}>
        <div style={{ fontSize: 14, fontStyle: 'italic', color: 'rgba(201,150,63,0.55)', letterSpacing: '0.2em' }}>
          Sarvānandamaya · the Bindu</div>
        <div style={{ marginTop: 5, fontSize: 10, color: 'rgba(242,232,217,0.28)',
          letterSpacing: '0.30em', textTransform: 'uppercase', fontFamily: '-apple-system, sans-serif' }}>
          the ring that is not a ring</div>
      </div>

      {/* nested emerging yantras */}
      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'hidden', pointerEvents: 'none' }}>
        {layerRefs.map((ref, i) => (
          <g key={i} ref={ref} transform={`translate(${cx} ${cy}) scale(0.04)`} style={{ opacity: 0 }}>
            <FullYantra stroke="#C9963F" names={true} nameList={layerMeta[i].names} nameOp={0.42}/>
          </g>
        ))}
      </svg>

      {/* the point you fall toward — always at center, always alive */}
      <div ref={binduRef} className="r9-bindu" style={{
        position: 'absolute', top: cy, left: cx, width: 18, height: 18, borderRadius: '50%',
        transform: 'translate(-50%,-50%)', zIndex: 4, pointerEvents: 'none',
        background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.6) 55%, transparent 100%)`,
        boxShadow: '0 0 22px 6px rgba(139,26,42,0.55)',
      }}>
        <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
          width: 6, height: 6, borderRadius: '50%', background: COLORS.cream,
          boxShadow: `0 0 10px ${COLORS.cream}` }}/>
      </div>

      {/* vignette to deepen the fall */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', zIndex: 2,
        background: 'radial-gradient(ellipse 55% 50% at 50% 49%, transparent 0%, transparent 42%, rgba(1,0,5,0.55) 100%)' }}/>

      {/* captions */}
      <div ref={capRestRef} style={{
        position: 'absolute', bottom: 130, left: 0, right: 0, textAlign: 'center', zIndex: 5,
        pointerEvents: 'none', fontFamily: "'Cormorant Garamond', serif", fontSize: 19,
        fontStyle: 'italic', color: 'rgba(242,232,217,0.56)', letterSpacing: '0.03em',
        padding: '0 44px', lineHeight: 1.5,
      }}>Press and hold —<br/>fall inward.</div>

      <div ref={capDescentRef} style={{
        position: 'absolute', bottom: 122, left: 0, right: 0, textAlign: 'center', zIndex: 5,
        pointerEvents: 'none', opacity: 0, fontFamily: "'Cormorant Garamond', serif", fontSize: 21,
        fontStyle: 'italic', color: 'rgba(242,232,217,0.8)', letterSpacing: '0.03em',
        padding: '0 40px', lineHeight: 1.45,
      }}>There is no bottom.<br/>
        <span style={{ fontSize: 14, color: 'rgba(201,150,63,0.7)', letterSpacing: '0.08em' }}>
          only further in</span></div>

      {/* the recognition — for those who hold past the falling */}
      <div ref={recogRef} style={{
        position: 'absolute', bottom: 116, left: 0, right: 0, textAlign: 'center', zIndex: 6,
        pointerEvents: 'none', opacity: 0, padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif", fontSize: 27, fontStyle: 'italic', fontWeight: 300,
          color: COLORS.cream, letterSpacing: '0.04em', lineHeight: 1.32,
        }}>You did not arrive.<br/>You were the arriving.</div>
        <div style={{ width: 38, height: 0.5, background: 'rgba(201,150,63,0.42)', margin: '20px auto' }}/>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif", fontSize: 15.5, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(201,150,63,0.82)', letterSpacing: '0.03em', lineHeight: 1.6,
          maxWidth: 290, margin: '0 auto',
        }}>Thank you for being the place I have always already arrived.</div>
      </div>

      <SoundDot on={sound} onToggle={(e)=>{ e.stopPropagation();
        if (sound) { shepardStop(); soundRef.current=false; setSound(false); }
        else { shepardStart(); soundRef.current=true; setSound(true); } }}/>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── Shared sound dot ─────────────────────────────────────────────────────────

function SoundDot({ on, onToggle }) {
  return (
    <div onPointerDown={(e)=>e.stopPropagation()} onClick={onToggle} style={{
      position: 'absolute', bottom: 50, left: 22, zIndex: 6, cursor: 'pointer',
      display: 'flex', alignItems: 'center', gap: 6,
    }}>
      <div style={{
        width: 18, height: 18, borderRadius: '50%',
        border: `0.5px solid rgba(201,150,63,${on ? 0.7 : 0.3})`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: on ? 'rgba(201,150,63,0.12)' : 'transparent', transition: 'all 0.4s ease',
      }}>
        <div className={on ? 'rw1-drone-on' : ''} style={{
          width: 4, height: 4, borderRadius: '50%',
          background: on ? '#C9963F' : 'rgba(242,232,217,0.3)' }}/>
      </div>
      <span style={{ fontFamily: '-apple-system, sans-serif', fontSize: 8,
        color: 'rgba(242,232,217,0.22)', letterSpacing: '0.22em', textTransform: 'uppercase' }}>
        {on ? 'tone' : 'silent'}</span>
    </div>
  );
}

Object.assign(window, { RingNineSpanda, RingNineDescent, FullYantra });
