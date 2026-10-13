// games-elements.jsx — Water Level, The Fire, Root System
const { useState, useEffect, useRef } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

// ─── WATER LEVEL ──────────────────────────────────────────────────────────────
function GWater({ game, onReturn }) {
  const [angle,    setAngle]    = useState(0);
  const [vel,      setVel]      = useState(0);
  const [stillSec, setStillSec] = useState(0);
  const [done,     setDone]     = useState(false);
  const physRef = useRef({ angle:0, vel:0, still:0 });
  const containerRef = useRef(null);

  // Continuous physics loop
  useEffect(() => {
    let raf;
    function tick() {
      const p = physRef.current;
      p.vel *= 0.94;                       // damping
      p.angle += p.vel;
      p.angle = Math.max(-0.45, Math.min(0.45, p.angle));
      const isStill = Math.abs(p.vel) < 0.006 && Math.abs(p.angle) < 0.06;
      p.still = isStill ? p.still + 0.016 : 0;
      setAngle(p.angle);
      setVel(p.vel);
      setStillSec(p.still);
      if (p.still >= 30) setDone(true);
      raf = requestAnimationFrame(tick);
    }
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, []);

  function handleMove(e) {
    const rect = containerRef.current?.getBoundingClientRect();
    if (!rect) return;
    const src = e.touches?.[0] || e;
    const rel = (src.clientX - rect.left) / rect.width - 0.5; // -0.5 to 0.5
    physRef.current.vel += rel * 0.025;
  }

  // Periodic "event" perturbations
  useEffect(() => {
    const events = ['A notification.','A thought.','The news.','A memory.','An urge.','A deadline.'];
    let i = 0;
    const id = setInterval(() => {
      physRef.current.vel += (Math.random()-0.5)*0.2;
      i++;
    }, 6000);
    return () => clearInterval(id);
  }, []);

  const W = 240, H = 180;
  const waterY = H * 0.55;
  const leftY  = waterY + Math.sin(angle) * W/2;
  const rightY = waterY - Math.sin(angle) * W/2;
  const pct = Math.min(100, Math.round((stillSec/30)*100));

  if (done) return (
    <GShell game={game} onReturn={onReturn}>
      <GameDone game={game} headline="Still." sub="The water found its level." onReturn={onReturn} />
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <div ref={containerRef} onMouseMove={handleMove} onTouchMove={handleMove}
        style={{ height:'100%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'28px', userSelect:'none' }}>
        <Starfield count={40} opacity={.22} />
        <div style={{ position:'relative', zIndex:2 }}>
          <svg width={W} height={H} style={{ overflow:'visible' }}>
            <defs>
              <clipPath id="vessel-clip">
                <rect x="1" y="1" width={W-2} height={H-2} />
              </clipPath>
            </defs>
            {/* Vessel */}
            <rect x="0" y="0" width={W} height={H} fill={`${game.color}08`} stroke={`${game.color}35`} strokeWidth="1.5" rx="4" />
            {/* Water fill */}
            <polygon points={`0,${leftY} ${W},${rightY} ${W},${H} 0,${H}`}
              fill={`${game.color}28`} clipPath="url(#vessel-clip)" />
            {/* Surface line */}
            <line x1="0" y1={leftY} x2={W} y2={rightY} stroke={game.accent} strokeWidth="1.2" opacity=".65" clipPath="url(#vessel-clip)" />
            {/* Center guide */}
            <line x1={W/2} y1="0" x2={W/2} y2={H} stroke={`${game.accent}15`} strokeWidth=".8" strokeDasharray="4 6" />
          </svg>
        </div>

        <div style={{ position:'relative', zIndex:2, textAlign:'center' }}>
          <div style={{ width:'180px', height:'3px', borderRadius:'2px', background:'rgba(255,255,255,.08)', marginBottom:'12px' }}>
            <div style={{ width:`${pct}%`, height:'100%', borderRadius:'2px', background:game.accent, transition:'width .3s' }} />
          </div>
          <p style={{ ...T.italic(17, .55) }}>
            {stillSec < 3 ? 'Move the vessel. Find the still point.' : stillSec < 15 ? 'Hold it there.' : 'Almost.'}
          </p>
          <p style={{ ...T.label(9,.28), marginTop:'4px' }}>{Math.floor(stillSec)}s / 30s still</p>
        </div>
      </div>
    </GShell>
  );
}

// ─── THE FIRE ─────────────────────────────────────────────────────────────────
function GFire({ game, onReturn }) {
  const canvasRef = useRef(null);
  const fuelRef   = useRef(50);
  const [fuelDisp, setFuelDisp] = useState(50);
  const [tendSec,  setTendSec]  = useState(0);
  const [done,     setDone]     = useState(false);

  useEffect(() => {
    const canvas = canvasRef.current; if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;
    const W = canvas.width, H = canvas.height;
    const BASE = { x: W/2, y: H - 80 };
    const particles = [];
    let raf;

    function spawn() {
      const f = fuelRef.current;
      const n = Math.floor(f / 18);
      for (let i=0;i<n;i++) {
        particles.push({
          x: BASE.x + (Math.random()-.5)*24,
          y: BASE.y + (Math.random()-.5)*8,
          vx: (Math.random()-.5)*0.7,
          vy: -(1.2+Math.random()*2.2),
          life: 1, decay: 0.013+Math.random()*.009,
          r: 5+Math.random()*9,
        });
      }
    }

    function draw() {
      ctx.clearRect(0,0,W,H);
      fuelRef.current = Math.max(0, fuelRef.current - 0.18);
      setFuelDisp(Math.round(fuelRef.current));
      spawn();
      for (let i=particles.length-1;i>=0;i--) {
        const p=particles[i];
        p.x+=p.vx; p.y+=p.vy; p.vy-=.015; p.life-=p.decay;
        if (p.life<=0){particles.splice(i,1);continue;}
        const a=p.life*.75, h=p.life;
        ctx.beginPath();
        ctx.arc(p.x,p.y,p.r*p.life,0,Math.PI*2);
        ctx.fillStyle=`rgba(${Math.floor(220+35*h)},${Math.floor(60+130*h)},10,${a})`;
        ctx.fill();
      }
      // Ember base
      ctx.beginPath();
      ctx.arc(BASE.x, BASE.y, 18, 0, Math.PI*2);
      ctx.fillStyle=`rgba(200,80,10,${.15+fuelRef.current/200})`;
      ctx.fill();
      raf=requestAnimationFrame(draw);
    }
    draw();
    return ()=>cancelAnimationFrame(raf);
  }, []);

  useEffect(()=>{
    if (done) return;
    const id=setInterval(()=>{
      if (fuelDisp>=15&&fuelDisp<=82){ setTendSec(t=>{const nt=t+1;if(nt>=60)setDone(true);return nt;}); }
    },1000);
    return ()=>clearInterval(id);
  },[fuelDisp,done]);

  function addFuel(e){e.stopPropagation();fuelRef.current=Math.min(100,fuelRef.current+22);}

  if (done) return (
    <GShell game={game} onReturn={onReturn}>
      <GameDone game={game} headline="60 seconds tended." sub="Not too much. Not too little." onReturn={onReturn} />
    </GShell>
  );

  return (
    <GShell game={game} onReturn={onReturn}>
      <div style={{ height:'100%', position:'relative' }}>
        <canvas ref={canvasRef} style={{ position:'absolute', inset:0, width:'100%', height:'100%' }} />
        <div style={{ position:'absolute', bottom:0, left:0, right:0, padding:'12px 24px 20px', textAlign:'center', background:'linear-gradient(transparent,rgba(10,4,4,.7))' }}>
          <div style={{ display:'flex', gap:'4px', justifyContent:'center', marginBottom:'10px' }}>
            {[...Array(12)].map((_,i)=><div key={i} style={{ width:'20px', height:'3px', borderRadius:'2px', background: i<Math.floor(tendSec/5)?game.color:`${game.color}20`, transition:'background .3s' }}/>)}
          </div>
          <p style={{ ...T.italic(15,.50) }}>{fuelDisp<10?'The fire is dying.':fuelDisp>85?'Too much.':tendSec<30?`${tendSec}s`:'Holding well.'}</p>
          <button onClick={addFuel} style={{ marginTop:'10px', padding:'10px 32px', borderRadius:'24px', background:`${game.color}22`, border:`1px solid ${game.color}45`, fontFamily:"'Cormorant Garamond',serif", fontSize:'16px', color:'rgba(240,232,220,.75)', cursor:'pointer', letterSpacing:'.12em' }}>Add fuel</button>
        </div>
      </div>
    </GShell>
  );
}

// ─── ROOT SYSTEM ──────────────────────────────────────────────────────────────
function GRoots({ game, onReturn }) {
  const canvasRef  = useRef(null);
  const growingRef = useRef({});
  const savedRef   = useRef([]);
  const growRaf    = useRef(null);
  const KEY        = 'game_roots_v1';
  const [count, setCount] = useState(0);

  function drawAll(ctx, W, H) {
    ctx.fillStyle='#0A0604'; ctx.fillRect(0,0,W,H);
    // Soil layers
    const layers=[['#1A0A04',H*.25,H*.75],['#140804',H*.55,H*.45],['#0E0602',H*.78,H*.22]];
    layers.forEach(([c,y,h])=>{ ctx.fillStyle=c; ctx.fillRect(0,y,W,h); });
    ctx.strokeStyle='rgba(255,255,255,.03)'; ctx.lineWidth=.8;
    [.3,.55,.78].forEach(p=>{ ctx.beginPath();ctx.moveTo(0,H*p);ctx.lineTo(W,H*p);ctx.stroke(); });
    // Saved paths
    savedRef.current.forEach(path=>drawPath(ctx,path));
    // Growing paths
    Object.values(growingRef.current).forEach(r=>drawPath(ctx,r));
  }

  function drawPath(ctx,segs) {
    if (!segs||segs.length<2) return;
    ctx.beginPath(); ctx.strokeStyle='rgba(120,75,30,.85)'; ctx.lineWidth=1.8; ctx.lineCap='round';
    ctx.moveTo(segs[0].x,segs[0].y);
    segs.slice(1).forEach(s=>ctx.lineTo(s.x,s.y));
    ctx.stroke();
    // Glow at tip
    const last=segs[segs.length-1];
    ctx.beginPath(); ctx.arc(last.x,last.y,3,0,Math.PI*2);
    ctx.fillStyle=`${game.accent}70`; ctx.fill();
  }

  function startGrow() {
    if (growRaf.current) return;
    const canvas=canvasRef.current; if(!canvas) return;
    const ctx=canvas.getContext('2d');
    function grow(){
      const roots=growingRef.current;
      if (!Object.keys(roots).length){ growRaf.current=null; return; }
      Object.keys(roots).forEach(id=>{
        const segs=roots[id], last=segs[segs.length-1];
        segs.push({ x:last.x+(Math.random()-.48)*3, y:last.y+2.5+Math.random()*2 });
      });
      drawAll(ctx,canvas.width,canvas.height);
      growRaf.current=requestAnimationFrame(grow);
    }
    growRaf.current=requestAnimationFrame(grow);
  }

  function handleDown(e) {
    e.preventDefault();
    const canvas=canvasRef.current, rect=canvas.getBoundingClientRect();
    const src=e.touches?.[0]||e;
    const id=e.touches?.[0]?.identifier??'mouse';
    const x=src.clientX-rect.left, y=src.clientY-rect.top;
    growingRef.current[id]=[{x,y}];
    startGrow();
  }

  function handleUp(e) {
    const src=e.changedTouches?.[0]||{identifier:'mouse'};
    const id=src.identifier??'mouse';
    const segs=growingRef.current[id];
    if (segs&&segs.length>5){ savedRef.current=[...savedRef.current.slice(-60),segs]; localStorage.setItem(KEY,JSON.stringify(savedRef.current)); setCount(c=>c+1); }
    delete growingRef.current[id];
  }

  useEffect(()=>{
    const canvas=canvasRef.current; if(!canvas) return;
    canvas.width=canvas.offsetWidth; canvas.height=canvas.offsetHeight;
    try{savedRef.current=JSON.parse(localStorage.getItem(KEY)||'[]');}catch{}
    setCount(savedRef.current.length);
    drawAll(canvas.getContext('2d'),canvas.width,canvas.height);
    return ()=>cancelAnimationFrame(growRaf.current);
  },[]);

  return (
    <GShell game={game} onReturn={onReturn}>
      <div style={{ height:'100%', position:'relative' }}>
        <canvas ref={canvasRef}
          onMouseDown={handleDown} onMouseUp={handleUp} onMouseLeave={handleUp}
          onTouchStart={handleDown} onTouchEnd={handleUp}
          style={{ position:'absolute', inset:0, width:'100%', height:'100%', touchAction:'none', cursor:'crosshair', display:'block' }} />
        <div style={{ position:'absolute', bottom:'16px', left:0, right:0, textAlign:'center', pointerEvents:'none' }}>
          <p style={{ ...T.italic(14,.38) }}>Hold to grow roots.</p>
          {count>0&&<p style={{ ...T.label(9,.25), marginTop:'3px' }}>{count} root{count!==1?'s':''} grown</p>}
        </div>
      </div>
    </GShell>
  );
}

Object.assign(window, { GWater, GFire, GRoots });
