// ─── Pure Home Mandala — Phase 2 ──────────────────────────────────────────────
// No labels. No tabs. No buttons. Just the yantra breathing in its current
// temporal state. The classical 9 interlocking triangles of the Sri Yantra
// surrounded by the two lotuses, the bhupura, and held by the Bindu.

// ─── Time Variants — the same yantra in five atmospheres ─────────────────────

const TIME_VARIANTS = {
  dawn: {
    label: 'Dawn',
    sublabel: 'warm · ascending',
    bg: '#0A0610',
    ambient: 'radial-gradient(ellipse 65% 55% at 50% 60%, rgba(232,150,80,0.13) 0%, transparent 70%)',
    petalSat: 1.0,
    petalBrightness: 1.0,
    petalOpacityMul: 0.95,
    lotusInnerOp: 0.55,
    triStroke: '#D4A067',
    triOpacity: 0.62,
    triStrokeWidth: 0.7,
    bhupuraColor: 'rgba(207,148,67,0.30)',
    binduScale: 1.0,
    binduColor: '#A8341F',
    motes: 8,
  },
  noon: {
    label: 'Noon',
    sublabel: 'vivid · full',
    bg: '#060104',
    ambient: 'radial-gradient(ellipse 65% 55% at 50% 48%, rgba(201,150,63,0.07) 0%, transparent 68%)',
    petalSat: 1.0,
    petalBrightness: 1.0,
    petalOpacityMul: 1.0,
    lotusInnerOp: 0.50,
    triStroke: '#C9963F',
    triOpacity: 0.70,
    triStrokeWidth: 0.65,
    bhupuraColor: 'rgba(207,148,67,0.25)',
    binduScale: 1.0,
    binduColor: '#8B1A2A',
    motes: 6,
  },
  dusk: {
    label: 'Dusk',
    sublabel: 'amber · descending',
    bg: '#0A0508',
    ambient: 'radial-gradient(ellipse 60% 50% at 50% 40%, rgba(199,90,80,0.13) 0%, transparent 70%)',
    petalSat: 0.85,
    petalBrightness: 0.92,
    petalOpacityMul: 0.85,
    lotusInnerOp: 0.40,
    triStroke: '#C99443',
    triOpacity: 0.55,
    triStrokeWidth: 0.6,
    bhupuraColor: 'rgba(184,132,62,0.22)',
    binduScale: 1.05,
    binduColor: '#7A1620',
    motes: 9,
  },
  night: {
    label: 'Night',
    sublabel: 'silver · deep',
    bg: '#020308',
    ambient: 'radial-gradient(ellipse 65% 55% at 50% 50%, rgba(140,180,220,0.08) 0%, transparent 70%)',
    petalSat: 0.45,
    petalBrightness: 0.75,
    petalOpacityMul: 0.55,
    lotusInnerOp: 0.28,
    triStroke: '#A4B8CC',
    triOpacity: 0.42,
    triStrokeWidth: 0.55,
    bhupuraColor: 'rgba(180,200,220,0.18)',
    binduScale: 1.1,
    binduColor: '#8B1A2A',
    motes: 12,
  },
  newmoon: {
    label: 'New Moon',
    sublabel: 'the Bindu rises',
    bg: '#020001',
    ambient: 'radial-gradient(ellipse 50% 45% at 50% 50%, rgba(139,26,42,0.22) 0%, transparent 60%)',
    petalSat: 0.30,
    petalBrightness: 0.50,
    petalOpacityMul: 0.30,
    lotusInnerOp: 0.15,
    triStroke: 'rgba(201,150,63,0.35)',
    triOpacity: 0.18,
    triStrokeWidth: 0.5,
    bhupuraColor: 'rgba(201,150,63,0.10)',
    binduScale: 1.6,
    binduColor: '#8B1A2A',
    motes: 3,
  },
};

// ─── Geometry — coordinates relative to a centered origin ────────────────────

// Sri Yantra approximation: 4 upward (Shiva) + 5 downward (Shakti) triangles
// proportioned to interlock in the recognizable mandala pattern.
const UPS = [
  { apex: [0, -88], base:  34, half: 76 }, // U1 — outermost
  { apex: [0, -68], base:  26, half: 60 }, // U2
  { apex: [0, -50], base:  18, half: 46 }, // U3
  { apex: [0, -34], base:  10, half: 34 }, // U4 — innermost upward
];
const DOWNS = [
  { apex: [0,  88], base: -34, half: 76 }, // D1 — outermost
  { apex: [0,  72], base: -28, half: 66 }, // D2
  { apex: [0,  56], base: -22, half: 52 }, // D3
  { apex: [0,  42], base: -16, half: 40 }, // D4
  { apex: [0,  26], base: -10, half: 26 }, // D5 — the mūla trikona, holds the bindu
];

function triPathFrom({ apex, base, half }) {
  const [ax, ay] = apex;
  return `M ${ax},${ay} L ${half},${base} L ${-half},${base} Z`;
}

