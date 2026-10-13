// ─── Bindu Mandala — Expanded Screen Components ──────────────────────────────
// Uses globals from shakti-data.js, all-shaktis-data.js, screens.jsx, mandala-v2.jsx

// ─── Local geometry helpers (scoped to this module) ──────────────────────────

function triPath(R, up = false) {
  const h = +(R * Math.sqrt(3) / 2).toFixed(2), half = +(R / 2).toFixed(2);
  return up ? `M 0,${-R} L ${h},${half} L ${-h},${half} Z`
            : `M 0,${R} L ${h},${-half} L ${-h},${-half} Z`;
}

function bgPetalPath(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1), c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// ─── Background geometry for Avarana Threshold ───────────────────────────────
// Large, faint — the geometric form of the avarana filling the upper screen.

function ThresholdBg({ geometry }) {
  const cx = 195, cy = 310, op = 0.045;

  if (geometry === 'lotus8') {
    const oR = 148, iR = 98, hw = 44;
    const pp = bgPetalPath(oR, iR, hw);
    return (
      <svg style={{ position:'absolute', top:0, left:0, width:'100%', height:'100%',
        pointerEvents:'none' }}>
        <g opacity={op}>
          {[0,45,90,135,180,225,270,315].map((a, i) => (
            <g key={i} transform={`translate(${cx},${cy}) rotate(${a})`}>
              <path d={pp} fill="none" stroke={COLORS.gold} strokeWidth={0.9}/>
            </g>
          ))}
          <circle cx={cx} cy={cy} r={iR + 4} fill="none"
            stroke={COLORS.gold} strokeWidth={0.5}/>
          <circle cx={cx} cy={cy} r={oR + 8} fill="none"
            stroke={COLORS.gold} strokeWidth={0.4}/>
        </g>
      </svg>
    );
  }

  if (geometry === 'tri14') {
    return (
      <svg style={{ position:'absolute', top:0, left:0, width:'100%', height:'100%',
        pointerEvents:'none' }}>
        <g opacity={op} transform={`translate(${cx},${cy})`}>
          {[145, 118, 94].map((r, i) => (
            <React.Fragment key={i}>
              <path d={triPath(r, false)} fill="none" stroke={COLORS.gold}
                strokeWidth={0.8} strokeLinejoin="round"/>
              <path d={triPath(Math.round(r * 0.88), true)} fill="none" stroke={COLORS.gold}
                strokeWidth={0.8} strokeLinejoin="round"/>
            </React.Fragment>
          ))}
        </g>
      </svg>
    );
  }

  return null;
}

// ─── Ring Position Indicator — 9 dots, for Today Screen ──────────────────────

function RingIndicator() {
  const states = [
    { ring:1, status:'ancient',    size:5,  op:0.42, color:'#CF9443' },
    { ring:2, status:'home',       size:7,  op:0.95, color:COLORS.gold, cls:'ring-indicator-home' },
    { ring:3, status:'unlocked',   size:5,  op:0.50, color:COLORS.gold },
    { ring:4, status:'locked',     size:4,  op:0.20, color:COLORS.gold },
    { ring:5, status:'locked',     size:4,  op:0.16, color:COLORS.gold },
    { ring:6, status:'locked',     size:3.5,op:0.13, color:COLORS.gold },
    { ring:7, status:'locked',     size:3.5,op:0.10, color:COLORS.gold },
    { ring:8, status:'deep_ghost', size:3,  op:0.06, color:COLORS.gold },
    { ring:9, status:'deep_ghost', size:3,  op:0.05, color:COLORS.gold },
  ];

  return (
    <div style={{ display:'flex', alignItems:'center', justifyContent:'center',
      gap:10, padding:'8px 0 4px' }}>
      {states.map(({ ring, size, op, color, cls }) => (
        <div key={ring} style={{
          width: size, height: size, borderRadius:'50%',
          background: color, opacity: op,
          flexShrink: 0,
          boxShadow: ring === 2 ? `0 0 8px 2px rgba(201,150,63,0.55)` : 'none',
          animation: ring === 2 ? 'ringIndicatorPulse 3s ease-in-out infinite' : 'none',
        }}/>
      ))}
    </div>
  );
}

// ─── 1. Mandala Screen V2 — The Living Sri Yantra ────────────────────────────

