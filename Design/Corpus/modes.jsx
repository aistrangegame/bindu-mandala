// ─── Phase 4 · The Eight Modes of Engagement ─────────────────────────────────
// Each mode is its own atmosphere. Not a feature, a practice.

// ─── Shared helpers (Babel script scope) ──────────────────────────────────────

function petalPathM(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// A miniature Sri Yantra for embedding inside mode screens
function MiniYantra({ size = 220, intensity = 1, todayIdx = null }) {
  const cx = size/2, cy = size/2;
  const oR = size * 0.42, iR = size * 0.34, hw = size * 0.07;
  const pPath = petalPathM(oR, iR, hw);
  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}
      style={{ overflow: 'visible', display: 'block' }}>
      {/* bhupura */}
      <rect x={cx - oR*1.15} y={cy - oR*1.15} width={oR*2.3} height={oR*2.3}
        fill="none" stroke={COLORS.gold}
        strokeWidth="0.4" opacity={0.18 * intensity}/>
      {/* 16 petals */}
      {SHAKTIS.map((s, i) => {
        const isToday = todayIdx !== null && i === todayIdx;
        const col = CLUSTER_INFO[s.cluster].color;
        const op = isToday ? 0.95 : STATUS_OPACITY[s.status] * 0.7 * intensity;
        return (
          <g key={i} transform={`translate(${cx},${cy}) rotate(${i*22.5})`}>
            <path d={pPath} fill={col} opacity={op}/>
          </g>
        );
      })}
      {/* nested triangles */}
      <g transform={`translate(${cx},${cy})`} opacity={0.45 * intensity}>
        {[ {r: iR*0.85, up:false}, {r: iR*0.65, up:true},
           {r: iR*0.45, up:false}, {r: iR*0.30, up:true} ].map((t, k) => (
          <path key={k}
            d={t.up
              ? `M 0,${-t.r} L ${t.r*0.866},${t.r/2} L ${-t.r*0.866},${t.r/2} Z`
              : `M 0,${t.r} L ${t.r*0.866},${-t.r/2} L ${-t.r*0.866},${-t.r/2} Z`}
            fill="none" stroke={COLORS.gold} strokeWidth="0.4"/>
        ))}
      </g>
      {/* bindu */}
      <circle cx={cx} cy={cy} r={size*0.022} fill={COLORS.accentRed} opacity={0.9}/>
      <circle cx={cx} cy={cy} r={size*0.009} fill={COLORS.cream}/>
    </svg>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 1 — DARŚANA · BEHOLDING
// The yantra wakes to your stillness. Time stretches.
// Three depths: arriving (3s of stillness) · holding (30s) · entered (2 min)
// ═════════════════════════════════════════════════════════════════════════════

function DarsanaScreen({ depth = 'arriving' }) {
  const screenW = 390, screenH = 844;
  const darknessBg = {
    arriving: 'radial-gradient(ellipse 90% 80% at 50% 50%, #0A0608 0%, #060104 60%, #030103 100%)',
    holding:  'radial-gradient(ellipse 80% 65% at 50% 50%, #0D0608 0%, #030103 70%, #010001 100%)',
    entered:  'radial-gradient(ellipse 60% 50% at 50% 50%, #0F0708 0%, #020001 70%, #000000 100%)',
  }[depth];
  const yantraSize = {
    arriving: 280, holding: 320, entered: 360,
  }[depth];
  const intensity = { arriving: 0.85, holding: 1.0, entered: 1.2 }[depth];

  // Bījas appearing in space (holding/entered)
  const bijas = depth !== 'arriving' ? SHAKTIS.map((s, i) => {
    const angle = (i * 22.5 - 90) * Math.PI / 180;
    const r = yantraSize * 0.62;
    return {
      bija: s.bija,
      x: 195 + r * Math.cos(angle),
      y: 422 + r * Math.sin(angle),
      delay: i * 0.35,
    };
  }) : [];

  return (
    <div style={{
      width: screenW, height: screenH,
      background: darknessBg,
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={depth === 'arriving' ? 6 : depth === 'holding' ? 10 : 14}/>

      {/* Status bar fades as depth increases */}
      <div style={{ opacity: depth === 'arriving' ? 0.5 : depth === 'holding' ? 0.15 : 0 }}>
        <StatusBar/>
      </div>

      {/* Outward radiance — strong in 'entered' state */}
      {depth === 'entered' && (
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%,-50%)',
          width: 540, height: 540, borderRadius: '50%',
          background: `radial-gradient(circle, rgba(201,150,63,0.18) 0%,
            rgba(139,26,42,0.06) 35%, transparent 70%)`,
          pointerEvents: 'none',
          animation: 'darsanaRadiance 6s ease-in-out infinite',
        }}/>
      )}

      {/* The yantra */}
      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%, -50%)',
        zIndex: 2,
      }}>
        <MiniYantra size={yantraSize} intensity={intensity} todayIdx={4}/>
      </div>

      {/* Bija syllables appearing at petal positions (depth >= holding) */}
      {bijas.map((b, i) => (
        <div key={i} style={{
          position: 'absolute', left: b.x, top: b.y,
          transform: 'translate(-50%, -50%)',
          fontFamily: "'Cormorant Garamond', serif",
          fontStyle: 'italic', fontWeight: 300,
          fontSize: 13, color: 'rgba(201,150,63,0.55)',
          letterSpacing: '0.08em',
          opacity: 0,
          animation: `darsanaBijaIn 4s ease-in-out ${b.delay}s infinite`,
          textShadow: '0 0 8px rgba(201,150,63,0.5)',
          pointerEvents: 'none', zIndex: 3,
        }}>{b.bija}</div>
      ))}

      {/* Mode label — bottom, fades with depth */}
      <div style={{
        position: 'absolute', bottom: 48, left: 0, right: 0,
        textAlign: 'center',
        opacity: depth === 'arriving' ? 0.55 : depth === 'holding' ? 0.25 : 0,
        transition: 'opacity 2s ease',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 14, fontStyle: 'italic',
          color: 'rgba(201,150,63,0.7)',
          letterSpacing: '0.32em', textTransform: 'lowercase',
        }}>darśana</div>
        <div style={{
          marginTop: 8,
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
        }}>{depth === 'arriving' ? 'hold still · she wakes'
            : depth === 'holding' ? 'beholding · 30s'
            : '∞'}</div>
      </div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 2 — RECOGNITION · THE CATCH (refined)
// Now shows the today's-petal pulsing on the visible-behind mandala.
// Three states: open (waiting for tap) · caught (filled) · reciprocated (she felt you).
// ═════════════════════════════════════════════════════════════════════════════

