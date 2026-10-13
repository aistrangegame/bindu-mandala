# Memory and the Well — two worlds, designed in full (stage 2)

Slices read in full: `index/by-world/memory.jsonl` (461 rows) and `index/by-world/well.jsonl` (191 rows; 55 shared with memory) — 597 distinct index ids. Thin rows were opened at their register sources (07-codex C-1101, C-1126, C-1253, C-1346, C-1348, 07:1280-1295; 04 frames list F01–F40; 16-airtable-asg:134, 194, 294) and at the code (`PortraitMandalaView.swift:400-440`, `RecognitionLogStore.swift`, `AirtableService.swift:700-760, 280-290`, `CorrespondenceStore.swift:24-34`, `ShaktiDetailView.swift:1110-1150`).

**No Design frame (F01–F40) exists for Memory or the Well** (04-briefs-audits-frames.md, "Gaps in the picture list": the Field, the Well, the Portrait). The Design floor for both worlds is therefore Design's prototypes with numbers: Living Rite `The Memory` + `The Well` (register 02:937-1002), the Memory Layer MEM-1…MEM-7 (03:693-743), Smṛti / Pūjā (03:662-684), and the rupakarshini/padakarshini studio shapes (12, 13). F14 is the reference for the Recognition lines that hand off into Memory. In the ledger, `reference_frame` names the prototype (e.g. `DES-02 L-23 Memory`, `DES-03 MEM-5`) where no F-frame exists.

The two worlds sit on one ground: **what he has walked, returned as light** (Memory) and **what he has said, held under the water** (the Well). Memory is above ground and in day; the Well is beneath the floor and at night. They share one reader of his record (§1.3, M1) and one book (M22).

---

## 1 · The worlds

### 1.1 Memory — in his words and Design's

- Design (03:693, memory.jsx header): *"Every recognition leaves a luminous trace. Over time, the yantra becomes a portrait of your consciousness. The instrument starts to mirror you."* Five dimensions (03:101-109): *"Memory (accumulation) — Every recognition leaves a luminous trace. Over months and years, the yantra becomes uniquely yours — bright where you have met her, mystery where you haven't."*
- Living Rite (02:977-991): header **The Memory**, sub *"your face in the instrument"*, footer *"she is felt, not measured"*.
- Direction II (02:1290): *"Your own Śrī Yantra, beginning nearly dark, filling in petal by petal, triangle by triangle… warmer where you've been recently, dim where you have not yet walked."*
- His Codex: C-1348 *"the realization is that there is no gap to fill. It's always been complete"* (the year keeps its gaps as space); C-1108 *"if I zoom out … weeks, months, years, then I might be able to see like a pattern"* (zoomable time); C-1262 *"after the cycle ends … we go back, we review our cycle"*; C-1321 *"when we look at that whole thing, then something else will emerge out of that pattern"*; C-1007 *"You write your own story and you don't want to write the story against yourself."*; C-1300 *"the less information they give, the less feedback it gives back … The more information they give, the more information it gives back"*; C-1135 *"the front forms the individual Atman's essence … the back forms like a part of the whole"*.
- The law that governs it (rupakarshini "Count in Private", 12:787): *"Memory is allowed to know. The screen is not allowed to tell."* Site law 8 (14:75): *"What a phone remembers lights things; it never opens or closes anything."*

**The law of light (settled here, §7 C1).** Every instrument in Memory encodes only **whether** (met / offered / walked), **when** (recency warmth, age patina, a day's place on a ring, a span between two dates) and **his own chosen acts** (a crossing he held, a stroke he drew, a word he left). **Never how often, never how much.** No light is scaled by a tally. This replaces `PortraitStats.intensity = min(1, count/12)` (PortraitMandalaView.swift:414), Design's `min(1,total/80)` (03 MEM-1) and Living Rite's `min(1,n/7)` (02:991) with one rule, the same rule the Mandala already follows ("whether, never how often", MandalaCanvasLayer.swift:480-494, G7-0038).

### 1.2 The Well — in his words and Design's

- Living Rite (02:957-975): **The Well** — *"speak to her directly · she is listening"*; editor placeholder *"Speak to her directly. She is listening."*
- C-1346 (07:965): *"communicate with your past self by sending letters to your past … to any moment, any particular memory, any particular time, any particular age"*; *"send messages to the future … set them to like a particular time"*; reading *"in the text format … Or … a slow release format … a word-by-word reveal, because … by the time when we are reading the message … the memory has sort of gone"*; *"It's like a design has been created for us, and we're getting to experience it."*
- C-1126 (07:300): *"I start sending energy backwards in time to those moments where you felt lost … to help complete the loop. Complete the cycle."* C-1253: *"we have the ability to readjust our past … Through that sending gratitude, asking for help."*
- Floors (04 BC-12, FB-15): *"her voice is authored, never generated; the Well is his alone"*; *"Never auto-generate. Never seed. Never suggest phrases."*
- S15 recognition (12:559): *"I am under the floor now; nothing here is asked of me but to look."*

### 1.3 The one reader both worlds stand on — the merged record (M1)

Memory and the Well **read the device record merged with the App Activity ledger**, so a new phone is never empty (defect today: Smṛti, Svapna, Pūjā and the Portrait read only on-phone `RecognitionEntry`, 21-code-layers:159; Her Moments already merges, ShaktiDetailView.swift:1110-1150).

`MemoryRecord` (new service, `Services/MemoryRecord.swift`), built from what exists:
1. **Pages App Activity** (`tblJlBeiHnqGpYrL7`) with `AirtableService.fetchPage` (reuse the paging already in `fetchRecognitions`, AirtableService.swift:710-747, 100 a page) for Source App ∈ {Mandala, Feed, Learning, Field, Being, Chakras, Mirror, Site}; reads Activity Type, Felt At, Activity Date, Link to Mandala, Link to The Map, Notes, Detail, Excerpt, Duration, Descent Ring, Moon Phase, Lunar Day, Gesture Source, Voice, Client Write Id.
2. **Reads every local store**: `RecognitionEntry` (RecognitionLogStore), `CorrespondenceStore` ('correspondence'), `PortraitStrokeStore` ('portrait-strokes'), `PlayTraceStore`/`PlayGardenStore`, `MarginNoteStore`, `CodexNoteStore`, `BinduMemory`, `ShaktiLetter`, `DescentState`, `HomeMemoryStore`.
3. **Merges** into one time-ordered list of `Act {kind, kp?, chakra?, ring?, at, words?, source}`; dedup by Client Write Id first, then (kind, kp, Felt At within ±2 s); a ledger milestone beside its migrated twin is one act (existing `ActivityLedger.momentRows`).
4. **Caches** the merged list as a read mirror (rebuildable, never a second ledger; App Activity stays the single ledger).
5. **Restores on an empty phone** (practice data never lost): river letters from their ledger stamps (CorrespondenceStore 'merge restores' already exists); her letters from the Mandala table `Letter fldgASyV031Hr4sHp` (seed-back exists); strokes from the `Portrait Drawn` row's **Detail** (new: the stroke's ≤256 unit points serialised there — no new field); HomeMemory dwell from `First Dwelling` / Duration rows (new restore — today HomeMemory is phone-only by R17, 04:566).
6. **Never writes on read**; reads are offline-safe (local shown first, ledger merged in when it arrives, no spinner, no banner).

---

### 1.4 Memory — the full experience

**Arriving.** From the Bindu (Home) Memory is a door along the menu constellation; from Recognition it is the settle; from Today a line; from any Śakti's seat a long-press "her memory". The crossing travels through the point: the touched point blooms in Memory's colour (dusk ground `#1C1812` → `#211E19` → `#2B261F`, radial 130% 100% at 50% 18%) over 0.9 s, then (C-1348) *"a dark screen … a white dot … keeps on growing … and then the picture really forms around it"*: the bindu (r 10, red radial + cream core r 3.5) grows from 0 to full in 1.2 s and the Portrait's faint rings draw outward from it (0.6 s, ring by ring 9 → 1, 60 ms apart). Sound: the bindu strikes the Ring 9 root of Design's one tuning, gain 0.03, decaying 2.4 s.

**Being there — the Portrait (home of the world).** A 330 pt living Śrī Yantra on the dusk ground (Design 02:977-991, built PortraitMandalaView): faint ring circles rgba(242,232,217,.05) .5 px at ring radii base [158,123,95,78,65,52,40,26,0]/172 (LivingMandala.swift:20-21) with **ring 1's 28 seats on the Bhūpura square, as in the Mandala** (fix of the circle/square split, ModeField.swift:18 vs PortraitMandalaView:449-462); ring-2 lotus petals (oR 134 iR 112 hw 22); four faint triangles 90/70/50/32; 102 seats.

