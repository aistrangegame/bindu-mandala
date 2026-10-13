// ─── Ring Worlds III — Phase 3c ──────────────────────────────────────────────
// Rings 3, 4, 5, 6 — each finding its own verb.
//   3 · Anaṅga      — the Smoke Lotus (bodyless desire; reach and it dissolves)
//   4 · Sampradāya  — the Lineage (the teaching travels teacher → student)
//   5 · Kulottīrṇa  — the Overflow (light transcends the boundary that holds it)
//   6 · Nigarbha    — the Concealed (revealed only by nearness, then hidden again)
//
// Depends on globals: COLORS, RING3_SHAKTIS, RING4_SHAKTIS, RING5_SHAKTIS,
// RING6_SHAKTIS (plain scripts) · DustMotes/StatusBar/HomeIndicator (screens.jsx).

// ─── Shared helpers ───────────────────────────────────────────────────────────

function R3ReturnArc({ color = 'rgba(201,150,63,0.30)' }) {
  return (
    <div style={{ position: 'absolute', top: 56, left: '50%', transform: 'translateX(-50%)',
      pointerEvents: 'none', zIndex: 3 }}>
      <svg width="80" height="14" viewBox="0 0 80 14">
        <path d="M 8,11 Q 40,3 72,11" fill="none" stroke={color} strokeWidth="0.7" strokeLinecap="round"/>
      </svg>
    </div>
  );
}

function w3TriPath(R, up) {
  const h = +(R * Math.sqrt(3) / 2).toFixed(2), half = +(R / 2).toFixed(2);
  return up ? `M 0,${-R} L ${h},${half} L ${-h},${half} Z`
            : `M 0,${R} L ${h},${-half} L ${-h},${-half} Z`;
}
function w3Petal(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1), c2y = (-oR * 0.85).toFixed(1), c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// ─── Audio — one shared context, a couple of voices ──────────────────────────
let __w3Ctx = null;
function w3Audio() {
  if (!__w3Ctx && typeof window !== 'undefined') {
    const C = window.AudioContext || window.webkitAudioContext;
    if (C) __w3Ctx = new C();
  }
  return __w3Ctx;
}
// a single shaped note (for discrete tones — lineage steps, overflow swells)
function w3Note(freq, dur = 1.6, vol = 0.09, type = 'sine') {
  const ctx = w3Audio(); if (!ctx) return;
  if (ctx.state === 'suspended') ctx.resume();
  const now = ctx.currentTime;
  const osc = ctx.createOscillator(); osc.type = type; osc.frequency.value = freq;
  const o2 = ctx.createOscillator(); o2.type = type; o2.frequency.value = freq * 2;
  const g = ctx.createGain(), g2 = ctx.createGain();
  g2.gain.value = 0.25; osc.connect(g); o2.connect(g2); g.connect(ctx.destination); g2.connect(ctx.destination);
  g.gain.setValueAtTime(0, now); g.gain.linearRampToValueAtTime(vol, now + 0.08);
  g.gain.linearRampToValueAtTime(0, now + dur);
  g2.gain.setValueAtTime(0, now); g2.gain.linearRampToValueAtTime(vol * 0.25, now + 0.12);
  g2.gain.linearRampToValueAtTime(0, now + dur * 0.85);
  osc.start(now); osc.stop(now + dur); o2.start(now); o2.stop(now + dur * 0.9);
}
// a sustained breathy voice (for the bodyless hum + the concealed whisper)
let __w3Sustain = null;
function w3SustainStart(freq, vol = 0.05, vibrato = 5) {
  const ctx = w3Audio(); if (!ctx || __w3Sustain) return;
  if (ctx.state === 'suspended') ctx.resume();
  const g = ctx.createGain(); g.gain.value = 0; g.connect(ctx.destination);
  const osc = ctx.createOscillator(); osc.type = 'sine'; osc.frequency.value = freq;
  const lfo = ctx.createOscillator(); lfo.type = 'sine'; lfo.frequency.value = 0.25;
  const lfoG = ctx.createGain(); lfoG.gain.value = vibrato; lfo.connect(lfoG); lfoG.connect(osc.frequency);
  osc.connect(g); osc.start(); lfo.start();
  g.gain.setTargetAtTime(vol, ctx.currentTime, 0.4);
  __w3Sustain = { osc, lfo, g, vol };
}
function w3SustainGain(v) { if (__w3Sustain) try { __w3Sustain.g.gain.setTargetAtTime(v, __w3Ctx.currentTime, 0.2); } catch(e){} }
function w3SustainStop() {
  if (!__w3Sustain) return; const s = __w3Sustain; __w3Sustain = null;
  try { s.g.gain.setTargetAtTime(0, __w3Ctx.currentTime, 0.3);
    setTimeout(() => { try { s.osc.stop(); s.lfo.stop(); } catch(e){} }, 800); } catch(e){}
}

