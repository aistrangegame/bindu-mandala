// ─── Bindu Mandala — Legend Explorations ─────────────────────────────────────
// The yantra becomes a held image. Navigation moves to a Legend — nine
// thresholds, ordered as a descent inward (Ring 1 ground → Ring 9 Bindu).
// Status is encoded as LIGHT, never as locks. Four placements explored.

const { StatusBar, TabBar, HomeIndicator, DustMotes, SriYantraMandala } = window;

// ─── Roman numerals — carved, temple-like ring index ─────────────────────────
const ROMAN = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'];

// ─── Status tiers — luminosity, not locks ────────────────────────────────────
// home → unlocked → ancient(ground) → locked(ahead) → deep_ghost(veiled)
const TIER = {
  home:       { tag: 'You are here', glyph: 0.95, text: 0.95, sub: 0.60, accent: '#C9963F', rule: 'solid',  open: true,  veil: 0.00 },
  unlocked:   { tag: 'Open',         glyph: 0.82, text: 0.84, sub: 0.50, accent: '#C9963F', rule: 'solid',  open: true,  veil: 0.00 },
  ancient:    { tag: 'Ground',       glyph: 0.62, text: 0.66, sub: 0.40, accent: '#CF9443', rule: 'solid',  open: true,  veil: 0.00 },
  locked:     { tag: 'Ahead',        glyph: 0.30, text: 0.34, sub: 0.22, accent: 'rgba(242,232,217,0.40)', rule: 'dashed', open: false, veil: 0.55 },
  deep_ghost: { tag: 'Veiled',       glyph: 0.16, text: 0.20, sub: 0.13, accent: 'rgba(242,232,217,0.28)', rule: 'dashed', open: false, veil: 0.72 },
};

// ─── Ring glyphs — minimal sacred geometry, one per avarana ──────────────────
// Only primitives: squares, triangles, radial petal-ticks, dots.

function radialTicks(n, inner, outer, cx, cy) {
  const out = [];
  for (let i = 0; i < n; i++) {
    const a = (i * (360 / n) - 90) * Math.PI / 180;
    out.push([
      cx + inner * Math.cos(a), cy + inner * Math.sin(a),
      cx + outer * Math.cos(a), cy + outer * Math.sin(a),
    ]);
  }
  return out;
}

function RingGlyph({ ring, size = 34, color = '#C9963F', opacity = 1 }) {
  const c = size / 2;
  const sw = Math.max(0.7, size / 34);
  const st = { stroke: color, strokeWidth: sw, fill: 'none', strokeLinejoin: 'round' };
  let body = null;

  if (ring === 1) {
    // Bhupura — the world square
    const r = size * 0.36;
    body = <rect x={c - r} y={c - r} width={r * 2} height={r * 2} {...st} />;
  } else if (ring === 2 || ring === 3) {
    // Lotus rings — radial petal ticks
    const n = ring === 2 ? 16 : 8;
    body = (
      <g>
        <circle cx={c} cy={c} r={size * 0.16} {...st} />
        {radialTicks(n, size * 0.22, size * 0.42, c, c).map(([x1, y1, x2, y2], i) => (
          <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} stroke={color} strokeWidth={sw} strokeLinecap="round" />
        ))}
      </g>
    );
  } else if (ring === 4) {
    // Interlocked star — two triangles
    const r = size * 0.40, h = r * Math.sqrt(3) / 2, hf = r / 2;
    body = (
      <g>
        <path d={`M ${c},${c - r} L ${c + h},${c + hf} L ${c - h},${c + hf} Z`} {...st} />
        <path d={`M ${c},${c + r} L ${c + h},${c - hf} L ${c - h},${c - hf} Z`} {...st} />
      </g>
    );
  } else if (ring === 5) {
    // Ten outer — upward triangle cluster
    const r = size * 0.40, h = r * Math.sqrt(3) / 2, hf = r / 2;
    body = (
      <g>
        <path d={`M ${c},${c - r} L ${c + h},${c + hf} L ${c - h},${c + hf} Z`} {...st} />
        <path d={`M ${c},${c - r * 0.5} L ${c + h * 0.5},${c + hf * 0.5} L ${c - h * 0.5},${c + hf * 0.5} Z`} {...st} opacity={0.6} />
      </g>
    );
  } else if (ring === 6) {
    // Ten inner — downward triangle cluster
    const r = size * 0.40, h = r * Math.sqrt(3) / 2, hf = r / 2;
    body = (
      <g>
        <path d={`M ${c},${c + r} L ${c + h},${c - hf} L ${c - h},${c - hf} Z`} {...st} />
        <path d={`M ${c},${c + r * 0.5} L ${c + h * 0.5},${c - hf * 0.5} L ${c - h * 0.5},${c - hf * 0.5} Z`} {...st} opacity={0.6} />
      </g>
    );
  } else if (ring === 7) {
    // Vak ring — circle of speech-dots
    body = (
      <g>
        <circle cx={c} cy={c} r={size * 0.34} {...st} />
        {radialTicks(12, size * 0.34, size * 0.34, c, c).map(([x1, y1], i) => (
          <circle key={i} cx={x1} cy={y1} r={sw * 0.9} fill={color} />
        ))}
      </g>
    );
  } else if (ring === 8) {
    // Mula Trikona — root triangle
    const r = size * 0.40, h = r * Math.sqrt(3) / 2, hf = r / 2;
    body = <path d={`M ${c},${c + r} L ${c + h},${c - hf} L ${c - h},${c - hf} Z`} {...st} />;
  } else if (ring === 9) {
    // Bindu — the point
    body = (
      <g>
        <circle cx={c} cy={c} r={size * 0.40} stroke={color} strokeWidth={sw * 0.7} fill="none" opacity={0.5} />
        <circle cx={c} cy={c} r={size * 0.16} fill={color} />
      </g>
    );
  }

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} style={{ opacity, overflow: 'visible', flexShrink: 0 }}>
      {body}
    </svg>
  );
}

