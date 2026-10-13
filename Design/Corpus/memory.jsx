// ─── Phase 6 · The Memory Layer ───────────────────────────────────────────────
// Every recognition leaves a luminous trace. Over time, the yantra becomes
// a portrait of your consciousness. The instrument starts to mirror you.

// ─── Local helpers ────────────────────────────────────────────────────────────

function pPath(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// Synthetic practitioner — recognition history per petal.
// Real version reads from on-device log + Airtable shakti map.
const PRACTITIONER_HISTORY = SHAKTIS.map((s, i) => {
  const seedMul = s.status === 'embodied' ? 1.0 : s.status === 'active' ? 0.55
                : s.status === 'exploring' ? 0.22 : 0.04;
  const total = Math.floor(180 * seedMul + Math.random() * 24);
  const firstDayAgo = Math.floor(120 + Math.random() * 180);
  const lastDayAgo  = Math.floor(Math.random() * (s.status === 'embodied' ? 3 : s.status === 'active' ? 7 : 30));
  const peakMonth = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][Math.floor(Math.random()*12)];
  return {
    idx: i, name: s.name, short: s.short, status: s.status, cluster: s.cluster,
    color: CLUSTER_INFO[s.cluster].color,
    total, firstDayAgo, lastDayAgo, peakMonth,
    intensity: Math.min(1, total / 80),
  };
});

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 1 — THE PORTRAIT MANDALA
// The home yantra, but lit by YOUR memory. Each petal's brightness is your
// recognition density with her. Some blazing. Some still dark.
// This is the spiritual fingerprint. Your face in the instrument.
// ═════════════════════════════════════════════════════════════════════════════