function RecognitionScreen({ state = 'reciprocated' }) {
  const s = TODAY_SHAKTI;
  return (
    <div style={{
      width: 390, height: 844, background: '#060104',
      position: 'relative', overflow: 'hidden',
    }}>
      {/* Mandala visible behind, dimmed */}
      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%,-50%)',
        opacity: state === 'open' ? 0.5 : state === 'caught' ? 0.3 : 0.42,
        transition: 'opacity 1.5s ease',
      }}>
        <MiniYantra size={340} intensity={state === 'reciprocated' ? 1.4 : 0.8} todayIdx={4}/>
      </div>

      {/* Reciprocated state — the today's petal has registered the catch */}
      {state === 'reciprocated' && (
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%, -50%) translateY(-94px)',
          width: 60, height: 60, borderRadius: '50%',
          background: `radial-gradient(circle, rgba(201,150,63,0.55) 0%, transparent 70%)`,
          pointerEvents: 'none', zIndex: 3,
          animation: 'recogPetalGlow 3s ease-in-out infinite',
        }}/>
      )}

      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 3 }}>
        <StatusBar/>
      </div>

      {/* The catch overlay — rises from bottom */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        height: 360,
        background: `linear-gradient(to top, rgba(4,1,4,0.98) 0%, rgba(8,2,6,0.94) 65%, rgba(8,2,6,0.82) 100%)`,
        borderTop: `0.5px solid rgba(201,150,63,0.18)`,
        borderRadius: '20px 20px 0 0',
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        padding: '32px 32px 28px',
        zIndex: 2,
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 38, fontWeight: 300, color: COLORS.cream,
          letterSpacing: '0.07em', textAlign: 'center',
          lineHeight: 1.05, marginBottom: 8,
        }}>{s.name}</div>

        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontWeight: 300, fontStyle: 'italic',
          color: COLORS.gold, opacity: 0.78,
          letterSpacing: '0.12em', marginBottom: 24,
        }}>{s.bija}</div>

        {/* Catch circle */}
        <div style={{
          width: 68, height: 68, borderRadius: '50%',
          border: `1px solid rgba(201,150,63,${state === 'open' ? 0.55 : 0.75})`,
          background: state === 'open'
            ? `rgba(201,150,63,0.04)`
            : `rgba(201,150,63,0.12)`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          marginBottom: 14,
          boxShadow: state === 'open' ? 'none'
            : `0 0 24px rgba(201,150,63,0.32), inset 0 0 10px rgba(201,150,63,0.10)`,
          transition: 'all 1.2s ease',
        }}>
          {state !== 'open' && (
            <div style={{
              width: 18, height: 18, borderRadius: '50%',
              background: COLORS.gold,
              boxShadow: `0 0 12px rgba(201,150,63,0.85)`,
            }}/>
          )}
        </div>

        {/* Caption */}
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: state === 'open' ? 14 : 16,
          fontStyle: 'italic', fontWeight: 300,
          color: state === 'open'
            ? 'rgba(242,232,217,0.45)'
            : state === 'caught' ? 'rgba(242,232,217,0.7)'
            : COLORS.gold,
          letterSpacing: '0.04em',
          textAlign: 'center', marginTop: 4,
          minHeight: 24, transition: 'all 1.5s ease',
        }}>
          {state === 'open' && 'tap to register the moment'}
          {state === 'caught' && 'she is named'}
          {state === 'reciprocated' && 'and she felt you back'}
        </div>

        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.25)',
          letterSpacing: '0.18em', textTransform: 'uppercase',
          marginTop: 16,
        }}>{state === 'reciprocated' ? 'LOGGED · 2:41 PM · her 3rd today' : ''}</div>
      </div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 3 — SĀDHANA · THE KHAḌGAMĀLA
// 102 names, sequential, ring-by-ring inward.
// Sub-states: sankalpa · station · ring-transition · bindu-arrival
// ═════════════════════════════════════════════════════════════════════════════

