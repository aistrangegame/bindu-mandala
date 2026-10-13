// shell-moments.jsx — Day 19 moments: the floor, wake-up, practice, corridor, Sakshi close.
const { useState, useEffect, useRef } = React;
const D19 = () => window.WALK_CANON_LITE.day19;

// soft synthesized tone (zero audio assets — canon law)
function playShellTone(hz, seconds) {
  const AC = window.AudioContext || window.webkitAudioContext;
  let ctx; try { ctx = new AC(); } catch (e) { return () => {}; }
  const now = ctx.currentTime;
  const master = ctx.createGain(); master.connect(ctx.destination);
  master.gain.setValueAtTime(0, now);
  master.gain.linearRampToValueAtTime(0.16, now + 2.5);
  master.gain.setValueAtTime(0.16, now + seconds - 3);
  master.gain.linearRampToValueAtTime(0, now + seconds);
  [1, 2, 3].forEach((h, i) => {
    const o = ctx.createOscillator(), g = ctx.createGain();
    o.type = 'sine'; o.frequency.value = hz * h;
    g.gain.value = [1, .18, .05][i];
    o.connect(g); g.connect(master); o.start(now); o.stop(now + seconds + .1);
  });
  const t = setTimeout(() => { try { ctx.close(); } catch (e) {} }, (seconds + 1) * 1000);
  return () => { clearTimeout(t); try { ctx.close(); } catch (e) {} };
}

// ── One-second floor: Blink. Breathe. Press. — a complete day ──
function FloorOneSecond({ pace, onDone }) {
  const [step, setStep] = useState('blink');           // blink → breathe → press → complete
  const [phase, setPhase] = useState('');
  const [held, setHeld] = useState(0);
  const holdRef = useRef(null);
  const f = D19().floor;

  useEffect(() => {
    if (step !== 'breathe') return;
    const b = f.breath, s = 1000 * pace;
    setPhase('in');
    const t1 = setTimeout(() => setPhase('hold'), b.inhale * s);
    const t2 = setTimeout(() => setPhase('out'), (b.inhale + b.hold) * s);
    const t3 = setTimeout(() => setStep('press'), (b.inhale + b.hold + b.exhale) * s + 400);
    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, [step]);

  useEffect(() => {
    if (step !== 'complete') return;
    writeWalkEvent('floor', 'Blink. Breathe. Press. — a full day of walking.', 'Sakshi');
    const t = setTimeout(onDone, 4200 * pace + 1600);
    return () => clearTimeout(t);
  }, [step]);

  const startHold = () => {
    const t0 = Date.now();
    holdRef.current = setInterval(() => {
      const p = Math.min(1, (Date.now() - t0) / f.hold_ms);
      setHeld(p);
      if (p >= 1) { clearInterval(holdRef.current); setStep('complete'); }
    }, 40);
  };
  const endHold = () => { clearInterval(holdRef.current); if (step === 'press') setHeld(0); };

  const ring = (pct, breathing) => (
    <div style={{ width:'120px', height:'120px', borderRadius:'50%', position:'relative', margin:'34px auto 0',
      border:'1px solid rgba(240,232,220,.16)',
      animation: breathing ? `breathe ${(f.breath.inhale + f.breath.hold + f.breath.exhale) * pace}s ease-in-out infinite` : 'none' }}>
      <svg width="120" height="120" style={{ position:'absolute', inset:0, transform:'rotate(-90deg)' }}>
        <circle cx="60" cy="60" r="58" fill="none" stroke="rgba(232,197,104,.75)" strokeWidth="1.5"
          strokeDasharray={2 * Math.PI * 58} strokeDashoffset={2 * Math.PI * 58 * (1 - pct)} style={{ transition:'stroke-dashoffset .05s linear' }}/>
      </svg>
    </div>
  );

  return (
    <div onClick={() => step === 'blink' && setStep('breathe')}
      style={{ height:'100%', display:'flex', flexDirection:'column', justifyContent:'center', padding:'0 44px', textAlign:'center', animation:'fade-in .9s ease', cursor: step==='blink'?'pointer':'default' }}>
      {step === 'blink' && (<div style={{ animation:'emerge 1s ease' }}>
        <p style={ST.serif(34)}>Blink.</p>
        <p style={{ ...ST.italic(14, .42), marginTop:'18px' }}>One deliberate blink.<br/>Felt as a crossing.</p>
        <p style={{ ...ST.label(9, .28), marginTop:'46px' }}>then touch the glass</p>
      </div>)}
      {step === 'breathe' && (<div style={{ animation:'emerge 1s ease' }}>
        <p style={ST.serif(34)}>Breathe.</p>
        {ring(0, true)}
        <p style={{ ...ST.label(9, .3), marginTop:'26px', minHeight:'12px' }}>{phase === 'in' ? 'in · four' : phase === 'hold' ? 'hold · four' : 'out · four'}</p>
      </div>)}
      {step === 'press' && (<div style={{ animation:'emerge 1s ease' }}>
        <p style={ST.serif(34)}>Press.</p>
        <div onMouseDown={startHold} onMouseUp={endHold} onMouseLeave={endHold}
          onTouchStart={startHold} onTouchEnd={endHold} style={{ cursor:'pointer' }}>
          {ring(held, false)}
        </div>
        <p style={{ ...ST.label(9, .28), marginTop:'26px' }}>press and hold</p>
      </div>)}
      {step === 'complete' && (<div style={{ animation:'emerge 1.6s ease' }}>
        <p style={ST.serif(24, .9)}>{D19().floor.completion.text.split('. ')[0]}.</p>
        <p style={{ ...ST.italic(17, .5), marginTop:'16px' }}>Everything else today is extra.</p>
      </div>)}
    </div>
  );
}

// ── Wake-up: one sound. Nothing to do. Ends on one word. ──
function WakeupMoment({ pace, showNC, onDone }) {
  const [stage, setStage] = useState('sound');
  const w = D19().wakeup;
  const secs = Math.max(8, 90 * pace * 0.2);
  useEffect(() => {
    const stop = playShellTone(w.hz, secs);
    const t1 = setTimeout(() => setStage('word'), secs * 1000);
    return () => { stop(); clearTimeout(t1); };
  }, []);
  useEffect(() => {
    if (stage !== 'word') return;
    writeWalkEvent('wakeup', 'One sound, played through. ' + w.end_word.text, null);
    const t = setTimeout(onDone, 2600);   // the app closes it before the walker can linger
    return () => clearTimeout(t);
  }, [stage]);
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'0 44px', textAlign:'center', animation:'fade-in 1.2s ease' }}>
      {stage === 'sound' ? (<div>
        <div style={{ width:'8px', height:'8px', borderRadius:'50%', background:'rgba(232,197,104,.8)', margin:'0 auto 40px', animation:'breathe 4s ease-in-out infinite', boxShadow:'0 0 26px rgba(232,197,104,.5)' }}></div>
        <p style={{ ...ST.italic(16, .55), whiteSpace:'pre-line' }}>{w.line.text}<NC show={showNC && !w.line.canon} /></p>
      </div>) : (
        <p style={{ ...ST.serif(38), animation:'emerge 1.2s ease' }}>{w.end_word.text}</p>
      )}
    </div>
  );
}