function petalPath(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// ─── Cluster color mapping for the 16 petals, in position order ──────────────

const PETAL_COLORS = SHAKTIS.map(s => CLUSTER_INFO[s.cluster].color);

// ─── PureMandala — the yantra itself ─────────────────────────────────────────

function PureMandala({ time = 'noon', todayIndex = 4, size = 340 }) {
  const t = TIME_VARIANTS[time];
  const cx = size / 2, cy = size / 2;

  // Bhupura (Ring 1) — outer square boundary
  const bO = 158, bI = 148, bGate = 12;

  // 16-petal lotus (Ring 2) — outer lotus
  const r2_oR = 134, r2_iR = 112, r2_hw = 22;
  const r2_pPath = petalPath(r2_oR, r2_iR, r2_hw);

  // 8-petal lotus (Ring 3) — inner lotus
  const r3_oR = 109, r3_iR = 92, r3_hw = 32;
  const r3_pPath = petalPath(r3_oR, r3_iR, r3_hw);

  // Bindu sizing — boosted in new moon
  const binduBase = 14;
  const binduSize = Math.round(binduBase * t.binduScale);
  const binduCoreSize = Math.round(binduSize * 0.42);

  return (
    <div style={{
      position: 'relative', width: size, height: size,
      flexShrink: 0,
      filter: `saturate(${t.petalSat}) brightness(${t.petalBrightness})`,
    }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}
        style={{ overflow: 'visible', display: 'block' }}>

        {/* ── Ring 1 — Bhupura, the ancient ground ───── */}
        <g stroke={t.bhupuraColor} strokeWidth={0.55} fill="none">
          <rect x={cx - bO} y={cy - bO} width={bO * 2} height={bO * 2}/>
          {/* Inner square as 8 segments — gaps at T-gates */}
          {[
            [-bI, -bI, -bGate, -bI], [bGate, -bI, bI, -bI],
            [bI, -bI, bI, -bGate],   [bI, bGate, bI, bI],
            [bI, bI, bGate, bI],     [-bGate, bI, -bI, bI],
            [-bI, bI, -bI, bGate],   [-bI, -bGate, -bI, -bI],
          ].map(([x1, y1, x2, y2], k) => (
            <line key={k} x1={cx + x1} y1={cy + y1} x2={cx + x2} y2={cy + y2}/>
          ))}
          {/* T-gate connectors */}
          {[
            [-bGate, -bI, -bGate, -bO], [bGate, -bI, bGate, -bO],
            [-bGate,  bI, -bGate,  bO], [bGate,  bI, bGate,  bO],
            [-bI, -bGate, -bO, -bGate], [-bI,  bGate, -bO,  bGate],
            [ bI, -bGate,  bO, -bGate], [ bI,  bGate,  bO,  bGate],
          ].map(([x1, y1, x2, y2], k) => (
            <line key={`g${k}`} x1={cx + x1} y1={cy + y1} x2={cx + x2} y2={cy + y2}/>
          ))}
        </g>

        {/* ── Ring 2 boundary ─────────────────────────── */}
        <circle cx={cx} cy={cy} r={r2_oR + 2} fill="none"
          stroke="rgba(201,150,63,0.06)" strokeWidth="0.4"/>

        {/* ── Ring 2 — 16-petal lotus, cluster colors ─── */}
        {SHAKTIS.map((s, i) => {
          const angle = i * 22.5;
          const col = PETAL_COLORS[i];
          const isToday = i === todayIndex;
          // base opacity by status, modulated by time variant
          const baseOp = STATUS_OPACITY[s.status] * t.petalOpacityMul;
          return (
            <g key={i} transform={`translate(${cx},${cy}) rotate(${angle})`}>
              {isToday && (
                <path d={r2_pPath} fill={col}
                  className="home-petal-today-glow"
                  style={{ filter: 'blur(4px)' }}
                  opacity={0.55}/>
              )}
              <path
                d={r2_pPath} fill={col}
                className={isToday ? 'home-petal-today' : `home-petal-${s.status}`}
                style={{ animationDelay: isToday ? '0s' : `${(i * 0.18).toFixed(2)}s`,
                         opacity: baseOp }}
              />
            </g>
          );
        })}

        {/* ── Ring 2/3 boundary ───────────────────────── */}
        <circle cx={cx} cy={cy} r={r2_iR - 1} fill="none"
          stroke="rgba(201,150,63,0.09)" strokeWidth="0.4"/>

        {/* ── Ring 3 — 8-petal lotus, translucent ─────── */}
        {[0,1,2,3,4,5,6,7].map(i => (
          <g key={i} transform={`translate(${cx},${cy}) rotate(${i * 45})`}>
            <path d={r3_pPath}
              fill={`rgba(201,150,63,${t.lotusInnerOp * 0.10})`}
              stroke={`rgba(201,150,63,${t.lotusInnerOp * 0.4})`}
              strokeWidth="0.5"
              className="home-r3-petal"
              style={{ animationDelay: `${(i * 0.6).toFixed(1)}s` }}/>
          </g>
        ))}

        {/* ── Ring 3/triangle boundary ───────────────── */}
        <circle cx={cx} cy={cy} r={r3_iR - 1} fill="none"
          stroke="rgba(201,150,63,0.05)" strokeWidth="0.35"/>

        {/* ── Rings 4-8 — the 9 interlocking triangles ── */}
        <g transform={`translate(${cx},${cy})`}>
          {UPS.map((tri, i) => (
            <path key={`u${i}`} d={triPathFrom(tri)} fill="none"
              stroke={t.triStroke} strokeWidth={t.triStrokeWidth}
              strokeLinejoin="round"
              className={`home-tri-up home-tri-up-${i}`}
              style={{
                opacity: t.triOpacity * (1 - i * 0.08),
                animationDelay: `${(i * 0.5).toFixed(1)}s`,
              }}/>
          ))}
          {DOWNS.map((tri, i) => (
            <path key={`d${i}`} d={triPathFrom(tri)} fill="none"
              stroke={t.triStroke} strokeWidth={t.triStrokeWidth}
              strokeLinejoin="round"
              className={`home-tri-down home-tri-down-${i}`}
              style={{
                opacity: t.triOpacity * (1 - i * 0.06),
                animationDelay: `${(i * 0.5 + 0.3).toFixed(1)}s`,
              }}/>
          ))}
        </g>
      </svg>

      {/* ── Ring 9 — the Bindu, breathing ──────────────── */}
      <div className="home-bindu" style={{
        width: binduSize, height: binduSize,
        background: `radial-gradient(circle, ${t.binduColor} 0%, ${t.binduColor}aa 50%, transparent 100%)`,
        boxShadow: `0 0 ${binduSize}px ${Math.round(binduSize*0.4)}px ${t.binduColor}66`,
      }}>
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%,-50%)',
          width: binduCoreSize, height: binduCoreSize,
          borderRadius: '50%',
          background: COLORS.cream,
          opacity: 0.96,
          boxShadow: `0 0 ${Math.round(binduCoreSize*0.7)}px rgba(242,232,217,0.65)`,
        }}/>
      </div>
    </div>
  );
}