*Seat light (the fix):*
- Unmet: dot r 1.5, rgba(242,232,217,.14).
- Met (any `Shakti Recognized` act, merged): white core r 1.6 (whether) + halo whose **brightness is recency only**: `warmth = 0.25 + 0.75·e^(−d/21)` (d = days since she was last felt; the PlayTraceStore formula, already the "cools to an ember, never zero" rule); halo r 4 + 6·warmth, opacity .12 + .16·warmth; dot opacity .70 + .30·warmth.
- **Colour is age** (patina, G5-0064): `a = (daysSinceFirstMet/1095)^0.55` clamped; colour mixes bone rgb(228,220,205) → amber rgb(208,158,72) → deep gold rgb(164,112,38). A relationship of three years is deep gold; one of a week is bone. Time, never tally.
- **Breath is her status, the crossing he chose** (Design 03:695): embodied 4.5 s, active 6 s, exploring 8 s, mapped 11 s (sine on halo radius ±6%). The Portrait "does not breathe" today (:778) — this adds it.
- No numeral anywhere on the canvas, no per-seat count ring (Design's r148 count is dropped).

*Living layers (built, kept):* his strokes mirrored n-fold by the ring begun in [28,16,8,14,10,10,12,3,1], colour = ring hue lifted s+10 l≥58; the year ring (one bead per practised day at angle 2π·doy/365 − π/2, r .977, glow 4.5, core 1.4; missed days are space, C-1348); play layers (root web 9 roots, practice wheel a spoke per game r .30-.37, body petals 7 on the axis, seed bloom 8 green petals, bead ring 102 at r .945) warming by `.25 + .75·e^(−d/21)`; the sealed lid — the bindu's eye closes while any river letter is sealed.

*Settle (arriving from Recognition):* 3,400 ms, 30 ms ticks: 0–.34 her gold point flies from the bindu to her seat (ease-out cubic) trailing a fading gold line, head r 4.6 → 3.4 with 14 pt aura; .34–1 a halo blooms (r 6 → 36, op .8 → 0) while **a hand-drawn ring settles true around her seat over 4 s** (180 segments, wobble decaying with trueness, G5-0065) and its tone glides from 0.985·root to root (gain 0 → .036 @3.2 s → .020 @6 s → 0 @9 s, + fifth ×1.5 at gain .14 of that). Only `.felt` acts fly (fix: `settleIfRecent` today flies a silence, :384-387).

*Gestures on the Portrait:* tap a seat → Petal Biography (one-camera zoom, z .22 → 34, the seat fanning 20°–160°); long-press 0.9 s → "hold this image" export (built, 1500 px, no branding, no numbers); pinch out → the Sky (zoom ladder up); pinch in on the bindu → the Book; two-finger rotate → turns the Portrait to its back (the two faces, M24); draw with one finger held still 0.4 s → stroke capture (built StrokeCaptureLayer, StillnessSensor).

**Going deeper — the instruments, each its own room reached from the Portrait, never stacked on it.**
1. **Petal Biography** (tap a seat): her name 36 pt, cluster dot, breath of her status; *her biography with you* as **places in time, not stats**: "first met · {month year}" (a date), "most recently · {today | yesterday | Mon D}" (a date), and **MOMENTS SHE WAS HERE** — his notes verbatim, newest first, each 'she was felt here · {when}' + moon-phase name (built rows of Her Moments, 02:937-939), merged. Dropped: total, peak month, longest gap, days walked. Doors: '‹ Portrait', *who carries her* (Relationship Field's Shakti's Carriers), her room (Her Home), her letter (the Well).
2. **Threshold Timeline**: a .5 px gold spine at x 38; one 12 pt node per crossing he made (mapped → exploring → active → embodied) with the date and, if he left one, his word at that crossing (italic 14); name 18 italic; from → to 9 pt. Reads the new `Threshold Crossed` act (§4). Design's sample notes are never shipped.
3. **Cluster Garden**: five lineage cards (gradient {colour}10 → transparent, border {colour}28, radius 10), each a 64 pt mini-fragment, one tiny petal per Śakti lit by the seat-light rule above; footer *"each cluster is a lineage in you. / some have bloomed. others are still seed."* No meter, no %, no totals.
4. **Density Atlas**: trailing year 9 months × 31 cells (16 pt, gap 2) and lifetime years × 12 months (24 pt, gap 4). A day cell is **lit if practised** (binary), its colour the blend of that day's act kinds (felt gold `#C9963F`, silence indigo, letter ember `#DA3B12`, play green, stroke the ring hue); a month cell in the lifetime view is a 31-bead arc lit per practised day. Tap a day → that day's glyph (zoom ladder); tap a month → the Month Mirror. Words: *"the shape of your practice" / "your rhythm has texture. / read it like a season."*; lifetime *"the shape of all your years"*. Dropped: "five years walked".
5. **First Word · Last Word**: a row per Śakti ever met, oldest first; 16 pt track; span line from her first-met date to her last-felt date on a FIRST MET … TODAY axis; start dot 6 pt; end dot glows if last < 7 days else .45. Footer *"some relationships are old. / some are weeks old. all of them are yours."* No totals.
6. **Lifetime Spiral**: bindu r 18 accentRed + cream r 6 (*"the seed, present from year 0"*); one ring per year of practice r = 30 + 24·yi; each ring is that year's bead ring (one bead per practised day, the built YearRingLayer, re-used per year); 16 radial marks per ring in cluster colours lit by whether any of that cluster was met that year. Inner band: his foundation days (Self Timeline rows, §7 Q2). Tap a ring → that year's Portrait. Dropped: stats grid.
7. **The Afterline** (G4-0803): in the Lifetime view his road is one gold line ending at today; drag the point past today and it *"goes to what kept going"*: each **sealed forward river letter** is a branch reaching its opening day (five-branch draw .22 s steps); the visions are never drawn — a branch shows only "opens {date}" (no peek).
8. **The Chain** (SILSILA, G4-0809): practised days as lamps on one chain, each lit from the previous; touch the chain and a spark runs the lit length (0.5 + to·.18 s); the last lamp (today) is dashed until something is done today, then solid, glow .28. *"The last lamp on the chain is not lit. / It is yours. Touch the chain."*
9. **Day · Month · Year · Lifetime (the zoom ladder)** (S16 Portrait shape, Pratikramana nesting): pinch out from the Portrait → the Sky; pinch in on a day → the **Day glyph** on a vertical thread (arcs around a dot · an ember · a small constellation) with the day's **six quiet lights** (Being family: gaia `#7A9B6E`, sakshi `#6E8597`, grace `#C2918E`, bindu `#BE5A4E`, hold `#928A7E`, chant `#C3A359`; each lit if that register had an act that day: Silence Held → sakshi, Shakti Recognized → bindu, Played → gaia, Letter → grace, Stroke/Portrait Drawn → hold, Garland Recited/HeartRegister → chant; halo = min(lights) — whether only); a month → **the Month Mirror** (built: day glyphs round a circle, touched rings lit, *"What moved through the month"*, *"The turning"*, MonthSitting *"does this land? · it lands · say more · leave my own word"*); a year → the year ring; the lifetime → the Spiral. A missed day is held inside its fortnight, never a gap or a broken streak.
10. **The Book** (built ArchiveBookView, widened): his own words, oldest first, as a book (paper `#F2EADB`, rotateY −7°, page turn rotateY −180° over 900 ms cubic-bezier(.645,.045,.355,1), dot rail at the edge): readable letters, margin notes ("What you have left"), recognition notes, lights-with-words, Codex notes, words he wrote in the 33's rooms (*"What is the ground made of today?"* answers), kept things from games ("What you chose to keep"). Frontispiece *"the book of {higher-self name}"* (BinduMemory). His words in his colour of the day, her lines in hers (authorship by colour). Pages he lingered on keep embers (≥3.5 / 7 / 14 s → op .5/.72/.92, blur 14/22/32). The exact middle page is a door "go down" (→ Beneath). Last page *"the next page is not written yet"* → *seal it forward* (the Well's river) / *leave my own word in the Codex*.
11. **The Codex shelf** (a library you fall into): his own Codex entries (RAW, or Notes where RAW is empty — his typed 2024-25 entries) as nebulae on a slow spiral (≈11 s per turn); fall into one → its words revealed word by word (250 ms/word, +430 ms after a full stop, +180 ms after a comma). Only his words; the AI summaries in Notes are never shown. "Held. · Seen. · Kept." settles (1.4 s, scale .4 → 1) when he leaves a new word (CodexWrite, Source App 'Bindu Mandala').
12. **The Word's Star sky**: every word he has offered (dance words, post-dance words, standing words, a room's one word) is a star at `wordToPosition(word)` (h = ((h<<5) − h) + c, mapped to 0.15–0.85): **the same word on another day is the same star in the same place** (cross.html:2298-2348). Star alpha by age only: `max(.08, .4/(1 + ageMonths·.5))`, twinkle sin(t·.3 + i); colour = the chakra's Map hex where the word was given (Map colours win over CHAKRA_HUES); standing words as a quartet cluster (mind/body/spirit/now in a 0.014 ring), pale silver; body points he tapped in the rooms (safety, desire…) as soft points; the **reach-history thread** — one never-fading path through the 33 in the order he walked them (quadratic, sampled per room). Tap a star → the word, the room, the date.
13. **The Sky of every page** (golden angle): everything met, walked, played, written as a star on a golden-angle disc (star i at i·137.508°, radius c·√i), kinds as colours (Śaktis gold, chakras by Map hex, games green, letters ember, walks walked-gold `#F9E3A7`, sister-app acts in their app's light: Feed, Learning, Site); unmet stars rgba(200,200,210,.25); motes orbit met stars; places he dwelt ≥2.5 s become ember stars. Three rim ways in (the Portrait, the Word's Star, the Walks) joined by dotted threads. Tap a star → fall into its record (approach 1−seg(.16,.34) · gathering · strata seg(.44,.66) · mouth seg(.84,.96)), the act read back in the ledger's own vocabulary (*"Fell inward to the Bindu"*, *"Dwelt past the first adaptation"*, *"She appeared"*).
14. **The Walks sky** (read-only echo of Lalita Family's Mirror walks): 110 background stars at 3 depths, a shooting star ≈ every 14 s; the 20 walks as stars placed by Sort Order ("position in the sky"), coloured hsl(Hue, 45%, 62%), drawn with their figure glyph (machine, stick, beam, river, three, doubling, ledger, chamber, vessel, threshold, flame); a walked walk glows oklch(.92 .08 90) and breathes 3.2–6.2 s. **Long-press** a walk star: its figure draws only while held; a 110 Hz carrier / 3.5 Hz beat rises gain .02 → .06 over .9 s (only while holding); the **Vow You** shows, then after 2 s of holding it carves to the **Vow I** (debossed, the carve). Release → star settles. Zoom ×7 over 1.15 s to enter; exit flood 1.4 s. No person ever attached (table law).
15. **The residue map** (G4-0324): when the 33's rooms keep their spatial grids (25×35), Memory lays all 33 residues together, each in its room's map colour, as one field of footprints, warmth, fracture, echo and burn — whether a place was touched, never how often.
16. **The Arc** (G5-0601): an invitation, never auto-launched: a breathing heart and *"See where you are in the constellation of love"*; on tap, 12 nodes on a circle (radius 250 of a 700 field) appear one by one, 5 s each (~62 s), lines drawing by dashoffset .8 s; captions Cinzel 14 gold / Crimson 17 cream; at the end his higher-self name at the centre and five of his words orbiting at 70 pt, 72° apart, one turn per 120 s; an 80 pt ring breathing 0.25 Hz.
17. **The garden under the real sky** (World in a Box): sun and moon by the real hour (Ephemeris), petals/fireflies/leaves/snow by ṛtu; one plant per session he played, a firefly per **game kind** played (whether, not per 36 beads); a daily gift (pebble, feather, acorn, marble, button, ribbon, key, shell) that arrives while he is away (PlayGardenStore `worldVisitedAt`); each object sounds when touched (its ring root).
18. **The descent, remembered** (built DescentFilmView): one frame per ring crossed (RingGlyph 96 gold, Sanskrit name, *"the way opened · {date}"*), 4.5 s a frame, tap advances; ring 1 *"the ground"*, ring 2 *"home"* — with dates now read from the merged crossings (fix: today dates assume ring = 3 + i, :35-38).
19. **The two faces** (C-1135): rotating the Portrait (two-finger twist past 90°, 900 ms flip) shows its back: the whole Śrī Yantra with **all 102 seats lit alike** and his bindu as one point among them — *the part of the whole*. Rotate back → his face.
20. **The Record** (keep): the Portrait with every layer, the year rings and the dated list of his own words *"newest first, back to where you began"* on one A4 candle sheet (wide-tracked caps, hairlines with a centre dot) and a PNG; the *mandala of your record* (a ring of 365 day-segments turning 0.00055 rad/frame, practised days lit, today white → 102 beads → strokes ×8 → body marks as petals → centre state; *"The record is open."* when empty; **no numbers printed on it**). *Carry your road*: his App Activity rows (Source App Mandala) exported as a dated file through ShareLink — his own record, given only when he asks (BC-13).
21. **Keep or release**: *forget me* (a 2.3 s hold of his mark, G31) lets the **display memory** go — head starts, floor traces, warmth — and never touches the ledger, his words, letters or strokes (§7 C6).

**Sound of Memory.** No song and no drone in Memory (a song's drone plays only during its dance). Memory's fixed tone is **the ring roots of Design's one tuning**: a seat tapped sounds her ring root once (gain .02, 1.7 s bell envelope — lrRingChime's voice); the settle ring glides into tune (above); the Walks drone only while held. Chimes opt-in, default off (DESIGN_SPEC §2.7).

**Visual language.** Being chassis, dusk (G5-0524): ground `#1C1812/#211E19/#2B261F`, ink `#F4EFE6`, ink-2 `#9E9991`, sage `#7C8F6E`, spark Bindu `#BE5A4E`, breath 8 s; Fraunces + Spectral at the crossing, the house Cormorant inside the Portrait; the Record on the candle sheet; Mandala/Map colours win where they conflict (gold `#C9963F`, accentBright, cluster colours, Map chakra hexes).

**Leaving.** Touch the point (always top-centre, 44 pt) → home through the point; or the menu constellation; or a door (her room, the Well, Time's Great Wheel, the Relationship Field's carriers). Back returns to exactly the instrument and zoom he left (stored per world).

### 1.5 The Well — the full experience

**Arriving (going down).** From Home the Well is a **dark tile** on the paper of the world (`#0A0806 → #14100A`, the river's seven strands faint inside it). First time, and at true thresholds: **the Descent** — 2.35 s cubic-bezier(.66,0,.24,1): the paper plane lifts (0 → hold 9% → −104% @55%), a dark plane wells up (radial 120% 90% at 50% 46%, `#14100A`, `#0A0806` 55%, `#060402`) with an ember horizon (rgba(243,176,90,.16) 0 → rgba(218,59,18,.05) 5% → transparent 13%); an 11 pt ember appears (op 0 → 1 @13%, scale .45 → 1 @13% → 1.18 @55% → 1 @76% → .7); a ~4% band between the planes shows the real destination; tone 110 + 110 (+6 ¢) + 164.81 Hz peaking ≈ 0.8 s, gone by 1.25 s; haptic (intensity .9, sharpness .15) at 55%. Afterwards: the dark veil, 1.5 s.

Then **the door that resists** (S15): a slit of accent light; hold ≈ 1.25 s (release early and it refuses, a soft back-push of 6 pt); the typeface changes at the crossing (Newsreader 300 italic, *"ONLY under the floor"*). Then **the breathing ring** (Lemuria): warmth blooms from the void over 2.5 s, a ring breathes on a 4 s cycle with filtered-white-noise breath (*"No pitched tone. Pure air."*), collapses smoothly (height to 0), 2.8 s gap, and one seed line arrives word by word at 200 ms a word (a seed of the day, verbatim, e.g. *"What is trying to say itself through you?"*).

**Being there — the water.** Ground `#0E0C14 → #07060C` (Lalita *under*), surface `#07060C`, ink-2 `#B9B2C9`, muted `#8D86A0`, voice oklch(.62 .09 300); tempo 1,200 ms for every transition. A **NOW hairline** crosses the water at 48% height: letters forward float above it, letters back below. Seven blue current strands drift at alpha .05 (built RiverCurrent) — **the river is the floor of the Well**. A pink-noise floor (7-coefficient, LP 4 kHz, gain .015) is the water's sound. A 320 pt warm glow rgba(245,226,214,.055) follows his finger while he touches (lerp .12). Idle 20 s → the point wanders on the water (sum-of-sines path, 9 pt, halo 3.2–4 s); it cannot be caught — *"presence, not target"*. Wake lock while any reading or still phase runs.

Wave tiers (from Time's wave sheet, as the river's light, never a song): *the deep* (gradient down from 55%), *tidal pull* (3 bands at 82–90%), *water-marks* (a faint ring left where a letter entered, 10 s), *the wave-archive* — when he enters the river view, every letter he has ever set in it appears for one breath as a foam mark along the shore, then settles: *"Every wave you have offered has reached this shore."*

**Doors on the water** (each a serif line beside a 1 px slit of accent light, appearing one breath apart; the set changes with the time of day; walked doors dim): *her letters* · *the river* · *send light back* · *the glass* · *one sentence* · *sit at the water* · *your own words* · *go further down* (→ Beneath).

**Her letters (the 102).** The yantra is reflected on the water: 102 points on its rings; a point she has been written to glows (*"your words live here"*); ring order for the reflection [2,1,3…9] (built). Tap a point → her letter. Built LetterEditorView: atmosphere-lit by her colour and the time; **the writing screen lit by his colour of the day** (wash brightens while held); the prompt *"Speak to her directly. She is listening."* sits above the page and recedes to .45 opacity once there are words; no box (1 px rule, 1 px cursor 1 s steps); autosave every 2 s and on `.inactive`, only when dirty (LetterDraft.isDirty — viewing never writes); *speak it* (G46: press once, 'saved' lights at once, transcript solidifies ~90 ms/word +260 ms at punctuation, listening ember 15 pt with hairline rings at 3.4/4.3/5.6 s, on-device SFSpeech; his voice file kept forever, never generated). Releasing her letter: a 2.3 s hold of his mark (armed only when there are words) → the card settles in her light → one line *"The room has changed."* → her room in Her Home shows the letter folded (Her Home reads it).

**The river (C-1346).** Composer: *to* — her (any of 102), *myself at {age, spelled}* (0–120), *a memory*, *my past self*, *my later self* (allowed directions per recipient, built). Back letters are readable at once and float below NOW. Forward letters are **sealed to a day**: her next day (the 6 am turn of the 102, DailyEnergyService), Pūrṇimā (tithi 15 begins at elongation 168°), Amāvasyā, this tithi returns, **tomorrow, a week, a season (the next ṛtu)**, or a date — all open at local midnight of their civil date (new: tomorrow/week/season/date). Before sending: *one breath* — a 2.4 s breath ring; then the wax: he **drags the seal onto the letter** (G27) and it folds (900 ms, scaleY .2, translateY −60) with a settle tone; *"A letter waits. It opens {date}."* No words → nothing sealed. There is no peek (built, :512). His own voice may be the letter (voice letter, built).

**A letter opens (the two blooms).** On its day the sealed letter's light rises to NOW: *"A letter is ready. Open it."* Opening is held: **bloom 1** — the seal melts (1.4 s, ember); **the held centre** — 21 s of near-silence where the river stills (Karishma freeze: current strands stop, pink noise holds), a 50 bpm heartbeat felt as haptic [30] and seen as a 1.2 s pulse (rise 100 ms, fall 500 ms, hue 345); any touch during it resets nothing and costs nothing (don't-engage: he may simply rest); a designed pass-through: a 110 Hz carrier with 7.83 Hz beat inside the silence (gain .02, designed:true), ending at 4.0 Hz; **bloom 2** — the words, revealed word by word **only while he holds** (hold to read, G1; ≈250 ms a word, +430 ms after a full stop, +180 ms after a comma, each word blur 4 → 0; per-word haptic .3 skipped under 90 ms; release pauses). After the last word the carrier alone holds 8 s at gain .04, then fades. Read again later: whole text at once, or slow — his choice. The page has yellowed with the real days it waited (patina `1 − e^(−days/240)`, tint (0.62,0.46,0.20)).

**Light sent back (C-1126).** Built SendLightBackView: choose a moment (a day on the Chain, a past age), choose her light, add words if he wishes, hold 2.4 s → the light travels down the river backward (against the current, 2.4 s) and enters that moment: *"It has gone back. It was always going to arrive."* The moment's lamp on Memory's Chain carries a faint second glow ever after.

**The glass (under the floor).** A chamber where a second-person line is carved into the first person by holding (the carve: line draws by clipping at .85/s; a press of ≈2 s carves *you* → *I*, debossed; Mirror held tone 110 Hz / 3.5 Hz, gain .02 → .06 only while holding; blips 174 · 220 · 196 · 233 · 246.9 Hz at arrival / look / glass / carve / carved; exit 261.6 then 329.6 Hz 0.7 s later). Lines that may be carved (all authored, verbatim): Shadow's *"I see you. I love you. Thank you for showing up. You can rest now."*; Maya's *"I see you. Thank you for the protection. You can be glass now."*; Armin's *"Pick one … imagine — fully, with feeling, in detail — what it would be like if the opposite were true."*; the 20 walks' *Vow You → Vow I* (read-only from Walks). The phrase may assemble out of order (4th, 3rd, 1st, 2nd — the inversion). LOOK: two eyes that blink every 4.5–11 s (scaleY .08, ≈120 ms). One line he carves may stand as his vow: ● *"a vow · arrived"* / ○ *"still living"* (terra `#C47A52` glow), one redraw a day. The Recognition lines are never replaced by vows.

**One sentence.** Single-line entries, private: *"Write one sentence that finishes: I chose this so I could learn _______."* (Incarnation); in the evening *"At the end of today, notice what you're carrying that someone else put down."* (Echo); *thank you, past self* / *I promise, later self* (the shape, authored afresh: two recipients of the river).

**Release into the water** (only by his explicit act): write anything (the brain dump), then hold 2.3 s → the letter **erodes** (Atlantis: characters fall over 10 s, weighted so longer words lose characters first; each falling character opacity .8 s, transform 1.2 s translateY + rotate; haptic 50 ms per character throttled 1 per 200 ms; tone: sine from 68 Hz with overtones 136.1 · 204.15 · 272.2 Hz stripped back to 68 Hz, then silence). The words are not kept; one ledger row *Letter Released* without words (§7 Q1).

**Closing gestures** (optional, after any letter): the four lines to a lineage — *I'm sorry · please forgive me · thank you · I love you* (Ho'oponopono, verbatim tradition) — and the gratitude line, each laid on the water as one light.

**Sit at the water.** A breath before writing, by verb (the Bindu Field breath sessions, verbatim names and one-words): ground *Come Home* (Diaphragmatic 4:8, *Down*), balance *The Even Breath* (Box 5:5:5:5, *Even*), open *The Hum* (Bhramari, *Resonance*), clarify *The Counted Exhale* (Susokukan, *Clear*), activate *The Stoke* (Bhastrika, screened, *Heat*), rest *The Long Release* (4-7-8, *Release*), dissolve *The Empty Pause* (Bahya kumbhaka, *Empty*), expand *The Thinning Breath* (8:4:8, *Wide*), cohere *Home Frequency* (~6 bpm, *Home*), sound *The Ocean Breath* (Ujjayi, *Ocean*), sleep *The Night Protocol* (cyclic sighing, *Sleep*). And one dance: **Ember** (*Sit Around The Fire*, `bindu/still.mp3`), seed *"Sit down. The fire is already lit."* — the song's drone only during its dance.

**Your own words.** Everything he has written in the Well, newest first, ending on *"this is where you began"*; tap a line to mark it (G41: a tap marks, a second unmarks; marks kept with the letter).

**Leaving.** *Surface* is always present (top, Newsreader italic): surfacing .95 s, the dark thins at one edge; back to exactly where he was above. The point at the top takes him home through the point. *Go further down* → Beneath (one breath of dark).

---

## 2 · Every element, placed

Status codes: B built · P partial · N not built · W wrong. Action: reuse / move / new / fix.

### Memory