function SoundDot3({ on, onToggle, label = 'tone', color = '#C9963F' }) {
  return (
    <div onPointerDown={(e)=>e.stopPropagation()} onClick={onToggle} style={{
      position: 'absolute', bottom: 50, left: 22, zIndex: 6, cursor: 'pointer',
      display: 'flex', alignItems: 'center', gap: 6 }}>
      <div style={{ width: 18, height: 18, borderRadius: '50%',
        border: `0.5px solid ${color}${on ? 'b3' : '4d'}`, display: 'flex', alignItems: 'center',
        justifyContent: 'center', background: on ? `${color}1f` : 'transparent', transition: 'all 0.4s ease' }}>
        <div className={on ? 'rw1-drone-on' : ''} style={{ width: 4, height: 4, borderRadius: '50%',
          background: on ? color : 'rgba(242,232,217,0.3)' }}/>
      </div>
      <span style={{ fontFamily: '-apple-system, sans-serif', fontSize: 8,
        color: 'rgba(242,232,217,0.22)', letterSpacing: '0.22em', textTransform: 'uppercase' }}>
        {on ? label : 'silent'}</span>
    </div>
  );
}

function RingId({ title, sub, color }) {
  return (
    <div style={{ position: 'absolute', top: 90, left: 0, right: 0, textAlign: 'center', zIndex: 3,
      fontFamily: "'Cormorant Garamond', serif", pointerEvents: 'none' }}>
      <div style={{ fontSize: 14, fontStyle: 'italic', color, letterSpacing: '0.20em' }}>{title}</div>
      <div style={{ marginTop: 5, fontSize: 10, color: 'rgba(242,232,217,0.30)', letterSpacing: '0.30em',
        textTransform: 'uppercase', fontFamily: '-apple-system, sans-serif' }}>{sub}</div>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 3 — ANAṄGA · THE SMOKE LOTUS  (bodyless desire)
// ═════════════════════════════════════════════════════════════════════════════

function RingThreeWorld({ initialActive = null }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 392;
  const shaktis = (typeof RING3_SHAKTIS !== 'undefined' ? RING3_SHAKTIS : []);
  const [active, setActive] = React.useState(initialActive);
  const [unified, setUnified] = React.useState(false);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const [moving, setMoving] = React.useState(false);
  const moveT = React.useRef(null);
  const rose = '#C4725A';

  React.useEffect(() => () => { w3SustainStop(); clearTimeout(moveT.current); }, []);
  function onMove() {
    setMoving(true);
    clearTimeout(moveT.current);
    moveT.current = setTimeout(() => setMoving(false), 800);
  }
  function ensureSound() { if (!soundRef.current) { w3SustainStart(116.5, 0.045, 6); soundRef.current = true; setSound(true); } }
  function touch(i, e) { e && e.stopPropagation(); ensureSound(); setUnified(false); setActive(i);
    w3SustainGain(0.06); setTimeout(()=>w3SustainGain(0.03), 1400); }
  function unify(e) { e && e.stopPropagation(); ensureSound(); setActive(null); setUnified(true);
    w3SustainGain(0.075); setTimeout(()=>{ setUnified(false); w3SustainGain(0.03); }, 2600); }
  function release() { setActive(null); setUnified(false); }

  const oR = 116, iR = 30, hw = 52;
  const petal = w3Petal(oR, iR, hw);
  const cur = active != null ? shaktis[active] : null;

  return (
    <div onClick={release} onPointerMove={onMove} style={{ width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 72% 62% at 50% 46%, #160A0C 0%, #0A0406 55%, #060103 100%)',
      position: 'relative', overflow: 'hidden', cursor: 'default', touchAction: 'none', userSelect: 'none' }}>
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(ellipse 60% 50% at 50% 44%, rgba(196,114,90,0.13) 0%, rgba(139,26,42,0.05) 50%, transparent 78%)' }}/>
      <DustMotes count={7}/>
      <StatusBar/>
      <R3ReturnArc color="rgba(196,114,90,0.34)"/>
      <RingId title="Sarvasaṅkṣobhaṇa · the Anaṅgas" sub="eight forms · one bodiless longing" color="rgba(196,114,90,0.62)"/>

      {/* the smoke lotus — soft plumes, no crisp edges */}
      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible', pointerEvents: 'none' }}>
        <defs>
          <filter id="r3blur" x="-60%" y="-60%" width="220%" height="220%">
            <feGaussianBlur stdDeviation="5.5"/>
          </filter>
          <radialGradient id="r3grad" cx="50%" cy="38%" r="62%">
            <stop offset="0%" stopColor="#E0937A" stopOpacity="0.9"/>
            <stop offset="55%" stopColor={rose} stopOpacity="0.5"/>
            <stop offset="100%" stopColor="#8B1A2A" stopOpacity="0"/>
          </radialGradient>
        </defs>
        {/* faint guide ring — barely there */}
        <circle cx={cx} cy={cy} r={iR + 4} fill="none" stroke="rgba(196,114,90,0.10)" strokeWidth="0.5"/>
      </svg>

      {/* petals — bodyless: they thin and scatter when reached for, gather only in stillness */}
      {shaktis.map((s, i) => {
        const ang = i * 45;
        const isActive = active === i;
        const gather = unified || isActive || !moving;
        const drift = gather ? 0 : 24;                 // smoke fleeing outward when chased
        const scl = isActive ? 1.06 : gather ? 1 : 1.18;
        const op = unified ? 0.92 : isActive ? 1 : (active != null ? 0.22 : (gather ? 0.66 : 0.18));
        const bright = isActive ? 1.5 : unified ? 1.35 : gather ? 1.05 : 0.78;
        const blurAmt = gather ? 5.5 : 10;
        return (
          <div key={s.id} onClick={(e)=>touch(i, e)} className="r3-smoke" style={{
            position: 'absolute', top: cy, left: cx, width: 1, height: 1, zIndex: 3,
            transform: `rotate(${ang}deg)`, cursor: 'pointer',
            animationDelay: `${(i * 0.7).toFixed(1)}s`,
          }}>
            <svg width="220" height="220" viewBox="-110 -110 220 220" style={{
              position: 'absolute', left: -110, top: -110, overflow: 'visible',
              opacity: op,
              transition: 'opacity 1.1s ease, transform 1.3s cubic-bezier(.22,.61,.36,1)',
              transform: `translateY(${-drift}px) scale(${scl})`,
            }}>
              <path d={w3Petal(oR, iR, hw)} fill="url(#r3grad)"
                style={{ filter: `url(#r3blur) brightness(${bright})`, transition: 'filter 1.1s ease' }}/>
            </svg>
          </div>
        );
      })}

      {/* the shared seed — hsauṁ — tap to unify */}
      <div onClick={unify} style={{ position: 'absolute', top: cy, left: cx, transform: 'translate(-50%,-50%)',
        zIndex: 4, cursor: 'pointer', width: 54, height: 54, borderRadius: '50%',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: unified ? 'radial-gradient(circle, rgba(224,147,122,0.4) 0%, transparent 70%)' : 'transparent',
        transition: 'background 0.8s ease' }}>
        <div className="r3-seed" style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 22,
          fontStyle: 'italic', color: unified ? COLORS.cream : (moving ? 'rgba(224,147,122,0.42)' : 'rgba(224,147,122,0.92)'),
          letterSpacing: '0.06em', transition: 'color 0.8s ease', textShadow: '0 0 16px rgba(196,114,90,0.6)' }}>
          hsauṁ</div>
      </div>

      {/* lower text */}
      <div style={{ position: 'absolute', top: 540, left: 0, right: 0, bottom: 116, padding: '0 36px',
        zIndex: 5, pointerEvents: 'none', textAlign: 'center',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-start' }}>
        {cur && (
          <div key={cur.id} className="rw1-rise" style={{ width: '100%' }}>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 36, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.05em', marginBottom: 6 }}>{cur.name}</div>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 17, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.62)', lineHeight: 1.6, maxWidth: 300, margin: '0 auto' }}>{cur.quality}</div>
          </div>
        )}
        {!cur && unified && (
          <div className="rw1-rise" style={{ width: '100%' }}>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 23, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.78)', lineHeight: 1.5, maxWidth: 300, margin: '0 auto' }}>
              Eight forms, one longing. The desire that arrives without a body.</div>
          </div>
        )}
        {!cur && !unified && moving && (
          <div key="moving" className="rw1-rise" style={{ width: '100%' }}>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 20, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.50)', lineHeight: 1.6, maxWidth: 290, margin: '0 auto' }}>
              The more you reach for her, the more she thins.</div>
          </div>
        )}
        {!cur && !unified && !moving && (
          <div key="still" className="rw1-rise" style={{ width: '100%' }}>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 20, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.60)', lineHeight: 1.6, maxWidth: 290, margin: '0 auto' }}>
              Be still — and the bodiless longing gathers.</div>
          </div>
        )}
      </div>

      <div style={{ position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center', zIndex: 4,
        fontFamily: '-apple-system, sans-serif', fontSize: 8.5, color: 'rgba(242,232,217,0.20)',
        letterSpacing: '0.26em', textTransform: 'uppercase', pointerEvents: 'none' }}>
        be still to let her gather · touch a plume · the seed for all eight</div>

      <SoundDot3 on={sound} color="#C4725A" label="longing" onToggle={(e)=>{ e.stopPropagation();
        if (sound) { w3SustainStop(); soundRef.current=false; setSound(false); }
        else { w3SustainStart(116.5,0.045,6); soundRef.current=true; setSound(true); } }}/>
      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 4 — SAMPRADĀYA · THE LINEAGE  (the teaching travels teacher → student)
