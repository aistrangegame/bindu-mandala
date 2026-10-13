// games-pattern.jsx — SriYantra, The12Signs, Mandala Completion
const { useState, useEffect, useRef, useMemo } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

// ─── SRI YANTRA TRACE ─────────────────────────────────────────────────────────
// Simplified yantra: 9 triangles, traced one line at a time
const YANTRA_LINES = (() => {
  const cx=183, cy=230, r=90;
  const pts = (n,rad,off=0) => Array.from({length:n},(_,i)=>{
    const a=(i*2*Math.PI/n)+off-Math.PI/2;
    return [cx+rad*Math.cos(a), cy+rad*Math.sin(a)];
  });
  const outer = pts(3, r, 0);    // upward triangle
  const inner = pts(3, r*.72, Math.PI/3); // downward triangle
  const mid1  = pts(3, r*.88, 0);
  const mid2  = pts(3, r*.56, Math.PI/3);
  const lines = [];
  // 4 upward triangles
  [[outer,0],[outer,1],[outer,2],[mid1,0],[mid1,1],[mid1,2]].forEach(([tri,s])=>{
    const [a,b,c]=tri;
    lines.push([[a,b],[b,c],[c,a]][s%3]);
  });
  // 5 downward triangles
  [[inner,0],[inner,1],[inner,2],[mid2,0],[mid2,1],[mid2,2]].forEach(([tri,s])=>{
    const [a,b,c]=tri;
    lines.push([[c,b],[a,c],[b,a]][s%3]);
  });
  // outer circle outline (as 12 arcs/segments)
  for(let i=0;i<8;i++){
    const a1=(i/8)*Math.PI*2-Math.PI/2, a2=((i+1)/8)*Math.PI*2-Math.PI/2;
    lines.push([[cx+r*1.12*Math.cos(a1),cy+r*1.12*Math.sin(a1)],[cx+r*1.12*Math.cos(a2),cy+r*1.12*Math.sin(a2)]]);
  }
  return lines.slice(0,18); // 18 lines total
})();