// ─── A quiet, scaled yantra — the held image ─────────────────────────────────
// Scales the full 344 instrument down without breaking its centering.

function HeldYantra({ scale = 0.62, dim = 1 }) {
  const box = Math.round(344 * scale);
  return (
    <div style={{ width: box, height: box, position: 'relative', flexShrink: 0, opacity: dim }}>
      <div style={{ position: 'absolute', top: 0, left: 0, transform: `scale(${scale})`, transformOrigin: 'top left' }}>
        <SriYantraMandala size={344} todayIndex={TODAY_INDEX} />
      </div>
    </div>
  );
}

// ─── Shared screen frame ─────────────────────────────────────────────────────
function Phone({ children, bg = COLORS.ground }) {
  return (
    <div style={{ width: 390, height: 844, background: bg, position: 'relative',
      overflow: 'hidden', display: 'flex', flexDirection: 'column',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif' }}>
      {children}
    </div>
  );
}

const eyebrow = {
  textAlign: 'center', fontSize: 10, color: '#C9963F', letterSpacing: '0.17em',
  textTransform: 'uppercase', opacity: 0.82,
};

// Ordered descent: outer ground (1) → inner Bindu (9)
const DESCENT = () => AVARANAS.slice().sort((a, b) => a.ring - b.ring);

// ═══════════════════════════════════════════════════════════════════════════
//  VARIATION 1 — THE DESCENT
//  Yantra as crest. Below: nine thresholds as a single column you read
//  downward — the same inward movement as the geometry. A scroll, not a menu.
// ═══════════════════════════════════════════════════════════════════════════

function LegendDescent() {
  const rings = DESCENT();
  return (
    <Phone>
      <div style={{ position: 'absolute', inset: 0, background:
        'radial-gradient(ellipse 60% 30% at 50% 14%, rgba(201,150,63,0.06) 0%, transparent 70%)',
        pointerEvents: 'none' }} />
      <DustMotes count={5} />
      <StatusBar />

      <div style={{ ...eyebrow, paddingTop: 4 }}>The Nine Avaraṇas</div>

      {/* Yantra crest */}
      <div style={{ display: 'flex', justifyContent: 'center', padding: '6px 0 2px', zIndex: 2 }}>
        <HeldYantra scale={0.40} />
      </div>
      <div style={{ textAlign: 'center', fontFamily: "'Cormorant Garamond', serif",
        fontSize: 13, fontStyle: 'italic', color: 'rgba(242,232,217,0.42)',
        letterSpacing: '0.04em', marginBottom: 4, zIndex: 2 }}>
        Descend, one ring at a time
      </div>

      {/* The descending column */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '4px 20px 8px', zIndex: 2 }}>
        {rings.map((av) => {
          const t = TIER[av.status];
          return (
            <div key={av.ring} style={{
              display: 'flex', alignItems: 'center', gap: 15,
              padding: '13px 14px', marginBottom: 2,
              borderRadius: 12,
              background: av.status === 'home' ? 'rgba(201,150,63,0.06)' : 'transparent',
              border: av.status === 'home' ? '0.5px solid rgba(201,150,63,0.22)' : '0.5px solid transparent',
              borderBottom: av.status === 'home' ? '0.5px solid rgba(201,150,63,0.22)'
                : (t.rule === 'dashed' ? '0.5px dashed rgba(242,232,217,0.10)' : '0.5px solid rgba(201,150,63,0.10)'),
              cursor: t.open ? 'pointer' : 'default',
            }}>
              <RingGlyph ring={av.ring} size={34} color={t.accent} opacity={t.glyph} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 19,
                  fontWeight: 300, color: COLORS.cream, opacity: t.text, letterSpacing: '0.03em',
                  lineHeight: 1.1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                  {av.name}
                </div>
                <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 12.5,
                  fontStyle: 'italic', color: COLORS.cream, opacity: t.sub, letterSpacing: '0.02em',
                  whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                  {av.subtitle}
                </div>
                <div style={{ fontSize: 9, color: COLORS.cream, opacity: t.sub * 0.75,
                  letterSpacing: '0.10em', textTransform: 'uppercase', marginTop: 3 }}>
                  {av.form} · {av.count} {av.count === 1 ? 'point' : 'forces'}
                </div>
              </div>
              <div style={{ textAlign: 'right', flexShrink: 0 }}>
                <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 17,
                  color: t.accent, opacity: t.glyph, letterSpacing: '0.08em', lineHeight: 1 }}>
                  {ROMAN[av.ring]}
                </div>
                <div style={{ fontSize: 7.5, color: t.accent, opacity: t.open ? 0.7 : 0.5,
                  letterSpacing: '0.16em', textTransform: 'uppercase', marginTop: 4 }}>
                  {t.tag}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      <TabBar active="mandala" />
      <HomeIndicator />
    </Phone>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
//  VARIATION 2 — THE VEIL
//  Yantra is the full hero. A sheet of thresholds is drawn up from below
//  like lifting a veil. Shown mid-rise: the gesture is the point.
// ═══════════════════════════════════════════════════════════════════════════

function LegendVeil() {
  const rings = DESCENT();
  return (
    <Phone bg="#070205">
      <DustMotes count={5} />
      <StatusBar />
      <div style={{ ...eyebrow, paddingTop: 2 }}>2nd Avaraṇa · Sarvāśā-Paripūraka</div>

      {/* Yantra hero, dimmed as the veil rises over it */}
      <div style={{ position: 'absolute', top: 78, left: 0, right: 0, display: 'flex',
        justifyContent: 'center', zIndex: 1 }}>
        <HeldYantra scale={0.74} dim={0.55} />
      </div>

      {/* The rising veil */}
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 540,
        background: 'linear-gradient(to top, rgba(8,2,6,0.99) 0%, rgba(10,3,7,0.97) 78%, rgba(12,4,8,0.80) 100%)',
        borderTop: '0.5px solid rgba(201,150,63,0.20)',
        borderRadius: '20px 20px 0 0',
        boxShadow: '0 -18px 50px rgba(0,0,0,0.6), 0 -1px 24px rgba(201,150,63,0.10)',
        display: 'flex', flexDirection: 'column', padding: '12px 22px 0', zIndex: 3 }}>

        <div style={{ width: 38, height: 4, borderRadius: 3, background: 'rgba(242,232,217,0.28)',
          margin: '0 auto 14px' }} />
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 12 }}>
          <span style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 21, fontWeight: 300,
            color: COLORS.cream, letterSpacing: '0.04em' }}>Nine Thresholds</span>
          <span style={{ fontSize: 8.5, color: '#C9963F', opacity: 0.55, letterSpacing: '0.16em',
            textTransform: 'uppercase' }}>Draw up to descend</span>
        </div>

        <div style={{ flex: 1, overflowY: 'auto' }}>
          {rings.map((av, i) => {
            const t = TIER[av.status];
            return (
              <div key={av.ring} style={{
                display: 'flex', alignItems: 'center', gap: 14, padding: '11px 4px',
                borderBottom: i < rings.length - 1
                  ? (t.rule === 'dashed' ? '0.5px dashed rgba(242,232,217,0.09)' : '0.5px solid rgba(201,150,63,0.10)')
                  : 'none',
                cursor: t.open ? 'pointer' : 'default',
              }}>
                <RingGlyph ring={av.ring} size={30} color={t.accent} opacity={t.glyph} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 17,
                    fontWeight: 300, color: COLORS.cream, opacity: t.text, letterSpacing: '0.03em',
                    lineHeight: 1.15, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {av.name}
                  </div>
                  <div style={{ fontSize: 9, color: COLORS.cream, opacity: t.sub,
                    letterSpacing: '0.08em', textTransform: 'uppercase', marginTop: 2 }}>
                    {av.form}
                  </div>
                </div>
                {av.status === 'home'
                  ? <span style={{ fontSize: 8, color: '#C9963F', letterSpacing: '0.14em',
                      textTransform: 'uppercase', opacity: 0.85 }}>Here</span>
                  : <span style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 15,
                      color: t.accent, opacity: t.glyph, letterSpacing: '0.06em' }}>{ROMAN[av.ring]}</span>}
              </div>
            );
          })}
        </div>
      </div>

      <HomeIndicator light={true} />
    </Phone>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