// ═════════════════════════════════════════════════════════════════════════════

const R4_GLOSS = ['the stirring','the scattering','the drawing','the gladdening','the enchanting',
  'the stilling','the opening','the mastering','the colouring','the maddening','the accomplishing',
  'the fulfilling','made of mantra','the perfecting'];

function RingFourWorld({ initialActive = null, autoStart = true }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 396;
  const shaktis = (typeof RING4_SHAKTIS !== 'undefined' ? RING4_SHAKTIS : []);
  const N = shaktis.length || 14;
  const R = 150;
  const nodes = React.useMemo(() => Array.from({ length: N }, (_, i) => {
    const a = (i / N) * 2 * Math.PI - Math.PI / 2;
    return { x: cx + R * Math.cos(a), y: cy + R * Math.sin(a), up: i % 2 === 0 };
  }), [N]);
  const [lit, setLit] = React.useState(initialActive != null ? initialActive : -1);
  const [selected, setSelected] = React.useState(initialActive);
  const [fullyLit, setFullyLit] = React.useState(false);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const green = '#6FA37E';
  const timer = React.useRef(null);

  function transmit(fromTap) {
    if (fromTap && !soundRef.current) { soundRef.current = true; setSound(true); }
    setSelected(null); setFullyLit(false);
    let i = 0; setLit(0);
    if (soundRef.current) w3Note(174.6 * Math.pow(2, (0/12)), 1.4, 0.05);
    clearInterval(timer.current);
    timer.current = setInterval(() => {
      i += 1;
      if (i >= N) { clearInterval(timer.current); setFullyLit(true); setTimeout(()=>setLit(-1), 600); return; }
      setLit(i);
      if (soundRef.current) w3Note(174.6 * Math.pow(2, (i / 12) / 2), 1.2, 0.045);
    }, 340);
  }
  React.useEffect(() => {
    if (autoStart && initialActive == null) { const t = setTimeout(()=>transmit(false), 900); return () => { clearTimeout(t); clearInterval(timer.current); }; }
    return () => clearInterval(timer.current);
  }, []);

  const cur = selected != null ? shaktis[selected] : null;

  return (
    <div onClick={()=>setSelected(null)} style={{ width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 70% 60% at 50% 47%, #07120C 0%, #050B07 55%, #040603 100%)',
      position: 'relative', overflow: 'hidden', cursor: 'default', touchAction: 'none', userSelect: 'none' }}>
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(ellipse 60% 52% at 50% 47%, rgba(111,163,126,0.10) 0%, transparent 74%)' }}/>
      <DustMotes count={6}/>
      <StatusBar/>
      <R3ReturnArc color="rgba(111,163,126,0.32)"/>
      <RingId title="Sarvasaubhāgyadāyaka · the Sampradāya" sub="fourteen · the teaching travels the line" color="rgba(111,163,126,0.66)"/>

      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>
        {/* lineage garland — curved threads through which the practice travels */}
        {nodes.map((n, i) => {
          const m = nodes[(i + 1) % N];
          const passed = fullyLit || (lit >= 0 && i < lit);
          const mx = (n.x + m.x) / 2, my = (n.y + m.y) / 2;
          const ctrlx = cx + (mx - cx) * 0.84, ctrly = cy + (my - cy) * 0.84; // bow inward (garland droop)
          return <path key={'l'+i} d={`M ${n.x} ${n.y} Q ${ctrlx} ${ctrly} ${m.x} ${m.y}`}
            fill="none" stroke={green} strokeWidth={passed ? 1.1 : 0.5}
            opacity={passed ? 0.55 : 0.14} style={{ transition: 'all 0.5s ease' }}/>;
        })}
        {/* the 14 triangles + lights */}
        {nodes.map((n, i) => {
          const isLit = lit === i, wasLit = fullyLit || (lit >= 0 && i <= lit), isSel = selected === i;
          const op = isSel ? 1 : isLit ? 1 : wasLit ? 0.72 : 0.3;
          return (
            <g key={i} transform={`translate(${n.x} ${n.y})`} onClick={(e)=>{ e.stopPropagation(); setSelected(i); }}
              style={{ cursor: 'pointer' }}>
              <circle r="15" fill="transparent"/>
              {(isLit || isSel) && <circle r="11" fill={green} opacity="0.3" style={{ filter: 'blur(5px)' }}/>}
              <path d={w3TriPath(8.5, n.up)} fill="none" stroke={green} strokeWidth="0.9"
                opacity={op} style={{ transition: 'opacity 0.4s ease' }}/>
              <circle r={isLit ? 3 : 2} fill={isLit || isSel || wasLit ? COLORS.cream : green}
                opacity={op} style={{ transition: 'all 0.4s ease' }}/>
            </g>
          );
        })}
        {/* the traveling light — the teaching itself, passing bead to bead */}
        {lit >= 0 && (
          <g transform={`translate(${nodes[lit].x} ${nodes[lit].y})`} style={{ pointerEvents: 'none' }}>
            <circle r="17" fill={green} opacity="0.28" style={{ filter: 'blur(8px)' }}/>
            <circle r="4.2" fill={COLORS.cream} opacity="0.96"
              style={{ filter: 'drop-shadow(0 0 9px rgba(242,232,217,0.85))' }}/>
          </g>
        )}
        {/* the source — the root of the lineage, at center */}
        <g transform={`translate(${cx} ${cy})`} onClick={(e)=>{ e.stopPropagation(); transmit(true); }} style={{ cursor: 'pointer' }}>
          <circle r="22" fill="transparent"/>
          <circle r="6" fill="none" stroke={green} strokeWidth="0.6" opacity="0.4"/>
          <circle r="2.6" fill={green} opacity="0.85"/>
        </g>
      </svg>

      <div style={{ position: 'absolute', top: 566, left: 0, right: 0, bottom: 116, padding: '0 36px',
        zIndex: 5, pointerEvents: 'none', textAlign: 'center' }}>
        {cur ? (
          <div key={cur.id} className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 34, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.05em', marginBottom: 5 }}>{cur.name}</div>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 17, fontStyle: 'italic',
              color: 'rgba(111,163,126,0.85)', marginBottom: 12 }}>{R4_GLOSS[selected] || ''}</div>
            <div style={{ fontFamily: '-apple-system, sans-serif', fontSize: 9.5, color: 'rgba(242,232,217,0.4)',
              letterSpacing: '0.18em', textTransform: 'uppercase' }}>
              the {ordinal(selected + 1)} of fourteen · received, and passed on</div>
          </div>
        ) : fullyLit ? (
          <div key="unbroken" className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 22, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.74)', lineHeight: 1.5, maxWidth: 300, margin: '0 auto' }}>
              The garland is unbroken — every name still passed, hand to hand.</div>
          </div>
        ) : (
          <div className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 19, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.52)', lineHeight: 1.6, maxWidth: 290, margin: '0 auto' }}>
              The teaching travels the line — teacher to student, across the generations.</div>
          </div>
        )}
      </div>

      <div style={{ position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center', zIndex: 4,
        fontFamily: '-apple-system, sans-serif', fontSize: 8.5, color: 'rgba(242,232,217,0.20)',
        letterSpacing: '0.26em', textTransform: 'uppercase', pointerEvents: 'none' }}>
        touch a station · the center to send the teaching</div>

      <SoundDot3 on={sound} color="#6FA37E" label="lineage" onToggle={(e)=>{ e.stopPropagation();
        soundRef.current = !soundRef.current; setSound(soundRef.current); }}/>
      <HomeIndicator light={true}/>
    </div>
  );
}
function ordinal(n) {
  const s = ['th','st','nd','rd'], v = n % 100;
  return n + (s[(v - 20) % 10] || s[v] || s[0]);
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 5 — KULOTTĪRṆA · THE OVERFLOW  (light transcends what contains it)
// ═════════════════════════════════════════════════════════════════════════════

const R5_GLOSS = ['grants attainment','grants abundance','makes beloved','the auspicious one',
  'grants every desire','the liberator','conqueror of death','remover of obstacles',
  'beauty in all limbs','grantor of grace'];

function RingFiveWorld({ initialActive = null, initialFlood = false }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 392;
  const shaktis = (typeof RING5_SHAKTIS !== 'undefined' ? RING5_SHAKTIS : []);
  const N = shaktis.length || 10;
  const ringR = 116, boundR = 142;
  const nodes = React.useMemo(() => Array.from({ length: N }, (_, i) => {
    const a = (i / N) * 2 * Math.PI - Math.PI / 2;
    return { a, x: cx + ringR * Math.cos(a), y: cy + ringR * Math.sin(a) };
  }), [N]);
  const [active, setActive] = React.useState(initialActive);
  const [flood, setFlood] = React.useState(initialFlood);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const gold = '#D4A017';

  function tap(i, e) { e && e.stopPropagation(); if (!soundRef.current){soundRef.current=true;setSound(true);} setFlood(false); setActive(i);
    if (soundRef.current) w3Note(261.6, 1.8, 0.05); }
  function overflowAll(e) { e && e.stopPropagation(); if (!soundRef.current){soundRef.current=true;setSound(true);} setActive(null); setFlood(true);
    if (soundRef.current) { [0,1,2,3].forEach(k=>setTimeout(()=>w3Note(261.6*Math.pow(2,k/12),2.4,0.04), k*90)); } }
  function release() { setActive(null); setFlood(false); }
  const cur = active != null ? shaktis[active] : null;

  return (
    <div onClick={release} style={{ width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 72% 64% at 50% 44%, #0E0A04 0%, #080502 55%, #050301 100%)',
      position: 'relative', overflow: 'hidden', cursor: 'default', touchAction: 'none', userSelect: 'none' }}>
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none',
        background: flood
          ? 'radial-gradient(ellipse 95% 80% at 50% 44%, rgba(212,160,23,0.22) 0%, rgba(242,232,217,0.06) 45%, transparent 85%)'
          : 'radial-gradient(ellipse 56% 48% at 50% 44%, rgba(212,160,23,0.10) 0%, transparent 72%)',
        transition: 'background 1.2s ease' }}/>
      <DustMotes count={6}/>
      <StatusBar/>
      <R3ReturnArc color="rgba(212,160,23,0.34)"/>
      <RingId title="Sarvārthasādhaka · the Kulottīrṇas" sub="ten · overflowing what contains them" color="rgba(212,160,23,0.66)"/>

      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible', pointerEvents: 'none' }}>
        <defs>
          <radialGradient id="r5ray" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stopColor="#F2E8D9" stopOpacity="0.5"/>
            <stop offset="100%" stopColor="#D4A017" stopOpacity="0"/>
          </radialGradient>
        </defs>
        {/* the kula — the containing boundary */}
        <circle cx={cx} cy={cy} r={boundR} fill="none" stroke={gold}
          strokeWidth={flood ? 0.4 : 0.9} opacity={flood ? 0.12 : 0.4}
          strokeDasharray={flood ? '2 8' : 'none'} style={{ transition: 'all 1.2s ease' }}/>

        {/* overflow rays — light spilling past the boundary */}
        {(flood || active != null) && nodes.map((n, i) => {
          const show = flood || active === i;
          if (!show) return null;
          const ex = cx + (boundR + 70) * Math.cos(n.a), ey = cy + (boundR + 70) * Math.sin(n.a);
          return <line key={'r'+i} x1={cx + (ringR-10)*Math.cos(n.a)} y1={cy + (ringR-10)*Math.sin(n.a)}
            x2={ex} y2={ey} stroke="url(#r5ray)" strokeWidth="6" className="r5-ray"
            style={{ transformOrigin: `${cx}px ${cy}px` }}/>;
        })}

        {/* the ten triangles */}
        {nodes.map((n, i) => {
          const isActive = active === i, on = flood || isActive;
          return (
            <g key={i} transform={`translate(${n.x} ${n.y}) rotate(${(n.a*180/Math.PI)+90})`}
              onClick={(e)=>tap(i, e)} style={{ cursor: 'pointer' }}>
              <circle r="16" fill="transparent"/>
              {on && <path d={w3TriPath(15, true)} fill={gold} opacity="0.18" style={{ filter:'blur(5px)' }}/>}
              <path d={w3TriPath(13, true)} fill="none" stroke={on ? '#F2E8D9' : gold}
                strokeWidth="0.9" opacity={on ? 0.95 : (active!=null?0.22:0.5)} style={{ transition:'all 0.6s ease' }}/>
            </g>
          );
        })}
        <circle cx={cx} cy={cy} r="3" fill={gold} opacity="0.7"/>
      </svg>

      {/* center gesture target */}
      <div onClick={overflowAll} style={{ position:'absolute', top:cy, left:cx, transform:'translate(-50%,-50%)',
        width:48, height:48, borderRadius:'50%', zIndex:4, cursor:'pointer' }}/>

      <div style={{ position: 'absolute', top: 560, left: 0, right: 0, bottom: 116, padding: '0 36px',
        zIndex: 5, pointerEvents: 'none', textAlign: 'center' }}>
        {cur ? (
          <div key={cur.id} className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 34, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.05em', marginBottom: 6 }}>{cur.name}</div>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 17, fontStyle: 'italic',
              color: 'rgba(212,160,23,0.85)' }}>{R5_GLOSS[active] || ''}</div>
          </div>
        ) : flood ? (
          <div className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 23, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.80)', lineHeight: 1.5, maxWidth: 300, margin: '0 auto' }}>
              The accomplishment overflows the one who sought it.</div>
            <div style={{ marginTop: 14, fontFamily: '-apple-system, sans-serif', fontSize: 9,
              color: 'rgba(212,160,23,0.5)', letterSpacing: '0.28em', textTransform: 'uppercase' }}>
              the boundary cannot hold her</div>
          </div>
        ) : (
          <div className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 19, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.52)', lineHeight: 1.6, maxWidth: 290, margin: '0 auto' }}>
              Ten forces the circle was meant to hold — and cannot.</div>
          </div>
        )}
      </div>

      <div style={{ position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center', zIndex: 4,
        fontFamily: '-apple-system, sans-serif', fontSize: 8.5, color: 'rgba(242,232,217,0.20)',
        letterSpacing: '0.26em', textTransform: 'uppercase', pointerEvents: 'none' }}>
        touch one to overflow · the center to transcend the kula</div>

      <SoundDot3 on={sound} color="#D4A017" label="overflow" onToggle={(e)=>{ e.stopPropagation();
        soundRef.current = !soundRef.current; setSound(soundRef.current); }}/>
      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 6 — NIGARBHA · THE CONCEALED  (revealed only by nearness)
