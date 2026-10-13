// living-rite-more.jsx — restored engagement mechanics:
// Embodiment progression · Her Moments · Nityā detail · Avaraṇa threshold ·
// The Well letter editor. All lit by the day's / her atmosphere.

// ─── Embodiment pill — she deepens as she is felt ─────────────────────────────

function EmbodimentPill({ shakti, atmo, count }) {
  const [level, setLevel] = React.useState(() => lrCrossLevel(shakti.kp));
  const [held, setHeld] = React.useState(0);   // 0..1 during the hold
  const holdRef = React.useRef(null);

  const cur = LR_STATUS[level];
  const reached = lrReachedIndex(count);
  const readyTarget = level < LR_STATUS.length - 1 && reached > level ? level + 1 : null;

  const beginHold = () => {
    if (!readyTarget) return;
    setHeld(0.001);
    const start = Date.now();
    holdRef.current = setInterval(() => {
      const p = Math.min(1, (Date.now() - start) / 750);
      setHeld(p);
      if (p >= 1) {
        clearInterval(holdRef.current);
        const next = level + 1;
        lrSetCrossLevel(shakti.kp, next);
        setLevel(next);
        setHeld(0);
        if (navigator.vibrate) navigator.vibrate(12);
      }
    }, 30);
  };
  const endHold = () => { if (holdRef.current) clearInterval(holdRef.current); setHeld(0); };
  React.useEffect(() => () => endHold(), []);

  const pillColor = [
    'rgba(242,232,217,0.4)', atmo.accentSoft, atmo.accent, atmo.accentBright,
  ][level];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
      {/* four-node embodiment track */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
        {LR_STATUS.map((s, i) => (
          <React.Fragment key={s.key}>
            {i > 0 ? <div style={{ width: 18, height: 1, background: i <= level ? atmo.accent : 'rgba(242,232,217,0.14)' }} /> : null}
            <div style={{
              width: i === level ? 9 : 6, height: i === level ? 9 : 6, borderRadius: '50%',
              background: i <= level ? (i === level ? atmo.accentBright : atmo.accent) : 'transparent',
              border: i > level ? '1px solid rgba(242,232,217,0.22)' : 'none',
              boxShadow: i === level ? `0 0 10px ${atmo.accentBright}` : 'none',
            }} />
          </React.Fragment>
        ))}
      </div>

      <button
        onMouseDown={beginHold} onMouseUp={endHold} onMouseLeave={endHold}
        onTouchStart={beginHold} onTouchEnd={endHold}
        disabled={!readyTarget}
        style={{
          position: 'relative', overflow: 'hidden', cursor: readyTarget ? 'pointer' : 'default',
          background: 'none', border: `1px solid ${pillColor}`, borderRadius: 999,
          padding: '6px 16px', fontFamily: 'ui-sans-serif, sans-serif', fontSize: 10.5,
          letterSpacing: '0.18em', textTransform: 'uppercase', color: pillColor,
          animation: readyTarget ? 'lrPillBreath 2.2s ease-in-out infinite' : 'none',
        }}
      >
        <span style={{ position: 'absolute', inset: 0, background: atmo.accent, opacity: 0.22, width: `${held * 100}%`, transition: 'none' }} />
        <span style={{ position: 'relative' }}>{cur.label}</span>
      </button>

      {readyTarget ? (
        <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 13, color: 'rgba(242,232,217,0.5)' }}>
          hold to cross into {LR_STATUS[readyTarget].label.toLowerCase()}
        </div>
      ) : (
        <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 13, color: 'rgba(242,232,217,0.4)' }}>
          {level === LR_STATUS.length - 1 ? 'she lives in you' : 'felt into being'}
        </div>
      )}
    </div>
  );
}

// ─── Her Moments — the record of every recognition ────────────────────────────

function HerMoments({ moments, atmo }) {
  const fmt = (ts) => {
    const d = new Date(ts), now = new Date();
    const sameDay = d.toDateString() === now.toDateString();
    const yst = new Date(now.getTime() - 86400000).toDateString() === d.toDateString();
    let h = d.getHours() % 12; if (h === 0) h = 12;
    const m = String(d.getMinutes()).padStart(2, '0');
    const ap = d.getHours() < 12 ? 'AM' : 'PM';
    const when = sameDay ? 'today' : yst ? 'yesterday' : d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    return `${when}, ${h}:${m} ${ap}`;
  };
  if (!moments || moments.length === 0) {
    return <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 17, color: 'rgba(242,232,217,0.5)' }}>She has not been felt here yet.</div>;
  }
  return (
    <div>
      {moments.slice().reverse().map((mo, i) => (
        <div key={mo.ts} style={{ display: 'flex', gap: 14, padding: '11px 0', borderBottom: '1px solid rgba(201,150,63,0.08)' }}>
          <div style={{ width: 6, height: 6, borderRadius: '50%', background: atmo.accent, marginTop: 8, flexShrink: 0, boxShadow: `0 0 6px ${atmo.accent}` }} />
          <div style={{ flex: 1 }}>
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'baseline' }}>
              <span style={{ fontFamily: 'ui-sans-serif, sans-serif', fontSize: 12, letterSpacing: '0.03em', color: 'rgba(242,232,217,0.6)' }}>she was felt here · {fmt(mo.ts)}</span>
              <span style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 13, color: 'rgba(242,232,217,0.45)' }}>· {lrMoonName(mo.ts)}</span>
            </div>
            {mo.note ? <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 15, color: 'rgba(242,232,217,0.68)', marginTop: 4, textWrap: 'pretty' }}>{mo.note}</div> : null}
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── Nityā sheet — who presides over today ────────────────────────────────────

