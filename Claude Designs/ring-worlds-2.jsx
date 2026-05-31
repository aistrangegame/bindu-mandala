// ─── Ring Worlds II — Phase 3b ───────────────────────────────────────────────
// The rings that were deferred, each finding its own experiential form.
//
// RING 1 — Bhūpura · the Earth-City (the outer ground, the world made visible)
//   The three families ARE the three nested squares:
//     · 10 Siddhi  on the outer line  — the powers · accomplishment · work
//     · 8 Mātṛkā   on the middle line — the mothers · language · family
//     · 10 Mudrā   on the inner line  — the seals · gesture · body
//   The ground does not breathe. It holds. A low Mūlādhāra drone, four gates
//   where the world enters, and 28 lights you have walked among without knowing.
//
// Depends on globals: COLORS, RING1_SHAKTIS, AVARANAS (plain scripts),
// and DustMotes / StatusBar / HomeIndicator (screens.jsx). ReturnGesture is
// defined locally so this file is independent of ring-worlds.jsx load order.

// ─── Local chrome ─────────────────────────────────────────────────────────────

function ReturnArc({ color = 'rgba(207,148,67,0.34)' }) {
  return (
    <div style={{
      position: 'absolute', top: 56, left: '50%',
      transform: 'translateX(-50%)', pointerEvents: 'none', zIndex: 3,
    }}>
      <svg width="80" height="14" viewBox="0 0 80 14">
        <path d="M 8,11 Q 40,3 72,11" fill="none"
          stroke={color} strokeWidth="0.7" strokeLinecap="round"/>
      </svg>
    </div>
  );
}

// ─── Ground drone — a single sustained Mūlādhāra tone ────────────────────────
// One shared instance across all artboards; refless toggle.

let __groundCtx = null;
let __drone = null; // { osc1, osc2, gain }

function groundAudio() {
  if (!__groundCtx && typeof window !== 'undefined') {
    const C = window.AudioContext || window.webkitAudioContext;
    if (C) __groundCtx = new C();
  }
  return __groundCtx;
}

function startDrone() {
  const ctx = groundAudio();
  if (!ctx || __drone) return;
  if (ctx.state === 'suspended') ctx.resume();
  const now = ctx.currentTime;
  const gain = ctx.createGain();
  gain.gain.setValueAtTime(0, now);
  gain.gain.linearRampToValueAtTime(0.05, now + 2.2);
  gain.connect(ctx.destination);
  // root + a fifth above — the ground tone, low and warm
  const osc1 = ctx.createOscillator();
  osc1.type = 'sine'; osc1.frequency.value = 73.42;   // ~ low D
  const osc2 = ctx.createOscillator();
  osc2.type = 'sine'; osc2.frequency.value = 110.0;    // a fifth
  const g2 = ctx.createGain(); g2.gain.value = 0.4;
  osc1.connect(gain); osc2.connect(g2); g2.connect(gain);
  // a slow breathing of the drone's amplitude — the world turning, almost still
  const lfo = ctx.createOscillator(); lfo.type = 'sine'; lfo.frequency.value = 0.07;
  const lfoG = ctx.createGain(); lfoG.gain.value = 0.018;
  lfo.connect(lfoG); lfoG.connect(gain.gain);
  osc1.start(now); osc2.start(now); lfo.start(now);
  __drone = { osc1, osc2, lfo, gain };
}

function stopDrone() {
  const ctx = groundAudio();
  if (!ctx || !__drone) return;
  const now = ctx.currentTime;
  const d = __drone; __drone = null;
  try {
    d.gain.gain.cancelScheduledValues(now);
    d.gain.gain.setValueAtTime(d.gain.gain.value, now);
    d.gain.gain.linearRampToValueAtTime(0, now + 1.4);
    d.osc1.stop(now + 1.5); d.osc2.stop(now + 1.5); d.lfo.stop(now + 1.5);
  } catch (e) {}
}