function MandalaScreenV2() {
  return (
    <div style={{ width:390, height:844, background:COLORS.ground,
      display:'flex', flexDirection:'column', overflow:'hidden',
      position:'relative' }}>

      <div style={{
        position:'absolute', inset:0,
        background:`radial-gradient(ellipse 65% 55% at 50% 48%,
          rgba(201,150,63,0.05) 0%, transparent 68%)`,
        pointerEvents:'none',
      }}/>

      <DustMotes count={6}/>
      <StatusBar/>

      {/* Home ring identity */}
      <div style={{ textAlign:'center', padding:'6px 0 2px', zIndex:2,
        fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize:10, color:COLORS.gold, letterSpacing:'0.17em', textTransform:'uppercase',
        opacity:0.85 }}>
        2nd Avaraṇa · Sarvāśā-Paripūraka
      </div>
      <div style={{ textAlign:'center', padding:'0 0 4px', zIndex:2,
        fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize:9, color:'rgba(242,232,217,0.26)', letterSpacing:'0.10em' }}>
        <span style={{ color:'rgba(201,150,63,0.6)' }}>Home</span>
        {'  ·  '}
        <span style={{ color:'rgba(201,150,63,0.4)' }}>Ring 3 Open</span>
        {'  ·  '}
        <span>Rings 4–9 Ahead</span>
      </div>

      {/* The mandala — center of everything */}
      <div style={{ flex:1, display:'flex', alignItems:'center',
        justifyContent:'center', zIndex:2 }}>
        <SriYantraMandala size={344} todayIndex={TODAY_INDEX}/>
      </div>

      {/* Progress */}
      <div style={{ textAlign:'center', padding:'4px 0 4px', zIndex:2,
        fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize:11, color:'rgba(242,232,217,0.36)', letterSpacing:'0.08em' }}>
        <span style={{ color:COLORS.gold }}>{PROGRESS.active}</span>
        {' of '}{PROGRESS.total}{' Active  '}
        <span style={{ opacity:0.3 }}>·  </span>
        <span style={{ color:COLORS.cream, opacity:0.6 }}>{PROGRESS.embodied}</span>
        {' Embodied'}
      </div>

      {/* Cluster legend */}
      <div style={{ display:'flex', justifyContent:'center', flexWrap:'wrap',
        gap:'5px 18px', padding:'2px 24px 4px', zIndex:2 }}>
        {Object.entries(CLUSTER_INFO).map(([k, info]) => (
          <div key={k} style={{ display:'flex', alignItems:'center', gap:5 }}>
            <div style={{ width:5, height:5, borderRadius:'50%',
              background:info.color, boxShadow:`0 0 4px ${info.color}` }}/>
            <span style={{ fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
              fontSize:8.5, color:'rgba(242,232,217,0.38)', letterSpacing:'0.08em' }}>
              {info.label}
            </span>
          </div>
        ))}
      </div>

      {/* Interaction hint */}
      <div style={{ textAlign:'center', padding:'2px 0 8px', zIndex:2,
        fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize:8.5, color:'rgba(242,232,217,0.16)',
        letterSpacing:'0.22em', textTransform:'uppercase' }}>
        Tap to enter · Hold to catch · Bindu for silence
      </div>

      <TabBar active="mandala"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── 2. Avarana Threshold Screen — Sacred Doorway ────────────────────────────
// Shown when the practitioner taps a locked ring.
// The territory names itself. Then it says: you have already been here.

function AvaranaThresholdScreen({ avarana }) {
  if (!avarana) return null;
  const { name, subtitle, form, formDescription, presidingForm, yogini,
          mentalState, chakra, personalConnection, geometry, count } = avarana;

  const isLocked = avarana.status === 'locked' || avarana.status === 'deep_ghost';

  return (
    <div style={{ width:390, height:844,
      background:`linear-gradient(180deg, #060103 0%, ${COLORS.ground} 100%)`,
      display:'flex', flexDirection:'column', overflow:'hidden',
      position:'relative', fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif' }}>

      {/* Background geometry — the form of this avarana, faintly present */}
      <ThresholdBg geometry={geometry}/>
      <DustMotes count={5}/>

      <StatusBar/>

      {/* Back nav */}
      <div style={{ display:'flex', alignItems:'center', padding:'8px 22px 4px',
        color:COLORS.gold, fontSize:13, gap:6, cursor:'pointer', zIndex:2 }}>
        <span style={{ fontSize:18, lineHeight:1 }}>‹</span>
        <span style={{ letterSpacing:'0.06em' }}>Mandala</span>
      </div>

      {/* The territory names itself */}
      <div style={{ padding:'12px 32px 0', zIndex:2 }}>
        {/* Avarana name */}
        <div className="t-line-1" style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:34, fontWeight:300, color:COLORS.gold,
          letterSpacing:'0.08em', lineHeight:1.1, marginBottom:6, opacity:0,
        }}>{name}</div>

        {/* Subtitle */}
        <div className="t-line-2" style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:17, fontStyle:'italic', fontWeight:300,
          color:'rgba(242,232,217,0.55)', letterSpacing:'0.03em',
          marginBottom:18, opacity:0,
        }}>{subtitle}</div>

        {/* Thin divider */}
        <div className="t-line-2" style={{
          width:40, height:0.5,
          background:`rgba(201,150,63,0.4)`,
          marginBottom:20, opacity:0,
        }}/>

        {/* Sequential text lines — no labels, just the values arriving */}
        {[
          { text: form,          style:{ fontSize:15, color:COLORS.cream, opacity:0.82 } },
          { text: presidingForm, style:{ fontSize:14, color:COLORS.cream, opacity:0.60 } },
          { text: yogini,        style:{ fontSize:13, fontStyle:'italic', color:COLORS.cream, opacity:0.48 } },
          { text: mentalState,   style:{ fontSize:13, fontStyle:'italic', color:COLORS.cream, opacity:0.40 } },
          { text: chakra,        style:{ fontSize:12, color:COLORS.gold, opacity:0.45, letterSpacing:'0.1em' } },
        ].map(({ text, style }, i) => (
          <div key={i} className={`t-line-${i + 3}`} style={{
            fontFamily:"'Cormorant Garamond', serif",
            fontWeight:300, marginBottom:12,
            ...style, opacity:0,
          }}>{text}</div>
        ))}
      </div>

      {/* Personal Connection — bottom portion */}
      <div style={{ flex:1, display:'flex', flexDirection:'column',
        justifyContent:'flex-end', padding:'0 32px 20px', zIndex:2 }}>

        {/* Separator */}
        <div className="t-connection" style={{
          width:'100%', height:0.5,
          background:`rgba(201,150,63,0.2)`,
          marginBottom:22, opacity:0,
        }}/>

        {/* The letter */}
        <div className="t-connection" style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:15.5, fontStyle:'italic', fontWeight:300,
          color:'rgba(242,232,217,0.65)',
          lineHeight:1.75, letterSpacing:'0.01em',
          marginBottom:28, opacity:0,
        }}>
          {personalConnection}
        </div>

        {/* The unlock gesture */}
        <button className="t-button" style={{
          width:'100%', height:54, borderRadius:27,
          background: isLocked ? COLORS.accentRed : `rgba(139,26,42,0.7)`,
          border: isLocked ? 'none' : `1px solid rgba(139,26,42,0.4)`,
          color:COLORS.cream,
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:18, fontWeight:300, letterSpacing:'0.14em',
          cursor:'pointer',
          boxShadow: isLocked ? `0 4px 28px rgba(139,26,42,0.4)` : 'none',
          opacity:0,
        }}>Enter this Avaraṇa</button>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ─── 3. Quick Recognition Demo — The Live Catch ───────────────────────────────
