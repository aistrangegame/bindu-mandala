// rite-app.jsx — the building's grammar, walked: entering (self-paced), dwelling,
// the descent, the doors, leaving. The specimen only fills slots.

/* __iife */ (function () {
const {
  RT: RTA, RITE_WORLDS: WORLDS, RITE_SPECIMENS: SPECS, RITE_BIJA_HZ, RITE_AFTER_DUR,
  useRiteClock, riteState, riteBeatDur, useStillness, riteAfterStyle, riteMakeAudio, clamp01: c01a,
} = window;

const RITE_VISIT_KEY = 'rite.visits.v1';
const WORLD_OPTS = Object.keys(WORLDS).map(
  (k) => `ring ${k} · ${WORLDS[k].gem.toLowerCase()} on ${WORLDS[k].dhatu.toLowerCase()}`
);

function readVisits() {
  try { return JSON.parse(localStorage.getItem(RITE_VISIT_KEY) || '{}'); } catch (e) { return {}; }
}
function writeVisits(v) {
  try { localStorage.setItem(RITE_VISIT_KEY, JSON.stringify(v)); } catch (e) {}
}

function RiteCorridor({ hue, sat, onEnter, onDoor }) {
  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden' }}>
      <div style={{
        position: 'absolute', inset: 0,
        background: `radial-gradient(130% 90% at 50% 50%, hsl(${hue},30%,6%), #050205 74%)`,
      }} />
      {[-1, 1].map((dir) => (
        <button key={dir} type="button" onClick={() => onDoor(dir)} aria-label="neighbour" style={{
          position: 'absolute', top: '34%', height: 180, width: 60, padding: 0,
          [dir < 0 ? 'left' : 'right']: 0, border: 'none', background: 'transparent', cursor: 'pointer',
        }}>
          <div style={{
            position: 'absolute', top: 0, bottom: 0, [dir < 0 ? 'left' : 'right']: 10, width: 44,
            background: `radial-gradient(closest-side, hsla(${hue},70%,62%,0.3), transparent 78%)`,
            filter: 'blur(9px)',
          }} />
        </button>
      ))}
      <button type="button" onClick={onEnter} style={{
        position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-50%)',
        width: 150, height: 48, border: 'none', background: 'transparent', cursor: 'pointer',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10,
      }}>
        <div style={{ width: 46, height: 1, background: `hsla(${hue},50%,84%,0.42)` }} />
        <div style={{
          fontFamily: RTA.serif, fontSize: 11.5, letterSpacing: '0.24em',
          textTransform: 'uppercase', color: RTA.cream, opacity: 0.42,
        }}>enter</div>
      </button>
    </div>
  );
}

