// ─── Phase 7 · The Relationship Field ─────────────────────────────────────────
// The outer Saṅgha given its own world. The people you love are her wearing
// human faces. The work of recognition is the work of love.

// ─── Local helpers ────────────────────────────────────────────────────────────

function petalPathR(oR, iR, hw) {
  const c1y = (-iR * 1.85).toFixed(1);
  const c2y = (-oR * 0.85).toFixed(1);
  const c2x = (hw * 0.95).toFixed(1);
  return `M 0,${-iR} C ${hw},${c1y} ${c2x},${c2y} 0,${-oR} ` +
         `C ${-c2x},${c2y} ${-hw},${c1y} 0,${-iR} Z`;
}

// ─── The Beloved — practitioner's relationship field ─────────────────────────
// In production this flows from on-device profile data. Here, a rich set.

const FIELD = [
  { name: 'Ram',     carries: [13, 0],     hue: '#7A5A9A',
    role: 'beloved · life partner',
    note: 'who returns me to myself',
    meta: 'present · 12 years',
    encounters: 1284, peakShakti: 13,
    last: 'today, 10:14 AM', position: 0 },
  { name: 'Ashrey',  carries: [12, 11],    hue: '#4A7A5A',
    role: 'son',
    note: 'who names what is forming',
    meta: 'present · 6 years',
    encounters: 718, peakShakti: 12,
    last: 'today, 8:32 AM', position: 1 },
  { name: 'Gaia',    carries: [1],         hue: '#D4A017',
    role: 'daughter',
    note: 'who anchors the I-sense',
    meta: 'present · 4 years',
    encounters: 612, peakShakti: 1,
    last: 'today, 8:32 AM', position: 2 },
  { name: 'Ma',      carries: [10, 9],     hue: '#C4725A',
    role: 'mother',
    note: 'the steadying continuous one',
    meta: 'lifelong',
    encounters: 1042, peakShakti: 10,
    last: '2 days ago', position: 3 },
  { name: 'Papa',    carries: [3, 6],      hue: '#C45040',
    role: 'father',
    note: 'who taught the discipline of seeing',
    meta: 'lifelong',
    encounters: 681, peakShakti: 6,
    last: '5 days ago', position: 4 },
  { name: 'Nilima',  carries: [14, 7],     hue: '#8C7BAA',
    role: 'sister',
    note: 'who remembers what I forget',
    meta: 'lifelong',
    encounters: 412, peakShakti: 14,
    last: '11 days ago', position: 5 },
];

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 1 — THE RELATIONSHIP FIELD
// Your yantra at center. The beloved arranged around it as luminous nodes.
// Each connected to the shaktis they carry by colored thread.
// ═════════════════════════════════════════════════════════════════════════════