// Shows the mandala screen with the recognition overlay risen from the bottom.
// State: just after the circle was tapped — "she felt you back" is appearing.

function QuickRecognitionDemo() {
  const s = TODAY_SHAKTI; // Sparśākarṣiṇī — today's shakti

  return (
    <div style={{ width:390, height:844, background:COLORS.ground,
      position:'relative', overflow:'hidden' }}>

      {/* Mandala dimmed behind — still present, aware of what just happened */}
      <div style={{ position:'absolute', inset:0, display:'flex', flexDirection:'column',
        alignItems:'center', justifyContent:'center', opacity:0.38 }}>
        <SriYantraMandala size={344} todayIndex={TODAY_INDEX}/>
      </div>

      {/* Status bar still visible at top */}
      <div style={{ position:'absolute', top:0, left:0, right:0, zIndex:3 }}>
        <StatusBar/>
      </div>

      {/* The overlay — dark, translucent, rising from bottom */}
      <div className="quick-recog-panel" style={{
        position:'absolute', bottom:0, left:0, right:0,
        height:296,
        background:`linear-gradient(to top, rgba(4,1,4,0.97) 0%, rgba(8,2,6,0.92) 70%, rgba(8,2,6,0.82) 100%)`,
        borderTop:`0.5px solid rgba(201,150,63,0.18)`,
        borderRadius:'16px 16px 0 0',
        display:'flex', flexDirection:'column',
        alignItems:'center', padding:'24px 32px 20px',
        zIndex:2,
      }}>

        {/* Her name — the field has been named */}
        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:36, fontWeight:300, color:COLORS.cream,
          letterSpacing:'0.07em', textAlign:'center',
          lineHeight:1.05, marginBottom:6,
        }}>{s.name}</div>

        {/* Her bija */}
        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:22, fontWeight:300, fontStyle:'italic',
          color:COLORS.gold, opacity:0.75,
          letterSpacing:'0.12em', marginBottom:22,
        }}>{s.bija}</div>

        {/* The recognition circle — tapped, now registering */}
        <div style={{
          width:56, height:56, borderRadius:'50%',
          border:`1px solid rgba(201,150,63,0.65)`,
          background:`rgba(201,150,63,0.08)`,
          display:'flex', alignItems:'center', justifyContent:'center',
          marginBottom:8,
          boxShadow:`0 0 18px rgba(201,150,63,0.22), inset 0 0 8px rgba(201,150,63,0.08)`,
        }}>
          {/* Filled center — registered */}
          <div style={{
            width:14, height:14, borderRadius:'50%',
            background:COLORS.gold, opacity:0.85,
            boxShadow:`0 0 10px rgba(201,150,63,0.7)`,
          }}/>
        </div>

        {/* "She felt you back" — the bilateral recognition, ~1.5s after tap */}
        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:14, fontStyle:'italic', fontWeight:300,
          color:COLORS.gold, letterSpacing:'0.05em',
          opacity:0.88, textAlign:'center', marginTop:4,
        }}>and she felt you back</div>

        {/* Logged timestamp */}
        <div style={{
          fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
          fontSize:10, color:'rgba(242,232,217,0.28)',
          letterSpacing:'0.14em', textTransform:'uppercase',
          marginTop:8,
        }}>LOGGED · 2:41 PM</div>
      </div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── 4. Today Screen V3 — With Ring Position Indicator ───────────────────────