| # | element | what it does (mechanism + numbers) | source (index · register) | status today (code) | action |
|---|---|---|---|---|---|
| M1 | Merged record (MemoryRecord) | Pages App Activity (100/page) + all local stores; dedup by Client Write Id, then (kind,kp,Felt At ±2 s); read cache rebuildable; restores letters, river, strokes (Detail), dwell on empty phone; never writes on read | G7-0590, G7-0512, G1-0600, G1-0531, G4-0480, G6-0845 · 21:159, 02:1663 | W — Portrait/Smṛti read local only; Her Moments merges (ShaktiDetailView:1110-1150, AirtableService:710) | new (reuse fetchPage, momentRows) |
| M2 | Law of light | whether · when · his chosen acts; never how often; detector test (digits followed by "of" or "/" and digits, %, streak, days since, behind, overdue) on every Memory string | G5-0294, G7-0524, G7-0038, G1-0027, G1-0570, G2-0441 · 12:787, 21:30 | P — law tests exist (LawsTests:1340, LawsDrawnMeasureTests) | fix + extend tests |
| M3 | Crossing in (white dot grows) | point blooms 0.9 s in dusk colour; bindu 0 → full 1.2 s; rings draw 9→1, 60 ms apart; Ring 9 root, gain .03, 2.4 s | C-1348 (07:975), G1-0609 · 03:36-38 | N | new |
| M4 | Portrait geometry | 330 pt; radii [158,123,95,78,65,52,40,26,0]/172; ring 1 on the Bhūpura square; petals oR134 iR112 hw22; triangles 90/70/50/32; bindu r10 + core 3.5 | G7-0519, G1-0525, G7-0497, G7-0525 · 02:977-991, 21:30 | B with defects (ring-1 circle; kp−28 hard-coded :340) | fix |
| M5 | Seat light by recency + patina + status breath | warmth .25+.75·e^(−d/21); halo r 4+6w, op .12+.16w; colour bone→amber→deep gold by (days/1095)^.55; breath 4.5/6/8/11 s | G7-0524, G1-0527, G1-0579, G2-0104, G5-0064, G1-0739 · 21:30, 03:695 | W — intensity = min(1,count/12) (:414) | fix (replace count) |
| M6 | Settle flight + hand ring settling true | 3,400 ms; fly 0–.34, halo .34–1 (r6→36); hand ring 4 s, 180 segments; tone .985·root→root, gain →.036@3.2 s; only .felt flies | G1-0526, G7-0520, G7-0526, G5-0065 · 02:993-998, 13:212-215 | B flight; W silence flies (:384-387); N ring | fix + new |
| M7 | Living layers | strokes n-fold [28,16,8,14,10,10,12,3,1]; year beads at 2π·doy/365 − π/2, r .977; gaps kept; sealed lid | G6-0889, G7-0529, G7-1010, G6-0804 · 17:346, 21:31 | B (LivingMandalaLayers:67-96) | reuse |
| M8 | Play layers | root web 9, wheel a spoke per game, body petals 7, seed 8 petals, bead ring 102 @ .945; warmth .25+.75e^(−d/21) | G7-0530, G6-0834, G2-0865, G2-0866, G2-0880 · 21:32 | B; W root asymmetry (:63-64); two stores one act | fix + merge stores |
| M9 | Stroke capture | one finger still .4 s begins; unit coords; ≤256 pts; persisted, ledgered once, recovered after kill | G7-0529, G6-0836, G7-0720 · 22:341-346 | B | reuse + serialise to Detail |
| M10 | Tap a seat → fall into her (one camera) | z .22 → 34; seats fan 20°–160°; approach/gathering/strata/mouth | G7-0527, G5-0071, G5-0427 · 12:323, 13:398 | N (petals not tappable) | new |
| M11 | Petal Biography | first met (date) · most recently (date) · MOMENTS SHE WAS HERE (his notes, moon phase); doors carriers/room/letter | G1-0743, G7-0582, G1-0521 · 03:714, 02:937 | P (Her Moments fold, ShaktiDetailView:761-815) | move + new room |
| M12 | Threshold Timeline | spine .5 px at x38; node 12 pt per chosen crossing; date + his word; reads `Threshold Crossed` | G1-0744, G7-0583, G7-0604 · 03:717-727 | N (advanceStatus exists :534-542) | new + new Activity Type |
| M13 | Cluster Garden | 5 cards, 64 pt fragments lit by M5 rule; no meters | G1-0745, G7-0584 · 03:729 | N | new |
| M14 | Density Atlas | 9×31 cells 16 pt gap 2; lifetime ×12 24 pt gap 4; day lit if practised, colour = act kinds | G1-0746, G7-0585 · 03:732-735 | N | new |
| M15 | First Word · Last Word | span lines first-met→last-felt; end glow if < 7 d | G1-0747, G7-0586 · 03:737 | N | new |
| M16 | Lifetime Spiral | ring per year r 30+24·yi; each a bead ring; 16 cluster marks; inner band of Self days | G1-0748, G7-0587, G6-0738, G3-0401 · 03:740-743 | N (year ring this year only :277) | new (reuse YearRingLayer) |
| M17 | The Afterline | his line ends at today; drag past → sealed forward letters as branches to their opening days, .22 s steps; no peek | G4-0803 · 11:430 | N | new |
| M18 | The Chain of lamps | practised days as lamps; spark 0.5+to·.18 s; today dashed→solid glow .28 | G4-0809 · 11:444-447 | N | new |
| M19 | Zoom ladder (Sky·Day·Month·Year·Lifetime) | pinch ladder; hand-feel LONG/SHORT constants; missed day held in its fortnight | G5-0365, G5-0360, G6-0741, G3-0369, G3-0358, G3-0451, G3-0497, G5-0402, G5-0660 · 13:131 | N | new |
| M20 | Day glyph + six lights | glyph on a thread; six Being lights lit by act kinds; halo=min(lights) | G5-0128, G5-0376, G6-0754, G5-0097, G5-0129 · 13:221-227 | N | new |
| M21 | Month Mirror + answerable witness | built month circle; MonthSitting it lands · say more (= shows its sources) · leave my own word → Codex | G7-0537, G6-0806, G7-1011, G5-0133, G5-0127, G4-0685, G7-0538 · 21:37 | B | reuse; 'say more' = sources |
| M22 | The Book | oldest first; page turn 900 ms; embers ≥3.5/7/14 s; frontispiece; middle door; last page seal forward / leave my word; authorship by colour | G7-0536, G7-0406, G7-0476, G5-0119, G5-0237, G5-0261, G5-0679, G4-0694, G4-0866, G5-0478 · 21:36 | B (ArchiveBookView:179-205) | reuse + widen sources |
| M23 | Codex shelf | his RAW entries as nebulae, ≈11 s spiral; word-by-word; "Held. Seen. Kept." on a new word | G5-0123, G3-0326, G6-0788, G6-0909, G5-0131 · 07:1-15 | N shelf; B CodexWrite | new + reuse |
| M24 | The two faces (C-1135) | twist past 90° → 900 ms flip; back = all 102 lit alike, his bindu one among them | G3-0382, G3-0381 · 07:310-318 | N | new |
| M25 | The Word's Star sky | wordToPosition hash 0.15–0.85; same word same place; alpha max(.08,.4/(1+age·.5)); Map hex; quartets; body points; reach-history thread | G4-0240, G4-0239, G4-0086, G2-0541, G3-0272, G4-0173, G4-0257, G3-0271 · 08:439-442, 846 | N | new |
| M26 | Sky of every page | golden angle i·137.508°, r c√i; kinds as colours; unmet .25; ember star ≥2.5 s; three rim ways; ledger vocabulary read back | G5-0105, G5-0118, G5-0425, G5-0460, G7-1014 · 12:396, 13:219 | N | new |
| M27 | The Walks sky | 110 stars, 3 depths, shooting star 14 s; 20 walks by Sort Order, hsl(Hue), glyph; walked glow oklch(.92 .08 90) breath 3.2–6.2 s; long-press 110/3.5 Hz .02→.06 .9 s; Vow You → (2 s) Vow I; zoom ×7 1.15 s; exit 1.4 s | G6-0743, G6-0664…0683, G5-0224, G5-0463 · 16:169-194, 294 | N | new (read-only) |
| M28 | Residue map of the 33 | 33 grids 25×35 laid as one field, each room's map colour; whether only | G4-0324 · 09:158 | N (grids not persisted) | new (after the 33) |
| M29 | The Arc (invitation) | 12 nodes r250/700, 5 s each, line .8 s; name at centre; 5 words orbit 70 pt, 120 s; ring .25 Hz | G5-0601 · 14:440-449 | N | new |
| M30 | Garden under the real sky | real sun/moon; ṛtu particles; plant per session; firefly per game kind; daily gift while away; objects sound | G2-0906, G5-0209 · 05:3090, 12:544 | P (PlayGardenStore) | new view, reuse store |
| M31 | The Record | A4 candle sheet + PNG; mandala of the record 0.00055 rad/frame; dated words; no numbers; carry your road = ledger export on ask | G2-0904, G5-0220, G5-0210, G7-0521, G7-0588, G7-0606, G5-0377 · 21:114, 143 | P (1500 px export :82-94) | widen |
| M32 | Keep or release | forget me = 2.3 s hold; releases display memory only | G1-0092, G5-0339, G4-0865, G4-0159 · 13:63-64 | N | new (guarded) |
| M33 | Descent remembered | 4.5 s per frame; dates from merged crossings incl. rings 1–2 | G7-0541, G7-0542, G6-0800, G2-0150 · 21:40 | B; W ring = 3+i (:35-38) | fix |
| M34 | Portrait doors become world doors | six doors (draw · point · river · where she speaks · book · month) → each crosses to its own world/room; Cosmic Now leaves for Time | G7-0522, G7-0581 · 21:30, 96 | W (stacked behind one screen :191-228) | move |
| M35 | Crossing out / back-to-where | point → home; menu; doors; per-world back stack restores instrument + zoom | spine; G1-0609 | P | new |
| M36 | Memory sound | ring-root bell gain .02 on seat tap; settle glide; Walks drone held only; chimes off by default | G2-0181, G1-0574 §2.7-2.8 | P | new |
| M37 | Memory visual language | Being dusk tokens; Fraunces+Spectral at crossing; candle sheet for Record | G5-0524, G5-0492 · 13:635-642, 778 | N | new tokens |
| M38 | Arrival from Recognition (routing) | settle crosses into Memory from Today/Her Presence/Mandala; from inside her room the flight waits and plays on the next Memory entry the same day | G2-0319, G7-0137, G1-0497, G1-0587, G7-0135 · 04:516, 19:711 | W (only from Rite; jumps out of rooms) | fix |
| M39 | Words of the world | header/whispers verbatim: *The Memory* / *your face in the instrument* / *she is felt, not measured*; MEM subtitles re-voiced without counts | G7-0523, G7-0632, G1-0741 · 22:52-61 | B | reuse; edit subtitles |
| M40 | Privacy of the record | never synced to the site; never analysed; Recognition never shared outward; export only to him | G2-0031, G5-0556, G3-0346, G1-0570 · 14:156-170 | B (local + private base) | keep (test) |

### The Well

| # | element | what it does (mechanism + numbers) | source (index · register) | status today (code) | action |
|---|---|---|---|---|---|
| W1 | Dark tile on Home | `#0A0806→#14100A` tile with the river faint; tap = Descent first time, dark veil after | G5-0114 · 13:167-168 | N | new |
| W2 | The Descent | 2.35 s (.66,0,.24,1); paper −104% @55%; ember 11 pt; tone 110+110(+6¢)+164.81 Hz ≈.8 s; haptic .9/.15 @55% | G5-0113 · 13:154-158 | N | new |
| W3 | Door that resists | hold ≈1.25 s; early release refuses (6 pt push-back); typeface → Newsreader at crossing | G5-0222, G5-0357 · 12:559-560 | N | new |
| W4 | Breathing ring arrival | warmth 2.5 s; ring 4 s cycle; white-noise breath; collapse; 2.8 s; seed word by word 200 ms | G5-0591, G4-0475, G4-0603 · 14:375-383 | N | new |
| W5 | The water (space) | `#0E0C14→#07060C`; NOW hairline 48%; 7 current strands α .05; pink noise .015 LP 4 kHz; touch glow 320 pt lerp .12; tempo 1,200 ms | G7-0534, G4-0165, G5-0641, G5-0229, G5-0525, G5-0487, G5-0493 · 21:34, 13:779 | P (river view built; Well is a list off the hamburger, RootView:62) | move into a world |
| W6 | Wave tiers as the river's light | the deep, tidal pull 82–90%, water-marks 10 s, wave-archive *"Every wave you have offered has reached this shore."* | G4-0175 · 08:864-875 | N | new |
| W7 | The wandering point on the water | idle 20 s; sum-of-sines; halo 3.2–4 s; uncatchable | G5-0140 · 14:648-659 | N | new |
| W8 | Doors on the water | serif line beside 1 px slit; one breath apart; set by time of day; walked doors dim | G5-0379 · 13:243-244 | N | new |
| W9 | Her letters — the 102 reflected | 102 points on the water; written glow *"your words live here"*; order [2,1,3…9] | G7-0544, G1-0523, G2-0166, G2-0341 · 21:47 | B (WellView, list) | move to water |
| W10 | Letter editor | atmosphere-lit; day-colour wash; prompt recedes to .45; boxless rule; autosave 2 s + .inactive, only dirty; PATCH Letter fldgASyV031Hr4sHp | G1-0524, G6-0803, G5-0477, G5-0094, G5-0389, G5-0600, G2-0102 · 02:967-975 | B; W loses words on background kill (RD-15) | fix |
| W11 | Speak a letter (G46) | press once; ~90 ms/word +260; ember 15 pt rings 3.4/4.3/5.6 s; on-device; voice kept | G4-0770, G4-0858, G6-0841, G7-0543 · 11:320 | B (SpeechCapture, VoiceWord) | reuse |
| W12 | Release her letter + one line | 2,300 ms hold of his mark (armed with words); *"The room has changed."* | G4-0755, G5-0093, G5-0095 · 12:381-383 | N | new |
| W13 | The river composer | recipients her / age 0–120 spelled / a memory / past self / later self; back readable at once | G6-0835, G7-0534, G4-0677, G5-0208, G3-0512 · 17:590 | B (CorrespondenceStore, CorrespondenceView) | reuse |
| W14 | Seal to a day | her day, Pūrṇimā (168°), Amāvasyā, tithi returns + tomorrow / week / season / date; local midnight; one breath 2.4 s; wax drag G27 fold 900 ms | G4-0751, G7-0414, G6-0822, G6-0824, G7-1007 · 11:301 | P (4 openings, no wax drag) | widen |
| W15 | Opening: two blooms + held centre | seal melts 1.4 s; 21 s held stillness; 50 bpm haptic [30] + 1.2 s pulse hue 345; 110 Hz / 7.83 Hz designed then 4.0; carrier holds 8 s @ .04 | G4-0455, G4-0379, G4-0384, G4-0465, G4-0462, G4-0464, G4-0247, G4-0248, G4-0478, G4-0268, G5-0688 · 09:364-408, 644-715 | N | new |
| W16 | Word by word, held | ≈250 ms/word +430/+180; blur 4→0; only while held (G1); haptic .3; release pauses; later whole or slow | G5-0368, G5-0111, G3-0512 · 13:174-176 | P (0.24 s/word after .8 s, not held) | fix |
| W17 | Patina | 1 − e^(−days/240); tint (.62,.46,.20) | G6-0835 · 17:590 | B | reuse |
| W18 | No peek, no reply | sealed refuses open; nothing answers (:11, :512) | G7-0732, G4-0677 · 22:436-442 | B | keep (test) |
| W19 | Light sent back | moment + her light + words; 2.4 s hold; travels upstream 2.4 s; *"It has gone back. It was always going to arrive."*; lamp on Memory's Chain keeps a second glow | G7-0535, G3-0379, G6-0885 · 21:35 | B (LightBackViews) | reuse + link M18 |
| W20 | The glass — the carve | clip .85/s; ≈2 s press carves you→I; held tone 110/3.5 Hz .02→.06; blips 174·220·196·233·246.9; exit 261.6→329.6 | G5-0410, G5-0222, G5-0223, G5-0447 · 13:353, 375-376 | N | new |
| W21 | Lines that may be carved | Shadow's and Maya's two-line practices, Armin's inversion, the 20 Vow You→Vow I (read-only) | G6-0566, G6-0744 · 15:1374, 16:295 | N | new |
| W22 | Inversion order + LOOK | phrase assembles 4,3,1,2; eyes blink 4.5–11 s, scaleY .08 ≈120 ms | G5-0371, G5-0448 · 13:182, 486 | N | new |
| W23 | A vow arrived / still living | ● / ○, terra `#C47A52`; one redraw a day | G5-0411 · 13:360 | N | new |
| W24 | One sentence | Incarnation's sentence; Echo's evening question; thank you past self / I promise later self | G6-0595, G6-0594, G6-0752 · 15:1430-1431, 16:306 | N | new |
| W25 | Release into the water | brain dump then 2.3 s hold; erosion 10 s weighted; haptic 50 ms ≤1/200 ms; 68 Hz + 136.1/204.15/272.2 stripped; words not kept | G2-0872, G5-0193, G5-0592, G5-0972 · 14:385-393 | N | new (Q1) |
| W26 | Closing gestures | four lines to a lineage; gratitude line; each a light on the water | G5-0314, G5-1124, G5-0912 · 12:912 | N | new |
| W27 | Sit at the water | 11 breath sessions by verb (names/one-words verbatim); seeds as invocations; one word to sit with | G4-0349…0359, G4-0612, G4-0277 · 09:222-238, 10:441 | B in Bindu Field; N here | reuse catalog |
| W28 | Ember dance | `bindu/still.mp3`; seed *"Sit down. The fire is already lit."*; drone only during the dance | G4-0453 · 09:713 | N | new (score exists) |
| W29 | Your own words | all Well writing newest first → *"this is where you began"*; G41 tap to mark | G5-0096, G4-0765 · 12:384, 11:315 | N | new |
| W30 | Leave my own word → Codex | from any letter: 'leave my own word' writes a Codex row (Source App Bindu Mandala) | G6-0909, G6-0788, G6-0840 · 17:169 | B | reuse |
| W31 | Surfacing + exits | *Surface* always; .95 s; dark thins at one edge; back to where he was; *go further down* → Beneath | G5-0116, G4-0330 · 13:479 | N | new |
| W32 | Well haptics | fulcrum [30] @50 bpm; mirror [8]; seal settle; descent .9/.15 | G4-0477 · 09:694 | N | new |
| W33 | Well ledger writes | Letter Written, Letter Sealed, Letter Opened, Light Sent Back, Name Kept, Letter Released (new); Gesture Source Well | G6-0843, G6-0771, G2-0348 · 17:631, 16:337 | P (Gesture Source Well never used) | fix |
| W34 | Privacy floor of the Well | his alone; never auto-generate, seed or suggest; no generated voice; never analysed | G2-0364, G2-0093, G2-0039, G1-0598 · 04:164, 596 | B | keep (test) |
| W35 | Well wakes and holds | wake lock in reading/still phases; don't-engage (any touch costs nothing) | G5-0689, G5-0688 · 14:956-957 | N | new |
| W36 | Well visual + sound language | Lalita *under* + Learning dark; Newsreader 300 italic; voice oklch(.62 .09 300); the Well's fixed tone = 110 Hz carrier (held only) | G5-0525, G5-0487, G5-0493, G5-0223 · 13:590-650, 779 | N | new tokens |

