// living-rite-today.jsx — The Living Rite (Today).
// Each Śakti generates her own arrival. Her element selects a composition PLAN
// (block order, alignment, sigil placement, whether her name becomes the
// backdrop); her ring the geometry; her cluster/ring the hue; a per-kp mood the
// lean, scale and spin. All plans render through one centered, clip-proof
// engine — so days differ structurally, never overflow. Her name is a door.

// ─── Plans — element → structure ──────────────────────────────────────────────
// blocks: 'kicker' 'name' 'phon' 'know' 'rule' 'quality' 'prompt'

const TD_PLANS = {
  fire: {   // ascension — she rises: prompt & quality first, name the climax
    order: ['kicker', 'prompt', 'rule', 'quality', 'name', 'phon', 'know'],
    align: 'center', sigil: 'bottom', sigilScale: 1.0,
  },
  water: {  // descent — she settles: name high, prompt pools at the close
    order: ['kicker', 'name', 'phon', 'know', 'rule', 'quality', 'prompt'],
    align: 'center', sigil: 'bottomWide', sigilScale: 1.15,
  },
  air: {    // horizon — she drifts: asymmetric, sigil off one edge, a horizon line
    order: ['kicker', 'name', 'phon', 'know', 'rule', 'quality', 'prompt'],
    align: 'lean', sigil: 'side', sigilScale: 1.0, horizonLine: true,
  },
  ether: {  // veil — she pervades: her name is the vast ground; a quiet stack floats
    order: ['kicker', 'nameSmall', 'rule', 'quality', 'prompt', 'know'],
    align: 'center', sigil: 'center', sigilScale: 0.9, veilName: true,
  },
  earth: {  // foundation — she grounds: centered, a wide low sigil base
    order: ['kicker', 'name', 'phon', 'know', 'rule', 'quality', 'prompt'],
    align: 'center', sigil: 'bottomBig', sigilScale: 1.3,
  },
  light: {  // radiance — she is the point: compact name within a dominant sigil
    order: ['kicker', 'name', 'phon', 'rule', 'quality', 'prompt', 'know'],
    align: 'center', sigil: 'centerBig', sigilScale: 1.15, nameCap: 52,
  },
};

// ─── Block renderers ──────────────────────────────────────────────────────────

function TdBlock(kind, ctx) {
  const { shakti, atmo, fade, plan, nameSize, quality, prompt, onOpen } = ctx;
  const leftAlign = plan.align === 'lean' && ctx.left;
  const rightAlign = plan.align === 'lean' && !ctx.left;
  const alignItems = leftAlign ? 'flex-start' : rightAlign ? 'flex-end' : 'center';
  const textAlign = leftAlign ? 'left' : rightAlign ? 'right' : 'center';

  switch (kind) {
    case 'kicker': {
      const cl = shakti.cluster && window.CLUSTER_INFO ? window.CLUSTER_INFO[shakti.cluster] : null;
      return (
        <div key={kind} style={{ ...fade(0.25), display: 'flex', alignItems: 'center', gap: 10, marginBottom: 22, justifyContent: alignItems }}>
          {shakti.cluster ? <LrClusterDot color={atmo.accent} size={8} /> : null}
          <LrLabel size={11.5} color={atmo.accentBright} tracking="0.3em">
            {LR_ORDINALS[shakti.ring]} Āvaraṇa{cl ? ` · ${cl.label}` : ''}
          </LrLabel>
        </div>
      );
    }
    case 'name':
    case 'nameSmall': {
      const size = kind === 'nameSmall' ? 27 : nameSize;
      return (
        <button key={kind} onClick={onOpen} data-comment-anchor="today-name"
          aria-label={`${shakti.phonetic || shakti.name} — open her presence`}
          style={{
            ...fade(0.4), background: 'none', border: 'none', cursor: 'pointer', padding: '4px 2px',
            fontFamily: LR_SERIF, fontWeight: 300, fontSize: size, lineHeight: 1.06, letterSpacing: '0.05em',
            color: LR_BASE.cream, textAlign, textShadow: `0 0 55px ${atmo.glow}`, width: '100%',
            display: 'block',
          }}>{shakti.name}</button>
      );
    }
    case 'phon':
      if (!shakti.phonetic) return null;
      return <LrLabel key={kind} size={12.5} color="rgba(242,232,217,0.5)" tracking="0.26em" style={{ ...fade(0.55), marginTop: 12, width: '100%', textAlign }}>{shakti.phonetic}</LrLabel>;
    case 'know':
      return (
        <button key={kind} onClick={onOpen} style={{
          ...fade(0.7), background: 'none', border: 'none', cursor: 'pointer',
          fontFamily: LR_SERIF, fontStyle: 'italic', fontSize: 15, color: atmo.accentBright,
          opacity: 0.92, padding: '6px 4px', letterSpacing: '0.06em', marginTop: 10,
          alignSelf: alignItems,
        }}>know her&nbsp;›</button>
      );
    case 'rule':
      return <div key={kind} style={{ ...fade(0.8), margin: '24px 0', alignSelf: alignItems }}><LrHairline width={54} color={`color-mix(in oklab, ${atmo.accent} 62%, transparent)`} /></div>;
    case 'quality':
      return <div key={kind} style={{ ...fade(0.9), fontSize: 25, lineHeight: 1.3, color: atmo.accentBright, maxWidth: 330, textAlign, textWrap: 'pretty' }}>{quality}</div>;
    case 'prompt':
      return <div key={kind} style={{ ...fade(1.05), fontStyle: 'italic', fontSize: 20, lineHeight: 1.55, color: 'rgba(242,232,217,0.82)', maxWidth: 310, marginTop: 20, textAlign, textWrap: 'pretty' }}>“{prompt}”</div>;
    default:
      return null;
  }
}