function NityaSheet({ moon, dayAtmo, onClose }) {
  const isFull = moon.isFull;
  const nitya = window.NITYA_DEVIS.find(n => n.name === moon.nityaName);
  return (
    <div onClick={onClose} style={{
      position: 'absolute', inset: 0, zIndex: 45, background: 'rgba(4,1,3,0.55)',
      display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', animation: 'lrVeilIn 0.3s ease',
    }}>
      <div onClick={(e) => e.stopPropagation()} style={{
        background: `radial-gradient(ellipse 120% 60% at 50% 0%, ${dayAtmo.glow}, transparent 70%), linear-gradient(${dayAtmo.ground}, ${dayAtmo.groundDeep})`,
        borderTopLeftRadius: 26, borderTopRightRadius: 26, borderTop: '1px solid rgba(201,150,63,0.2)',
        padding: '14px 32px 40px', maxHeight: '78%', overflowY: 'auto', animation: 'lrSheetUp 0.42s cubic-bezier(0.2,0.9,0.3,1)',
      }}>
        <div style={{ width: 40, height: 4, borderRadius: 2, background: 'rgba(242,232,217,0.2)', margin: '0 auto 26px' }} />
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 22 }}>
          <LrMoonGlyph frac={moon.frac} size={26} />
          <LrLabel size={11} color={dayAtmo.accentBright} tracking="0.26em">{moon.tithiLabel}</LrLabel>
        </div>
        <div style={{ fontFamily: LR_SERIF, fontWeight: 300, fontSize: lrNameSize(moon.nityaName, 40), lineHeight: 1.12, letterSpacing: '0.04em', color: LR_BASE.cream }}>
          {moon.nityaName}
        </div>
        <div style={{ margin: '20px 0' }}><LrHairline width={40} color={dayAtmo.accentSoft} /></div>
        <div style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 20, lineHeight: 1.5, color: dayAtmo.accentBright, textWrap: 'pretty' }}>
          {isFull ? 'Pūrṇimā — the full moon belongs to Lalitā, seated in the Bindu, from whom the whole yantra breathes.'
                  : `She presides over ${nitya ? nitya.tithiName : 'this tithi'} — one of the fifteen Nityā Devīs who turn the lunar fortnight.`}
        </div>
        <div style={{ fontFamily: LR_SERIF, fontSize: 16.5, lineHeight: 1.6, color: 'rgba(242,232,217,0.7)', marginTop: 18, textWrap: 'pretty' }}>
          The Nityā is the mood of the day itself — the goddess of this moon-phase, presiding above whichever of the 102 arrives to be felt. She frames the encounter without competing with it.
        </div>
        <button onClick={onClose} style={{
          marginTop: 30, background: 'none', border: 'none', cursor: 'pointer',
          fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 16, color: 'rgba(242,232,217,0.55)',
        }}>close</button>
      </div>
    </div>
  );
}

// ─── Avaraṇa threshold — "you have already been here" ─────────────────────────