// ─── Geometry — points evenly distributed on a square's perimeter ────────────

function squarePoints(half, n) {
  const per = 8 * half, pts = [];
  for (let i = 0; i < n; i++) {
    const d = (((i + 0.5) / n) * per) % per;
    let x, y;
    if (d < 2 * half)      { x = -half + d;            y = -half; }
    else if (d < 4 * half) { x = half;                 y = -half + (d - 2 * half); }
    else if (d < 6 * half) { x = half - (d - 4 * half); y = half; }
    else                   { x = -half;                y = half - (d - 6 * half); }
    pts.push([x, y]);
  }
  return pts;
}

// ─── The three families — canonical, with the lived weight named ─────────────

const R1_FAMILIES = {
  siddhi: {
    key: 'siddhi', label: 'Siddhi', english: 'the ten powers · accomplishment',
    color: '#D9A93C',
    lived: 'Ten powers of accomplishment. You have known these as work — the thing that got done, the will that held through the night. Every accomplishment was already hers.',
  },
  matrka: {
    key: 'matrka', label: 'Mātṛkā', english: 'the eight mothers · language',
    color: '#CF9443',
    lived: 'Eight mothers — language itself. You have known these as family, as the mother-tongue, as every name spoken in love. The world was spoken before it was seen.',
  },
  mudra: {
    key: 'mudra', label: 'Mudrā', english: 'the ten seals · gesture',
    color: '#B07F36',
    lived: 'Ten seals — the gestures of the body. You have known these as the body — the reach, the grip, the hand that shaped a whole life. Matter became sacred in the moving.',
  },
};

// Quality lines — concise, canonical meanings (not invented; the traditional
// senses of the aṇimādi siddhis, the eight mātṛkās, the mudrā-śaktis).
const R1_QUALITY = {
  // 10 Siddhi
  1:  'the power to grow infinitely small — to enter the atom of a moment',
  2:  'weightlessness — to be unburdened by what you carry',
  3:  'the power to grow vast — to contain more than your form',
  4:  'sovereignty — to preside over what is yours',
  5:  'mastery — the world arranging itself around your steadiness',
  6:  'irresistible will — a wanting that meets no wall',
  7:  'fruition — the right to enjoy what has ripened',
  8:  'the wish answered before it is spoken',
  9:  'reach — to arrive anywhere without moving',
  10: 'the garland of all desires, each one already granted',
  // 8 Mātṛkā
  11: 'the first sound — she who speaks the world into vowels',
  12: 'the great voice — speech as sovereign power',
  13: 'the ever-young syllable — speech before it was taught',
  14: 'the sustaining word — language that holds the world together',
  15: 'the rooting tongue — speech that digs into the earth of meaning',
  16: 'the radiant utterance — language that rules from the height',
  17: 'the fierce syllable — the word that ends what must end',
  18: 'the abundant word — speech that pours itself into form',
  // 10 Mudrā
  19: 'the seal that stirs — the gesture that wakes the still',
  20: 'the seal that scatters — the gesture that disperses what clings',
  21: 'the seal that draws — the gesture of attraction itself',
  22: 'the seal that gladdens — the gesture that floods with delight',
  23: 'the seal that enchants — the gesture that suspends the mind',
  24: 'the seal that arrests — the gesture that holds time still',
  25: 'the seal that opens — the great yawn of space',
  26: 'the seal that masters — the gesture that brings all under one will',
  27: 'the seal that colours — the gesture that tints the world with feeling',
  28: 'the seal that maddens — the gesture of divine intoxication',
};

function familyOf(pos) {
  if (pos <= 10) return 'siddhi';
  if (pos <= 18) return 'matrka';
  return 'mudra';
}

// ═════════════════════════════════════════════════════════════════════════════
// RING 1 WORLD — THE EARTH-CITY
// ═════════════════════════════════════════════════════════════════════════════

