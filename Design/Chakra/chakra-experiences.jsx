// chakra-experiences.jsx — all 7 experience screens
const { useState, useEffect, useRef } = React;

// ─── Shell ───────────────────────────────────────────────────────────────────
function ExperienceShell({ chakra, onBack, children }) {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: chakra.bg,
      display: 'flex', flexDirection: 'column',
      position: 'relative', overflow: 'hidden',
    }}>
      <div style={{
        display: 'flex', alignItems: 'center',
        padding: '10px 20px 4px', gap: '10px', flexShrink: 0,
      }}>
        <button onClick={onBack} style={{
          background: 'none', border: 'none', cursor: 'pointer',
          fontSize: '20px', color: `${chakra.accent}70`,
          padding: '4px 6px', lineHeight: 1,
        }}>←</button>
        <span style={{
          fontFamily: "'DM Sans', sans-serif",
          fontSize: '10px', letterSpacing: '0.28em',
          color: `${chakra.accent}55`, textTransform: 'uppercase',
        }}>{chakra.experienceLabel}</span>
      </div>
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative' }}>
        {children}
      </div>
    </div>
  );
}

// ─── 1. ROOT — Quiz ───────────────────────────────────────────────────────────
function RootExperience({ chakra, onBack, onComplete }) {
  const [qIdx, setQIdx]       = useState(0);
  const [selected, setSelected] = useState(null);
  const [score, setScore]     = useState(0);
  const [animKey, setAnimKey] = useState(0);
  const [done, setDone]       = useState(false);

  const q = chakra.quiz[qIdx];

  function pick(i) {
    if (selected !== null) return;
    setSelected(i);
    const correct = i === q.ans;
    if (correct) setScore(s => s + 1);
    setTimeout(() => {
      if (qIdx < chakra.quiz.length - 1) {
        setQIdx(x => x + 1);
        setSelected(null);
        setAnimKey(k => k + 1);
      } else { setDone(true); }
    }, 1100);
  }

  if (done) return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <Completion chakra={chakra} headline="You are grounded."
        sub={`${score} of ${chakra.quiz.length} known`} onComplete={onComplete} />
    </ExperienceShell>
  );

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '16px 24px 32px', gap: '20px' }}>
        {/* Progress bar */}
        <div style={{ display: 'flex', gap: '6px' }}>
          {chakra.quiz.map((_, i) => (
            <div key={i} style={{
              flex: 1, height: '2px', borderRadius: '2px',
              background: i < qIdx ? chakra.color : i === qIdx ? `${chakra.color}60` : 'rgba(255,255,255,0.08)',
              transition: 'background 0.4s',
            }} />
          ))}
        </div>

        {/* Question */}
        <div key={animKey} style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: '26px', color: 'rgba(240,232,220,0.92)',
          lineHeight: 1.35, marginTop: '8px', minHeight: '90px',
          animation: 'emerge 0.5s ease both',
        }}>{q.q}</div>

        {/* Options */}
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px',
          marginTop: 'auto', marginBottom: '8px',
        }}>
          {q.opts.map((opt, i) => {
            const isCorrect = selected !== null && i === q.ans;
            const isWrong   = selected === i && i !== q.ans;
            return (
              <button key={i} onClick={() => pick(i)} style={{
                padding: '18px 10px', borderRadius: '16px', cursor: 'pointer',
                border: `1px solid ${isCorrect ? chakra.color : isWrong ? '#7A2020' : `${chakra.color}28`}`,
                background: isCorrect ? `${chakra.color}28` : isWrong ? '#2A0A0A' : `${chakra.color}0C`,
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: '17px', lineHeight: 1.3, textAlign: 'center',
                color: isCorrect ? chakra.accent : isWrong ? '#D07070' : 'rgba(240,232,220,0.72)',
                transition: 'all 0.3s ease',
              }}>{opt}</button>
            );
          })}
        </div>
      </div>
    </ExperienceShell>
  );
}

