// ─── Bindu Mandala — The Veil · The Descent ──────────────────────────────────
// FULL-FIDELITY INTERACTION — design handoff to Claude Code.
//
// THE GESTURE
//   Resting: the yantra is a held image. Bindu breathes; Ring 2 petals live.
//   A faint peek at the bottom whispers "there is more below."
//   Swipe up (or tap the handle) → a veil of dark ground rises over the yantra,
//   which dims behind it (to ~0.55) but is never hidden. Swipe back down, or
//   tap the dimmed yantra, to dismiss.
//
// THE DESCENT (inside the veil)
//   Nine Avaraṇas as a column read top→bottom = outer ground → inner Bindu.
//   Rings I–VIII are rows; Ring IX (the Bindu) is a distinct footer, not a row.
//
// LUMINOSITY SYSTEM (status is light, never locks — no labels, no padlocks)
//   home       fully lit + faint gold wash behind the row + glyph glow
//   unlocked   glyph & name glow gold, solid threshold-line
//   ancient    warm but dimmer (the ground beneath you), solid line
//   locked     veiled (~0.34), DASHED threshold-line = not yet crossed
//   deep_ghost barely there (~0.20), dashed line
//
// ROUTING ON TAP
//   open ring (home/unlocked/ancient) → Ring World   (Ring II = the inhabited lotus)
//   locked / deep_ghost ring          → Threshold ceremony
// ─────────────────────────────────────────────────────────────────────────────

const { RingGlyph, HeldYantra, SriYantraMandala,
        StatusBar, HomeIndicator, DustMotes,
        AvaranaThresholdScreen, RingTwoWorld } = window;

const ROMAN_V = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'];

// Luminosity tokens — the entire status language lives here.
const LUM = {
  home:       { glyph: 0.95, name: 0.96, sub: 0.62, accent: '#C9963F',               dashed: false, wash: true,  glow: true  },
  unlocked:   { glyph: 0.85, name: 0.88, sub: 0.54, accent: '#C9963F',               dashed: false, wash: false, glow: true  },
  ancient:    { glyph: 0.60, name: 0.66, sub: 0.42, accent: '#CF9443',               dashed: false, wash: false, glow: false },
  locked:     { glyph: 0.30, name: 0.36, sub: 0.24, accent: 'rgba(242,232,217,0.42)', dashed: true,  wash: false, glow: false },
  deep_ghost: { glyph: 0.18, name: 0.22, sub: 0.15, accent: 'rgba(242,232,217,0.30)', dashed: true,  wash: false, glow: false },
};

const isOpenRing = (status) => status === 'home' || status === 'unlocked' || status === 'ancient';

// ─── One threshold in the descent ────────────────────────────────────────────

function ThresholdRow({ av, onEnter }) {
  const L = LUM[av.status];
  return (
    <div
      onClick={() => onEnter(av.ring)}
      style={{
        display: 'flex', alignItems: 'center', gap: 16,
        padding: '15px 16px',
        borderRadius: 13,
        background: L.wash
          ? 'linear-gradient(90deg, rgba(201,150,63,0.10) 0%, rgba(201,150,63,0.03) 100%)'
          : 'transparent',
        border: L.wash ? '0.5px solid rgba(201,150,63,0.26)' : '0.5px solid transparent',
        borderBottom: L.wash
          ? '0.5px solid rgba(201,150,63,0.26)'
          : (L.dashed ? '0.5px dashed rgba(242,232,217,0.11)' : '0.5px solid rgba(201,150,63,0.11)'),
        cursor: 'pointer',
        WebkitTapHighlightColor: 'transparent',
      }}>
      {/* Glyph — with a soft glow when the ring is lit */}
      <div style={{ position: 'relative', display: 'flex', flexShrink: 0,
        filter: L.glow ? 'drop-shadow(0 0 7px rgba(201,150,63,0.45))' : 'none' }}>
        <RingGlyph ring={av.ring} size={36} color={L.accent} opacity={L.glyph} />
      </div>

      {/* Name block */}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 20, fontWeight: 300,
          color: '#F2E8D9', opacity: L.name, letterSpacing: '0.03em', lineHeight: 1.1,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
          {av.name}
        </div>
        <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 13, fontStyle: 'italic',
          color: '#F2E8D9', opacity: L.sub, letterSpacing: '0.02em',
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
          {av.subtitle}
        </div>
        <div style={{ fontSize: 9, color: '#F2E8D9', opacity: L.sub * 0.72,
          letterSpacing: '0.11em', textTransform: 'uppercase', marginTop: 4 }}>
          {av.form} · {av.count} {av.count === 1 ? 'point' : 'forces'}
        </div>
      </div>

      {/* Roman numeral — the only ornament on the right */}
      <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 19, color: L.accent,
        opacity: L.glyph, letterSpacing: '0.06em', lineHeight: 1, flexShrink: 0, width: 30,
        textAlign: 'right' }}>
        {ROMAN_V[av.ring]}
      </div>
    </div>
  );
}

