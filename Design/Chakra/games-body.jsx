// games-body.jsx — Body Map, Spine Walk, Shake to Clear
const { useState, useEffect, useRef } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

// ─── BODY MAP ─────────────────────────────────────────────────────────────────
const BODY_KEY = 'game_bodymap_v1';
const MODES    = ['alive','tight','absent'];
const MODE_CFG = {
  alive:  { color:'#80E5BC', label:'Alive',  desc:'Where do you feel energy?' },
  tight:  { color:'#E89080', label:'Tight',  desc:'Where do you feel held?'   },
  absent: { color:'#8090C0', label:'Absent', desc:'Where do you feel nothing?' },
};

function GBodyMap({ game, onReturn }) {
  const canvasRef = useRef(null);
  const [mode, setMode] = useState('alive');
  const [sessions, setSessions] = useState(()=>{try{return JSON.parse(localStorage.getItem(BODY_KEY)||'[]');}catch{return [];}});

  function drawAll(ctx, W, H, currentSession=null) {
    ctx.fillStyle='#03080A'; ctx.fillRect(0,0,W,H);

    // Body outline SVG-equivalent in canvas
    const cx=W/2, top=H*.08, bH=H*.84;
    ctx.strokeStyle='rgba(255,255,255,.12)'; ctx.lineWidth=1.2; ctx.lineCap='round'; ctx.lineJoin='round';

    // Head
    ctx.beginPath(); ctx.arc(cx, top+bH*.09, bH*.07, 0, Math.PI*2); ctx.stroke();
    // Torso
    ctx.beginPath();
    ctx.moveTo(cx-bH*.09, top+bH*.17); ctx.lineTo(cx-bH*.12, top+bH*.52);
    ctx.lineTo(cx-bH*.07, top+bH*.54); ctx.lineTo(cx-bH*.07, top+bH*.78);
    ctx.moveTo(cx+bH*.09, top+bH*.17); ctx.lineTo(cx+bH*.12, top+bH*.52);
    ctx.lineTo(cx+bH*.07, top+bH*.54); ctx.lineTo(cx+bH*.07, top+bH*.78);
    ctx.moveTo(cx-bH*.09, top+bH*.17); ctx.lineTo(cx+bH*.09, top+bH*.17);
    ctx.stroke();
    // Arms
    ctx.beginPath();
    ctx.moveTo(cx-bH*.09, top+bH*.17); ctx.lineTo(cx-bH*.22, top+bH*.25); ctx.lineTo(cx-bH*.26, top+bH*.50);
    ctx.moveTo(cx+bH*.09, top+bH*.17); ctx.lineTo(cx+bH*.22, top+bH*.25); ctx.lineTo(cx+bH*.26, top+bH*.50);
    ctx.stroke();
    // Legs
    ctx.beginPath();
    ctx.moveTo(cx-bH*.07, top+bH*.78); ctx.lineTo(cx-bH*.09, top+bH*.92); ctx.lineTo(cx-bH*.09, top+bH*.99);
    ctx.moveTo(cx+bH*.07, top+bH*.78); ctx.lineTo(cx+bH*.09, top+bH*.92); ctx.lineTo(cx+bH*.09, top+bH*.99);
    ctx.stroke();

    // Heat map from all sessions
    const allDots=[...sessions.flatMap(s=>s.dots), ...(currentSession?.dots||[])];
    allDots.forEach(dot=>{
      const cfg=MODE_CFG[dot.mode];
      const grad=ctx.createRadialGradient(dot.x,dot.y,0,dot.x,dot.y,22);
      grad.addColorStop(0,cfg.color+'70');
      grad.addColorStop(1,cfg.color+'00');
      ctx.beginPath(); ctx.arc(dot.x,dot.y,22,0,Math.PI*2);
      ctx.fillStyle=grad; ctx.fill();
    });
  }

  const sessionRef=useRef({dots:[]});

  function getPos(e){
    const c=canvasRef.current, r=c.getBoundingClientRect();
    const src=e.touches?.[0]||e;
    return {x:src.clientX-r.left, y:src.clientY-r.top, mode};
  }

  function tap(e){
    e.preventDefault();
    const p=getPos(e);
    sessionRef.current.dots=[...sessionRef.current.dots,p];
    const c=canvasRef.current; drawAll(c.getContext('2d'),c.width,c.height,sessionRef.current);
  }

  function save(){
    if(!sessionRef.current.dots.length) return;
    const next=[...sessions.slice(-29),{...sessionRef.current,ts:Date.now()}];
    setSessions(next); localStorage.setItem(BODY_KEY,JSON.stringify(next));
    sessionRef.current={dots:[]};
    const c=canvasRef.current; drawAll(c.getContext('2d'),c.width,c.height);
  }

  useEffect(()=>{
    const c=canvasRef.current; if(!c) return;
    c.width=c.offsetWidth; c.height=c.offsetHeight;
    drawAll(c.getContext('2d'),c.width,c.height);
  },[sessions]);

  const dayCount=new Set(sessions.map(s=>new Date(s.ts).toDateString())).size;

  return(
    <GShell game={game} onReturn={onReturn}>
      <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
        {/* Mode selector */}
        <div style={{display:'flex',gap:'6px',padding:'4px 16px 6px',flexShrink:0,justifyContent:'center'}}>
          {MODES.map(m=>(
            <button key={m} onClick={()=>setMode(m)} style={{flex:1,padding:'8px 0',borderRadius:'16px',border:`1px solid ${mode===m?MODE_CFG[m].color:MODE_CFG[m].color+'30'}`,background:mode===m?`${MODE_CFG[m].color}20`:'none',color:mode===m?MODE_CFG[m].color:'rgba(240,232,220,.45)',fontFamily:"'Cormorant Garamond',serif",fontSize:'14px',cursor:'pointer',transition:'all .2s'}}>
              {MODE_CFG[m].label}
            </button>
          ))}
        </div>
        <p style={{...T.italic(13,.38),textAlign:'center',flexShrink:0,marginBottom:'2px'}}>{MODE_CFG[mode].desc}</p>

        {/* Canvas body */}
        <canvas ref={canvasRef}
          onMouseDown={tap} onTouchStart={tap}
          style={{flex:1,width:'100%',touchAction:'none',cursor:'crosshair',display:'block'}}/>

        {/* Footer */}
        <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',padding:'6px 20px 14px',flexShrink:0}}>
          <p style={{...T.label(9,.28)}}>{dayCount} day{dayCount!==1?'s':''} mapped · {sessions.length} sessions</p>
          {sessionRef.current?.dots?.length>0&&(
            <button onClick={save} style={{padding:'8px 20px',borderRadius:'20px',background:`${game.color}20`,border:`1px solid ${game.color}45`,fontFamily:"'Cormorant Garamond',serif",fontSize:'14px',color:'rgba(240,232,220,.75)',cursor:'pointer',letterSpacing:'.1em',textTransform:'uppercase',animation:'emerge .3s ease'}}>Save</button>
          )}
        </div>
      </div>
    </GShell>
  );
}