function RelationshipFieldScreen() {
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 432;

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 80% 70% at 50% 50%, #060306 0%, #010103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={10}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Relationship Field</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.03em',
        }}>she wears their faces · they carry her in</div>
      </div>

      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* The home yantra — small, faintly visible at center */}
        {(() => {
          const oR = 88, iR = 70, hw = 14;
          const pPath = petalPathR(oR, iR, hw);
          return (
            <g transform={`translate(${cx},${cy})`}>
              <circle r={oR + 4} fill="none"
                stroke="rgba(201,150,63,0.10)" strokeWidth="0.4"/>
              {SHAKTIS.map((s, i) => {
                const col = CLUSTER_INFO[s.cluster].color;
                return (
                  <g key={i} transform={`rotate(${i * 22.5})`}>
                    <path d={pPath} fill={col} opacity={0.30}/>
                  </g>
                );
              })}
              <circle r="6" fill={COLORS.accentRed} opacity="0.85"/>
              <circle r="2" fill={COLORS.cream}/>
            </g>
          );
        })()}

        {/* Connection threads from each beloved to their carrier-shaktis */}
        {FIELD.map((person, pi) => {
          const angle = (pi / FIELD.length) * Math.PI * 2 - Math.PI / 2;
          const r = 200;
          const px = cx + r * Math.cos(angle);
          const py = cy + r * Math.sin(angle);

          return person.carries.map((shaktiIdx, k) => {
            const sAngle = (shaktiIdx * 22.5 - 90) * Math.PI / 180;
            const sR = 80;
            const sx = cx + sR * Math.cos(sAngle);
            const sy = cy + sR * Math.sin(sAngle);
            return (
              <g key={`${pi}-${k}`}>
                <line x1={px} y1={py} x2={sx} y2={sy}
                  stroke={person.hue} strokeWidth="0.5"
                  opacity="0.40" strokeDasharray="2 4"/>
                {/* Highlight the carrier-petal */}
                <circle cx={sx} cy={sy} r="6" fill={person.hue}
                  opacity="0.40"
                  style={{ filter: 'blur(4px)' }}/>
              </g>
            );
          });
        })}
      </svg>

      {/* Beloved nodes — positioned around the yantra */}
      {FIELD.map((person, pi) => {
        const angle = (pi / FIELD.length) * Math.PI * 2 - Math.PI / 2;
        const r = 200;
        const px = cx + r * Math.cos(angle);
        const py = cy + r * Math.sin(angle);
        // Choose label offset based on quadrant
        const labelBelow = py < cy;
        return (
          <div key={person.name} style={{
            position: 'absolute', left: px, top: py,
            transform: 'translate(-50%,-50%)',
            textAlign: 'center', zIndex: 3,
          }}>
            <div style={{
              width: 16, height: 16, borderRadius: '50%',
              background: `radial-gradient(circle, ${person.hue} 0%, ${person.hue}88 70%, transparent 100%)`,
              margin: '0 auto',
              boxShadow: `0 0 12px 3px ${person.hue}66`,
            }}/>
            <div style={{
              marginTop: labelBelow ? -36 : 6,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 14, fontStyle: 'italic', fontWeight: 300,
              color: COLORS.cream,
              letterSpacing: '0.04em',
            }}>{person.name}</div>
          </div>
        );
      })}

      {/* Caption */}
      <div style={{
        position: 'absolute', bottom: 100, left: 0, right: 0,
        textAlign: 'center', padding: '0 32px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 19, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.72)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 12,
        }}>six souls in your field.<br/>each one a carrier of her.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>tap a name · enter their page · hold to add a soul</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 2 — THE PERSON PAGE
// Tap a beloved. Open their full shakti-carrier profile.
// Their shaktis named. Encounters logged. When she enters most through them.
// ═════════════════════════════════════════════════════════════════════════════