function RingOneWorld({ initialFamily = null, initialMet = null, initialAllLit = false }) {
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 348;

  // three nested squares — the three families
  const outerHalf = 150, midHalf = 110, innerHalf = 72;
  const gateOut = 18;        // how far the T-gates protrude past the outer line

  // 28 lights: 10 outer (siddhi), 8 mid (matrka), 10 inner (mudra)
  const seats = React.useMemo(() => {
    const list = (typeof RING1_SHAKTIS !== 'undefined' ? RING1_SHAKTIS : []);
    const outer = squarePoints(outerHalf, 10);
    const mid   = squarePoints(midHalf, 8);
    const inner = squarePoints(innerHalf, 10);
    return list.map((s) => {
      const fam = familyOf(s.pos);
      let pt;
      if (fam === 'siddhi') pt = outer[s.pos - 1];
      else if (fam === 'matrka') pt = mid[s.pos - 11];
      else pt = inner[s.pos - 19];
      return { ...s, fam, x: cx + pt[0], y: cy + pt[1],
        quality: R1_QUALITY[s.pos] };
    });
  }, []);

  const [focusFam, setFocusFam] = React.useState(initialFamily);
  const [met, setMet] = React.useState(
    initialMet != null ? seats.find((s) => s.pos === initialMet) || null : null);
  const [allLit, setAllLit] = React.useState(initialAllLit);
  const [sound, setSound] = React.useState(false);

  React.useEffect(() => () => stopDrone(), []);

  function ensureSound() {
    if (!sound) { startDrone(); setSound(true); }
  }
  function toggleSound(e) {
    e && e.stopPropagation();
    if (sound) { stopDrone(); setSound(false); }
    else { startDrone(); setSound(true); }
  }

  function meet(s, e) {
    e && e.stopPropagation();
    ensureSound();
    setAllLit(false);
    setMet(s);
    setFocusFam(s.fam);
  }
  function focusFamily(key, e) {
    e && e.stopPropagation();
    ensureSound();
    setAllLit(false);
    setMet(null);
    setFocusFam((prev) => (prev === key ? null : key));
  }
  function ignite(e) {
    e && e.stopPropagation();
    ensureSound();
    setMet(null);
    setFocusFam(null);
    setAllLit(true);
  }
  function release() {
    setAllLit(false);
    setMet(null);
    setFocusFam(null);
  }

  // square stroke opacity given focus state
  const squareOp = (fam) => {
    if (allLit) return 0.5;
    if (!focusFam) return 0.24;
    return focusFam === fam ? 0.52 : 0.07;
  };

  // a light's opacity / radius
  const lightStyle = (s) => {
    const isMet = met && met.id === s.id;
    let op, r, glow;
    if (isMet)            { op = 1;    r = 5.4; glow = 13; }
    else if (allLit)      { op = 0.96; r = 3.4; glow = 9; }
    else if (focusFam) {
      if (s.fam === focusFam) { op = 0.92; r = 3.6; glow = 8; }
      else                    { op = 0.10; r = 2.0; glow = 0; }
    } else                { op = 0.52; r = 2.8; glow = 4; }
    return { op, r, glow };
  };

  // The square path, optionally with T-gates broken into the outer line.
  const sq = (half) =>
    `M ${cx - half},${cy - half} H ${cx + half} V ${cy + half} H ${cx - half} Z`;

  // The four T-gates on the outer square (top, right, bottom, left)
  const gates = [
    { id: 'top',    x: cx,            y: cy - outerHalf, dx: 0,  dy: -1 },
    { id: 'right',  x: cx + outerHalf, y: cy,            dx: 1,  dy: 0 },
    { id: 'bottom', x: cx,            y: cy + outerHalf, dx: 0,  dy: 1 },
    { id: 'left',   x: cx - outerHalf, y: cy,            dx: -1, dy: 0 },
  ];

  const activeFam = focusFam ? R1_FAMILIES[focusFam] : null;

  return (
    <div
      onClick={release}
      style={{
        width: screenW, height: screenH,
        background: 'linear-gradient(180deg, #0C0703 0%, #080402 55%, #060301 100%)',
        position: 'relative', overflow: 'hidden', cursor: 'default',
      }}>

      {/* warm earth ambient — low and grounded, weighted to the base */}
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        background: `radial-gradient(ellipse 78% 62% at 50% 62%,
          rgba(207,148,67,0.11) 0%, rgba(139,90,40,0.05) 46%, transparent 76%)`,
      }}/>
      <DustMotes count={9}/>

      <StatusBar/>
      <ReturnArc/>

      {/* Ring identity */}
      <div style={{
        position: 'absolute', top: 90, left: 0, right: 0, textAlign: 'center', zIndex: 3,
        fontFamily: "'Cormorant Garamond', serif", pointerEvents: 'none',
      }}>
        <div style={{
          fontSize: 14, fontStyle: 'italic', color: 'rgba(217,169,60,0.62)',
          letterSpacing: '0.20em',
        }}>Trailokyamohana · the Earth-City</div>
        <div style={{
          marginTop: 5, fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
          fontFamily: '-apple-system, sans-serif',
        }}>28 forces · the outer ground</div>
      </div>

      {/* The earth-city */}
      <svg width={screenW} height={screenH} viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* faint path inward — the distant lotus & bindu, the way in */}
        <g transform={`translate(${cx},${cy})`} opacity={allLit ? 0.06 : 0.12}
          style={{ transition: 'opacity 1.2s ease', pointerEvents: 'none' }}>
          <circle r={46} fill="none" stroke="rgba(201,150,63,0.5)" strokeWidth="0.4"/>
          <circle r={32} fill="none" stroke="rgba(201,150,63,0.4)" strokeWidth="0.4"/>
        </g>
        {/* the distant bindu — a far ember at the heart of the ground */}
        <circle cx={cx} cy={cy} r="3.4" fill={COLORS.accentRed}
          className="rw1-far-bindu" opacity="0.5" style={{ pointerEvents: 'none' }}/>

        {/* the three family squares */}
        {[['mudra', innerHalf], ['matrka', midHalf], ['siddhi', outerHalf]].map(([fam, half]) => (
          <path key={fam} d={sq(half)} fill="none"
            stroke={R1_FAMILIES[fam].color} strokeWidth="0.8"
            strokeLinejoin="miter"
            opacity={squareOp(fam)}
            style={{ transition: 'opacity 1s ease' }}/>
        ))}

        {/* four T-gates on the outer square — where the world enters */}
        {gates.map((g) => {
          // build a T-gate: a short outward stem + a lintel bar across it
          const sx = g.x + g.dx * gateOut, sy = g.y + g.dy * gateOut;
          // lintel runs perpendicular to (dx,dy)
          const px = -g.dy, py = g.dx;
          const halfBar = 15;
          const lit = allLit;
          return (
            <g key={g.id}
              onClick={ignite}
              style={{ cursor: 'pointer' }}
              className="rw1-gate">
              {/* invisible larger hit area */}
              <rect x={Math.min(g.x, sx) - 16} y={Math.min(g.y, sy) - 16}
                width={Math.abs(sx - g.x) + 32} height={Math.abs(sy - g.y) + 32}
                fill="transparent"/>
              <line x1={g.x} y1={g.y} x2={sx} y2={sy}
                stroke={R1_FAMILIES.siddhi.color}
                strokeWidth="0.9" opacity={lit ? 0.7 : 0.4}
                style={{ transition: 'opacity 1s ease' }}/>
              <line x1={sx + px * halfBar} y1={sy + py * halfBar}
                x2={sx - px * halfBar} y2={sy - py * halfBar}
                stroke={R1_FAMILIES.siddhi.color}
                strokeWidth="0.9" opacity={lit ? 0.7 : 0.4}
                style={{ transition: 'opacity 1s ease' }}/>
              {/* threshold ember at the gate mouth */}
              <circle cx={sx} cy={sy} r="2.4" fill={R1_FAMILIES.siddhi.color}
                className="rw1-gate-ember"
                opacity={lit ? 0.9 : 0.5}/>
            </g>
          );
        })}

        {/* the 28 lights */}
        {seats.map((s) => {
          const { op, r, glow } = lightStyle(s);
          const isMet = met && met.id === s.id;
          return (
            <g key={s.id}
              onClick={(e) => meet(s, e)}
              style={{ cursor: 'pointer' }}>
              {/* hit area */}
              <circle cx={s.x} cy={s.y} r="13" fill="transparent"/>
              {glow > 0 && (
                <circle cx={s.x} cy={s.y} r={r + 3} fill={R1_FAMILIES[s.fam].color}
                  opacity={op * 0.3}
                  style={{ filter: `blur(${glow * 0.5}px)`, transition: 'opacity 0.8s ease' }}/>
              )}
              <circle cx={s.x} cy={s.y} r={r} fill={R1_FAMILIES[s.fam].color}
                opacity={op}
                style={{ transition: 'opacity 0.8s ease, r 0.6s ease' }}/>
              {isMet && (
                <circle cx={s.x} cy={s.y} r={r} fill="none"
                  stroke={R1_FAMILIES[s.fam].color} strokeWidth="1"
                  className="rw1-met-ring" style={{ transformOrigin: `${s.x}px ${s.y}px` }}/>
              )}
              {isMet && (
                <circle cx={s.x} cy={s.y} r={r * 0.42} fill={COLORS.cream} opacity="0.95"/>
              )}
            </g>
          );
        })}
      </svg>

      {/* ── Lower composition — the encounter ─────────────────────────────── */}
      <div style={{
        position: 'absolute', top: 512, left: 0, right: 0, bottom: 110,
        padding: '0 34px', zIndex: 3, pointerEvents: 'none',
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        justifyContent: 'flex-start', textAlign: 'center',
      }}>

        {/* MET A SHAKTI */}
        {met && (
          <div key={met.id} className="rw1-rise" style={{ width: '100%' }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 40, fontWeight: 300,
              color: COLORS.cream, letterSpacing: '0.05em', lineHeight: 1.05,
              marginBottom: 6,
            }}>{met.name}</div>
            <div style={{
              fontFamily: '-apple-system, sans-serif', fontSize: 9.5,
              color: R1_FAMILIES[met.fam].color, opacity: 0.85,
              letterSpacing: '0.30em', textTransform: 'uppercase', marginBottom: 18,
            }}>{R1_FAMILIES[met.fam].label} · {R1_FAMILIES[met.fam].english.split(' · ')[1]}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 19, fontStyle: 'italic',
              fontWeight: 300, color: 'rgba(242,232,217,0.66)', lineHeight: 1.6,
              letterSpacing: '0.015em', maxWidth: 300, margin: '0 auto',
            }}>{met.quality}</div>
          </div>
        )}

        {/* FAMILY FOCUSED */}
        {!met && activeFam && (
          <div key={activeFam.key} className="rw1-rise" style={{ width: '100%' }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 34, fontWeight: 300,
              color: activeFam.color, letterSpacing: '0.06em', marginBottom: 5,
            }}>{activeFam.label}</div>
            <div style={{
              fontFamily: '-apple-system, sans-serif', fontSize: 9.5,
              color: 'rgba(242,232,217,0.40)', letterSpacing: '0.28em',
              textTransform: 'uppercase', marginBottom: 18,
            }}>{activeFam.english}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 16.5, fontStyle: 'italic',
              fontWeight: 300, color: 'rgba(242,232,217,0.60)', lineHeight: 1.66,
              letterSpacing: '0.01em', maxWidth: 312, margin: '0 auto',
            }}>{activeFam.lived}</div>
          </div>
        )}

        {/* ALL LIT — the world made visible */}
        {allLit && (
          <div className="rw1-rise" style={{ width: '100%' }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 24, fontStyle: 'italic',
              fontWeight: 300, color: 'rgba(242,232,217,0.78)', lineHeight: 1.5,
              letterSpacing: '0.02em', maxWidth: 320, margin: '0 auto 22px',
            }}>Thank you for the world I have walked through without knowing it was you.</div>
            <div style={{
              fontFamily: '-apple-system, sans-serif', fontSize: 9,
              color: 'rgba(242,232,217,0.26)', letterSpacing: '0.30em',
              textTransform: 'uppercase',
            }}>the whole ground, alight</div>
          </div>
        )}

        {/* DEFAULT — the invitation */}
        {!met && !activeFam && !allLit && (
          <div className="rw1-rise" style={{ width: '100%' }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: 20, fontStyle: 'italic',
              fontWeight: 300, color: 'rgba(242,232,217,0.52)', lineHeight: 1.6,
              letterSpacing: '0.02em', maxWidth: 296, margin: '0 auto 4px',
            }}>The ground you have walked, before you knew it was hers.</div>
          </div>
        )}
      </div>

      {/* ── Family legend / toggles ───────────────────────────────────────── */}
      <div style={{
        position: 'absolute', bottom: 82, left: 0, right: 0, zIndex: 4,
        display: 'flex', justifyContent: 'center', gap: 22,
      }}>
        {Object.values(R1_FAMILIES).map((f) => {
          const on = focusFam === f.key;
          const dim = focusFam && !on;
          return (
            <div key={f.key}
              onClick={(e) => focusFamily(f.key, e)}
              style={{
                display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer',
                opacity: dim ? 0.34 : 1, transition: 'opacity 0.4s ease',
              }}>
              <div style={{
                width: 6, height: 6, borderRadius: '50%', background: f.color,
                boxShadow: on ? `0 0 8px 1px ${f.color}` : 'none',
                transition: 'box-shadow 0.4s ease',
              }}/>
              <span style={{
                fontFamily: "'Cormorant Garamond', serif", fontSize: 14, fontStyle: 'italic',
                color: on ? f.color : 'rgba(242,232,217,0.5)',
                letterSpacing: '0.04em', transition: 'color 0.4s ease',
              }}>{f.label}</span>
            </div>
          );
        })}
      </div>

      {/* hint line + sound toggle */}
      <div style={{
        position: 'absolute', bottom: 56, left: 0, right: 0, textAlign: 'center', zIndex: 4,
        fontFamily: '-apple-system, sans-serif', fontSize: 8.5,
        color: 'rgba(242,232,217,0.20)', letterSpacing: '0.26em', textTransform: 'uppercase',
        pointerEvents: 'none',
      }}>
        tap a light to meet her · a gate to let the world in
      </div>

      {/* sound toggle — lower left, discreet */}
      <div onClick={toggleSound} style={{
        position: 'absolute', bottom: 50, left: 22, zIndex: 5, cursor: 'pointer',
        display: 'flex', alignItems: 'center', gap: 6,
      }}>
        <div style={{
          width: 18, height: 18, borderRadius: '50%',
          border: `0.5px solid rgba(217,169,60,${sound ? 0.7 : 0.3})`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          background: sound ? 'rgba(217,169,60,0.12)' : 'transparent',
          transition: 'all 0.4s ease',
        }}>
          <div className={sound ? 'rw1-drone-on' : ''} style={{
            width: 4, height: 4, borderRadius: '50%',
            background: sound ? '#D9A93C' : 'rgba(242,232,217,0.3)',
          }}/>
        </div>
        <span style={{
          fontFamily: '-apple-system, sans-serif', fontSize: 8,
          color: 'rgba(242,232,217,0.22)', letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>{sound ? 'ground' : 'silent'}</span>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ─── Export ───────────────────────────────────────────────────────────────────
Object.assign(window, { RingOneWorld, R1_FAMILIES });