function SadhanaScreen({ state = 'station', ringIdx = 2, posInRing = 5 }) {
  const screenW = 390, screenH = 844;

  // Sample a current shakti based on ringIdx + posInRing
  const currentShakti = (() => {
    if (ringIdx === 2) return SHAKTIS[posInRing] || SHAKTIS[5];
    if (ringIdx === 3) return RING3_SHAKTIS[posInRing] || RING3_SHAKTIS[0];
    if (ringIdx === 8) return RING8_SHAKTIS[posInRing] || RING8_SHAKTIS[0];
    return SHAKTIS[5];
  })();

  // Total progress count
  const totalRecited =
    ringIdx === 1 ? posInRing :
    ringIdx === 2 ? 28 + posInRing :
    ringIdx === 3 ? 28 + 16 + posInRing :
    ringIdx === 4 ? 28 + 16 + 8 + posInRing :
    ringIdx === 5 ? 28 + 16 + 8 + 14 + posInRing :
    ringIdx === 6 ? 28 + 16 + 8 + 14 + 10 + posInRing :
    ringIdx === 7 ? 28 + 16 + 8 + 14 + 10 + 10 + posInRing :
    ringIdx === 8 ? 28 + 16 + 8 + 14 + 10 + 10 + 12 + posInRing :
    102;
  const progressPct = (totalRecited / 102) * 100;

  return (
    <div style={{
      width: screenW, height: screenH,
      background: `radial-gradient(ellipse 80% 70% at 50% 50%,
        rgba(20,8,16,0.96) 0%, rgba(6,1,4,1) 70%)`,
      position: 'relative', overflow: 'hidden',
      fontFamily: "'Cormorant Garamond', serif",
    }}>
      <DustMotes count={8}/>
      <StatusBar/>

      {/* ═══════════ SANKALPA — intention setting ═══════════ */}
      {state === 'sankalpa' && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'center',
          padding: '0 36px',
        }}>
          <div style={{
            fontSize: 11, color: '#C9963F',
            fontFamily: '-apple-system, sans-serif',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            opacity: 0.7, marginBottom: 36,
          }}>Saṅkalpa</div>

          <div style={{
            fontSize: 30, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.cream, lineHeight: 1.4,
            letterSpacing: '0.03em', textAlign: 'center',
            marginBottom: 28, maxWidth: 320,
          }}>I begin the garland<br/>not to gain anything,<br/>but to remember<br/>what I have always been.</div>

          <div style={{ width: 40, height: 0.5, background: 'rgba(201,150,63,0.4)', margin: '0 0 28px' }}/>

          <div style={{
            fontSize: 14, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.55)',
            letterSpacing: '0.04em',
            textAlign: 'center', maxWidth: 280, lineHeight: 1.6,
            marginBottom: 56,
          }}>One hundred and two names will arrive in sequence. ~28 minutes. Sit upright. Breath low.</div>

          <button style={{
            padding: '14px 44px', borderRadius: 32,
            background: COLORS.accentRed, border: 'none',
            color: COLORS.cream, fontFamily: "'Cormorant Garamond', serif",
            fontSize: 17, fontWeight: 300, letterSpacing: '0.14em',
            cursor: 'pointer',
            boxShadow: `0 4px 28px rgba(139,26,42,0.4)`,
          }}>Begin</button>
        </div>
      )}

      {/* ═══════════ STATION — current shakti, full screen ═══════════ */}
      {state === 'station' && (
        <>
          {/* Ring identity bar */}
          <div style={{
            position: 'absolute', top: 64, left: 0, right: 0,
            textAlign: 'center', fontStyle: 'italic',
            fontSize: 12, color: 'rgba(201,150,63,0.6)',
            letterSpacing: '0.20em',
          }}>{AVARANAS[ringIdx-1].name}</div>

          {/* The current shakti — full presence */}
          <div style={{
            position: 'absolute', top: '36%', left: 0, right: 0,
            textAlign: 'center', padding: '0 28px',
            transform: 'translateY(-50%)',
          }}>
            <div style={{
              fontSize: 46, fontWeight: 300, color: COLORS.cream,
              letterSpacing: '0.06em', lineHeight: 1.05,
              marginBottom: 16,
            }}>{currentShakti.name}</div>

            <div style={{
              fontSize: 26, fontStyle: 'italic',
              color: COLORS.gold, letterSpacing: '0.14em',
              marginBottom: 24, opacity: 0.85,
            }}>{currentShakti.bija || 'hsauṁ'}</div>

            <div style={{ width: 36, height: 0.5,
              background: 'rgba(201,150,63,0.35)', margin: '0 auto 24px' }}/>

            <div style={{
              fontSize: 17, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.62)',
              lineHeight: 1.7, letterSpacing: '0.02em',
              maxWidth: 300, margin: '0 auto',
            }}>{currentShakti.quality || 'She of the field'}</div>
          </div>

          {/* Progress arc — bottom */}
          <div style={{
            position: 'absolute', bottom: 110, left: 0, right: 0,
          }}>
            {/* Ring dots */}
            <div style={{
              display: 'flex', justifyContent: 'center', gap: 14,
              marginBottom: 18,
            }}>
              {[1,2,3,4,5,6,7,8,9].map(r => {
                const isActive = r === ringIdx;
                const isPast = r < ringIdx;
                return (
                  <div key={r} style={{
                    width: isActive ? 8 : 5, height: isActive ? 8 : 5,
                    borderRadius: '50%',
                    background: isActive ? COLORS.gold
                      : isPast ? 'rgba(201,150,63,0.55)'
                      : 'rgba(201,150,63,0.15)',
                    boxShadow: isActive ? '0 0 10px 2px rgba(201,150,63,0.7)' : 'none',
                  }}/>
                );
              })}
            </div>

            <div style={{
              width: 240, height: 1, margin: '0 auto',
              background: 'rgba(201,150,63,0.15)',
              borderRadius: 0.5, position: 'relative',
            }}>
              <div style={{
                position: 'absolute', top: 0, left: 0,
                width: `${progressPct}%`, height: 1,
                background: COLORS.gold,
                boxShadow: '0 0 4px rgba(201,150,63,0.6)',
              }}/>
            </div>

            <div style={{
              textAlign: 'center', marginTop: 14,
              fontSize: 10, fontFamily: '-apple-system, sans-serif',
              color: 'rgba(242,232,217,0.35)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
            }}>{totalRecited} of 102 · Ring {ringIdx}</div>
          </div>
        </>
      )}

      {/* ═══════════ RING TRANSITION — moving inward ═══════════ */}
      {state === 'transition' && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'center',
          padding: '0 36px',
        }}>
          <div style={{
            fontSize: 11, color: 'rgba(201,150,63,0.7)',
            fontFamily: '-apple-system, sans-serif',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            marginBottom: 36,
          }}>Descending</div>

          <div style={{
            fontSize: 16, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.45)',
            letterSpacing: '0.04em', marginBottom: 14,
          }}>You leave the Sixteen-Petal Lotus.</div>

          <div style={{
            fontSize: 30, fontWeight: 300, color: COLORS.cream,
            letterSpacing: '0.05em', lineHeight: 1.2,
            marginBottom: 12, textAlign: 'center',
          }}>You enter</div>

          <div style={{
            fontSize: 36, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.gold, letterSpacing: '0.05em',
            textShadow: '0 0 18px rgba(201,150,63,0.5)',
            marginBottom: 36, textAlign: 'center',
          }}>Sarvasaṅkṣobhaṇa</div>

          <div style={{
            fontSize: 15, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.55)',
            letterSpacing: '0.04em', maxWidth: 280,
            textAlign: 'center', lineHeight: 1.7,
          }}>The eight bodiless desires —<br/>where longing arrives without a body.</div>

          <div style={{
            marginTop: 56,
            fontSize: 9, fontFamily: '-apple-system, sans-serif',
            color: 'rgba(242,232,217,0.25)',
            letterSpacing: '0.30em', textTransform: 'uppercase',
          }}>tap to continue</div>
        </div>
      )}

      {/* ═══════════ VISARJANA — release & return ═══════════ */}
      {state === 'visarjana' && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'center',
          padding: '0 36px',
        }}>
          <div style={{
            fontSize: 11, color: 'rgba(201,150,63,0.7)',
            fontFamily: '-apple-system, sans-serif',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            marginBottom: 36,
          }}>Visarjana · the release</div>

          {/* The yantra ascending back outward — small but glowing */}
          <div style={{
            position: 'relative', marginBottom: 44,
            animation: 'sadhanaBinduBreath 5s ease-in-out infinite',
          }}>
            <MiniYantra size={140} intensity={1.4}/>
          </div>

          <div style={{
            fontSize: 26, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.cream, lineHeight: 1.4,
            letterSpacing: '0.04em', textAlign: 'center',
            marginBottom: 24, maxWidth: 320,
          }}>What I have received,<br/>I release.</div>

          <div style={{ width: 36, height: 0.5,
            background: 'rgba(201,150,63,0.4)', marginBottom: 28 }}/>

          <div style={{
            fontSize: 16, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.55)',
            letterSpacing: '0.02em', lineHeight: 1.7,
            textAlign: 'center', maxWidth: 300,
            marginBottom: 56,
          }}>The garland is offered back<br/>to the one who wove it.<br/>The 102 return to the One.</div>

          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(242,232,217,0.30)',
            letterSpacing: '0.30em', textTransform: 'uppercase',
          }}>tap to close · she remains</div>
        </div>
      )}

      {/* ═══════════ BINDU — the culmination ═══════════ */}
      {state === 'bindu' && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          background: 'radial-gradient(ellipse 50% 45% at 50% 50%, rgba(139,26,42,0.25) 0%, transparent 60%)',
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'center',
        }}>
          <div style={{
            width: 100, height: 100, borderRadius: '50%',
            background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.5) 50%, transparent 100%)`,
            position: 'relative',
            marginBottom: 64,
            boxShadow: `0 0 70px 20px rgba(139,26,42,0.45)`,
            animation: 'sadhanaBinduBreath 5s ease-in-out infinite',
          }}>
            <div style={{
              position: 'absolute', top: '50%', left: '50%',
              transform: 'translate(-50%, -50%)',
              width: 28, height: 28, borderRadius: '50%',
              background: COLORS.cream,
              boxShadow: `0 0 28px ${COLORS.cream}, 0 0 56px rgba(242,232,217,0.5)`,
            }}/>
          </div>

          <div style={{
            fontSize: 30, fontWeight: 300, color: COLORS.cream,
            letterSpacing: '0.06em', marginBottom: 12,
          }}>Lalitā</div>

          <div style={{
            fontSize: 22, fontStyle: 'italic', color: COLORS.gold,
            letterSpacing: '0.12em', opacity: 0.85, marginBottom: 36,
          }}>aiṁ klīṁ sauḥ</div>

          <div style={{ width: 36, height: 0.5,
            background: 'rgba(201,150,63,0.4)', marginBottom: 32 }}/>

          <div style={{
            fontSize: 18, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.6)',
            letterSpacing: '0.02em', lineHeight: 1.7,
            textAlign: 'center', maxWidth: 280,
          }}>One hundred and two have been said.<br/>What remains is what was always there.</div>
        </div>
      )}

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 4 — SMṚTI · THE CONSTELLATION OF MEMORY
// Every recognition ever made, as light on the yantra.
// Sub-states: full constellation · zoomed cluster · time-lapse moment
// ═════════════════════════════════════════════════════════════════════════════

// Generate a synthetic recognition history for visual demonstration
function genConstellation() {
  const recogs = [];
  SHAKTIS.forEach((s, i) => {
    const count = s.status === 'embodied' ? 28 + Math.floor(Math.random()*18)
                : s.status === 'active'   ? 12 + Math.floor(Math.random()*8)
                : s.status === 'exploring'? 4  + Math.floor(Math.random()*4)
                : Math.floor(Math.random()*2);
    for (let j = 0; j < count; j++) {
      // jitter around the petal position
      const angle = (i * 22.5 - 90) * Math.PI / 180;
      const baseR = 150 + Math.random() * 30;
      const jitter = (Math.random() - 0.5) * 14;
      const aJitter = (Math.random() - 0.5) * 0.12;
      const x = 195 + (baseR + jitter) * Math.cos(angle + aJitter);
      const y = 422 + (baseR + jitter) * Math.sin(angle + aJitter);
      recogs.push({
        shaktiIdx: i, x, y,
        size: 1 + Math.random() * 1.8,
        opacity: 0.4 + Math.random() * 0.5,
        recent: Math.random() < 0.06,
        color: CLUSTER_INFO[s.cluster].color,
      });
    }
  });
  return recogs;
}

function SmritiScreen({ state = 'full' }) {
  // Memoize so it doesn't regenerate per state change in canvas
  const recogs = React.useMemo(() => genConstellation(), []);
  const totalRecogs = recogs.length;

  return (
    <div style={{
      width: 390, height: 844,
      background: 'radial-gradient(ellipse 80% 70% at 50% 50%, #050309 0%, #010103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      {/* Title bar */}
      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0,
        textAlign: 'center',
        fontFamily: "'Cormorant Garamond', serif",
      }}>
        <div style={{
          fontSize: 11, color: '#C9963F',
          fontFamily: '-apple-system, sans-serif',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7,
        }}>Smṛti · the Memory</div>
        <div style={{
          marginTop: 8,
          fontSize: 22, fontWeight: 300, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.78)',
          letterSpacing: '0.03em',
        }}>{state === 'cluster' ? 'Sparśākarṣiṇī · 23 catches'
            : state === 'timelapse' ? '264 days · last spring · now'
            : 'where she has been most alive'}</div>
      </div>

      {/* Yantra outline — very faint, the canvas */}
      <div style={{
        position: 'absolute', top: 142, left: '50%',
        transform: 'translateX(-50%)',
        opacity: state === 'cluster' ? 0.15 : 0.25,
        transition: 'opacity 1s ease',
      }}>
        <MiniYantra size={380} intensity={0.4}/>
      </div>

      {/* The constellation of recognitions */}
      <svg width="390" height="540"
        viewBox="0 0 390 540"
        style={{
          position: 'absolute', top: 142, left: 0,
          pointerEvents: 'none',
        }}>
        {recogs.map((r, i) => {
          const visible = state === 'cluster' ? r.shaktiIdx === 4 : true;
          const sz = state === 'cluster' && r.shaktiIdx === 4 ? r.size * 2.3 : r.size;
          const op = visible ? r.opacity : 0.04;
          return (
            <circle key={i}
              cx={r.x - (390/2 - 195)}
              cy={r.y - 282}
              r={sz}
              fill={r.color}
              opacity={op}
              className={r.recent ? 'smriti-twinkle' : ''}
              style={{
                filter: r.recent ? `drop-shadow(0 0 4px ${r.color})` : 'none',
              }}/>
          );
        })}
      </svg>

      {/* Bindu in center */}
      <div style={{
        position: 'absolute', top: 422, left: 195,
        transform: 'translate(-50%, -50%)',
        width: 14, height: 14, borderRadius: '50%',
        background: `radial-gradient(circle, ${COLORS.accentRed} 0%, transparent 70%)`,
      }}>
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%, -50%)',
          width: 5, height: 5, borderRadius: '50%',
          background: COLORS.cream,
        }}/>
      </div>

      {/* Stats bottom */}
      <div style={{
        position: 'absolute', bottom: 86, left: 0, right: 0,
        textAlign: 'center', padding: '0 30px',
      }}>
        {state === 'full' && (
          <>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 17, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.62)',
              letterSpacing: '0.02em', lineHeight: 1.6,
              marginBottom: 20,
            }}>{totalRecogs} recognitions · 218 days · 12 of 16 known</div>
            <div style={{ display: 'flex', justifyContent: 'center', gap: 18 }}>
              {['All time','This year','Month','Week'].map((label, i) => (
                <div key={i} style={{
                  fontFamily: '-apple-system, sans-serif',
                  fontSize: 10, color: i === 0 ? COLORS.gold : 'rgba(242,232,217,0.30)',
                  letterSpacing: '0.18em', textTransform: 'uppercase',
                  paddingBottom: 6,
                  borderBottom: i === 0 ? '0.5px solid #C9963F' : 'none',
                }}>{label}</div>
              ))}
            </div>
          </>
        )}

        {state === 'cluster' && (
          <>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 16, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.6)',
              lineHeight: 1.6, marginBottom: 12,
            }}>last caught — today, 9:14 AM<br/>"morning light on hands"</div>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.30)',
              letterSpacing: '0.18em', textTransform: 'uppercase',
            }}>tap any star · open her log</div>
          </>
        )}

        {state === 'timelapse' && (
          <>
            <div style={{
              width: 240, height: 1, margin: '0 auto 12px',
              background: 'rgba(201,150,63,0.18)',
              position: 'relative',
            }}>
              <div style={{
                position: 'absolute', top: 0, left: 0,
                width: '72%', height: 1,
                background: COLORS.gold,
                boxShadow: '0 0 4px rgba(201,150,63,0.6)',
              }}/>
              <div style={{
                position: 'absolute', left: '72%', top: -4,
                width: 9, height: 9, borderRadius: '50%',
                background: COLORS.gold, transform: 'translateX(-50%)',
                boxShadow: '0 0 8px rgba(201,150,63,0.85)',
              }}/>
            </div>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.30)',
              letterSpacing: '0.18em', textTransform: 'uppercase',
            }}>day 191 of 264 · watching herself emerge</div>
          </>
        )}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 5 — MAUNA · THE SILENCE (refined)
// Multi-orbital field of names + breath-synced Bindu + timed captions
// Captions arrive at 7s, 14s, 21s, 28s — successively deeper
// ═════════════════════════════════════════════════════════════════════════════

function MaunaScreen({ depth = 'd14' }) {
  const cx = 195, cy = 422;
  const r2 = 158, r3 = 110;

  const captions = {
    d7:  'All of her. Here. Always.',
    d14: 'She has not gone anywhere.',
    d21: 'You have not gone anywhere.',
    d28: '',
  };
  const captionOpacity = depth === 'd28' ? 0 : 0.7;

  return (
    <div style={{ width: 390, height: 844, background: '#020001',
      position: 'relative', overflow: 'hidden' }}>

      <div style={{
        position: 'absolute', inset: 0,
        background: 'radial-gradient(ellipse 60% 50% at 50% 50%, transparent 0%, rgba(0,0,0,0.85) 100%)',
        pointerEvents: 'none',
      }}/>

      {/* Outer 16 names — Ring 2 orbit */}
      {SHAKTIS.map((s, i) => {
        const angle = (i * 22.5 - 90) * Math.PI / 180;
        const x = cx + r2 * Math.cos(angle);
        const y = cy + r2 * Math.sin(angle);
        const rot = i * 22.5;
        return (
          <div key={s.id} className="mauna-name" style={{
            position: 'absolute', left: x, top: y,
            transform: `translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 11, fontStyle: 'italic',
            color: `rgba(242,232,217,${0.14 + (depth === 'd28' ? 0.04 : 0)})`,
            letterSpacing: '0.18em', whiteSpace: 'nowrap',
            opacity: 0, animationDelay: `${0.18 + i * 0.20}s`,
            textShadow: '0 0 8px rgba(201,150,63,0.16)',
          }}>{s.short}</div>
        );
      })}

      {/* Inner 8 names — Ring 3 orbit */}
      {RING3_SHAKTIS.map((s, i) => {
        const angle = (i * 45 - 90) * Math.PI / 180;
        const x = cx + r3 * Math.cos(angle);
        const y = cy + r3 * Math.sin(angle);
        const rot = i * 45;
        return (
          <div key={s.id} className="mauna-name" style={{
            position: 'absolute', left: x, top: y,
            transform: `translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 10, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.10)',
            letterSpacing: '0.14em', whiteSpace: 'nowrap',
            opacity: 0, animationDelay: `${0.4 + i * 0.22}s`,
          }}>{s.short}</div>
        );
      })}

      {/* Faint orbits */}
      <svg width="390" height="844" style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}>
        <circle cx={cx} cy={cy} r="200" fill="none" stroke="rgba(201,150,63,0.04)" strokeWidth="0.5"/>
        <circle cx={cx} cy={cy} r="92" fill="none" stroke="rgba(201,150,63,0.04)" strokeWidth="0.4"/>
      </svg>

      {/* Bindu */}
      <div style={{
        position: 'absolute', top: cy, left: cx,
        transform: 'translate(-50%, -50%)',
      }}>
        <div className="mauna-bindu" style={{
          width: 84, height: 84, borderRadius: '50%',
          background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.65) 55%, transparent 100%)`,
          position: 'relative',
        }}>
          <div style={{
            position: 'absolute', top: '50%', left: '50%',
            transform: 'translate(-50%, -50%)',
            width: 22, height: 22, borderRadius: '50%',
            background: COLORS.cream,
            boxShadow: `0 0 24px ${COLORS.cream}, 0 0 48px rgba(242,232,217,0.45)`,
          }}/>
        </div>
      </div>

      {/* Caption — rotates through depths */}
      <div className="mauna-caption" style={{
        position: 'absolute', top: cy + 230, left: 0, right: 0,
        textAlign: 'center', opacity: 0,
        fontFamily: "'Cormorant Garamond', serif",
        fontSize: 18, fontStyle: 'italic',
        color: `rgba(242,232,217,${captionOpacity})`,
        letterSpacing: '0.06em',
      }}>{captions[depth]}</div>

      {/* Depth indicator — very subtle */}
      <div style={{
        position: 'absolute', bottom: 56, left: 0, right: 0,
        textAlign: 'center',
        fontFamily: '-apple-system, sans-serif',
        fontSize: 9, color: 'rgba(242,232,217,0.14)',
        letterSpacing: '0.32em', textTransform: 'uppercase',
      }}>
        {depth === 'd7'  ? '7 seconds in' :
         depth === 'd14' ? '14 seconds in' :
         depth === 'd21' ? '21 seconds in' :
         '∞'}
      </div>

      <HomeIndicator light={true}/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 6 — SVAPNA · THE DREAM
// Morning. Who walked through last night?
// Sub-states: question · tap-to-mark · resolved
// ═════════════════════════════════════════════════════════════════════════════

function SvapnaScreen({ state = 'question' }) {
  const [recording, setRecording] = React.useState(state === 'voice-active');

  return (
    <div style={{ width: 390, height: 844,
      background: 'linear-gradient(180deg, #1A1018 0%, #0A0A18 50%, #050810 100%)',
      position: 'relative', overflow: 'hidden' }}>

      {/* Pre-dawn light at top */}
      <div style={{
        position: 'absolute', top: 0, left: 0, right: 0, height: 200,
        background: 'radial-gradient(ellipse 80% 100% at 50% 0%, rgba(232,180,140,0.20) 0%, transparent 70%)',
        pointerEvents: 'none',
      }}/>

      <DustMotes count={12}/>
      <StatusBar/>

      {/* ═══════════ Question state ═══════════ */}
      {state === 'question' && (
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, bottom: 0,
          display: 'flex', flexDirection: 'column',
          alignItems: 'center', justifyContent: 'center',
          padding: '0 36px',
        }}>
          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(232,180,140,0.55)',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            marginBottom: 42,
          }}>Svapna · before the day</div>

          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 34, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.cream, lineHeight: 1.3,
            letterSpacing: '0.02em', textAlign: 'center',
            marginBottom: 52, maxWidth: 320,
          }}>Who walked through<br/>last night?</div>

          <div style={{ width: 40, height: 0.5, background: 'rgba(232,180,140,0.4)', marginBottom: 48 }}/>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 18, alignItems: 'center' }}>
            <button style={{
              width: 240, padding: '14px 24px', borderRadius: 28,
              background: 'rgba(232,180,140,0.10)',
              border: '0.5px solid rgba(232,180,140,0.5)',
              color: COLORS.cream,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 16, fontStyle: 'italic',
              letterSpacing: '0.08em', cursor: 'pointer',
            }}>I felt someone</button>
            <button style={{
              width: 240, padding: '14px 24px', borderRadius: 28,
              background: 'transparent',
              border: '0.5px solid rgba(232,180,140,0.25)',
              color: 'rgba(242,232,217,0.55)',
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 16, fontStyle: 'italic',
              letterSpacing: '0.08em', cursor: 'pointer',
            }}>The night was still</button>
          </div>
        </div>
      )}

      {/* ═══════════ Voice / text recording state ═══════════ */}
      {(state === 'voice' || state === 'voice-active') && (
        <>
          <div style={{
            position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
          }}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(232,180,140,0.55)',
              letterSpacing: '0.32em', textTransform: 'uppercase',
              marginBottom: 10,
            }}>Svapna · recording</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 20, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.75)',
              letterSpacing: '0.03em', maxWidth: 320, margin: '0 auto',
              lineHeight: 1.5,
            }}>tell the dream while it is still here</div>
          </div>

          {/* Voice waveform — visualizer */}
          <div style={{
            position: 'absolute', top: 230, left: 0, right: 0,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            gap: 4, height: 120,
          }}>
            {Array.from({length: 42}).map((_, i) => {
              const isActive = state === 'voice-active';
              const h = isActive
                ? 12 + Math.abs(Math.sin(i * 0.7) * Math.cos(i * 0.3)) * 80
                : 8;
              return (
                <div key={i} style={{
                  width: 3, height: h,
                  background: isActive
                    ? 'linear-gradient(180deg, rgba(232,180,140,0.95) 0%, rgba(232,180,140,0.5) 100%)'
                    : 'rgba(232,180,140,0.18)',
                  borderRadius: 1.5,
                  animation: isActive ? `svapnaWaveform ${0.8 + (i % 5) * 0.18}s ease-in-out infinite` : 'none',
                  animationDelay: `${i * 0.05}s`,
                  transition: 'background 0.4s ease',
                }}/>
              );
            })}
          </div>

          {/* Mic button & timer */}
          <div style={{
            position: 'absolute', top: 388, left: 0, right: 0,
            textAlign: 'center',
          }}>
            <div style={{
              width: 76, height: 76, borderRadius: '50%',
              margin: '0 auto 18px',
              background: state === 'voice-active'
                ? 'radial-gradient(circle, rgba(232,180,140,0.4) 0%, rgba(232,180,140,0.10) 70%)'
                : 'rgba(232,180,140,0.08)',
              border: `0.5px solid rgba(232,180,140,${state === 'voice-active' ? 0.85 : 0.4})`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
              boxShadow: state === 'voice-active'
                ? '0 0 28px 8px rgba(232,180,140,0.35)'
                : 'none',
              animation: state === 'voice-active' ? 'svapnaMicPulse 2.2s ease-in-out infinite' : 'none',
            }}>
              <svg width="22" height="32" viewBox="0 0 22 32" fill="none">
                <rect x="7" y="3" width="8" height="15" rx="4"
                  fill={state === 'voice-active' ? 'rgba(242,232,217,0.95)' : 'rgba(232,180,140,0.8)'}/>
                <path d="M 3 16 Q 11 22 19 16" stroke={state === 'voice-active' ? 'rgba(242,232,217,0.85)' : 'rgba(232,180,140,0.7)'} strokeWidth="0.8" fill="none"/>
                <line x1="11" y1="22" x2="11" y2="28" stroke={state === 'voice-active' ? 'rgba(242,232,217,0.85)' : 'rgba(232,180,140,0.7)'} strokeWidth="0.8"/>
              </svg>
            </div>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 11, color: 'rgba(232,180,140,0.65)',
              letterSpacing: '0.22em',
            }}>{state === 'voice-active' ? '00:42 · recording' : 'tap to speak'}</div>
          </div>

          {/* Text option below */}
          <div style={{
            position: 'absolute', bottom: 140, left: 30, right: 30,
          }}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 9, color: 'rgba(242,232,217,0.30)',
              letterSpacing: '0.30em', textTransform: 'uppercase',
              textAlign: 'center', marginBottom: 16,
            }}>or write</div>
            <div style={{
              padding: '14px 18px',
              background: 'rgba(232,180,140,0.04)',
              border: '0.5px solid rgba(232,180,140,0.18)',
              borderRadius: 12,
              minHeight: 80,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 14, fontStyle: 'italic',
              color: state === 'voice-active' ? 'rgba(242,232,217,0.62)' : 'rgba(242,232,217,0.25)',
              lineHeight: 1.65, letterSpacing: '0.01em',
            }}>{state === 'voice-active'
              ? '"There was a long room. Someone called my name from inside it — the voice was familiar but I could not place it..."'
              : 'a few words about what arrived'}</div>
          </div>
        </>
      )}

      {/* ═══════════ Tap-to-mark state ═══════════ */}
      {state === 'tap' && (
        <>
          <div style={{
            position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
          }}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(232,180,140,0.55)',
              letterSpacing: '0.32em', textTransform: 'uppercase',
              marginBottom: 10,
            }}>Svapna</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 22, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.78)',
              letterSpacing: '0.04em', maxWidth: 320, margin: '0 auto',
            }}>Tap who walked through</div>
          </div>

          {/* Faint yantra with two petals marked */}
          <div style={{
            position: 'absolute', top: '52%', left: '50%',
            transform: 'translate(-50%, -50%)', opacity: 0.55,
          }}>
            <MiniYantra size={320} intensity={0.7}/>
          </div>

          {/* Marked petals — Ātmā and Smṛti */}
          <div style={{
            position: 'absolute', top: 280, left: 75,
            width: 30, height: 30, borderRadius: '50%',
            background: 'radial-gradient(circle, rgba(232,180,140,0.7) 0%, transparent 70%)',
            pointerEvents: 'none',
            animation: 'svapnaMarkPulse 3s ease-in-out infinite',
          }}/>
          <div style={{
            position: 'absolute', top: 535, left: 88,
            width: 30, height: 30, borderRadius: '50%',
            background: 'radial-gradient(circle, rgba(232,180,140,0.7) 0%, transparent 70%)',
            pointerEvents: 'none',
            animation: 'svapnaMarkPulse 3s ease-in-out 1.5s infinite',
          }}/>

          {/* Brief dream note */}
          <div style={{
            position: 'absolute', bottom: 130, left: 36, right: 36,
            padding: '16px 18px',
            background: 'rgba(232,180,140,0.06)',
            border: '0.5px solid rgba(232,180,140,0.18)',
            borderRadius: 12,
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 14, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.62)',
            lineHeight: 1.65, letterSpacing: '0.01em',
          }}>"There was a long room.<br/>Someone called my name from inside it."</div>

          <div style={{
            position: 'absolute', bottom: 80, left: 0, right: 0, textAlign: 'center',
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(242,232,217,0.30)',
            letterSpacing: '0.22em', textTransform: 'uppercase',
          }}>2 marked · hold to add a note</div>
        </>
      )}

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 7 — PŪJĀ · THE EVENING OFFERING
// At day's end. The day's catches witnessed. Offered. Released.
// Sub-states: gathering · offering · released
// ═════════════════════════════════════════════════════════════════════════════