**Elements placed: 40 (Memory) + 36 (the Well) = 76.**

---

## 3 · Parity ledger

Written as `waves/upgrade/ledger/memory-and-well.csv` (one row per checkable element; columns `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by`). No F-frame exists for either world; reference frames are Design prototypes (`DES-02 L-23 Memory`, `DES-02 Well`, `DES-03 MEM-n`, `RK S15`, `RK Descent`…) and F14 for the Recognition lines.

---

## 4 · Data contract

**App Activity `tblJlBeiHnqGpYrL7`** (the single ledger). Read by MemoryRecord: Activity Name `fldqAZ3xmkQwHaJQm` · Source App `fldHPuwmYPa3Ry91q` · Activity Type `fldXNRBZy6QvIP8yz` · Activity Date `fldMcikl2kbVRFv4G` · Detail `fldFWURRpDmzcSAvl` · Notes `fldVyj4hkzxcrIBoJ` · Link to Mandala `fldzsEMInQmNIxTNu` · Felt At `fldWAR0B4pNxjTwEJ` · Lunar Day `fldJc7iCzxZOSdO4D` · Moon Phase `fldMpjvAsT64v85bh` · Gesture Source `fldP3wq8QTgxeTDuC` · Descent Ring `fldi7SOuep57UoXzi` · Duration `fldrIOx1id7Esm2fd` · Link to The Map `fldkF65ySNGGkeugH` · Excerpt `fldu19uazNrEt5vg5` · Voice `fldhnzXPqnxYHTJv5` · Surfaced `fldUXJrrHnNLKdeln` · Surfaced Date `fldzKJNjSS5fRwHA6` · Shared With `fldgrIfuL6i4M9gZv` · Client Write Id and Link to Mirror (ids not in the register — read by name until resolved).

**Activity Types read** (existing vocabulary, ActivityLedger.swift:79-166): Shakti Recognized · Letter Written · Ring Crossed · Silence Held · Full Circle · First Dwelling · Note Left · State Set Down · Siddhi Received · Played · Letter Sealed · Letter Opened · Portrait Drawn · Wager Resolved · Witness Written · Garland Recited · Day Offered · Leela Drop · Light Entered · Chakra Practiced · Light Sent Back · Name Kept; sister-app kinds read for the Sky and grace: Story Met, Ash Replied, Walk Completed, Veil Lifted, Chapter Completed, Topic Opened.