// ─── Sigil placement ──────────────────────────────────────────────────────────

function TdSigil({ atmo, plan, comp, opacity, left }) {
  const s = plan.sigilScale * comp.sigilScale;
  let wrap;
  switch (plan.sigil) {
    case 'bottom':     wrap = { left: '50%', bottom: -40, transform: `translateX(-50%) scale(${s})` }; break;
    case 'bottomWide': wrap = { left: '50%', bottom: -140, transform: `translateX(-50%) scale(${s})` }; break;
    case 'bottomBig':  wrap = { left: '50%', bottom: -220, transform: `translateX(-50%) scale(${s})` }; break;
    case 'side':       wrap = { top: '40%', [left ? 'right' : 'left']: -220, transform: `translateY(-50%) scale(${s})` }; break;
    case 'centerBig':  wrap = { left: '50%', top: '46%', transform: `translate(-50%,-50%) scale(${s})` }; break;
    default:           wrap = { left: '50%', top: '46%', transform: `translate(-50%,-50%) scale(${s * 0.95})` };
  }
  const size = plan.sigil === 'bottomBig' ? 760 : plan.sigil === 'centerBig' ? 560 : 620;
  return (
    <div style={{ position: 'absolute', inset: 0, opacity, transition: 'opacity 2.4s ease 0.2s', pointerEvents: 'none' }}>
      <div style={{ position: 'absolute', ...wrap }}>
        <LrSigil atmo={atmo} size={size} spin spinDir={comp.spin} />
      </div>
      {plan.horizonLine ? (
        <div style={{ position: 'absolute', left: 0, right: 0, top: '43%', height: 1,
          background: `linear-gradient(90deg, transparent, ${atmo.accentSoft} 28%, ${atmo.accentSoft} 72%, transparent)` }} />
      ) : null}
    </div>
  );
}

// ─── Screen ───────────────────────────────────────────────────────────────────

