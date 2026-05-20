// ─── Bindu Mandala — Screen Components ─────────────────────────────────────
// All data accessed from window globals set by shakti-data.js

// ─── Shared Primitives ───────────────────────────────────────────────────────

function HomeIndicator({ light = false }) {
  return (
    <div style={{
      position: 'absolute',
      bottom: 8, left: '50%',
      transform: 'translateX(-50%)',
      width: 134, height: 5,
      borderRadius: 3,
      background: light ? 'rgba(242,232,217,0.45)' : 'rgba(242,232,217,0.35)',
      pointerEvents: 'none',
      zIndex: 10,
    }}/>
  );
}

function StatusBar() {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '14px 22px 6px', height: 44,
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
      fontSize: 13, fontWeight: 600, color: 'rgba(242,232,217,0.7)',
      letterSpacing: '0.03em', flexShrink: 0,
    }}>
      <span>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <svg width="17" height="12" viewBox="0 0 17 12" fill="none">
          <rect x="0" y="4" width="3" height="8" rx="0.8" fill="rgba(242,232,217,0.5)"/>
          <rect x="4.5" y="2.5" width="3" height="9.5" rx="0.8" fill="rgba(242,232,217,0.65)"/>
          <rect x="9" y="0.5" width="3" height="11.5" rx="0.8" fill="rgba(242,232,217,0.8)"/>
          <rect x="13.5" y="0" width="3" height="12" rx="0.8" fill="rgba(242,232,217,0.9)"/>
        </svg>
        <svg width="16" height="12" viewBox="0 0 16 12">
          <path d="M8 2.5 Q8 2.5 14 6.5 Q8 10.5 8 10.5 Q8 10.5 2 6.5 Q8 2.5 8 2.5Z" fill="none" stroke="rgba(242,232,217,0.7)" strokeWidth="1.2"/>
          <circle cx="8" cy="6.5" r="1.5" fill="rgba(242,232,217,0.7)"/>
        </svg>
        <svg width="25" height="12" viewBox="0 0 25 12">
          <rect x="0.5" y="0.5" width="21" height="11" rx="3" stroke="rgba(242,232,217,0.5)" strokeWidth="1" fill="none"/>
          <rect x="22" y="3.5" width="2.5" height="5" rx="1" fill="rgba(242,232,217,0.4)"/>
          <rect x="2" y="2" width="16" height="8" rx="2" fill="rgba(242,232,217,0.8)"/>
        </svg>
      </div>
    </div>
  );
}

function TabBar({ active }) {
  const tabs = [
    { id: 'today', label: 'Today', icon: (
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
        <path d="M12 3 Q18 7 18 13 Q18 18 12 21 Q6 18 6 13 Q6 7 12 3Z" stroke="currentColor" strokeWidth="1.3" fill="none"/>
        <circle cx="12" cy="13" r="2.5" fill="currentColor" opacity="0.7"/>
      </svg>
    )},
    { id: 'mandala', label: 'Mandala', icon: (
      <svg width="24" height="24" viewBox="0 0 24 24">
        {[0,45,90,135,180,225,270,315].map((a,i) => (
          <g key={i} transform={`translate(12,12) rotate(${a})`}>
            <path d="M0,-2.5 C2,-5 2,-9.5 0,-11 C-2,-9.5 -2,-5 0,-2.5Z" fill="currentColor" opacity="0.7"/>
          </g>
        ))}
        <circle cx="12" cy="12" r="2" fill="currentColor"/>
      </svg>
    )},
    { id: 'well', label: 'The Well', icon: (
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
        <circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="1.3"/>
        <circle cx="12" cy="12" r="5.5" stroke="currentColor" strokeWidth="1" opacity="0.6"/>
        <circle cx="12" cy="12" r="2" fill="currentColor" opacity="0.5"/>
      </svg>
    )},
  ];
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-around', alignItems: 'center',
      padding: '10px 0 20px',
      background: 'linear-gradient(to top, rgba(13,5,8,0.98) 0%, rgba(13,5,8,0.85) 100%)',
      borderTop: '0.5px solid rgba(201,150,63,0.15)',
      flexShrink: 0,
    }}>
      {tabs.map(tab => {
        const isActive = tab.id === active;
        return (
          <div key={tab.id} style={{
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
            color: isActive ? COLORS.gold : 'rgba(242,232,217,0.32)',
            fontSize: 10, fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
            letterSpacing: '0.06em', textTransform: 'uppercase',
            cursor: 'pointer', padding: '4px 20px',
          }}>
            {tab.icon}
            <span>{tab.label}</span>
          </div>
        );
      })}
    </div>
  );
}

function MoonPhase() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 9, justifyContent: 'center' }}>
      <svg width="22" height="22" viewBox="0 0 22 22">
        <defs>
          <mask id="moonMask">
            <rect width="22" height="22" fill="white"/>
            <circle cx="14.5" cy="11" r="8.5" fill="black"/>
          </mask>
        </defs>
        <circle cx="11" cy="11" r="8.5" fill={COLORS.gold} opacity="0.85" mask="url(#moonMask)"/>
        <circle cx="11" cy="11" r="8.5" fill="none" stroke={COLORS.gold} strokeWidth="0.5" opacity="0.4"/>
      </svg>
      <span style={{
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 11, color: 'rgba(242,232,217,0.45)',
        letterSpacing: '0.12em', textTransform: 'uppercase',
      }}>Waning Crescent · 23rd Night</span>
    </div>
  );
}

