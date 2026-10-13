// games-language.jsx — MirrorMaze, UnsentLetter, ShadowTranslator
const { useState: useSt2, useEffect: useEf2, useRef: useRf2 } = React;
const { GShell, GameDone, Starfield, T, Btn } = window;

const CHAKRAS_7 = window.CHAKRAS_7;

// ─── MIRROR MAZE ──────────────────────────────────────────────────────────────
const CHAKRA_PROMPTS = [
  { chakra:'Root',      lens:'ground it. Speak of earth, foundation, what holds. Connect it to the body, to safety, to what is beneath.', color:'#A83232' },
  { chakra:'Sacral',    lens:'make it flow. Speak of water, movement, feeling, creativity. Let it shift and find its own shape.', color:'#C45A18' },
  { chakra:'Solar',     lens:'ignite it. Speak of fire, power, will, action. What does this word DO? What does it choose?', color:'#C49B17' },
  { chakra:'Heart',     lens:'open it with love. Speak of connection, compassion, what it means to give and receive. Let it be held.', color:'#1A8060' },
  { chakra:'Throat',    lens:'speak it truthfully. What does this word sound like when it is fully expressed? What is its truest utterance?', color:'#1E6EA0' },
  { chakra:'Third Eye', lens:'see it clearly. What does this word reveal when all effort to understand it stops? What sees through it?', color:'#4A3AAB' },
  { chakra:'Crown',     lens:'transcend it. What does this word become when it is recognized as part of everything? How does it dissolve into the whole?', color:'#8A3AB5' },
];