// ─── SPINE WALK ───────────────────────────────────────────────────────────────
const CHAKRA_CENTERS = [
  {name:'Root',     y:.92, color:'#A83232', freq:396},
  {name:'Sacral',   y:.78, color:'#C45A18', freq:417},
  {name:'Solar',    y:.64, color:'#C49B17', freq:528},
  {name:'Heart',    y:.50, color:'#1A8060', freq:639},
  {name:'Throat',   y:.37, color:'#1E6EA0', freq:741},
  {name:'Third Eye',y:.24, color:'#4A3AAB', freq:852},
  {name:'Crown',    y:.10, color:'#8A3AB5', freq:963},
];

function GSpine({ game, onReturn }) {
  const [dotY,   setDotY]   = useState(0.5);
  const [moving, setMoving] = useState(false);
  const [taps,   setTaps]   = useState([]); // {chakra, duration}
  const [current,setCurrent]= useState(null);
  const [done,   setDone]   = useState(false);
  const startRef = useRef(null);
  const containerRef = useRef(null);

  function getNearestChakra(y) {
    return CHAKRA_CENTERS.reduce((best,c)=>Math.abs(c.y-y)<Math.abs(best.y-y)?c:best, CHAKRA_CENTERS[0]);
  }

  function handleMove(e){
    e.preventDefault();
    const rect=containerRef.current?.getBoundingClientRect(); if(!rect) return;
    const src=e.touches?.[0]||e;
    const relY=Math.max(0,Math.min(1,(src.clientY-rect.top)/rect.height));
    setDotY(relY);
    setCurrent(getNearestChakra(relY));
  }

  function handleStart(e){setMoving(true);startRef.current=Date.now();handleMove(e);}
  function handleEnd(){
    if(!current||!startRef.current) return;
    setMoving(false);
    const dur=Date.now()-startRef.current;
    setTaps(prev=>{
      const next=[...prev,{chakra:current.name,color:current.color,duration:dur}];
      if(next.length>=7) setDone(true);
      return next;
    });
    startRef.current=null;
  }

  if(done) return(
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={50} opacity={.28}/>
      <div style={{position:'relative',zIndex:2,height:'100%',display:'flex',flexDirection:'column',padding:'20px 24px'}}>
        <p style={{...T.sacred(20,.80),textAlign:'center',marginBottom:'16px'}}>Your attention map.</p>
        <div style={{flex:1,display:'flex',flexDirection:'column',gap:'8px'}}>
          {CHAKRA_CENTERS.map(c=>{
            const t=taps.filter(tp=>tp.chakra===c.name).reduce((a,b)=>a+b.duration,0);
            const max=Math.max(...taps.map(tp=>tp.duration),1);
            const pct=Math.min(100,Math.round((t/max)*100));
            return(
              <div key={c.name} style={{display:'flex',alignItems:'center',gap:'10px'}}>
                <div style={{width:'56px',textAlign:'right'}}>
                  <p style={{fontFamily:"'Cormorant Garamond',serif",fontSize:'13px',color:`${c.color}`,opacity:.8}}>{c.name}</p>
                </div>
                <div style={{flex:1,height:'6px',borderRadius:'3px',background:'rgba(255,255,255,.06)'}}>
                  <div style={{height:'100%',borderRadius:'3px',background:c.color,width:`${pct}%`,transition:'width .6s ease'}}/>
                </div>
                <p style={{...T.label(8,.30),width:'30px'}}>{t>0?`${(t/1000).toFixed(1)}s`:''}</p>
              </div>
            );
          })}
        </div>
        <p style={{...T.italic(14,.38),textAlign:'center',marginTop:'16px',marginBottom:'20px'}}>No centre is wrong. This is your pattern.</p>
        <Btn onClick={()=>{setTaps([]);setDone(false);setCurrent(null);}} color={game.color} accent={game.accent} style={{alignSelf:'center'}}>Walk again</Btn>
      </div>
    </GShell>
  );

  return(
    <GShell game={game} onReturn={onReturn}>
      <div ref={containerRef} style={{height:'100%',display:'flex',position:'relative',overflow:'hidden'}}
        onMouseMove={moving?handleMove:undefined} onMouseDown={handleStart} onMouseUp={handleEnd}
        onTouchMove={handleMove} onTouchStart={handleStart} onTouchEnd={handleEnd}
        onMouseLeave={handleEnd}>
        <Starfield count={45} opacity={.26}/>

        {/* Spine SVG */}
        <svg style={{position:'absolute',inset:0,width:'100%',height:'100%',zIndex:1}} preserveAspectRatio="none">
          <line x1="50%" y1="5%" x2="50%" y2="95%" stroke="rgba(200,185,240,.12)" strokeWidth="1.5"/>
          {CHAKRA_CENTERS.map(c=>(
            <g key={c.name}>
              <circle cx="50%" cy={`${c.y*100}%`} r="5" fill={`${c.color}35`} stroke={`${c.color}60`} strokeWidth=".8"/>
            </g>
          ))}
          {/* Moving dot */}
          <circle cx="50%" cy={`${dotY*100}%`} r="14" fill={`${current?.color||'#fff'}30`}
            stroke={current?.color||'rgba(255,255,255,.4)'} strokeWidth="1.5" style={{transition:'cy .06s,stroke .3s,fill .3s'}}/>
        </svg>

        {/* Chakra labels on right */}
        <div style={{position:'absolute',right:'24px',top:0,bottom:0,display:'flex',flexDirection:'column',justifyContent:'space-between',padding:'6% 0',zIndex:2,pointerEvents:'none'}}>
          {CHAKRA_CENTERS.map(c=>(
            <p key={c.name} style={{...T.label(8,.35),color:`${c.color}`,opacity:current?.name===c.name?1:.45,transition:'opacity .2s',textAlign:'right'}}>{c.name}</p>
          ))}
        </div>

        {/* Instruction / current */}
        <div style={{position:'absolute',bottom:'16px',left:0,right:0,textAlign:'center',zIndex:2,pointerEvents:'none'}}>
          {current
            ? <p style={{...T.italic(16,.70),color:current.color}}>{current.name}</p>
            : <p style={{...T.italic(14,.38)}}>Drag the light up and down your spine.</p>}
          <p style={{...T.label(9,.28),marginTop:'4px'}}>{taps.length} / 7 centres visited</p>
        </div>
      </div>
    </GShell>
  );
}

