// bindu-moments.jsx — Bindu's five walkable moments: story, practice, wake-up, gate.
// All prose is canon-true from Walk Canon v1.0. Interface copy is marked.
const { useState, useEffect, useRef } = React;

const paras = (s) => (s || '').split(/\n\n+/).map(p => p.trim()).filter(Boolean);

// ── Tap-paced reader: one passage, centered and alone ──
function TapPaced({ passages, size = 21, italic = false, slow = 1, label, onDone, doneHint, bare = false }) {
  const [i, setI] = useState(0);
  const last = i >= passages.length - 1;
  const cur = passages[i];
  return (
    <div onClick={() => (last ? onDone() : setI(i + 1))}
      style={{ height:'100%', background: bare ? 'transparent' : BINDU_GROUND, display:'flex', flexDirection:'column',
        justifyContent:'center', padding:'0 46px', cursor:'pointer', userSelect:'none', WebkitUserSelect:'none' }}>
      {label && <p style={{ ...BT.label(9, .3), textAlign:'center', marginBottom:'34px' }}>{label}</p>}
      <p key={i} style={{ ...(italic ? BT.italic(size, .6) : BT.serif(size, .82)), textAlign:'center',
        whiteSpace:'pre-line', animation:`emerge ${2 * slow}s ease` }}>{cur}</p>
      <p style={{ ...BT.label(8.5, .22), textAlign:'center', marginTop:'46px' }}>
        {last ? (doneHint || 'touch to leave') : 'touch to continue'}
      </p>
    </div>
  );
}

// ── STORY — Bindu's voice, then the unannounced interlude ──
function BinduStory({ pace, showNC, onDone }) {
  const B = BINDU();
  const [part, setPart] = useState('thread');   // thread → hush → interlude
  const thread = paras(B.story.story_thread);
  const interlude = paras(B.story.interlude);
  useEffect(() => {
    if (part !== 'hush') return;
    const t = setTimeout(() => setPart('interlude'), 3400 * pace);
    return () => clearTimeout(t);
  }, [part]);
  if (part === 'thread') return (
    <div data-screen-label="Bindu · Story" style={{ height:'100%' }}>
      <TapPaced passages={thread} slow={pace} label="Bindu" onDone={() => setPart('hush')} doneHint="touch" />
    </div>
  );
  if (part === 'hush') return (
    <div data-screen-label="Bindu · Story" style={{ height:'100%', background:BINDU_GROUND }}></div>
  );
  // The interlude: no voice mark. Sakshi is never announced.
  return (
    <div data-screen-label="Bindu · Interlude" style={{ height:'100%' }}>
      <TapPaced passages={interlude} size={19} italic slow={pace * 1.2} onDone={onDone} doneHint="go" />
    </div>
  );
}

// ── PRACTICE — teaching one line at a time, the point, the mudra, the reflection ──
function BinduPracticeV1({ pace, showNC, onDone }) {
  const B = BINDU();
  const [stage, setStage] = useState('teaching'); // teaching → canvas → post → mudra → reflection → deeper?
  const [pt, setPt] = useState(null);
  const [deeper, setDeeper] = useState(false);
  const teaching = paras(B.practice.teaching);
  const reflection = paras(B.practice.bindu_reflection);
  const goDeeper = paras(B.practice.go_deeper);

  if (stage === 'teaching') return (
    <div data-screen-label="Bindu · Practice" style={{ height:'100%' }}>
      <TapPaced passages={teaching} size={19.5} slow={pace * 1.35} label={`${B.identity.name} · ${B.identity.verb}`}
        onDone={() => setStage('canvas')} doneHint="touch — the canvas is next" />
    </div>
  );

  if (stage === 'canvas') return (
    <div data-screen-label="Bindu · Practice Canvas"
      onPointerDown={e => {
        if (pt) return;
        const r = e.currentTarget.getBoundingClientRect();
        setPt({ x: (e.clientX - r.left) / r.width, y: (e.clientY - r.top) / r.height });
        setTimeout(() => setStage('post'), 2600 * pace);
      }}
      style={{ height:'100%', background:BINDU_GROUND, position:'relative', cursor:'pointer', touchAction:'none' }}>
      {!pt && <p style={{ ...BT.italic(15, .5), position:'absolute', top:'12%', left:'46px', right:'46px', textAlign:'center' }}>
        {B.practice.writing_prompt}
      </p>}
      {pt && <div style={{ position:'absolute', left:`calc(${pt.x * 100}% - 6px)`, top:`calc(${pt.y * 100}% - 6px)`, animation:'fade-in 1.2s ease' }}>
        <BreathingDot size={12} />
      </div>}
    </div>
  );

  if (stage === 'post') return (
    <div data-screen-label="Bindu · Practice" onClick={() => setStage('mudra')}
      style={{ height:'100%', background:BINDU_GROUND, position:'relative', cursor:'pointer' }}>
      {pt && <div style={{ position:'absolute', left:`calc(${pt.x * 100}% - 6px)`, top:`calc(${pt.y * 100}% - 6px)` }}>
        <BreathingDot size={12} />
      </div>}
      <div style={{ position:'absolute', left:'46px', right:'46px', bottom:'18%' }}>
        <p style={{ ...BT.serif(18, .78), textAlign:'center', animation:'emerge 2.2s ease' }}>{B.practice.post_writing}</p>
        <p style={{ ...BT.label(8.5, .22), textAlign:'center', marginTop:'30px' }}>touch to continue</p>
      </div>
    </div>
  );

  if (stage === 'mudra') return <YoniMudraV1 pace={pace} onDone={() => setStage('reflection')} />;

  if (stage === 'reflection') return (
    <div data-screen-label="Bindu · Reflection" style={{ height:'100%' }}>
      <TapPaced passages={reflection} size={19.5} slow={pace * 1.2}
        onDone={() => setDeeper(false) || setStage('close')} doneHint="touch" />
    </div>
  );

  // close: rest, with the quiet go-deeper door
  if (stage === 'close' && !deeper) return (
    <div data-screen-label="Bindu · Practice" style={{ height:'100%', background:BINDU_GROUND, display:'flex',
      flexDirection:'column', justifyContent:'center', padding:'0 46px', animation:'fade-in 1.4s ease' }}>
      <div style={{ display:'flex', justifyContent:'center', marginBottom:'40px' }}><BreathingDot /></div>
      <CreamDoor title="Leave the room" sub="" onOpen={onDone} delay={.3} />
      <CreamDoor title="Go deeper" sub="three more ways in" onOpen={() => setDeeper(true)} delay={.7} />
    </div>
  );

  return (
    <div data-screen-label="Bindu · Go Deeper" style={{ height:'100%' }}>
      <TapPaced passages={goDeeper} size={18.5} slow={pace * 1.2} onDone={onDone} doneHint="touch to leave" />
    </div>
  );
}

