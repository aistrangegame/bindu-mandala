// rite-seat.jsx — the architecture. A home is her seat in the Śrī Yantra, seen from
// INSIDE it: one-point perspective, the far wall is the aperture, the walls are the
// seat's own edges receding past you. Ring geometry gives the room; her signature
// gives the opening. Turrell-grade: the light field is saturated, not dim.

/* __iife */ (function () {
const RS_W = 402, RS_H = 874;
const RS_R = 330, RS_KFAR = 0.28, RS_KNEAR = 2.55;

// Unit outlines, centred on the origin, y down.
function riteShapePoints(kind) {
  const P = [];
  if (kind === 'square') {
    [[-1, -1], [1, -1], [1, 1], [-1, 1]].forEach(([x, y]) => P.push([x * 0.94, y * 0.94]));
  } else if (kind === 'tri-down') {
    P.push([0, 1], [0.95, -0.62], [-0.95, -0.62]);
  } else if (kind === 'tri-up') {
    P.push([0, -1], [0.95, 0.62], [-0.95, 0.62]);
  } else if (kind === 'petal') {
    const N = 11;
    for (let i = 0; i <= N; i++) { const t = i / N; P.push([Math.pow(Math.sin(Math.PI * t), 1.45) * 0.58, -Math.cos(Math.PI * t)]); }
    for (let i = N - 1; i > 0; i--) { const t = i / N; P.push([-Math.pow(Math.sin(Math.PI * t), 1.45) * 0.58, -Math.cos(Math.PI * t)]); }
  } else if (kind === 'ten') {
    for (let i = 0; i < 10; i++) { const a = (i / 10) * Math.PI * 2 - Math.PI / 2; P.push([Math.cos(a), Math.sin(a)]); }
  } else {
    for (let i = 0; i < 26; i++) { const a = (i / 26) * Math.PI * 2 - Math.PI / 2; P.push([Math.cos(a), Math.sin(a)]); }
  }
  return P;
}

const rsPath = (pts) => pts.map((p, i) => `${i ? 'L' : 'M'} ${p[0].toFixed(1)},${p[1].toFixed(1)}`).join(' ') + ' Z';
const rsProject = (pts, vx, vy, R, k) => pts.map(([x, y]) => [vx + x * R * k, vy + y * R * k]);

// The aperture's real vertical span on screen. Both the room and everything placed
// around it derive from this one function, so they cannot drift apart.
function riteApertureSpan(room, vpY) {
  const pts = riteShapePoints(room);
  const m = pts.reduce((acc, p) => Math.max(acc, Math.abs(p[1])), 0);
  const vy = vpY * RS_H, half = RS_R * RS_KFAR * m;
  return { top: vy - half, bottom: vy + half, cy: vy, half };
}

// Her signature, emissive, on the far wall. This is the uniqueness channel that
// two Śaktis in the same ring cannot share.
function RiteApertureFace({ kind, r, hue, sat, lum, a, b, id }) {
  const L = lum * (0.34 + 0.66 * a);
  const core = `hsl(${hue},${Math.round(sat * 0.5)}%,${Math.min(97, L + 34)}%)`;
  const mid = `hsl(${hue},${sat}%,${L}%)`;
  const s = r * 0.66;
  const glow = { filter: `url(#rsSoft${id})` };
  if (kind === 'point') {
    return (
      <g>
        <circle r={s * 0.3} fill={core} />
        <circle r={s * 0.62} fill={mid} opacity="0.75" style={glow} />
      </g>
    );
  }
  if (kind === 'triad') {
    const d = s * (0.44 + 0.16 * b);
    return (
      <g>
        {[[0, -d], [-d * 0.88, d * 0.55], [d * 0.88, d * 0.55]].map(([x, y], i) => (
          <g key={i} transform={`translate(${x} ${y})`}>
            <circle r={s * 0.42} fill={mid} opacity="0.9" style={glow} />
            <circle r={s * 0.17} fill={core} />
          </g>
        ))}
      </g>
    );
  }
  if (kind === 'tri-down' || kind === 'triangle-down') {
    return (
      <g>
        <path d={`M ${-s},${-s * 0.78} L ${s},${-s * 0.78} L 0,${s} Z`} fill={mid} style={glow} />
        <path d={`M ${-s * 0.55},${-s * 0.36} L ${s * 0.55},${-s * 0.36} L 0,${s * 0.5} Z`} fill={core} opacity="0.85" />
      </g>
    );
  }
  if (kind === 'ring16' || kind === 'ring8') {
    const n = kind === 'ring16' ? 16 : 8;
    return (
      <g>
        <circle r={s * 0.34} fill={core} opacity="0.9" />
        {Array.from({ length: n }).map((_, i) => {
          const ang = (i / n) * Math.PI * 2 - Math.PI / 2;
          return <circle key={i} r={s * 0.13} cx={Math.cos(ang) * s * 0.82} cy={Math.sin(ang) * s * 0.82} fill={mid} style={glow} />;
        })}
      </g>
    );
  }
  if (kind === 'band') {
    return (
      <g>
        <ellipse rx={s} ry={s * 0.72} fill={mid} opacity="0.5" style={glow} />
        <rect x={-s} y={-s * 0.1 + Math.sin(b * Math.PI) * s * 0.3} width={s * 2} height={s * 0.2} fill={core} />
      </g>
    );
  }
  if (kind === 'lens') {
    return (
      <g>
        <path d={`M 0,${-s} C ${s * 0.8},${-s * 0.3} ${s * 0.8},${s * 0.3} 0,${s} C ${-s * 0.8},${s * 0.3} ${-s * 0.8},${-s * 0.3} 0,${-s} Z`} fill={mid} style={glow} />
        <circle r={s * 0.2} fill={core} />
      </g>
    );
  }
  return <circle r={s * 0.55} fill={mid} style={glow} />;
}

// The whole Śrī Yantra, faint, out beyond the far wall — what the second
// adaptation discovers is on the other side of the light.
function RiteYantraBeyond({ stroke, op }) {
  if (op <= 0.002) return null;
  const petal = (oR, iR, hw) => `M 0,${-iR} C ${hw},${-iR * 1.85} ${hw * 0.95},${-oR * 0.85} 0,${-oR} C ${-hw * 0.95},${-oR * 0.85} ${-hw},${-iR * 1.85} 0,${-iR} Z`;
  const ups = [[-88, 34, 76], [-68, 26, 60], [-50, 18, 46], [-34, 10, 34]];
  const downs = [[88, -34, 76], [72, -28, 66], [56, -22, 52], [42, -16, 40], [26, -10, 26]];
  const tri = ([ay, base, half]) => `M 0,${ay} L ${half},${base} L ${-half},${base} Z`;
  return (
    <g opacity={op} stroke={stroke} fill="none" strokeLinejoin="round">
      <rect x={-150} y={-150} width={300} height={300} strokeWidth="1" opacity="0.7" />
      {[[0, -150, 0, -170], [0, 150, 0, 170], [-150, 0, -170, 0], [150, 0, 170, 0]].map((g, k) => (
        <line key={k} x1={g[0]} y1={g[1]} x2={g[2]} y2={g[3]} strokeWidth="1" opacity="0.7" />
      ))}
      {Array.from({ length: 16 }, (_, i) => (
        <g key={'a' + i} transform={`rotate(${i * 22.5})`}><path d={petal(132, 112, 20)} strokeWidth="0.7" opacity="0.6" /></g>
      ))}
      {Array.from({ length: 8 }, (_, i) => (
        <g key={'b' + i} transform={`rotate(${i * 45})`}><path d={petal(104, 88, 30)} strokeWidth="0.7" opacity="0.55" /></g>
      ))}
      <g strokeWidth="0.8" opacity="0.9">
        {ups.map((t, i) => <path key={'u' + i} d={tri(t)} />)}
        {downs.map((t, i) => <path key={'d' + i} d={tri(t)} />)}
      </g>
    </g>
  );
}

// The room. One SVG, drawn far-to-near.
function RiteSeatInterior({ room, aperture, hue, sat, wallHue, a, b, vpY, reduced, id = 'x' }) {
  const pts = React.useMemo(() => riteShapePoints(room), [room]);
  const vx = RS_W / 2, vy = vpY * RS_H, R = RS_R;
  const kFar = RS_KFAR, kNear = RS_KNEAR;
  const far = rsProject(pts, vx, vy, R, kFar);
  const near = rsProject(pts, vx, vy, R, kNear);
  const farR = R * kFar;

  // Wall faces. A wall's brightness comes from where it sits: floor catches the
  // pooled light, ceiling stays in shadow.
  const walls = pts.map((p, i) => {
    const j = (i + 1) % pts.length;
    const my = (p[1] + pts[j][1]) / 2;
    const f = Math.max(0, Math.min(1, 0.5 + 0.5 * my));
    return {
      d: `M ${near[i][0].toFixed(1)},${near[i][1].toFixed(1)} L ${near[j][0].toFixed(1)},${near[j][1].toFixed(1)} L ${far[j][0].toFixed(1)},${far[j][1].toFixed(1)} L ${far[i][0].toFixed(1)},${far[i][1].toFixed(1)} Z`,
      f,
      x1: (far[i][0] + far[j][0]) / 2, y1: (far[i][1] + far[j][1]) / 2,
      x2: (near[i][0] + near[j][0]) / 2, y2: (near[i][1] + near[j][1]) / 2,
      i,
    };
  });

  const farL = 20 + 62 * a;                       // the aperture: a real light field
  const farC = `hsl(${hue},${sat}%,${farL}%)`;
  const farHot = `hsl(${hue},${Math.round(sat * 0.42)}%,${Math.min(98, farL + 26)}%)`;

  return (
    <svg width={RS_W} height={RS_H} viewBox={`0 0 ${RS_W} ${RS_H}`} style={{ position: 'absolute', inset: 0, display: 'block' }}>
      <defs>
        <filter id={`rsSoft${id}`} x="-70%" y="-70%" width="240%" height="240%">
          <feGaussianBlur stdDeviation={2.2 + 5 * (1 - a)} />
        </filter>
        <filter id={`rsFar${id}`} x="-90%" y="-90%" width="280%" height="280%">
          <feGaussianBlur stdDeviation={3 + 16 * (1 - a)} />
        </filter>
        <filter id={`rsGrain${id}`}>
          <feTurbulence type="fractalNoise" baseFrequency="0.72" numOctaves="3" seed="7" />
          <feColorMatrix type="saturate" values="0" />
        </filter>
        <radialGradient id={`rsShaft${id}`} cx={vx} cy={vy} r={R * 1.5} gradientUnits="userSpaceOnUse">
          <stop offset="0%" stopColor={`hsl(${hue},${sat}%,${Math.min(82, farL + 10)}%)`} stopOpacity={0.62 * a} />
          <stop offset="30%" stopColor={`hsl(${hue},${sat}%,${farL}%)`} stopOpacity={0.28 * a} />
          <stop offset="74%" stopColor={`hsl(${hue},${sat}%,${farL}%)`} stopOpacity="0" />
        </radialGradient>
        {walls.map((w) => (
          <linearGradient key={w.i} id={`rsW${id}_${w.i}`} x1={w.x1} y1={w.y1} x2={w.x2} y2={w.y2} gradientUnits="userSpaceOnUse">
            <stop offset="0%" stopColor={`hsl(${wallHue},${30 + 24 * w.f}%,${(4 + (10 + 30 * w.f) * a).toFixed(1)}%)`} />
            <stop offset="55%" stopColor={`hsl(${wallHue},${22 + 18 * w.f}%,${(2.4 + (5 + 14 * w.f) * a).toFixed(1)}%)`} />
            <stop offset="100%" stopColor={`hsl(${wallHue},16%,${(1 + 3 * a).toFixed(1)}%)`} />
          </linearGradient>
        ))}
        <radialGradient id={`rsGlow${id}`} cx={vx} cy={vy} r={farR * 1.15} gradientUnits="userSpaceOnUse">
          <stop offset="0%" stopColor={farHot} stopOpacity="1" />
          <stop offset="45%" stopColor={farC} stopOpacity="0.92" />
          <stop offset="100%" stopColor={`hsl(${hue},${sat}%,${(farL * 0.55).toFixed(0)}%)`} stopOpacity="0.7" />
        </radialGradient>
        <clipPath id={`rsFarClip${id}`}><path d={rsPath(far)} /></clipPath>
      </defs>

      <rect width={RS_W} height={RS_H} fill={`hsl(${wallHue},34%,${(1.4 + 1.6 * a).toFixed(1)}%)`} />

      {/* what lies beyond — the rest of the 102, arriving only on the second adaptation */}
      <g clipPath={`url(#rsFarClip${id})`}>
        <rect x={vx - farR * 1.2} y={vy - farR * 1.2} width={farR * 2.4} height={farR * 2.4} fill={`hsl(${hue},${sat}%,${(farL * 0.5).toFixed(0)}%)`} />
        <g transform={`translate(${vx} ${vy}) scale(${(0.34 + 0.5 * b).toFixed(3)})`}>
          <RiteYantraBeyond stroke={farHot} op={0.1 + 0.72 * b} />
        </g>
      </g>

      <g opacity={1 - 0.55 * b}>
        {/* the bloom the aperture throws past its own edge */}
        <g style={{ filter: `url(#rsFar${id})` }}>
          <path d={rsPath(rsProject(pts, vx, vy, R, kFar * 1.9))} fill={farC} opacity={0.12 + 0.34 * a} />
        </g>
        <path d={rsPath(far)} fill={`url(#rsGlow${id})`} opacity={0.62 + 0.38 * a} />
      </g>
      <g transform={`translate(${vx} ${vy})`} opacity={(0.4 + 0.6 * a) * (1 - 0.7 * b)}>
        <RiteApertureFace kind={aperture} r={farR} hue={hue} sat={sat} lum={farL} a={a} b={b} id={id} />
      </g>

      {/* the seat's edges, receding past you */}
      {walls.map((w) => <path key={w.i} d={w.d} fill={`url(#rsW${id}_${w.i})`} />)}
      {/* the structural lines of her seat, catching the light */}
      {pts.map((p, i) => (
        <line key={i} x1={far[i][0]} y1={far[i][1]} x2={near[i][0]} y2={near[i][1]}
          stroke={`hsl(${hue},${sat}%,${Math.min(88, farL + 18)}%)`} strokeWidth="1.1" opacity={0.3 + 0.5 * a} />
      ))}
      <path d={rsPath(far)} fill="none" stroke={farHot} strokeWidth="1.1" opacity={0.24 + 0.6 * a} />

      {/* the shaft — the light as a volume you are standing in */}
      <path d={rsPath(near)} fill={`url(#rsShaft${id})`} />

      {/* the dhātu — her ring's material, in the surfaces */}
      <rect width={RS_W} height={RS_H} filter={`url(#rsGrain${id})`} opacity={0.05 + 0.09 * a} style={{ mixBlendMode: 'overlay' }} />
      <rect width={RS_W} height={RS_H} fill="none" />
      {/* the eye's own falloff */}
      <radialGradient id={`rsVig${id}`} cx="50%" cy={`${vpY * 100}%`} r="78%">
        <stop offset="45%" stopColor="#000" stopOpacity="0" />
        <stop offset="100%" stopColor="#000" stopOpacity={0.9 - 0.28 * a} />
      </radialGradient>
      <rect width={RS_W} height={RS_H} fill={`url(#rsVig${id})`} />
    </svg>
  );
}

Object.assign(window, { riteShapePoints, riteApertureSpan, RiteSeatInterior, RiteApertureFace, RiteYantraBeyond, RS_W, RS_H });

})();