function GYantra({ game, onReturn }) {
  const [done,    setDone]    = useState(() => new Set(JSON.parse(localStorage.getItem('yantra')||'[]')));
  const [current, setCurrent] = useState(() => {
    const d = new Set(JSON.parse(localStorage.getItem('yantra')||'[]'));
    return d.size < YANTRA_LINES.length ? d.size : -1;
  });
  const canvasRef = useRef(null);
  const tracing   = useRef(false);
  const tracePath = useRef([]);

  function dist(p1,p2){ return Math.hypot(p1[0]-p2[0],p1[1]-p2[1]); }

  function drawAll(ctx) {
    const c = canvasRef.current;
    ctx.fillStyle = '#07050E'; ctx.fillRect(0,0,c.width,c.height);
    // Circles
    [1.12,.98,.85].forEach(s=>{
      ctx.beginPath(); ctx.arc(183,230,90*s,0,Math.PI*2);
      ctx.strokeStyle=`${game.accent}12`; ctx.lineWidth=.8; ctx.stroke();
    });
    // Completed lines
    YANTRA_LINES.forEach(([a,b],i)=>{
      if (!done.has(i)) return;
      ctx.beginPath(); ctx.moveTo(a[0],a[1]); ctx.lineTo(b[0],b[1]);
      ctx.strokeStyle=`${game.accent}80`; ctx.lineWidth=1.8; ctx.lineCap='round'; ctx.stroke();
    });
    // Current guide
    if (current >= 0 && current < YANTRA_LINES.length) {
      const [a,b] = YANTRA_LINES[current];
      ctx.beginPath(); ctx.arc(a[0],a[1],7,0,Math.PI*2);
      ctx.fillStyle=`${game.color}60`; ctx.fill();
      ctx.beginPath(); ctx.arc(b[0],b[1],5,0,Math.PI*2);
      ctx.strokeStyle=`${game.color}40`; ctx.lineWidth=1; ctx.stroke();
      // Faint guide
      ctx.beginPath(); ctx.moveTo(a[0],a[1]); ctx.lineTo(b[0],b[1]);
      ctx.strokeStyle=`${game.color}18`; ctx.lineWidth=1; ctx.setLineDash([4,6]); ctx.stroke();
      ctx.setLineDash([]);
    }
    // Trace in progress
    if (tracePath.current.length > 1) {
      ctx.beginPath(); ctx.moveTo(tracePath.current[0][0],tracePath.current[0][1]);
      tracePath.current.forEach(p=>ctx.lineTo(p[0],p[1]));
      ctx.strokeStyle=`${game.accent}50`; ctx.lineWidth=2; ctx.stroke();
    }
  }

  useEffect(()=>{
    const c=canvasRef.current; if(!c) return;
    c.width=c.offsetWidth; c.height=c.offsetHeight;
    drawAll(c.getContext('2d'));
  },[done,current]);

  function getPos(e){
    const c=canvasRef.current, r=c.getBoundingClientRect();
    const src=e.touches?.[0]||e;
    return [src.clientX-r.left, src.clientY-r.top];
  }

  function onStart(e){ e.preventDefault(); if(current<0) return; tracing.current=true; tracePath.current=[getPos(e)]; }
  function onMove(e){ e.preventDefault(); if(!tracing.current) return; tracePath.current=[...tracePath.current,getPos(e)]; drawAll(canvasRef.current.getContext('2d')); }
  function onEnd(e){
    e.preventDefault(); if(!tracing.current||current<0) return; tracing.current=false;
    const path=tracePath.current; tracePath.current=[];
    if(path.length<4){drawAll(canvasRef.current.getContext('2d'));return;}
    const [tA,tB]=YANTRA_LINES[current];
    const start=path[0], end=path[path.length-1];
    // Check if traced near start→end or end→start
    const fwd = dist(start,tA)<22 && dist(end,tB)<22;
    const rev = dist(start,tB)<22 && dist(end,tA)<22;
    if(fwd||rev){
      const next=new Set([...done,current]);
      setDone(next); localStorage.setItem('yantra',JSON.stringify([...next]));
      const nc=next.size<YANTRA_LINES.length?next.size:-1;
      setCurrent(nc);
    } else { drawAll(canvasRef.current.getContext('2d')); }
  }

  const isComplete = done.size >= YANTRA_LINES.length;
  if(isComplete) return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={50} opacity={.26}/>
      <div style={{height:'100%',display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',gap:'20px',padding:'36px',textAlign:'center'}}>
        <svg viewBox="60 140 246 180" style={{width:'220px'}}>
          {YANTRA_LINES.map(([a,b],i)=>(
            <line key={i} x1={a[0]} y1={a[1]} x2={b[0]} y2={b[1]} stroke={`${game.accent}80`} strokeWidth="1.5" strokeLinecap="round"/>
          ))}
        </svg>
        <p style={{...T.sacred(26,.88)}}>The yantra is complete.</p>
        <p style={{...T.italic(16,.42),maxWidth:'220px'}}>You walked through the geometry of the divine feminine.</p>
        <Btn onClick={()=>{localStorage.removeItem('yantra');setDone(new Set());setCurrent(0);}} color={game.color} accent={game.accent}>Trace again</Btn>
      </div>
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
        <div style={{padding:'2px 20px 4px',flexShrink:0,display:'flex',alignItems:'center',gap:'8px'}}>
          <div style={{flex:1,height:'2px',borderRadius:'1px',background:'rgba(255,255,255,.06)'}}>
            <div style={{height:'100%',borderRadius:'1px',background:game.color,width:`${(done.size/YANTRA_LINES.length)*100}%`,transition:'width .3s'}}/>
          </div>
          <span style={{...T.label(9,.35)}}>{done.size}/{YANTRA_LINES.length}</span>
        </div>
        <canvas ref={canvasRef}
          onMouseDown={onStart} onMouseMove={onMove} onMouseUp={onEnd}
          onTouchStart={onStart} onTouchMove={onMove} onTouchEnd={onEnd}
          style={{flex:1,width:'100%',touchAction:'none',cursor:'crosshair',display:'block'}}/>
        <div style={{padding:'6px 24px 16px',textAlign:'center',flexShrink:0}}>
          {current>=0
            ? <p style={{...T.italic(14,.42)}}>Trace from the glowing dot to the hollow one.</p>
            : <p style={{...T.italic(14,.42)}}>Complete.</p>}
        </div>
      </div>
    </GShell>
  );
}

// ─── THE 12 SIGNS ─────────────────────────────────────────────────────────────
const SIGNS_DATA = [
  {sym:'♈',name:'Aries',order:0},{sym:'♉',name:'Taurus',order:1},{sym:'♊',name:'Gemini',order:2},
  {sym:'♋',name:'Cancer',order:3},{sym:'♌',name:'Leo',order:4},{sym:'♍',name:'Virgo',order:5},
  {sym:'♎',name:'Libra',order:6},{sym:'♏',name:'Scorpio',order:7},{sym:'♐',name:'Sagittarius',order:8},
  {sym:'♑',name:'Capricorn',order:9},{sym:'♒',name:'Aquarius',order:10},{sym:'♓',name:'Pisces',order:11}
];

function GSigns({ game, onReturn }) {
  const [cards] = useState(()=>[...SIGNS_DATA].sort(()=>Math.random()-.5).map((s,i)=>({...s,pos:i})));
  const [placed, setPlaced] = useState([]);   // array of 12 positions: which sign index
  const [dragging, setDragging] = useState(null);
  const [hinting, setHinting]   = useState(false);
  const [done, setDone]         = useState(false);

  // Check if adjacent signs "feel right" (correct neighbors in zodiac order)
  function getGlow(posIdx) {
    const signIdx = placed[posIdx];
    if (signIdx == null) return 0;
    const order = cards[signIdx].order;
    let correct = 0;
    // check left neighbor
    const left = placed[(posIdx-1+12)%12];
    if (left!=null && ((cards[left].order+1)%12===order)) correct++;
    const right = placed[(posIdx+1)%12];
    if (right!=null && (order+1)%12===cards[right].order) correct++;
    return correct;
  }

  function drop(posIdx) {
    if (dragging==null) return;
    const next=[...placed];
    // swap if occupied
    const prev=next[posIdx];
    const oldPos=next.indexOf(dragging);
    if(oldPos>=0) next[oldPos]=prev!=null?prev:undefined;
    next[posIdx]=dragging;
    setPlaced(next);
    setDragging(null);
    // check complete
    const complete=next.every((s,i)=>s!=null&&cards[s].order===i);
    if(complete) setTimeout(()=>setDone(true),600);
  }

  const unplaced=cards.map((_,i)=>i).filter(i=>!placed.includes(i));

  if(done) return(
    <GShell game={game} onReturn={onReturn}>
      <GameDone game={game} headline="The order is restored." sub="You found it through feeling." onReturn={onReturn}/>
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={60} opacity={.30}/>
      <div style={{position:'relative',zIndex:2,height:'100%',display:'flex',flexDirection:'column',padding:'6px 14px 12px',gap:'10px'}}>
        <p style={{...T.italic(14,.42),textAlign:'center',flexShrink:0}}>Arrange the signs. Let feeling guide the order.</p>

        {/* Circle of 12 slots */}
        <div style={{position:'relative',flex:1,minHeight:'260px'}}>
          <svg viewBox="0 0 366 320" style={{width:'100%',height:'100%',position:'absolute',top:0,left:0}}>
            <circle cx="183" cy="160" r="105" fill="none" stroke={`${game.accent}12`} strokeWidth="1"/>
          </svg>
          {Array.from({length:12},(_,i)=>{
            const a=(i/12)*Math.PI*2-Math.PI/2;
            const x=183+105*Math.cos(a), y=160+105*Math.sin(a);
            const glow=getGlow(i);
            const s=placed[i];
            return (
              <div key={i} onDragOver={e=>e.preventDefault()} onDrop={()=>drop(i)}
                onClick={()=>s!=null&&setDragging(dragging===null?null:s)}
                style={{position:'absolute',left:`${(x/366)*100}%`,top:`${(y/320)*100}%`,transform:'translate(-50%,-50%)',width:'44px',height:'44px',borderRadius:'50%',
                  background:s!=null?`${game.color}25`:'rgba(255,255,255,.04)',
                  border:`1px solid ${glow>0?game.accent:game.color+'28'}`,
                  boxShadow:glow>1?`0 0 14px ${game.accent}50`:glow>0?`0 0 7px ${game.color}40`:'none',
                  display:'flex',alignItems:'center',justifyContent:'center',cursor:'pointer',
                  fontSize:'22px',transition:'all .25s',
                }}>
                {s!=null&&<span style={{filter:`drop-shadow(0 0 3px ${game.accent}60)`}}>{cards[s].sym}</span>}
              </div>
            );
          })}
        </div>

        {/* Unplaced signs */}
        <div style={{display:'flex',flexWrap:'wrap',gap:'6px',justifyContent:'center',flexShrink:0}}>
          {unplaced.map(i=>(
            <button key={i} draggable onDragStart={()=>setDragging(i)} onClick={()=>setDragging(i===dragging?null:i)}
              style={{width:'40px',height:'40px',borderRadius:'50%',border:`1px solid ${dragging===i?game.accent:game.color+'35'}`,
                background:dragging===i?`${game.color}35`:`${game.color}12`,fontSize:'20px',cursor:'grab',
                boxShadow:dragging===i?`0 0 12px ${game.color}50`:'none',transition:'all .2s'}}>
              {cards[i].sym}
            </button>
          ))}
          {unplaced.length===0&&placed.some(s=>s==null)&&(
            <p style={{...T.italic(13,.38)}}>Fill all 12 positions.</p>
          )}
        </div>

        {dragging!==null&&(
          <p style={{...T.label(9,.35),textAlign:'center',flexShrink:0}}>Tap a slot to place {cards[dragging].sym} {cards[dragging].name}</p>
        )}
      </div>
    </GShell>
  );
}

// ─── MANDALA COMPLETION ───────────────────────────────────────────────────────
function GMandala({ game, onReturn }) {
  const canvasRef = useRef(null);
  const drawRef   = useRef(false);
  const lastRef   = useRef(null);
  const strokes   = useRef([]);
  const [done, setDone] = useState(false);
  const [strokeCount, setStrokeCount] = useState(0);

  function drawEverything(ctx, W, H) {
    ctx.fillStyle='#180808'; ctx.fillRect(0,0,W,H);
    const cx=W/2, cy=H/2, r=100;
    // Full mandala: 7 petals drawn
    for(let p=0;p<7;p++){
      const a=(p/7)*Math.PI*2;
      ctx.beginPath();
      ctx.arc(cx+r*.5*Math.cos(a), cy+r*.5*Math.sin(a), r*.38, 0, Math.PI*2);
      ctx.strokeStyle=`${game.color}18`; ctx.lineWidth=1; ctx.stroke();
    }
    // Missing petal ghost (bottom-right, petal index 2)
    const ma=(2/7)*Math.PI*2;
    ctx.beginPath();
    ctx.arc(cx+r*.5*Math.cos(ma), cy+r*.5*Math.sin(ma), r*.38, 0, Math.PI*2);
    ctx.strokeStyle=`${game.color}40`; ctx.lineWidth=.8; ctx.setLineDash([4,5]); ctx.stroke(); ctx.setLineDash([]);
    // Center rings
    [18,38,58,78,98].forEach(rr=>{
      ctx.beginPath(); ctx.arc(cx,cy,rr,0,Math.PI*2);
      ctx.strokeStyle=`${game.color}14`; ctx.lineWidth=.7; ctx.stroke();
    });
    // Spokes
    for(let i=0;i<12;i++){
      const a=(i/12)*Math.PI*2;
      ctx.beginPath(); ctx.moveTo(cx,cy); ctx.lineTo(cx+r*Math.cos(a),cy+r*Math.sin(a));
      ctx.strokeStyle=`${game.color}10`; ctx.lineWidth=.6; ctx.stroke();
    }
    // User strokes
    strokes.current.forEach(s=>{
      if(s.length<2) return;
      ctx.beginPath(); ctx.moveTo(s[0].x,s[0].y);
      s.forEach(p=>ctx.lineTo(p.x,p.y));
      ctx.strokeStyle=`${game.accent}70`; ctx.lineWidth=2.2; ctx.lineCap='round'; ctx.lineJoin='round';
      ctx.shadowColor=game.accent; ctx.shadowBlur=6; ctx.stroke(); ctx.shadowBlur=0;
    });
    // "Missing" label
    ctx.fillStyle=`${game.accent}35`;
    ctx.font="italic 11px 'Cormorant Garamond', serif";
    ctx.textAlign='center';
    ctx.fillText('complete this petal', cx+r*.5*Math.cos(ma), cy+r*.5*Math.sin(ma)+r*.38+18);
  }

  function getPos(e){
    const c=canvasRef.current, r=c.getBoundingClientRect();
    const src=e.touches?.[0]||e;
    return {x:src.clientX-r.left, y:src.clientY-r.top};
  }

  function onStart(e){e.preventDefault();drawRef.current=true;const p=getPos(e);lastRef.current=p;strokes.current=[...strokes.current,[p]];redraw();}
  function onMove(e){
    e.preventDefault();if(!drawRef.current)return;
    const p=getPos(e);
    const last=strokes.current[strokes.current.length-1];
    last.push(p); lastRef.current=p; redraw();
  }
  function onEnd(e){
    e.preventDefault();drawRef.current=false;
    const cnt=strokes.current.filter(s=>s.length>4).length;
    setStrokeCount(cnt);
    if(cnt>=3) setDone(true);
  }
  function redraw(){
    const c=canvasRef.current; if(!c) return;
    drawEverything(c.getContext('2d'),c.width,c.height);
  }

  useEffect(()=>{
    const c=canvasRef.current; if(!c) return;
    c.width=c.offsetWidth; c.height=c.offsetHeight;
    drawEverything(c.getContext('2d'),c.width,c.height);
  },[]);

  if(done) return(
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={45} opacity={.24}/>
      <div style={{height:'100%',display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',gap:'20px',padding:'36px',textAlign:'center'}}>
        <canvas ref={canvasRef} style={{width:'220px',height:'220px',borderRadius:'50%',border:`1px solid ${game.color}30`}}/>
        <p style={{...T.sacred(24,.88)}}>The imperfect line is the most sacred.</p>
        <p style={{...T.italic(15,.42),maxWidth:'220px'}}>It is the only one that belongs entirely to you.</p>
        <Btn onClick={()=>{strokes.current=[];setDone(false);setStrokeCount(0);}} color={game.color} accent={game.accent}>Draw again</Btn>
      </div>
    </GShell>
  );

  return(
    <GShell game={game} onReturn={onReturn}>
      <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
        <canvas ref={canvasRef}
          onMouseDown={onStart} onMouseMove={onMove} onMouseUp={onEnd} onMouseLeave={onEnd}
          onTouchStart={onStart} onTouchMove={onMove} onTouchEnd={onEnd}
          style={{flex:1,width:'100%',touchAction:'none',cursor:'crosshair',display:'block'}}/>
        <div style={{padding:'8px 24px 16px',textAlign:'center',flexShrink:0}}>
          <p style={{...T.italic(14,.40)}}>Draw the missing petal. Any way it comes.</p>
        </div>
      </div>
    </GShell>
  );
}

Object.assign(window, { GYantra, GSigns, GMandala });