// ── Practice: Anahata vignette — the room opens, grace may surface ──
function PracticeMoment({ pace, showNC, onDone }) {
  const p = D19().practice;
  const room = WALK_CANON_LITE.rooms[p.room - 1];
  const [beat, setBeat] = useState(0);   // 0,1 teaching · 2 question+write · 3 grace+reflection · 4 gate shape
  const [text, setText] = useState('');
  const advance = () => setBeat(b => b + 1);
  const finish = () => {
    writeWalkEvent('practice', 'Opened the heart. Wrote to: ' + p.question.text, room.voice);
    onDone();
  };
  const widen = 44 - beat * 4; // space widens as the room opens (register)
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', justifyContent:'center',
      padding:`0 ${widen}px`, transition:'padding 1.5s ease', animation:'fade-in 1s ease',
      background:`radial-gradient(ellipse at 50% 20%, ${room.color_hex}14 0%, transparent 65%)` }}>
      <p style={{ ...ST.label(9, .32), marginBottom:'26px' }}>{room.name} · {room.verb}</p>
      {beat <= 1 && (
        <div onClick={advance} style={{ cursor:'pointer' }}>
          <p style={{ ...ST.serif(22), animation:'emerge 1.2s ease' }} key={beat}>{p.teaching[beat].text}</p>
          <p style={{ ...ST.label(9, .24), marginTop:'44px' }}>touch to continue</p>
        </div>
      )}
      {beat === 2 && (<div style={{ animation:'emerge 1.2s ease' }}>
        <p style={ST.serif(26)}>{p.question.text}</p>
        <textarea value={text} onChange={e => setText(e.target.value)} rows={4} placeholder="write, or don't"
          style={{ width:'100%', marginTop:'26px', background:'rgba(240,232,220,.045)', border:'1px solid rgba(240,232,220,.14)',
            borderRadius:'4px', padding:'14px', color:'rgba(240,232,220,.85)', fontFamily:"'Cormorant Garamond',serif", fontSize:'16px', resize:'none' }} />
        <button onClick={advance} style={{ marginTop:'20px', background:'none', border:'none', cursor:'pointer', ...ST.label(10, .45), padding:'12px 0' }}>continue →</button>
      </div>)}
      {beat === 3 && (<div style={{ animation:'emerge 1.4s ease' }}>
        <p style={ST.italic(15, .44)}>{p.grace.text}<NC show={showNC && !p.grace.canon} kind="register example" /></p>
        <p style={{ ...ST.serif(20), marginTop:'34px' }}>{p.reflection.text}<NC show={showNC && !p.reflection.canon} /></p>
        <button onClick={advance} style={{ marginTop:'40px', background:'none', border:'none', cursor:'pointer', ...ST.label(10, .45), padding:'12px 0' }}>continue →</button>
      </div>)}
      {beat >= 4 && (<div onClick={finish} style={{ animation:'emerge 1.4s ease', cursor:'pointer', display:'flex', flexDirection:'column', alignItems:'center', gap:'22px' }}>
        <SealedGate hex={room.color_hex} />
        <p style={ST.italic(14, .4)}>The gate knows how to wait too.</p>
        <p style={{ ...ST.label(9, .24) }}>touch to leave the room</p>
      </div>)}
    </div>
  );
}