//  VARIATION 3 — THE DOORWAYS
//  Each avarana is a literal portal — an arched chamber. Nine doorways in a
//  3×3 grid: open ones lit from within, ones ahead dark behind a veil.
// ═══════════════════════════════════════════════════════════════════════════

function Doorway({ av }) {
  const t = TIER[av.status];
  const lit = t.open;
  return (
    <div style={{
      position: 'relative', aspectRatio: '0.74',
      borderRadius: '40px 40px 8px 8px',
      background: lit
        ? `radial-gradient(ellipse 90% 70% at 50% 80%, rgba(201,150,63,0.14) 0%, rgba(26,12,16,0.6) 70%)`
        : 'rgba(10,4,8,0.7)',
      border: `0.5px ${t.rule} ${lit ? 'rgba(201,150,63,0.40)' : 'rgba(242,232,217,0.12)'}`,
      boxShadow: lit ? 'inset 0 -18px 30px rgba(201,150,63,0.10), 0 0 18px rgba(201,150,63,0.06)' : 'none',
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      padding: '14px 6px 9px', overflow: 'hidden',
      cursor: lit ? 'pointer' : 'default',
    }}>
      {/* veil scrim over locked doorways */}
      {!lit && <div style={{ position: 'absolute', inset: 0, background: `rgba(6,1,4,${t.veil})`,
        backdropFilter: 'blur(0.5px)' }} />}
      <div style={{ position: 'relative', zIndex: 1, display: 'flex', flexDirection: 'column',
        alignItems: 'center', flex: 1, justifyContent: 'center', gap: 8 }}>
        <RingGlyph ring={av.ring} size={30} color={t.accent} opacity={t.glyph} />
        <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 15, color: t.accent,
          opacity: t.glyph, letterSpacing: '0.06em', lineHeight: 1 }}>{ROMAN[av.ring]}</div>
      </div>
      <div style={{ position: 'relative', zIndex: 1, textAlign: 'center' }}>
        <div style={{ fontSize: 7.5, color: COLORS.cream, opacity: t.sub,
          letterSpacing: '0.10em', textTransform: 'uppercase', whiteSpace: 'nowrap' }}>
          {av.form}
        </div>
        <div style={{ fontSize: 6.5, color: t.accent, opacity: t.open ? 0.7 : 0.45,
          letterSpacing: '0.16em', textTransform: 'uppercase', marginTop: 3 }}>
          {t.tag}
        </div>
      </div>
    </div>
  );
}