function PortraitMandalaScreen() {
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 432;
  const oR = 180, iR = 110, hw = 34;
  const petalPath = pPath(oR, iR, hw);
  const labelR = 148;

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 70% 60% at 50% 50%, #060306 0%, #020001 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={9}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Portrait Mandala</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.03em',
        }}>your face in the instrument</div>
      </div>

      {/* The yantra — petals lit by recognition density */}
      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* Background nested triangles — faint */}
        <g transform={`translate(${cx},${cy})`} opacity="0.20">
          {[ {r: 90, up:false}, {r: 70, up:true},
             {r: 50, up:false}, {r: 32, up:true} ].map((t, k) => (
            <path key={k}
              d={t.up
                ? `M 0,${-t.r} L ${t.r*0.866},${t.r/2} L ${-t.r*0.866},${t.r/2} Z`
                : `M 0,${t.r} L ${t.r*0.866},${-t.r/2} L ${-t.r*0.866},${-t.r/2} Z`}
              fill="none" stroke={COLORS.gold} strokeWidth="0.4"/>
          ))}
        </g>

        {/* The 16 petals — intensity-driven */}
        {PRACTITIONER_HISTORY.map((h, i) => {
          const angle = i * 22.5;
          // Brightness layered: blur glow + main fill, both modulated by intensity
          const glowR = 14 * h.intensity;
          return (
            <g key={i}>
              {/* Glow halo */}
              <g transform={`translate(${cx},${cy}) rotate(${angle})`}
                style={{ pointerEvents: 'none' }}>
                <path d={petalPath} fill={h.color}
                  opacity={0.10 + h.intensity * 0.45}
                  style={{ filter: `blur(${4 + h.intensity * 4}px)` }}/>
              </g>
              {/* Main petal */}
              <g transform={`translate(${cx},${cy}) rotate(${angle})`}>
                <path d={petalPath} fill={h.color}
                  opacity={0.18 + h.intensity * 0.78}
                  className={`portrait-petal-${h.status}`}
                  style={{ animationDelay: `${(i * 0.16).toFixed(2)}s` }}/>
              </g>
              {/* Recognition count — small italic in the petal */}
              {(() => {
                const la = (angle - 90) * Math.PI / 180;
                const lx = cx + labelR * Math.cos(la);
                const ly = cy + labelR * Math.sin(la);
                return (
                  <text x={lx} y={ly + 3}
                    textAnchor="middle"
                    fontFamily="'Cormorant Garamond', serif"
                    fontStyle="italic"
                    fontSize="11"
                    fill={h.intensity > 0.4 ? COLORS.cream : 'rgba(242,232,217,0.30)'}
                    style={{ pointerEvents: 'none' }}>
                    {h.total}
                  </text>
                );
              })()}
            </g>
          );
        })}

        {/* Bindu */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="12" fill={COLORS.accentRed} opacity="0.85"/>
          <circle r="4" fill={COLORS.cream}/>
        </g>
      </svg>

      {/* Bottom — your portrait summary */}
      <div style={{
        position: 'absolute', bottom: 96, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 19, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 14,
        }}>1,418 recognitions across 264 days.<br/>Five embodied. Three nearly so.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>tap any petal · open her biography</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 2 — THE PETAL BIOGRAPHY
// Tap a petal in the portrait. Open her full story with you.
// First catch · last catch · total · peak month · longest gap · notes archive.
// ═════════════════════════════════════════════════════════════════════════════

function PetalBiographyScreen({ idx = 4 }) {
  const s = SHAKTIS[idx];
  const h = PRACTITIONER_HISTORY[idx];
  const color = CLUSTER_INFO[s.cluster].color;
  const [cr, cg, cb] = [
    parseInt(color.slice(1,3),16),
    parseInt(color.slice(3,5),16),
    parseInt(color.slice(5,7),16),
  ];

  // Sample recognition notes
  const notes = [
    { date: 'Today, 9:14 AM',     text: 'morning light on hands' },
    { date: 'Yesterday, 6:48 PM', text: 'in the kitchen — the warmth of the cup' },
    { date: 'May 22, 11:30 PM',   text: '' },
    { date: 'May 19, 2:14 PM',    text: 'her, in the way the air moved across my arm' },
    { date: 'May 17, 8:41 PM',    text: '' },
    { date: 'May 14, 2:33 PM',    text: 'in the garden — extraordinary' },
  ];

  return (
    <div style={{
      width: 390, height: 844,
      background: `linear-gradient(180deg, rgba(${cr},${cg},${cb},0.08) 0%, #060104 50%, #050103 100%)`,
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        display: 'flex', alignItems: 'center', padding: '6px 22px 8px',
        color: COLORS.gold, fontSize: 13, gap: 6, cursor: 'pointer', zIndex: 2,
      }}>
        <span style={{ fontSize: 18, lineHeight: 1 }}>‹</span>
        <span style={{ letterSpacing: '0.06em' }}>Portrait</span>
      </div>

      {/* Hero block — her, your span */}
      <div style={{
        padding: '8px 28px 22px',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 8,
        }}>her biography with you</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 36, fontWeight: 300, color: COLORS.cream,
          letterSpacing: '0.06em', lineHeight: 1.05, marginBottom: 6,
        }}>{s.name}</div>
        <div style={{
          fontSize: 11, color: 'rgba(242,232,217,0.38)',
          letterSpacing: '0.18em', textTransform: 'uppercase',
          marginBottom: 12,
        }}>{s.phonetic}</div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 10, height: 10, borderRadius: '50%',
            background: color, boxShadow: `0 0 8px ${color}`,
          }}/>
          <span style={{
            fontFamily: '-apple-system, sans-serif', fontSize: 10,
            color: 'rgba(242,232,217,0.5)',
            letterSpacing: '0.18em', textTransform: 'uppercase',
          }}>{CLUSTER_INFO[s.cluster].label}</span>
          <div style={{
            marginLeft: 'auto',
            padding: '3px 12px', borderRadius: 12,
            border: `1px solid ${color}`,
            fontSize: 10, color: color,
            letterSpacing: '0.14em', textTransform: 'uppercase',
          }}>{h.status}</div>
        </div>
      </div>

      {/* Stat grid */}
      <div style={{
        padding: '20px 28px 22px',
        display: 'grid', gridTemplateColumns: '1fr 1fr',
        rowGap: 22, columnGap: 18,
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        {[
          { label: 'total catches',  value: h.total, isNum: true },
          { label: 'first met',      value: 'Year 2 · 2024' },
          { label: 'most recent',    value: h.lastDayAgo === 0 ? 'today' : `${h.lastDayAgo}d ago` },
          { label: 'peak month',     value: h.peakMonth + ' Y4' },
          { label: 'longest gap',    value: '41 days · in Y3' },
          { label: 'days walked',    value: '1,621 lifetime' },
        ].map((stat, i) => (
          <div key={i}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 9, color: 'rgba(242,232,217,0.32)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
              marginBottom: 6,
            }}>{stat.label}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: stat.isNum ? 28 : 20,
              fontStyle: stat.isNum ? 'normal' : 'italic',
              fontWeight: 300,
              color: COLORS.cream,
              letterSpacing: '0.02em', lineHeight: 1,
            }}>{stat.value}</div>
          </div>
        ))}
      </div>

      {/* Notes archive */}
      <div style={{
        padding: '18px 28px 0', flex: 1, overflow: 'hidden',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif', fontSize: 9,
          color: 'rgba(201,150,63,0.55)',
          letterSpacing: '0.30em', textTransform: 'uppercase',
          marginBottom: 16,
        }}>moments she was here</div>

        {notes.map((n, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'flex-start', gap: 14, padding: '10px 0',
            borderBottom: i < notes.length - 1 ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
          }}>
            <div style={{
              width: 5, height: 5, borderRadius: '50%',
              background: color, marginTop: 6, flexShrink: 0, opacity: 0.7,
            }}/>
            <div style={{ flex: 1 }}>
              <div style={{
                fontFamily: '-apple-system, sans-serif',
                fontSize: 11, color: 'rgba(242,232,217,0.40)',
                letterSpacing: '0.06em', marginBottom: 3,
              }}>{n.date}</div>
              {n.text && (
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 14, fontStyle: 'italic',
                  color: 'rgba(242,232,217,0.65)',
                  lineHeight: 1.5,
                }}>{n.text}</div>
              )}
            </div>
          </div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 3 — THE THRESHOLD TIMELINE