function GMirror({ game, onReturn }) {
  const [phase, setPhase] = useSt2('input');
  const [word,  setWord]  = useSt2('');
  const [idx,   setIdx]   = useSt2(0);
  const [forms, setForms] = useSt2([]);
  const [loading, setLoading] = useSt2(false);

  async function startMaze() {
    if (!word.trim()) return;
    setPhase('running');
    setIdx(0);
    setForms([]);
    await fetchNext(word.trim(), 0, []);
  }

  async function fetchNext(w, i, prev) {
    if (i >= CHAKRA_PROMPTS.length) { setPhase('complete'); return; }
    setIdx(i); setLoading(true);
    const p = CHAKRA_PROMPTS[i];
    try {
      const resp = await window.claude.complete({
        messages: [{ role:'user', content:`The original word is: "${w}". Through the lens of the ${p.chakra} Chakra — ${p.lens} In exactly 2 sentences. Begin with the word itself.` }]
      });
      const next = [...prev, { chakra: p.chakra, color: p.color, text: resp }];
      setForms(next);
      setLoading(false);
      if (i < CHAKRA_PROMPTS.length - 1) {
        setTimeout(() => fetchNext(w, i+1, next), 400);
      } else {
        setPhase('complete');
      }
    } catch {
      const next = [...prev, { chakra: p.chakra, color: p.color, text: `${w} — seen through ${p.chakra}.` }];
      setForms(next);
      setLoading(false);
      if (i < CHAKRA_PROMPTS.length - 1) setTimeout(() => fetchNext(w, i+1, next), 400);
      else setPhase('complete');
    }
  }

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={60} opacity={.28} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column' }}>

        {phase === 'input' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', padding:'32px', animation:'emerge .7s ease' }}>
            <p style={{ ...T.sacred(24,.80), marginBottom:'10px', textAlign:'center' }}>One word.</p>
            <p style={{ ...T.italic(17,.40), marginBottom:'32px', textAlign:'center' }}>It will pass through all seven.<br/>Each one will transform it.</p>
            <input value={word} onChange={e=>setWord(e.target.value)}
              onKeyDown={e=>e.key==='Enter'&&word.trim()&&startMaze()}
              placeholder="…" style={{ width:'100%', background:'none', border:'none', borderBottom:`1px solid ${game.color}40`, padding:'10px 0', color:game.accent, fontFamily:"'Cormorant Garamond',serif", fontSize:'40px', textAlign:'center', letterSpacing:'.1em', outline:'none', marginBottom:'24px' }} />
            {word.trim() && <Btn onClick={startMaze} color={game.color} accent={game.accent}>Enter the maze</Btn>}
          </div>
        )}

        {phase === 'running' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column' }}>
            {/* Progress */}
            <div style={{ display:'flex', gap:'4px', padding:'8px 20px', flexShrink:0 }}>
              {CHAKRA_PROMPTS.map((_,i)=>(
                <div key={i} style={{ flex:1, height:'2px', borderRadius:'1px', background: i<idx?CHAKRA_PROMPTS[i].color : i===idx&&loading?`${CHAKRA_PROMPTS[i].color}55`:'rgba(255,255,255,.08)', transition:'background .3s' }} />
              ))}
            </div>
            {/* Current + completed */}
            <div style={{ flex:1, overflow:'auto', padding:'8px 20px 16px', display:'flex', flexDirection:'column', gap:'12px' }}>
              {forms.map((f,i)=>(
                <div key={i} style={{ padding:'14px 16px', borderRadius:'14px', background:`${f.color}0C`, border:`1px solid ${f.color}25`, animation:'emerge .5s ease' }}>
                  <p style={{ fontSize:'9px', letterSpacing:'.22em', color:`${f.color}80`, textTransform:'uppercase', marginBottom:'6px' }}>{f.chakra}</p>
                  <p style={{ ...T.italic(15,.75), lineHeight:1.65 }}>{f.text}</p>
                </div>
              ))}
              {loading && (
                <div style={{ padding:'14px 16px', borderRadius:'14px', background:`${CHAKRA_PROMPTS[idx].color}08`, border:`1px solid ${CHAKRA_PROMPTS[idx].color}20` }}>
                  <p style={{ fontSize:'9px', letterSpacing:'.22em', color:`${CHAKRA_PROMPTS[idx].color}60`, textTransform:'uppercase', marginBottom:'6px' }}>{CHAKRA_PROMPTS[idx].chakra}</p>
                  <p style={{ ...T.italic(15,.35) }}>receiving…</p>
                </div>
              )}
            </div>
          </div>
        )}

        {phase === 'complete' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column' }}>
            <div style={{ padding:'12px 20px 4px', flexShrink:0, textAlign:'center' }}>
              <p style={{ ...T.sacred(20,.55) }}>"{word}"</p>
              <p style={{ ...T.label(9,.30), marginTop:'2px' }}>through seven transformations</p>
            </div>
            <div style={{ flex:1, overflow:'auto', padding:'6px 20px 20px', display:'flex', flexDirection:'column', gap:'10px' }}>
              {forms.map((f,i)=>(
                <div key={i} style={{ padding:'12px 14px', borderRadius:'12px', background:`${f.color}0A`, border:`1px solid ${f.color}22` }}>
                  <p style={{ fontSize:'9px', letterSpacing:'.22em', color:`${f.color}75`, textTransform:'uppercase', marginBottom:'4px' }}>{f.chakra}</p>
                  <p style={{ ...T.italic(14,.72), lineHeight:1.6 }}>{f.text}</p>
                </div>
              ))}
              <button onClick={() => { setPhase('input'); setWord(''); setForms([]); }} style={{ marginTop:'8px', padding:'10px 24px', borderRadius:'22px', cursor:'pointer', background:`${game.color}18`, border:`1px solid ${game.color}40`, fontFamily:"'Cormorant Garamond',serif", fontSize:'14px', color:'rgba(240,232,220,.70)', letterSpacing:'.15em', textTransform:'uppercase', alignSelf:'center' }}>New word</button>
            </div>
          </div>
        )}
      </div>
    </GShell>
  );
}

// ─── THE LETTER ───────────────────────────────────────────────────────────────
const LETTER_KEY = 'game_letter_v1';