function PersonPageScreen({ personIdx = 0 }) {
  const person = FIELD[personIdx];
  const carriedShaktis = person.carries.map(idx => SHAKTIS[idx]);

  return (
    <div style={{
      width: 390, height: 844,
      background: `linear-gradient(180deg, ${person.hue}18 0%, #060104 50%, #050103 100%)`,
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        display: 'flex', alignItems: 'center', padding: '6px 22px 8px',
        color: person.hue, fontSize: 13, gap: 6, cursor: 'pointer',
      }}>
        <span style={{ fontSize: 18, lineHeight: 1 }}>‹</span>
        <span style={{ letterSpacing: '0.06em', opacity: 0.85 }}>Field</span>
      </div>

      {/* Hero */}
      <div style={{
        padding: '8px 28px 24px', textAlign: 'center',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          width: 56, height: 56, borderRadius: '50%',
          background: `radial-gradient(circle, ${person.hue} 0%, ${person.hue}66 60%, transparent 100%)`,
          boxShadow: `0 0 32px 6px ${person.hue}55`,
          margin: '0 auto 18px',
        }}/>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 46, fontWeight: 300, fontStyle: 'italic',
          color: COLORS.cream,
          letterSpacing: '0.05em', lineHeight: 1,
          marginBottom: 10,
        }}>{person.name}</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: `rgba(242,232,217,0.45)`,
          letterSpacing: '0.28em', textTransform: 'uppercase',
          marginBottom: 14,
        }}>{person.role}</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.65)',
          letterSpacing: '0.02em',
          maxWidth: 280, margin: '0 auto',
        }}>{person.note}</div>
      </div>

      {/* Their shaktis — the carrier reveal */}
      <div style={{ padding: '22px 28px 0' }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9.5, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 16,
        }}>she enters through them as</div>

        {carriedShaktis.map((s, i) => {
          const col = CLUSTER_INFO[s.cluster].color;
          const intensity = i === 0 ? 1.0 : 0.7;
          return (
            <div key={s.id} style={{
              display: 'flex', alignItems: 'center', gap: 14,
              padding: '12px 0',
              borderBottom: i < carriedShaktis.length - 1
                ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
            }}>
              <div style={{
                width: 10, height: 10, borderRadius: '50%',
                background: col, opacity: intensity,
                boxShadow: `0 0 8px ${col}`,
                flexShrink: 0,
              }}/>
              <div style={{ flex: 1 }}>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 19, fontStyle: 'italic', fontWeight: 300,
                  color: COLORS.cream,
                  letterSpacing: '0.02em',
                  marginBottom: 3,
                }}>{s.name}</div>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 13, fontStyle: 'italic',
                  color: 'rgba(242,232,217,0.50)',
                  letterSpacing: '0.01em', lineHeight: 1.5,
                }}>{s.quality}</div>
              </div>
              {i === 0 && (
                <div style={{
                  fontFamily: '-apple-system, sans-serif',
                  fontSize: 9, color: col,
                  letterSpacing: '0.18em', textTransform: 'uppercase',
                  padding: '2px 8px',
                  border: `0.5px solid ${col}55`, borderRadius: 8,
                }}>primary</div>
              )}
            </div>
          );
        })}
      </div>

      {/* Stats grid */}
      <div style={{
        padding: '22px 28px',
        display: 'grid', gridTemplateColumns: '1fr 1fr',
        rowGap: 18, columnGap: 18,
        marginTop: 8,
      }}>
        {[
          { label: 'encounters', value: person.encounters.toLocaleString() },
          { label: 'in field',   value: person.meta },
          { label: 'last met',   value: person.last },
          { label: 'most alive', value: SHAKTIS[person.peakShakti].short },
        ].map((stat, i) => (
          <div key={i}>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 9, color: 'rgba(242,232,217,0.32)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
              marginBottom: 5,
            }}>{stat.label}</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 18, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.82)',
              letterSpacing: '0.02em', lineHeight: 1.1,
            }}>{stat.value}</div>
          </div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 3 — THE SHAKTI'S CARRIERS
// Reverse lookup. Tap a shakti, see WHICH PEOPLE in your life carry her.
// ═════════════════════════════════════════════════════════════════════════════

