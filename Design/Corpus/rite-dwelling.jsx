// rite-dwelling.jsx — the room, built on her seat's interior architecture.
// Text is residue here: the architecture carries the recognition.

/* __iife */ (function () {
const { RT: RTD, clamp01: c01d, lerp: lerpD, RS_W: DW, RS_H: DH } = window;
const cross = (a, at, w = 0.14) => c01d((a - at) / w);

// Motes suspended in the shaft — they only become visible once the eye has adjusted.
function RiteMotes({ hue, a, vpY, reduced }) {
  const seeds = React.useMemo(() => Array.from({ length: 9 }, (_, i) => ({
    x: 16 + ((i * 37) % 68), y: 12 + ((i * 53) % 74), d: 20 + (i % 5) * 7, s: 1 + (i % 3) * 0.7,
  })), []);
  if (a < 0.2) return null;
  return (
    <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', opacity: (a - 0.2) * 0.9 }}>
      {seeds.map((m, i) => (
        <div key={i} style={{
          position: 'absolute', left: `${m.x}%`, top: `${m.y}%`, width: m.s, height: m.s,
          borderRadius: '50%', background: `hsl(${hue},60%,86%)`,
          boxShadow: `0 0 ${3 + m.s * 2}px hsla(${hue},70%,80%,0.7)`,
          animation: reduced ? 'none' : `riteMote ${m.d}s ease-in-out ${i * 1.7}s infinite`,
        }} />
      ))}
    </div>
  );
}

function RiteRoom({ spec, world, st, still, shown, hue, reduced, entered, onLibrary, onDoor, onLeave, letterOpen, onLetter }) {
  const { a, b, res } = st;
  const vpY = spec.alt;
  const letterIn = cross(a, res.letter, 0.2);
  // Everything placed around the light derives from the aperture's real span.
  // Reserved: 52 top (status bar / leaving), 150 bottom (letter, "go deeper", indicator).
  const span = window.riteApertureSpan(world.room, vpY);
  const TOP_BAND = 52, BOTTOM_BAND = 150, ID_H = 60;
  const freeAbove = span.top - TOP_BAND;
  const freeBelow = (DH - BOTTOM_BAND) - span.bottom;
  const portraitBelow = freeBelow >= freeAbove;
  let idTop, bandTop, bandBottom;
  if (portraitBelow) {
    bandBottom = BOTTOM_BAND;
    if (freeAbove >= ID_H + 16) { idTop = Math.max(TOP_BAND, span.top - 16 - ID_H); bandTop = span.bottom + 22; }
    else { idTop = span.bottom + 14; bandTop = idTop + ID_H + 20; }
  } else {
    bandBottom = DH - (span.top - 20);
    if (freeBelow >= ID_H + 16) { idTop = span.bottom + 16; bandTop = TOP_BAND + 12; }
    else { idTop = TOP_BAND; bandTop = TOP_BAND + ID_H + 14; }
  }

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: '#040103' }}>
      <RiteSeatInterior
        room={world.room} aperture={spec.shape} hue={hue} sat={world.sat} wallHue={world.wallHue}
        a={a} b={b} vpY={vpY} reduced={reduced} id="room"
      />
      <RiteMotes hue={hue} a={a} vpY={vpY} reduced={reduced} />

      <div style={{ position: 'absolute', inset: 0, opacity: entered ? 1 : 0, pointerEvents: entered ? 'auto' : 'none', transition: 'opacity 1800ms linear' }}>
        {/* her name, cut into the wall above the light */}
        <div style={{
          position: 'absolute', top: idTop, left: 0, right: 0, textAlign: 'center',
          display: 'flex', flexDirection: 'column', gap: 7, alignItems: 'center', pointerEvents: 'none',
        }}>
          <div style={{
            fontFamily: RTD.serif, fontSize: 30, color: RTD.cream, opacity: 0.62,
            textShadow: `0 0 26px hsla(${hue},60%,40%,0.5)`,
          }}>{spec.dev}</div>
          <div style={{
            fontFamily: RTD.serif, fontSize: 11.5, letterSpacing: '0.3em', textTransform: 'uppercase',
            color: `hsl(${hue},48%,74%)`, opacity: 0.72,
          }}>{spec.quality}</div>
        </div>

        {/* the portrait — arriving at the pace of stillness, held once arrived */}
        <div style={{
          position: 'absolute', left: 44, right: 44, top: bandTop, bottom: bandBottom,
          display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 13, textAlign: 'center',
          pointerEvents: 'none',
        }}>
          {shown > 0 && (
            <div style={{
              position: 'absolute', inset: '-26px -30px', borderRadius: 200,
              background: 'radial-gradient(closest-side, rgba(4,1,3,0.82), rgba(4,1,3,0))',
            }} />
          )}
          {spec.lines.map((l, i) => (
            <div key={i} style={{
              position: 'relative', fontFamily: RTD.serif, fontSize: 19, lineHeight: 1.45,
              color: RTD.cream, textWrap: 'pretty',
              opacity: i < shown ? 0.9 : 0,
              transform: i < shown ? 'translateY(0)' : 'translateY(9px)',
              transition: 'opacity 2600ms linear, transform 2600ms ease-out',
            }}>{l}</div>
          ))}
        </div>

        {/* her letter, resting where it was left */}
        {spec.letter && (
          <button type="button" onClick={onLetter} aria-label="her letter" style={{
            position: 'absolute', right: 22, bottom: 100, width: 48, height: 44,
            border: 'none', background: 'transparent', cursor: 'pointer', opacity: letterIn * 0.95, padding: 0,
          }}>
            <div style={{
              width: 34, height: letterOpen ? 26 : 13, borderRadius: 2, marginLeft: 'auto',
              background: `hsla(${hue},34%,86%,0.16)`,
              borderTop: `1px solid hsla(${hue},44%,90%,0.42)`,
              transition: 'height 900ms ease-out',
            }} />
          </button>
        )}
        {spec.letter && letterOpen && (
          <div style={{
            position: 'absolute', left: 26, right: 26, bottom: 150, padding: '14px 16px',
            fontFamily: RTD.serif, fontStyle: 'italic', fontSize: 16, lineHeight: 1.55,
            color: RTD.cream, opacity: 0.86, textWrap: 'pretty',
            background: 'rgba(4,1,3,0.72)', borderRadius: 4,
          }}>{spec.letter}</div>
        )}

        {/* the doors — her two neighbours, lit along the seat's own edges */}
        {[-1, 1].map((dir) => (
          <button key={dir} type="button" onClick={() => onDoor(dir)} aria-label="neighbour" style={{
            position: 'absolute', top: '40%', height: 130, width: 44, padding: 0,
            [dir < 0 ? 'left' : 'right']: 0, border: 'none', background: 'transparent', cursor: 'pointer',
          }}>
            <div style={{
              position: 'absolute', top: 0, bottom: 0, [dir < 0 ? 'left' : 'right']: 4, width: 2,
              background: `linear-gradient(180deg, transparent, hsla(${hue},70%,72%,${0.22 + 0.5 * a}), transparent)`,
              filter: 'blur(0.6px)',
            }} />
          </button>
        ))}

        {/* the library, folded behind the room */}
        <button type="button" onClick={onLibrary} style={{
          position: 'absolute', left: '50%', transform: 'translateX(-50%)', bottom: 40,
          width: 150, height: 46, border: 'none', background: 'transparent', cursor: 'pointer',
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-end', gap: 8,
          opacity: cross(a, 0.28, 0.3) * 0.8,
        }}>
          <div style={{
            fontFamily: RTD.serif, fontSize: 11.5, letterSpacing: '0.26em',
            textTransform: 'uppercase', color: RTD.cream, opacity: 0.72,
          }}>go deeper</div>
          <div style={{ width: 58, height: 1, background: `hsla(${hue},50%,84%,0.5)` }} />
        </button>

        <button type="button" onClick={onLeave} aria-label="leave" style={{
          position: 'absolute', top: 52, left: 6, width: 46, height: 46, padding: 0,
          border: 'none', background: 'transparent', cursor: 'pointer',
        }}>
          <div style={{
            width: 15, height: 15, borderLeft: `1px solid ${RTD.cream}`, borderBottom: `1px solid ${RTD.cream}`,
            opacity: 0.42, transform: 'rotate(45deg)', margin: '0 auto',
          }} />
        </button>
      </div>
    </div>
  );
}

