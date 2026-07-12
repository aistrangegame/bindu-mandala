// living-rite-detail.jsx — Her Presence (Shakti Detail) + the Recognition Moment.
// The detail inherits the day's atmosphere; scale is reverence.

function DetailScreen({ shakti, atmo, motion, moments, count, backLabel, onBack, onFeelHer }) {
  const [deeper, setDeeper] = React.useState(false);
  const av = atmo.avarana;
  const quality = lrQuality(shakti);
  const clusterInfo = shakti.cluster && window.CLUSTER_INFO ? window.CLUSTER_INFO[shakti.cluster] : null;

  const sectionLabel = (t) => (
    <LrLabel size={11.5} color={atmo.accentBright} tracking="0.28em" style={{ marginBottom: 12 }}>{t}</LrLabel>
  );

  return (
    <div data-screen-label={`Her Presence — ${shakti.name}`} style={{
      position: 'absolute', inset: 0,
      background: lrBackdrop(atmo),
      fontFamily: LR_SERIF, color: LR_BASE.cream,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      {/* fixed atmosphere */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}>
        <div style={{ position: 'absolute', inset: 0, background: `radial-gradient(ellipse 130% 55% at 50% -5%, ${atmo.glow}, transparent 70%)` }} />
        <div style={{ position: 'absolute', left: '50%', top: -160, transform: 'translateX(-50%)', opacity: 0.55 }}>
          <LrSigil atmo={atmo} size={600} spin spinDir={-1} />
        </div>
        <LrMotes atmo={atmo} count={10} animate={motion} />
      </div>
      <LrDepth atmo={atmo} />

      {/* nav */}
      <div style={{ position: 'relative', zIndex: 3, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: `${LR_SAFE_TOP}px 22px 10px` }}>
        <button onClick={onBack} style={{
          background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8,
          fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 17, color: LR_BASE.gold, padding: '6px 0',
        }}>
          <span style={{ fontSize: 24, fontWeight: 300, lineHeight: 0.8 }}>‹</span> {backLabel || 'today'}
        </button>
        <LrLabel size={11} color="rgba(242,232,217,0.45)">{shakti.kp} · 102</LrLabel>
      </div>

      {/* scroll body */}
      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', padding: '10px 28px 30px' }}>

        {/* Hero */}
        <div style={{ textAlign: 'center', paddingTop: 22, paddingBottom: 30 }}>
          <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 18 }}>
            <LrLabel size={11.5} color={atmo.accentBright} tracking="0.3em">
              {LR_ORDINALS[shakti.ring]} Āvaraṇa · {av ? av.form : ''}
            </LrLabel>
          </div>
          <h1 style={{
            margin: 0, fontWeight: 300, fontSize: lrNameSize(shakti.name, 50),
            lineHeight: 1.1, letterSpacing: '0.05em', textShadow: `0 0 50px ${atmo.glow}`,
          }}>{shakti.name}</h1>
          {shakti.phonetic ? (
            <LrLabel size={12.5} color="rgba(242,232,217,0.48)" tracking="0.26em" style={{ marginTop: 12 }}>
              {shakti.phonetic}
            </LrLabel>
          ) : null}
          <div style={{ display: 'flex', justifyContent: 'center', marginTop: 22 }}>
            <LrHairline width={54} color={`color-mix(in oklab, ${atmo.accent} 60%, transparent)`} />
          </div>
          <div style={{ fontSize: 24, lineHeight: 1.3, color: atmo.accentBright, marginTop: 22, textWrap: 'pretty' }}>
            {quality}
          </div>
          {clusterInfo ? (
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, marginTop: 16 }}>
              <LrClusterDot color={atmo.accent} size={7} />
              <LrLabel size={11} color="rgba(242,232,217,0.5)">{clusterInfo.label}</LrLabel>
            </div>
          ) : null}
        </div>

        {/* Portrait — the soul, leading */}
        {(shakti.description || (av && av.personalConnection)) ? (
          <div style={{ padding: '26px 0', borderTop: '1px solid rgba(201,150,63,0.14)' }}>
            <div style={{ fontStyle: 'italic', fontSize: 20, lineHeight: 1.6, color: LR_BASE.gold, textWrap: 'pretty' }}>
              {shakti.description || av.personalConnection}
            </div>
          </div>
        ) : null}

        {/* Somatic */}
        {shakti.somaticPoetry ? (
          <div style={{ padding: '26px 0', borderTop: '1px solid rgba(201,150,63,0.14)' }}>
            {sectionLabel('Somatic signature')}
            <div style={{ fontStyle: 'italic', fontSize: 20, lineHeight: 1.65, color: 'rgba(242,232,217,0.82)', whiteSpace: 'pre-line' }}>
              {shakti.somaticPoetry}
            </div>
          </div>
        ) : null}

        {/* Bīja */}
        {shakti.bija ? (
          <div style={{ padding: '26px 0', borderTop: '1px solid rgba(201,150,63,0.14)', textAlign: 'center' }}>
            {sectionLabel('Bīja · tap to hear')}
            <BijaGlyph bija={shakti.bija} atmo={atmo} />
          </div>
        ) : null}

        {/* Appreciation */}
        {(shakti.recognition || (av && av.appreciationPhrase)) ? (
          <div style={{ padding: '26px 0', borderTop: '1px solid rgba(201,150,63,0.14)', textAlign: 'center' }}>
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 16 }}>
              <LrHairline width={36} />
            </div>
            <div style={{ fontStyle: 'italic', fontSize: 19, lineHeight: 1.55, color: LR_BASE.gold, textWrap: 'pretty' }}>
              “{shakti.recognition || av.appreciationPhrase}”
            </div>
          </div>
        ) : null}

        {/* Embodiment — she deepens as she is felt */}
        <div style={{ padding: '28px 0 8px', borderTop: '1px solid rgba(201,150,63,0.14)', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
          {sectionLabel('Embodiment')}
          <EmbodimentPill shakti={shakti} atmo={atmo} count={count || 0} />
        </div>

        {/* Her moments */}
        <div style={{ padding: '26px 0', borderTop: '1px solid rgba(201,150,63,0.14)' }}>
          {sectionLabel('Her moments')}
          <HerMoments moments={moments} atmo={atmo} />
        </div>

        {/* Go deeper */}
        {(shakti.tattva || shakti.location || av) ? (
          <div style={{ paddingTop: 10 }}>
            <button onClick={() => setDeeper(!deeper)} style={{
              width: '100%', background: 'none', border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'center', gap: 14, minHeight: 48, padding: 0,
            }}>
              <span style={{ fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 17, letterSpacing: '0.08em', color: 'rgba(201,150,63,0.85)', whiteSpace: 'nowrap' }}>
                {deeper ? 'less' : 'go deeper'}
              </span>
              <div style={{ flex: 1, height: 1, background: 'rgba(201,150,63,0.22)' }} />
            </button>
            {deeper ? (
              <div style={{ paddingTop: 18, paddingBottom: 10, display: 'flex', flexDirection: 'column', gap: 20 }}>
                {shakti.tattva ? <DeepRow label="Tattva" value={shakti.tattva} atmo={atmo} /> : null}
                {shakti.location ? <DeepRow label="Bodily seat" value={shakti.location} atmo={atmo} /> : null}
                {av ? <DeepRow label="Her ring" value={`${av.name} — ${av.subtitle}`} atmo={atmo} /> : null}
                {av ? <DeepRow label="Form" value={av.formDescription} atmo={atmo} /> : null}
                {av ? <DeepRow label="Mental state" value={av.mentalState} atmo={atmo} /> : null}
                {av ? <DeepRow label="Chakra" value={av.chakra} atmo={atmo} /> : null}
              </div>
            ) : null}
          </div>
        ) : null}
      </div>

      {/* footer CTA */}
      <div style={{ position: 'relative', zIndex: 3, padding: '10px 26px 20px' }}>
        <button onClick={onFeelHer} style={{
          width: '100%', height: 58, border: 'none', borderRadius: 29, cursor: 'pointer',
          background: `linear-gradient(135deg, ${LR_BASE.red}, color-mix(in oklab, ${LR_BASE.red} 70%, ${atmo.accent} 30%))`,
          boxShadow: `0 4px 40px ${atmo.glow}`,
          fontFamily: LR_SERIF, fontSize: 22, letterSpacing: '0.14em', color: LR_BASE.cream,
        }}>
          I feel her
        </button>
      </div>
    </div>
  );
}