// ─── Subtle Temporal Mark — a single dot or curve at top of screen ──────────
// Almost imperceptible. Just enough that the practitioner who looks for it
// knows what time the yantra is reading. Never has text.

function TemporalMark({ time }) {
  // Position on a horizontal arc — left=dawn, top=noon, right=dusk, bottom=night
  const pos = {
    dawn:    { x: 40,  glow: '#E8C97A', sym: 'arc-asc' },
    noon:    { x: 50,  glow: '#F2E8D9', sym: 'sun' },
    dusk:    { x: 60,  glow: '#C99443', sym: 'arc-desc' },
    night:   { x: 75,  glow: '#A4B8CC', sym: 'moon' },
    newmoon: { x: 50,  glow: '#3A1A20', sym: 'dot' },
  }[time];

  return (
    <div style={{
      position: 'absolute', top: 52, left: 0, right: 0,
      display: 'flex', justifyContent: 'center',
      pointerEvents: 'none', zIndex: 2,
    }}>
      <div style={{
        width: 6, height: 6, borderRadius: '50%',
        background: pos.glow, opacity: 0.5,
        boxShadow: `0 0 8px ${pos.glow}`,
      }}/>
    </div>
  );
}

// ─── HomeScreen — the actual mobile screen ───────────────────────────────────
// 390 × 844. No tab bar. No buttons. No labels. Just the yantra.

function HomeScreen({ time = 'noon', todayIndex = 4 }) {
  const t = TIME_VARIANTS[time];
  return (
    <div style={{
      width: 390, height: 844,
      background: t.bg,
      position: 'relative', overflow: 'hidden',
    }}>
      {/* Ambient glow */}
      <div style={{
        position: 'absolute', inset: 0,
        background: t.ambient,
        pointerEvents: 'none',
      }}/>

      {/* Status bar — at the very top */}
      <StatusBar/>

      {/* Dust motes — atmospheric particles, count varies by time */}
      <DustMotes count={t.motes}/>

      {/* Temporal mark — barely perceptible */}
      <TemporalMark time={time}/>

      {/* The yantra — perfectly centered, generous breathing room */}
      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%, -50%)',
        zIndex: 2,
      }}>
        <PureMandala time={time} todayIndex={todayIndex} size={340}/>
      </div>

      <HomeIndicator light={time === 'newmoon' || time === 'night'}/>
    </div>
  );
}

// ─── Export ───────────────────────────────────────────────────────────────────
Object.assign(window, {
  PureMandala, HomeScreen, TemporalMark, TIME_VARIANTS,
});