function AvaranaThreshold({ ring, onEnter, onClose }) {
  const av = LR_AVARANA_BY_RING[ring];
  const atmo = React.useMemo(() => lrAtmosphere(LR_ALL.find(s => s.ring === ring)), [ring]);
  const [arrived, setArrived] = React.useState(false);
  React.useEffect(() => { const t = setTimeout(() => setArrived(true), 60); return () => clearTimeout(t); }, []);
  const fade = (d) => ({ opacity: arrived ? 1 : 0, transform: arrived ? 'none' : 'translateY(10px)', transition: `opacity 1.3s ease ${d}s, transform 1.3s ease ${d}s` });

  return (
    <div data-screen-label={`Threshold — ${av.name}`} style={{
      position: 'absolute', inset: 0, background: lrBackdrop(atmo),
      fontFamily: LR_SERIF, color: LR_BASE.cream, display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <div style={{ position: 'absolute', inset: 0, opacity: 0.7, pointerEvents: 'none' }}>
        <div style={{ position: 'absolute', left: '50%', top: '42%', transform: 'translate(-50%,-50%)' }}>
          <LrSigil atmo={atmo} size={620} spin spinDir={ring % 2 ? 1 : -1} />
        </div>
      </div>
      <LrMotes atmo={atmo} count={12} animate={true} />
      <LrDepth atmo={atmo} />

      <div style={{ position: 'relative', zIndex: 3, display: 'flex', justifyContent: 'space-between', padding: `${LR_SAFE_TOP}px 22px 0` }}>
        <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 17, color: LR_BASE.gold }}>‹ the field</button>
        <LrLabel size={11} color="rgba(242,232,217,0.45)">{av.count} śaktis</LrLabel>
      </div>

      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', padding: '0 30px', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
        <div style={{ textAlign: 'center' }}>
          <LrLabel size={11.5} color={atmo.accentBright} tracking="0.3em" style={fade(0.2)}>{LR_ORDINALS[ring]} Āvaraṇa · {av.form}</LrLabel>
          <h1 style={{ ...fade(0.35), margin: '18px 0 0', fontWeight: 300, fontSize: lrNameSize(av.name, 46), lineHeight: 1.1, letterSpacing: '0.05em', textShadow: `0 0 50px ${atmo.glow}` }}>{av.name}</h1>
          <div style={{ ...fade(0.5), fontStyle: 'italic', fontSize: 22, color: atmo.accentBright, marginTop: 14 }}>{av.subtitle}</div>
          <div style={{ ...fade(0.7), display: 'flex', justifyContent: 'center', margin: '24px 0' }}><LrHairline width={48} color={atmo.accentSoft} /></div>
          <div style={{ ...fade(0.8), fontStyle: 'italic', fontSize: 18.5, lineHeight: 1.62, color: 'rgba(242,232,217,0.82)', textAlign: 'left', textWrap: 'pretty' }}>
            {av.personalConnection}
          </div>
          {av.appreciationPhrase ? (
            <div style={{ ...fade(0.95), fontStyle: 'italic', fontSize: 18, lineHeight: 1.5, color: LR_BASE.gold, marginTop: 22, textWrap: 'pretty' }}>
              “{av.appreciationPhrase}”
            </div>
          ) : null}
          <div style={{ ...fade(1.05), display: 'flex', gap: 18, justifyContent: 'center', marginTop: 22, flexWrap: 'wrap' }}>
            {av.mentalState ? <span style={{ fontSize: 14.5, fontStyle: 'italic', color: 'rgba(242,232,217,0.55)' }}>{av.mentalState}</span> : null}
            {av.chakra ? <span style={{ fontSize: 14.5, fontStyle: 'italic', color: 'rgba(242,232,217,0.55)' }}>· {av.chakra}</span> : null}
          </div>
        </div>
      </div>

      <div style={{ position: 'relative', zIndex: 3, padding: '10px 30px 22px' }}>
        <button onClick={onEnter} style={{
          width: '100%', height: 56, border: 'none', borderRadius: 28, cursor: 'pointer',
          background: `linear-gradient(135deg, ${atmo.accent}, ${atmo.accentBright})`,
          boxShadow: `0 4px 40px ${atmo.glow}`, fontFamily: LR_SERIF, fontSize: 20, letterSpacing: '0.1em', color: '#0D0508',
        }}>enter her ring</button>
      </div>
    </div>
  );
}

// ─── The Well — letter editor ─────────────────────────────────────────────────

function LetterEditor({ shakti, atmo, onBack }) {
  const key = 'lr_letter_' + shakti.kp;
  const [draft, setDraft] = React.useState('');
  React.useEffect(() => { try { setDraft(localStorage.getItem(key) || ''); } catch (e) {} }, [key]);
  const save = (v) => { setDraft(v); try { localStorage.setItem(key, v); } catch (e) {} };

  return (
    <div data-screen-label={`Letter — ${shakti.name}`} style={{
      position: 'absolute', inset: 0, background: `linear-gradient(${atmo.groundDeep}, #0a0508)`,
      fontFamily: LR_SERIF, color: LR_BASE.cream, display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(ellipse 120% 40% at 50% 0%, ${atmo.glow}, transparent 68%)`, pointerEvents: 'none' }} />
      <div style={{ position: 'relative', zIndex: 2, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: `${LR_SAFE_TOP}px 22px 12px`, borderBottom: '1px solid rgba(201,150,63,0.12)' }}>
        <button onClick={() => { save(draft); onBack(); }} style={{ background: 'none', border: 'none', cursor: 'pointer', fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 17, color: LR_BASE.gold }}>‹ the well</button>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <LrClusterDot color={atmo.accent} size={7} />
          <span style={{ fontFamily: LR_SERIF, fontSize: 18, letterSpacing: '0.04em' }}>{shakti.name}</span>
        </div>
        <span style={{ width: 56 }} />
      </div>
      <textarea
        value={draft}
        onChange={(e) => save(e.target.value)}
        placeholder="Speak to her directly. She is listening."
        autoFocus
        style={{
          position: 'relative', zIndex: 2, flex: 1, width: '100%', border: 'none', outline: 'none', resize: 'none',
          background: 'transparent', color: 'rgba(242,232,217,0.92)', caretColor: LR_BASE.gold,
          fontFamily: LR_SERIF, fontSize: 20, lineHeight: 1.6, letterSpacing: '0.01em', padding: '22px 26px 30px',
        }}
      />
    </div>
  );
}

Object.assign(window, { EmbodimentPill, HerMoments, NityaSheet, AvaranaThreshold, LetterEditor });
