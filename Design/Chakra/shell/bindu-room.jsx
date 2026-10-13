// bindu-room.jsx — Room 01 · BINDU — The Origin. Warm gold on cream.
// Register: a single breathing dot is the entire scene. No chrome. The moment
// before a story, not the first page of one.
const { useState, useEffect, useRef, useCallback } = React;

const BINDU = () => window.WALK_CANON.rooms.find(r => r.identity.book_position === 1);

// ── Type atoms on cream (ink = warm dark umber; gold = the room's blood) ──
const BT = {
  ink: (a) => `rgba(56,44,26,${a})`,
  gold: '#C9A84C', goldLight: '#E8C568',
  serif:  (size, op=.85) => ({ fontFamily:"'Cormorant Garamond',serif", fontSize:size+'px', color:`rgba(56,44,26,${op})`, lineHeight:1.5, textWrap:'pretty' }),
  italic: (size, op=.52) => ({ fontFamily:"'Cormorant Garamond',serif", fontStyle:'italic', fontSize:size+'px', color:`rgba(56,44,26,${op})`, lineHeight:1.7, textWrap:'pretty' }),
  label:  (size, op=.35) => ({ fontFamily:"'DM Sans',sans-serif", fontSize:size+'px', letterSpacing:'.26em', textTransform:'uppercase', color:`rgba(56,44,26,${op})` }),
};

// Non-canon marker (interface copy / composed connective tissue)
function BNC({ show, kind }) {
  if (!show) return null;
  return <span style={{ fontFamily:'ui-monospace,monospace', fontSize:'8.5px', letterSpacing:'.08em',
    color:'rgba(56,44,26,.30)', border:'1px dotted rgba(56,44,26,.25)', borderRadius:'3px',
    padding:'1px 5px', marginLeft:'8px', verticalAlign:'middle', whiteSpace:'nowrap' }}>{kind || 'non-canon'}</span>;
}

// The cream ground — Bindu IS the weather.
const BINDU_GROUND = 'radial-gradient(circle at 50% 40%, #F8F1DF 0%, #F2E7CC 62%, #EADCBA 100%)';

// ── The breathing dot — the entire scene ──
function BreathingDot({ size = 13, breath = 4.6, glow = 1, style }) {
  return (
    <div style={{ width:size+'px', height:size+'px', borderRadius:'50%',
      background:`radial-gradient(circle at 42% 38%, ${BT.goldLight}, ${BT.gold} 75%)`,
      boxShadow:`0 0 ${18*glow}px rgba(201,168,76,.55), 0 0 ${46*glow}px rgba(201,168,76,.28)`,
      animation:`breathe ${breath}s ease-in-out infinite`, ...style }}></div>
  );
}

// ── Still-touch: rest one finger on the glass and be still ──
// (One point of contact, meeting one point — the room's own frequency.)
function useStillTouch(ms, onComplete, enabled = true) {
  const [holding, setHolding] = useState(false);
  const [progress, setProgress] = useState(0);
  const ref = useRef({});
  const start = useCallback((e) => {
    if (!enabled) return;
    const r = ref.current;
    r.x = e.clientX; r.y = e.clientY; r.t0 = Date.now();
    setHolding(true);
    r.iv = setInterval(() => {
      const p = Math.min(1, (Date.now() - r.t0) / ms);
      setProgress(p);
      if (p >= 1) { clearInterval(r.iv); setHolding(false); onComplete(); }
    }, 40);
  }, [ms, onComplete, enabled]);
  const cancel = useCallback(() => {
    clearInterval(ref.current.iv); setHolding(false); setProgress(0);
  }, []);
  const move = useCallback((e) => {
    const r = ref.current;
    if (r.iv && (Math.abs(e.clientX - r.x) > 14 || Math.abs(e.clientY - r.y) > 14)) cancel();
  }, [cancel]);
  useEffect(() => () => clearInterval(ref.current.iv), []);
  return { holding, progress, handlers: { onPointerDown:start, onPointerUp:cancel, onPointerLeave:cancel, onPointerMove:move } };
}