function ClusterDot({ shakti }) {
  const info = CLUSTER_INFO[shakti.cluster];
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 7, justifyContent: 'center' }}>
      <div style={{ width: 7, height: 7, borderRadius: '50%', background: info.color, boxShadow: `0 0 8px ${info.color}` }}/>
      <span style={{
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 10.5, color: info.color,
        letterSpacing: '0.18em', textTransform: 'uppercase',
      }}>{info.label}</span>
    </div>
  );
}

// ─── Dust Motes — drifting gold particles (temple atmosphere) ────────────────

function DustMotes({ count = 8 }) {
  // Stable pseudo-random positions/timings per mote
  const motes = Array.from({ length: count }, (_, i) => {
    const seed = (i * 73 + 17) % 100;
    return {
      id: i,
      left: 8 + ((seed * 7) % 84),       // horizontal start %
      drift: -10 + ((seed * 13) % 20),   // horizontal drift px
      size: 1.4 + ((seed * 3) % 22) / 10,
      duration: 16 + ((seed * 5) % 14),
      delay: (seed % 80) / 8,
      opacity: 0.18 + ((seed * 11) % 28) / 100,
    };
  });
  return (
    <div style={{ position:'absolute', inset:0, pointerEvents:'none', overflow:'hidden', zIndex: 1 }}>
      {motes.map(m => (
        <div key={m.id} className="dust-mote" style={{
          position: 'absolute',
          left: `${m.left}%`,
          bottom: '-12px',
          width: m.size, height: m.size,
          borderRadius: '50%',
          background: COLORS.gold,
          opacity: m.opacity,
          boxShadow: `0 0 ${m.size * 4}px rgba(201,150,63,0.5)`,
          ['--drift']: `${m.drift}px`,
          animation: `moteRise ${m.duration}s linear ${m.delay}s infinite`,
        }}/>
      ))}
    </div>
  );
}

// ─── Body Outline SVG ─────────────────────────────────────────────────────────

function BodyOutlineSVG({ clusterColor, size = 120 }) {
  const s = size / 120;
  const glowColor = clusterColor;
  return (
    <svg width={size} height={size * 1.85} viewBox="0 0 120 222" style={{ overflow: 'visible' }}>
      <defs>
        <filter id="bodyGlow">
          <feGaussianBlur stdDeviation="5" result="blur"/>
          <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
        <radialGradient id="skinGlow" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor={glowColor} stopOpacity="0.18"/>
          <stop offset="100%" stopColor={glowColor} stopOpacity="0"/>
        </radialGradient>
      </defs>
      {/* Ambient glow — skin surface */}
      <ellipse cx="60" cy="111" rx="48" ry="78" fill="url(#skinGlow)" filter="url(#bodyGlow)"/>
      {/* Head */}
      <ellipse cx="60" cy="23" rx="18" ry="21" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.45"/>
      {/* Neck */}
      <path d="M52,42 L52,52 Q60,56 68,52 L68,42" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.35"/>
      {/* Shoulders + torso */}
      <path d="M52,52 Q32,56 26,68 L24,130 Q24,142 34,145 L46,147 Q60,149 74,147 L86,145 Q96,142 96,130 L94,68 Q88,56 68,52" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.4"/>
      {/* Left arm */}
      <path d="M26,70 Q14,90 13,120 Q12,132 16,136 Q18,138 19,135 L20,118 Q19,106 23,90 L26,70" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.35"/>
      {/* Right arm */}
      <path d="M94,70 Q106,90 107,120 Q108,132 104,136 Q102,138 101,135 L100,118 Q101,106 97,90 L94,70" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.35"/>
      {/* Left leg */}
      <path d="M46,147 Q42,165 40,192 Q39,204 40,210 Q42,216 46,215 Q50,214 51,208 L53,190 L55,155" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.38"/>
      {/* Right leg */}
      <path d="M74,147 Q78,165 80,192 Q81,204 80,210 Q78,216 74,215 Q70,214 69,208 L67,190 L65,155" fill="none" stroke={glowColor} strokeWidth="1.2" opacity="0.38"/>
      {/* Skin surface shimmer lines */}
      <path d="M35,85 Q60,90 85,85" stroke={glowColor} strokeWidth="0.5" opacity="0.2" strokeDasharray="3 8" fill="none"/>
      <path d="M30,105 Q60,112 90,105" stroke={glowColor} strokeWidth="0.5" opacity="0.15" strokeDasharray="3 8" fill="none"/>
    </svg>
  );
}

// ─── Lotus Mandala SVG ────────────────────────────────────────────────────────

