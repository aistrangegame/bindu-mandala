// bindu-practice.jsx — The Recognition, v3.
// ONE living dot persists across the entire practice — Bindu itself, the protagonist.
// It glides between movements, leans toward the walker's finger, ceases breathing at
// Recognition, becomes the room at Lalita, and finally comes to rest where the hand chooses.
const { useState, useEffect, useRef, useCallback } = React;

const sentencesOf = (p) => p.match(/[^.!?]+[.!?]+(\s|$)/g)?.map(s => s.trim()) || [p];
const paras = (s) => (s || '').split(/\n\n+/).map(p => p.trim()).filter(Boolean);
const P = () => paras(BINDU().practice.teaching);

// Gold emphasis on key canon phrases
function emphasize(text, phrases, gold = '#A57D22') {
  let parts = [text];
  (phrases || []).forEach(ph => {
    parts = parts.flatMap(part => {
      if (typeof part !== 'string' || !part.includes(ph)) return [part];
      const out = [];
      part.split(ph).forEach((seg, i, arr) => {
        out.push(seg);
        if (i < arr.length - 1) out.push(<em key={ph + i} style={{ fontStyle:'inherit', color:gold }}>{ph}</em>);
      });
      return out;
    });
  });
  return parts;
}

// One sentence, spoken word by word
function SpokenSentence({ text, emph, gold, style }) {
  const words = text.split(' ');
  // find emphasized char ranges so word coloring survives the split
  const joined = words.join(' ');
  const goldSet = new Set();
  (emph || []).forEach(ph => {
    let idx = joined.indexOf(ph);
    while (idx !== -1) {
      let c = 0;
      words.forEach((w, wi) => {
        const start = c, end = c + w.length;
        if (start < idx + ph.length && end > idx) goldSet.add(wi);
        c = end + 1;
      });
      idx = joined.indexOf(ph, idx + 1);
    }
  });
  return (
    <p style={style}>
      {words.map((w, i) => (
        <span key={i} style={{ display:'inline-block', whiteSpace:'pre',
          color: goldSet.has(i) ? (gold || '#A57D22') : 'inherit',
          animation:`word-in .9s ease ${i * 0.1}s both` }}>{w + (i < words.length - 1 ? ' ' : '')}</span>
      ))}
    </p>
  );
}

// Sentences arrive on their own breath; a window keeps long paragraphs on the glass.
function SentenceFlow({ text, pace = 1, style, emph, gold, align = 'center', onDone, replace = false, window: win = 0 }) {
  const sents = sentencesOf(text);
  const [n, setN] = useState(0);
  useEffect(() => {
    if (n >= sents.length) { onDone && onDone(); return; }
    const words = sents[n].split(' ').length;
    const dur = Math.max(1800, sents[n].length * 34, words * 130 + 1100) * pace;
    const t = setTimeout(() => setN(n + 1), dur);
    return () => clearTimeout(t);
  }, [n]);
  const upto = Math.min(n + 1, sents.length);
  let start = 0;
  if (replace) start = Math.max(0, Math.min(n, sents.length - 1));
  else if (win > 0) start = Math.max(0, upto - win);
  const visible = replace ? sents.slice(start, start + 1) : sents.slice(start, upto);
  return (
    <div style={{ display:'flex', flexDirection:'column', gap:'14px', textAlign:align }}>
      {visible.map((s, i) => {
        const isNewest = start + i === upto - 1;
        const dimmed = !replace && win > 0 && visible.length === win && i === 0;
        return isNewest
          ? <SpokenSentence key={start + i} text={s} emph={emph} gold={gold} style={style} />
          : <p key={start + i} style={{ ...style, opacity: dimmed ? .3 : .68, transition:'opacity 1.5s ease' }}>{emphasize(s, emph, gold)}</p>;
      })}
    </div>
  );
}

function VoiceMark({ name, color }) {
  return (
    <div style={{ position:'absolute', top:'64px', left:0, right:0, display:'flex', justifyContent:'center',
      alignItems:'center', gap:'8px', animation:'fade-in 2.6s ease', zIndex:20 }}>
      <span style={{ width:'5px', height:'5px', borderRadius:'50%', background:color }}></span>
      <span style={{ fontFamily:"'DM Sans',sans-serif", fontSize:'9px', letterSpacing:'.3em', textTransform:'uppercase', color, opacity:.75 }}>{name}</span>
    </div>
  );
}