// ═════════════════════════════════════════════════════════════════════════════

const R6_GLOSS = ['made of knowing','made of power','sovereign splendour','giver of knowledge',
  'remover of disease','the support of all','remover of sorrow','made of bliss',
  'the protectress','giver of the fruit'];

function RingSixWorld({ revealAt = null }) {
  const screenW = 390, screenH = 844, cx = 195, cy = 392;
  const shaktis = (typeof RING6_SHAKTIS !== 'undefined' ? RING6_SHAKTIS : []);
  const N = shaktis.length || 10;
  const R = 96;
  const nodes = React.useMemo(() => Array.from({ length: N }, (_, i) => {
    const a = (i / N) * 2 * Math.PI - Math.PI / 2;
    return { a, x: cx + R * Math.cos(a), y: cy + R * Math.sin(a), up: i % 2 === 0 };
  }), [N]);
  // light position (the candle in the dark chamber)
  const [light, setLight] = React.useState(revealAt != null ? { x: nodes[revealAt].x, y: nodes[revealAt].y } : { x: cx, y: cy });
  const [whisper, setWhisper] = React.useState(revealAt);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const fadeT = React.useRef(null);
  const violet = '#9A86C4';
  const REVEAL = 92;

  React.useEffect(() => () => w3SustainStop(), []);
  function move(e) {
    const r = e.currentTarget.getBoundingClientRect();
    const scale = r.width / screenW;
    setLight({ x: (e.clientX - r.left) / scale, y: (e.clientY - r.top) / scale });
    if (soundRef.current) {
      // nearest concealed one drives the quiet tone
      let best = 1e9; nodes.forEach(n => { const d = Math.hypot(n.x-(e.clientX-r.left)/scale, n.y-(e.clientY-r.top)/scale); if (d<best) best=d; });
      w3SustainGain(best < REVEAL ? 0.05 * (1 - best/REVEAL) : 0.004);
    }
  }
  function enter() { if (!soundRef.current) { w3SustainStart(207.65, 0.02, 3); soundRef.current = true; setSound(true); } }
  function tap(i, e) {
    e && e.stopPropagation();
    const d = Math.hypot(nodes[i].x - light.x, nodes[i].y - light.y);
    if (d > REVEAL) return; // can't name what the light hasn't reached
    setWhisper(i);
    clearTimeout(fadeT.current);
    fadeT.current = setTimeout(() => setWhisper(null), 3200); // too interior to be spoken — it fades
  }

  const dist = (n) => Math.hypot(n.x - light.x, n.y - light.y);
  const cur = whisper != null ? shaktis[whisper] : null;

  return (
    <div onPointerMove={move} onPointerEnter={enter} onClick={()=>{}} style={{ width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 60% 55% at 50% 46%, #0A0710 0%, #050309 55%, #020104 100%)',
      position: 'relative', overflow: 'hidden', cursor: 'crosshair', touchAction: 'none', userSelect: 'none' }}>
      <DustMotes count={4}/>
      <StatusBar/>
      <R3ReturnArc color="rgba(154,134,196,0.30)"/>
      <RingId title="Sarvarakṣākara · the Nigarbhas" sub="ten · concealed, too interior to be spoken" color="rgba(154,134,196,0.62)"/>

      {/* the moving light — a soft glow that follows the touch */}
      <div style={{ position: 'absolute', top: light.y, left: light.x, transform: 'translate(-50%,-50%)',
        width: REVEAL * 2.1, height: REVEAL * 2.1, borderRadius: '50%', zIndex: 2, pointerEvents: 'none',
        background: 'radial-gradient(circle, rgba(154,134,196,0.16) 0%, rgba(154,134,196,0.05) 40%, transparent 70%)',
        transition: 'top 0.18s ease, left 0.18s ease' }}/>

      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>
        {/* the ten concealed triangles — opacity by nearness to the light */}
        {nodes.map((n, i) => {
          const near = Math.max(0, 1 - dist(n) / REVEAL);
          const isWhisper = whisper === i;
          const op = isWhisper ? 0.95 : near * 0.85;
          return (
            <g key={i} transform={`translate(${n.x} ${n.y})`} onClick={(e)=>tap(i, e)} style={{ cursor: 'pointer' }}>
              <circle r="16" fill="transparent"/>
              {near > 0.3 && <path d={w3TriPath(13, n.up)} fill={violet} opacity={near*0.12} style={{filter:'blur(4px)'}}/>}
              <path d={w3TriPath(11, n.up)} fill="none" stroke={violet} strokeWidth="0.8"
                opacity={op} style={{ transition: 'opacity 0.4s ease' }}/>
              <circle r="1.8" fill={isWhisper ? COLORS.cream : violet} opacity={op}/>
            </g>
          );
        })}
        {/* the protected center — Sarvarakṣākara, she who protects all */}
        <circle cx={cx} cy={cy} r="3.4" fill={violet} opacity="0.5" className="r6-heart"/>
      </svg>

      <div style={{ position: 'absolute', top: 552, left: 0, right: 0, bottom: 116, padding: '0 38px',
        zIndex: 5, pointerEvents: 'none', textAlign: 'center' }}>
        {cur ? (
          <div key={cur.id + '' + Date.now()} className="r6-whisper">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 32, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.05em', marginBottom: 6 }}>{cur.name}</div>
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 16, fontStyle: 'italic',
              color: 'rgba(154,134,196,0.85)' }}>{R6_GLOSS[whisper] || ''}</div>
          </div>
        ) : (
          <div className="rw1-rise">
            <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 19, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.46)', lineHeight: 1.6, maxWidth: 290, margin: '0 auto' }}>
              What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near.</div>
          </div>
        )}
      </div>

      <div style={{ position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center', zIndex: 4,
        fontFamily: '-apple-system, sans-serif', fontSize: 8.5, color: 'rgba(242,232,217,0.18)',
        letterSpacing: '0.26em', textTransform: 'uppercase', pointerEvents: 'none' }}>
        move the light · touch what it reaches · she will not stay</div>

      <SoundDot3 on={sound} color="#9A86C4" label="within" onToggle={(e)=>{ e.stopPropagation();
        if (sound) { w3SustainStop(); soundRef.current=false; setSound(false); }
        else { w3SustainStart(207.65,0.02,3); soundRef.current=true; setSound(true); } }}/>
      <HomeIndicator light={true}/>
    </div>
  );
}

Object.assign(window, { RingThreeWorld, RingFourWorld, RingFiveWorld, RingSixWorld });
