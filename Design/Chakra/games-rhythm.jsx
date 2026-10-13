// games-rhythm.jsx — Coherence, MantraTuner, DrumOfEarth
const { useState: useSt, useEffect: useEf, useRef: useRf, useCallback: useCB } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

// Shared audio init
function initAudio(ref) {
  if (!ref.current) {
    try { ref.current = new (window.AudioContext || window.webkitAudioContext)(); } catch(e) {}
  }
  if (ref.current?.state === 'suspended') ref.current.resume();
  return ref.current;
}

// ─── COHERENCE ────────────────────────────────────────────────────────────────
function avgBPM(times) {
  if (times.length < 2) return null;
  const recent = times.slice(-6);
  const intervals = recent.slice(1).map((t,i) => t - recent[i]);
  return 60000 / (intervals.reduce((a,b)=>a+b,0) / intervals.length);
}

function GCoherence({ game, onReturn }) {
  const [heartTaps, setHeartTaps] = useSt([]);
  const [breathTaps, setBreathTaps] = useSt([]);
  const [coherent, setCoherent] = useSt(false);
  const [peak, setPeak] = useSt(0);
  const canvasRef = useRf(null);
  const rafRef = useRf(null);

  const hBPM = avgBPM(heartTaps);
  const bBPM = avgBPM(breathTaps);
  const coherenceScore = hBPM && bBPM ? Math.max(0, 1 - Math.abs(hBPM-bBPM)/Math.max(hBPM,bBPM)) : 0;

  useEf(() => {
    const isC = coherenceScore > 0.82 && hBPM && bBPM;
    setCoherent(isC);
    if (isC) setPeak(p => Math.max(p, coherenceScore));
  }, [coherenceScore]);

  // Canvas wave animation
  useEf(() => {
    const c = canvasRef.current; if (!c) return;
    const ctx = c.getContext('2d');
    c.width = c.offsetWidth; c.height = c.offsetHeight;
    let t = 0;
    function draw() {
      ctx.clearRect(0,0,c.width,c.height);
      const hw = c.width, hh = c.height;
      const hFreq = hBPM ? hBPM/60 : 1;
      const bFreq = bBPM ? bBPM/60 : 0.8;
      const blend = coherenceScore;

      // Heart wave (lower)
      ctx.beginPath();
      ctx.strokeStyle = `rgba(200,75,110,${.5+blend*.3})`;
      ctx.lineWidth = 1.5;
      for (let x=0;x<hw;x++) {
        const y = hh*.68 + Math.sin((x/hw)*Math.PI*4*hFreq+t)*22;
        x===0?ctx.moveTo(x,y):ctx.lineTo(x,y);
      }
      ctx.stroke();

      // Breath wave (upper)
      ctx.beginPath();
      ctx.strokeStyle = `rgba(30,110,160,${.5+blend*.3})`;
      ctx.lineWidth = 1.5;
      for (let x=0;x<hw;x++) {
        const y = hh*.32 + Math.sin((x/hw)*Math.PI*4*bFreq+t*.9)*22;
        x===0?ctx.moveTo(x,y):ctx.lineTo(x,y);
      }
      ctx.stroke();

      // Coherence bridge glow
      if (blend > 0.5) {
        ctx.beginPath();
        ctx.strokeStyle = `rgba(128,220,180,${(blend-.5)*2*.4})`;
        ctx.lineWidth = 1;
        for (let x=0;x<hw;x++) {
          const yh = hh*.68 + Math.sin((x/hw)*Math.PI*4*hFreq+t)*22;
          const yb = hh*.32 + Math.sin((x/hw)*Math.PI*4*bFreq+t*.9)*22;
          const y = yb + (yh-yb)*(1-blend);
          x===0?ctx.moveTo(x,y):ctx.lineTo(x,y);
        }
        ctx.stroke();
      }
      t += 0.04;
      rafRef.current = requestAnimationFrame(draw);
    }
    draw();
    return () => cancelAnimationFrame(rafRef.current);
  }, [hBPM, bBPM, coherenceScore]);

  function tapHeart(e) { e.stopPropagation(); setHeartTaps(p=>[...p.slice(-7),Date.now()]); }
  function tapBreath(e) { e.stopPropagation(); setBreathTaps(p=>[...p.slice(-7),Date.now()]); }

  return (
    <GShell game={game} onReturn={onReturn}>
      <div style={{ height:'100%', display:'flex', flexDirection:'column', position:'relative' }}>
        {coherent && <div style={{ position:'absolute', inset:0, background:`radial-gradient(ellipse at 50% 50%,rgba(20,160,120,.08),transparent)`, pointerEvents:'none', zIndex:1, transition:'opacity .5s' }} />}

        {/* Canvas waves */}
        <div style={{ flex:1, position:'relative' }}>
          <canvas ref={canvasRef} style={{ position:'absolute', inset:0, width:'100%', height:'100%' }} />
          {/* Labels */}
          <p style={{ position:'absolute', top:'22%', left:'24px', ...T.label(9,.40), color:'rgba(30,110,160,.6)' }}>Breath</p>
          <p style={{ position:'absolute', top:'60%', left:'24px', ...T.label(9,.40), color:'rgba(200,75,110,.6)' }}>Heart</p>
          {/* Score */}
          {hBPM && bBPM && (
            <div style={{ position:'absolute', top:'46%', left:'50%', transform:'translate(-50%,-50%)', textAlign:'center' }}>
              <p style={{ ...T.sacred(28, coherent?.85:.45) }}>{Math.round(coherenceScore*100)}%</p>
              <p style={{ ...T.label(8,.35) }}>coherence</p>
            </div>
          )}
        </div>

        {/* Two tap zones */}
        <div style={{ display:'flex', height:'140px', flexShrink:0, borderTop:`1px solid rgba(255,255,255,.04)` }}>
          <button onPointerDown={tapBreath} style={{ flex:1, background:`rgba(30,110,160,.08)`, border:'none', borderRight:`1px solid rgba(255,255,255,.04)`, cursor:'pointer', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'6px' }}>
            <div style={{ width:'36px', height:'36px', borderRadius:'50%', border:`1px solid rgba(30,110,160,.40)`, display:'flex', alignItems:'center', justifyContent:'center' }}>
              <div style={{ width:'10px', height:'10px', borderRadius:'50%', background:'rgba(30,110,160,.55)' }} />
            </div>
            <span style={{ ...T.label(9,.40), color:'rgba(30,110,160,.6)' }}>Breath</span>
            {bBPM && <span style={{ ...T.sacred(14,.50) }}>{Math.round(bBPM)}</span>}
          </button>
          <button onPointerDown={tapHeart} style={{ flex:1, background:`rgba(200,75,110,.08)`, border:'none', cursor:'pointer', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'6px' }}>
            <div style={{ width:'36px', height:'36px', borderRadius:'50%', border:`1px solid rgba(200,75,110,.40)`, display:'flex', alignItems:'center', justifyContent:'center' }}>
              <div style={{ width:'10px', height:'10px', borderRadius:'50%', background:'rgba(200,75,110,.55)' }} />
            </div>
            <span style={{ ...T.label(9,.40), color:'rgba(200,75,110,.6)' }}>Heart</span>
            {hBPM && <span style={{ ...T.sacred(14,.50) }}>{Math.round(hBPM)}</span>}
          </button>
        </div>

        {!hBPM && !bBPM && (
          <p style={{ position:'absolute', top:'50%', left:'50%', transform:'translate(-50%,-50%)', ...T.italic(16,.38), textAlign:'center', width:'220px', zIndex:2, pointerEvents:'none' }}>Tap Breath with one thumb, Heart with the other.</p>
        )}
      </div>
    </GShell>
  );
}