function ContinueHint({ label = 'touch to continue', dark }) {
  return <p style={{ position:'absolute', bottom:'50px', left:0, right:0, textAlign:'center', zIndex:20,
    fontFamily:"'DM Sans',sans-serif", fontSize:'8.5px', letterSpacing:'.26em', textTransform:'uppercase',
    color: dark ? 'rgba(235,240,225,.3)' : 'rgba(56,44,26,.25)', animation:'fade-in 2s ease' }}>{label}</p>;
}

// ── THE LIVING DOT — Bindu itself. Never unmounts. ──
function LivingDot({ d, lean }) {
  const size = d.size;
  return (
    <div style={{ position:'absolute', left:d.x + '%', top:d.y + '%', zIndex:5, pointerEvents:'none',
      width:size + 'px', height:size + 'px', marginLeft:-size / 2 + 'px', marginTop:-size / 2 + 'px',
      opacity: d.visible ? 1 : 0,
      transform:`translate(${lean.x}px,${lean.y}px)`,
      transition:'left 2.6s cubic-bezier(.45,0,.25,1), top 2.6s cubic-bezier(.45,0,.25,1), ' +
        'width 3s cubic-bezier(.55,0,.25,1), height 3s cubic-bezier(.55,0,.25,1), ' +
        'margin 3s cubic-bezier(.55,0,.25,1), opacity 2.2s ease, transform 1.1s ease' }}>
      <div style={{ width:'100%', height:'100%', borderRadius:'50%',
        background:'radial-gradient(circle at 42% 38%, #E8C568, #C9A84C 75%)',
        boxShadow:`0 0 ${18 * d.glow}px rgba(201,168,76,.55), 0 0 ${46 * d.glow}px rgba(201,168,76,.28)`,
        animation: d.breathing ? 'breathe 4.6s ease-in-out infinite' : 'none',
        transition:'box-shadow 2s ease' }}></div>
    </div>
  );
}

// Transparent hit area over the dot's anchor
function DotHit({ x, y, r = 34, onTouch }) {
  return <div onClick={onTouch} style={{ position:'absolute', left:x + '%', top:y + '%',
    width:r * 2 + 'px', height:r * 2 + 'px', margin:-r + 'px', borderRadius:'50%', cursor:'pointer', zIndex:15 }}></div>;
}

function Ripples({ x, y, dark }) {
  return (
    <div style={{ position:'absolute', left:x + '%', top:y + '%', zIndex:4, pointerEvents:'none' }}>
      {[0, 1, 2].map(i => <div key={i} style={{ position:'absolute', width:'20px', height:'20px', margin:'-10px',
        borderRadius:'50%', border:`1px solid ${dark ? 'rgba(127,184,154,.5)' : 'rgba(201,168,76,.55)'}`,
        animation:`ripple 2.6s ease-out ${i * .5}s 1 both` }}></div>)}
    </div>
  );
}

// ═══ MOVEMENTS — each positions the one dot, never draws its own ═══

// I · Contact
function MContact({ pace, setDot, next }) {
  const [touched, setTouched] = useState(false);
  const [flowDone, setFlowDone] = useState(false);
  useEffect(() => { setDot({ x:50, y:34, size:14, glow:1, visible:true, breathing:true }); }, []);
  return (
    <div data-screen-label="Practice I · Contact" onClick={() => flowDone && next()}
      style={{ position:'absolute', inset:0, cursor: flowDone ? 'pointer' : 'default' }}>
      <VoiceMark name="Bindu · Recognize" color="#A57D22" />
      {!touched && <DotHit x={50} y={34} onTouch={() => { setTouched(true); setDot(d => ({ ...d, glow:1.8 })); }} />}
      {touched && <Ripples x={50} y={34} />}
      <div style={{ position:'absolute', left:'46px', right:'46px', top:'44%', zIndex:10 }}>
        {touched
          ? <SentenceFlow text={P()[0]} pace={pace} style={{ ...BT.serif(21, .84) }} emph={['recognition']} onDone={() => setFlowDone(true)} />
          : <p style={{ ...BT.label(9, .28), textAlign:'center', animation:'fade-in 3s ease 1s backwards' }}>touch the point</p>}
      </div>
      {flowDone && <ContinueHint />}
    </div>
  );
}