function GLetter({ game, onReturn }) {
  const stored = (() => { try { return JSON.parse(localStorage.getItem(LETTER_KEY)); } catch { return null; } })();
  const [phase, setPhase] = useSt2(() => {
    if (!stored) return 'write';
    if (stored.fate === 'bury') return 'write'; // can write a new one
    if (stored.fate === 'seal') {
      const daysLeft = (stored.openAt - Date.now()) / 86400000;
      return daysLeft <= 0 ? 'open' : 'sealed';
    }
    return 'write';
  });
  const [text, setText] = useSt2('');
  const [revealIdx, setRevealIdx] = useSt2(0);
  const daysLeft = stored?.openAt ? Math.ceil((stored.openAt - Date.now()) / 86400000) : 0;
  const letterWords = stored?.text?.split(' ') || [];

  function choose(fate) {
    if (fate === 'burn') {
      localStorage.removeItem(LETTER_KEY);
      setPhase('burned');
      return;
    }
    if (fate === 'bury') {
      localStorage.setItem(LETTER_KEY, JSON.stringify({ text, fate:'bury', savedAt: Date.now() }));
      setPhase('buried');
      return;
    }
    if (fate === 'seal') {
      localStorage.setItem(LETTER_KEY, JSON.stringify({ text, fate:'seal', savedAt: Date.now(), openAt: Date.now() + 30*86400000 }));
      setPhase('sealed');
      return;
    }
  }

  // Reveal words one by one
  useEf2(() => {
    if (phase !== 'open') return;
    if (revealIdx >= letterWords.length) return;
    const t = setTimeout(() => setRevealIdx(i=>i+1), 280);
    return () => clearTimeout(t);
  }, [revealIdx, phase]);

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={55} opacity={.26} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column' }}>

        {phase === 'write' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', padding:'8px 20px 16px', gap:'12px' }}>
            <p style={{ ...T.italic(17,.50), textAlign:'center', flexShrink:0 }}>Write a letter you've never sent.</p>
            <textarea value={text} onChange={e=>setText(e.target.value)} placeholder="Dear…" rows={8}
              style={{ flex:1, background:`${game.color}0A`, border:`1px solid ${game.color}28`, borderRadius:'14px', padding:'16px', color:'rgba(240,232,220,.88)', fontFamily:"'Cormorant Garamond',serif", fontSize:'18px', lineHeight:1.7, resize:'none' }} />
            {text.trim().length > 20 && (
              <div style={{ display:'flex', gap:'10px', justifyContent:'center', flexShrink:0, animation:'emerge .4s ease' }}>
                {[['Bury','bury'],['Burn','burn'],['Seal · 30 days','seal']].map(([label,fate])=>(
                  <button key={fate} onClick={()=>choose(fate)} style={{ padding:'9px 14px', borderRadius:'20px', background:'none', border:`1px solid ${game.color}${fate==='seal'?'60':'35'}`, fontFamily:"'Cormorant Garamond',serif", fontSize:'13px', color:`rgba(240,232,220,${fate==='seal'?.80:.55})`, cursor:'pointer', letterSpacing:'.08em' }}>{label}</button>
                ))}
              </div>
            )}
          </div>
        )}

        {phase === 'sealed' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'20px', padding:'40px', textAlign:'center', animation:'emerge .7s ease' }}>
            <div style={{ width:'80px', height:'100px', borderRadius:'4px 4px 0 0', background:`${game.color}18`, border:`1px solid ${game.color}40`, display:'flex', alignItems:'center', justifyContent:'center' }}>
              <p style={{ ...T.label(10,.50) }}>sealed</p>
            </div>
            <p style={{ ...T.sacred(20,.75) }}>Sealed for {daysLeft} day{daysLeft!==1?'s':''}.</p>
            <p style={{ ...T.italic(15,.38), maxWidth:'220px' }}>Return when it opens.</p>
          </div>
        )}

        {phase === 'open' && (
          <div style={{ flex:1, overflow:'auto', padding:'20px 28px', animation:'fade-in .8s ease' }}>
            <p style={{ ...T.label(9,.40), marginBottom:'16px', textAlign:'center' }}>Your letter. {Math.round((Date.now()-stored.savedAt)/86400000)} days ago.</p>
            <p style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'18px', lineHeight:1.75, color:'rgba(240,232,220,.82)' }}>
              {letterWords.slice(0, revealIdx).join(' ')}
              <span style={{ opacity:.3 }}>
                {revealIdx < letterWords.length ? ' ' + letterWords.slice(revealIdx).join(' ') : ''}
              </span>
            </p>
            {revealIdx >= letterWords.length && (
              <button onClick={() => { localStorage.removeItem(LETTER_KEY); setPhase('write'); setText(''); }} style={{ marginTop:'24px', padding:'10px 24px', borderRadius:'22px', cursor:'pointer', background:`${game.color}18`, border:`1px solid ${game.color}40`, fontFamily:"'Cormorant Garamond',serif", fontSize:'14px', color:'rgba(240,232,220,.70)', letterSpacing:'.1em', textTransform:'uppercase' }}>Write again</button>
            )}
          </div>
        )}

        {phase === 'buried' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'16px', padding:'40px', textAlign:'center', animation:'emerge .7s ease' }}>
            <p style={{ ...T.sacred(22,.75) }}>Buried.</p>
            <p style={{ ...T.italic(16,.40), maxWidth:'220px' }}>It will return to the earth.</p>
            <Btn onClick={() => { setPhase('write'); setText(''); }} color={game.color} accent={game.accent}>Write another</Btn>
          </div>
        )}

        {phase === 'burned' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', gap:'16px', padding:'40px', textAlign:'center', animation:'emerge .7s ease' }}>
            <p style={{ ...T.sacred(22,.75) }}>Released.</p>
            <p style={{ ...T.italic(16,.40), maxWidth:'220px' }}>The fire received it.</p>
            <Btn onClick={() => { setPhase('write'); setText(''); }} color={game.color} accent={game.accent}>Write another</Btn>
          </div>
        )}
      </div>
    </GShell>
  );
}