// ─── The Bindu footer — Ring IX, not a row ───────────────────────────────────

function BinduFooter({ av, onEnter }) {
  return (
    <div onClick={() => onEnter(av.ring)} style={{
      position: 'relative', marginTop: 14, padding: '30px 16px 26px',
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      cursor: 'pointer', WebkitTapHighlightColor: 'transparent',
    }}>
      {/* A more present hairline — you have reached the center of the column */}
      <div style={{ position: 'absolute', top: 0, left: '14%', right: '14%', height: 0.5,
        background: 'linear-gradient(90deg, transparent, rgba(201,150,63,0.45), transparent)' }} />
      {/* radial warmth behind the point */}
      <div style={{ position: 'absolute', top: 8, left: '50%', transform: 'translateX(-50%)',
        width: 180, height: 130,
        background: 'radial-gradient(ellipse 50% 50% at 50% 40%, rgba(139,26,42,0.20) 0%, transparent 70%)',
        pointerEvents: 'none' }} />

      <div className="veil-bindu" style={{
        width: 26, height: 26, marginBottom: 18, position: 'relative',
        background: 'radial-gradient(circle, #8B1A2A 0%, rgba(139,26,42,0.65) 55%, transparent 100%)',
      }}>
        <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
          width: 10, height: 10, borderRadius: '50%', background: '#F2E8D9',
          boxShadow: '0 0 12px rgba(242,232,217,0.6)', opacity: 0.96 }} />
      </div>

      <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 24, fontWeight: 300,
        color: '#C9963F', letterSpacing: '0.05em', lineHeight: 1.1, textAlign: 'center' }}>
        {av.name}
      </div>
      <div style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 14, fontStyle: 'italic',
        color: 'rgba(242,232,217,0.6)', letterSpacing: '0.03em', marginTop: 5, textAlign: 'center' }}>
        {av.subtitle}
      </div>
      <div style={{ fontSize: 8.5, color: 'rgba(201,150,63,0.55)', letterSpacing: '0.26em',
        textTransform: 'uppercase', marginTop: 12 }}>
        The Bindu · IX
      </div>
    </div>
  );
}

// ─── Destination — Ring World (open) or Threshold ceremony (locked) ──────────