// II · The Name — the dot takes its place inside the word
function MName({ pace, setDot, next }) {
  const [split, setSplit] = useState(false);
  const [flowDone, setFlowDone] = useState(false);
  useEffect(() => { setDot({ x:50, y:20, size:11, glow:.9, visible:true, breathing:true }); }, []);
  const enterWord = () => {
    setSplit(true);
    setDot({ x:50, y:38.5, size:10, glow:1.1, visible:true, breathing:true });  // glides into the gap
  };
  return (
    <div data-screen-label="Practice II · The Name" onClick={() => flowDone && next()}
      style={{ position:'absolute', inset:0, cursor: flowDone ? 'pointer' : 'default' }}>
      <VoiceMark name="Bindu · Recognize" color="#A57D22" />
      <div style={{ position:'absolute', left:0, right:0, top:'26%', display:'flex', flexDirection:'column', alignItems:'center', zIndex:10 }}>
        <p style={{ ...BT.italic(14, .45), marginBottom:'34px', animation:'emerge 2s ease' }}>The Sanskrit drops a clue in plain English:</p>
        <div onClick={(e) => { if (!split) { e.stopPropagation(); enterWord(); } }}
          style={{ display:'flex', alignItems:'center', cursor: split ? 'default' : 'pointer', height:'70px' }}>
          <span style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'52px', color:BT.ink(.85), letterSpacing:'.06em',
            transform: split ? 'translateX(-17px)' : 'none', transition:'transform 2.6s cubic-bezier(.2,.8,.2,1)' }}>BIND</span>
          <span style={{ width: split ? '36px' : '0px', transition:'width 2.6s cubic-bezier(.2,.8,.2,1)' }}></span>
          <span style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'52px', color:'#A57D22', letterSpacing:'.06em',
            transform: split ? 'translateX(17px)' : 'none', transition:'transform 2.6s cubic-bezier(.2,.8,.2,1)' }}>U</span>
        </div>
      </div>
      <div style={{ position:'absolute', left:'44px', right:'44px', top:'50%', zIndex:10 }}>
        {split
          ? <SentenceFlow text={P()[1].replace(/^The Sanskrit drops a clue in plain English: Bind · U\.\s*/, '')} pace={pace} window={3}
              style={{ ...BT.serif(19.5, .82) }} emph={['binds you to yourself', 'before the first thought']} onDone={() => setFlowDone(true)} />
          : <p style={{ ...BT.label(9, .28), textAlign:'center', animation:'fade-in 3s ease 1.5s backwards' }}>touch the name</p>}
      </div>
      {flowDone && <ContinueHint />}
    </div>
  );
}

// III · The Smallest Thing — subtraction; then every walker who ever arrived
function MSmallest({ pace, setDot, next }) {
  const [stage, setStage] = useState(0);
  const [lit, setLit] = useState({});
  const field = useRef(Array.from({ length: 44 }, (_, i) => ({
    x: 8 + Math.random() * 84, y: 10 + Math.random() * 72, d: Math.random() * 4, id: i,
  }))).current;
  useEffect(() => { setDot({ x:50, y:24, size:14, glow:1, visible:true, breathing:true }); }, []);
  useEffect(() => {
    // the dot shrinks as the subtraction strips everything away
    if (stage === 1) setDot(d => ({ ...d, size:8, glow:.8 }));
  }, [stage]);
  const subtraction = 'What is structurally true at this position: you have arrived as the smallest thing consciousness can be. A point. No dimension. No direction. No history. No future.';
  const walkers = 'Every walker who arrives at Bindu arrives at the same place, because there is only one place this small. The variations begin at the next register. Here, every walker is identical — reduced to what they share with every other Bindu that has ever arrived. You are not the first.';
  return (
    <div data-screen-label="Practice III · The Smallest Thing" onClick={() => stage === 2 && next()}
      style={{ position:'absolute', inset:0, cursor: stage === 2 ? 'pointer' : 'default' }}>
      <VoiceMark name="Bindu · Recognize" color="#A57D22" />
      {stage >= 1 && field.map(p => (
        <div key={p.id} onClick={(e) => { e.stopPropagation(); setLit(l => ({ ...l, [p.id]: true })); }}
          style={{ position:'absolute', left:p.x + '%', top:p.y + '%', width:'24px', height:'24px', margin:'-12px', zIndex:12,
            display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer',
            animation:`fade-in 3s ease ${p.d}s backwards` }}>
          <div style={{ width: lit[p.id] ? '5px' : '3px', height: lit[p.id] ? '5px' : '3px', borderRadius:'50%',
            background:'#C9A84C', opacity: lit[p.id] ? .95 : .3, transition:'all 1.2s ease',
            boxShadow: lit[p.id] ? '0 0 12px rgba(201,168,76,.8)' : 'none' }}></div>
        </div>
      ))}
      <div style={{ position:'absolute', left:'46px', right:'46px', top:'38%', zIndex:10, pointerEvents:'none' }}>
        {stage === 0 && <SentenceFlow text={subtraction} pace={pace} replace style={{ ...BT.serif(22, .84) }}
          emph={['A point.']} onDone={() => setStage(1)} />}
        {stage >= 1 && <SentenceFlow text={walkers} pace={pace} window={3} style={{ ...BT.serif(18.5, .8) }}
          emph={['You are not the first.']} onDone={() => setStage(2)} />}
      </div>
      {stage === 1 && <ContinueHint label="each point was someone — touch them" />}
      {stage === 2 && <ContinueHint />}
    </div>
  );
}