function LegendDoorways() {
  const rings = DESCENT();
  return (
    <Phone>
      <div style={{ position: 'absolute', inset: 0, background:
        'radial-gradient(ellipse 60% 26% at 50% 12%, rgba(201,150,63,0.06) 0%, transparent 70%)',
        pointerEvents: 'none' }} />
      <DustMotes count={5} />
      <StatusBar />
      <div style={{ ...eyebrow, paddingTop: 4 }}>The Nine Chambers</div>

      <div style={{ display: 'flex', justifyContent: 'center', padding: '4px 0 0', zIndex: 2 }}>
        <HeldYantra scale={0.30} />
      </div>
      <div style={{ textAlign: 'center', fontFamily: "'Cormorant Garamond', serif",
        fontSize: 12.5, fontStyle: 'italic', color: 'rgba(242,232,217,0.40)',
        letterSpacing: '0.04em', margin: '0 0 8px', zIndex: 2 }}>
        Lit doorways open · veiled ones wait
      </div>

      <div style={{ flex: 1, overflowY: 'auto', padding: '0 18px 10px', zIndex: 2 }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
          {rings.map((av) => <Doorway key={av.ring} av={av} />)}
        </div>
      </div>

      <TabBar active="mandala" />
      <HomeIndicator />
    </Phone>
  );
}

// ═══════════════════════════════════════════════════════════════════════════
//  VARIATION 4 — THE SPINE
//  The descent made literal: a vertical thread (the suṣumnā) with nine nodes.
//  Bright above where you've reached, faint below where you haven't. Tap a
//  node to enter. The thread shows exactly how deep you are.
// ═══════════════════════════════════════════════════════════════════════════

function LegendSpine() {
  const rings = DESCENT();
  return (
    <Phone>
      <div style={{ position: 'absolute', inset: 0, background:
        'radial-gradient(ellipse 50% 60% at 22% 50%, rgba(201,150,63,0.05) 0%, transparent 68%)',
        pointerEvents: 'none' }} />
      <DustMotes count={4} />
      <StatusBar />
      <div style={{ ...eyebrow, paddingTop: 4 }}>The Descent</div>

      {/* faint yantra echo, upper-right */}
      <div style={{ position: 'absolute', top: 52, right: -36, zIndex: 1 }}>
        <HeldYantra scale={0.46} dim={0.28} />
      </div>

      <div style={{ flex: 1, position: 'relative', padding: '10px 20px 6px', zIndex: 2 }}>
        {/* the thread */}
        <div style={{ position: 'absolute', left: 38, top: 18, bottom: 14, width: 1,
          background: 'linear-gradient(to bottom, rgba(201,150,63,0.55) 0%, rgba(201,150,63,0.45) 30%, rgba(242,232,217,0.10) 48%, rgba(242,232,217,0.04) 100%)' }} />

        {rings.map((av) => {
          const t = TIER[av.status];
          const node = av.status === 'home' ? 11 : t.open ? 8 : 5;
          return (
            <div key={av.ring} style={{ display: 'flex', alignItems: 'center', gap: 18,
              height: `${100 / 9}%`, position: 'relative', cursor: t.open ? 'pointer' : 'default' }}>
              {/* node */}
              <div style={{ width: 18, display: 'flex', justifyContent: 'center', flexShrink: 0 }}>
                <div style={{ width: node, height: node, borderRadius: '50%',
                  background: av.status === 'deep_ghost' ? 'transparent' : t.accent,
                  border: av.status === 'deep_ghost' ? `1px solid ${t.accent}` : 'none',
                  opacity: t.open ? 0.95 : 0.5,
                  boxShadow: av.status === 'home' ? '0 0 10px 2px rgba(201,150,63,0.7)' : 'none',
                  animation: av.status === 'home' ? 'ringIndicatorPulse 3s ease-in-out infinite' : 'none' }} />
              </div>
              <RingGlyph ring={av.ring} size={26} color={t.accent} opacity={t.glyph * 0.9} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 16.5,
                  fontWeight: 300, color: COLORS.cream, opacity: t.text, letterSpacing: '0.03em',
                  lineHeight: 1.1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                  {av.name}
                </div>
                <div style={{ fontSize: 8.5, color: COLORS.cream, opacity: t.sub,
                  letterSpacing: '0.09em', textTransform: 'uppercase', marginTop: 1 }}>
                  {av.form} · {ROMAN[av.ring]}
                </div>
              </div>
              <span style={{ fontSize: 7.5, color: t.accent, opacity: t.open ? 0.7 : 0.5,
                letterSpacing: '0.14em', textTransform: 'uppercase', flexShrink: 0 }}>{t.tag}</span>
            </div>
          );
        })}
      </div>

      <TabBar active="mandala" />
      <HomeIndicator />
    </Phone>
  );
}

Object.assign(window, {
  RingGlyph, HeldYantra,
  LegendDescent, LegendVeil, LegendDoorways, LegendSpine,
});