// ─── 2. SACRAL — Creative Canvas ─────────────────────────────────────────────
function SacralExperience({ chakra, onBack, onComplete }) {
  const canvasRef = useRef(null);
  const drawing   = useRef(false);
  const lastPos   = useRef(null);
  const [hasDrawn, setHasDrawn] = useState(false);

  useEffect(() => {
    const c = canvasRef.current;
    if (!c) return;
    c.width = c.offsetWidth * window.devicePixelRatio;
    c.height = c.offsetHeight * window.devicePixelRatio;
    const ctx = c.getContext('2d');
    ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
    ctx.fillStyle = '#0A0604'; ctx.fillRect(0, 0, c.offsetWidth, c.offsetHeight);
  }, []);

  function pos(e, c) {
    const r = c.getBoundingClientRect();
    const src = e.touches ? e.touches[0] : e;
    return { x: src.clientX - r.left, y: src.clientY - r.top };
  }
  function start(e) {
    e.preventDefault(); drawing.current = true;
    lastPos.current = pos(e, canvasRef.current); setHasDrawn(true);
  }
  function move(e) {
    e.preventDefault();
    if (!drawing.current) return;
    const c = canvasRef.current, ctx = c.getContext('2d');
    const p = pos(e, c), l = lastPos.current;
    ctx.beginPath(); ctx.moveTo(l.x, l.y); ctx.lineTo(p.x, p.y);
    ctx.strokeStyle = chakra.color; ctx.lineWidth = 4;
    ctx.lineCap = 'round'; ctx.lineJoin = 'round';
    ctx.shadowColor = chakra.accent; ctx.shadowBlur = 10;
    ctx.stroke(); lastPos.current = p;
  }
  function stop() { drawing.current = false; }
  function clear() {
    const c = canvasRef.current, ctx = c.getContext('2d');
    ctx.fillStyle = '#0A0604'; ctx.fillRect(0, 0, c.offsetWidth, c.offsetHeight);
    setHasDrawn(false);
  }

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '4px 16px 16px', gap: '10px' }}>
        <p style={{
          fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
          fontSize: '17px', color: `${chakra.accent}80`, textAlign: 'center',
          flexShrink: 0,
        }}>Draw what flows freely from you</p>
        <div style={{ flex: 1, position: 'relative' }}>
          <canvas ref={canvasRef} style={{
            position: 'absolute', inset: 0, width: '100%', height: '100%',
            borderRadius: '18px', border: `1px solid ${chakra.color}28`,
            touchAction: 'none', cursor: 'crosshair', display: 'block',
          }}
            onMouseDown={start} onMouseMove={move} onMouseUp={stop} onMouseLeave={stop}
            onTouchStart={start} onTouchMove={move} onTouchEnd={stop}
          />
        </div>
        <div style={{ display: 'flex', justifyContent: 'center', gap: '12px', flexShrink: 0 }}>
          <button onClick={clear} style={{
            padding: '8px 20px', background: 'none', border: `1px solid ${chakra.color}38`,
            borderRadius: '20px', color: `${chakra.accent}55`, fontSize: '12px',
            letterSpacing: '0.12em', cursor: 'pointer',
          }}>Clear</button>
          {hasDrawn && (
            <button onClick={onComplete} style={{
              padding: '8px 24px', borderRadius: '20px',
              background: `${chakra.color}22`, border: `1px solid ${chakra.color}55`,
              fontFamily: "'Cormorant Garamond', serif", fontSize: '16px',
              color: 'rgba(240,232,220,0.82)', letterSpacing: '0.14em', cursor: 'pointer',
              animation: 'emerge 0.4s ease',
            }}>Complete</button>
          )}
        </div>
      </div>
    </ExperienceShell>
  );
}