function ShaktiCarriersScreen({ shaktiIdx = 13 }) {
  const shakti = SHAKTIS[shaktiIdx];
  const color = CLUSTER_INFO[shakti.cluster].color;
  // Find all carriers
  const carriers = FIELD.filter(p => p.carries.includes(shaktiIdx));

  return (
    <div style={{
      width: 390, height: 844,
      background: `linear-gradient(180deg, ${color}0F 0%, #060104 50%, #050103 100%)`,
      position: 'relative', overflow: 'hidden',
    }}>
      <StatusBar/>

      <div style={{
        display: 'flex', alignItems: 'center', padding: '6px 22px 8px',
        color: color, fontSize: 13, gap: 6, cursor: 'pointer',
      }}>
        <span style={{ fontSize: 18, lineHeight: 1 }}>‹</span>
        <span style={{ letterSpacing: '0.06em', opacity: 0.85 }}>Portrait</span>
      </div>

      {/* Hero — the shakti */}
      <div style={{
        padding: '8px 28px 24px', textAlign: 'center',
        borderBottom: '0.5px solid rgba(201,150,63,0.10)',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 10,
        }}>who carries her into your life</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 38, fontWeight: 300, color: COLORS.cream,
          letterSpacing: '0.05em', lineHeight: 1,
          marginBottom: 10,
        }}>{shakti.name}</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 24, fontStyle: 'italic', fontWeight: 300,
          color: color, letterSpacing: '0.12em',
          textShadow: `0 0 16px ${color}88`,
          marginBottom: 16,
        }}>{shakti.bija}</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 16, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.60)',
          maxWidth: 290, margin: '0 auto',
          lineHeight: 1.55,
        }}>{shakti.quality}</div>
      </div>

      {/* The carriers list */}
      <div style={{ padding: '24px 28px 0' }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 9.5, color: `rgba(242,232,217,0.45)`,
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 18,
        }}>{carriers.length === 0 ? 'no carriers yet' :
            carriers.length === 1 ? 'one soul carries her' :
            `${carriers.length} souls carry her`}</div>

        {carriers.length === 0 ? (
          <div style={{
            padding: '24px',
            border: '0.5px dashed rgba(201,150,63,0.22)',
            borderRadius: 12, textAlign: 'center',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 16, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.40)',
              lineHeight: 1.6,
            }}>no one yet carries her into your life.<br/>watch · she may arrive through someone soon.</div>
          </div>
        ) : (
          carriers.map((person, i) => (
            <div key={person.name} style={{
              display: 'flex', alignItems: 'center', gap: 16,
              padding: '14px 0',
              borderBottom: i < carriers.length - 1
                ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
            }}>
              <div style={{
                width: 18, height: 18, borderRadius: '50%',
                background: `radial-gradient(circle, ${person.hue} 0%, ${person.hue}66 70%, transparent 100%)`,
                boxShadow: `0 0 12px 2px ${person.hue}66`,
                flexShrink: 0,
              }}/>
              <div style={{ flex: 1 }}>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 20, fontStyle: 'italic', fontWeight: 300,
                  color: COLORS.cream,
                  letterSpacing: '0.04em',
                  marginBottom: 3,
                }}>{person.name}</div>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 13, fontStyle: 'italic',
                  color: 'rgba(242,232,217,0.45)',
                  letterSpacing: '0.01em',
                }}>{person.note}</div>
              </div>
              <div style={{
                fontFamily: '-apple-system, sans-serif',
                fontSize: 9, color: 'rgba(242,232,217,0.32)',
                letterSpacing: '0.18em', textTransform: 'uppercase',
                textAlign: 'right',
              }}>{person.role.split(' · ')[0]}</div>
            </div>
          ))
        )}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 4 — THE ENCOUNTER LOG
// When you were with whom — and which shaktis arose. The crossing of love
// and recognition mapped over time.
// ═════════════════════════════════════════════════════════════════════════════

const ENCOUNTERS = [
  { date: 'Today, 10:14 AM', person: 'Ram',     hue: '#7A5A9A',
    shaktis: [13, 0], context: 'morning chai. he was reading. I was watching.' },
  { date: 'Today, 8:32 AM',  person: 'Ashrey',  hue: '#4A7A5A',
    shaktis: [12],    context: 'he named the tree outside · Sapodilla, he said.' },
  { date: 'Today, 8:32 AM',  person: 'Gaia',    hue: '#D4A017',
    shaktis: [1],     context: 'she said: "Mama, look! ME!"' },
  { date: 'Yesterday, 7pm',  person: 'Ram',     hue: '#7A5A9A',
    shaktis: [13, 9], context: 'dinner. silence between sentences.' },
  { date: '2 days ago',      person: 'Ma',      hue: '#C4725A',
    shaktis: [10, 9], context: 'phone call · she asked how I was sleeping.' },
  { date: '3 days ago',      person: 'Ashrey',  hue: '#4A7A5A',
    shaktis: [12, 11],context: 'bedtime story · he finished my sentence.' },
];

