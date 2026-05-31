// ─── Bindu Mandala — 9-Ring Sri Yantra Component ─────────────────────────────
// Nine rings. Nine metabolisms. The ground does not breathe — it holds.
// The center never stopped calling. Everything between is alive.

// ─── Geometry ─────────────────────────────────────────────────────────────────

const SY = {
  // Ring 1 — Bhupura, Ancient Ground. Warm amber, no animation.
  BH_OUTER: 161, BH_INNER: 149, BH_GATE: 11,
  BH_COLOR: '#CF9443',  // warmer amber than gold — like something breathed a long time

  // Ring 2 — 16-Petal Lotus, Home
  R2_OUTER: 147, R2_INNER: 116, R2_HW: 28,

  // Ring 3 — 8-Petal Lotus, Unlocked. Wider petals — the Ananga forms are more open.
  R3_OUTER: 114, R3_INNER: 91,  R3_HW: 34,

  // Rings 4-7 — Interlocked Triangle Pairs. Each pair slightly dimmer, thinner.
  TRIS: [
    { ring: 4, d: 87, u: 79, cls: 'lock-r4', sw: 0.70 },
    { ring: 5, d: 70, u: 62, cls: 'lock-r5', sw: 0.65 },
    { ring: 6, d: 54, u: 46, cls: 'lock-r6', sw: 0.60 },
    { ring: 7, d: 40, u: 33, cls: 'lock-r7', sw: 0.55 },
  ],

  // Ring 8 — Mula Trikona, Deep Ghost
  MT_R: 24,

  // Ring 9 — Bindu (handled as HTML overlay for scale breathing)
  BINDU_SIZE: 22,
};

// ─── Helpers ──────────────────────────────────────────────────────────────────

function hexRgb(hex) {
  return [parseInt(hex.slice(1,3),16), parseInt(hex.slice(3,5),16), parseInt(hex.slice(5,7),16)];
}

function makePetalPath(outerR, innerR, hw) {
  const ir = innerR.toFixed(1), or = outerR.toFixed(1);
  const c1x = hw.toFixed(1),           c1y = (-innerR * 1.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1),  c2y = (-outerR * 0.85).toFixed(1);
  const nc2x = (-(hw * 0.95)).toFixed(1), nc1x = (-hw).toFixed(1);
  return `M 0,${-ir} C ${c1x},${c1y} ${c2x},${c2y} 0,${-or} C ${nc2x},${c2y} ${nc1x},${c1y} 0,${-ir} Z`;
}

function makeTriPath(R, up = false) {
  const h = +(R * Math.sqrt(3) / 2).toFixed(2);
  const half = +(R / 2).toFixed(2);
  if (up) return `M 0,${-R} L ${h},${half} L ${-h},${half} Z`;
  return `M 0,${R} L ${h},${-half} L ${-h},${-half} Z`;
}

// ─── Ring 1 — Bhupura, Ancient Ground ────────────────────────────────────────
// The world boundary. Two squares with T-gate openings on each cardinal side.
// No animation: the earth underfoot does not breathe — it holds.

function Bhupura({ cx, cy }) {
  const { BH_OUTER: o, BH_INNER: i, BH_GATE: g, BH_COLOR: col } = SY;
  const st = { stroke: col, strokeWidth: 0.5, fill: 'none', opacity: 0.22 };

  // Inner square as 8 line segments — gaps at each cardinal center (the T-gate openings)
  const segs = [
    [cx-i, cy-i, cx-g, cy-i], [cx+g, cy-i, cx+i, cy-i], // top
    [cx+i, cy-i, cx+i, cy-g], [cx+i, cy+g, cx+i, cy+i], // right
    [cx+i, cy+i, cx+g, cy+i], [cx-g, cy+i, cx-i, cy+i], // bottom
    [cx-i, cy+i, cx-i, cy+g], [cx-i, cy-g, cx-i, cy-i], // left
  ];

  // T-gate connectors — bridge from inner gap to outer boundary
  const gates = [
    [cx-g, cy-i, cx-g, cy-o], [cx+g, cy-i, cx+g, cy-o], // top gate
    [cx-g, cy+i, cx-g, cy+o], [cx+g, cy+i, cx+g, cy+o], // bottom gate
    [cx-i, cy-g, cx-o, cy-g], [cx-i, cy+g, cx-o, cy+g], // left gate
    [cx+i, cy-g, cx+o, cy-g], [cx+i, cy+g, cx+o, cy+g], // right gate
  ];

  return (
    <g>
      <rect x={cx-o} y={cy-o} width={o*2} height={o*2} {...st}/>
      {segs.map(([x1,y1,x2,y2], k) => (
        <line key={k} x1={x1} y1={y1} x2={x2} y2={y2} {...st}/>
      ))}
      {gates.map(([x1,y1,x2,y2], k) => (
        <line key={`g${k}`} x1={x1} y1={y1} x2={x2} y2={y2} {...st}/>
      ))}
    </g>
  );
}