// ─── 3. SOLAR — Reflection ────────────────────────────────────────────────────
function SolarExperience({ chakra, onBack, onComplete }) {
  const [text, setText] = useState('');
  const words = text.trim().split(/\s+/).filter(Boolean).length;

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '8px 22px 24px', gap: '14px' }}>
        <p style={{
          fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
          fontSize: '17px', color: `${chakra.accent}80`,
          lineHeight: 1.6, textAlign: 'center', flexShrink: 0,
        }}>{chakra.prompt}</p>

        {/* Fire glow */}
        <div style={{
          position: 'relative', flex: 1, display: 'flex', flexDirection: 'column',
        }}>
          <textarea value={text} onChange={e => setText(e.target.value)}
            placeholder="Begin when ready…"
            style={{
              flex: 1, width: '100%', background: `${chakra.color}0A`,
              border: `1px solid ${chakra.color}28`, borderRadius: '16px',
              padding: '18px', color: 'rgba(240,232,220,0.88)', resize: 'none', outline: 'none',
              fontFamily: "'Cormorant Garamond', serif", fontSize: '19px', lineHeight: 1.7,
            }}
          />
          {/* Fire underlay grows with text */}
          <div style={{
            position: 'absolute', bottom: 0, left: 0, right: 0,
            height: `${Math.min(words * 6, 100)}px`,
            background: `linear-gradient(to top, ${chakra.color}22, transparent)`,
            borderRadius: '0 0 16px 16px',
            transition: 'height 1.2s ease',
            pointerEvents: 'none',
          }} />
        </div>

        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0,
        }}>
          <span style={{
            fontSize: '11px', letterSpacing: '0.18em',
            color: `${chakra.accent}45`, textTransform: 'uppercase',
          }}>{words > 0 ? `${words} words` : 'Begin when ready'}</span>
          {words >= 10 && (
            <button onClick={onComplete} style={{
              padding: '10px 24px', borderRadius: '22px',
              background: `${chakra.color}22`, border: `1px solid ${chakra.color}55`,
              fontFamily: "'Cormorant Garamond', serif", fontSize: '16px',
              color: 'rgba(240,232,220,0.82)', letterSpacing: '0.14em', cursor: 'pointer',
              animation: 'emerge 0.4s ease',
            }}>Complete</button>
          )}
        </div>
      </div>
    </ExperienceShell>
  );
}

// ─── 4. HEART — Body Scan / Breathing ────────────────────────────────────────
function HeartExperience({ chakra, onBack, onComplete }) {
  const PHASES = [
    { name: 'inhale',  dur: 4, label: 'Breathe in',  size: 170, tdur: '3.8s' },
    { name: 'hold',    dur: 2, label: 'Hold',          size: 170, tdur: '0.3s' },
    { name: 'exhale',  dur: 6, label: 'Breathe out',  size: 95,  tdur: '5.8s' },
    { name: 'pause',   dur: 2, label: 'Rest',          size: 95,  tdur: '0.3s' },
  ];
  const [pIdx, setPIdx] = useState(0);
  const [count, setCount] = useState(PHASES[0].dur);
  const [round, setRound] = useState(0);
  const [done, setDone]   = useState(false);
  const phase = PHASES[pIdx];

  useEffect(() => {
    if (done) return;
    let remaining = phase.dur;
    setCount(remaining);
    const id = setInterval(() => {
      remaining -= 1;
      setCount(remaining);
      if (remaining <= 0) {
        clearInterval(id);
        const next = (pIdx + 1) % PHASES.length;
        if (pIdx === PHASES.length - 1) {
          const r = round + 1;
          setRound(r);
          if (r >= 3) { setDone(true); return; }
        }
        setPIdx(next);
      }
    }, 1000);
    return () => clearInterval(id);
  }, [pIdx, done]);

  if (done) return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <Completion chakra={chakra} headline="Your heart is open." onComplete={onComplete} />
    </ExperienceShell>
  );

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{
        height: '100%', display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', gap: '36px', padding: '20px',
      }}>
        <p style={{
          fontFamily: "'DM Sans', sans-serif", fontSize: '11px',
          letterSpacing: '0.22em', color: `${chakra.accent}50`, textTransform: 'uppercase',
        }}>Round {round + 1} of 3</p>

        {/* Breathing circle */}
        <div style={{
          width: `${phase.size}px`, height: `${phase.size}px`, borderRadius: '50%',
          background: `radial-gradient(circle at 38% 38%, ${chakra.accent}40, ${chakra.color}65)`,
          boxShadow: `0 0 ${phase.size * 0.4}px ${chakra.color}55`,
          transition: `all ${phase.tdur} ease-in-out`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <span style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: '32px', color: 'rgba(240,232,220,0.65)',
          }}>{count}</span>
        </div>

        <p key={phase.name} style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: '24px', letterSpacing: '0.1em',
          color: 'rgba(240,232,220,0.75)',
          animation: 'emerge 0.4s ease',
        }}>{phase.label}</p>

        <p style={{
          fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
          fontSize: '14px', color: 'rgba(240,232,220,0.30)',
          textAlign: 'center', maxWidth: '220px',
        }}>Place your hands on your heart center</p>
      </div>
    </ExperienceShell>
  );
}

