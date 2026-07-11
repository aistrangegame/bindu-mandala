// living-rite-app.jsx — root: navigation, day cycle, engagement model, tweaks.

// Per-destination entrance motion — detail rises from her name, recognition
// blooms from center, memory settles in, the rest cross-fade up.
const LR_SCREEN_ANIM = {
  detail: 'lrScreenRise',
  recognition: 'lrScreenBloom',
  memory: 'lrScreenSettle',
  threshold: 'lrScreenRise',
};

const LR_TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "dayOffset": 0,
  "timeOfDay": "auto",
  "motion": true,
  "atmosphereIntensity": 0.85
}/*EDITMODE-END*/;

function LivingRiteApp() {
  const [t, setTweak] = useTweaks(LR_TWEAK_DEFAULTS);
  const [forceDay, setForceDay] = React.useState(null);
  const [forceTime, setForceTime] = React.useState(null);
  React.useEffect(() => { window.__lrSetDay = setForceDay; window.__lrSetTime = setForceTime; }, []);
  const [nav, setNav] = React.useState(() => {
    try { return JSON.parse(localStorage.getItem('lr_nav') || 'null') || { screen: 'today' }; }
    catch (e) { return { screen: 'today' }; }
  });
  const [menuOpen, setMenuOpen] = React.useState(false);
  const [nityaOpen, setNityaOpen] = React.useState(false);

  // The record of every recognition — the spine of Her Moments, embodiment,
  // and the Portrait's lighting. {kp, ts, note}.
  const [moments, setMoments] = React.useState(() => {
    try { return JSON.parse(localStorage.getItem('lr_moments') || '[]'); }
    catch (e) { return []; }
  });
  React.useEffect(() => {
    try { localStorage.setItem('lr_moments', JSON.stringify(moments)); } catch (e) {}
  }, [moments]);

  React.useEffect(() => {
    try { localStorage.setItem('lr_nav', JSON.stringify(nav)); } catch (e) {}
  }, [nav]);

  const todayShakti = React.useMemo(() => {
    const forced = forceDay != null ? forceDay : t.dayOffset;
    return lrTodaysShakti(forced);
  }, [t.dayOffset, forceDay]);
  const tv = React.useMemo(() => lrTimeVariant(forceTime != null ? forceTime : t.timeOfDay), [t.timeOfDay, forceTime]);
  const dayAtmo = React.useMemo(() => lrApplyTime(lrAtmosphere(todayShakti), tv), [todayShakti.kp, tv]);
  const moon = React.useMemo(() => lrMoon(forceDay != null ? forceDay : t.dayOffset), [t.dayOffset, forceDay]);

  const focusShakti = nav.kp ? (LR_ALL.find(s => s.kp === nav.kp) || todayShakti) : todayShakti;
  const focusAtmo = React.useMemo(() => lrApplyTime(lrAtmosphere(focusShakti), tv), [focusShakti.kp, tv]);

  const countByKp = React.useMemo(() => {
    const m = {}; moments.forEach(x => { m[x.kp] = (m[x.kp] || 0) + 1; }); return m;
  }, [moments]);
  const momentsFor = (kp) => moments.filter(x => x.kp === kp);

  const go = (screen, extra) => { setMenuOpen(false); setNityaOpen(false); setNav({ screen, ...(extra || {}) }); };

  const feelHer = (s) => {
    const ts = Date.now();
    setMoments(prev => [...prev, { kp: s.kp, ts, note: '' }]);
    go('recognition', { kp: s.kp, momentTs: ts, from: nav.screen === 'detail' ? nav.from : nav.screen });
  };
  const updateMomentNote = (ts, note) => {
    setMoments(prev => prev.map(x => x.ts === ts ? { ...x, note } : x));
  };

  let screen = null;
  if (nav.screen === 'today') {
    screen = (
      <TodayScreen
        shakti={todayShakti} atmo={dayAtmo} moon={moon}
        motion={t.motion} intensity={t.atmosphereIntensity}
        onOpenDetail={() => go('detail', { kp: todayShakti.kp, from: 'today' })}
        onOpenNitya={() => setNityaOpen(true)}
        onFeelHer={() => feelHer(todayShakti)}
      />
    );
  } else if (nav.screen === 'detail') {
    const backTo = nav.from || 'today';
    screen = (
      <DetailScreen
        shakti={focusShakti} atmo={focusAtmo} motion={t.motion}
        moments={momentsFor(focusShakti.kp)} count={countByKp[focusShakti.kp] || 0}
        backLabel={backTo === 'field' ? 'the field' : backTo === 'well' ? 'the well' : backTo === 'mandala' ? 'the mandala' : 'today'}
        onBack={() => go(backTo)}
        onFeelHer={() => feelHer(focusShakti)}
      />
    );
  } else if (nav.screen === 'recognition') {
    screen = (
      <RecognitionScreen
        shakti={focusShakti} atmo={focusAtmo}
        onNote={(text) => nav.momentTs && updateMomentNote(nav.momentTs, text)}
        onClose={() => go('memory', { settle: focusShakti.kp })}
      />
    );
  } else if (nav.screen === 'field') {
    screen = (
      <FieldScreen
        todayShakti={todayShakti} dayAtmo={dayAtmo} motion={t.motion} countByKp={countByKp}
        onOpenShakti={(s) => go('detail', { kp: s.kp, from: 'field' })}
        onOpenThreshold={(ring) => go('threshold', { ring })}
      />
    );
  } else if (nav.screen === 'threshold') {
    screen = (
      <AvaranaThreshold
        ring={nav.ring}
        onEnter={() => go('field', { openRing: nav.ring })}
        onClose={() => go('field')}
      />
    );
  } else if (nav.screen === 'well') {
    screen = (
      <WellScreen
        dayAtmo={dayAtmo} countByKp={countByKp}
        onOpenLetter={(s) => go('letter', { kp: s.kp })}
      />
    );
  } else if (nav.screen === 'letter') {
    screen = <LetterEditor shakti={focusShakti} atmo={focusAtmo} onBack={() => go('well')} />;
  } else if (nav.screen === 'memory') {
    screen = <MemoryScreen dayAtmo={dayAtmo} todayShakti={todayShakti} countByKp={countByKp} settleKp={nav.settle} />;
  } else if (nav.screen === 'mandala') {
    screen = (
      <MandalaHome
        dayAtmo={dayAtmo} todayShakti={todayShakti} countByKp={countByKp}
        onOpenShakti={(s) => go('detail', { kp: s.kp, from: 'mandala' })}
      />
    );
  }

  const showHamburger = nav.screen !== 'recognition' && nav.screen !== 'detail' && nav.screen !== 'threshold' && nav.screen !== 'letter';

  return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#161013', padding: '28px 0' }}>
      <IOSDevice dark>
        <div style={{ position: 'relative', width: '100%', height: '100%', background: dayAtmo.groundDeep, overflow: 'hidden' }}>
          <div key={`${nav.screen}:${nav.kp || ''}:${nav.ring || ''}`} style={{ position: 'absolute', inset: 0, animation: `${LR_SCREEN_ANIM[nav.screen] || 'lrScreenIn'} 0.55s cubic-bezier(0.2,0.8,0.3,1)` }}>
            {screen}
          </div>

          {showHamburger && !menuOpen ? (
            <button
              onClick={() => setMenuOpen(true)}
              aria-label="Menu"
              style={{
                position: 'absolute', top: LR_SAFE_TOP - 2, right: 14, zIndex: 30,
                width: 44, height: 44, background: 'none', border: 'none', cursor: 'pointer',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 6,
              }}
            >
              {[0,1,2].map(i => (
                <div key={i} style={{ width: 19, height: 1, background: 'rgba(201,150,63,0.75)' }} />
              ))}
            </button>
          ) : null}

          {nityaOpen ? (
            <NityaSheet moon={moon} dayAtmo={dayAtmo} onClose={() => setNityaOpen(false)} />
          ) : null}

          {menuOpen ? (
            <MenuVeil
              dayAtmo={dayAtmo}
              current={nav.screen}
              onSelect={(id) => go(id)}
              onClose={() => setMenuOpen(false)}
            />
          ) : null}
        </div>
      </IOSDevice>

      <TweaksPanel>
        <TweakSection label="The day" />
        <TweakSlider
          label="Preview day +N" value={t.dayOffset} min={0} max={30} step={1}
          onChange={(v) => setTweak('dayOffset', v)}
        />
        <TweakSelect
          label="Time of day" value={t.timeOfDay}
          options={['auto', 'dawn', 'noon', 'dusk', 'night']}
          onChange={(v) => setTweak('timeOfDay', v)}
        />
        <TweakSection label="Atmosphere" />
        <TweakSlider
          label="Intensity" value={t.atmosphereIntensity} min={0.3} max={1} step={0.05}
          onChange={(v) => setTweak('atmosphereIntensity', v)}
        />
        <TweakToggle label="Motion" value={t.motion} onChange={(v) => setTweak('motion', v)} />
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<LivingRiteApp />);