function RiteLibrary({ spec, world, hue, onClose }) {
  const rows = [
    ['Function', spec.fn], ['Somatic signature', spec.somatic], ['Iconography', spec.icon],
    ['Esoteric tattva', spec.tattva], ['Bodily location', spec.location],
    ['Etymology', `${spec.roots.join(' + ')} — ${spec.gloss}`],
    ['Bīja', world.bija], ['Śakti family', spec.family],
    ['Āvaraṇa', `${world.ord} — ${world.name}`],
    ['Her seat', `${world.room === 'square' ? 'the bhūpura' : world.room === 'petal' ? 'a lotus petal' : world.room === 'circle' ? 'the bindu' : 'a triangle'} · ${world.gem} on ${world.dhatu}`],
    ['World', `${world.clock} · ${world.region}`],
  ];
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 12, display: 'flex', flexDirection: 'column',
      animation: 'riteSheet 620ms cubic-bezier(0.16,1,0.3,1)',
    }}>
      <button type="button" onClick={onClose} aria-label="close" style={{
        flex: '0 0 92px', border: 'none', background: 'transparent', cursor: 'pointer',
      }} />
      <div style={{
        flex: 1, borderRadius: '26px 26px 0 0', overflow: 'auto',
        background: `linear-gradient(180deg, hsla(${hue},22%,9%,0.98), rgba(6,2,4,0.995))`,
        borderTop: `1px solid hsla(${hue},44%,72%,0.24)`, padding: '26px 26px 60px',
      }}>
        <div style={{
          fontFamily: RTD.serif, fontSize: 12, letterSpacing: '0.24em', textTransform: 'uppercase',
          color: RTD.gold, opacity: 0.72, marginBottom: 22,
        }}>the library</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 22 }}>
          {rows.map(([k, v]) => (
            <div key={k} style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              <div style={{
                fontFamily: RTD.mono, fontSize: 11, letterSpacing: '0.14em', textTransform: 'uppercase',
                color: RTD.cream, opacity: 0.62,
              }}>{k}</div>
              <div style={{
                fontFamily: RTD.serif, fontSize: 17, lineHeight: 1.5, color: RTD.cream,
                opacity: 0.82, textWrap: 'pretty',
              }}>{v}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { RiteRoom, RiteLibrary, RiteMotes });

})();