function PujaScreen({ state = 'offering' }) {
  // Today's catches — 5 recognitions across the day
  const todayCatches = [
    { idx: 4,  time: '7:14 AM', note: 'morning light on hands' },
    { idx: 1,  time: '9:42 AM', note: 'an idea I didn\'t make' },
    { idx: 4,  time: '11:30 AM', note: '' },
    { idx: 9,  time: '2:08 PM', note: 'gratitude for the door opening' },
    { idx: 13, time: '8:55 PM', note: 'returning to myself' },
  ];
  const cx = 195, cy = 400;

  return (
    <div style={{ width: 390, height: 844,
      background: 'linear-gradient(180deg, #0A0508 0%, #060104 50%, #030103 100%)',
      position: 'relative', overflow: 'hidden' }}>

      {/* Sunset glow at edges */}
      <div style={{
        position: 'absolute', top: 0, left: 0, right: 0, height: '40%',
        background: 'radial-gradient(ellipse 80% 100% at 50% 100%, rgba(199,90,80,0.12) 0%, transparent 70%)',
        pointerEvents: 'none',
      }}/>

      <DustMotes count={7}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(199,143,90,0.7)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 10,
        }}>Pūjā · the offering</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontWeight: 300, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.78)',
          letterSpacing: '0.04em',
        }}>{state === 'gathering' ? 'today\'s catches'
            : state === 'offering' ? 'five recognitions, this day'
            : 'received'}</div>
      </div>

      {/* The day's catches as luminous points around the yantra */}
      <div style={{
        position: 'absolute', top: 142, left: '50%',
        transform: 'translateX(-50%)',
        opacity: state === 'released' ? 0.25 : 0.5,
        transition: 'opacity 2s ease',
      }}>
        <MiniYantra size={300} intensity={0.7}/>
      </div>

      {/* Today's catches as glowing dots */}
      <svg width="390" height="500"
        style={{ position: 'absolute', top: 142, left: 0, pointerEvents: 'none' }}>
        {todayCatches.map((c, i) => {
          const s = SHAKTIS[c.idx];
          const angle = (c.idx * 22.5 - 90) * Math.PI / 180;
          const r = 120 + (i % 2) * 8;
          const x = 195 + r * Math.cos(angle) - (390/2 - 195);
          const y = 150 + r * Math.sin(angle);
          const dx = (Math.random() - 0.5) * 6;
          const dy = (Math.random() - 0.5) * 6;
          return (
            <g key={i}>
              <circle cx={x + dx} cy={y + dy} r="9"
                fill={CLUSTER_INFO[s.cluster].color}
                opacity={state === 'released' ? 0 : 0.15}
                style={{ filter: 'blur(5px)', transition: 'opacity 2s ease' }}/>
              <circle cx={x + dx} cy={y + dy} r="3"
                fill={CLUSTER_INFO[s.cluster].color}
                opacity={state === 'released' ? 0 : 0.85}
                className="puja-catch"
                style={{ animationDelay: `${i * 0.4}s`, transition: 'opacity 2s ease' }}/>
            </g>
          );
        })}
      </svg>

      {/* Bindu — absorbs the catches when released */}
      <div style={{
        position: 'absolute', top: 290, left: 195,
        transform: 'translate(-50%, -50%)',
        width: state === 'released' ? 48 : 16,
        height: state === 'released' ? 48 : 16,
        borderRadius: '50%',
        background: `radial-gradient(circle, ${COLORS.accentRed} 0%, rgba(139,26,42,0.55) 55%, transparent 100%)`,
        transition: 'all 2.5s ease',
        boxShadow: state === 'released' ? '0 0 40px 12px rgba(139,26,42,0.45)' : 'none',
      }}>
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%, -50%)',
          width: state === 'released' ? 16 : 5,
          height: state === 'released' ? 16 : 5,
          borderRadius: '50%',
          background: COLORS.cream,
          transition: 'all 2.5s ease',
        }}/>
      </div>

      {/* List of today's catches — only in offering state */}
      {state === 'offering' && (
        <div style={{
          position: 'absolute', bottom: 168, left: 28, right: 28,
        }}>
          {todayCatches.map((c, i) => {
            const s = SHAKTIS[c.idx];
            return (
              <div key={i} style={{
                display: 'flex', alignItems: 'center', gap: 12,
                padding: '7px 0',
                borderBottom: i < 4 ? '0.5px solid rgba(201,150,63,0.07)' : 'none',
              }}>
                <div style={{
                  width: 5, height: 5, borderRadius: '50%',
                  background: CLUSTER_INFO[s.cluster].color,
                  opacity: 0.85,
                }}/>
                <div style={{
                  fontSize: 10, fontFamily: '-apple-system, sans-serif',
                  color: 'rgba(242,232,217,0.32)',
                  letterSpacing: '0.12em', width: 64,
                }}>{c.time}</div>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 13, fontStyle: c.note ? 'normal' : 'italic',
                  color: 'rgba(242,232,217,0.7)',
                  flex: 1,
                }}>{s.name}</div>
              </div>
            );
          })}
        </div>
      )}

      {/* Released state — final text */}
      {state === 'released' && (
        <div style={{
          position: 'absolute', bottom: 160, left: 36, right: 36, textAlign: 'center',
        }}>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 22, fontStyle: 'italic', fontWeight: 300,
            color: 'rgba(242,232,217,0.7)',
            letterSpacing: '0.02em', lineHeight: 1.6,
            marginBottom: 24,
          }}>The day is received.<br/>Tomorrow opens again.</div>
          <div style={{ width: 32, height: 0.5,
            background: 'rgba(201,150,63,0.3)', margin: '0 auto 22px' }}/>
          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(242,232,217,0.28)',
            letterSpacing: '0.30em', textTransform: 'uppercase',
          }}>sleep with the field</div>
        </div>
      )}

      {/* Offer button — offering state */}
      {state === 'offering' && (
        <button style={{
          position: 'absolute', bottom: 76, left: '50%',
          transform: 'translateX(-50%)',
          padding: '12px 36px', borderRadius: 28,
          background: 'rgba(199,143,90,0.15)',
          border: '0.5px solid rgba(199,143,90,0.4)',
          color: COLORS.cream,
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 15, fontStyle: 'italic',
          letterSpacing: '0.10em', cursor: 'pointer',
        }}>offer the day</button>
      )}

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// MODE 8 — SAṄGHA · THE ASSEMBLY
// The field is all you. There are no strangers in it.
// Two layers: INNER — the 102 shaktis as your living community.
//             OUTER — the people you love as carriers of specific shaktis.
// You are not alone — you are in the company of one hundred and two
// living forces, and the loved ones who carry them into your life.
// ═════════════════════════════════════════════════════════════════════════════

