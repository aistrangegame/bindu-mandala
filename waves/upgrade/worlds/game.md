# A Strange Game — Lalitā's play (world design, stage 2)

Slice: `waves/upgrade/index/by-world/game.jsonl` (554 rows, every row read; printed readable to scratch and read 1–3246). Code read where the slice was thin: `Views/Mandala/TheEightDissolutions.swift` (1–318), `Services/TreeOfLife.swift` (168–226), `Services/LeelaDrops.swift` (1–80), `Views/Play/PlayModels.swift` (85–131), `Views/Play/PlayGame.swift` (140–356), `Views/Play/PlayGamesPattern.swift` (452–540), `Views/Play/PlayPhysicsWhole.swift` (54–76, 456–507), `Data/ActivityLedger.swift` (field ids), `Views/Mandala/GatesOfReleaseLayer.swift` (1–40); register `05-chakra-corpus.md:2976-3130` (Sacred Experiences, Hub, Seven Gates, Mirror, World in a Box), `06-chakra-skills.md:1805-1832`, `audio-on-github.md`.

Paths below: `P/` = `iOS/Bindu Mandala/Views/Play/`, `S/` = `iOS/Bindu Mandala/Services/`, `M/` = `iOS/Bindu Mandala/Views/Mandala/`, `T/` = `iOS/Bindu MandalaTests/`. Register refs are `NN:line` (file `waves/register/NN-*.md`). Index ids are `Gn-nnnn`. Element numbers are `E01…E97` (§2).

---

## 1 · The world

### 1.1 What it is — in his words and Design's

- **His words.** "Leela, the divine play … comes from a place of the player knowing the entire game and continuing to play it." "Lalita is the level of the Leela where the Leela knows Leela itself." "Leela is this element that is dropping into the game at different points and sort of just giving you freebies." "Every … story ends with some kind of an action item in the real world." "Leela never discloses about what you are going to encounter ahead." (C-1330, 07:920-923, G3-0503). "In the first part you've woken them up, in the second part now you're playing … once you realize that it's all just one then what else is there to do, just play." (C-1278, G3-0465). "So help me understand, is what I would usually say to the universe." (C-1201). "That's the way the whole system works, through asking for help and then being given." (C-1265). "The desire for liberation actually keeps us chained." (C-1033). "We limit our own capacity by limiting it based on the time." (C-1058). Origin: a printed Śrī Yantra, "a red dot right in the center … this white light moving behind the red dot. No particular pattern" (C-1222). His intention for the game: "A recognizing instrument of love technology in the form of games, that help you remember yourself by downloading the higher self into this reality." (06:2038-2044, G3-0279).
- **The skill's words.** "The game is reception infrastructure … the walker brings willingness; the game opens reception; the higher self downloads. Not as metaphor. As mechanic." (G3-0277, G5-0564). "Leela = the divine play itself. Lalita = the level of Leela that knows itself as Leela. Bindu = the level of Leela that does not yet know itself as Leela." (G5-0570). "Every other game is played inside this one. Every player is also the play." (Identity · A Strange Game, G6-0721). "The game holds and remembers, so the player can play." (G3-0280).
- **Design's words.** The Play Engine home: "The playing side" · the Sakshi seed "I'm holding it for you, because you held it for me." · "nothing here keeps score" (G3-0239). The play chassis: "cloth, paper and a marigold point … Everything you receive arrives on ivory paper. Nothing keeps score." (G5-0489). The sketchbook's rule: "every game … is a physical verb with a skill in it, instant feedback, a clear arrival; words only as the reward" (G3-0247). Leela on the 33: "You cannot lose here. You can only not-yet-arrive." (G3-0301). The care line: "If today is heavy, the board can wait. Three breaths is a whole game." (G4-0688, G7-0432).
- **The foundation.** A Strange Game is one of the fifteen worlds: **Leela at the centre and every game its own world** (READER-BRIEF-2). Ruling 5: games stay; each Leela landing opens the chakra's energy (room). Ruling 16: his own limits stay — dissolutions once a day; Leela drops ≥3 days apart then 30%; "never in the first days" is lifted.

### 1.2 Arriving