function TodayScreen({ shakti, atmo, moon, motion, intensity, onOpenDetail, onOpenNitya, onFeelHer }) {
  const [arrived, setArrived] = React.useState(false);
  React.useEffect(() => {
    setArrived(false);
    const t = setTimeout(() => setArrived(true), 60);
    return () => clearTimeout(t);
  }, [shakti.kp]);

  const comp = React.useMemo(() => lrComposition(shakti), [shakti.kp]);
  const plan = TD_PLANS[comp.element] || TD_PLANS.earth;
  const left = !comp.flip;
  const bgAtmo = { ...atmo, _flipLeft: comp.flip };
  const baseCap = plan.nameCap || (plan.align === 'lean' ? 66 : 58);
  const nameSize = lrNameSize(shakti.name, baseCap) + [0, 2, -2, 3][comp.nameTier];
  const sigilO = arrived ? (0.62 + intensity * 0.42) : 0;

  const fade = (delay) => ({
    opacity: arrived ? 1 : 0,
    transform: arrived ? 'translateY(0)' : 'translateY(10px)',
    transition: `opacity 1.3s ease ${delay}s, transform 1.3s ease ${delay}s`,
  });

  const ctx = { shakti, atmo, fade, plan, nameSize, left,
    quality: lrQuality(shakti), prompt: lrPrompt(shakti), onOpen: onOpenDetail };

  const alignItems = plan.align === 'lean' ? (left ? 'flex-start' : 'flex-end') : 'center';

  return (
    <div data-screen-label="Today — The Living Rite" style={{
      position: 'absolute', inset: 0, background: lrBackdrop(bgAtmo),
      overflow: 'hidden', display: 'flex', flexDirection: 'column',
      fontFamily: LR_SERIF, color: LR_BASE.cream,
    }}>
      <TdSigil atmo={atmo} plan={plan} comp={comp} opacity={sigilO} left={left} />

      {/* veil: her name as the vast ground, and the door */}
      {plan.veilName ? (
        <button onClick={onOpenDetail} aria-label={`${shakti.name} — open her presence`} style={{
          position: 'absolute', inset: 0, zIndex: 1, background: 'none', border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24,
        }}>
          <span style={{
            fontFamily: LR_SERIF, fontWeight: 300, fontSize: Math.min(lrNameSize(shakti.name, 120) * 1.7, 150),
            lineHeight: 0.94, letterSpacing: '0.01em', color: atmo.accentFaint, opacity: sigilO,
            textAlign: 'center', textWrap: 'balance', wordBreak: 'break-word',
          }}>{shakti.name}</span>
        </button>
      ) : null}

      <LrMotes atmo={atmo} count={16} animate={motion} />
      <LrDepth atmo={atmo} />

      {/* celestial strip — tap to meet who presides today */}
      <div style={{ position: 'relative', zIndex: 6 }}>
        <button onClick={onOpenNitya} style={{ ...fade(0.1), width: '100%', background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12, padding: `${LR_SAFE_TOP}px 24px 0` }}>
          <LrMoonGlyph frac={moon.frac} size={18} />
          <LrLabel size={11.5} color="rgba(242,232,217,0.62)">{moon.tithiLabel} · {moon.nityaName}</LrLabel>
          <span style={{ color: atmo.accentBright, fontSize: 12, opacity: 0.7 }}>›</span>
        </button>
      </div>

      {/* center stack — always centered, cannot clip */}
      <div style={{
        flex: 1, position: 'relative', zIndex: 2, minHeight: 0,
        display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: alignItems,
        padding: plan.align === 'lean' ? '0 30px' : '0 28px',
        textAlign: plan.align === 'lean' ? (left ? 'left' : 'right') : 'center',
        pointerEvents: plan.veilName ? 'none' : 'auto',
      }}>
        <div style={{ pointerEvents: 'auto', display: 'flex', flexDirection: 'column', alignItems: alignItems, width: '100%', maxWidth: plan.align === 'lean' ? '94%' : 360 }}>
          {plan.order.map(k => TdBlock(k, ctx))}
        </div>
      </div>

      {/* foot */}
      <div style={{ position: 'relative', zIndex: 6, padding: '0 26px 22px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14, ...fade(1.25) }}>
        <button onClick={onFeelHer} data-comment-anchor="feel-her-cta" style={{
          width: '100%', height: 60, border: 'none', borderRadius: 30, cursor: 'pointer',
          background: `linear-gradient(135deg, ${LR_BASE.red}, color-mix(in oklab, ${LR_BASE.red} 66%, ${atmo.accent} 34%))`,
          boxShadow: `0 4px 48px ${atmo.glow}, 0 4px 30px rgba(139,26,42,0.5)`,
          fontFamily: LR_SERIF, fontSize: 23, letterSpacing: '0.14em', color: LR_BASE.cream,
        }}>I feel her</button>
        <LrLabel size={11} color="rgba(242,232,217,0.44)">
          {shakti.kp} of 102{shakti.bija ? ` · bīja ${shakti.bija}` : ''}
        </LrLabel>
      </div>
    </div>
  );
}

Object.assign(window, { TodayScreen });