**Activity Types / options written (new select options, no new fields):** `Threshold Crossed` (Link to Mandala; Notes = his word at the crossing, optional; Detail = "{from} → {to}") · `Letter Released` (no words) · `Dance Completed` / `Post-Dance Word` / `Standing Words` (written by the 33 and Today; read here for the Word's Star; word in Excerpt). Gesture Source values used: `Well` (first use), add `Memory` for strokes drawn in Memory. `Portrait Drawn` rows carry the stroke's unit points (≤256, JSON) in **Detail** so a new phone redraws them. Rules kept: notes are his words only; no count in any name or detail (ActivityLedger.swift:24-25, 488-501).

**Mandala table** (Śakti rows): Letter `fldgASyV031Hr4sHp` (her letter, synced), Status `fldDiihcxC54WKPhT` (embodiment, his crossing), Last Felt `fldWT0dGqdUQrdRGT` (read for warmth fallback), Recognition Count `flddp0tLpf8iuxyt4` (**never read for light**; readiness only, in Her Presence).

**Codex `tblDF4OCMcRoxkQjU`** (base app248ZTWhYJlvQj2): read Title `fldxmZqObGiIoHHll`, Date `fldth1fgVdc2HgIyn`, RAW `fld459YeVBZBgB8zh`, Notes `fld07qLLRIgRTvi7q` (only on the 28 records with empty RAW); write via CodexWrite with Source App `fldaii08WVwJQA5qP` = 'Bindu Mandala' (`selhkTEAbJE3DUuce`), Status never written.

**Walks `tblJ2sg5ubhN5CH5M`** (read-only; Row Type = Walk, Status = Live): Name, Sort Order, Figure Kind, Hue, Vow You, Vow I (ids fld0ylQw1PesCTmvc, fldEQucrCE8Hww0Ra, fldYCk2bQfmIjbm8E, fld3dK8qeSp3tw82V, fldTaHbAaMKZu1Sb4, fldlE7ReL5V1NeFns, fldKa1nVEpcdk5klI). Entry rows (private Carved text) are never read. No person link, ever.

**Bindu Field catalog** (breath sessions, read): rec7sR8aqptY7uQpe, rechUbF8gHsuu51PS, recsi52JcIgBbDRZA, recyhgZSwsPVEZA0R, recKE2cq3dwPTkYoS, recMeuavySskl60n6, recAfXRujKb2C3NAS, reca2ZsfcgKobscb6, recLSSOozJbHKm702, recA1b1fTg6cL1ijB, recYKA8lnBVzPkvPF; seeds fldyFZy2hzFXTM52K.

**Local stores** (SwiftData / files; each restorable from the ledger): RecognitionEntry · ShaktiLetter · LetterDraft · 'correspondence' (CorrespondenceStore: RiverLetter, RiverDraft, LightSentBack) · 'portrait-strokes' · PlayTraceStore + PlayGardenStore (merge to one) · MarginNote · 'codex-notes' · 'bindu-memory' (BinduMemory, history never overwritten) · DescentState · HomeMemoryStore · MemoryRecord cache (new, rebuildable) · per-world back stack (new).

**Bundled audio**: `bindu/still.mp3` (Ember, 11,810 KB, sha 7dbb702d) — the Well's one dance. No other song is played in either world. Synthesised (nothing claimed): 110 Hz carrier / 3.5 Hz beat (Walks, glass), 110/7.83 → 4.0 (held centre), Descent chord 110 + 110 (+6 ¢) + 164.81, glass blips, erosion 68 Hz series, pink noise, ring-root bells of the one tuning.

---

## 5 · Doors

| from / to | way | thread |
|---|---|---|
| Home → Memory | menu constellation point; Home door | spine |
| Home → the Well | dark tile → Descent | spine |
| Recognition (Her Presence / Today / Mandala) → Memory | settle crossing, her kp | her position |
| Her Home (her room) → Memory | long-press her seat light → her Petal Biography | her position |
| Memory (Petal Biography) → Her Home | *her room* | her position |
| Memory (Petal Biography) → the Well | *her letter* → her letter on the water | her position |
| Memory (Petal Biography) → Relationship Field | *who carries her* (Shakti's Carriers, '‹ Portrait' back) | her position |
| Memory (Density Atlas / Day) → Time | a day → Time's Great Wheel at that day | the day |
| Time (Great Wheel, a day) → Memory | *open its catches* → the Day glyph | the day |
| Memory (Word's Star) → the 33 | tap a star → the room it was given in | the chakra |
| Memory (Sky, a chakra star) → the 33 | its room | the chakra |
| Memory (Book middle page) → Beneath | *go down* | spine |
| Memory (Book last page) → the Well | *seal it forward* → river composer | spine |
| Memory (Afterline branch) → the Well | its sealed letter (shows only "opens {date}") | the day |
| Memory (Descent remembered) ↔ the Climb | a frame's ring → that ring on the Climb | her position |
| Memory → Modes (Smṛti) | long-press a ring in the Portrait → Smṛti opens on that ring | her position |
| Memory → A Strange Game | play-layer spoke → that game | spine |
| the Well → Her Home | after releasing her letter, *her room* (the letter rests folded) | her position |
| the Well → Memory | *your own words* ↔ the Book; light sent back → the Chain | spine |
| the Well → Beneath | *go further down* | spine |
| the Well → the 33 | Ember dance → Ahaṅ (fire) | the chakra |
| Today → the Well | Rite's *close the day* letter (evening) | the day |
| Her Home → the Well | the folded letter in her room, *write to her* | her position |
| any world → Memory / Well | menu; search ("letter", "portrait", her name → her biography / her letter) | spine |
| gestures | long-press any seat anywhere 0.9 s = her memory; swipe down from the top of the Well = surface | spine |
| leaving | the point (home, through the point); back to exactly where he was | spine |

---

## 6 · To Bindu Feed

| material | source |
|---|---|
| Codex → short stories with archetype comments (Bindu Feed's origin) | G3-0516 (C-1351, 07:985-988) |
| A daily self-learning story from his entries | G3-0352 (C-1067, 07:165) |
| The FlASH Point story (Red/Black/Blue/White Flash) | G3-0331 (C-1005, 07:60) |
| His name's meaning across lives; the scarf and the picnic blanket | G3-0381 (C-1134, 07:310) |
| The month as a letter of his life (MonthReading narrative version) | G6-0883, G7-0538, G6-0948 (MonthReading.swift:140-160) |
| The Book of his words as a story-shaped object; the Record as gift object | G7-0536, G7-0606 |
| Encounter Log stories ("when she crossed between you") — Design's samples never shipped as his | G1-0766 (03:844-853) |
| Story links per track (45 rows → tbl7vzODMMJUgeX0b) — Memory shows only 'a story lives here' as a door | G4-0608 (10:421) |
| Ramana Maharshi exemplar portrait | G4-0788 (11:393-397) |
| Bindu Being's 'a mirror, not a master' teaching | G4-0794 (11:409) |
| Rumi as love letters | G5-1031 (12:1416) |
| ASG life-timeline narratives (founding, ASG's birth, first awakening) — the days stay in Memory as light | G6-0738, G3-0401 |
| The Practice Book's dedication and spreads | G3-0183 (06:1147) |
| Gate letters of rooms 27/29/33 (the 33's story layer) | G2-0934 |
| Lemuria and Atlantis texts (mechanics kept, text to Feed) | G5-0591, G5-0592 |
| A higher starting point for others (C-1287) | G3-0474 |

---

## 7 · Conflicts settled and open

**Settled (with evidence):**
- **C1 · Count-driven brightness.** Three formulas disagree (code min(1,count/12) :414; Design min(1,total/80) 03:709; Living Rite min(1,n/7) 02:991) while Smṛti refuses counts (TheModes:160-162) and the Mandala removed its felt ramp by law (MandalaCanvasLayer:480-494). Floors: *nothing scores him*, *no counts about him*, BC-13 *nothing grades him*. Ruling: light = whether + recency warmth + age patina + his chosen status breath (M5). Recognition Count is read only for readiness in Her Presence. Same rule for the Atlas, Garden, Spiral, Word's Star.
- **C2 · Local-only memory vs "practice data never lost".** MemoryRecord merges device + App Activity and restores on an empty phone (M1). Strokes ride in `Portrait Drawn.Detail`; dwell restores from Duration rows (HomeMemory stays phone-first but no longer phone-only).
- **C3 · The Well vs the recognition archive** (02:1652). The Well holds letters (to her, the river, light, carved lines, sentences); recognition notes live in Her Moments and Memory's Petal Biography and the Book.
- **C4 · Letters on device (padakarshini A3, law 26) vs sync (R17).** App rule: letters sync to his private base (Letter field; river stamps in Notes) — App Activity single ledger wins; law 26's "nothing leaves the device" does not apply to his own private base.
- **C5 · Design's numbers in MEM-1…7, Smṛti, Pūjā, Great Wheel** (1,418 recognitions; 264 days; 41-day gap; bloom %). All dropped; places, dates and spans kept (BC-13: numbers may describe her, the structure, the place and the day). Synthetic generators (PRACTITIONER_HISTORY, genConstellation, LIFETIME_YEARS) never ship.
- **C6 · forget me vs "practice data never lost".** Charter II §4.1: *"Storage is forever unless the practitioner explicitly releases."* forget me releases the display memory only (head start, traces, warmth); the ledger, words, letters and strokes stay. The Welcome's "release everything" (06:1075) is rejected.
- **C7 · Recognition settle routing** (Design always settles; AR-08 jumps out of rooms; RootView:105-106 only from the Rite). M38: crosses into Memory from Today/Her Presence/Mandala; from inside her room the flight waits for the next Memory entry that day. Only `.felt` flies.
- **C8 · Ring-1 seat geometry** (square in ModeField:18, circle in Portrait:449-462). Mandala geometry wins: square.
- **C9 · Word-reveal pace** (0.24 s/word built; ~1.5 words/s A3; 250 ms + punctuation rupakarshini; pace 1.55 Correspondence; 200 ms Lemuria). Letters: 250 ms + 430/180 at punctuation, held (G1). Arrival seed: 200 ms (Lemuria V7.1, latest).
- **C10 · Placeholder vs "no placeholder"** (Living Rite and snapshot `well-letter.geom` vs site *"Blank space IS the invitation"*). Design for this app is the floor: the line stays, placed above the page and receding to .45 once words exist (G5-0094).
- **C11 · Openings.** Built: her day, Pūrṇimā, Amāvasyā, tithi returns. A3/G27/Sketchbook add tomorrow, week, season, a date (1/7/90 days). All kept; local midnight of the civil date.
- **C12 · Generated voices and reflections.** C-1346's *"any voice … the highest self speaking"*, Correspondence's raw/higher/witness modes, the AI letter reader, `buildWalkerSnapshot`, Witness Line generation, G-ENGINE generated letters: rejected (no generated voice; letters private, never analysed). His own recorded voice is the only voice. "say more" in the answerable witness shows the witness's **sources** (the ledger rows), never new text.
- **C13 · MonthReading template sentences** (17:357, 21:168). Fixed authored strings filled only with names and acts from his record — kept as authored text; the narrative month-letter version goes to Bindu Feed.
- **C14 · Walks in the Mandala** (Source App Feed; Walks.App Activity empty; Link to Mirror 0). Read-only echo, no person; "walked" matched by Link to Mirror when filled, else by walk name in Activity Name; the Feed's writer should fill Link to Mirror (Lalita Family build note, not his question).
- **C15 · Smṛti** (Modes) shares MemoryRecord; its views stay in the Modes world; Memory opens it by long-press on a ring.
- **C16 · Songs.** Abide, Unfold, Journey and Return have no mp3 on GitHub (ruling 12) — their mechanisms (fulcrum, two blooms, Karishma freeze, heartbeat) are used without the songs; only Ember (`bindu/still.mp3`) plays, during its dance.
- **C17 · Low-state law citation.** Cite C-1002 and C-1057, not C-1120 (07:1330). The low-state door itself belongs to Today; it reads Memory's and the Well's words.
- **C18 · Two play stores for one act** (PlayTraceStore + PlayGardenStore). Merge into one store feeding both the play layers and the garden.
- **C19 · Embodiment thresholds 1/3/7.** Owned by Her Presence; Memory's Threshold Timeline records only the crossings he chose.

**Open questions for Ashrey (genuine):**
- **Q1 · Releasing a letter.** May a letter he writes be released into the water with its words not kept (C-1137 *"The whole point of everything is to let go"*; the Letter game's burn/bury), against the floor *practice data never lost*? Designed as W25 with only a wordless ledger row; built only on his yes.
- **Q2 · His foundation days in the Lifetime Spiral.** Should the inner band carry his own days (AKAS 2010, ASG 2015 C-1261, first Kundalini awakening C-1170) — it needs three Self rows added by hand in the Timeline table.
- **Q3 · A word at each crossing.** When he crosses a Śakti (mapped → exploring → active → embodied), may the crossing ask for one optional word that the Threshold Timeline keeps — or should the crossing stay wordless?

---

## 8 · Coverage

Every index id in `memory.jsonl` and `well.jsonl`, with its disposition. Script check (python3 -I over both slices against this table):

```
slice ids (memory 461 + well 191, 55 shared) = 597 distinct
mapped = 597 · missing = 0 [] · extra = 0 · duplicates = 0
placed 393 · merged 4 · to Bindu Feed 13 · rejected 6 · not this world 181
```

| id | slice | title | disposition |
|---|---|---|---|
| G1-0008 | W | Well letter rests in the room as a folded object — never fabricated | not this world (her-home); reads W10 letter |
| G1-0015 | M | New additive Swift layer (9 files) | not this world (her-home) |
| G1-0023 | M | HomeMemory: head start from accumulated dwell, compression 1.0→0.36 | not this world (her-home; dwell restored by M1) |
| G1-0024 | M | 'you have stood here before' — one line, once, on returning; nothing displayed | not this world (her-home, ruling 15) |
| G1-0027 | M | Invariant 2: Never measure out loud | placed M2 |
| G1-0034 | W | Not in the Homes handoff: Mandala, Today, Portrait, Well writing, Descent film, Homecoming, Settings, Codex | not this world (her-home handoff scope note) |
| G1-0073 | M | Climb rail — one tick per world labelled with body region; marks met, never how many | not this world (climb) |
| G1-0078 | M | Rite beat timing: dur 2.4 s (reduced 3.4 s) × compression; trav ease .03 | not this world (her-home) |
| G1-0085 | M | In the room: 'stay' ×14, label, 'you have stood here before' within 14 s, return to the axis | not this world (her-home) |
| G1-0088 | W | Well letter in room: localStorage homes.well.v1, folded object 36×14→27px | not this world (her-home); reads W10 letter |
| G1-0090 | M | Leaving: memory.record dwell, mark met, exposure +0.12 over 24 s | not this world (her-home, ruling 15) |
| G1-0092 | M | Forget me — clears memory, core lights, rail marks | placed M32 |
| G1-0114 | M | Second adaptation reverses the room's premise; reached only by return (or 'stay' ×14 for review) | not this world (her-home) |
| G1-0284 | M | grantsFifth: ninth world, a very long stay, or a long relationship | not this world (her-home / sound) |
| G1-0293 | M | HomeMemory storage and compression formula (0.68^v, floor 0.36) | not this world (her-home) |
| G1-0294 | M | headStart = min(dwell × 0.55, 221 s), 0 under 12 s; record caps dwell at 4000 s | not this world (her-home) |
| G1-0295 | M | Memory keyed by name — repeated names share dwell; key by position | not this world (her-home; HomeMemory keyed by kp) |
| G1-0296 | M | Felt return: core light, steady pulse, floor traces (max 7), 'stood here before' 14 s | not this world (her-home; climb lights stay alike, ruling 15) |
| G1-0327 | M | The return — her room begins where you left it (felt, none displayed); traces capped at 7 | not this world (her-home) |
| G1-0337 | M | Gift: a third state beyond the second adaptation | not this world (her-home) |
| G1-0423 | W | Specimen 28 Sarva-Trikhaṇḍā (सर्वत्रिखण्डा) — triad, late; letter exists | rejected (Design specimen letter must not ship as his; floor nothing invented) / her-home |
| G1-0427 | M | Compression on return — Zero Gap (0.66^(v−1), floor .36); beat durations 2.4/3.2/2.8 s | not this world (her-home) |
| G1-0428 | M | Rite visit-count off-by-one quirk | not this world (her-home) |
| G1-0443 | W | Her letter slip — fades in as a crosses the rate's letter threshold | not this world (her-home); reads W10 letter |
| G1-0480 | M | Embodiment ladder: Mapped → Exploring → Active → Embodied, crossing by press-and-hold | not this world (her-presence); read by M12 |
| G1-0481 | M | shakti-data status field (e.g. 'embodied') ignored — everyone starts Mapped | not this world (her-presence) |
| G1-0495 | M | Recognition staged arrival: name → phrase → 'she was felt here · time' → 'and she felt you back · h:mm:ss' → note | not this world (her-presence) |
| G1-0496 | M | Recognition interaction: tap anywhere closes after 300ms; note saved per keystroke | not this world (her-presence) |
| G1-0497 | M | Recognition close: ceremony gathers into the point (lrCollapse .62 s), hands off to Portrait/Memory | placed M38 |
| G1-0518 | M | Field felt-count display violates 'no counts about him' | not this world (mandala/rings) |
| G1-0521 | M | Her Moments list — 'she was felt here · {when}' + moon phase + note | placed M11 |
| G1-0523 | W | The Well (Living Rite): 'speak to her directly · she is listening' — Ring 2 Karṣiṇīs receive letters | placed W9 |
| G1-0524 | W | Letter editor — full-height textarea, autosave per keystroke lr_letter_<kp> | placed W10 |
| G1-0525 | M | The Memory: Portrait Mandala — 'your face in the instrument', 'she is felt, not measured' | placed M4 |
| G1-0526 | M | Memory settle: her gold point flies from the bindu to her seat, halo blooms (3400ms) | placed M6 |
| G1-0527 | M | Portrait recency warmth/cooling not implemented (DESIGN_SPEC Phase 5) | placed M5 |
| G1-0531 | M | Living Rite persisted state (lr_nav, lr_moments, lr_cross_<kp>, lr_letter_<kp>, lr_sound) | placed M1 |
| G1-0547 | M | FELT level: three rings converge inward; 'and she felt you back' at 2400ms; 'her point is lit · touch to return' | not this world (her-presence) |
| G1-0555 | M | Direction II · The Portrait Becomes the Home — your Śrī Yantra filling in petal by petal over years | placed M4 |
| G1-0556 | M | Direction III · The Daily Rite Re-Centred — thirty seconds, one breath, one gesture lights one point | not this world (today-rite) |
| G1-0570 | M | The bar §1.3 She is felt, not measured — recognition log private, never synced, never analyzed | placed M2 |
| G1-0574 | M | DESIGN_SPEC port targets §2.1–2.8 (Atmosphere, TimeVariant, day cycle, six archetypes, Detail, Recognition, Mandala, Field/Well/Portrait) | placed M1 (data) / M36 |
| G1-0576 | M | Phase 2 Recognition 102-aware: lossless migration shaktiPosition (1–16) → khadgamalaPosition (1–102) + ringNumber | placed M1 |
| G1-0579 | M | Phase 5 Portrait: 102 points near-dark brighten with felt-count, warmer when recent, cooling with neglect; no numbers ever | placed M5 |
| G1-0580 | M | Stretch: continuous ring drone; WidgetKit today's Śakti; descent as remembered film; exportable high-res Portrait; timed Silence dwell (.silence) | placed M31 (export); rest not this world (sound, today-rite) |
| G1-0587 | M | Recognition → Portrait handoff as one continuous gesture (port as one transition) | placed M38 |
| G1-0598 | M+W | The Well ≠ recognition archive (letters vs Her Moments) | placed W34 (settled §7 C3) |
| G1-0600 | M | Native persistence equivalents: RecognitionEntry (global position, local-only), EmbodimentState, DescentState, sound toggle default off | placed M1 |
| G1-0609 | M | Layer navigation routes (Memory, Relationship, Temporal instruments) | placed M3 / §5 doors |
| G1-0628 | M | Mode Recognition — The Catch: long-press anywhere; 360px sheet; 68px catch circle | not this world (modes) |
| G1-0630 | M | Mode Smṛti — Memory: long-press a ring; constellation; full · cluster · timelapse | not this world (modes; §7 C15) |
| G1-0633 | M | Mode Pūjā — Offering: evening; day's catches absorbed into the bindu (16→48px, 2.5 s) | not this world (modes) |
| G1-0635 | M | Layer instrument counts: Memory 7, Temporal 6 + contract, Relationship 6 | placed §1.4 (instruments M11-M16) |
| G1-0638 | M | Five dimensions: Depth, Time, Memory, Relationship, Practice | placed §1.1 (five dimensions) |
| G1-0681 | M | Silence V2 — Two Orbitals: Silence grows richer as rings open; bindu 76 → 78px | not this world (home/modes) |
| G1-0733 | M | Smṛti constellation: synthetic points per Ring-2 Śakti by status; recent twinkle; cluster view; time-lapse scrubber | not this world (modes; §7 C15) |
| G1-0736 | M | Pūjā screen: day's catches as cluster-colour dots absorbed into the bindu (16 → 48px, 2.5 s) | not this world (modes) |
| G1-0739 | M | Memory Layer: 'Every recognition leaves a luminous trace … The instrument starts to mirror you.' | placed M5 (petal breaths) / §1.1 |
| G1-0740 | M | PRACTITIONER_HISTORY synthetic model (intensity = min(1, total/80)) — real version reads on-device log | rejected (synthetic data, floor nothing invented; §7 C5) |
| G1-0741 | M | Memory instruments ①–⑦ subtitles (Portrait Mandala, Petal Biography, Threshold Timeline, Cluster Garden, Density Atlas, First Word·Last Word, Lifetime Spiral) | placed M39 |
| G1-0742 | M | MEM-1 Portrait Mandala — petals lit by your memory; 'Your face in the instrument' (shows counts — strip) | placed M4 / M5 |
| G1-0743 | M | MEM-2 Petal Biography — her biography with you (stat grid, moments she was here) | placed M11 |
| G1-0744 | M | MEM-3 Threshold Timeline — crossings as sacred events (sample data verbatim) | placed M12 |
| G1-0745 | M | MEM-4 Cluster Garden — five lineages with bloom meters ('some have bloomed. others are still seed.') | placed M13 |
| G1-0746 | M | MEM-5 Density Atlas — calendar heat-map of golden light (trailing year / lifetime) | placed M14 |
| G1-0747 | M | MEM-6 First Word · Last Word — the span of each relationship as a line | placed M15 |
| G1-0748 | M | MEM-7 Lifetime Spiral — every year a concentric ring of the same yantra; the seed present from year 0 | placed M16 |
| G1-0756 | M | TMP-5 Great Wheel — 365 days radially, recognition density as luminosity, moon dots, season sectors; swipe years | not this world (time); door §5 |
| G1-0765 | M | REL-3 Shakti's Carriers — who carries her into your life (reverse lookup; '‹ Portrait') | not this world (relationship); door §5 |
| G1-0766 | M | REL-4 Encounter Log — 'when she crossed between you' (sample entries verbatim) | to Bindu Feed (§6) / relationship |
| G1-0778 | M | Recognition is the spine feeding every layer (Catch → Smṛti → Portrait → Thresholds → Atlas/Wheel/Spiral → Pūjā → Encounter Log) | placed M1 |
| G1-0779 | M | Synthetic data must not ship (PRACTITIONER_HISTORY, genConstellation, density grids, LIFETIME_YEARS, Great Wheel) | placed M2 (§7 C5) |
| G2-0031 | M | CB0-07 recognition log private | placed M40 |
| G2-0039 | W | CB0-15 Well letters local-only (old) | placed W34 (placeholder line kept §7 C10; local-only superseded) |
| G2-0045 | M | HO1-03 five dimensions | merged into G1-0638 |
| G2-0051 | M | HO1-09 lifetime storage default | placed M1 |
| G2-0062 | M | HO1-20 settled items (Sādhana arc etc.) | not this world (modes/time) |
| G2-0084 | M | FB-06 write contract field ids | placed §4 data contract |
| G2-0093 | W | FB-15 locked scope | placed W34 |
| G2-0102 | W | FB-24 Well sync autosave 5 s | placed W10 |
| G2-0104 | M | FB-26 Portrait intensity formula | placed M5 |
| G2-0120 | M | DA1-06 Portrait mirror of attention | placed M4 (verification) |
| G2-0144 | M | MBB-06 RecognitionEntry migration kp+ring | placed M1 |
| G2-0150 | M | MBB-12 DescentState + Veil ladder | placed M33 |
| G2-0152 | M | MBB-14 Portrait 102 points, no numbers | placed M4 |
| G2-0153 | M | MBB-15 stretch: widget, film, export, drone, Silence | placed M31 |
| G2-0166 | M+W | DA2-11 unexplained boundaries | placed W9 |
| G2-0181 | M+W | FH-13 Field/Well/Portrait + audio engines | placed M36 / W9 |
| G2-0185 | M | FH-18 Portrait 'No numbers, ever' | placed M2 |
| G2-0186 | M | FH-19 reaching further (drone, widget, film) | placed M31 |
| G2-0199 | M | RBB-06 Ruling 4: Airtable + App Activity govern | placed M1 |
| G2-0228 | M | XMB-12 entering-ceremony compression formula | not this world (her-home) |
| G2-0234 | M | EXP-39–44 Systems ideas | not this world (modes) |
| G2-0263 | M | CCH-17 return: dwell head start, 227 s, 'you have stood here before' | not this world (her-home) |
| G2-0282 | M | THR-14 Return: expecting you, floor traces, forget me | not this world (her-home) |
| G2-0319 | M | AR-08 didSettleNotification jumps to Portrait | placed M38 |
| G2-0323 | M | ARD-01 usage never stopped, pipe broke | placed M1 (restore baseline) |
| G2-0324 | W | ARD-02 letters KP29/44/40 sync gaps | placed W10 (sync gaps fixed by M1 restore) |
| G2-0325 | W | ARD-03 WellView dirty-on-load bug | placed W10 |
| G2-0327 | W | ARD-05 UI defects SE width, z-order, sans slips | placed W9 (SE-width header fix) |
| G2-0341 | W | BV2-7 Ashrey's alone: letters, marginalia, bīja recordings | placed W9 |
| G2-0347 | M | ERR-06 App Activity six event fields + types | placed §4 data contract |
| G2-0348 | M+W | ERR-07 R17 App Activity single record | placed W33 / §4 |
| G2-0351 | W | CN-04 branch order phase-2a letters gate | placed W10 (letters gate test) |
| G2-0364 | W | BC-12 her voice authored; Well his alone | placed W34 |
| G2-0365 | M | BC-13 surviving walls | placed M2 |
| G2-0372 | M+W | WV-06 landings (Portrait layers, Gates, river Well, etc.) | placed M7 / W13 |
| G2-0376 | M | WV-10 Waves 3–5 (Origin, Play, Memory, ephemeris, gift notification, Score JSON) | not this world (time) |
| G2-0379 | M | RD-02 unmerged practitioner-notes branch | not this world (spine, the Margin); read by M22 |
| G2-0381 | M | RD-04 usage pattern | placed M1 (usage baseline) |
| G2-0390 | M | RD-14 restorable list (Veil, ring mechanisms, modes, temporal, memory) | placed M11-M16 (memory instruments); rest not this world (mandala, rings, modes, time) |
| G2-0440 | M | C6 recognition storage | placed M1 (§7 C2/C4) |
| G2-0441 | M | C7 numbers and measurement | placed M2 (§7 C5) |
| G2-0475 | M | E must-not-miss: Siddhi after-effect ~180 s; forget me | not this world (her-home) |
| G2-0476 | W | E must-not-miss: letter editor loses words on background kill | placed W10 |
| G2-0497 | M | BinduGate: place a point offering | not this world (the-33) |
| G2-0510 | M+W | Muladhara writing prompt + autosave | placed M22 (his room writings gathered) |
| G2-0517 | M | Muladhara wake-up Descent: tap where safety lived | not this world (the-33); body points shown in M25 |
| G2-0524 | M | Svadhisthana practice: Follow + writing | placed M22 |
| G2-0531 | M | Svadhisthana Memory Current: offer one word | not this world (the-33); word shown in M25 |
| G2-0540 | M | Dance Fruit (end text) | not this world (the-33) |
| G2-0541 | M | bindu-memory constellation of offered words | placed M25 |
| G2-0545 | M | Maya Phase 3 Eight Inversions | not this world (the-33) |
| G2-0846 | M | Room 33 gate opens only when all 33 offerings given | not this world (the-33) |
| G2-0865 | M | B.3.1 The 108 (beads on 4 rings) → 102-bead rosary | placed M8 |
| G2-0866 | M | B.3.2 The Seed (stage by elapsed time) | placed M8 |
| G2-0872 | W | B.3.8 The Letter (bury/burn/seal 30 days) | placed W25 |
| G2-0880 | M | B.3.16 Body Map alive/tight/absent | placed M8 |
| G2-0892 | W | BUG Hub LetterView unreachable; completed-count keys unwritten | not this world (game) |
| G2-0893 | M | B.5.2 Living Mandala (SEALED, builder-only) | placed M7 |
| G2-0894 | M | BUG Living Mandala reads seed?.ts (always none) | placed M8 (seed layer reads raw timestamp) |
| G2-0897 | M | B.5.5 The Body as Scripture | not this world (modes) |
| G2-0898 | W | B.5.6 The Child Space | not this world (game) |
| G2-0901 | M+W | B.5.8 The Correspondence (river Well ancestor) | placed W13 (generated read voices rejected §7 C12) |
| G2-0904 | M | B.5.11 The Record (print/save) | placed M31 |
| G2-0906 | M | B.5.13 The World in a Box (deriveWorld) | placed M30 |
| G2-0908 | M | Tree-of-Life cross-page localStorage contract | not this world (the-33 data); read by M1 |
| G2-0914 | M | C.2 writeWalkEvent stub; App Activity field ids; no Airtable writer | not this world (the-33 data) |
| G2-0921 | M | C.4 Grace: once, then rest; drawn from App Activity | not this world (today-rite) |
| G2-0934 | W | E Gate texts for rooms 27, 29, 32, 33 are letters | to Bindu Feed (§6) / the-33 |
| G2-0936 | M | E Maya Mirror = strongest 'everything comes back' prototype | not this world (the-33) |
| G3-0073 | M | Bindu practice page canvas: place your point | not this world (the-33) |
| G3-0081 | M | Panel 1 Muladhara wake-up (full flow) | not this world (the-33) |
| G3-0087 | M | Panel 2 Svadhisthana wake-up (six drifting lights) | not this world (the-33) |
| G3-0113 | M | Panel 6 Ajna wake-up (hold phone still; constellation of your offerings) | not this world (the-33); renderer shared with M25 |
| G3-0154 | M | ASG D26: completing 32 sets gaia-reveal-received, unlocks Gaia layer | not this world (the-33) |
| G3-0180 | M | T-WEL The Welcome guidebook and release ritual | rejected (release-everything breaks floor practice data never lost; §7 C6) |
| G3-0182 | M | T-RH The Road Home: memory hub | placed M25 / M26 (Road Home constellation) |
| G3-0183 | M | PB Practice Book: structure and dedication | to Bindu Feed (§6) |
| G3-0201 | M | P9 Phase 3 Eight Inversions (mini-reveals) | not this world (the-33) |
| G3-0203 | M | P9 Phase 6 The Mirror "The Bindu Speaks" (8 stations then/now) | not this world (the-33) |
| G3-0205 | M | P9 Recognition and Closing (Go Play) | not this world (the-33) |
| G3-0208 | M | P9 data write conflict (savePrevAnswers vs writes nothing) | not this world (the-33) |
| G3-0217 | M | D-SHELL VX dance shell | not this world (the-33) |
| G3-0234 | M | MAP-VX2 words, Tree of seven nodes, visits, Playground | not this world (the-33) |
| G3-0241 | M | G-ENGINE letters, book, store | placed M22 (the book of kept things); generated letters rejected §7 C12 |
| G3-0261 | M | BCA-GATE offerings become embers; Gaia letters at 27/29/32/33 | not this world (the-33) |
| G3-0262 | M | BCA-WEATHER weather, grace co-reader, day closes on Sakshi sentence | not this world (the-33 / today-rite) |
| G3-0271 | M | M-WORDTHREAD and M-BODYMAP | placed M25 |
| G3-0272 | M | M-BINDUMEM and M-CROSSFRUIT | placed M25 |
| G3-0273 | M | M-ESSENCE, M-RESET, M-STORE | placed M32 (reset guarded) |
| G3-0280 | M | Field reading collapse: the game holds and remembers | placed M2 (law) |
| G3-0283 | M | Road Home five doors + Standing Place | not this world (home) |
| G3-0286 | M | Three pools: essence / memory / being | placed M1 / §4 |
| G3-0287 | M | bindu-memory event kinds | placed §4 (vocabulary) |
| G3-0288 | M | Pool laws | placed M1 (pool laws) |
| G3-0324 | M | Dance count/visit lines break no-number law | placed M2 |
| G3-0326 | M | Codex source and reading rules | placed M23 |
| G3-0328 | M | C-1002 LOW-STATE LAW: offer his own words, never reassurance or reflection [KEY] | not this world (today-rite; §7 C17) |
| G3-0329 | M | C-1003 The Four Pillars | placed M23 (his words on the shelf) |
| G3-0330 | M | C-1004 Heal generational trauma (context) | not this world (relationship) |
| G3-0331 | M | C-1005 FlASH Point story: his state vocabulary (LES/HES, Ram integrates) | to Bindu Feed (§6) |
| G3-0333 | M | C-1007 Write your own story, never against yourself | placed M2 |
| G3-0338 | M | C-1018 Journal family: Codex / Emotions / Gratitude / Dreams | placed M23 (Codex only; journals private) |
| G3-0346 | M | C-1047 Telling dims the energy: Recognition private | placed M40 |
| G3-0348 | M+W | C-1057 One-tap state check-in answered from his own Codex [KEY] | not this world (today-rite) |
| G3-0352 | M | C-1067 Daily self-learning story from his entries; planning and reviewing | to Bindu Feed (§6) |
| G3-0354 | M | C-1070 Purpose = reconnection with essence; mirror from his own data | placed M23 |
| G3-0356 | M | C-1072 Mirror his own reasoning, one level deeper | placed M23 |
| G3-0357 | M | C-1074 Experiments: intention vs result (mild) | placed M23 |
| G3-0358 | M | C-1085 Rooms of light; no good/bad verdicts; close each thought; zoom-out pattern | placed M19 |
| G3-0363 | M | C-1091 Dive and return; observe, never judge; appreciate what was done | placed M2 |
| G3-0364 | M | C-1099 One-button voice capture to Codex; counter-perspective | placed M23 / W11 |
| G3-0369 | M | C-1108 Never manufacture 'something is wrong'; zoomable time | placed M19 |
| G3-0379 | M | C-1126 Send energy backward in time; loop completion | placed W19 |
| G3-0381 | M | C-1134 Name meaning across existence; Atma-Brahman part and whole | placed M24 (part and whole); story to Bindu Feed (§6) |
| G3-0382 | M | C-1135 Two faces: individual Atman / part of the whole | placed M24 |
| G3-0384 | M | C-1137 Name chosen by us (Ashrey = shelter); let go [KEY] | placed M22 (frontispiece, name) |
| G3-0401 | M | C-1174 Journey marker: Kundalini unfolding | placed M16 (§7 Q2); narrative to Bindu Feed |
| G3-0419 | M | C-1206 Recording shines light: Codex write | placed M23 |
| G3-0421 | M | C-1209 Instrument reflects his Codex to lift him out of mind games | placed M23 |
| G3-0431 | M | C-1228 Codex gaps = integration, not deficit; ask is practice [KEY] | placed M2 |
| G3-0451 | M | C-1262 Purpose: bring the witness into reality; cycle review [KEY] | placed M19 |
| G3-0474 | M | C-1287 App as a higher starting point | to Bindu Feed (§6) |
| G3-0483 | M | C-1300 Reflection proportional to what he gives; reveal unseen pattern | placed M2 |
| G3-0497 | M | C-1321 Slow down; pattern emerges from the whole Codex | placed M19 |
| G3-0499 | M | C-1325 Road Home onboarding: name, DOB, higher-self name surfaced eyes-closed; Bindu memory [KEY] | not this world (home; BinduMemory) — read by M22 frontispiece |
| G3-0512 | M | C-1346 The Correspondence: letters to past/future self; word-by-word reveal [KEY] | placed W13 / W16 |
| G3-0516 | M | C-1351 Codex → short stories with archetype comments (Bindu Feed origin) [KEY] | to Bindu Feed (§6) |
| G3-0537 | M | Miscitation: C-1120 for low-state law | placed §7 C17 |
| G4-0045 | W | Adaptive Return (VX #13): start when t>DUR·.85 ∧ e<.15 ∧ person settling within 30 s of end | not this world (the-33) |
| G4-0077 | M | Alive Fruit weave: Dwell (three variants per dance) | not this world (the-33) |
| G4-0078 | M | Alive Fruit weave: Motion (still / swaying / moving) | not this world (the-33) |
| G4-0079 | M | Alive Fruit weave: Count lines | rejected (count lines, no counts about him) / the-33 |
| G4-0080 | M | Alive Fruit weave: Echo and Thread | not this world (the-33) |
| G4-0081 | M+W | Post-word: 'what came home with you?' keep / or close | not this world (the-33); word shown in M25 |
| G4-0086 | M | Bindu Memory stars: localStorage schema, wordToPosition hash, star alpha | placed M25 |
| G4-0091 | M | Cross-panel state: previous chakra's word woven into next ('The fire forged…') | not this world (the-33) |
| G4-0157 | M | Storage pools: bindu-essence / bindu-memory / bindu-being schemas | placed M1 / §4 |
| G4-0158 | M | Deposit map: five stage gates per chakra (act1 → wakeup → practice → dance → act2), each with optional presence word | not this world (the-33) |
| G4-0159 | M | Reset: 'Begin New Journey' press-and-hold, explicit key list, never clear() | placed M32 |
| G4-0160 | M | Future API: buildWalkerSnapshot() sends three pools to a Claude endpoint | rejected (no generated voice; letters private, never analysed) |
| G4-0161 | M | Pool helpers: get/set/push, getMostRepeated() counts a word only if repeated | placed M1 |
| G4-0165 | W | OL-1 pink noise floor (7-coefficient, LP 4 kHz, gain 0.015) | placed W5 |
| G4-0169 | M | cross visual upgrade Tier 2 (reach-history thread, procession lights, resonance zones, chant haze, configuration membrane) | not this world (the-33) |
| G4-0172 | M | cross visual upgrade Tier 5 (bell footprints, Karishma valley heartbeat, Lalita constellation acknowledgment, cathedral embers) | not this world (the-33) |
| G4-0173 | M | cross.html constellation from 4 sources (chakra dances by CHAKRA_HUES, ensemble violet, legacy, being quartet clusters) | placed M25 |
| G4-0175 | W | Time 'The Wave' metaphor tiers 0-5 (second metaphor sheet) | placed W6 |
| G4-0176 | M | Time spec new pool kinds bindu-dance-completed / post-bindu-dance; bindu-memory-v2 fallback | placed §4 |
| G4-0206 | W | return (I Was Wrong) pendulum with centre warmth and embers | not this world (game); song absent (ruling 12) |
| G4-0207 | M | enough (Ordinary) ratchet staircase with persistent landings; peak lights every landing | not this world (climb) |
| G4-0224 | M | The 2.69 Hz constellation: Kingdom → Sound of Silence → Golden → Aatma → Maya | not this world (beneath) |
| G4-0239 | M | Bindu Memory constellation in the Memory world and the Bindu deep zoom | placed M25 |
| G4-0240 | M | The Word's Star: same word, same place forever; alpha .06+.10·bloom+.30·shweta | placed M25 |
| G4-0241 | M | Lalita's constellation acknowledgment 'You have been one of the dancers.' | not this world (the-33) |
| G4-0247 | W | Karishma windows: named silences where the field freezes | placed W15 |
| G4-0248 | W | Karishma valley heartbeat (~50 BPM centre pulse in the longest silence) | placed W15 |
| G4-0257 | M | Reach-history thread as a lifetime path through the 33 (Memory) | placed M25 |
| G4-0268 | W | 'The verb is its own phase': carrier alone holds after the song (Aatma; the Well) | placed W15 |
| G4-0276 | M | Sonar Ears at 33 scored songs (hidden lenses unlock) | not this world (beneath) |
| G4-0277 | W | One word per chakra song as room dance subtitle (Ground, Flow, Current, Already, Received, Open, WE, Within, Dissolve, Home, Sovereign, Before, Here, Recognition) | placed W27 |
| G4-0280 | M | Standing words (mind / body / spirit / now) as a 4-star cluster arrival ritual | placed M25 (written by today-rite) |
| G4-0292 | M | Four storage schemas for dance records → map to App Activity kinds | placed §4 |
| G4-0324 | M | Spatial memory grids 25×35; karishma_decay 0.0005 'nothing fades while the body is held in stillness'; known maps Threshold, warmth, fracture, echo, burn | placed M28 |
| G4-0330 | W | return contract: reverse generation order, Karishma final bloom, Bindu spiral; adaptive:true 'music and person find the ending together' (477) | placed W31 |
| G4-0334 | M | field_connection contract: pools essence/memory/being + app_activity {source_app Field, activity_type Ceremony Sealed} → tblJlBeiHnqGpYrL7 | placed §4 |
| G4-0335 | M | cross_dance contract: leitmotifs and constellation_visibility | not this world (the-33) |
| G4-0349 | W | Breath session 101 'ground' — Come Home (Diaphragmatic 4:8) | placed W27 |
| G4-0350 | W | Breath session 102 'balance' — The Even Breath (Box 5:5:5:5) | placed W27 |
| G4-0351 | W | Breath session 103 'open' — The Hum (Bhramari) | placed W27 |
| G4-0352 | W | Breath session 104 'clarify' — The Counted Exhale (Susokukan) | placed W27 |
| G4-0353 | W | Breath session 105 'activate' — The Stoke (Bhastrika, SCREENED) | placed W27 |
| G4-0354 | W | Breath session 106 'rest' — The Long Release (4-7-8) | placed W27 |
| G4-0355 | W | Breath session 107 'dissolve' — The Empty Pause (Bahya kumbhaka) | placed W27 |
| G4-0356 | W | Breath session 108 'expand' — The Thinning Breath (8:4:8) | placed W27 |
| G4-0357 | W | Breath session 109 'cohere' — Home Frequency (~6 bpm) | placed W27 |
| G4-0358 | W | Breath session 110 'sound' — The Ocean Breath (Ujjayi) | placed W27 |
| G4-0359 | W | Breath session 111 'sleep' — The Night Protocol (Cyclic sighing) | placed W27 |
| G4-0369 | M | cross Threshold Field: 25×35, return_decay 0.0015, hue 270 sat 35 — 'footsteps in snow the drone is dissolving'; 'Crossing leaves footprints, not heat.' | not this world (the-33) |
| G4-0375 | M | cross haptics, voice triggers (unrecorded), field connection writes, constellation visibility | not this world (the-33) |
| G4-0377 | W | abide.score.json identity: Time (Alan Walker Remix), 211.3 s, metaphor wave-v1 (17 elements), palette 220-235 / gold 35-45 only 168-180 | placed W15 (architecture only; song absent, ruling 12) |
| G4-0379 | W | abide timeline: 9 phases, 14 silences 40.8%, THE FULCRUM 21 s; two-bloom architecture 'Bloom must be allowed to FALL through the fulcrum.' | placed W15 |
| G4-0380 | W | abide ensemble hues (Karishma 40 the only warm one), leitmotifs, Ocean Field 'Water does not hold a mark; it holds a movement.' | not this world (the-33) |
| G4-0384 | W | abide binaural: 110 A2 absent fifth confirmed, presence 0.32, 13-step beat (7.83 inside fulcrum, 4.0 delta border at Recognition), no 2.69 | placed W15 |
| G4-0386 | W | abide Returning Deep, tiers t0-t5 ('EIGHT systems peak simultaneously at 170-175s… That is correct.'), haptics (no peak haptic gap) | not this world (the-33) |
| G4-0387 | M | abide optional layers, memory kinds, open personal offering, review_before_build 9 items | not this world (the-33) |
| G4-0453 | W | Ember (Sit Around The Fire, Ram Dass): sitting practice, 50.6% silence, Karishma dominant | placed W28 |
| G4-0454 | W | Unfold (Nils Frahm, Says): 55.1% silence, writing/listening sit | placed W4 (seed as invocation); song rejected (no mp3, ruling 12) |
| G4-0455 | W | Abide's fulcrum as the Well's architecture (two blooms with a held centre; Earth 7.83 inside the silence) | placed W15 |
| G4-0462 | W | Beat schedules as state arcs for the Rite/Climb/Well (arrive 8 α → descend 6 θ → hold 4.5 → Recognition 4.0 → surface 7.5→10) | placed W15 |
| G4-0464 | W | Karishma freeze in the Rite stillness gate: 'The binaural pauses with the song.' | placed W15 |
| G4-0465 | W | Designed pass-through frequencies (Schumann 7.83 at Climb apex or inside the Well's silence; 2.69 once) | placed W15 |
| G4-0470 | M | Constellation recedes at the apex and returns at the close (0.30 / 0.05 → 0.55) | not this world (the-33) |
| G4-0472 | M | Mirror word families as room answers (48 families exist verbatim across cross/abide/thunderclouds) | not this world (the-33 / her-home) |
| G4-0473 | M+W | The Word's Star as Memory's night sky / Relationship Field / Well (repeats brighten) | placed M25 |
| G4-0475 | W | 45 verbatim seeds as Today's seed of the day / Leela squares / Well invocations | placed W4 |
| G4-0477 | W | Haptic library (crossing footsteps, bell, mirror, strike, fulcrum 50 bpm, charge 46 bpm, thunder roll) for Recognition/Climb/Leela/Well | placed W32 |
| G4-0478 | W | Silence heartbeat: longest silence gets a visible and felt 50 bpm pulse | placed W15 |
| G4-0479 | M | Dance completion into App Activity (one row per completed room dance; orbit rings on danced rooms) | placed §4 (read by M1) |
| G4-0480 | M | Three storage pools (essence who / memory what / being how) as the Mandala's memory-read pattern | placed M1 |
| G4-0486 | M | Local data the app needs: spatial-memory grids per room, word-star log, danced-state per room; host <id>-data.json beside mp3 | not this world (the-33) |
| G4-0498 | M | App Activity bridge implemented:false in every Score; writes_recognition never fired — ledger floor unmet for dances | not this world (the-33) |
| G4-0555 | W | Silence structures in data (unfold 241 s near-silence; rise 37 strict windows; hold two silences 3-30 & 187-217 = 'two thresholds'; numb metronomic 1.5 s windows; journey 605-662 gap) | not this world (the-33 data) |
| G4-0585 | W | S6 Canvas depth field viz: background darkens with brainwave depth; carrier thread = sine at beat rate; 55 particles on smoothEnergy; central bloom; 18-particle burst on phase transitions; descending depth dot | not this world (beneath) |
| G4-0603 | W | 59 seed phrases incl. 11 breath seeds (verbatim lowercase declarations) | placed W4 |
| G4-0608 | M | Bindu Feed story links per track (45 rows → tbl7vzODMMJUgeX0b), e.g. press 'The Drums Were the Ground', 'The Soldier's Room'; still 'You Can't Find the Center Because You Are It'; dissolve 'The Veil That Noticed'; cohere 'Two Tones Leaning Into One' | to Bindu Feed (§6) |
| G4-0612 | W | Field Reading BINDU one-words per track and breath (ready word-set) | placed W27 |
| G4-0617 | W | Lab: free binaural instrument — set carrier/beat, save as 'my tone', bind to own kp position as the day's tone | not this world (modes) |
| G4-0622 | W | Journey/long set as Time or Well bed | rejected (no mp3 on GitHub, ruling 12) |
| G4-0677 | W | Form A3 Letter: sent forward or back, sealed to a day (NOW line; 'A letter waits. It opens <date>.' / 'A letter is ready. Open it.') | placed W13 / W14 |
| G4-0685 | W | Form A11 Answerable reflection (clauses rise 1.2 s, next 1.4-1.6 s later; 'Does this land?' lands · say more · leave my own word; month variant blur-sharpen) | placed M21 |
| G4-0694 | M | Sub-template/move: storybook--held-beats | placed M22 |
| G4-0751 | W | Gesture G27 Seal by wax | placed W14 |
| G4-0755 | W | Gesture G31 Hold to release | placed W12 |
| G4-0765 | W | Gesture G41 Tap to mark | placed W29 |
| G4-0770 | W | Gesture G46 Speak | placed W11 |
| G4-0776 | W | Corridor engine (BASE_CSS + CORRIDOR_JS): layers, step/piece arrival, --from direction, hit-test contract, nearest-centre activation, 80 ms throttle, idle when hidden, keyboard, ASGjump, remembers quietly | not this world (spine) |
| G4-0786 | W | Exemplar fieldguide.html (crisis): no play by instruction; figure a horizon that does not move; 'The alarm is real. The fire is not.' | not this world (today-rite / modes) |
| G4-0788 | M | Exemplar portrait.html (Ramana Maharshi): ages line is figure and navigation; drag the point; each moment a room (floor, train, silence 9 s halo, question, end) | to Bindu Feed (§6) |
| G4-0794 | W | Exemplar teaching a-mirror-not-a-master: three registers per law; law picker spine; the law held longest stays lit (press stored per law); Bindu Being's eight laws ('Reflect. Never dictate.' … 'A menu, not a mandate.') | to Bindu Feed (§6) |
| G4-0803 | M | Variant portrait--seer AFTERLINE: life as a line that ends, what outlasted as branches; drag past the death 'goes to what kept going' | placed M17 |
| G4-0809 | M | Variant storybook--tradition SILSILA: one lamp lit from the previous; touch the chain and a spark runs the lit length; the last lamp is yours | placed M18 |
| G4-0858 | W | Well: dictate letters on device with G46 (SFSpeechRecognizer.requiresOnDeviceRecognition), typing beside | placed W11 |
| G4-0865 | M | Memory: law 12 offers 'forget me' and 'carry your road' (dated record to keep or print) | placed M31 / M32 |
| G4-0866 | M | Memory: storybook--held-beats embers on lingered places (≥3.5/7/14 s → op .5/.72/.92, blur 14/22/32) | placed M22 |
| G4-0871 | M+W | Device-only storage (letters, asg.* localStorage keys) vs App Activity single ledger and letters sync | placed §7 C4 |
| G5-0064 | M | The patina (a piece that returns, aged) | placed M5 |
| G5-0065 | M | A ring drawn by hand, settling true | placed M6 |
| G5-0071 | M | One camera, whole to one piece (inhabited world) | placed M10 |
| G5-0093 | W | Hold to release (send by holding your mark) | placed W12 |
| G5-0094 | W | The prompt that recedes as you write | placed W10 |
| G5-0095 | W | Released, one line ('The room has changed.') | placed W12 |
| G5-0096 | M+W | Your own words, newest first ('this is where you began') | placed W29 / M22 |
| G5-0097 | M | Your colour today (eight quality colours) + your mark | placed M20 (owned by today-rite) |
| G5-0105 | M | The sky of every page (a roll you can see land) | placed M26 |
| G5-0111 | W | Hold to read (G1) | placed W16 |
| G5-0113 | W | The Descent (paper lifts, dark wells up) | placed W2 |
| G5-0114 | W | A dark room shown on the paper page | placed W1 |
| G5-0116 | W | The Still Point (G10) | placed W31 |
| G5-0118 | M | The walk log / reading becomes a sky | placed M26 |
| G5-0119 | M | The commonplace book | placed M22 |
| G5-0122 | M | Linking | merged into G5-0105 |
| G5-0123 | M | A library you fall into (nebulae) | placed M23 |
| G5-0127 | M+W | The witness that shows its sources (it lands · say more · leave my own word) | placed M21 |
| G5-0128 | M | A day as one glyph on a thread | placed M20 |
| G5-0129 | M | Time / count / touch with a 1.1 s hold ring | merged into G5-0128 (count mode rejected) |
| G5-0130 | M | The space I'm in | not this world (home, standing place) |
| G5-0131 | M | The Settle ('Held.' 'Seen.' 'Kept.') | placed M23 |
| G5-0133 | M | A month as a letter | placed M21 |
| G5-0134 | M | The gentle door toward what went quiet | not this world (home) |
| G5-0140 | W | The wandering point (presence, not target) | placed W7 |
| G5-0161 | M | Memory felt, never shown (G49) | not this world (her-home) |
| G5-0174 | M | Light, never locks: five tiers | not this world (mandala); status opacities used by M5 |
| G5-0182 | M | A portrait made of attention | placed M4 |
| G5-0193 | W | The Letter (burn, bury or seal) | placed W25 |
| G5-0208 | W | The river of letters around now (letters across time) | placed W13 |
| G5-0209 | M | Under the real hour and season (world in a box) | placed M30 |
| G5-0210 | M | A portrait made of the record (mandala of your record) | placed M31 |
| G5-0220 | M | A printable, dated record (carry your road) | placed M31 |
| G5-0222 | W | S15 The Mirror under the floor | placed W3 / W20 |
| G5-0223 | W | The Mirror's held tone | placed W20 |
| G5-0224 | M+W | A sky of walks | placed M27 |
| G5-0229 | W | Tempo per room | placed W5 |
| G5-0236 | W | A letter revealed phrase by phrase | placed W16 (phrase timing for her letters); generated stand-in rejected |
| G5-0237 | M | The book (up to 200 entries) | placed M22 |
| G5-0261 | M+W | Figure primitive PAGE (the book) | placed M22 |
| G5-0294 | M | Numbers describe them, never the reader (Count in Private) | placed M2 |
| G5-0314 | W | Ho'oponopono and Gratitude for the Well | placed W26 |
| G5-0339 | M | One memory store on the device (law 26) vs App Activity single ledger | placed M32 |
| G5-0357 | W | S7 Guide shape | placed W3 |
| G5-0360 | M | S10 Ledger shape | placed M19 |
| G5-0365 | M | S16 Portrait shape | placed M19 |
| G5-0368 | W | Word by word, breathing at punctuation | placed W16 |
| G5-0371 | W | A phrase that assembles out of order | placed W22 |
| G5-0376 | M | The whole field lit (six lights) | placed M20 |
| G5-0377 | M | The Climb, the Return and the Floor (his own lines) | placed M31 |
| G5-0379 | W | Doors as a serif line beside a slit | placed W8 |
| G5-0389 | W | The boxless word (or speak it) | placed W10 |
| G5-0396 | M | Motes in orbit — what you took up today | not this world (home) |
| G5-0402 | M | Hand-feel constants LONG / SHORT | placed M19 |
| G5-0410 | W | The carve ('you' → 'I') | placed W20 |
| G5-0411 | W | A vow arrived, or still living | placed W23 |
| G5-0425 | M | Motes round met stars | placed M26 |
| G5-0427 | M | Fall into one item | placed M10 |
| G5-0446 | W | The tunnel (Lalita Mirror) | placed W3 (tunnel) |
| G5-0447 | W | A walk as pure data | placed W20 |
| G5-0448 | W | LOOK (eyes that blink) | placed W22 |
| G5-0460 | M | Thirteen sky figures (regions with armatures and pitches) | placed M26 |
| G5-0463 | W | Nine walk figures drawn by holding | placed M27 |
| G5-0477 | M | The writing screen lit by the day's colour | placed W10 |
| G5-0478 | M | Earthed self disc; authorship by colour | placed M22 |
| G5-0487 | W | Token family Lalita (lalita chassis) | placed W36 |
| G5-0492 | M | Token family Being (being chassis) | placed M37 |
| G5-0493 | W | Token family Learning (learning chassis) | placed W36 |
| G5-0524 | M | Visual language for Memory: being (day / dusk) + candle sheet for the printed record | placed M37 |
| G5-0525 | W | Visual language for The Well: lalita "under" + learning dark | placed W36 |
| G5-0539 | M | Site law 8: memory, never permission | placed M2 |
| G5-0552 | M | The site as sixth app on the ledger | placed M1 |
| G5-0556 | M | The wall: publish what was learned; keep what it was learned from | placed M40 |
| G5-0567 | M | Three storage pools: essence · memory · being | placed M1 |
| G5-0572 | M | Five doors of the Road Home + Standing Place + Seed Planting | not this world (home) |
| G5-0591 | W | Lemuria: breath → words | placed W4 |
| G5-0592 | W | Atlantis build–hold–erode (a dissolution mechanic) | placed W25 |
| G5-0600 | W | Stitch points in love (how the app asks for a word) | placed W10 |
| G5-0601 | M | The Arc constellation (invitation, sequential nodes) | placed M29 |
| G5-0607 | M | Gate-continue: the line grows, the node appears, your word below | not this world (the-33) |
| G5-0641 | W | Cursor/touch presence in dark worlds | placed W5 |
| G5-0657 | M | Walked state as a trace, not a count | not this world (the-33 / climb) |
| G5-0660 | M | Cinematic viewer (focal zoom, swipe, cross-dissolve) | placed M19 |
| G5-0679 | M | 3D page-turn and dot rail | placed M22 |
| G5-0682 | M | Person filter dimming | not this world (relationship) |
| G5-0688 | W | 'Don't engage' stillness gate (Guard 13) | placed W35 |
| G5-0689 | W | Wake Lock in still phases (Guard 14) | placed W35 |
| G5-0912 | W | Topic: Gratitude (L-1352) | placed W26 |
| G5-0972 | W | Topic: The Brain Dump: An Emotion Coping Activity (L-1088) | placed W25 |
| G5-1010 | W | Topic: 3.4 Drawing Safety (L-1023) | not this world (beneath) |
| G5-1031 | W | Topic: Rumi (L-1358) | to Bindu Feed (§6) |
| G5-1124 | W | Topic: Hawaiian Ho'oponopono - Cleaning the Lineage | placed W26 |
| G5-1200 | W | Topic: Jungian Shadow Work | not this world (beneath) |
| G6-0376 | M | Map · Linked Builds · 1 Bindu | not this world (the-33; Linked Builds) |
| G6-0377 | M | Map · Linked Builds · 2 Muladhara | not this world (the-33; Linked Builds) |
| G6-0378 | M | Map · Linked Builds · 3 Svadhisthana | not this world (the-33; Linked Builds) |
| G6-0379 | M | Map · Linked Builds · 4 Manipura | not this world (the-33; Linked Builds) |
| G6-0380 | M | Map · Linked Builds · 5 Anahata | not this world (the-33; Linked Builds) |
| G6-0381 | M | Map · Linked Builds · 6 Vishuddha | not this world (the-33; Linked Builds) |
| G6-0382 | M | Map · Linked Builds · 7 Ajna | not this world (the-33; Linked Builds) |
| G6-0383 | M | Map · Linked Builds · 8 Sahasrara | not this world (the-33; Linked Builds) |
| G6-0384 | M | Map · Linked Builds · 9 Shadow | not this world (the-33; Linked Builds) |
| G6-0385 | M | Map · Linked Builds · 10 Soles | not this world (the-33; Linked Builds) |
| G6-0386 | M | Map · Linked Builds · 11 Forge | not this world (the-33; Linked Builds) |
| G6-0387 | M | Map · Linked Builds · 12 Prana | not this world (the-33; Linked Builds) |
| G6-0388 | M | Map · Linked Builds · 13 Hands | not this world (the-33; Linked Builds) |
| G6-0389 | M | Map · Linked Builds · 14 Pulse | not this world (the-33; Linked Builds) |
| G6-0390 | M | Map · Linked Builds · 15 Sonar | not this world (the-33; Linked Builds) |
| G6-0391 | M | Map · Linked Builds · 16 Echo | not this world (the-33; Linked Builds) |
| G6-0392 | M | Map · Linked Builds · 17 Vision | not this world (the-33; Linked Builds) |
| G6-0393 | M | Map · Linked Builds · 18 Axis | not this world (the-33; Linked Builds) |
| G6-0394 | M | Map · Linked Builds · 19 Crow | not this world (the-33; Linked Builds) |
| G6-0395 | M | Map · Linked Builds · 20 Armin | not this world (the-33; Linked Builds) |
| G6-0396 | M | Map · Linked Builds · 21 Inception | not this world (the-33; Linked Builds) |
| G6-0397 | M | Map · Linked Builds · 22 Intention | not this world (the-33; Linked Builds) |
| G6-0398 | M | Map · Linked Builds · 23 Inspiration | not this world (the-33; Linked Builds) |
| G6-0399 | M | Map · Linked Builds · 24 Insight | not this world (the-33; Linked Builds) |
| G6-0400 | M | Map · Linked Builds · 25 Intuition | not this world (the-33; Linked Builds) |
| G6-0401 | M | Map · Linked Builds · 26 Invention | not this world (the-33; Linked Builds) |
| G6-0402 | M | Map · Linked Builds · 27 Incarnation | not this world (the-33; Linked Builds) |
| G6-0403 | M | Map · Linked Builds · 28 Innocence | not this world (the-33; Linked Builds) |
| G6-0404 | M | Map · Linked Builds · 29 Integration | not this world (the-33; Linked Builds) |
| G6-0405 | M | Map · Linked Builds · 30 Maya | not this world (the-33; Linked Builds) |
| G6-0406 | M | Map · Linked Builds · 31 Aatma | not this world (the-33; Linked Builds) |
| G6-0407 | M | Map · Linked Builds · 32 Ego Reveal | not this world (the-33; Linked Builds) |
| G6-0408 | M | Map · Linked Builds · 33 Lalita | not this world (the-33; Linked Builds) |
| G6-0485 | M | Map · App Activity inverse link empty | not this world (the-33 / verification; Link to The Map) |
| G6-0488 | M | Map · Codex References (carried, unshown) | not this world (the-33; Codex References) |
| G6-0566 | M+W | Map gift #10 · Three letters' practices lifted out as energy | placed W21 |
| G6-0571 | M | Map gift #15 · Maya's transparency, as sound and glass | not this world (the-33) |
| G6-0594 | M | Map gift #41 · Echo's daily report | placed W24 |
| G6-0595 | M+W | Map gift #42 · Incarnation's sentence | placed W24 |
| G6-0632 | M | ASG table · Codex | placed M23 / §4 |
| G6-0645 | M | ASG table · The Builds | not this world (the-33 / beneath; The Builds) |
| G6-0650 | M | ASG table · App Activity | placed §4 |
| G6-0651 | M+W | ASG table · Walks | placed M27 / §4 |
| G6-0664 | M+W | Walk W-001 · The Catching Machine | placed M27 |
| G6-0665 | M+W | Walk W-002 · The Measuring Stick | placed M27 |
| G6-0666 | M+W | Walk W-003 · The Roof Beam | placed M27 |
| G6-0667 | M+W | Walk W-004 · The Same River | placed M27 |
| G6-0668 | M+W | Walk W-005 · The Hand That Moved First | placed M27 |
| G6-0669 | M+W | Walk W-006 · The Echo | placed M27 |
| G6-0670 | M+W | Walk W-007 · Two Ledgers | placed M27 |
| G6-0671 | M+W | Walk W-008 · The Quieter Room | placed M27 |
| G6-0672 | M+W | Walk W-009 · The Earned Self | placed M27 |
| G6-0673 | M+W | Walk W-010 · Seeing Is Solving | placed M27 |
| G6-0674 | M+W | Walk W-011 · The Story That Stole the State | placed M27 |
| G6-0675 | M+W | Walk W-012 · The Doorway | placed M27 |
| G6-0676 | M+W | Walk W-013 · His Father's Voice | placed M27 |
| G6-0677 | M+W | Walk W-014 · The Lack He Made the Center | placed M27 |
| G6-0678 | M+W | Walk W-015 · The Furnace | placed M27 |
| G6-0679 | M+W | Walk W-016 · The Soldier's Room | placed M27 |
| G6-0680 | M+W | Walk W-017 · The Hot Voice | placed M27 |
| G6-0681 | M+W | Walk W-018 · The Man Who Ran to Stand Still | placed M27 |
| G6-0682 | M+W | Walk W-019 · The Righteous Corrector | placed M27 |
| G6-0683 | M+W | Walk W-020 · I Am Too Much | placed M27 |
| G6-0685 | M | Walks · Entry rows private; belief correspondence; ledger link gap | placed M27 / §4 (§7 C14) |
| G6-0686 | M | Builds · type counts and fill | not this world (the-33; The Builds) |
| G6-0723 | M | App Activity · usage counts (160 rows) | placed M1 (verification baseline) |
| G6-0731 | M+W | ASG gift #7 · 'Shared with' as offering | not this world (relationship) |
| G6-0738 | M | ASG gift #14 · The ASG life timeline | placed M16 (§7 Q2) |
| G6-0741 | M | ASG gift #17 · Pratikramana's nested review as the answer to a missed day | placed M19 |
| G6-0743 | M+W | ASG gift #19 · The Walks sky | placed M27 |
| G6-0744 | W | ASG gift #20 · Vow You / Vow I as a paired recognition | placed W21 |
| G6-0746 | M | ASG gift #22 · The Builds as a map of everything made | not this world (the-33) |
| G6-0751 | W | ASG gift #27 · Gratitude for a person returns as that person's light | not this world (relationship / today-rite) |
| G6-0752 | W | ASG gift #28 · Thank You Past Ash / Future Ash I Promise (shape only) | placed W24 |
| G6-0754 | M | ASG gift #30 · Field-% as the shape of the day | placed M20 |
| G6-0755 | W | ASG gift #31 · Witness Line, Lalita's one line of the day | not this world (today-rite); generation rejected §7 C12 |
| G6-0771 | M | ASG C5 · App Activity under-uses its own design | placed W33 / §4 |
| G6-0773 | M | ASG C7 · Walks and the Mandala | placed M27 (§7 C14) |
| G6-0785 | M | Code core · ActivityLedger.swift (1371) · the ledger vocabulary | placed §4 |
| G6-0788 | M+W | Code core · CodexWrite.swift (129) · his word to Codex | placed M23 / W30 |
| G6-0800 | M | Code core · DescentState.swift (78) | placed M33 |
| G6-0803 | W | Code core · LetterDraft.swift (27) | placed W10 |
| G6-0804 | M | Code core · LivingMandala.swift (111) · Portrait geometry and year ring | placed M7 |
| G6-0805 | M | Code core · MarginNote.swift (79) | placed M22 (margin notes in the Book) |
| G6-0806 | M | Code core · MonthReading.swift (187) · Month Mirror and Portrait glyphs | placed M21 |
| G6-0808 | M | Code core · RecognitionEntry.swift (66) | placed M1 |
| G6-0810 | W | Code core · ShaktiLetter.swift (50) | placed W9 |
| G6-0818 | M | Code core · HeartRegister.swift (275) · kīrtan / bhajan register | not this world (modes) |
| G6-0822 | W | Code core · Ephemeris.swift (431) · the real sky | placed W14 |
| G6-0824 | W | Code core · DailyEnergyService.swift (99) · who presides today | placed W14 |
| G6-0827 | M | Code core · RiteDay.swift (344) · three doors, grace, Sakshi close | not this world (today-rite) |
| G6-0833 | M+W | Code core · ThreePools.swift (127) | placed M1 |
| G6-0834 | M | Code core · PlayTraceStore.swift (105) + PlayGardenStore.swift (88) | placed M8 |
| G6-0835 | M+W | Code core · CorrespondenceStore.swift (376) · the river | placed W13 / W17 |
| G6-0836 | M | Code core · PortraitStrokeStore.swift (157) | placed M9 |
| G6-0839 | M | Code core · BinduMemory.swift (79) · the name his higher self gave | placed M22 (frontispiece reads BinduMemory) |
| G6-0840 | M+W | Code core · CodexNoteStore.swift (54) | placed W30 |
| G6-0841 | M+W | Code core · SpeechCapture.swift (224) · his voice kept | placed W11 |
| G6-0843 | M+W | Code core · PracticeLedger.swift (98) | placed W33 |
| G6-0844 | M | Code core · MarginNoteStore.swift (112) | placed M22 |
| G6-0845 | M | Code core · RecognitionLogStore.swift (92) + RecognitionMigrator.swift (55) | placed M1 |
| G6-0867 | M | Code core · Two local stores record the same game act | placed M8 (§7 C18) |
| G6-0882 | M | Code gift #14 · Grace including the sister apps | not this world (today-rite) |
| G6-0883 | M | Code gift #15 · Sakshi close + MonthReading | to Bindu Feed (§6); Sakshi close not this world (today-rite) |
| G6-0884 | W | Code gift #16 · Low-state door | not this world (today-rite) |
| G6-0885 | M+W | Code gift #17 · The river, light sent back, recipients, patina | placed W19 / W13 |
| G6-0886 | M+W | Code gift #18 · His own voice kept + on-device transcription | placed W11 |
| G6-0889 | M | Code gift #21 · The Portrait as a living mandala | placed M7 |
| G6-0896 | M+W | Code gift #28 · Three pools | placed M1 |
| G6-0909 | M+W | Code gift #41 · Codex write of his own word | placed W30 |
| G6-0919 | M | Code missing · Ledger vocabulary gaps | placed §4 (vocabulary) |
| G6-0932 | M | Code C-6e · Measuring-word bans (floors, not lifted) | placed M2 |
| G6-0948 | M | Code C-17 · Story material in an energies app | to Bindu Feed (§6) |
| G6-1028 | W | Homes parity · Well letter as a folded object in the room (§4.5) | not this world (her-home); reads W10 letters |
| G6-1065 | W | Homes upgrade C4 · Build the Rite light room (R-09/R-11) as a mode of the Home | not this world (her-home) |
| G6-1068 | M | Homes upgrade C7 · Return: 'you have stood here before', floor traces, forget-me | not this world (her-home) |
| G7-0038 | M | Felt dot ramp removed (one felt size) | placed M2 |
| G7-0119 | M | Grace line | not this world (today-rite) |
| G7-0123 | M | Sakshi close | not this world (today-rite) |
| G7-0126 | M | LowStateDoor (his own words) | not this world (today-rite) |
| G7-0135 | M | Recognition close sequence | placed M38 |
| G7-0137 | M | Recognition settles to Memory only from Today | placed M38 |
| G7-0165 | M | Route today: Rite -> LowStateDoor | not this world (today-rite) |
| G7-0406 | M | Designed piece: The Book | placed M22 |
| G7-0414 | W | Designed piece: Sketchbook: Seal | placed W14 |
| G7-0417 | M | Designed piece: Sanctuary Gates / Field / Mirror; Body as Scripture; Child Space; Seven Gates; Correspondence | merged into G2-0901 (Correspondence → W13); rest not this world (game, modes, rings) |
| G7-0451 | M | Gift: Word thread / body points across rooms | not this world (the-33); shown in M25 |
| G7-0476 | M | The Book: a single place for what he chose to keep | placed M22 |
| G7-0497 | M | Ring-1 seat geometry mismatch Modes vs Portrait | placed M4 (§7 C8) |
| G7-0511 | M | Smrti full constellation | not this world (modes) |
| G7-0512 | M | Smrti reads local record only | placed M1 |
| G7-0513 | M | Smrti missing views | not this world (modes) |
| G7-0519 | M | Portrait mandala geometry and layers | placed M4 |
| G7-0520 | M | Portrait settle flight after recognition | placed M6 |
| G7-0521 | M | Portrait export 'hold this image' | placed M31 |
| G7-0522 | M+W | Portrait six doors | placed M34 |
| G7-0523 | M | Portrait whisper 'she is felt, not measured' | placed M39 |
| G7-0524 | M | Portrait brightness driven by count | placed M5 (§7 C1) |
| G7-0525 | M | Portrait ring-2 local index kp - 28 | placed M4 |
| G7-0526 | M | Portrait settle: silence flies as felt | placed M6 |
| G7-0527 | M | Portrait petals not tappable | placed M10 |
| G7-0528 | M | Portrait year ring current year only; local store only | placed M16 / M1 |
| G7-0529 | M | LivingMandalaLayers | placed M7 |
| G7-0530 | M | LivingPlayLayers as states | placed M8 |
| G7-0531 | M | LivingPlayLayers root asymmetry | placed M8 |
| G7-0534 | W | The River (Correspondence) | placed W5 / W13 |
| G7-0535 | W | Light sent back and higher-self name | placed W19 (higher-self name not this world: home) |
| G7-0536 | M | Archive as a book | placed M22 |
| G7-0537 | M | Month Mirror | placed M21 |
| G7-0538 | M | Month letter template-composed | placed M21 (§7 C13) |
| G7-0539 | M | Where She Speaks body of light | not this world (climb / her-presence) |
| G7-0541 | M | Descent film | placed M33 |
| G7-0542 | M | Descent film dates only from ring 3 | placed M33 |
| G7-0543 | M+W | VoiceWord buttons (his voice only) | placed W11 |
| G7-0544 | W | The Well: letters to all 102 | placed W9 |
| G7-0545 | W | Well is a list page off the hamburger | placed W5 |
| G7-0557 | M | The Margin | placed M22 (margin notes read); the Margin itself spine |
| G7-0581 | M | Time and Memory reached through the Portrait | placed M34 |
| G7-0582 | M | Memory instrument: Petal Biography | placed M11 |
| G7-0583 | M | Memory instrument: Threshold Timeline | placed M12 |
| G7-0584 | M | Memory instrument: Cluster Garden | placed M13 |
| G7-0585 | M | Memory instrument: Density Atlas | placed M14 |
| G7-0586 | M | Memory instrument: First Word . Last Word | placed M15 |
| G7-0587 | M | Memory instrument: Lifetime Spiral | placed M16 |
| G7-0588 | M | Memory: The Record built | placed M31 |
| G7-0589 | M | Memory's seven instruments as rooms | placed M10-M16 |
| G7-0590 | M | Local-only memory conflicts with 'practice data never lost' | placed M1 |
| G7-0591 | W | Beneath not built as a world | placed W1-W5 (Well chamber); rest not this world (beneath) |
| G7-0592 | W | Beneath as one underground space | placed W31 (door down); not this world (beneath) |
| G7-0598 | M | Svapna as he designed it | not this world (modes) |
| G7-0600 | M | Smrti three views | not this world (modes) |
| G7-0604 | M | Embodiment crossing chosen by him | placed M12 (owned by her-presence) |
| G7-0606 | M | The Record as gift object | placed M31 |
| G7-0632 | M | Snapshot baseline: memory.geom | placed M39 |
| G7-0636 | W | Snapshot baseline: well.geom | placed W9 (snapshot baseline) |
| G7-0637 | W | Snapshot baseline: well-letter.geom | placed W10 (snapshot baseline) |
| G7-0644 | M | UI: TheMarginUITests data safety | placed M22 (margin data safety; spine) |
| G7-0652 | M | LawsTheMarginTests | placed M22 (spine floor) |
| G7-0663 | W | LetterMigrationTests | placed W10 (letter migration test) |
| G7-0664 | W | LetterDraftTests | placed W10 |
| G7-0665 | M | MarginTests | placed M22 (spine floor) |
| G7-0670 | M+W | WaveSixMemoryTests | placed M1 / W13 (test) |
| G7-0676 | M | RiteDayTests | not this world (today-rite) |
| G7-0720 | M | LivingMandalaTests | placed M9 |
| G7-0732 | W | TheRiverTests | placed W18 |
| G7-0889 | M | Floor test: LawsTests.swift:1340 | placed M2 (floor test) |
| G7-0890 | M | Floor test: LawsDrawnMeasureTests | placed M2 (floor test) |
| G7-0891 | M | Floor test: OneBuildingTests C-1284 | placed M2 (floor test) |
| G7-0892 | M | Floor test: RiteDayTests.swift:148 ('Nothing was asked of you today.') | placed M2 (floor test) |
| G7-0893 | M | Floor test: PlayTests.swift:520 | placed M2 (floor test) |
| G7-0894 | M | Floor test: PlayTests.swift:542 | placed M2 (floor test) |
| G7-0895 | M | Floor test: TheRiverTests.swift:150 (Wager) | placed M2 (floor test) |
| G7-0896 | M | Floor test: ModesAndRitesTests.swift:104 (Smrti one light) | placed M2 (floor test) |
| G7-0897 | M | Floor test: RiteDayTests.swift:116 (grace never of today) | placed M2 (floor test) |
| G7-0898 | M | Floor test: GameStructureTests.swift:232 (ThreePools state not tally) | placed M2 (floor test) |
| G7-0899 | M | Floor test: TheLibraryFoldTests.swift:152 | placed M2 (floor test) |
| G7-0984 | M | Test gift: HomeMemory gentle compression | not this world (her-home) |
| G7-0995 | M+W | Test gift: ThreePools routing | placed M1 |
| G7-0998 | M | Test gift: LowStateDoor for hard days | not this world (today-rite) |
| G7-0999 | M | Test gift: Witness pages, Garland Recited, Day Offered | not this world (her-presence / modes) |
| G7-1001 | M | Test gift: GraceChannel across sister apps | not this world (today-rite) |
| G7-1002 | M | Test gift: SakshiClose evening close | not this world (today-rite) |
| G7-1005 | M+W | Test gift: The River through time | placed W13 |
| G7-1007 | W | Test gift: Panchanga engine verified against USNO | placed W14 |
| G7-1010 | M | Test gift: Living Mandala Portrait | placed M7 |
| G7-1011 | M | Test gift: MonthReading | placed M21 |
| G7-1014 | M | Test gift: The ledger's own vocabulary | placed M26 |
| G7-1016 | M | Test gift: The Margin everywhere | not this world (spine) |
