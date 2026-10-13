// games-patience.jsx — The108, TheSeed, TheCorridor
const { useState, useEffect, useRef, useMemo } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

// ─── THE 108 ──────────────────────────────────────────────────────────────────
const DOTS108 = (() => {
  const dots = [];
  [[40,128],[32,94],[24,62],[12,36]].forEach(([c,r]) => {
    for (let i = 0; i < c; i++) {
      const a = (i/c)*Math.PI*2 - Math.PI/2;
      dots.push({ id: dots.length, x: 183+r*Math.cos(a), y: 260+r*Math.sin(a) });
    }
  });
  return dots;
})();

function G108({ game, onReturn }) {
  const [tapped, setTapped] = useState(() => {
    try { return new Set(JSON.parse(localStorage.getItem('g108')||'[]')); } catch { return new Set(); }
  });
  const count = tapped.size;

  function tap(id) {
    if (tapped.has(id)) return;
    const next = new Set([...tapped, id]);
    setTapped(next);
    localStorage.setItem('g108', JSON.stringify([...next]));
  }
  function reset() { setTapped(new Set()); localStorage.removeItem('g108'); }

  const showLines = count >= 54;
  const patternLines = useMemo(() => {
    if (!showLines) return [];
    const tappedArr = DOTS108.filter(d => tapped.has(d.id));
    const lines = [];
    for (let i = 0; i < tappedArr.length - 12; i += 9) {
      lines.push([tappedArr[i], tappedArr[Math.min(i+9, tappedArr.length-1)]]);
    }
    return lines;
  }, [tapped, showLines]);

  const msg = count === 0 ? 'Tap each bead. No timer. No score.' :
              count < 36  ? '' :
              count < 72  ? 'A pattern is beginning to form.' :
              count < 108 ? `${108-count} remain.` : '108. Complete.';

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={60} opacity={.28} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column' }}>
        {/* Count */}
        <div style={{ textAlign:'center', padding:'2px 0 0', flexShrink:0 }}>
          <span style={{ ...T.sacred(36,.70) }}>{count}</span>
          <span style={{ ...T.sacred(18,.28) }}> / 108</span>
        </div>

        {/* Dots */}
        <svg viewBox="0 0 366 520" style={{ flex:1, width:'100%' }} onClick={() => {}}>
          {patternLines.map(([a,b],i) => (
            <line key={i} x1={a.x} y1={a.y} x2={b.x} y2={b.y} stroke={`${game.accent}18`} strokeWidth=".8" />
          ))}
          {DOTS108.map(dot => (
            <g key={dot.id} onClick={() => tap(dot.id)} style={{ cursor: tapped.has(dot.id)?'default':'pointer' }}>
              <circle cx={dot.x} cy={dot.y} r="18" fill="transparent" />
              <circle cx={dot.x} cy={dot.y} r={tapped.has(dot.id)?6:4}
                fill={tapped.has(dot.id) ? game.accent : `${game.accent}22`}
                stroke={tapped.has(dot.id) ? 'none' : `${game.accent}40`}
                strokeWidth=".8"
                style={{ transition:'all .15s' }}
              />
              {tapped.has(dot.id) && (
                <circle cx={dot.x} cy={dot.y} r="10" fill="none" stroke={`${game.accent}15`} strokeWidth=".6" />
              )}
            </g>
          ))}
        </svg>

        {/* Message */}
        <div style={{ padding:'4px 32px 20px', textAlign:'center', flexShrink:0 }}>
          {msg && <p style={{ ...T.italic(15,.50) }}>{msg}</p>}
          {count >= 108 && (
            <button onClick={reset} style={{ marginTop:'8px', padding:'5px 18px', borderRadius:'16px', background:'none', border:`1px solid ${game.accent}28`, color:`${game.accent}45`, fontSize:'11px', letterSpacing:'.15em', cursor:'pointer', textTransform:'uppercase' }}>Begin again</button>
          )}
        </div>
      </div>
    </GShell>
  );
}

