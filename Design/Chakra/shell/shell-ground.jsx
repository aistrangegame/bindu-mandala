// shell-ground.jsx — weather ground, doors, pulse, shared atoms for the Shell.
const { useState, useEffect, useRef, useCallback } = React;

// ── Shared type atoms (proven register: Cormorant + DM Sans on near-black) ──
const ST = {
  serif:  (size, op=.88) => ({ fontFamily:"'Cormorant Garamond',serif", fontSize:size+'px', color:`rgba(240,232,220,${op})`, lineHeight:1.45 }),
  italic: (size, op=.55) => ({ fontFamily:"'Cormorant Garamond',serif", fontStyle:'italic', fontSize:size+'px', color:`rgba(240,232,220,${op})`, lineHeight:1.7 }),
  label:  (size, op=.4)  => ({ fontFamily:"'DM Sans',sans-serif", fontSize:size+'px', letterSpacing:'.26em', textTransform:'uppercase', color:`rgba(220,210,235,${op})` }),
};

// Non-canon marker — visible only when the tweak is on
function NC({ show, kind }) {
  if (!show) return null;
  return <span style={{ fontFamily:'ui-monospace,monospace', fontSize:'8.5px', letterSpacing:'.08em',
    color:'rgba(240,232,220,.22)', border:'1px dotted rgba(240,232,220,.18)', borderRadius:'3px',
    padding:'1px 5px', marginLeft:'8px', verticalAlign:'middle', whiteSpace:'nowrap' }}>{kind || 'non-canon'}</span>;
}

// ── Starfield (corridor-era ground only — canon-adjacent register) ──
function ShellStarfield({ opacity = 0.35 }) {
  const ref = useRef(null);
  useEffect(() => {
    const c = ref.current; if (!c) return;
    const ctx = c.getContext('2d');
    c.width = c.offsetWidth; c.height = c.offsetHeight;
    const stars = Array.from({ length: 70 }, () => ({
      x: Math.random() * c.width, y: Math.random() * c.height,
      r: Math.random() * 1.0 + 0.2, ph: Math.random() * Math.PI * 2,
    }));
    let raf, t = 0;
    (function draw() {
      ctx.clearRect(0, 0, c.width, c.height);
      stars.forEach(s => {
        ctx.beginPath(); ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
        ctx.fillStyle = '#fff';
        ctx.globalAlpha = opacity * (0.35 + 0.65 * Math.sin(s.ph + t * 0.35));
        ctx.fill();
      });
      t += 0.016; raf = requestAnimationFrame(draw);
    })();
    return () => cancelAnimationFrame(raf);
  }, []);
  return <canvas ref={ref} style={{ position:'absolute', inset:0, width:'100%', height:'100%', pointerEvents:'none' }} />;
}

// ── The weather: ground wears the story thread's sky ──
function groundStyle(storyPos) {
  const rooms = WALK_CANON_LITE.rooms;
  const r = rooms[storyPos - 1];
  if (storyPos === 9) {
    // The corridor makes the whole app dark.
    return { corridor: true, hex: r.color_hex, next: rooms[9].color_hex,
      bg: 'radial-gradient(ellipse at 50% 32%, #0B0910 0%, #030204 75%)' };
  }
  return { corridor: false, hex: r.color_hex, next: (rooms[storyPos] || r).color_hex,
    bg: `radial-gradient(ellipse at 50% 96%, ${r.color_hex}2E 0%, transparent 52%),` +
        `radial-gradient(ellipse at 50% 30%, ${r.color_hex}10 0%, transparent 60%),` +
        'radial-gradient(ellipse at 50% 40%, #0A0810 0%, #040307 80%)' };
}

// Next room's color bleeds at the horizon before the walker arrives.
function HorizonBleed({ hex, strength = .14 }) {
  return <div style={{ position:'absolute', left:0, right:0, bottom:0, height:'90px', pointerEvents:'none',
    background:`linear-gradient(to top, ${hex}${Math.round(strength*255).toString(16).padStart(2,'0')} 0%, transparent 100%)`,
    filter:'blur(6px)' }}></div>;
}