function EncounterLogScreen() {
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
        }}>The Encounter Log</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 20, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.75)',
          letterSpacing: '0.03em',
        }}>when she crossed between you</div>
      </div>

      <div style={{
        padding: '6px 22px',
        flex: 1, overflow: 'hidden',
      }}>
        {ENCOUNTERS.map((e, i) => (
          <div key={i} style={{
            display: 'flex', gap: 14, padding: '14px 0',
            borderBottom: i < ENCOUNTERS.length - 1
              ? '0.5px solid rgba(201,150,63,0.08)' : 'none',
          }}>
            {/* Person node */}
            <div style={{
              width: 12, flexShrink: 0, paddingTop: 8,
            }}>
              <div style={{
                width: 10, height: 10, borderRadius: '50%',
                background: `radial-gradient(circle, ${e.hue} 0%, ${e.hue}66 70%, transparent 100%)`,
                boxShadow: `0 0 8px 2px ${e.hue}55`,
              }}/>
            </div>

            <div style={{ flex: 1 }}>
              <div style={{
                display: 'flex', alignItems: 'baseline', gap: 10,
                marginBottom: 6,
              }}>
                <div style={{
                  fontFamily: "'Cormorant Garamond', serif",
                  fontSize: 18, fontStyle: 'italic',
                  color: COLORS.cream,
                  letterSpacing: '0.03em',
                }}>{e.person}</div>
                <div style={{
                  fontFamily: '-apple-system, sans-serif',
                  fontSize: 9, color: 'rgba(242,232,217,0.32)',
                  letterSpacing: '0.16em',
                }}>{e.date}</div>
              </div>

              {/* The shaktis that arose */}
              <div style={{
                display: 'flex', gap: 10, marginBottom: 8, flexWrap: 'wrap',
              }}>
                {e.shaktis.map(sIdx => {
                  const s = SHAKTIS[sIdx];
                  const col = CLUSTER_INFO[s.cluster].color;
                  return (
                    <div key={sIdx} style={{
                      display: 'flex', alignItems: 'center', gap: 5,
                    }}>
                      <div style={{
                        width: 5, height: 5, borderRadius: '50%',
                        background: col, opacity: 0.85,
                      }}/>
                      <span style={{
                        fontFamily: "'Cormorant Garamond', serif",
                        fontSize: 12, fontStyle: 'italic',
                        color: col,
                        letterSpacing: '0.04em',
                      }}>{s.short}</span>
                    </div>
                  );
                })}
              </div>

              <div style={{
                fontFamily: "'Cormorant Garamond', serif",
                fontSize: 13.5, fontStyle: 'italic', fontWeight: 300,
                color: 'rgba(242,232,217,0.58)',
                letterSpacing: '0.01em', lineHeight: 1.55,
              }}>{e.context}</div>
            </div>
          </div>
        ))}
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 5 — THE FIELD WEB
// The whole relationship constellation with cross-connections — when
// two people share a carried shakti, a thread links them through her.
// ═════════════════════════════════════════════════════════════════════════════