// ─── 5. THROAT — Visualization ───────────────────────────────────────────────
function ThroatExperience({ chakra, onBack, onComplete }) {
  const [started, setStarted] = useState(false);
  const [wIdx, setWIdx]       = useState(-1);
  const words = chakra.words;

  useEffect(() => {
    if (!started || wIdx >= words.length) return;
    const w = words[wIdx];
    const delay = w === '·' ? 1800 : wIdx === -1 ? 600 : 650;
    const t = setTimeout(() => setWIdx(i => i + 1), delay);
    return () => clearTimeout(t);
  }, [wIdx, started]);

  // Group words into lines separated by ·
  const lines = [];
  let cur = [];
  words.slice(0, Math.max(0, wIdx + 1)).forEach(w => {
    if (w === '·') { if (cur.length) lines.push(cur.join(' ')); cur = []; }
    else cur.push(w);
  });
  if (cur.length) lines.push(cur.join(' '));

  const isDone = wIdx >= words.length;

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{
        height: '100%', display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', padding: '40px 36px',
      }}>
        {!started ? (
          <div style={{ textAlign: 'center', animation: 'emerge 0.7s ease' }}>
            <p style={{
              fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
              fontSize: '18px', color: 'rgba(240,232,220,0.58)',
              lineHeight: 1.7, marginBottom: '40px', maxWidth: '240px',
            }}>Find a comfortable position. Take one long breath.</p>
            <button onClick={() => { setStarted(true); setWIdx(0); }} style={{
              padding: '14px 36px', borderRadius: '30px', cursor: 'pointer',
              background: `${chakra.color}18`, border: `1px solid ${chakra.color}48`,
              fontFamily: "'Cormorant Garamond', serif", fontSize: '17px',
              color: 'rgba(240,232,220,0.78)', letterSpacing: '0.2em', textTransform: 'uppercase',
            }}>Begin</button>
          </div>
        ) : isDone ? (
          <div style={{ textAlign: 'center', animation: 'emerge 0.6s ease' }}>
            <p style={{
              fontFamily: "'Cormorant Garamond', serif", fontSize: '28px',
              color: 'rgba(240,232,220,0.88)', marginBottom: '16px',
            }}>Your truth has been heard.</p>
            <p style={{
              fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
              fontSize: '15px', color: 'rgba(240,232,220,0.45)',
              lineHeight: 1.75, marginBottom: '40px',
            }}>"{chakra.sacredText}"</p>
            <button onClick={onComplete} style={{
              padding: '13px 32px', borderRadius: '28px', cursor: 'pointer',
              background: `${chakra.color}20`, border: `1px solid ${chakra.color}50`,
              fontFamily: "'Cormorant Garamond', serif", fontSize: '16px',
              color: 'rgba(240,232,220,0.78)', letterSpacing: '0.16em', textTransform: 'uppercase',
            }}>Return</button>
          </div>
        ) : (
          <div style={{
            fontFamily: "'Cormorant Garamond', serif", fontSize: '30px',
            color: 'rgba(240,232,220,0.88)', lineHeight: 1.8,
            textAlign: 'center', letterSpacing: '0.04em', minHeight: '160px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '6px',
          }}>
            {lines.map((line, i) => (
              <span key={i} style={{
                display: 'block', opacity: i < lines.length - 1 ? 0.45 : 1,
                animation: 'emerge 0.6s ease',
              }}>{line}</span>
            ))}
          </div>
        )}
      </div>
    </ExperienceShell>
  );
}