// The Yoni Mudra — three breaths inside the triangle. Return to source.
function YoniMudraV1({ pace, onDone }) {
  const [breaths, setBreaths] = useState(0);
  const cycle = 8 * pace;  // one slow breath
  useEffect(() => {
    if (breaths >= 3) { const t = setTimeout(onDone, 1200); return () => clearTimeout(t); }
    const t = setTimeout(() => setBreaths(b => b + 1), cycle * 1000);
    return () => clearTimeout(t);
  }, [breaths]);
  return (
    <div data-screen-label="Bindu · Yoni Mudra" style={{ height:'100%', background:BINDU_GROUND, display:'flex',
      flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'0 52px', textAlign:'center' }}>
      <p style={{ ...BT.italic(15.5, .55), animation:'emerge 2s ease' }}>
        Bring both hands together — thumbs touching, index fingers touching — the triangle between them. The womb gesture. Hold it for three breaths.
      </p>
      <svg width="110" height="96" viewBox="0 0 110 96" style={{ marginTop:'44px', animation:`breathe ${cycle}s ease-in-out infinite` }}>
        <path d="M55 8 L102 88 L8 88 Z" fill="none" stroke="rgba(201,168,76,.6)" strokeWidth="1"/>
        <circle cx="55" cy="64" r="4" fill="#C9A84C" opacity=".8"/>
      </svg>
      <p style={{ ...BT.label(9, .3), marginTop:'38px', minHeight:'12px' }}>
        {breaths >= 3 ? '' : ['first breath', 'second breath', 'third breath'][breaths]}
      </p>
    </div>
  );
}

// ── WAKE-UP — no sound. One point of contact IS the frequency. Ends on one word. ──
function BinduWakeup({ pace, showNC, onDone }) {
  const B = BINDU();
  const [stage, setStage] = useState('instruction'); // instruction → holding → word
  const still = useStillTouch(7000 * pace, () => setStage('word'), stage !== 'word');
  useEffect(() => {
    if (stage !== 'word') return;
    binduWalkEvent('wakeup', 'One point of contact. ' + 'Recognized.');
    const t = setTimeout(onDone, 3000);
    return () => clearTimeout(t);
  }, [stage]);
  if (stage === 'word') return (
    <div data-screen-label="Bindu · Wake-up" style={{ height:'100%', background:BINDU_GROUND, display:'flex',
      alignItems:'center', justifyContent:'center' }}>
      <p style={{ ...BT.serif(36, .85), animation:'emerge 1.6s ease' }}>Recognized.<BNC show={showNC} kind="composed" /></p>
    </div>
  );
  return (
    <div {...still.handlers} data-screen-label="Bindu · Wake-up"
      style={{ height:'100%', background:BINDU_GROUND, display:'flex', flexDirection:'column',
        justifyContent:'center', padding:'0 50px', textAlign:'center', cursor:'pointer', touchAction:'none', userSelect:'none', WebkitUserSelect:'none' }}>
      <p style={{ ...BT.serif(19, .78), whiteSpace:'pre-line', animation:'emerge 2s ease' }}>{B.wakeup.frequency_practice}</p>
      <p style={{ ...BT.italic(13.5, .4), marginTop:'34px' }}>{B.wakeup.bija}</p>
      <div style={{ height:'40px', marginTop:'30px', display:'flex', justifyContent:'center' }}>
        {still.holding && <BreathingDot size={10} glow={1 + still.progress * 2} breath={2.4} />}
      </div>
      {!still.holding && <p style={{ ...BT.label(8.5, .24) }}>hold still, here, on the glass<BNC show={showNC} kind="interface" /></p>}
    </div>
  );
}

