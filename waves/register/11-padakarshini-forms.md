# THE REGISTER · 11 — padakarshini: the forms, the gesture grammar, the exemplars
*Second reading, 12 Oct 2026 (night). Reader 11. Source root: `/root/.claude/skills/synced/…/padakarshini/` (below: `SKILL.md`, `forms.md` = `references/forms.md`, `contract.json` = `references/forms-contract.json`, `gestures.md` = `references/gestures.md`, exemplars by short path).*

**Lens.** The last build turned chakra rooms and Śakti Homes into text pages. padakarshini is the engine that turns a field of understanding into something you **walk one step at a time**. It holds 26 forms with data contracts, a gesture grammar (G0 hold engine, G1–G50, six input adapters), a ceremony grammar, seven forms of time, and 34 working HTML exemplars. Each exemplar shows a different way to reveal text **by an act rather than by reading a page**. This file lists all of it in §A. §B maps every piece onto the app's fifteen worlds: the 33 rooms × five threads, Her Home, the Rite, the Well, Beneath and the games.

---

# A · Inventory

## A0 · SKILL.md (101 lines) — what the engine is

- **Formula** (`SKILL.md:19`): `PAGE = CORRIDOR × FORM × WORLD-or-FIGURE × CONTENT`.
  - **Corridor**: "one piece of information per screen. Scroll is movement: *in* (converge), *out* (open), *walk* (travel). A count, a hint once, then silence." Snap-scroll. "a tall piece scrolls inside itself, never skipped" (:21).
  - **Form**: 26 grammars, each with "one mechanism of its own and a data contract" (:22).
  - **World** (for reading forms): what moves behind the text. The list is point, spine, panels, pulse, wave, stars, earth, sky, descent, rings, yantra, lights, breath, split, thread (:23).
  - **Figure** (for doing and seeing forms): "a drawn thing that *is* the content and changes with the scroll: rings lit, a sun crossing, a jar filling, a breathing circle, a life-line … **Never a generic world where a figure is owed.**" (:24)
  - **Content** "arrives through the contract. The engine never invents copy." (:25)
- **The twelve forms, one line each** (:28–41): icebreaker (walk) · storybook (in) · teaching guide (walk/out) · practice card (walk) · walk (out, descent) · field guide (walk) · portrait (in) · map (in) · two chairs (walk) · recipe (walk) · calendar (walk, split) · verse (in).
- **Fourteen more from the design corpus** (:43): Rite · Mirror walk · Letter · Gates of release · Breath session · Play-it piece · Four-section reading · Voice · Still Point · The day's line · Answerable reflection · Wager · Scored performance · Board. Also four ways in (threshold card, two-door station, the Veil, home by how far walked), the ceremony grammar, seven forms of time, and what the walk form becomes. Plus the **guide** and the **door**, a register with a die (:45).
- **Three layers** (:47–51): (1) Form, made of fixed hooks (`.step > .piece`, `#w`, `#fig`, `#count`, `#hint`) and a contract, "Never redesigned per page"; (2) Sub-template, a variant per topic family set by `data-variant` on body; (3) Move, "one choice per page that belongs to that topic alone". "Variants change what is drawn, never what is hooked."
- **How the laws are read** (ruling of 11 Oct, :53–54): laws are "settled moves, not walls". Two floors hold everywhere: **truth** ("gates open on the act, timers count, no claimed past, no invented count") and **access** ("a keyboard path, one way out, contrast for text"). "**the experience as designed is the law**: no rule removes, softens or shortcuts a designed hold, gate, wait, count, sound or line in an existing experience."
- **Laws** (:57–64): one piece per screen ("Nothing taller than ~700px at 390 wide. Split lists to three, one Q&A per screen, one voice per screen"); only true when true; plain language on the surface; attribution holds; readable at the darkest point (`readable()`, the descent ink brightens as it falls); wellbeing (pointers, not pages); copy nothing; "The hoop doesn't hurry. Three per form, walked, then the rest."
- **Nineteen laws from the design corpus** (:66–86), verbatim keys:
  1. "How you touch a thing is the teaching." One gesture per place, "whose shape is its meaning: stay, follow, part, bear, keep pace, carry a light." A held Enter or Space is the keyboard path for every hold. No one-tap shortcut.
  2. "A hold is the hold it was designed to be." An early release drains and never fails. The act waits for the release.
  3. "Crossings happen while the hand keeps asking."
  4. "Stillness is an input." A touch pauses the count and never resets it.
  5. "Staying opens things; nothing new is locked." A deeper turn arrives at about a minute. Designed gates stay: the walk's 3-day cooldown is restored.
  6. A ceremony "may open with one breath and close with a hold that carves or lays down — a whisper and one warmer light rather than a checkmark."
  7. "Walk it or read it, as equals."
  8. "One gesture carries one register. Favoured: vertical walks the axis, sideways is the place's own gesture, a full swipe moves one step, never four."
  9. "Discovered, not instructed": one hint, once, then silence.
  10. "Words arrive at the reader's pace or the breath's. A touch asks; the next exhale answers."
  11. "The page may know the day; it doesn't count the reader." No streaks and no "N of M" about the reader, "never tiered by returns".
  12. "Memory is felt rather than shown, and can be let go." Dwell, not visits. "*forget me* and *carry your road* always offered." On the device: "one key per thing under one prefix".
  13. "Nothing is staged to show that something happened."
  14. "Leaving is one gesture everywhere, never punished." Esc, a left-edge drag or the back link. "the rope reaches a quiet room from anywhere."
  15. "Readiness may be sensed; crossing is chosen."
  16. "Every place moves as what it is." A place "may be known by its tempo before its name".
  17. "Score before building; test the room; ship with proof." Five tracks; "could this belong to any other place?"
  18. "Paper is where you read; dark is where your reading is reflected. Going down is one crossing (a hold that resists, then gives)."
  19. "Two sides meet at one shared structure, each keeping its home": a knowing page and a playing page carry "one quiet door to each other ('play it' · 'read it')".
- **Gates** (:88–89): walk every step in a real mobile browser (`verify_walk.py`, Playwright, 390×844). Zero unlit steps, zero JS errors, no piece taller than a screen. Then "the person walks three."
- **Process** (:91–92): register (topic · lake · primary form · secondary form · why) → the person rules → one form, three topics, walk → Design (sub-templates) → re-walk → Code → Git → Builds table.
- **Sisters** (:94–97): "rupakarshini wins on look, padakarshini wins on step."
- **Lessons learned the hard way** (:101): "the 55%-visible bug, dark accents on dark grounds, the descent ink, tall pieces, collapsing twice into one form and being unflattened by 'look before you make.'"

## A1 · forms.md (284 lines) — the 26 forms, the ways in, sub-templates, ceremony, time

### A1.1 · The twelve (22 Sept)
| # | form | screens in order | its one mechanism | dir | contract (verbatim) | line |
|---|---|---|---|---|---|---|
| 1 | Icebreaker | name + two sentences · *Ask one of these* (3–5 q) · *Worth knowing* (one Q&A per screen, ≤5) · *Words to know* (3 per screen) · *A voice* (one per screen, ≤5) · *A line to leave them with* · door to storybook | hand-over-able: one tap copies the questions | walk | `{name, one, questions[], five:[[q,a]], words:[[term,def]], voices:[[name,role,line]], line}` | 6–9 |
| 2 | Storybook | title+summary · ten pages (title · affirmation · text ≤150 words) · *Before you go* · door to icebreaker | "never a summary; the fable does the work"; cover image blurred behind | in | `{name, one, questions[], pages:[[title,aff,text]]}` | 11–14 |
| 3 | Teaching guide | title · the teaching in one breath · before the laws · each law (law · because · what it looks like today) · the practice · close + source | three registers per law; a picker of the laws | walk/out | `{title, sub, one, opening, laws:[[law,because,looks]], practice, close, source:[line,href]}` | 16–19 |
| 4 | Practice card | title · When · How (numbered) · Now (breathing circle + timer) · After + source | "the circle grows 4 / shrinks 6; the timer waits" | walk | `{title, one, when, steps[], seconds, after, source}` | 21–24 |
| 5 | Walk | title + how the gate works · each day (title · piece · carry · "I read this — start the clock") · closing | cooldown in localStorage; day n opens `cooldownDays` after day n−1 is marked; "never closes; never counts". World: descent (ink brightens) | out | `{title, one, cooldownDays, days:[{n,title,piece,carry}]}` | 26–29 |
| 6 | Field guide | title · *Which is it?* picker · each situation (When · Do · Because) · closing + see-a-professional | the picker jumps to the situation | walk | `{title, one, line, situations:[{when, do[], because}]}` | 31–34 |
| 7 | Portrait | name + dates + one · five moments (age · title · text) · line + door | life-line across the top; the point travels. Families sage · scientist · seer · poet | in | `{name, dates, one, moments:[{age,title,text}], line, open}` | 36–39 |
| 8 | Map | title · one node per screen (numeral · name · gloss · text) · line + source | "the structure drawn (rings · spine · tree · grid · geometry); current node lit" | in | `{title, one, nodes:[{n,name,gloss,text}], line, source}` | 41–44 |
| 9 | Two chairs | title · the question · rounds (left, right) · *Where are you sitting?* · held open + line | sit in a chair; the last screen answers it; never picks | walk | `{title, one, question, left:{who,says[]}, right:{who,says[]}, held, line}` | 46–49 |
| 10 | Recipe | title · need · do · watch for · keep | the process drawn *above* the list (jar filling, days ticking) | walk | `{title, one, need:[[item,amount]], steps[], watch, keep}` | 51–54 |
| 11 | Calendar | title · when · hours (time · what) · why · if you're there + line | "the sun crosses; lamps light; the split world" | walk | `{title, one, when, day:[{time,what}], why, do, line}` | 56–59 |
| 12 | Verse | title · each line (original · gloss) · whole · line | original above, gloss beneath; public-domain originals only | in | `{title, one, lines:[{orig,gloss}], whole, line}` | 61–64 |