// ─── 6. THIRD EYE — Oracle ────────────────────────────────────────────────────
function ThirdEyeExperience({ chakra, onBack, onComplete }) {
  const [flipped, setFlipped] = useState(false);
  const [oracle]  = useState(() => {
    const oracles = chakra.oracles;
    return oracles[Math.floor(Math.random() * oracles.length)];
  });

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{
        height: '100%', display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', gap: '30px', padding: '20px',
      }}>
        <p style={{
          fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
          fontSize: '16px', color: `${chakra.accent}65`, textAlign: 'center',
        }}>{flipped ? 'Your message has arrived.' : 'When you are ready, pull your card.'}</p>

        {/* Flip card */}
        <div onClick={() => setFlipped(true)}
          style={{ width: '224px', height: '326px', perspective: '1000px', cursor: flipped ? 'default' : 'pointer' }}>
          <div style={{
            width: '100%', height: '100%', position: 'relative',
            transformStyle: 'preserve-3d',
            transition: 'transform 0.85s cubic-bezier(0.4,0,0.2,1)',
            transform: flipped ? 'rotateY(180deg)' : 'rotateY(0deg)',
          }}>
            {/* Back */}
            <div style={{
              position: 'absolute', inset: 0, borderRadius: '20px',
              background: `linear-gradient(160deg, ${chakra.bgSolid}, #0A0818)`,
              border: `1px solid ${chakra.color}45`, backfaceVisibility: 'hidden',
              display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden',
            }}>
              <svg viewBox="0 0 200 200" style={{ width: '164px', height: '164px', opacity: 0.55 }}>
                {[22,48,74,96].map((r, i) => <circle key={i} cx="100" cy="100" r={r} fill="none" stroke={chakra.color} strokeWidth="0.7" />)}
                {Array.from({length: 12}, (_, i) => {
                  const a = (i * 30 * Math.PI) / 180;
                  return <line key={i} x1="100" y1="100" x2={100 + 96 * Math.cos(a)} y2={100 + 96 * Math.sin(a)} stroke={chakra.color} strokeWidth="0.5" />;
                })}
                <circle cx="100" cy="100" r="9" fill={chakra.color} opacity="0.9" />
                <circle cx="100" cy="100" r="3" fill={chakra.accent} />
              </svg>
            </div>
            {/* Front */}
            <div style={{
              position: 'absolute', inset: 0, borderRadius: '20px',
              background: `linear-gradient(180deg, #0E0A1E 0%, ${chakra.bgSolid} 100%)`,
              border: `1px solid ${chakra.accent}30`, backfaceVisibility: 'hidden',
              transform: 'rotateY(180deg)',
              display: 'flex', flexDirection: 'column',
              alignItems: 'center', justifyContent: 'center', padding: '28px 22px', gap: '20px',
            }}>
              <span style={{
                fontSize: '10px', letterSpacing: '0.28em',
                color: `${chakra.accent}55`, textTransform: 'uppercase',
              }}>Ajna · Insight</span>
              <p style={{
                fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
                fontSize: '19px', color: 'rgba(240,232,220,0.92)',
                lineHeight: 1.75, textAlign: 'center',
              }}>"{oracle}"</p>
            </div>
          </div>
        </div>

        {flipped && (
          <button onClick={onComplete} style={{
            padding: '12px 28px', borderRadius: '26px', cursor: 'pointer',
            background: `${chakra.color}18`, border: `1px solid ${chakra.color}48`,
            fontFamily: "'Cormorant Garamond', serif", fontSize: '16px',
            color: 'rgba(240,232,220,0.75)', letterSpacing: '0.16em', textTransform: 'uppercase',
            animation: 'emerge 0.5s ease',
          }}>Return</button>
        )}
      </div>
    </ExperienceShell>
  );
}