// IV · The Asking — GAIA. The room floods green; Bindu listens, unseen.
function MGaia({ pace, setDot, next }) {
  const [held, setHeld] = useState(false);
  const [answer, setAnswer] = useState(false);
  const [flowDone, setFlowDone] = useState(false);
  useEffect(() => { setDot(d => ({ ...d, visible:false })); }, []);
  const onAnswer = () => {
    setAnswer(true); setFlowDone(true);
    setDot({ x:50, y:80, size:14, glow:2.4, visible:true, breathing:true });  // the answer arrives
  };
  return (
    <div data-screen-label="Practice IV · The Asking (Gaia)" onClick={() => flowDone && next()}
      onPointerDown={() => !held && setHeld(true)}
      style={{ position:'absolute', inset:0, cursor:'pointer', touchAction:'none' }}>
      <div style={{ position:'absolute', inset:0, zIndex:0, animation:'fade-in 2.8s ease',
        background:'radial-gradient(circle at 50% 46%, #17372D 0%, #0B211A 74%)' }}>
        <div style={{ position:'absolute', left:'-20%', top:'10%', width:'80%', height:'40%', borderRadius:'50%',
          background:'radial-gradient(ellipse, rgba(72,128,100,.16), transparent 70%)', filter:'blur(20px)',
          animation:'gaia-drift 16s ease-in-out infinite alternate' }}></div>
        <div style={{ position:'absolute', right:'-25%', bottom:'8%', width:'90%', height:'44%', borderRadius:'50%',
          background:'radial-gradient(ellipse, rgba(52,108,84,.18), transparent 70%)', filter:'blur(24px)',
          animation:'gaia-drift 19s ease-in-out infinite alternate-reverse' }}></div>
      </div>
      <VoiceMark name="Gaia" color="#7FB89A" />
      {held && !answer && [0, 1, 2, 3].map(i => (
        <div key={i} style={{ position:'absolute', left:'50%', top:'38%', width:'80px', height:'80px', margin:'-40px',
          borderRadius:'50%', border:'1px solid rgba(127,184,154,.4)', pointerEvents:'none', zIndex:3,
          animation:`converge ${5.5 * pace}s linear ${i * 1.4 * pace}s infinite` }}></div>
      ))}
      <div style={{ position:'absolute', left:'46px', right:'46px', top:'34%', zIndex:10, pointerEvents:'none' }}>
        {held
          ? <SentenceFlow text={P()[3]} pace={pace * 1.1} window={4} gold="#9FCCAF"
              style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'19px', color:'rgba(228,238,226,.86)', lineHeight:1.75, textWrap:'pretty', textAlign:'center' }}
              emph={['You are one of the answers.']} onDone={onAnswer} />
          : <p style={{ fontFamily:"'DM Sans',sans-serif", fontSize:'9px', letterSpacing:'.26em', textTransform:'uppercase',
              color:'rgba(228,238,226,.35)', textAlign:'center', animation:'fade-in 3s ease 1.5s backwards' }}>
              the ground is asking — touch it, and stay</p>}
      </div>
      {flowDone && <ContinueHint dark />}
    </div>
  );
}