// ─── Ring 2 — Home Lotus, 16 Petals ──────────────────────────────────────────
// The current field of play. Petals breathe in a slow wave — each 0.18s behind
// the next, so the lotus undulates like water. Today's petal glows gold.

function HomeLotus({ cx, cy, todayIndex }) {
  const { R2_OUTER: oR, R2_INNER: iR, R2_HW: hw } = SY;
  const pPath = makePetalPath(oR, iR, hw);
  const lR = (oR + iR) / 2; // label midpoint = 131.5

  return (
    <g>
      {SHAKTIS.map((s, i) => {
        const angle   = i * 22.5;
        const isToday = i === todayIndex;
        const col     = CLUSTER_INFO[s.cluster].color;
        const [r,g,b] = hexRgb(col);
        const cls     = isToday ? 'ring2-today' : `ring2-${s.status}`;
        const delay   = isToday ? '0s' : `${(i * 0.18).toFixed(2)}s`;
        const la      = (angle - 90) * Math.PI / 180;
        const lx      = cx + lR * Math.cos(la);
        const ly      = cy + lR * Math.sin(la);
        const lop     = Math.min(0.82, STATUS_OPACITY[s.status] + 0.18);

        return (
          <g key={i}>
            {/* Embodied petals get a soft blurred glow layer beneath */}
            {s.status === 'embodied' && (
              <g transform={`translate(${cx},${cy}) rotate(${angle})`}
                style={{ pointerEvents:'none' }}>
                <path d={pPath} fill={`rgba(${r},${g},${b},0.15)`}
                  style={{ filter:'blur(5px)' }}/>
              </g>
            )}
            <g transform={`translate(${cx},${cy}) rotate(${angle})`}>
              <path d={pPath} fill={col} className={cls} style={{ animationDelay: delay }}/>
            </g>
            <text x={lx} y={ly} textAnchor="middle" dominantBaseline="middle"
              fontSize={7.5} fontFamily="'Cormorant Garamond', serif"
              fill={`rgba(${r},${g},${b},${lop})`}
              style={{ userSelect:'none', pointerEvents:'none' }}>
              {s.short}
            </text>
          </g>
        );
      })}
    </g>
  );
}

// ─── Ring 3 — Unlocked Lotus, 8 Petals ───────────────────────────────────────
// Accessible. The Ananga Shaktis wait here — bodiless desires, wider petals,
// slower breath. Labels barely visible — they haven't been formally met yet.

function UnlockedLotus({ cx, cy }) {
  const { R3_OUTER: oR, R3_INNER: iR, R3_HW: hw } = SY;
  const pPath = makePetalPath(oR, iR, hw);
  const lR    = (oR + iR) / 2; // 102.5

  return (
    <g>
      {RING3_SHAKTIS.map((s, i) => {
        const angle = i * 45;
        const la    = (angle - 90) * Math.PI / 180;
        const lx    = cx + lR * Math.cos(la);
        const ly    = cy + lR * Math.sin(la);
        return (
          <g key={i}>
            <g transform={`translate(${cx},${cy}) rotate(${angle})`}>
              <path d={pPath} fill={COLORS.gold} className="ring3-petal"
                style={{ animationDelay: `${(i * 0.6).toFixed(1)}s` }}/>
            </g>
            <text x={lx} y={ly} textAnchor="middle" dominantBaseline="middle"
              fontSize={6.5} fontFamily="'Cormorant Garamond', serif"
              fill="rgba(242,232,217,0.30)"
              style={{ userSelect:'none', pointerEvents:'none' }}>
              {s.short}
            </text>
          </g>
        );
      })}
    </g>
  );
}

// ─── Rings 4-7 — Interlocked Triangle Zone, Locked ───────────────────────────
// 8 overlapping triangles (4 down / 4 up) at different sizes.
// Each pair breathes at its own pace, staggered so they pulse as a living web.
// Their intersection at low opacity IS the visual essence of the Sri Yantra.

function TriangleZone({ cx, cy }) {
  return (
    <g transform={`translate(${cx},${cy})`}>
      {SY.TRIS.map(({ ring, d, u, cls, sw }, gi) => (
        <g key={ring}>
          <path d={makeTriPath(d, false)} fill="none" stroke={COLORS.gold}
            strokeWidth={sw} strokeLinejoin="round" className={cls}
            style={{ animationDelay: `${(gi * 0.7).toFixed(1)}s` }}/>
          <path d={makeTriPath(u, true)} fill="none" stroke={COLORS.gold}
            strokeWidth={sw} strokeLinejoin="round" className={cls}
            style={{ animationDelay: `${(gi * 0.7 + 0.4).toFixed(1)}s` }}/>
        </g>
      ))}
    </g>
  );
}