// ─── 7. CROWN — Pattern Weaving (matching) ────────────────────────────────────
function CrownExperience({ chakra, onBack, onComplete }) {
  const [cards] = useState(() => {
    const all = [];
    chakra.pairs.forEach((p, i) => {
      all.push({ id: `c${i}`, pairId: i, text: p.concept, type: 'concept' });
      all.push({ id: `m${i}`, pairId: i, text: p.match,   type: 'match'   });
    });
    for (let i = all.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [all[i], all[j]] = [all[j], all[i]];
    }
    return all;
  });

  const [sel, setSel]         = useState([]);
  const [matched, setMatched] = useState(new Set());
  const [wrong, setWrong]     = useState(null);

  useEffect(() => {
    if (sel.length < 2) return;
    const [a, b] = sel;
    if (a.pairId === b.pairId && a.type !== b.type) {
      setTimeout(() => { setMatched(m => new Set([...m, a.pairId])); setSel([]); }, 450);
    } else {
      setWrong([a.id, b.id]);
      setTimeout(() => { setSel([]); setWrong(null); }, 700);
    }
  }, [sel]);

  const allDone = matched.size === chakra.pairs.length;

  function tap(card) {
    if (matched.has(card.pairId)) return;
    if (sel.find(s => s.id === card.id)) return;
    if (sel.length >= 2) return;
    setSel(s => [...s, card]);
  }

  if (allDone) return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <Completion chakra={chakra} headline="All things are connected." onComplete={onComplete} />
    </ExperienceShell>
  );

  return (
    <ExperienceShell chakra={chakra} onBack={onBack}>
      <div style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '8px 18px 24px', gap: '12px' }}>
        <p style={{
          fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
          fontSize: '16px', color: `${chakra.accent}70`, textAlign: 'center', flexShrink: 0,
        }}>Connect each force to its dwelling.</p>
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gridTemplateRows: 'repeat(4, 1fr)',
          gap: '8px', flex: 1,
        }}>
          {cards.map(card => {
            const isMatched  = matched.has(card.pairId);
            const isSelected = !!sel.find(s => s.id === card.id);
            const isWrong    = wrong && wrong.includes(card.id);
            return (
              <button key={card.id} onClick={() => tap(card)} style={{
                borderRadius: '14px', cursor: isMatched ? 'default' : 'pointer',
                border: `1px solid ${isMatched ? `${chakra.color}70` : isSelected ? chakra.accent : isWrong ? '#7A2020' : `${chakra.color}25`}`,
                background: isMatched ? `${chakra.color}22` : isSelected ? `${chakra.color}28` : isWrong ? '#200808' : `${chakra.color}0A`,
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: card.type === 'concept' ? '18px' : '14px',
                letterSpacing: card.type === 'concept' ? '0.12em' : '0.04em',
                color: isMatched ? chakra.accent : isSelected ? 'rgba(240,232,220,0.95)' : 'rgba(240,232,220,0.62)',
                transition: 'all 0.25s ease',
                lineHeight: 1.3, padding: '8px',
                animation: isWrong ? 'shake 0.4s ease' : undefined,
              }}>{card.text}</button>
            );
          })}
        </div>
      </div>
    </ExperienceShell>
  );
}

// ─── Shared Completion screen ─────────────────────────────────────────────────
function Completion({ chakra, headline, sub, onComplete }) {
  return (
    <div style={{
      height: '100%', display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center', padding: '40px 36px', textAlign: 'center',
      animation: 'emerge 0.7s ease',
    }}>
      <div style={{
        width: '88px', height: '88px', borderRadius: '50%', marginBottom: '32px',
        background: `radial-gradient(circle at 38% 38%, ${chakra.accent}45, ${chakra.color}65)`,
        boxShadow: `0 0 40px ${chakra.color}65`,
        animation: 'breathe 4s ease-in-out infinite',
      }} />
      <p style={{
        fontFamily: "'Cormorant Garamond', serif", fontSize: '32px',
        color: 'rgba(240,232,220,0.92)', marginBottom: '10px', lineHeight: 1.2,
      }}>{headline}</p>
      {sub && <p style={{ fontSize: '12px', letterSpacing: '0.16em', color: `${chakra.accent}50`, marginBottom: '16px', textTransform: 'uppercase' }}>{sub}</p>}
      <p style={{
        fontFamily: "'Cormorant Garamond', serif", fontStyle: 'italic',
        fontSize: '16px', color: 'rgba(240,232,220,0.48)', lineHeight: 1.75,
        marginBottom: '44px', maxWidth: '240px',
      }}>"{chakra.sacredText}"</p>
      <button onClick={onComplete} style={{
        padding: '14px 36px', borderRadius: '30px', cursor: 'pointer',
        background: `${chakra.color}22`, border: `1px solid ${chakra.color}55`,
        fontFamily: "'Cormorant Garamond', serif", fontSize: '17px',
        color: 'rgba(240,232,220,0.80)', letterSpacing: '0.15em', textTransform: 'uppercase',
      }}>Return</button>
    </div>
  );
}

// Export all to window
Object.assign(window, {
  ExperienceShell, Completion,
  RootExperience, SacralExperience, SolarExperience,
  HeartExperience, ThroatExperience, ThirdEyeExperience, CrownExperience
});