// V · The Trinity — LALITA. The dot becomes the room.
function MLalita({ pace, setDot, next }) {
  const [phase, setPhase] = useState('intro');
  const [found, setFound] = useState({});
  const [flowDone, setFlowDone] = useState(false);
  const three = [
    { id:'red',   label:'Kurukulla — red, the feminine',  x:32, y:40, bg:'radial-gradient(circle at 40% 35%, #D4604F, #A5291B)' },
    { id:'white', label:'Varahi — white, the masculine',  x:68, y:40, bg:'radial-gradient(circle at 40% 35%, #FFFDF6, #E8DFC8)' },
    { id:'union', label:'their union — the individual soul', x:50, y:64, bg:'linear-gradient(130deg, #C9524A 20%, #F3EBD8 80%)' },
  ];
  const allFound = three.every(t => found[t.id]);
  useEffect(() => { setDot({ x:50, y:58, size:14, glow:1.2, visible:true, breathing:true }); }, []);
  useEffect(() => {
    if (phase === 'zoom') {
      setDot({ x:50, y:50, size:1400, glow:1, visible:true, breathing:false });   // the dot IS the room now
      const t = setTimeout(() => setPhase('inside'), 3100); return () => clearTimeout(t);
    }
    if (phase === 'inside' && allFound) { const t = setTimeout(() => setPhase('merged'), 2400); return () => clearTimeout(t); }
    if (phase === 'merged') {
      const t = setTimeout(() => {
        setDot({ x:50, y:26, size:16, glow:1.6, visible:true, breathing:true });  // back out — one point again
        setPhase('text');
      }, 4400);
      return () => clearTimeout(t);
    }
  }, [phase, allFound]);
  const inside = phase === 'inside' || phase === 'merged';
  return (
    <div data-screen-label="Practice V · The Trinity (Lalita)" onClick={() => flowDone && next()}
      style={{ position:'absolute', inset:0, cursor: flowDone ? 'pointer' : 'default' }}>
      <VoiceMark name="Lalita" color={inside ? '#8A5E10' : '#B5822A'} />
      {phase === 'intro' && (
        <div style={{ position:'absolute', left:'44px', right:'44px', top:'26%', zIndex:10 }}>
          <SentenceFlow text={'Lalita Mahatripurasundari — the Shakti of the Bindu, the presiding consciousness of Avarana 9 (Sarvanandamaya Chakra, the All-Blissful) — is the game knowing itself as the player.'}
            pace={pace} window={3} style={{ ...BT.serif(19.5, .82) }} emph={['the game knowing itself as the player']} />
          <p style={{ ...BT.label(8.5, .3), textAlign:'center', marginTop:'240px', animation:'fade-in 2.5s ease 6s backwards' }}>look closer — touch the point</p>
        </div>
      )}
      {phase === 'intro' && <DotHit x={50} y={58} r={44} onTouch={() => setPhase('zoom')} />}
      {inside && (
        <div style={{ position:'absolute', inset:0, zIndex:10, animation:'fade-in 1.8s ease 1.2s backwards' }}>
          <p style={{ ...BT.italic(15, .55), position:'absolute', top:'16%', left:'44px', right:'44px', textAlign:'center', color:'rgba(74,50,8,.66)' }}>
            Inside the single point you could cover with your fingertip, three sub-bindus are already alive.
          </p>
          {three.map(t => {
            const isFound = found[t.id], merged = phase === 'merged';
            return (
              <div key={t.id} onClick={() => phase === 'inside' && setFound(f => ({ ...f, [t.id]: true }))}
                style={{ position:'absolute', left: merged ? '50%' : t.x + '%', top: merged ? '46%' : t.y + '%',
                  transition:'left 2.6s cubic-bezier(.5,0,.3,1), top 2.6s cubic-bezier(.5,0,.3,1), opacity 2.6s ease',
                  opacity: merged ? 0 : 1, cursor:'pointer', display:'flex', flexDirection:'column', alignItems:'center', gap:'12px',
                  transform:'translate(-50%,-50%)' }}>
                <div style={{ width:'30px', height:'30px', borderRadius:'50%', background:t.bg,
                  boxShadow: isFound ? '0 0 22px rgba(120,70,10,.45)' : '0 0 10px rgba(120,70,10,.2)',
                  animation:`breathe ${3.4 + (t.x % 1.3)}s ease-in-out infinite`, transition:'box-shadow 1.4s ease' }}></div>
                <span style={{ fontFamily:"'Cormorant Garamond',serif", fontStyle:'italic', fontSize:'12.5px',
                  color:'rgba(74,50,8,.75)', opacity: isFound && !merged ? 1 : 0, transition:'opacity 1.6s ease', whiteSpace:'nowrap' }}>{t.label}</span>
              </div>
            );
          })}
          {phase === 'merged' && (
            <div style={{ position:'absolute', left:'50%', top:'46%', transform:'translate(-50%,-50%)' }}>
              <div style={{ width:'16px', height:'16px', borderRadius:'50%', margin:'0 auto',
                background:'radial-gradient(circle at 42% 38%, #E8C568, #B8860B 75%)',
                boxShadow:'0 0 26px rgba(140,90,20,.6)', animation:'fade-in 2.4s ease 1.6s backwards, breathe 4s ease-in-out infinite' }}></div>
              <svg width="180" height="160" viewBox="0 0 180 160" style={{ position:'absolute', left:'50%', top:'50%', transform:'translate(-50%,-52%)', animation:'fade-in 2s ease 2.2s backwards', opacity:.5 }}>
                <path d="M90 18 L162 138 L18 138 Z" fill="none" stroke="rgba(120,70,10,.5)" strokeWidth=".8"/>
                <path d="M90 142 L18 30 L162 30 Z" fill="none" stroke="rgba(120,70,10,.35)" strokeWidth=".7"/>
              </svg>
            </div>
          )}
          {phase === 'inside' && !allFound && <ContinueHint label="touch each of the three" />}
        </div>
      )}
      {phase === 'text' && (
        <div style={{ position:'absolute', left:'46px', right:'46px', top:'38%', zIndex:10, animation:'fade-in 1.8s ease' }}>
          <SentenceFlow text={'The trinity hidden in the dot. What looks like simplicity is already infinite. The Bindu is not an enclosure. The Bindu is the source of all enclosures. The entire Sri Yantra is contained inside this point you are.'}
            pace={pace} window={4} style={{ ...BT.serif(20.5, .84) }} emph={['this point you are']} onDone={() => setFlowDone(true)} />
        </div>
      )}
      {flowDone && <ContinueHint />}
    </div>
  );
}

