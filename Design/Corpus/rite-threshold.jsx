// rite-threshold.jsx — the three beats of entering. Self-paced: each beat writes
// itself, then waits for you. Never skipped, quietly compressed on return.

/* __iife */ (function () {
const { RT: RTT, clamp01: c01 } = window;

// Beat 2 — an unseen hand writes her name, stroke by stroke.
function RiteWriting({ text, progress, reduced, size = 36 }) {
  let mask = null;
  if (!reduced) {
    const segs = 3;
    const seg = Math.min(segs - 0.001, progress * segs);
    const i = Math.floor(seg);
    const within = seg - i;
    const eased = within < 0.72 ? within / 0.72 : 1;
    const p = ((i + eased) / segs) * 100;
    mask = `linear-gradient(90deg, #000 ${p}%, rgba(0,0,0,0) ${Math.min(100, p + 7)}%)`;
  }
  return (
    <div style={{
      fontFamily: RTT.serif, fontSize: size, lineHeight: 1.35, color: RTT.cream,
      opacity: reduced ? (progress > 0.02 ? 0.92 : 0) : 0.92,
      transition: reduced ? 'opacity 500ms linear' : 'none',
      letterSpacing: '0.02em', textAlign: 'center',
      WebkitMaskImage: mask || 'none', maskImage: mask || 'none',
    }}>{text}</div>
  );
}

// Beat 3 — the etymology breaks into its roots and recombines.
function RiteEtymology({ roots, gloss, progress, reduced }) {
  const split = c01(progress / 0.58);
  const join = c01((progress - 0.52) / 0.48);
  const gap = reduced ? (progress > 0.5 ? 0 : 14) : (1 - join) * split * 28;
  const glossOpacity = reduced ? (progress > 0.6 ? 0.5 : 0) : c01((progress - 0.6) / 0.4) * 0.5;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 15 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap, transition: reduced ? 'gap 600ms linear' : 'none' }}>
        {roots.map((r, i) => (
          <span key={i} style={{
            fontFamily: RTT.serif, fontSize: 26, color: RTT.cream,
            opacity: reduced ? (progress > 0.05 ? 0.8 : 0) : c01(split * roots.length - i) * 0.8,
            transition: reduced ? 'opacity 500ms linear' : 'none',
            fontStyle: i === roots.length - 1 && roots.length > 2 ? 'italic' : 'normal',
          }}>{r}</span>
        ))}
      </div>
      <div style={{
        fontFamily: RTT.serif, fontStyle: 'italic', fontSize: 16.5, color: RTT.cream,
        opacity: glossOpacity, letterSpacing: '0.03em', textAlign: 'center', maxWidth: 270,
      }}>{gloss}</div>
    </div>
  );
}

function RiteThreshold({ spec, beat, progress, reduced, hue, sat, onAdvance }) {
  if (beat > 3) return null;
  const ready = progress >= 0.99;
  const shown = beat === 1 ? 'phrase' : beat === 2 ? 'name' : 'etymology';
  return (
    <div onClick={onAdvance} style={{
      position: 'absolute', inset: 0, zIndex: 6, cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
    }}>
      {/* No black card. You are already standing in her room — the ceremony happens
          in front of the architecture, and her light is lit before you arrive. */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(closest-side at 50% ${spec.alt * 100}%, hsla(${hue},${sat}%,40%,0.1), rgba(4,1,3,0.5) 62%, rgba(4,1,3,0.82))`,
      }} />
      <div style={{ position: 'relative', padding: '26px 34px', textAlign: 'center' }}>
        <div style={{
          position: 'absolute', inset: '-10px -6px', borderRadius: 200,
          background: 'radial-gradient(closest-side, rgba(4,1,3,0.8), rgba(4,1,3,0))',
        }} />
        <div style={{ position: 'relative' }}>
        {shown === 'phrase' && (
          <div style={{
            fontFamily: RTT.serif, fontSize: 24, lineHeight: 1.5, color: RTT.cream,
            opacity: c01(progress / 0.34) * 0.94, letterSpacing: '0.04em', textWrap: 'pretty',
          }}>{spec.phrase}</div>
        )}
        {shown === 'name' && (
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 17 }}>
            <RiteWriting text={spec.dev} progress={progress} reduced={reduced} />
            <div style={{
              fontFamily: RTT.serif, fontSize: 15, letterSpacing: '0.24em',
              textTransform: 'uppercase', color: `hsl(${hue},52%,72%)`,
              opacity: c01((progress - 0.55) / 0.45) * 0.62,
            }}>{spec.name}</div>
          </div>
        )}
        {shown === 'etymology' && (
          <RiteEtymology roots={spec.roots} gloss={spec.gloss} progress={progress} reduced={reduced} />
        )}
        </div>
      </div>
      {/* the three beats, and where you are in them */}
      <div style={{ position: 'absolute', bottom: 92, left: 0, right: 0, display: 'flex', justifyContent: 'center', gap: 9 }}>
        {[1, 2, 3].map((n) => (
          <div key={n} style={{
            width: n === beat ? 16 : 4, height: 4, borderRadius: 2,
            background: n <= beat ? `hsl(${hue},50%,76%)` : 'rgba(242,232,217,0.2)',
            opacity: n === beat ? 0.85 : 0.4, transition: 'width 500ms ease, opacity 500ms ease',
          }} />
        ))}
      </div>
      <div style={{
        position: 'absolute', bottom: 62, left: 0, right: 0, textAlign: 'center',
        fontFamily: RTT.serif, fontSize: 10.5, letterSpacing: '0.28em', textTransform: 'uppercase',
        color: RTT.cream, opacity: ready ? 0.4 : 0, transition: 'opacity 1100ms linear',
      }}>{beat === 3 ? 'touch to enter' : 'touch to go on'}</div>
    </div>
  );
}

Object.assign(window, { RiteThreshold, RiteWriting, RiteEtymology });
})();