**Ways in** (all crossings travel through the point, blooming from the touch in this world's colour — cloth #0F4A50 with the marigold point #F2B632; full list §5):
1. From **Home** — the Lalitā source's door "play in her field" (`M/LalitaSourceView.swift:68-72`, G7-0180).
2. From the **menu** constellation — the game's world-point.
3. From **room 30 (Māyā)** and **room 33 (Lalitā)** of the 33; from each chakra room's game door (`<Game> · <verb>`, `Views/Chakra/ChakraRoomView.swift:524-579`, G7-0361).
4. From **Her Home / Her Presence** — every one of the 102 has a game door (`P/PlayGame.swift:360-390`, G7-0235).
5. From **Today** — The Draw and The Sakshi Pause as Today's doors; a Leela drop's "carry it".
6. From **search**, the **Veil**, the die "Or don't decide. Touch the point. The field chooses." (G5-0287) and a universal link `aistrangegame.com/b/<verb>` (G4-0151) straight into a dance on the Dances shelf.

**The entrance — the Eight Dissolutions** (E03; built, `M/TheEightDissolutions.swift`, `S/TreeOfLife.swift:205-223`). The first entry of a practice day (day boundary 06:00, `DailyEnergyService.practiceDayIndex()`) walks the eight. Second by second:

| t | what he sees | what he hears / feels |
|---|---|---|
| 0 s | Ground near-black (0.03, 0.02, 0.03) under paper (0.91, 0.89, 0.87) at α .10; an 8 pt point (0.75, 0.22, 0.17), shadow 8 pt; the ring-1 panel declaration "The earth that holds you was chosen by you." (voice 20 pt, centred, 40 pt side margins) and under it "Now release it." (15 pt, ink α .62) | Om swell set to 0 (`SoundConductor.swellOm(0)`) |
| station 1 | touch, lift → release | medium impact .8; Om swell .15 + .6·1/8 = .225 |
| release | the line scales 1.08, blurs 8 pt, fades; 1.8 s (0.6 s reduce-motion) → next station; ground α rises .10 + .60·i/8 over 3 s ease | |
| station 2 | "Every desire was drawing you toward yourself." / "Let the word go." — the line drifts right 22 pt/s for up to 8 s; touching resets the clock | release after 8 s untouched |
| station 3 | "The fire that agitated you was building your form." / "Now be still." | release after 5 s with no touch |
| station 4 | "The love that arrived for others was always your own heart opening." / "Let the recognition fold back into you." — tracking 6·fold pt | pinch to < 0.8, or three taps (each folds 1/3) |
| station 5 | "What you finally said out loud was what you always knew." / "Now let the silence hold it." | 10 s; touches do not reset (the absence is the act) |
| station 6 | "You stopped looking and the seeing arrived on its own." / "Now move." | drag travel > 160 pt |
| station 7 | "The disease that was removed was the belief that you were less than what you are." / "Now offer it back." — line rises −160 pt on release | swipe up > 80 pt, or hold 3 s |
| station 8 | "Will. Knowledge. Action. You already know. You have always known." / "Now release what you held." | hold ≥ 3 s, lift |
| recognition | "Everything you placed in this space is already moving toward you." ground α .75 | Om swell 1.0, 7 s (3 s reduce-motion) |
| closing | "You have always had the Knowledge." · "You have always been the Will." · "Now You Become the Action." — one per 3 s (1.5 s), stacked; ground α .85 | |
| last words | "Now go play." 26 pt; ground α 1.0 | Om swell → 0 then off after 5 s (2 s); the field's own sound takes it |
| field | cross-fade 1.4 s into the field home | |

No Śakti, ring or chakra is named (the naming is the veil). **The dissolution writes nothing** — the only mark is the phone-local `dissolved_day`. Later the same practice day the entrance is "Now go play." alone for 3 s, then the field. Every station accepts its gesture broadly and has a fallback; leaving is one edge gesture (`theEdgeWayOut`). Build move: the dissolutions leave `LivingMandalaView` (G7-0209) and become the game world's own threshold, reached from every way in.

### 1.3 Being there — the field (home of the world)

**The field** (E07) is Lalitā's field: the place the world opens on after the entrance. What changes from today: the single disc of 36 lights (`P/PlayFieldView.swift:141-148`, G7-0282) becomes a **constellation of worlds** with Leela at the centre.

- **Ground.** Play chassis cloth #0F4A50 with the 5 px cross-hatch weave (`--play-weave`: two repeating linear gradients, white α .035 / black α .05); dark pair #0B3B40 / #082F33 (G5-0489).
- **Drawing (kept from today, `P/PlayFieldView.swift:245-274`).** Rings 2–8 in gold at α .07–.10; a square rim; a glow in the season's ṛtu colour (`SeasonLight`, `PlayPhysicsWhole.swift:721-727`); the garland of 102 beads turning once every 180 s; her point (accent red 120 pt halo, gold 40 pt core) breathing on a 9 s cycle.
- **Centre.** Leela's light, pinned at the centre (as the Śrī Yantra light is pinned today, `:73-110`), hue (0.36, 0.80, 0.78), with the board's token teal #0F7C7A as its core.
- **Around it** — the family worlds as glyph-points on one ring at radius 0.62 of the field, each glyph moving with its motion signature (G5-0467) and named in Newsreader 13 pt under it (lifting "a way, not a list", ruling 10; G7-0281, G7-0283): elements · heart · passage · pattern · words · growth · sacred · time (the eight families of the 36, G7-0463…0470), then the new worlds: the Sketchbook, the Child corner, Sacred Experiences, the Dances shelf, the Life Games, the Boards. Angles: families placed at the mean seat angle of their games' addresses (`PlayFieldLayout.point`), relaxed apart to ≥ 50 pt over 80 passes (existing `relaxed()`).
- **The address overview** (kept): pinch out on the field and every game stands at its own Śakti address exactly as today (ring distance radius·(9−ring)/8; seat angle −π/2 + 2π(i−1)/n; twins ±0.16; ring-9 at 0.16; garland at 1.1). Pinch in returns to the constellation. This keeps the 102-address truth visible without making it the only way in.
- **Words on the field.** Header "LALITA · THE PLAY THAT KNOWS ITSELF" (`:167`); once per visit the moving point writes "Leela is the game; Lalita is the game knowing itself." (Map gift #35, G6-0588) letter by letter at the foot and lets it fade over 9 s; the Sakshi seed "I'm holding it for you, because you held it for me." appears only on the first field of a day, under the point, 7 s. Foot words "the modes" (ModesDoorView) and "the road" (`MandalaWays.ask(.road)`), plus "your book" (E86).
- **The open ground** (Map gift #17, G6-0573). "One field. No question to answer." Anywhere on the field's empty cloth, a finger draws a marigold line (width 3 pt, fades over 9 s like Trace, E76); nothing is saved unless he holds 1.8 s on the drawing → "keep in the book".
- **Sound.** Entering the field: bell 523 Hz (`bell(f)` = f 2.6 s at .18 + 2.76f 1.6 s at .05 + .5f 3 s at .05, G3-0240). A tap on a world-point: 272.2 Hz (today's field tone, `:221-243`). Under the field: nothing — the play's own sound only begins inside a game.
- **Rare event — Lalitā enters** (E12, G5-0151). Unannounced, at most once in a play day, by chance 1 in 9 field visits: the ground inverts #020208 → cream #F8F3EE over 3 s, everything else dims to α .12, one line in the season hue at hsl(h 55% 36%), then gives the ground back with a four-turn exit spiral. "An event, not a theme."

### 1.4 Being there — each family world, then each game

**Crossing into a family world** (E09, G5-0469): overlay of the family hue 0 → .92 over .70 s ease-in, the glyph scales ×11, the world arrives at 700 ms; the whole ground recolours over 1.2 s (G5-0245). Inside a family world the games stand as lights on the family's own ground (gradient geometry by meaning, G5-0470: elements = light from the ground; heart = off-centre heat; passage = deepening downward; pattern = spotlight from above; words = horizontal band; growth = light from the ground with a green cast; sacred = edges heavier than centre; time = horizontal band turning with the sun). Each light carries its verb (P/PlayGame.swift:143-181) and, beneath, its name (lifting "game title never a heading", G7-0238). Tapping a light floods into that game in its own hue (`PlayGame.hue`) on its ring ground (`PlayGame.ground`).

**Inside a game** (E16, built host `P/PlayGameHost.swift`): ground, stage, stillness; the hint for 7 s then fading over 1.6 s — now recallable by a 1.1 s hold on the point at the top (G7-0289); a "< leave" that writes the ledger row if engaged (acts ≥ 3 and ≥ 6 s); word field for word games in Sanskrit type 30 pt "one word"; on completion the row first, drone to 0, bloom haptic, after 1.6 s either Recognition (`RecognitionMomentView(source: .play)`, the two lines verbatim) or PlayStillness (9 s breath of glow plus her name; "Feel her – …"). **There is no end screen** (`:12-13`). Every one of the 36 games and the new ones are specified in §2 rows E37–E85.

### 1.5 Going deeper — Leela on the 33

Leela is the world's centre (E21–E35). Second by second:

1. **Crossing in.** From the field's centre: overlay teal → board stone #E3E9EA (light) / slate #1B2230 (dark), .70 s; ground recolours 1.2 s. Lora / DM Sans (leela chassis, G5-0488).
2. **The intention** (E22) on paper #F2F5F4: "Leela on the 33" · "You cannot lose here. You can only not-yet-arrive." · "Harish Johari's Leela is the old board game of self-knowledge: you bring a question, the die decides where you land, arrows lift you, snakes return you to a lesson. Here the board is the 33 positions of the spine, each one asking its own question." · "What are you bringing to the board?" (placeholder "A question, a situation, a wall, a wish…") · "What are you playing for?" **My life** / **What I'm building** · "Enter the board". Each line revealed one per 1.5 s (Story beat duration, G4-0724). If a walk is in progress, this is skipped and the board returns exactly as left.
3. **The board** (E23). 33 rounded squares in boustrophedon, three columns (COLX 60/180/300 on a 360-wide board, row height 58, base y 650, scaled to width), each in its Map colour (Mandala/Map colours win), square 32 an empty ring. Gold arrows #B08A33 (dark #D6B25C); violet dotted snakes #6A4C9C (dark #A58ADB); token teal #0F7C7A (dark #3FB8B4), dot glow rgba(15,124,122,.28). Status line: "Unborn at 33." / "Throw. A six brings you in." The token waits at 33, "where the game also ends".
4. **The die** (E24). Press and hold (G29): 2200 ms, a breath ring closes around the die, "Breathe in." / "Let go when the ring closes." → "Let go."; rattle (band-pass noise 1900 Hz) while held; haptic ramp .15 → .6, latch at full (medium). Early release drains at 620–750 ms: "No hurry." / "Hold again when you're ready." A single tap on the die is the one-tap way through (Leela on the 33 keeps its tap die, G4-0753); a shake > 1.4 g also throws (built). Roll 480 ms; the face shows pips, never a numeral (`P/PlayGamesPattern.swift:587-596`); bell 660 + haptic [10, 40, 10] on throw.
5. **Unborn.** Non-six: "A {v}." / "Still unborn at 33. Only a six brings you in." — the engine's softer line "A breath at the threshold." / "Breathe once. Throw again when you're ready. A six brings you in." alternates; the token brightens +.15. **In the first game ever**, a six arrives by the third throw (rigged). A six: "A six. You are born onto the board." / "Bindu. A six also throws again." bell 523; the token comes down to square 1 (Bindu), landing ring .6 → 2.4.
6. **Moving** (E26). Each square: hop 550 ms, lift 8 px, cubic-bezier(.22,1,.36,1); step tone (196 Hz triangle .16 s — engine) layered with today's tick and 272.2·(1 + n/33) Hz. A six throws again. Overshoot: "Not yet. The board waits for an exact landing on 33." / "The die rests: you need exactly {33−pos} to arrive."
7. **Arrow or snake** (E27). 300 ms pause on the square. Arrow: "An arrow lifts you." — rise 330 → 660 and 495 → 990 Hz over 1.4 s, the token travels the arrow over 1600 ms; the arrow is "an act of giving or service". Snake: "A snake carries you back to a lesson." — settle 247 → 123 Hz over 2 s, travel 2300 ms; "this square's practice, made small — a lesson, not a fall".
8. **Landing opens the room** (E28, ruling 5). 900 ms after the token rests, the square's sheet rises (paper sheet: translateY 40 px, scale .96 → 1, 1.1 s cubic-bezier(.22,1,.36,1)): band colour; "Square n · system"; name; Sanskrit; question; the via-line ("An arrow from N, Name. …" / "A snake from N, Name. …"). One button: **Enter**. A crossing floods into that chakra's energy room (the 33's room engine: its moving point, practice, wake-up, gate, at the room's own register and fixed tone), entered at its gate and one of its Three Ways In (G6-0586). Leaving the room returns through the point to the board — token on the square, walk kept — and the sheet now offers **practice first**: "I did it" · "Let it be"; then the reading (the square's practice, verbatim), "One move" — "{Verb}, once, today." — the seed to carry (the square's signature phrase), and the door to the position's own room. Buttons "Throw again" · "Rest here" · "Back to the board".
9. **Square 32** (E30): "This square is held for its own walk." No room opens; the Reveal's words stay sealed (ruling 2).
10. **Arriving at 33** (E31). The whole path lights tile by tile in marigold #F2B632, one per 220 ms, bell 392; "You arrived at Lalita." / "The walk is complete. Begin again whenever you like."; the intention given back in his words — "Your walk: …" (the squares landed, by name) + "The game ends where it began. What you carried in was held the whole way." + Lalitā's practice; "What will you carry out?" / "Rest here". After 2.6 s, Recognition of kp 102 (built). The book gets "Walked: '<intent>'".
11. **The care line** (E32), always at the board's foot, ink-2, 13 pt: **"If today is heavy, the board can wait. Three breaths is a whole game."**

### 1.6 Leela drops (the play dropping in)

E34. Rare and unannounced, anywhere in the app (root presenter `.leelaDrops()`): **never within 3 days of the last drop, then by chance 0.3 on a practice day, once a day at most, never the same drop twice running** (`S/LeelaDrops.swift:24-79`). Ruling 16 lifts "never in the first days": the gap counts only from the last drop, not from first launch. After a 9 s settle the drop's lead appears on cream #fbf5e6 in coral ink #c4574a, Cinzel, 440 ms reveal per phrase; the real-world action 4.5 s later; "carry it" · "hold in silence" (both one `Leela Drop` row). Never about the game ahead; always about his life; always ending in an action. The pool: the eight GameStructure drops, widened by the short Leela Stories' energy closings (rooms 1–8, 10–19, 21–26, 28; G6-0587) and the first drop's ask: "Ask reality for help with one thing. Real life. Not in the game. Right now." (placeholder "hey. i am here. help me with…"; buttons offer the ask / hold in silence; nine beats ending "Now go. Lightly. Play.").

### 1.7 The Mirror, the Gates, the box, the child, the dances

- **The Mirror's eight stations** (E06) — Māyā's Phase 6, "The Bindu Speaks", a world of its own in the sacred family and a door from room 30. Black ground; the dot changes colour per station; restatements type at 22 cps; his stored answers then vs now; inverse acts with no skip ("No skip. No timeout bypass."): 1 Root "Touch where you placed it. Then release." · 2 Sacral "Let the word go." (8 s without touch; a touch resets, "still following") · 3 Solar "Don't engage." (6 s without tapping 8 tempting particles; "still building") · 4 Heart "Let the recognition fold back into you." (pinch letter-spacing to 0, or triple-tap) · 5 Throat "Now let the silence hold it." (10 s → "The silence already held it.") · 6 Third eye "Close your eyes." / "your third eye doesn't need these ones" (8 s, three haptic pulses, "What did you see?") · 7 Crown "Now offer it back." (swipe up 60 px or hold 3 s) · 8 Soul "Release what you held." (hold 3 s → "now let go" → release; three ripples). Closing: "Everything you placed in this space is already moving toward you." (repeat walkers: "You've seen it before. The words changed. What they called to you didn't.") · "What never changes is what was never given." · "You have always had the Knowledge." / "You have always been the Will." / "Now You Become the Action." · **"Go Play"** in red, 3 s fade → the field.
- **The Seven Gates** (E79) and **Release** (E78) — the descent Crown → Root, hold 2.6 s to lay each down; seven cards (a certainty / a self-picture / a story / a protection / an effort / a borrowed desire / the grip itself); seven gifts rise (steadiness, in your feet … space, above the head); bells 440 + 40k Hz.
- **The World in a Box** (E60) — his play becomes a world: the last 240 traces as objects, gifts from days away, tilt to turn.
- **The Child corner** (E88) — the door 2.8 s "This door is small." / "Welcome back. You remembered how."; Finger Garden, Colour Rivers, Rain, Echo; play with no goal on amber #C47820 → #F8D870.
- **The Dances shelf** (E94) — 27 + 2 standalone dances, each a door showing only its verb and seed; the song revealed after the fruit.

### 1.8 Leaving

- **Back** (spine): the point at the top returns home through the crossing; "< return" from the field returns exactly where he came from (back stack), never to a fixed screen.
- From a game: "< leave" (row written if engaged) → the family world → the field.
- From Leela: "Rest here" keeps the walk; "Back to the board"; the point → home. "Begin again with a new question" clears the walk.
- Coda: leaving the field from its foot, the hero line "The only winning move is to play." emerges (title 2 s at 0.8 s; subtitle 1.4 s; heroBreath letter-spacing .02 → .06 em over 9 s, G5-0644).
- Doors out along the threads: to the room of any chakra 1–33 (via a landing or a game's room door), to her seat kp 1–102 (a game's address), to the day (Today, Time's Great Wheel and Sandhya).

### 1.9 Visual language (tokens) and sound

| token family | values (light / dark) | where |
|---|---|---|
| play (cloth) | ground #0F4A50 + weave; surface #0B3E43; surface-2 #0B3B40; line rgba(243,236,221,.16); ink #F3ECDD (8.44); ink-2 #A7C6C1 (5.43); marigold #F2B632 (5.44); rise gold #F6D27A; lesson lilac #C2B2F4; deep #082F33; dot glow rgba(242,182,50,.45); paper #F4EBDA / ink #2B2621 / quiet #6E655B; ease-sheet cubic-bezier(.22,1,.36,1); dark cloth #0B3B40/#082F33 | field, family worlds, games' receiving paper |
| leela (board) | stone #E3E9EA · paper #F2F5F4 · line #C5CFD2 · ink #1D2631 · ink-2 #56616C · token #0F7C7A (text #007573) · arrows #B08A33 · snakes #6A4C9C · deep #1B2230 / slate #1B2230 · card #232B3A · line #39445A · ink #E6ECEE · ink-2 #A3AEB8 · token #3FB8B4 · arrows #D6B25C · snakes #A58ADB · surface-2 #141A26 · hover #2A3344 · deep #10151F | the board |
| sketch grounds | choose #3B2A55 · talk #1D2F5E · manage #1F4D2B · join #6E4A1E · turn #7A2E1E · trace #22205A · still #0E5566 · beat #5E1B2B · release #123A4A · seal #6A5A3E | the ten sketch worlds |
| games | `PlayGame.hue` and ring `ground` (`P/PlayGame.swift:301-355`) | each existing game |
| drops | cream #fbf5e6, coral #c4574a, Cinzel | Leela drops |
| entrance | ink (0.17,0.17,0.17), paper (0.91,0.89,0.87), point (0.75,0.22,0.17) | the dissolutions |
| type | Gloock (display/ceremony) + Newsreader (ui) for play; Lora + DM Sans for the board | bundled fonts |

Sound palette (Design's engine, absolute pitches, G3-0240 / G5-0240): bell(f) as above; letter ready 880 · born 523 · intro 523 · arrive 392 · throw 660 · card 740 · pause end 523; step 196 Hz triangle .16 s; rise 330 → 660 & 495 → 990 / 1.4 s; settle 247 → 123 / 2 s; breathIn 174 Hz 3.8 s; breathOut 261 → 196 / 4.6 s; rattle band-pass 1900 Hz; Turn bells 392 / 490 / 588; Release 440 + 40k. Game engine (built, `P/PlayInstruments.swift:163-328`): own AVAudioEngine, 6 voices + looping drone; tone 12 ms attack, decay e^(−3.2t/dur); thump 95 → 42 Hz / .45 s; heartbeat lub 68 Hz, dub 52 Hz at +.14 s; drone f + .45·1.5f + .25·2f over a 10 s loop; the point's pitch 136.1 Hz; session .ambient while open; honours the silent switch. "One sound claim at a time" is lifted (ruling 10): a game's own sound may sit over the Om bed.

---

## 2 · Every element, placed

Status: built / partial / not / wrong. Action: reuse · move · new · fix · reject.

| # | element | what it does (mechanism + numbers) | source (index ids · register) | status today (code) | action |
|---|---|---|---|---|---|
| E01 | The world's frame and laws | A Strange Game = reception infrastructure; Leela = play, Lalitā = play knowing itself, Bindu = play not yet knowing; "one yantra three ways" (appreciate · climb · play at the centre); "push the design limits … this gamified app"; one body three windows (personal board / astrangeigame.com / aistrangegame.com); "the game holds and remembers"; devotion reveals completeness already there (the app never "completes" him); E-chakras/Lalita Game named but unrecorded (§7) | G2-0355, G2-0357, G3-0277, G5-0564, G3-0465, G5-0570, G3-0279, G3-0280, G3-0278, G3-0459, G6-0588, G6-0623 · 04:586-588, 06:2033-2047, 07:700-733, 14:217, 14:250-251, 15:1414, 15:1562 | partial (header line only, `P/PlayFieldView.swift:167`) | new (frame line on the field, E07) |
| E02 | Crossings into the world | every way in arrives through the point (bloom from touch, cloth #0F4A50 + marigold); today PlayField is a global full-screen presenter reachable from anywhere (`RootView.swift:93`) and launched from the Mandala; route through one router with a back stack | G7-0005, G7-0157, G7-0180, G7-0026, G2-0910 · 19:572, 19:25-28, 19:82, 19:544-550, 05:3142-3146 | wrong (overlay, `Root/RootView.swift:93,95`) | move |
| E03 | The Eight Dissolutions (entrance) | 8 stations (table §1.2): lift · let go 8 s · be still 5 s · fold in (pinch < .8 or 3 taps) · silence 10 s (touch does not reset) · move > 160 pt · offer up (swipe > 80 pt or hold 3 s) · hold ≥ 3 s release; release 1.8 s; ground .1 + .6·i/8 over 3 s; Om .15 + .6(i+1)/8, recognition 7 s, closing 3 × 3 s, last words 5 s; writes nothing; no naming | G7-0094, G7-0209, G7-0226, G7-0993, G5-0530, G6-0793 · 19:312-319, 19:720-738, 19:777-781, 22:604 | built (`M/TheEightDissolutions.swift:1-318`; `S/TreeOfLife.swift:205-223`), lives on the Mandala | move into this world |
| E04 | Dissolutions once a practice day | `dissolved_day` == today → "Now go play." 3 s → field; 06:00 boundary; add ruling test | G7-0921, G7-0930 · 22:492, 22:512-521 | built, untested | new test |
| E05 | "Now go play." and the coda | last words 26 pt; leaving the field: "The only winning move is to play." (title 2 s at .8 s, subtitle 1.4 s, letter-spacing .02 → .06 em over 9 s) | G5-0644 · 14:718-721, 14:848 | partial (last words built) | new (coda) |
| E06 | The Mirror — Māyā's eight stations | black; "The Bindu Speaks"; 22 cps restatement; answers then vs now; inverse acts (§1.7) with exact timings 8 s / 6 s + 8 particles / pinch-or-triple-tap / 10 s / 8 s + 3 haptic pulses / swipe 60 px or hold 3 s / hold 3 s + 3 ripples; closing lines; "Go Play" red, 3 s fade; writes nothing | G2-0547, G2-0548 · 05:360-373 | built as web (corpus), not in app | new (sacred family + door from room 30) |
| E07 | The field (home) | cloth + weave; rings 2–8 gold α .07–.10; garland 102 beads / 180 s; her point 120/40 pt, 9 s breath; Leela pinned at centre; family glyphs at r .62, ≥ 50 pt apart; header; frame line written by the point, 9 s fade; Sakshi seed first visit of the day 7 s; foot "the modes" · "the road" · "your book"; open ground draws marigold 3 pt lines fading 9 s, hold 1.8 s to keep; pinch out = address overview (today's layout); tap 272.2 Hz; entering bell 523 | G7-0277, G7-0278, G7-0279, G7-0280, G7-0281, G7-0282, G7-0283, G7-0448, G2-0883, G3-0239, G6-0573, G2-0927 · 20:115-130, 20:611, 06:1824-1832, 15:1381, 05:3328-3335 | partial (disc of 36, `P/PlayFieldView.swift:73-313`) | fix + new |
| E08 | Family worlds | elements (Drum, Root, Water, Fire, Rain, Shake, + Still) · heart (Pulse, Coherence, Echo, + Beat) · passage (Corridor, Door, Spine, Scrolls, Tat Tvam Asi, + Release, Seven Gates) · pattern (Yantra, Mandala, Twelve, Turn, Join, + Trace) · words (Translator, Maze, Letter, Flash, + Who is thinking?) · growth (Seed, Rivers, Body Map, World in a Box, Finger Garden) · sacred (Still·Ājñā, Rām Japa, Bhakti, Garland, Bīja Tones, + The 108, Sakshi Pause, Tratak, the Mirror) · time (Sandhya, Great Wheel, + The Draw); each entered as a space | G7-0463, G7-0464, G7-0465, G7-0466, G7-0467, G7-0468, G7-0469, G7-0470, G2-0370, G4-0862, G5-0245 · 20:692-702, 04:607, 11:606, 12:587, 13:521-522 | not | new |
| E09 | Colour-flood crossing | overlay 0 → .92 / .70 s ease-in; glyph ×11; navigate 700 ms; whole ground recolours 1.2 s; a threshold of one colour (rings turning 80 s / 50 s opposite; breath 4/2/6/2 × 3) where a game or room asks for it | G5-0469, G5-0205 · 13:533-534, 13:879, 12:540, 13:403 | not | new |
| E10 | Glyph motion and grounds | 13 signatures: Maya rotate 26 s · Garden 4.5 s scale 1 → 1.07 · Watcher still · Descent 2.8 s ember · Return 7 s orbit ±12° · Forgetting 20 s stutter ≤ 2 px · Remembering 9 s dawn · Body 8 s breath · Thread 3.5 s shuttle ±6 px · Circle 42 s · Signal 7 s pulse · Forge 5.5 s assembling · Field rotateY 10 s; assigned: elements Forge · heart Body · passage Descent · pattern Circle · words Signal · growth Garden · sacred Watcher · time Return · Leela Thread · Sketchbook Field · Child Remembering · Dances Maya · Life Games Forgetting · Boards Return; grounds by meaning (§1.4) | G5-0467, G5-0470 · 13:530-535, 13:910, 13:930 | not | new |
| E11 | Token families | play, leela, sketch, drops, entrance (table §1.9); fonts bundled | G5-0488, G5-0489, G5-0521, G7-0434 · 13:603-616, 13:775, 13:827-829, 20:588 | not (games use indigo sky hues) | new |
| E12 | Lalitā enters (inversion to cream) | #020208 → #F8F3EE / 3 s, others α .12, one line hsl(h 55% 36%), exit spiral 4 turns; at most once a play day, chance 1/9 field visits | G5-0151 · 12:450, 13:427, 13:631-632, 13:955 | not | new |
| E13 | Sound palette | engine bells and gestures (§1.9); built PlaySound engine kept; point 136.1 Hz; lift one-claim rule | G3-0240, G5-0240, G3-0294, G7-0293, G7-0294, G7-0230 · 06:1833-1842, 06:2187-2190, 12:579, 13:494, 20:50, 20:164-171, 20:718 | partial (`P/PlayInstruments.swift:163-328`) | reuse + new bells |
| E14 | Haptics | built: tap soft · thump heavy · tick selection · heartbeat thump + tap .7 at .15 s · bloom success; library: crossing_peak [12,40,12,40,12,60,30,12,40] · bell [20,30,40,30,20] · mirror [8] · strike [8,20,8,400] · fulcrum [30] at 50 bpm · charge [25] at 46 bpm · thunder [30,40,50,40,30]; engine 8 on press, 12 at full, [10,40,10] on throw | G7-0292, G4-0477 · 20:158-163, 09:694, 06:1833-1842 | partial (`P/PlayInstruments.swift:128-151`) | reuse + new patterns |
| E15 | One hold engine (G0) | p += dt/UP_MS, drains at DOWN_MS 620–750 ms; commit on threshold, act on release; durations: die 2200 · deck 1900 · Sakshi inhale 4000 · Seven Gates lay down 2600 · Child door 2800 · rewind 1400 · story beat 1500 · seal ceremony 1000; haptic ramp .15 → .6 sharpness .3, one latch; no buzz on early release; role=button named for the act + progressbar; held-key parity | G4-0724, G3-0267, G5-0234, G4-0753, G7-0484 · 11:235-270, 11:303, 06:2008, 12:575, 20:725 | not (each game its own timer) | new shared `HoldEngine` |
| E16 | Game host and session | PlayModel protocol (advance, draw, began, moved, ended, caption, give, meet) + FrameClock dt ≤ 1/20 s; PlayAddress seat/ring/threshold/garland; handoff recognition/stillness; phases playing → gathering → still, engaged = acts ≥ 3 and ≥ 6 s; hint 7 s, fade 1.6 s, now recallable (hold 1.1 s on the point); "< leave"; word field 30 pt; hand-off 1.6 s; PlayStillness 9 s; PlayRipple life 1.6 s reach 140, r = 6 + reach·(1−(1−p)^2.2), α .55(1−p); TouchSense absorb tanh(1.6x)/tanh(1.6), pad (majorRadius−7)/28; CoreMotion 60 Hz; PlayInk settled ≥ .55; title shown (lift "never a heading"); fix header comment "sixteen"; catalogue moves to Models | G7-0228, G7-0233, G7-0234, G7-0237, G7-0238, G7-0284, G7-0286, G7-0287, G7-0289, G7-0229, G7-0290, G7-0291, G7-0295, G7-0297, G7-0311, G6-0918, G7-0727 · 20:42-171, 20:199, 20:305, 17:783, 22:393-398 | built (`P/PlayGameHost.swift`, `P/PlayModels.swift`, `P/PlayGame.swift`, `P/PlayInstruments.swift`) | reuse + fix |
| E17 | Ledger and one store | one `Played` row per engaged game (`ActivityLedger.played(game:place:linkRecordId:seconds:at:)`, link her Śakti row else the Avaraṇa; place "The Shadow crossing" / "The Armin crossing" / "The garland" / "Nth Avarana"); every verb as App Activity; merge PlayTraceStore + PlayGardenStore into one PlayStore (traces, seeds, worldVisitedAt) — one act, one file; fix `Shakti.playPosition` fallback +28 to read the Mandala row | G7-0285, G2-0371, G6-0834, G6-0867, G6-0906, G7-0231, G7-0236, G7-0726 · 20:137-139, 20:52-54, 20:65, 17:582, 17:586, 17:765, 22:386-392 | built (two stores = wrong) | fix (merge) |
| E18 | Floors of play | no end screen; "Failure is present-tense physics … Force is absorbed, never punished … Storage may count; the screen may not."; no streaks, badges, dots, progress bars, congratulations; "The build stops at Nothing fell."; words released at game end except the Letter; answers only from her rows or his words; ASG laws "never score, grade, rate, rank, judge or predict; no urgency; offer never command; no claims of certainty; no exclamation marks, no emoji; crisis care line"; playing-side laws 1–9 ("No number may ever measure the player. A count may be the form of a practice (a mala), never a grade." · "empty days stay silent" · "the return asks once, then lets go"); D28 never fake completeness; no timers (C-1058); no state-chasing (C-1033); no good/bad verdicts (C-1085); flow — challenge just above level, judge off (C-1006) as tuning guidance only; ceremonies stay (site law 1 is site-only); restrictions written as law (two gestures, one sound, "a way, not a list") lifted | G2-0363, G7-0288, G7-0296, G7-0990, G2-0923, G4-0399, G7-0232, G3-0246, G3-0307, G5-0238, G3-0311, G3-0349, G3-0344, G3-0332, G4-0873, G5-0534, G7-0489 · 04:595, 20:149, 20:176, 05:3235, 09:688, 06:1873, 06:2326-2362, 07:65-68, 07:125-153, 11:659, 14:66, 20:713-721 | built in part (`P/PlayGameHost.swift:12-13`, `P/PlayPhysics.swift:9-18`) | reuse + tests |
| E19 | No simulated presence, no counts about him | "84 hearts breathing" (random 76–96; Sanctuary/Field 84 ± waves) never ports; "1 of 7 awakened" never ports; completed-count keys never port | G2-0932, G2-0909 · 05:3372, 05:3134-3141 | n/a | floor |
| E20 | Doors from rooms and seats | each game's address = its door from the 33 and from her seat (§5); every one of 102 has a game door, else her bead in the Garland; Chakra Game pieces → rooms (Correspondence → Incarnation; Seed → gate offerings; Translator → 32; Corridor → 9; Coherence → 14; Drum → root pair; Shake → 19; Spine → 18; Water → 3; Fire → 4/11; Root → 2/10; Yantra → 1/Ātmā; Maze → throat pair; Body Map → body arrivals; Child Space → 28); homeless placed: Turn → room 31, Bīja Tones → every energy room's wake-up, Great Wheel → Time, Garland → Mandala | G3-0266, G5-0218, G7-0235, G7-0989, G7-0361, G7-0183, G7-0472, G7-0473, G7-0474, G7-0475 · 06:1978-2001, 12:552, 20:64, 20:439, 20:575, 20:704, 22:599 | partial (`P/PlayGame.swift:360-390`) | fix (homeless) |
| E21 | Leela — world and catalogue place | its own world at the field's centre; address seat 102; doors from rooms 1 and 33; handoff Recognition of kp 102; Gyan Chaupar lineage ("the current square lit") | G7-0471, G7-0269, G7-0308, G6-0766 · 20:680-691, 20:560, 16:326 | built as one light (`P/PlayGamesPattern.swift:452-636`) | move + new |
| E22 | Leela intention | lines verbatim §1.5 step 2; one per 1.5 s; "My life" / "What I'm building"; engine intro variant "What are you carrying into this game?" (placeholder "a question, a wish, a wall, a wondering") · "Carry it in" · "For life, or for something you're building. The board reads either."; word field from the host | G3-0301, G7-0429, G5-0246, G3-0242 · 06:2275-2283, 06:1847-1861, 20:573, 12:588 | not | new |
| E23 | Leela board | boustrophedon 3 × 11, COLX 60/180/300, ROWH 58, BASEY 650; Map colours; 32 empty ring; arrows gold, snakes violet dotted; token teal; current square lit; SQ data read from The Map (`tblwpmyKOeMxEEHd7`) / ChakraConstellation, not a baked copy | G3-0238, G7-0301, G7-0304, G5-0239, G3-0243, G3-0003 · 06:1805-1822, 06:1860, 06:38, 20:212, 20:262-268, 12:579-582 | partial (spiral 1.5 turns, `PlayPhysicsWhole.swift:503-507`) | fix (boustrophedon) |
| E24 | Leela die | hold 2200 ms with breath ring + words; rattle 1900 Hz; tap = quick throw; shake > 1.4 g; roll 480 ms; pips only; bell 660 + [10,40,10]; early release drains, "No hurry." | G7-0433 · 20:587 | partial (hold → throw 0.6–1.4 s, shake, pips built) | fix + new words |
| E25 | Leela birth | unborn at 33; six enters at square 1; **six throws again**; first-ever game six within three throws; non-six lines; token +.15; walk begins and ends on 33 | G3-0158, G7-0302, G7-0303 · 06:744, 20:213, 20:225, 20:561-563 | partial (no six-again, no rig) | fix |
| E26 | Leela movement and sound | hop 550 ms, lift 8 px, (.22,1,.36,1); step 196 Hz tri + 272.2(1+n/33); landing ring .6 → 2.4; overshoot lines; 300 ms pause | (G5-0239, G3-0242 primary in E23/E22) · 12:579-582, 06:1847-1861 | partial (glide rate 3.5/s ≈ 286 ms) | fix |
| E27 | Arrows and snakes | arrows 5→8 "The heart's gesture returns at the crown." · 12→18 "The breath's open door becomes the blink." · 13→20 "Love leaving through the hands arrives whole." · 26→29 "What assembles, integrates."; snakes 30→9 "A construction seen through returns you to the corridor: notice." · 19→10 "When the thinking stops, you are back in your feet." · 15→6 "The precise word asks again: will I say what I know?" · 28→21 "Before anyone taught you, you carried something in. Name it."; rise 330→660 1.4 s / travel 1600 ms; settle 247→123 2 s / travel 2300 ms | G3-0302, G3-0303, G7-0427, G7-0488, G7-0991, G3-0306 · 06:2284-2303, 06:2314-2322, 20:572, 20:729, 22:601 | built (`PlayPhysicsWhole.swift:456-477`, as draft) | reuse (draft stands; §7) |
| E28 | Landing opens the chakra's energy room | sheet rises 1.1 s; Enter → colour flood into the 33's room (its point, practice, wake-up, gate; Three Ways In); return to the board, walk kept; then "I did it · Let it be", reading, one move, seed, door; the Consciousness Loop shape (preRoll breath 5.5 s → seed → offering → dance → reveal → fruit → lalitā) available where the room's dance step runs; contract A14 {title, positions[{n, name, color, question, line, practice, href?, held?}], rises, returns, enter, exact, care} | G7-0426, G7-0447, G6-0586, G4-0308, G7-0305, G4-0688, G6-0794, G6-0798 · 20:569-571, 20:605, 15:1412, 09:64-73, 11:123-126, 17:225, 17:308 | wrong (landing = name 22 pt + essence 15 pt only, `P/PlayGamesPattern.swift:597-606`) | new |
| E29 | Square sheet | band colour · "Square n · system" · name · Sanskrit · question · via-line · reading = practice verbatim · "One move" "{Verb}, once, today." · seed = signature · door to the room in-app; buttons "Throw again" · "Rest here" · "Back to the board"; no Claude tier | G3-0304, G7-0428, G3-0305 · 06:2304-2313, 20:572 | not | new |
| E30 | Square 32 held | "This square is held for its own walk."; no room; drawn as an empty ring | G7-0430 · 20:575 | partial (ring drawn, no words) | fix |
| E31 | Arrival at 33 | path tiles lit one per 220 ms marigold, bell 392; arrival lines; intention given back; "What will you carry out?" / "Rest here"; Recognition kp 102 after 2.6 s; book "Walked: '<intent>'" | G7-0431, G7-0306 · 20:576, 20:269, 20:566, 06:1847-1861 | partial (glide + Recognition built) | new words |
| E32 | The care line | "If today is heavy, the board can wait. Three breaths is a whole game." verbatim, board foot, always | G7-0432 · 20:577, 11:123-126 | not | new |
| E33 | Walk persisted, a row per landing | `LeelaWalk` value persisted {intent, mode, square, born, path[], arrivedAt}; per landing one `Played` row (detail "Leela · Square n · Name", Link to The Map); "I did it"/"Let it be" one `Chakra Practiced` row; "Begin again with a new question" clears | G7-0307 · 20:271-273, 20:584-586 | not (walk lost on leave; one row per game) | new |
| E34 | Leela drops | ≥ 3 days then 0.3, once a day, never repeat; lift the first-days rule; 9 s settle; lead → action 4.5 s → "carry it" / "hold in silence"; cream/coral/Cinzel 440 ms; pool = 8 GameStructure drops + short Leela Stories' closings + the first ask; never spoils, about life, ends in action; signs (déjà vu, synchronicity), "help me understand", gratitude + ask + surrender as drop seeds from his Codex verbatim | G6-0831, G6-0894, G7-0158, G7-0910, G3-0300, G5-0571, G3-0503, G6-0587, G3-0395, G3-0416, G3-0443, G3-0452, G3-0462, G3-0402, G6-0830, G7-0728, G7-1023, G3-0535 · 17:564, 17:753, 06:2261-2271, 14:252-253, 15:1413, 07:380-748, 07:920-923, 22:399-407, 22:491 | built (`S/LeelaDrops.swift:19-204`, `S/GameStructure.swift:16-96`) | fix (first-days) + widen pool |
| E35 | The die as a door | "Or don't decide. Touch the point. The field chooses." scoped chips everything / the 33 / the 102 / games, never repeating the last; the Mandala's map--sky door with a die (visible roll across 102 + 33) | G4-0860, G5-0287 · 11:595, 12:773, 13:95, 14:128 | not | new (spine door into this world) |
| E36 | (reserved: Leela catalogue light merged into E21) | — | — | — | — |
| E37 | The Corridor (passage) | threshold 3→4, stillness; 12 rings travel outward per step (pow(.74,k)); a step every 0.8–1.2 s, 24 to cross; hurried step adds .34 to press, relaxing .45/s; walls cool and close in; door of light 10 + 120·shown^1.6 from step 18; "You walked through." / "The door was always there." | G7-0240, G2-0867, G5-0188 · 20:179, 20:249-251, 05:2914-2916, 12:521 | built (`P/PlayGamesPassage.swift`, `P/PlayPhysics.swift`) | move into passage world |
| E38 | Pulse (heart) | seat 70; after 8 steady taps the light beats 3 more at his period → Recognition; gap > 2.4 s resets; caught at ≥ 8 taps steadiness ≥ .55; period .4–1.5 s; heartbeat 68/52 Hz; add the unused lines "The most reliable relationship you have ever been in." / "It was here before your first thought. It will be here after your last." revealed by the beat | G7-0241, G2-0885, G7-0416 · 20:180, 20:242-247, 05:2983-2986 | built (`P/PlayGamesHeart.swift`, `PlayPhysics.swift:93-133`) | move + words |
| E39 | Spine Walk (passage) | seat 84; 10 stations at .05 + .1i on a just scale from 272.2 Hz; rest .9 s; max .55/s; Map body order | G7-0242, G2-0881, G5-0202 · 20:181, 05:2968-2969 | built | move |
| E40 | Echo (heart) | seat 80; tap a call, wait 1.6 s, she answers; ratios 1, 9/8, 5/4, 4/3, 3/2 on 272.2; rhythm match within 28%; the fifth → Recognition | G7-0243 · 20:182 | built | move |
| E41 | Finger Garden (growth + child) | seat 69; ≤ 24 stems; tones 220 × [1, 9/8, 5/4, 3/2, 5/3]; drone 110 Hz; bloom at 12 stems; rate 1/(1+s/180); drone gain min(.18, .014n); G47 multi-touch | G7-0244, G4-0771 · 20:183, 11:321 | built | move (also in Child corner) |
| E42 | Rain (elements + child) | seat 71; ≤ 500 drops; wind from swipes and roll; chimes 426/480/568/640; breath tone 213 Hz; 4 breaths, a breath = swipe 2.2–9 s with travel > .35 | G7-0245 · 20:184 | built | move |
| E43 | The Drum (elements) | seat 53; strata; root to the water table; branches every 4 depths; on-beat thump + haptic, off-beat shiver; period 1.0 ± .18 s; depth 20; "You reached the water table." / "Steady. Deep. Yours." | G7-0246, G2-0870, G5-0191 · 20:185, 05:2924-2926 | built | move |
| E44 | Root System (elements) | seat 4; each still finger grows a root; drone 68 Hz; haptic every 1.3 s; depth += dt·s²·reach/22 | G7-0247, G2-0876, G5-0197 · 20:186 | built | move |
| E45 | Water Level (elements) | seat 15, stillness; tilt + nudges; a knock every 6 s (code 5–8 s); ±.45 rad; stiffness 9, damping 1.6; drone 210 Hz; surface brightens to a mirror; settle **30 s** still in wall-clock (Design) | G7-0248, G2-0874, G5-0195 · 20:187, 05:2939-2942, 12:528 | built (settles 12 s) | fix to 30 s / 6 s |
| E46 | The Fire (elements) | seat 65; ≤ 420 sparks; smoke when roaring; two horizon lines; stick 320 Hz partials 2.76, 5.4; band .15–.82; burn .11/s; feed .12 + .14p; 60 s tended; "60 seconds tended." / "Not too much. Not too little." | G7-0249, G2-0875, G5-0196 · 20:188, 05:2944-2946, 12:529 | built | move + words |
| E47 | Shake to Clear (elements) | seat 82, stillness; 22 drifting words verbatim (should have … deadline); threshold .9 g; G19 drift ×(1+4·shake), fade (1−shake); tap adds .5; "Only the field remains." | G7-0250, G2-0882, G4-0743, G5-0203 · 20:189, 05:2971-2974, 11:293 | built | move |
| E48 | The Door (passage) | seat 94; hold 2.8 s gentle ≤ .62; 7 rings scale 1 + 1.6·open²; arch path; quarter tone 480(1+.06q); hard press absorbed (C-1357); a second form: the Two Doors — hold to enter, doors scale ×40 (ring, never a progress bar) | G7-0251, G5-0676 · 20:190, 14:894 | built (Two Doors not) | move + new form |
| E49 | Śrī Yantra trace (pattern) | seat 102; 27 edges in drawing order, tolerance 18 pt; triangle order [4,8,3,7,2,6,1,5,0]; each edge plays its ring's tone; corpus line-by-line 18 lines within 22 px either direction, progress kept | G7-0252, G2-0877, G5-0198, G4-0742 · 20:191, 05:2952-2954, 11:292, 12:531 | built | move |
| E50 | The Garland (sacred) | address garland (all 102); pull down = next bead (slip .35 s); rest 1.6 s = feel her; caption her name; held bead → Recognition, whole round → stillness; fix comment; door from the Mandala | G7-0253, G7-0239 · 20:192, 20:110 | built, homeless | move + door |
| E51 | Bīja Tones (sacred) | 9 bands = the nine Tree-of-Life panels' awakening tones 174 · 210 · 320 · 341 · 384 · 426 · 480 · 528 · silence (ninth asks to touch nothing 9 s); pulse period 60/(f/5); tuned when last 6 intervals within 6%; absorbs Mantra Tuner (tap a tempo, bpm = f/8, within 5% after 6 taps) on the same tones, not solfeggio; door from every energy room's wake-up | G7-0254, G2-0869, G5-0190, G7-0403, G7-0481, G2-0864, G6-0605, G7-0971 · 20:193, 20:722, 05:2900, 05:2921-2922, 15:1405, 22:579 | built (keyed to rings), homeless | fix labels + doors |
| E52 | Coherence (heart) | seat 70; left half breath, right half heart; waves meet; drone 136.1 Hz; breath 5–14 s; meeting ≥ .7 for three breaths (internal, never shown) | G7-0255, G2-0868, G5-0189 · 20:194, 05:2918-2919 | built | move |
| E53 | The Seed (growth) | seat 26; press 2.4 s still; seed < 2 h, sprout < 8 h, sapling < 24 h, tree < 72 h, bloom; growth 1 − (1 − h/72)^2.2; at bloom plants the next seed → Recognition; a seed planted at a Leela landing grows between visits; the Kombucha figure (jar fills 0 → .85·272, 8-day strip, "Cover it, and leave it be. The work is happening where you can't see it.") as its growing figure; A6 contract {title, verb, line, gesture, close, keep, realTime{unit, stages[]}}; "a count that survives closing is drawn, not printed" | G7-0256, G2-0866, G5-0187, G4-0863, G4-0789, G4-0680, G7-0276, G7-0992 · 20:201, 05:2908-2912, 11:99-102, 11:398, 11:607, 22:394, 22:602 | built (`PlayPhysicsWhole.swift:54-76`) | move + landing seed |
| E54 | Mandala Completion (pattern) | ring 7; dashed ghost petal; missed stroke fades .8 s; rounds 8, 12, 16 petals; missing = (round·5+3) % n; "The imperfect line is the most sacred." | G7-0257, G2-0879, G5-0200 · 20:202, 05:2960-2962 | built | move + line |
| E55 | The Twelve (pattern) | ring 7; drag to swap; closing chord on tones 0, 4, 8; circle of fifths from 272.2 folded below 544.4; "The order is restored." / "You found it through feeling." | G7-0258, G2-0878, G5-0199 · 20:203, 05:2956-2958 | built | move |
| E56 | Body Map (growth) | seat 77; 10 centres Soles … Crow; rest 1.2 s; pressure < .12 open, < .55 alive, else held; inks Alive · Tight · Absent; eight qualities (tightness, warmth, ache, tingling, numbness, heaviness, lightness, hollowness) chosen by a second touch; inks over past sessions as light | G7-0259, G2-0880, G5-0201 · 20:204, 05:2964-2966, 12:534, 13:283-284 | built (qualities not) | move + qualities |
| E57 | Shadow Translator (words) | seat 101; burden word → gift = 1 + letterSum % 10 → one of the 10 Siddhi Śaktis (kp 1–10); the coin turned by circling; back shows her name and Appreciation Phrase; no generated voice | G7-0260, G2-0873, G5-0194 · 20:294-296 | built | move |
| E58 | Mirror Maze (words) | seat 30; 7 energy chakras as lenses, tones by AwakeningTones; essences under each lens; opening .26, fall .16, lens y .16 + .11k; tilt to guide; the corpus's 7 claude forms replaced by the authored consonant-skeleton lexicon (27 families, e.g. lv → love / live / leaf / lift / lake) shown 1.8 s uppercase on a .85 dark; fix async completion after leave | G7-0261, G2-0871, G5-0192, G7-0310, G2-0538 · 20:206, 20:297, 20:301, 05:316, 05:2928-2929 | built (bug) | fix + lexicon |
| E59 | The Letter + Seal (words) | seat 88, stillness; write · draw the page down to fold (rate .7) · press the wax 2.2 s; sealed into CorrespondenceStore to a tithi; Seal sketch adds "tomorrow / in a week / in a season" (#6A5A3E); corpus bury / burn / seal 30 days as three ways to close; opened letter revealed phrase by phrase (E87) | G7-0262, G2-0872, G5-0193, G7-0414, G3-0257 · 20:207, 20:298, 05:2931-2933, 06:1906 | built (seal to tithi) | move + choices |
| E60 | The World in a Box (growth) | ring 9; last 240 traces become objects (game → thing map `PlayPhysicsWhole.swift:422-435`); tilt/drag turns the box; gifts = one per whole day away, ≤ 3, become stones; golden-angle placement; corpus deriveWorld adds plants, paint, cloud, drum, fireflies (one per 36 beads), tree, boats, arches, pond, flag, stones; 8 daily gift kinds; seasons; weather; naming (his word); no generated story; keeps objects never totals | G7-0263, G2-0906, G2-0900 · 20:211, 05:3090-3094, 22:393-398 | built (no weather/seasons/naming) | move + enrich |
| E61 | Colour Rivers (growth + child) | seat 20; 4 colours; 10 × 18 grid detects meetings; reaches the sea after 14 s overlap | G7-0264 · 20:210 | built | move |
| E62 | The Scrolls (passage) | threshold 3→4; 12 lines verbatim ending "You are a bigger container now."; 110 pt pull per line; max 260 pt/s (copy to Feed) | G7-0265, G7-1022 · 20:209, 20:275, 22:603 | built | move |
| E63 | Still · Ājñā (sacred) | seat 51; "What do I see\nwhen I stop looking?" · "The screen will wait.\nClose your eyes."; 30 s dark; "The seeing was always there." | G7-0266 · 20:208, 20:275-278, 05:3001 | built | move + line |
| E64 | Flash · Intuition (words) | seat 91; "One breath." / "Something already knows." / "Don't word it yet." / "Give it one word."; in-breath ≥ 2 s then flashes .95 s, reach 70; "The knowing was already there." | G7-0267 · 20:207, 20:299 | built | move |
| E65 | Tat Tvam Asi (passage) | threshold 6→7; Tat / Tvam / Asi, one breath 2.6 s each; aurora 7 bands hue .55–.95; "Nothing needed repair."; corpus close "I am whole." | G7-0268 · 20:208, 20:279-282 | built | move |
| E66 | Turn (pattern) | ring 8, stillness; 3 rings r 300/215/130 (34 wide on 720), picked by distance > 237 / > 152 / > 60; tick every 15° (code π/6 notch); snap within .12 rad, bells 392 / 490 / 588; aligned < .08 → centre lights "The point appears."; friction 1.8, coupling .3; TurningWord max 1.6 rad/s and its stale doc ("Mental State … Siddhi"; real mapping is a letter-sum into kp 1–10) corrected; door from room 31 | G7-0270, G3-0252, G4-0748, G5-0450, G7-0300 · 20:224, 20:205, 20:214, 06:1898, 11:298, 13:491 | built, homeless | move + door + bells |
| E67 | Join (pattern) | seat 92; two names road[i], road[i+16]; meeting touch 34, gentle ≤ 260; merge 500 ms, third .6 → 1, shows Invention's Map essence | G7-0271, G3-0251, G5-0453 · 20:215, 20:261, 06:1897, 13:493 | built | move |
| E68 | Rām Japa (sacred) | seat 42 (his name; his ruling), stillness never Recognition; राम in Devanagari; elliptical mala 108 with gold meru; one bead per whole breath 1.8–14 s | G7-0272, G7-0911, G7-0912, G7-0913, G7-0914, G7-0678 · 20:216, 20:280-283, 22:185-191, 22:494 | built | move |
| E69 | Bhakti / Ārati (sacred) | seat 24; circle the lamp sunwise 0.3–2.4 rad/s, 7 circles; scale 1, 1.125, 1.25, 4/3, 1.5, 5/3, 2 | G7-0273 · 20:217, 20:281 | built | move |
| E70 | Sandhya (time) | ring 2; junction from today's sun times (Prātaḥ, Madhyāhna, Sāyam); dawn drawn up, noon still or face-up, dusk drawn down; gradient triplets; "What you carried today\nyou may set down here."; JunctionLight .12; LotusSun openness | G7-0274, G7-0299 · 20:218-222, 22:305 | built | move |
| E71 | The Great Wheel (time) | ring 1; six ṛtu sectors; days he played as lights on the rim (light, never a number); today drawn to the top; seasonal yantra with ṛtu name and poetry (SeasonLight); spin friction .9, catch within .35; remove dead code; doors from Time | G7-0275, G7-0309, G7-0298 · 20:220-221, 20:289-290 | built, homeless | move + door + fix |
| E72 | The Draw (time; Today door) | "Chance places a card in your hand. What you do with it is yours."; hold deck 1900 ms (tremble rotate(sin(18p)·2.5p deg), ±1.5 px ≈ 20 Hz, rattle); lift −24 px .5 s, pause .3 s, rotateY 180° .9 s, perspective 800 (engine lift −26 / flip 1300); bell 740; one card per day stays all day: "Today's card." / "Carry a line from your day into it?" / "Ask the card" / "Keep the card" / "Let it go and draw again"; 24 titles (A six to be born … Surrender); weekday planet line (Sun "the Self…" · Moon "family and home" · Mars "courage and the body's work" · Mercury "messages" · Jupiter "teaching and generosity" · Venus "beauty and affection" · Saturn "endings, tidying, boundaries"); card bodies from the 45 verbatim seeds / Map signatures until he gives the 24 bodies | G3-0244, G7-0404, G5-0241, G4-0475 · 06:1862-1867, 12:583, 13:491, 09:686, 10:396-404 | not | new |
| E73 | The Sakshi Pause (sacred; Today door) | hold orb 4000 ms = inhale (r 46 → 110, breathIn 174 Hz 3.8 s, "In."); release = exhale 5200 ms (breathOut 261 → 196, "Out."); three beads; "Again, when you're ready." / "One breath is a whole practice. Stop here."; close "No agenda" / "The float that needs no clock."; keep "{n} breaths, no agenda." (his own keep, drawn as beads); his "slow time down in the moment and not react" and "take stock … put a pause" as its reason | G3-0245, G7-0405, G3-0360, G3-0361 · 06:1868-1871, 07:205-213 | not | new |
| E74 | The 108 (sacred) | 108 beads on 4 rings 40 / 32 / 24 / 12; tap each; lines join from bead 54; "Tap each bead. No timer. No score."; lit beads are the record, no number | G2-0865, G5-0186, G7-0402 · 05:2902-2906, 12:519, 13:504 | not | new |
| E75 | Beat (heart) | #5E1B2B; 60 bpm heartbeat at 98 Hz; taps within 130 ms glow gold; after 8 near taps a second drum 147 Hz: "The music answers." / "A second drum has joined you." / "Nobody is counting." | G3-0255, G7-0412, G5-0452 · 06:1901, 13:492 | not | new |
| E76 | Trace (pattern) | #22205A; dashed inward spiral r = 320 − 16.5t, t ∈ [0, 6π] on 720; line 7 wide fading 9 s (.95 → .40); tick every 260 ms; within 26 of centre after > 40 points → bell 523 "The point." + "Everything begins as a point. Everything ends as a point. The same point."; "wherever your finger goes is right" | G3-0253, G7-0410, G5-0451 · 06:1899, 11:292, 13:492 | not | new |
| E77 | Still (elements) | #0E5566; tilt (or drag) a drop into the centre; ring fills over 7 s → "Held." / "Stillness was the whole game." | G3-0254, G7-0411 · 06:1900 | not | new |
| E78 | Release (passage) | #123A4A; seven cards (a certainty / a self-picture / a story / a protection / an effort / a borrowed desire / the grip itself); drag down = set down; drag up = keep ("That's allowed."); gifts rise: steadiness, in your feet · warmth, in your belly · a breath that needs nothing · an open hand · a true word, in your throat · clear sight, behind the eyes · space, above the head; bells 440 + 40k | G3-0256, G7-0413 · 06:1902-1905 | not | new |
| E79 | The Seven Gates (passage) | descent Crown → Root, a veil per gate; each gate offers one Release card; hold 2.6 s to lay it down (words rise, not fall — his C-1230 offering); the gift rises at the gate; end: Return / Ascend; no gatekeeper voice; one `State Set Down` row per gate laid | G7-0417 · 05:3069, 05:3082-3084, 20:529-554 | not (ring version on the Mandala: `M/GatesOfReleaseLayer.swift`) | new |
| E80 | Talk — ring of ten vantages | #1D2F5E; ring: Gaia "The asking always precedes the answer." · Sid "The goal is already accomplished. The work is holding it." · Arch "Teach before you sell. The invitation never closes." · Sakshi "What is seen completely, completes itself." · Karishma "It was ready before you were." · Ashrey "The architect who discovers he is the architecture." · Neev "What consciousness stands on." · Shweta "What consciousness flows through." · Bindu "Always moving. With love." · Lalita "Knows the game. Plays anyway."; wheel Ask · Tell · Wonder · Stay quiet — choosing a vantage shows its one line, nothing generated; door to the Relationship Field; 360° perspective (C-1152), "a game in which we have to play with each other" (C-1285) | G3-0249, G7-0408, G5-0242, G3-0388, G3-0472 · 06:1884-1895, 07:345-348, 07:765-768 | not | new |
| E81 | Manage | #1F4D2B; sign five of 12 practices; the week is his real App Activity (not simulated); a rest day: "the bench is part of the game"; "You are the manager. You are never rated."; door to the Modes' Manager mode | G3-0250, G7-0409, G5-0243 · 06:1896, 13:522 | not | new (simulation rejected) |
| E82 | Who is thinking? (words) | his five questions verbatim, one per screen on the moving point: "Who is thinking the thought?" · "Is it me or is it my anxiety thinking?" · "Is there any truth to the thought?" · "Can i find examples from the past that contradict the negative thought?" · "Can i find an positive thought that replaces the negative thought?"; one word given back, released | G3-0327 · 07:40-43, 07:1303-1305 | not | new |
| E83 | Tratak (sacred) | his origin: a red dot at the yantra's centre, a white light moving behind it "no particular pattern" (random walk, 0.3 pt/frame, never repeating); gaze; Identity practice line "I sit before the Yantra. The dot becomes the doorway. The light moves on its own."; no instruction after the first breath | G3-0426, G6-0721 · 07:535-538, 16:234-236 | not | new |
| E84 | Rooms of Light (child) | his "Blow your mind" place: mirrors and lights "an endless flow of lights in all directions"; each touch emits a light that reflects off 6 virtual mirrors; for all ages | G3-0358 · 07:195-198 | not | new |
| E85 | The Sketchbook | "A wide net. Each sketch is a different verb and a different world. Play them all; keep what comes alive."; the ten grounds; the rule "a physical verb with a skill in it, instant feedback, a clear arrival; words only as the reward"; holds Turn, Trace, Beat, Still, Join, Release, Seal, Talk, Manage (Choose → Feed) | G3-0247, G7-0457 · 06:1876-1879, 06:1908-1909, 20:607-609, 20:703 | not | new |
| E86 | The Book | "Your book" / "What you chose to keep. It stays on this phone." / "Nothing kept yet. Whatever you keep from a game will be here."; ≤ 200 entries; "Kept"; entries: Leela "Walked: '<intent>'", a Draw card, an open-ground drawing, a letter kept unread | G7-0406, G5-0237, G3-0241 · 06:1843-1846, 12:577, 20:529-554 | not | new |
| E87 | Paper sheet and phrase reveal | sheet rises 40 px from .96 over 1.1 s, closes 500 ms to +30; a letter phrase by phrase: each held min(900, 180 + 16·len) ms, split after [.,;:?!]; seal pulses while composing; authored text only (no generated letter) | G5-0236, G5-0235 · 12:576, 13:245-248, 13:1017 | not | new |
| E88 | The Child corner | door hold 2.8 s "This door is small." / "Welcome back. You remembered how." (words shrink to 55%); amber #C47820 → #F8D870; every touch makes something and a sound, no end; holds Finger Garden, Colour Rivers, Rain, Echo, Rooms of Light; the Child Space's 20 questions on daily rotation, answered in his own word, kept in the book (no generated reflection, no child voice); BoxGame crash is web-only | G2-0899, G5-0204, G2-0898, G2-0900 · 05:3045-3060, 12:537, 12:553 | partial (games built) | new space |
| E89 | Sacred Experiences ("Right Now — what is calling you") | five "when" cards → Pulse, Shadow (Scrolls), Still, Flash, Arrive (Tat Tvam Asi) with their corpus close lines | (G7-0416 in E38; G7-0417 in E79) · 05:2976-3009 | partial (games built, door not) | new door |
| E90 | The Mirror · 60 s (camera) | front camera scaleX(−1), brightness .8; 1 px ring silver #C8CCD8 fills over 60 s; whispers "find your eyes" / "stay"; "What did you see?" (his word, released); "you were here"; no-camera path complete (dark 60 s) | G5-0219 · 12:554, 13:285, 05:3071-3075 | not | new |
| E91 | Life Games | nine Codex games (Fire, System, Learning, Family, Work, Maya, Health, Social, Seva) + Practice, Fitness, Adventure (twelve); each its own world showing recognitions on days his Codex tagged with that game, as light not count (join App Activity date ↔ Codex `Gaia Guess The Game`); Social carries Khelo Holi rays (conic rainbow 30 s, title gradient 5 s) at a celebration | G5-0559, G6-0765, G6-0632, G5-0661 · 14:181-192, 16:90, 16:325, 14:834 | not | new |
| E92 | Boards and planned play shelf | Leela on the 33 and the Seven Gates live; named-only until his content exists (D28 never fake completeness): Gyan Chaupar, Your Road, The Game of Rebirth, The Infinity Perspective, The Table of Buddha Selection; Today pieces (The Dive, Morning/Evening Handoff, When the Ground Shakes) belong to Today | G6-0700 · 16:224 | not | new (shelf) |
| E93 | Sefirat HaOmer — 49 nights | 7 × 7 gate: "Forty-nine gated nights. One opens after the last, never before."; "No blessing text" | G6-0742 · 16:290 | not | held for his ruling |
| E94 | The Dances shelf | 27 + 2 standalone dances (+ cross; abide pending), each a door with verb + seed only ("The person scanning sees only the verb. No song. No artist."), song and artist after the fruit; layouts: wall of verbs · blind draw · curated path search → reach → return → enough → still; verb rules: one word, a verb, never repeated; universal links `/b/<verb>`; per-dance config (DUR, PEAK_T, hue, Return, drops, shapes, seed) and Score rows; the fruit text verbatim with {w}; doors held dark where no mp3 exists on GitHub | G4-0279, G4-0002, G4-0119, G4-0120…G4-0148, G4-0149, G4-0150, G4-0151, G4-0162, G4-0178…G4-0200, G4-0203, G4-0206, G4-0288, G4-0291, G4-0342, G4-0413…G4-0446, G4-0594, G6-0697, G4-0053…G4-0072, G4-0075, G4-0076 · 08:43-57, 08:356-383, 08:646-695, 08:756-771, 08:889-937, 08:1177-1281, 09:198, 09:519-570, 10:319-324, 16:218 | not (web builds only) | new (player reused) |
| E95 | Score player | one clock (elapsed) drives binaural glide, Canvas tiers, Core Haptics, text; ScoreV2 Codable; unknown vocabulary_module → Layer 1; reads Score JSON `fldxIm6qUXLcdrRuR` + Audio Data URL `fldUlWDvSkeHpx80x` | G4-0459 · 09:624, 11:119-122 | not (built in the 33 world) | reuse from the 33 |
| E96 | Chakra Game heritage | spine of 7 orbs → portal → experience; seven experiences (river draw, reflection, 4-2-6-2 breath × 3, word reveal 650 ms / "·" 1800 ms, oracle flip, matching) live in their rooms; the root quiz with a progress bar is rejected (nothing scores him); "Your heart is open." / "All things are connected." declarations not ported (no congratulation) | G2-0859, G2-0861, G2-0862, G7-0415 · 05:2842-2872, 20:529-554 | built web | merged into rooms (E20) |
| E97 | Mini Games hub registry | 18 games, six categories (Patience · Time / Rhythm · Body / Language · Mirror / Elements / Sacred Pattern / Body · Space) → all now standing in family worlds | G2-0863 · 05:2874-2899 | built web | merged into E08 |

Count: 95 placed elements (E01–E97 less E36 reserved and E97 merged-only registry); 36 existing games (E21 Leela + E37–E71) and 23 new or newly-housed worlds (E06, E72–E93).

---

## 3 · Parity ledger

Written as `waves/upgrade/ledger/game.csv` — 112 rows, ids `GAME-E..` keyed to §2 — (columns `id, world, element, source, numbers_to_match, reference_frame, status_today, code_today, build_action, verify_by`). No Design frame F01–F40 shows this world; `reference_frame` names the Design prototype instead: **G-ENGINE** (`a-strange-game-play.html`), **G-LEELA33** (`leela-on-the-33.html`), **G-SKETCH** (`a-strange-game-sketchbook.html`), **CG** (Chakra Game corpus), or **code** where the build itself is the reference.

---

## 4 · Data contract

**Airtable (read).**
- The Map `tblwpmyKOeMxEEHd7` — via the bake `Data/ChakraConstellation.json` (44 keys): name, sanskrit, system, colorHex, verb, coreQuestion, signaturePhrase, practicePrompt, threeWaysIn, gateType/gateText, essence, leelaStory (drops only; sealed rows refused), road. Leela squares = road order 1–33.
- Identity `tbluLyZj9ilH2RhIg` — via `Data/GameStructure.json`: panels 1–9 (verb, declaration, seed), faces, practices (Sacred Pause, Sri Yantra Tratak, Morning Intention, Evening Reflection), leelaDrops (8). Games list (18 rows) for Life Games.
- Mandala table (seats) — Śakti name and Appreciation Phrase (Shadow Translator, Garland caption), `playPosition` from khadgamalaPosition.
- Avaraṇa rows — Mental State / Siddhi (Seven Gates gifts may draw the ring's Siddhi words as the gift's second line).
- Codex `tblDF4OCMcRoxkQjU` — field `Gaia Guess The Game` [A Fire | System | Learning | Family | Work | Maya | Health | Social | Seva Game] + date (Life Games light).
- Field catalogue — Score JSON `fldxIm6qUXLcdrRuR`, Audio Data URL `fldUlWDvSkeHpx80x`; Builds `tbl5PR84YTy4anzAD` (dance list).

**Airtable (write) — App Activity `tblJlBeiHnqGpYrL7` only** (Source App "Mandala"; Gesture Source `fldP3wq8QTgxeTDuC` option "Play"):
| type | when | links / fields |
|---|---|---|
| `Played` | an engaged game (acts ≥ 3, ≥ 6 s); each Leela landing | Link to Mandala `fldzsEMInQmNIxTNu` (her row, else Avaraṇa); Link to The Map `fldkF65ySNGGkeugH` for landings; Detail `fldFWURRpDmzcSAvl` ("Leela · Square n · Name"); Duration (sec) `fldrIOx1id7Esm2fd`; Activity Date `fldMcikl2kbVRFv4G`; Felt At `fldWAR0B4pNxjTwEJ` |
| `Chakra Practiced` | "I did it" / "Let it be" on a landing sheet | Link to The Map; Notes `fldVyj4hkzxcrIBoJ` empty (both answers are the same act) |
| `Leela Drop` | "carry it" / "hold in silence" | drop id in Detail |
| `Letter Sealed` / `Letter Opened` | Letter / Seal | her row (seat 88 default) |
| `State Set Down` | each Seven Gates card laid | Avaraṇa or Map row of the gate |
| `Shakti Recognized` | a game's handoff to Recognition | her row |
| `Silence Held` | Sakshi Pause close; Still · Ājñā 30 s | Duration (sec) |
| `Garland Recited` | a whole Garland round | — |
| nothing | the Eight Dissolutions; the Mirror's eight stations | — |

**Bundled / hosted assets** (`audio-on-github.md`, ruling 12): dance shelf `b/arise, b/bindu-dances-reach, b/dream, b/enough, b/fade, b/glow, b/howl, b/light, b/lose, b/melt, b/move, b/release, b/remember, b/rise, b/search, b/stay, b/still, b/wild` and `bindu/ache, believe, crash, cross, dream, earn, enough, fade, glow, ground, howl, light, lose, melt, move, numb, play, release, remember, rise, search, stay, still, trace, wild` (`.mp3`). Not on GitHub (doors held dark): shine (Golden), return (I Was Wrong), abide (Time), lift, wake, brave, ascend, unfold, crave, want, confront, miss, cherish, journey. Meditate pieces `bindu/in_shadow`, `bindu/kingdom`, `bindu/before` belong to Home. Fonts: Gloock, Newsreader, Lora, DM Sans, Cinzel. All other game sound is synthesised (no files).

**Local stores (PracticeVault / UserDefaults).** `dissolved_day` (int practice day) · `leela_last_drop_day`, `leela_last_drop_id`, `leela_last_considered_day` (`leela_first_seen_day` retired by ruling 16) · **PlayStore** (merge of PlayTraceStore + PlayGardenStore: traces {game, position, ring, at}, seeds {plantedAt, address}, worldVisitedAt) · **LeelaWalk** {intent, mode: life|building, square?, born, path[], arrivedAt?} · **Book** (≤ 200 {kind, text, at}) · **Draw** {day, card, kept} · CorrespondenceStore (Letter). Every store is a vault file: never lost (floor).

---

## 5 · Doors

| from | way | to | thread |
|---|---|---|---|
| Home (the Bindu) | Lalitā source "play in her field" → the Dissolutions | the field | — |
| any world | menu constellation point "A Strange Game" | the Dissolutions / "Now go play." | — |
| any world | search ("leela", a game name, a verb) | that game's world | — |
| any world | the die "Or don't decide. Touch the point. The field chooses." (scope games) | a game | — |
| the Mandala | map--sky die across 102 + 33 | the landed seat's game door / the 33 room | kp, chakra |
| the Mandala | the Garland | E50 | kp (all 102) |
| Her Home / Her Presence (kp 1–102) | her game door; else her bead in the Garland | the addressed game | kp |
| the 33, room n | `<Game> · <verb>` door (E20 table) | the game | chakra |
| the 33, rooms 1 & 33 | Leela | the board | chakra |
| the 33, room 30 | the Mirror | E06 | chakra |
| the 33, room 31 | Turn | E66 | chakra |
| the 33, energy rooms' wake-up | Bīja Tones | E51 | chakra |
| the 33, room 9 | Corridor, Scrolls | E37, E62 | chakra |
| the 33, room 20 | Tat Tvam Asi | E65 | chakra |
| the 33, room 28 | the Door; the Child corner | E48, E88 | chakra |
| the 33, room 32 | Shadow Translator (as a light only; no words of the Reveal) | E57 | chakra |
| Today | The Draw; The Sakshi Pause | E72, E73 | day |
| Today | a Leela drop's "carry it" | (stays in life; no game opens) | day |
| Time | the Great Wheel; Sandhya at the junction | E71, E70 | day |
| the Modes | Manager mode | E81 | — |
| the Relationship Field | Talk (ring of ten) | E80 | — |
| the Well | the Letter's opening | E59 | day |
| outside | `aistrangegame.com/b/<verb>` universal link | Dances shelf, that dance | — |
| **out of this world** | | | |
| a Leela landing | Enter | the chakra's room (the 33), then back to the board | chakra |
| any game | handoff Recognition | Her Presence moment (two lines) → back to the game's world | kp |
| a game's address | "her seat" | Her Home kp n | kp |
| the field foot | "the modes" / "the road" / "your book" | Modes / the Climb's road / the Book | — |
| the field | the point | Home, through the crossing | — |
| any game | "< leave" | family world → field (back stack) | — |
| Great Wheel | today at the top | Time | day |

---

## 6 · To Bindu Feed

| material | source (ids · register) |
|---|---|
| The 32 Leela Stories (rooms 1–31, 33), three-voice witness/Bindu/Gaia texts — e.g. "The point arrives without knowing it was called…", "You thought you were reading about a point of consciousness waking up. You were reading about yourself…" | G2-0591, G2-0600, G2-0608, G2-0616, G2-0624, G2-0632, G2-0640, G2-0648, G2-0656, G2-0665, G2-0673, G2-0681, G2-0689, G2-0697, G2-0705, G2-0713, G2-0721, G2-0729, G2-0737, G2-0745, G2-0753, G2-0761, G2-0769, G2-0777, G2-0785, G2-0793, G2-0801, G2-0809, G2-0817, G2-0826, G2-0834, G2-0845 · 05:492-2734 (their energy closings stay as drops, E34) |
| Leela's origin "The One says I Am. Then asks — Am I alone? / Lonely. La-One-Lee …" | G3-0148, G5-0580 · 06:666, 14:303 |
| Sketch Choose (Life is Strange): scenes, three choices, consequences, rewind spiral 1400 ms −540° blur 0 → 6 px | G3-0248, G7-0407, G5-0244 · 06:1881-1883, 13:493 |
| Hall of Perspectives, "I already did" | G3-0468 · 07:745-748 |
| Learning topic Aboriginal Dreamtime & Songlines | G5-1154 · 12:1539 |
| Copies (kept here as energy, also to Feed): the dance fruit texts (E94); the Scrolls' twelve lines (E62); the drop leads/actions and panel declarations (E03, E34) | G4-0053…G4-0076, G7-1022, G7-1023 |

---

## 7 · Conflicts — settled and open

**Settled from evidence and rulings**
1. **Mandala hosts the game** (G7-0026, G7-0209) → the game is its own world; the Dissolutions and the field move out of `LivingMandalaView` and the root overlay (foundation).
2. **Seed timings** (G7-0276): code `SeedGrowth` is 2 / 8 / 24 / 72 h (`PlayPhysicsWhole.swift:61-68`); the tests sample 3 / 12 / 30 / 80 h, which fall inside those bands — no disagreement. Keep 2/8/24/72 (Design).
3. **Tuning** (G2-0864, G7-0481, G6-0605): one tuning; each room keeps its fixed awakening tone. Mantra Tuner's solfeggio (396–963) is retired; Bīja Tones keeps 174 · 210 · 320 · 341 · 384 · 426 · 480 · 528 · silence but labels the nine bands as the nine Tree-of-Life panels (rooms), not rings, so ring 2 no longer reads as Anāhata at Svādhiṣṭhāna's tone.
4. **Leela board shape**: Design's boustrophedon (G-LEELA33) is the floor; the code spiral goes. **Colours**: Map colours win over the engine's SQ hexes (G3-0243).
5. **Hop speed**: 170 ms (single file), 560 ms step (engine), 550 ms + 8 px lift (padakarshini forms, latest and matched in rupakarshini) → 550 ms.
6. **Die gesture**: A14 names both — held die G29 2200 ms in the play engine, tap on Leela on the 33 → hold with the breath ring, tap as the one-tap way through, shake kept.
7. **Leela reading voice / letters**: the Claude quick tier and `letter()` are generated text → refused (no generated voice; nothing invented). The design's own "without Claude" path is used: reading = the square's practice verbatim, seed = its signature, closing "Your walk: …" + Lalitā's practice (G3-0305). Mirror Maze's claude forms and Shadow Translator's claude gift are already replaced in code by authored rows; Child Space reflections and the child voice, Sanctuary gatekeeper, Body as Scripture verses, World-in-a-Box story — all refused, mechanisms kept.
8. **"What I'm building" writing back to the gameplan** (G3-0306): no — App Activity is the single ledger; the mode lives in LeelaWalk only.
9. **Square 32** — held, "This square is held for its own walk." (ruling 2).
10. **"Never in the first days"** (G7-0910): lifted by ruling 16; `shouldDrop` counts the gap from the last drop only (nil → may drop); `minimumGapDays == 3` and `chance == 0.3` get pinned in tests.
11. **Dissolutions vs the Mirror** — code's eight (skill's Mirror Dissolution instructions; ring 3 "Now be still" 5 s, ring 6 "Now move") and Design's Māyā Phase 6 (ring 3 "Don't engage" 6 s with 8 particles, ring 6 "Close your eyes" 8 s) are different sources → both kept: the Dissolutions as the entrance (built, his declarations, writes nothing), the Mirror as its own world with Design's stations verbatim and "Go Play" in red.
12. **Water Level** 12 s (code) vs 30 s (Design, frame-rate bug in web) → 30 s wall-clock, knock every 6 s.
13. **Fire** numbers: web 50 start, .18/frame, +22 (frame-dependent) vs code band .15–.82, .11/s, .12 + .14p → keep code (same band, time-correct).
14. **Hold durations disagree** (G7-0484) → one G0 catalogue (E15); each hold named by its act.
15. **Simulated presence** "84 hearts" and Manage's simulated week → rejected (no fake counts; HO1-12); Manage reads his real week.
16. **Two-Door LIVE/EVIL progress bar** → kept as a hold with a ring, never a bar (anti-pattern canon).
17. **Gates and locks** (G5-0530, G5-0534, G4-0873): site law 1 is site-only; his own holds stay (dissolutions once a day, drops ≥ 3 days then 30%); designed ceremonies stay; nothing else is locked.
18. **Drop texts as story** (G7-1023): drops are short authored substrings revealed by form (phrase reveal, 4.5 s action) → energy; they stay here and are copied to the Feed.
19. **Seven Gates direction**: Design lays things down (falling); his Codex (C-1230/1232, already in `GatesOfReleaseLayer`) makes it an offering that rises → words rise.
20. **Child Space 20 vs 12 questions** → the 20 in `Child Space` source (the larger, verbatim set).
21. **Verb collisions** on the shelf (G4-0288): the shelf keeps registry verbs (still → ember per 09, 31 Aug); chakra-room verbs live in the 33 (Press, Follow, Build, Open, Speak, Still, Receive, Hold, Dissolve); `shine` and `arise` doors wait for their songs.
22. **Leela sheet link "Walk this position on aistrangegame.com"** → in-app door to the position's own room (the 33), keeping the person inside the instrument.
23. **Turn notch** π/6 (code) vs 15° tick (Design) → 15° ticks, snap ±7.5° (G5-0450) with Design bells.

**Open — genuine questions for Ashrey**
1. **Leela's arrows and snakes** — the draft (5→8, 12→18, 13→20, 26→29; 15→6, 19→10, 28→21, 30→9 with their lines) was written "for Ashrey's ruling". Ship it as is? And does **triple six** return you (Johari) — or does a six simply throw again forever?
2. **Leela drops from the whole Codex** (C-1330 "run it through Leela's story") — may Claude craft new drops from his Codex for his approval (as with the 16 Karṣiṇī functions, ruling 7), or do drops stay only authored substrings and his verbatim Codex lines?
3. **The Draw's 24 card bodies** — he has the 24 titles; the bodies are not written. His words, the Map's, or Claude-drafted for his approval?
4. **Sefirat HaOmer (49 nights)** and the **E Chakras / "Lalita Game"** named at Ātmā and Lalitā ("From here, the E Chakras open.") with no record — do they belong here, and if so, what are they?

---

## 8 · Coverage

Every index id in `by-world/game.jsonl`, with its disposition. (Generated from the placement map in §2 plus the Feed / not-this-world / rejected lists; script check pasted at the end.)

| id | disposition |
|---|---|
| G2-0355 | placed (§2 E01) |
| G2-0357 | placed (§2 E01) |
| G2-0363 | placed (§2 E18) |
| G2-0370 | placed (§2 E08) |
| G2-0371 | placed (§2 E17) |
| G2-0376 | not this world — time / memory (Waves 3–5 summary) |
| G2-0500 | not this world — the-33 (room 1 practice) |
| G2-0522 | not this world — the-33 (room declaration conflict) |
| G2-0530 | not this world — the-33 (room 3 wake-up) |
| G2-0538 | placed (§2 E58) |
| G2-0547 | placed (§2 E06) |
| G2-0548 | placed (§2 E06) |
| G2-0591 | to Bindu Feed (§6) |
| G2-0600 | to Bindu Feed (§6) |
| G2-0608 | to Bindu Feed (§6) |
| G2-0616 | to Bindu Feed (§6) |
| G2-0624 | to Bindu Feed (§6) |
| G2-0632 | to Bindu Feed (§6) |
| G2-0640 | to Bindu Feed (§6) |
| G2-0648 | to Bindu Feed (§6) |
| G2-0656 | to Bindu Feed (§6) |
| G2-0657 | not this world — the-33 (Pulse layer rooms 9–32) |
| G2-0665 | to Bindu Feed (§6) |
| G2-0673 | to Bindu Feed (§6) |
| G2-0681 | to Bindu Feed (§6) |
| G2-0689 | to Bindu Feed (§6) |
| G2-0697 | to Bindu Feed (§6) |
| G2-0705 | to Bindu Feed (§6) |
| G2-0713 | to Bindu Feed (§6) |
| G2-0721 | to Bindu Feed (§6) |
| G2-0729 | to Bindu Feed (§6) |
| G2-0737 | to Bindu Feed (§6) |
| G2-0745 | to Bindu Feed (§6) |
| G2-0753 | to Bindu Feed (§6) |
| G2-0761 | to Bindu Feed (§6) |
| G2-0769 | to Bindu Feed (§6) |
| G2-0777 | to Bindu Feed (§6) |
| G2-0785 | to Bindu Feed (§6) |
| G2-0793 | to Bindu Feed (§6) |
| G2-0801 | to Bindu Feed (§6) |
| G2-0809 | to Bindu Feed (§6) |
| G2-0817 | to Bindu Feed (§6) |
| G2-0826 | to Bindu Feed (§6) |
| G2-0834 | to Bindu Feed (§6) |
| G2-0845 | to Bindu Feed (§6) |
| G2-0846 | not this world — the-33 (room 33 gate) |
| G2-0859 | placed (§2 E96) |
| G2-0860 | rejected — floor: nothing scores him (quiz + progress bar) |
| G2-0861 | placed (§2 E96) |
| G2-0862 | placed (§2 E96) |
| G2-0863 | merged into E08 (family worlds; registry row E97) |
| G2-0864 | placed (§2 E51) |
| G2-0865 | placed (§2 E74) |
| G2-0866 | placed (§2 E53) |
| G2-0867 | placed (§2 E37) |
| G2-0868 | placed (§2 E52) |
| G2-0869 | placed (§2 E51) |
| G2-0870 | placed (§2 E43) |
| G2-0871 | placed (§2 E58) |
| G2-0872 | placed (§2 E59) |
| G2-0873 | placed (§2 E57) |
| G2-0874 | placed (§2 E45) |
| G2-0875 | placed (§2 E46) |
| G2-0876 | placed (§2 E44) |
| G2-0877 | placed (§2 E49) |
| G2-0878 | placed (§2 E55) |
| G2-0879 | placed (§2 E54) |
| G2-0880 | placed (§2 E56) |
| G2-0881 | placed (§2 E39) |
| G2-0882 | placed (§2 E47) |
| G2-0883 | placed (§2 E07) |
| G2-0885 | placed (§2 E38) |
| G2-0890 | rejected — floor: no simulated presence ("84 hearts") |
| G2-0892 | rejected — floor: no counts about him; generated letter (no generated voice) |
| G2-0898 | placed (§2 E88) |
| G2-0899 | placed (§2 E88) |
| G2-0900 | placed (§2 E60) |
| G2-0906 | placed (§2 E60) |
| G2-0909 | placed (§2 E19) |
| G2-0910 | placed (§2 E02) |
| G2-0923 | placed (§2 E18) |
| G2-0927 | placed (§2 E07) |
| G2-0932 | placed (§2 E19) |
| G3-0003 | placed (§2 E23) |
| G3-0148 | to Bindu Feed (§6) |
| G3-0158 | placed (§2 E25) |
| G3-0238 | placed (§2 E23) |
| G3-0239 | placed (§2 E07) |
| G3-0240 | placed (§2 E13) |
| G3-0241 | placed (§2 E86) |
| G3-0242 | placed (§2 E22) |
| G3-0243 | placed (§2 E23) |
| G3-0244 | placed (§2 E72) |
| G3-0245 | placed (§2 E73) |
| G3-0246 | placed (§2 E18) |
| G3-0247 | placed (§2 E85) |
| G3-0248 | to Bindu Feed (§6) |
| G3-0249 | placed (§2 E80) |
| G3-0250 | placed (§2 E81) |
| G3-0251 | placed (§2 E67) |
| G3-0252 | placed (§2 E66) |
| G3-0253 | placed (§2 E76) |
| G3-0254 | placed (§2 E77) |
| G3-0255 | placed (§2 E75) |
| G3-0256 | placed (§2 E78) |
| G3-0257 | placed (§2 E59) |
| G3-0266 | placed (§2 E20) |
| G3-0267 | placed (§2 E15) |
| G3-0277 | placed (§2 E01) |
| G3-0278 | placed (§2 E01) |
| G3-0279 | placed (§2 E01) |
| G3-0280 | placed (§2 E01) |
| G3-0294 | placed (§2 E13) |
| G3-0300 | placed (§2 E34) |
| G3-0301 | placed (§2 E22) |
| G3-0302 | placed (§2 E27) |
| G3-0303 | placed (§2 E27) |
| G3-0304 | placed (§2 E29) |
| G3-0305 | placed (§2 E29) |
| G3-0306 | placed (§2 E27) |
| G3-0307 | placed (§2 E18) |
| G3-0311 | placed (§2 E18) |
| G3-0327 | placed (§2 E82) |
| G3-0332 | placed (§2 E18) |
| G3-0344 | placed (§2 E18) |
| G3-0349 | placed (§2 E18) |
| G3-0358 | placed (§2 E84) |
| G3-0360 | placed (§2 E73) |
| G3-0361 | placed (§2 E73) |
| G3-0388 | placed (§2 E80) |
| G3-0395 | placed (§2 E34) |
| G3-0402 | placed (§2 E34) |
| G3-0416 | placed (§2 E34) |
| G3-0426 | placed (§2 E83) |
| G3-0443 | placed (§2 E34) |
| G3-0452 | placed (§2 E34) |
| G3-0459 | placed (§2 E01) |
| G3-0462 | placed (§2 E34) |
| G3-0465 | placed (§2 E01) |
| G3-0468 | to Bindu Feed (§6) |
| G3-0472 | placed (§2 E80) |
| G3-0503 | placed (§2 E34) |
| G3-0535 | placed (§2 E34) |
| G4-0002 | placed (§2 E94) |
| G4-0053 | placed (§2 E94) |
| G4-0054 | placed (§2 E94) |
| G4-0055 | placed (§2 E94) |
| G4-0056 | placed (§2 E94) |
| G4-0057 | placed (§2 E94) |
| G4-0058 | placed (§2 E94) |
| G4-0059 | placed (§2 E94) |
| G4-0060 | placed (§2 E94) |
| G4-0061 | placed (§2 E94) |
| G4-0062 | placed (§2 E94) |
| G4-0063 | placed (§2 E94) |
| G4-0064 | placed (§2 E94) |
| G4-0065 | placed (§2 E94) |
| G4-0066 | placed (§2 E94) |
| G4-0067 | placed (§2 E94) |
| G4-0068 | placed (§2 E94) |
| G4-0069 | placed (§2 E94) |
| G4-0070 | placed (§2 E94) |
| G4-0071 | placed (§2 E94) |
| G4-0072 | placed (§2 E94) |
| G4-0073 | not this world — the-33 (Mūlādhāra dance fruit) |
| G4-0074 | not this world — the-33 (Anāhata dance fruit) |
| G4-0075 | placed (§2 E94) |
| G4-0076 | placed (§2 E94) |
| G4-0119 | placed (§2 E94) |
| G4-0120 | placed (§2 E94) |
| G4-0121 | placed (§2 E94) |
| G4-0122 | placed (§2 E94) |
| G4-0123 | placed (§2 E94) |
| G4-0124 | placed (§2 E94) |
| G4-0125 | placed (§2 E94) |
| G4-0126 | placed (§2 E94) |
| G4-0127 | placed (§2 E94) |
| G4-0128 | placed (§2 E94) |
| G4-0129 | placed (§2 E94) |
| G4-0130 | placed (§2 E94) |
| G4-0131 | placed (§2 E94) |
| G4-0132 | placed (§2 E94) |
| G4-0133 | placed (§2 E94) |
| G4-0134 | placed (§2 E94) |
| G4-0135 | placed (§2 E94) |
| G4-0136 | placed (§2 E94) |
| G4-0137 | placed (§2 E94) |
| G4-0138 | placed (§2 E94) |
| G4-0139 | placed (§2 E94) |
| G4-0140 | placed (§2 E94) |
| G4-0141 | placed (§2 E94) |
| G4-0142 | placed (§2 E94) |
| G4-0143 | placed (§2 E94) |
| G4-0144 | placed (§2 E94) |
| G4-0145 | placed (§2 E94) |
| G4-0146 | placed (§2 E94) |
| G4-0147 | placed (§2 E94) |
| G4-0148 | placed (§2 E94) |
| G4-0149 | placed (§2 E94) |
| G4-0150 | placed (§2 E94) |
| G4-0151 | placed (§2 E94) |
| G4-0162 | placed (§2 E94) |
| G4-0178 | placed (§2 E94) |
| G4-0179 | placed (§2 E94) |
| G4-0180 | placed (§2 E94) |
| G4-0181 | placed (§2 E94) |
| G4-0182 | placed (§2 E94) |
| G4-0183 | placed (§2 E94) |
| G4-0184 | placed (§2 E94) |
| G4-0185 | placed (§2 E94) |
| G4-0186 | placed (§2 E94) |
| G4-0187 | placed (§2 E94) |
| G4-0188 | placed (§2 E94) |
| G4-0189 | placed (§2 E94) |
| G4-0190 | placed (§2 E94) |
| G4-0191 | placed (§2 E94) |
| G4-0192 | placed (§2 E94) |
| G4-0193 | placed (§2 E94) |
| G4-0194 | placed (§2 E94) |
| G4-0195 | placed (§2 E94) |
| G4-0196 | placed (§2 E94) |
| G4-0197 | placed (§2 E94) |
| G4-0198 | placed (§2 E94) |
| G4-0199 | placed (§2 E94) |
| G4-0200 | placed (§2 E94) |
| G4-0201 | not this world — the-33 (Mūlādhāra dance config) |
| G4-0202 | not this world — the-33 (Anāhata dance config) |
| G4-0203 | placed (§2 E94) |
| G4-0206 | placed (§2 E94) |
| G4-0279 | placed (§2 E94) |
| G4-0288 | placed (§2 E94) |
| G4-0291 | placed (§2 E94) |
| G4-0308 | placed (§2 E28) |
| G4-0319 | not this world — sound / the-33 (three-layer substrate; dependency of E95) |
| G4-0342 | placed (§2 E94) |
| G4-0399 | placed (§2 E18) |
| G4-0402 | not this world — the-33 (chakra room Score) |
| G4-0403 | not this world — the-33 (chakra room Score) |
| G4-0404 | not this world — the-33 (chakra room Score) |
| G4-0405 | not this world — the-33 (chakra room Score) |
| G4-0406 | not this world — the-33 (chakra room Score) |
| G4-0407 | not this world — the-33 (chakra room Score) |
| G4-0408 | not this world — the-33 (chakra room Score) |
| G4-0409 | not this world — the-33 (chakra room Score) |
| G4-0410 | not this world — the-33 (chakra room Score) |
| G4-0411 | not this world — home (Meditate → Bindu) |
| G4-0412 | not this world — home (Meditate → Bindu) |
| G4-0413 | placed (§2 E94) |
| G4-0414 | placed (§2 E94) |
| G4-0415 | placed (§2 E94) |
| G4-0416 | placed (§2 E94) |
| G4-0417 | placed (§2 E94) |
| G4-0418 | placed (§2 E94) |
| G4-0419 | placed (§2 E94) |
| G4-0420 | placed (§2 E94) |
| G4-0421 | placed (§2 E94) |
| G4-0422 | placed (§2 E94) |
| G4-0423 | placed (§2 E94) |
| G4-0424 | placed (§2 E94) |
| G4-0425 | placed (§2 E94) |
| G4-0426 | placed (§2 E94) |
| G4-0427 | placed (§2 E94) |
| G4-0428 | placed (§2 E94) |
| G4-0429 | placed (§2 E94) |
| G4-0430 | placed (§2 E94) |
| G4-0431 | placed (§2 E94) |
| G4-0432 | placed (§2 E94) |
| G4-0433 | placed (§2 E94) |
| G4-0434 | placed (§2 E94) |
| G4-0435 | placed (§2 E94) |
| G4-0436 | placed (§2 E94) |
| G4-0437 | placed (§2 E94) |
| G4-0438 | placed (§2 E94) |
| G4-0439 | placed (§2 E94) |
| G4-0440 | placed (§2 E94) |
| G4-0441 | placed (§2 E94) |
| G4-0442 | placed (§2 E94) |
| G4-0443 | placed (§2 E94) |
| G4-0444 | placed (§2 E94) |
| G4-0445 | placed (§2 E94) |
| G4-0446 | placed (§2 E94) |
| G4-0459 | placed (§2 E95) |
| G4-0475 | placed (§2 E72) |
| G4-0477 | placed (§2 E14) |
| G4-0594 | placed (§2 E94) |
| G4-0674 | not this world — spine (Guide and Door) |
| G4-0680 | placed (§2 E53) |
| G4-0688 | placed (§2 E28) |
| G4-0724 | placed (§2 E15) |
| G4-0742 | placed (§2 E49) |
| G4-0743 | placed (§2 E47) |
| G4-0748 | placed (§2 E66) |
| G4-0753 | placed (§2 E15) |
| G4-0771 | placed (§2 E41) |
| G4-0789 | placed (§2 E53) |
| G4-0860 | placed (§2 E35) |
| G4-0862 | placed (§2 E08) |
| G4-0863 | placed (§2 E53) |
| G4-0873 | placed (§2 E18) |
| G5-0052 | not this world — the-33 (walk it or read it) |
| G5-0054 | not this world — the-33 (figure chooses the door) |
| G5-0151 | placed (§2 E12) |
| G5-0186 | placed (§2 E74) |
| G5-0187 | placed (§2 E53) |
| G5-0188 | placed (§2 E37) |
| G5-0189 | placed (§2 E52) |
| G5-0190 | placed (§2 E51) |
| G5-0191 | placed (§2 E43) |
| G5-0192 | placed (§2 E58) |
| G5-0193 | placed (§2 E59) |
| G5-0194 | placed (§2 E57) |
| G5-0195 | placed (§2 E45) |
| G5-0196 | placed (§2 E46) |
| G5-0197 | placed (§2 E44) |
| G5-0198 | placed (§2 E49) |
| G5-0199 | placed (§2 E55) |
| G5-0200 | placed (§2 E54) |
| G5-0201 | placed (§2 E56) |
| G5-0202 | placed (§2 E39) |
| G5-0203 | placed (§2 E47) |
| G5-0204 | placed (§2 E88) |
| G5-0205 | placed (§2 E09) |
| G5-0218 | placed (§2 E20) |
| G5-0219 | placed (§2 E90) |
| G5-0234 | placed (§2 E15) |
| G5-0235 | placed (§2 E87) |
| G5-0236 | placed (§2 E87) |
| G5-0237 | placed (§2 E86) |
| G5-0238 | placed (§2 E18) |
| G5-0239 | placed (§2 E23) |
| G5-0240 | placed (§2 E13) |
| G5-0241 | placed (§2 E72) |
| G5-0242 | placed (§2 E80) |
| G5-0243 | placed (§2 E81) |
| G5-0244 | to Bindu Feed (§6) |
| G5-0245 | placed (§2 E08) |
| G5-0246 | placed (§2 E22) |
| G5-0287 | placed (§2 E35) |
| G5-0307 | not this world — beneath (ten Mahāvidyās) |
| G5-0450 | placed (§2 E66) |
| G5-0451 | placed (§2 E76) |
| G5-0452 | placed (§2 E75) |
| G5-0453 | placed (§2 E67) |
| G5-0467 | placed (§2 E10) |
| G5-0469 | placed (§2 E09) |
| G5-0470 | placed (§2 E10) |
| G5-0488 | placed (§2 E11) |
| G5-0489 | placed (§2 E11) |
| G5-0521 | placed (§2 E11) |
| G5-0530 | placed (§2 E03) |
| G5-0534 | placed (§2 E18) |
| G5-0559 | placed (§2 E91) |
| G5-0564 | placed (§2 E01) |
| G5-0570 | placed (§2 E01) |
| G5-0571 | placed (§2 E34) |
| G5-0580 | to Bindu Feed (§6) |
| G5-0644 | placed (§2 E05) |
| G5-0661 | placed (§2 E91) |
| G5-0676 | placed (§2 E48) |
| G5-1154 | to Bindu Feed (§6) |
| G6-0529 | not this world — the-33 (Tree of Life panel) |
| G6-0530 | not this world — the-33 (Tree of Life panel) |
| G6-0531 | not this world — the-33 (Tree of Life panel) |
| G6-0532 | not this world — the-33 (Tree of Life panel) |
| G6-0533 | not this world — the-33 (Tree of Life panel) |
| G6-0534 | not this world — the-33 (Tree of Life panel) |
| G6-0535 | not this world — the-33 (Tree of Life panel) |
| G6-0536 | not this world — the-33 (Tree of Life panel) |
| G6-0537 | not this world — the-33 (Tree of Life panel) |
| G6-0538 | not this world — the-33 (Tree of Life panel) |
| G6-0573 | placed (§2 E07) |
| G6-0586 | placed (§2 E28) |
| G6-0587 | placed (§2 E34) |
| G6-0588 | placed (§2 E01) |
| G6-0605 | placed (§2 E51) |
| G6-0622 | not this world — the-33 (Map designed-unbuilt) |
| G6-0623 | placed (§2 E01) |
| G6-0632 | placed (§2 E91) |
| G6-0697 | placed (§2 E94) |
| G6-0700 | placed (§2 E92) |
| G6-0721 | placed (§2 E83) |
| G6-0742 | placed (§2 E93) |
| G6-0765 | placed (§2 E91) |
| G6-0766 | placed (§2 E21) |
| G6-0793 | placed (§2 E03) |
| G6-0794 | placed (§2 E28) |
| G6-0798 | placed (§2 E28) |
| G6-0830 | placed (§2 E34) |
| G6-0831 | placed (§2 E34) |
| G6-0834 | placed (§2 E17) |
| G6-0867 | placed (§2 E17) |
| G6-0894 | placed (§2 E34) |
| G6-0906 | placed (§2 E17) |
| G6-0918 | placed (§2 E16) |
| G7-0005 | placed (§2 E02) |
| G7-0026 | placed (§2 E02) |
| G7-0094 | placed (§2 E03) |
| G7-0157 | placed (§2 E02) |
| G7-0158 | placed (§2 E34) |
| G7-0180 | placed (§2 E02) |
| G7-0183 | placed (§2 E20) |
| G7-0209 | placed (§2 E03) |
| G7-0226 | placed (§2 E03) |
| G7-0228 | placed (§2 E16) |
| G7-0229 | placed (§2 E16) |
| G7-0230 | placed (§2 E13) |
| G7-0231 | placed (§2 E17) |
| G7-0232 | placed (§2 E18) |
| G7-0233 | placed (§2 E16) |
| G7-0234 | placed (§2 E16) |
| G7-0235 | placed (§2 E20) |
| G7-0236 | placed (§2 E17) |
| G7-0237 | placed (§2 E16) |
| G7-0238 | placed (§2 E16) |
| G7-0239 | placed (§2 E50) |
| G7-0240 | placed (§2 E37) |
| G7-0241 | placed (§2 E38) |
| G7-0242 | placed (§2 E39) |
| G7-0243 | placed (§2 E40) |
| G7-0244 | placed (§2 E41) |
| G7-0245 | placed (§2 E42) |
| G7-0246 | placed (§2 E43) |
| G7-0247 | placed (§2 E44) |
| G7-0248 | placed (§2 E45) |
| G7-0249 | placed (§2 E46) |
| G7-0250 | placed (§2 E47) |
| G7-0251 | placed (§2 E48) |
| G7-0252 | placed (§2 E49) |
| G7-0253 | placed (§2 E50) |
| G7-0254 | placed (§2 E51) |
| G7-0255 | placed (§2 E52) |
| G7-0256 | placed (§2 E53) |
| G7-0257 | placed (§2 E54) |
| G7-0258 | placed (§2 E55) |
| G7-0259 | placed (§2 E56) |
| G7-0260 | placed (§2 E57) |
| G7-0261 | placed (§2 E58) |
| G7-0262 | placed (§2 E59) |
| G7-0263 | placed (§2 E60) |
| G7-0264 | placed (§2 E61) |
| G7-0265 | placed (§2 E62) |
| G7-0266 | placed (§2 E63) |
| G7-0267 | placed (§2 E64) |
| G7-0268 | placed (§2 E65) |
| G7-0269 | placed (§2 E21) |
| G7-0270 | placed (§2 E66) |
| G7-0271 | placed (§2 E67) |
| G7-0272 | placed (§2 E68) |
| G7-0273 | placed (§2 E69) |
| G7-0274 | placed (§2 E70) |
| G7-0275 | placed (§2 E71) |
| G7-0276 | placed (§2 E53) |
| G7-0277 | placed (§2 E07) |
| G7-0278 | placed (§2 E07) |
| G7-0279 | placed (§2 E07) |
| G7-0280 | placed (§2 E07) |
| G7-0281 | placed (§2 E07) |
| G7-0282 | placed (§2 E07) |
| G7-0283 | placed (§2 E07) |
| G7-0284 | placed (§2 E16) |
| G7-0285 | placed (§2 E17) |
| G7-0286 | placed (§2 E16) |
| G7-0287 | placed (§2 E16) |
| G7-0288 | placed (§2 E18) |
| G7-0289 | placed (§2 E16) |
| G7-0290 | placed (§2 E16) |
| G7-0291 | placed (§2 E16) |
| G7-0292 | placed (§2 E14) |
| G7-0293 | placed (§2 E13) |
| G7-0294 | placed (§2 E13) |
| G7-0295 | placed (§2 E16) |
| G7-0296 | placed (§2 E18) |
| G7-0297 | placed (§2 E16) |
| G7-0298 | placed (§2 E71) |
| G7-0299 | placed (§2 E70) |
| G7-0300 | placed (§2 E66) |
| G7-0301 | placed (§2 E23) |
| G7-0302 | placed (§2 E25) |
| G7-0303 | placed (§2 E25) |
| G7-0304 | placed (§2 E23) |
| G7-0305 | placed (§2 E28) |
| G7-0306 | placed (§2 E31) |
| G7-0307 | placed (§2 E33) |
| G7-0308 | placed (§2 E21) |
| G7-0309 | placed (§2 E71) |
| G7-0310 | placed (§2 E58) |
| G7-0311 | placed (§2 E16) |
| G7-0361 | placed (§2 E20) |
| G7-0402 | placed (§2 E74) |
| G7-0403 | placed (§2 E51) |
| G7-0404 | placed (§2 E72) |
| G7-0405 | placed (§2 E73) |
| G7-0406 | placed (§2 E86) |
| G7-0407 | to Bindu Feed (§6) |
| G7-0408 | placed (§2 E80) |
| G7-0409 | placed (§2 E81) |
| G7-0410 | placed (§2 E76) |
| G7-0411 | placed (§2 E77) |
| G7-0412 | placed (§2 E75) |
| G7-0413 | placed (§2 E78) |
| G7-0414 | placed (§2 E59) |
| G7-0415 | placed (§2 E96) |
| G7-0416 | placed (§2 E38) |
| G7-0417 | placed (§2 E79) |
| G7-0426 | placed (§2 E28) |
| G7-0427 | placed (§2 E27) |
| G7-0428 | placed (§2 E29) |
| G7-0429 | placed (§2 E22) |
| G7-0430 | placed (§2 E30) |
| G7-0431 | placed (§2 E31) |
| G7-0432 | placed (§2 E32) |
| G7-0433 | placed (§2 E24) |
| G7-0434 | placed (§2 E11) |
| G7-0443 | not this world — the-33 (Pulse layer rooms 9–32) |
| G7-0447 | placed (§2 E28) |
| G7-0448 | placed (§2 E07) |
| G7-0457 | placed (§2 E85) |
| G7-0463 | placed (§2 E08) |
| G7-0464 | placed (§2 E08) |
| G7-0465 | placed (§2 E08) |
| G7-0466 | placed (§2 E08) |
| G7-0467 | placed (§2 E08) |
| G7-0468 | placed (§2 E08) |
| G7-0469 | placed (§2 E08) |
| G7-0470 | placed (§2 E08) |
| G7-0471 | placed (§2 E21) |
| G7-0472 | placed (§2 E20) |
| G7-0473 | placed (§2 E20) |
| G7-0474 | placed (§2 E20) |
| G7-0475 | placed (§2 E20) |
| G7-0481 | placed (§2 E51) |
| G7-0484 | placed (§2 E15) |
| G7-0488 | placed (§2 E27) |
| G7-0489 | placed (§2 E18) |
| G7-0530 | not this world — memory (Portrait play layers; fed by PlayStore E17) |
| G7-0678 | placed (§2 E68) |
| G7-0726 | placed (§2 E17) |
| G7-0727 | placed (§2 E16) |
| G7-0728 | placed (§2 E34) |
| G7-0910 | placed (§2 E34) |
| G7-0911 | placed (§2 E68) |
| G7-0912 | placed (§2 E68) |
| G7-0913 | placed (§2 E68) |
| G7-0914 | placed (§2 E68) |
| G7-0921 | placed (§2 E04) |
| G7-0930 | placed (§2 E04) |
| G7-0971 | placed (§2 E51) |
| G7-0989 | placed (§2 E20) |
| G7-0990 | placed (§2 E18) |
| G7-0991 | placed (§2 E27) |
| G7-0992 | placed (§2 E53) |
| G7-0993 | placed (§2 E03) |
| G7-1022 | placed (§2 E62) |
| G7-1023 | placed (§2 E34) |

### Script check

```
$ python3 -I coverage.py
slice rows: 554  unique ids: 554
dispositions: {'placed': 472, 'not this': 39, 'to Bindu': 39, 'rejected —': 3, 'merged into': 1}
missing (no disposition): 0 []
ids cited in §2 but not in slice: 0 []
```
