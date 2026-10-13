// rite-descent.jsx — "go deeper" is not a sheet. You fall inward through her, and
// each field of her card becomes a chamber rendered as motion, not a paragraph.
// Self-paced: a touch carries you one chamber further in.

/* __iife */ (function () {
const { RT: RD, clamp01: c0, lerp: lp, RiteApertureFace, riteShapePoints } = window;

function riteStations(spec, world) {
  return [
    { k: 'function', label: 'what she does',      text: spec.fn },
    { k: 'somatic',  label: 'where she is felt',  text: spec.somatic },
    { k: 'icon',     label: 'how she appears',    text: spec.icon },
    { k: 'tattva',   label: 'the principle',      text: `${spec.tattva} — ${spec.quality}` },
    { k: 'root',     label: 'her name, opened',   text: `${spec.roots.join(' · ')} — ${spec.gloss}` },
  ];
}

const dPath = (pts, r) => pts.map((p, i) => `${i ? 'L' : 'M'} ${(p[0] * r).toFixed(1)},${(p[1] * r).toFixed(1)}`).join(' ') + ' Z';

// ── the chambers ────────────────────────────────────────────────────────────

// 1 · The field of her action — her seat's form multiplying outward.
function ChFunction({ hue, sat, t, aperture, room }) {
  const pts = riteShapePoints(room);
  return (
    <svg width="330" height="330" viewBox="-165 -165 330 330">
      {Array.from({ length: 7 }, (_, i) => {
        const ph = ((t * 0.16 + i / 7) % 1);
        const r = 18 + ph * 138;
        return <path key={i} d={dPath(pts, r)} fill="none"
          stroke={`hsl(${hue},${sat}%,${72 - ph * 22}%)`} strokeWidth={1.6 - ph}
          opacity={(1 - ph) * (ph < 0.1 ? ph * 10 : 1) * 0.85} />;
      })}
      <g opacity="0.95"><RiteApertureFace kind={aperture} r={30} hue={hue} sat={sat} lum={74} a={1} b={0} id="dfn" /></g>
    </svg>
  );
}

// 2 · Where she is felt — the body as registers, breathing at her altitude.
function ChSomatic({ hue, sat, t, alt }) {
  const y = -150 + alt * 300;
  const br = 0.5 + 0.5 * Math.sin(t * 0.55);
  return (
    <svg width="330" height="330" viewBox="-165 -165 330 330">
      <line x1="0" y1="-152" x2="0" y2="152" stroke={`hsl(${hue},30%,60%)`} strokeWidth="0.6" opacity="0.3" />
      {Array.from({ length: 15 }, (_, i) => {
        const ry = -150 + i * 21.4;
        const near = Math.max(0, 1 - Math.abs(ry - y) / 62);
        const w = 26 + near * 62;
        return <line key={i} x1={-w} y1={ry} x2={w} y2={ry}
          stroke={`hsl(${hue},${30 + near * sat * 0.6}%,${44 + near * 34}%)`}
          strokeWidth={0.5 + near * 1.4} opacity={0.2 + near * 0.75} />;
      })}
      <ellipse cx="0" cy={y} rx={54 + br * 16} ry={30 + br * 10}
        fill={`hsl(${hue},${sat}%,62%)`} opacity={0.18 + br * 0.2} style={{ filter: 'blur(16px)' }} />
      <ellipse cx="0" cy={y} rx={13 + br * 5} ry={8 + br * 3} fill={`hsl(${hue},40%,88%)`} opacity={0.5 + br * 0.35} />
    </svg>
  );
}

// 3 · How she appears — her implement as light-geometry, doing its one action.
function ChIcon({ hue, sat, t, aperture }) {
  const c = `hsl(${hue},${sat}%,70%)`, hot = `hsl(${hue},40%,92%)`;
  const cy2 = (Math.sin(t * 0.5) + 1) / 2;
  return (
    <svg width="330" height="330" viewBox="-165 -165 330 330">
      {aperture === 'point' && (
        // the noose: it draws the vast into the tiny
        <g>
          {Array.from({ length: 4 }, (_, i) => {
            const ph = ((t * 0.2 + i / 4) % 1);
            return <circle key={i} r={140 - ph * 126} fill="none" stroke={c}
              strokeWidth={0.8 + ph * 1.6} opacity={(1 - ph * 0.7) * 0.6} />;
          })}
          <circle r={7 + cy2 * 3} fill={hot} opacity="0.92" />
        </g>
      )}
      {aperture === 'triad' && (
        // the three-part seal, gathering will, knowledge and action into one
        <g>
          {[0, 1, 2].map((i) => {
            const ang = (i / 3) * Math.PI * 2 - Math.PI / 2;
            const d = lp(112, 20, cy2);
            return (
              <g key={i}>
                <line x1={Math.cos(ang) * d} y1={Math.sin(ang) * d} x2="0" y2="0"
                  stroke={c} strokeWidth="0.7" opacity={0.2 + 0.4 * cy2} />
                <circle cx={Math.cos(ang) * d} cy={Math.sin(ang) * d} r={19 - cy2 * 5}
                  fill="none" stroke={c} strokeWidth="1.3" opacity="0.8" />
                <circle cx={Math.cos(ang) * d} cy={Math.sin(ang) * d} r={5} fill={hot} opacity={0.5 + 0.4 * cy2} />
              </g>
            );
          })}
          <circle r={6 + cy2 * 22} fill={hot} opacity={cy2 * 0.5} style={{ filter: 'blur(9px)' }} />
        </g>
      )}
      {(aperture === 'tri-down' || aperture === 'triangle-down') && (
        // the womb-seal: hands joining into the downward triangle
        <g>
          {[0, 1].map((s) => {
            const sx = s ? 1 : -1;
            const o = lp(74, 2, cy2);
            return <path key={s} d={`M ${sx * (-96 + o * sx * 0)},-84 L ${sx * 96},-84 L 0,96 Z`}
              fill="none" stroke={c} strokeWidth="1.2" opacity="0.5"
              transform={`translate(${sx * o} 0)`} />;
          })}
          <path d="M -96,-84 L 96,-84 L 0,96 Z" fill={`hsl(${hue},${sat}%,60%)`} opacity={cy2 * 0.24} />
          <circle cy={30} r={5 + cy2 * 4} fill={hot} opacity={0.4 + cy2 * 0.5} />
        </g>
      )}
      {!['point', 'triad', 'tri-down', 'triangle-down'].includes(aperture) && (
        <g opacity="0.9"><RiteApertureFace kind={aperture} r={110} hue={hue} sat={sat} lum={70} a={1} b={cy2} id="dic" /></g>
      )}
    </svg>
  );
}

// 4 · The principle — one form, turning, saying nothing else.
function ChTattva({ hue, sat, t, room }) {
  const pts = riteShapePoints(room);
  return (
    <svg width="330" height="330" viewBox="-165 -165 330 330">
      <g transform={`rotate(${(t * 5) % 360})`}>
        <path d={dPath(pts, 118)} fill="none" stroke={`hsl(${hue},${sat}%,68%)`} strokeWidth="1.1" opacity="0.7" />
        <path d={dPath(pts, 78)} fill={`hsl(${hue},${sat}%,52%)`} opacity="0.1" />
      </g>
      <g transform={`rotate(${-(t * 3) % 360})`}>
        <path d={dPath(pts, 44)} fill="none" stroke={`hsl(${hue},30%,86%)`} strokeWidth="0.8" opacity="0.55" />
      </g>
      <circle r="3.4" fill={`hsl(${hue},40%,92%)`} opacity="0.9" />
    </svg>
  );
}

// 5 · Her name, opened — the roots drawn inward until they are one word again.
function ChRoot({ hue, sat, t, spec }) {
  const cyc = (Math.sin(t * 0.32) + 1) / 2;
  const n = spec.roots.length;
  return (
    <div style={{ width: 330, height: 330, position: 'relative' }}>
      {spec.roots.map((r, i) => {
        const ang = (i / n) * Math.PI * 2 - Math.PI / 2;
        const d = lp(118, 0, cyc);
        return (
          <div key={i} style={{
            position: 'absolute', left: 165 + Math.cos(ang) * d, top: 165 + Math.sin(ang) * d,
            transform: 'translate(-50%,-50%)',
            fontFamily: RD.serif, fontSize: lp(23, 15, cyc), color: RD.cream,
            opacity: 0.35 + (1 - cyc) * 0.55, whiteSpace: 'nowrap',
          }}>{r}</div>
        );
      })}
      <div style={{
        position: 'absolute', left: 165, top: 165, transform: 'translate(-50%,-50%)',
        fontFamily: RD.serif, fontSize: 40, color: RD.cream, opacity: cyc * 0.95,
        textShadow: `0 0 30px hsla(${hue},${sat}%,60%,0.65)`,
      }}>{spec.dev}</div>
    </div>
  );
}

function Chamber({ st, spec, world, hue, sat, t }) {
  const p = { hue, sat, t };
  if (st.k === 'function') return <ChFunction {...p} aperture={spec.shape} room={world.room} />;
  if (st.k === 'somatic') return <ChSomatic {...p} alt={spec.alt} />;
  if (st.k === 'icon') return <ChIcon {...p} aperture={spec.shape} />;
  if (st.k === 'tattva') return <ChTattva {...p} room={world.room} />;
  return <ChRoot {...p} spec={spec} />;
}

// ── the fall ────────────────────────────────────────────────────────────────

function RiteDescent({ spec, world, hue, sat, reduced, onClose }) {
  const stations = React.useMemo(() => riteStations(spec, world), [spec, world]);
  const [target, setTarget] = React.useState(0);
  const [dz, setDz] = React.useState(0);
  const [t, setT] = React.useState(0);
  const tgt = React.useRef(0);
  tgt.current = target;

  React.useEffect(() => {
    let raf, last = performance.now();
    const loop = (now) => {
      const dt = Math.min(0.05, (now - last) / 1000); last = now;
      setT((v) => v + dt);
      setDz((v) => v + (tgt.current - v) * (reduced ? 0.028 : 0.055));
      raf = requestAnimationFrame(loop);
    };
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, [reduced]);

  const atEnd = target >= stations.length;
  const advance = () => setTarget((v) => Math.min(stations.length, v + 1));
  const pts = riteShapePoints(world.room);

  return (
    <div onClick={atEnd ? undefined : advance} style={{
      position: 'absolute', inset: 0, zIndex: 14, overflow: 'hidden', cursor: atEnd ? 'default' : 'pointer',
      background: `radial-gradient(120% 90% at 50% 46%, hsl(${world.wallHue},34%,5%), #030102 74%)`,
      animation: 'riteFall 700ms cubic-bezier(0.16,1,0.3,1)',
    }}>
      {/* the shaft you are falling through — her seat, repeating inward */}
      <svg width="402" height="874" viewBox="0 0 402 874" style={{ position: 'absolute', inset: 0 }}>
        <g transform="translate(201 402)">
          {Array.from({ length: 8 }, (_, i) => {
            const ph = ((t * 0.09 + i / 8) % 1);
            const r = 14 * Math.pow(2.9, ph * 2.1);
            return <path key={i} d={dPath(pts, r)} fill="none"
              stroke={`hsl(${hue},${sat}%,64%)`} strokeWidth={0.5 + ph * 0.8}
              opacity={Math.min(ph * 6, 1) * (1 - ph) * 0.16} />;
          })}
        </g>
      </svg>

      {/* the chambers, at their depths */}
      <div style={{ position: 'absolute', left: 201, top: 402, width: 0, height: 0 }}>
        {stations.map((st, i) => {
          const rel = i - dz;
          if (rel > 2.2 || rel < -1.1) return null;
          const s = Math.pow(2.5, -rel);
          const o = rel >= 0 ? c0(1 - rel * 0.62) : c0(1 + rel * 1.5);
          return (
            <div key={st.k} style={{
              position: 'absolute', left: 0, top: 0, width: 330, height: 330,
              transform: `translate(-50%,-50%) scale(${s.toFixed(3)})`,
              opacity: o, willChange: 'transform, opacity',
            }}>
              <Chamber st={st} spec={spec} world={world} hue={hue} sat={sat} t={t} />
            </div>
          );
        })}
      </div>

      {/* what this chamber is — arriving only when you are inside it */}
      {stations.map((st, i) => {
        const near = c0(1 - Math.abs(i - dz) / 0.42);
        if (near <= 0.02) return null;
        return (
          <div key={st.k} style={{
            position: 'absolute', left: 30, right: 30, bottom: 148, textAlign: 'center',
            opacity: near, pointerEvents: 'none',
          }}>
            <div style={{
              fontFamily: RD.mono, fontSize: 10.5, letterSpacing: '0.24em', textTransform: 'uppercase',
              color: `hsl(${hue},44%,78%)`, opacity: 0.8, marginBottom: 12,
            }}>{st.label}</div>
            <div style={{
              fontFamily: RD.serif, fontSize: 19, lineHeight: 1.5, color: RD.cream,
              opacity: 0.94, textWrap: 'pretty',
            }}>{st.text}</div>
          </div>
        );
      })}

      {/* the floor of her — the facts, once the fall is done */}
      {atEnd && (
        <div style={{
          position: 'absolute', inset: 0, background: 'rgba(3,1,2,0.9)', overflow: 'auto',
          padding: '84px 30px 60px', animation: 'riteFall 900ms ease-out',
        }}>
          <div style={{
            fontFamily: RD.mono, fontSize: 10.5, letterSpacing: '0.24em', textTransform: 'uppercase',
            color: `hsl(${hue},44%,78%)`, opacity: 0.8, marginBottom: 26, textAlign: 'center',
          }}>the floor of her</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
            {[['Āvaraṇa', `${world.ord} — ${world.name}`], ['Her seat', `${world.room === 'square' ? 'the bhūpura' : world.room === 'petal' ? 'a lotus petal' : world.room === 'circle' ? 'the bindu' : 'a triangle'}`],
              ['Bodily location', spec.location], ['Bīja', world.bija], ['Śakti family', spec.family],
              ['Gem · dhātu', `${world.gem} on ${world.dhatu}`], ['Clock', world.clock]].map(([k, v]) => (
              <div key={k} style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
                <div style={{ fontFamily: RD.mono, fontSize: 10.5, letterSpacing: '0.14em', textTransform: 'uppercase', color: RD.cream, opacity: 0.55 }}>{k}</div>
                <div style={{ fontFamily: RD.serif, fontSize: 17, color: RD.cream, opacity: 0.85 }}>{v}</div>
              </div>
            ))}
          </div>
          <button type="button" onClick={onClose} style={{
            margin: '38px auto 0', display: 'block', padding: '13px 26px', cursor: 'pointer',
            background: 'transparent', border: `1px solid hsla(${hue},44%,72%,0.4)`, borderRadius: 2,
            fontFamily: RD.serif, fontSize: 11.5, letterSpacing: '0.24em', textTransform: 'uppercase',
            color: RD.cream, opacity: 0.8,
          }}>rise back into her room</button>
        </div>
      )}

      {/* how deep you are */}
      <div style={{ position: 'absolute', left: 20, top: 0, bottom: 0, width: 2, display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 8, pointerEvents: 'none' }}>
        {stations.map((s, i) => (
          <div key={s.k} style={{
            width: 2, height: i === Math.round(dz) ? 22 : 8, borderRadius: 1,
            background: i <= dz + 0.4 ? `hsl(${hue},50%,76%)` : 'rgba(242,232,217,0.18)',
            opacity: i <= dz + 0.4 ? 0.75 : 0.4, transition: 'height 500ms ease',
          }} />
        ))}
      </div>

      {!atEnd && (
        <div style={{
          position: 'absolute', bottom: 62, left: 0, right: 0, textAlign: 'center', pointerEvents: 'none',
          fontFamily: RD.serif, fontSize: 10.5, letterSpacing: '0.28em', textTransform: 'uppercase',
          color: RD.cream, opacity: 0.34,
        }}>touch to go further in</div>
      )}
      <button type="button" onClick={onClose} aria-label="rise" style={{
        position: 'absolute', top: 50, left: 6, width: 46, height: 46, padding: 0,
        border: 'none', background: 'transparent', cursor: 'pointer', zIndex: 3,
      }}>
        <div style={{ width: 15, height: 15, borderTop: `1px solid ${RD.cream}`, borderLeft: `1px solid ${RD.cream}`, opacity: 0.42, transform: 'rotate(45deg)', margin: '0 auto' }} />
      </button>
    </div>
  );
}

Object.assign(window, { RiteDescent, riteStations });
})();