// ─── THE SEED ─────────────────────────────────────────────────────────────────
function GSeed({ game, onReturn }) {
  const KEY = 'game_seed_v1';
  const [ts, setTs] = useState(() => localStorage.getItem(KEY) ? parseInt(localStorage.getItem(KEY)) : null);

  function plant() {
    const now = Date.now();
    localStorage.setItem(KEY, now.toString());
    setTs(now);
  }
  function uproot() { localStorage.removeItem(KEY); setTs(null); }

  const hrs = ts ? (Date.now() - ts) / 3600000 : 0;
  const stage = !ts ? 'none' : hrs < 2 ? 'seed' : hrs < 8 ? 'sprout' : hrs < 24 ? 'sapling' : hrs < 72 ? 'tree' : 'flower';
  const days = ts ? Math.floor(hrs / 24) : 0;
  const label = stage==='none' ? '' : stage==='seed' ? 'Planted.' : stage==='sprout' ? 'Day 1.' :
                stage==='sapling' ? 'Day 1. Growing.' : `Day ${days+1}.${stage==='flower'?' In bloom.':''}`;

  // SVG stage illustrations
  const SVGIll = () => {
    const soil = <line x1="60" y1="240" x2="306" y2="240" stroke="rgba(90,60,30,.5)" strokeWidth="1.5" />;
    if (stage==='none') return (
      <g>
        {soil}
        <ellipse cx="183" cy="252" rx="10" ry="6" fill="rgba(90,60,30,.35)" />
      </g>
    );
    if (stage==='seed') return (
      <g>
        {soil}
        <ellipse cx="183" cy="248" rx="11" ry="7" fill="rgba(90,60,30,.55)" />
      </g>
    );
    if (stage==='sprout') return (
      <g>
        {soil}
        <line x1="183" y1="240" x2="183" y2="195" stroke={`${game.accent}80`} strokeWidth="1.5" />
        <ellipse cx="172" cy="198" rx="13" ry="7" fill={`${game.accent}45`} transform="rotate(-25 172 198)" />
        <ellipse cx="194" cy="203" rx="13" ry="7" fill={`${game.accent}45`} transform="rotate(25 194 203)" />
      </g>
    );
    if (stage==='sapling') return (
      <g>
        {soil}
        <rect x="180" y="200" width="6" height="40" rx="3" fill="rgba(90,60,30,.6)" />
        {[[163,196,-35],[203,192,35],[158,210,-55],[208,205,55]].map(([x,y,r],i)=>(
          <ellipse key={i} cx={x} cy={y} rx="18" ry="9" fill={`${game.color}40`} transform={`rotate(${r} ${x} ${y})`} />
        ))}
      </g>
    );
    if (stage==='tree') return (
      <g>
        {soil}
        <rect x="179" y="185" width="8" height="55" rx="4" fill="rgba(90,60,30,.6)" />
        <line x1="183" y1="208" x2="158" y2="188" stroke="rgba(90,60,30,.4)" strokeWidth="1.5" />
        <line x1="183" y1="208" x2="208" y2="188" stroke="rgba(90,60,30,.4)" strokeWidth="1.5" />
        <circle cx="183" cy="160" r="50" fill={`${game.color}32`} />
        <circle cx="155" cy="172" r="30" fill={`${game.color}28`} />
        <circle cx="211" cy="172" r="30" fill={`${game.color}28`} />
      </g>
    );
    return ( // flower
      <g>
        {soil}
        <rect x="179" y="185" width="8" height="55" rx="4" fill="rgba(90,60,30,.6)" />
        <circle cx="183" cy="155" r="52" fill={`${game.color}30`} />
        <circle cx="155" cy="168" r="30" fill={`${game.color}26`} />
        <circle cx="211" cy="168" r="30" fill={`${game.color}26`} />
        {[[183,126],[165,142],[201,142],[176,157],[190,157],[170,135],[196,135]].map(([x,y],i)=>(
          <circle key={i} cx={x} cy={y} r="5" fill="rgba(220,130,160,.75)" />
        ))}
      </g>
    );
  };

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={50} opacity={.25} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center' }}>
        {stage === 'none' ? (
          <div style={{ textAlign:'center', padding:'40px', animation:'emerge .8s ease' }}>
            <p style={{ ...T.sacred(24,.75), marginBottom:'12px', lineHeight:1.5 }}>The seed is not yours to grow.</p>
            <p style={{ ...T.italic(18,.40), marginBottom:'36px' }}>You only need to plant it.</p>
            <Btn onClick={plant} color={game.color} accent={game.accent}>Plant</Btn>
          </div>
        ) : (
          <div style={{ width:'100%', textAlign:'center', animation:'emerge .6s ease' }}>
            <svg viewBox="0 0 366 300" style={{ width:'100%', height:'220px' }}>
              {[...Array(12)].map((_,i)=><circle key={i} cx={30+i*28} cy={15+Math.sin(i*1.2)*10} r="1.2" fill="rgba(255,255,255,.25)" />)}
              <SVGIll />
            </svg>
            <p style={{ ...T.sacred(18,.65), marginBottom:'6px' }}>{label}</p>
            <p style={{ ...T.italic(14,.30) }}>Return tomorrow.</p>
            <button onClick={uproot} style={{ marginTop:'20px', padding:'5px 16px', borderRadius:'14px', background:'none', border:`1px solid ${game.accent}22`, color:`${game.accent}35`, fontSize:'10px', letterSpacing:'.15em', cursor:'pointer', textTransform:'uppercase' }}>Uproot</button>
          </div>
        )}
      </div>
    </GShell>
  );
}