function TodayScreenV3() {
  const s = TODAY_SHAKTI;
  const clusterColor = CLUSTER_INFO[s.cluster].color;

  return (
    <div style={{ width:390, height:844, background:COLORS.ground,
      display:'flex', flexDirection:'column', overflow:'hidden',
      position:'relative' }}>

      {/* Bija texture — ambient background */}
      <div style={{
        position:'absolute', top:'50%', left:'50%',
        transform:'translate(-50%,-53%)',
        fontFamily:"'Cormorant Garamond', serif",
        fontSize:280, fontWeight:300,
        color:COLORS.gold, opacity:0.065,
        userSelect:'none', pointerEvents:'none', lineHeight:1,
      }}>{s.bija}</div>

      <div style={{
        position:'absolute', inset:0,
        background:`radial-gradient(ellipse 55% 50% at 50% 42%,
          rgba(139,26,42,0.18) 0%, transparent 68%)`,
        pointerEvents:'none',
      }}/>

      <DustMotes count={9}/>
      <StatusBar/>

      {/* Moon */}
      <div style={{ padding:'8px 0 10px', position:'relative', zIndex:2 }}>
        <MoonPhase/>
      </div>

      {/* Main content */}
      <div style={{ flex:1, display:'flex', flexDirection:'column',
        alignItems:'center', padding:'0 36px',
        justifyContent:'center', zIndex:2 }}>

        <div style={{ marginBottom:18 }}><ClusterDot shakti={s}/></div>

        <div className="today-name-anim" style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:48, fontWeight:300, color:COLORS.cream,
          letterSpacing:'0.07em', textAlign:'center',
          lineHeight:1.05, marginBottom:11,
        }}>{s.name}</div>

        <div style={{
          fontSize:12, color:'rgba(242,232,217,0.40)',
          letterSpacing:'0.20em', textTransform:'uppercase',
          marginBottom:20,
        }}>{s.phonetic}</div>

        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:22, fontWeight:400, color:COLORS.gold,
          letterSpacing:'0.04em', textAlign:'center',
          marginBottom:26,
        }}>{s.quality}</div>

        <div style={{ width:48, height:0.5, background:`rgba(201,150,63,0.35)`,
          marginBottom:26 }}/>

        <div className="today-prompt-anim" style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:20, fontStyle:'italic',
          color:'rgba(242,232,217,0.75)',
          textAlign:'center', lineHeight:1.70,
          letterSpacing:'0.02em', marginBottom:28,
        }}>"{s.somatic}"</div>

        {/* Bija */}
        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:40, fontWeight:300, color:COLORS.gold,
          opacity:0.58, letterSpacing:'0.1em', marginBottom:5,
        }}>{s.bija}</div>
        <div style={{
          fontSize:9.5, color:'rgba(242,232,217,0.28)',
          letterSpacing:'0.22em', textTransform:'uppercase',
          marginBottom:4,
        }}>Bīja</div>
      </div>

      {/* Button area — with ring indicator above */}
      <div style={{ padding:'0 24px 14px', flexShrink:0, zIndex:2 }}>

        {/* Ring Position Indicator — subtle anchor to the game */}
        <RingIndicator/>

        {/* Avarana label beneath dots */}
        <div style={{
          textAlign:'center', marginBottom:14,
          fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
          fontSize:9, color:'rgba(201,150,63,0.35)',
          letterSpacing:'0.14em', textTransform:'uppercase',
        }}>2nd Avaraṇa</div>

        <button style={{
          width:'100%', height:56, borderRadius:28,
          background:COLORS.accentRed, border:'none',
          color:COLORS.cream,
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:20, fontWeight:400, letterSpacing:'0.12em',
          cursor:'pointer',
          boxShadow:`0 4px 32px rgba(139,26,42,0.45)`,
        }}>I feel her</button>
      </div>

      <TabBar active="today"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── 5. Shakti Detail V2 — Expanded Vocabulary ───────────────────────────────