// Beloved-people composition — each one a carrier of specific shaktis
const BELOVED = [
  { name: 'Ram',     carries: [13, 0],  hue: '#7A5A9A',  // Ātmā · Buddhi
    note: 'who returns me to myself' },
  { name: 'Ashrey',  carries: [12, 11], hue: '#4A7A5A',  // Nāma · Bīja
    note: 'who names what is forming' },
  { name: 'Gaia',    carries: [1],     hue: '#D4A017',   // Ahaṅ
    note: 'who anchors the I-sense' },
  { name: 'Mother',  carries: [10, 9], hue: '#C4725A',   // Dhairya · Citta
    note: 'the steadying continuous one' },
  { name: 'Self',    carries: [13, 14, 15], hue: '#8C7BAA', // Ātmā · Amṛta · Śarīra
    note: 'the witness already here' },
];

function SanghaScreen({ state = 'inner' }) {
  const cx = 195, cy = 410;

  // ─── INNER LAYER — all 102 visible as the living assembly ──────────────
  // For the inner state we render Ring 2 fully named, Rings 3, 7, 8
  // visible as their own positioned shaktis. The convocation.
  const InnerAssembly = () => (
    <>
      {/* The full yantra at higher intensity — they are alive */}
      <div style={{
        position: 'absolute', top: 142, left: '50%',
        transform: 'translateX(-50%)', opacity: 0.65,
      }}>
        <MiniYantra size={340} intensity={1.2} todayIdx={4}/>
      </div>

      {/* Ring 2 — the 16 names orbiting at known radius, italic and breathing */}
      {SHAKTIS.map((s, i) => {
        const angle = (i * 22.5 - 90) * Math.PI / 180;
        const r = 192;
        const x = cx + r * Math.cos(angle);
        const y = cy + r * Math.sin(angle);
        const rot = i * 22.5;
        return (
          <div key={s.id} style={{
            position: 'absolute', left: x, top: y,
            transform: `translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 10, fontStyle: 'italic',
            color: `rgba(242,232,217,${0.42 + STATUS_OPACITY[s.status]*0.35})`,
            letterSpacing: '0.10em', whiteSpace: 'nowrap',
            textShadow: `0 0 6px ${CLUSTER_INFO[s.cluster].color}40`,
            animation: `sanghaNameBreathe ${5 + (i % 3)}s ease-in-out infinite`,
            animationDelay: `${i * 0.18}s`,
          }}>{s.short}</div>
        );
      })}

      {/* Ring 3 — the 8 Anaṅgas, slightly inward */}
      {RING3_SHAKTIS.map((s, i) => {
        const angle = (i * 45 - 90) * Math.PI / 180;
        const r = 122;
        const x = cx + r * Math.cos(angle);
        const y = cy + r * Math.sin(angle);
        const rot = i * 45;
        return (
          <div key={s.id} style={{
            position: 'absolute', left: x, top: y,
            transform: `translate(-50%,-50%) rotate(${rot}deg)`,
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 9, fontStyle: 'italic',
            color: 'rgba(201,150,63,0.55)',
            letterSpacing: '0.10em', whiteSpace: 'nowrap',
            animation: `sanghaNameBreathe ${7 + (i % 2)}s ease-in-out infinite`,
            animationDelay: `${i * 0.22}s`,
          }}>{s.short}</div>
        );
      })}

      {/* Caption block — bottom */}
      <div style={{
        position: 'absolute', bottom: 78, left: 0, right: 0, textAlign: 'center',
        padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 19, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.6,
          marginBottom: 18,
        }}>One hundred and two living forces.<br/>This is your assembly.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>you walk with her · she walks with you</div>
      </div>
    </>
  );

  // ─── OUTER LAYER — loved ones as carriers, around the yantra ───────────
  const OuterCarriers = () => (
    <>
      {/* Faint yantra */}
      <div style={{
        position: 'absolute', top: 152, left: '50%',
        transform: 'translateX(-50%)', opacity: 0.42,
      }}>
        <MiniYantra size={300} intensity={0.7}/>
      </div>

      {/* People as luminous nodes around the yantra */}
      {BELOVED.map((person, i) => {
        const angle = (i / BELOVED.length) * Math.PI * 2 - Math.PI / 2;
        const r = 192;
        const x = cx + r * Math.cos(angle);
        const y = cy + r * Math.sin(angle);
        return (
          <React.Fragment key={person.name}>
            {/* Connection lines from person to their shaktis on the yantra */}
            {person.carries.map((shaktiIdx, k) => {
              const sAngle = (shaktiIdx * 22.5 - 90) * Math.PI / 180;
              const sR = 116;
              const sx = cx + sR * Math.cos(sAngle);
              const sy = cy + sR * Math.sin(sAngle);
              return (
                <svg key={k} width="390" height="844"
                  style={{ position: 'absolute', top: 0, left: 0, pointerEvents: 'none' }}>
                  <line x1={x} y1={y} x2={sx} y2={sy}
                    stroke={person.hue} strokeWidth="0.5"
                    opacity="0.42" strokeDasharray="2 4"/>
                </svg>
              );
            })}
            {/* The person node */}
            <div style={{
              position: 'absolute', left: x, top: y,
              transform: 'translate(-50%,-50%)',
              textAlign: 'center', zIndex: 3,
            }}>
              <div style={{
                width: 16, height: 16, borderRadius: '50%',
                background: `radial-gradient(circle, ${person.hue} 0%, ${person.hue}88 70%, transparent 100%)`,
                margin: '0 auto 6px',
                boxShadow: `0 0 14px 3px ${person.hue}66`,
                animation: 'sanghaNodeBreathe 4s ease-in-out infinite',
                animationDelay: `${i * 0.4}s`,
              }}/>
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 14, fontStyle: 'italic', fontWeight: 300,
                color: COLORS.cream,
                letterSpacing: '0.04em',
              }}>{person.name}</div>
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 10, fontStyle: 'italic',
                color: 'rgba(242,232,217,0.40)',
                letterSpacing: '0.02em', lineHeight: 1.4,
                marginTop: 2, maxWidth: 110,
              }}>{person.note}</div>
            </div>
          </React.Fragment>
        );
      })}

      {/* Caption */}
      <div style={{
        position: 'absolute', bottom: 78, left: 0, right: 0, textAlign: 'center',
        padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 19, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.6,
          marginBottom: 18,
        }}>The people you love<br/>are her wearing human faces.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>tap a name · see which shaktis she carries</div>
      </div>
    </>
  );

  // ─── PERSON-DETAIL — tap a loved one, see their shaktis revealed ────────
  const PersonDetail = () => {
    const person = BELOVED[0]; // Ram for the demo
    return (
      <>
        <div style={{
          position: 'absolute', top: 152, left: '50%',
          transform: 'translateX(-50%)', opacity: 0.45,
        }}>
          <MiniYantra size={320} intensity={0.7}/>
        </div>

        {/* Their shaktis brighten on the yantra */}
        {person.carries.map((shaktiIdx, k) => {
          const sAngle = (shaktiIdx * 22.5 - 90) * Math.PI / 180;
          const r = 130;
          const sx = cx + r * Math.cos(sAngle);
          const sy = cy + r * Math.sin(sAngle);
          return (
            <div key={k} style={{
              position: 'absolute', left: sx, top: sy,
              transform: 'translate(-50%,-50%)',
              width: 32, height: 32, borderRadius: '50%',
              background: `radial-gradient(circle, ${person.hue}aa 0%, transparent 70%)`,
              animation: 'sanghaNodeBreathe 3.5s ease-in-out infinite',
              boxShadow: `0 0 22px 6px ${person.hue}66`,
              pointerEvents: 'none',
            }}/>
          );
        })}

        {/* Person banner */}
        <div style={{
          position: 'absolute', top: 488, left: 0, right: 0, textAlign: 'center',
        }}>
          <div style={{
            width: 22, height: 22, borderRadius: '50%',
            background: `radial-gradient(circle, ${person.hue} 0%, ${person.hue}88 60%, transparent 100%)`,
            boxShadow: `0 0 18px 4px ${person.hue}88`,
            margin: '0 auto 14px',
          }}/>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 36, fontWeight: 300, fontStyle: 'italic',
            color: COLORS.cream, letterSpacing: '0.05em', marginBottom: 10,
          }}>{person.name}</div>
          <div style={{
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 16, fontStyle: 'italic',
            color: 'rgba(242,232,217,0.55)', marginBottom: 28,
            letterSpacing: '0.02em',
          }}>{person.note}</div>

          <div style={{ width: 36, height: 0.5,
            background: 'rgba(201,150,63,0.3)', margin: '0 auto 22px' }}/>

          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10, color: 'rgba(201,150,63,0.55)',
            letterSpacing: '0.32em', textTransform: 'uppercase',
            marginBottom: 14,
          }}>carries</div>
          <div style={{
            display: 'flex', justifyContent: 'center', gap: 22, marginBottom: 22,
          }}>
            {person.carries.map((idx, k) => (
              <div key={k} style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 18, fontStyle: 'italic', fontWeight: 300,
                color: COLORS.gold, letterSpacing: '0.04em',
              }}>{SHAKTIS[idx].name}</div>
            ))}
          </div>
          <div style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 9, color: 'rgba(242,232,217,0.28)',
            letterSpacing: '0.30em', textTransform: 'uppercase',
          }}>this is how she enters through him</div>
        </div>
      </>
    );
  };

  return (
    <div style={{ width: 390, height: 844,
      background: 'radial-gradient(ellipse 70% 60% at 50% 50%, #060306 0%, #010103 100%)',
      position: 'relative', overflow: 'hidden' }}>

      <StatusBar/>

      {/* Title bar */}
      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(180,160,200,0.6)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 8,
        }}>Saṅgha · the assembly</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 13, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.45)',
          letterSpacing: '0.20em',
        }}>{state === 'inner' ? 'the inner sangha · 102 forces'
            : state === 'outer' ? 'the outer sangha · loved ones'
            : 'how she enters through him'}</div>
      </div>

      {state === 'inner' && <InnerAssembly/>}
      {state === 'outer' && <OuterCarriers/>}
      {state === 'person' && <PersonDetail/>}

      <HomeIndicator light={true}/>
    </div>
  );
}

// ─── Export ──────────────────────────────────────────────────────────────────
Object.assign(window, {
  DarsanaScreen, RecognitionScreen, SadhanaScreen,
  SmritiScreen, MaunaScreen, SvapnaScreen,
  PujaScreen, SanghaScreen, MiniYantra,
});