function FieldWebScreen() {
  const screenW = 390, screenH = 844;
  const cx = screenW / 2, cy = 432;

  // Compute people positions
  const peopleNodes = FIELD.map((p, i) => {
    const angle = (i / FIELD.length) * Math.PI * 2 - Math.PI / 2;
    const r = 168;
    return {
      ...p,
      x: cx + r * Math.cos(angle),
      y: cy + r * Math.sin(angle),
    };
  });

  // Find shared shaktis
  const sharedConnections = [];
  for (let i = 0; i < FIELD.length; i++) {
    for (let j = i + 1; j < FIELD.length; j++) {
      const shared = FIELD[i].carries.filter(s => FIELD[j].carries.includes(s));
      if (shared.length > 0) {
        sharedConnections.push({
          a: i, b: j, shared,
          color: CLUSTER_INFO[SHAKTIS[shared[0]].cluster].color,
        });
      }
    }
  }

  return (
    <div style={{
      width: screenW, height: screenH,
      background: 'radial-gradient(ellipse 80% 70% at 50% 50%, #060306 0%, #010103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={8}/>
      <StatusBar/>

      <div style={{
        position: 'absolute', top: 64, left: 0, right: 0, textAlign: 'center',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: '#C9963F',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          opacity: 0.7, marginBottom: 8,
        }}>The Field Web</div>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 17, fontStyle: 'italic',
          color: 'rgba(242,232,217,0.62)',
          letterSpacing: '0.03em',
        }}>the threads between them</div>
      </div>

      <svg width={screenW} height={screenH}
        viewBox={`0 0 ${screenW} ${screenH}`}
        style={{ position: 'absolute', top: 0, left: 0, overflow: 'visible' }}>

        {/* Faint center yantra outline */}
        <g transform={`translate(${cx},${cy})`}>
          <circle r="70" fill="none" stroke="rgba(201,150,63,0.12)" strokeWidth="0.4"/>
          <circle r="42" fill="none" stroke="rgba(201,150,63,0.10)" strokeWidth="0.4"/>
          <circle r="8" fill={COLORS.accentRed} opacity="0.8"/>
          <circle r="3" fill={COLORS.cream}/>
        </g>

        {/* Cross-connections — threads between people who share shaktis */}
        {sharedConnections.map((conn, ci) => {
          const a = peopleNodes[conn.a];
          const b = peopleNodes[conn.b];
          // Curve through center area
          const mx = (a.x + b.x) / 2;
          const my = (a.y + b.y) / 2;
          // Slight bend toward yantra center
          const tx = mx + (cx - mx) * 0.35;
          const ty = my + (cy - my) * 0.35;
          return (
            <path key={ci}
              d={`M ${a.x},${a.y} Q ${tx},${ty} ${b.x},${b.y}`}
              fill="none" stroke={conn.color}
              strokeWidth="0.7" opacity="0.40"
              strokeLinecap="round"/>
          );
        })}

        {/* Person nodes — luminous */}
        {peopleNodes.map((p, pi) => (
          <g key={pi}>
            <circle cx={p.x} cy={p.y} r="20"
              fill={p.hue} opacity="0.18"
              style={{ filter: 'blur(6px)' }}/>
            <circle cx={p.x} cy={p.y} r="9"
              fill={p.hue}/>
            <circle cx={p.x} cy={p.y} r="3"
              fill={COLORS.cream}/>
          </g>
        ))}
      </svg>

      {/* Labels */}
      {peopleNodes.map((p, pi) => {
        const labelAbove = p.y < cy;
        const dy = labelAbove ? -28 : 22;
        return (
          <div key={pi} style={{
            position: 'absolute', left: p.x, top: p.y + dy,
            transform: 'translateX(-50%)',
            fontFamily: "'Cormorant Garamond', serif",
            fontSize: 13, fontStyle: 'italic',
            color: COLORS.cream,
            letterSpacing: '0.03em',
            zIndex: 3, whiteSpace: 'nowrap',
          }}>{p.name}</div>
        );
      })}

      {/* Caption */}
      <div style={{
        position: 'absolute', bottom: 96, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: "'Cormorant Garamond', serif",
          fontSize: 18, fontStyle: 'italic', fontWeight: 300,
          color: 'rgba(242,232,217,0.68)',
          letterSpacing: '0.02em', lineHeight: 1.55,
          marginBottom: 12,
        }}>{sharedConnections.length} shared currents.<br/>where one carries her, another may too.</div>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(242,232,217,0.30)',
          letterSpacing: '0.22em', textTransform: 'uppercase',
        }}>tap a thread · see which shakti runs through</div>
      </div>

      <HomeIndicator/>
    </div>
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// INSTRUMENT 6 — ADDING A BELOVED
// The ritual of bringing someone into your field. Not a "contacts list" —
// a sacred recognition: "this person carries her in."
// ═════════════════════════════════════════════════════════════════════════════