// Five new fields added as reading experience, not a data list.

function ShaktiDetailScreenV2() {
  const s = SHAKTIS[13]; // Ātmākarṣiṇī
  const clusterColor = CLUSTER_INFO[s.cluster].color;
  const [cr, cg, cb] = [
    parseInt(clusterColor.slice(1,3),16),
    parseInt(clusterColor.slice(3,5),16),
    parseInt(clusterColor.slice(5,7),16),
  ];

  // Extended fields — the full vocabulary
  const ext = {
    etymology: 'Ātma (Self) + ākarṣiṇī (She who attracts) — She who draws the very Self into continuous recognition',
    appreciationPhrase: 'Thank you for returning me to what I am before I am anything.',
    family: 'Ātmā — the primal Self-luminosity. Ground of all the Karṣiṇīs, prior to every experience.',
    function: 'She draws awareness back to its unlocated source — the recognition that precedes all others.',
    khadgamalaPos: 14,
  };

  const statusColors = {
    mapped:'rgba(242,232,217,0.35)', exploring:'rgba(201,150,63,0.55)',
    active:COLORS.gold, embodied:'#D4A017',
  };
  const statusLabels = { mapped:'Mapped', exploring:'Exploring', active:'Active', embodied:'Embodied' };

  return (
    <div style={{ width:390, height:844, background:COLORS.ground,
      display:'flex', flexDirection:'column', overflow:'hidden',
      position:'relative' }}>

      <StatusBar/>

      {/* Navigation */}
      <div style={{
        display:'flex', alignItems:'center', justifyContent:'space-between',
        padding:'6px 20px 10px',
        borderBottom:'0.5px solid rgba(201,150,63,0.12)', flexShrink:0,
      }}>
        <div style={{ display:'flex', alignItems:'center', gap:6,
          color:COLORS.gold, fontSize:13, cursor:'pointer' }}>
          <span style={{ fontSize:18, lineHeight:1 }}>‹</span>
          <span style={{ letterSpacing:'0.06em' }}>Mandala</span>
        </div>
        <svg width="26" height="34" viewBox="0 0 26 34">
          <path d="M13,3 C18,7.5 19,16 13,31 C8,16 9,7.5 13,3Z"
            fill={clusterColor} opacity="0.85"/>
        </svg>
      </div>

      {/* Header — name + etymology + phonetic */}
      <div style={{ padding:'16px 26px 14px',
        borderBottom:'0.5px solid rgba(201,150,63,0.10)', flexShrink:0 }}>

        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:34, fontWeight:300, color:COLORS.cream,
          letterSpacing:'0.06em', lineHeight:1.1, marginBottom:5,
        }}>{s.name}</div>

        {/* Etymology — just below the name, before phonetic */}
        <div style={{
          fontFamily:"'Cormorant Garamond', serif",
          fontSize:12.5, fontWeight:300,
          color:`rgba(${cr},${cg},${cb},0.55)`,
          letterSpacing:'0.02em', lineHeight:1.5,
          marginBottom:10, fontStyle:'italic',
        }}>{ext.etymology}</div>

        <div style={{
          fontSize:11, color:'rgba(242,232,217,0.38)',
          letterSpacing:'0.18em', textTransform:'uppercase', marginBottom:12,
        }}>{s.phonetic}</div>

        <div style={{ display:'flex', alignItems:'center', gap:10 }}>
          <ClusterDot shakti={s}/>
          <div style={{
            padding:'3px 12px', borderRadius:12,
            border:`1px solid ${statusColors[s.status]}`,
            fontSize:10, color:statusColors[s.status],
            letterSpacing:'0.14em', textTransform:'uppercase',
          }}>{statusLabels[s.status]}</div>
          {/* Khadgamala position — subtle, precise */}
          <div style={{
            marginLeft:'auto', fontSize:10,
            color:'rgba(242,232,217,0.28)', letterSpacing:'0.08em',
          }}>Pos. {ext.khadgamalaPos} · 102</div>
        </div>
      </div>

      {/* Scrollable body */}
      <div style={{ flex:1, overflowY:'auto', padding:'0 26px' }}>

        {/* Quality */}
        <div style={{ padding:'18px 0 0' }}>
          <div style={sectionLabel}>Quality</div>
          <div style={{
            fontFamily:"'Cormorant Garamond', serif",
            fontSize:19, fontWeight:300, color:COLORS.gold,
            letterSpacing:'0.02em', marginBottom:8,
          }}>{s.quality}</div>
          <div style={{ fontSize:14, lineHeight:1.75,
            color:'rgba(242,232,217,0.62)', letterSpacing:'0.01em',
          }}>{s.description}</div>
        </div>

        {/* Somatic Signature */}
        <div style={{ padding:'18px 0 0' }}>
          <div style={sectionLabel}>Somatic Signature</div>
          <div style={{
            fontFamily:"'Cormorant Garamond', serif",
            fontSize:17, fontStyle:'italic', fontWeight:300,
            color:'rgba(242,232,217,0.72)', lineHeight:1.8,
            whiteSpace:'pre-line',
          }}>{s.somaticPoetry}</div>
        </div>

        {/* Appreciation Phrase — no section label, it stands alone */}
        <div style={{ padding:'20px 0 0', textAlign:'center' }}>
          <div style={{ width:32, height:0.5,
            background:'rgba(201,150,63,0.3)', margin:'0 auto 16px' }}/>
          <div style={{
            fontFamily:"'Cormorant Garamond', serif",
            fontSize:16, fontStyle:'italic', fontWeight:300,
            color:COLORS.gold, letterSpacing:'0.04em', lineHeight:1.65,
          }}>{ext.appreciationPhrase}</div>
        </div>

        {/* Bija */}
        <div style={{ padding:'20px 0 0', textAlign:'center' }}>
          <div style={sectionLabel}>Bīja Syllable · Tap to Hear</div>
          <div style={{ display:'flex', alignItems:'center', justifyContent:'center', gap:18 }}>
            <div style={{
              fontFamily:"'Cormorant Garamond', serif",
              fontSize:68, fontWeight:300, color:COLORS.gold, lineHeight:1,
              textShadow:`0 0 30px rgba(201,150,63,0.38)`,
            }}>{s.bija}</div>
            <div style={{ position:'relative', width:44, height:44 }}>
              <div style={{
                position:'absolute', inset:0, borderRadius:'50%',
                border:`1px solid rgba(201,150,63,0.55)`,
                background:'rgba(201,150,63,0.05)',
                display:'flex', alignItems:'center', justifyContent:'center',
                cursor:'pointer',
              }}>
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                  <path d="M3,2 L11,7 L3,12 Z" fill={COLORS.gold} opacity="0.85"/>
                </svg>
              </div>
              <div style={{ position:'absolute', inset:-6, borderRadius:'50%',
                border:'0.5px solid rgba(201,150,63,0.22)', pointerEvents:'none' }}/>
            </div>
          </div>
        </div>

        {/* Shakti Family */}
        <div style={{ padding:'18px 0 0' }}>
          <div style={sectionLabel}>Lineage</div>
          <div style={{ fontSize:13.5, lineHeight:1.65,
            color:'rgba(242,232,217,0.58)', letterSpacing:'0.01em',
            fontFamily:"'Cormorant Garamond', serif", fontStyle:'italic',
          }}>{ext.family}</div>
        </div>

        {/* Function */}
        <div style={{ padding:'16px 0 0' }}>
          <div style={sectionLabel}>Cosmic Function</div>
          <div style={{ fontSize:13.5, lineHeight:1.65,
            color:'rgba(242,232,217,0.58)', letterSpacing:'0.01em',
          }}>{ext.function}</div>
        </div>

        {/* Tattva */}
        <div style={{ padding:'16px 0 0' }}>
          <div style={sectionLabel}>Esoteric Tattva</div>
          <div style={{ display:'flex', alignItems:'center', gap:10 }}>
            <div style={{
              width:26, height:26, borderRadius:'50%',
              background:`rgba(${cr},${cg},${cb},0.12)`,
              border:`1px solid rgba(${cr},${cg},${cb},0.28)`,
              display:'flex', alignItems:'center', justifyContent:'center',
            }}>
              <div style={{ width:9, height:9, borderRadius:'50%',
                background:clusterColor, opacity:0.8 }}/>
            </div>
            <span style={{ fontSize:14, color:'rgba(242,232,217,0.68)',
              letterSpacing:'0.04em' }}>{s.tattva}</span>
          </div>
        </div>

        {/* Field Connection */}
        {s.fieldConnection && (
          <div style={{
            margin:'18px 0 0', padding:'14px 16px',
            background:`rgba(${cr},${cg},${cb},0.07)`,
            borderRadius:10,
            borderLeft:`2px solid rgba(${cr},${cg},${cb},0.32)`,
          }}>
            <div style={{ ...sectionLabel, marginBottom:7 }}>
              Field Connection — {s.fieldConnection.field}
            </div>
            <div style={{
              fontFamily:"'Cormorant Garamond', serif",
              fontSize:14.5, fontStyle:'italic', fontWeight:300,
              color:'rgba(242,232,217,0.62)', lineHeight:1.7,
            }}>{s.fieldConnection.note}</div>
          </div>
        )}

        {/* Recognition Log */}
        <div style={{ padding:'18px 0 0' }}>
          <div style={sectionLabel}>Recognition Log</div>
          {[
            { time:'Today, 9:14 AM', note:'Morning light on hands' },
            { time:'May 17, 8:41 PM', note:null },
            { time:'May 14, 2:33 PM', note:'In the garden — extraordinary' },
          ].map((entry, i) => (
            <div key={i} style={{
              display:'flex', alignItems:'flex-start', gap:13, padding:'9px 0',
              borderBottom:i < 2 ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
            }}>
              <div style={{ width:5, height:5, borderRadius:'50%',
                background:clusterColor, marginTop:5, flexShrink:0, opacity:0.65 }}/>
              <div>
                <div style={{ fontSize:12, color:'rgba(242,232,217,0.36)',
                  letterSpacing:'0.06em', marginBottom:2 }}>{entry.time}</div>
                {entry.note && <div style={{ fontSize:12.5,
                  color:'rgba(242,232,217,0.56)', fontStyle:'italic' }}>{entry.note}</div>}
              </div>
            </div>
          ))}
        </div>

        <div style={{ height:24 }}/>
      </div>

      <TabBar active="mandala"/>
      <HomeIndicator/>
    </div>
  );
}