// ─── MANTRA TUNER ─────────────────────────────────────────────────────────────
function GMantra({ game, onReturn }) {
  const chakras = window.CHAKRAS_7;
  const [selected, setSelected] = useSt(null);
  const [taps, setTaps] = useSt([]);
  const [tuned, setTuned] = useSt(false);
  const audioRef = useRf(null);
  const oscRef   = useRf(null);

  const ch = selected != null ? chakras[selected] : null;
  const targetBPM = ch ? Math.round(ch.freq / 8) : null; // solfeggio / 8 → percussive rhythm
  const userBPM   = avgBPM(taps);
  const diff = targetBPM && userBPM ? Math.abs(userBPM - targetBPM) / targetBPM : 1;

  useEf(() => { if (diff < 0.05 && taps.length >= 6) setTuned(true); }, [diff, taps]);

  function selectChakra(i) {
    setSelected(i); setTaps([]); setTuned(false);
    const ctx = initAudio(audioRef);
    if (!ctx) return;
    if (oscRef.current) { try { oscRef.current.stop(); } catch(e) {} }
    const osc = ctx.createOscillator();
    const g = ctx.createGain();
    osc.type = 'sine'; osc.frequency.value = chakras[i].freq;
    g.gain.value = 0.08;
    osc.connect(g); g.connect(ctx.destination);
    osc.start(); oscRef.current = osc;
  }

  function handleTap() {
    if (!ch) return;
    setTaps(p => [...p.slice(-8), Date.now()]);
  }

  useEf(() => () => { try { oscRef.current?.stop(); } catch(e) {} }, []);

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={50} opacity={.28} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column', alignItems:'center', padding:'12px 20px' }}>
        {/* Chakra selector */}
        <div style={{ display:'flex', gap:'8px', flexWrap:'wrap', justifyContent:'center', flexShrink:0, marginBottom:'16px' }}>
          {chakras.map((c,i) => (
            <button key={c.id} onClick={() => selectChakra(i)} style={{ padding:'6px 12px', borderRadius:'20px', border:`1px solid ${selected===i?c.color:`${c.color}30`}`, background: selected===i?`${c.color}28`:'none', color: selected===i?`${c.color}`:'rgba(240,232,220,.45)', fontSize:'11px', letterSpacing:'.1em', cursor:'pointer', fontFamily:"'Cormorant Garamond',serif" }}>
              {c.name}
            </button>
          ))}
        </div>

        {!ch ? (
          <p style={{ ...T.italic(17,.38), textAlign:'center', marginTop:'60px' }}>Choose a chakra.<br/>A tone will play.</p>
        ) : (
          <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'20px', width:'100%' }}>
            {/* Frequency display */}
            <div style={{ textAlign:'center' }}>
              <p style={{ ...T.sacred(48, tuned?.9:.6), color: tuned?ch.color:'rgba(240,232,220,.6)' }}>{ch.freq}<span style={{ fontSize:'18px', opacity:.5 }}>hz</span></p>
              <p style={{ ...T.label(9,.35) }}>{ch.name} · {targetBPM} bpm target</p>
            </div>

            {/* Pendulum visual */}
            <svg viewBox="0 0 200 120" style={{ width:'200px', height:'120px' }}>
              {/* Reference pendulum */}
              <line x1="100" y1="10" x2={100+40*Math.sin((Date.now()/1000)*(targetBPM/60)*Math.PI)} y2="80" stroke={`${ch.color}50`} strokeWidth="1.5" style={{ animation:'none' }} />
              {/* User pendulum */}
              {userBPM && <line x1="100" y1="10" x2={100+40*Math.sin((Date.now()/1000)*(userBPM/60)*Math.PI)} y2="80" stroke={tuned?ch.color:'rgba(240,232,220,.6)'} strokeWidth="1.5" />}
            </svg>

            {/* Match feedback */}
            {userBPM && (
              <div style={{ textAlign:'center' }}>
                <p style={{ ...T.sacred(22, tuned?.85:.55), color: tuned?ch.color:'rgba(240,232,220,.55)' }}>
                  {tuned ? 'Tuned.' : diff<0.15 ? 'Close.' : diff<0.3 ? 'Approaching.' : 'Find the rhythm.'}
                </p>
                <p style={{ ...T.label(9,.30) }}>{Math.round(userBPM)} bpm</p>
              </div>
            )}

            {/* Tap area */}
            <button onPointerDown={handleTap} style={{ width:'100px', height:'100px', borderRadius:'50%', border:`2px solid ${ch.color}50`, background:`${ch.color}12`, cursor:'pointer', display:'flex', alignItems:'center', justifyContent:'center', animation: tuned?'breathe 2s ease-in-out infinite':'none' }}>
              <div style={{ width:'36px', height:'36px', borderRadius:'50%', background:`${ch.color}60` }} />
            </button>
          </div>
        )}
      </div>
    </GShell>
  );
}