// ── The corridor: three-breath entry, unvoiced story, the pulse begins ──
function CorridorMoment({ pace, showNC, pulseMode, onDone }) {
  const c = D19().corridor;
  const [entered, setEntered] = useState(false);
  const [idx, setIdx] = useState(-1);    // -1 entry · 0..n passages · n signature · n+1 exit
  useEffect(() => {
    const t1 = setTimeout(() => { setEntered(true); setIdx(0); }, 6500 * pace + 1200);
    return () => clearTimeout(t1);
  }, []);
  const last = c.passages.length;        // signature index
  const done = idx > last;
  const advance = () => { if (entered && !done) setIdx(i => i + 1); };
  const exit = () => {
    writeWalkEvent('corridor', 'Walked the corridor. ' + c.signature.text, null);
    onDone();
  };
  return (
    <div onClick={advance} style={{ height:'100%', position:'relative', background:'#020103', cursor: done ? 'default' : 'pointer' }}>
      <ShellStarfield opacity={0.16} />
      {/* three-breath dark entry — brightness eases down unbidden, no title */}
      <div style={{ position:'absolute', inset:0, background:'#000', opacity: entered ? 0 : 1,
        transition:`opacity ${6.5 * pace + 1}s ease-in`, pointerEvents:'none', zIndex:20,
        display:'flex', alignItems:'center', justifyContent:'center' }}>
        <div style={{ width:'60px', height:'60px', borderRadius:'50%', border:'1px solid rgba(240,232,220,.14)',
          animation:`breathe ${2.2 * pace + 1.2}s ease-in-out infinite` }}></div>
      </div>
      <div style={{ position:'absolute', inset:0, display:'flex', flexDirection:'column', justifyContent:'center', padding:'0 46px', zIndex:10 }}>
        {idx >= 0 && idx < last && (
          <p key={idx} style={{ ...ST.serif(20, .78), animation:'emerge 1.6s ease' }}>
            {c.passages[idx].text}<NC show={showNC && !c.passages[idx].canon} />
          </p>
        )}
        {idx === last && (
          <p style={{ ...ST.italic(22, .68), animation:'emerge 2.2s ease' }}>{c.signature.text}</p>
        )}
        {idx >= 0 && !done && <p style={{ ...ST.label(9, .18), marginTop:'50px' }}>touch to continue</p>}
      </div>
      {/* exit: the dark thins at one edge — never a door rising */}
      {done && (
        <div onClick={exit} style={{ position:'absolute', top:0, right:0, bottom:0, width:'88px', cursor:'pointer', zIndex:30,
          background:'linear-gradient(to left, rgba(122,21,21,.20) 0%, transparent 100%)', animation:'fade-in 4s ease' }}></div>
      )}
      {idx === last && !done && (
        <div onClick={() => setIdx(last + 1)} style={{ position:'absolute', inset:0, zIndex:25 }}></div>
      )}
      <ThePulse mode={pulseMode} />
    </div>
  );
}

// ── Sakshi day-close: one sentence. Witnessing, never accounting. ──
function SakshiClose({ walked, onDone }) {
  const cl = D19().close;
  const parts = ['floor', 'wakeup', 'practice', 'corridor'].filter(k => walked.includes(k)).map(k => cl.fragments[k]);
  let sentence;
  if (parts.length === 0) sentence = cl.waited.nothing;
  else {
    const list = parts.length === 1 ? parts[0] : parts.slice(0, -1).join(', ') + (parts.length > 2 ? ',' : '') + ' and ' + parts[parts.length - 1];
    sentence = 'You ' + (list.startsWith('opened') || list.startsWith('walked') ? list : 'walked ' + list) + '.';
    if (!walked.includes('corridor')) sentence += ' ' + cl.waited.corridor;
  }
  useEffect(() => { writeWalkEvent('close', sentence, 'Sakshi'); }, []);
  return (
    <div onClick={onDone} style={{ height:'100%', display:'flex', flexDirection:'column', justifyContent:'center', padding:'0 46px', textAlign:'center', cursor:'pointer', animation:'fade-in 1.6s ease' }}>
      <p style={ST.italic(19, .66)}>{sentence}</p>
      <p style={{ ...ST.label(9, .2), marginTop:'60px' }}>touch to rest</p>
    </div>
  );
}

Object.assign(window, { FloorOneSecond, WakeupMoment, PracticeMoment, CorridorMoment, SakshiClose, playShellTone });