// VI · Recognition — the dot ceases breathing; the room holds absolutely still
function MRecognition({ pace, setDot, next }) {
  const [flowDone, setFlowDone] = useState(false);
  useEffect(() => {
    setDot({ x:50, y:34, size:14, glow:.9, visible:true, breathing:false });     // ceased
    const t = setTimeout(() => setDot(d => ({ ...d, breathing:true, glow:1.2 })), 10000 * pace);
    return () => clearTimeout(t);
  }, []);
  return (
    <div data-screen-label="Practice VI · Recognition" onClick={() => flowDone && next()}
      style={{ position:'absolute', inset:0, cursor: flowDone ? 'pointer' : 'default' }}>
      <VoiceMark name="Bindu · Recognize" color="#A57D22" />
      <div style={{ position:'absolute', left:'46px', right:'46px', top:'44%', zIndex:10 }}>
        <SentenceFlow text={P()[5]} pace={pace * 1.3} style={{ ...BT.serif(21, .84) }}
          emph={['ceasing the thing that was preventing it']} onDone={() => setFlowDone(true)} />
      </div>
      {flowDone && <ContinueHint />}
    </div>
  );
}

// VII · The Way Back — the triangle draws itself around the dot
function MWayBack({ pace, setDot, next }) {
  const [flowDone, setFlowDone] = useState(false);
  useEffect(() => { setDot({ x:50, y:28.5, size:11, glow:1, visible:true, breathing:true }); }, []);
  return (
    <div data-screen-label="Practice VII · The Way Back" onClick={() => flowDone && next()}
      style={{ position:'absolute', inset:0, cursor: flowDone ? 'pointer' : 'default' }}>
      <VoiceMark name="Bindu · Recognize" color="#A57D22" />
      <svg width="120" height="106" viewBox="0 0 120 106" style={{ position:'absolute', left:'50%', top:'27%', transform:'translate(-50%,-50%)', zIndex:4 }}>
        <path d="M60 8 L112 98 L8 98 Z" fill="none" stroke="rgba(201,168,76,.65)" strokeWidth="1"
          strokeDasharray="330" strokeDashoffset="330" style={{ animation:`draw-in ${6 * pace}s ease forwards` }}/>
      </svg>
      <div style={{ position:'absolute', left:'46px', right:'46px', top:'42%', zIndex:10 }}>
        <SentenceFlow text={P()[6]} pace={pace} window={4} style={{ ...BT.serif(19, .82) }}
          emph={['Bindu = Lalita.', 'The same point.']} onDone={() => setFlowDone(true)} />
      </div>
      {flowDone && <ContinueHint label="touch — your point is next" />}
    </div>
  );
}