// Moments of crossing. When she moved from mapped → exploring → active →
// embodied. Each crossing is a sacred event, rendered with the date and
// the act that crossed her over.
// ═════════════════════════════════════════════════════════════════════════════

const THRESHOLDS = [
  { date: 'Feb 14',  shakti: 'Ātmākarṣiṇī',     color: '#7A5A9A',
    from: 'exploring', to: 'active',
    note: 'sat with her at dawn for the first time. she stayed.' },
  { date: 'Mar 03',  shakti: 'Sparśākarṣiṇī',   color: '#C4725A',
    from: 'mapped',    to: 'exploring',
    note: 'felt her in the way the cup warmed my palms.' },
  { date: 'Mar 28',  shakti: 'Cittākarṣiṇī',    color: '#2A7A7A',
    from: 'active',    to: 'embodied',
    note: 'three weeks of catching her daily. she is now a habit of mind.' },
  { date: 'Apr 14',  shakti: 'Sparśākarṣiṇī',   color: '#C4725A',
    from: 'exploring', to: 'active',
    note: '17 catches in 10 days. she has become weather, not event.' },
  { date: 'May 02',  shakti: 'Dhairyākarṣiṇī',  color: '#4A7A5A',
    from: 'mapped',    to: 'exploring',
    note: 'noticed her standing under criticism without flinching.' },
  { date: 'May 19',  shakti: 'Ātmākarṣiṇī',     color: '#7A5A9A',
    from: 'active',    to: 'embodied',
    note: 'she does not leave anymore.' },
];