// ── Arrival: threshold hint → the question, held → still touch opens ──
function BinduArrival({ pace, gesture, showNC, onEnter }) {
  const B = BINDU();
  const [beat, setBeat] = useState(0);  // 0 empty · 1 dot · 2 hint · 3 question · 4 affordance
  useEffect(() => {
    const ts = [
      setTimeout(() => setBeat(1), 1800 * pace),
      setTimeout(() => setBeat(2), 4600 * pace),
      setTimeout(() => setBeat(3), 9400 * pace),
      setTimeout(() => setBeat(4), 13800 * pace),
    ];
    return () => ts.forEach(clearTimeout);
  }, []);
  useEffect(() => {
    if (gesture !== 'wait' || beat < 4) return;
    const t = setTimeout(onEnter, 9000 * pace);
    return () => clearTimeout(t);
  }, [beat, gesture]);
  const still = useStillTouch(2600 * pace, onEnter, gesture === 'still-touch' && beat >= 3);
  return (
    <div {...still.handlers} data-screen-label="Bindu · Arrival"
      style={{ height:'100%', background:BINDU_GROUND, display:'flex', flexDirection:'column',
        alignItems:'center', justifyContent:'center', padding:'0 48px', textAlign:'center',
        cursor: beat >= 3 ? 'pointer' : 'default', touchAction:'none', userSelect:'none', WebkitUserSelect:'none' }}>
      <div style={{ height:'120px', display:'flex', alignItems:'center', justifyContent:'center' }}>
        {beat >= 1 && <div style={{ animation:'fade-in 3.2s ease' }}>
          <BreathingDot glow={still.holding ? 1 + still.progress * 1.6 : 1} />
        </div>}
      </div>
      <div style={{ minHeight:'28px', marginTop:'34px' }}>
        {beat >= 2 && <p style={{ ...BT.italic(15, .48), animation:'emerge 2.6s ease' }}>{B.arrival.threshold_hint}</p>}
      </div>
      <div style={{ minHeight:'70px', marginTop:'26px' }}>
        {beat >= 3 && <p style={{ ...BT.serif(24, .82), animation:'emerge 2.8s ease' }}>{B.arrival.core_question}</p>}
      </div>
      <div style={{ minHeight:'16px', marginTop:'44px' }}>
        {beat >= 4 && !still.holding && (
          <p style={{ ...BT.label(9, .3), animation:'fade-in 3s ease' }}>
            {gesture === 'wait' ? 'be here' : 'rest one finger on the glass, and be still'}<BNC show={showNC} kind="interface" />
          </p>
        )}
      </div>
    </div>
  );
}

// ── A door on cream — quiet serif line, hairline slit ──
function CreamDoor({ title, sub, dim, held, onOpen, delay = 0 }) {
  return (
    <button onClick={held ? undefined : onOpen} style={{ display:'flex', alignItems:'center', gap:'16px', width:'100%',
      background:'none', border:'none', cursor: held ? 'default' : 'pointer', padding:'12px 6px', textAlign:'left',
      opacity:0, animation:`emerge 1.6s ease ${delay}s forwards` }}>
      <span style={{ width:'1px', height:'28px', flexShrink:0, background:BT.ink(dim || held ? .15 : .3) }}></span>
      <span style={{ display:'flex', flexDirection:'column', gap:'2px', opacity: dim ? .42 : held ? .35 : 1, transition:'opacity 1s ease' }}>
        <span style={BT.serif(20, .8)}>{title}</span>
        {sub ? <span style={BT.italic(12.5, .4)}>{sub}</span> : null}
      </span>
    </button>
  );
}