function RiteApp() {
  const prefersReduced = React.useRef(
    typeof window.matchMedia === 'function' && window.matchMedia('(prefers-reduced-motion: reduce)').matches
  ).current;

  const [tw, setTweak] = useTweaks({
    dilation: '1× — true',
    world: WORLD_OPTS[0],
    reduced: prefersReduced,
    sound: false,
  });

  const dilation = tw.dilation.startsWith('1×') ? 1 : tw.dilation.startsWith('3×') ? 3 : 12;
  const ringNo = Number(tw.world.match(/ring (\d)/)[1]);
  const world = WORLDS[ringNo];
  const reduced = tw.reduced;
  const hue = world.hue, sat = world.sat;

  const [idx, setIdx] = React.useState(1);
  const [screen, setScreen] = React.useState('in');
  const [beat, setBeat] = React.useState(1);
  const [beatT, setBeatT] = React.useState(0);
  const [enteredAt, setEnteredAt] = React.useState(null);
  const [descent, setDescent] = React.useState(false);
  const [letterOpen, setLetterOpen] = React.useState(false);
  const [visits, setVisits] = React.useState(() => readVisits());
  const [after, setAfter] = React.useState(null);
  const [shownMax, setShownMax] = React.useState(0);
  const [scale, setScale] = React.useState(1);

  React.useEffect(() => {
    const fit = () => setScale(Math.min(1, (window.innerHeight - 48) / 874));
    fit(); window.addEventListener('resize', fit);
    return () => window.removeEventListener('resize', fit);
  }, []);

  const gt = useRiteClock({ running: true, dilation, resetKey: 0 });
  const spec = SPECS[idx];
  const visitCount = (visits[spec.num] || 0) + 1;
  const roomT = enteredAt == null ? 0 : Math.max(0, gt - enteredAt);
  const st = riteState({ t: roomT, spec, reduced });
  const entered = enteredAt != null;

  const beatDur = riteBeatDur(beat, visitCount, reduced);
  const beatProgress = c01a((gt - beatT) / beatDur);

  const rawStill = useStillness(gt, screen === 'in' && entered && !descent);
  const still = Math.min(rawStill, roomT);
  const candidate = window.riteLinesShown(still, st.a, spec.lines.length);
  React.useEffect(() => { if (candidate > shownMax) setShownMax(candidate); }, [candidate, shownMax]);

  const afterAge = after ? gt - after.at : Infinity;
  const afterStyle = after ? riteAfterStyle(after.kind, afterAge) : {};

  const audio = React.useRef(null);
  if (!audio.current) audio.current = riteMakeAudio();
  React.useEffect(() => {
    if (tw.sound) audio.current.start(RITE_BIJA_HZ[world.bija] || 136.1);
    audio.current.update(st.a, st.b, tw.sound && screen === 'in');
  }, [tw.sound, st.a, st.b, screen, world.bija]);

  const advance = () => {
    if (beat >= 3) { setBeat(4); setEnteredAt(gt); }
    else { setBeat(beat + 1); setBeatT(gt); }
  };

  const enter = (nextIdx) => {
    const n = SPECS[nextIdx].num;
    const nv = { ...visits, [n]: (visits[n] || 0) + 1 };
    setVisits(nv); writeVisits(nv);
    setIdx(nextIdx); setScreen('in');
    setBeat(1); setBeatT(gt); setEnteredAt(null);
    setDescent(false); setLetterOpen(false); setShownMax(0);
  };
  const door = (dir) => enter((idx + dir + SPECS.length) % SPECS.length);
  const leave = () => { setAfter({ kind: world.after, at: gt }); setScreen('corridor'); setDescent(false); };

  React.useEffect(() => {
    const n = spec.num;
    if (!visits[n]) { const nv = { ...visits, [n]: 1 }; setVisits(nv); writeVisits(nv); }
    setBeatT(gt);
  }, []);

  const nextLine = (() => {
    if (!entered) return 'the threshold';
    if (st.a < 0.4) return 'not yet';
    if (shownMax >= spec.lines.length) return 'all surfaced';
    return `${Math.max(0, Math.ceil(4 + (shownMax + 1) * 6.5 - still))}s of stillness`;
  })();

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 24, background: '#161013' }}>
      <div style={{ width: 402 * scale, height: 874 * scale, flex: '0 0 auto' }}>
        <div style={{ transform: `scale(${scale})`, transformOrigin: 'top left' }}>
          <IOSDevice dark>
            <div style={{ position: 'relative', height: '100%', background: RTA.ground, ...afterStyle, transition: 'filter 1200ms linear' }}>
              {screen === 'in' ? (
                <>
                  <RiteRoom
                    spec={spec} world={world} st={st} still={still} shown={shownMax} hue={hue}
                    reduced={reduced} entered={entered}
                    letterOpen={letterOpen} onLetter={() => setLetterOpen((v) => !v)}
                    onLibrary={() => setDescent(true)} onDoor={door} onLeave={leave}
                  />
                  {!entered && (
                    <RiteThreshold spec={spec} beat={beat} progress={beatProgress}
                      reduced={reduced} hue={hue} sat={sat} onAdvance={advance} />
                  )}
                  {descent && (
                    <RiteDescent spec={spec} world={world} hue={hue} sat={sat}
                      reduced={reduced} onClose={() => setDescent(false)} />
                  )}
                </>
              ) : (
                <RiteCorridor hue={hue} sat={sat} onEnter={() => enter(idx)} onDoor={door} />
              )}
            </div>
          </IOSDevice>
        </div>
      </div>

      <TweaksPanel title="The Rite">
        <TweakSection label="Time">
          <TweakRadio label="Dilation" value={tw.dilation} options={['1× — true', '3×', '12× — sketch']} onChange={(v) => setTweak('dilation', v)} />
          <TweakRow label="Phase" value={entered ? st.phase : `threshold · beat ${Math.min(beat, 3)}`} />
          <TweakRow label="First adaptation" value={entered ? `${Math.round(st.a * 100)}%` : '—'} />
          <TweakRow label="Second adaptation" value={st.b > 0 ? `${Math.round(st.b * 100)}%` : '—'} />
        </TweakSection>
        <TweakSection label="Stillness">
          <TweakRow label="Held" value={`${still.toFixed(0)}s`} />
          <TweakRow label="Next line" value={nextLine} />
        </TweakSection>
        <TweakSection label="Her">
          <TweakRow label="Specimen" value={`${spec.num} · ${spec.name}`} />
          <TweakRow label="Her seat" value={`${world.room} · ${world.gem}`} />
          <TweakRow label="Aperture" value={spec.shape} />
          <TweakRow label="Rate" value={spec.rate} />
          <TweakRow label="Visits" value={`${visitCount} · ceremony at ${Math.round(window.riteCompression(visitCount) * 100)}%`} />
        </TweakSection>
        <TweakSection label="World (previews P1–P9)">
          <TweakSelect label="Ring" value={tw.world} options={WORLD_OPTS} onChange={(v) => setTweak('world', v)} />
          <TweakRow label="Clock" value={world.clock} />
          <TweakRow label="Altitude" value={world.region} />
        </TweakSection>
        <TweakSection label="After-effect">
          <TweakRow label="Lingering" value={after && afterAge < RITE_AFTER_DUR ? `${after.kind} · ${Math.round(RITE_AFTER_DUR - afterAge)}s left` : '—'} />
        </TweakSection>
        <TweakSection label="Access">
          <TweakToggle label="Reduced motion" value={reduced} onChange={(v) => setTweak('reduced', v)} />
          <TweakToggle label="Sound" value={tw.sound} onChange={(v) => setTweak('sound', v)} />
        </TweakSection>
        <TweakSection label="Jump">
          <TweakButton label="Settled — the eye has adjusted" onClick={() => { setBeat(4); setEnteredAt(gt - st.marks.adaptEnd - 2); }} />
          <TweakButton label="The second adaptation" onClick={() => { setBeat(4); setEnteredAt(gt - st.marks.holdEnd - 96); }} />
          <TweakButton label="The descent" onClick={() => { setBeat(4); if (enteredAt == null) setEnteredAt(gt); setDescent(true); }} />
          <TweakButton secondary label="Re-enter this room" onClick={() => { setBeat(1); setBeatT(gt); setEnteredAt(null); setLetterOpen(false); setDescent(false); setShownMax(0); }} />
          <TweakButton secondary label="Forget every return" onClick={() => { setVisits({}); writeVisits({}); setBeat(1); setBeatT(gt); setEnteredAt(null); setShownMax(0); }} />
        </TweakSection>
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<RiteApp />);
})();