// ─── THE CORRIDOR ─────────────────────────────────────────────────────────────
function GCorridor({ game, onReturn }) {
  const [steps, setSteps]   = useState(0);
  const [taps, setTaps]     = useState([]);
  const [state, setState]   = useState('idle'); // idle | walking | too-fast | done
  const TARGET_MIN = 800, TARGET_MAX = 1200; // ms per step (50–75 BPM)

  function step() {
    const now = Date.now();
    setTaps(prev => {
      const next = [...prev.slice(-5), now];
      if (next.length >= 2) {
        const interval = next[next.length-1] - next[next.length-2];
        if (interval < TARGET_MIN) {
          setState('too-fast');
          setTimeout(() => setState('walking'), 600);
        } else if (interval <= TARGET_MAX) {
          setState('walking');
          setSteps(s => {
            const ns = s + 1;
            if (ns >= 24) setState('done');
            return ns;
          });
        } else {
          setState('idle');
        }
      } else {
        setState('walking');
      }
      return next;
    });
  }

  const progress = Math.min(steps / 24, 1);
  const wallColor = state === 'too-fast' ? 'rgba(220,80,80,.35)' : 'rgba(180,160,240,.18)';
  const isDone = state === 'done' || steps >= 24;

  if (isDone) return (
    <GShell game={game} onReturn={onReturn}>
      <GameDone game={game} headline="You walked through." sub="The door was always there." onReturn={onReturn} />
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={40} opacity={.22} />
      <div onClick={step} style={{ position:'relative', zIndex:2, height:'100%', cursor:'pointer', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', userSelect:'none' }}>
        {/* Corridor SVG */}
        <svg viewBox="0 0 366 460" style={{ width:'100%', flex:1 }}>
          {/* Nested walls */}
          {[0,1,2,3,4,5,6].map(i => {
            const s = 0.1 + i*0.13 + progress*0.08;
            const w = s*300, h = s*380;
            return (
              <rect key={i} x={(366-w)/2} y={(460-h)/2} width={w} height={h}
                fill="none" stroke={wallColor} strokeWidth={state==='too-fast'&&i>4?1.5:.8} style={{ transition:'stroke .3s' }} />
            );
          })}
          {/* Corner lines */}
          {[[0,0],[366,0],[0,460],[366,460]].map(([cx,cy],i)=>(
            <line key={i} x1="183" y1="230" x2={cx} y2={cy} stroke="rgba(180,160,240,.05)" strokeWidth=".8" />
          ))}
          {/* Door of light */}
          {steps >= 18 && (
            <ellipse cx="183" cy="230" rx={12*(steps-18)/6} ry={18*(steps-18)/6}
              fill={`rgba(255,245,200,${Math.min(.9,(steps-18)/6*.7)})`}
              style={{ filter:'blur(3px)' }} />
          )}
          {/* Step counter */}
          <text x="183" y="430" textAnchor="middle" style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'13px', fill:`rgba(180,160,240,.45)` }}>{steps} / 24</text>
        </svg>

        {/* Instruction */}
        <div style={{ padding:'8px 32px 20px', textAlign:'center', flexShrink:0 }}>
          {state === 'idle' && steps === 0 && <p style={{ ...T.italic(16,.40) }}>Tap to walk. Find your true pace.</p>}
          {state === 'too-fast' && <p style={{ ...T.italic(15,.50), color:'rgba(220,130,130,.6)' }}>Too fast. Slow down.</p>}
          {state === 'walking' && steps > 0 && <p style={{ ...T.italic(15,.35) }}>Keep the pace.</p>}
        </div>
      </div>
    </GShell>
  );
}

Object.assign(window, { G108, GSeed, GCorridor });
