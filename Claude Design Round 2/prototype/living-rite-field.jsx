// living-rite-field.jsx — The Field (the 102 as a descent through nine rings),
// The Well, The Memory, and the menu veil. All lit by the day's atmosphere.

// ─── The Field — nine rings, descent ─────────────────────────────────────────

function FieldScreen({ todayShakti, dayAtmo, motion, countByKp, onOpenShakti, onOpenThreshold, openRing: initialOpen }) {
  const [openRing, setOpenRing] = React.useState(initialOpen || todayShakti.ring);
  const scrollRef = React.useRef(null);

  return (
    <div data-screen-label="The Field — 102" style={{
      position: 'absolute', inset: 0,
      background: `linear-gradient(${dayAtmo.ground}, ${dayAtmo.groundDeep})`,
      fontFamily: LR_SERIF, color: LR_BASE.cream,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(ellipse 130% 40% at 50% -5%, ${dayAtmo.glow}, transparent 70%)`, pointerEvents: 'none' }} />

      <div style={{ position: 'relative', zIndex: 2, textAlign: 'center', padding: `${LR_SAFE_TOP}px 24px 16px`, borderBottom: '1px solid rgba(201,150,63,0.12)' }}>
        <h1 style={{ margin: 0, fontWeight: 300, fontSize: 32, letterSpacing: '0.06em' }}>The Field</h1>
        <LrLabel size={11} color="rgba(242,232,217,0.45)" style={{ marginTop: 8 }}>
          nine rings · one hundred and two
        </LrLabel>
      </div>

      <div ref={scrollRef} style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', padding: '6px 0 30px' }}>
        {[1,2,3,4,5,6,7,8,9].map(ring => (
          <FieldRing
            key={ring}
            ring={ring}
            open={openRing === ring}
            onToggle={() => setOpenRing(openRing === ring ? null : ring)}
            todayShakti={todayShakti}
            countByKp={countByKp || {}}
            onOpenShakti={onOpenShakti}
            onOpenThreshold={onOpenThreshold}
          />
        ))}
      </div>
    </div>
  );
}

function FieldRing({ ring, open, onToggle, todayShakti, countByKp, onOpenShakti, onOpenThreshold }) {
  const av = LR_AVARANA_BY_RING[ring];
  const list = LR_ALL.filter(s => s.ring === ring);
  const ringAtmo = lrAtmosphere(list[0]);
  const holdsToday = todayShakti.ring === ring;

  return (
    <div style={{ borderBottom: '1px solid rgba(201,150,63,0.10)', position: 'relative', overflow: 'hidden' }}>
      <button onClick={onToggle} style={{
        width: '100%', border: 'none', cursor: 'pointer',
        background: open ? `linear-gradient(90deg, ${ringAtmo.accentFaint}, transparent 72%)` : 'none',
        display: 'flex', alignItems: 'center', gap: 16, padding: '18px 24px',
        textAlign: 'left', color: LR_BASE.cream, transition: 'background 0.4s ease', position: 'relative', zIndex: 2,
      }}>
        {/* ring sigil chip */}
        <div style={{
          width: 48, height: 48, position: 'relative', flexShrink: 0, borderRadius: '50%',
          background: `radial-gradient(circle, ${ringAtmo.accentFaint}, transparent 72%)`,
          boxShadow: open ? `0 0 20px ${ringAtmo.glow}` : 'none', transition: 'box-shadow 0.4s ease',
        }}>
          <LrSigil atmo={ringAtmo} size={48} opacity={2.4} spin={open} spinDir={ring % 2 ? 1 : -1} />
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
            <span style={{ fontFamily: LR_SERIF, fontSize: 21, letterSpacing: '0.04em', color: open ? ringAtmo.accentBright : LR_BASE.cream }}>{av.name}</span>
            {holdsToday ? <span style={{
              width: 7, height: 7, borderRadius: '50%', background: ringAtmo.accentBright,
              boxShadow: `0 0 8px ${ringAtmo.accentBright}`, flexShrink: 0,
            }} /> : null}
          </div>
          <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 14.5, color: 'rgba(242,232,217,0.55)', marginTop: 3 }}>
            {av.subtitle}
          </div>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 4, flexShrink: 0 }}>
          <LrLabel size={10.5} color={ringAtmo.accentBright}>{list.length}</LrLabel>
          <span style={{
            fontSize: 13, color: 'rgba(242,232,217,0.4)',
            transform: open ? 'rotate(90deg)' : 'none', transition: 'transform 0.3s ease',
          }}>›</span>
        </div>
      </button>

      {open ? (
        <div style={{ position: 'relative', padding: '4px 24px 18px', background: `linear-gradient(${ringAtmo.groundDeep}, transparent)` }}>
          {/* the ring's geometry, filling the room you've entered */}
          <div style={{ position: 'absolute', inset: 0, opacity: 0.5, pointerEvents: 'none', overflow: 'hidden' }}>
            <div style={{ position: 'absolute', left: '50%', top: '46%', transform: 'translate(-50%,-50%)' }}>
              <LrSigil atmo={ringAtmo} size={360} spin spinDir={ring % 2 ? 1 : -1} />
            </div>
          </div>
          {/* atmosphere caption — her ring's mental state, and the threshold */}
          <div style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10, padding: '6px 2px 12px', flexWrap: 'wrap' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
              <LrLabel size={10} color={ringAtmo.accentBright} tracking="0.24em">{av.form}</LrLabel>
              {av.mentalState ? <span style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 14, color: 'rgba(242,232,217,0.6)' }}>{av.mentalState}</span> : null}
            </div>
            <button onClick={() => onOpenThreshold && onOpenThreshold(ring)} style={{
              background: 'none', border: 'none', cursor: 'pointer', flexShrink: 0,
              fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 14, color: ringAtmo.accentBright, letterSpacing: '0.04em',
            }}>the threshold&nbsp;›</button>
          </div>
          <div style={{ position: 'relative' }}>
          {list.map(s => {
            const isToday = s.kp === todayShakti.kp;
            const sAtmo = lrAtmosphere(s);
            const felt = (countByKp[s.kp] || 0) > 0;
            return (
              <button key={s.kp} onClick={() => onOpenShakti(s)} style={{
                width: '100%', background: isToday ? `linear-gradient(90deg, ${sAtmo.accentFaint}, transparent 80%)` : 'none',
                border: 'none', borderRadius: 10, cursor: 'pointer',
                display: 'flex', alignItems: 'center', gap: 14, padding: '11px 12px',
                textAlign: 'left', color: LR_BASE.cream,
              }}>
                <div style={{ width: 7, height: 7, borderRadius: '50%', background: sAtmo.accent,
                  opacity: felt ? 1 : 0.4, boxShadow: felt ? `0 0 8px ${sAtmo.accentBright}` : 'none', flexShrink: 0 }} />
                <span style={{ fontFamily: LR_SERIF, fontSize: 19, letterSpacing: '0.03em', flex: 1, minWidth: 0, color: felt ? LR_BASE.cream : 'rgba(242,232,217,0.82)' }}>
                  {s.name}
                </span>
                {isToday ? (
                  <span style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 13.5, color: sAtmo.accentBright, flexShrink: 0 }}>today</span>
                ) : (felt ? <span style={{ fontFamily: 'ui-sans-serif,sans-serif', fontSize: 10.5, color: sAtmo.accentBright, flexShrink: 0 }}>{countByKp[s.kp]}</span> : null)}
              </button>
            );
          })}
          </div>
        </div>
      ) : null}
    </div>
  );
}

// ─── The Well ─────────────────────────────────────────────────────────────────

function WellScreen({ dayAtmo, countByKp, onOpenLetter }) {
  const karsinis = LR_ALL.filter(s => s.ring === 2);
  const preview = (kp) => { try { return (localStorage.getItem('lr_letter_' + kp) || '').split('\n')[0].trim(); } catch (e) { return ''; } };
  return (
    <div data-screen-label="The Well" style={{
      position: 'absolute', inset: 0,
      background: `linear-gradient(${dayAtmo.ground}, ${dayAtmo.groundDeep})`,
      fontFamily: LR_SERIF, color: LR_BASE.cream,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <div style={{ position: 'relative', zIndex: 2, textAlign: 'center', padding: `${LR_SAFE_TOP}px 24px 16px`, borderBottom: '1px solid rgba(201,150,63,0.12)' }}>
        <h1 style={{ margin: 0, fontWeight: 300, fontSize: 32, letterSpacing: '0.06em', color: LR_BASE.gold }}>The Well</h1>
        <LrLabel size={11} color="rgba(242,232,217,0.42)" style={{ marginTop: 8 }}>
          speak to her directly · she is listening
        </LrLabel>
        <div style={{ fontStyle: 'italic', fontSize: 14.5, color: 'rgba(242,232,217,0.5)', marginTop: 10 }}>
          The sixteen Karṣiṇīs of your home ring receive letters.
        </div>
      </div>
      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 0 30px' }}>
        {karsinis.map(s => {
          const sAtmo = lrAtmosphere(s);
          const first = preview(s.kp);
          return (
            <button key={s.kp} onClick={() => onOpenLetter(s)} style={{
              width: '100%', background: 'none', border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'flex-start', gap: 16, padding: '16px 26px',
              textAlign: 'left', color: LR_BASE.cream,
              borderBottom: '1px solid rgba(201,150,63,0.07)',
            }}>
              <div style={{ paddingTop: 9 }}><LrClusterDot color={sAtmo.accent} size={8} /></div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: LR_SERIF, fontSize: 22, letterSpacing: '0.04em' }}>{s.name}</div>
                <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 15, color: first ? 'rgba(242,232,217,0.6)' : 'rgba(242,232,217,0.36)', marginTop: 3, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {first || 'You can speak to her here'}
                </div>
              </div>
              <span style={{ fontSize: 15, color: 'rgba(242,232,217,0.3)', paddingTop: 8 }}>›</span>
            </button>
          );
        })}
      </div>
    </div>
  );
}

// ─── The Memory — portrait of attention ──────────────────────────────────────

function MemoryScreen({ dayAtmo, todayShakti, countByKp, settleKp }) {
  const D = 330, c = D / 2;
  const ringR = { 1: 152, 2: 118, 3: 92, 4: 76, 5: 63, 6: 50, 7: 38, 8: 25, 9: 0 };
  const [settlePhase, setSettlePhase] = React.useState(0);
  React.useEffect(() => {
    if (settleKp == null) return;
    setSettlePhase(0);
    const start = Date.now();
    const id = setInterval(() => {
      const p = Math.min(1, (Date.now() - start) / 3400);
      setSettlePhase(p);
      if (p >= 1) clearInterval(id);
    }, 30);
    return () => clearInterval(id);
  }, [settleKp]);
  const cnt = countByKp || {};

  const dots = LR_ALL.map(s => {
    const list = LR_ALL.filter(x => x.ring === s.ring);
    const idx = list.findIndex(x => x.kp === s.kp);
    const a = (idx * 2 * Math.PI) / list.length - Math.PI / 2;
    const r = ringR[s.ring];
    const n = cnt[s.kp] || 0;
    const felt = n > 0;
    const intensity = Math.min(1, n / 7);
    const sAtmo = lrAtmosphere(s);
    return { x: c + r * Math.cos(a), y: c + r * Math.sin(a), felt, intensity, kp: s.kp,
      color: felt ? sAtmo.accentBright : 'rgba(242,232,217,0.14)' };
  });
  const settleDot = settleKp != null ? dots.find(d => d.kp === settleKp) : null;
  const ease = (x) => 1 - Math.pow(1 - Math.max(0, Math.min(1, x)), 3);
  // One continuous motion: her point flies out of the bindu (0–0.34), then a
  // halo blooms at her seat (0.34–1). The rest of the field fades in behind her.
  const arrive = settleDot ? ease(settlePhase / 0.34) : 1;
  const haloP = settleDot ? Math.max(0, Math.min(1, (settlePhase - 0.34) / 0.66)) : 0;
  const fieldP = settleKp != null ? Math.min(1, settlePhase / 0.45) : 1;
  const hx = settleDot ? c + (settleDot.x - c) * arrive : c;
  const hy = settleDot ? c + (settleDot.y - c) * arrive : c;

  return (
    <div data-screen-label="The Memory — Portrait Mandala" style={{
      position: 'absolute', inset: 0,
      background: `radial-gradient(ellipse 100% 60% at 50% 45%, ${dayAtmo.glow}, transparent 75%), linear-gradient(${dayAtmo.groundDeep}, #050203)`,
      fontFamily: LR_SERIF, color: LR_BASE.cream,
      display: 'flex', flexDirection: 'column', alignItems: 'center', overflow: 'hidden',
    }}>
      <div style={{ textAlign: 'center', padding: `${LR_SAFE_TOP}px 24px 0`, opacity: fieldP, transition: 'opacity 0.4s ease' }}>
        <h1 style={{ margin: 0, fontWeight: 300, fontSize: 32, letterSpacing: '0.06em' }}>The Memory</h1>
        <LrLabel size={11} color="rgba(242,232,217,0.45)" style={{ marginTop: 8 }}>
          your face in the instrument
        </LrLabel>
      </div>

      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <svg width={D} height={D} viewBox={`0 0 ${D} ${D}`}>
          <g opacity={fieldP}>
            {Object.values(ringR).filter(r => r > 0).map((r, i) => (
              <circle key={i} cx={c} cy={c} r={r} fill="none" stroke="rgba(242,232,217,0.05)" strokeWidth="0.5" />
            ))}
            {[78, 58, 40].map((r, i) => (
              <path key={'t'+i} d={lrTrianglePath(c, c, r, i % 2 === 1)} fill="none" stroke="rgba(201,150,63,0.14)" strokeWidth="0.6" />
            ))}
            {dots.map(d => {
              if (settleDot && d.kp === settleKp) return null;   // drawn as the flying head
              return (
                <g key={d.kp}>
                  {d.felt ? <circle cx={d.x} cy={d.y} r={4 + d.intensity * 6} fill={d.color} opacity={0.12 + d.intensity * 0.16} /> : null}
                  <circle cx={d.x} cy={d.y} r={d.felt ? 2.2 + d.intensity * 2 : 1.5} fill={d.color} opacity={d.felt ? 0.7 + d.intensity * 0.3 : 1} />
                </g>
              );
            })}
          </g>

          {/* her point, flown from the recognition into its seat */}
          {settleDot ? (
            <g>
              <line x1={c} y1={c} x2={hx} y2={hy} stroke={LR_BASE.gold} strokeWidth={1.1} strokeLinecap="round" opacity={(1 - arrive) * 0.5} />
              {haloP > 0 ? (
                <circle cx={settleDot.x} cy={settleDot.y} r={6 + haloP * 30} fill="none" stroke={LR_BASE.gold} strokeWidth="1" opacity={(1 - haloP) * 0.8} />
              ) : null}
              <circle cx={hx} cy={hy} r={14} fill={LR_BASE.gold} opacity={0.18 + (1 - arrive) * 0.2} />
              <circle cx={hx} cy={hy} r={arrive < 1 ? 4.6 : 3.4} fill={LR_BASE.gold} opacity={0.95} />
            </g>
          ) : null}

          <circle cx={c} cy={c} r={10} fill={`url(#lrBindu)`} />
          <circle cx={c} cy={c} r={3.5} fill={LR_BASE.cream} />
          <defs>
            <radialGradient id="lrBindu">
              <stop offset="0%" stopColor={LR_BASE.red} />
              <stop offset="100%" stopColor="transparent" />
            </radialGradient>
          </defs>
        </svg>
      </div>

      <div style={{ paddingBottom: 46, textAlign: 'center', opacity: fieldP, transition: 'opacity 0.4s ease' }}>
        <div style={{ fontStyle: 'italic', fontSize: 16, color: 'rgba(242,232,217,0.45)' }}>
          she is felt, not measured
        </div>
      </div>
    </div>
  );
}

// ─── Menu veil ────────────────────────────────────────────────────────────────

function MenuVeil({ dayAtmo, current, onSelect, onClose }) {
  const items = [
    { id: 'today',   label: 'The Rite' },
    { id: 'mandala', label: 'The Mandala' },
    { id: 'field',   label: 'The Field' },
    { id: 'well',    label: 'The Well' },
    { id: 'memory',  label: 'The Memory' },
  ];
  return (
    <div
      data-screen-label="Menu"
      onClick={onClose}
      style={{
        position: 'absolute', inset: 0, zIndex: 40,
        background: `radial-gradient(ellipse 80% 55% at 50% 42%, ${dayAtmo.glow}, transparent 75%), ${dayAtmo.groundDeep}`,
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        gap: 8, animation: 'lrVeilIn 0.45s ease',
      }}
    >
      {items.map(it => (
        <button
          key={it.id}
          onClick={(e) => { e.stopPropagation(); onSelect(it.id); }}
          style={{
            background: 'none', border: 'none', cursor: 'pointer',
            fontFamily: LR_SERIF, fontStyle: 'italic', fontWeight: 300,
            fontSize: 36, letterSpacing: '0.04em', padding: '10px 40px',
            color: current === it.id ? dayAtmo.accentBright : LR_BASE.cream,
          }}
        >
          {it.label}
        </button>
      ))}
      <button
        onClick={(e) => e.stopPropagation()}
        style={{
          background: 'none', border: 'none', cursor: 'default',
          fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 20,
          color: 'rgba(242,232,217,0.35)', marginTop: 26, padding: '8px 40px',
        }}
      >
        Settings
      </button>
    </div>
  );
}

Object.assign(window, { FieldScreen, WellScreen, MemoryScreen, MenuVeil });
