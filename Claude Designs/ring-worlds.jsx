// ─── Ring Worlds — Phase 3 ────────────────────────────────────────────────────
// Three worlds, three atmospheres, three vocabularies.
// Ring 2 — the inhabited lotus (the home ring, deeply known)
// Ring 7 — the sound chamber (Vāk · where speech is sound is healing)
// Ring 8 — the root triangle (three becoming one becoming none)

// ─── Local helpers (each Babel script has its own scope) ─────────────────────

function petalPath(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// ─── Shared atmospherics ──────────────────────────────────────────────────────

function FaintRingMemory({ size = 390, opacity = 0.04 }) {
  // The ghost of where you came from — outer rings as faint memory at edges.
  const cx = size / 2, cy = size / 2;
  return (
    <svg width={size} height={size}
      style={{ position: 'absolute', top: 0, left: 0, pointerEvents: 'none' }}>
      <g fill="none" stroke={COLORS.gold} strokeWidth="0.4">
        <rect x={cx-180} y={cy-180} width="360" height="360" opacity={opacity * 1.2}/>
        <rect x={cx-168} y={cy-168} width="336" height="336" opacity={opacity}/>
      </g>
    </svg>
  );
}

function ReturnGesture({ light = false }) {
  // Subtle arc at top suggesting "swipe down to return to home"
  return (
    <div style={{
      position: 'absolute', top: 56, left: '50%',
      transform: 'translateX(-50%)', pointerEvents: 'none', zIndex: 3,
    }}>
      <svg width="80" height="14" viewBox="0 0 80 14">
        <path d="M 8,11 Q 40,3 72,11" fill="none"
          stroke={light ? 'rgba(242,232,217,0.25)' : 'rgba(201,150,63,0.32)'}
          strokeWidth="0.7" strokeLinecap="round"/>
      </svg>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 2 WORLD — THE INHABITED LOTUS
// You are inside the home ring. The 16-petal lotus fills the screen.
// Each petal known, breathing at its own status. Today glowing warmer.
// ═════════════════════════════════════════════════════════════════════════════

function RingTwoWorld({ todayIndex = 4, mode = 'default' }) {
  // mode: 'default' (interactive — press any petal to invoke) | 'invocation' (static, today)
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 430;
  const oR = 172, iR = 96, hw = 32; // sized to fit labels comfortably within screen
  const pPath = petalPath(oR, iR, hw);
  const labelR = 138; // labels sit on the petal mid-body — never near the screen edge
  const [invoked, setInvoked] = React.useState(null);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const clearT = React.useRef(null);
  React.useEffect(() => () => { rwHomeStop(); clearTimeout(clearT.current); }, []);
  const interactive = mode !== 'invocation';
  const invocIdx = mode === 'invocation' ? todayIndex : invoked;
  const invocShakti = invocIdx != null ? SHAKTIS[invocIdx] : null;

  function pressPetal(i, e) {
    e && e.stopPropagation();
    if (!interactive) return;
    clearTimeout(clearT.current);
    setInvoked(i);
    if (soundRef.current) rwHomeGain(0.075);
  }
  function releasePetal() {
    if (!interactive) return;
    if (soundRef.current) rwHomeGain(0.045);
    clearTimeout(clearT.current);
    clearT.current = setTimeout(() => setInvoked(null), 2600); // release · she remains, then settles
  }
  function toggleSound(e) {
    e && e.stopPropagation();
    if (soundRef.current) { rwHomeStop(); soundRef.current = false; setSound(false); }
    else { rwHomeStart(); soundRef.current = true; setSound(true); }
  }

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'linear-gradient(180deg, #0A0608 0%, #060104 60%, #050103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 75% 60% at 50% 50%,
          rgba(201,150,63,0.10) 0%, transparent 70%)`,
        pointerEvents: 'none',
      }}/>
      <DustMotes count={10}/>
      <FaintRingMemory size={screenW} opacity={0.05}/>

      <StatusBar/>
      <ReturnGesture/>

      {/* Ring identity — minimal */}
      <div style={{
        position: 'absolute', top: 92, left: 0, right: 0,
        textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 13, fontStyle: 'italic',
        color: 'rgba(201,150,63,0.5)',
        letterSpacing: '0.18em',
      }}>
        Sarvāśā-Paripūraka · the Sixteen
      </div>

      {/* The lotus — large, inhabited */}
      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* Faint inner-ring memory at center — the depths ahead */}
        <g transform={`translate(${cx},${cy})`} opacity={invocIdx != null ? 0.04 : 0.08}>
          {[80, 65, 50, 36].map(r => (
            <React.Fragment key={r}>
              <path d={`M 0,${-r} L ${r*0.866},${r/2} L ${-r*0.866},${r/2} Z`}
                fill="none" stroke={COLORS.gold} strokeWidth="0.4"/>
              <path d={`M 0,${r} L ${r*0.866},${-r/2} L ${-r*0.866},${-r/2} Z`}
                fill="none" stroke={COLORS.gold} strokeWidth="0.4"/>
            </React.Fragment>
          ))}
        </g>

        {/* The 16 petals — large, identified */}
        {SHAKTIS.map((s, i) => {
          const angle = i * 22.5;
          const isToday = i === todayIndex;
          const col = CLUSTER_INFO[s.cluster].color;
          const baseOp = STATUS_OPACITY[s.status];
          const muted = invocIdx != null && i !== invocIdx;
          const finalOp = muted ? baseOp * 0.18 : baseOp;
          const la = (angle - 90) * Math.PI / 180;
          const lx = cx + labelR * Math.cos(la);
          const ly = cy + labelR * Math.sin(la);

          return (
            <g key={i}>
              {/* Soft halo behind today's petal */}
              {isToday && (
                <g transform={`translate(${cx},${cy}) rotate(${angle})`}
                  style={{ pointerEvents: 'none' }}>
                  <path d={pPath} fill={col} opacity="0.42"
                    style={{ filter: 'blur(11px)' }}
                    className="rw2-today-halo"/>
                </g>
              )}
              {/* Embodied petals get a glow layer */}
              {s.status === 'embodied' && !muted && (
                <g transform={`translate(${cx},${cy}) rotate(${angle})`}
                  style={{ pointerEvents: 'none' }}>
                  <path d={pPath} fill={col} opacity="0.25"
                    style={{ filter: 'blur(6px)' }}/>
                </g>
              )}
              <g transform={`translate(${cx},${cy}) rotate(${angle})`}
                onPointerDown={(e) => pressPetal(i, e)}
                onPointerUp={releasePetal} onPointerLeave={releasePetal}
                style={{ cursor: interactive ? 'pointer' : 'default' }}>
                <path d={pPath} fill={col}
                  opacity={finalOp}
                  className={isToday ? 'rw2-today' : `rw2-petal rw2-${s.status}`}
                  style={{ animationDelay: `${(i * 0.16).toFixed(2)}s` }}/>
              </g>
              {/* Petal label — small italic, just outside */}
              <text x={lx} y={ly}
                textAnchor="middle" dominantBaseline="middle"
                fontSize="10" fontFamily="'Cormorant Garamond', serif"
                fontStyle="italic"
                fill={isToday ? COLORS.cream : `rgba(242,232,217,${muted ? 0.10 : 0.55})`}
                opacity={muted ? 0.5 : 1}
                style={{ userSelect: 'none', pointerEvents: 'none',
                         letterSpacing: '0.04em' }}>
                {s.short}
              </text>
            </g>
          );
        })}

        {/* Bindu at center — distant but present */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="10" fill={COLORS.accentRed} opacity={invocIdx != null ? 0.4 : 0.85}>
            <animate attributeName="r" values="9;12;9" dur="4.5s" repeatCount="indefinite"/>
          </circle>
          <circle r="4" fill={COLORS.cream}
            opacity={invocIdx != null ? 0.5 : 0.95}
            style={{ filter: 'drop-shadow(0 0 6px rgba(242,232,217,0.7))' }}/>
        </g>
      </svg>

      {/* Invocation overlay — rises when a petal is pressed (or static for today) */}
      {invocShakti && (
        <div key={invocIdx} style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'flex-end',
          padding: '0 36px 140px', zIndex: 4, pointerEvents: 'none',
        }}>
          <div className="rw2-invoc-name" style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 34, fontWeight: 300, color: COLORS.cream,
            letterSpacing: '0.08em', textAlign: 'center',
            lineHeight: 1.1, marginBottom: 8, opacity: 0,
          }}>{invocShakti.name}</div>
          <div className="rw2-invoc-bija" style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 26, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.gold, opacity: 0,
            letterSpacing: '0.12em', marginBottom: 18,
          }}>{invocShakti.bija}</div>
          <div className="rw2-invoc-quality" style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 16, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.62)',
            letterSpacing: '0.04em', textAlign: 'center',
            opacity: 0,
          }}>{invocShakti.quality}</div>
          <div className="rw2-invoc-hint" style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 9, color: 'rgba(242,232,217,0.18)',
            letterSpacing: '0.28em', textTransform: 'uppercase',
            marginTop: 36, opacity: 0,
          }}>release · she remains</div>
        </div>
      )}

      {interactive && invocIdx == null && (
        <div style={{ position: 'absolute', bottom: 58, left: 0, right: 0, textAlign: 'center', zIndex: 4,
          fontFamily: '-apple-system, sans-serif', fontSize: 8.5, color: 'rgba(242,232,217,0.20)',
          letterSpacing: '0.26em', textTransform: 'uppercase', pointerEvents: 'none' }}>
          press a petal to invoke her presence</div>
      )}
      {interactive && <RingSoundToggle on={sound} onToggle={toggleSound} label="home" color="#C9963F"/>}
      <HomeIndicator/>
    </div>
  );
}

// ─── Ring 2 — the lotus following the sun (time-of-day variants) ─────────────

function RingTwoLotusByTime({ phase }) {
  // phase: 'opening' | 'open' | 'closing' | 'closed'
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 420;
  const oR = 200, iR = 110, hw = 40;
  const baseLabel = {
    opening: 'Dawn · the petals open',
    open:    'Noon · the lotus is full',
    closing: 'Dusk · the petals fold',
    closed:  'Night · the lotus rests',
  }[phase];

  const bg = {
    opening: 'linear-gradient(180deg, #0F0810 0%, #080406 100%)',
    open:    'linear-gradient(180deg, #0A0608 0%, #060104 100%)',
    closing: 'linear-gradient(180deg, #0C0508 0%, #06010A 100%)',
    closed:  'linear-gradient(180deg, #020108 0%, #010104 100%)',
  }[phase];

  return (
    <div style={{
      width: screenW, height: screenH, background: bg,
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={6}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 92, left: 0, right: 0,
        textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 13, fontStyle: 'italic',
        color: 'rgba(201,150,63,0.55)',
        letterSpacing: '0.18em',
      }}>{baseLabel}</div>

      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0 }}>

        {SHAKTIS.map((s, i) => {
          const angle = i * 22.5;
          const col = CLUSTER_INFO[s.cluster].color;
          // Petal openness modulates outer radius and opacity per phase
          const openFactor =
            phase === 'opening' ? 0.78 :
            phase === 'open'    ? 1.0  :
            phase === 'closing' ? 0.85 :
                                  0.45;
          const opMul =
            phase === 'opening' ? 0.85 :
            phase === 'open'    ? 1.0 :
            phase === 'closing' ? 0.82 :
                                  0.4;
          const dOR = oR * openFactor;
          const dIR = iR;
          const dHW = hw * (0.7 + 0.3 * openFactor);
          const pPath = petalPath(dOR, dIR, dHW);
          const finalOp = STATUS_OPACITY[s.status] * opMul;

          return (
            <g key={i} transform={`translate(${cx},${cy}) rotate(${angle})`}>
              <path d={pPath} fill={col} opacity={finalOp}
                style={{ transition: 'opacity 1s ease' }}/>
            </g>
          );
        })}

        <g transform={`translate(${cx},${cy})`}>
          <circle r="10" fill={COLORS.accentRed} opacity={phase === 'closed' ? 0.95 : 0.85}/>
          <circle r="4" fill={COLORS.cream}
            opacity={phase === 'closed' ? 0.98 : 0.95}/>
        </g>
      </svg>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 7 WORLD — THE VĀK SOUND CHAMBER
// Eight speech-goddesses arranged as a sonic field.
// Tap a Vāk to hear her bīja. Tap center for the full chord.
// The visual itself resonates with the sound.
// ═════════════════════════════════════════════════════════════════════════════

// Audio context — created lazily on first interaction
let __audioCtx = null;
function getAudio() {
  if (!__audioCtx && typeof window !== 'undefined') {
    const C = window.AudioContext || window.webkitAudioContext;
    if (C) __audioCtx = new C();
  }
  return __audioCtx;
}

function playBija(freq, dur = 2.4, vol = 0.13) {
  const ctx = getAudio();
  if (!ctx) return;
  if (ctx.state === 'suspended') ctx.resume();
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.type = 'sine';
  osc.frequency.value = freq;
  // Add a gentle second harmonic for warmth
  const osc2 = ctx.createOscillator();
  osc2.type = 'sine';
  osc2.frequency.value = freq * 2;
  const gain2 = ctx.createGain();
  osc.connect(gain); osc2.connect(gain2);
  gain.connect(ctx.destination); gain2.connect(ctx.destination);
  const now = ctx.currentTime;
  gain.gain.setValueAtTime(0, now);
  gain.gain.linearRampToValueAtTime(vol, now + 0.15);
  gain.gain.linearRampToValueAtTime(vol * 0.85, now + dur * 0.7);
  gain.gain.linearRampToValueAtTime(0, now + dur);
  gain2.gain.setValueAtTime(0, now);
  gain2.gain.linearRampToValueAtTime(vol * 0.25, now + 0.2);
  gain2.gain.linearRampToValueAtTime(0, now + dur * 0.9);
  osc.start(now); osc.stop(now + dur);
  osc2.start(now); osc2.stop(now + dur * 0.9);
}

// ─── Sustained home voice (Ring 2) ───────────────────────────────────────────
let __rwHome = null;
function rwHomeStart() {
  const ctx = getAudio(); if (!ctx || __rwHome) return;
  if (ctx.state === 'suspended') ctx.resume();
  const g = ctx.createGain(); g.gain.value = 0; g.connect(ctx.destination);
  const o1 = ctx.createOscillator(); o1.type = 'sine'; o1.frequency.value = 130.81; // C3 — home
  const o2 = ctx.createOscillator(); o2.type = 'sine'; o2.frequency.value = 196.00; // a fifth
  const g2 = ctx.createGain(); g2.gain.value = 0.45; o2.connect(g2); g2.connect(g);
  o1.connect(g);
  const lfo = ctx.createOscillator(); lfo.type = 'sine'; lfo.frequency.value = 0.18; // slow breath
  const lg = ctx.createGain(); lg.gain.value = 0.02; lfo.connect(lg); lg.connect(g.gain);
  o1.start(); o2.start(); lfo.start();
  g.gain.setTargetAtTime(0.045, ctx.currentTime, 0.6);
  __rwHome = { o1, o2, lfo, g };
}
function rwHomeGain(v) { if (__rwHome) try { __rwHome.g.gain.setTargetAtTime(v, __audioCtx.currentTime, 0.25); } catch(e){} }
function rwHomeStop() {
  if (!__rwHome) return; const h = __rwHome; __rwHome = null;
  try { h.g.gain.setTargetAtTime(0, __audioCtx.currentTime, 0.4);
    setTimeout(() => { try { h.o1.stop(); h.o2.stop(); h.lfo.stop(); } catch(e){} }, 1000); } catch(e){}
}

// ─── Ring 8 triad — three tones that collapse into one ───────────────────────
const R8_FREQS = [261.63, 311.13, 392.00]; // Icchā · Jñāna · Kriyā (a minor triad)
let __r8 = null;
function r8Start() {
  const ctx = getAudio(); if (!ctx || __r8) return; if (ctx.state === 'suspended') ctx.resume();
  const master = ctx.createGain(); master.gain.value = 0; master.connect(ctx.destination);
  const oscs = R8_FREQS.map((f) => {
    const o = ctx.createOscillator(); o.type = 'sine'; o.frequency.value = f;
    const g = ctx.createGain(); g.gain.value = 0.33; o.connect(g); g.connect(master); o.start();
    return { o, g };
  });
  master.gain.setTargetAtTime(0.06, ctx.currentTime, 0.5);
  __r8 = { master, oscs };
}
function r8Set(target) { // 'triad' | 0|1|2 | 'bindu'
  if (!__r8) return; const ctx = getAudio(); const t = ctx.currentTime;
  __r8.oscs.forEach((v, i) => {
    const f = target === 'triad' ? R8_FREQS[i] : target === 'bindu' ? 130.81 : R8_FREQS[target];
    try { v.o.frequency.setTargetAtTime(f, t, 0.55); } catch(e){}
  });
}
function r8Stop() {
  if (!__r8) return; const r = __r8; __r8 = null;
  try { r.master.gain.setTargetAtTime(0, __audioCtx.currentTime, 0.4);
    setTimeout(() => r.oscs.forEach((v) => { try { v.o.stop(); } catch(e){} }), 1000); } catch(e){}
}

// ─── A small, discreet sound toggle (lower-left) ─────────────────────────────
function RingSoundToggle({ on, onToggle, label = 'tone', color = '#E8C97A' }) {
  return (
    <div onPointerDown={(e)=>e.stopPropagation()} onClick={onToggle} style={{
      position: 'absolute', bottom: 50, left: 22, zIndex: 6, cursor: 'pointer',
      display: 'flex', alignItems: 'center', gap: 6 }}>
      <div style={{ width: 18, height: 18, borderRadius: '50%',
        border: `0.5px solid ${color}${on ? 'b3' : '4d'}`, display: 'flex', alignItems: 'center',
        justifyContent: 'center', background: on ? `${color}1f` : 'transparent', transition: 'all 0.4s ease' }}>
        <div style={{ width: 4, height: 4, borderRadius: '50%', background: on ? color : 'rgba(242,232,217,0.3)' }}/>
      </div>
      <span style={{ fontFamily: '-apple-system, sans-serif', fontSize: 8,
        color: 'rgba(242,232,217,0.22)', letterSpacing: '0.22em', textTransform: 'uppercase' }}>
        {on ? label : 'silent'}</span>
    </div>
  );
}

// Bīja frequencies — a mystical mode (mixolydian-ish), warm and grounded.
// Vāśinī starts low; ascending around the circle.
const VAK_FREQS = [
  { name: 'Vāśinī',     bija: 'aṁ',  freq: 220.00 },
  { name: 'Kāmeśvarī',  bija: 'āṁ',  freq: 246.94 },
  { name: 'Modinī',     bija: 'iṁ',  freq: 261.63 },
  { name: 'Vimalā',     bija: 'īṁ',  freq: 293.66 },
  { name: 'Aruṇā',      bija: 'uṁ',  freq: 329.63 },
  { name: 'Jayinī',     bija: 'ūṁ',  freq: 349.23 },
  { name: 'Sarveśvarī', bija: 'eṁ',  freq: 392.00 },
  { name: 'Kaulinī',    bija: 'aiṁ', freq: 440.00 },
  { name: 'Vāṅmayī',    bija: 'oṁ',  freq: 493.88 },
  { name: 'Onmādinī',   bija: 'auṁ', freq: 523.25 },
  { name: 'Mantreśī',   bija: 'aṃ',  freq: 587.33 },
  { name: 'Śaktimayī',  bija: 'aḥ',  freq: 659.25 },
];

function RingSevenWorld({ initialActive = null, chord = false, initialHealed = false }) {
  const [active, setActive] = React.useState(initialActive);
  const [chordActive, setChordActive] = React.useState(chord);
  const [sounded, setSounded] = React.useState(() => new Set(
    initialHealed ? VAK_FREQS.map((_, i) => i) : (initialActive != null ? [initialActive] : [])));
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 408;
  const N = VAK_FREQS.length;
  const step = 360 / N;
  const orbitR = 140;
  const healed = sounded.size >= 7;

  function strikeOne(i) {
    setActive(i);
    setChordActive(false);
    setSounded(prev => { const n = new Set(prev); n.add(i); return n; });
    playBija(VAK_FREQS[i].freq, 2.6, 0.11);
    setTimeout(() => setActive(prev => prev === i ? null : prev), 2400);
  }
  function strikeChord() {
    setChordActive(true);
    setActive(null);
    setSounded(new Set(VAK_FREQS.map((_, i) => i)));
    VAK_FREQS.forEach((v, i) => {
      setTimeout(() => playBija(v.freq, 3.2, 0.05), i * 55);
    });
    setTimeout(() => setChordActive(false), 3400);
  }

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'linear-gradient(180deg, #0E0703 0%, #0A0502 50%, #060301 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 70% 55% at 50% 48%,
          rgba(212,160,23,0.16) 0%, rgba(139,90,40,0.06) 45%, transparent 75%)`,
        pointerEvents: 'none',
      }}/>
      <DustMotes count={8}/>

      <StatusBar/>
      <ReturnGesture/>

      <div style={{
        position: 'absolute', top: 92, left: 0, right: 0,
        textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 13, fontStyle: 'italic',
        color: 'rgba(212,160,80,0.6)',
        letterSpacing: '0.18em',
      }}>Sarvarogahara · the Vāk Chamber</div>

      {/* Background geometry — Ring 7 triangles, very subtle */}
      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0 }}>
        <g transform={`translate(${cx},${cy})`} opacity="0.12">
          {[80, 65, 52, 40].map(r => (
            <React.Fragment key={r}>
              <path d={`M 0,${-r} L ${r*0.866},${r/2} L ${-r*0.866},${r/2} Z`}
                fill="none" stroke="#E8C97A" strokeWidth="0.5"/>
              <path d={`M 0,${r} L ${r*0.866},${-r/2} L ${-r*0.866},${-r/2} Z`}
                fill="none" stroke="#E8C97A" strokeWidth="0.5"/>
            </React.Fragment>
          ))}
        </g>

        {/* Sound rings — visible when something is sounding */}
        {(active !== null || chordActive) && [0, 1, 2].map(i => (
          <circle key={i} cx={cx}
            cy={active !== null
              ? cy + orbitR * Math.sin((active * step - 90) * Math.PI / 180)
              : cy}
            r={20}
            fill="none" stroke="#E8C97A" strokeWidth="0.6"
            className="rw7-sound-ring"
            style={{
              transformOrigin: `${cx}px ${active !== null
                ? cy + orbitR * Math.sin((active * step - 90) * Math.PI / 180)
                : cy}px`,
              animationDelay: `${i * 0.3}s`,
              opacity: chordActive ? 0.5 : 0.7,
            }}/>
        ))}

        {/* Chord ripple — emanates from center when chord plays */}
        {chordActive && [0, 1, 2, 3].map(i => (
          <circle key={`c${i}`} cx={cx} cy={cy} r={30}
            fill="none" stroke="#F2E8D9" strokeWidth="0.5"
            className="rw7-chord-ring"
            style={{ transformOrigin: `${cx}px ${cy}px`,
                     animationDelay: `${i * 0.2}s` }}/>
        ))}
      </svg>

      {/* The 12 Vāk-devatās — circular arrangement */}
      {VAK_FREQS.map((v, i) => {
        const angle = (i * step - 90) * Math.PI / 180;
        const vx = cx + orbitR * Math.cos(angle);
        const vy = cy + orbitR * Math.sin(angle);
        const isActive = active === i;
        return (
          <div key={i}
            onClick={() => strikeOne(i)}
            style={{
              position: 'absolute', left: vx, top: vy,
              transform: 'translate(-50%, -50%)',
              display: 'flex', flexDirection: 'column',
              alignItems: 'center', cursor: 'pointer',
              zIndex: 3, userSelect: 'none',
            }}>
            <div style={{
              width: 44, height: 44, borderRadius: '50%',
              border: `1px solid rgba(232,201,122,${isActive ? 0.95 : 0.45})`,
              background: isActive
                ? 'radial-gradient(circle, rgba(232,201,122,0.32) 0%, rgba(232,201,122,0.05) 100%)'
                : 'radial-gradient(circle, rgba(232,201,122,0.06) 0%, transparent 80%)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              transition: 'all 0.5s ease',
              boxShadow: isActive
                ? '0 0 24px 6px rgba(232,201,122,0.55), inset 0 0 12px rgba(232,201,122,0.3)'
                : '0 0 0 0 rgba(0,0,0,0)',
            }}>
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 18, fontWeight: 300, fontStyle: 'italic',
                color: isActive ? COLORS.cream : 'rgba(232,201,122,0.85)',
                letterSpacing: '0.06em',
                transition: 'color 0.5s ease',
              }}>{v.bija}</div>
            </div>
            <div style={{
              marginTop: 6,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 10.5, fontStyle: 'italic',
              color: isActive ? '#E8C97A' : 'rgba(242,232,217,0.55)',
              letterSpacing: '0.04em',
              transition: 'color 0.5s ease',
            }}>{v.name}</div>
          </div>
        );
      })}

      {/* Chord center — tap for the full harmonic */}
      <div onClick={strikeChord} style={{
        position: 'absolute', left: cx, top: cy,
        transform: 'translate(-50%, -50%)',
        width: 60, height: 60, borderRadius: '50%',
        background: chordActive
          ? 'radial-gradient(circle, rgba(242,232,217,0.85) 0%, rgba(232,201,122,0.4) 50%, transparent 100%)'
          : 'radial-gradient(circle, rgba(232,201,122,0.18) 0%, rgba(232,201,122,0.04) 60%, transparent 100%)',
        border: `0.5px solid rgba(242,232,217,${chordActive ? 0.6 : 0.18})`,
        cursor: 'pointer', zIndex: 4,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        transition: 'all 0.6s ease',
        boxShadow: chordActive
          ? '0 0 40px 14px rgba(232,201,122,0.45)'
          : '0 0 12px 2px rgba(232,201,122,0.12)',
      }}>
        <div style={{
          width: 6, height: 6, borderRadius: '50%',
          background: COLORS.cream,
          opacity: chordActive ? 1 : 0.7,
        }}/>
      </div>

      {/* Caption — bottom */}
      <div style={{
        position: 'absolute', bottom: 70, left: 0, right: 0,
        textAlign: 'center', zIndex: 3, pointerEvents: 'none',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: healed && active === null && !chordActive ? 17 : 15, fontStyle: 'italic',
          color: chordActive || active !== null ? '#E8C97A'
            : healed ? 'rgba(242,232,217,0.78)' : 'rgba(242,232,217,0.45)',
          letterSpacing: '0.04em',
          transition: 'color 0.6s ease',
          minHeight: 22, padding: '0 38px', lineHeight: 1.4,
        }}>
          {chordActive ? 'the full chord — all twelve at once'
           : active !== null ? VAK_FREQS[active].name
           : healed ? 'The word that healed what the mind could not reach.'
           : 'tap a syllable · tap center for the chord'}
        </div>
        <div style={{
          marginTop: 8,
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9, color: 'rgba(242,232,217,0.18)',
          letterSpacing: '0.28em', textTransform: 'uppercase',
        }}>{healed ? 'she who removes all disease' : `${sounded.size} of 12 voices sounded`}</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 8 WORLD — THE MŪLA TRIKOṆA