// VIII · The Point — the dot that walked with you comes to rest where your hand chooses
function MPlacePoint({ pace, setDot, setPt, next }) {
  const [placed, setPlaced] = useState(null);
  useEffect(() => { setDot({ x:50, y:16, size:12, glow:1, visible:true, breathing:true }); }, []);
  const place = (e) => {
    if (placed) return;
    const r = e.currentTarget.getBoundingClientRect();
    const p = { x: ((e.clientX - r.left) / r.width) * 100, y: ((e.clientY - r.top) / r.height) * 100 };
    setPlaced(p); setPt(p);
    setDot({ x:p.x, y:p.y, size:14, glow:1.4, visible:true, breathing:true });    // Bindu travels to your choice
    setTimeout(next, 4200 * pace);
  };
  return (
    <div data-screen-label="Bindu · Place the Point" onPointerDown={place}
      style={{ position:'absolute', inset:0, cursor: placed ? 'default' : 'pointer', touchAction:'none' }}>
      {!placed && <p style={{ ...BT.italic(15, .5), position:'absolute', top:'26%', left:'46px', right:'46px', textAlign:'center', zIndex:10 }}>
        {BINDU().practice.writing_prompt}</p>}
      {placed && <div style={{ animation:'fade-in .5s ease 2.5s backwards' }}><Ripples x={placed.x} y={placed.y} /></div>}
    </div>
  );
}

// ── Orchestrator: the stage that carries the one dot ──
function BinduPractice({ pace, showNC, onDone }) {
  const B = BINDU();
  const [mv, setMv] = useState(0);
  const [dot, setDotRaw] = useState({ x:50, y:34, size:14, glow:1, visible:true, breathing:true });
  const [lean, setLean] = useState({ x:0, y:0 });
  const [pt, setPt] = useState(null);
  const [deeper, setDeeper] = useState(false);
  const stageRef = useRef(null);
  const setDot = useCallback((v) => setDotRaw(prev => (typeof v === 'function' ? v(prev) : { ...prev, ...v })), []);
  const next = useCallback(() => setMv(m => m + 1), []);

  // the dot leans, slightly, toward the walker's finger — alive
  const onMove = (e) => {
    const r = stageRef.current?.getBoundingClientRect(); if (!r) return;
    const dx = e.clientX - (r.left + r.width * dot.x / 100);
    const dy = e.clientY - (r.top + r.height * dot.y / 100);
    const len = Math.hypot(dx, dy) || 1, pull = Math.min(5, len * 0.02);
    setLean({ x: (dx / len) * pull, y: (dy / len) * pull });
  };

  const reflection = paras(B.practice.bindu_reflection);
  const goDeeper = paras(B.practice.go_deeper);

  const movements = [
    <MContact pace={pace} setDot={setDot} next={next} />,
    <MName pace={pace} setDot={setDot} next={next} />,
    <MSmallest pace={pace} setDot={setDot} next={next} />,
    <MGaia pace={pace} setDot={setDot} next={next} />,
    <MLalita pace={pace} setDot={setDot} next={next} />,
    <MRecognition pace={pace} setDot={setDot} next={next} />,
    <MWayBack pace={pace} setDot={setDot} next={next} />,
    <MPlacePoint pace={pace} setDot={setDot} setPt={setPt} next={next} />,
    // post-writing — the dot rests where you placed it
    <div data-screen-label="Bindu · Practice" onClick={next} style={{ position:'absolute', inset:0, cursor:'pointer' }}>
      <div style={{ position:'absolute', left:'46px', right:'46px', bottom:'16%', zIndex:10 }}>
        <p style={{ ...BT.serif(18, .78), textAlign:'center', animation:'emerge 2.2s ease' }}>{B.practice.post_writing}</p>
        <p style={{ ...BT.label(8.5, .22), textAlign:'center', marginTop:'28px' }}>touch to continue</p>
      </div>
    </div>,
    <MudraM pace={pace} setDot={setDot} pt={pt} onDone={next} />,
    // reflection — the dot stays at your point the whole read
    <div data-screen-label="Bindu · Reflection" style={{ position:'absolute', inset:0 }}>
      <TapPaced passages={reflection} size={19.5} slow={pace * 1.15} label="Bindu" onDone={next} doneHint="touch" bare />
    </div>,
    <UnfoldingM pt={pt} setDot={setDot} onDone={next} />,
  ];

  const atEnd = mv >= movements.length;
  return (
    <div ref={stageRef} onPointerMove={onMove} onPointerLeave={() => setLean({ x:0, y:0 })}
      style={{ height:'100%', position:'relative', background:BINDU_GROUND, overflow:'hidden' }}>
      {!atEnd && <div key={mv} style={{ position:'absolute', inset:0, animation:'fade-in 1.6s ease' }}>{movements[mv]}</div>}
      {atEnd && !deeper && (
        <div data-screen-label="Bindu · Practice" style={{ position:'absolute', inset:0, display:'flex',
          flexDirection:'column', justifyContent:'center', padding:'0 46px', animation:'fade-in 1.4s ease', zIndex:10 }}>
          <CreamDoor title="Leave the room" sub="" onOpen={onDone} delay={.3} />
          <CreamDoor title="Go deeper" sub="three more ways in" onOpen={() => setDeeper(true)} delay={.7} />
        </div>
      )}
      {atEnd && deeper && (
        <div data-screen-label="Bindu · Go Deeper" style={{ position:'absolute', inset:0, zIndex:10 }}>
          <TapPaced passages={goDeeper} size={18.5} slow={pace * 1.2} onDone={onDone} doneHint="touch to leave" bare />
        </div>
      )}
      <LivingDot d={atEnd ? { ...dot, x:50, y:30, size:13, glow:1 } : dot} lean={lean} />
    </div>
  );
}