function LotusMandalaSVG({ size = 320, activeIndex = 4, animated = false, onPetalClick }) {
  const cx = size / 2, cy = size / 2;
  const outerR = size * 0.435;
  const innerR = size * 0.117;
  const hw = size * 0.087;
  const labelR = (innerR + outerR) * 0.5;

  const filterId = `petalGlow-${size}`;
  const bindufId = `binduGlow-${size}`;

  const petalPath = `M 0,${-innerR.toFixed(1)} C ${hw.toFixed(1)},${(-innerR*1.85).toFixed(1)} ${(hw*0.95).toFixed(1)},${(-outerR*0.85).toFixed(1)} 0,${-outerR.toFixed(1)} C ${(-hw*0.95).toFixed(1)},${(-outerR*0.85).toFixed(1)} ${(-hw).toFixed(1)},${(-innerR*1.85).toFixed(1)} 0,${-innerR.toFixed(1)} Z`;

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} style={{ overflow: 'visible' }}>
      <defs>
        <filter id={filterId} x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="6" result="blur"/>
          <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
        <filter id={bindufId} x="-200%" y="-200%" width="500%" height="500%">
          <feGaussianBlur stdDeviation="5" result="blur"/>
          <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
        <filter id="ghostGlow" x="-100%" y="-100%" width="300%" height="300%">
          <feGaussianBlur stdDeviation="2" result="blur"/>
          <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
        </filter>
      </defs>

      {/* Outer ghost geometry — other avaraṇas */}
      <g transform={`translate(${cx},${cy})`} opacity="1">
        {/* Outer concentric circles */}
        {[1.08, 1.14, 1.2].map((r, i) => (
          <circle key={i} r={outerR * r} fill="none"
            stroke={`rgba(201,150,63,${0.07 - i * 0.015})`} strokeWidth="0.6"
            strokeDasharray={i === 2 ? "4 7" : undefined}/>
        ))}
        {/* Outer 8-petal ghost ring */}
        {[0,45,90,135,180,225,270,315].map((a, i) => (
          <g key={i} transform={`rotate(${a + 22.5})`}>
            <path
              d={`M 0,${-(outerR * 1.1).toFixed(1)} C ${(hw*0.6).toFixed(1)},${-(outerR*1.18).toFixed(1)} ${(hw*0.5).toFixed(1)},${-(outerR*1.28).toFixed(1)} 0,${-(outerR*1.32).toFixed(1)} C ${(-hw*0.5).toFixed(1)},${-(outerR*1.28).toFixed(1)} ${(-hw*0.6).toFixed(1)},${-(outerR*1.18).toFixed(1)} 0,${-(outerR*1.1).toFixed(1)} Z`}
              fill={`rgba(201,150,63,0.04)`}
              stroke={`rgba(201,150,63,0.08)`} strokeWidth="0.5"
            />
          </g>
        ))}
        {/* Inner geometry ring */}
        <circle r={innerR * 0.8} fill="none" stroke="rgba(201,150,63,0.2)" strokeWidth="0.5"/>
        <circle r={innerR * 1.4} fill="none" stroke="rgba(201,150,63,0.1)" strokeWidth="0.5"/>
      </g>

      {/* 16 Petals */}
      {SHAKTIS.map((shakti, i) => {
        const angle = i * 22.5;
        const clusterColor = CLUSTER_INFO[shakti.cluster].color;
        const opacity = STATUS_OPACITY[shakti.status];
        const isToday = i === activeIndex;
        const isEmbodied = shakti.status === 'embodied';

        const labelAngleRad = (angle - 90) * Math.PI / 180;
        const lx = cx + labelR * Math.cos(labelAngleRad);
        const ly = cy + labelR * Math.sin(labelAngleRad);

        return (
          <g key={i} style={{ cursor: onPetalClick ? 'pointer' : 'default' }}
             onClick={() => onPetalClick && onPetalClick(i)}>
            <g transform={`translate(${cx},${cy}) rotate(${angle})`}>
              <path
                d={petalPath}
                fill={clusterColor}
                opacity={opacity}
                filter={isEmbodied ? `url(#${filterId})` : undefined}
                className={isToday && animated ? 'petal-breathe' : undefined}
                style={isToday && animated ? { transformOrigin: `${cx}px ${cy}px` } : undefined}
              />
            </g>
            {/* Petal label — counter-rotated to stay horizontal */}
            <text
              x={lx} y={ly}
              textAnchor="middle" dominantBaseline="middle"
              fontSize={size * 0.021}
              fontFamily="'Cormorant Garamond', serif"
              fill={opacity > 0.5 ? 'rgba(242,232,217,0.82)' : 'rgba(242,232,217,0.38)'}
              style={{ pointerEvents: 'none', userSelect: 'none' }}
            >
              {shakti.short}
            </text>
          </g>
        );
      })}

      {/* Bindu — center point */}
      <g transform={`translate(${cx},${cy})`}>
        <circle r={size * 0.028} fill={COLORS.accentRed} filter={`url(#${bindufId})`} opacity="0.95"/>
        <circle r={size * 0.012} fill={COLORS.cream} opacity="0.9"/>
      </g>

      {/* TODAY indicator — thin ray + dot + label outside today's petal */}
      {(() => {
        const a = (activeIndex * 22.5 - 90) * Math.PI / 180;
        const r1 = outerR * 1.06;
        const r2 = outerR * 1.21;
        const r3 = outerR * 1.34;
        const cosA = Math.cos(a), sinA = Math.sin(a);
        // anchor based on angle — text reads outward
        const anchor = Math.abs(cosA) < 0.3 ? 'middle' : (cosA > 0 ? 'start' : 'end');
        const padX = anchor === 'start' ? 6 : (anchor === 'end' ? -6 : 0);
        const padY = anchor === 'middle' ? (sinA > 0 ? 8 : -8) : 0;
        return (
          <g style={{ pointerEvents: 'none' }}>
            <line
              x1={cx + r1 * cosA} y1={cy + r1 * sinA}
              x2={cx + r2 * cosA} y2={cy + r2 * sinA}
              stroke={COLORS.gold} strokeWidth="0.6" opacity="0.55"
            />
            <circle
              cx={cx + r2 * cosA} cy={cy + r2 * sinA}
              r={size * 0.0075} fill={COLORS.gold} opacity="0.85"
            />
            <text
              x={cx + r3 * cosA + padX} y={cy + r3 * sinA + padY}
              textAnchor={anchor}
              dominantBaseline="middle"
              fontSize={size * 0.027}
              fontFamily="-apple-system, BlinkMacSystemFont, sans-serif"
              fill={COLORS.gold} opacity="0.7"
              style={{ letterSpacing: '0.28em' }}
            >TODAY</text>
          </g>
        );
      })()}
    </svg>
  );
}