function ThresholdTimelineScreen() {
  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #060104 0%, #040103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        padding: '12px 22px 18px',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Threshold Timeline</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 22, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.78)',
          letterSpacing: '0.03em',
        }}>moments of crossing</div>
      </div>

      <div style={{
        flex: 1, padding: '8px 22px',
        position: 'relative',
        overflow: 'hidden',
      }}>
        {/* Spine line */}
        <div style={{
          position: 'absolute', top: 8, bottom: 16, left: 38,
          width: 0.5, background: 'rgba(201,150,63,0.18)',
        }}/>

        {THRESHOLDS.map((th, i) => (
          <div key={i} style={{
            display: 'flex', gap: 18, padding: '14px 0',
            position: 'relative',
          }}>
            {/* Date */}
            <div style={{
              width: 28, flexShrink: 0,
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.40)',
              letterSpacing: '0.14em', textTransform: 'uppercase',
              textAlign: 'right', paddingTop: 6,
            }}>{th.date}</div>

            {/* Node */}
            <div style={{
              width: 14, flexShrink: 0,
              position: 'relative', paddingTop: 6,
            }}>
              <div style={{
                width: 12, height: 12, borderRadius: '50%',
                background: `radial-gradient(circle, ${th.color} 0%, ${th.color}88 70%, transparent 100%)`,
                boxShadow: `0 0 10px 2px ${th.color}88`,
                position: 'absolute', left: 1, top: 6,
              }}>
                <div style={{
                  position: 'absolute', top: '50%', left: '50%',
                  transform: 'translate(-50%, -50%)',
                  width: 4, height: 4, borderRadius: '50%',
                  background: COLORS.cream,
                }}/>
              </div>
            </div>

            {/* Content */}
            <div style={{ flex: 1, paddingTop: 0 }}>
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 18, fontStyle: 'italic',
                color: COLORS.cream,
                letterSpacing: '0.02em',
                marginBottom: 4,
              }}>{th.shakti}</div>
              <div style={{
                fontFamily: '-apple-system, sans-serif',
                fontSize: 9,
                color: th.color,
                letterSpacing: '0.16em', textTransform: 'uppercase',
                marginBottom: 8,
              }}>
                <span style={{ opacity: 0.55 }}>{th.from}</span>
                <span style={{ margin: '0 6px', opacity: 0.5 }}>→</span>
                <span>{th.to}</span>
              </div>
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 14, fontStyle: 'italic', fontWeight: 300,
                color: 'rgba(242,232,217,0.62)',
                letterSpacing: '0.01em', lineHeight: 1.55,
              }}>{th.note}</div>
            </div>
          </div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 4 — THE CLUSTER GARDEN
// Five gardens, one per cluster. How thoroughly has each cluster bloomed
// in you? Each cluster's shaktis as petals, sized by your relationship density.
// ═════════════════════════════════════════════════════════════════════════════

function ClusterGardenScreen() {
  const clusters = Object.entries(CLUSTER_INFO);

  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #060104 0%, #050103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        padding: '14px 22px 22px',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Cluster Garden</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.75)',
          letterSpacing: '0.03em',
        }}>how each lineage has bloomed in you</div>
      </div>

      <div style={{
        padding: '14px 22px',
        display: 'flex', flexDirection: 'column', gap: 10,
      }}>
        {clusters.map(([key, info], ci) => {
          const clusterShaktis = PRACTITIONER_HISTORY.filter(h => h.cluster === key);
          const totalRecogs = clusterShaktis.reduce((a, h) => a + h.total, 0);
          const avgIntensity = clusterShaktis.length === 0
            ? 0
            : clusterShaktis.reduce((a, h) => a + h.intensity, 0) / clusterShaktis.length;

          return (
            <div key={key} style={{
              padding: '14px 16px 14px 14px',
              background: `linear-gradient(90deg, ${info.color}10 0%, transparent 100%)`,
              border: `0.5px solid ${info.color}28`,
              borderRadius: 10,
              display: 'flex', alignItems: 'center', gap: 16,
            }}>
              {/* Mini-mandala fragment for this cluster */}
              <svg width="64" height="64" viewBox="0 0 64 64"
                style={{ flexShrink: 0 }}>
                <g transform="translate(32,32)">
                  {clusterShaktis.map((h, i) => {
                    const angle = (i / clusterShaktis.length) * 360 - 90;
                    return (
                      <g key={i} transform={`rotate(${angle})`}>
                        <path d="M 0,-10 C 4,-22 -4,-22 0,-10 Z"
                          fill={info.color}
                          opacity={0.25 + h.intensity * 0.7}/>
                      </g>
                    );
                  })}
                  <circle r="2.5" fill={COLORS.accentRed} opacity="0.85"/>
                  <circle r="1" fill={COLORS.cream}/>
                </g>
              </svg>

              {/* Info */}
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 17, fontStyle: 'italic',
                  color: COLORS.cream,
                  letterSpacing: '0.02em',
                  marginBottom: 3,
                }}>{info.label}</div>
                <div style={{
                  fontFamily: '-apple-system, sans-serif',
                  fontSize: 9.5, color: 'rgba(242,232,217,0.36)',
                  letterSpacing: '0.16em',
                  marginBottom: 8,
                }}>{clusterShaktis.length} shaktis · {totalRecogs} catches</div>

                {/* Bloom meter */}
                <div style={{
                  width: '100%', height: 2, borderRadius: 1,
                  background: 'rgba(242,232,217,0.06)',
                  position: 'relative',
                }}>
                  <div style={{
                    position: 'absolute', top: 0, left: 0, height: '100%',
                    width: `${avgIntensity * 100}%`,
                    background: info.color, borderRadius: 1,
                    boxShadow: `0 0 6px ${info.color}`,
                  }}/>
                </div>
              </div>

              {/* Intensity number */}
              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 22, fontStyle: 'italic',
                color: info.color,
                opacity: 0.85, textAlign: 'right',
                flexShrink: 0,
              }}>{Math.round(avgIntensity * 100)}<span style={{
                fontSize: 11, opacity: 0.55, letterSpacing: '0.1em',
              }}>%</span></div>
            </div>
          );
        })}
      </div>

      {/* Footer */}
      <div style={{
        position: 'absolute', bottom: 92, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.02em', lineHeight: 1.6,
          marginBottom: 12,
        }}>each cluster is a lineage in you.<br/>some have bloomed. others are still seed.</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 5 — THE DENSITY ATLAS