Also the **Guide** (title · in one sentence · a Tuesday · why I made it · what's inside · what it refuses to do · if you want to try it; "first person for the *why*") and the **Door** ("Every built page in one list, grouped by kind, with a scoped shuffle"). Neither has an exemplar (:66–71). The 21 family variants are listed at :74–75. Routing: `routing.json` has 916 instances, `doors.json` has 406 sibling pairs.

### A1.2 · The fourteen from the design corpus (§A, :89–185), with every number
- **A1 · Rite: a reading received, not read** (:91–95)
  - Screens: arrival (the place's mark breathing · "One <thing> has come to meet you." · title · "touch to receive") · the reading ("every paragraph already on the page, unlit; each touch lights one") · the gathering (voices, one line per touch) · the recognition ("one line from the reader, spoken or typed, 'yours to mend'") · the sealing ("a struck bowl; 'The room has changed.'; the close").
  - Who speaks in full: "each day keeps two voices and one from a rotation (`rota[]`, keyed on the date) in full, the rest pass with one line or stay silent; the zeroth voice is never silent. Never tiered by a count of the reader's returns."
  - Density: a full voice costs `(1.4 + 1.4·lines + 1.4 if it has a closing line + 2.8)` s, a passing line 4.2 s, the centre 6.6 s. (A past self at 9 s per return was "not carried".)
  - Ground `#050408`.
  - Contract: `{title, place:{name,glyph,color}, kicker, body[], voices:[{who,glyph,color,lines[],passing,close?}], kept[], rota[], prompt, close:[line,sub]}`. Exemplar: A Strange Feed, The Rite v3.
- **A2 · Mirror walk: a walk under the floor** (:97–102)
  - Screens: door (G14) · arrival (three first-person lines; held threshold) · three teachings, word by word, with a hold between each (figure depths **0.32, 0.60, 0.85**) · "look" · one question with a field (skippable; then "the unnamed") · the glass returns the reader's word with one reflection (held gate) · the vow, "offered in the second person and carved in the first by a ~2 s hold (G32)" · walk out (the figure completes, light floods over **1.4 s**, "the sky receives you, one star warmer").
  - Word-by-word timing: **~250 ms a word, +430 ms at a full stop, +180 ms at a comma**, each word "sharpening from a 4 px blur, never breaking mid-word".
  - Ground `#0e0c14 → #07060c`; "the typeface changes at the crossing".
  - Sky of walks: walked lights warm `oklch(0.92 0.08 90)`, waiting lights violet, breathing at staggered 3.2–6.2 s. A tap zooms into a light (scale 7, 1.15 s). A proposed walk looks like any waiting light; its trace ("this room came from what you said") shows only at its exit.
  - Contract: `{id, name, hue, figure, arrival[3], teachings:[{text,depth}]×3, question, reflection, vowYou, vow, exit, status:'live'|'proposed', trace?}`.
- **A3 · Letter: sent forward or back, sealed to a day** (:104–109)
  - A NOW line across the page: forward letters above it, back letters below.
  - Back letters are addressed to an age, a year, a moment or a feeling. Forward letters go to a date or a number of months, or to tomorrow / a week / a season.
  - "one breath before sending"; it floats above or below the line; "A letter waits. It opens <date>." / "A letter is ready. Open it."; it can be read at once or revealed slowly (~1.5 words/s).
  - Mechanism: "sealed to a date; nothing opens early; the seal is dragged on (G27) or held."
  - Guard: "a letter returns by itself, with no reply and no peek; a forward letter opens at local midnight of its civil date (no 30-day months). Letters stay on the device."
  - Contract: `{title, one, letters:[{dir:'back'|'forward', to:{kind:'age'|'year'|'moment'|'feeling'|'date'|'months', value}, text, made, opens?}], reveal:'direct'|'slow'}`.
- **A4 · Gates of release** (:111–116)
  - The descent is drawn as arches down one line. Only the next arch is lit (a torch-flicker); passed ones keep a hollow glow.
  - Each gate: a whisper, a question, a field. Then "set it down by a hold (G33) or keep it (G26) — both allowed". The gate then reads "· passed ·", with the first of the reader's words in small italic "in that visit only (a laid-down word is stored nowhere)".
  - The return rises, "one gift received at each gate (tap)". "The ground darkens a step at each gate and lightens on the way up." Progress is kept between visits; nothing is locked.
  - Contract: `{title, one, gates:[{name, gloss, question}], gifts:[], close}`. Guard: "authored lines with one seam".
- **A5 · Breath session, chosen by intention** (:118–124)
  - Intentions: ground, activate, open, clarify, dissolve, expand, rest, balance.
  - The session card shows the breath as three tiles (in / hold / out s), a frequency claim with an honesty badge **S · T · C**, and minutes **3 · 5 · 10 · 15**. A strong session gets a gentle screen first ("four conditions … 'do any of these speak to where you are today?'").
  - The circle scales **0.7 ↔ 1.2**, with exhale cue words "written as the sound itself, 'mmm', 'haaa'". One recognition line appears "once, at 45% of the time, for 4 s".
  - Shapes (in/hold/out): 4/4/8 · 5/0/5 · 4/2/6 · 4/0/8 · 6/0/2 (screened) · 4/2/12 · 4/6/8 · 5/5/5 · 4/0/6 · 4/0/8.
  - Contract: `{title, intention, one, inhale, hold, exhale, minutes[], cue, seed, recognition, screened?:{conditions[], guidance}, tiers?}`. Exemplar: Bindu Field, Bindu Akash.
- **A6 · Play-it piece: one gesture, one line, no score** (:126–131)
  - Objects: beads, a seed, a corridor, a drum, two pads, a vessel, a flame, a spiral, rings, tiles.
  - Real time: a seed "sprout at 2 h, sapling at 8 h, tree at 24 h, flowering at 72 h".
  - Contract: `{title, verb, line, gesture:{g, params}, close, keep, realTime?:{unit, stages[]}}`. Guard: "a count that survives closing is drawn (beads lit), not printed."
- **A7 · Four-section reading** (:133–138)
  - Opens on "the reading material of this world is <verb>". Sections: **SAY** (the confusion the rush holds) · **WALK** (the evidence) · **HAND** (what this equips you with) · **OPEN** (the invitation, "always opens and never closes").
  - Each section arrives by one of G2–G8. "There is no generic reading, not even as a fallback."
  - Contract: `{title, kind, one, world, voice, say, walk, hand, open, status:'walked'|'in progress'|'seeded'}`. Exemplar: the Feed's `point-content.js`.
- **A8 · Voice: a chapter read by hand** (:140–145). Hold to read (G1). Each speaker has a pace. "one heart phrase arrives slower and in the accent; where attention broke, an ember stays." The end screen is "Where you stayed", then the speaker is named. Contract: `{chapter, speaker, pace, text}` with one `**heart phrase**`.
- **A9 · Still Point: each hold takes something away** (:147–151). Seven stages: invitation · full sentence · shorter claim · short line · a few words · only the ember, breathing · a closing line that releases you. "type grows as text shortens; chrome goes; the ground darkens; 'Surface' is always there." Contract: `{title, stages:[invite, sentence, claim, line, words, null, release]}`. Placement: "at the foot of a teaching, never gated".
- **A10 · The day's line, in three persons** (:153–158)
  - One screen: a point and its glow, then the line resolving line by line out of the dark, a signature, and "leave".
  - The three persons: *to* you (second person, "— the field"); *back* to you ("drawn only from what the reader sealed on this device"; marked "a vow · arrived" with a filled point or "still living" with an open circle; one "draw once more" a day); *about* the world.
  - "chosen from the local practice day alone … the same all day; … no 'return tomorrow' promise".
  - Contract: `{persons:{to:[{lines[], sign}], back:{from:'device'}, about:[{line, href}]}, pick:'date', redraw:1}`.
- **A11 · Answerable reflection** (:160–165)
  - Each clause rises over **1.2 s**; the next follows **1.4–1.6 s** later. A faint source line, then "Does this land?" with three answers: it lands · say more · leave my own word (kept) · plus "tap to be told again".
  - Month variant: one line "whose words sharpen out of blur as you scroll to them".
  - Contract: `{line[], sources[], answers:['lands','more','own']}`. Exemplar: Bindu Being, The Lalita Reflection.
- **A12 · Wager: carry this into the day** (:167–172). One thing to watch for, then "I'll carry this". Days later (3 in the export), on first open: "Did it appear?" yes · a glimpse · not yet. Yes or a glimpse seals a line; "not yet restarts the carrying". Contract: `{offer, dueInDays, states:['offered','active','sealed'], responses:['yes','glimpse','notyet'], note}`.
- **A13 · Scored performance: a timed piece written as data** (:174–179)
  - Screens: seed question (one word, no box) · the piece played from its Score (phases, scored silences, crescendo, each voice entering at its own second, mirror words flashing) · the word returned at the peak · the fruit ("a text woven from how the reader was: still, swaying or moving") · close.
  - Crescendo: modulator ramps **145 → 160 s**, holds to **180 s**, releases by **195 s**; climax tier above **0.25**.
  - Contract: `{title, durationSec, phases:[{name,from,to}], silences:[{from,to}], crescendo:{rise:[a,b], hold, release, threshold}, entries:{voice:sec}, mirror:{times[], words[]}, seed, fruit:{template, weaves[]}, close}`. Exemplar: `bindu-performance-engine.js`.
- **A14 · Board: a game of positions** (:181–185)
  - Screens: what you bring ("my life" or "what I'm building") · the board (positions in their own colours; rises and returns drawn; a token) · the throw ("a held die, G29, in A Strange Game · play; a plain tap on the die in Leela on the 33; a six enters; an exact landing arrives") · each landing opens a room · at the last position, the whole walk read back · a care line.
  - Each landing room holds: the position's question, how you came (rise or return, and why), "a practice first ('I did it' · 'Let it be'), then a reading, one move for today, a seed to carry, and a door to the position's own page".
  - Contract: `{title, positions:[{n, name, color, question, line, practice, href?, held?}], rises:[[from,to]], returns:[[from,to]], enter, exact, care}`. Care line, verbatim: "If today is heavy, the board can wait. Three breaths is a whole game."

### A1.3 · Four ways in (§B, :187–203)
- **B1 · Threshold card.** One small thing before entering, chosen by weight, "never the same kind twice": threshold sentence (**40**), a practice of one breath (**23**), a question about the body today (**20**), something real that found you (**12**), the point alone (**5**). "The very first open is a threshold. A tap anywhere crosses … nothing auto-advances." Contract: `{kinds:[{kind, weight, label, accent, body, sub?}], first:'threshold', noRepeat:true}`.
- **B2 · Two-door station: walk it or read it.** Two halves, each named in its own word (read · letter · speaks), each with a duration line. "Two flames … *half* when one is lit, *whole* when both are. After a walk, the written version is offered 'now, while it is still warm'". Contract: `{name, walk:{verb, hint, href}, read:{…}|null, flames:{walk, read}}`.
- **B3 · The Veil.** The image stays whole ("look, do not operate"). A veil drawn up (G42) holds the places as a column by depth, with tiers *You are here · Open · Ground · Ahead · Veiled*. "Places ahead sit behind a dashed, uncrossed line; nothing is locked." Contract: `{places:[{n, name, line, tier}], image}`. Exemplar: Bindu Mandala, Mandala Veil and Legend.
- **B4 · Home by how far you have walked.** Three homes. A black splash on first arrival only (**1.6 s**). "return. / the road remembers" only for a returner after days away (**2.3 s**). One overlay per arrival. A completion ceremony: line at **0**, a point swelling at **1.1 s**, a second line at **2.4 s**, gone at **3.8 s**. "read from the device's own event record, never from a stored 'done' flag." Contract: `{states:{arrival, partway, returned}, read:'device-events'}`.

### A1.4 · New sub-templates and moves for the twelve (§C table, :205–241)
- icebreaker: voices gather after you finish (Feed Story Detail).
- storybook:
  - `storybook--held-beats`: three held beats (kindle · part · spread), **1500 ms** each (G0), always advanceable by a tap. On return, embers mark panels lingered on (≥ 3.5 / 7 / 14 s).
  - `storybook--return-pass`: told inward, then outward, with "one chime per screen climbing a scale inward and descending it outward" (Bindu Blink).
- teaching:
  - move: laws arrive by one of G2–G8.
  - `teaching--voice` (G1).
  - move: the descent reveal ("each card rises as it is reached (1 s, from 10 px)").
  - move: Still Point at the foot.
  - move: received as a Rite.
- practice:
  - `practice--breath-is-the-hold` (G29; three beads; "one breath is a whole practice").
  - `practice--camera` (G22, sixty seconds).
  - `practice--tempo` (G23).
  - move: the opening breath ("a breath ring (5.5 s, four ticks, a progress arc, 'breathe', then 'tap to enter' … the ring is not a hold)").
  - move: the seven forms of time.
  - `practice--ladder-of-centres` ("one body cue and one tone per centre, climbing, 60 s each (15 s quick)"; Chakra Game Hub).
- walk:
  - `walk--gates` (A4 as a walk).
  - `walk--growing` (2 h · 8 h · 24 h · 72 h).
- fieldguide:
  - `fieldguide--when`: the picker names states, verbatim: "When the mind won't land", "When something goes unseen", "When seeking is the obstacle", "When you doubt what you know", "When something feels missing" (Chakra Game, Sacred Experiences).
  - `fieldguide--body`: touch where it speaks (G40).
- portrait: `portrait--voice` (identity always open; words earned by staying, G30).
- map:
  - `map--yantra-walk`: "the structure walked inward by scroll at constant size; only your ring lit; stars marked walked ● · in progress ◐ · seeded ○; the visit told back at the centre" (Feed, The Point v9).
  - `map--veil` (B3).
  - `map--sky`: every page a star on the golden angle, the die at the centre.
  - `map--climb`: "the body as altitude: bands of weather, a rail naming the region, fly into a light, three touch beats in, sideways doors to neighbours" (Mandala, The Homes and The Axis).
  - move: arrows step a ring (G43).
  - `map--circulation`: "one sentence travels round it hop by hop; each station says what it takes in, gives out and keeps".
- twochairs: authorship by colour.
- recipe: nothing new.
- calendar:
  - `calendar--day`: "doors that change with the hour, walked doors dim, 'close the day' on one sentence; the morning question and the evening offering as its two ends" (Mandala, The Eight Modes).
  - `calendar--sky`: "five wheels round the point (hour, lunar day, lunar mansion, season, sun sign), one lit bead each" (Mandala, The Temporal Layer).
  - move: breathing on the wall clock: an 8 s breath with phase `(now mod 8000)/8000` "so every open copy breathes in step"; an hourly gathering of 3 min on the UTC hour.
- verse:
  - move: focus, not fade ("each line rises 14 px while its blur clears 6 px → 0 over 3.2 s").
  - move: written by an unseen hand ("a name drawn stroke by stroke in its own script (transliteration first; never a seed syllable)", Mandala, The Rite of Entering).
  - move: the inversion (words arrive out of order and settle).
  - move: words from particles (the line sampled into points that gather out of rising particles on an exhale).
- **MOVES.md play rows to add** (:243–256): stillness G2 (FIELD, ORB) · follow G3 (LINE, RAIL) · part G4 (FIELD, PAGE) · bear G5 (FIELD) · pace G6 (RINGS) · carry G9 (FIELD, RINGS) · deepen G10 (FIELD) · receive G11 (PAGE, FIELD) · turn G24 (RINGS, POLY) · trace G18 (SPINE, POLY, PATH) · tempo G23 (ORB, COUNT).

### A1.5 · The ceremony grammar (§D, :258–268)
Order fixed; a form names which steps it uses:
1. **Open with one breath.** Three options: the 5.5 s breath ring with four ticks ("the ring is not a hold"); a hold of one full breath (**5 s**) "that also unlocks sound, the screen wake lock and one soft haptic"; or a breathing circle. "Nothing is asked for before the breath."
2. **Come nearer in beats (optional):** three touches, each writing itself (G35); "shortened on return, never skipped".
3. **The act.** One gesture. A word is "asked without a box: the question in large italic, the word appearing large in the accent with a blinking cursor over a thin rule, and 'or speak it' beneath."
4. **The answer, in the world's own material:**
   - fire "flares from low (focal 50% 96%, **5.5 s**, four rising ripples)"
   - water pools (**6.5 s**, four ripples)
   - air disperses (**6.0 s**, five wide ripples, off-centre)
   - ether blooms once (**4.8 s**, three)
   - earth settles (**7.5 s**, two)
   - light radiates (**3.8 s**, five)
   - with materials: stone settles, glass rings, paper folds.
5. **Close with a hold that carves or lays down:** G32 carve ("offered as 'you', carved as 'I'"), G33 lay down, G31 send.
6. **"What is left is a whisper and one warmer light, never a checkmark."** "The room has changed." · "Held." · "Seen." · "Kept." · "…and <it> felt you back". "A logged moment settles into the field over **1.4 s** under one word."
7. A sealing sound: one struck bowl, only where sound is on.
8. **Return to where you were**, on the breath you left on. The Feed's `walk-continuity.js` carries depth, breath phase and what was carried in `sessionStorage` for **90 minutes**; "the breath clock is never restarted mid-walk".
9. Proof: no staged answer, nothing counted, end state shown under reduced motion, every hold done by a real hold and by a held key.

### A1.6 · The seven forms of time (§E, :270–279)
"A practice's timer is never a clock; it is a form that breathes, fills or blooms." Begin and close by a **1.1 s** hold ring (G0). The form can be switched mid-session from a rail of seven glyphs.
1. **Aperture** (stillness): a breathing point of **34 px** inside a **200 px** glow; three rings of **150 px** expanding, staggered, on a **9 s** pace.
2. **Pace** (guided breath): in **4 s**, hold **4**, out **6**, rest **2**. The glow scales **0.62 → 1.12 → 0.62** on `0.5 − 0.5·cos(πk)`, with the phase word beneath.
3. **Trail** (movement): `climb = 1 − exp(−minutes / max(6, 0.7·usual))`; glow size `60 + 150·climb` px. "a quiet marker passes when you go beyond your usual (at 0.9 of it), unannounced."
4. **Hold** (effort as stillness): "a line held taut while pressed, trembling **1.2 px at 0.18 s**; it drops **16 px** when released."
5. **Bloom** (thought becoming a constellation): each tap drops a mote; the ground glows up to **0.34** with elapsed minutes/60.
6. **Orbit** (being with): each tap adds a presence, up to **nine**, on radii **50 / 88 / 126 px**, periods **14–29 s**, alternating direction.
7. **Night** (sleep): falls to dark over **2.5 s**; **34 stars** twinkle on **3–7 s**; a floor line; an ember breathing on **9 s**.

Guard: no "longest hold", no mote count.

### A1.7 · What the walk becomes (§F, :281–284)
`cooldownDays` keeps its meaning, with waiting cards reading "This day is still closed. It keeps its own time." A new walk may choose "one a day, if you like". A walk may be a descent, a growing figure, or a river of letters. It remembers by dwell and offers *forget me* and *carry your road*.

## A2 · forms-contract.json (191 lines)
Two arrays.
- `existing` (3): icebreaker, storybook, teaching. Each has slug, label, exemplar, href, rule, contract.
- `new` (23): practice, walk, fieldguide, portrait, map, twochairs, recipe, calendar, verse, rite, mirrorwalk, letter, gates, breath, playit, fourfold, voice, stillpoint, dayline, reflection, wager, score, board.
- Total **26**, which matches SKILL. Exemplar names: Belly Breathing, Thirty Days With Anxiety, When It Feels Like a Panic Attack, Ramana Maharshi, The Nine Dimensions, 432 Hz or 440 Hz, Kombucha at Home, Diwali, The Gāyatrī, then the corpus sources.
- `rule` lines worth quoting:
  - walk: "a cooldown clock in the browser; the next day opens after the last, never before" (:40)
  - map: "the big numeral — position is the content" (:61)
  - letter: "time is the lock, and only time opens it" (:110)
  - stillpoint: "each hold removes something … until only the point breathes" (:152)
  - reflection: "The reader has the last word." (:166)
- The JSON contracts are **abbreviated** compared with forms.md. Mirrorwalk drops `×3` and the status enum. Letter drops the `to.kind` enum. Dayline drops `from:'device'`, `pick:'date'`, `redraw:1`. Score drops the shapes of crescendo, entries and fruit. Wager drops the enum values. Treat forms.md as the fuller source; see C.

## A3 · gestures.md (333 lines) — the grammar, every number

### How to use (:11–17)
- A page names its gesture by number (`data-gesture="G4"`); the gesture brings its own keyboard path, tap, reduced motion and fallback. One gesture per place; vertical walks, sideways is the place's own.
- **Tap test** (from the Rite's `useTap`): moved < **9 px** on both axes and lifted within **700 ms**.
- **Hold cancel:** movement beyond **9 px** (the Door uses 7 px; a still touch uses 24 px). Pointer-up, pointer-cancel, pointer-leave and window blur all release.
- Switch off the system long-press only on the control that owns a hold (`touch-action:none; user-select:none; -webkit-touch-callout:none`).
- **"One way out of every withholding mode"**: a "read plainly" choice that turns every withholding mode off (G1–G8, G10, G11) for new builds.

### G0 · The hold engine (:19–45)
- The law: completion needs a real hold or a held key; an early release does nothing; the act waits for the release; there is "no tap rate and no play-through".
- Engine:
  ```
  tick: dt=min(64,t−last); p += target>p ? dt/UP_MS : −dt/DOWN_MS (clamp)
        p≥1 && !locked → locked=true; onCommit()   (the visual commit, at the threshold)
        p==0 && target==0 → stop
  press(): target=1 (pointerdown, or keydown Enter/Space; e.repeat ignored)
  release(): locked&&!done → done=true; onComplete()   (act on release)
             else target=0  (drains)
  ```
  "Commit on the threshold, act on release: permissions, audio, navigation and anything sent wait for the lift."
- **Durations in the corpus**, choose by meaning:
  - 700 ms (site `.hold`)
  - 733 (Lalita Mirror gate bars, +0.075/55 ms)
  - 750 (Living Rite embodiment crossing)
  - 900 (Instrument Light carve minimum; Living Axis fall to source)
  - 1000 (seal the Ceremony)
  - 1100 (Being hold ring; the Point's gate burst; the rope)
  - 1250 (Lalita Mirror door)
  - 1300 (Threshold cross; Still Point stage)
  - 1400 (rewind)
  - 1500 (Story beat)
  - 1900 (deck shuffle)
  - 2200 (die throw)
  - 2300 up / 620 down (Compose release)
  - 2600 (Seven Gates lay down)
  - 2800 (Child Space)
  - 2900 / 750 (The Turning)
  - 4000 (Archetype Profile ring; Sakshi Pause inhale)
  - 4200 (the Light, draw one line in)
  - 5000 (Bindu Immersive Act 0, one breath)
- Bands: commit 0.7–1.3 s; ceremonial 1.1–2.9 s with a drain; > 3 s only where the hold *is* the act.
- Early release drains at DOWN_MS **620–750 ms**, or eases **0.04/frame**. "Never a failure sound, never a jolt back to zero."
- Haptics: a tick at press (8 ms web); a continuous ramp **0.15 → 0.6**, sharpness ≈ **0.3**; one latch at completion (12 ms web / medium impact native); no buzz on early release.
- Accessibility: `role="button"` named for the act ("hold to release into the field"); `role="progressbar"` with `aria-valuenow` while held; states announced.

### G1–G50, each in brief
| G | name | source | mechanism and numbers | keyboard / tap | line |
|---|---|---|---|---|---|
| G1 | Hold to read | Learning App, the Voice | Words assemble while held; each fades in **~260 ms** (opacity 0→1, translateY 6→0, blur 3→0). Base **560 ms/word**; heart words **1150 ms (×1.5)**; after `. ; : ! ?` +**440 ms×pace**; after `,` +**210 ms×pace**. Pace per speaker **1.0 · 0.82 · 1.15 · 1.34**. On release the last word becomes an ember: tiers <1.5 s · 1.5–4.5 · 4.5–12 · ≥12 s (pulses); dwell capped at 60 s. A break ≥ **2.5 s** is kept as a `held` phrase (~4-word window). End: "Where you stayed", 2–3 phrases, then the speaker named. Haptic tick per word ~0.3, none under ~90 ms gap. | held Enter/Space; no tap | 47–55 |
| G2 | Stillness | Feed Reading world I, Instrument v3 gate, Light v2 Approach, Light S-L01 Dawn; Mandala Eight Modes; Chakra Game Water Level | **Reading:** come near the star (< **52 px**) and stop (< **0.9 px/frame**); every **1.5 s** of stay a section surfaces (4 in all); moving decays it ×0.6; a speed > **2.2** closes them; ring `r = 26 + breath·3` drawn to `stay/1.5`; field alpha `1 − (given/4)·0.62`. **Gate:** `GATE_MS = 4600`; "busy" = finger down or input within **340 ms**; a touch pauses and never resets ("every still second he has ever given is kept"); one line after **700 ms**, once ever; tone swells over 4.6 s, gone 0.22 s after a touch. **Approach:** stone acoustic opens over **8.5 s**; calm eases toward `acc/4600` at **0.035/frame**. **Dawn:** agitation (down +0.5, move +0.06, wheel/key +0.3, accel `m>0.9` adds `min(0.25,(m−0.9)·0.05)`), decays ×0.35/s, still < **0.06**; the scene opens after **12 s** of stillness; "eyelids open **only during inhales**, over 28 s of inhaling. Words then come only on the exhale, after two breaths of silence." **Depths:** 3 s / 30 s / 2 min; captions at 7, 14, 21, 28 s. **Still touch:** one finger for **5 s**; a move > 24 px restarts; the point leans `min(5 px, d·0.02)` at 2.2/s. **Water Level:** |ω| < 0.006, |angle| < 0.06 rad, held for **30 s**. | rest at keyboard; no tap | 57–68 |
| G3 | Following | Feed Reading world II | Nine rays (groups 3/4/2; twist 2.30/1.55/0.72 rad; base −0.55/1.05/3.35; spread 1.02/1.34/0.62; reach 1.0/0.74/0.86 of R = 0.42·min(W,H)). Press within **70 px** of a ray; travel eases 0.18/frame to `d/(0.94R)`; it reels back ×0.94/frame. `given = floor(travel·4.4)`; only the band you are in shows; other rays dim to 0.34 and pulse 1.9× faster. | held key travels | 70–74 |
| G4 | Parting | Reading world III | Four curtains drift 0.020/0.034/0.013/0.047 (×260 px/s) at densities 0.30/0.24/0.20/0.16 × 0.94. Press: a parting of **r 104 px**. A section is given after **1.35 s** with the parting over the star (within 1.5×104). It leaves a thin zone r 96 at 0.55. Text masked by `radial-gradient(circle 104px at x y,#000 62%,transparent 100%)`, so it can only be read through the opening. | held key | 76–79 |
| G5 | Bearing | Reading world IV | Press builds at `dt·(0.55 + pressure·1.1)`/s and falls 1.5/s. Below **0.12** there is no impression ("a quiet line says so"). A section strikes every **0.9 s** at depth d; struck sections stay (`scale(0.985+0.015d)`, drop-shadow 0.6+1.4d px). A vertical gauge. "nothing here is a tap, because an impression cannot be made by touching". | held key at 0.55/s | 81–84 |
| G6 | Keeping pace | Reading world VII; Point Portal (the Dance); `dance-world.js` | Three lanes, r `(0.30+i·0.215)·R`, speed `(1.42−i·0.30)·0.16` rad/s. Catch within **56 px**; keep within **84 px**; a section lands every **1.15 s**; let go and the rest scatter (scatter fades 1.4/s). | held key | 86–89 |
| G7 | Turning panes | `world-five.js` | 11 two-sided panes, five facing pairs plus one on the mirror line. 0.75 of the shell = half a turn; sections at turns 0, π, 2π, 3π; every other one arrives mirror-written and unflips; the lone pane gives nothing and returns you. | held key/arrow | 91–94 |
| G8 | Send and wait | `world-six.js` | Take a star, aim, let go. It returns with one section; laps **3.2, 5.4, 8.0, 11.2 s**; flights run on the wall clock ("what returns while you are away waits at its post, lit"); every arc is kept thinly in the sky. | hold to take, release to send | 96–99 |
| G9 | Carried light | Mandala Ring Worlds II, ring 6 (`RingSixWorld`) | A light follows the finger (0.18 s), r 2.1×92 px. Ten marks on a ring of r 96; opacity `(1−d/92)·0.85`. A tap names a mark only within **92 px** ("can't name what the light hasn't reached"); the whisper fades after **3.2 s**. Tone gain `0.05·(1−d/92)`, else 0.004. | arrows 24 px; Enter names | 101–104 |
| G10 | Still Point | Learning App, `stillHoldStart` | Seven stages; one hold of **~1.3 s** per stage; type ≈ **18 → 25 → 29 → 33 → 41 px**; chrome goes; ground darkens; "Surface" always there; haptics recede 0.25 → 0.15 → none. "add nothing here: no progress, no reward. The reward for depth is quiet." | held key | 106–110 |
| G11 | Received as a Rite | Feed Rite v3 | Paragraphs unlit `opacity 0.05; blur(5px); translateY(11px)` → lit over **2.6 s** (`cubic-bezier(.2,.7,.2,1)`); each tap lights one and scrolls it to **52%** of the screen. Base line "received at the pace of breath". "The field gathers" fades in over 2.5 s. Gathering: each voice sounds `(4 + lines·3.6)` s; the first enters at **2.4 s**. Recognition: one line; bowl; "The room has changed." at **3.6 s**; close at **7.6 s**. | Enter = tap | 112–117 |
| G12 | Pull to turn | Feed, The Door | Long-press timer **1100 ms**, cancelled > 7 px; pull follows `pull/120·10px`, dims `1 − pull/120·0.35` (cap 120); past **84 px** the list opens. A 2×2 dot mark is a real button. | Enter on dot; Esc | 119–122 |
| G13 | The rope | Feed Door `Rope()`; Instrument v3 | A **1.1 s** long press anywhere opens a black room: an ember in a breathing ring, "two full breaths (10 s each) before any words, one line of reassurance, two ways out". A tap before the words jumps to them. | held key 1.1 s | 124–127 |
| G14 | The Descent | Lalita Mirror `enterStart`; Learning App Descent | Door: press and the veil rises; at **1250 ms** the floor gives. An early release is refused with nothing said; a two-finger hold also works. Passage **2.35 s**, `cubic-bezier(0.66,0,0.24,1)`: paper lifts `0 → −104%` (9–55% of time); the dark plane wells `104% → 0` with a warm horizon; ember **11 px** scales 0.45 → 1 → 1.18 at 55% → 0.7; a ~4% seam. Plays the first time and at every Threshold; otherwise the everyday dark veil (**1.5 s**). Sound: **110 Hz** + a +6 ¢ twin + a fifth **164.81 Hz**, gain **0.13**, peaks ~0.8 s, gone by 1.25 s; body-thud 0.9/0.15 at the crossing. Reduced motion: still a 1250 ms hold, then a 0.3 s fade. | held key; no tap ("only deliberate holding moves you") | 129–134 |
| G15 | Membrane push | Instrument v3 `T.update`; The Chrome | Tension `t = 1 − min(1,|q−at|/span)`, span **0.36**. Push accrues only toward the surface and when t > 0.02: `push += |force|·30`; decays 0.18/s with no hand. Brake `(1 − 0.58·t·(1 − 0.85·push))^(dt·60)` when t > 0.30; it hands back `0.0016·t`/frame if lifted with push < 0.5. At push ≥ 1: a ring flashes out in **26 shards**; passage **5.4 s**; stays open (tension ×0.20). "Immense" preset `DRAG 0.00018 · DAMP 0.956 · span 0.42 · glide 5.4 s · WHEEL 0.00008 · PINCH 0.0020`, `K = 393/frameWidth`. Gearing: "a full swipe is one register, never four (240 px = one register in the Rooms; clamped to ±1)". | held arrow | 136–141 |
| G16 | Consent pull | Feed, The Seam | Each pull move sets `asking = 6` frames. At the mouth (`smoothstep(0.84,0.96,depth) > 0.35`) consent rises **0.0075/frame** (~2.2 s) while asking, and falls 0.012 otherwise. "It never fires on its own." | held key | 143–146 |
| G17 | Two holds of the centre | Mandala Ring Worlds II, ring 9 (`ring-nine.jsx`) | **Inward:** self-similar figures at scale `0.03·2^(6.4·d)`, fade in over the first 10%, out over the last 28%. Idle speed 0.85 → **3.0** held; drains 1.4×. Past **6.5 s** a recognition ramps in over **2.2 s**; speed `3.0 − 2.2·recog`; the point swells `1 + 1.7·recog`. **Outward:** bloom p eases 0.06/frame to 1 while held, else an idle breath (period **12 s**, peak 0.62). Layers at p = 0.06 root triangle · 0.24 triangles · 0.42 inner petals · 0.54 outer petals · 0.66 frame · 0.80 names. **Shepard tone:** 7 sines over 7 octaves from **32.7 Hz**, glide `0.05 + 0.10·intensity` oct/s, bell `exp(−((phase−0.5)/0.26)^2)·0.42`, master `0.07·intensity`. | held key | 148–153 |
| G18 | Trace | sketchbook Trace; Chakra Game, Sri Yantra trace | **Spiral:** `r = 320 − 16.5·t`, t∈[0,6π], 720-unit canvas; line 7 wide, fades over **9 s** (0.95 → 0.40); a tick every 260 ms; done within **26 units** of centre after > 40 points; "wherever your finger goes is right". **Line by line:** each line traced end to end; accepted when both ends fall within **22 px**, either direction; progress kept. | held key draws | 155–159 |
| G19 | Shake | Mini Games, Shake to Clear | `delta = |Δx|+|Δy|+|Δz|` > **18** adds 0.3 (cap 1); decays 0.04/frame; words drift ×(1+4·shake) and fade (1−shake). A tap adds 0.5. iOS: `requestPermission()` from a tap. | Enter = tap | 161–165 |
| G20 | Tilt | sketchbook, Still | Target `x = C + clamp(γ·9, ±300)`, `y = C + clamp((β−10)·9, ±300)`; the drop follows at 0.12. Inside r **46** a gold ring fills over **7 s**; outside it drains 0.004/frame. "Held." Fallback after **1.8 s** with no reading: "drag the drop to the middle and rest your finger there". | arrows | 167–170 |
| G21 | Microphone loudness | site `/tree-of-life/vishuddha-wakeup` | `fftSize 256`; volume = mean/255; `v = 0.8v + 0.2raw`. Above **0.05** it acts (loosens `v·0.012`/frame, only increasing); above **0.08** marks spawn every 300–400 ms; complete at **0.92**. Fallback "tap to loosen". "Nothing is recorded." | taps | 172–175 |
| G22 | Front camera | Chakra Game The Mirror; Sanctuary | Mirrored, dimmed face inside a silver ring filling over **60 s**; a whisper at start and at the midpoint; afterwards a line whose letter-spacing closes **0.2em → 0.04em**. No camera: "the whisper says you are already here". | — | 177–180 |
| G23 | Tempo | sketchbook Beat; Mini Games Drum, Corridor, Coherence, Mantra Tuner | `avgBPM` over the last 6 taps. **Beat:** 1000 ms, **98 Hz** bell; second drum **147 Hz** 500 ms after; on-beat ±**130 ms** rings gold; closeness ±1; at **8** "The music answers." **Drum:** 1000 ± 180 ms; root grows to 20. **Corridor:** steps of 800–1200 ms; door of light from step 18; done at 24 (the red flush is left out). **Coherence:** `1 − |h−b|/max(h,b)`, waves merge > **0.82**. **Tuner:** target `round(f/8)`, tuned within 5% after ≥6 taps. "show no tap counts or scores". | Enter/Space | 182–190 |
| G24 | Turn rings into alignment | sketchbook, Turn | Rings r **300/215/130** (34 wide, 720 canvas); picked by distance (>237, >152, >60); a tick every 15°; snap within **0.12 rad** with bells **392, 490, 588 Hz**; aligned under 0.08; all three aligned → the centre lights. | arrows 15° | 192–195 |
| G25 | Drag two together | sketchbook, Join | On overlap, slide to the midpoint and fade (700 ms, `cubic-bezier(0.65,0,0.35,1)`); a third tile blooms **0.3 → 1.08 → 1 over 1.1 s** with one line. | Enter picks, Enter joins | 197–200 |
| G26 | Set down or keep | sketchbook, Release | Card tilts `dy/40`°, fades `1 − min(0.6,|dy|/400)`. Past **90 px** down it is set down (falls 420 px, scale 0.8, 1.1 s); past 90 up it is kept (rises 320, 0.8 s). The ground darkens per card; on the way up gifts rise to be tapped. | held arrows | 202–205 |
| G27 | Seal by wax | sketchbook, Seal | Write; choose 1 / 7 / 90 days; drag the wax onto the letter; it folds (900 ms, `scaleY(0.2) translateY(−60px)`), a settle tone, "A letter waits. It opens <date>." / "A letter is ready. Open it." With no words, nothing is sealed. | Enter picks / sets | 207–210 |
| G28 | Rewind by held spiral | sketchbook, Choose | Hold **1400 ms**; −540°×p; consequence fades `1 − 0.8p`; the choice is undone and offered again; a journal keeps every branch; "Live this one". | — | 212–215 |
| G29 | The hold is the move | A Strange Game · play | Die **2200 ms** (rattle while held); deck **1900 ms** (trembles `rotate(sin(18p)·2.5p deg)`); breathe in **4000 ms** (circle r 46 → 110), let go to breathe out **5200 ms**; three beads; "One breath is a whole practice. Stop here." Early release: "No hurry." Leela on the 33 keeps its tap die. | held key | 217–219 |
| G30 | Colour through staying | Feed Player Detail (The Turning) | G0 with UP **2900** / DOWN **750**; light l drives grey (`saturate(0.32) brightness(0.70)`) → full colour; words legible past **l = 0.55**. | — | 221–223 |
| G31 | Hold to release | Feed, Ash's Compose | G0 **2300 / 620**; armed only when there are words. | Tab to ring + hold | 225–227 |
| G32 | Carve | Light v2 `drawIn` **4200 ms**; Instrument v3 (≥ 900 ms, < 9 px); Lalita Mirror (+0.05/110 ms ≈ 2.2 s); Mirror Universe ~2 s | The line is offered in the second person; held, it locks in the first person; early release resets or drains. "Once carved it stays, scored into the place." "the change of person is done by the reader's act; never pre-carved." | held key | 229–232 |
| G33 | Hold to lay down | Chakra Game, Seven Gates | Hold **2600 ms**; words sink: `put-down` 1.7 s after 0.2 s (`opacity 1→0`, `translateY 0→34px`, `scale 1→0.9`); "· passed ·" with the first words this visit only. | held key | 234–237 |
| G34 | Hold to become small | Chakra Game, Child Space | **2800 ms** (+50/2800 every 50 ms); words shrink toward **55%**; the door warms; opens after **1.4 s**: "Welcome." first time, "Welcome back." after. | held key | 239–242 |
| G35 | Touch beats | Mandala Rite of Entering (`RITE_T`); Homes Axis | Beats write themselves over **1.9, 3.7, 5.6 s** (reduced motion 2.6/5.2/7.8 in quantised steps), then wait: "touch to go on" / last "touch to enter". "Never timed onward, never skipped." On return ×`max(0.36, 0.66^(visits−1))`. | Enter = touch | 244–247 |
| G36 | Ask, and the exhale answers | Feed Light v2 | 10 s breath: in 40% · hold 15% · out 40% · rest 5%; eased `(1−cos πt)/2`. A touch adds a "want" (max 2); at the next exhale start, one line. "Unasked, the space only breathes." | Enter asks | 249–252 |
| G37 | Breath as navigation (concept) | Bindu Field Design Exploration | The ring grows on the inhale; the field comes toward you; 4·7·8 drawn; depth planes by tilting. "a concept to score before building". | — | 254–257 |
| G38 | Leave by the edge | Chakra Game Bindu Immersive `edgeReturn`; Experience Score | Pointer-down within **24 px** of the left edge, released > **70 px** right → back to the room. "never punished, never 'are you sure?'". | Esc | 259–262 |
| G39 | Long-press to catch; recognition ceremony | Mandala Eight Modes; App v2 "hold to catch"; Living Rite "I feel her" | Staging: name **300 ms**, phrase **1100**, "felt here · <time>" **2600**, "and felt you back · <time>" **4300**, close hint **5400**; closing collapses inward over **620 ms**; the answer moves in the being's element. | Enter on pill | 264–267 |
| G40 | Touch the body where it speaks | Chakra Game Body as Scripture; Body Map | One-line figure with 7 points; regions crown, brow, throat, heart, hands, belly, sacrum, base, legs. A screen in the region's colour asks the quality (tightness, warmth, ache, tingling, numbness, heaviness, lightness, hollowness) plus one word. Body Map: three inks (alive, tight, absent); past sessions faint under today's. | list of region buttons | 269–272 |
| G41 | Tap to mark | Learning App Reading Room; `walkLog-contract.md` | A tap marks, a second unmarks; each tap appends one entry; odd count = marked. Tick ~0.5 (~0.3 to unmark). | Enter toggles | 274–277 |
| G42 | Draw the way in up over the image | Mandala Veil; Feed hub; the Door | Swipe up or tap the handle; the dark veil rises; the image dims to **~55%** and never disappears; places by depth. | Enter/Esc | 279–282 |
| G43 | Arrows step a ring | Feed Game View | `idx = (idx+dir+n)%n`; fade out **0.28 s**, swap, fade in **0.4 s**; input ignored while fading. | ← → | 284–286 |
| G44 | Continuous zoom | Feed Seam; Universe v3 | Camera `z 0.22 → 34` (start 0.30); `R = pr·z`; pan friction 0.945, zoom 0.90; velocity `dx/z·0.55`; clamp `520/max(0.3,z)`; door at `R > 36` within `0.42·W`; the fall opens at `z > 0.93·ZMAX`. | +/−, arrows | 288–291 |
| G45 | Turn a world, a sphere, a body | Seam; Living Field; Bindu Map 3D | Sideways drag sets a velocity decaying ×0.90; a tap on a node raises a card with "enter". | arrows | 293–296 |
| G46 | Speak | Lalita Capture; Learning App; Rite v3 | Press once, "saved" lights the instant you press; a tap ends; the transcript solidifies at **~90 ms/word** (+260 ms at punctuation); four sentence-cards rise; untouched they lower after **9 s**; the listening ember is **15 px** with three hairline rings at **3.4, 4.3, 5.6 s** ("not a level meter, not a timer"); a failed transcription keeps the audio as still marks. Typing is always beside it; it needs an on-device engine. | — | 298–301 |
| G47 | Finger play | Chakra Game Child Games | A plant grows from each finger while it stays down (multi-touch), with a drone of **110 + 220 Hz**; paint with blended colours, each its own tone; press for rain, swipe for wind; an echo disc plays a tapped rhythm back on rising tones. | held key | 303–306 |
| G48 | Tap a value and type it | Bindu Lab v3, Mixer | Readouts editable (40–600 Hz, ±0.01). "let the field choose" picks a weighted band, cycles the digits, then locks them "like a slot machine settling". | Enter commits | 308–311 |
| G49 | Dwell (a measure) | Learning App; Mandala Homes `homes-memory.js` | Held phrase ≥ **2.5 s**; ember tiers 1.5 / 4.5 / 12 s; story panel embers ≥ **3.5 s** (op 0.5, blur 14), ≥ **7 s** (0.72, 22), ≥ **14 s** (0.92, 32). A room you have stood in: head start 0 below 12 s, else `min(dwell·0.55, 221 s)`; the ceremony is shortened to `max(0.36, 0.68^min(visits,4))`. "dwell is felt, never shown". | — | 313–316 |
| G50 | Sweep | Instrument v3 `uni-deep.js` | A drag draws one line across the field; strength `+= px×0.010` (cap 1), fades 0.30/s; items within **0.055** of the line answer, the three deepest named. Beside it: dwell 0→1 at 0.30/s (drains 1.30/s); turn a world; "tap a ring to hear your own words from that time". | arrows 15°; held key | 318–321 |

**Input adapters** (:323–333):
| adapter | gesture | permission | fallback |
|---|---|---|---|
| stillness | G2 | none | rest at the keyboard |
| microphone loudness | G21 | `getUserMedia` from a tap; stop tracks | "tap to loosen" |
| shake | G19 | `DeviceMotionEvent.requestPermission()` | tap adds 0.5 |
| tilt | G20 | `DeviceOrientationEvent.requestPermission()` | drag after 1.8 s |
| trace | G18 | none | held key draws |
| front camera | G22 | `getUserMedia({video})` | dark screen; continues |

"Each adapter is opt-in, reads nothing it does not use, records nothing, and switches off when the page is hidden."

## A4 · The shared engine inside every exemplar (BASE_CSS + CORRIDOR_JS)
Read in full in `variants/fieldguide--conversation.html:1–251` and `forms/practice.html:1–193`. Every other exemplar repeats it. All 21 variants' CORRIDOR blocks were diffed and are identical.
- **Layers** (`fieldguide--conversation.html:48`): "world 0 · figure and play surfaces 1 · steps 2 · chrome 5 · picker 6".
- **Step / piece:** `.step{min-height:100svh;scroll-snap-align:start;scroll-snap-stop:always}`. The piece arrives `opacity:0; transform:scale(var(--from)) translateY(10px)` → `.step.on .piece{opacity:1;transform:none}` over **1.1 s ease / 1.3 s cubic-bezier(.16,1,.3,1)**.
  - `--from` sets direction: **.86** = in (pieces grow toward you, used by map, portrait, verse, storybook); **1.12** = out (walk); **1** = walk (most); .9 for map variants.
  - **Text is revealed by arrival, not by reading:** each piece fades and scales into place as its step becomes current.
- **Hit-test contract** (`:72–78`): ".step is a positioned, full-viewport box above the figure layer, so it would swallow every pointer event aimed at a play surface … The step passes events through; the text block keeps them." (`.step{pointer-events:none}.piece{pointer-events:auto}`)
- **Activation** (`:174–195`): "Scroll-driven, not observer-driven: picks the step whose centre is nearest the viewport centre." It sets `count` "i / N", `body.dataset.cur`, `--p = i/(N−1)` on `#w` and root, calls `window.ASGfig(e.dataset, i, N)`, and hides the hint after step 1.
- **Throttle** (`:196–204`): a timestamp throttle of **80 ms**, "never gated on requestAnimationFrame. An rAF gate deadlocks permanently in a hidden or throttled document".
- **Idle:** `visibilitychange` toggles `body.still`, which pauses all animations ("a page nobody is looking at genuinely idles").
- **Keyboard:** ArrowDown / Space go to the next step, ArrowUp to the previous (single-snap smooth).
- **`ASGjump(target)`** (`:224–232`): "ALWAYS use this for any move that can cross more than one step. scroll-snap-stop:always swallows multi-snap smooth scrolls entirely … Instant, then re-sync."
- **The corridor remembers** (`:236–250`): opt in with `data-remember="<key>"`; key `asg.at.<key>`; "Restore quietly — no banner, no 'welcome back', and never past the furthest step actually reached."
- **Contrast** (`:12–32`): `--acp: color-mix(in oklab, var(--ac) 50%, #191919 50%)`. "MIXED IN OKLAB AGAINST A NEUTRAL, not in oklch … Polar interpolation rotates the hue … up to 14.6° … turned a lavender into a rose." Worst case **5.39:1**. `--actext` (accent as text) flips per ground: paper (`.dark`: ink #1F1B16, bg #F7F3EC) or night (`.light`: ink #F5EFE6, bg #0B0910).
- **"CHROME OVER A FIGURE GROUND: solid ink, never alpha"** (`calendar.html:39–43`): ".66 measured 3.87:1 on the morning stop … Solid ink … clears every sky by 8:1".
- **GATE 6c:** the back link gets a 44 px target; picker dots get 44 px buttons with a 32 px `::before` dot ("size the target, not the mark", `a-mirror-not-a-master.html:73–75`).
- **Reduced motion:** all animations off, transitions 0.2 s, piece transform none.
- **DOORS.css** (`storybook--tradition.html:169–193`):
  - The door is a 52 px glyph disc (`inset 0 0 0 1.5px var(--ac)`, gradient of the destination colour `--to`), a kicker "The same subject · as an icebreaker", a line, and →.
  - **The handover:** "the world leans toward the next page's accent". `.w::before` fills with `--handto` to opacity **.55** over **.55 s**, the piece fades to .2, navigation follows after **520 ms** (`DOORS_JS`, :240–244).
- **Typography:** Lora (serif) + DM Sans (sans). Kicker `.k`: 11 px, .26em, uppercase.

## A5 · The 34 exemplars, file by file (mechanics, steps, timings, how text is revealed)

### forms/ (10)
- **index.html (90)**, the front door. "Not a corridor: a page you scan, so it scrolls freely (no snap)" (:2).
  - Three registers: **Doing** ("you do something — with your breath, your hands, your week"), **Seeing** ("the drawing is the content"), **Reading** ("a voice carries you").
  - Each form shows "its own figure in miniature — the same drawing you meet inside, so the door already looks like the room" (:5–6).
  - The glyph moves once on hover: breathe `scale(1.18)`, turn `rotate(60deg)`, rise `translateY(−6px)`, fade `.25`; transitions **1.4 s cubic-bezier(.22,1,.36,1)**.
  - Topic counts: practice 239 · walk 61 · fieldguide 55 · recipe 3 · map 21 · calendar 3 · twochairs 21 · portrait 82 · storybook 38 · verse 6 · teaching 222 · icebreaker 138. Footer "889 pages · 41 families · each topic keeps one colour across every form it appears in" (:88).
  - Lede: "Each carries a drawing that changes as you go; each ends somewhere quieter than it started." (:55)
- **practice.html (193)**, Belly Breathing, `data-variant="breath"`, accent #4A7A5A, paper.
  - 5 steps: title · When · How (4 numbered) · Now · After.
  - The figure is one circle in `#fig` that "persists across every step, and on the 'Now' step it becomes the instrument" (:45–46). Fig modes scale it: quiet `--os .52/--oo .5`, open .78/.72, now 1/1, grace 1.5/.34, over **2.4 s**.
  - Timer: SMALL **62** / BIG **176**, IN **4** / OUT **6**; `r` transitions `cubic-bezier(.4,0,.5,1)` over the phase seconds; 120 s; phase word "in"/"out"; button begin / pause / resume / again; "done" for 2.5 s.
  - **Play:** "hold anywhere on the circle and it breathes with you — rings bloom while held". Press: orb to BIG over 4 s, rings fade in `.3−i·.1` staggered .5 s. Release: SMALL over 6 s, rings fade over 2.6 s. Keyboard Space/Enter (:182–192).
  - Copy: "Breathe in as it grows. Out as it shrinks. The page waits with you." (:133)
  - World: an 11 s tide.
- **walk.html (189)**, Thirty Days With Anxiety, `data-variant="month"`, accent #3AADA8, `--from 1.12` (out).
  - "The descent is the figure: a rail of thirty landings down the left edge. The rail travels so the live landing sits at eye level" (:42–44). 30 dots: 3 `.real`; `.done` = accent; `.live` scaled 2.1 with a 18 px tick; the rail translates `−n·28px` over **1.8 s**.
  - **Gate:** key `asg.walk.anxiety`, `CD = 3·864e5`. Day 1 is open; day n opens at `prev + CD`. A locked day hides its text and button and shows `.wcard` with a **tide** of 5 dots (`rise` 5.4 s, staggered .5 s) and "This day is still closed. It keeps its own time." plus "opens <date>" or "opens after the day before it". The button reads "I read this — start the clock"; once marked, the label is "read on <date>".
  - **Play:** "the waiting has its own quiet life — touch the tide and it answers" (`ripple` 1.2 s, staggered .08 s).
  - Grace: "The rest of the walk arrives on its own clock." / "Nothing here counts your days or tells you you're behind. The gate only ever opens; it never closes on you." (:139–140)
- **calendar.html (192)**, Diwali, `data-variant="festival"`, accent #D8742A.
  - "The sky is the page. It owns the top 46svh and actually passes: pre-dawn to night" (:44–47). Five sky stops (predawn, morning, noon, dusk, night) as gradients; at night the card and ink invert.
  - Sun on arc `M30 250 A230 230 0 0 1 490 250`: `a = π(1−d)`, `cx = 260+230cos a`, `cy = 250−230 sin a`, hidden above d .86; **2.4 s** transitions. Eight clay lamps; each step sets `data-hour` and `data-lit` (0,0,0,0,0,2,8,5,3,1), and the flames light staggered **.09 s** with a 2.6 s flicker.
  - **Play:** "a lamp can be lit early by touch, and it stays lit for the rest of the day" (:189).
  - Text sits on a card in the lit lower half.
- **fieldguide.html (166)**, crisis variant, accent #B33A2E. "No play, by instruction: nothing here may cost attention. The figure is a horizon that does not move — the one steady thing on the screen." (:37–38) Horizon line at 22%; a glow under it whose opacity follows `data-here` (open .5, situation 1, grace .14). Picker of three on the title screen; `scrollTo instant` then sync. Grace: "The alarm is real. The fire is not."
- **map.html (197)**, The Nine Dimensions, `data-variant="rings"`, night, `--from .86`.
  - **Nine rings, numbered 1 outermost (r 232) to 9 innermost (r 24), step 26.** "Scrolling inward travels: the system opens toward you while the live ring lights and carries its numeral."
  - "PERF CONTRACT: the scaled subtree carries NO filter, and scale is capped at 2.3x — the glow is a second stroked circle" (:43–45). Scale ramp S = {1:.92, 2:1.08, 3:1.25, 4:1.42, 5:1.6, 6:1.78, 7:1.95, 8:2.12, 9:2.3}, **2.2 s cubic-bezier(.3,.9,.2,1)**.
  - Live ring: accent, width 1.8; passed .06; inner .2; a glow ring of width 7 at .16; core r 5 (opacity .35 past ring 6); grace r 26 at .14.
  - **Play:** "the rings can be spun — sideways drag only, vertical still scrolls"; rot = r0 + dx·.55; snaps to **40°**.
  - World: a starfield scaling `1 + p·.35`. Grace: "You do not go there. You widen here."
- **portrait.html (195)**, Ramana Maharshi, sage, gold #C9A84C.
  - "The ages line is the figure and the navigation: the point tracks the moment and can be dragged to travel the life. Each moment is a room — the ground changes light around you rather than illustrating the scene." (:38–40)
  - Rooms: floor, train (a window's moving bars, 2.6 s), silence (a halo breathing 9 s), question, end (a gleam).
  - Life-line X {60,160,260,360,460}, fill by dashoffset (1.4 s), the point drop-shadowed.
  - **Drag the point**; on release, jump instant to the nearest moment.
- **recipe.html (213)**, Kombucha, ferment. "The jar lives ABOVE the list and never behind it" (:35). The tea fills to `data-fill` (0 → .85) × MAX 272; the SCOBY appears from step 2; an 8-day strip of dots lights `data-days`. Tap the jar to toggle `data-open` (the glass clears, you see inside). GRACE · COVER: a cloth drops over the rim and day 8 reads "· ready" (:85–93). Last line: "Cover it, and leave it be. The work is happening where you can't see it."
- **twochairs.html (207)**, 432 or 440 Hz, debate. Two chair figures lean (rotate ±3°, translateY −4) on rounds; they recede at "held". Pick "Where are you sitting?" (left / right / "Neither — I'm on the floor between them"); the chosen seat ellipse warms (.5) and the sitline answers. **Play:** tap off-text to swap the chairs ("they trade sides, arguments and all"). Last screen: "Listen to both. Notice what the noticing does."
- **verse.html (151)**, The Gāyatrī, mantra.
  - Each line gets "a head-rule above it — the shirorekhā that runs across Devanagari — so the words read as one connected utterance, and the syllable groups are spaced as breath" (:37–40).
  - **Touch the line and it breathes:** letter-spacing .012 → .07em, word-spacing .22 → .5em over **2.4 s**, then back after **2.6 s**.
  - **GRACE · SOUND:** the four lines together "under one head-rule that draws through them in order": each rule draws **.7 s** at `i·.7 s`, each line brightens .35 → 1 at `i·.7+.3 s`.
  - The world glow climbs `96% − p·62%`.

### learning/ and teachings/ (3)
- **icebreaker/neem-karoli-baba.html (258)**, 16 steps. "FELT PASS … THE LAMP. A pool of light over a table … that warms as the conversation goes on (--p) … EACH QUESTION IS A CARD YOU HAND OVER. Tap one: it lifts, is copied on its own, and says so." (:77–82) A handed card shows `translateY(−4px) rotate(−.6deg)` and the label "copied — ask it" for 2.4 s. Cards can be flicked: dx tilts `dx·.02°`; past **110 px** the jump moves one step. Stacked card edges as `::before/::after`.
- **story/bashar-the-five-laws.html (218)**, 12 steps. "A book, not a scroll. Each screen is a real page on a warm stock … a corner you can lift" (:39–42). The page `perspective(1400px) rotateY(--turn)`: current 0°, past 6°, future −7°, over **1.2 s**. The fore-edge stack `--edge = 1 − k/(N−1)` thins as you read. The corner lifts 14 → 46 px; a click turns the page.
- **teachings/a-mirror-not-a-master.html (227)**, 13 steps, laws variant. "Three registers at once: the law at full voice, the because directly beneath it, the looks-like as a lived line at the foot. A picker of the eight laws sits at the top and is the spine of the page" (:40–43). The `#lawpick` buttons jump. **Play:** "the law you hold longest stays lit, and keeps staying lit". The press duration is stored per law in `asg.teaching.mirror.held`; the top one gets a `.held` ring if > 600 ms (:210–225). Content: the eight laws of Bindu Being's ethic, verbatim titles "Reflect. Never dictate." … "A menu, not a mandate." Close: "The medicine is the gap between what happened and the story you tell about it. A mirror shows the first. A master only ever talks about the second." (:175)

### variants/ (21)
Each header records topic, form, family, pool and seed, and a **move** line: figure · direction · ground · density · play.
- **fieldguide--conversation**: figure HORIZON at 10% ("a line through the 'because' text reads as a strike-through"); play copy: each "try saying" line is a button that copies itself ("copied", 2.2 s). Adds an "Instead of" band.
- **fieldguide--for-someone-else**: figure **STANCE**. "Three marks — you, them, the illness — and each situation moves you." Positions `all/against/merged/apart/beside` with coordinates (e.g. beside you [146,112], them [214,112], it [180,40]). Gaze lines rotate by atan2. "Every page in the family ENDS on beside. The illness is drawn as a ring, never as a face." **Play:** drag "you". On release, distance to them: < **34** "too close to see it", > **140** "too far to help", else "near enough to stand beside". "It resets on the next step and is never stored." (:111–119, 192–217)
- **map--grid**: Five Elements, a wheel at r 130; sheng arcs around the rim (solid), ke as a dashed star; "The live phase lights only its OUTGOING arrows"; characters counter-rotate "so they never read upside down". Spin with **72°** detents; tap a phase to jump. Grace: a traveller orbits for 14 s. Desktop: a half-screen band.
- **map--path**: Bardo Thödol, the fallback for journeys. "The road is drawn faint in full from the start … the walked part draws in; the end runs off the edge of the band, because a road does not stop where the map does." Five stations on S-curves; segments draw by dashoffset over 1.6 s; live ring r 22; tap a station. Grace: "It was never written for the dead alone. It is practice for the living, told as a road."
- **map--poly**: Metatron's Cube, "a construction that builds, in the order you'd draw it by hand. Every stroke carries pathLength='1', so drawing is one dashoffset transition … the dodecahedron step lights NONE — the absence is the content." (:144–147)
  - Seed of Life: 7 circles at r 50, delays .12·i. Fruit: 13 circles, delays .06·i. **78** lines, delays .018·i. Vertices appear.
  - Solid edge sets light in accent (tetra, cube, octa, icosa; dodeca ""); the rest hush to .35.
  - Spin at **60°** detents: "the figure has sixfold symmetry, so every detent lands on the same drawing. That is itself the lesson." Grace: an 80 s slow turn.
  - Honesty: "Close — not exact … It isn't here." Close line: "Three are really there. Two you have to bring yourself."
- **map--spine**: 7 Chakras, the **climb**.
  - A rail **13.2 svh wide × 154 svh tall** on the left. "The column travels so the live centre holds the optical middle; at the end it steps back to show the whole spine." The rail moves `translateY(−(y/1400)·H)` over **1.9 s**. Grace scale `min(1, innerHeight·.8/H)`.
  - Sushumna is a rainbow gradient #C8453A → #9A72C0, drawn by dashoffset `1 − (k−1)/6·.93 − .04`. Ida and pingala are braids crossing at every centre, lit by `max(0, 1 − (k−1)/5)`.
  - Lotus petal counts **4 · 6 · 10 · 12 · 16 · 2**, and the crown as three rings of fine petals (36 + 48 + 60). "The Ajna step's text says 'drawn with two petals' — the figure must agree with the words." Each lotus blooms from `scale(.25) rotate(−50deg)` over **2.2 s**. Bīja labels LAM VAM RAM YAM HAM OM; the crown is silent.
  - **Play:** "Pull the spine down to climb, up to descend; release to arrive. A tap without a drag goes to the nearest centre." The drag step is `railH·200/1400` per centre.
  - World glow in each centre's colour. Grace: "It was never a ladder. It is one spine, lit all the way." Honest source line: "a modern synthesis — older tantric texts give other counts and other colours."
- **map--tree**: Tree of Life. Ten sefirot on three pillars, 22 paths. "The lightning flash … crosses the abyss (Binah→Chesed) where no path runs, which is the point of it. It draws down edge by edge as you read; the ending lights every path from the bottom up — the return." Path delays `(620−y)/620·1.6 s`. Da'at is a dashed circle ("present, and not counted"). Hit circles r **44** ("size the target"). Grace: "The light came down to arrive. The paths are how you walk back up."
- **portrait--scientist**: Lynn Margulis, figure **RECEPTION**. "Future points are INVISIBLE until reached: the figure must never tell the ending before the words do." Levels 0 rejected · 1 proposed · 2 contested · 3 tested · 4 supported · 5 accepted. "a NEW claim starts a NEW line, drawn hollow — a person's claims do not share one fortune." The room brightens `--lift = lv/5`. A required "How to read it" step: "the line is reception, not truth." Drag, then go to the nearest moment.
- **portrait--seer**: Rudolf Steiner, figure **AFTERLINE**. "It draws the life as a line that ENDS, and what outlasted it as branches that keep going. The visions are never drawn." Life 1861–1925 mapped `30 + (y−1861)·250/64`; five branches draw at .22 s steps; drag past the death "goes to what kept going". A "Held open" step.
- **practice--body**: Body Scan, figure **SCAN**. "a band of warmth that descends the SCREEN, not as a drawn body. It costs no column, and it never pretends to know the reader's shape." The band is 46 svh at `translateY(y·100svh − 23svh)` over **2.6 s**; held it widens to 66 svh ("stay here longer"); the whole screen at the end (140 svh). Warmth mixed toward amber "so a slate accent never becomes a shadow". 6 region ticks on the right.
- **practice--lesson**: Sleep Hygiene, figure FIELD + CHOICE.
  - "A lesson is a list of changes, and every lesson's real advice is 'start with one'. So the list becomes a choice." Five changes plotted by effort (x) and effect (y), with a "start here" zone. "Where the lesson gives no basis, OMIT the 'where to start' step — never guess a position. The full list always comes first, so nothing depends on the play."
  - Choose one and **the fortnight**: 14 dots fill with real days since choosing (`asg.lesson.sleep-hygiene`). "day d of the fourteen". On return, a quiet `resume` line on the title.
- **practice--senses**: 5-4-3-2-1 grounding, figure **COUNT**. "the instrument is the count … each dot is a 44px target. Nothing advances on its own and nothing is scored." The note shows "n of 15 noticed" and, at full, "You're here." "Never stored."
- **practice--stillness**: Leaves on a Stream, figure **WATER**.
  - "a surface at the foot of the screen that settles, step by step, from ripples to still". `data-calm` 0 → 1 drives ripple opacity `1 − calm·.85` and speed `4 + calm·14` s.
  - **Play:** type a thought → it rides a leaf (13 s drift) off the page ("Nothing you type is kept. It floats off the page."). Touch the water and a ripple ring spreads (2.6 s). Ambient empty leaves every **11 s**.
  - Grace: "You are the one on the bank."
- **storybook--cosmology**: Te Ao Māori, figure PAGE + **SEPARATION**.
  - "the world behind the book IS the story. Two planes (sky, earth) close over the room; SLOT data-sep 0..1 per page sets how far apart they are, and the light between them follows." The sky moves −34 svh·sep and the earth +34 svh·sep over **3.2 s**. The seam glows `rgba(255,236,205,.12 + sep·.7)`; a dawn radial lies behind; `data-rain` adds falling lines.
  - FELT PASS: "the parting was happening BEHIND the page … The seam now sits high (28svh)".
  - Separations per page: 0, 0, .06, .3, .8, .7 + rain.
- **storybook--tradition**: Sufism, figure **SILSILA**.
  - "the chain. One lamp per page plus one unlit at the end … Each page lights the next lamp FROM the previous one … The ending's last lamp is the reader's; touching it lights it." (:109–113)
  - **Play:** "touch the chain and a spark runs the lit length of it, first lamp to the newest — the transmission, replayed." The spark runs `0.5 + to·.18` s; at the end the touch lights yours (dashed bowl → solid, glow .28).
  - Closes on DOORS (to the icebreaker, `--to #65a4d0`). Last page: "The last lamp on the chain is not lit. / It is yours. Touch the chain."
- **teaching--mind-body**: Fight, Flight, Freeze, figure **TIDE**.
  - "The ground breathes at six breaths a minute (5s in, 5s out), the pace of a settled body." "TEMPO IS A PER-STEP SLOT, default rest." Tempos: rest h **5000** (hi 22 / lo 34 svh), quick **1700** (20/30), still **8000** (36/38) — set "ONLY where the step's own words describe alarm or shutdown".
  - **Play:** hold → "the tide rises and waits; let go and it falls over eight seconds — a long exhale, untaught." (rise to 18 svh over 2.6 s; fall over 8000 ms)
  - FELT PASS: the waterline became a scalloped swell.
- **teaching--other**: Loving Boundaries, FIELD only, play none. `.looks` label slot "sounds like".
- **teaching--relationship**: Empathic Listening, figure **ATTUNE**.
  - "two people as two lines. Both drift at the same speed; the only thing that changes is the phase between them. Each rule closes the gap. At the end they are IN STEP BUT STILL TWO — a fixed vertical gap that never closes, because rule six is about not merging." (:109–113)
  - Wavelength 240; `data-ph` 1 → .8 → .6 → .42 → .26 → .12 → 0. Drag your line; in phase when `< .04` of the wavelength → both lines deepen. Drift 9 s.
  - Rule 6: "Stay two people." Ends with a DOOR to the field guide.
- **teaching--skill**: Defusion, figure **DISTANCE**.
  - "The sentence is the figure; each stage puts space between 'you' and it." Stages bought `{t}` → had "I'm having the thought that {t}" → noticed "I notice I'm having the thought that {t}". Gap 4 px → 26–56 → 48–110 px; font 26–34 → 19–24 → 16.5–20 px; ink 1 → .86 → .74.
  - "on arrival the move plays itself once, slowly — then it's yours" (2.2 s per stage). "Try one of yours" with a capitalisation rule for names. "Nothing you type is stored or sent anywhere."
- **twochairs--mind-and-machine**: The Mirror Test, figure **MIRROR**. "the two chairs are one chair and its reflection. Tap the figure and a mark appears on the chair; a beat later it appears in the glass … The chosen seat warms on both sides, because a reflection cannot choose differently." The reflection's mark is delayed **.7 s**. Last line: "Look at the reflection. Then ask who is asking."
- **walk--relationships**: Thirty Days Together, figure **LADDER**.
  - "Two rails down the left edge, one per person; each finished day adds a rung between them. Every seventh day is a date night … drawn as a double rung — the course's rhythm is visible before you read a word of it."
  - The waiting state: "two dots that drift toward each other" (7 s). Gate key `asg.walk.relationships`, CD 3 days, FIRST 5; button "We did this — start the clock"; `data-remember`.
  - Grace: "Nothing here keeps score between you. A missed week is just a longer rung."

---

# B · Gifts for the upgrade
*Each row gives: what it is · source · world(s) · how it works there (mechanism) · what it needs · energy or story. Ruling 5 (energies, not stories) applies: forms whose job is narrative (storybook, portrait, icebreaker, two chairs, teaching prose) are flagged "story → Bindu Feed", but their figures and gestures are energy mechanisms and are offered here. Nothing below invents content: every room fills from canon via a contract.*

## B1 · The cure for "rooms read as text pages": the corridor engine, ported
| # | gift | source | world(s) | how it works there | needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **The corridor**: one piece per screen; text *arrives* (scale `--from` → 1, opacity 0 → 1 over 1.1/1.3 s) as its step becomes current; direction coded by `--from` (.86 in · 1 walk · 1.12 out) | A4; `SKILL.md:21` | all 33 rooms; Her Home Detail; the Well; Beneath; Time | Replace the single ScrollView template (Foundation root cause 2) with a vertically paged SwiftUI corridor: `ScrollView(.vertical)` + `.scrollTargetBehavior(.paging)` + `.scrollPosition(id:)`. Each page is a `Step` view with a `Piece`. The current step is set by nearest-centre (never by an observer). Direction per world: inward rooms (Ajna, Bindu, Maya) `.86`; outward (Crow, Lalita) `1.12`. | a `CorridorView` + `StepModel { id, dataset }` + an `onActivate(dataset, i, N)` hook (= `ASGfig`) | energy |
| 2 | **Figure, not world**: a drawn thing that *is* the content and changes per step through `ASGfig(dataset,i,N)` slots (`data-ring`, `data-calm`, `data-sep`, `data-y`, `data-ph`, `data-tempo`, `data-lit`, `data-hour`…) | `SKILL.md:24`; every variant | every room thread | Each room's thread declares a figure and per-step slot values. The figure lives in a fixed layer behind the steps (Canvas/Metal) and animates between slot values. **This is the direct remedy for "data rendered as prose".** | a `Figure` protocol: `apply(slots:, step:, of:)`, one per figure type below | energy |
| 3 | **Hit-test contract**: steps pass touches through; only text keeps them; play surfaces sit under the text, around it | A4 `:72–78` | every room with a gesture | In SwiftUI the step container is `.allowsHitTesting(false)`, the piece `true`, and the gesture layer (zIndex 1) receives every touch around the words. Lets a room be read *and* touched on the same screen. | layering rule in `CorridorView` | energy |
| 4 | **`ASGjump`**: any multi-step move is instant then re-synced | A4 `:224–232` | pickers, life-lines, rails, tap-a-node | Needed wherever a figure tap jumps (tap a ring, tap a station, drag the spine). | `scrollTo(id, anchor:.top)` without animation + re-sync | energy |
| 5 | **The corridor remembers**, quietly ("no banner, no 'welcome back', never past the furthest step reached") | A4 `:236–250` | 33 rooms, walks, Her Home | Restore the step on return. Write it as an App Activity "position" row rather than localStorage (one ledger). | App Activity field for last step per place | energy |
| 6 | **Idle when unseen** (`body.still` pauses animation) and the **80 ms timestamp throttle** ("never gated on a frame that may never arrive") | A4 | all | `scenePhase != .active` pauses TimelineViews and display links; also mirrors G-adapter "switches off when the page is hidden". | — | energy |
| 7 | **Contrast law**: `--acp = oklab mix(accent 50%, #191919)`; "chrome over a figure ground: solid ink, never alpha"; descent ink brightens as it falls | A4; `calendar.html:39–43`; `SKILL.md:61` | all 33 rooms (each has its own hex), sky stops, Beneath | Every chakra hex (e.g. #2A2420 Shadow, #060D30 Echo) gets a computed text tint, never alpha. Chrome over a moving sky is solid. | a `readable(accent, ground)` helper in Swift (OKLab) | energy |
| 8 | **Doors along the threads, with the handover**: the world leans toward the destination's colour (`--to`, overlay .55 over .55 s), then navigates at 520 ms; a 52 px glyph disc of the destination; "The same subject · as …" | DOORS.css `storybook--tradition.html:169–193, 240–244` | the three threads (kp · chakra · day); between the five threads of a room; Home ↔ Detail | Each door shows the next place's miniature figure ("the door already looks like the room", `index.html:5–6`) and tints the screen toward its colour before the crossing. | a `DoorView(to: Place)` + a crossing overlay | energy |
| 9 | **The door looks like the room**: every form's glyph in miniature, moving once (breathe 1.18 / turn 60° / rise −6 / fade .25, 1.4 s) | `forms/index.html:2–6, 34–39` | the always-available menu; the Veil; search results | Index rows carry the place's own live figure in a 76 px disc, so the menu is a field of tiny rooms. | glyph per figure type | energy |
| 10 | **"Read plainly"**: one way out of every withholding mode | `gestures.md:17` | Settings / Modes | One switch turns G1–G11 reveal gestures into plain text for any day he wants. Lets every gesture be bold without trapping him. | one global preference | energy |

## B2 · The 33 rooms × five threads: which form and gesture fits which room type, and why
Room types (from register 05, `05-chakra-corpus.md:387–421`): **Structural / Recognition** (1 Bindu, 9 Shadow, 20 Armin, 30 Maya, 31 Aatma, 32 Ego Reveal, 33 Lalita) · **Energy · Soul Tree / Stillness** (2–8) · **Body · Bindu Tree / Movement** (10–19) · **Mind · Maya Tree / Visualization** (21–29). Gate types: Canvas (1), Textarea (2–9, 17, 20–33), Sound Response (10–13, 15, 16), Tap Rhythm (14), Device Tilt (18, 19).

### B2.1 · Thread-level gifts (apply to every room)
| thread | form / gesture | source | how it works in the room | data contract it needs | E/S |
|---|---|---|---|---|---|
| **Story told by a moving point** | **A7 Four-section reading** (SAY · WALK · HAND · OPEN), each section arriving by **the room's own gesture** (G2–G8, G9, G11); "There is no generic reading, not even as a fallback." | `forms.md:133–138` | The point *is* the reader's finger: in Ajna it rests (G2); in Svadhisthana it follows a ray (G3); in Anahata it parts a veil (G4); in Muladhara it bears down (G5); in Pulse it keeps pace (G6). The four canon sections of the room's story surface only by that act. | `{title, kind, one, world, voice, say, walk, hand, open, status}` + `gesture: G#` per room. Canon story text split into four sections (from Airtable story fields, verbatim). | energy (mechanism); the story text itself is a Bindu Feed candidate, so flag the long narrative and keep the four-line sections |
| | **Map figure with a travelling point**: the portrait life-line point (drag, nearest-moment jump), map--path road ("a road does not stop where the map does"), map--spine climb | `portrait.html:38–40, 179–193`; `map--path.html:146–151`; `map--spine.html:126–130` | The room's story beats sit on a drawn path. The point travels as you scroll and can be dragged to jump. Walked segments draw in (pathLength 1, dashoffset 1.6 s); future beats stay invisible until reached ("the figure must never tell the ending before the words do", `portrait--scientist.html:117–118`). | `nodes:[{n,name,gloss,text}]` + path geometry per room | energy |
| | **G11 received as a Rite**: every paragraph on the page from the start, unlit (opacity .05, blur 5, +11 px), each touch lights one over 2.6 s | `gestures.md:112–117` | For rooms whose verb is RECEIVE (8 Sahasrara, 16 Echo): the story is already there, invisible; each touch lets the light reach one more line. | `body[]` | energy |
| | **Word-by-word arrival** (~250 ms/word, +430 at a stop, +180 at a comma, sharpening from a 4 px blur) and **G1 hold to read** (560 ms/word, heart phrase 1150, ember tiers) | `forms.md:99`; `gestures.md:47–55` | Story lines arrive at a pace, never as a block. Hold-to-read for the deepest rooms (25 Intuition, "before the word"). "Where you stayed" shows his dwelt phrases at the end, which are felt rather than counted. | `{chapter, speaker, pace, text with **heart phrase**}` | energy |
| **Practice** | **Practice card** (When · How · Now · After) with **the circle that waits** (4 in / 6 out; SMALL 62 / BIG 176; "The page waits with you"); **hold anywhere and it breathes with you** | `practice.html` | Every room's practice becomes a 4–5 step corridor whose Now step turns the persistent figure into the instrument. | `{title, one, when, steps[], seconds, after, source}` | energy |
| | **E · seven forms of time**: Aperture / Pace / Trail / Hold / Bloom / Orbit / Night, switchable mid-session from a rail of seven glyphs; begin/close by a 1.1 s hold ring | `forms.md:270–279` | The practice's duration is never a clock. Stillness rooms (2–8) take **Aperture**. Breath rooms (12 Prana, 23 Inspiration) take **Pace**. Movement rooms (10–19) take **Trail** ("a quiet marker passes when you go beyond your usual, unannounced"). Effort rooms (22 Intention HOLD, 4 Manipura) take **Hold**. Mind rooms (21–29) take **Bloom**. Relationship practices take **Orbit**, up to nine presences. Night practices take **Night**. | `form: aperture|pace|trail|hold|bloom|orbit|night` per practice + numbers above | energy |
| | **Practice sub-templates**: body SCAN band (descending warmth, hold to stay longer), senses COUNT, stillness WATER (calm 0 → 1; a thought on a leaf, never stored), lesson CHOICE (plot by effort/effect; "start with one"), breath-is-the-hold (G29), camera (G22), tempo (G23), **ladder-of-centres** ("one body cue and one tone per centre, climbing, 60 s each (15 s quick)") | variants; `forms.md:216–221` | Body rooms (10 Soles → 19 Crow) take SCAN. Water rooms (3 Svadhisthana) take WATER. 12 Prana takes breath-is-the-hold. 14 Pulse takes tempo. The Climb / Hub takes ladder-of-centres across 2–8 with its awakening Hz (174, 210, 320, 341, 384, 426, 480). | per-practice figure slot (`data-y`, `data-calm`, …) | energy |
| | **A5 Breath session by intention** (ground, activate, open, clarify, dissolve, expand, rest, balance; circle 0.7 ↔ 1.2; cue words as sound; one recognition line at 45% for 4 s; S·T·C honesty badge on frequency claims) | `forms.md:118–124` | The practice thread of the breath rooms and the Modes. The honesty badge suits the app's Hz-carrying practices (the binaural awakenings). | `{title, intention, one, inhale, hold, exhale, minutes[], cue, seed, recognition, screened?}` | energy |
| **Wake-up** | **Ceremony step 1, "Open with one breath"**: a 5.5 s breath ring with four ticks, or a **5 s one-breath hold** that unlocks sound, wake lock and one haptic | `forms.md:260` | Every wake-up opens with the breath before anything asks. The legacy wake-ups' "Press and hold" (Muladhara) is exactly the 5 s hold. | `opening: ring|hold|circle` | energy |
| | **G35 touch beats** (1.9 / 3.7 / 5.6 s, then "touch to go on"; shortened on return, never skipped) | `gestures.md:244–247` | The wake-up's phases (6 for Muladhara, 7 for Svadhisthana) come one touch at a time, each writing itself. | `beats[]` | energy |
| | **G14 Descent** for downward wake-ups and **G17 two holds** for the centre | `gestures.md:129–153` | Muladhara wake-up "A guided descent to the body" = G14 (1250 ms door, 2.35 s passage, 110 Hz + 164.81 Hz). Bindu wake-up "a guided arrival at the point" = G17 inward fall with the Shepard tone from 32.7 Hz. | per room: `wake: G14|G17|…` | energy |
| | **B1 Threshold card** before the room (sentence 40 · one breath 23 · body question 20 · something real 12 · the point alone 5; never the same kind twice; the first open is a threshold) | `forms.md:189–191` | A small thing before each room opens. Weights are drawn locally, `noRepeat`. | `{kinds:[{kind, weight, label, accent, body}]}` per room (canon lines only) | energy |
| **Dance** | **A13 Scored performance**: the Score is data and a separate player plays it; phases, scored silences, crescendo (145 → 160 → 180 → 195 s, climax above 0.25), voice entries by second, mirror words at set times, the fruit woven from how he was (still / swaying / moving) | `forms.md:174–179` | Every room's dance is a Score file, played by one engine. Ruling 6: entries name every archetype (Bindu, Gaia, Sid, Arch, Karishma, Sakshi, Ashrey, Lalita). The bindu-field Score Format v2.0 is the same idea; this contract fixes the fields. | `{title, durationSec, phases, silences, crescendo, entries:{voice:sec}, mirror:{times, words}, seed, fruit, close}` per room | energy |
| | **G6 keeping pace**, which is literally from `dance-world.js` (3 lanes; catch within 56 px, keep within 84; a section lands every 1.15 s) and **G23 tempo** (beat ±130 ms; at closeness 8 "The music answers.") | `gestures.md:86–89, 182–190` | The dance's hand part: he keeps pace with an orbiting light, or taps with the beat until a second drum (147 Hz) joins. No score shown. | lane speeds per room; song BPM | energy |
| **Gate** | Gate type → gesture (G0 law: completes by real hold or held key; early release drains): **Canvas → G18 trace**; **Textarea → ceremony step 3 "a word asked without a box"** (large italic question, word large in the accent with a blinking cursor over a thin rule, "or speak it") **then G32 carve or G33 lay down**; **Sound Response → G21 mic loudness** (0.05 act / 0.08 marks / 0.92 complete; "tap to loosen" fallback); **Tap Rhythm → G23**; **Device Tilt → G20** (7 s gold ring; drag fallback after 1.8 s) | `gestures.md`; `forms.md:262–264` | The gate is the room's last act, and it opens on the act (truth floor). The answer moves in the room's element: fire flares 5.5 s, water pools 6.5 s, air disperses 6.0 s, ether blooms 4.8 s, earth settles 7.5 s, light radiates 3.8 s. Then a whisper plus one warmer light, never a checkmark. | `gate:{type, g, prompt}` per room; element per room (ruling 4: Ahaṅ fire, Nāma air, Ātma light, Amṛta water) | energy |

### B2.2 · The 33, room by room (mechanism mapping only; content comes from canon)
| # | room · verb | type / gate | story by the point | practice | wake-up | dance | gate | why this gesture |
|---|---|---|---|---|---|---|---|---|
| 1 | Bindu · RECOGNIZE | Structural · Canvas | G2 stillness (Reading I: 52 px, 1.5 s per section) | Aperture (34 px point, 9 s) | G17 inward fall + Shepard tone | Score | **G18 spiral trace into the centre** (done within 26 units of centre) | the centre is reached by stopping, and the Canvas gate is a line drawn *to* the point |
| 2 | Muladhara · PRESS | Soul · Textarea | **G5 bearing** ("an impression cannot be made by touching") | SCAN from the top down; Hold form | 5 s one-breath hold; G14 descent; 174 Hz | Score (Woodkid Iron) | word without a box → **G33 lay down** to earth (settles 7.5 s) | PRESS is pressure; earth settles |
| 3 | Svadhisthana · FLOW/FOLLOW | Soul · Textarea | **G3 following a ray** | WATER (calm 0 → 1; leaf) | "Six Lights Drift" ≈ G9 carried light | Score (Crystallize) | word → G32 carve; water pools 6.5 s | FOLLOW is literal |
| 4 | Manipura · BURN/BUILD | Soul · Textarea | G5 strikes every 0.9 s (forging) | Hold form (taut line, 1.2 px tremble) | 320 Hz gong; beats | Score | **G33 lay down into fire** (flares from low 5.5 s) or **G25 join** (build) | burn = release into fire; build = assemble |
| 5 | Anahata · OPEN | Soul · Textarea | **G4 parting** (r 104 px veil held open; text masked to the opening) | Pace 4/4/6/2 | 341 Hz bowl, longest decay | Score | word → G32; "…and it felt you back" | OPEN is holding a veil open |
| 6 | Vishuddha · SPEAK | Soul · Textarea | G36 ask, the exhale answers | breath with cue sound "haaa" | **G21 mic**: the source *is* `/tree-of-life/vishuddha-wakeup` | Score | **G46 speak** (on-device), typing beside | SPEAK; the only loudness reader in the corpus came from this room |
| 7 | Ajna · STILL | Soul · Textarea | **G2 stillness** | Aperture | 426 Hz shimmer; Dawn (eyes open only on inhales) | Score | **G10 Still Point** stages | STILL is the absence of input |
| 8 | Sahasrara · RECEIVE | Soul · Textarea | **G11 received as a Rite** | Night or Aperture | 480 Hz distant bell | Score | G17 outward bloom (layers .06 … .80) | RECEIVE: each touch lets light in |
| 9 | Shadow · LOOK | Structural · Textarea | **G9 carried light** ("can't name what the light hasn't reached") | Hold | G14 descent; membrane Shadow 3→4 = **G15** | Score | word offered to the dark → G32 | a corridor in the dark read by a light you carry |
| 10 | Soles · PRESS | Body · Sound | G5 | SCAN feet; Trail | 5 s hold | Score | G21 (LAM mirror) | press into ground; sound answers |
| 11 | Forge · TRANSFORM | Body · Sound | G5 strikes | Hold | beats | Score | G21; or G25 join (two into a third) | forging |
| 12 | Prana · BREATHE | Body · Sound | G36 | **G29 breathe-in hold 4000 / out 5200, three beads**; Pace | one-breath hold | Score | G21 (breath loudness) | BREATHE |
| 13 | Hands · REACH | Body · Sound | G3 reach out along a ray | G40 hands region | beats | Score | G21 | REACH outward |
| 14 | Pulse · SUSTAIN | Body · **Tap Rhythm** | **G6 keep pace** | Trail | heartbeat | Score | **G23 Beat** (1000 ms, 98 Hz, ±130 ms, closeness 8 → 147 Hz drum) or Coherence (two pads, merge > .82) | a heartbeat kept |
| 15 | Sonar · SEND | Body · Sound | **G8 send and wait** (laps 3.2, 5.4, 8.0, 11.2 s; returns on the wall clock) | Trail | beats | Score | G21; **G31 hold to release** (2300/620) | SEND, and what you send returns in its own time |
| 16 | Echo · RECEIVE (listener) | Body · Sound | G11; or G1 hold to read | Orbit | — | Score | **G47 echo disc** (tap a rhythm, played back rising) or G21 | the listener hears it come back |
| 17 | Vision · SEE | Body · Textarea | G9 / **G44 zoom** (z .22 → 34; a star grows into a world) | Aperture | — | Score | word → G32 | SEE by drawing near |
| 18 | Axis · BLINK | Body · **Tilt** | G44 | Trail | G15 membrane | Score | **G20 tilt** (drop into r 46; ring 7 s; "Held.") | Device Tilt |
| 19 | Crow · RELEASE | Body · **Tilt** | G8 | Night | — | Score | **G20** + **G26 set down** (falls 420 px) | release by letting it fall |
| 20 | Armin · ONE | Structural · Textarea | G2 | Orbit | **G15 membrane push** (Armin 6→7; 26 shards; 5.4 s passage) + **G16 consent pull** | Score | word → G32 ("offered as you, carved as I") | a crossing that only gives to continued intent; ONE by the change of person |
| 21 | Inception · ASK | Mind · Textarea | **G36 ask, and the exhale answers** | Bloom | — | Score | **A11 answerable reflection** (lands · say more · leave my own word) | ASK |
| 22 | Intention · HOLD | Mind · Textarea | G0 ceremonial hold | **Hold form** | — | Score | word → G32 | HOLD |
| 23 | Inspiration · BREATHE IN | Mind · Textarea | G36 | **G29 inhale hold 4000** | — | Score | word → G32 | BREATHE IN |
| 24 | Insight · SEE FROM IN | Mind · Textarea | **G17 inward fall** / G44 into a star | Aperture | — | Score | word → G32 | seeing from inside |
| 25 | Intuition · TRUST | Mind · Textarea | **G1 hold to read** ("before the word") | Dawn stillness (words only on the exhale) | — | Score | word → G33 | trust the pace |
| 26 | Invention · ASSEMBLE | Mind · Textarea | **G25 join two tiles → a third** (blooms .3 → 1.08 → 1 over 1.1 s) | Bloom | — | Score | word → G32 | bīja "the third thing" is this gesture exactly |
| 27 | Incarnation · CHOOSE | Mind · Textarea | **G28 rewind by held spiral** (1400 ms; "Live this one") | Trail | — | Score | **B2 two doors** | CHOOSE among branches |
| 28 | Innocence · REMEMBER | Mind · Textarea | **G34 hold to become small** (2800 ms; words to 55%; "Welcome.") | **G47 finger play** | — | Score | word → G32 | before anyone taught you |
| 29 | Integration · ARRIVE | Mind · Textarea | **G50 sweep** (one line; everything near it answers) or **map--circulation** | Orbit | — | Score | word → G32 | nothing was separate: one line touches all |
| 30 | Maya · DISSOLVE | Structural · Textarea | **G10 Still Point** (each hold takes away; type 18 → 41 px) | Night | silence | Score | G17 outward, then gone; release stage = Maya's last line "only You, playing" (ruling 8) | DISSOLVE = removal |
| 31 | Aatma · KNOW/HOLD | Structural · Textarea | G2 | Hold | 528 Hz trinity | Score | **G32 carve** | the soul revealed is the "I" carved from "you" |
| 32 | Ego Reveal · CONNECT | Structural · Textarea | **kept sealed** (ruling 2): A3's sealed state, "A letter waits." | — | — | — | — | the words stay sealed; the form already has a sealed state with no peek |
| 33 | Lalita · PLAY | Structural · Textarea | A6 play-it | **G47 finger play** (no goal, no ending) | — | Score | the field of games (S17) | PLAY |

## B3 · Her Home (her room) and her chambers
| # | gift | source | how it works in Her Home | needs | E/S |
|---|---|---|---|---|---|
| 1 | **G35 touch beats replace the three text slides over fog** | `gestures.md:244–247`; Foundation audit 2 | The Home opens with three self-writing beats (1.9 / 3.7 / 5.6 s), each waiting for "touch to go on", the last "touch to enter". Shortened on return (×max(0.36, 0.66^(visits−1))), never skipped. No fog panel and no text block. | 3 beat lines from canon per Śakti | energy |
| 2 | **G30 colour through staying** (G0 2900/750; grey `saturate .32 brightness .70` → full colour; words legible past l = .55) | `gestures.md:221–223` | Answers audit 4 (light ~11–65 vs Design 80–255): her room *brightens to Design's light* as he presses and stays. | room light ramp tied to l | energy |
| 3 | **G49 dwell head start** (`min(dwell·0.55, 221 s)` above 12 s of dwell; ceremony shortened `max(0.36, 0.68^min(visits,4))`) | `gestures.md:313–316` | A chamber he has stood in opens further along its adaptation clock. Felt, never shown. | dwell per kp in App Activity | energy |
| 4 | **G2 stillness gate** (4600 ms; a touch pauses, never resets; "every still second he has ever given is kept"; one line after 700 ms, once ever) | `gestures.md:60` | Her far wall (the withheld fifth / deeper chamber) opens to the absence of his hand. | accumulated stillness per kp | energy |
| 5 | **B2 two-door station** (walk it · read it, two flames: half / whole) | `forms.md:193–195` | Fixes audit 1: Home and Detail become two halves of one door, equal weight, with "now, while it is still warm" offered after each. | `{walk, read, flames}` per kp | energy |
| 6 | **A7 or G11 for her Detail's 13 sections** | `forms.md:133–138`; `gestures.md:112–117` | Her Detail stops being a text page. Sections arrive by her ring's gesture, or lit one per touch. | Detail sections from Airtable verbatim | energy |
| 7 | **Ceremony grammar for "I feel her"**: breath → beats → act → answer in her element → hold → whisper + one warmer light → bowl → return on the same breath | `forms.md:258–268`; G39 staging (300 / 1100 / 2600 / 4300 / 5400 ms; collapse 620 ms) | Recognition ceremony with the two verbatim lines ("she was felt here" / "and she felt you back"). The answer moves in her element (Ahaṅ fire flares 5.5 s, Nāma air 6.0 s, Ātma light 3.8 s, Amṛta water 6.5 s). | element per Śakti; the two lines verbatim | energy |
| 8 | **map--climb** (body as altitude, bands of weather, a rail naming the region, fly into a light, three touch beats in, sideways doors to neighbours) | `forms.md:230` | The approach to her Home from the Climb; sideways doors are her `neighbourOf` positions. | neighbour graph (register 01 H-TABLE) | energy |
| 9 | **G43 arrows step a ring of places** (fade .28 / swap / .4 s) | `gestures.md:284–286` | Step to her ring-sisters without leaving the chamber register. | ring roster | energy |
| 10 | **A9 Still Point at the foot of her room**, never gated | `forms.md:147–151` | Below her Detail, seven holds strip her line to the ember. | `stages[7]` (canon lines only) | energy |
| 11 | **G13 the rope** (1.1 s press anywhere → a black room, two 10 s breaths before words) and **G38 leave by the edge** (24 px, > 70 px) | `gestures.md:124–127, 259–262` | From any chamber: a quiet room, or out, never punished. | — | energy |
| 12 | **G9 carried light** for Ring 6 chambers (the source *is* Ring Worlds II ring 6) | `gestures.md:101–104` | Ring 6 rooms are read by a light that reveals only what is near. | ten marks per room | energy |
| 13 | **G17 two holds** for the Ring 9 / Bindu chamber (inward fall, outward bloom; layers at .06–.80) | `gestures.md:148–153` | Mahātripurasundarī's chamber. | — | energy |

## B4 · Today and the Rite
| # | gift | source | how | needs | E/S |
|---|---|---|---|---|---|
| 1 | **A1 Rite form as a contract** (arrival · reading lit per touch · gathering · recognition "yours to mend" · sealing) with the density budget `(1.4 + 1.4·lines + 1.4 + 2.8)` s per full voice, 4.2 s per passing line, 6.6 s for the centre | `forms.md:91–95` | Today's Rite fills from one contract. "each day keeps two voices and one from a rotation (`rota[]`, keyed on the date) in full … the zeroth voice is never silent." Ruling 6: voices are the named archetypes. | `{title, place, kicker, body[], voices[], kept[], rota[], prompt, close}` | energy |
| 2 | **G11 timing** (lit over 2.6 s, scroll to 52%; "The field gathers" 2.5 s; voices `(4 + lines·3.6)` s; "The room has changed." at 3.6 s; close at 7.6 s) | `gestures.md:112–117` | Exact timings for the Rite's reading and sealing. | — | energy |
| 3 | **A10 the day's line in three persons** (to you, signed "— the field"; back to you, from his own sealed vows, "a vow · arrived" ● / "still living" ○; about the world) | `forms.md:153–158` | The first screen through the Today door: one line resolving out of the dark, "leave". Chosen from the local practice day; one "draw once more" a day. | Airtable line pools; his sealed vows (from G32 carves) | energy |
| 4 | **B1 threshold card** before the Rite | `forms.md:189–191` | Varies what meets him first, by weight. | kinds pool | energy |
| 5 | **calendar--day** (doors that change with the hour; walked doors dim; "close the day" on one sentence; the morning question and the evening offering as its two ends) | `forms.md:235` | Today as a day-long corridor: morning Rite → day doors → evening Pūjā (register 03's "⑦ Pūjā · The Evening Offering"). | hour-keyed doors | energy |
| 6 | **B4 home by how far walked** (black splash 1.6 s first arrival; "return. / the road remembers" 2.3 s after days away; completion ceremony 0 / 1.1 / 2.4 / 3.8 s) | `forms.md:201–203` | Launch at the Bindu (ruling 1): the arrival state is read from App Activity events, never a "done" flag. | event reads | energy |

## B5 · The Well (his letters) and Beneath
| # | gift | source | how | needs | E/S |
|---|---|---|---|---|---|
| 1 | **A3 Letter, adapted**: a NOW line; a letter can be sealed to a day ("A letter waits. It opens <date>." / "A letter is ready. Open it."), read at once or revealed at ~1.5 words/s | `forms.md:104–109` | His letters to a Śakti can optionally be sealed forward to a date (her next day in the 102-day cycle, a full moon, a month). The Well becomes a river of letters above and below the NOW line. "no reply and no peek" fits law 8: her voice is never generated. | `{letters:[{dir, to:{kind:'kp'|'date'|…}, text, made, opens?}], reveal}`; private | energy |
| 2 | **G27 seal by wax** (drag the seal on; fold 900 ms `scaleY(.2) translateY(−60)`, settle tone; no words → nothing sealed) and **G31 hold to release** (2300/620, armed only with words) | `gestures.md:207–210, 225–227` | Sending a letter is a held act, never a tap on "Send". | — | energy |
| 3 | **G46 speak** (press once, "saved" lights at once; transcript at ~90 ms/word; 15 px ember with rings 3.4/4.3/5.6 s, "not a level meter, not a timer") | `gestures.md:298–301` | Dictate a letter on-device (`SFSpeechRecognizer.requiresOnDeviceRecognition`), typing beside it. | on-device speech; mic permission | energy |
| 4 | **G41 tap to mark** (parity log) | `gestures.md:274–277` | Mark lines in past letters; each tap appends one App Activity entry. | ledger rows | energy |
| 5 | **A2 Mirror walk under the floor** (G14 door 1250 ms; three arrival lines; three teachings word by word at depths .32 / .60 / .85; "look"; one question; the word returned; vow carved ~2 s; light floods 1.4 s; one star warmer) | `forms.md:97–102` | **Beneath** (Foundation: "Under the ground … S15 Mirror, G14 descent"). Each walk is a light in the sky of walks: warm when walked (`oklch(.92 .08 90)`), violet when waiting, breathing 3.2–6.2 s. | `{id, name, hue, figure, arrival[3], teachings[3], question, reflection, vowYou, vow, exit, status}` | energy |
| 6 | **A4 Gates of release** (arches down one line; only the next lit; at each: whisper, question, set down by G33 2600 ms or keep by G26; "· passed ·"; rising, one gift per gate; ground darkens a step per gate) | `forms.md:111–116` | Shadow work beneath the ground. "a laid-down word is stored nowhere" honours journal privacy. | `{gates:[{name, gloss, question}], gifts[]}` | energy |
| 7 | **teaching--skill DISTANCE** (bought `{t}` → "I'm having the thought that {t}" → "I notice I'm having the thought that {t}"; the gap widens, type shrinks) | `teaching--skill.html:144–152, 215–240` | The **Shadow Translator**: he types a charged line and watches it move away from "you" in three stages. Never stored. | — | energy |
| 8 | **practice--stillness WATER + leaf** | `practice--stillness.html` | Beneath's surface: a thought set on a leaf drifts 13 s and off the page. | — | energy |
| 9 | **Law 18 + G14 passage** (paper lifts, dark wells up, ember 11 px, 110 Hz + fifth) | `SKILL.md:85`; `gestures.md:129–134` | The one crossing from the lit ground to Beneath: the first time and at every Threshold; otherwise the 1.5 s everyday veil. | — | energy |
| 10 | **A11 answerable reflection** (clauses rise 1.2 s, 1.4–1.6 s apart; sources shown; lands / say more / leave my own word) | `forms.md:160–165` | The witness at the Well: a reflection on his month that shows its sources and that he can answer with his own word, which then replaces it. | `{line[], sources[], answers}` | energy |

## B6 · The Mandala, the nine rings, the Climb, the Veil
| # | gift | source | how | needs | E/S |
|---|---|---|---|---|---|
| 1 | **map.html rings figure**: nine rings r 232 → 24 (step 26), live ring lit with its numeral, scale ramp .92 → 2.3 capped (no filter on the scaled subtree; the glow is a second stroke), core dims past ring 6; drag spins with 40° snaps | `map.html:40–110, 152–196` | **The nine rings as a corridor inward**: scrolling travels toward the Bindu, one āvaraṇa per screen, the live ring lit. The perf contract carries straight to Metal/SwiftUI. | ring names, counts, colours (register 03) | energy |
| 2 | **map--yantra-walk** (inward at constant size; only your ring lit; stars ● walked · ◐ in progress · ○ seeded; "the visit told back at the centre") | `forms.md:227` | His position (kp) is the lit star; walked Śaktis are ●. | App Activity per kp | energy |
| 3 | **map--poly construction**: "the order you'd draw it by hand"; every stroke `pathLength=1` + dashoffset; staggered delays; spin at the figure's symmetry ("every detent lands on the same drawing. That is itself the lesson"); "the absence is the content" | `map--poly.html:144–240` | **The Śrī Yantra drawn by hand**: bhūpura, circles, petals, then the nine interlocking triangles (four up, five down) stroke by stroke as he scrolls, each āvaraṇa's own edges lighting while the rest hush (.35). Grace: an 80 s slow turn. | yantra geometry (exists in app) | energy |
| 4 | **map--spine for the Climb (Axis)**: a 154 svh rail that travels so the live centre holds the optical middle; sushumna drawn as a gradient by dashoffset; ida/pingala braided and crossing at every centre; lotus petal counts 4·6·10·12·16·2 and a crown of fine petals; drag to climb, tap goes to the nearest centre; at the end it steps back to show the whole | `map--spine.html:126–271` | **The Climb** ("Axis 18"): vertical drag climbs (Foundation navigation). The figure agrees with the words ("drawn with two petals"). | per-chakra hex and petal counts; the 33's positions on the axis | energy |
| 5 | **map--tree "lightning flash"**: a separate stroke that crosses where no path runs, drawing down edge by edge; the ending lights every path from the bottom up ("the return") | `map--tree.html:144–225` | The descent of light from Bindu down through the rings, then the return up at the end of a walk. | path list | energy |
| 6 | **map--grid two cycles** (outgoing arrows only: one it feeds, one it restrains; glyphs counter-rotate so they never read upside down; 72° detents) | `map--grid.html:144–225` | The Relationship Field or the elements (ruling 4: Ahaṅ fire, Nāma air, Ātma light, Amṛta water) drawn as a wheel of feeding and restraining. | relations data | energy |
| 7 | **B3 / map--veil + G42** (image stays whole at ~55%; a column by depth; tiers You are here · Open · Ground · Ahead · Veiled; dashed uncrossed line; "nothing is locked") | `forms.md:197–199`; `gestures.md:279–282` | The always-available index ("the hamburger grown into the whole Meru by depth"). | `{places:[{n, name, line, tier}]}` | energy |
| 8 | **map--sky** (every page a star on the golden angle, the die at the centre, scope chips, a roll you can see land) and the **Door with a die** | `forms.md:229`; `SKILL.md:45` | "the die" navigation: a visible roll across all 102 + 33. | — | energy |
| 9 | **G15 membrane push** (span .36, K 30, brake law, 26 shards, 5.4 s; one register per full swipe, 240 px) | `gestures.md:136–141` | Shadow 3→4 and Armin 6→7 membranes (Foundation). | — | energy |
| 10 | **G44 continuous zoom** (z .22 → 34; a world offers its door at R > 36) | `gestures.md:288–291` | Deep zoom into the Bindu (ruling 9); flying into a light. | — | energy |
| 11 | **map--circulation** (a ring around a centre; one sentence travels hop by hop; each station says what it takes in, gives out, keeps) | `forms.md:232` | The 16 Karṣiṇī Functions (ruling 7) around a centre, one sentence circulating. | function rows | energy |

## B7 · A Strange Game (Leela) and every game its own world
| # | gift | source | how | needs | E/S |
|---|---|---|---|---|---|
| 1 | **A14 Board** (positions in their own colours; rises/returns drawn; throw; each landing opens a room: question → how you came → **a practice first ("I did it" · "Let it be")** → reading → one move → a seed → a door to the position's own page; at the end, the whole walk read back; care line verbatim "If today is heavy, the board can wait. Three breaths is a whole game.") | `forms.md:181–185` | Ruling 5: each Leela landing opens the chakra's energy room. This contract is that mechanism. | `{positions:[{n,name,color,question,line,practice,href}], rises, returns, enter, exact, care}` | energy |
| 2 | **G29 the hold is the move** (die 2200 ms with a rattle; deck 1900 ms trembling; Leela on the 33 keeps its tap die) | `gestures.md:217–219` | The throw. | — | energy |
| 3 | **A6 Play-it pieces** (one object, one gesture, one line, no score; real-time seed 2 h / 8 h / 24 h / 72 h; counts drawn as lit beads, not printed) | `forms.md:126–131` | Each mini-game as its own world. | `{title, verb, line, gesture:{g,params}, close, keep, realTime?}` | energy |
| 4 | Gesture games: **G18 Sri Yantra trace** line by line (22 px), **G19 shake to clear** (Δ > 18), **G20 tilt** (Still), **G23 Drum / Corridor / Coherence / Tuner**, **G24 three rings into alignment** (bells 392/490/588; centre lights), **G25 Join**, **G26 Release**, **G27 Seal**, **G28 Choose/rewind**, **G47 Child garden / paint / rain / echo** (110 + 220 Hz drone) | `gestures.md:155–219, 303–306` | Each is a ready world in Lalitā's field, with its numbers. | sounds | energy |
| 5 | **walk--growing / play-it realTime** | `forms.md:223` | A seed planted at a landing that grows by hours between visits. | timestamps in App Activity | energy |

## B8 · Time, Memory, Modes, Relationship Field, Presence, Home
| # | gift | source | world | how | needs | E/S |
|---|---|---|---|---|---|---|
| 1 | **calendar figure** (sky band 46 svh with 5 stops; sun on an arc `a = π(1−d)`; lamps lit per step, staggered .09 s; a lamp can be lit early by touch and stays lit) | `calendar.html` | **Time**; Today | One day as a corridor: the sky actually passes; his touch can light a lamp early. | hour slots | energy |
| 2 | **calendar--sky** (five wheels: hour, lunar day, lunar mansion, season, sun sign; one lit bead each) and **breathing on the wall clock** (8 s, phase `(now mod 8000)/8000`) | `forms.md:236–237` | Time; the Bindu | The five clocks (Foundation's "five clocks") as rings round the point. | astronomical calc | energy |
| 3 | **Walk with cooldown** (rail of landings travels to eye level; tide of 5 dots in the waiting card; "This day is still closed. It keeps its own time.") | `walk.html` | Time; the Climb over days | His own 12 Oct rulings (Leela ≥ 3 days, dissolutions once a day) are designed gates; this is how a gate *waits* beautifully. | App Activity timestamps | energy |
| 4 | **storybook--tradition SILSILA** (one lamp lit from the previous; a spark runs the lit length on touch; the last lamp is yours) | `storybook--tradition.html:108–239` | **Memory** | His walked days as a chain of lamps; touch it and the light runs from the first day to today. | his ledger | energy (the stories in it are story → Feed) |
| 5 | **Law 12 offers**: *forget me* and *carry your road* (a dated record to keep or print) | `SKILL.md:79`; `forms.md:284` | Memory | Both always offered. Felt dwell, never shown as counts. | export of App Activity | energy |
| 6 | **storybook--held-beats embers** (≥ 3.5 / 7 / 14 s → op .5/.72/.92, blur 14/22/32) | `forms.md:209`; G49 | Memory | Places he lingered carry a faint ember on return. | dwell | energy |
| 7 | **B2 two-door station** and **law 7** | `forms.md:193`; `SKILL.md:74` | **Modes** | Every mode offered as walk it / read it. | — | energy |
| 8 | **Eight Modes depths** (3 s / 30 s / 2 min; captions 7, 14, 21, 28 s) | `gestures.md:63` | Modes (Darśana, Mauna) | Stillness that deepens in tiers. | canon captions | energy |
| 9 | **fieldguide--for-someone-else STANCE** (three marks: you, them, the third; positions all / against / merged / apart / beside; drag "you"; distance < 34 "too close", > 140 "too far", else "near enough to stand beside"; never stored) | `fieldguide--for-someone-else.html:111–217` | **Relationship Field** (ruling 10, built in full) | Three marks: **him, the person, and the Śakti the person carries** (register 03 BELOVED: Ram, Gaia, Mother…). He drags himself and the field names where he stands. Ends on "beside". | person → Śakti rows | energy |
| 10 | **teaching--relationship ATTUNE** (two waves, same speed; only the phase differs; drag yours; in step when < .04 of the wavelength → both deepen; "IN STEP BUT STILL TWO") | `teaching--relationship.html:109–226` | Relationship Field | The relationship's living line: he brings his line into step with theirs. | — | energy |
| 11 | **walk--relationships LADDER** (two rails, a rung per shared day; every 7th a double rung; the waiting state is two dots drifting toward each other) | `walk--relationships.html:122–220` | Relationship Field | Shared days with a person, drawn as rungs. | — | energy |
| 12 | **twochairs authorship by colour** and **two chairs "never picks"** | `forms.md:233`; `twochairs.html` | Relationship Field; Modes | Each voice's words in its own colour, his in his. | — | energy (debates themselves: story → Feed) |
| 13 | **G30 colour through staying** | `gestures.md:221–223` | **Her Presence** (no figure of a Śakti) | Her presence is coloured in by his staying, not by a picture. | — | energy |
| 14 | **G2 stillness gate + G17 two holds + "Now go play"** | Foundation :13; `gestures.md` | **Home / the Bindu** | The summit and the centre. | — | energy |
| 15 | **verse moves**: shirorekhā head-rule, breathing line (spacing .012 → .07em over 2.4 s), "focus, not fade" (rise 14 px, blur 6 → 0 over 3.2 s), "written by an unseen hand" (her name stroke by stroke, transliteration first, never a seed syllable), words from particles | `verse.html`; `forms.md:238–241` | Her Home name; the Rite; the 102 names | Her name drawn by an unseen hand on arrival; nāma lines breathe on touch. | Devanagari stroke paths | energy |

## B9 · Story material: flag for Bindu Feed (ruling 5), keep the mechanisms here
| item | source | why story | what stays in this app |
|---|---|---|---|
| Storybook form + `parable`, `cosmology`, `tradition` | `bashar…`, `storybook--*` | ten-page fables | page-turn physics (rotateY ±7°, 1.2 s; thinning fore-edge); SEPARATION planes as an energy figure (two planes parting, light between, `sep` 0..1) for 30 Maya or Armin's crossing; SILSILA for Memory |
| Portrait form + `sage`, `scientist`, `seer` | `portrait*` | lives in moments | the life-line point and its drag; "future points invisible until reached"; AFTERLINE branches (what outlasted) for his own road in Memory |
| Icebreaker | `neem-karoli-baba.html` | conversation cards about a person | hand-over cards (copy one question); the lamp warming with `--p` |
| Two chairs | `twochairs*` | debates | the MIRROR (a mark answered by its reflection .7 s late) for 32/17; chairs that never pick |
| Teaching guide prose | `a-mirror-not-a-master.html` | rules in prose | three registers per law; the law picker. Its eight laws are Bindu Being's ethic, which matches "nothing scores him" |

---

# C · Conflicts and gaps

1. **forms-contract.json vs forms.md.** The JSON's `existing/new` split (3 / 23) does not match "twelve + fourteen" (`SKILL.md:22`). Several contracts are abbreviated in the JSON:
   - mirrorwalk: no `×3`, no status enum
   - letter: no `to.kind` enum
   - dayline: no `from:'device'`, `pick:'date'`, `redraw:1`
   - score: crescendo, entries and fruit shapes missing
   - wager: enums missing

   forms.md:2 says the JSON "is the source of the contracts". **Ruling for the builder: use forms.md's fuller shapes**, since they are a superset.
2. **Two different return-compression constants.** G35 (Rite of Entering): `max(0.36, 0.66^(visits−1))` (`gestures.md:246`). G49 (Homes): `max(0.36, 0.68^min(visits,4))` (`gestures.md:315`). Keep each where its experience was designed (law: "the experience as designed"). Do not unify them.
3. **Letters "stay on the device"** (A3 guard, `forms.md:109`; G46 "words stay on the device") vs the app's ruling that letters sync (register 04 CB0-15 superseded, R17). Also "one key per thing under one prefix" (law 12) and every exemplar's localStorage keys (`asg.walk.*`, `asg.lesson.*`, `asg.teaching.mirror.held`, `asg.at.*`) vs the floor **"App Activity is the single ledger"**. In the app, every form's persistence goes to App Activity (letters to his own private table). The device-only guard was written for a public website, so the privacy intent holds through his private base.
4. **Counting the reader** (law 11) appears in exemplars that predate it:
   - `practice--lesson` prints "day d of the fourteen"
   - `practice--senses` prints "n of 15 noticed"
   - both walks print "Day 1 of 30" and "read on <date>"
   - `a-mirror-not-a-master` stores and lights the law held longest (a measure of the reader)
   - every exemplar shows `#count` "i / N"

   The app's floor is "nothing scores him". The restriction on measuring words is lifted (Foundation :40), but the floor stays. Port the figures and **drop the reader-counts** (draw lit beads instead, per A6's guard).
5. **"Nothing new is locked"** (law 5) vs his own designed gates (Leela ≥ 3 days, dissolutions once a day; Foundation :44). There is no conflict: law 5 and §F explicitly keep designed gates. The walk's waiting card is the model for how those gates wait.
6. **A1 Rite: "Never tiered by a count of the reader's returns"** vs the Rite of Entering's return compression (register 02 R-05 "Zero Gap") and G35. Compression is designed pacing, which law 12 explicitly keeps. It is not tiering, so no conflict, but the builder must not let compression change *which* voices speak.
7. **Recognition lines.** G39's staging strings ("felt here · <time>", "and felt you back · <time>") differ from the app's verbatim floor lines ("she was felt here" / "and she felt you back"). **The app's lines win**; use only G39's timings.
8. **map--spine chakra colours and bījas** (#C8453A … #9A72C0; LAM VAM RAM YAM HAM OM) are the web "modern synthesis" and differ from the app canon hexes (05 register: Muladhara #B83A3A, Svadhisthana #D47438 …). Bījas: "nothing invented, verbatim". Use the app canon hexes; the figure mechanics port and the colours do not.
9. **G21 microphone, G22 camera, G19/G20 motion and G46 speech** need iOS permission strings and on-device engines (`NSMicrophoneUsageDescription`, `NSCameraUsageDescription`, CoreMotion; `SFSpeechRecognizer` with `requiresOnDeviceRecognition`). None of these are built. Each needs its designed fallback (tap to loosen / dark screen / drag / typing).
10. **The web corridor uses CSS scroll-snap.** SwiftUI needs a paging ScrollView, a `scrollPosition` binding for `ASGjump`, and the hit-test layering. Nothing exists yet. This is the main engineering gap behind Foundation root cause 2.
11. **No guide or door exemplar** (`forms.md:68, 71`). The Veil and the die-door have contracts but no exemplar in this skill. The Mandala Veil export (register 03) is the reference.
12. **Numbers disagree across docs:** "511-topic register" (SKILL :13) vs "889 pages · 41 families" (`forms/index.html:88`) vs "916 instances" (`forms.md:75`). These are web-site numbers and do not bear on the app.
13. **Wellbeing law** (pointers, not pages, `SKILL.md:62`) and the crisis field guide's "see a professional": the app has no care line yet. A14's care line ("If today is heavy, the board can wait. Three breaths is a whole game.") is a designed part of the Board form and should come with Leela.
14. **A5's "S · T · C honesty badge"** for frequency claims has no counterpart in the app's Hz-carrying awakenings (174 / 210 / 320 / 341 / 384 / 426 / 480 / 528 Hz). The badge legend is not defined in the files read here; it lives in the Bindu Field source.
15. **Designed but unbuilt in the app (all of §B):** the corridor engine, the figure protocol, G0 as a shared engine with held-key parity, the ceremony grammar's element answers, the seven forms of time, A3 / A4 / A2 under the ground, the A14 board contract with practice-first landings, the Score player (A13) for 33 dances, and the B3 Veil with five tiers.

---

# D · Coverage proof
Method key:
- **R-full**: read with the Read tool, line 1 to the end.
- **R-mid + diff**: the shared regions were verified byte-identical against a file already read in full. Lines 8–107 (BASE) were diffed against `fieldguide--conversation.html:8–107`; the only differences were the accent line and in some files a one-line shift (`:root{` / `.count{white-space:nowrap}`) or a missing `body.still` line. Line 1 is identical across all 21 variants once `<title>` and description are stripped (one md5, dc659025, ×21); lines 1–7 header comments were printed in full. The CORRIDOR_JS tail (from the `CORRIDOR_JS` line to the end) was diffed against `fieldguide--conversation.html:168–251`, with 0 diff lines in all 21. The unique middle of each file was read in full with Read.
- **R-folded**: one line was over 2000 characters, so a `fold -s -w 600` copy in scratch was read in full for that region.

| file | wc -l | lines read | method | md5 |
|---|---|---|---|---|
| SKILL.md | 101 | 1–101 | R-full | c33318f0 |
| references/forms.md | 284 | 1–284 | R-full | d0be8039 |
| references/forms-contract.json | 191 | 1–191 | R-full | bb298d78 |
| references/gestures.md | 333 | 1–333 | R-full | 08f05b98 |
| exemplars/forms/index.html | 90 | 1–90 | R-full | ed50849b |
| exemplars/forms/practice.html | 193 | 1–193 | R-full | 6f93b4b5 |
| exemplars/forms/walk.html | 189 | 1–189 | R-full | 3964b351 |
| exemplars/forms/calendar.html | 192 | 1–192 | R-full | da4be3e7 |
| exemplars/forms/fieldguide.html | 166 | 1–166 | R-full | c9acd596 |
| exemplars/forms/map.html | 197 | 1–197 | R-full | ef776724 |
| exemplars/forms/portrait.html | 195 | 1–195 | R-full | ab2cf8f7 |
| exemplars/forms/recipe.html | 213 | 1–213 | R-full | 89f65104 |
| exemplars/forms/twochairs.html | 207 | 1–207 | R-full | 791361d4 |
| exemplars/forms/verse.html | 151 | 1–151 | R-full | 36651611 |
| exemplars/learning/icebreaker/neem-karoli-baba.html | 258 | 1–258 | R-full | 41705c8c |
| exemplars/learning/story/bashar-the-five-laws.html | 218 | 1–218 | R-full | f58acac5 |
| exemplars/teachings/a-mirror-not-a-master.html | 227 | 1–227 | R-full | 7819203a |
| variants/fieldguide--conversation.html | 251 | 1–251 | R-full (the reference) | c7cf5672 |
| variants/fieldguide--for-someone-else.html | 301 | 1–301 | R-full | 708deca8 |
| variants/map--grid.html | 309 | 100–309 R; 1–99 diff | R-mid + diff | 38db71aa |
| variants/map--path.html | 288 | 100–288 R; 1–99 diff | R-mid + diff | aa2eba5e |
| variants/map--poly.html | 310 | folded copy 107–241 R (covers original 107–226 incl. the 7538-char line 184); 1–106 diff; 227–310 corridor diff | R-folded + diff | 0248f9fd |
| variants/map--spine.html | 329 | folded copy 107–271 R (covers original 107–245 incl. the 15695-char line 190); 1–106 diff; 246–329 corridor diff | R-folded + diff | f1e7f5e4 |
| variants/map--tree.html | 309 | 143–226 R; 100–142 identical TYPE_MAP/BAND block read in map--grid; 1–99 diff; 226–309 corridor diff | R-mid + diff | 626711a4 |
| variants/portrait--scientist.html | 280 | 100–197 R; rest diff | R-mid + diff | 935f0df1 |
| variants/portrait--seer.html | 279 | 100–196 R; rest diff | R-mid + diff | 0753057e |
| variants/practice--body.html | 256 | 107–173 R; rest diff | R-mid + diff | 85316194 |
| variants/practice--lesson.html | 351 | 107–268 R; rest diff | R-mid + diff | f935cd60 |
| variants/practice--senses.html | 243 | 107–160 R; rest diff | R-mid + diff | 659d1c76 |
| variants/practice--stillness.html | 259 | 107–176 R; rest diff | R-mid + diff | 3669f2df |
| variants/storybook--cosmology.html | 301 | 100–218 R; rest diff | R-mid + diff | 3dc1c57a |
| variants/storybook--tradition.html | 328 | 100–245 R; rest diff | R-mid + diff | 269f34c6 |
| variants/teaching--mind-body.html | 303 | 107–220 R; rest diff | R-mid + diff | aec29aea |
| variants/teaching--other.html | 270 | 107–187 R; rest diff | R-mid + diff | 68f2ff17 |
| variants/teaching--relationship.html | 315 | 100–232 R; rest diff | R-mid + diff | b5ba4805 |
| variants/teaching--skill.html | 330 | 107–247 R; rest diff | R-mid + diff | e36e1da8 |
| variants/twochairs--mind-and-machine.html | 267 | 100–184 R; rest diff | R-mid + diff | f0aeb9c3 |
| variants/walk--relationships.html | 304 | 107–221 R; rest diff | R-mid + diff | 5db7e6d8 |

There are 34 exemplar files (the brief said about 32). All are covered. Nothing was modified. The only file written outside this one is the scratch fold of two files. Context only, not assigned: `waves/foundation/FOUNDATION-2026-10-12.md` (52 lines, R-full), and greps of registers 01, 03, 04 and 05 for vocabulary (the 33-room type and gate table at `05-chakra-corpus.md:387–421`).

---

## Return message
**File:** `/home/claude/bindu-mandala/waves/register/11-padakarshini-forms.md`

**Ten most valuable gifts:**
1. **The corridor + figure engine**: one piece per screen, text that arrives by scale and opacity as its step becomes current, a drawn figure per room driven by per-step slots, and the hit-test contract so a room can be read and touched at once. This directly fixes "data rendered as prose / one ScrollView for 33 rooms".
2. **Room-type → gesture mapping for all 33**, from the canon gate types: Canvas → G18 trace into the point; Textarea → a word asked without a box, then G32 carve or G33 lay down; Sound Response → G21 mic (whose source *is* the Vishuddha wake-up); Tap Rhythm → G23 Beat; Device Tilt → G20. Highlights: Invention ASSEMBLE = G25 join ("the third thing"), Maya DISSOLVE = G10 Still Point, Shadow LOOK = G9 carried light, Armin = G15 membrane + G16 consent.
3. **A7 Four-section reading** (SAY · WALK · HAND · OPEN), each section surfacing only by the room's own gesture (stillness, following, parting, bearing, keeping pace). This is the "story told by a moving point" thread without a text page.
4. **The ceremony grammar**: one breath first; beats; the act; an answer in the world's own element (fire flares 5.5 s, water pools 6.5 s, air 6.0 s, light 3.8 s); a hold that carves or lays down; a whisper and one warmer light instead of a checkmark; return on the same breath.
5. **G0 hold engine**: commit on the threshold, act on release, drain on early release, held-key parity, haptic ramp 0.15 → 0.6, plus a catalogue of every designed hold duration from 700 ms to 5000 ms.
6. **The seven forms of time** (Aperture, Pace, Trail, Hold, Bloom, Orbit, Night) with exact numbers, so no practice ever shows a clock.
7. **Her Home cures**: G35 touch beats replace the fog slides; G30 colour-through-staying brings her room up to Design's light; the B2 two-door station makes Home and Detail equal halves; the G2 stillness gate opens her far wall.
8. **Map figures for the Mandala and the Climb**: the nine-ring inward corridor (scale capped at 2.3, no filters); the hand-drawn construction (map--poly) for the Śrī Yantra; the travelling spine rail with braided channels and petal counts for the Climb; the Veil with five tiers that never lock.
9. **Beneath and the Well**: A2 Mirror walk (1250 ms door, word-by-word teachings, a vow carved from "you" to "I"); A4 Gates of release (laid-down words stored nowhere); A3 sealed letters with G27 wax and G31 hold-to-send; the DISTANCE figure as the Shadow Translator.
10. **The Relationship Field and the Board**: STANCE (you · them · the Śakti they carry; drag yourself to "beside"), ATTUNE (two waves brought into step but kept two), and A14 Board, where every Leela landing opens the chakra room with a practice first and a verbatim care line.