// ─── SHAKE TO CLEAR ───────────────────────────────────────────────────────────
const THOUGHT_WORDS = [
  'deadline','should have','what if','not enough','tomorrow','remember','sorry','always',
  'never','too much','too little','they said','I said','why did I','I should','maybe',
  'one more','I meant to','almost','eventually','if only','somehow','I know','but still'
];

function GShake({ game, onReturn }) {
  const [phase,   setPhase]   = useState('intro');
  const [words,   setWords]   = useState([]);
  const [cleared, setCleared] = useState(false);
  const canvasRef = useRef(null);
  const wordsRef  = useRef([]);
  const rafRef    = useRef(null);
  const shakeRef  = useRef(0);

  // Spawn floating words
  useEffect(()=>{
    if(phase!=='thinking') return;
    const W=370, H=680;
    wordsRef.current = THOUGHT_WORDS.map((w,i)=>({
      text:w, x:30+Math.random()*(W-80), y:40+Math.random()*(H-80),
      vx:(Math.random()-.5)*.4, vy:(Math.random()-.5)*.3,
      opacity:0.15+Math.random()*.5, size:11+Math.floor(Math.random()*10),
      scattered:false,
    }));
  },[phase]);

  // Animation loop
  useEffect(()=>{
    if(phase==='cleared') return;
    const c=canvasRef.current; if(!c) return;
    const ctx=c.getContext('2d');
    c.width=c.offsetWidth; c.height=c.offsetHeight;
    const W=c.width, H=c.height;

    function draw(){
      ctx.fillStyle=`#07050E`; ctx.fillRect(0,0,W,H);
      const ws=wordsRef.current;
      ws.forEach(w=>{
        w.x+=w.vx*(1+(shakeRef.current*4));
        w.y+=w.vy*(1+(shakeRef.current*4));
        if(w.x<-100||w.x>W+100||w.y<-100||w.y>H+100) w.scattered=true;
        ctx.globalAlpha=Math.max(0,w.opacity*(1-shakeRef.current));
        ctx.fillStyle='rgba(200,185,240,1)';
        ctx.font=`${w.size}px 'Cormorant Garamond', serif`;
        ctx.fillText(w.text,w.x,w.y);
      });
      ctx.globalAlpha=1;
      shakeRef.current=Math.max(0,shakeRef.current-0.04);
      if(ws.every(w=>w.scattered)){ setPhase('cleared'); return; }
      rafRef.current=requestAnimationFrame(draw);
    }
    rafRef.current=requestAnimationFrame(draw);
    return()=>cancelAnimationFrame(rafRef.current);
  },[phase]);

  // Device shake detection
  useEffect(()=>{
    if(phase!=='thinking') return;
    let lastAcc={x:0,y:0,z:0};
    function handleMotion(e){
      const acc=e.accelerationIncludingGravity||e.acceleration;
      if(!acc) return;
      const delta=Math.abs((acc.x||0)-lastAcc.x)+Math.abs((acc.y||0)-lastAcc.y)+Math.abs((acc.z||0)-lastAcc.z);
      lastAcc={x:acc.x||0,y:acc.y||0,z:acc.z||0};
      if(delta>18) shakeRef.current=Math.min(1,shakeRef.current+0.3);
    }
    window.addEventListener('devicemotion',handleMotion);
    return()=>window.removeEventListener('devicemotion',handleMotion);
  },[phase]);

  // Click-shake fallback
  function clickShake(){
    shakeRef.current=Math.min(1,shakeRef.current+0.5);
    wordsRef.current.forEach(w=>{
      w.vx+=(Math.random()-.5)*3;
      w.vy+=(Math.random()-.5)*3;
    });
  }

  return(
    <GShell game={game} onReturn={onReturn}>
      {phase==='intro'&&(
        <div style={{height:'100%',display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',gap:'24px',padding:'40px',textAlign:'center',animation:'emerge .8s ease'}}>
          <Starfield count={50} opacity={.30}/>
          <div style={{position:'relative',zIndex:2}}>
            <p style={{...T.sacred(26,.85),marginBottom:'12px',lineHeight:1.4}}>Shake the thoughts loose.</p>
            <p style={{...T.italic(17,.40),marginBottom:'36px',lineHeight:1.7}}>All of it. The loops,<br/>the lists, the replays.<br/>Let them scatter.</p>
            <Btn onClick={()=>setPhase('thinking')} color={game.color} accent={game.accent}>Begin</Btn>
          </div>
        </div>
      )}

      {phase==='thinking'&&(
        <div style={{height:'100%',position:'relative'}} onClick={clickShake}>
          <canvas ref={canvasRef} style={{position:'absolute',inset:0,width:'100%',height:'100%',cursor:'pointer'}}/>
          <div style={{position:'absolute',bottom:'20px',left:0,right:0,textAlign:'center',pointerEvents:'none',zIndex:2}}>
            <p style={{...T.italic(14,.40)}}>Shake your phone — or tap to scatter.</p>
          </div>
        </div>
      )}

      {phase==='cleared'&&(
        <div style={{height:'100%',display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',gap:'24px',padding:'40px',textAlign:'center',animation:'emerge 1s ease',background:`radial-gradient(ellipse at 50% 50%,${game.color}08,transparent)`}}>
          <Starfield count={70} opacity={.50}/>
          <div style={{position:'relative',zIndex:2}}>
            <div style={{width:'80px',height:'80px',borderRadius:'50%',background:`radial-gradient(circle,${game.accent}35,${game.color}50)`,boxShadow:`0 0 40px ${game.color}60`,margin:'0 auto 24px',animation:'breathe 4s ease-in-out infinite'}}/>
            <p style={{...T.sacred(30,.90),marginBottom:'12px'}}>Only the field remains.</p>
            <p style={{...T.italic(17,.45),marginBottom:'36px',lineHeight:1.7,maxWidth:'240px'}}>This is what was here<br/>before the thinking started.</p>
            <Btn onClick={onReturn} color={game.color} accent={game.accent}>Return</Btn>
          </div>
        </div>
      )}
    </GShell>
  );
}

Object.assign(window, { GBodyMap, GSpine, GShake });