// ─── TODAY SCREEN V1 — with Body Outline ─────────────────────────────────────

function TodayScreenV1() {
  const s = TODAY_SHAKTI;
  const clusterColor = CLUSTER_INFO[s.cluster].color;
  const clusterLabel = CLUSTER_INFO[s.cluster].label;

  return (
    <div style={{
      width: 390, height: 844, background: COLORS.ground,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
      position: 'relative',
    }}>
      {/* Background radial warmth */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 60% 55% at 50% 38%, rgba(139,26,42,0.18) 0%, transparent 70%)`,
        pointerEvents: 'none',
      }}/>

      <DustMotes count={9}/>

      <StatusBar/>

      {/* Moon */}
      <div style={{ padding: '8px 0 12px', position: 'relative', zIndex: 2 }}>
        <MoonPhase/>
      </div>

      {/* Main content */}
      <div style={{
        flex: 1, display: 'flex', flexDirection: 'column',
        alignItems: 'center', padding: '0 32px',
        gap: 0, justifyContent: 'center',
        position: 'relative', zIndex: 2,
      }}>
        {/* Cluster */}
        <div style={{ marginBottom: 16 }}>
          <ClusterDot shakti={s}/>
        </div>

        {/* Sanskrit name */}
        <div className="today-name-anim" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 44, fontWeight: 300,
          color: COLORS.cream,
          letterSpacing: '0.08em',
          textAlign: 'center',
          lineHeight: 1.1,
          marginBottom: 10,
        }}>{s.name}</div>

        {/* Phonetic */}
        <div style={{
          fontSize: 12, color: 'rgba(242,232,217,0.45)',
          letterSpacing: '0.2em', textTransform: 'uppercase',
          marginBottom: 18,
        }}>{s.phonetic}</div>

        {/* Quality */}
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontWeight: 400,
          color: COLORS.gold,
          letterSpacing: '0.04em',
          textAlign: 'center',
          marginBottom: 20,
        }}>{s.quality}</div>

        {/* Thin divider */}
        <div style={{ width: 48, height: 0.5, background: `rgba(201,150,63,0.4)`, marginBottom: 20 }}/>

        {/* Somatic prompt */}
        <div className="today-prompt-anim" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.78)',
          textAlign: 'center',
          lineHeight: 1.65,
          letterSpacing: '0.02em',
          marginBottom: 28,
        }}>"{s.somatic}"</div>

        {/* Body outline */}
        <div style={{ marginBottom: 12, opacity: 0.9 }}>
          <BodyOutlineSVG clusterColor={clusterColor} size={90}/>
        </div>

        {/* Body location label */}
        <div style={{
          fontSize: 10, color: `rgba(${hexToRgb(clusterColor)},0.65)`,
          letterSpacing: '0.18em', textTransform: 'uppercase',
          marginBottom: 24,
        }}>Skin Surface</div>

        {/* Bija */}
        <div style={{
          fontSize: 12, color: 'rgba(242,232,217,0.4)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
          marginBottom: 8,
        }}>Bīja  ·  {s.bija}</div>
      </div>

      {/* Button area */}
      <div style={{ padding: '0 24px 16px', flexShrink: 0 }}>
        <button style={{
          width: '100%', height: 56, borderRadius: 28,
          background: COLORS.accentRed,
          border: 'none',
          color: COLORS.cream,
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontWeight: 400, letterSpacing: '0.12em',
          cursor: 'pointer',
          boxShadow: `0 4px 32px rgba(139,26,42,0.45)`,
        }}>I feel her</button>
        <div style={{
          textAlign: 'center', marginTop: 12,
          fontSize: 11, color: 'rgba(242,232,217,0.3)',
          letterSpacing: '0.15em',
        }}>Today's Bīja — {s.bija}</div>
      </div>

      <TabBar active="today"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── TODAY SCREEN V2 — Bīja Texture Background ───────────────────────────────

function TodayScreenV2() {
  const s = TODAY_SHAKTI;
  const clusterColor = CLUSTER_INFO[s.cluster].color;

  return (
    <div style={{
      width: 390, height: 844, background: COLORS.ground,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
      position: 'relative',
    }}>
      {/* Large bija texture — background */}
      <div style={{
        position: 'absolute',
        top: '50%', left: '50%',
        transform: 'translate(-50%, -54%)',
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 280, fontWeight: 300,
        color: COLORS.gold,
        opacity: 0.07,
        userSelect: 'none', pointerEvents: 'none',
        lineHeight: 1, letterSpacing: '-0.05em',
        whiteSpace: 'nowrap',
      }}>{s.bija}</div>

      {/* Warm glow */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 55% 50% at 50% 42%, rgba(139,26,42,0.2) 0%, transparent 70%)`,
        pointerEvents: 'none',
      }}/>

      <DustMotes count={9}/>

      <StatusBar/>

      <div style={{ padding: '8px 0 12px', position: 'relative', zIndex: 2 }}>
        <MoonPhase/>
      </div>

      {/* Main content — more generous spacing without body outline */}
      <div style={{
        flex: 1, display: 'flex', flexDirection: 'column',
        alignItems: 'center', padding: '0 36px',
        justifyContent: 'center', gap: 0,
        position: 'relative', zIndex: 2,
      }}>
        <div style={{ marginBottom: 20 }}>
          <ClusterDot shakti={s}/>
        </div>

        <div className="today-name-anim" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 48, fontWeight: 300,
          color: COLORS.cream,
          letterSpacing: '0.07em',
          textAlign: 'center',
          lineHeight: 1.05,
          marginBottom: 12,
        }}>{s.name}</div>

        <div style={{
          fontSize: 12, color: 'rgba(242,232,217,0.42)',
          letterSpacing: '0.2em', textTransform: 'uppercase',
          marginBottom: 22,
        }}>{s.phonetic}</div>

        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontWeight: 400,
          color: COLORS.gold,
          letterSpacing: '0.04em',
          textAlign: 'center',
          marginBottom: 28,
        }}>{s.quality}</div>

        <div style={{ width: 48, height: 0.5, background: `rgba(201,150,63,0.35)`, marginBottom: 28 }}/>

        <div className="today-prompt-anim" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.75)',
          textAlign: 'center',
          lineHeight: 1.7,
          letterSpacing: '0.02em',
          marginBottom: 52,
        }}>"{s.somatic}"</div>

        {/* Bija shown as visual object here too */}
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 42, fontWeight: 300,
          color: COLORS.gold,
          opacity: 0.6,
          letterSpacing: '0.1em',
          marginBottom: 6,
        }}>{s.bija}</div>

        <div style={{
          fontSize: 10, color: 'rgba(242,232,217,0.3)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>Bīja</div>
      </div>

      <div style={{ padding: '0 24px 16px', flexShrink: 0 }}>
        <button style={{
          width: '100%', height: 56, borderRadius: 28,
          background: COLORS.accentRed,
          border: 'none',
          color: COLORS.cream,
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontWeight: 400, letterSpacing: '0.12em',
          cursor: 'pointer',
          boxShadow: `0 4px 32px rgba(139,26,42,0.45)`,
        }}>I feel her</button>
        <div style={{
          textAlign: 'center', marginTop: 12,
          fontSize: 11, color: 'rgba(242,232,217,0.3)',
          letterSpacing: '0.15em',
        }}>Today's Bīja — {s.bija}</div>
      </div>

      <TabBar active="today"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── MANDALA SCREEN ───────────────────────────────────────────────────────────

function MandalaScreen() {
  return (
    <div style={{
      width: 390, height: 844, background: COLORS.ground,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      position: 'relative',
    }}>
      {/* Faint center radial */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 70% 60% at 50% 45%, rgba(201,150,63,0.06) 0%, transparent 70%)`,
        pointerEvents: 'none',
      }}/>

      <StatusBar/>

      {/* Avarana label */}
      <div style={{
        textAlign: 'center', padding: '10px 0 6px',
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 11, color: COLORS.gold,
        letterSpacing: '0.16em', textTransform: 'uppercase',
        opacity: 0.85,
      }}>2nd Avaraṇa — Sarvāśā-Paripūraka Cakra</div>

      {/* Lotus — centered, fills most of screen */}
      <div style={{
        flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center',
        paddingBottom: 8,
      }}>
        <LotusMandalaSVG size={344} activeIndex={TODAY_INDEX} animated={true}/>
      </div>

      {/* Progress summary */}
      <div style={{
        textAlign: 'center', paddingBottom: 14,
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 12, color: 'rgba(242,232,217,0.45)',
        letterSpacing: '0.1em',
      }}>
        <span style={{ color: COLORS.gold }}>{PROGRESS.active}</span> of {PROGRESS.total} Active
        <span style={{ margin: '0 10px', opacity: 0.4 }}>·</span>
        <span style={{ color: COLORS.cream, opacity: 0.7 }}>{PROGRESS.embodied}</span> Embodied
      </div>

      {/* Cluster legend — two tight rows */}
      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, auto)',
        gap: '6px 22px',
        justifyContent: 'center',
        padding: '0 24px 6px',
      }}>
        {Object.entries(CLUSTER_INFO).map(([key, info]) => (
          <div key={key} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <div style={{ width: 5, height: 5, borderRadius: '50%', background: info.color, boxShadow: `0 0 4px ${info.color}` }}/>
            <span style={{
              fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
              fontSize: 9.5, color: 'rgba(242,232,217,0.45)',
              letterSpacing: '0.1em',
            }}>{info.label}</span>
          </div>
        ))}
      </div>

      {/* Tap hint */}
      <div style={{
        textAlign: 'center', paddingBottom: 12,
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 9, color: 'rgba(242,232,217,0.22)',
        letterSpacing: '0.24em', textTransform: 'uppercase',
      }}>Tap a petal to enter · Bindu for silence</div>

      <TabBar active="mandala"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── SHAKTI DETAIL SCREEN ─────────────────────────────────────────────────────

function ShaktiDetailScreen() {
  // Show Ātmākarṣiṇī (index 13) to demonstrate field connection
  const s = SHAKTIS[13];
  const clusterColor = CLUSTER_INFO[s.cluster].color;
  const clusterLabel = CLUSTER_INFO[s.cluster].label;

  const statusColors = { mapped:'rgba(242,232,217,0.35)', exploring:'rgba(201,150,63,0.55)', active:COLORS.gold, embodied:'#D4A017' };
  const statusLabels = { mapped:'Mapped', exploring:'Exploring', active:'Active', embodied:'Embodied' };

  return (
    <div style={{
      width: 390, height: 844, background: COLORS.ground,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
      position: 'relative',
    }}>
      <StatusBar/>

      {/* Navigation */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '6px 20px 12px',
        borderBottom: '0.5px solid rgba(201,150,63,0.12)',
        flexShrink: 0,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: COLORS.gold, fontSize: 13, cursor: 'pointer' }}>
          <span style={{ fontSize: 18, lineHeight: 1 }}>‹</span>
          <span style={{ letterSpacing: '0.06em' }}>Mandala</span>
        </div>
        {/* Mini petal icon */}
        <svg width="28" height="36" viewBox="0 0 28 36">
          <path d="M14,4 C18,8 19,16 14,32 C9,16 10,8 14,4 Z" fill={clusterColor} opacity="0.85"/>
        </svg>
      </div>

      {/* Header */}
      <div style={{ padding: '18px 26px 16px', borderBottom: '0.5px solid rgba(201,150,63,0.1)', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 12 }}>
          <div style={{ flex: 1 }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 34, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.06em',
              lineHeight: 1.1, marginBottom: 6,
            }}>{s.name}</div>
            <div style={{
              fontSize: 11, color: 'rgba(242,232,217,0.4)',
              letterSpacing: '0.18em', textTransform: 'uppercase', marginBottom: 12,
            }}>{s.phonetic}</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <ClusterDot shakti={s}/>
              <div style={{
                padding: '3px 12px', borderRadius: 12,
                border: `1px solid ${statusColors[s.status]}`,
                fontSize: 10, color: statusColors[s.status],
                letterSpacing: '0.14em', textTransform: 'uppercase',
              }}>{statusLabels[s.status]}</div>
            </div>
          </div>
        </div>
      </div>

      {/* Scrollable body */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 26px' }}>

        {/* Quality Description */}
        <div style={{ padding: '20px 0 0' }}>
          <div style={sectionLabel}>Quality</div>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 19, fontWeight: 300,
            color: COLORS.gold, letterSpacing: '0.02em', marginBottom: 10,
          }}>{s.quality}</div>
          <div style={{
            fontSize: 14, lineHeight: 1.75,
            color: 'rgba(242,232,217,0.65)',
            letterSpacing: '0.01em',
          }}>{s.description}</div>
        </div>

        {/* Somatic Signature */}
        <div style={{ padding: '20px 0 0' }}>
          <div style={sectionLabel}>Somatic Signature</div>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 17, fontStyle: 'italic', fontWeight: 300,
            color: 'rgba(242,232,217,0.75)',
            lineHeight: 1.8, whiteSpace: 'pre-line',
          }}>{s.somaticPoetry}</div>
        </div>

        {/* Bija */}
        <div style={{ padding: '22px 0 0', textAlign: 'center' }}>
          <div style={sectionLabel}>Bīja Syllable · Tap to Hear</div>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 18 }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 68, fontWeight: 300,
              color: COLORS.gold,
              lineHeight: 1,
              textShadow: `0 0 30px rgba(201,150,63,0.4)`,
            }}>{s.bija}</div>
            <div style={{ position: 'relative', width: 44, height: 44 }}>
              {/* Pulse rings hinting interactivity */}
              <div style={{
                position: 'absolute', inset: 0,
                borderRadius: '50%',
                border: `1px solid rgba(201,150,63,0.55)`,
                background: 'rgba(201,150,63,0.05)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                cursor: 'pointer',
              }}>
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                  <path d="M3,2 L11,7 L3,12 Z" fill={COLORS.gold} opacity="0.85"/>
                </svg>
              </div>
              <div style={{
                position: 'absolute', inset: -6,
                borderRadius: '50%',
                border: `0.5px solid rgba(201,150,63,0.25)`,
                pointerEvents: 'none',
              }}/>
            </div>
          </div>
        </div>

        {/* Tattva */}
        <div style={{ padding: '20px 0 0' }}>
          <div style={sectionLabel}>Esoteric Tattva</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 28, height: 28, borderRadius: '50%',
              background: `rgba(${hexToRgb(clusterColor)},0.15)`,
              border: `1px solid rgba(${hexToRgb(clusterColor)},0.3)`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <div style={{ width: 10, height: 10, borderRadius: '50%', background: clusterColor, opacity: 0.8 }}/>
            </div>
            <span style={{ fontSize: 15, color: 'rgba(242,232,217,0.7)', letterSpacing: '0.04em' }}>{s.tattva}</span>
          </div>
        </div>

        {/* Field Connection — only when present */}
        {s.fieldConnection && (
          <div style={{
            margin: '22px 0 0',
            padding: '16px 18px',
            background: `rgba(${hexToRgb(clusterColor)},0.07)`,
            borderRadius: 12,
            borderLeft: `2px solid rgba(${hexToRgb(clusterColor)},0.35)`,
          }}>
            <div style={{ ...sectionLabel, marginBottom: 8 }}>
              Field Connection — {s.fieldConnection.field}
            </div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 15, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.65)', lineHeight: 1.7,
            }}>{s.fieldConnection.note}</div>
          </div>
        )}

        {/* Recognition Log */}
        <div style={{ padding: '22px 0 0' }}>
          <div style={sectionLabel}>Recognition Log</div>
          {[
            { time: 'Today, 9:14 AM', note: 'Morning light on hands' },
            { time: 'May 17, 8:41 PM', note: null },
            { time: 'May 14, 2:33 PM', note: 'In the garden — extraordinary' },
          ].map((entry, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'flex-start', gap: 14,
              padding: '10px 0',
              borderBottom: i < 2 ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
            }}>
              <div style={{
                width: 6, height: 6, borderRadius: '50%',
                background: clusterColor, marginTop: 5, flexShrink: 0, opacity: 0.7,
              }}/>
              <div>
                <div style={{ fontSize: 12, color: 'rgba(242,232,217,0.4)', letterSpacing: '0.06em', marginBottom: 3 }}>{entry.time}</div>
                {entry.note && <div style={{ fontSize: 13, color: 'rgba(242,232,217,0.6)', fontStyle: 'italic' }}>{entry.note}</div>}
              </div>
            </div>
          ))}
        </div>

        <div style={{ height: 28 }}/>
      </div>

      <TabBar active="mandala"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── RECOGNITION MOMENT SCREEN ────────────────────────────────────────────────

function RecognitionMomentScreen() {
  const s = TODAY_SHAKTI;
  const clusterColor = CLUSTER_INFO[s.cluster].color;

  return (
    <div style={{
      width: 390, height: 844,
      background: '#080307',
      display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center',
      overflow: 'hidden', position: 'relative',
    }}>
      {/* Bija texture — very large, behind everything */}
      <div style={{
        position: 'absolute',
        top: '50%', left: '50%',
        transform: 'translate(-50%, -55%)',
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 360, fontWeight: 300,
        color: COLORS.gold,
        opacity: 0.065,
        userSelect: 'none', pointerEvents: 'none',
        lineHeight: 1,
      }}>{s.bija}</div>

      {/* Ripple rings */}
      {[0, 1.1, 2.2, 3.3].map((delay, i) => (
        <div key={i} className="ripple-ring" style={{
          animationDelay: `${delay}s`,
          borderColor: `rgba(201,150,63,${0.35 - i * 0.06})`,
        }}/>
      ))}

      {/* Center content */}
      <div style={{
        position: 'relative', zIndex: 2,
        display: 'flex', flexDirection: 'column',
        alignItems: 'center', padding: '0 44px',
        textAlign: 'center',
      }}>
        {/* Sanskrit name */}
        <div className="recog-name" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 38, fontWeight: 300,
          color: COLORS.cream,
          letterSpacing: '0.1em',
          lineHeight: 1.1,
          marginBottom: 28,
          opacity: 0,
        }}>{s.name}</div>

        {/* Thin divider */}
        <div className="recog-text" style={{
          width: 32, height: 0.5,
          background: `rgba(201,150,63,0.5)`,
          marginBottom: 28, opacity: 0,
        }}/>

        {/* Appreciation phrase */}
        <div className="recog-text" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 24, fontWeight: 300, fontStyle: 'italic',
          color: COLORS.cream,
          lineHeight: 1.7,
          letterSpacing: '0.02em',
          opacity: 0,
        }}>{s.recognition}</div>
      </div>

      {/* Logged timestamp */}
      <div className="recog-logged" style={{
        position: 'absolute', bottom: 120, left: 0, right: 0,
        textAlign: 'center', opacity: 0,
      }}>
        <div style={{
          fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
          fontSize: 11, color: 'rgba(242,232,217,0.35)',
          letterSpacing: '0.16em', textTransform: 'uppercase',
          marginBottom: 10,
        }}>Logged · 9:41 AM</div>

        {/* Hairline between the two acts of recognition */}
        <div className="recog-reciprocity" style={{
          width: 22, height: 0.5,
          background: `rgba(201,150,63,0.4)`,
          margin: '0 auto 10px',
          opacity: 0,
        }}/>

        {/* Reciprocity — she felt you back */}
        <div className="recog-reciprocity" style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 14, fontStyle: 'italic',
          color: COLORS.gold,
          letterSpacing: '0.05em',
          opacity: 0,
          marginBottom: 22,
        }}>And she felt you back · 9:41:03</div>

        <div style={{
          margin: '0 auto',
          width: 248,
          background: 'rgba(242,232,217,0.04)',
          border: '0.5px solid rgba(242,232,217,0.12)',
          borderRadius: 14,
          padding: '12px 18px',
        }}>
          <div style={{
            fontSize: 13, color: 'rgba(242,232,217,0.3)',
            fontStyle: 'italic', letterSpacing: '0.04em',
            fontFamily: "'Cormorant Garamond', serif",
          }}>What did you notice?</div>
        </div>
      </div>

      {/* Dismiss hint */}
      <div style={{
        position: 'absolute', bottom: 36,
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 10, color: 'rgba(242,232,217,0.18)',
        letterSpacing: '0.2em', textTransform: 'uppercase',
      }}>Tap anywhere to close</div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── SILENCE SCREEN — the Bindu, undifferentiated ────────────────────────────

function SilenceScreen() {
  // The 16 Shaktis arranged like distant stars around the bindu
  // All present, none announcing themselves
  const cx = 195, cy = 422;
  const nameRadius = 156;

  return (
    <div style={{
      width: 390, height: 844,
      background: '#040104',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* Vignette — the edges deepen, drawing the eye to center */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(ellipse 70% 60% at 50% 50%, transparent 0%, rgba(0,0,0,0.65) 100%)`,
        pointerEvents: 'none',
      }}/>

      {/* The 16 names arranged like stars — barely there */}
      {SHAKTIS.map((s, i) => {
        const angle = (i * 22.5 - 90) * Math.PI / 180;
        const x = cx + nameRadius * Math.cos(angle);
        const y = cy + nameRadius * Math.sin(angle);
        // tangential rotation so names read along the circle
        const rot = (i * 22.5);
        return (
          <div key={s.id} className="silence-name" style={{
            position: 'absolute',
            left: x, top: y,
            transform: `translate(-50%, -50%) rotate(${rot}deg)`,
            transformOrigin: 'center',
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 11, fontStyle: 'italic',
            fontWeight: 300,
            color: 'rgba(242,232,217,0.16)',
            letterSpacing: '0.18em',
            whiteSpace: 'nowrap',
            opacity: 0,
            animationDelay: `${0.15 + i * 0.12}s`,
            textShadow: '0 0 8px rgba(201,150,63,0.15)',
          }}>{s.short}</div>
        );
      })}

      {/* Faint outer geometry — the locked avaraṇas, distant */}
      <svg width="390" height="844" style={{ position:'absolute', inset:0, pointerEvents:'none' }}>
        <circle cx={cx} cy={cy} r="200" fill="none" stroke="rgba(201,150,63,0.05)" strokeWidth="0.5"/>
        <circle cx={cx} cy={cy} r="220" fill="none" stroke="rgba(201,150,63,0.035)" strokeWidth="0.5" strokeDasharray="2 8"/>
        <circle cx={cx} cy={cy} r="240" fill="none" stroke="rgba(201,150,63,0.025)" strokeWidth="0.5"/>
      </svg>

      {/* Bindu — large, slow breath. Her undifferentiated form. */}
      <div style={{
        position: 'absolute',
        top: cy, left: cx,
        transform: 'translate(-50%, -50%)',
      }}>
        {/* Soft outer ring — barely there, holding her */}
        <div style={{
          position: 'absolute',
          top: '50%', left: '50%',
          transform: 'translate(-50%, -50%)',
          width: 132, height: 132,
          borderRadius: '50%',
          border: '0.5px solid rgba(201,150,63,0.18)',
        }}/>
        <div className="silence-bindu" style={{
          width: 76, height: 76,
          borderRadius: '50%',
          background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.7) 60%, transparent 100%)`,
          position: 'relative',
        }}>
          <div style={{
            position: 'absolute',
            top: '50%', left: '50%',
            transform: 'translate(-50%, -50%)',
            width: 20, height: 20,
            borderRadius: '50%',
            background: COLORS.cream,
            boxShadow: `0 0 22px ${COLORS.cream}, 0 0 44px rgba(242,232,217,0.45)`,
            opacity: 0.96,
          }}/>
        </div>
      </div>

      {/* Caption — appears only after presence has settled */}
      <div className="silence-caption" style={{
        position: 'absolute',
        top: cy + 220, left: 0, right: 0,
        textAlign: 'center',
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 18, fontStyle: 'italic', fontWeight: 300,
        color: 'rgba(242,232,217,0.55)',
        letterSpacing: '0.06em',
        opacity: 0,
      }}>All of her. Here. Always.</div>

      {/* No status bar. No tab bar. Only the dismiss hint, almost invisible. */}
      <div style={{
        position: 'absolute', bottom: 38, left: 0, right: 0,
        textAlign: 'center',
        fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize: 9, color: 'rgba(242,232,217,0.14)',
        letterSpacing: '0.28em', textTransform: 'uppercase',
      }}>Tap to return</div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── Utilities ────────────────────────────────────────────────────────────────

const sectionLabel = {
  fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
  fontSize: 9.5, color: 'rgba(242,232,217,0.3)',
  letterSpacing: '0.2em', textTransform: 'uppercase',
  marginBottom: 10,
};

function hexToRgb(hex) {
  const r = parseInt(hex.slice(1,3),16);
  const g = parseInt(hex.slice(3,5),16);
  const b = parseInt(hex.slice(5,7),16);
  return `${r},${g},${b}`;
}

// ─── Export to window ─────────────────────────────────────────────────────────
Object.assign(window, {
  StatusBar, TabBar, MoonPhase, ClusterDot, HomeIndicator,
  BodyOutlineSVG, LotusMandalaSVG, DustMotes,
  TodayScreenV1, TodayScreenV2,
  MandalaScreen, ShaktiDetailScreen, RecognitionMomentScreen,
  SilenceScreen,
  hexToRgb, sectionLabel,
});