// ── GATE — the walk's only Canvas gate. The offering leaves. ──
function BinduGate({ pace, showNC, onGiven, onDone }) {
  const B = BINDU();
  const [stage, setStage] = useState('interaction'); // interaction → canvas → held → leaving → kept → gatetext → after → signature
  const [pt, setPt] = useState(null);
  const inter = paras(B.gate.gate_interaction).filter(p => !/^Button:/.test(p));
  const gateText = paras(B.gate.gate_text);
  const afterStory = paras(B.story.after_story);

  useEffect(() => {
    if (stage === 'held') {
      const t = setTimeout(() => setStage('leaving'), 4600 * pace);
      return () => clearTimeout(t);
    }
    if (stage === 'leaving') {
      const t = setTimeout(() => setStage('kept'), 3400);
      return () => clearTimeout(t);
    }
  }, [stage]);

  const place = (e) => {
    if (pt) return;
    const r = e.currentTarget.getBoundingClientRect();
    const p = { x: (e.clientX - r.left) / r.width, y: (e.clientY - r.top) / r.height };
    setPt(p);
    try {
      const off = JSON.parse(localStorage.getItem('bindu-offerings') || '[]');
      off.push({ room: 1, x: p.x, y: p.y, ts: new Date().toISOString() });
      localStorage.setItem('bindu-offerings', JSON.stringify(off));  // one unseen point of 33
    } catch (err) {}
    binduWalkEvent('gate', 'The point has been placed.');
    onGiven(p);
    setStage('held');
  };

  if (stage === 'interaction') return (
    <div data-screen-label="Bindu · Gate" style={{ height:'100%' }}>
      <TapPaced passages={inter} size={20} slow={pace} onDone={() => setStage('canvas')} doneHint="touch — then place the point" />
    </div>
  );

  if (stage === 'canvas' || stage === 'held' || stage === 'leaving') return (
    <div data-screen-label="Bindu · Gate Canvas" onPointerDown={stage === 'canvas' ? place : undefined}
      style={{ height:'100%', background:BINDU_GROUND, position:'relative', cursor: pt ? 'default' : 'pointer', touchAction:'none' }}>
      {pt && (
        <div style={{ position:'absolute', left:`calc(${pt.x * 100}% - 7px)`, top:`calc(${pt.y * 100}% - 7px)`,
          animation: stage === 'leaving' ? 'lift-away 3.2s ease-in forwards' : 'fade-in 1.4s ease' }}>
          <BreathingDot size={14} breath={4.6 * pace} />
        </div>
      )}
      {stage === 'leaving' && (
        <p style={{ ...BT.italic(15, .5), position:'absolute', left:'46px', right:'46px', bottom:'16%',
          textAlign:'center', animation:'emerge 2.6s ease 1.2s backwards' }}>
          The room keeps what you gave it. You walk lighter.
        </p>
      )}
    </div>
  );

  if (stage === 'kept') return (
    <div data-screen-label="Bindu · Gate" style={{ height:'100%' }}>
      <TapPaced passages={gateText} size={20} slow={pace} onDone={() => setStage('after')} doneHint="keep moving" />
    </div>
  );

  if (stage === 'after') return (
    <div data-screen-label="Bindu · After" style={{ height:'100%' }}>
      <TapPaced passages={afterStory} slow={pace} label="Bindu" onDone={() => setStage('signature')} doneHint="touch" />
    </div>
  );

  return (
    <div data-screen-label="Bindu · Signature" onClick={onDone}
      style={{ height:'100%', background:BINDU_GROUND, display:'flex', flexDirection:'column',
        justifyContent:'center', padding:'0 46px', textAlign:'center', cursor:'pointer' }}>
      <div style={{ display:'flex', justifyContent:'center', marginBottom:'42px' }}><BreathingDot /></div>
      <p style={{ ...BT.serif(21, .8), animation:'emerge 2.4s ease' }}>{B.story.signature_phrase}</p>
      <p style={{ ...BT.label(8.5, .22), marginTop:'52px' }}>touch to return</p>
    </div>
  );
}

Object.assign(window, { TapPaced, BinduStory, BinduWakeup, BinduGate });