// Month by month, the shape of your practice. Recognition density per day
// over the past year, rendered as a calendar heat-map of golden light.
// ═════════════════════════════════════════════════════════════════════════════

function DensityAtlasScreen({ mode = 'current' }) {
  // mode: 'current' = 9 months × 31 days (the trailing year)
  //       'lifetime' = 5 years × 12 months (the whole arc, compressed)

  const isLifetime = mode === 'lifetime';

  const months = ['Sep','Oct','Nov','Dec','Jan','Feb','Mar','Apr','May'];
  const yearLabels = ['2022','2023','2024','2025','2026'];
  const monthHeaders = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

  const currentGrid = React.useMemo(() => {
    const out = [];
    for (let m = 0; m < months.length; m++) {
      const row = [];
      for (let d = 0; d < 31; d++) {
        const seasonal = Math.sin((m / months.length) * Math.PI + 0.5) * 0.4;
        const weekly = Math.sin((d / 7) * Math.PI * 2) * 0.1;
        const rand = Math.random() * 0.4 - 0.1;
        const v = Math.max(0, Math.min(1, 0.35 + seasonal + weekly + rand));
        row.push(v);
      }
      out.push(row);
    }
    return out;
  }, []);

  const lifetimeGrid = React.useMemo(() => {
    // 5 years × 12 months, intensity growing over years
    const out = [];
    for (let y = 0; y < 5; y++) {
      const yearBase = 0.25 + y * 0.12;
      const row = [];
      for (let m = 0; m < 12; m++) {
        const seasonal = Math.sin((m / 12) * 2 * Math.PI + 1.2) * 0.25;
        const rand = Math.random() * 0.3 - 0.1;
        const v = Math.max(0, Math.min(1, yearBase + seasonal + rand));
        row.push(v);
      }
      out.push(row);
    }
    return out;
  }, []);

  const grid = isLifetime ? lifetimeGrid : currentGrid;
  const rowLabels = isLifetime ? yearLabels : months;
  const colHeaders = isLifetime ? monthHeaders : null;

  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #060104 0%, #040103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        padding: '14px 22px 16px',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Density Atlas</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.75)',
          letterSpacing: '0.03em',
        }}>{isLifetime
          ? 'the shape of all your years'
          : 'the shape of your practice'}</div>
      </div>

      {/* View toggle */}
      <div style={{
        display: 'flex', justifyContent: 'center', gap: 24,
        padding: '14px 0 10px',
      }}>
        {[
          { v: 'current',  label: 'trailing year' },
          { v: 'lifetime', label: 'lifetime' },
        ].map(opt => (
          <div key={opt.v} style={{
            fontFamily: '-apple-system, sans-serif',
            fontSize: 10,
            color: opt.v === mode ? COLORS.gold : 'rgba(242,232,217,0.30)',
            letterSpacing: '0.20em', textTransform: 'uppercase',
            paddingBottom: 5,
            borderBottom: opt.v === mode ? '0.5px solid #C9963F' : 'none',
          }}>{opt.label}</div>
        ))}
      </div>

      {/* Column headers — only for lifetime mode */}
      {colHeaders && (
        <div style={{
          padding: '6px 22px 4px',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <div style={{ width: 36, flexShrink: 0 }}/>
          <div style={{ flex: 1, display: 'flex', gap: 4 }}>
            {colHeaders.map((m, i) => (
              <div key={i} style={{
                flex: 1, textAlign: 'center',
                fontFamily: '-apple-system, sans-serif',
                fontSize: 8, color: 'rgba(242,232,217,0.28)',
                letterSpacing: '0.14em', textTransform: 'uppercase',
              }}>{m}</div>
            ))}
          </div>
        </div>
      )}

      {/* Grid */}
      <div style={{
        padding: '6px 22px 16px',
        display: 'flex', flexDirection: 'column',
        gap: isLifetime ? 14 : 8,
      }}>
        {grid.map((row, ri) => (
          <div key={ri} style={{
            display: 'flex', alignItems: 'center', gap: 10,
          }}>
            <div style={{
              width: 36, flexShrink: 0,
              fontFamily: '-apple-system, sans-serif',
              fontSize: isLifetime ? 11 : 10,
              color: isLifetime && ri === grid.length - 1
                ? COLORS.gold
                : 'rgba(242,232,217,0.42)',
              letterSpacing: '0.14em',
              textTransform: isLifetime ? 'none' : 'uppercase',
              textAlign: 'right',
              fontStyle: isLifetime ? 'italic' : 'normal',
            }}>{rowLabels[ri]}</div>
            <div style={{
              flex: 1, display: 'flex',
              gap: isLifetime ? 4 : 2,
            }}>
              {row.map((v, ci) => (
                <div key={ci} style={{
                  flex: 1,
                  height: isLifetime ? 24 : 16,
                  borderRadius: 1,
                  background: v < 0.1
                    ? 'rgba(201,150,63,0.04)'
                    : `rgba(201,150,63,${0.10 + v * 0.85})`,
                  boxShadow: v > 0.65 ? `0 0 4px rgba(201,150,63,${v * 0.8})` : 'none',
                }}/>
              ))}
            </div>
          </div>
        ))}
      </div>

      {/* Legend */}
      <div style={{
        position: 'absolute', bottom: isLifetime ? 178 : 200, left: 0, right: 0,
        display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 8,
      }}>
        <span style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9, color: 'rgba(242,232,217,0.32)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>quiet</span>
        <div style={{ display: 'flex', gap: 2 }}>
          {[0.05, 0.20, 0.40, 0.60, 0.85].map((v, i) => (
            <div key={i} style={{
              width: 12, height: 8,
              background: `rgba(201,150,63,${0.10 + v * 0.85})`,
              boxShadow: v > 0.6 ? `0 0 3px rgba(201,150,63,${v * 0.8})` : 'none',
            }}/>
          ))}
        </div>
        <span style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9, color: 'rgba(242,232,217,0.32)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>dense</span>
      </div>

      <div style={{
        position: 'absolute', bottom: 96, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.65)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 10,
          whiteSpace: 'pre-line',
        }}>{isLifetime
          ? 'five years walked.\nthe rhythm has deepened.'
          : 'your rhythm has texture.\nread it like a season.'}</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.28)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>{isLifetime ? 'tap any month · zoom in' : 'tap any day · see its catches'}</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 6 — FIRST WORD · LAST WORD