// ─── DRUM OF EARTH ────────────────────────────────────────────────────────────
function GDrum({ game, onReturn }) {
  const [taps, setTaps] = useSt([]);
  const [depth, setDepth] = useSt(0);
  const [flash, setFlash] = useSt(null); // 'good' | 'miss'
  const TARGET = 1000; // ms = 60 BPM
  const TOLERANCE = 180;

  function beat() {
    const now = Date.now();
    setTaps(prev => {
      const next = [...prev.slice(-4), now];
      if (next.length >= 2) {
        const interval = next[next.length-1] - next[next.length-2];
        const onBeat = Math.abs(interval - TARGET) <= TOLERANCE;
        setFlash(onBeat ? 'good' : 'miss');
        setTimeout(() => setFlash(null), 300);
        if (onBeat) setDepth(d => Math.min(d+1, 20));
      }
      return next;
    });
  }

  const isDone = depth >= 20;
  const layerColors = ['#3A2010','#2A1808','#1E1206','#140E04','#0C0A04'];

  if (isDone) return (
    <GShell game={game} onReturn={onReturn}>
      <GameDone game={game} headline="You reached the water table." sub="Steady. Deep. Yours." onReturn={onReturn} />
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <div onClick={beat} style={{ height:'100%', cursor:'pointer', userSelect:'none', position:'relative', display:'flex', flexDirection:'column' }}>
        {/* Earth cross-section SVG */}
        <svg viewBox="0 0 366 440" style={{ flex:1, width:'100%' }}>
          {/* Sky strip */}
          <rect x="0" y="0" width="366" height="55" fill="#0A0504" />
          {/* Stars */}
          {[...Array(15)].map((_,i)=><circle key={i} cx={20+i*23} cy={20+Math.sin(i*1.5)*12} r="1" fill="rgba(255,255,255,.2)" />)}
          {/* Soil layers */}
          {layerColors.map((col,i)=>(
            <rect key={i} x="0" y={55+i*76} width="366" height="76" fill={col} />
          ))}
          {/* Layer lines */}
          {[1,2,3,4].map(i=>(
            <line key={i} x1="0" y1={55+i*76} x2="366" y2={55+i*76} stroke="rgba(255,255,255,.04)" strokeWidth="1" />
          ))}
          {/* Water table line */}
          <line x1="0" y1="435" x2="366" y2="435" stroke="rgba(30,110,160,.5)" strokeWidth="1.5" strokeDasharray="8 4" />

          {/* Root - grows down */}
          {depth > 0 && (
            <>
              <line x1="183" y1="55" x2="183" y2={55+depth*(380/20)} stroke="rgba(90,60,20,.9)" strokeWidth="2.5" />
              {/* Side roots at intervals */}
              {[4,8,12,16].filter(m=>depth>=m).map((m,i)=>(
                <g key={m}>
                  <line x1="183" y1={55+m*(380/20)} x2={183+(i%2===0?1:-1)*35} y2={55+m*(380/20)+18} stroke="rgba(90,60,20,.6)" strokeWidth="1.5" />
                  <line x1="183" y1={55+m*(380/20)} x2={183+(i%2===0?-1:1)*28} y2={55+m*(380/20)+14} stroke="rgba(90,60,20,.5)" strokeWidth="1" />
                </g>
              ))}
              {/* Root tip glow */}
              <circle cx="183" cy={55+depth*(380/20)} r="4" fill={game.accent} opacity=".6" />
            </>
          )}

          {/* Flash feedback */}
          {flash === 'good' && <rect x="0" y="0" width="366" height="440" fill="rgba(90,60,20,.12)" />}
          {flash === 'miss' && <rect x="0" y="0" width="366" height="440" fill="rgba(180,60,60,.08)" />}

          {/* Depth label */}
          <text x="183" y="430" textAnchor="middle" style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'11px', fill:'rgba(30,110,160,.55)' }}>{depth} / 20</text>
        </svg>

        {/* Instruction */}
        <div style={{ padding:'8px 32px 16px', textAlign:'center', flexShrink:0, background:'rgba(10,4,4,.6)' }}>
          <p style={{ ...T.italic(15,.40) }}>Tap at one beat per second. Steady.</p>
        </div>
      </div>
    </GShell>
  );
}

Object.assign(window, { GCoherence, GMantra, GDrum });