// ─── 6. Silence Screen V2 — Multi-Ring Star Field ────────────────────────────
// As more avaranas unlock, the Silence grows richer.
// Ring 3's Ananga names appear as a second orbital closer to the Bindu.

function SilenceScreenV2() {
  const cx = 195, cy = 422;
  const r2 = 156; // Ring 2 names (existing)
  const r3 = 108; // Ring 3 names (new, closer to center)

  return (
    <div style={{ width:390, height:844, background:'#040104',
      position:'relative', overflow:'hidden' }}>

      {/* Vignette */}
      <div style={{
        position:'absolute', inset:0,
        background:`radial-gradient(ellipse 70% 60% at 50% 50%,
          transparent 0%, rgba(0,0,0,0.70) 100%)`,
        pointerEvents:'none',
      }}/>

      {/* Ring 2 — 16 names at their orbital distance */}
      {SHAKTIS.map((s, i) => {
        const angle = (i * 22.5 - 90) * Math.PI / 180;
        const x = cx + r2 * Math.cos(angle);
        const y = cy + r2 * Math.sin(angle);
        const rot = i * 22.5;
        return (
          <div key={s.id} className="silence-name" style={{
            position:'absolute', left:x, top:y,
            transform:`translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily:"'Cormorant Garamond', serif",
            fontSize:11, fontStyle:'italic', fontWeight:300,
            color:'rgba(242,232,217,0.16)',
            letterSpacing:'0.18em', whiteSpace:'nowrap',
            opacity:0,
            animationDelay:`${0.12 + i * 0.12}s`,
            textShadow:'0 0 8px rgba(201,150,63,0.14)',
          }}>{s.short}</div>
        );
      })}

      {/* Ring 3 — 8 Ananga names at closer orbital */}
      {RING3_SHAKTIS.map((s, i) => {
        const angle = (i * 45 - 90) * Math.PI / 180;
        const x = cx + r3 * Math.cos(angle);
        const y = cy + r3 * Math.sin(angle);
        const rot = i * 45;
        return (
          <div key={s.id} className="silence-name" style={{
            position:'absolute', left:x, top:y,
            transform:`translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily:"'Cormorant Garamond', serif",
            fontSize:10, fontStyle:'italic', fontWeight:300,
            color:'rgba(242,232,217,0.11)',
            letterSpacing:'0.14em', whiteSpace:'nowrap',
            opacity:0,
            animationDelay:`${0.30 + i * 0.18}s`,
            textShadow:'0 0 6px rgba(201,150,63,0.10)',
          }}>{s.short}</div>
        );
      })}

      {/* Outer geometry — three faint rings */}
      <svg width="390" height="844"
        style={{ position:'absolute', inset:0, pointerEvents:'none' }}>
        <circle cx={cx} cy={cy} r="196" fill="none"
          stroke="rgba(201,150,63,0.05)" strokeWidth="0.5"/>
        <circle cx={cx} cy={cy} r="218" fill="none"
          stroke="rgba(201,150,63,0.04)" strokeWidth="0.5"
          strokeDasharray="2 8"/>
        <circle cx={cx} cy={cy} r="240" fill="none"
          stroke="rgba(201,150,63,0.03)" strokeWidth="0.5"/>
        {/* Inner ring boundary (ring 3 orbital) */}
        <circle cx={cx} cy={cy} r="90" fill="none"
          stroke="rgba(201,150,63,0.04)" strokeWidth="0.4"/>
      </svg>

      {/* Bindu — 78px, slightly larger (second ring has unlocked) */}
      <div style={{
        position:'absolute', top:cy, left:cx,
        transform:'translate(-50%,-50%)',
      }}>
        <div style={{
          position:'absolute', top:'50%', left:'50%',
          transform:'translate(-50%,-50%)',
          width:134, height:134, borderRadius:'50%',
          border:'0.5px solid rgba(201,150,63,0.18)',
        }}/>
        <div className="silence-bindu" style={{
          width:78, height:78, borderRadius:'50%',
          background:`radial-gradient(circle, ${COLORS.accentRed} 0%,
            rgba(139,26,42,0.7) 60%, transparent 100%)`,
          position:'relative',
        }}>
          <div style={{
            position:'absolute', top:'50%', left:'50%',
            transform:'translate(-50%,-50%)',
            width:21, height:21, borderRadius:'50%',
            background:COLORS.cream,
            boxShadow:`0 0 22px ${COLORS.cream}, 0 0 44px rgba(242,232,217,0.45)`,
            opacity:0.96,
          }}/>
        </div>
      </div>

      {/* Caption — all of her, here, always */}
      <div className="silence-caption" style={{
        position:'absolute', top:cy + 224, left:0, right:0,
        textAlign:'center',
        fontFamily:"'Cormorant Garamond', serif",
        fontSize:18, fontStyle:'italic', fontWeight:300,
        color:'rgba(242,232,217,0.52)',
        letterSpacing:'0.06em', opacity:0,
      }}>All of her. Here. Always.</div>

      <div style={{
        position:'absolute', bottom:38, left:0, right:0, textAlign:'center',
        fontFamily:'-apple-system, BlinkMacSystemFont, sans-serif',
        fontSize:9, color:'rgba(242,232,217,0.13)',
        letterSpacing:'0.28em', textTransform:'uppercase',
      }}>Tap to return</div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── Exports ──────────────────────────────────────────────────────────────────
Object.assign(window, {
  RingIndicator, AvaranaThresholdScreen,
  MandalaScreenV2, QuickRecognitionDemo,
  TodayScreenV3, ShaktiDetailScreenV2, SilenceScreenV2,
});