// ── The room scene: the dot, the seed message, quiet doors, the warm gate ──
function BinduRoomScene({ state, showNC, onOpen }) {
  const B = BINDU();
  const th = state.threads;
  const gateWarm = th.story && th.practice && th.wakeup && !state.gate_given;
  const doors = [];
  if (!state.gate_given) {
    if (!th.story)    doors.push({ key:'story',    title:'The story',   sub:'in Bindu\u2019s voice' });
    if (!th.practice) doors.push({ key:'practice', title:'The practice', sub:'one line at a time' });
    if (!th.wakeup)   doors.push({ key:'wakeup',   title:'One sound.',  sub:'there is no sound yet' });
  }
  const walkedDoors = [];
  if (th.story && !state.gate_given)    walkedDoors.push({ key:'story',    title:'The story',    sub:'walked', dim:true });
  if (th.practice && !state.gate_given) walkedDoors.push({ key:'practice', title:'The practice', sub:'walked', dim:true });
  if (th.wakeup && !state.gate_given)   walkedDoors.push({ key:'wakeup',   title:'One sound.',   sub:'walked', dim:true });
  return (
    <div data-screen-label="Bindu · The Room" style={{ height:'100%', background:BINDU_GROUND, position:'relative' }}>
      <div style={{ position:'absolute', inset:0, display:'flex', flexDirection:'column', padding:'0 40px' }}>
        <div style={{ flex:'0 0 36%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'flex-end', gap:'30px' }}>
          <BreathingDot glow={state.gate_given ? .7 : 1} />
          <p style={{ ...BT.italic(15, .5), textAlign:'center', animation:'emerge 2.4s ease' }}>
            {state.gate_given ? B.story.signature_phrase : B.arrival.seed_message}
          </p>
        </div>
        <div style={{ flex:1, display:'flex', flexDirection:'column', justifyContent:'center', gap:'2px' }}>
          {state.gate_given ? (
            <p style={{ ...BT.label(9, .3), textAlign:'center', animation:'fade-in 3s ease' }}>walked</p>
          ) : gateWarm ? (
            <div>
              <div style={{ display:'flex', alignItems:'center', gap:'10px', padding:'0 6px', marginBottom:'6px', animation:'fade-in 2.5s ease' }}>
                <div style={{ width:'6px', height:'6px', borderRadius:'50%', background:'#D08A3E', animation:'ember 2.2s ease-in-out infinite' }}></div>
                <span style={BT.italic(13, .5)}>The gate is warm.</span>
              </div>
              <CreamDoor title="The gate" sub="the canvas is open" onOpen={() => onOpen('gate')} delay={.4} />
              {walkedDoors.map((d, i) => <CreamDoor key={d.key} {...d} onOpen={() => onOpen(d.key)} delay={.8 + i * .3} />)}
            </div>
          ) : (
            <div>
              {doors.map((d, i) => <CreamDoor key={d.key} {...d} onOpen={() => onOpen(d.key)} delay={.6 + i * .5} />)}
              {walkedDoors.map((d, i) => <CreamDoor key={d.key} {...d} onOpen={() => onOpen(d.key)} delay={.9 + i * .3} />)}
              {!state.gate_given && (th.story || th.practice || th.wakeup) && !gateWarm && (
                <div style={{ display:'flex', alignItems:'center', gap:'16px', padding:'12px 6px', opacity:0, animation:'emerge 1.6s ease 1.4s forwards' }}>
                  <SealedGlyph />
                  <span style={BT.italic(12.5, .35)}>The gate knows how to wait too.</span>
                </div>
              )}
            </div>
          )}
        </div>
        <div style={{ flex:'0 0 90px', display:'flex', alignItems:'flex-start', justifyContent:'center' }}>
          <p style={{ ...BT.label(8.5, .22) }}>{B.identity.sanskrit} · the origin</p>
        </div>
      </div>
    </div>
  );
}

function SealedGlyph() {
  return <div style={{ width:'18px', height:'26px', borderRadius:'9px 9px 2px 2px', flexShrink:0,
    border:'1px solid rgba(201,168,76,.5)', borderBottom:'2px solid rgba(201,168,76,.65)' }}></div>;
}

// ── Living witness — quiet ledger writes (shared key with the Shell) ──
function binduWalkEvent(moment, excerpt) {
  try {
    const led = JSON.parse(localStorage.getItem('bindu-shell-activity') || '[]');
    led.push({ ts: new Date().toISOString(), room: 1, moment, excerpt, surfaced: false });
    localStorage.setItem('bindu-shell-activity', JSON.stringify(led));
  } catch (e) {}
}

Object.assign(window, { BINDU, BT, BNC, BINDU_GROUND, BreathingDot, useStillTouch, BinduArrival, CreamDoor, BinduRoomScene, SealedGlyph, binduWalkEvent });