// ─── SHADOW TRANSLATOR ────────────────────────────────────────────────────────
function GShadowT({ game, onReturn }) {
  const [phase, setPhase] = useSt2('input');
  const [burden, setBurden] = useSt2('');
  const [gift, setGift]     = useSt2('');
  const [loading, setLoading] = useSt2(false);

  async function translate() {
    if (!burden.trim()) return;
    setLoading(true); setPhase('loading');
    try {
      const resp = await window.claude.complete({
        messages: [{ role:'user', content:`A person has described something they carry as a burden, in its most negative terms: "${burden.trim()}". Your task: translate this into its positive capacity — what strength, gift, or wisdom is encoded in this very thing they find difficult? Do not minimize the difficulty. Do not offer advice. Simply name what this burden IS when seen as capacity. 3 sentences maximum. Begin with the burden's gift, not an acknowledgment of what was said.` }]
      });
      setGift(resp);
    } catch {
      setGift('What you named is real. And it is also the outline of something that has not yet found its full expression. The burden is the gift, waiting for a container large enough to hold it.');
    }
    setLoading(false); setPhase('revealed');
  }

  return (
    <GShell game={game} onReturn={onReturn}>
      <Starfield count={50} opacity={.26} />
      <div style={{ position:'relative', zIndex:2, height:'100%', display:'flex', flexDirection:'column', padding:'8px 22px 20px', gap:'14px' }}>

        {(phase === 'input' || phase === 'loading') && (
          <>
            <p style={{ ...T.italic(17,.52), textAlign:'center', flexShrink:0 }}>Name something you carry<br/>in its most difficult form.</p>
            <textarea value={burden} onChange={e=>setBurden(e.target.value)}
              disabled={phase==='loading'}
              placeholder="My _____ is …"
              rows={5} style={{ flex:1, background:`${game.color}0A`, border:`1px solid ${game.color}28`, borderRadius:'14px', padding:'16px', color:'rgba(240,232,220,.88)', fontFamily:"'Cormorant Garamond',serif", fontSize:'19px', lineHeight:1.7, resize:'none' }} />
            {burden.trim().length > 8 && phase === 'input' && (
              <Btn onClick={translate} color={game.color} accent={game.accent} style={{ alignSelf:'center', animation:'emerge .4s ease' }}>Translate</Btn>
            )}
            {phase === 'loading' && (
              <p style={{ ...T.italic(15,.38), textAlign:'center', animation:'fade-in .5s ease' }}>the translation is arriving…</p>
            )}
          </>
        )}

        {phase === 'revealed' && (
          <div style={{ flex:1, display:'flex', flexDirection:'column', gap:'20px', animation:'emerge .8s ease' }}>
            {/* Original - small, above */}
            <div style={{ padding:'12px 16px', borderRadius:'12px', background:'rgba(255,255,255,.04)', border:'1px solid rgba(255,255,255,.08)' }}>
              <p style={{ ...T.label(8,.28), marginBottom:'4px' }}>What you named</p>
              <p style={{ ...T.italic(14,.45), lineHeight:1.6 }}>{burden}</p>
            </div>
            {/* Mirror separator */}
            <div style={{ display:'flex', alignItems:'center', gap:'10px' }}>
              <div style={{ flex:1, height:'1px', background:`${game.color}30` }} />
              <p style={{ ...T.label(9,.40) }}>↓</p>
              <div style={{ flex:1, height:'1px', background:`${game.color}30` }} />
            </div>
            {/* Translation - large, below */}
            <div style={{ padding:'16px 18px', borderRadius:'14px', background:`${game.color}10`, border:`1px solid ${game.color}35`, flex:1 }}>
              <p style={{ ...T.label(8,.40), marginBottom:'8px' }}>The gift</p>
              <p style={{ fontFamily:"'Cormorant Garamond',serif", fontSize:'19px', color:'rgba(240,232,220,.85)', lineHeight:1.75 }}>{gift}</p>
            </div>
            <button onClick={() => { setPhase('input'); setBurden(''); setGift(''); }} style={{ padding:'9px 22px', borderRadius:'20px', cursor:'pointer', background:'none', border:`1px solid ${game.color}35`, fontFamily:"'Cormorant Garamond',serif", fontSize:'14px', color:'rgba(240,232,220,.65)', letterSpacing:'.12em', textTransform:'uppercase', alignSelf:'center' }}>Again</button>
          </div>
        )}
      </div>
    </GShell>
  );
}

Object.assign(window, { GMirror, GLetter, GShadowT });
