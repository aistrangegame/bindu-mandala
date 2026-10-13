// games-utils.jsx — shared components for all games
const { useState, useEffect, useRef } = React;

function Starfield({ count = 90, opacity = 0.4 }) {
  const ref = useRef(null);
  useEffect(() => {
    const c = ref.current; if (!c) return;
    const ctx = c.getContext('2d');
    c.width = c.offsetWidth; c.height = c.offsetHeight;
    const stars = Array.from({ length: count }, () => ({
      x: Math.random() * c.width, y: Math.random() * c.height,
      r: Math.random() * 1.1 + 0.2, ph: Math.random() * Math.PI * 2,
    }));
    let raf, t = 0;
    function draw() {
      ctx.clearRect(0, 0, c.width, c.height);
      stars.forEach(s => {
        ctx.beginPath(); ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
        ctx.fillStyle = '#fff';
        ctx.globalAlpha = opacity * (0.4 + 0.6 * Math.sin(s.ph + t * 0.4));
        ctx.fill();
      });
      t += 0.016; raf = requestAnimationFrame(draw);
    }
    draw(); return () => cancelAnimationFrame(raf);
  }, []);
  return <canvas ref={ref} style={{ position:'absolute', inset:0, width:'100%', height:'100%', pointerEvents:'none' }} />;
}

function GShell({ game, onReturn, children }) {
  const bg = `radial-gradient(ellipse at 50% 40%, ${game.bgDark} 0%, ${game.bgDeep} 100%)`;
  return (
    <div style={{ height:'100%', background:bg, position:'relative', overflow:'hidden', display:'flex', flexDirection:'column' }}>
      <div style={{ display:'flex', alignItems:'center', padding:'10px 20px 6px', gap:'10px', flexShrink:0, position:'relative', zIndex:10 }}>
        <button onClick={onReturn} style={{ background:'none', border:'none', cursor:'pointer', fontSize:'20px', color:`${game.accent}55`, padding:'2px 6px', lineHeight:1 }}>←</button>
        <span style={{ fontFamily:"'DM Sans',sans-serif", fontSize:'10px', letterSpacing:'.28em', color:`${game.accent}45`, textTransform:'uppercase' }}>{game.name}</span>
      </div>
      <div style={{ flex:1, overflow:'hidden', position:'relative', zIndex:1 }}>
        {children}
      </div>
    </div>
  );
}

function GameDone({ game, headline, sub, onReturn }) {
  return (
    <div style={{ height:'100%', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'40px', textAlign:'center', animation:'emerge .7s ease' }}>
      <div style={{ width:'72px', height:'72px', borderRadius:'50%', marginBottom:'24px', background:`radial-gradient(circle at 38% 38%,${game.accent}45,${game.color}65)`, boxShadow:`0 0 32px ${game.color}60`, animation:'breathe 4s ease-in-out infinite' }} />
      <p style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'26px', color:'rgba(240,232,220,.90)', marginBottom:'12px', lineHeight:1.3 }}>{headline}</p>
      {sub && <p style={{ fontFamily:"'Cormorant Garamond',serif", fontStyle:'italic', fontSize:'16px', color:'rgba(240,232,220,.46)', lineHeight:1.75, marginBottom:'36px', maxWidth:'240px' }}>{sub}</p>}
      <button onClick={onReturn} style={{ padding:'12px 30px', borderRadius:'26px', cursor:'pointer', background:`${game.color}22`, border:`1px solid ${game.color}55`, fontFamily:"'Cormorant Garamond',serif", fontSize:'15px', color:'rgba(240,232,220,.78)', letterSpacing:'.15em', textTransform:'uppercase' }}>Return</button>
    </div>
  );
}

// Shared text styles
const T = {
  sacred: (size, opacity=.85) => ({ fontFamily:"'Cormorant Garamond',serif", fontSize:`${size}px`, color:`rgba(240,232,220,${opacity})`, lineHeight:1.4 }),
  label:  (size, opacity=.45) => ({ fontFamily:"'DM Sans',sans-serif",       fontSize:`${size}px`, color:`rgba(200,185,240,${opacity})`, letterSpacing:'.2em', textTransform:'uppercase' }),
  italic: (size, opacity=.55) => ({ fontFamily:"'Cormorant Garamond',serif", fontStyle:'italic',   fontSize:`${size}px`, color:`rgba(240,232,220,${opacity})`, lineHeight:1.65 }),
};

function Btn({ onClick, color, accent, children, style={} }) {
  return (
    <button onClick={onClick} style={{ padding:'12px 28px', borderRadius:'26px', cursor:'pointer', background:`${color}22`, border:`1px solid ${color}55`, fontFamily:"'Cormorant Garamond',serif", fontSize:'16px', color:`rgba(240,232,220,.80)`, letterSpacing:'.15em', textTransform:'uppercase', ...style }}>
      {children}
    </button>
  );
}

Object.assign(window, { Starfield, GShell, GameDone, T, Btn });
