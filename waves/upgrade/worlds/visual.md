# The visual language — upgrade map (cross-cutting world)

Slice: `waves/upgrade/index/by-world/visual.jsonl` (507 rows, all read). Rulings 1–17 and the settled points apply throughout.
This file is the one place a builder needs for **how every world looks, moves and touches**: which of the thirteen studio languages
each world wears, every token as a SwiftUI value, the palette engine, the breath of each enclosure and world, the depth laws (chrome
thins, colour warms to ember), the point in every world, type and the sixteen faces, canon-colour precedence, light levels against
Design, Reduce Motion and contrast floors. World files own *what* happens in each world; this file owns *how it is drawn*.

Register shorthand: R01 = `waves/register/01-homes.md`, R02 = `02-rite-axis-field.md`, R03 = `03-mandala-worlds-layers.md`,
R04 = `04-briefs-audits-frames.md`, R05/R06 chakra corpus/skills, R08 dances, R09 field scores, R11/R12 padakarshini, R13
rupakarshini, R14 aistrangegame, R15 Airtable Map, R17–R22 code readers. Code paths are under `iOS/Bindu Mandala/`.

---

## 1 · The world

### 1.1 What it is, in his words and Design's

- **His law for every surface** (C-1307 via XMB-11, R04:353): *action recedes with depth* — the Zero Gap: labels at the outer ring,
  none at the centre. C-1306 (R07:840–843): the one particle "moves because it loves" — the point is the same point everywhere.
  C-1215 (R07:525–528): "we're sort of taking stuff out rather than trying to add stuff back in" (reduce to the core) and his
  customers' dislike of generated imagery — real marks only, never generated pictures.
- **Design's bar** (R02:1448–1456): "The interface is the teaching." "Atmosphere, not page. Dark ground, warm light from within, dust
  motes, generous negative space, one quiet identity line." "**Nothing in this app is a static screen.** Every surface is generated
  from the Śakti herself — her ring, cluster, tattva/element, and the hour of day." "Do not hand-pick colors per screen."
- **Design's tone** (DS-02, R04:54): "Devotional. Embodied. Quiet luxury. Sacred geometry precision… entering a temple through a side
  door — intimate, not grand… Not a meditation app. Not a wellness brand."
- **Charter II laws** (BC-05…08, R04:589–592): the room test; motion carries meaning; the Bindu-light is a character; **light stands
  in the air** (glows, cores, additive lines, membranes, transmission, caustics, gems, bloom, HDR; **colour warms with depth**; each
  world its own light); every place moves as what it is.
- **rupakarshini's laws** (R13:51–54): 1 one particle, never re-made · 2 the ground is a position · 4 every crossing passes through
  something · **5 colour warms with depth — gold at the surface … ember red at the centre** · **6 interfaces thin with depth — chrome
  100 → 80 → 60 → 25 → 0 %** · **7 breath slows toward the centre … an existing experience keeps its own breath** · 8 every place moves
  as what it is (`--dur-breath` is a default, not a law) · **9 type changes where a crossing means something** · 12 figures are pure
  functions of time and data · 16 a hold is the hold it was designed to be. Borrowing law (R13:65): "**Mechanics cross freely;
  grounds and voices never do.**"

### 1.2 The experience, second by second — what the eye meets across a crossing

1. **Launch (Home).** Black for one beat; a seed kindles at 1.65 s in pale gold, the bloom opens on `Animation.waking` (2.85 s,
   curve 0.22, 1, 0.3, 1) into the silence ground `#040104`, which lifts to `#0D0508` at the rim. The point sits at the centre as an
   **ember** (`#C0392B` core, `#8B1A2A` halo) breathing on 4 s (scale 1 → 1.20). Haptic *kindle* (intensity .6 / sharpness .2) at the
   kindle frame. Chrome at 0 %: Home is the centre (depth 1).
2. **Touch the point → the menu** (a constellation of world-points, each a dot in its world's own ground colour, the point at the
   middle). Choosing a world: the chosen dot crowns, tethers to centre, and **the crossing blooms from the touch point in the colour of
   the world entered** (Veil-light 1.05 s or Veil-dark 1.5 s, §1.6). The type changes only now, mid-bloom, when the scrim is at its
   hold (45 % of the duration) — never on a visible frame.
3. **Arriving.** "Dark first, then the room": 0.4 s at the destination's deep ground, then 1.4 s rise of its light. The world's
   own breath starts on the shared epoch (phase continuous across launches). Chrome steps to the world's depth level (§1.8). The point
   rides to its place in the new world, recoloured by depth (§1.9) — it is never re-made.
4. **Going deeper inside a world** (ring inward, zoom, descent): colour warms one step toward ember; chrome thins one step; breath
   slows (except the Bindu, the slow heart, 4 s); sound quiets. Every step is reversible: touching restores chrome for 4 s.
5. **Leaving** a Śakti's room: her Siddhi lingers on the whole app as a filter that decays over 180 s (k² curve) — lighter, heavier,
   sharper or wider by her ring — **never named** (ruling 15).

### 1.3 One language per world (the thirteen studio languages placed)

Each world root carries `.environment(\.chassis, …)`; "the world picks one, never two at once" (R13:791). Where a world has an inner
room in a second language, entering it is a designed crossing (law 9) and only one language is on screen at any moment.
**Colour precedence** inside every language: Mandala/Map canon colours win (§1.11).

