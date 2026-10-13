// ─── Phase 5 · The Temporal Layer ─────────────────────────────────────────────
// The yantra is alive in time. Hour, tithi, nakshatra, moon, season, year.
// Six instruments: Cosmic Now · Lunar Yantra · Sandhya · Seasonal · Great
// Wheel · Tithi.

// ─── Shared mini yantra (declared locally — each Babel script is own scope) ──

function petalP(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

function YantraGlyph({ size = 220, intensity = 1, tone = 'warm', todayIdx = null }) {
  const cx = size/2, cy = size/2;
  const oR = size * 0.42, iR = size * 0.34, hw = size * 0.07;
  const pPath = petalP(oR, iR, hw);
  const tones = {
    warm:   { triStroke: '#C9963F', petalMul: 1.0 },
    cool:   { triStroke: '#A4B8CC', petalMul: 0.5 },
    silver: { triStroke: '#D4DCE6', petalMul: 0.35 },
    ember:  { triStroke: '#C25640', petalMul: 0.85 },
    bloom:  { triStroke: '#E8C97A', petalMul: 1.15 },
  };
  const t = tones[tone] || tones.warm;
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}
      style={{ overflow: 'visible', display: 'block' }}>
      <rect x={cx - oR*1.15} y={cy - oR*1.15} width={oR*2.3} height={oR*2.3}
        fill="none" stroke={t.triStroke}
        strokeWidth="0.4" opacity={0.18 * intensity}/>
      {SHAKTIS.map((s, i) => {
        const isToday = todayIdx !== null && i === todayIdx;
        const col = CLUSTER_INFO[s.cluster].color;
        const op = isToday ? 0.95 : STATUS_OPACITY[s.status] * 0.7 * intensity * t.petalMul;
        return (
          <g key={i} transform={`translate(${cx},${cy}) rotate(${i*22.5})`}>
            <path d={pPath} fill={col} opacity={op}/>
          </g>
        );
      })}
      <g transform={`translate(${cx},${cy})`} opacity={0.45 * intensity}>
        {[ {r: iR*0.85, up:false}, {r: iR*0.65, up:true},
           {r: iR*0.45, up:false}, {r: iR*0.30, up:true} ].map((tr, k) => (
          <path key={k}
            d={tr.up
              ? `M 0,${-tr.r} L ${tr.r*0.866},${tr.r/2} L ${-tr.r*0.866},${tr.r/2} Z`
              : `M 0,${tr.r} L ${tr.r*0.866},${-tr.r/2} L ${-tr.r*0.866},${-tr.r/2} Z`}
            fill="none" stroke={t.triStroke} strokeWidth="0.4"/>
        ))}
      </g>
      <circle cx={cx} cy={cy} r={size*0.022} fill={COLORS.accentRed} opacity={0.9}/>
      <circle cx={cx} cy={cy} r={size*0.009} fill={COLORS.cream}/>
    </svg>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 1 — THE COSMIC NOW
// A dashboard of your temporal location. Five concentric wheels turning at
// different rates: hour · tithi · nakshatra · season · year. Each labeled.
// You see, at a glance, where you are inside time itself.
// ═════════════════════════════════════════════════════════════════════════════

const NAKSHATRAS = [
  'Aśvinī','Bharaṇī','Kṛttikā','Rohiṇī','Mṛgaśīrṣā','Ārdrā','Punarvasu',
  'Puṣya','Āśleṣā','Maghā','Pūrva Phalgunī','Uttara Phalgunī','Hasta',
  'Citrā','Svātī','Viśākhā','Anurādhā','Jyeṣṭhā','Mūla','Pūrvāṣāḍhā',
  'Uttarāṣāḍhā','Śravaṇa','Dhaniṣṭhā','Śatabhiṣā','Pūrva Bhādrapadā',
  'Uttara Bhādrapadā','Revatī'
];

const TITHIS = [
  'Pratipada','Dvitīyā','Tṛtīyā','Caturthī','Pañcamī','Ṣaṣṭhī','Saptamī',
  'Aṣṭamī','Navamī','Daśamī','Ekādaśī','Dvādaśī','Trayodaśī','Caturdaśī','Pūrṇimā'
];

function CosmicNowScreen() {
  // Sample current state — would come from real time/almanac in production
  const now = {
    timeOfDay: 'Sandhya · evening twilight',
    timeAngle: 280, // ~6:30pm on 24h dial (270 = sunset)
    tithi: 'Trayodaśī',
    tithiNum: 12,
    nakshatra: 'Anurādhā',
    nakshatraNum: 16,
    moonPhase: 'Waxing Gibbous',
    moonIllum: 0.78,
    season: 'Śarad · autumn',
    seasonAngle: 245,
    solarPos: 'Vṛścika · Scorpio',
    pakshaShukla: true, // bright fortnight
  };

  const cx = 195, cy = 422;

  const wheels = [
    { r: 158, label: 'hour',     value: '6:42 PM',     angle: now.timeAngle,              tickCount: 24, dotColor: '#C9963F' },
    { r: 130, label: 'tithi',    value: 'Trayodaśī',   angle: now.tithiNum * 24,          tickCount: 15, dotColor: '#E8C97A' },
    { r: 102, label: 'nakṣatra', value: 'Anurādhā',    angle: now.nakshatraNum * (360/27),tickCount: 27, dotColor: '#D4A067' },
    { r: 74,  label: 'season',   value: 'Śarad',       angle: now.seasonAngle,            tickCount: 6,  dotColor: '#D4A017' },
    { r: 48,  label: 'sūrya',    value: 'Vṛścika',     angle: 210,                        tickCount: 12, dotColor: '#C45050' },
  ];

  return (
    <div style={{
      width: 390, height: 844,
      background: 'radial-gradient(ellipse 70% 60% at 50% 50%, #0A0608 0%, #020001 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={8}/>
      <StatusBar/>

      {/* Title */}
      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Cosmic Now</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.65)',
          letterSpacing: '0.03em',
        }}>where you are, inside time</div>
      </div>

      {/* Concentric wheels — pure geometry, no embedded text */}
      <svg width="390" height="844"
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {wheels.map((w, wi) => {
          const ar = (w.angle - 90) * Math.PI / 180;
          const dx = cx + w.r * Math.cos(ar);
          const dy = cy + w.r * Math.sin(ar);
          return (
            <g key={wi}>
              {/* Ring — clearer stroke */}
              <circle cx={cx} cy={cy} r={w.r} fill="none"
                stroke="rgba(201,150,63,0.25)" strokeWidth="0.5"/>
              {/* Tick marks */}
              {Array.from({length: w.tickCount}).map((_, i) => {
                const a = (i / w.tickCount) * 360 - 90;
                const tar = a * Math.PI / 180;
                const x1 = cx + (w.r - 2) * Math.cos(tar);
                const y1 = cy + (w.r - 2) * Math.sin(tar);
                const x2 = cx + (w.r + 2) * Math.cos(tar);
                const y2 = cy + (w.r + 2) * Math.sin(tar);
                return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2}
                  stroke="rgba(201,150,63,0.22)" strokeWidth="0.3"/>;
              })}
              {/* Radial line from center to position dot — anchors it */}
              <line x1={cx} y1={cy} x2={dx} y2={dy}
                stroke={w.dotColor} strokeWidth="0.4" opacity="0.18"/>
              {/* Position dot */}
              <circle cx={dx} cy={dy} r="4.5" fill={w.dotColor}
                style={{ filter: `drop-shadow(0 0 6px ${w.dotColor})` }}/>
              <circle cx={dx} cy={dy} r="1.5" fill={COLORS.cream}/>
            </g>
          );
        })}

        {/* Bindu */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="14" fill={COLORS.accentRed} opacity="0.85"
            style={{ filter: 'drop-shadow(0 0 18px rgba(139,26,42,0.7))' }}>
            <animate attributeName="r" values="13;16;13" dur="5s" repeatCount="indefinite"/>
          </circle>
          <circle r="5" fill={COLORS.cream}
            style={{ filter: 'drop-shadow(0 0 10px rgba(242,232,217,0.85))' }}/>
        </g>
      </svg>

      {/* Legend — current values, color-keyed to each wheel */}
      <div style={{
        position: 'absolute', bottom: 220, left: 36, right: 36,
        display: 'grid', gridTemplateColumns: '14px 1fr 1fr',
        rowGap: 8, columnGap: 12,
        alignItems: 'baseline',
      }}>
        {wheels.map((w, i) => (
          <React.Fragment key={i}>
            <div style={{
              width: 6, height: 6, borderRadius: '50%',
              background: w.dotColor, opacity: 0.85,
              boxShadow: `0 0 5px ${w.dotColor}`,
              alignSelf: 'center',
            }}/>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.42)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
            }}>{w.label}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 15, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.85)',
              letterSpacing: '0.02em',
            }}>{w.value}</div>
          </React.Fragment>
        ))}
      </div>

      {/* Bottom — the current temporal voice */}
      <div style={{
        position: 'absolute', bottom: 88, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(212,160,103,0.7)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 14,
        }}>this moment</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.78)',
          letterSpacing: '0.02em', lineHeight: 1.5,
          marginBottom: 10,
        }}>Sandhyā · the evening junction.<br/>Anurādhā watches the moon waxing.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>Śukla Pakṣa · day 13 · moon 78% full</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 2 — THE LUNAR YANTRA