// The mudra — the dot returns to center for three breaths, then back to your point
function MudraM({ pace, setDot, pt, onDone }) {
  const [breaths, setBreaths] = useState(0);
  const cycle = 8 * pace;
  useEffect(() => { setDot({ x:50, y:52.5, size:9, glow:1, visible:true, breathing:true }); }, []);
  useEffect(() => {
    if (breaths >= 3) {
      if (pt) setDot({ x:pt.x, y:pt.y, size:12, glow:1, visible:true, breathing:true });  // the way back works
      const t = setTimeout(onDone, 2600); return () => clearTimeout(t);
    }
    const t = setTimeout(() => setBreaths(b => b + 1), cycle * 1000);
    return () => clearTimeout(t);
  }, [breaths]);
  return (
    <div data-screen-label="Bindu · Yoni Mudra" style={{ position:'absolute', inset:0 }}>
      <p style={{ ...BT.italic(15.5, .55), position:'absolute', top:'22%', left:'52px', right:'52px', textAlign:'center', animation:'emerge 2s ease', zIndex:10 }}>
        Bring both hands together — thumbs touching, index fingers touching — the triangle between them. The womb gesture. Hold it for three breaths.
      </p>
      <svg width="110" height="96" viewBox="0 0 110 96" style={{ position:'absolute', left:'50%', top:'50%', transform:'translate(-50%,-50%)', zIndex:4,
        animation:`breathe ${cycle}s ease-in-out infinite` }}>
        <path d="M55 8 L102 88 L8 88 Z" fill="none" stroke="rgba(201,168,76,.6)" strokeWidth="1"/>
      </svg>
      <p style={{ ...BT.label(9, .3), position:'absolute', top:'64%', left:0, right:0, textAlign:'center', zIndex:10, minHeight:'12px' }}>
        {breaths >= 3 ? '' : ['first breath', 'second breath', 'third breath'][breaths]}
      </p>
    </div>
  );
}

// The unfolding — 32 faint points spiral out from where the dot came to rest
function UnfoldingM({ pt, setDot, onDone }) {
  const cx = pt ? pt.x : 50, cy = pt ? pt.y : 46;
  useEffect(() => { setDot({ x:cx, y:cy, size:14, glow:1.3, visible:true, breathing:true }); }, []);
  const pts = useRef(Array.from({ length: 32 }, (_, i) => {
    const a = i * 0.62, r = 12 + i * 4.2;
    return { x: cx + Math.cos(a) * r * 0.62, y: cy + Math.sin(a) * r * 0.44, d: 1 + i * 0.22 };
  })).current;
  return (
    <div data-screen-label="Bindu · The Unfolding" onClick={onDone} style={{ position:'absolute', inset:0, cursor:'pointer' }}>
      {pts.map((p, i) => (
        <div key={i} style={{ position:'absolute', left:p.x + '%', top:p.y + '%', width:'3px', height:'3px', zIndex:4,
          borderRadius:'50%', background:'#C9A84C', opacity:0, animation:`spiral-point 3.4s ease ${p.d}s forwards` }}></div>
      ))}
      <p style={{ ...BT.serif(20, .82), position:'absolute', left:'46px', right:'46px', bottom:'18%', textAlign:'center',
        animation:'emerge 2.8s ease 6s backwards', zIndex:10 }}>
        You already placed it. The rest is the unfolding.
      </p>
      <ContinueHint label="touch to rest" />
    </div>
  );
}

Object.assign(window, { BinduPractice, SentenceFlow, VoiceMark });