// Three points. Three were never three. The simplicity is the teaching.
// Tap a vertex → the other two collapse into it.
// Tap the realized quality → it dissolves into the Bindu. Begin again.
// ═════════════════════════════════════════════════════════════════════════════

const MULA_VERTICES = [
  { name: 'Icchā',  english: 'Will',      sub: 'the wanting before want has an object',
    color: '#C45050' },
  { name: 'Jñāna',  english: 'Knowledge', sub: 'the knowing before knowledge has content',
    color: '#9A8FC4' },
  { name: 'Kriyā',  english: 'Action',    sub: 'the doing before doing has direction',
    color: '#5A9A8B' },
];

function RingEightWorld({ state: initialState = 'triangle' }) {
  // state: 'triangle' | 'icchaa' | 'jnaana' | 'kriyaa' | 'dissolved'
  const [state, setState] = React.useState(initialState);
  const [sound, setSound] = React.useState(false);
  const soundRef = React.useRef(false);
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 330;             // triangle composed in upper half
  const R = 132;                                 // triangle radius (apex to center)

  React.useEffect(() => () => r8Stop(), []);
  const idxOf = (s) => s === 'icchaa' ? 0 : s === 'jnaana' ? 1 : s === 'kriyaa' ? 2 : null;
  function applySound(s) {
    if (!soundRef.current) return;
    r8Set(s === 'triangle' ? 'triad' : s === 'dissolved' ? 'bindu' : idxOf(s));
  }
  function chooseVertex(i, e) {
    e && e.stopPropagation();
    if (state !== 'triangle') return;
    const s = ['icchaa', 'jnaana', 'kriyaa'][i];
    setState(s); applySound(s);
  }
  function advance() {
    if (state === 'triangle') return;            // must choose a vertex first
    const s = state === 'dissolved' ? 'triangle' : 'dissolved';
    setState(s); applySound(s);
  }
  function toggleSound(e) {
    e && e.stopPropagation();
    if (soundRef.current) { r8Stop(); soundRef.current = false; setSound(false); }
    else { r8Start(); soundRef.current = true; setSound(true);
      r8Set(state === 'triangle' ? 'triad' : state === 'dissolved' ? 'bindu' : idxOf(state)); }
  }

  // Triangle vertex positions — apex up (icchaa), bottom-left (jnaana), bottom-right (kriyaa)
  const verts = [
    { idx: 0, x: cx,            y: cy - R },
    { idx: 1, x: cx - R * 0.866, y: cy + R * 0.5 },
    { idx: 2, x: cx + R * 0.866, y: cy + R * 0.5 },
  ];

  const isCollapsed = state === 'icchaa' || state === 'jnaana' || state === 'kriyaa';
  const collapseIdx = state === 'icchaa' ? 0 : state === 'jnaana' ? 1 : state === 'kriyaa' ? 2 : null;
  const isDissolved = state === 'dissolved';
  const meta = collapseIdx !== null ? MULA_VERTICES[collapseIdx] : null;

  return (
    <div onClick={advance} style={{
      width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 80% 70% at 50% 40%, #0A0608 0%, #020001 100%)',
      position: 'relative', overflow: 'hidden',
      cursor: state === 'triangle' ? 'default' : 'pointer', userSelect: 'none',
    }}>
      <DustMotes count={4}/>

      <StatusBar/>
      <ReturnGesture light={true}/>

      {/* Ring identity */}
      <div style={{
        position: 'absolute', top: 92, left: 0, right: 0,
        textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 13, fontStyle: 'italic',
        color: 'rgba(242,232,217,0.35)',
        letterSpacing: '0.18em',
      }}>Sarvasiddhiprada · the Mūla Trikoṇa</div>

      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* The triangle — full presence in triangle state */}
        {state === 'triangle' && (
          <path
            d={`M ${verts[0].x},${verts[0].y} L ${verts[1].x},${verts[1].y} L ${verts[2].x},${verts[2].y} Z`}
            fill="none" stroke={COLORS.cream} strokeWidth="1"
            strokeLinejoin="round" opacity="0.85"
            className="rw8-triangle"/>
        )}

        {/* Collapsed state — ghosted triangle + lines pulling toward the chosen vertex */}
        {isCollapsed && (
          <g className="rw8-collapse">
            <path
              d={`M ${verts[0].x},${verts[0].y} L ${verts[1].x},${verts[1].y} L ${verts[2].x},${verts[2].y} Z`}
              fill="none" stroke={COLORS.cream} strokeWidth="0.5"
              opacity="0.10"/>
            {verts.filter((_, i) => i !== collapseIdx).map((v, k) => (
              <line key={k}
                x1={v.x} y1={v.y}
                x2={verts[collapseIdx].x} y2={verts[collapseIdx].y}
                stroke={meta.color}
                strokeWidth="0.5" opacity="0.55"
                strokeDasharray="2 5"/>
            ))}
          </g>
        )}

        {/* Vertices — luminous points (hidden when dissolved) */}
        {!isDissolved && verts.map((v, i) => {
          const m = MULA_VERTICES[i];
          const isThisCollapse = i === collapseIdx;
          const fade = (isCollapsed && !isThisCollapse) ? 0.22 : 1;
          return (
            <g key={i} opacity={fade}
              onClick={state === 'triangle' ? (e) => chooseVertex(i, e) : undefined}
              style={{ cursor: state === 'triangle' ? 'pointer' : 'default' }}>
              <circle cx={v.x} cy={v.y} r="20" fill="transparent"/>
              <circle cx={v.x} cy={v.y} r={isThisCollapse ? 24 : 12}
                fill={m.color} opacity="0.20"
                style={{ filter: 'blur(8px)' }}/>
              <circle cx={v.x} cy={v.y} r={isThisCollapse ? 7 : 5}
                fill={m.color}/>
              <circle cx={v.x} cy={v.y} r={isThisCollapse ? 3 : 2}
                fill={COLORS.cream}/>
            </g>
          );
        })}

        {/* Bindu — at the triangle's centroid, swells huge when dissolved */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r={isDissolved ? 52 : 7}
            fill={COLORS.accentRed}
            opacity={isDissolved ? 0.92 : 0.7}
            style={{
              filter: isDissolved
                ? 'drop-shadow(0 0 44px rgba(139,26,42,0.8))'
                : 'drop-shadow(0 0 8px rgba(139,26,42,0.4))',
              transition: 'all 1.4s ease',
            }}/>
          <circle r={isDissolved ? 20 : 3}
            fill={COLORS.cream}
            opacity={isDissolved ? 1 : 0.9}
            style={{
              filter: isDissolved
                ? 'drop-shadow(0 0 24px rgba(242,232,217,0.95))'
                : 'drop-shadow(0 0 4px rgba(242,232,217,0.7))',
              transition: 'all 1.4s ease',
            }}/>
        </g>
      </svg>

      {/* ── Triangle state — vertex labels + descriptions + caption ──────── */}
      {state === 'triangle' && (
        <>
          {verts.map((v, i) => {
            const m = MULA_VERTICES[i];
            const dy = i === 0 ? -36 : 30;
            const dx = i === 0 ? 0 : (i === 1 ? -10 : 10);
            return (
              <div key={i} style={{
                position: 'absolute',
                left: v.x + dx, top: v.y + dy,
                transform: 'translate(-50%, -50%)',
                pointerEvents: 'none', zIndex: 3,
                textAlign: 'center',
              }}>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 24, fontWeight: 300, fontStyle: 'italic',
                  color: m.color,
                  letterSpacing: '0.04em',
                  textShadow: `0 0 14px ${m.color}88`,
                }}>{m.name}</div>
                <div style={{
                  fontFamily: '-apple-system, sans-serif',
                  fontSize: 10,
                  color: 'rgba(242,232,217,0.40)',
                  letterSpacing: '0.20em', textTransform: 'uppercase',
                  marginTop: 3,
                }}>{m.english}</div>
              </div>
            );
          })}

          {/* The teaching, set below the triangle — fills the lower half */}
          <div style={{
            position: 'absolute', top: 540, left: 36, right: 36,
            textAlign: 'center', zIndex: 3, pointerEvents: 'none',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 21, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.72)',
              letterSpacing: '0.02em', lineHeight: 1.6,
              marginBottom: 24,
            }}>The root triangle.<br/>Will, knowledge, action —<br/>one undivided power.</div>

            <div style={{
              width: 36, height: 0.5,
              background: 'rgba(242,232,217,0.22)',
              margin: '0 auto 22px',
            }}/>

            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.30)',
              letterSpacing: '0.32em', textTransform: 'uppercase',
            }}>tap a vertex</div>
          </div>
        </>
      )}

      {/* ── Collapsed state — chosen quality fills the lower composition ── */}
      {isCollapsed && (
        <div style={{
          position: 'absolute', top: 470, left: 0, right: 0,
          padding: '0 32px', zIndex: 4, pointerEvents: 'none',
          textAlign: 'center',
        }}>
          {/* HUGE name */}
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 76, fontWeight: 300, fontStyle: 'italic',
            color: meta.color,
            letterSpacing: '0.05em',
            lineHeight: 1.0, marginBottom: 14,
            textShadow: `0 0 40px ${meta.color}aa`,
          }}>{meta.name}</div>

          {/* English under */}
          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 11, color: 'rgba(242,232,217,0.45)',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            marginBottom: 32,
          }}>{meta.english}</div>

          {/* Italic prose */}
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 19, fontStyle: 'italic', fontWeight: 300,
            color: 'rgba(242,232,217,0.66)',
            lineHeight: 1.65,
            letterSpacing: '0.015em',
            maxWidth: 300, margin: '0 auto 36px',
          }}>{meta.sub}</div>

          {/* Faint hint */}
          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 9, color: 'rgba(242,232,217,0.22)',
            letterSpacing: '0.30em', textTransform: 'uppercase',
          }}>the other two have collapsed in · tap to dissolve</div>
        </div>
      )}

      {/* ── Dissolved state — the resolution ─────────────────────────────── */}
      {isDissolved && (
        <div style={{
          position: 'absolute', top: 470, left: 0, right: 0,
          padding: '0 36px', zIndex: 4, pointerEvents: 'none',
          textAlign: 'center',
        }}>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 38, fontStyle: 'italic', fontWeight: 300,
            color: COLORS.cream,
            letterSpacing: '0.04em', lineHeight: 1.25,
            marginBottom: 28,
          }}>The three were never three.</div>

          <div style={{
            width: 40, height: 0.5,
            background: 'rgba(201,150,63,0.4)',
            margin: '0 auto 28px',
          }}/>

          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 18, fontStyle: 'italic', fontWeight: 300,
            color: 'rgba(242,232,217,0.50)',
            lineHeight: 1.7, letterSpacing: '0.02em',
            maxWidth: 300, margin: '0 auto 44px',
          }}>Will, knowing, doing — three motions of the same hand. The hand was always whole.</div>

          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(242,232,217,0.25)',
            letterSpacing: '0.32em', textTransform: 'uppercase',
          }}>tap to begin again</div>
        </div>
      )}

      <RingSoundToggle on={sound} onToggle={toggleSound} label="three" color="#C9963F"/>
      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── Export ───────────────────────────────────────────────────────────────────
Object.assign(window, {
  RingTwoWorld, RingTwoLotusByTime,
  RingSevenWorld, RingEightWorld,
  MULA_VERTICES, VAK_FREQS,
});