| # | World | Language (primary) | Inner crossing into | Ground(s) | Display face · UI face |
|---|---|---|---|---|---|
| 1 | Home (the Bindu) | **mandala · silence** | — | `#040104` centre → `#0D0508` rim | Cormorant Garamond Light · system small caps |
| 2 | Today / the Rite | **feed · prayer** carrying her mandala palette | **linen** (the morning page before noon) | `#050408` under her ground `mix(#0D0508 80 %, hue 20 %)` | Cormorant (name, voice italic) · system caps; Instrument Serif · Geist on linen |
| 3 | The Mandala (held yantra + Veil) | **mandala** | — | indigo well `#0A0611 → #050308 (60 %) → #030105`; Veil `#080307` | Cormorant · system caps |
| 4 | The nine rings | **mandala · ring-n** | — | ring wash / deep (table §1.4.4) | Cormorant · system caps |
| 5 | Her Home | **mandala · per-being (S13 Room)** | — | her ground / deep; "the room is its light" | Cormorant |
| 6 | Her Presence | **feed · identity header** on her mandala palette | — | her deep ground | Cormorant 26 (Medium) · system caps |
| 7 | The Climb (Axis) | **ascent** | — (weather bands 1–6 are the Axis's own dark) | Axis fog → ascent sky `#D8B658 → #FFFFFF` | Cormorant light italic · Inter 11 caps |
| 8 | The 33 (the braid) | **chakra** (extended to all 33) | — (the Bindu room uses chakra's cream ground) | night `#0C0A12` → `#020205`; cream `#F8F1DF` | Cormorant caps · DM Sans |
| 9 | A Strange Game | **leela** (board) | **play** (each game its own world) | stone `#E3E9EA` / slate `#1B2230`; cloth `#0F4A50` | Lora · DM Sans → Gloock · Newsreader |
| 10 | The Modes | **field** | **candle** (Pūjā / evening offering) | void `#020208`; candle `#100A08` | Lora italic 300 · DM Sans · DM Mono; Cinzel |
| 11 | Time | **mandala · relit by the hour** | **linen** (morning page) | junction skies over `#0D0508` | Cormorant + Roman-numeral caps |
| 12 | Memory | **being** (day / dusk) | **candle · sheet** (the printed record) | `#FAF6EE` / dusk radial `#2B261F → #19160F` | Fraunces · Spectral |
| 13 | The Well | **lalita · under** | **learning · dark** (the Descent) | `#0E0C14 → #07060C`; `#0A0806` | **Newsreader 300 italic** (changes at the crossing) |
| 14 | Beneath | **blink** (fifteen temperatures) | **learning · dark** (the Descent) | fifteen near-blacks (§1.4.14) | Lora · DM Sans caps |
| 15 | The Relationship Field | **lalita · night / paper** | — (a Person = paper room) | `#1A1826`; `#FBF8F1` + person hue | Instrument Sans |

All thirteen languages are used: mandala (1, 3, 4, 5, 11), feed (2, 6), linen (2, 11), ascent (7), chakra (8), leela (9), play (9),
field (10), candle (10, 12), being (12), lalita (13, 15), learning (13, 14), blink (14).

### 1.4 Every token, ported to SwiftUI — per world

Conventions: `Color(hex:)` exists (`Theme/Color+Tokens.swift`). Fonts through `AppFont` so Dynamic Type holds
(`Font.custom(name, size:, relativeTo:)`, `Theme/Fonts.swift:65–78`). Sizes are pt at Dynamic Type "Large". Every text size below
the floor in a source (8–10 px) is raised to **11 pt** (§1.13). Motion curves are `Animation.timingCurve(c1x, c1y, c2x, c2y,
duration:)`. Haptics are Core Haptics events `(intensity / sharpness)`.

**Shared motion constants** (`Theme/Motion.swift`, new; R13:834–846):

| Name | Curve | Duration | Used for |
|---|---|---|---|
| `veilLight` | (0.22, 0.61, 0.36, 1); bloom (0.16, 1, 0.3, 1) | 1.05 s | everyday crossing into a light world |
| `veilDark` | (0.5, 0, 0.15, 1) | 1.5 s | crossing into a dark world |
| `descent` | (0.66, 0, 0.24, 1) | 2.35 s | Home→Well, Home→Beneath, first entry beneath |
| `waking` | (0.22, 1, 0.3, 1) | 2.85 s | launch |
| `surfacing` | (0.22, 0.61, 0.36, 1) | 0.95 s | return after time away |
| `sheetRise` | (0.22, 1, 0.36, 1) | 1.1 s (board hop 0.55 s) | paper sheets, cards |
| `verb` | (0.16, 1, 0.3, 1) | 0.6 s (a world arriving in beats 1.1 s) | verbs, mode arrivals |
| `blinkLids` | (0.62, 0.02, 0.4, 1) | 0.66 s | the blink crossing (Home → Rite) |
| `lightReach` | (0.2, 0.7, 0.2, 1) | 2.6 s | light reaching text |
| `nameFade` | (0.25, 0.1, 0.25, 1) | 1.6 s (1.4–1.8) | names arriving |
| `rkOut(d)` | (0.22, 0.61, 0.36, 1) | 0.25 s default | small UI |
| `soft` | (0.4, 0, 0.2, 1) | 0.5 s | reveals (height 0.5 s + opacity 0.4 s, R14:899) |

Pace pairs (R13:847): `still (0.5 s, rise 16)` · `measured (0.25 s, 24)` · `quick (0.18 s, 32)`. Space scale:
`[4, 8, 12, 16, 24, 32, 48, 64, 96]`. Durations: fast .15 · base .25 · slow .5 · hold 700 ms (R13:686–691).

**Haptic family** (`Theme/Haptics.swift` rewritten on Core Haptics; today it holds only `light/medium/soft` UIImpact, R17:705):
`tick .3/.4` · `word .3/.4` · `heart .5/.3` · `hold` continuous .15 → .6 at sharpness .3 (fades on early release) · `completion
.8/.5` · `descent .9/.15` at 55 % of the Descent · `kindle .6/.2` · `stillPoint .25 → .15 → none` · `crawl` (earth / Ring 1: three
transients .2/.1 at 90 ms intervals, C-1170). "Warm, never sharp" (no sharpness above .5); a haptics-off switch; **withdrawal at the
deepest place** (no haptic at depth 1 other than the Still Point fade).

#### 1.4.1 Home (the Bindu) — mandala · silence

| Token | Value |
|---|---|
| ground | radial centre (0.5, 0.46): `#040104` at 0 → `#0D0508` at 1.0 |
| surface / veil | `#080307` |
| ink · ink-2 | `#F2E8D9` (17.13:1 on `#040104`) · `#968D85` (6.18:1) |
| gold (voice, sig) | `#C9963F` (7.60:1) |
| point at centre | core `#C0392B`, halo `#8B1A2A` → `#A4343E` lit; 10 pt core (BinduPoint), breath 4 s scale 1 → 1.20 |
| motes | gold `#C9963F`, rise 16–30 s; dawn/unmet 15 motes rise in today's colour, met → settle bone `#D8D2C4` |
| type | greeting Cormorant Light Italic 26 pt (voice); date + moon: Cormorant Light 15 pt tracked .18 em, Roman numerals; small caps labels 11 pt .22 em |
| spacing | yantra (CentreYantra = Design FullYantra ±150 units) keeps ≥ 200 pt negative space; status bar 60 pt; safe top 54 |
| motion | `waking` on launch; `surfacing` on return; deep zoom (ruling 9) on `descent` curve at 2.35 s per enclosure step |
| haptics | kindle at launch; heart on touching the point; stillPoint at the deepest zoom |
| breath | Bindu 4 s; world glow 12.5 s (§1.6) |
| chrome | 0 % at rest (depth 1); a faint "surface" mark at 25 % α on touch |

#### 1.4.2 Today / the Rite — feed · prayer, her palette

| Token | Value |
|---|---|
| ground | prayer `#050408` full-bleed, her ground `mix(oklab, #0D0508 80 %, accent 20 %)` above it in the element backdrop; groundDeep `mix(#070205 88 %, accent 12 %)` |
| accent family | `accent = hsl(h, s, l)` · `bright = hsl(h, min(s+10, 88), min(l+18, 78))` · `soft = accent α .62` · `faint = accent α .24` · `glow = hsl(h, s, min(l+6, 70)) α .36` · `ink = hsl(h, s×.55, 12)` (R02:442–455) |
| relit | dawn / noon / dusk / night / new moon deltas (§1.5.3) |
| "I feel her" pill | her `accent` at full saturation — still **the only saturated CTA in the app** (UXA-08); label ink chosen by contrast (§1.13) |
| type | her name Cormorant Light **64 pt** (56 on SE, 72 max — "scale is reverence"); quality Cormorant gold 22 pt; somatic Cormorant Light Italic 20 pt; phonetic / labels system caps 13 pt .2 em; low line 12 pt |
| motion | nine arrival beats 0.10 … 1.25 s (DayLight `ArrivalBeat`), staged arrival 1.3 s with 10 pt rise; sigil fades in 2.4 s after 0.2 s; Recognition: name 1.8 s at +0.3, phrase 1.8 s at +0.9, logged 1.0 s at +2.6, reciprocity 1.4 s at +4.1; ripples 4 s at 0 / 1.1 / 2.2 / 3.3 |
| breath | feed's 0.1 Hz (10 s) under everything, started at load, never restarted; her element backdrop breath (fire 11 · water 13 · air 12 · ether 9.6 · earth 15 · light 7.6 s); sigil spin 140 + (hue mod 60) s; the Rite's sigil Bindu keeps its 5.5 s (law 7) |
| haptics | heart on "I feel her"; completion at "and she felt you back"; word on each beat |
| linen morning (before noon) | ground `#F6EFE2`, surface `#FBF6EB`, ink `#25201A` (14.12:1), ember `#B8593A` (graphic) / `#AF5132` (text 4.52:1); Instrument Serif 33 pt title, Geist 17 pt body, Geist Mono 11 pt; fade 0.6 s |
| chrome | 100 % (surface world, depth .25 → step 80 %) — see §1.8 |

#### 1.4.3 The Mandala — mandala

| Token | Value |
|---|---|
| sky | indigo well radial centred at 0.44 h: `#0A0611` → `#050308` (60 %) → `#030105` rim; day's glow at 80 % × 55 % fading by 66 % (MandalaSky.swift) |
| starfield | 150 stars, LCG seed 20260711, radius 120–740, size .5–2.3, opacity .12–.62, every 5th gold, 40 % twinkle (5 + d s) — code has 120 / 20240517, wrong (G7-0030) |
| yantra strokes | gold `#C9963F`, stroke ×1.7, **no 0.9 / 0.7 dimmers**; bhūpura `#CF9443` (gold-warm); Bindu crimson `#8B1A2A` radial |
| seats | radii focus 7 · today 6 · family 5.5 · felt 4.4 · unfelt 3 pt; hit area 44 pt each |
| status as light | mapped .22 · exploring .44 · active .76 · embodied 1.0 (relationship, never a grade) |
| Veil | `#080307` sheet, rows ring glyph · numeral · name · threshold line |
| type | title "Śrī Yantra" Cormorant Light 34 pt; sub system caps 11 pt .32 em; seat names ≥ 11 pt (fixes 9 px) |
| motion | shimmer 8 s; Bindu breath 4 s ×1.28; today's petal 3.5 s (brightness 1 → 1.55, shadow 6 → 14) ; chime flash 1.7 s |
| haptics | tick on seat; heart on today's seat |

#### 1.4.4 The nine rings — mandala · ring-n

Per ring: `hue` (Atmosphere), `wash = mix(oklab, #0D0508 80 %, ring 20 %)`, `deep = mix(#070205 88 %, ring 12 %)`, `text` = ring hex
lifted toward cream until ≥ 4.5:1 on its wash (computed this session):

| Ring | Hex | wash | deep | text on wash | Fog (WORLDS) | density | veil | tempo | breath | chrome |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 amber 35° | `#CE9546` | `#2D1C15` | `#190D0D` | `#CE9546` 6.22 | `#1D1206` | .0125 | 0.00 | 1.00 | still (0) | 100 % |
| 2 cluster (inner 43°) | `#D4A017` | `#2E1E12` | `#1A0E0B` | `#D4A017` 6.75 | `#0A1330` | .017 | .12 | .82 | 3.5 s | 80 % |
| 3 rose 341° | `#C46482` | `#2C141D` | `#190810` | `#C56583` 4.54 | `#2A0C06` | .021 | .24 | .62 | 8 s | 80 % |
| 4 crimson 353° | `#BE3747` | `#2B0E14` | `#18050B` | `#CC5D61` 4.51 | `#0B1219` | .014 | .36 | .72 | 9 s | 60 % |
| 5 coral 18° | `#D37045` | `#2E1614` | `#1A090C` | `#D37045` 4.97 | `#06180E` | .018 | .48 | .66 | 11 s | 60 % |
| 6 teal 194° | `#4490A7` | `#1B1C22` | `#100C13` | `#4490A7` 4.69 | `#1A0409` | .022 | .60 | .50 | 13 s | 25 % |
| 7 wine 322° | `#B04F8C` | `#29111E` | `#170711` | `#BB6597` 4.54 | `#D8D2C4` (milk) | .034 | .72 | .44 | 15 s | 25 % |
| 8 red 2° | `#D62F29` | `#2F0E10` | `#1A060A` | `#DE5244` 4.53 | `#0F0B04` | .015 | .86 | .36 | 18 s | 25 % |
| 9 white-gold 46° | `#E7CA6A` | `#31241B` | `#1C1110` | `#E7CA6A` 9.33 | `#141008` | .009 | 1.00 | .28 | 4 s | 0 % |

Fog density × (1 + veil × 0.55); tempo scales the world's animation clock only, never her adaptation clock (R01:48–58). Gem
diffusion per ring (light behaviour, never hue): 1 .20 topaz · 2 .30 sapphire · 3 .45 coral · 4 .15 diamond · 5 .25 emerald · 6 .55
ruby · 7 .95 pearl (no directional light) · 8 .10 cat's eye (one hard travelling band) · 9 .70 all gems. Type: ring name Cormorant
Light 28 pt; ordinal system caps 11 pt .32 em gold α .85; sub Cormorant Italic 15 pt α .68. Haptics: crawl on Ring 1 (earth); tick
crossing each enclosure. Bell per enclosure inward 392 → 196 Hz, silent outward (sound world).

#### 1.4.5 Her Home — mandala · per-being

Her palette (as Today) at her ring's depth; seat-interior light `farL = 20 + 62·a` (lightness 20 % at entry → 82 % adapted),
`farHot = hsl(h, s × .42, min(98, farL + 26))`; blur `2.2 + 5(1 − a)` and far `3 + 16(1 − a)` ("the image sharpens as the eye adapts");
room bg `#040103`; motes `hsl(h, 60 %, 86 %)` visible only when a > .2. Type: her name Cormorant Light 38 pt (Devanāgarī mask sweep
3 strokes), region line system caps 11 pt (fixes mono 8.5–9 px), quality Cormorant Italic 15 pt. Beat dots 4 × 4 pt, current 16 pt
wide gold, done gold .6, pending cream .25 (beats, not a score). Breath locked to her bīja syllable (pulse, particle rhythm,
light-breath — G1-0046) on the world clock × her ring's tempo. Haptics: hold continuous on the threshold; descent at the shaft;
completion at the second adaptation. Light band: §1.12.

#### 1.4.6 Her Presence — feed identity header on her palette

Disc 96 pt in her accent with her ring glyph (no figure — disc + glyph only); name Cormorant 26 pt Medium; role line "Quality · what it
means" system caps 12 pt .18 em; principle Cormorant Italic 18 pt. Colour through staying: at rest grey (saturate .32, brightness .70);
press-and-stay on the ∞ path 2.9 s raises her colour to full; words gather past l = .55; early release drains 750 ms. Each presence its
own clock 6.8–16.5 s; Bindu ember 3.2 s; Lalitā the only one that turns (28 s). Recognition natures (six) answer in her element. Haptics:
hold continuous; completion at full colour.

#### 1.4.7 The Climb (Axis) — ascent

| Token | Value |
|---|---|
| bands 1–6 | the Axis's own weather (WORLDS fog per ring, blended by climb/30, density × (1 + swallow × 1.6)); env gradient `#3A3A44 → #1A1A20 → #0A0A0C`; ACES tone map exposure 1.04 |
| bands 7 → summit | ascent sky: RadialGradient centre (0.5, 1.10), stops `#D8B658 0` · `#C9A84C .18` · `#D4B76A .32` · `#E6D29A .50` · `#F4E9CF .68` · `#FAF6EC .82` · `#FBFAF6 .92` · `#FFFFFF 1`; horizon line `#FFFFFF` drawn once |
| ink | cream `#F2E8D9` while mean ground luminance < .6; ascent ink `#3A2E15` (11.00:1 on `#F4E9CF`) / `#4A3C1E` / `#5A4B28` above; switch is a 0.95 s `surfacing` cross-fade |
| door | `#B8322B` (4.93:1), deep `#5F1814`, hot `#D94A3E`; rises at 20 s, "Tap to cross" at 22 s, crossing scale 1 → 5.5 |
| dyad light (body 10–19) | two colours in productive tension per centre (§1.11.3) |
| type | Cormorant Light Italic 26 / 22 / 20 pt (each line one shade lighter: focus-not-fade); "Go." 44 pt; Inter 11 pt uppercase .28 em hints; 33 vertebrae as 1 pt ticks with a ring at 18 |
| motion | rise 3.4 / 30 bands per s, settle .06; `lightReach` 2.6 s; presence pulse rates .22 met / .9 / .4; crown breath .86 + .14 sin(t·.3) |
| haptics | hold continuous on membranes (Shadow 3→4, Armin 6→7); completion on giving; stillPoint at the summit stillness gate (4.6 s) |

#### 1.4.8 The 33 — chakra (all 33)

| Token | Value |
|---|---|
| ground | night `#0C0A12` under a twinkling starfield, deep `#020205`; surface `mix(#0C0A12 90 %, #F0E8DC)`; line `rgba(240,232,220,.10)` |
| room hue | **Map Color Hex** (`fldAsbQnAo3Fk2QHF`) for every room; six-step contract derived from it in oklab: `-bright` (+18 L) · `-glow` (α .36) · `-tint` (mix 12 % into ground) · `-border` (α .30) · `-soft` (α .62); scene ladder deep/mid/light/warm |
| ink | `rgba(240,232,220,.92)` (13.67:1), ink-2 `#99948F` (6.54:1 — "cream at 50 % is 4.58:1 — keep ≥ 55 %"); voice `#C9A84C`, spark `#E8C568` |
| grounds | child (amber `#C47820`, ink `#F0B85A` 10.97:1), mirror (silver `#C8CCD8`), cream "the Bindu room" (`#F8F1DF`, surface `#EADCBA`, ink `#3A2E15`) |
| persistent dot | `#C0392B`, 6 pt, α .30, top 16 / right 16, every panel; wakes at 32 s of each closing |
| type | Cormorant Light caps wide-tracked (room name 34 pt, .06 em); DM Sans 11 pt uppercase .16–.42 em (raised from 8–10 px) |
| motion | orb breath 4 s (scale 1 → 1.07, each 3.8 s + offset); turnA 80 s, turnB 50 s opposite; emerge rise 12 pt stagger .06 s, fade .4–.9 s; next room's hex rises from the bottom edge at 24 s; progressive luminance P1 5 % → P8 90 %, P9 white |
| haptics | gate holds 3500 / 3200 / 2800 / 2600 / 2400 / 2000 / 1800 / 1500 ms (root → soul), `hold` continuous; completion "— ENTERED" |

#### 1.4.9 A Strange Game — leela board, play games

Leela light: stone `#E3E9EA`, paper `#F2F5F4`, line `#C5CFD2`, ink `#1D2631` (12.45:1), ink-2 `#56616C` (5.15), token teal `#0F7C7A`
(text `#007573` 4.52), arrows gold `#B08A33`, snakes violet `#6A4C9C` (dotted). Leela dark: slate `#1B2230`, card `#232B3A`, ink
`#E6ECEE`, token `#3FB8B4` (6.62), arrows `#D6B25C`, snakes `#A58ADB`. Board type Lora 17 / DM Sans 13. Hop 550 ms lift 8 pt; snakes
slower ("a lesson, not a fall"). A Leela landing → **colour flood** into that chakra's room hex (0 → .92 over .70 s, glyph ×11) then
dark first, then the room. Play: cloth `#0F4A50` with 5 pt cross-hatch (white .035 / black .05), surface `#0B3E43`, ink `#F3ECDD`
(8.44:1), ink-2 `#A7C6C1`, marigold `#F2B632`, rise gold `#F6D27A`, lilac `#C2B2F4`; paper `#F4EBDA` / ink `#2B2621` / quiet
`#6E655B`; ten sketch grounds choose `#3B2A55` · talk `#1D2F5E` · manage `#1F4D2B` · join `#6E4A1E` · turn `#7A2E1E` · trace
`#22205A` · still `#0E5566` · beat `#5E1B2B` · release `#123A4A` · seal `#6A5A3E` — opening a game recolours the whole ground over 1.2 s;
type Gloock display 40 pt · Newsreader 17 pt; `sheetRise` for what you receive. Lalitā's field: rings 2–8 gold α .07–.10, garland of
102 beads turning once per 180 s, her point accentRed 120 pt / gold 40 pt breathing 9 s. Haptics: tick per hop, word on a card turn.
"Nothing keeps score."

#### 1.4.10 The Modes — field, candle for Pūjā

Field void `#020208` / `#05050F`, line `rgba(255,255,255,.08)`, ink Bindu cream `#F5E2D6` (16.49:1), ink-2 `#887D79` (5.18), voice coral
`#D46453` (5.66), spark gold `#C4A862`. **Each mode tints the screen `hsl(h, 55 %, 68 %)`** by its element (§1.5.4). Type: verb Lora
Italic 300 at 64–84 pt; DM Sans 13 pt; DM Mono 76 pt readouts, badges 11 pt .16 em; Cinzel ceremony. Radius 10. `verb` curve 0.6 s.
Mauna captions at 7 / 14 / 21 / 28 s; Mauna Bindu breath 6 s. Dusk variant (Georgia → Lora): `#0C0906`, ink `#EDE0D0`, voice
`#E07A5F`; Mist (SF Pro → DM Sans): `#060D14`, ink `#D8E8F0`, voice `#6BA3BE`. Candle (Pūjā): ground `#100A08`, surface `#1A1410`,
ink parchment `#E8D9B8` (14.08:1), ink-2 `#928672`, the one gold `#C9A84C`, glow `#E8C162`, unreached `#6B5A3E` (decor) / `#8E7D5F`
(text 4.91); yantra stroke .55, bright `rgba(232,193,98,.85)`, gold hairline frame; Cinzel lowercase tracked .32 em (names) / .42 em
(seal), Lora italic arrival lines; **no sound**. Haptics: hold continuous (pūjā gathering), completion on release into the point.

#### 1.4.11 Time — mandala relit by the hour, linen morning

TIME_VARIANTS (R03:205–212) drive the ground: dawn bg `#0A0610` ambient `rgba(232,150,80,.13)` · noon `#060104` `rgba(201,150,63,.07)` ·
dusk `#0A0508` `rgba(199,90,80,.13)` · night `#020308` `rgba(140,180,220,.08)` · new moon `#020001` `rgba(139,26,42,.22)`; Bindu colour
dawn `#A8341F` · noon `#8B1A2A` · dusk `#7A1620` · night `#8B1A2A` · new moon `#8B1A2A` at ×1.6; motes 8 / 6 / 9 / 12 / 3. Moon glyph:
outline `rgba(242,232,217,.30)` w .8, lit path α .82, terminator `rx = |ill − .5| × 2 × r`. Five clocks as five rings with one lit bead.
Type: Cormorant Light 15 pt + Roman-numeral caps .18 em. Linen morning page as in §1.4.2. Haptics: tick per clock ring turned.

#### 1.4.12 Memory — being, candle sheet

Day: ground `#FAF6EE` (paper grain), surface `#F4EFE6`, ink `#2E2A24` (13.23:1), ink-2 `#5A5349` (7.04), voice sage `#7C8F6E` (graphic),
sig `#5F7355` (4.79), spark crimson Bindu `#BE5A4E`, deep `#19160F`. Dusk: radial(130 % 100 % at 50 % 18 %) `#2B261F → #211E19 (55 %)
→ #19160F`, ink `#F4EFE6`, ink-2 `#9E9991`. Six field lights: gaia `#7A9B6E` · sakshi `#6E8597` · grace `#C2918E` · bindu `#BE5A4E` ·
hold `#928A7E` · chant `#C3A359`. Breath 8 s (6–9). Fraunces display 33 pt (opsz 72), Spectral 17 pt body. Printed record on candle
sheet `#FBF5E6`, ink `#2A1F14`, brick `#9D4439`. Haptics: word on a day glyph; completion at "Held." / "Seen." / "Kept." (the
Settle, 1.4 s).

#### 1.4.13 The Well — lalita under, learning dark

Under: ground `#0E0C14`, surface `#07060C`, ink-2 `#B9B2C9` (9.5:1), muted `#8D86A0`, voice / sig `#8E7AB5` (moonlit, oklch .62 .09
300); tempo 1200 ms; **display + UI switch to Newsreader 300 Italic** at the crossing (24 pt reading, 17 pt UI). Learning dark: `#0A0806`
/ `#14100A` / `#080605`, ink `#F4ECDA`, ember `#DD3E16` (4.54), gold `#F3B05A` (10.63), white-hot `#FFFCF4`; seed radial `#FFFCF4 →
#F7C478 (46 %) → #DA3B12`. Descent 2.35 s: paper lifts, dark wells up, ember (9 pt `#F3B05A`, glow 22 / 48 pt) crosses the seam at 55 %
with haptic descent. The door resists: ≈1.25 s hold, release early and it refuses. Haptics: hold continuous; descent at the seam.

#### 1.4.14 Beneath — blink temperatures

Near-black under a 2 % fractal-noise grain; one off-centre glow; cream at four set opacities (ink `#DBD5CC` 88 % = 13.57:1, ink-2
`#807E79` 50 % = 4.88:1). Fifteen section temperatures, inward warming to the point: `#0A0A0C` · `#09090E` · `#0C0904` · `#07090E` ·
`#080808` · `#0C0A07` · `#0E0B09` · threshold `#0A0A0C` · `#0A0A0C` · `#09090E` · `#0D0907` · `#080A0E` · `#090B09` · `#0C0A08` ·
`#0F0B09`. Ember `#7A2F14` / lit `#94472C`; gold answer `#C8A96E`; flash gold / white / lavender `#C9A8E8` in ≥ 250 ms steps. Type Lora
19 pt reading, DM Sans 11 pt caps tracked 3 pt. Eyelids open only on the inhale after ≈12 s stillness (`blinkLids` .66 s). Haptics:
stillPoint at the Still Point; withdrawal at the deepest band.

#### 1.4.15 The Relationship Field — lalita night / paper

Night (the Morning): ground `#1A1826`, surface `#23202F`, ink `#ECE7DD` (14.17:1), ink-2 `#B6B0C2` (8.30), muted `#8D879D` (4.51),
voice dawn-cool `#B3B3DD`, sig moonlit `#8E7AB5`, spark walked gold `#F9E3A7`; tempo 600 ms. Paper (a Person): `#FBF8F1` / `#FFFFFF`
/ `#F4F0E7`, line `#E2DBCD`, ink `#2B2620`, ink-2 `#57503F`, muted `#756C5D`, voice hearth `#D39562`, person dot `oklch(.66 .13 H)` on
paper / `oklch(.75 .13 H)` on night, accent text `oklch(.50 .11 H)`, wash `oklch(.955 .03 H)`; tempo 350 ms. `personHue(name)`:
`n = n·31 + scalar` (UInt32 wrap), `hue = round((n × 137.508) mod 360)`. Instrument Sans: day title 40 / 500 −.02 em; names 26–32 /
500; body 17 / 400 lh 1.55; secondary 15; labels 12 / 500 caps .18 em. Radius 20 (sheets 28, pills 999, tiles 24). Spacing 4 · 8 · 12 ·
16 · 24 · 32 · 48. The three existing connections (ruling 11) take their Śakti's mandala hue, not a name hue: Gaia·Ahaṅkāra kp 31 (fire),
Ashrey·Nāma kp 40 (air), Ram·Ātmā kp 42 (light). Haptics: heart on a person; word on a thread.

### 1.5 The palette engine — one hue per Śakti

`Atmosphere.derive(from: Shakti, at: TimeVariant) -> Atmosphere` — **pure, deterministic, testable** (R02:1455–1456); already built
(`Theme/Atmosphere.swift:58–159`) — extend, never replace (R01:26).

#### 1.5.1 Seed

- Ring 1, 3–9: `ringHue(n)` — 1 (35, 58, 54) · 3 (341, 45, 58) · 4 (353, 55, 48) · 5 (18, 62, 55) · 6 (194, 42, 46) · 7 (322, 38, 50) ·
  8 (2, 68, 50) · 9 (46, 72, 66) (H, S %, L %).
- Ring 2 seeds from her **cluster** ("sisters of a cluster share a light as well as a corridor"): inner 29–31 (43, 78, 52) · tanmātra
  32–36 (13, 47, 56) · citta 37 (180, 49, 32) · stability 38–41 (140, 24, 38) · selfBody 42–44 (270, 26, 48).
- Key `selfBody` (the data spells `self` in shakti-data.js — the Swift enum is canonical; G1-0533).

#### 1.5.2 Jitter by position (position is identity)

`frac = ((kp × 2654435761) mod 1000 + 1000) mod 1000 / 1000`; `jitter(kp, range) = (frac − 0.5) × range`. Hue `h += jitter(kp, 14)`
(±7°); sigil rotation `round(jitter(kp, 44))` (±22°); composition bits `m = (kp × 2654435761) >>> 0`: flip `m & 1`, spin `(m & 2) ? 1 : −1`,
sigil scale .86–1.26, name tier `(m >> 6) & 3`. Without kp: the unjittered ring seed = "the world shown empty".

#### 1.5.3 Relit by the hour (five states)

Windows (settled C16 — FH-07 / the prototype, gap-free; FB-11 had gaps 8–11, 2–5, 8–9): **dawn 05–09 · noon 09–16 · dusk 16–20 ·
night otherwise · new moon** when lunar phase < .03 or > .97 (overrides night). Deltas applied to her (h, s, l):

| State | dh | lAdd | sMul | glowMul | tint | tintA | moteMul |
|---|---|---|---|---|---|---|---|
| dawn | +8 | +6 | 1.02 | 1.15 | `#3A1C22` | .12 | 1.0 |
| noon | −5 | +13 | .88 | .80 | `#242838` | .07 | 0.7 |
| dusk | +3 | +2 | 1.16 | 1.25 | `#331306` | .14 | 1.15 |
| night | −7 | −9 | 1.06 | 1.05 | `#060716` | .16 | 1.3 |
| new moon | −7 | −12 | .55 | .85 | `#04030C` | .18 | 0.5 |

`s = clamp(s × sMul, 6…90)`, `l = clamp(l + lAdd, 8…82)`, ground re-mixed with tint at tintA, glow α `clamp(.36 × glowMul)`.
**moteMul is read** (Design defect: never read, G1-0467) — mote count × moteMul. **Every consumer is relit**, including the Mandala focus
card and the Āvaraṇa Threshold (Design passed `null` there). New-moon row: prototype values for the four states; new moon extends with
Home's TIME_VARIANTS desaturation (petalSat .30, opMul .30 → sMul .55) and Bindu ×1.6.

#### 1.5.4 Six element layouts, ruling 4, and the ether hue

| Element | Archetype (structure, not recolour) | Backdrop (light placement) | Motes | Backdrop breath | Mode tint `hsl(h,55,68)` |
|---|---|---|---|---|---|
| fire | **ascension** — bīja column up, name low-centre, updraft | radial(95 % 62 % at 50 % 104 %, glow) + radial(120 % 40 % at 50 % −10 %, faint) + linear(`#080203` → groundDeep) | rise | 11 s | 25° `#DAA681` |
| water | **descent** — name high, prompt pools low, cool floor | radial(130 % 52 % at 50 % 106 %, soft) + linear(ground → groundDeep) | fall | 13 s | 210° `#81ADDA` |
| air | **horizon** — asymmetric, name leans, sigil offset | radial(78 % 96 % at 82 % / 18 % 40 %, glow) + linear 120° | drift | 12 s | 195° `#81C4DA` |
| ether | **veil** — name the vast backdrop, prompt afloat | circle at 50 % 44 %, glow + faint → 42 % | twinkle | 9.6 s | **280° `#BC81DA`** |
| earth | **foundation** — wide low sigil base, centred, stable | radial(140 % 48 % at 50 % 96 %) | still (.18 ↔ .42) | 15 s | 15° `#DA9781` |
| light | **radiance** — name inside a dominant living sigil | circle at 50 % 42 % soft → glow 26 % → clear 62 % + linear(groundDeep → `#060305`) | twinkle | 7.6 s | 50° `#DACB81` |

Ring → element: 1 earth · 3 air · 4 water · 5 fire · 6 ether · 7 air · 8 fire · 9 light; Ring 2 from her tattva, **with ruling 4's explicit
kp table first**: kp 31 Ahaṅkāra → fire · kp 40 Nāma → air · kp 42 Ātmā → light · kp 43 Amṛta → water; then `parse(tattva:)` with a new
`light` branch ("light", "sat", "pure being", "prakāśa") so Ātma can be light; unmatched → ether. `SensoryDoorway.forTattva` gains a light
doorway. (Today `Element.parse` maps all four to ether and has no light branch — G6-0924.)

**Ether hue settled: 280°.** Evidence: the field language has eight element hues and none for ether (G5-0531); the register names crown
280 / soul 265 as the nearest; air (195) and water (210) already hold the blue band and the ruling-4 elements fix fire 25 · air 195 · light 50
· water 210, so ether needs a hue no other mode owns; 280 is the crown's ("beyond form") and matches ether's composition (*veil — she
pervades*) and the Mandala Veil's violet-black `#080307`. Soul 265 is not used for ether (Ātma is light, ruling 4). In Mandala worlds the
element never sets hue — her ring/cluster seed does (ring 6 stays teal 194°); the 280° tint applies only where a world colours *by element*
(the Modes tint, element vocabularies in the dance). Earth 15 and the field's crown 280 / soul 265 / dissolution 190 stay for the dance's
element vocabularies only.

#### 1.5.5 Layers that carry the palette (built — keep, restore what was lost)

Rite layer stack (`Today/DailyRiteView.swift:198–224`): AtmosphereBackground → RiteSigil (LrSigil path for path, stroke ×1.7, blurred halo
blur 2.6·w, α .75, ×2.2 width, additive) → veil name (ether) → DustMotes 16 by element → DepthOverlay (vignette .55 radial 78 % 82 % at 50 %
46 %, grain fractalNoise .9 / 2 octaves α .11–.22) → staged column. LightField (`Theme/LightField.swift:146–203`) holds the backdrops layer
for layer. Port losses to restore (RD-07): ×1.7 strokes without the 0.9 / 0.7 dimmers; lrBackdrop collapsed; motes invisible on fire /
water days; air-lean lost; staged arrivals collapsed.

#### 1.5.6 Gem = behaviour, never colour; the after-effect

Gem diffusion (table §1.4.4) drives shadow softness, key vs ambient, glow falloff (`Homes/HomeGem.swift`, keyed by ring — fixes Design's
element-keying bug). Ring 7 has **no directional light** ("milky, diffuse, sourceless is the instruction"). After-effect on leaving her room
(ruling 15): `kind = ring.after` (1 sharper · 2 wider · 3 lighter · 4 wider · 5 sharper · 6 heavier · 7 wider · 8 lighter · 9 wider);
`k = 1 − age/180`, `e = k²`, 1.2 s linear transition; lighter: brightness 1 + .07e, saturation 1 − .06e, offset −3e pt · heavier:
brightness 1 − .06e, contrast 1 + .04e, scale 1 + .01e anchored bottom · sharper: contrast 1 + .1e, saturation 1 + .05e, scale 1 − .014e ·
wider: brightness 1 + .03e, scale 1 + .018e. Applied as one app-root modifier. **No line** — "her siddhi is still on the instrument" is
removed from `Views/Rooms/HerSiddhiLingers.swift`; 24 s → 180 s.

### 1.6 Breath — the single 8 s clock lifted

`BreathClock` keeps **one epoch** (`timeIntervalSinceReferenceDate`, same phase on every screen across launches) and drops **the beat
snap**: `period(grammar:score:)` returns the period unsnapped (`Theme/BreathClock.swift:44–53`; also `ShaktiFactsCache.swift:103`,
`RiteOpenings.swift:72–75`, `HeartRegister.swift:68–70, 122`). Phase `(1 − cos 2πt/p)/2` stays.

**Per enclosure (the nine metabolisms, Design's own periods — law 7: breath slows toward the centre, the Bindu a slow heart):**

| Enclosure | Token | Period | Detail |
|---|---|---|---|
| 1 Bhūpura | ground | 0 (holds) | "the earth underfoot does not breathe" |
| 2 sixteen petals — **home** | home | **3.5 s** today's petal | others by relationship: embodied 4.5 · active 6 · exploring 7.5 · mapped 10 s; stagger i × 0.18 s (code has 3 s — wrong) |
| 3 eight petals | petal8 | 8 s | Ring 3 petal .9 → 1.18 |
| 4 fourteen triangles | tri1 | 9 s | up-triangle peak 1.25 |
| 5 outer ten | tri2 | 11 s | 1.20 |
| 6 inner ten | tri3 | 13 s | 1.18 |
| 7 eight triangles | tri4 | 15 s | 1.15 |
| 8 primary triangle | root | 18 s | "almost still"; down-triangles 10 / 12 / 14 / 16 / 18 s |
| 9 Bindu | bindu | 4 s | scale 1 → 1.20 (Home) / ×1.28 (Mandala) |

**Per world:** Home 4 s (Bindu) · Today: feed 10 s under everything + element backdrop (7.6–15 s) + Rite sigil Bindu 5.5 s · Mandala:
the nine above + shimmer 8 s + seat flare 8 + (kp mod 13) s + each energy `3.4 + (kp mod 7) × .7` s with delay `−(kp mod 11) × .6` s ·
nine rings: their enclosure period × world tempo · Her Home: locked to her bīja (pulse, particles, light-breath derived from SYLLABLE)
on her ring's tempo; her live Score's breath if one exists (ScoreLightVeil, now unsnapped) · Her Presence: own clock 6.8–16.5 s, Bindu
ember 3.2 s, Lalitā turns 28 s · Climb: crown .86 + .14 sin(t·.3) (≈21 s), band clocks W1–W9 verbatim · the 33: orb 4 s, rings 80 /
50 s · Game: Lalitā's point 9 s, garland 180 s · Modes: Mauna Bindu 6 s, field verb 0.6 s · Time: the wall-clock 8 s phase (an
appointment on the UTC hour) — the only world that keeps 8 s · Memory: 8 s (6–9) · Well: tempo 1.2 s per step, Mirror tone held only
while holding · Beneath: breath read from the inhale (eyelids) · Relationship: night 0.6 s / paper 0.35 s tempo, presences own clocks.
**World glow** (all worlds): opacity 0 → .07 over 12.5 s (0.08 Hz) in the world's own colour — settled as an *opacity glow, never a
scale* (the site's 1.0035 scale is rejected: scaling sacred geometry breaks its precision; worlds.md WO:57–61 is the later rule); shares
the sound LFO 0.08 Hz.

### 1.7 Light stands in the air

Lifted (RD-11, BC-03, BC-07): clamp 0.86, wash ×0.09, veil −45 %, the "binding condition" (no free-standing light) — all gone; **HDR and
bloom on** in every SceneKit / Metal world; the three-moments VFX cap (XMB-10) and place-count cap (SH-03) are superseded by fullness.
Glow stand-in where there is no bloom pass: 128 × 128 radial texture (stops 0 inner, .32 inner α .55, 1 outer), additive, depth-write
off, fog off. Additive particles near the eye stack to white — **clamp point size 1–9 pt** and start fields 4 units out (invariant 7).
Frame safety: `dt` capped .05 s; a failing frame keeps the last good frame.

### 1.8 Interfaces thin with depth

Law 6 + the Zero Gap (C-1307): chrome opacity by depth step — **100 → 80 → 60 → 25 → 0 %**; labels at the outer ring, none at the centre.

| Depth step | Chrome | Where |
|---|---|---|
| 0 surface | 100 % | Game, Relationship, Memory, Time, Modes, Mandala at "whole instrument", Ring 1 |
| 1 | 80 % | Today, the 33 index, Rings 2–3, Climb bands 1–3 |
| 2 | 60 % | Her Presence, Rings 4–5, Climb 4–6, a 33 room |
| 3 | 25 % | Her Home, Rings 6–8, Climb 7–8, the Well |
| 4 centre | 0 % | Ring 9, the summit, Beneath's deepest band, Home (the Bindu), deep zoom |

At 0 %: a faint "surface" mark (cream α .25, still a 44 pt target) and Esc / left-edge drag always work. Text is full ink or hidden —
never half-alpha text. Touch anywhere brings chrome back for 4 s (chrome sinks again after 3.8–4 s). The point grows as chrome thins:
×1 at step 0 → ×26 at the deepest deep-zoom frame (ruling 9). Everything gets quieter, not louder, as it goes deeper (XMB-13).

### 1.9 Colour warms to ember red at the centre

Law 5 / BC-07. The **point's colour** is `mix(oklab, gold #C9963F, ember #C0392B, depth)`: depth 0 `#C9963F` · .25 `#C9813A` · .5
`#C76B35` · .75 `#C45430` · 1 `#C0392B`. At the Bindu the point *is* ember, on its crimson ground `#8B1A2A`. Grounds warm the same way in
the dark worlds: Beneath's fifteen temperatures warm inward to the point; the nine rings' washes run amber → white-gold with the Bindu
crimson at the centre; the Climb's point warms while its sky whitens (the sky is the crown's milk, the point is the heart's ember). Temperature
rule (R14:327–332): every experience shifts temperature at least twice.

### 1.10 The point in every world

One `@Observable PointState {born, touches, hue, motes, depth, position}` drawn by an app overlay above every world, carried across
crossings by `matchedGeometryEffect`; never unmounted, never re-made, never explained.

| World | Depth | Colour | Size · breath | Look and behaviour |
|---|---|---|---|---|
| Home | 1.0 | `#C0392B` core, `#8B1A2A` halo | 10 pt core; 4 s ×1.20; ×26 at deep zoom | the slow heart; becomes the world at the deepest zoom (crimson fill, then the summit) |
| Today | .25 | `#C9813A` → her accent glow | 7 pt; 10 s feed breath | sits on the celestial strip; at "felt back" the Recognition collapses inward into it |
| Mandala | .25 → 1 by zoom | gold → ember | the Bindu itself, r .10 R; 4 s ×1.28 | the yantra's centre is the point; the watching point, "never a crisp, measurable circle" |
| Nine rings | (n − 1)/8 | depth mix | 7 pt; enclosure period | rides at the ring's centre; ghost of outer rings at the edges |
| Her Home | her ring's depth | depth mix + her gem glow | 7 pt; bīja-locked | her mark; bloom at her mark widens with b |
| Her Presence | her ring's depth | Bindu ember 3.2 s | 6 pt | traces the ∞ path while held |
| Climb | climb/30 | depth mix | 7 pt; follow-light | leads the flight; crowned presence for today |
| The 33 | .3 | `#C0392B` persistent dot, α .3 | 6 pt top-right 16 / 16; wakes at 32 s | **the moving point that tells each room**: wander, lean ≤ 5 pt to a still finger, trail, blink, condense from 90 motes over 12 s; shape library line → circle → lemniscate → eyes → heart (Pointe timelines); the inverse principle: the dot shrinks as energy grows |
| Game | 0 | gold `#C9963F` (Lalitā's field: accentRed 120 / gold 40) | 9 s | marigold `#F2B632` in Play worlds (play language's "marigold point") |
| Modes | .2 | depth mix over the mode tint | 7 pt; mode breath | stops breathing during Mauna stillness |
| Time | .1 | gold | 7 pt; wall-clock 8 s | the lit bead on each clock ring |
| Memory | .1 | spark `#BE5A4E` | 6 pt; 8 s | at the centre of the year ring; motes in orbit (what was taken up today, never counted) |
| Well | .75 | ember `#F3B05A` | 9 pt, glow 22 / 48 pt | crosses the seam at 55 % of the Descent |
| Beneath | .9 | ember `#7A2F14` / lit `#94472C` | 9 pt; inhale-only | the ember the Still Point strips down to |
| Relationship | 0 | walked gold `#F9E3A7` | 7 pt | ember core listening at a capture; rose window of who gathered turns round it |

Pointy (C-1306): "the pointy loves" — dot → line → circle → infinity → heart (heart x = 16 sin³t, y = 13 cos t − 5 cos 2t − 2 cos 3t −
cos 4t). The app icon is the first frame of the Waking: ember in a pale-gold halo, three faces light / dark / tinted, 1024 pt, checked at
120 / 87 / 60 / 40, corner 22.37 %.

### 1.11 Canon colours win

#### 1.11.1 Precedence (settled)

1. **Map Color Hex** (`fldAsbQnAo3Fk2QHF`) for each of the 33 rooms; **Mandala Atmosphere** (ring / cluster seed + jitter) for each of the
   102. 2. Mandala house tokens (ground, gold, cream, crimson, clusters). 3. The world's language tokens (§1.4). 4. Field / dance / site
   hues **only** where no canon value exists (element tints, dance element vocabularies).
- Dance hues lose: Anahata 330 vs canon `#6B8E4E`; cross CHAKRA_HUES (anahata 130, ajna 250, sahasrara 290); Field batch hues
  (Svadhisthana 210 vs `#D47438`, Ajna 50 vs `#5B4E8E`, Aatma 265 vs `#D4A948`); song-character hues apply only to standalone dances.
- Site palette drift loses: Muladhara `#A82828` / `#C02020` vs canon; Manipura `#C4A013` vs `#D4A948`; Bindu subtitle "The Point" vs canon
  "The Origin".
- HO2 / FB-09 ring hues lose to Atmosphere hues (R4 crimson 353, R5 coral 18, R6 teal 194, R7 wine 322); the gem bends, never colours.
- Cluster colours: DS-04 mapping wins (inner instrument amber `#D4A017`, self·body·immortality violet `#7A5A9A`); HO1-15 table was
  swapped (confirmed by F01 / F34).
- Ground: `#0D0508` is the house ground; `#060104` is noon's ground in TIME_VARIANTS; the Mandala's ground is the indigo night well
  (F08 / F09); crimson-black on the Mandala was a port loss.

#### 1.11.2 The 33 — seeded grounds for rooms 21–33 (where the Map gives a hex, the hex wins)

SCENE (gen_practice.py:31–45): 21–29 innerfield grounds with three accents each (21 `#0E0A1F` · `#C98B3A` `#8E4A2E` `#5B3A22`; 25 `#0B0E22`
· `#4B3F9E` `#233A8E` `#8C9AD8`; 29 `#140C1E` · `#F0A9A9` `#A9F0C8` `#A9C8F0`); 30 veil `#F4F1EC`; 31 trikona `#0F0A04` (Will / Knowledge /
Action); 32 field `#0E1A0C` (**light without text** — ruling 2); 33 morning `#FBF6EA`. Mind triads: Creation 21–23 warm amber
`rgba(238,136,0)`, Recognition 24–26 cool blue-silver `rgba(100,140,220)`, Emergence 27–29 gold `rgba(201,168,76)` — walked in the
Map's order (ruling 13).

#### 1.11.3 The dyad palette (body 10–19, the Climb)

| BP | Centre | Dyad | Color Hex |
|---|---|---|---|
| 10 | Soles | Red / Cyan | `#7A1515` |
| 11 | Forge | Yellow / Blue | `#6B5800` |
| 12 | Prana | Orange / Azure | `#7A3800` |
| 13 | Hands | Green / Magenta | `#163D1E` |
| 14 | Pulse | Green / Magenta | `#112E17` |
| 15 | Sonar | Blue / Yellow | `#091840` |
| 16 | Echo | Blue / Yellow | `#060D30` |
| 17 | Vision | Yellow / Blue | `#5C4800` |
| 18 | Axis | Indigo / Chartreuse | `#1A0848` |
| 19 | Crow | Violet / Chartreuse | `#3A0A54` |

The Color Hex is the ground; the dyad is the body light as two colours in productive tension (two-tone shader: primary from the hex lifted
+40 L, complement at its hue + 180°). Shadow 9: no dyad — darkness and starfield. Armin 20: all pairs at once — aurora. Naming per Colour
Dyad (Gold vs Yellow, Azure vs Blue spellings in Primary Color are descriptive only).

#### 1.11.4 Next-colour rhyme

Every threshold carries the destination's colour: the next room's hex bleeds up from the bottom edge at 24 s (or during the crossing);
Ajna → Sahasrara door `#9B5AE6`, Sahasrara → Shadow `#E8D4A8`; "the threshold-fade carries the color of the destination" (D14–D15);
sideways doors are the other form's glyph in its accent, ringed in this page's accent; on press the world tints toward it (α .55) and
changes after 520 ms.

### 1.12 Light levels against Design

Design's rooms were verified by GPU read (`gl.readPixels`) at **80–255** luminance; the audited Code rooms measured **11–65 / 255**
(RD-06) and the capture tests pass anything with mean .01–.9 and spread > .02 (G7-1025). The new bands, per room, on a 64 × 64 Rec.709
luminance grid of the adapted frame (0–255):

| Room / archetype | Design min → max | Rule |
|---|---|---|
| Aṇimā (warm topaz) | 128 → 240 | max ≥ 216, min ≥ 115 |
| Mahimā (depth gradient) | 46 → 255 | max ≥ 230 |
| Vaśitva (pool falloff) | 13 → 197 | max ≥ 177 |
| Mahātripurasundarī (radial) | 24 → 221 | max ≥ 199 |
| Laghimā (vertical) | 73 → 255 | max ≥ 230, min ≥ 66 |
| Garimā (real shadow band) | 13 → 204 | max ≥ 184, range ≥ 70 |
| Sarva-Yoni (backlit membrane) | 82 → 255 | max ≥ 230, min ≥ 74 |
| Trikhaṇḍā (convergence) | 42 → 255 | asymmetry 86/81 → 81/81 at convergence |
| Ring 3 Anaṅga | 38 → 84 | max ≥ 76 |
| cosmic | 47 → 129 | max ≥ 116 |
| giving | 31 → 182 | max ≥ 164 |
| revealing | 27 → 209 | max ≥ 188 |
| sounding | 78 → 198 | max ≥ 178 |
| sourcing | 73 → 204 | max ≥ 184 |
| bindu | 43 → 157 | max ≥ 141 |

Plus for every room: brightest region ≥ 80 (the Design floor of the band) at the adapted frame; "always visibly changed" (> 20 % of the
grid moves between adaptations); the near half does not run away with the light (near / far ratio < 3.5); sister divergence > .1; never
black, never blown at either adaptation. Seat interior: farL 20 % at entry → 82 % adapted. Flat worlds (Mandala, Rite, Recognition,
Field chips) are measured against their Design frame (F08–F10 etc.) region by region, after the ×1.7 stroke restore.

### 1.13 Reduce Motion

Settled scoping (C21, laws 16 and 19): **decorative loops pause; mechanisms stretch; holds keep their length.**

| Class | Full motion | Reduce Motion |
|---|---|---|
| decorative loops (motes, twinkle, shimmer, sigil spin, drift, world glow, page breath) | run | paused on a mid-flight frame (`TimelineView(.animation(paused: reduceMotion))`, no `repeatForever` without a gate) |
| adaptation (Her Home, Rite of Entering) | continuous | **quantized and longer**: a in 4 steps, b in 3; adapt 160 s, hold 190 s, second 150 s — never disabled, never frozen at the end state |
| breath of the point and the yantra | continuous scale | opacity step every half-period (no scale), period unchanged |
| crossings (Veil, Descent, blink, flood, passage) | full | 0.2 s cross-fade, silent; type still changes at the cross-fade midpoint |
| holds and gates | designed length | **same length**; the progress ring fills in 4 discrete steps |
| camera flights (Climb, deep zoom) | eased flight | cut through a 0.2 s fade to each station |
| text reveals (clause by clause, sharpen) | timed | appear whole, in order |

The Living Rite's `* { animation: none }` and the Concept Board's frozen-at-62 s are rejected (they disable the mechanism).

### 1.14 Contrast floors

- **Text**: ≥ 11 pt; body ≥ **4.5:1**; display (≥ 24 pt, or ≥ 18.66 pt bold — "22 px / 400 is NOT large text") ≥ 3:1; cream on ground at
  α ≥ **.5** (`#807670`, 4.55:1). The old .3 α floor measures 2.31:1 and is texture, not text (C8: FIDELITY rule 4 governs).
- **Accent as text**: a glyph uses `actext`, a line or shape uses `ac` — on paper `acp = mix(oklab, ac 50 %, #191919 50 %)` (worst case
  5.39:1, ≤ 2.2° hue drift; never oklch, which drifted 14.6° and "turned a lavender into a rose"); on night the raw accent if ≥ 4.5:1, else
  lifted toward cream in oklab (ring table §1.4.4). `readable(accent, ground)` helper in Swift.
- **Chrome over a figure ground**: solid ink, never alpha (α .66 measured 3.87:1, solid 8:1). Text measured against the pixels actually
  behind the glyph (the nearest gradient stop to its edge).
- **Graphic marks**: dim states still ≥ 3:1 (status-as-light); crimson `#8B1A2A` (2.19:1) and lit `#A4343E` (3.01:1) are graphic only,
  never text.
- **Touch**: every target ≥ 44 pt (`Hit.min`), the visible mark may be small inside it; decorative layers never intercept touches; z-order
  world 0 · figure 1 · play surfaces 1 · steps 2 · chrome 5 · picker 6. A pool of light never covers text (the covenant-pool bug).
- **Consequence red** `#C0392B` (pressed `#9E2D21`) only where there is consequence; "red has no limits" (11 Oct) — but the "I feel her"
  pill stays the one saturated CTA.
- A settled line stands at ≥ .55 α (PlayInk).
- Measure every label on every world's deepest surface (the 33 rooms × deep grounds especially).

### 1.15 Type: crossings and the sixteen faces

Law 9: **type changes only where a crossing means something** — at a world crossing (mid-bloom) or at an inner crossing that carries
meaning (Well: Newsreader under the floor; Memory: Fraunces = "seen whole, not scored"; Game: board Lora → game Gloock; Modes: candle
Cinzel at Pūjā; Today: linen Instrument Serif before noon). Never inside a world for decoration. Faces per world in §1.3 / §1.4.

**Bundle** (all OFL / Google Fonts; today only `Fonts/CormorantGaramond-Light.ttf` and `-LightItalic.ttf` ship). Register each in
`UIAppFonts`, route through `AppFont` (Dynamic Type), canvas labels via `UIFontMetrics`:

| # | Family | Weights / styles | Worlds |
|---|---|---|---|
| 0 | Cormorant Garamond (extend) | + Regular 400, Medium 500, Italic 400 | Home, Today, Mandala, rings, Her Home, Her Presence, Climb, 33, Time |
| 1 | Lora | 400, 400 Italic, 300 Italic | Game board, Modes, Beneath |
| 2 | DM Sans | 400, 500 | 33, Game, Modes, Beneath |
| 3 | DM Mono | 300, 400 | Modes readouts |
| 4 | Cinzel | 400 | Modes (candle), Memory sheet |
| 5 | EB Garamond | 400, Italic | Well (learning dark) reading |
| 6 | Fraunces | 300, 400 Italic (opsz) | Memory; clause-by-clause lines |
| 7 | Spectral | 300, 400 | Memory body |
| 8 | Instrument Sans | 400, 500 | Relationship Field |
| 9 | Instrument Serif | 400, Italic | Today / Time linen morning |
| 10 | Newsreader | 300 Italic, 400 | the Well; Play games UI |
| 11 | Gloock | 400 | Play games display |
| 12 | Inter | 400, 500 | Climb hints |
| 13 | Geist | 400 | linen body |
| 14 | Geist Mono | 400 | linen numerals |
| 15 | Space Mono | 400 | Learning kickers (Descent) |
| 16 | JetBrains Mono | 300, 400 | mandala mono (Axis ordinals, Living Axis) |

(Sixteen to add, plus Cormorant extended.) Studio builds loaded no fonts — their type was never proven; the app is the first proof.

### 1.16 Sound and the visual

The visual world writes no sound. It hands the sound world: the 0.08 Hz world-glow phase (shared LFO), the crossing timeline (tone at
start, Descent tone peaking ≈ .8 s and gone by 1.25 s), destination colour for each crossing (threshold tones per world), and "no sound"
for candle (Pūjā). No mp3 is owned here.

---

## 2 · Every element, placed

Status codes: B built · P partial · N not built · W wrong. Action: reuse / move / new / fix.

| # | Element | What it does (mechanism + numbers) | Source (index ids · register) | Status today (code) | Action |
|---|---|---|---|---|---|
| 1 | Chassis enum, one language per world root | `enum Chassis { mandala, chakra, lalita(LalitaGround), leela(dark:), play(PlayWorld?), ascent, field(FieldGround, hue:), being(dusk:), learning(dark:), feed(FeedGround), candle(sheet:), blink(Int), linen }`; `.environment(\.chassis)`; output = chassis ⊗ world ⊗ container ⊗ content; studio proof questions name each language | G5-0330, G5-0483, G5-0505, G5-0334, G5-0351, G5-0503, G5-0504 · R13:11–40, 561–564, 692–712 | N | new `Theme/Chassis.swift` |
| 2 | Spine role grammar | Views read roles (bg, surface, ink, ink-2, voice, sig, spark, deep), never hexes; text ladder high 92 · mid 80 · body 72 · soft 58 · whisper 36 · ghost 20 %; radius w-radius / 12, sm ×.5, lg ×1.33, pill 999; focus ring sig 70 % + white 2 pt; test asserts no literal colour in Views | G5-0331, G5-0501, G1-0569, G5-0335 · R13:29–48, 682–685; R02:1448–1449 | N (literals exist) | new `SpineTokens`; LawsTests "no literals" |
| 3 | Borrowing law, anti-borrowing, nesting | mechanics cross, grounds and voices never; each dance metaphor owns a hue register (violet 270 = cross only); outer shape governs, ≤ 2 nested; every chakra designed from the element up, never re-skinned | G5-0340, G4-0468, G5-0366, G4-0005 · R13:65, 134; R09:659; R08:76 | N | rule in review checklist + test on chassis per world |
| 4 | Mandala house tokens | ground `#0D0508`, surface `#1A0C10`, veil `#080307`, silence `#040104`, gold `#C9963F`, goldDeep `#A07830`, goldWarm `#CF9443`, cream `#F2E8D9`, ink-2 `#968D85`, crimson `#8B1A2A`, crimsonLit `#A4343E`, goldBright `#D4A017`; status .22/.44/.76/1; hairline gold α .14; Codex chassis breaths; Axis UI CSS ported to pt | G5-0484, G1-0043, G2-0004, G6-0853, G1-0417, G1-0462, G2-0192, G1-0583, G2-0116, G1-0559, G2-0003, G1-0636, G1-0532, G1-0096 · R13:566–577; R02:33; R04:55 | P (`Color+Tokens.swift`: no ink2, crimsonLit, goldBright) | extend `Color+Tokens.swift` |
| 5 | Ground ruling (C10) | house `#0D0508`; noon TIME_VARIANT `#060104`; Mandala indigo well `#0A0611 → #050308 → #030105`; chassis pairs cream `#F7F3EC` / void `#0A0A0C` for proofs only | G2-0444, G1-0602, G2-0056, G5-0347, G5-0348, G7-0045, G2-0401 · R04:660, 729; R03:8; R13:84–91; R19:152–154 | B (MandalaSky) | reuse; doc ruling |
| 6 | Cluster colours (C11) | DS-04 mapping: inner `#D4A017` (1–3), sense `#C4725A` (4–8), citta `#2A7A7A` (9), stability `#4A7A5A` (10–13), self·body·immortality `#7A5A9A` (14–16) | G2-0005, G2-0057, G2-0445 · R04:56, 118, 730 | B | reuse |
| 7 | Ring hues + wash/deep + legible text | §1.4.4 table; wash `mix(#0D0508 80 %, ring 20 %)` oklab, deep `mix(#070205 88 %, 12 %)`; FB-09 / HO2 hues rejected | G1-0042, G2-0238, G2-0448, G2-0087, G1-0111 · R01:128, 321–336; R04:158, 375, 733 | P (hues B; oklab mix N) | new `OKLab.swift` mix helper |
| 8 | Feed language (Today, Her Presence) | field `#0E0C12`, prayer `#050408`, card `#171420`, ink `#EDE8E3`, dawn `#C9A07A` (replaced by her accent), light `#EDE3CE`, stone nave `#D9D2C4`/`#FBF9F4` with ink `#16131B`, carved shadow; breath 10 s never restarted; words made of particles (200 motes, Lora italic 22–30) | G5-0494, G5-0067, G5-0069 · R13:652–660; R12:321–322 | N | new `Chassis.feed` |
| 9 | Linen language (morning page) | §1.4.2 linen row; near-threshold ember dots, no percentages | G5-0497 · R13:675–678 | N | new |
| 10 | Ascent language (Climb) | §1.4.7; sky stops; door reds; ink ladder | G5-0490 · R13:618–623 | N | new |
| 11 | Chakra language (the 33) | §1.4.8; chassis B contract (hue → six steps → scene ladder → verb → system); verb cards for the 33 index | G5-0486, G5-0346, G5-0384 · R13:73–83, 579–588 | N (rooms share 7 looks by kind) | new |
| 12 | Leela language | §1.4.9 light / dark pair | G5-0488 · R13:603–608 | N | new |
| 13 | Play language | §1.4.9 cloth, paper, ten sketch grounds, 1.2 s recolour | G5-0489 · R13:610–616 | N | new |
| 14 | Field language (Modes) | §1.4.10; Bindu Field tokens (void `#020208`, text α 1/.55/.28/.12, two-shadow glow r 24 α .28 + r 50 α .10, sheets `rgba(5,5,16,.97)`) shared so the two apps feel related | G5-0491, G4-0316 · R13:625–632; R09:120–125 | N | new |
| 15 | Candle language | §1.4.10 candle row; no sound | G5-0495 · R13:662–666 | N | new |
| 16 | Being language (Memory) | §1.4.12 | G5-0492 · R13:635–642 | N | new |
| 17 | Lalita language (Relationship, Well) | §1.4.13, §1.4.15; the ground is a position: plain `#F4F0E7` 120 ms · warm paper `#FBF8F1` 350 ms · night `#1A1826` 600 ms · capture `#1B1814 → #100E0B` 150 ms · under `#0E0C14 → #07060C` 1200 ms; "between rooms the ground lifts continuously; no hard cut" | G5-0487, G5-0342 · R13:50, 144–147, 590–601 | N | new `OKLCH.swift` |
| 18 | Learning language (dark crossings) | §1.4.13; "every screen change passes through the ember"; veil-light 1.05 · veil-dark 1.5 · waking 2.85 · descent 2.35 · surfacing .95 | G5-0493 · R13:644–650 | N | new |
| 19 | Blink language (Beneath) | §1.4.14 fifteen temperatures; fifteen bands of glass (`#F6F1E4 #3E4C86 #4A5C93 #5A6BA0 #6A6494 #C9A84C #9C7C3E #C0392B #A8442E #8A3A52 #6E3560 #4E3468 #38386E #2A3C70 #C9A84C`, middle band swells ×7 over 1.1 s) as Beneath's section figure | G5-0496, G5-0106 · R13:668–673, 396–397 | N | new |
| 20 | Home wears mandala · silence | §1.4.1 | G5-0513 · R13:767 | N | new root env |
| 21 | Today wears feed prayer + her palette (+ linen) | §1.4.2 | G5-0514 · R13:768 | P (palette B) | new root env |
| 22 | Mandala wears mandala | §1.4.3 | G5-0515 · R13:769 | B | reuse |
| 23 | Nine rings wear mandala ring-n | §1.4.4 | G5-0516 · R13:770 | P | extend |
| 24 | Her Home wears mandala per-being (S13 Room) | §1.4.5 | G5-0517 · R13:771 | P | extend |
| 25 | Her Presence wears feed identity header | §1.4.6 | G5-0518 · R13:772 | N | new |
| 26 | Climb wears ascent above band 7 | §1.4.7 (settled: Axis dark bands 1–6, ascent sky from band 7) | G5-0519 · R13:773; R01:196–219 | N | new |
| 27 | The 33 wear chakra | §1.4.8 | G5-0520 · R13:774 | N | new |
| 28 | Game wears leela, games wear play | §1.4.9 | G5-0521 · R13:775 | N | new |
| 29 | Modes wear field, Pūjā wears candle | §1.4.10 | G5-0522 · R13:776 | N | new |
| 30 | Time wears mandala relit + linen | §1.4.11 | G5-0523 · R13:777 | P | extend |
| 31 | Memory wears being + candle sheet | §1.4.12 | G5-0524 · R13:778 | N | new |
| 32 | Well wears lalita under + learning dark | §1.4.13 | G5-0525 · R13:779 | N | new |
| 33 | Beneath wears blink + learning dark | §1.4.14 | G5-0526 · R13:780 | N | new |
| 34 | Relationship wears lalita | §1.4.15 | G5-0527 · R13:781 | N | new |
| 35 | Ring weather token table | WORLDS fog colour / density / veil / tempo per ring (§1.4.4); `struct RingWorld` with veil 0 → 1 monotone, tempo 1 → .28 (r3 .62 < r4 .72 kept as Design wrote) | G1-0099, G1-0018, G1-0076 · R01:48–58, 219, 273–285 | B (`HomeWorlds.swift:308–328`) | reuse |
| 36 | Type registers and scale of reverence | Sanskrit names Cormorant Light .06–.10 em; body serif (no system sans at 9–11 pt — "UI debris"); bīja Cormorant Light very large as visual objects; labels caps .18–.22 em; italic = the voice; Today name 64 pt (56–72); Detail name ≥ 44 pt; name written inside the figure; display type as the figure; words indexed on the figure; SE width header collision fixed | G2-0006, G2-0007, G2-0443, G2-0157, G2-0159, G2-0160, G2-0167, G6-0857, G2-0327, G5-0422, G5-0424, G5-0459 · R04:57–58, 255–258, 265, 525, 728; R13:395–397, 512 | P (44–48 pt; sans slips) | fix sizes; Cormorant on quality + Settings |
| 37 | Sixteen typefaces bundled | table §1.15 | G5-0502, G5-0506, G5-0704, G4-0781 · R13:852–854, 713; R14:1193–1196; R11:358 | N (2 files) | new font files + UIAppFonts |
| 38 | Type changes at crossings | swap face at the crossing's hold frame only | G5-0344 · R13:54, 108–109 | N | new in TransitionOverlay |
| 39 | Type motion | clause rises 1.2 s, next 1.4–1.6 s later, under a breathing dot (Fraunces light); words sharpen blur 6 → 0, α .35 → 1 at 25 % visibility; letter-spacing closes .2 → .04 em over 2 s ease-out; five ways a paragraph arrives; text recedes while you look (top text → α .25 while dragging) | G5-0369, G5-0370, G5-0372, G5-0454, G1-0301 · R13:179–183, 497; R01:217, 703 | N | new text modifiers |
| 40 | Spacing, pace, scales | Space [4…96]; padding 20–40 around geometry; yantra ≥ 200 pt negative space; status bar 60; safe top 54; type ladder display 40 → 76, h1 32 → 52, h2 26 → 37, h3 20 → 26, body 16 → 17.7, mono floor 11; reading 60 ch; bottom scroll fade 28 pt; desktop width rules → iPad only | G2-0059, G5-0500, G5-0499, G5-0385, G7-0560 · R04:120; R13:686–691, 847, 258 | P (Layout.swift, BottomScrollFade) | new `Space`, `Pace` |
| 41 | Motion curves and Design timings | table §1.4; DS-13 timings; v1 motion; Living Rite / Axis / Modes / ring-world keyframe vocabularies ported as named Animations; tempo per room (morning 600 · person 350 · list 120 · capture 150 · Mirror 1200 ms); entry fade 16 pt over .7 s stagger .1; reveal height .5 s + α .4 s; softBounce 2.5 s; warm pulse .2 ↔ .5 at 1 Hz; boiling line seed every 110 ms; dwell rises .30/s drains 1.30/s; DustMotes `seed = (i×73+17) mod 100`, left 8 + (seed×7) mod 84 %, size 1.4 + ((seed×3) mod 22)/10, duration 16 + (seed×5) mod 14 s, α .18 + ((seed×11) mod 28)/100; axBreath translate glitch not ported | G5-0498, G2-0014, G1-0662, G1-0459, G1-0550, G1-0727, G1-0699, G1-0710, G5-0229, G5-0631, G5-0678, G5-0680, G5-0457, G5-0387, G5-0428, G1-0541, G1-0663 · R13:834–846; R04:65; R03:239–253, 475, 546, 620–626; R02:317–358, 1174, 1228–1240 | P | new `Theme/Motion.swift` |
| 42 | Haptic family | §1.4 haptic family; crawl for Ring 1 / earth | G5-0124, G6-0858, G2-0227 · R12:419; R13:501–502, 855–856; R17:705 | W (UIImpact light/medium/soft) | rewrite `Haptics.swift` on Core Haptics |
| 43 | Palette engine | `Atmosphere.derive` pure; one hue; ±7° jitter; ±22° rotation; cluster seeds; 20 % ground blend; groundDeep 12 %; per-kp identity seed (FNV-1a for figure variation only, never legibility); "every surface generated from the Śakti" | G1-0573, G2-0173, G2-0204, G2-0300, G6-0850, G1-0112, G1-0465, G1-0533, G2-0174, G2-0158, G1-0014, G2-0190, G6-0902, G1-0574, G5-0272 · R02:442–455, 1455–1469; R01:26, 321–338 | B | reuse; add oklab mixes |
| 44 | Relit by the hour | five states, windows, deltas, moteMul read, every consumer relit; Home TIME_VARIANTS; moon names and glyph | G1-0466, G1-0467, G2-0175, G1-0656, G1-0471 · R02:457–504; R03:205–212; R04:278, 735 | P (moteMul unread; Mandala focus card / Threshold unrelit) | fix |
| 45 | Six element layouts | §1.5.4 archetypes, backdrops, motes, breaths; LrSigil per āvaraṇa; LrDepth; Rite layer stack; DayLight intensities (rite sigil .62 + .85 × .42, field chip 1.0, room .5, threshold .7, presence .55) | G1-0473, G2-0177, G1-0477, G6-0851, G6-0859, G1-0476, G6-0855, G7-0131, G1-0475, G7-0116, G7-0100 · R02:521–600; R17:668–707; R19:354–439 | P (air-lean, staged arrival lost) | restore |
| 46 | Ruling 4 elements + ether 280° | kp table first, `light` parse branch, SensoryDoorway light; ether hue 280; Bindu Field element vocabularies; reading element hues are dance-only | G6-0856, G6-0924, G2-0201, G5-0531, G4-0302, G5-0292 · R17:694, 802; R13:1084–1086; R09:23–34; R12:784 | W | fix `Element.swift`, `SomaticRegion.swift` |
| 47 | Gem diffusion | behaviour only; ring 7 sourceless; ring 8 one hard band; rig key 2600 (nil ring 7), ember 4200, ambient 460 + 2600 × diffuse × .45; MandalaLight: one source (ring-9 hue), falloff 1.35, refraction limit .45, veil takes ≤ .45 from a mark and ≤ .25 from text (floor .5), Tratak onset 20 s / full 45 s | G1-0017, G2-0252, G6-0964, G6-0977, G6-1018, G6-1019, G6-0860 · R01:46; R18:24, 42, 92–93; R17:713 | B | reuse |
| 48 | After-effect, felt never named | §1.5.6 | G1-0009, G1-0090, G1-0419, G1-0430, G7-0328 · R02:39–47, 128–138; R20:379–382 | W (named line, 24 s, exposure only) | fix `HerSiddhiLingers.swift` |
| 49 | Breath per enclosure | §1.6 table; status petals; today 3.5 s; Bindu 4 s | G1-0777, G1-0655, G2-0449, G6-0854, G2-0389, G2-0374, G1-0506 · R03:188–203, 980; R13:183; R17:683 | W (ring 2 = 3 s, snapped) | fix `DayLight.FieldBreath` |
| 50 | BreathClock: one epoch, no snap | keep `seconds(at:)`, drop `(p / beat).rounded() * beat` | G6-0852, G6-0929, G6-0921 · R17:673, 786, 828 | W | fix |
| 51 | Per-world breath + world glow | §1.6 per-world list; 0.08 Hz opacity glow 0 → .07 over 12.5 s; bīja-locked breath in Her Home; ScoreLightVeil unsnapped; "slower the deeper" resolved by law 7 (the Bindu 4 s, a heart) | G5-0638, G5-0345, G2-0360, G7-0327, G1-0046, G2-0127 · R14:688, 1033; R13:54, 92–94; R04:208, 592; R01:147; R20:377 | N | new `WorldBreath` |
| 52 | Interfaces thin with depth | §1.8 chrome steps; Zero Gap labels at R1, none at R9; quieter deeper | G2-0227, G2-0229 · R04:353, 355; (cross-ref G5-0172) | N | new `.chromeDepth(_)` modifier |
| 53 | Colour warms to ember at the centre | §1.9 point mix; temperature rule ×2 per experience; progressive luminance in the 33 (P1 5 % → P8 90 %, P9 white) | G2-0359, G5-0585, G3-0270 · R04:591; R14:327–332; R06:2011–2012; (cross-ref G5-0397) | N | new `PointState.colour(depth:)` |
| 54 | Light stands in the air; caps lifted | §1.7; XMB-10 / SH-03 superseded; XMB errata | G2-0454, G2-0226, G2-0305, G2-0387, G2-0216 · R04:342, 352, 490, 630, 739 | P | fix (HDR / bloom everywhere) |
| 55 | The point in every world | §1.10 table; DotStage radius 7 breathing 6 s ±9 %, lean ≤ 5 pt, condense 90 motes / 12 s; persistent 6 pt `#C0392B` α .3; Pointe timelines (LINE 2, CIRCLE 4.5, LEMNISCATE 9, EYES 14, BLINK 18, FADE 19, MORPH 20.5, HEART 25…; infinite loop 76 s); inverse principle; shape library (heart, lemniscate, spiral, rose, circle, morph) | G2-0225, G2-0483, G3-0077, G3-0322, G7-0425, G3-0487, G2-0358, G4-0107, G4-0039, G3-0200, G3-0206, G3-0214 · R04:351, 589–590; R05:29–31; R06:187–190, 1353–1509, 2612; R07:840–843; R08:257–263, 551 | P (`BinduPoint` exists; no app overlay) | new app overlay `PointLayer` |
| 56 | Icon and the Waking's first frame | kindling icon 1024 pt, three faces; Axis thumbnail motif (gold line x = 50 α .5, eight cream `#FFF6DE` dots, crown dot); the Aperture eye (turn per 42 s at rest, 2.4 s while drawing) as the Home "what is this" glyph | G5-0445, G1-0095, G5-0072 · R13:482, 874; R01:254; R12:324 | N | new icon set |
| 57 | Canon colours win | §1.11.1 precedence; dance / site / field hues lose; Primary Color + Color Hex baked; SCENE seeds for 21–33; Mind triad fills | G4-0289, G4-0487, G4-0007, G5-0630, G6-0621, G6-0489, G5-0278, G3-0137 · R08:97–107, 1257–1260; R09:748; R14:618–625; R15:58, 92, 1543; R12:733; R06:622–630 | P (fields carried, unshown) | bake + `CanonColour` lookup |
| 58 | Dyad palette (body 10–19) | §1.11.3 table; two-tone shader | G6-0423, G6-0424, G6-0425, G6-0426, G6-0427, G6-0428, G6-0429, G6-0430, G6-0432, G6-0433, G6-0527, G6-0604 · R15:129–138, 400–404, 1394 | N | bake `fld4Bdiu8fg0RNrbE`; new shader |
| 59 | Next-colour rhyme, destination-coloured thresholds | §1.11.4; registers cream / void / violet-indigo (D14–D15); sideways doors 520 ms | G3-0275, G7-0450, G3-0310, G5-0018 · R06:2022–2023, 2353–2356; R20:613; R12:116, 610 | N | new |
| 60 | Crossing visuals | Veil: origin = touch point clamped [−10 %, 110 %], fallback (50 %, 46 %); light: scrim 1 → hold 45 % → 0, bloom Ø ≈ 6× screen, α 0 → .95 @14 % → .5 @62 % → 0, scale .04 → .16 → 1 → 1.35, fill `rgba(255,248,232,.95) → rgba(247,213,163,.55) 32 % → rgba(243,176,90,0) 68 %`; dark: scrim 0 → 1 @20 % → hold 64 % → 0, ember 9 pt `#F3B05A` glow 22 / 48 pt; recoloured per destination; "swap the screen first"; silent; descent reveal | G5-0112, G5-0091 · R12:379, 405–408; R13:148–153, 876 | N | new `TransitionOverlay` |
| 61 | Light levels vs Design | §1.12 bands; seat light farL 20 → 82; RoomLightPass additive air-light; RoomAir bodies; binding condition lifted in the mechanism layer; port losses (stroke ×1.7, dimmers); R3 regressions (brightness .15 → 1.5, DustMotes(7), plume 116; glow ladder 1.0 / .9 / .55 / .30, `.blendMode(.screen)`) | G2-0279, G2-0383, G7-1025, G7-0947, G1-0436, G6-0976, G6-0979, G6-1063, G2-0384, G2-0134 · R01:194–196, 945–946; R04:220, 434, 625–626; R18:41, 44, 141; R22:554, 638 | W (11–65 / 255) | fix lights + new tests |
| 62 | Render primitives and robustness | glow texture, sprites, motes, drift motes, line loops; renderer: antialias, pixelRatio ≤ 2, sRGB, ACES exposure 1.04, soft shadows, FogExp2 .014, camera 60° near .1 far 500; dt cap .05; last good frame; particle size clamp; render stack SceneKit + Metal (Canvas for flat worlds) | G1-0097, G1-0067, G2-0318, G1-0094, G1-0032, G7-0295 · R01:96, 196–199, 252, 261–267; R04:515; R20:170 | P | reuse / new `FrameGuard` |
| 63 | Reduce Motion | §1.13 matrix | G1-0029, G1-0410, G1-0416, G1-0460, G2-0455, G4-0779, G7-0656 · R01:93, 966, 1035; R02:30, 92, 105, 360; R04:740; R11:353–354; R22:127 | W (rooms freeze at end state) | fix + DeviceSlipTests extend |
| 64 | Contrast floors | §1.14 | G1-0571, G2-0106, G2-0126, G2-0442, G1-0597, G4-0778, G5-0015, G5-0302, G5-0510, G5-0289, G7-0311, G2-0491, G5-0248 · R12:594–600; R02:1452, 1645–1650; R04:182, 207, 727; R11:351–352, 480; R12:110–113, 866–874; R13:731–752; R05:75–76 | P | new `readable()` + contrast unit test |
| 65 | Touch targets and hit-test order | ≥ 44 pt, small mark inside; z-order contract | G5-0016, G5-0014 · R12:109, 114 | B (`Hit.min 44`) | reuse; audit seats (26 px) |
| 66 | Consequence red | one saturated CTA; `#C0392B` only where consequence; red has no limits | G2-0113, G5-0332 · R04:189; R13:33, 684, 694 | B | reuse |
| 67 | No figure of a Śakti | aniconic: shapes performing actions; light, glow, gems, geometry welcome; real marks only, no generated imagery; figural-vocabulary tests kept, catalogue pins retired | G2-0331, G2-0457, G2-0224, G7-0614, G7-0615, G7-0884, G7-0885, G7-0886, G7-0887, G7-0888, G3-0424 · R04:350, 534, 742; R07:525–528; R22:32, 477–488 | B (tests) | keep; rewrite as images row |
| 68 | Drawing law | five marks (point, line, arc, triangle, ring); "if the mark would work on someone else's site, it's wrong"; sacred geometry belongs to the dancer and uses the actual yantra elements; figures `draw(t, kind, hue, count, progress)` pure, seeded `rnd(i) = frac(sin(i·127.1 + 31.4)·43758.5453)`; glow = second stroke, never drop-shadow; scale cap 2.4×; pause off-screen; every world declares tier systems t0–t5 (global boost .8) | G5-0349, G4-0034, G4-0035, G5-0418, G5-0020, G4-0331 · R13:56, 98–99, 385; R08:216–218; R12:118, 637; R09:166 | N | refactor Canvas layers |
| 69 | Figure protocol and primitives | PAGE = CORRIDOR × FORM × WORLD-or-FIGURE × CONTENT; figure `apply(slots:, step:, of:)` behind steps; cathedral figure + 70-star field (twinkle 2–6 s, .5–1.5 pt); FIELD (breath 9 s, the no-figure wash), HORIZON, RAIL (ty = −index·28, live ×2.1), VESSEL (top 42 %), CARD / SEATS / BAND (46 %), DISTANCE / ATTUNE, SEPARATION (±34 % · sep, seam of light); 41-family table; MOVES five slots; play surfaces; **the figure is the loading state** (no spinner); thread knots that breathe; no numbers grid | G4-0637, G4-0777, G5-0029, G5-0035, G5-0249, G5-0250, G5-0252, G5-0260, G5-0262, G5-0264, G5-0268, G5-0270, G5-0013, G5-0685, G5-0421 · R13:395; R11:12–17, 475; R12:103–108, 162–172, 204–209, 616–674; R14:918–922 | N | new `Figure` protocol |
| 70 | Glyph family for the 15 worlds | strokes and dots, 28 pt; one 60 × 60 glyph per form; redrawn for the 15 worlds, each breathing as what it is | G5-0383, G5-0040 · R13:256–257, 932; R12:221 | N | new 15 glyphs |
| 71 | Design-parity verification | numbers parsed from Design's own files (LR_RECOG, LrSigil, lrBackdrop, syShimmer, RING_CHARACTER, FORMS, arrival beats…); geometry at three widths; timing tables; FIDELITY checklist (atmosphere layers, composition, RM gating, legibility, tokens, degradation, 17 Pro Max + SE, adversarial zoom); prototype is the source of truth for look and motion | G7-0935, G7-0945, G7-0946, G7-0948, G2-0170, G2-0188, G6-0783 · R22:526, 550–556; R04:273, 298; R17:31 | N | new test targets |

**71 elements placed.**

---

## 3 · Parity ledger

Written to `waves/upgrade/ledger/visual.csv` — **157 rows** (`VIS-001 … VIS-157`; one row per checkable element; columns `id, world, element, source, numbers_to_match,
reference_frame, status_today, code_today, build_action, verify_by`). Summary of what it checks: every language's ground / ink / accent
hexes and contrast ratios; the sixteen faces registered; every motion constant; every haptic event; Atmosphere outputs for kp 1, 30, 31,
40, 42, 43, 60, 102 at the five time states; the six element layouts against F-frames; ruling-4 elements and ether 280; nine enclosure
periods and the unsnapped clock; chrome steps by depth; point colour by depth; the after-effect curve; canon colour lookups for all 33;
the dyad table; light bands for the 15 archetypes / rooms; Reduce Motion behaviour per class; contrast floors and 44 pt targets.

---

## 4 · Data contract

**Airtable — Mandala (Shakti) table** (ids from R17:52–66): `khadgamalaPosition` `fldI0aV1sfOeNybHI` (kp → ring via KhadgamalaMap
spans 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102), `clusterGroup` `fld1HO6HwMH8fSwS3` (Ring 2 hue seed),
`esotericTattva` `fldxylgY985SwqdJE` (Ring 2 element; ruling-4 kp table wins), `bija` `fldnOqkWcvjQNxpWl` (Her Home bīja-locked breath),
`status` `fldDiihcxC54WKPhT` (status-as-light opacity), `iconography` `fldXJEBCQxLdHWGuP` (attribute actor — aniconic), **Score JSON**
`fldz1vCCMpXiw8s1n` (her Score's breath / hue for ScoreLightVeil). Read-only here; **no new fields** (ruling 11).

**Airtable — Map table** (R15): Color Hex `fldAsbQnAo3Fk2QHF` (room hue, 33 / 33; Ego Reveal's hex "provisional" — used as light
only), Primary Color `fldtBecVRvcucpDDw` (descriptive), Colour Dyad `fld4Bdiu8fg0RNrbE` (bodies 10–19), Tree `fldX2s98w8U0Y5nK1`
(which tree art). All to be baked into `Data/ChakraConstellation.json` (keys today: `system`, `stage`, `primaryColor`, `avaranaField`;
add `colorHex`, `colourDyad`, `tree`).

**Bundled assets**: 16 font families (§1.15) under `Fonts/`; the app icon set (kindling, three faces); no mp3 (sound world owns all 44).
Tree artworks for the 33 are owned by the 33 world.

**Local stores** (per-viewer conveniences; never the ledger): `chassis.lastWorld` (for back-to-where-you-were colour), `point.state`
{born, touches, depth} (TTL 90 min with walk continuity), `afterEffect` {kind, at} (180 s), `settings.motion` (full / reduced / off),
`settings.geometry` (off / subtle / full), `settings.haptics` (on / off), `hamburger_first_run_seen` (existing).

**App Activity types written**: none by the visual layer. It **reads** App Activity for the two weathers of a door (met / unmet), the
motes in orbit (what was taken up today) and status-as-light — it never writes and never counts.

---

## 5 · Doors

The visual world owns no destination; it owns **how every door looks**:

- **The point (touch → Home)** from all 14 worlds: the point recolours toward ember along its path, the crossing is Veil-dark 1.5 s
  (or `surfacing` 0.95 s if returning after time away), chrome steps to 0 %.
- **The menu** (constellation of world-points): each world-point is a dot in its world's ground colour with its glyph (element 70);
  choosing blooms from the touch in the colour of the world entered.
- **Named crossings**: Home → Today = **blink** (lids .66 s, seam glints in her colour, navigate at 780 ms); Home → Well / Beneath =
  **Descent** 2.35 s; a Leela landing → that chakra's room = **colour flood** (.70 s, glyph ×11); Climb membranes and Home ↔ 33 = the
  **passage** (5.4 s, gates at .34 / .68); every other crossing = **Veil** light 1.05 s or dark 1.5 s by the destination ground's
  luminance (> .5 → light).
- **Doors along the threads**: kp (her hue + jitter carried into the destination), chakra (Map hex carried), day (today's hue threaded
  through every world until 6 am).
- **Search, the Veil index**: the Veil sheet `#080307` with five tiers of light (here · open · ground · ahead ≈ 34 % · veiled ≈ 20 %).
- **Back to exactly where you were**: depth, breath phase, point age and the world's chassis restored; colour returns through the
  crossing, never a cut.
- **Gestures as doors**: left-edge drag and Esc always leave, "never with 'are you sure?'"; hold doors keep their designed length.

---

## 6 · To Bindu Feed

- **Editorial argument page** and link preview (EC 492 / 485) — essay forms, not energies (G5-0384; verb cards stay as the 33 index).
- **Field readings and the seven lenses as words** (G4-0579) — the readings are story; the lens colours (one_word red, need green, holds
  gold, frequency blue, shape silver, grace rose, recognition gold) stay as structure for the dance roster.
- **The practice page's story portal** (G3-0159: section 15 "STORY PORTAL" and the narrative tiers of the Two-Act template) — the 33
  world keeps the energy sections; the story portal's text goes to the Feed.
- **cross.score.json's recognition prose** (G4-0364: "A song that pretends to be a club track while actually being a delivery vehicle
  for the sacred…") — the metaphor's palette (violet 260–285 + accent 35–50) stays with the dance; the prose is Feed material.
- **Feed's own descent reveal and stone nave** (G5-0091, G5-0067) are borrowed here as mechanics only (borrowing law) — their Feed
  grounds stay Feed's.

---

## 7 · Conflicts settled and open

**Settled from evidence:**

1. **One 8 s breath clock** (BreathClock) vs Design's periods → lifted (Foundation:40, ruling 10 "restrictions lifted"): one epoch, no
   snap; home 3.5 s (T/mandala:41, EC:186 — "the spec sheet rounds home to 3 s").
2. **Bindu 4 s vs 5.5 s vs "slower the deeper"** → law 7: the Bindu is a slow heart at 4 s in Home / Mandala / rings; the Living Rite's
   sigil keeps 5.5 s (an existing experience keeps its own breath); DA1-13's ladder (Veil 2.25, Silence 6) is superseded by per-world
   breaths in §1.6.
3. **Ether hue** → 280° (evidence §1.5.4). **Ruling-4 elements** → kp table first, `light` branch added.
4. **Time windows (C16)** → FH-07 / prototype windows, five states (new moon kept).
5. **Ground (C10)**, **clusters (C11)**, **ring hues (C14)**, **dance / site / field hues** → Mandala/Map colours win (§1.11).
6. **Legibility floor (C8)** → ≥ 11 pt and ≥ .5 α (4.55:1), the FIDELITY rule; .3 α is texture.
7. **Today name size (C9)** → 64 pt (56–72), Charter II "fuller" and DA2-12 "scale is reverence"; 44–48 retired.
8. **Reduce Motion (C21)** → loops pause, mechanisms quantize and lengthen, holds keep their length; global `animation: none` rejected.
9. **Restraint vs fullness (C20)** → fullness: HDR / bloom on, caps lifted (BC-03).
10. **World breath: scale 1.0035 vs opacity glow .07** → opacity glow (WO:57–61; scaling the yantra breaks its geometry).
11. **Ascent's white sky vs the Axis's dark** → Axis weather for bands 1–6, ascent sky from the Crown band (W7 is already milk-white
    `#F6F1E6`), ink flips at mean luminance .6; the point still warms to ember (law 5).
12. **After-effect** → 180 s, k², per-ring kind, never named (ruling 15).
13. **Persistent 33 dot `#C0392B` vs Mandala crimson `#8B1A2A`** → both canon: the point's ember is `#C0392B`, the yantra Bindu's ground /
    halo is `#8B1A2A`.
14. **Contrast mix 50 % vs 55 %** → 50 % oklab (BASE.css + gate.js are latest; 5.39:1 worst case); **scale cap 2.3× vs 2.4×** → 2.4×
    (FIGURES.css header, the later file).
15. **Status-as-light opacities vs "nothing scores him"** → kept as light of relationship (Design token), never shown as a number or
    label; petal counts and bloom meters stay out.
16. **Ring 2 HSL (43, 78, 52) renders `#E4AE25`, the token is `#D4A017`** → Atmosphere (HSL) derives light; the token hex is the
    cluster dot. Both kept, by role.
17. **Hamburger** (G7-0008) → the menu is a constellation of world-points (spine); the three-bar glyph retires to the spine world's ruling.

**Open (genuine questions for Ashrey):**

1. **The 33 rooms' derived colours.** rupakarshini marks the Body 10 / Mind 9 / Tree 7 hues "seeded — ratify per build". The Map's Color
   Hex exists for all 33 and wins, so nothing is blocked; the only thing for his eye is whether the **six-step colours derived from those
   hexes** (bright / glow / tint / border / soft) feel right on the first walk (ledger rows verify_by his-walk).

(Bīja near the figure: rupakarshini's corpus forbids a seed syllable in or near the yantra, but his settled point "bījas may sit in the
yantra" governs — not reopened.) Everything else above is settled from the rulings and evidence.

---

## 8 · Coverage

Every index id in `by-world/visual.jsonl`, with its disposition. Generated and checked by script (result pasted at the end).

| id | title | disposition |
|---|---|---|
| G1-0004 | Held attribute as the room's one actor | not this world (her-home) |
| G1-0009 | Leaving — her Siddhi lingers on the whole app, decaying, never named | placed (§2 #48) |
| G1-0014 | Existing shipped files that must not be rebuilt | placed (§2 #43) |
| G1-0017 | Gem.swift diffusion per ring (gem carries light) | placed (§2 #47) |
| G1-0018 | RingWorld: veil and tempo per ring | placed (§2 #35) |
| G1-0029 | Invariant 4: Reduced motion is longer and quantized, never disabled | placed (§2 #63) |
| G1-0032 | Invariant 7: Contrast floor; clamp particle size | placed (§2 #62) |
| G1-0042 | Existing hue tokens per ring (Atmosphere.swift — keep) | placed (§2 #7) |
| G1-0043 | Design tokens: ground #0D0508, gold #C9963F, cream #F2E8D9, accentRed #8B1A2A, Cormorant Garamond | placed (§2 #4) |
| G1-0046 | Bīja → visual rhythm locked to syllable — not built | placed (§2 #51) |
| G1-0047 | Esoteric tattva modifies dhātu light/material — not built | not this world (her-home) |
| G1-0055 | ATTR_TINT — 15 colour tints of her actor | not this world (her-home) |
| G1-0067 | Axis stack and render setup | placed (§2 #62) |
| G1-0069 | Presences — the 102 as points of light (ring radius, halos, met core, presiding crown) | not this world (climb) |
| G1-0070 | Presence pulse rates (met / authored / seat) | not this world (climb) |
| G1-0076 | Weather blending by climb: fog colour, veil, swallow density | placed (§2 #35) |
| G1-0080 | Beat 2 — Devanāgarī written by unseen hand (3 strokes, mask sweep) | not this world (her-home) |
| G1-0083 | Rite prompts and beat dots | not this world (her-home) |
| G1-0090 | Leaving: memory.record dwell, mark met, exposure +0.12 over 24 s | placed (§2 #48) |
| G1-0094 | Robustness: keep last good frame; dt capped 0.05 s | placed (§2 #62) |
| G1-0095 | Axis thumbnail/icon motif | placed (§2 #56) |
| G1-0096 | Axis UI CSS values | placed (§2 #4) |
| G1-0097 | H-CORE primitives: smoothstep, glowTexture (bloom stand-in), sprites, motes, driftMotes, loop | placed (§2 #62) |
| G1-0099 | WORLDS constants table (fog colour/density, veil, tempo per ring) | placed (§2 #35) |
| G1-0101 | W1 Feet — raked topaz floor, 11 standing stones, swinging sun (20 s day–night) | not this world (rings) |
| G1-0102 | W2 Pelvis — blood-pulse rings over sapphire pool (systole ^6) | not this world (rings) |
| G1-0103 | W3 Navel — 2,600-point GPU flow field (churn) | not this world (rings) |
| G1-0104 | W4 Heart — three RGB caustic planes over glossy floor, dispersive diamond prism (lunar fortnight ≈158 s) | not this world (rings) |
| G1-0105 | W5 Throat — 72-instance bone colonnade, 24 light shafts (lunar month ≈316 s) | not this world (rings) |
| G1-0106 | W6 Forehead — 9 marrow-lit translucent bodies glowing from within (season ≈952 s) | not this world (rings) |
| G1-0107 | W7 Crown — sourceless milk fog, zero directional lights (solar half-year ≈1904 s) | not this world (rings) |
| G1-0108 | W8 Above Crown — chatoyancy shader, one travelling band (year ≈101 s) | not this world (rings) |
| G1-0109 | W9 Totality — nine orbiting gem lamps, yantra of circles and triangles, core breath | not this world (rings) |
| G1-0111 | H-LIGHT — Atmosphere.swift port (ring HSL, cluster hues, ±7° jitter) | placed (§2 #7) |
| G1-0112 | atmosphereJitter and gemFor (c, ink, bright) | placed (§2 #43) |
| G1-0115 | SEAT shapes per ring and seatShell extrusion | not this world (her-home) |
| G1-0116 | aperture primitive (tri-down womb-seal, triad) | not this world (her-home) |
| G1-0247 | Attribute placement and second-adaptation growth (opacity multiply defect) | not this world (her-home) |
| G1-0249 | Attribute form: noose | not this world (her-home) |
| G1-0250 | Attribute form: goad | not this world (her-home) |
| G1-0251 | Attribute form: cup | not this world (her-home) |
| G1-0252 | Attribute form: arrows | not this world (her-home) |
| G1-0253 | Attribute form: bow | not this world (her-home) |
| G1-0254 | Attribute form: mirror | not this world (her-home) |
| G1-0255 | Attribute form: lotus | not this world (her-home) |
| G1-0256 | Attribute form: flame | not this world (her-home) |
| G1-0257 | Attribute form: rosary | not this world (her-home) |
| G1-0258 | Attribute form: trident | not this world (her-home) |
| G1-0259 | Attribute form: vajra | not this world (her-home) |
| G1-0260 | Attribute form: skullcup | not this world (her-home) |
| G1-0261 | Attribute form: plough | not this world (her-home) |
| G1-0262 | Attribute form: sceptre | not this world (her-home) |
| G1-0263 | Attribute form: garland | not this world (her-home) |
| G1-0264 | Attribute form: seed | not this world (her-home) |
| G1-0265 | Attribute form: gem | not this world (her-home) |
| G1-0266 | Attribute form: grain | not this world (her-home) |
| G1-0267 | Attribute form: lamp | not this world (her-home) |
| G1-0268 | Attribute form: chain | not this world (her-home) |
| G1-0269 | Attribute form: herb | not this world (her-home) |
| G1-0270 | Attribute form: ground | not this world (her-home) |
| G1-0271 | Attribute form: radiance | not this world (her-home) |
| G1-0272 | Attribute form: seal | not this world (her-home) |
| G1-0273 | Attribute form: palm | not this world (her-home) |
| G1-0274 | Attribute form: line | not this world (her-home) |
| G1-0287 | Descent shaft: 46 breathing rungs | not this world (her-home) |
| G1-0301 | Text recedes while you look (room never behind writing) | placed (§2 #39) |
| G1-0309 | Study Sarva-Trikhaṇḍā: multi-pass RGB render-target composite (convergence computed, not drawn) | not this world (her-home) |
| G1-0410 | Reduced motion in older studies = off / frozen — contradicts 'longer and quantized'; Axis slows but doesn't quantize | placed (§2 #63) |
| G1-0415 | Rite of Entering prototype stack and keyframes | not this world (her-home) |
| G1-0416 | Rite reduced motion: decorative drift stops, adaptation continues in quantized steps over longer total | placed (§2 #63) |
| G1-0417 | RT tokens (ground, gold, cream, red, serif, mono) | placed (§2 #4) |
| G1-0419 | Per-ring after-effect kind (sharper/wider/lighter/heavier) — the Siddhi's felt quality | placed (§2 #48) |
| G1-0430 | After-effect per Siddhi kind — filter/transform on whole instrument, 180 s, k², never named | placed (§2 #48) |
| G1-0432 | Seat Interior — room seen from inside her seat, one-point perspective, aperture as far wall | not this world (her-home) |
| G1-0435 | Seat draw order — ground, yantra beyond (second adaptation), bloom, aperture, floor-lit walls, shaft, dhātu grain, vignette | not this world (her-home) |
| G1-0436 | Seat light: farL 20 → 82 with adaptation; blur sharpens as eye adapts | placed (§2 #61) |
| G1-0446 | Motes visible only once the eye has adjusted (a > .2) | not this world (her-home) |
| G1-0459 | Living Rite keyframe vocabulary (motes, ripples, recognition responses, bīja pulse, collapse, sy-*, screen transitions) | placed (§2 #41) |
| G1-0460 | Living Rite reduced motion: global animation none (JS motion still runs) | placed (§2 #63) |
| G1-0462 | LR palette: base, cluster hues (hex), ring hue names | placed (§2 #4) |
| G1-0465 | lrAtmosphere derivation (accent, bright, soft, faint, ground mix 20%, groundDeep, glow, rotation ±22°) | placed (§2 #43) |
| G1-0466 | Time of day relights her (dawn/noon/dusk/night) — 'the light should move' | placed (§2 #44) |
| G1-0467 | moteMul never read; lrApplyTime(null) un-relit | placed (§2 #44) |
| G1-0471 | lrMoonName ranges and LrMoonGlyph | placed (§2 #44) |
| G1-0473 | Composition engine: element → structural archetype (ascension, descent, horizon, veil, foundation, radiance) | placed (§2 #45) |
| G1-0475 | LrSigil — āvaraṇa geometry as a spinning stroke sigil | placed (§2 #45) |
| G1-0476 | LrDepth vignette + grain; LrMotes per element animation | placed (§2 #45) |
| G1-0477 | Element backdrops (fire/water/air/ether/earth/light gradients) | placed (§2 #45) |
| G1-0499 | SriYantraGeometry (SY_R 320): bhūpura, gates, circles, 16/8 petals, 9 triangles table, breathing bindu | not this world (mandala) |
| G1-0501 | Mandala starfield: 150 stars, LCG seed 20260711 | not this world (mandala) |
| G1-0506 | Each energy breathes and flares on her own rhythm — the field is alive | placed (§2 #49) |
| G1-0532 | Living Axis concept: own 390×844 frame; tokens incl. --veil #080307, --silence #040104, --gold-bright #E8C97A | placed (§2 #4) |
| G1-0533 | Atmosphere engine ported from Atmosphere.swift (evidence native file exists); CLUSTER_HUE key selfBody vs self | placed (§2 #43) |
| G1-0541 | axBreath translate(−50%,−50%) offsets Bindu inner div (visual glitch) | placed (§2 #41) |
| G1-0550 | Living Axis keyframes (axBreath, axDot, axFloat, axRipple, axShimmer, axConverge) | placed (§2 #41) |
| G1-0559 | shakti-data.js COLORS, STATUS_OPACITY, CLUSTER_INFO; clusters by position | placed (§2 #4) |
| G1-0569 | The bar §1.1 The interface is the teaching; §1.2 Atmosphere not page — never introduce a new color | placed (§2 #2) |
| G1-0571 | The bar §1.5 The floor: tap ≥ 44pt; read text ≥ 11pt and ≥ 0.3 alpha | placed (§2 #64) |
| G1-0573 | Nothing in this app is a static screen — every surface generated from the Śakti (ring, cluster, element, hour); Atmosphere.derive pure | placed (§2 #43) |
| G1-0574 | DESIGN_SPEC port targets §2.1–2.8 (Atmosphere, TimeVariant, day cycle, six archetypes, Detail, Recognition, Mandala, Field/Well/Portrait) | placed (§2 #43) |
| G1-0583 | README: run over HTTP; reset lr_* keys; tokens; no external assets; build order | placed (§2 #4) |
| G1-0597 | Legibility and touch floor violations to fix, not copy (26px hits, 9px/7.5px names, 8px gauge, 10.5px at .34) | placed (§2 #64) |
| G1-0602 | Mandala-family shared visual constants (ground #060104, ancient amber #CF9443, petal path, motes) | placed (§2 #5) |
| G1-0636 | Codex document chassis (tokens, ambient, binduBreath 5 s, ring breath helpers 4/7/11 s) | placed (§2 #4) |
| G1-0655 | PureMandala motion: today petal 3.5 s; status-based petal breath 4.5/6/7.5/10 s; triangle brightness 9–18 s; bindu 4 s | placed (§2 #49) |
| G1-0656 | TIME_VARIANTS table — five home atmospheres (dawn, noon, dusk, night, new moon) | placed (§2 #44) |
| G1-0662 | v1 motion CSS (today name/prompt, petal-breathe 3 s, ripple-ring 4 s, recog timeline, silence-bindu 6 s) | placed (§2 #41) |
| G1-0663 | v1 primitives: StatusBar, TabBar, MoonPhase ('Waning Crescent · 23rd Night'), ClusterDot, DustMotes formula | placed (§2 #41) |
| G1-0667 | Giant bīja texture behind the screen (280–360px gold at ~.07) | not this world (today-rite) |
| G1-0692 | RingGlyph — the nine sigils from primitives | not this world (mandala) |
| G1-0699 | Ring-world CSS: rw7-sound-ring 1.6 s, rw7-chord-ring 2.4 s, rw8-triangle 18 s, rw8-collapse .9 s | placed (§2 #41) |
| G1-0700 | FaintRingMemory — 'The ghost of where you came from — outer rings as faint memory at edges' | not this world (rings) |
| G1-0710 | Ring Worlds II CSS (rw1-far-bindu, gate-ember, met-ring, drone-on, r3-smoke, r3-seed, r5-ray, r6-whisper, r6-heart) | placed (§2 #41) |
| G1-0727 | Eight Modes host keyframes and MiniYantra | placed (§2 #41) |
| G1-0777 | Breath ladder as one system across files; Ring 2 per-status breaths | placed (§2 #49) |
| G2-0003 | DS-02 emotional register (tone) | placed (§2 #4) |
| G2-0004 | DS-03 colour tokens | placed (§2 #4) |
| G2-0005 | DS-04 Ring 2 cluster colours (DS version) | placed (§2 #6) |
| G2-0006 | DS-05 typography three registers | placed (§2 #36) |
| G2-0007 | DS-06 Today size scale | placed (§2 #36) |
| G2-0012 | DS-11 lotus geometry | not this world (mandala) |
| G2-0014 | DS-13 animation timing table | placed (§2 #41) |
| G2-0056 | HO1-14 Handoff colour tokens | placed (§2 #5) |
| G2-0057 | HO1-15 cluster colours (Handoff version) | placed (§2 #6) |
| G2-0059 | HO1-17 spacing / negative space | placed (§2 #40) |
| G2-0087 | FB-09 nine ring atmospheres | placed (§2 #7) |
| G2-0091 | FB-13 nine-ring geometry at d=344 | not this world (mandala) |
| G2-0106 | UXA-01 legibility hard fails | placed (§2 #64) |
| G2-0113 | UXA-08 only saturated red CTA | placed (§2 #66) |
| G2-0116 | DA1-02 tokens exact; never a wellness app | placed (§2 #4) |
| G2-0126 | DA1-12 Call 5 legibility label-or-texture | placed (§2 #64) |
| G2-0127 | DA1-13 Bindu breath as language (slower deeper) | placed (§2 #51) |
| G2-0134 | RFB-04 R3 port regressions + glow ladder | placed (§2 #61) |
| G2-0157 | DA2-02 scale crisis | placed (§2 #36) |
| G2-0158 | DA2-03 one atmosphere for 102 | placed (§2 #43) |
| G2-0159 | DA2-04 tokens not composition | placed (§2 #36) |
| G2-0160 | DA2-05 system sans 9–11px UI debris | placed (§2 #36) |
| G2-0167 | DA2-12 The Living Rite four principles | placed (§2 #36) |
| G2-0170 | FH-02 reference prototype as design truth | placed (§2 #71) |
| G2-0173 | FH-05 nothing is a static screen | placed (§2 #43) |
| G2-0174 | FH-06 Atmosphere engine + lrBackdrop | placed (§2 #43) |
| G2-0175 | FH-07 time relighting deltas | placed (§2 #44) |
| G2-0177 | FH-09 six archetypes | placed (§2 #45) |
| G2-0179 | FH-11 Recognition ceremony responds in her nature | not this world (today-rite) |
| G2-0188 | R2R-01 prototype is source of truth for look/motion/behaviour | placed (§2 #71) |
| G2-0190 | R2R-04 prototype engines list | placed (§2 #43) |
| G2-0192 | R2R-06 prototype tokens | placed (§2 #4) |
| G2-0201 | RBB-08 Ruling 6: element per-ring table | placed (§2 #46) |
| G2-0204 | RBB-11 engine foundation (Atmosphere.derive, newmoon) | placed (§2 #43) |
| G2-0216 | XMB-00 master-brief errata | placed (§2 #54) |
| G2-0224 | XMB-08 Iconography grammar four layers | placed (§2 #67) |
| G2-0225 | XMB-09 Bindu on every screen, watching point | placed (§2 #55) |
| G2-0226 | XMB-10 VFX three moments | placed (§2 #54) |
| G2-0227 | XMB-11 Codex pass: nine Siddhis, Zero Gap, crawling haptic | placed (§2 #42, #52) |
| G2-0229 | XMB-13 one taxonomy (element) four bodies; quieter deeper | placed (§2 #52) |
| G2-0238 | HDP-05 per-ring hue tokens | placed (§2 #7) |
| G2-0252 | CCH-06 gem diffusion per ring | placed (§2 #47) |
| G2-0258 | CCH-12 Attribute actor (aniconic, 26 forms, grows 0.9→3.16) | not this world (her-home) |
| G2-0279 | THR-11 GPU luminance parity ranges | placed (§2 #61) |
| G2-0284 | THR-16 nine worlds as weather | not this world (climb) |
| G2-0300 | GH-02 Atmosphere divergences corrected | placed (§2 #43) |
| G2-0305 | SH-03 VFX proximity/focus principle | placed (§2 #54) |
| G2-0318 | AR-07 render stack (Canvas → SceneKit+Metal) | placed (§2 #62) |
| G2-0327 | ARD-05 UI defects SE width, z-order, sans slips | placed (§2 #36) |
| G2-0331 | BV2-L4 aniconic → no figural depiction | placed (§2 #67) |
| G2-0358 | BC-05/06 room test; Bindu-light a character | placed (§2 #55) |
| G2-0359 | BC-07 light stands in the air | placed (§2 #53) |
| G2-0360 | BC-08 every place moves as what it is | placed (§2 #51) |
| G2-0374 | WV-08 Wave 1 Light list | placed (§2 #49) |
| G2-0383 | RD-06 gap cause 2: binding condition, luminance | placed (§2 #61) |
| G2-0384 | RD-07 gap cause 3: port losses | placed (§2 #61) |
| G2-0387 | RD-11 first-principles table (lift caps, sound, doors) | placed (§2 #54) |
| G2-0389 | RD-13 Mandala/Rite Wave 1 list with numbers | placed (§2 #49) |
| G2-0401 | F08 Living Mandala cosmic tier on indigo | placed (§2 #5) |
| G2-0442 | C8 legibility floor | placed (§2 #64) |
| G2-0443 | C9 Today name size | placed (§2 #36) |
| G2-0444 | C10 ground colour | placed (§2 #5) |
| G2-0445 | C11 cluster colours | placed (§2 #6) |
| G2-0448 | C14 per-ring hue | placed (§2 #7) |
| G2-0449 | C15 breath rates | placed (§2 #49) |
| G2-0454 | C20 restraint vs fullness | placed (§2 #54) |
| G2-0455 | C21 reduced motion | placed (§2 #63) |
| G2-0457 | C23 figures | placed (§2 #67) |
| G2-0483 | DotStage: one dot never unmounted | placed (§2 #55) |
| G2-0491 | BUG covenant pool overlays text; 'Go.' on cream | placed (§2 #64) |
| G2-0508 | Tree image lightbox (pinch 1–6×) — image missing | not this world (the-33) |
| G2-0856 | B.1.15 ThePulse 58 Hz + glow arc | not this world (the-33) |
| G2-0857 | B.1.16 Ground / weather (starfield, horizon bleed) | not this world (the-33) |
| G2-0907 | B.6 shared legacy instruments | not this world (the-33) |
| G2-0912 | C.2 Shell Ground: weather by storyPos; pulse room 9→32 not wired | not this world (the-33) |
| G2-0925 | C.4 CLAUDE.md build law (chakra rooms) | not this world (the-33) |
| G3-0077 | Persistent Bindu dot on every panel | placed (§2 #55) |
| G3-0083 | BCA room 02 Muladhara and design notes | not this world (the-33) |
| G3-0089 | BCA room 03 Svadhisthana | not this world (the-33) |
| G3-0110 | BCA room 06 Vishuddha (shape constricts) | not this world (the-33) |
| G3-0122 | Atlas 09 Shadow | not this world (the-33) |
| G3-0137 | Mind rooms triads and colours | placed (§2 #57) |
| G3-0157 | Lalita animation 33→8→∞→♡ and map renames to A Strange Love Map | not this world (the-33) |
| G3-0159 | M-V5 Two-Act energy template (practice page) | not this world (the-33) |
| G3-0165 | M-LIGHTBOX tree image zoom | not this world (the-33) |
| G3-0167 | P-MUL Muladhara practice art and story scene | not this world (the-33) |
| G3-0168 | P-SVA Svadhisthana practice art and story | not this world (the-33) |
| G3-0169 | P-MAN Manipura practice art, story, timing conflict | not this world (the-33) |
| G3-0170 | P-ANA Anahata practice art and story | not this world (the-33) |
| G3-0171 | P-VIS Vishuddha practice (5 beats vs 11 conflict) | not this world (the-33) |
| G3-0172 | P-AJN Ajna practice art and story | not this world (the-33) |
| G3-0173 | P-SAH Sahasrara practice (five beats, tap to receive) | not this world (the-33) |
| G3-0174 | P-SHA Shadow corridor: walk by press-and-hold | not this world (the-33) |
| G3-0200 | P9 Maya Phase 2 POINTE timeline | placed (§2 #55) |
| G3-0206 | P9 Phase 7 Infinite Bindu Loop (76 s) | placed (§2 #55) |
| G3-0212 | C-GATE gate framework: L-system trace, colour fill, hold durations | not this world (the-33) |
| G3-0214 | C-POINTE Pointe animation v2 | placed (§2 #55) |
| G3-0216 | C-TREEGATE tree gate prototype | not this world (the-33) |
| G3-0229 | L1 Bindu Performance layer (ensemble of dancers) | not this world (the-33) |
| G3-0230 | L2 Element Canvas layer (burn/warmth/echo maps) | not this world (the-33) |
| G3-0270 | M-BLEED and M-LUMINANCE | placed (§2 #53) |
| G3-0275 | M-NEXTCOLOR and M-SIGIL | placed (§2 #59) |
| G3-0310 | Canonical decisions D10-D19 | placed (§2 #59) |
| G3-0322 | Persistent red Bindu: affection grown by repetition, never by reward | placed (§2 #55) |
| G3-0424 | C-1215 Wider net then core; level-aware guide; caution on generated imagery | placed (§2 #67) |
| G3-0487 | C-1306 Pointy: dot → line → circle → infinity → heart; 'the pointy loves' [KEY] | placed (§2 #55) |
| G4-0005 | Per-chakra systems designed 'from the element up — never re-skinned' | placed (§2 #3) |
| G4-0007 | Song-character colour guide (hue by character) | placed (§2 #57) |
| G4-0008 | Shape guide: song moment → shape | not this world (the-33) |
| G4-0010 | Ensemble dancer spec: Bindu (V2 template numbers) | not this world (the-33) |
| G4-0011 | Ensemble dancer spec: Gaia (V2 template numbers) | not this world (the-33) |
| G4-0012 | Ensemble dancer spec: Sid (V2 template numbers) | not this world (the-33) |
| G4-0013 | Ensemble dancer spec: Arch (V2 template numbers) | not this world (the-33) |
| G4-0014 | Ensemble dancer spec: Karishma (V2 template numbers) | not this world (the-33) |
| G4-0015 | Ensemble dancer spec: Sakshi (V2 template numbers) | not this world (the-33) |
| G4-0016 | Ensemble dancer spec: Ashrey (V2 template numbers) | not this world (the-33) |
| G4-0034 | Lesson #60: sacred geometry belongs to the dancer, not the environment | placed (§2 #68) |
| G4-0035 | Lesson #80: sacred geometry should use the actual yantra elements | placed (§2 #68) |
| G4-0039 | Shape library functions (heart, lemniscate, spiral, rose, circle, morph) | placed (§2 #55) |
| G4-0098 | Movement type RINGS (Muladhara (2)) | not this world (the-33) |
| G4-0099 | Movement type TRAILS (Svadhisthana (3)) | not this world (the-33) |
| G4-0100 | Movement type EMBERS (Manipura (4)) | not this world (the-33) |
| G4-0101 | Movement type RIPPLES (Anahata (5)) | not this world (the-33) |
| G4-0102 | Movement type WAVES (Vishuddha (6)) | not this world (the-33) |
| G4-0103 | Movement type CONSTELLATION (Ajna (7)) | not this world (the-33) |
| G4-0104 | Movement type ASCENT (Sahasrara (8)) | not this world (the-33) |
| G4-0105 | Movement type TRIANGLE (Soul / Aatma (31)) | not this world (the-33) |
| G4-0106 | Movement type GEOMETRY CYCLE (Maya (30)) | not this world (the-33) |
| G4-0107 | Inverse principle: the dot shrinks as energy grows | placed (§2 #55) |
| G4-0154 | Zimmer six tiers are roles, not visuals (Tier 0-5) | not this world (the-33) |
| G4-0168 | cross visual upgrade Tier 0-1 (Neev ground-marks, Sid columns, Gaia band, Vault, colour journey, grain) | not this world (the-33) |
| G4-0171 | cross visual upgrade Tier 4 (Schumann charged air, earth-rising, keystone cascade, Shweta clarity, crossingPeakIntensity) | not this world (the-33) |
| G4-0289 | Dance hues vs canon room hexes (Anahata 330 vs #6B8E4E; CHAKRA_HUES rainbow) | placed (§2 #57) |
| G4-0302 | Bindu Field element vocabularies (earth … dissolution 64 veil particles 9 s; soul 14 s breath) | placed (§2 #46) |
| G4-0305 | Cathedral tiers T1-T4 (Air/Ether), Shweta crystallization 22 shards | not this world (the-33) |
| G4-0316 | Bindu Field design tokens (Void #020208; TEXT rgba(245,226,214) 1.0/0.55/0.28/0.12; Lora italic 300; DM Mono; two-shadow glow; sheets) | placed (§2 #14) |
| G4-0326 | Geometry requires a 'why'; shape_choreography vocabulary and triggers | not this world (the-33) |
| G4-0331 | tiers t0-t5 contract (named pointers into vocabulary module); global_boost 0.8 | placed (§2 #68) |
| G4-0364 | cross.score.json identity/metaphor: element threshold; recognition; cathedral-v1; palette 260-285 + accent 35-50; forbidden turquoise/ocean blue/foam white | not this world (the-33) |
| G4-0370 | cross path and Two Rising Arches geometry | not this world (the-33) |
| G4-0381 | abide path: two infinities in the silences, heart at 170 'patient love', spiral return; geometry Five-Stage Wave-Fronts | not this world (the-33) |
| G4-0468 | Metaphor palettes with anti-borrowing (forbidden hues) keep the 15 worlds distinct | placed (§2 #3) |
| G4-0487 | Room colours: Field hue vs Mandala room colour (Svadhisthana 210 vs #D47438; Ajna 50 vs #5B4E8E; Anahata 330 vs #6B8E4E; Aatma 265 vs #D4A948) | placed (§2 #57) |
| G4-0579 | S3 lens colour signatures (one_word red, need green, holds gold, frequency blue, shape silver, grace rose, recognition gold) and two-step progressive disclosure | to Bindu Feed (readings); lens colours kept as dance structure (the-33) |
| G4-0637 | padakarshini formula: PAGE = CORRIDOR × FORM × WORLD-or-FIGURE × CONTENT | placed (§2 #69) |
| G4-0777 | Figure protocol: a drawn thing that is the content, changed per step via slots (data-ring, data-calm, data-sep, data-y, data-ph, data-tempo, data-lit, data-hour …) | placed (§2 #69) |
| G4-0778 | Contrast law: --acp = oklab mix(accent 50%, #191919) (not oklch — hue rotates up to 14.6°, 'turned a lavender into a rose'); worst case 5.39:1; --actext flips per ground; 'chrome over a figure ground: solid ink, never alpha' (.66 measured 3.87:1; solid clears 8:1); descent ink brightens | placed (§2 #64) |
| G4-0779 | GATE 6c: 44 px targets ('size the target, not the mark'); reduced motion: animations off, transitions 0.2 s, piece transform none | placed (§2 #63) |
| G4-0781 | Typography: Lora + DM Sans; kicker .k 11 px, .26em, uppercase | placed (§2 #37) |
| G5-0013 | Design-pass new elements (lawpick, rails, waiting card, page, play surfaces) | placed (§2 #69) |
| G5-0014 | Hit-test contract (stacking order) | placed (§2 #65) |
| G5-0015 | Accent tokens --ac / --acp / --actext and the 50% oklab mix | placed (§2 #64) |
| G5-0016 | Tap targets ≥44 px with a small visible mark inside | placed (§2 #65) |
| G5-0018 | Sideways doors between forms (DOORS.css) | placed (§2 #59) |
| G5-0020 | Performance rules for figures | placed (§2 #68) |
| G5-0029 | 41-family figure table | placed (§2 #69) |
| G5-0035 | 'Beyond' ideas: corridor remembers · grace library · density · figure as loading state · doors carry identity | placed (§2 #69) |
| G5-0040 | glyphs.json: one 60×60 glyph per form | placed (§2 #70) |
| G5-0067 | The nave (stone ground of the Light) | placed (§2 #8) |
| G5-0069 | Words made of particles (200 steam motes) | placed (§2 #8) |
| G5-0072 | The Aperture: an eye that turns faster while it draws | placed (§2 #56) |
| G5-0091 | The descent reveal (Feed) | placed (§2 #60) |
| G5-0106 | Bands of glass (fifteen bands) | placed (§2 #19) |
| G5-0112 | The Veil (page-change bloom from the touch) | placed (§2 #60) |
| G5-0124 | Haptic family (token family: Haptics) | placed (§2 #42) |
| G5-0229 | Tempo per room | placed (§2 #41) |
| G5-0248 | BASE.css tokens and grounds | placed (§2 #64) |
| G5-0249 | Figure primitive FIELD (the no-figure wash) | placed (§2 #69) |
| G5-0250 | Figure primitive HORIZON | placed (§2 #69) |
| G5-0252 | Figure primitive RAIL | placed (§2 #69) |
| G5-0260 | Figure primitive VESSEL | placed (§2 #69) |
| G5-0262 | Figure primitives CARD, SEATS, BAND | placed (§2 #69) |
| G5-0264 | Figure family DISTANCE / ATTUNE | placed (§2 #69) |
| G5-0268 | Figure family SEPARATION (sky/earth parting) | placed (§2 #69) |
| G5-0270 | MOVES: the move as five slots and the play library | placed (§2 #69) |
| G5-0272 | identity.js: stable seed from a name (FNV-1a) | placed (§2 #43) |
| G5-0278 | SCENE table for positions 21–33 | placed (§2 #57) |
| G5-0289 | Guide v2 / v3 (WORLD_CSS yantra world, readable()) | placed (§2 #64) |
| G5-0292 | gen_reading: element hues and the reading strip | placed (§2 #46) |
| G5-0302 | Contrast gate (gate.js) → Swift unit test | placed (§2 #64) |
| G5-0330 | rupakarshini formula: chassis ⊗ world ⊗ container ⊗ content | placed (§2 #1) |
| G5-0331 | The family as page layers (spine role grammar) | placed (§2 #2) |
| G5-0332 | Colour of consequence: --bindu #C0392B (red has no limits) | placed (§2 #66) |
| G5-0334 | rupakarshini page skeleton | placed (§2 #1) |
| G5-0335 | Universal laws (house) | placed (§2 #2) |
| G5-0340 | Borrowing law | placed (§2 #3) |
| G5-0342 | The ground as a position (law 2) | placed (§2 #17) |
| G5-0344 | Type changes only where a crossing means something (law 9) | placed (§2 #38) |
| G5-0345 | Law 8: every place moves as what it is | placed (§2 #51) |
| G5-0346 | Chassis B: thirty-three chakra worlds contract | placed (§2 #11) |
| G5-0347 | Chassis grounds (cream/void, live pair, paper, dusk) | placed (§2 #5) |
| G5-0348 | Chassis B as worn on aistrangegame.com (grounds, accents, type) | placed (§2 #5) |
| G5-0349 | The drawing law of five marks | placed (§2 #68) |
| G5-0351 | The site's five contracts | placed (§2 #1) |
| G5-0366 | Shape nesting rule | placed (§2 #3) |
| G5-0369 | Clause by clause | placed (§2 #39) |
| G5-0370 | Words sharpen as you reach them | placed (§2 #39) |
| G5-0372 | Letter-spacing closing | placed (§2 #39) |
| G5-0383 | A glyph family of strokes and dots | placed (§2 #70) |
| G5-0384 | Verb cards, link preview, editorial argument page | placed (§2 #11) |
| G5-0385 | Width rules (desktop) do not apply to iPhone | placed (§2 #40) |
| G5-0387 | A line that boils | placed (§2 #41) |
| G5-0418 | Figures are pure functions of time and data (law 12) | placed (§2 #68) |
| G5-0421 | Cathedral figure and 70-star field | placed (§2 #69) |
| G5-0422 | A name written inside the figure | placed (§2 #36) |
| G5-0424 | Display type as the figure | placed (§2 #36) |
| G5-0428 | Structure lens and lanes; outward side | placed (§2 #41) |
| G5-0445 | The kindling icon (app icon) | placed (§2 #56) |
| G5-0454 | Five ways for a paragraph to arrive | placed (§2 #39) |
| G5-0457 | Warm pulse at the bottom edge | placed (§2 #41) |
| G5-0459 | Words indexed on the figure | placed (§2 #36) |
| G5-0483 | Token family: shared slot grammar (--w-*) | placed (§2 #1) |
| G5-0484 | Token family Mandala (house chassis) | placed (§2 #4) |
| G5-0486 | Token family ChakraTable (chakra chassis) | placed (§2 #11) |
| G5-0487 | Token family Lalita (lalita chassis) | placed (§2 #17) |
| G5-0488 | Token family Leela (leela chassis) | placed (§2 #12) |
| G5-0489 | Token family Play (play chassis) | placed (§2 #13) |
| G5-0490 | Token family Ascent (ascent chassis) | placed (§2 #10) |
| G5-0491 | Token family Field (field chassis) | placed (§2 #14) |
| G5-0492 | Token family Being (being chassis) | placed (§2 #16) |
| G5-0493 | Token family Learning (learning chassis) | placed (§2 #18) |
| G5-0494 | Token family Feed (feed chassis) | placed (§2 #8) |
| G5-0495 | Token family Candle (candle chassis) | placed (§2 #15) |
| G5-0496 | Token family Blink (blink chassis: fifteen temperatures) | placed (§2 #19) |
| G5-0497 | Token family Linen (linen chassis) + the linen morning | placed (§2 #9) |
| G5-0498 | Token family Motion (Animation curves) | placed (§2 #41) |
| G5-0499 | Token family Pace (still / measured / quick) | placed (§2 #40) |
| G5-0500 | Token family Space and scales (spacing, type ladder, durations) | placed (§2 #40) |
| G5-0501 | Token family Spine roles (spine.css) | placed (§2 #2) |
| G5-0502 | Token family Fonts to bundle | placed (§2 #37) |
| G5-0503 | rk.css element core | placed (§2 #1) |
| G5-0504 | rk.js runtime | placed (§2 #1) |
| G5-0505 | Studio proof builds: eight-band page and thirteen questions | placed (§2 #1) |
| G5-0506 | Studio builds load no fonts (type unproven) | placed (§2 #37) |
| G5-0508 | Wazoodle brand home: the ladder-as-identity pattern | rejected — ruling: Chassis A brand worlds are business-only; nothing of content transfers |
| G5-0510 | Brand-home stale rk.css: illegible deep-band labels | placed (§2 #64) |
| G5-0513 | Visual language for Home (the Bindu): mandala (silence ground) | placed (§2 #20) |
| G5-0514 | Visual language for Today / the Rite: feed prayer for the Rite + mandala Living Rite palette per Śakti | placed (§2 #21) |
| G5-0515 | Visual language for The Mandala (held yantra + Veil): mandala | placed (§2 #22) |
| G5-0516 | Visual language for The nine rings: mandala data-world ring-1…9 | placed (§2 #23) |
| G5-0517 | Visual language for Her Home (her room): mandala per-being palette, S13 Room | placed (§2 #24) |
| G5-0518 | Visual language for Her Presence (portrait): feed identity-header grammar on mandala tokens | placed (§2 #25) |
| G5-0519 | Visual language for The Climb (Axis): ascent | placed (§2 #26) |
| G5-0520 | Visual language for The 33 (the braid): chakra (seven-colour table) extended to chassis B's 33 | placed (§2 #27) |
| G5-0521 | Visual language for A Strange Game: leela (board) + play (each game its own world) + linen (morning question) | placed (§2 #28) |
| G5-0522 | Visual language for The Modes: field (colour that follows the state) + candle for the Pūjā/evening | placed (§2 #29) |
| G5-0523 | Visual language for Time: mandala relit-by-hour + the three junction skies; linen for the morning page | placed (§2 #30) |
| G5-0524 | Visual language for Memory: being (day / dusk) + candle sheet for the printed record | placed (§2 #31) |
| G5-0525 | Visual language for The Well: lalita "under" + learning dark | placed (§2 #32) |
| G5-0526 | Visual language for Beneath: blink (temperatures warming toward the point) + learning dark | placed (§2 #33) |
| G5-0527 | Visual language for The Relationship Field: lalita night / paper (a Person) | placed (§2 #34) |
| G5-0531 | Element hues: field chassis eight vs app Element enum six vs ruling 4 vs site five | placed (§2 #46) |
| G5-0585 | Fabric/stitch metaphor and the temperature rule | placed (§2 #53) |
| G5-0630 | Homepage chakra palette A and Holi set (palette drift) | placed (§2 #57) |
| G5-0631 | Homepage world system (scroll snap, entry fade) | placed (§2 #41) |
| G5-0636 | WORLD_ESSENCE: per-world colour and voice table | not this world (sound) — WORLD_ESSENCE website voices |
| G5-0638 | One breath for image and sound: 0.08 Hz world breath | placed (§2 #51) |
| G5-0678 | Reveal states (height reveal) | placed (§2 #41) |
| G5-0680 | Scroll progress, softBounce cue, section snap | placed (§2 #41) |
| G5-0685 | Section templates (Room gated, Thread Segment, Voyager, numbers grid) | placed (§2 #69) |
| G5-0704 | Fonts disagree across ASG sources | placed (§2 #37) |
| G6-0004 | Map · Tree Caption · 1 Bindu | not this world (the-33) |
| G6-0011 | Map · Tree Caption · 2 Muladhara | not this world (the-33) |
| G6-0018 | Map · Tree Caption · 3 Svadhisthana | not this world (the-33) |
| G6-0025 | Map · Tree Caption · 4 Manipura | not this world (the-33) |
| G6-0032 | Map · Tree Caption · 5 Anahata | not this world (the-33) |
| G6-0039 | Map · Tree Caption · 6 Vishuddha | not this world (the-33) |
| G6-0046 | Map · Tree Caption · 7 Ajna | not this world (the-33) |
| G6-0053 | Map · Tree Caption · 8 Sahasrara | not this world (the-33) |
| G6-0060 | Map · Tree Caption · 9 Shadow | not this world (the-33) |
| G6-0064 | Map · Dyad Description · 9 Shadow | not this world (climb) |
| G6-0068 | Map · Tree Caption · 10 Soles | not this world (the-33) |
| G6-0072 | Map · Dyad Description · 10 Soles | not this world (climb) |
| G6-0076 | Map · Tree Caption · 11 Forge | not this world (the-33) |
| G6-0080 | Map · Dyad Description · 11 Forge | not this world (climb) |
| G6-0084 | Map · Tree Caption · 12 Prana | not this world (the-33) |
| G6-0088 | Map · Dyad Description · 12 Prana | not this world (climb) |
| G6-0092 | Map · Tree Caption · 13 Hands | not this world (the-33) |
| G6-0096 | Map · Dyad Description · 13 Hands | not this world (climb) |
| G6-0100 | Map · Tree Caption · 14 Pulse | not this world (the-33) |
| G6-0104 | Map · Dyad Description · 14 Pulse | not this world (climb) |
| G6-0108 | Map · Tree Caption · 15 Sonar | not this world (the-33) |
| G6-0112 | Map · Dyad Description · 15 Sonar | not this world (climb) |
| G6-0116 | Map · Tree Caption · 16 Echo | not this world (the-33) |
| G6-0120 | Map · Dyad Description · 16 Echo | not this world (climb) |
| G6-0124 | Map · Tree Caption · 17 Vision | not this world (the-33) |
| G6-0128 | Map · Dyad Description · 17 Vision | not this world (climb) |
| G6-0132 | Map · Tree Caption · 18 Axis | not this world (the-33) |
| G6-0136 | Map · Dyad Description · 18 Axis | not this world (climb) |
| G6-0140 | Map · Tree Caption · 19 Crow | not this world (the-33) |
| G6-0144 | Map · Dyad Description · 19 Crow | not this world (climb) |
| G6-0148 | Map · Tree Caption · 20 Armin | not this world (the-33) |
| G6-0152 | Map · Dyad Description · 20 Armin | not this world (climb) |
| G6-0156 | Map · Tree Caption · 21 Inception | not this world (the-33) |
| G6-0163 | Map · Tree Caption · 22 Intention | not this world (the-33) |
| G6-0170 | Map · Tree Caption · 23 Inspiration | not this world (the-33) |
| G6-0177 | Map · Tree Caption · 24 Insight | not this world (the-33) |
| G6-0184 | Map · Tree Caption · 25 Intuition | not this world (the-33) |
| G6-0191 | Map · Tree Caption · 26 Invention | not this world (the-33) |
| G6-0198 | Map · Tree Caption · 27 Incarnation | not this world (the-33) |
| G6-0205 | Map · Tree Caption · 28 Innocence | not this world (the-33) |
| G6-0212 | Map · Tree Caption · 29 Integration | not this world (the-33) |
| G6-0219 | Map · Tree Caption · 30 Maya | not this world (the-33) |
| G6-0226 | Map · Tree Caption · 31 Aatma | not this world (the-33) |
| G6-0233 | Map · Tree Caption · 32 Ego Reveal | not this world (the-33) |
| G6-0240 | Map · Tree Caption · 33 Lalita | not this world (the-33) |
| G6-0423 | Map · Colour Dyad · 10 Soles | placed (§2 #58) |
| G6-0424 | Map · Colour Dyad · 11 Forge | placed (§2 #58) |
| G6-0425 | Map · Colour Dyad · 12 Prana | placed (§2 #58) |
| G6-0426 | Map · Colour Dyad · 13 Hands | placed (§2 #58) |
| G6-0427 | Map · Colour Dyad · 14 Pulse | placed (§2 #58) |
| G6-0428 | Map · Colour Dyad · 15 Sonar | placed (§2 #58) |
| G6-0429 | Map · Colour Dyad · 16 Echo | placed (§2 #58) |
| G6-0430 | Map · Colour Dyad · 17 Vision | placed (§2 #58) |
| G6-0432 | Map · Colour Dyad · 18 Axis | placed (§2 #58) |
| G6-0433 | Map · Colour Dyad · 19 Crow | placed (§2 #58) |
| G6-0479 | Map · Tree (field family) | not this world (the-33) |
| G6-0489 | Map · System / Walker Journey Stage / Primary Color / Avarana (carried, unshown) | placed (§2 #57) |
| G6-0527 | Dyad system (Colour Dyad + Dyad Description) | placed (§2 #58) |
| G6-0599 | Map gift #4 · The tree in every room with its own touch verb | not this world (the-33) |
| G6-0604 | Map gift #25 · The dyad colours on the Climb | placed (§2 #58) |
| G6-0621 | Map C14 · Colour naming | placed (§2 #57) |
| G6-0753 | ASG gift #29 · Gratitude mood words as colours (vocabulary only) | rejected — floor: his journals private (excluded read; vocabulary only) |
| G6-0783 | Code core · FIDELITY.md (132) · design-fidelity checklist | placed (§2 #71) |
| G6-0850 | Code core · Atmosphere.swift (160) · per-Śakti palette | placed (§2 #43) |
| G6-0851 | Code core · AtmosphereBackground.swift (73) | placed (§2 #45) |
| G6-0852 | Code core · BreathClock.swift (88) · one breath, one point | placed (§2 #50) |
| G6-0853 | Code core · Color+Tokens.swift (52) | placed (§2 #4) |
| G6-0854 | Code core · DayLight.swift (156) | placed (§2 #49) |
| G6-0855 | Code core · DepthOverlay.swift (71) | placed (§2 #45) |
| G6-0856 | Code core · Element.swift (48) | placed (§2 #46) |
| G6-0857 | Code core · Fonts.swift (169) | placed (§2 #36) |
| G6-0858 | Code core · HSL / Haptics / Layout / SeatLighting | placed (§2 #42) |
| G6-0859 | Code core · LightField.swift (253) · CSS gradient vocabulary | placed (§2 #45) |
| G6-0860 | Code core · MandalaLight.swift (417) · one source, nine refractions | placed (§2 #47) |
| G6-0902 | Code gift #34 · Atmosphere, LightField, DayLight, DepthOverlay | placed (§2 #43) |
| G6-0921 | Code missing · Per-world breath | placed (§2 #50) |
| G6-0924 | Code C-3 · Ruling 4 elements (Ahaṅ fire, Nāma air, Ātma light, Amṛta water) | placed (§2 #46) |
| G6-0929 | Code C-6b · Restriction still enforced: one breath clock | placed (§2 #50) |
| G6-0964 | Homes file · HomeGem.swift (125) | placed (§2 #47) |
| G6-0976 | Homes file · RoomLightPass.metal (162) | placed (§2 #61) |
| G6-0977 | Homes file · RoomLightRig.swift (264) | placed (§2 #47) |
| G6-0979 | Homes file · RoomAir.swift (1118) | placed (§2 #61) |
| G6-1003 | Homes file · WorldClimb.swift (481) | not this world (climb) |
| G6-1004 | Homes file · WorldBands.swift (729) | not this world (climb) |
| G6-1005 | Homes file · WorldClimbScene.swift (963) | not this world (climb) |
| G6-1016 | Homes parity · Nine worlds as weather W1–W9 (H-WORLDS) | not this world (her-home) |
| G6-1017 | Homes parity · World tempo on the world clock only; veil ×0.55 | not this world (her-home) |
| G6-1018 | Homes parity · Gem diffusion; Crown sourceless (no key) | placed (§2 #47) |
| G6-1019 | Homes parity · Atmosphere hue port, ±7° jitter, Ring 2 cluster seeds | placed (§2 #47) |
| G6-1063 | Homes upgrade C2 · Lift the binding condition in the mechanism layer | placed (§2 #61) |
| G6-1064 | Homes upgrade C3 · Show her attribute as a lit, aniconic performing shape | not this world (her-home) |
| G7-0008 | HamburgerButton three bars and first-run breath | not this world (spine) — menu glyph; see §7 settled 17 |
| G7-0029 | MandalaCanvasLayer draw order | not this world (mandala) |
| G7-0030 | Starfield count, seed and ranges wrong vs Design | not this world (mandala) |
| G7-0031 | Motes envelope by time variant | not this world (mandala) |
| G7-0032 | Enclosures as hairlines or gem bands | not this world (mandala) |
| G7-0035 | Yantra layers breath, shimmer, triple glow, gate lights | not this world (mandala) |
| G7-0037 | Seat radii, breath, flare, names | not this world (mandala) |
| G7-0041 | SriYantraGeometry exact to Design | not this world (mandala) |
| G7-0045 | MandalaSky indigo sky across the hour | placed (§2 #5) |
| G7-0063 | RingGlyph nine glyphs, rings 4-7 shared | not this world (mandala) |
| G7-0090 | CentreYantra = Design FullYantra | not this world (home) |
| G7-0100 | Rite layer stack | placed (§2 #45) |
| G7-0116 | RiteSigil | placed (§2 #45) |
| G7-0131 | DustMotesView by element | placed (§2 #45) |
| G7-0138 | Recognition six natures exact | not this world (her-presence) |
| G7-0139 | RecognitionLight beyond Design | not this world (her-presence) |
| G7-0146 | ChakraRoomDoor presenter and room fields by kind | not this world (the-33) |
| G7-0229 | PlayRipple | not this world (game) |
| G7-0278 | Lalita's field drawing | not this world (game) |
| G7-0295 | Glow and core drawing helpers | placed (§2 #62) |
| G7-0311 | PlayInk settled line rule | placed (§2 #64) |
| G7-0327 | ScoreLightVeil | placed (§2 #51) |
| G7-0328 | HerSiddhiLingers after-effect | placed (§2 #48) |
| G7-0425 | Designed piece: Persistent 6 px Bindu dot | placed (§2 #55) |
| G7-0450 | Gift: Next-colour bleed at room exits | placed (§2 #59) |
| G7-0560 | BottomScrollFade | placed (§2 #40) |
| G7-0614 | Aniconic: no figure of a Sakti (floor) | placed (§2 #67) |
| G7-0615 | Aniconic: catalogue and iconographic-field pins (lifted) | placed (§2 #67) |
| G7-0656 | DeviceSlipTests | placed (§2 #63) |
| G7-0884 | Floor test: LawsTests.swift:856 Aniconic figural vocabulary | placed (§2 #67) |
| G7-0885 | Floor test: HomeAttributeTests.swift:304 | placed (§2 #67) |
| G7-0886 | Floor test: RoomSceneTests (no figural node) | placed (§2 #67) |
| G7-0887 | Floor test: RecognitionNatureTests.swift:299 | placed (§2 #67) |
| G7-0888 | Floor test: PlayTests.swift:573 | placed (§2 #67) |
| G7-0935 | New test: Design parity | placed (§2 #71) |
| G7-0945 | Numbers parity read from Design's own files | placed (§2 #71) |
| G7-0946 | Geometry parity | placed (§2 #71) |
| G7-0947 | Light parity | placed (§2 #61) |
| G7-0948 | Timing parity | placed (§2 #71) |
| G7-1025 | Light bounds far below Design | placed (§2 #61) |

**Script check** (`python3 -I cov.py` over `by-world/visual.jsonl` vs the ids in §2 sources and the dispositions above):

```
slice ids 507 unique 507 placed 324 special 5 not-this-world 178 UNPLACED 0 ids in §2 not in slice []
```

Every one of the 507 ids appears exactly once in the table above; none is missing; every id cited in §2 belongs to the slice (cross-references to other slices are marked "cross-ref" and excluded).