function AddBelovedScreen({ state = 'naming' }) {
  // state: 'naming' | 'selecting-shaktis' | 'note' | 'arriving'

  return (
    <div style={{
      width: 390, height: 844,
      background: 'linear-gradient(180deg, #0A0610 0%, #060104 60%, #040103 100%)',
      position: 'relative', overflow: 'hidden',
    }}>
      <DustMotes count={6}/>
      <StatusBar/>

      <div style={{
        display: 'flex', alignItems: 'center', padding: '6px 22px 8px',
        color: 'rgba(201,150,63,0.6)', fontSize: 13, gap: 6, cursor: 'pointer',
      }}>
        <span style={{ fontSize: 18, lineHeight: 1 }}>‹</span>
        <span style={{ letterSpacing: '0.06em' }}>Field</span>
      </div>

      {/* Progress dots */}
      <div style={{
        display: 'flex', justifyContent: 'center', gap: 12, padding: '12px 0 0',
      }}>
        {['naming','selecting-shaktis','note','arriving'].map(s => (
          <div key={s} style={{
            width: 6, height: 6, borderRadius: '50%',
            background: s === state ? COLORS.gold : 'rgba(201,150,63,0.20)',
            boxShadow: s === state ? '0 0 6px 1px rgba(201,150,63,0.6)' : 'none',
          }}/>
        ))}
      </div>

      <div style={{
        position: 'absolute', top: 130, left: 0, right: 0,
        textAlign: 'center', padding: '0 36px',
      }}>
        <div style={{
          fontFamily: '-apple-system, sans-serif',
          fontSize: 10, color: 'rgba(201,150,63,0.65)',
          letterSpacing: '0.32em', textTransform: 'uppercase',
          marginBottom: 16,
        }}>{state === 'naming' ? 'a soul arrives in your field'
           : state === 'selecting-shaktis' ? 'how does she enter through them'
           : state === 'note' ? 'who they are to you'
           : 'received'}</div>
      </div>

      {/* NAMING — text input for the name */}
      {state === 'naming' && (
        <>
          <div style={{
            position: 'absolute', top: 250, left: 0, right: 0,
            textAlign: 'center', padding: '0 32px',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 26, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.78)',
              letterSpacing: '0.03em', lineHeight: 1.55,
              marginBottom: 38,
            }}>By what name<br/>do you know them?</div>
            <div style={{
              padding: '14px 22px',
              background: 'rgba(242,232,217,0.04)',
              border: '0.5px solid rgba(242,232,217,0.18)',
              borderRadius: 8,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 22, fontStyle: 'italic',
              color: COLORS.cream,
              textAlign: 'center',
              letterSpacing: '0.04em',
              marginBottom: 14,
            }}>Nilima<span style={{
              display: 'inline-block', width: 1, height: 22,
              background: COLORS.cream, marginLeft: 3,
              animation: 'cursorBlink 1.1s steps(2) infinite',
            }}/></div>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.32)',
              letterSpacing: '0.20em', textTransform: 'uppercase',
            }}>the name you call them</div>
          </div>
        </>
      )}

      {/* SELECTING SHAKTIS — which shaktis does she enter through them as */}
      {state === 'selecting-shaktis' && (
        <>
          <div style={{
            position: 'absolute', top: 200, left: 0, right: 0,
            textAlign: 'center', padding: '0 32px',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 22, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.78)',
              letterSpacing: '0.02em', lineHeight: 1.55,
              marginBottom: 28,
            }}>What does she become<br/>when she comes through them?</div>
          </div>

          {/* Mini-yantra with two selected petals */}
          <div style={{
            position: 'absolute', top: 320, left: '50%',
            transform: 'translateX(-50%)',
            width: 240, height: 240,
          }}>
            <svg width="240" height="240" viewBox="0 0 240 240">
              <g transform="translate(120,120)">
                {SHAKTIS.map((s, i) => {
                  const col = CLUSTER_INFO[s.cluster].color;
                  // 14 and 7 are selected — Amrta and Rupa
                  const selected = i === 14 || i === 7;
                  const oR = 100, iR = 70, hw = 18;
                  const path = petalPathR(oR, iR, hw);
                  return (
                    <g key={i} transform={`rotate(${i * 22.5})`}>
                      <path d={path} fill={col}
                        opacity={selected ? 0.95 : 0.18}
                        style={selected ? { filter: `drop-shadow(0 0 10px ${col}aa)` } : {}}/>
                    </g>
                  );
                })}
                <circle r="4" fill={COLORS.accentRed} opacity="0.8"/>
              </g>
            </svg>
          </div>

          <div style={{
            position: 'absolute', bottom: 170, left: 0, right: 0,
            textAlign: 'center',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 15, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.62)',
              letterSpacing: '0.04em', marginBottom: 6,
            }}>two chosen · Amṛtākarṣiṇī · Rūpākarṣiṇī</div>
            <div style={{
              fontFamily: '-apple-system, sans-serif',
              fontSize: 10, color: 'rgba(242,232,217,0.30)',
              letterSpacing: '0.22em', textTransform: 'uppercase',
            }}>tap petals · two or three is enough</div>
          </div>
        </>
      )}

      {/* NOTE — write what they are to you */}
      {state === 'note' && (
        <>
          <div style={{
            position: 'absolute', top: 220, left: 0, right: 0,
            textAlign: 'center', padding: '0 32px',
          }}>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 24, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.78)',
              letterSpacing: '0.02em', lineHeight: 1.55,
              marginBottom: 36,
            }}>In one breath:<br/>who is she, to you?</div>
            <div style={{
              padding: '20px 24px',
              minHeight: 90,
              background: 'rgba(242,232,217,0.04)',
              border: '0.5px solid rgba(242,232,217,0.18)',
              borderRadius: 12,
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 17, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.85)',
              textAlign: 'center',
              letterSpacing: '0.02em', lineHeight: 1.6,
            }}>who remembers what I forget</div>
          </div>
        </>
      )}

      {/* ARRIVING — the welcome */}
      {state === 'arriving' && (
        <>
          <div style={{
            position: 'absolute', top: 220, left: 0, right: 0,
            textAlign: 'center', padding: '0 32px',
          }}>
            {/* The new node — appearing */}
            <div style={{
              width: 36, height: 36, borderRadius: '50%',
              background: 'radial-gradient(circle, #8C7BAA 0%, rgba(140,123,170,0.5) 60%, transparent 100%)',
              boxShadow: '0 0 36px 10px rgba(140,123,170,0.5)',
              margin: '0 auto 22px',
            }}/>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 42, fontWeight: 300, fontStyle: 'italic',
              color: COLORS.cream,
              letterSpacing: '0.05em', lineHeight: 1,
              marginBottom: 14,
            }}>Nilima</div>
            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 17, fontStyle: 'italic',
              color: 'rgba(242,232,217,0.55)',
              letterSpacing: '0.02em',
              maxWidth: 280, margin: '0 auto 36px',
            }}>who remembers what I forget</div>

            <div style={{ width: 36, height: 0.5,
              background: 'rgba(201,150,63,0.4)',
              margin: '0 auto 28px' }}/>

            <div style={{
              fontFamily: "'Cormorant Garamond', serif",
              fontSize: 19, fontStyle: 'italic', fontWeight: 300,
              color: 'rgba(242,232,217,0.72)',
              letterSpacing: '0.02em', lineHeight: 1.55,
              maxWidth: 300, margin: '0 auto',
            }}>she is now in your field.<br/>she will arrive in the yantra<br/>each time you meet.</div>
          </div>
        </>
      )}

      <HomeIndicator/>
    </div>
  );
}

// ─── Exports ──────────────────────────────────────────────────────────────────
Object.assign(window, {
  RelationshipFieldScreen, PersonPageScreen,
  ShaktiCarriersScreen, EncounterLogScreen,
  FieldWebScreen, AddBelovedScreen,
  FIELD, ENCOUNTERS,
});