// For each shakti you have met: the day she first arrived, and the day
// she was last present. The span of your relationship rendered as a line.
// ═════════════════════════════════════════════════════════════════════════════

function FirstLastScreen() {
  // Sort by first-day-ago descending (oldest relationships first)
  const sorted = [...PRACTITIONER_HISTORY]
    .filter(h => h.total > 0)
    .sort((a, b) => b.firstDayAgo - a.firstDayAgo);

  const maxDays = Math.max(...sorted.map(h => h.firstDayAgo));

  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #060104 0%, #040103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        padding: '14px 22px 16px',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>First Word · Last Word</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.75)',
          letterSpacing: '0.03em',
        }}>the span of each relationship</div>
      </div>

      {/* Time axis labels */}
      <div style={{
        display: 'flex', justifyContent: 'space-between',
        padding: '8px 120px 4px 110px',
        fontFamily: '-apple-system, sans-serif',
        fontSize: 9, color: 'rgba(242,232,217,0.32)',
        letterSpacing: '0.18em', textTransform: 'uppercase',
      }}>
        <span>first met</span>
        <span>today</span>
      </div>

      <div style={{
        padding: '4px 22px 16px',
        display: 'flex', flexDirection: 'column', gap: 7,
      }}>
        {sorted.map((h, i) => {
          // Bar starts at first-day-ago and runs to last-day-ago (== more recent / shorter)
          const startPct = ((maxDays - h.firstDayAgo) / maxDays) * 100;
          const endPct   = ((maxDays - h.lastDayAgo) / maxDays) * 100;
          const widthPct = endPct - startPct;

          return (
            <div key={i} style={{
              display: 'flex', alignItems: 'center', gap: 10,
            }}>
              {/* Name label */}
              <div style={{
                width: 84, flexShrink: 0,
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 11, fontStyle: 'italic',
                color: 'rgba(242,232,217,0.75)',
                letterSpacing: '0.02em',
                textAlign: 'right',
              }}>{h.short}</div>

              {/* The span */}
              <div style={{
                flex: 1, height: 16, position: 'relative',
                background: 'rgba(242,232,217,0.025)',
                borderRadius: 1,
              }}>
                {/* Span line */}
                <div style={{
                  position: 'absolute', top: '50%', left: `${startPct}%`,
                  width: `${widthPct}%`, height: 1,
                  background: h.color,
                  opacity: 0.6,
                  transform: 'translateY(-50%)',
                  borderRadius: 0.5,
                }}/>
                {/* Start dot */}
                <div style={{
                  position: 'absolute', top: '50%', left: `calc(${startPct}% - 3px)`,
                  width: 6, height: 6, borderRadius: '50%',
                  background: h.color, opacity: 0.85,
                  transform: 'translateY(-50%)',
                  boxShadow: `0 0 4px ${h.color}`,
                }}/>
                {/* End dot — brighter if recent */}
                <div style={{
                  position: 'absolute', top: '50%', left: `calc(${endPct}% - 3px)`,
                  width: 6, height: 6, borderRadius: '50%',
                  background: h.color, opacity: h.lastDayAgo < 7 ? 1 : 0.45,
                  transform: 'translateY(-50%)',
                  boxShadow: h.lastDayAgo < 7 ? `0 0 8px ${h.color}` : 'none',
                }}/>
              </div>

              {/* Total */}
              <div style={{
                width: 32, flexShrink: 0,
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 12, fontStyle: 'italic',
                color: 'rgba(242,232,217,0.42)',
                textAlign: 'right',
              }}>{h.total}</div>
            </div>
          );
        })}
      </div>

      {/* Footer */}
      <div style={{
        position: 'absolute', bottom: 96, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 12,
        }}>some relationships are old.<br/>some are weeks old. all of them are yours.</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 7 — THE LIFETIME SPIRAL