function DeepRow({ label, value, atmo }) {
  return (
    <div>
      <LrLabel size={10.5} color="rgba(242,232,217,0.42)" style={{ marginBottom: 6 }}>{label}</LrLabel>
      <div style={{ fontFamily: LR_SERIF, fontSize: 17.5, lineHeight: 1.5, color: 'rgba(242,232,217,0.78)' }}>{value}</div>
    </div>
  );
}

function BijaGlyph({ bija, atmo }) {
  const [pulse, setPulse] = React.useState(0);
  const [sounding, setSounding] = React.useState(false);
  const syllable = bija.split(' — ')[0];
  const sound = () => {
    const dur = lrPlayBija(bija);
    setPulse(p => p + 1);
    if (dur > 0) {
      setSounding(true);
      setTimeout(() => setSounding(false), dur * 1000);
    }
  };
  return (
    <button
      onClick={sound}
      style={{ background: 'none', border: 'none', cursor: 'pointer', position: 'relative', padding: '18px 30px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12 }}
      aria-label={`Bīja syllable ${syllable} — tap to hear`}
    >
      <span style={{ position: 'relative', display: 'inline-block' }}>
        {/* resonance rings while sounding */}
        {sounding ? [0, 0.5, 1].map((d, i) => (
          <span key={i} style={{
            position: 'absolute', left: '50%', top: '50%', width: 90, height: 90, marginLeft: -45, marginTop: -45,
            borderRadius: '50%', border: `1px solid ${atmo.accentSoft}`,
            animation: `lrBijaRing 3.6s ${d}s ease-out infinite`, pointerEvents: 'none',
          }} />
        )) : null}
        <span key={pulse} style={{
          position: 'relative',
          fontFamily: LR_SERIF, fontWeight: 300, fontSize: 84, lineHeight: 1,
          color: LR_BASE.gold, textShadow: sounding ? `0 0 70px ${atmo.accent}` : `0 0 40px ${atmo.glow}`,
          display: 'inline-block', transition: 'text-shadow 0.6s ease',
          animation: pulse ? 'lrBijaPulse 1.4s ease-out' : 'none',
        }}>{syllable}</span>
      </span>
      <span style={{
        fontFamily: 'ui-sans-serif, sans-serif', fontSize: 10, letterSpacing: '0.22em', textTransform: 'uppercase',
        color: sounding ? atmo.accentBright : 'rgba(242,232,217,0.4)', transition: 'color 0.4s ease',
      }}>{sounding ? 'sounding' : 'tap to sound her'}</span>
    </button>
  );
}

// ─── Recognition Moment ───────────────────────────────────────────────────────

function RecognitionScreen({ shakti, atmo, onNote, onClose }) {
  const [stage, setStage] = React.useState(0);
  const [act2Time, setAct2Time] = React.useState(null);
  const [note, setNote] = React.useState('');
  const act1Time = React.useMemo(() => new Date(), []);

  const saveNote = (v) => {
    setNote(v);
    if (onNote) onNote(v);
  };

  React.useEffect(() => {
    const timers = [
      setTimeout(() => setStage(1), 300),    // name
      setTimeout(() => setStage(2), 1100),   // phrase
      setTimeout(() => setStage(3), 2600),   // act 1
      setTimeout(() => { setAct2Time(new Date()); setStage(4); }, 4300), // act 2
      setTimeout(() => setStage(5), 5400),   // close hint
    ];
    return () => timers.forEach(clearTimeout);
  }, []);

  const av = atmo.avarana;
  const [closing, setClosing] = React.useState(false);
  const beginClose = () => { if (closing || stage < 1) return; setClosing(true); setTimeout(onClose, 620); };
  const comp = React.useMemo(() => lrComposition(shakti), [shakti.kp]);
  const R = LR_RECOG[comp.element] || LR_RECOG.earth;
  const phrase = shakti.recognition || (av && av.appreciationPhrase) || '';
  const fmt = (d, sec) => {
    let h = d.getHours() % 12; if (h === 0) h = 12;
    const m = String(d.getMinutes()).padStart(2, '0');
    const s = String(d.getSeconds()).padStart(2, '0');
    return sec ? `${h}:${m}:${s}` : `${h}:${m} ${d.getHours() < 12 ? 'AM' : 'PM'}`;
  };
  const vis = (n, dy) => ({
    opacity: stage >= n ? 1 : 0,
    transform: stage >= n ? 'translateY(0)' : `translateY(${dy == null ? 8 : dy}px)`,
    transition: 'opacity 1.4s ease, transform 1.4s ease',
  });

  return (
    <div
      data-screen-label="Recognition Moment"
      onClick={beginClose}
      style={{
        position: 'absolute', inset: 0, cursor: 'pointer',
        background: `radial-gradient(ellipse 105% 72% at ${R.focal}, ${atmo.glow}, transparent 74%), linear-gradient(${atmo.groundDeep}, #050203)`,
        fontFamily: LR_SERIF, color: LR_BASE.cream,
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        overflow: 'hidden', textAlign: 'center',
      }}
    >
      {/* her ring's geometry, responding in the manner of her element */}
      <div style={{
        position: 'absolute', left: R.fx, top: R.fy, transform: 'translate(-50%,-50%)',
        pointerEvents: 'none',
        animation: stage >= 1 ? `${R.resp} ${R.respDur}s ease-in-out ${R.respFill}` : 'none',
      }}>
        <LrSigil atmo={atmo} size={480} spin spinDir={comp.spin} opacity={0.55} />
      </div>

      {shakti.bija ? (
        <div aria-hidden="true" style={{
          position: 'absolute', left: R.fx, top: R.fy, transform: 'translate(-50%,-50%)',
          fontSize: 320, fontWeight: 300, color: atmo.accentFaint, opacity: 0.5, lineHeight: 1, pointerEvents: 'none',
          animation: stage >= 2 ? `${R.resp} ${R.respDur * 1.3}s ease-in-out infinite` : 'none',
        }}>{shakti.bija.split(' — ')[0]}</div>
      ) : null}

      <LrMotes atmo={atmo} count={R.motes} animate={true} />

      {/* ripples of recognition, moving as her element moves */}
      {Array.from({ length: R.rippleN }).map((_, i) => (
        <div key={i} style={{
          position: 'absolute', left: R.fx, top: R.fy,
          width: 10, height: 10, marginLeft: -5, marginTop: -5,
          borderRadius: '50%', border: `1px solid ${atmo.accentSoft}`,
          animation: `${R.ripple} ${R.rippleDur}s ${(i * R.rippleDur / R.rippleN).toFixed(2)}s ease-out infinite`,
          pointerEvents: 'none',
        }} />
      ))}

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 40px', position: 'relative', zIndex: 2, opacity: closing ? 0 : 1, transform: closing ? 'scale(0.84)' : 'none', transition: 'opacity 0.55s ease, transform 0.62s cubic-bezier(0.5,0,0.75,0)' }}>
        <div style={{ ...vis(1), fontSize: lrNameSize(shakti.name, 46), fontWeight: 300, letterSpacing: '0.08em', lineHeight: 1.15, textShadow: `0 0 60px ${atmo.glow}` }}>
          {shakti.name}
        </div>
        {phrase ? (
          <React.Fragment>
            <div style={{ ...vis(2), margin: '28px 0' }}>
              <LrHairline width={36} />
            </div>
            <div style={{ ...vis(2), fontStyle: 'italic', fontSize: 24, lineHeight: 1.55, color: LR_BASE.cream, maxWidth: 320, textWrap: 'pretty' }}>
              {phrase}
            </div>
          </React.Fragment>
        ) : null}
      </div>

      <div style={{ position: 'relative', zIndex: 2, paddingBottom: 44, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12, opacity: closing ? 0 : 1, transform: closing ? 'scale(0.9)' : 'none', transition: 'opacity 0.45s ease, transform 0.6s cubic-bezier(0.5,0,0.75,0)' }}>
        <LrLabel size={12} color="rgba(242,232,217,0.6)" style={vis(3, 4)}>
          she was felt here · {fmt(act1Time)}
        </LrLabel>
        <div style={{ ...vis(4, 0) }}><LrHairline width={22} /></div>
        <div style={{ ...vis(4, 4), fontStyle: 'italic', fontSize: 17, color: LR_BASE.gold, letterSpacing: '0.04em' }}>
          and she felt you back · {fmt(act2Time || act1Time, true)}
        </div>

        {/* Her note — what did you notice? Appears once reciprocity has landed. */}
        <div
          onClick={(e) => e.stopPropagation()}
          style={{
            ...vis(5, 8), width: 288, marginTop: 20, cursor: 'text',
            background: 'rgba(242,232,217,0.045)',
            border: '0.5px solid rgba(242,232,217,0.14)',
            borderRadius: 14, padding: '13px 16px',
          }}
        >
          <textarea
            value={note}
            onChange={(e) => saveNote(e.target.value)}
            placeholder="What did you notice?"
            rows={note && note.length > 40 ? 3 : 1}
            style={{
              width: '100%', border: 'none', outline: 'none', resize: 'none',
              background: 'transparent', color: 'rgba(242,232,217,0.9)',
              fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 15, lineHeight: 1.5,
              caretColor: LR_BASE.gold, letterSpacing: '0.02em',
            }}
          />
        </div>

        <LrLabel size={10.5} color="rgba(242,232,217,0.38)" style={{ ...vis(5, 0), marginTop: 16 }}>
          tap outside to close
        </LrLabel>
      </div>

      {/* collapse — the ceremony gathers into the point, handing off to the Portrait */}
      {closing ? (
        <div style={{
          position: 'absolute', left: '50%', top: '46%', width: 300, height: 300, marginLeft: -150, marginTop: -150,
          borderRadius: '50%', pointerEvents: 'none', zIndex: 10,
          background: `radial-gradient(circle, ${atmo.accentBright}, ${atmo.glow} 35%, transparent 68%)`,
          animation: 'lrCollapse 0.62s cubic-bezier(0.5,0,0.75,0) forwards',
        }} />
      ) : null}
    </div>
  );
}

Object.assign(window, { DetailScreen, RecognitionScreen });