// The same instrument at four key lunar phases. Across one cycle.
// New (Bindu rises) → Waxing (rings build) → Full (entire mandala blooms)
// → Waning (releasing back to seed).
// ═════════════════════════════════════════════════════════════════════════════

function LunarYantraScreen({ phase = 'full' }) {
  const config = {
    'new': {
      label: 'Amāvasyā · the dark moon',
      poetry: 'when the moon is hidden,\nthe Bindu rises.',
      meta: 'sit with the seed',
      bg: 'radial-gradient(ellipse 60% 50% at 50% 50%, rgba(139,26,42,0.18) 0%, #010001 70%)',
      yantraIntensity: 0.25,
      binduSize: 90,
      moonIllum: 0,
      moonSide: 'none',
    },
    'waxing': {
      label: 'Śukla Pakṣa · the moon waxes',
      poetry: 'the petals open\nfrom the inside out.',
      meta: 'the bright half · ring 3 brightening',
      bg: 'radial-gradient(ellipse 70% 55% at 50% 50%, rgba(232,201,122,0.10) 0%, #050308 70%)',
      yantraIntensity: 0.75,
      binduSize: 28,
      moonIllum: 0.5,
      moonSide: 'right',
    },
    'full': {
      label: 'Pūrṇimā · the full moon',
      poetry: 'every petal in bloom.\nall 16, all at once.',
      meta: 'the yantra is most alive',
      bg: 'radial-gradient(ellipse 80% 65% at 50% 50%, rgba(242,232,217,0.10) 0%, rgba(201,150,63,0.06) 35%, #060306 80%)',
      yantraIntensity: 1.35,
      binduSize: 22,
      moonIllum: 1,
      moonSide: 'full',
    },
    'waning': {
      label: 'Kṛṣṇa Pakṣa · the moon wanes',
      poetry: 'the petals fold inward.\nshe returns to seed.',
      meta: 'the dark half · the integration',
      bg: 'radial-gradient(ellipse 65% 55% at 50% 50%, rgba(140,160,200,0.06) 0%, #030308 80%)',
      yantraIntensity: 0.55,
      binduSize: 38,
      moonIllum: 0.5,
      moonSide: 'left',
    },
  }[phase];

  return (
    <div style={{
      width: 390, height: 844, background: config.bg,
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={phase === 'new' ? 4 : phase === 'full' ? 14 : 8}/>
      <StatusBar/>

      {/* Moon glyph — top, showing current illumination */}
      <div style={{
        position: 'absolute', top: 76, left: 0, right: 0,
        display: 'flex', justifyContent: 'center',
      }}>
        <svg width="56" height="56" viewBox="0 0 56 56">
          <circle cx="28" cy="28" r="20" fill="none"
            stroke="rgba(242,232,217,0.20)" strokeWidth="0.5"/>
          {config.moonSide === 'full' && (
            <circle cx="28" cy="28" r="20" fill="rgba(242,232,217,0.55)"
              style={{ filter: 'drop-shadow(0 0 14px rgba(242,232,217,0.65))' }}/>
          )}
          {config.moonSide === 'right' && (
            <>
              <circle cx="28" cy="28" r="20" fill="rgba(242,232,217,0.15)"/>
              <path d="M 28,8 A 20,20 0 0,1 28,48 Z" fill="rgba(242,232,217,0.55)"
                style={{ filter: 'drop-shadow(0 0 8px rgba(242,232,217,0.45))' }}/>
            </>
          )}
          {config.moonSide === 'left' && (
            <>
              <circle cx="28" cy="28" r="20" fill="rgba(242,232,217,0.15)"/>
              <path d="M 28,8 A 20,20 0 0,0 28,48 Z" fill="rgba(140,160,200,0.5)"/>
            </>
          )}
          {config.moonSide === 'none' && (
            <circle cx="28" cy="28" r="6" fill={COLORS.accentRed}
              style={{ filter: 'drop-shadow(0 0 10px rgba(139,26,42,0.75))' }}/>
          )}
        </svg>
      </div>

      <div style={{
        position: 'absolute', top: 152, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
        }}>{config.label}</div>
      </div>

      {/* The yantra */}
      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%, -50%) translateY(-20px)',
      }}>
        <div style={{ position: 'relative' }}>
          <YantraGlyph size={300}
            intensity={config.yantraIntensity}
            tone={phase === 'new' ? 'cool' : phase === 'full' ? 'bloom' : phase === 'waning' ? 'silver' : 'warm'}/>

          {/* When new, the Bindu fills the role of the whole instrument */}
          {phase === 'new' && (
            <div style={{
              position: 'absolute', top: '50%', left: '50%',
              transform: 'translate(-50%, -50%)',
              width: config.binduSize, height: config.binduSize, borderRadius: '50%',
              background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.5) 50%, transparent 100%)`,
              boxShadow: '0 0 64px 20px rgba(139,26,42,0.45)',
              animation: 'lunarBinduBreath 6s ease-in-out infinite',
            }}>
              <div style={{
                position: 'absolute', top: '50%', left: '50%',
                transform: 'translate(-50%, -50%)',
                width: 24, height: 24, borderRadius: '50%',
                background: COLORS.cream,
                boxShadow: '0 0 20px rgba(242,232,217,0.85)',
              }}/>
            </div>
          )}
        </div>
      </div>

      {/* Poetry */}
      <div style={{
        position: 'absolute', bottom: 156, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 18, whiteSpace: 'pre-line',
        }}>{config.poetry}</div>
        <div style={{ width: 32, height: 0.5,
          background: 'rgba(201,150,63,0.3)', margin: '0 auto 14px' }}/>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>{config.meta}</div>
      </div>

      {/* Phase indicator strip — bottom */}
      <div style={{
        position: 'absolute', bottom: 80, left: 0, right: 0,
        display: 'flex', justifyContent: 'center', gap: 18,
      }}>
        {['new','waxing','full','waning'].map(p => (
          <div key={p} style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 9,
            color: p === phase ? COLORS.gold : 'rgba(242,232,217,0.20)',
            letterSpacing: '0.18em', textTransform: 'uppercase',
            opacity: p === phase ? 1 : 0.5,
          }}>{p === phase ? '· ' + p + ' ·' : p}</div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 3 — THE SANDHYAS
// Three twilight junctions. Each is a sacred hinge moment.
// Pratah (dawn) · Madhyahna (noon) · Sayam (dusk).
// Each is its own micro-practice, opened by the time-of-day.
// ═════════════════════════════════════════════════════════════════════════════

function SandhyaScreen({ which = 'sayam' }) {
  const config = {
    'pratah': {
      label: 'Prātaḥ Sandhyā · the morning junction',
      time: '5:42 AM',
      sky: 'linear-gradient(180deg, #0F0610 0%, #200818 25%, #481020 55%, #88381F 85%, #C66832 100%)',
      glow: 'radial-gradient(ellipse 100% 60% at 50% 100%, rgba(232,180,140,0.45) 0%, transparent 70%)',
      shakti: 'Brāhmī',
      shaktiNote: 'she who breathes the first breath of the world',
      invitation: 'Open the eyes\nbefore the world opens them for you.',
      practice: 'three breaths · facing east',
      tone: 'warm',
    },
    'madhyahna': {
      label: 'Madhyāhna Sandhyā · the noon junction',
      time: '12:14 PM',
      sky: 'linear-gradient(180deg, #FFE4A0 0%, #FFCB6A 30%, #E8A040 70%, #B66828 100%)',
      glow: 'radial-gradient(ellipse 100% 80% at 50% 30%, rgba(255,230,168,0.55) 0%, transparent 70%)',
      shakti: 'Vaiṣṇavī',
      shaktiNote: 'she who pervades the high light without shadow',
      invitation: 'The sun has nothing to hide.\nNeither do you.',
      practice: 'one minute · still upright',
      tone: 'noon',
    },
    'sayam': {
      label: 'Sāyam Sandhyā · the evening junction',
      time: '6:42 PM',
      sky: 'linear-gradient(180deg, #060104 0%, #1A081C 30%, #501020 60%, #8A2828 82%, #C44030 100%)',
      glow: 'radial-gradient(ellipse 100% 70% at 50% 100%, rgba(196,64,48,0.50) 0%, transparent 70%)',
      shakti: 'Rudrāṇī',
      shaktiNote: 'she who closes the day, who holds the threshold',
      invitation: 'What you carried today\nyou may set down here.',
      practice: 'three breaths · facing west',
      tone: 'ember',
    },
  }[which];

  return (
    <div style={{
      width: 390, height: 844,
      background: config.sky,
      position: 'relative', overflow: 'hidden',
    }}>
      {/* Glow from the horizon */}
      <div style={{
        position: 'absolute', inset: 0,
        background: config.glow,
        pointerEvents: 'none',
      }}/>
      <DustMotes count={6}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10,
          color: which === 'madhyahna' ? 'rgba(60,30,15,0.55)' : 'rgba(242,232,217,0.55)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 8,
        }}>Sandhyā · the junction</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 13, fontStyle: 'italic',
          color: which === 'madhyahna' ? 'rgba(60,30,15,0.7)' : 'rgba(242,232,217,0.65)',
          letterSpacing: '0.16em',
        }}>{config.label}</div>
        <div style={{
          marginTop: 6,
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10,
          color: which === 'madhyahna' ? 'rgba(60,30,15,0.45)' : 'rgba(242,232,217,0.32)',
          letterSpacing: '0.22em',
        }}>{config.time}</div>
      </div>

      {/* The shakti, named */}
      <div style={{
        position: 'absolute', top: 200, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 56, fontWeight: 300, fontStyle: 'italic',
          color: which === 'madhyahna' ? 'rgba(80,40,15,0.92)' : COLORS.cream,
          letterSpacing: '0.05em',
          lineHeight: 1, marginBottom: 18,
          textShadow: which === 'madhyahna'
            ? '0 0 24px rgba(80,40,15,0.4)'
            : '0 0 28px rgba(242,232,217,0.4)',
        }}>{config.shakti}</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 16, fontStyle: 'italic', fontWeight: 300,
          color: which === 'madhyahna' ? 'rgba(80,40,15,0.65)' : 'rgba(242,232,217,0.62)',
          letterSpacing: '0.02em',
          maxWidth: 280, margin: '0 auto',
        }}>{config.shaktiNote}</div>
      </div>

      {/* Mini yantra centered low */}
      <div style={{
        position: 'absolute', top: 400, left: '50%',
        transform: 'translateX(-50%)',
        opacity: which === 'madhyahna' ? 0.35 : 0.5,
      }}>
        <YantraGlyph size={160} intensity={0.6}
          tone={config.tone === 'ember' ? 'ember' : config.tone === 'noon' ? 'bloom' : 'warm'}/>
      </div>

      {/* The invitation */}
      <div style={{
        position: 'absolute', bottom: 170, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontStyle: 'italic', fontWeight: 300,
          color: which === 'madhyahna' ? 'rgba(40,20,10,0.85)' : 'rgba(242,232,217,0.78)',
          letterSpacing: '0.03em', lineHeight: 1.5,
          whiteSpace: 'pre-line', marginBottom: 28,
        }}>{config.invitation}</div>
        <button style={{
          padding: '12px 36px', borderRadius: 28,
          background: which === 'madhyahna' ? 'rgba(80,40,15,0.18)' : 'rgba(242,232,217,0.12)',
          border: which === 'madhyahna'
            ? '0.5px solid rgba(80,40,15,0.5)'
            : '0.5px solid rgba(242,232,217,0.4)',
          color: which === 'madhyahna' ? 'rgba(40,20,10,0.9)' : COLORS.cream,
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 15, fontStyle: 'italic',
          letterSpacing: '0.10em', cursor: 'pointer',
        }}>begin sandhyā</button>
        <div style={{
          marginTop: 18,
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9,
          color: which === 'madhyahna' ? 'rgba(40,20,10,0.45)' : 'rgba(242,232,217,0.28)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
        }}>{config.practice}</div>
      </div>

      <HomeIndicator light={which !== 'madhyahna'}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 4 — THE SEASONAL YANTRA
// The instrument across the four seasons of practice.
// Vasanta · Grishma · Sharad · Hemanta.
// ═════════════════════════════════════════════════════════════════════════════

function SeasonalYantraScreen({ season = 'sharad' }) {
  const config = {
    'vasanta': {
      label: 'Vasanta · spring',
      sub: 'when the petals begin again',
      bg: 'linear-gradient(180deg, #0A0F08 0%, #060A06 100%)',
      glow: 'radial-gradient(ellipse 70% 60% at 50% 45%, rgba(180,201,122,0.10) 0%, transparent 65%)',
      poetry: 'after the long silence,\nthe field begins to remember itself.',
      tone: 'bloom',
      yantraIntensity: 0.95,
    },
    'grishma': {
      label: 'Grīṣma · summer',
      sub: 'when she is in full sun',
      bg: 'linear-gradient(180deg, #1A0908 0%, #0A0306 100%)',
      glow: 'radial-gradient(ellipse 80% 70% at 50% 40%, rgba(232,150,80,0.18) 0%, transparent 65%)',
      poetry: 'the heat is her presence.\nthe brightness is her presence.',
      tone: 'warm',
      yantraIntensity: 1.3,
    },
    'sharad': {
      label: 'Śarad · autumn',
      sub: 'when she becomes clear',
      bg: 'linear-gradient(180deg, #08060A 0%, #050308 100%)',
      glow: 'radial-gradient(ellipse 70% 60% at 50% 45%, rgba(212,160,103,0.14) 0%, transparent 65%)',
      poetry: 'the sky is cool. the air is exact.\nshe shows herself without ornament.',
      tone: 'warm',
      yantraIntensity: 1.0,
    },
    'hemanta': {
      label: 'Hemanta · winter',
      sub: 'when she goes quiet',
      bg: 'linear-gradient(180deg, #050810 0%, #020308 100%)',
      glow: 'radial-gradient(ellipse 60% 50% at 50% 45%, rgba(140,160,200,0.10) 0%, transparent 70%)',
      poetry: 'she is in the seed now.\nyou keep her warm inside you.',
      tone: 'cool',
      yantraIntensity: 0.65,
    },
  }[season];

  return (
    <div style={{
      width: 390, height: 844, background: config.bg,
      position: 'relative', overflow: 'hidden',
    }}>
      <div style={{ position: 'absolute', inset: 0, background: config.glow, pointerEvents: 'none' }}/>
      <DustMotes count={season === 'grishma' ? 14 : season === 'hemanta' ? 4 : 8}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 76, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
        }}>The Seasonal Yantra</div>
        <div style={{
          marginTop: 8,
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.78)',
          letterSpacing: '0.04em',
        }}>{config.label}</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 13, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.45)',
          letterSpacing: '0.04em', marginTop: 4,
        }}>{config.sub}</div>
      </div>

      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%, -50%)',
      }}>
        <YantraGlyph size={320} intensity={config.yantraIntensity} tone={config.tone} todayIdx={4}/>
      </div>

      <div style={{
        position: 'absolute', bottom: 160, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          whiteSpace: 'pre-line',
        }}>{config.poetry}</div>
      </div>

      {/* Season strip — bottom */}
      <div style={{
        position: 'absolute', bottom: 80, left: 0, right: 0,
        display: 'flex', justifyContent: 'center', gap: 22,
      }}>
        {['vasanta','grishma','sharad','hemanta'].map(s => (
          <div key={s} style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 9,
            color: s === season ? COLORS.gold : 'rgba(242,232,217,0.20)',
            letterSpacing: '0.18em', textTransform: 'uppercase',
          }}>{s === season ? '· ' + s + ' ·' : s}</div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 5 — THE GREAT WHEEL
// Your year of practice rendered as a single circle.
// 365 days arranged radially. Each day's recognition density as luminosity.
// Moon phase as small dots on the outer ring. Seasonal sectors lightly shaded.
// You see, in one image, the entire shape of your year with her.
// ═════════════════════════════════════════════════════════════════════════════

function GreatWheelScreen({ year = 2026, yearOfPractice = 5 }) {
  const cx = 195, cy = 432;
  const days = 365;

  // Synthesize a year's recognition density per day
  // Earlier years have less density (you were just beginning)
  const yearMul = yearOfPractice === 1 ? 0.30
                : yearOfPractice === 2 ? 0.55
                : yearOfPractice === 3 ? 0.80
                : yearOfPractice === 4 ? 1.0
                : 1.15;
  const seedOffset = yearOfPractice;
  const yearDensity = React.useMemo(() => {
    const arr = [];
    for (let d = 0; d < days; d++) {
      const seasonal = Math.sin((d / days) * 2 * Math.PI + 1.3 + seedOffset) * 0.4 + 0.5;
      const weekly = Math.sin((d / 7) * 2 * Math.PI) * 0.1;
      const random = Math.random() * 0.3;
      const v = Math.max(0, Math.min(1, (seasonal + weekly + random) * yearMul));
      arr.push(v);
    }
    return arr;
  }, [year]);

  const yearTotalRecogs = Math.round(
    yearOfPractice === 1 ? 268 :
    yearOfPractice === 2 ? 542 :
    yearOfPractice === 3 ? 814 :
    yearOfPractice === 4 ? 1102 :
    1418
  );
  const isCurrentYear = yearOfPractice === 5;

  const seasonSectors = [
    { from: 0,   to: 90,  color: 'rgba(180,201,122,0.04)', label: 'Vasanta',  labelAngle: 45 },
    { from: 90,  to: 180, color: 'rgba(232,150,80,0.05)',  label: 'Grīṣma',   labelAngle: 135 },
    { from: 180, to: 270, color: 'rgba(212,160,103,0.04)', label: 'Śarad',    labelAngle: 225 },
    { from: 270, to: 360, color: 'rgba(140,160,200,0.04)', label: 'Hemanta',  labelAngle: 315 },
  ];

  return (
    <div style={{
      width: 390, height: 844,
      background: 'radial-gradient(ellipse 80% 70% at 50% 50%, #060306 0%, #020001 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={6}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Great Wheel</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.65)',
          letterSpacing: '0.03em',
        }}>{isCurrentYear ? 'your year, all at once' : `year ${yearOfPractice} · ${year}`}</div>
      </div>

      {/* Year navigator — 5 dots, current highlighted */}
      <div style={{
        position: 'absolute', top: 122, left: 0, right: 0,
        display: 'flex', justifyContent: 'center', gap: 16,
      }}>
        {[2022, 2023, 2024, 2025, 2026].map((y, i) => {
          const isYear = y === year;
          return (
            <div key={y} style={{
              display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            }}>
              <div style={{
                width: isYear ? 7 : 4, height: isYear ? 7 : 4,
                borderRadius: '50%',
                background: isYear ? COLORS.gold : 'rgba(201,150,63,0.30)',
                boxShadow: isYear ? '0 0 8px 2px rgba(201,150,63,0.6)' : 'none',
              }}/>
              <div style={{
                fontFamily: '-apple-system, sans-serif',
                fontSize: 8.5,
                color: isYear ? COLORS.gold : 'rgba(242,232,217,0.28)',
                letterSpacing: '0.12em',
              }}>{y}</div>
            </div>
          );
        })}
      </div>

      <svg width="390" height="844"
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* Seasonal sectors as colored arcs */}
        {seasonSectors.map((s, i) => {
          const aFrom = (s.from - 90) * Math.PI / 180;
          const aTo   = (s.to   - 90) * Math.PI / 180;
          const rO = 165;
          const x1 = cx + rO * Math.cos(aFrom);
          const y1 = cy + rO * Math.sin(aFrom);
          const x2 = cx + rO * Math.cos(aTo);
          const y2 = cy + rO * Math.sin(aTo);
          return (
            <path key={i}
              d={`M ${cx},${cy} L ${x1},${y1} A ${rO},${rO} 0 0,1 ${x2},${y2} Z`}
              fill={s.color}/>
          );
        })}

        {/* Daily density radii */}
        {yearDensity.map((v, d) => {
          const a = (d / days) * 360 - 90;
          const ar = a * Math.PI / 180;
          const r1 = 56;
          const r2 = 56 + 90 * v;
          const x1 = cx + r1 * Math.cos(ar);
          const y1 = cy + r1 * Math.sin(ar);
          const x2 = cx + r2 * Math.cos(ar);
          const y2 = cy + r2 * Math.sin(ar);
          const color = v > 0.7 ? '#E8C97A'
                      : v > 0.45 ? '#C9963F'
                      : v > 0.20 ? 'rgba(201,150,63,0.5)'
                      : 'rgba(201,150,63,0.15)';
          return (
            <line key={d} x1={x1} y1={y1} x2={x2} y2={y2}
              stroke={color} strokeWidth="0.7" strokeLinecap="round"
              opacity={0.4 + v * 0.6}/>
          );
        })}

        {/* Moon-phase markers — small dots at the outer ring at 13 lunar cycles */}
        {Array.from({length: 13}).map((_, m) => {
          const day = m * (days / 13);
          const a = (day / days) * 360 - 90;
          const ar = a * Math.PI / 180;
          const r = 168;
          const x = cx + r * Math.cos(ar);
          const y = cy + r * Math.sin(ar);
          return (
            <circle key={m} cx={x} cy={y} r="1.5"
              fill="rgba(242,232,217,0.55)"/>
          );
        })}

        {/* Center bindu */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="38" fill="none" stroke="rgba(201,150,63,0.18)" strokeWidth="0.4"/>
          <circle r="9" fill={COLORS.accentRed} opacity="0.85"/>
          <circle r="3" fill={COLORS.cream}/>
        </g>

        {/* Today marker — a small ring */}
        {(() => {
          const today = 264;
          const a = (today / days) * 360 - 90;
          const ar = a * Math.PI / 180;
          const r = 168;
          const x = cx + r * Math.cos(ar);
          const y = cy + r * Math.sin(ar);
          return (
            <g>
              <circle cx={x} cy={y} r="5"
                fill="none" stroke={COLORS.gold} strokeWidth="1"
                style={{ filter: 'drop-shadow(0 0 6px rgba(201,150,63,0.85))' }}/>
              <line x1={cx + 56 * Math.cos(ar)} y1={cy + 56 * Math.sin(ar)}
                    x2={x} y2={y}
                    stroke={COLORS.gold} strokeWidth="0.5" opacity="0.65"/>
            </g>
          );
        })()}

        {/* Season labels */}
        {seasonSectors.map((s, i) => {
          const ar = (s.labelAngle - 90) * Math.PI / 180;
          const r = 195;
          const x = cx + r * Math.cos(ar);
          const y = cy + r * Math.sin(ar);
          return (
            <text key={i} x={x} y={y} textAnchor="middle"
              fontFamily="'Cormorant Garamond', serif"
              fontStyle="italic" fontSize="10"
              fill="rgba(242,232,217,0.40)"
              letterSpacing="2"
              dominantBaseline="middle">{s.label}</text>
          );
        })}
      </svg>

      {/* Bottom — your year-stats */}
      <div style={{
        position: 'absolute', bottom: 84, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 14,
          whiteSpace: 'pre-line',
        }}>{isCurrentYear
          ? `264 days walked.\n${yearTotalRecogs.toLocaleString()} recognitions.\n3 quiet weeks in Hemanta.`
          : `${yearTotalRecogs.toLocaleString()} recognitions.\nyear ${yearOfPractice} of your practice.`}</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>{isCurrentYear ? 'tap any day · open its catches' : 'swipe ← → · navigate years'}</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 6 — TODAY'S TITHI · THE NITYA DEVĪ
// Each lunar day has a presiding goddess — one of the 15 Nityā Devīs.
// Names canonical (sourced from Śrīvidyā tradition · stored in shakti-data).
// Quality + bīja + dhyāna fields flow from Airtable. No invented content.
// ═════════════════════════════════════════════════════════════════════════════

function TithiTodayScreen({ tithiIdx = 13 }) {
  // Find today's Nitya — bounded by the canonical 15
  const nitya = NITYA_DEVIS.find(n => n.tithi === tithiIdx) || NITYA_DEVIS[0];
  // Compute moon illumination as a function of tithi (1 = new, 15 = full)
  const illum = Math.min(1, Math.max(0, (tithiIdx - 0.5) / 14.5));

  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #0A0508 0%, #050103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={6}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7,
        }}>Today's Tithi · Her Nitya Form</div>
      </div>

      {/* Moon glyph — illumination calibrated to the actual tithi */}
      <div style={{
        position: 'absolute', top: 130, left: 0, right: 0,
        display: 'flex', justifyContent: 'center',
      }}>
        <svg width="80" height="80" viewBox="0 0 80 80">
          <circle cx="40" cy="40" r="34" fill="rgba(242,232,217,0.08)"/>
          {/* Bright slice mask based on illumination */}
          <defs>
            <clipPath id="moonClip">
              <rect x={40 - 34 + (1 - illum) * 68} y="0" width="80" height="80"/>
            </clipPath>
          </defs>
          <circle cx="40" cy="40" r="34"
            fill="rgba(242,232,217,0.62)"
            clipPath="url(#moonClip)"
            style={{ filter: 'drop-shadow(0 0 18px rgba(242,232,217,0.5))' }}/>
          <circle cx="40" cy="40" r="34" fill="none"
            stroke="rgba(242,232,217,0.25)" strokeWidth="0.5"/>
        </svg>
      </div>

      {/* Tithi name + position */}
      <div style={{
        position: 'absolute', top: 238, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 38, fontWeight: 300, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.85)',
          letterSpacing: '0.05em', lineHeight: 1,
          marginBottom: 10,
        }}>{nitya.tithiName}</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.6)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
        }}>tithi {nitya.tithi} of 15 · bright fortnight</div>
      </div>

      {/* Divider */}
      <div style={{
        position: 'absolute', top: 332, left: '50%',
        transform: 'translateX(-50%)',
        width: 36, height: 0.5, background: 'rgba(201,150,63,0.4)',
      }}/>

      {/* The Nitya — her canonical name, large */}
      <div style={{
        position: 'absolute', top: 358, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.42)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 14,
        }}>she wears today the form of</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 46, fontWeight: 300, fontStyle: 'italic',
          color: COLORS.gold,
          letterSpacing: '0.04em',
          lineHeight: 1.05,
          textShadow: '0 0 26px rgba(201,150,63,0.5)',
          marginBottom: 20,
        }}>{nitya.name}</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
        }}>{nitya.tithi} of the fifteen nityā devīs</div>
      </div>

      {/* Quality / dhyāna — placeholder for Airtable-fed text */}
      <div style={{
        position: 'absolute', bottom: 140, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        {nitya.quality ? (
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 19, fontStyle: 'italic', fontWeight: 300,
            color: 'rgba(242,232,217,0.78)',
            letterSpacing: '0.02em', lineHeight: 1.55,
          }}>{nitya.quality}</div>
        ) : (
          <>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 9, color: 'rgba(201,150,63,0.32)',
              letterSpacing: '0.28em', textTransform: 'uppercase',
              padding: '12px 22px',
              border: '0.5px dashed rgba(201,150,63,0.18)',
              borderRadius: 14,
              display: 'inline-block',
            }}>her quality flows from Airtable</div>
            <div style={{
              marginTop: 14,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 13, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.32)',
              letterSpacing: '0.02em',
              maxWidth: 280, margin: '14px auto 0',
              lineHeight: 1.6,
            }}>quality · bīja · dhyāna<br/>render here when the database is connected</div>
          </>
        )}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ─── Exports ─────────────────────────────────────────────────────────────────
Object.assign(window, {
  YantraGlyph,
  CosmicNowScreen, LunarYantraScreen, SandhyaScreen,
  SeasonalYantraScreen, GreatWheelScreen, TithiTodayScreen,
});