function Destination({ ring, onBack }) {
  const av = AVARANAS[ring - 1];
  let screen;
  if (isOpenRing(av.status) && ring === 2) {
    screen = <RingTwoWorld todayIndex={TODAY_INDEX} />;     // the inhabited lotus
  } else {
    screen = <AvaranaThresholdScreen avarana={av} />;        // doorway (open) / ceremony (locked)
  }

  React.useEffect(() => {
    const onKey = (e) => { if (e.key === 'Escape') onBack(); };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [onBack]);

  return (
    <div className="dest-enter" style={{ position: 'absolute', inset: 0, zIndex: 60 }}>
      {screen}
      {/* Integrated back affordance over the existing "‹ Mandala" / return arc */}
      <div onClick={onBack} title="Back to the mandala" style={{
        position: 'absolute', top: 44, left: 0, width: 180, height: 56,
        cursor: 'pointer', zIndex: 61, WebkitTapHighlightColor: 'transparent',
      }} />
    </div>
  );
}

// ─── The screen ──────────────────────────────────────────────────────────────

function VeilMandala() {
  const SCREEN_W = 390, SCREEN_H = 844;
  const SHEET_H = 720, PEEK = 108;
  const CLOSED = SHEET_H - PEEK;          // translateY when resting
  const SNAP = CLOSED * 0.42;             // past this (upward) → open

  const offsetRef = React.useRef(CLOSED);
  const [, force] = React.useReducer((x) => x + 1, 0);
  const setOff = (v) => { offsetRef.current = v; force(); };

  const rootRef = React.useRef(null);
  const [dragging, setDragging] = React.useState(false);
  const drag = React.useRef(null);       // { startY, startOffset, moved }
  const [route, setRoute] = React.useState(null);

  // The stage is scaled to fit the viewport; convert screen px → local px.
  function localScale() {
    const el = rootRef.current;
    if (!el) return 1;
    const r = el.getBoundingClientRect();
    return r.height ? r.height / SCREEN_H : 1;
  }

  const offset = offsetRef.current;
  const open = offset < CLOSED * 0.5;
  // yantra dims from 1.0 (closed) → 0.5 (fully open)
  const dim = 0.5 + 0.5 * (offset / CLOSED);

  function pointerY(e) { return e.clientY != null ? e.clientY : (e.touches && e.touches[0].clientY); }
  function onDown(e) {
    drag.current = { startY: pointerY(e), startOffset: offsetRef.current, moved: 0 };
    setDragging(true);
    if (e.currentTarget.setPointerCapture && e.pointerId != null) {
      try { e.currentTarget.setPointerCapture(e.pointerId); } catch (_) {}
    }
  }
  function onMove(e) {
    if (!drag.current) return;
    const dyScreen = pointerY(e) - drag.current.startY;
    const dy = dyScreen / localScale();
    drag.current.moved = Math.max(drag.current.moved, Math.abs(dyScreen));
    let next = drag.current.startOffset + dy;
    next = Math.max(0, Math.min(CLOSED, next));
    setOff(next);
  }
  function onUp() {
    if (!drag.current) return;
    const tap = drag.current.moved < 6;
    setDragging(false);
    if (tap) {                              // treat as a tap on the handle → toggle
      setOff(offsetRef.current < CLOSED * 0.5 ? CLOSED : 0);
    } else {
      setOff(offsetRef.current < SNAP ? 0 : CLOSED);
    }
    drag.current = null;
  }

  const sheetTransition = dragging ? 'none' : 'transform 0.52s cubic-bezier(.22,1,.36,1)';

  const rows = AVARANAS.filter((a) => a.ring <= 8).sort((a, b) => a.ring - b.ring);
  const bindu = AVARANAS.find((a) => a.ring === 9);

  return (
    <div ref={rootRef} style={{ width: SCREEN_W, height: SCREEN_H, background: '#060104',
      position: 'relative', overflow: 'hidden',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif' }}>

      {/* ambient warmth */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(ellipse 64% 46% at 50% 42%, rgba(201,150,63,0.06) 0%, transparent 70%)' }} />
      <DustMotes count={6} />

      {/* ── The held yantra (dims behind the veil) ── */}
      <div style={{ position: 'absolute', inset: 0, transition: dragging ? 'none' : 'opacity 0.5s ease',
        opacity: dim }}>
        <StatusBar />
        <div style={{ textAlign: 'center', paddingTop: 4, fontSize: 10, color: '#C9963F',
          letterSpacing: '0.17em', textTransform: 'uppercase', opacity: 0.8 }}>
          2nd Avaraṇa · Sarvāśā-Paripūraka
        </div>
        <div style={{ position: 'absolute', top: 116, left: 0, right: 0, height: 600,
          display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <HeldYantra scale={0.82} />
        </div>
        <div style={{ position: 'absolute', top: 690, left: 0, right: 0, textAlign: 'center',
          fontFamily: "'Cormorant Garamond', serif", fontSize: 13, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.30)', letterSpacing: '0.05em',
          opacity: open ? 0 : 1, transition: 'opacity 0.4s ease' }}>
          the instrument · look, do not operate
        </div>
      </div>

      {/* ── Backdrop catcher — tap dimmed yantra to dismiss ── */}
      {open && (
        <div onClick={() => setOff(CLOSED)} style={{ position: 'absolute', inset: 0, zIndex: 5 }} />
      )}

      {/* ── The Veil ── */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, height: SHEET_H,
        transform: `translateY(${offset}px)`, transition: sheetTransition,
        zIndex: 10, display: 'flex', flexDirection: 'column',
        background: 'linear-gradient(to top, rgba(8,2,6,0.995) 0%, rgba(11,3,7,0.985) 70%, rgba(13,4,9,0.92) 100%)',
        borderTop: '0.5px solid rgba(201,150,63,0.22)',
        borderRadius: '22px 22px 0 0',
        boxShadow: '0 -20px 60px rgba(0,0,0,0.7), 0 -1px 30px rgba(201,150,63,0.10)',
      }}>
        {/* Handle / peek — the draggable header */}
        <div className="veil-handle"
          onPointerDown={onDown} onPointerMove={onMove} onPointerUp={onUp} onPointerCancel={onUp}
          style={{ flexShrink: 0, padding: '14px 24px 12px', cursor: 'grab', touchAction: 'none',
            userSelect: 'none' }}>
          <div style={{ width: 40, height: 4, borderRadius: 3, background: 'rgba(242,232,217,0.30)',
            margin: '0 auto 14px' }} />
          {/* Peek state: a whisper. Open state: the section title. */}
          {open ? (
            <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <span style={{ fontFamily: "'Cormorant Garamond', serif", fontSize: 22, fontWeight: 300,
                color: '#F2E8D9', letterSpacing: '0.04em' }}>The Nine Avaraṇas</span>
              <span style={{ fontSize: 8.5, color: '#C9963F', opacity: 0.5, letterSpacing: '0.16em',
                textTransform: 'uppercase' }}>Descend</span>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 7 }}>
              <svg className="peek-chevron" width="22" height="9" viewBox="0 0 22 9">
                <path d="M2,7 L11,2 L20,7" fill="none" stroke="#C9963F" strokeWidth="1" strokeLinecap="round" opacity="0.55" />
              </svg>
              <span style={{ fontSize: 8.5, color: 'rgba(201,150,63,0.5)', letterSpacing: '0.26em',
                textTransform: 'uppercase' }}>The Nine Avaraṇas</span>
            </div>
          )}
        </div>

        {/* The descending column */}
        <div style={{ flex: 1, overflowY: 'auto', padding: '4px 18px 28px', opacity: open ? 1 : 0.0,
          transition: 'opacity 0.4s ease', pointerEvents: open ? 'auto' : 'none' }}>
          {rows.map((av) => <ThresholdRow key={av.ring} av={av} onEnter={setRoute} />)}
          {bindu && <BinduFooter av={bindu} onEnter={setRoute} />}
        </div>
      </div>

      <HomeIndicator />

      {/* ── Destination overlay ── */}
      {route != null && <Destination ring={route} onBack={() => setRoute(null)} />}
    </div>
  );
}

Object.assign(window, { VeilMandala, ThresholdRow, BinduFooter, Destination });