// Every year of practice as a concentric ring of the same yantra.
// Year 1 innermost (the beginning). Each subsequent year outward.
// The whole arc of the practitioner's journey visible in one image.
// ═════════════════════════════════════════════════════════════════════════════

// Build N years of practice with growing density
const LIFETIME_YEARS = (() => {
  // Demo: 5 years of practice. Year 1 is faintest, year 5 (current) is brightest.
  const years = [];
  for (let y = 0; y < 5; y++) {
    const recogs = 240 + y * 280 + Math.floor(Math.random() * 100);
    const embodied = Math.min(16, Math.floor(y * 1.2 + Math.random() * 2));
    years.push({
      year: 2022 + y,
      label: y === 0 ? 'first year' : y === 4 ? 'this year' : `year ${y + 1}`,
      yearN: y + 1,
      recogs,
      embodied,
      intensity: 0.35 + y * 0.15,
      crossings: Math.floor(2 + y * 1.5 + Math.random() * 2),
    });
  }
  return years;
})();

function LifetimeSpiralScreen() {
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 412;
  const baseR = 30; // innermost
  const ringStep = 24;

  // Sum totals across years
  const totalRecogs = LIFETIME_YEARS.reduce((a, y) => a + y.recogs, 0);
  const totalYears  = LIFETIME_YEARS.length;

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 70% 60% at 50% 50%, #060306 0%, #020001 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={9}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Lifetime Spiral</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.03em',
        }}>every year of practice, layered</div>
      </div>

      {/* Concentric yearly rings */}
      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* The bindu — the seed, present from year 0 */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="18" fill={COLORS.accentRed} opacity="0.7"
            style={{ filter: 'drop-shadow(0 0 18px rgba(139,26,42,0.7))' }}/>
          <circle r="6" fill={COLORS.cream}/>
        </g>

        {/* Each year — a ring of petal-density */}
        {LIFETIME_YEARS.map((yr, yi) => {
          const r = baseR + yi * ringStep;
          // For each year, render 16 petal-marks colored by cluster, length by intensity
          return (
            <g key={yi}>
              {/* Year ring outline */}
              <circle cx={cx} cy={cy} r={r} fill="none"
                stroke={`rgba(201,150,63,${0.10 + yr.intensity * 0.18})`}
                strokeWidth="0.5"/>
              {/* 16 petals as small radial marks */}
              {SHAKTIS.map((s, i) => {
                const angle = (i * 22.5 - 90) * Math.PI / 180;
                const inner = r - 7;
                const outer = r + 7;
                const x1 = cx + inner * Math.cos(angle);
                const y1 = cy + inner * Math.sin(angle);
                const x2 = cx + outer * Math.cos(angle);
                const y2 = cy + outer * Math.sin(angle);
                const col = CLUSTER_INFO[s.cluster].color;
                return (
                  <line key={i} x1={x1} y1={y1} x2={x2} y2={y2}
                    stroke={col}
                    strokeWidth={1.5}
                    opacity={0.20 + yr.intensity * 0.65}
                    strokeLinecap="round"/>
                );
              })}
              {/* Year label at top-left of its ring */}
              {(() => {
                const ar = (-90 - 18) * Math.PI / 180;
                const lr = r + 14;
                const lx = cx + lr * Math.cos(ar);
                const ly = cy + lr * Math.sin(ar);
                return (
                  <text x={lx} y={ly + 3} textAnchor="middle"
                    fontFamily="'Cormorant Garamond', serif"
                    fontStyle="italic"
                    fontSize="10"
                    fill={yi === LIFETIME_YEARS.length - 1
                      ? COLORS.gold
                      : 'rgba(242,232,217,0.45)'}
                    letterSpacing="0.5">
                    {yr.year}
                  </text>
                );
              })()}
            </g>
          );
        })}
      </svg>

      {/* Lifetime stats */}
      <div style={{
        position: 'absolute', bottom: 184, left: 28, right: 28,
        display: 'grid', gridTemplateColumns: '1fr 1fr 1fr',
        rowGap: 18, columnGap: 14,
      }}>
        {[
          { label: 'years walked',   value: totalYears, isNum: true },
          { label: 'recognitions',   value: totalRecogs.toLocaleString(), isNum: true },
          { label: 'embodied',       value: LIFETIME_YEARS[LIFETIME_YEARS.length-1].embodied, isNum: true },
        ].map((stat, i) => (
          <div key={i} style={{ textAlign: 'center' }}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 9, color: 'rgba(242,232,217,0.32)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
              marginBottom: 4,
            }}>{stat.label}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 28, fontWeight: 300,
              color: COLORS.cream,
              letterSpacing: '0.02em', lineHeight: 1,
            }}>{stat.value}</div>
          </div>
        ))}
      </div>

      <div style={{
        position: 'absolute', bottom: 96, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 10,
        }}>five years inside the same yantra.<br/>each ring a season of being with her.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.28)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>tap a ring · enter that year</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ─── Exports ──────────────────────────────────────────────────────────────────
Object.assign(window, {
  PortraitMandalaScreen, PetalBiographyScreen,
  ThresholdTimelineScreen, ClusterGardenScreen,
  DensityAtlasScreen, FirstLastScreen,
  LifetimeSpiralScreen, LIFETIME_YEARS,
  PRACTITIONER_HISTORY,
});