// ── The pulse — warm, unnamed, ~60bpm, at the bottom of the glass ──
function ThePulse({ mode = 'glow', bpm = 60 }) {
  const dur = (60 / bpm).toFixed(2);
  useEffect(() => {
    if (mode === 'glow') return;
    // sub-audible warm tone, thumping at ~bpm (needs prior user gesture; Day 20 register)
    const AC = window.AudioContext || window.webkitAudioContext;
    let ctx; try { ctx = new AC(); } catch (e) { return; }
    const osc = ctx.createOscillator(), gain = ctx.createGain(), lfo = ctx.createOscillator(), lfoG = ctx.createGain();
    osc.frequency.value = 58; osc.type = 'sine';
    gain.gain.value = 0.0;
    lfo.frequency.value = bpm / 60; lfoG.gain.value = 0.028;
    lfo.connect(lfoG); lfoG.connect(gain.gain);
    osc.connect(gain); gain.connect(ctx.destination);
    osc.start(); lfo.start();
    return () => { try { osc.stop(); lfo.stop(); ctx.close(); } catch (e) {} };
  }, [mode, bpm]);
  if (mode === 'tone') return null;
  return (
    <div style={{ position:'absolute', left:0, right:0, bottom:0, height:'64px', pointerEvents:'none', zIndex:5,
      display:'flex', alignItems:'flex-end', justifyContent:'center', overflow:'hidden' }}>
      <div style={{ width:'150%', height:'54px', borderRadius:'50% 50% 0 0',
        background:'radial-gradient(ellipse at 50% 100%, rgba(214,142,90,.30) 0%, rgba(180,100,60,.10) 45%, transparent 72%)',
        animation:`pulsebeat ${dur}s ease-in-out infinite`, transformOrigin:'50% 100%' }}></div>
    </div>
  );
}

// ── A door: quiet serif line, hairline slit, never a card ──
function Door({ title, sub, onOpen, delay = 0 }) {
  return (
    <button onClick={onOpen} style={{ display:'flex', alignItems:'center', gap:'16px', width:'100%',
      background:'none', border:'none', cursor:'pointer', padding:'13px 6px', textAlign:'left',
      opacity:0, animation:`emerge 1.4s ease ${delay}s forwards` }}>
      <span style={{ width:'1px', height:'30px', flexShrink:0, background:'rgba(240,232,220,.28)' }}></span>
      <span style={{ display:'flex', flexDirection:'column', gap:'3px' }}>
        <span style={ST.serif(20, .82)}>{title}</span>
        {sub ? <span style={ST.italic(13, .38)}>{sub}</span> : null}
      </span>
    </button>
  );
}

// Sealed gate — shown as shape, not obstacle. Visible, closed, unbothered.
function SealedGate({ hex }) {
  return (
    <div style={{ display:'flex', flexDirection:'column', alignItems:'center', gap:'10px', opacity:.5 }}>
      <div style={{ width:'26px', height:'36px', borderRadius:'13px 13px 3px 3px',
        border:`1px solid ${hex}66`, borderBottom:`2px solid ${hex}88` }}></div>
    </div>
  );
}

// ── The App Activity ledger (living witness — quiet localStorage writes) ──
const LEDGER_KEY = 'bindu-shell-activity';
function writeWalkEvent(moment, excerpt, voice) {
  try {
    const led = JSON.parse(localStorage.getItem(LEDGER_KEY) || '[]');
    led.push({ ts: new Date().toISOString(), moment, excerpt, voice: voice || null, surfaced: false });
    localStorage.setItem(LEDGER_KEY, JSON.stringify(led));
  } catch (e) {}
}

Object.assign(window, { ST, NC, ShellStarfield, groundStyle, HorizonBleed, ThePulse, Door, SealedGate, writeWalkEvent });