// ─── Ring 8 — Mula Trikona, Deep Ghost ───────────────────────────────────────
// The root triangle: will, knowledge, action as one. Almost imperceptible.
// It has always been here. It will become visible in time.

function MulaTrikona({ cx, cy }) {
  return (
    <g transform={`translate(${cx},${cy})`}>
      <path d={makeTriPath(SY.MT_R, false)} fill="none"
        stroke={COLORS.gold} strokeWidth={0.45} strokeLinejoin="round"
        className="deep-ghost-tri"/>
    </g>
  );
}

// ─── TODAY Indicator — Ray + Dot ──────────────────────────────────────────────
// A thin gold ray and glowing dot mark today's assigned Shakti.
// No text — the active petal already speaks. The ray simply points.

function TodayIndicator({ cx, cy, todayIndex }) {
  const a = (todayIndex * 22.5 - 90) * Math.PI / 180;
  const cA = Math.cos(a), sA = Math.sin(a);
  const r1 = SY.R2_OUTER + 2;   // ray start
  const rE = SY.R2_OUTER + 8;   // ray end
  const rD = SY.R2_OUTER + 13;  // dot position (in bhupura zone)

  return (
    <g style={{ pointerEvents:'none' }}>
      <line
        x1={cx + r1*cA} y1={cy + r1*sA}
        x2={cx + rE*cA} y2={cy + rE*sA}
        stroke={COLORS.gold} strokeWidth={0.7} opacity={0.65}/>
      <circle
        cx={cx + rD*cA} cy={cy + rD*sA} r={2.5}
        fill={COLORS.gold} opacity={0.92}
        style={{ filter:'drop-shadow(0 0 4px rgba(201,150,63,0.85))' }}/>
    </g>
  );
}

// ─── SriYantraMandala — Root Component ───────────────────────────────────────
// The living instrument. All nine rings present simultaneously.
// The Ring 9 Bindu is an HTML overlay for reliable scale animation.

function SriYantraMandala({ size = 344, todayIndex = 4 }) {
  const cx = size / 2, cy = size / 2;

  return (
    <div style={{ position:'relative', width:size, height:size, flexShrink:0 }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}
        style={{ overflow:'visible', display:'block' }}>
        <defs>
          <radialGradient id="sy-ambient" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stopColor={COLORS.gold} stopOpacity="0.05"/>
            <stop offset="100%" stopColor={COLORS.gold} stopOpacity="0"/>
          </radialGradient>
        </defs>

        {/* Ambient center warmth — the whole mandala breathing together */}
        <circle cx={cx} cy={cy} r={cx * 0.9} fill="url(#sy-ambient)"/>

        {/* Ring 1 — Bhupura, ancient foundation — no animation */}
        <Bhupura cx={cx} cy={cy}/>

        {/* Faint outer lotus boundary */}
        <circle cx={cx} cy={cy} r={SY.R2_OUTER + 1} fill="none"
          stroke="rgba(201,150,63,0.07)" strokeWidth="0.4"/>

        {/* Ring 2 — Home Lotus — wave breathing, cluster colors */}
        <HomeLotus cx={cx} cy={cy} todayIndex={todayIndex}/>

        {/* Boundary between the two lotus rings */}
        <circle cx={cx} cy={cy} r={SY.R3_INNER} fill="none"
          stroke="rgba(201,150,63,0.10)" strokeWidth="0.4"/>

        {/* Ring 3 — Unlocked Lotus — amber, wider petals, slower breath */}
        <UnlockedLotus cx={cx} cy={cy}/>

        {/* Boundary between lotus zone and triangle zone */}
        <circle cx={cx} cy={cy} r={SY.R3_INNER - 4} fill="none"
          stroke="rgba(201,150,63,0.07)" strokeWidth="0.35"/>

        {/* Rings 4-7 — Locked triangles — the deep game, waiting */}
        <TriangleZone cx={cx} cy={cy}/>

        {/* Ring 8 — Mula Trikona — deep ghost */}
        <MulaTrikona cx={cx} cy={cy}/>

        {/* TODAY ray + dot */}
        <TodayIndicator cx={cx} cy={cy} todayIndex={todayIndex}/>
      </svg>

      {/* Ring 9 — Bindu — always calling, never absent — HTML for scale animation */}
      <div className="mandala-bindu-breathe" style={{
        width:  SY.BINDU_SIZE,
        height: SY.BINDU_SIZE,
        background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.65) 52%, transparent 100%)`,
      }}>
        <div style={{
          position:'absolute', top:'50%', left:'50%',
          transform:'translate(-50%,-50%)',
          width: Math.round(SY.BINDU_SIZE * 0.38),
          height: Math.round(SY.BINDU_SIZE * 0.38),
          borderRadius:'50%',
          background: COLORS.cream,
          opacity: 0.95,
          boxShadow:`0 0 9px rgba(242,232,217,0.55)`,
        }}/>
      </div>
    </div>
  );
}

Object.assign(window, { SriYantraMandala });
