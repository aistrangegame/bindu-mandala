# Her Home and Her Presence — the upgrade map, worlds 5 and 6

Stage 2 of the upgrade map (WORLD-BRIEF.md). Slices read in full: `index/by-world/her-home.jsonl` (886 rows) and `index/by-world/her-presence.jsonl` (217 rows), 1,058 unique ids. Register lines were opened wherever a row was thin (01-homes 176–190, 02-rite-axis-field 30–120, 04 frames 648–702, 17-code-core 40–175, audio-on-github). Code paths are relative to `iOS/Bindu Mandala/`.

Rulings applied throughout: READER-BRIEF-2 rulings 1–10 and floors, INDEX-BRIEF rulings 11–17 and the settled points. In this file the ones that do the most work are: **15** (the after-effect is felt and never named, "you have stood here before" returns once inside her room with floor traces as light, the Climb's 102 lights stay alike), **17** (everything is shown word for word, revealed through the room's form and never as a page), **10** (restrictions such as "no menu", "one sound at a time" and "three controls" are lifted), **4** (Ahaṅ fire, Nāma air, Ātma light, Amṛta water), and these floors: no figure of a Śakti, nothing scores him, nothing is invented, position is identity, App Activity is the single ledger, the two Recognition lines are kept verbatim.

---

## 1 · The world

### 1.1 Her Home in his words and in Design's

In his words. **C-1337** (6 May 2026) is the mandate this world exists to answer: *"map out all of the Sri Yantra Mandala energies. And then map these out as experiences for each energy … how you can connect with it and how you can interact with it, how you can experience it through allowing it to experience reality … build a practice to allow them to experience you. So you're building like a two way practice … knowledge, will, action."* Other entries shape it:

- **C-1060**: familiarity that "grounds you". This is the return.
- **C-1219**: "before we even get to experience that thing, we've formed a judgmental opinion." So the room never tells him what he will feel before he meets her.
- **C-1224**: "keep them where they are and allow them to engage to the full level on that topic itself." The doors open sideways and never send him out.
- **C-1279**: "the full journey … or they can just jump to the end." The room is the journey and the library is the one page.
- **C-1354**: "the second time I come back … a more deeper perspective." Each return opens the room further.
- **C-1119**: "the light and darkness are basically both the same." No room is valued over another.
- **C-1242**: "In that negation you are able to find what remains." This is what every second adaptation does.
- **C-1244**: "Energy follows intent." This is the activation cycle.
- **C-1145**: "Feel it in your hands … Once you have felt it through, now comes recalibration." The room's first minute asks for nothing.
- **C-1316**: his own word for these places is *spaces*: "an expansive space … a voice space … the Gaia space … built on the foundation of the origin."

In Design's words: *"This place is doing something to me, and it could not be any other place."* (S13 Room shape). *"Every home shares one architecture — the ceremony of entering, dwelling, and leaving. This is what makes 102 rooms feel like one building. Inside that architecture, every room is hers alone."* (01-homes:109). *"The room is the mechanism … A room whose far wall is not there is a mechanism. Every frame here changes what the room does."* (01-homes:744). *"Rooms are not 102 authored screens."* The ring gives the archetype and her card tunes it (01-homes:60, 388). *"The Turrell mechanism lives here: one normalized value a advances so slowly that nothing appears to happen, and every surface in the room reads from it."* (02:1497). *"There was never anyone here but Her."* (01-homes:98).

**What this world is.** Her Home is her room. There is one room for each of the 102 Śaktis, keyed by khaḍgamālā position (kp 1–102). Every ordinary tap on a Śakti now opens it. Today that tap lands on `ShaktiDetailView`, a 2D text page, with the room behind a link at the foot (18-code-homes:6, 129). The reversal is the first act of this upgrade:

- **The room is the Home.** You arrive there through the Rite of Entering.
- **The Detail becomes the library folded inside it.** The reference rows sit on one control and at the floor of each descent.
- **The Detail's soul becomes Her Presence (world 6).** That is her portrait, reached from the room by "her presence" and from every place that today says "know her".

The Home has two modes and two further depths:

1. **The Room** (default). This is the 3D mechanism room built in `Homes/`. Its binding condition is lifted, so her mechanism draws lit, non-figural geometry from Design's recipes, at Design's luminance (80–255, not 11–65).
2. **The Light Room**. This is the Rite of Entering's seat interior (R-09/R-11). It is one-point perspective, with the aperture as the far wall, the far-wall Śrī Yantra arriving at the second adaptation, portrait lines surfacing by stillness, her letter, and the fall through five chambers. It runs on its own clock of 90 × rate, 165 and 120 s.
3. **Going deeper**. The Room's shaft has five stations and the Light Room's fall has five chambers. Both end at *the floor of her*, which is the library.
4. **Her Dance**. This is a songless dance made from her own tone, entered by a door in her room or by a long hold on her seat in the Mandala.

### 1.2 Arriving

**Ways in.** Every way in runs through the Rite of Entering (§5 lists every door). Today's routes are `HerRoomDoor.swift:16-25` and `RiteOfEnteringView.entering`. The crossing travels through the point and blooms from the touch in her ring's colour. It is never a full-screen hard cut.

The crossing has three forms. Each keeps its own source numbers.

- **From the Mandala seat (fly-in).**
  - The log-scale camera holds the current enclosure at a constant share of the screen. Enclosure radii are [1.38, .93, .77, .62, .50, .39, .29, .20, .125, .06], with R = min(W,H)·0.335, scale = exp(lerp(ln(R/BAND[i]), ln(R/BAND[j]), f−i)), and a breath of ×(1+0.010·breath) on 10 s (G5-0056).
  - The flight goes to her seat at scale 3.0, placed at (w/2, 0.36h), easeOut 0.72 s.
  - The chamber holder is then placed at her seat at scale 0.02. Her world's air thickens and swallows the surroundings. Presences vanish past swallow 0.7 and the band past 0.96.
  - Her room grows 0.02 + 0.98·swallow, so the point becomes her room (G1-0084, G1-0324). The rite's three beats run while this happens.
- **From the Climb (a light touched).**
  - The flight lasts 1.1 s (`WorldClimbView.swift:247-260`) and continues straight into the rite.
  - Today a `fullScreenCover` hard-cuts at this point (G6-1015). That cut is removed.
- **From Today or the Bindu (the Pulse Gate).**
  - A circle breathes over 3 s. Holding it for 2.5 s fills a ring, and an 80 ms haptic marks completion.
  - The circle then scales ×40 and becomes the room (G5-0675).

**Optional beat 0: a body cue.** One verbatim Threshold Invitation, chosen by her bodily location, for example "Feel your feet. Something has been carrying you all day without being asked." It shows for one breath of 5.5 s before beat 1. This is offered only if he says yes to reusing the Walks table (open question Q2). His C-1145 grounds it.

**The Rite of Entering: three self-paced beats (G35).** Each beat writes itself and then waits. It never auto-advances and is never skipped. A return compresses it but never removes it.

| | Beat 1 — the inscription | Beat 2 — the unseen hand | Beat 3 — the roots |
|---|---|---|---|
| Content | her Appreciation Phrase (`fldBqEDpBonMc2s1K`) ‖ her ring's appreciationPhrase ‖ "Thank you for what was always already here." (Design-authored fallback) | Devanāgarī (`fldDhcJ1BJQCM5llO`) ‖ her name | etymology roots (`fldXypzqrhVILCqgh`, split on " + ") if >1 part, else `riteRoots` morphemes (prefixes Sarva, Anaṅga, Mahā, Tripura, Kāmeśvarī, Vajreśvarī, Bhaga; suffixes ākarṣiṇī, karṣiṇī, mayī, pradā, kāriṇī, sundarī, mālinī, eśvarī, iṇī, inī — "only splits on morphemes that actually occur in the khaḍgamālā") |
| Type | 23 px cream, tracking .04em | 38 px | roots 25 px |
| How it arrives | opacity clamp(bp/0.34)×0.94 | 3 strokes; seg = min(2.999, bp×3); each stroke completes at 72 % of its third; mask linear-gradient(90°, #000 pct %, transparent pct+7 %); true stroke-order paths where available (shirorekhā head-rule drawn first, G4-0791) | split = clamp(bp/0.58), join = clamp((bp−0.52)/0.48), gap = (1−join)×split×30 px; gloss (quality) italic 16.5 px fades in clamp((bp−0.6)/0.4)×0.6 |
| Flight station | travTo .30 | .62 | .88, then the 4th touch → 1 (entering) |
| Struck tone | carrier ×1 | ×1.5 | ×2. Sine, 0 → 0.05 in 20 ms, exponential decay to 0.0001 by 3.4 s, stop 3.6 s (`HomeCarrier.strikeFrequency`) |

Beat timing and pacing:

- **Beat length.** Each beat lasts 2.4 s (3.4 s under Reduce Motion), multiplied by the return compression: max(0.36, 0.68^min(v,4)), giving 1 → .68 → .4624 → .36 (`HomeMemory`, built).
- **No early cut.** A touch is ignored until bp ≥ 0.99, so an eager touch can no longer cut a beat short (fixes G1-0411).
- **Prompts.** The prompt reads "touch to go on" (beats 1–2) and then "touch to enter". It is set in mono 9 px, .3em, opacity .44, and appears only at bp ≥ 0.99.
- **Beat marks are restored.** Three dots sit at bottom 88 px, each 4×4. The current one is 16 px wide in gold, done ones are gold at .6, pending ones are cream at .25, with 500 ms transitions. They mark the ceremony's own three beats and say nothing about him. The refusal at `RiteOfEnteringView.swift:60-63` was app-added and is lifted by ruling 10.
- **Rite overlay.** The overlay fades in over 700 ms. The top line reads "{region} · the {ordinal} āvaraṇa", her name, her quality. The low line reads "{region} · {gem} on {dhātu}".
- **No cancel at the threshold.** This is kept (RD-11).

### 1.3 Being there — the Room (mode 1)

The room is built in three layers (01-homes:748):

- **The building** is shared, nearly invisible, and the same in every room.
- **The world** is her ring's weather.
- **Her mechanism** is the whole design.

**The clock (per Śakti).** Time is elapsed, never device motion. Stillness may govern only the arrival of a line.

- **Rate.** Each Śakti has a rate (fast ×0.72, even ×1.00, slow ×1.38, late ×1.12, from R-02). The rate is set by the ruling in §7 C1 and listed in Appendix A.
- **First adaptation.** a = smooth(t / (62 × rate.mul)), which is 44.6 / 62 / 85.6 / 69.4 s.
- **Hold.** The hold lasts 165 s.
- **Second adaptation.** b = smooth((t − holdEnd)/120).
- **Labels.** The near words flip to the deep words when b > 0.45.
- **Today's code.** The code runs every Śakti at 62/227/347 (`HomeMemory.swift:82`). The marks become functions of kp: adaptEnd(kp), holdEnd(kp) = adaptEnd + 165, secondEnd(kp) = holdEnd + 120.
- **Head start.** The room clock starts at the head start (§7 C3).

**Resolution by kp.** This is built, in `HomeRooms.swift:201-269` and `RoomReversal.swift:303-319`. The order is:

1. One of the eight authored rooms: kp 1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve.
2. Otherwise her ring's archetype, tuned by her card.
3. Otherwise her seat from inside. No kp reaches this floor today (WholeInstrumentTests), but it is kept as the floor.

**Lifting the binding condition.**

- `RoomMaterial.swift:17-23` still declares that every attribute is "an action on the room's own material … never a free-standing emissive solid". `RoomScene.swift:79-129` lets mechanisms return only surface actions. This is the root of the flat rooms.
- Charter II lifted the condition for `RoomAir` (RD-11: binding condition → "no figural depiction") but not for the mechanism layer.
- **Change:** `RoomSurfaceMechanism` may return *light bodies and non-figural geometry* in the *her* and *world* layers. That includes emissive solids, line loops, sprites, transmissive and physical materials, shaders, spotlights with shadows, and render-target composites.
- The stone inscription (impression, furrow, crack, swell, compaction) stays as a second register under the light. Today's dents become the floor's memory of what the light does.
- The rule that stays is: **no figure**. Shapes do one thing each and never depict her body.

**The eight authored rooms.** Each is ported literally from Design's three.js recipe (01-homes:356–378, with the Rooms-in-3D techniques mined in for kp 3, 4 and 28). Every number is in §2 rows HH-09 to HH-17 (HH-13 is Garimā's way out). In one line each:

- **kp 1 Aṇimā — CONTRACT.**
  - The walls close to 34 % (k = 0.34 + 0.66(1 − smooth(t/a))).
  - The aperture widens as (0.5 + 0.5/k)(1 + 11b), so twelvefold at the second adaptation. The key light is 900/k².
  - "The beyond" sprites travel from z −18 to −5.
  - Words: "the walls close while you stand still" → "the point was a door all along".
- **kp 2 Mahimā — ENDLESS.**
  - 24 lit seat-shaped frames (r 6 + 0.52i) recycle toward you over a span of 120 at 3.4 u/s.
  - Opacity is sin(π·clamp((z+120)/120))·0.95 + 0.06, with a haze sprite of 60 at op .16 and 140 motes.
  - At b, 10 frames continue behind you.
  - Words: "no far wall · it never arrives" → "you were never inside anything".
- **kp 3 Laghimā — RELEASE.**
  - Four cloth walls (26×13) have hems that lift: hem = smoothstep(0.62, 0, uv.y); p.y += hem·(uLift·2.4 + sin(uTime·.42 + p.x·.55)·.42·hem).
  - A lid ring (2–12.4, op .18) sits at y 8.4 with a sky sprite of 16. A black ground disc (r 16, op .55) gives a dark to rise from.
  - 340 rising points (gl_PointSize clamped 1–9) rise at 0.34 + lift·1.5.
  - The unmoored seat torus (r 1.6) drifts up: y −3.4 + 4.2·lift.
  - At b the walls rise 1.4 + b(15 + 2.4i), the lid descends, and the sky takes the room.
  - Words: "the floor has let go" → "the room has let go of itself".
- **kp 4 Garimā — PRESS.**
  - The ceiling slab (46×4.4×46) descends: y = 11 − 7.4k (+5.2b).
  - The strata ground displaces .5 + 1.9k (+1.4b), using a strata texture of 32×512 with bands 5–27 px and values 14–232.
  - The palm-press is 2.1/2.5, tint 0xB8263C, emissive 1.4 + 3.4b.
  - The ember light is 1300 and the raking light is 3.6 at (9,6,4). The fog thickens as 0.03 + 0.028k.
  - Leaving costs effort: the way-out hold is 3.3 s here, and the slab lifts 0.6 units while you hold.
  - Words: "the ceiling is coming down" → "the weight was holding you all along".
- **kp 6 Vaśitva — KNOWN.**
  - Box room 16×10×30 with 6 *standing* pillars and a torus seat.
  - A SpotLight of 2400 (dist 44, angle 0.4, penumbra .88, decay 1.55) with real shadow wanders: wx = sin(.16t)·5.2 + sin(.058t)·1.8, wz = −11 + cos(.125t)·5.4, wy = −2.4 + sin(.093t)·2.1.
  - At b it converges on you, with angle .4 − .17b and intensity ×(1 + .7b).
  - Colours come from her gem, not fixed violet.
  - Words: "the room exists only where attention rests" → "it has turned, and it rests on you".
- **kp 27 Sarva-Yoni — MEMBRANE.**
  - A transmissive lathe vessel: r = max(.06, 7.6·sin(π(.10+.82u))^.82), MeshPhysical 0xd4795c, transmission .94, thickness 3.4, ior 1.38, attenuation 0x8c2e1e @2.6, sheen .7.
  - 8 veins and backlights of 540/420/420/320/250. Nested vessels at ×1.55, 2.3 and 3.2.
  - It breathes as sin(0.28t), about 22.4 s.
  - Words: "no door · you were always inside" → "source within source · it was never one womb".
- **kp 28 Sarva-Trikhaṇḍā — TRIPLE.**
  - One neutral room is rendered three times into three render targets, offset by [(−1,−.42),(1,−.22),(.06,1)] × sep × (.52,.46).
  - They are composited as sep = vec3(a.r, b.g, c.b) and one = (a+b+c)/3, out = mix(one, sep, uSep). Convergence to one white room is computed, not drawn.
  - sep = settled(1−b) + breath·b, where breath = (.5+.5 sin((t−holdEnd)·.085))·.58.
  - The three tinted shells (0xff5a52, 0x4fe0a8, 0x6f8fe0) stay as a fallback below the GPU budget.
  - Words: "three rooms · one seal, only in stillness" → "three and one, and always both".
- **kp 102 Mahātripurasundarī — DISSOLVE.**
  - A gold line yantra (0xfff2cf, op .46) *standing in air*: 3 squares (r 13/11.6/10.2), circles r 9 and 8.1, a 16-petal ring (6.4→8.9), an 8-petal ring (4.9→6.3), and 4 upward plus 5 downward triangles.
  - It breathes br = sin(.115t), at scale (.94 + .07br)(1 + 2.1b), and z = 7.4b carries it behind you. The triangles counter-rotate at −t·.014.
  - The bindu (sprites 7.5/22 plus a sphere of r .2) comes from z −8.4 to 0, to where you stand, with its source halo restored.
  - Words: "there was never anyone here but Her" → "the bindu is where you are standing". Built last and by hand.

**The ten archetype rooms.** Each archetype comes from the ring, and each room is made hers by four tuning channels: physics (tattva + quality, one of 50 motions plus 3 appended), altitude (feet 0.94 → crown 0.10), phase ((kp mod ringCount)/ringCount), and words (quality). Design's lit objects return. Today's built marks stay beneath as the floor register (01-homes:452–470).

| Ring / family (kp) | Archetype | What is in the room | At b | Words (near → deep) |
|---|---|---|---|---|
| R1 Siddhi (1–10) | lent | an octahedron (r 1.5, emissive ×2.4) at (0, y, −9), moved by displace(kind, t, ph, 2.2), with six square echo loops each delayed 0.6 + 0.5i s | the lent object shrinks to 20 % and the shell goes to op 1 − .7b | "{quality} · lent, not shown" → "the capacity was never lent" |
| R1 Mātṛkā (11–18) | letters | a ring of n = 5/8/11/14 emissive slats at r 6.4; turn = (t·0.22 + i/n) mod 1; emissive 1.4 + max(0, sin π·turn)^8·5 + 1.8b; a voice column rising from the chest; a floor disc r 13 | letters stretch y ×(1 + 3.4b) | "{quality} · {syllable}" → "the letters were never separate from the voice" |
| R1 Mudrā (19–28) | a seal you stand inside | five digit tubes on an 11-point arc (−0.9…+0.9) inside a sphere shell r 16, with a held sprite of 4.4 | digits open by rotation.x = b·.42(1 + .1i); the held sprite grows ×(1 + 3.6b) | "{quality} · a seal you stand inside" → "the seal has opened its hand" |
| R2 (29–44) | crossed | a petal shell r 11; a presenting half of 7 thin tori (near) and an answering half of 7 sprites (lower, further) running displace(kind, t, ph + i/14) against displace(kind, t + 3.2, ph + .5 + i/14), in opposite phase | the halves converge | "{near}, answered in {far}" → "the {near} and the {far} were one sense"; kp 44 → "body and mind were one point"; uncrossed kp 29–33 → "{quality} · drawn toward the centre" → "the drawing and the drawn are one". kp 33 Sparśa has no walls, only surface (G1-0048) |
| R3 Anaṅga (45–52) | bodiless | 8 gem petal sprites orbit an empty centre at r 5.4; a torus rim r 1.5 is "a rim of light around nothing"; key light 2200 at the empty centre | shell op 1 − .8b | "{quality} · and nothing there to feel" → "the effect was the only body" |
| R4 (53–66) | cosmic | 14 nested triangle loops (r 3.4 + 2.1i) inside a sphere shell r 26; the same motion delayed 0.42 s per shell, amplitude 1 + .22i | — | "{quality} · at the scale of worlds" → "the gesture had no centre to leave" |
| R5 (67–76) | giving | an open cylinder r 11 h 22; 12 gift sprites spiral from r 16 to r 1.4, u = (t·0.055 + i/12) mod 1 (about 18 s); your hands as a torus cup r 1.9 | cup ×(1 + 4.2b) | "{quality} · arriving, unasked" → "the giving and the given are one" |
| R6 (77–86) | revealing | 10 icosahedra (emissive ×3.2) on r 6 under a *lit* veil sphere r 9.4 (ink op .72) | veil op max(0, .72 − .46a − .26b) | "{quality} · already here, behind the veil" → "it was never hidden · you were the veil" |
| R7 Vāsinī (87–94) | sounding | an open cylinder r 9 h 24 with the shader w = sin(ang·n + t·.5)·cos(y·.5 + t·.3), n = 2 + (kp mod 8); amp .5 + 1.6b; n node sprites at r 8.4 ("where the syllable is silent") | amp rises | "{quality} · {bīja}" → "you are inside the syllable" |
| R7 Weapons (95–98) | **sounding, struck** | as R7, plus "Weapons strike" (G1-0049): once per breath of the world tempo the wall takes one strike, a mode-n impulse at 0.55 s decay, with the struck tone ×2 at 0.03 | — | "{quality} · the room is her sound" → "you are inside the syllable" |
| R8 (99–101) | sourcing | a triangle R 4.6; her corner a white sprite 6.4 with light 900; the others 2.4 at op .2 with light 90; a bindu sprite 2.6; shell r 15 | the others answer: op .2 + .7b, light 90 + 700b | 99 "will, before there is anything to will" → "will was already act and form"; 100 "the act, before there is a deed" → "the act was already will and form"; 101 "form, before there is a thing" → "form was already will and act" |
| (floor) | her seat, from inside | a BackSide dhātu shell r 6.4 depth 28 extruded from her seat's cross-section; aperture at z −15.6; key 700 + 1500a; seams .16 + .34a; 90 motes | — | "her seat, from inside" |

**Her attribute, the room's one actor.**

- Her Iconography line (`fldXJEBCQxLdHWGuP`) gives one of 52 keys. The keys map to 26 forms by kinship (KIN), for example hook→goad, gaze→radiance, veil→palm, shield→ground. Each form performs one action, **lit**. 15 tints apply (kp 1 #f2ecd8, 4 #b8263c, 7 #ff7a3c, 13 #ffb45c, 15 #6a5f78, 17 #d8d2c4, 18 #ffd76a, 29 #ff6a7c, 45 #ffb0c4, 62 #ff8ab0, 91 #ff7a5c, 92 #ffd76a, 99 #fff6e2, 100 #ff4a5c, 101 #ffd76a). Otherwise the form takes her jittered gem colour.
- **Mount.** (0, (0.5 − alt)·6.4 − 0.4, −4.6) at scale 0.9. At b it grows to 0.9 + 2.6b = 3.5 and comes to z −1.2. Its opacity falls by a *single* factor of (1 − .55b) on the base, not a per-frame multiply.
- **Materials.** solid rough .38, metal .12, emissive ×1.6.
- **Periods.** The 26 forms run at noose 11.1 s, goad 7.7, cup 18.2, arrows 6.25 (staggered 1.25), bow 13.3, mirror ~105, lotus ~90, flame (3 sines), rosary one bead per 1.67 s, trident, vajra one strike per 9.09 s, skullcup 20.8, plough 14.3, sceptre barely moves (sin(t·.022)·.012), garland 30, seed, gem, grain, lamp, chain 16.7, herb, ground, radiance, seal, palm and line 7.1. The full table is in HH-31.
- **Today.** The motion and keys are built exactly (`HomeAttribute.swift:177-722`), but the form is never seen and the tint is never rendered. Both now come up as light.

**The world's air and light.**

- Every room carries her ring's weather (`RoomAir.swift`, built; Design's W1–W9 counts):
  - R1: the sun disc plus 90 motes.
  - R2: 7 expanding rings plus 120 motes.
  - R3: 2,600 curl points.
  - R4: 3 caustic spectra plus a diamond prism.
  - R5: 72 ribs plus 24 shafts.
  - R6: 9 ruby lanterns.
  - R7: 5 pearl veils plus 150 motes, sourceless with no key light.
  - R8: a chatoyant travelling band.
  - R9: 9 gem lamps plus 220 motes.
- Gem diffusion is topaz .20, sapphire .30, coral .45, diamond .15, emerald .25, ruby .55, pearl .95, cat's-eye .10 (one hard band), and .70 for R9.
- The veil from Yoginī scales fog ×(1 + veil·.55). Tempo from mental state runs 1.00 → 0.28 on the world clock only.
- Hues come from Atmosphere with ±7° per-Śakti jitter (Mandala and Map colours win).
- **Light is raised to Design's band.** Room luminance is held between 80 and 255 at both adaptations, with a wash guard (near-half luminance ratio < 3.5). The light ramps with G30 *colour through staying*: grey (saturate .32, brightness .70) rises to full colour as l climbs with dwell over the first adaptation.
- The tests' bounds of .01–.9 mean are replaced by Design's numbers (hi > 90/255, range > 70).

**Further channels, new.**

- **Bīja-locked rhythm** (G1-0046): pulse rate, particle rhythm and light-breath are locked to her syllable. The period is carrier/32 Hz rounded to the nearest breath between 4 and 12 s, so it is the same carrier that she sounds.
- **Tattva as light and material** (G1-0047): a fire-tattva Śakti in a water ring gets a warm key (hue +18°, 0.3 mix) inside cool air, and earth adds grain +.04. The rule: tattva colours the key light and the grain, never the ring's hue.

**Words in the room.**

- *Place* "{region} · the {ordinal} āvaraṇa" is 11 pt. *Name* is 28 pt. *Quality* is 15 pt.
- The near/deep sentence is 18.5 pt and crossfades. Stages are read at 2 Hz (`RoomWordsView`, built). The 8 authored sentences are verbatim (`HomeWords.swift:84-93`).
- The text recedes to .25 while he drags or looks, so the room is never behind writing (G1-0301).
- Presiding form and the Mudrā verb are named once on arrival, under the place line, for 6 s (coverage audit item 7).

**The portrait in the room.**

- The lines surface by stillness. The mechanism is shared with the Light Room and Her Presence (HH-37).
- Stillness is reset by touches outside her objects and controls. "Touching her own objects is not restlessness — only leaving the room's stillness is."
- A line shows when a ≥ .4 and unbroken stillness reaches 4 + 6.5n s, so at 10.5, 17, 23.5, 30, 36.5 s and onward.
- A shown line is never retracted in that visit. This is a monotonic ratchet ("arriving at the pace of stillness, held once arrived").
- **Source.** The lines are the sentences of her Codex Portrait (`fldlcmg7wtfIxgcZu`), then of Function, Somatic signature and Iconography, verbatim and in that order, with nothing truncated (ruling 17).
- **Layout.** The band runs left/right 44 at 19 px, lh 1.45, cream .9, with a dark halo rgba(4,1,3,.82). Each line reveals over 2600 ms (opacity linear, transform 9 px ease-out). After the fifth line the earlier lines step up to 15 px at .55 so every line stays on screen.

**His Personal Connection on her walls.**

- After her lines are all shown, her ring's personalConnection paragraph (Avaraṇa `fldlcmg7wtfIxgcZu`; verbatim at 01-homes:179–187) surfaces sentence by sentence along the wall. It is gold italic 15 px at op .62, at the same 6.5 s cadence of stillness. This is his voice in her world.
- **kp 102 is the exception.** The Dissolve room ends in silence (MBB-05). The ring-9 paragraph lives in her Presence instead (§7 C10).

**Her letter (from the Well).**

- If, and only if, a Well letter exists for her kp (`fldgASyV031Hr4sHp` / local `ShaktiLetter` by kp), a folded object rests in the room. It is 36 px wide and 14 px tall, opening to 27 px over 820 ms cubic-bezier(.16,1,.3,1), at right 22, bottom 150, op .85.
- A tap opens it as italic 16 px at op .66.
- It is read-only and never fabricated. Design's specimen letter for kp 28 never ships.

**Doors** (HH-40).

- Two named doors, as left and right vertical strips 52×150 at top 34%, a 1 px gradient line, the neighbour's name in vertical mono 8 px, op .5. They show only in the room, with no descent and the library closed.
- **Design's rule.** Ring 1 stays within its family (siddhi 1–10, mātṛkā 11–18, mudrā 19–28). Ring 2 stays within its cluster (inner 29–31, tanmātra 32–36, citta 37, stability 38–41, self 42–44). Every other ring wraps round its own ring. Where a neighbourhood has one member (kp 37) the door goes around the circle (36/38).
- **Sister door.** The third door, a horizontal seam at H − 150, leads to her namesake in another ring (`ShaktiFactsCache.sister`, pairs 19↔53 … 23↔62, 55→21).
- **Walking a door.** It releases her room and runs the rite toward the neighbour from where you stand: the camera travels, the next room grows from 0.02, and there is no 0.7 s opacity swap.

**Ways to act with her.**

- **The Activation Cycle** (built). Knowledge → Will → Action, each by her element's gesture:
  - fire: hold 3.0 s, with a haptic every .45 s
  - water: an unhurried pour of 180 pt below 240 pt/s
  - air: a 10 s breath, 4 in and 6 out, with no touch
  - earth: a still hold of 3.5 s
  - ether: 8 s of not touching
  - light: one touch within ±0.22 s of the peak of a 2.4 s pulse
  - presence (R7–9): 6 s

  The asks recede by ring: ×1 in R1–3, ×.6 in R4–6, none in R7–9. The cycle closes on three verbatim lines (quality / family word / somatic) and writes `Light Entered`. Its start waits 16 s where a Trinity face sits (kp 31 Gaia, kp 42 Higher Self), otherwise 5 s.
- **The Heart Register** (built for R2) is offered in every ring. A drone on his own Sa, call and answer, sounds only on first touch.
- **"I feel her"** opens the Recognition ceremony *inside the room* (HH-43). It follows the ceremony grammar and the G39 staging of 300 / 1100 / 2600 / 4300 / 5400 ms. The two lines are verbatim. The answer moves in her element (Ahaṅ fire 5.5 s, Nāma air 6.0 s, Ātma light 3.8 s, Amṛta water 6.5 s). The whole room brightens ×(1 + 0.8k) over the act-2 window, a 2 s cream Shweta wash comes at .10, and one peak haptic sounds.
- **Mudrā close.** Her āvaraṇa's mudrā, held for three breaths in words only (for example Kṣobha: "Both hands at the heart, fingers interlaced, thumbs pointing up."). It is offered as a quiet way to end the stay. Ring 7 is Khecharī by ruling. Holding the mudrā on Home's glass with two thumbs re-opens the last room carrying it.

**Return — felt, never shown** (HH-49 to HH-56).

- **Dwell and compression.**
  - Accumulated dwell per kp (`HomeMemory`, built) gives a head start of 0 below 12 s, otherwise min(dwell·.55, holdEnd(kp) − 6).
  - The rite compresses as described above.
  - The second adaptation, unreachable on a first visit, becomes reachable through relationship.
  - The room opens further along, with deeper light, and its walls recede further.
- **On return only:**
  - Her core carries white light and a slow steady pulse (rate .22, depth .09, halo ×1.25). This is "she was expecting you", an authored line that is felt and not written.
  - **"you have stood here before"** appears once, in the low line, for the first 14 s after the head start, on every return and never on the first visit.
  - **Floor traces as light**: one faint mark of her gem's light on her floor for each earlier stay, at most 7, size 1.1, op .16, at y −4.1, scattered by a seed of (kp, n). Their colour ages with the patina a = (days since first stay/1095)^0.55, from bone rgb(228,220,205) through amber (208,158,72) to deep gold (164,112,38).
  - **A hand-drawn ring.** Her seat's ring is drawn by hand, off-centre, and settles true over 4 s. Its tone comes into tune from 1.5 % flat: gain 0 → .036 @3.2 s → .020 @6 s → 0 @9 s, with the fifth partial only once the fifth is granted.
- **Never shown.** No number appears anywhere.
- **forget me** lets all of it go. It lives in Settings and in the library.
- **Ledger.** Silence Held is written at adaptEnd(kp), once per visit, and First Dwelling at holdEnd(kp), once ever. Both carry Duration (sec).

### 1.4 Being there — the Light Room (mode 2)

The Light Room is the Rite of Entering's seat interior (02-rite-axis-field:156–305). It is built here as the second mode of the same Home, not as a separate world:

- **How to enter it.** He enters by a two-finger hold of 1.3 s anywhere in the room, or by the control "her light", which appears beside "go deeper" once a ≥ .28. He goes back the same way.
- **Remembered.** The mode he last used is remembered per kp in the local store and opens next time.
- **Doors from elsewhere.** Today's door and the Climb can open it directly.

What he sees, in draw order (R-09):

1. **The room is her seat, seen from inside.**
   - One-point perspective. The far wall is the aperture. The walls are the seat's own edges receding past you.
   - Canvas 402×874, R 330, kFar .28, kNear 2.55, vanishing point (201, alt×874).
   - Seat outlines by ring: square ±1×.94 (R1); petal, an 11-step sin^1.45 × .58 lens (R2–3); tri-up (R4, 6, 8); tri-down (R5, 7); circle 26-gon (R9).
   - `riteApertureSpan` = vy ± 330×.28×max|y|. One function derives both the room and the layout around it, so they cannot drift apart.
2. **Ground.** hsl(wallHue, 34 %, 1.4 + 1.6a %).
3. **Beyond the far wall, the whole Śrī Yantra** (`RiteYantraBeyond`). It is stroked farHot at scale .34 + .5b and opacity .1 + .72b: a 300 square with 4 gate ticks, 16 petals (132/112, hw 20), 8 petals (104/88, hw 30), and 4 up plus 5 down triangles. "What lies beyond — the rest of the 102, arriving only on the second adaptation."
4. **Bloom** at opacity 1 − .55b. The far polygon is a radial at rsGlow .62 + .38a.
5. **Her aperture face**, the channel her sisters cannot share.
   - Opacity (.4 + .6a)(1 − .7b): her signature fades as the yantra takes over.
   - L = lum×(.34 + .66a); core hsl(hue, sat×.5, min(97, L + 34)); mid hsl(hue, sat, L); s = r×.66.
   - The faces:
     - **point**: core .3s plus mid .62s.
     - **triad**: three nodes at s(.44 + .16b), spreading with b.
     - **tri-down**: an outer down-triangle plus an inner one at .85.
     - **ring16 / ring8**: core plus 16 or 8 dots at .82s.
     - **band**: an ellipse plus a bar riding sin(bπ).
     - **lens**: a vesica plus a core.
   - Which face she has is set by the ruling in §7 C2 and listed in Appendix A.
6. **Walls.** The floor catches the light and the ceiling stays dark: stops hsl(wallHue, 30 + 24f, 4 + (10 + 30f)a). Edges .3 + .5a; far outline .24 + .6a.
7. **The shaft.** A radial at the vanishing point with r 1.5R: "the light as a volume you are standing in".
8. **Dhātu grain.** fractalNoise .72, 3 octaves, seed 7, overlay .05 + .09a. Vignette 45 % → .9 − .28a.
9. **The light field itself.**
   - farL = 20 + 62a, so 20 % at entry and 82 % adapted. farC = hsl(hue, sat, farL); farHot = hsl(hue, sat×.42, min(98, farL + 26)).
   - Blur is soft (stdDev 2.2 + 5(1 − a)) and the far blur is 3 + 16(1 − a): "the image sharpens as the eye adapts".
10. **Motes.** 9 deterministic motes appear only once a > .2, at opacity (a − .2)×.9. x 16 + (i·37 mod 68) %, y 12 + (i·53 mod 74) %, size 1 + (i mod 3)·.7, 20 + (i mod 5)·7 s, delay 1.7i s, hsl(hue, 60 %, 86 %).
11. **The floor breathes** at .06 + .04·breath on 5.5 s (the Cathedral Floor).

The threshold here has no black card. Her room is already lit, and the three beats are written in front of it:

- An overlay radial at (50 %, alt) from hsla(hue, sat, 40 %, .1) → rgba(4,1,3,.5) at 62 % → .82, with text on a dark halo of r 200.
- Beat 1: the phrase at 24 px, lh 1.5.
- Beat 2: Devanāgarī at 36 px, plus the Latin name at 15 px, .24em uppercase, hsl(hue, 52 %, 72 %), op c01((p − .55)/.45)×.62.
- Beat 3: roots at 26 px, with a gap of (1 − join)·split·28; the last root is italic when there are more than 2; gloss at 16.5 px, max-width 270, ×.5.
- Bars sit at bottom 92 with gap 9 (current 16×4, others 4×4, done hsl(hue, 50 %, 76 %)).
- The hint sits at bottom 62.
- Beat durations are {2.4, 3.2, 2.8} s × max(.36, .66^min(v − 1, 3)) — the Rite's own constant, kept where it was designed (G4-0870) — × 1.35 under Reduce Motion.

**Clock.** The first adaptation runs 90 s × rate.mul: fast 64.8, even 90, slow 124.2, late 100.8. Then the hold of 165 s and the second adaptation of 120 s. Both a and b use smoothstep².

**The dwelling overlay** (R-11). "Text is residue here: the architecture carries the recognition."

- **Layout.** TOP_BAND 52, BOTTOM_BAND 150, ID_H 60. The room-entered overlay fades in over 1800 ms.
- **Her name, cut into the wall above the light.** Devanāgarī 30 px cream .62, with a text-shadow of 0 0 26 px hsla(hue, 60 %, 40 %, .5). Quality 11.5 px, .3em uppercase, hsl(hue, 48 %, 74 %), .72.
- **The portrait band.** The same mechanism as in the Room.
- **Her letter slip.** It appears only if a letter exists, at right 22, bottom 100, 48×44. Its opacity is cross(a, rate.letter, .2)×.95, so it fades in as a crosses her rate's letter threshold (.30 / .44 / .60 / .55). It opens from 13 px to 26 px over 900 ms, filled hsla(hue, 34 %, 86 %, .16). Open, it reads italic 16 px, lh 1.55, cream .86 on rgba(4,1,3,.72).
- **Doors lit along the seat's own edges.** Top 40 %, h 130, w 44, a 2 px glow at hsla(hue, 70 %, 72 %, .22 + .5a).
- **"go deeper"** does not exist before a ≈ .28. Its opacity is cross(a, .28, .3)×.8, centred at bottom 40, 150×46, over a 58×1 hairline.
- **Leave.** A chevron at top 52, left 6, 46×46.

**Sound.** The Rite's voicing is kept: sub hz/2 at .9, hz at .55, hz×1.004 at .45 (slow beating), and the fifth hz×1.5 at gain .16b, so it opens only during the second adaptation. Master is .028 + .022a, lowpass 190 + 900a with τ 1.2. The voice sounds only in the room and is silent in the corridor. **hz is her carrier from the ring roots** (one tuning). Design's `RITE_BIJA_HZ` table (136.1, 144, 126.2 …) is not used (§7 C5).

### 1.5 Going deeper and the library

**"go deeper" is always offered.** `DescentReach.shallow` (3 of 5 stations until 62 s) was app-added gating and is lifted (G7-1033). The descent continues the inward travel and never opens a sheet. Self-paced: a touch carries you the next stretch, with a glissando a minor third down per station (built).

- **In the Room: the shaft** (H-DESCENT, Design's solids restored).
  - 46 rungs (32-gon circles), r = 5.4·0.985^i at z = −8 − 2.2i. Opacity .05 + .34·near, where near = 1 − clamp(|z − depth|/34). A key PointLight (gem, 900) follows at depth − 6. 160 motes. STATION_Z is [−16, −34, −52, −70, −88], dz eases .032, and stations show within 22 units.
  - The five stations, each a solid in her gem light:
    1. **tattva**: a TorusKnot(1.5, .34, 128, 16, 2, 3), emissive 1.8, spinning (t·.13, t·.09).
    2. **bodily location**: 13 bars (w = 3.4 − |i − 6|·.16), y 4.4 − .74i, breathing .5 + .5 sin(.22t + .4k). *Her* bar is lit at her body altitude, as `HomeDescent.swift:212-235` already corrects.
    3. **etymology**: n = clamp(roots, 2, 4) marks orbit inward over 14 s at radius 3.4(1 − draw), and a white "one" sprite reaches op draw³·.9.
    4. **quality**: an Icosahedron(2.1, 1), flat-shaded, turning.
    5. **phrase**: three flat tori r 2.4/3.5/4.6 at op .34/.26/.18, plus a white sprite of 3.4 at .6. This is the floor of the descent.
  - Each station's word is the verbatim field. An empty field is skipped, never invented.
  - The control reads "go deeper" → "further" → "come back up".
- **In the Light Room: the fall through five chambers** (R-12).
  - The chambers:
    1. **function**: 7 copies of the room's shape expand from r 18 to 156.
    2. **somatic**: 15 body registers breathing at her altitude.
    3. **icon**: noose circles converging 140 → 14, or triad seals 112 → 20, or womb-seal triangles 74 → 2, depending on her aperture.
    4. **tattva**: shapes counter-rotating at 5°/s and 3°/s.
    5. **root**: roots orbit inward from 118 to 0 on cyc = (sin .32t + 1)/2, with her Devanāgarī at 40 px fading in.
  - **Motion.** The target goes +1 per tap. dz eases .055 (.028 reduced). A chamber renders while rel ∈ (−1.1, 2.2), at scale 2.5^(−rel). The shaft is 8 outlines r = 14×2.9^(ph×2.1). The fall lasts 700 ms.
  - **Depth marks.** 5 bars at left 20, the current one 22 tall. They mark the chambers and say nothing about him.
  - **Hint.** "touch to go further in".
- **The floor of her = the library** (HH-59). After the last station or chamber, the floor of her rises: an overlay rgba(3,1,2,.9) over 900 ms, titled "the floor of her".
  - **Rows**, with empty rows omitted and every value verbatim from the Mandala table: quality · Function · Somatic signature · Iconography · esoteric tattva · bodily location · etymology (roots joined " + ") · inscription (Appreciation Phrase) · Devanāgarī · bīja (only if known) · āvaraṇa ("n — name") · her seat (the bhūpura / a lotus petal / a triangle / the bindu) · Śakti family · her family's one-line gloss (kp 1–52, from the Map's Shakti Function) · presiding form · Yoginī · mental state · goddess's body at this ring · world ("{gem} on {dhātu}") · clock · altitude · Mudrā verb · seed verb · related seats.
  - The control "rise back into her room" returns him, and so does a rise chevron at top 50, left 6, at any depth.
  - The same sheet is reachable at once from the room by the control **"the library"**. That sheet slides up with opacity over 520 ms and translateY 30 → 0 over 620 ms cubic-bezier(.16,1,.3,1), with radius 24, a gradient rgba(14,10,14,.97) → rgba(9,5,8,.99) and a gold hairline. An 88 px tap pad closes it.
  - Its foot holds three links:
    - **"her presence"**: Her Presence, world 6.
    - **"the research behind her"**: L-1537 for all seats and L-1533 for ring 2 seats, read-only, behind Q4.
    - **"forget me"**.
  - Nothing from `ShaktiDetailView` is deleted. Every section is either here or in Her Presence (§2 HP-01).

### 1.6 Her Dance (a per-Śakti dance from her own tone)

No Śakti has a song, and nothing is invented. Her Dance is songless, made from her synthesized carrier and her āvaraṇa drone in sustain mode (08-dances:1086–1104).

- **Ways in.** He enters by "her dance" in her room: a long-press of 1.3 s on her attribute, or the control beside "her light". The Mandala's long hold on a seat (G4-0229) also opens it.
- **Ways out.** The way out returns to the exact moment of her room he left.
- **Space.** It runs full-screen as a third mode of the Home.

| Part | Mechanism and numbers |
|---|---|
| Score (songless) | Breath period P = her Score `tempo.breath` (2–60 s, `fldz1vCCMpXiw8s1n`) ‖ 5.5 s. E(t) = .5 + .5 sin(2πt/P), scaled to sustain mode's floor and ceiling (#38, #40). Length 180 s: silence 0–4 · intro 4–30 · build 30–90 · peak 90–110 (PEAK_T 100) · descent 110–160 · outro 160–180. |
| The ensemble | The Bindu is the dancer and she is the field. **Gaia** is the āvaraṇa ground drone (bass): y → bindu.y + maxR(.2 + bass·.12), size 3 + bass·10, entering at bloom > .12. **Sid** holds the carrier: an elliptical orbit at .012 rad/frame, r maxR(.2 + sidSm·.1), y-squash .55, entering at > .22. **Arch** is her bīja when struck: it mirrors the Bindu with a 0.7 s delay, size 2 + mids·5, entering at > .32. **Karishma** lives in the silences between breaths: kT = e < .3 ? min(1, (.3 − e)/.25)·.8 : 0, brightest in fades. **Sakshi** is her ring position at the edge: an arc at .003, x = cx + cos·maxR·.9. **Ashrey** is the web to her neighbours (doors L/R): threads to the door edges and midpoint nodes when pr > .3, entering at > .65. **Bindu** is his touch: a Lissajous orbit, speed ∝ breath rate, amplitude ∝ E, a ring every breath, a comet of 28 positions, and a tap that freezes it. Presence lerps .04/.015. Entrance order Bindu → Gaia → Sid → Arch → Karishma → Sakshi → Ashrey, and the reverse to exit. **Neev** appears for t < 4 s and the last 2 s. **Shweta** fires at PEAK_T (a 2 s cream wash at .10). **Lalitā** is the Mirror and arrives after the descent begins. Each dancer's name shows as a tiny label on long-press (ruling 6). |
| Colour | Mandala colours win (settled). Bindu her bright · Gaia her deep · Sid gold #C9963F · Arch her accentSoft · Karishma #D4A017 · Sakshi ink2 #968D85 · Ashrey cycling ±40° about her hue. |
| Bloom | Five stages from E: dot → ghost trail (one ghost every 0.2 s, alpha a(1 − age/6)) → orbital rings on each breath peak → rays, particles and edge glow → crown, which is *her seat's own geometry* drawn as the crown mandala. Rise .06, fall .012, thresholds .15/.3/.5/.7: "Rises fast, falls slow." |
| Seed and word | Pre-roll: a breathing ring of 140 px on her breath, with "Breathe with the field. When you are ready, the seed will arrive." (authored), then "tap when ready", auto-advancing after 10 s. Seed: *her Appreciation Phrase*, verbatim, typed at P/20 per character (≈275 ms at 5.5 s). At PEAK_T *her quality word* is revealed at the bottom 15 % and dissolves over 4 s. |
| Mirror (Lalitā) | A near-white wash at 40–70 % alpha, rising 1–2 s, holding, and fading 2–4 s. It fires on the first threshold crossings (bloom .5/.7/.9), on the post-silence surge (E < .1 → > .4) and at the peak. Afterwards a contrast boost raises glows for 3–5 s. "The room remembering it's alive." |
| Sound | L = her carrier and R = her carrier + beat, hard-panned (AVAudioEngine). Beat: 8 (intro) → 7 → 5 (build) → 4.5 → **7.83 at PEAK_T for 3 s** → 6 → 7→9 (descent) → 10 (outro). ±0.3 wobble, frozen in Karishma windows. Inverse gain on her tone: amp = .045 + .015 sin(.18t) + .025(1 − E), so the quieter it is, the more she sounds. Gaia's ground is her ring technique (drone / breath / breathy / stepped / sourceless / triad / Shepard). No song's drone plays here, by the settled rule. |
| Silence | In the longest silence: Karishma's valley heartbeat (1.2 s period, rise 100 ms, fall 500 ms, hue 345) and a fulcrum haptic [30] at 50 bpm. If he presses "I feel her" during the dance, act 2 ("and she felt you back") lands in the next Karishma window, within one breath. |
| Floor | A residue grid of 25×35, spread and decay, karishma_decay .0005 ("nothing fades while the body is held in stillness"), persisted per kp in the local store and laid back on her floor the next time. |
| Language | Her chakra (via Avaraṇa subtleBodyChakra `fld6deGFzModjBmoj`) chooses the visual language. Ring 2 → Anahata's heart language: warmth map 30×40, 12 lotus petals, hexagram, and a canvas breath of 1 + heartScale·.015. The shape vocabulary is chosen by meaning: circle "the only breath" by default, heart for ring 2, infinity for kp 2 Mahimā, spiral on a return, none at the ring-9 peak. |
| Haptics | Core Haptics: bell [20,30,40,30,20] at strikes, mirror [8] on washes, crossing_peak [12,40,12,40,12,60,30,12,40] at PEAK_T, fulcrum at 50 bpm. |
| Ledger | Writes `Played` (Detail "Her Dance · {name}", Duration). It writes no Recognition: resonance_link writes_recognition stays false, and only "I feel her" recognises. |

### 1.7 Leaving

**The way out.**

- Hold for 2.2 s: "hold to withdraw" (3.3 s in Garimā). Under Reduce Motion a single touch: "touch to withdraw".
- An equal way out is the leading-edge swipe (22 pt edge, 72 pt travel). The rope (G13) works from any chamber, and so does Escape on a hardware keyboard.
- Letting go undoes the ending. A stay is filed once (`TheStay`).

**The crossing out.** It runs backwards (trav −= dt/2.4) through the point to *exactly where he was*: the Mandala seat at its zoom, the Climb at his band, Today, the chakra room, or the neighbour corridor. The `didSettle` jump to the Portrait from a room is removed (G2-0319).

**After-effect: felt, never named.** On leaving, her ring's kind lingers on the *whole app* for 180 s with e = (1 − age/180)². The kinds by ring are: R1 sharper, R2 wider, R3 lighter, R4 wider, R5 sharper, R6 heavier, R7 wider, R8 lighter, R9 wider.

| Kind | Filter (e = strength) | Transform |
|---|---|---|
| lighter | brightness(1 + .07e) saturate(1 − .06e) | translateY(−3e px) |
| heavier | brightness(1 − .06e) contrast(1 + .04e) | scale(1 + .01e), origin bottom |
| sharper | contrast(1 + .1e) saturate(1 + .05e) | scale(1 − .014e) |
| wider | brightness(1 + .03e) | scale(1 + .018e) |

- 3D scenes also take an exposure lift of 1.04 + .12(1 − age/24) for 24 s.
- **Nothing is written.** The line "her siddhi is still on the instrument" (`HomeAfterEffect.swift:101-104`, `HerSiddhiLingers.swift`, pinned at `HomesWaveOneTests.swift:272`) is removed by ruling 15.

### 1.8 Visual language and sound

**Tokens (Mandala house chassis + S13 Room)** (G5-0484, G5-0517).

- **Base colours.** ground #0D0508, surface #1A0C10, veil #080307, silence #040104, ink #F2E8D9 (16.62:1), ink2 #968D85, gold #C9963F (7.60:1), goldDk #A07830, goldBright #D4A017, crimson #8B1A2A, crimsonLit #A4343E.
- **Ring hues.** [#CE9546, ring 2 = cluster hue, #C46482, #BE3747, #D37045, #4490A7, #B04F8C, #D62F29, #E7CA6A]. Clusters: inner #D4A017, sense #C4725A, citta #2A7A7A, stability #4A7A5A, self #7A5A9A.
- **Per-world mixes.** wash mix(oklab, #0D0508 80 %, ring 20 %); deep mix(#070205 88 %, ring 12 %).
- **Per-Śakti palette from one hue.** h += jitter(kp, 14), where jitter(k, r) = ((k·2654435761 % 1000)/1000 − .5)·r; bright l + 18 (≤ 78), s + 10 (≤ 88); soft α .62; faint α .24.
- **Breath periods.** ground 0, home 3.5, petal8 8, tri1 9, tri2 11, tri3 13, tri4 15, root 18, bindu 4 s.
- **Type.** Cormorant Garamond (names 44–48 pt in the Presence, 28–38 in the room; italic voice 18–20). System small tracked caps for UI. JetBrains Mono for labels. Devanāgarī in the system font, never Cormorant.
- **Floor.** Read text ≥ 11 pt at ≥ .3 alpha, targets ≥ 44 pt, contrast floor held at both adaptations.
- **The room is its light.** The gem gives the light quality, the dhātu gives the walls, and there is one hue per Śakti.

**Sound** (`HomeSoundService`, built, every number Design's).

- **Ring roots** [55, 61.74, 69.30, 73.42, 82.41, 92.50, 98, 110, 123.47] Hz.
- **Her carrier** = root × JUST[idx(bīja in the 49-syllable varṇamālā) % 12] × 2, with JUST = [1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8].
- **Technique per ring.** R1 drone · R2 breath (LFO) · R3/R6 breathy · R4/R5 stepped [1, 9/8, 5/4, 3/2] at 5.2/3.4 s · R7 sourceless (partials 2, 3, 5 at .42/.26/.14) · R8 triad (1, 1.26, 1.5, glide 3.4, period 14) · R9 Shepard (5 voices, gain .22, LFO .22).
- **Strike** [1, 1.5, 2].
- **The fifth.** The fifth (gain .05) is *offered* by relationship. It arrives with dwell, and ring 9 always has it. The ground fifth ×.75 at .035 sounds from the first beat. Filter 220 → 1720, air .006 → .018.
- **Glissando** a minor third down per descent station.
- **Score overrides** from Airtable without a rebuild.
- **Rulings applied.** The room keeps its fixed tone (one tuning). Ruling 10 lifts "no in-app volume, no sound toggle and no mute button" (`HomeVoice.swift:50-52`): a sound control joins the room's controls, and the silent switch is still honoured. Her bīja tap uses this tuning, not the FNV hash onto a pentatonic scale (`BijaSoundService.swift:108-159`).

### 1.9 Reduce Motion: slowed, not frozen

`RoomView.swift:29-54` today stops the render loop and poses the room once at its settled end, so on such a device the room never adapts (G6-1046, G6-1058). This contradicts Design's invariant 4. The upgrade:

- **Adaptation continues in quantised steps over a longer total.** a goes in 4 steps and b in 3. Each step crossfades over 1.2 s.
- **Room durations.** first adaptation 62 × rate × 160/90, hold 190, second 150.
- **Light Room durations.** 160 × rate, then 190 and 150.
- **Decorative drift stops.** The attribute's one action and the mechanism keep running at 0.5× speed, rendered at 15 fps.
- **Other motion.** The rite beats are ×1.35 and write as a 500 ms fade instead of strokes. Motes are static.
- **Her Dance.** The dance runs at 0.5× lerps with bloom quantised to its 5 stages.
- **Way out.** A single touch.
- **What does not change.** Nothing is posed once and nothing is frozen.

---

### 1.10 Her Presence — the world

In his words:

- **C-1280**: "to sort of like almost like open or engage with it they first have to do like an intention … on the other side they can add their perspective … it sort of is trying to help them remember the witness."
- **C-1279**: "life is a one page answer how big that page is it's up to us."
- **C-1135**: "the front forms the individual Atman's essence … the back forms like a part of the whole."
- **C-1353**: "a gift of an energy that you can learn about."

In Design's words: "The detail inherits the day's atmosphere; scale is reverence." (02:678) "Lead with the soul; hide the encyclopedia." (DESIGN_SPEC §2.5). Portrait--voice: "identity always open; words earned by staying." Law 25: "A presence is one identity, seen whole — one record (colour, glyph, name) read live everywhere." And from rupakarshini: "names are never drawn as bodies."

**What this world is.** Her portrait: who she is, at the pace of his stillness, with no figure. It is what `ShaktiDetailView` was trying to be, which Design called *Her Presence* (02 L-13). Here it is relieved of being the gate to her room and of the stacked Wave 5–6 sections that made it a long page.

**Arriving.**

- The crossing comes through the point in her hue.
- Dark first: 0 → 0 over the first 22 %, then 1 by 1.8 s.
- Then a staged arrival: identity at 0.4 s, form line at 2.2 s, quality at 3.4 s, and controls at 5.6 s.
- Her quality arrives word by word at 200 ms after a 4 s breathing ring collapses (height → 0, never display:none).
- Her ground is her deep ground, relit by the hour (HP-21).

**Being there**, top to bottom. These are the elements in §2 HP-01 to HP-28.

- **Her identity disc (no figure).**
  - A 96 px disc in her hue, carrying her ring's geometry glyph (sigil). The glyph is the card.
  - Her bīja is a faint ground texture behind it: 320 px gold at ~.065.
  - The disc breathes on her own clock: Score `tempo.breath` ‖ her ring's breath period.
  - On a hold it beats at 0.1 Hz: scale 1 → 1.06 → 1 over 10 s, with a 100 ms haptic at each peak.
  - A two-finger turn flips it to its back face: her seat lit among the whole 102, faint (C-1135, "part of the whole").
  - Pinching zooms 1–4× around the finger (the cinematic viewer's gesture engine), with no overlay text.
- **Form line.** "{Ordinal} Āvaraṇa · {presiding form}" in 11.5 px, .3em. Then her name at lrNameSize(name, 50), weight 300, glow 50 px; phonetic 12.5 px at .48; a hairline of 54; quality 24 px accentBright; and, in ring 2, the cluster dot and label. Ring 2 also carries the seat line "She is the drawing-in of {quality lower-cased} — already running in you before the app was opened." (Design-authored).
- **The Turning — colour through staying.**
  - Her Presence rests grey: saturate(.32 + .68l), brightness(.70 + .30l).
  - Pressing and staying on the ∞ path for 2.9 s raises l to 1. Early release drains over 750 ms.
  - The ∞ path is M26 35 C26 16, 50 16, 66 35 C82 54, 106 54, 106 35 C106 16, 82 16, 66 35 C50 54, 26 54, 26 35 Z, with dasharray 360.
  - Captions read "trace the loop — let the light in" → "stay with the turning…" → "witnessed · the light is up".
  - Words are legible past l = .55. Once l reaches 1, the colour stays for the visit.
  - Identity (disc, form line, name, quality) is always open. Only the portrait's words are earned by staying.
- **The portrait at the pace of stillness.**
  - The same ratchet as in her room: unbroken stillness of 4 + 6.5n s gives line n. Touches on her own objects (the ∞, the disc, the bīja) are not restlessness.
  - The lines are her Codex Portrait sentences, then Function, Somatic and Iconography, verbatim, gold italic 20 px, lh 1.6 ("the soul, leading"), never truncated.
  - Each line uses the verse move "focus, not fade": it rises 14 px while its blur clears from 6 → 0 over 3.2 s.
  - Then **her ring's Personal Connection**, sentence by sentence at the same cadence, in his voice. Where a Śakti has no portrait text, this paragraph *is* her portrait (Design's fallback).
  - If neither exists, the silent voice card "·" appears at 40 px (graceful degradation; nothing invented).
- **Her somatic signature.** somaticPoetry italic 20, lh 1.65.
- **Where she is felt.** His body as twelve regions of light, never a figure and never hers: crown, brow, senses, throat, heart, hands, solar, belly, root, soles, spine, field (`SomaticRegion`). Her bodilyLocation lights its regions. Below sits her everyday doorway by tattva (heat / water / earth / breath / space / **light**, the last added per ruling 4) with her own first somatic line.
- **Her bīja.**
  - The syllable at 84 px, weight 300, gold. Its shadow is 40 px at rest and 70 px accent while sounding.
  - A tap plays her bīja at her carrier for 3.6 s, with a pulse of 1.4 s and three rings of 90 px over 3.6 s (delays 0 / .5 / 1 s).
  - Caption "tap to sound her" → "sounding". VoiceOver: "Bīja syllable {x} — tap to hear".
- **Appreciation.** A hairline of 36, then her phrase in italic 19 gold, centred ("a prayer, not a field").
- **Field Connection** (kp 31 Gaia, kp 40 Ashrey, kp 42 Ram only; ruling 11). A tinted card with radius 12 and a 2 px left border, carrying his fieldNote. It is also a door to the Relationship Field.
- **Embodiment.**
  - A four-node track: mapped .22, exploring .44, active .76, embodied 1.0.
  - The crossing is always his: a hold of 750 ms (30 ms fill ticks), vibrate 12 ms, one level per hold.
  - "Readiness is sensed" only as the pill's breath (2.2 s). It is a suggestion and never a lock. The 1/3/7 count gate is removed.
  - Status is never seeded on a fresh install (Q1 asks whether it is shown at all).
- **Her moments.** Newest first: a 6 px accent dot, "she was felt here · {today | yesterday | Mon D}, {h:mm AM}" at 12 px .6, "· {moon-phase}" in italic 13 at .45, and his note in italic 15 at .68. When empty: "She has not been felt here yet." No count.
- **Her deepening.** Layers — what she does · what her ring sets down · what her ring gives · the root of her name · how she is known · her enclosure — all open and offered freely, the newest arriving slowly. The visit-count gate (`HerDeepeningSection.swift:52-56`) is lifted.
- **go deeper (the disclosure).** Rows: Tattva · Bodily seat · Her ring ("{av.name} — {av.subtitle}") · Form (formDescription) · Mental state · Chakra · Iconography · Function · Etymology · Śakti family. Every row is verbatim. Folds are closed every visit.
- **Doorways.**
  - The everyday doorway.
  - The seal: a 2.4 s hold reveals her Appreciation Phrase.
  - "noticed her in passing", once a day, nothing placed, `Wager Resolved` "noticed in passing". It is re-grounded to C-1337's everyday doorways and no longer cited as C-1195.
- **One-Page Answer and Witness Page.**
  - Her one line, or "the whole of her home ›", which is the door to Her Home.
  - The Witness Page: a sealed envelope opened by a 1.8 s hold, "ask for help". It shows her Function beside his own perspective, kept on every save (`Witness Written`), and reseals on leaving.
- **Still Point at the foot.** Seven holds of 1.3 s each take something away. The stages are her Function sentence → her quality description → her Appreciation Phrase → her quality word → only the ember, breathing → her Devanāgarī name alone. Type grows as the text shortens. "Surface" is always there.
- **Footer.**
  - "be with her ›", the door to Her Home, run through the rite.
  - "{seed verb} with her", the play door: every one of the 102 has one, her game or else the rosary opened at her bead.
  - **"I feel her"**: full width, h 60, radius 30, gradient 135° red → mix(red 66 %, accent 34 %), 23 px .14em cream.
  - Her position reads "{kp} · 102". It is her identity, not a measure of him.

**Recognition** (`RecognitionMomentView`, built, exact to LR_RECOG).

- **The record comes first.** The ledger row `Shakti Recognized` is written *before any light moves* (floor).
- **The timeline.**
  - name at .3 s (46 px)
  - hairline and phrase (italic 24) at 1.1 s
  - "she was felt here · {h:mm a}" at 2.6 s
  - "and she felt you back · {h:mm:ss}" at 4.3 s (italic, gold): "The seconds are what make the reciprocity a distinct moment."
  - "What did you notice?" at 5.4 s, in a 288 px box that grows from 1 to 3 rows past 40 characters, saved per keystroke
  - "TAP ANYWHERE TO CLOSE"
- **The answer takes her element** (LR_RECOG: fy, focal, response duration, ripple duration, ripples, motes):

| Element | fy | focal | Response | Ripple | Ripples | Motes |
|---|---|---|---|---|---|---|
| flare | .60 | .96 | 5.5 s | 4.6 s | 4 | 12 |
| pool | .50 | .62 | 6.5 s | 6.4 s | 4 | 10 |
| disperse | .44 | .40 | 6.0 s | 4.0 s | 5 | 14 |
| bloom | .45 | .45 | 4.8 s | 5.6 s | 3 | 10 |
| settle | .54 | .92 | 7.5 s | 7.6 s | 2 | 6 |
| radiate | .44 | .44 | 3.8 s | 3.6 s | 5 | 12 |

  Ruling 4 maps ring 2's four elements: Ahaṅ fire → flare, Nāma air → disperse, Ātma light → radiate, Amṛta water → pool.
- **Close.** The ceremony gathers into the point (opacity 0, scale .84 over .55/.62 s), with an after-glow of k² over 1.8 s. It then **settles into Memory as one transition**: her gold point flies from the bindu to her seat over 0–.34 (ease-out cubic, with a fading gold line), and a halo blooms at her seat over .34–1 (r 6 → 36, op .8 → 0), all within 3400 ms. Today this settle happens only from Today. It now happens from every place.
- **Return.** He returns to where he was.

**Leaving.** Back returns to where he came from ("‹ {backLabel}": today / the field / the well / the mandala / the gift). The point goes home. Her Presence leaves no after-effect; that belongs to the room.

**Visual language.** The Feed's identity-header grammar on Mandala tokens (G5-0518):

- **Ground.** Her deep ground, with the six element compositions (fire → ascension, water → descent, air → horizon, ether → veil, earth → foundation, light → radiance). Mood bits m = (kp·2654435761)>>>0: flip m&1, spin m&2 ? 1 : −1, scale .86 + ((m>>3)&7)/7·.4, gradient angle ((m>>8)&15)·24°.
- **Relit by the hour.**
  - dawn 5–9 h: dh + 8, L + 6, S × 1.02, glow × 1.15, tint #3A1C22 @ 12 %
  - noon 9–16 h: dh − 5, L + 13, S × .88, glow × .8, tint #242838 @ 7 %
  - dusk 16–20 h: dh + 3, L + 2, S × 1.16, glow × 1.25, tint #331306 @ 14 %
  - night: dh − 7, L − 9, S × 1.06, glow × 1.05, tint #060716 @ 16 %
- **Element backdrops** breathe at fire 11, water 13, air 12, ether 9.6, earth 15 and light 7.6 s (`AtmosphereBackground`). The fixed atmosphere has a top glow radial(130 % 55 % at 50 % −5 %), the sigil at 600 px (op .55, spinning −1) and 10 motes.
- **Heartbeat.** An optional 72 BPM heartbeat (haptic only) beats under the disc for heart-ring seats (ring 2). Its source is A Strange Voice's persistent heartbeat; the voice narrative goes to the Feed.
- **Wake lock.** While a stillness phase runs, the idle timer is disabled, and it is released on exit.


## 2 · Every element, placed

Status today uses built / partial / not / wrong with code refs (`iOS/Bindu Mandala/`). Action is REUSE (keep as built), MOVE (into this world), CHANGE/FIX/UPGRADE/REWRITE (existing code), or NEW. Sources: index ids, then their register lines (first three per element).

| # | Element | What it does (mechanism + numbers) | Source (index ids · register) | Status today | Reuse / move / new |
|---|---|---|---|---|---|
| HH-01 | The room is the Home; Detail becomes the library inside it | Every ordinary tap on a Śakti (Mandala seat 2nd tap / 'enter her presence' stays Presence; 'be with her', Today seat line, Climb light, Field row, chakra-room door, gift, search) opens HerRoomPassage through the rite. ShaktiDetailView's reference sections fold into the room's library (HH-59); its soul becomes Her Presence (HP-01). Mandala ring 9 seat offers the DissolveRoom as well as the Bindu descent. | G6-1062, G1-0007, G6-1027, G6-1048, G6-1049, G6-1050, G6-1051, G6-1052, G6-1053, G6-1055, G6-1059, G2-0336, G2-0471, G2-0019, G2-0096, G2-0124, G2-0161, G2-0248, G1-0038, G1-0322, G1-0321, G1-0071, G2-0236, G3-0496 · 18-code-homes.md:140; 01-homes.md:7; 01-homes.md:26 | WRONG — built inverted: Detail is the front, room behind 'be with her' (ShaktiDetailView.swift:65-123,179-199; LivingMandalaView.swift:566-571 sends kp 102 to the descent only) | MOVE routes; RESHAPE ShaktiDetailView into library + Presence |
| HH-02 | Two-door station: walk it (Home) / read it (Presence) | Where a door names a Śakti, two halves of one door: 'be with her' (walk — her room) and 'know her' (read — her presence). The read half ends 'and now — walk it' into the Home. Two flames: half = walked, whole = read and walked (felt, no number). | G4-0690, G5-0378, G3-0466 · 11-padakarshini-forms.md:130; 11-padakarshini-forms.md:551; 11-padakarshini-forms.md:618 | PARTIAL — two text links on Detail/Significance card | NEW (station view, reuses existing links) |
| HH-03 | Crossing in through the point: fly-in, the point becomes her room | Log-scale camera (radii [1.38,.93,.77,.62,.50,.39,.29,.20,.125,.06], R=min(W,H)·.335, breath ×(1+.010·breath)/10 s) flies to her seat (scale 3.0 at h·.36, 0.72 s); chamber at her seat scale .02 → 1 (0.02+0.98·swallow); camera eye → her z+7.4−swallow·7.4 by smooth(trav); presences vanish past swallow .7, bands past .96; 'There is no transition screen anywhere.' Climb: 1.1 s flight continues into the rite (no cover cut). Today/Bindu: Pulse Gate — circle breathes 3 s, hold 2.5 s, haptic 80 ms, circle ×40 becomes the room. | G1-0084, G1-0077, G6-1015, G5-0056, G5-0675, G1-0324, G7-0340, G6-1054, G6-1036, G1-0001, G7-0018, G1-0508 · 01-homes.md:231-232; 01-homes.md:222-223; 18-code-homes.md:89 | PARTIAL — climb flight built then fullScreenCover hard-cut (TheBuilding.swift:287-307; WorldClimbView.swift:247-260); Mandala fly built (LivingMandalaView.swift:554-613) | REUSE flight; NEW continuous crossing (no cover) |
| HH-04 | Rite of Entering — three self-paced beats (G35) | Beat 1 phrase 23 px (op clamp(bp/.34)·.94; fallback chain her phrase ‖ ring phrase ‖ 'Thank you for what was always already here.'); beat 2 Devanāgarī 38 px written by an unseen hand in 3 strokes (seg=min(2.999,bp·3), stroke ends at 72 %, mask +7 % soft edge; shirorekhā first); beat 3 roots 25 px part (clamp(bp/.58)) and rejoin (clamp((bp−.52)/.48)), gap (1−join)·split·30 px, gloss italic 16.5 px ×.6 from .6. Stations .30/.62/.88/1; struck tone carrier×[1,1.5,2] 0→.05/20 ms, decay to .0001 by 3.4 s. Beat 2.4 s (3.4 RM) × max(.36,.68^min(v,4)). Touch ignored until bp ≥ .99. Prompts 'touch to go on'/'touch to enter' (mono 9 px .3em op .44). Beat marks restored (bottom 88, 4×4, current 16 wide gold, done .6, pending cream .25, 500 ms). No cancel at threshold. | G1-0002, G1-0078, G1-0079, G1-0080, G1-0081, G1-0082, G1-0083, G1-0411, G4-0759, G4-0850, G5-0181, G7-0314, G7-0315, G7-0316, G7-0317, G6-1013, G6-1014, G1-0282, G7-0318, G4-0710, G4-0791, G1-0060, G2-0259, G7-0983, G7-0312, G1-0298, G3-0425, G3-0391 · 01-homes.md:7; 01-homes.md:81; 01-homes.md:110 | BUILT as overlay (RiteOfEntering.swift:98-428; RiteOfEnteringView.swift:257-446); beat pips refused (:60-63); eager touch cuts beats (WRONG) | REUSE; FIX min dwell; RESTORE beat marks |
| HH-05 | Optional beat 0 — one body cue chosen by her body region | One verbatim Threshold Invitation (Walks table) chosen by her Bodily Location/Goddess Body Region, held one 5.5 s breath before beat 1 (e.g. 'Feel your feet. Something has been carrying you all day without being asked.'). C-1145: feel first, recalibrate after. | G6-0684, G6-0745, G3-0385 · 16-airtable-asg.md:190; 16-airtable-asg.md:296; 07-codex.md:330-333 | NOT BUILT | NEW — only on his yes (Q2) |
| HH-06 | Room clock per Śakti (rate channel) | a = smooth(t/(62·rate.mul)) (fast .72 → 44.6 s · even 62 · slow 1.38 → 85.6 · late 1.12 → 69.4); hold 165 s; b = smooth((t−holdEnd)/120); label flips at b > .45; one normalized value a that every surface reads (Turrell). Time is elapsed; stillness governs arrival of a line only (high-water). Room clock starts at head start. Rate per Śakti by the physics ruling (§7 C1, Appendix A). | G1-0003, G1-0113, G1-0114, G1-0420, G6-1043, G5-0164, G1-0026, G2-0297, G1-0584, G6-1012, G2-0256, G2-0346 · 01-homes.md:7; 01-homes.md:60-75; 01-homes.md:341-343 | PARTIAL — fixed 62/227/347 for all 102 (HomeMemory.swift:82; RoomView.swift:61-135) | CHANGE constants → functions of kp |
| HH-07 | Resolution by kp: 8 authored → ring archetype tuned by card → seat floor | HomeRooms.authored = {1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve}; ring 1 by family (siddhi 1–10, mātṛkā 11–18, mudrā 19–28), ring 2 crossed, 3 bodiless, 4 cosmic, 5 giving, 6 revealing, 7 sounding, 8 sourcing, 9 authored; counts 28·16·8·14·10·10·12·3·1; 58 rooms in rings 3–9. Never by name. | G1-0019, G1-0127, G1-0126, G1-0141, G6-1006, G6-1007, G6-1061, G2-0254, G2-0345, G2-0464, G2-0344, G2-0463, G6-0960, G7-0712, G7-0977, G2-0275, G5-0162, G5-0180, G6-1074, G7-0978 · 01-homes.md:60; 01-homes.md:74-75; 01-homes.md:382 | BUILT (HomeRooms.swift:201-269; RoomReversal.swift:303-319); dead placeholder types HomeRooms.swift:86-133 | REUSE; DELETE dead placeholders |
| HH-08 | Lift the binding condition in the mechanism layer | RoomSurfaceMechanism may return light bodies and non-figural geometry (emissive solids, line loops, sprites, transmissive/physical materials, shaders, spotlights with shadow, render-target composites) in the 'her' and 'world' layers; stone inscription (impression/furrow/crack/swell/compaction) kept beneath as second register. Only rule kept: no figure. Her-layer 'solids = 0' test retired. | G6-1063, G6-0973, G6-1073, G6-1008, G6-1010, G2-0383, G6-1056, G7-0698, G2-0387, G6-0972, G6-0974, G5-0328, G2-0285, G2-0378, G2-0385, G2-0457 · 18-code-homes.md:141; 18-code-homes.md:38; 18-code-homes.md:153-158 | WRONG — RoomMaterial.swift:17-23 'never a free-standing emissive solid'; RoomScene.swift:79-129, :827-833 solidsInHerLayer must be 0 | REWRITE RoomMaterial/RoomScene contract |
| HH-09 | Authored room kp 1 Aṇimā — CONTRACT | Shell r 6.4 d 26; aperture z −14.5; k = .34+.66(1−smooth(t/a)) walls to 34 %; aperture (0.5+0.5/k)(1+11b) — twelvefold; key 900/k²; shell op 1−.94b; 'the-beyond' sprites z −18 → −5. Words 'the walls close while you stand still' → 'the point was a door all along'. Sentence: 'The door is smaller than you. You are admitted anyway — and then it keeps closing … It never reaches you.' | G1-0118, G1-0312, G1-0303, G6-0983, G1-0142 · 01-homes.md:356-357; 01-homes.md:734; 01-homes.md:716 | WRONG — ContractRoom.swift: walls close 2/3 as dents, no 'beyond' (18-code-homes:48) | REWRITE to recipe |
| HH-10 | Authored room kp 2 Mahimā — ENDLESS | 24 lit seat-shaped frames r 6+.52i over SPAN 120 recycling at 3.4 u/s; op sin(π·clamp((z+120)/120))·.95+.06; haze sprite 60 op .16; 140 motes; four rails op .16 ('proof you are inside'); at b 10 frames continue behind you. Words 'no far wall · it never arrives' → 'you were never inside anything'. | G1-0119, G1-0313, G1-0304, G6-0984, G1-0143 · 01-homes.md:359; 01-homes.md:735; 01-homes.md:717 | WRONG — EndlessRoom.swift: frames are rows of dents | REWRITE to recipe |
| HH-11 | Authored room kp 3 Laghimā — RELEASE | Four cloth walls 26×13, hem = smoothstep(.62,0,uv.y), p.y += hem(uLift·2.4 + sin(uTime·.42+p.x·.55)·.42·hem); brightness overhead; lid ring 2–12.4 op .18 at y 8.4; sky sprite 16; black ground disc r 16 op .55; 340 rising points (size clamp 1–9) rise .34+lift·1.5; unmoored seat torus r 1.6 drifting y −3.4+4.2·lift; at b walls rise 1.4+b(15+2.4i), lid descends, sky takes the room. Words 'the floor has let go' → 'the room has let go of itself'. | G1-0120, G1-0314, G1-0306, G6-0985, G1-0414, G1-0144 · 01-homes.md:361-363; 01-homes.md:736; 01-homes.md:720 | WRONG — ReleaseRoom.swift: no cloth, hems, rising field or seat | REWRITE to recipe |
| HH-12 | Authored room kp 4 Garimā — PRESS | strataTexture 32×512 (bands 5–27 px, grey walk 14–232); ground 46×46 at 180×180 segs, displacement .5+1.9k (+1.4b), bump .9; ceiling slab 46×4.4×46 y = 11−7.4k (+5.2b) casting shadow; palm-press cylinder 2.1/2.5 tint 0xB8263C emissive 1.4+3.4b scale 1+1.8b; ember 1300; raking directional 3.6 at (9,6,4) − 2k; ambient 3.2; falling motes; fog .03+.028k. Words 'the ceiling is coming down' → 'the weight was holding you all along'. Spike renderers prove the port (Canvas & SceneKit; one shadow light, >15k tris). | G1-0125, G1-0315, G1-0307, G6-0986, G7-0567, G7-0569, G7-0570, G7-0571, G7-0568, G7-0573, G7-0574, G7-0716, G1-0145 · 01-homes.md:377-378; 01-homes.md:737; 01-homes.md:721 | WRONG — PressRoom.swift: palm cylinder refused, no fog; DEBUG spikes GarimaCanvasRoom.swift / GarimaSceneKitRoom.swift exist | REWRITE from spike; DELETE spikes after lift |
| HH-13 | Leaving Garimā costs effort | Way-out hold 3.3 s in kp 4 only (2.2 elsewhere); during the hold the slab lifts 0.6 units and the fog thins by .01; release before 3.3 s drains over 750 ms. Design: 'Leaving costs effort no other room asks for.' | (derived) | NOT BUILT | NEW |
| HH-14 | Authored room kp 6 Vaśitva — KNOWN | Box 16×10×30 'known-stone'; 6 standing pillars; torus seat r 1.5; SpotLight 2400 dist 44 angle .4 penumbra .88 decay 1.55 with shadow; wander wx = sin(.16t)·5.2+sin(.058t)·1.8, wz = −11+cos(.125t)·5.4, wy = −2.4+sin(.093t)·2.1; at b converges on him, angle .4−.17b, intensity ×(1+.7b); colours from her gem (not fixed violet). Words 'the room exists only where attention rests' → 'it has turned, and it rests on you'. | G1-0121, G1-0319, G1-0305, G6-0987, G1-0147 · 01-homes.md:365-366; 01-homes.md:741; 01-homes.md:718-719 | WRONG — KnownRoom.swift: no spotlight, pillars or shadow | REWRITE to recipe |
| HH-15 | Authored room kp 27 Sarva-Yoni — MEMBRANE | Lathe vessel r = max(.06,7.6·sin(π(.10+.82u))^.82), y −9→9.4; MeshPhysical 0xd4795c rough .42 transmission .94 thickness 3.4 ior 1.38 attenuation 0x8c2e1e@2.6 sheen .7 0xffc9a8 clearcoat .34; 8 veins 0xffb894; tri-down womb-seal aperture; backlights 0xffb08a 540/420/420/320/250, inner 0xffd9bc 130; nested ×1.55/2.3/3.2; breath sin(.28t) ≈ 22.4 s. Words 'no door · you were always inside' → 'source within source · it was never one womb'. | G1-0122, G1-0316, G1-0308, G6-0988, G1-0168 · 01-homes.md:368-369; 01-homes.md:738; 01-homes.md:722 | WRONG — MembraneRoom.swift: no transmission or backlight | REWRITE to recipe |
| HH-16 | Authored room kp 28 Sarva-Trikhaṇḍā — TRIPLE | One neutral room rendered into 3 render targets at offsets [(−1,−.42),(1,−.22),(.06,1)]·sep·(.52,.46); composite sep = vec3(a.r,b.g,c.b), one = (a+b+c)/3, out = mix(one, sep, uSep); sep = settled(1−b)+breath·b, breath = (.5+.5 sin((t−holdEnd)·.085))·.58; fallback 3 tinted shells 0xff5a52/0x4fe0a8/0x6f8fe0 (5 seat loops + 4 edge lines + seal sphere z −24). Words 'three rooms · one seal, only in stillness' → 'three and one, and always both'. | G1-0123, G1-0317, G1-0309, G6-0989, G1-0169 · 01-homes.md:371-372; 01-homes.md:739; 01-homes.md:723 | WRONG — TripleRoom.swift: 120 untinted impressions | REWRITE (Metal multi-pass) |
| HH-17 | Authored room kp 102 Mahātripurasundarī — DISSOLVE | Gold 0xfff2cf line yantra op .46 standing in air: squares r 13/11.6/10.2, circles 9/8.1, 16-petal 6.4→8.9, 8-petal 4.9→6.3, up-triangles apex 5.5/4.4/3.4/2.3, down 5.5/4.7/3.9/3.0/1.9 (half-width apex·.92); br = sin(.115t), scale (.94+.07br)(1+2.1b), z = 7.4b passes behind you; triangles −t·.014; bindu sprites 7.5/22 + sphere r .2 z −8.4 → 0 with source halo. Words 'there was never anyone here but Her' → 'the bindu is where you are standing'. Built last, by hand. Ends in silence (no marginalia). | G1-0124, G1-0318, G6-0990, G7-0711, G1-0243 · 01-homes.md:374-375; 01-homes.md:740; 18-code-homes.md:55 | WRONG — DissolveRoom.swift: 99 dents in stone, halo refused (:200-204) | REWRITE to recipe |
| HH-18 | Ring 1 Siddhi (kp 1–10, bar authored) — the capacity, lent | Box shell 13×11×30; octahedron r 1.5 emissive ×2.4 at (0,y,−9) moved by displace(kind,t,ph,2.2); six square echo loops repeat the motion delayed .6+.5i s with light; at b seams fade, shell op 1−.7b, object to 20 %. Words '{quality} · lent, not shown' → 'the capacity was never lent'. | G1-0131, G6-0992, G7-0701, G1-0146, G1-0148, G1-0149, G1-0150, G1-0151 · 01-homes.md:452; 18-code-homes.md:57; 22-code-tests.md:296 | PARTIAL — SiddhiRoom.swift: mark + 6 unlit echoes | UPGRADE to lit objects |
| HH-19 | Ring 1 Mātṛkā (kp 11–18) — letters | Sphere shell r 14; floor disc r 13 at y −5.4; n = 5+((kp−11) mod 4)·3 emissive slats on r 6.4; turn = (t·.22+i/n) mod 1; emissive 1.4+max(0,sin π·turn)^8·5+1.8b; voice column rising from the chest; at b letters stretch y ×(1+3.4b). Words '{quality} · {syllable}' → 'the letters were never separate from the voice'. | G1-0132, G6-0993, G7-0702, G1-0152, G1-0153, G1-0154, G1-0155, G1-0156, G1-0157, G1-0158, G1-0159 · 01-homes.md:454; 18-code-homes.md:58; 22-code-tests.md:297 | PARTIAL — MatrkaRoom.swift: no floor disc, letters as marks | UPGRADE |
| HH-20 | Ring 1 Mudrā (kp 19–28, bar 27/28) — a seal you stand inside | Five digit tubes on an 11-point arc (−.9…+.9) in sphere shell r 16; held sprite 4.4; at b digits open rotation.x = b·.42(1+.1i), held ×(1+3.6b). Words '{quality} · a seal you stand inside' → 'the seal has opened its hand' (Design's line restored over the code's rewrite 'the seal has opened, and let go of what it held'). Order of the ten matches the Map's Manipura list. | G1-0133, G6-0994, G7-0703, G6-0509, G1-0160, G1-0161, G1-0162, G1-0163, G1-0164, G1-0165, G1-0166, G1-0167 · 01-homes.md:456; 18-code-homes.md:59; 22-code-tests.md:298 | PARTIAL — MudraRoom.swift: vaults as marks; HomeGrammar.swift:686-694 rewrote deep line | UPGRADE; RESTORE Design line |
| HH-21 | Ring 2 (kp 29–44) — crossed (one sense, answered in another) | Petal sphere segment r 11; presenting 7 thin tori vs answering 7 sprites lower/further; displace(kind,t,ph+i/14) vs displace(kind,t+3.2,ph+.5+i/14); converge at b. CROSSED 34 form/ear · 35 taste/skin · 36 scent/eye · 37 mind/tongue · 38 courage/nose · 39 memory/speech · 40 name/hand · 41 seed/foot · 42 self/release · 43 deathless/generation · 44 body/mind (the KEY PAIRING → 'body and mind were one point'); 29–33 uncrossed → 'drawn toward the centre' / 'the drawing and the drawn are one'. kp 33 Sparśa: no walls, only surface. Physics per ruling 4: 31 fire, 40 air, 42 light, 43 water. | G1-0021, G1-0022, G1-0134, G6-0995, G7-0700, G2-0257, G1-0048, G1-0170, G1-0171, G1-0172, G1-0173, G1-0174, G1-0175, G1-0176, G1-0177, G1-0178, G1-0179, G1-0180, G1-0181, G1-0182, G1-0183, G1-0184, G1-0185 · 01-homes.md:77; 01-homes.md:157; 01-homes.md:458 | PARTIAL — CrossingRoom.swift: rings pressed in stone | UPGRADE |
| HH-22 | Ring 3 (kp 45–52) — bodiless | Sphere shell r 15; 8 gem petal sprites orbit an empty centre at r 5.4; torus rim r 1.5 'rim of light around nothing'; key 2200 at the empty centre; ambient 2.2; at b shell op 1−.8b. Words '{quality} · and nothing there to feel' → 'the effect was the only body'. | G1-0135, G6-0997, G7-0704, G1-0186, G1-0187, G1-0188, G1-0189, G1-0190, G1-0191, G1-0192, G1-0193 · 01-homes.md:460; 18-code-homes.md:62; 22-code-tests.md:299 | PARTIAL — BodilessRoom.swift | UPGRADE |
| HH-23 | Ring 4 (kp 53–66) — cosmic | 14 nested triangle loops r 3.4+2.1i inside sphere shell r 26; same physics delayed .42 s per shell, amplitude 1+.22i. Words '{quality} · at the scale of worlds' → 'the gesture had no centre to leave'. | G1-0136, G6-0998, G7-0705, G1-0194, G1-0195, G1-0196, G1-0197, G1-0198, G1-0199, G1-0200, G1-0201, G1-0202, G1-0203, G1-0204, G1-0205, G1-0206, G1-0207 · 01-homes.md:462; 18-code-homes.md:63; 22-code-tests.md:300 | PARTIAL — CosmicRoom.swift: triangles became bearings | UPGRADE |
| HH-24 | Ring 5 (kp 67–76) — giving | Open cylinder r 11 h 22 + floor disc; 12 gift sprites spiral r 16 → 1.4, u = (t·.055+i/12) mod 1 (≈18 s); your hands as torus cup r 1.9, ×(1+4.2b). 'You never reach.' Words '{quality} · arriving, unasked' → 'the giving and the given are one'. | G1-0137, G6-0999, G7-0706, G1-0208, G1-0209, G1-0210, G1-0211, G1-0212, G1-0213, G1-0214, G1-0215, G1-0216, G1-0217 · 01-homes.md:464; 18-code-homes.md:64; 22-code-tests.md:301 | PARTIAL — GivingRoom.swift | UPGRADE |
| HH-25 | Ring 6 (kp 77–86) — revealing | 10 icosahedra emissive ×3.2 on r 6 under a lit BackSide veil sphere r 9.4 ink op .72; veil op max(0,.72−.46a−.26b). Words '{quality} · already here, behind the veil' → 'it was never hidden · you were the veil'. | G1-0138, G6-1000, G7-0707, G1-0218, G1-0219, G1-0220, G1-0221, G1-0222, G1-0223, G1-0224, G1-0225, G1-0226, G1-0227 · 01-homes.md:466; 18-code-homes.md:65; 22-code-tests.md:302 | PARTIAL — RevealingRoom.swift | UPGRADE |
| HH-26 | Ring 7 (kp 87–98) — sounding; Weapons (95–98) strike | Open cylinder r 9 h 24, shader w = sin(ang·n+t·.5)·cos(y·.5+t·.3), n = 2+(kp mod 8), amp .5+1.6b; n node sprites at r 8.4 'where the syllable is silent'; sourceless (no key light). Weapons 95–98: once per world-tempo breath a mode-n impulse (.55 s decay) with struck tone ×2 at .03. Words '{quality} · {bīja}' / '{quality} · the room is her sound' → 'you are inside the syllable'. | G1-0139, G6-1001, G7-0708, G1-0049, G1-0228, G1-0229, G1-0230, G1-0231, G1-0232, G1-0233, G1-0234, G1-0235, G1-0236, G1-0237, G1-0238, G1-0239 · 01-homes.md:468; 18-code-homes.md:66; 22-code-tests.md:303 | PARTIAL — SoundingRoom.swift (travelling term dropped); Weapons treated as Vāsinīs | UPGRADE; NEW strike |
| HH-27 | Ring 8 (kp 99–101) — sourcing | Triangle R 4.6; her corner white sprite 6.4 + light 900; others 2.4 op .2 + light 90; bindu sprite 2.6 'the bindu they ring, not yet reached'; shell r 15; at b others answer op .2+.7b, light 90+700b. Words 99 'will, before there is anything to will' → 'will was already act and form'; 100 'the act, before there is a deed' → 'the act was already will and form'; 101 'form, before there is a thing' → 'form was already will and act'. Corner vertices are doors to Aatma's trikona (chakra 31). | G1-0140, G6-1002, G7-0709, G6-0572, G1-0240, G1-0241, G1-0242 · 01-homes.md:470; 18-code-homes.md:67; 22-code-tests.md:304 | PARTIAL — SourcingRoom.swift | UPGRADE (Q3 on corners) |
| HH-28 | Seat floor — 'her seat, from inside' | SEAT 1 square · 2 petal · 3 petal · 4–8 tri · 9 circle (30-gon); seatShell ExtrudeGeometry r 6 depth 26 translated z −.62·depth; chamberSeat BackSide ink rough .9 metal .05 r 6.4 d 28; aperture z −15.6 (white core r .16·s, gem sprites 4.4/13); tri-down womb-seal, triad 3 spheres; key gemLight 1500 dist 52; fill 260; ambient gem 1.1; 90 motes; seams .16+.34a; key 700+1500a; aperture .6+.6a. RoomShell: square 3 panels, petal 16/8, triangle away/toward, circle 16 with a mouth, seam of light where wall meets floor. | G1-0117, G1-0115, G1-0116, G6-0978, G6-1020 · 01-homes.md:351; 01-homes.md:347-349; 01-homes.md:350 | BUILT differently (RoomShell.swift:46-56,105-188) — not Design's extruded cross-section | UPGRADE to extruded shell |
| HH-29 | Grammar: four tuning channels | Physics: (tattva+' '+quality).lower(), first match of 50 regexes (+3 appended: Priyatā→swell, Saubhāgya→brighten, Cāpa→compress; 0 fall to breathe), displacement kernels with p = phase·2π, s(f) = sin(tf+p) … (e.g. 9 vāyu\|air\|lightness → [s(.12)·.4A, (.5+.5s(.1))·1.7A, 0]). Altitude: soles .94 · belly .66 · waist .68 · solar .60 · diaphragm .56 · heart .46 · throat .34 · eyes .26 · forehead .20 · crown .10 · spine/whole .50 (+7 code zones); y = (.5−alt)·9 (R1–3) or ·8 (R4–7). Phase = (kp mod ringCount)/ringCount. Words from quality lower-cased. Uniqueness grammar: Quality → soul; Function → what it does; Somatic → physics; Location → gravity; Iconography → attribute; Tattva → dhātu modifier; Bīja → tuning; Etymology → threshold; Phrase → inscription; Devanāgarī → the unseen hand; Cluster → corridor; Family → lineage. | G1-0020, G1-0129, G1-0130, G1-0058, G1-0244, G6-0962, G6-1009, G2-0255, G2-0272, G7-0692, G1-0044, G2-0239, G1-0128, G6-0991, G6-0996, G6-1022, G2-0277, G2-0334, G2-0295 · 01-homes.md:74; 01-homes.md:391-445; 01-homes.md:449-450 | BUILT (HomeGrammar.swift:135-283,371-436) | REUSE |
| HH-30 | Every room reverses its premise at the second adaptation | Not more of the same — a reversal (C-1242: 'in that negation … what remains'). Premise surface → answer surface (HomeBecoming, answer ≠ premise), geometry deltas per room, deep words verbatim ('the weight was holding you all along', 'a light you are inside is not a light you see' …). | G6-0965, G6-0980, G6-1011, G7-0979, G2-0280, G3-0437, G7-0985, G3-0375 · 18-code-homes.md:25; 18-code-homes.md:45; 18-code-homes.md:85 | BUILT (HomeBecoming.swift:122-209; RoomReversal.swift:147-225) | REUSE; geometry now lit |
| HH-31 | Her attribute — the room's one actor, lit and performing | ATTRIBUTE kp→52 keys → 26 forms by KIN (hook→goad, spear→trident, discus→trident, triangle→seal, triad→seal, hand→palm, gaze→radiance, spine→sceptre, syllable→radiance, ear→palm, drop→cup, flower→lotus, belt→garland, streamer→garland, churn→seal, molten→cup, pour→grain, veil→palm, stretch→sceptre, brush→line, boon→palm, fruit→gem, water→cup, banner→garland, cleanse→palm, shield→ground). Mount (0,(.5−alt)·6.4−.4,−4.6) scale .9 → .9+2.6b, z −4.6+3.4b, opacity ×(1−.55b) once. Materials solid rough .38 metal .12 emissive ×1.6. Forms: noose torus r1 tube .045, u=(t·.09) 11.1 s cast/close/draw; goad 7.7 s reach/pull; cup lathe 18.2 s level .1+.44fill−.44drunk; arrows 5 rods 6.25 s staggered 1.25 s; bow 21-pt stave 13.3 s draw .62; mirror r .78 metal 1 rot sin(.06t)·.7 face cos^6; lotus 8 petals open .5+.5sin(.07t); flame cone .3/1.1 f = .5sin3.1t+.3sin5.3t+.2sin1.7t; rosary 27 beads one per 1.67 s (45 s round); trident lift sin(πu)³; vajra strike every 9.09 s flash (1−u/.06)²; skullcup 20.8 s darkens as it fills; plough 14.3 s furrows rise; sceptre sin(.022t)·.012; garland 20 flowers grows over 30 s; seed densifies .5+.5sin(.05t); gem transmission .95 ior 2.2 dispersion 6; grain 26 sprites overflow; lamp flicker 1+.05sin2.6t+.03sin4.1t; chain 7 links 16.7 s fall open; herb 6 leaves heal sin(πu)^4; ground hex slab, load breathes .7+.1sin(.09t); radiance core 1.2 + halo 4; seal 5 capsules fold sin(πu)²; palm disc + 3 lines turn; line 60 pts 7.1 s. Tints (15) per HH text. Aniconic: shapes doing one thing. | G1-0004, G1-0247, G1-0248, G1-0055, G1-0275, G1-0245, G1-0249, G1-0250, G1-0251, G1-0252, G1-0253, G1-0254, G1-0255, G1-0256, G1-0257, G1-0258, G1-0259, G1-0260, G1-0261, G1-0262, G1-0263, G1-0264, G1-0265, G1-0266, G1-0267, G1-0268, G1-0269, G1-0270, G1-0271, G1-0272, G1-0273, G1-0274, G6-0963, G6-1021, G6-1064, G6-1075, G2-0258, G2-0270, G7-0693, G7-0981, G2-0223, G2-0224 · 01-homes.md:7; 01-homes.md:79; 01-homes.md:595 | PARTIAL — motion and keys exact (HomeAttribute.swift:177-722) but drawn as dents; tint never rendered (RoomMaterial.swift:470-536) | UPGRADE render path |
| HH-32 | Her world's air and light in every room | RoomAir nine bands (R1 sun + 90 motes · R2 7 rings + 120 · R3 2,600 curl · R4 3 caustic spectra + prism · R5 72 ribs + 24 shafts · R6 9 ruby lanterns · R7 5 pearl veils + 150, sourceless · R8 chatoyant band · R9 9 gem lamps + 220); gem diffusion topaz .20 sapphire .30 coral .45 diamond .15 emerald .25 ruby .55 pearl .95 cat's-eye .10 R9 .70; veil from Yoginī fog ×(1+veil·.55); tempo from mental state 1.00 → .28 on world clock only; HDR exposure + bloom per ring; Atmosphere hues ±7°. RITE_WORLDS columns kept: room shape, altitude, after-kind (gem hues replaced by Mandala colours). | G1-0039, G1-0418, G2-0252, G2-0253, G6-0961, G6-0964, G6-0976, G6-0977, G6-0979, G6-1016, G6-1017, G6-1018, G6-1019, G2-0388, G2-0374, G7-0691, G7-0327 · 01-homes.md:111; 02-rite-axis-field.md:35-47; 04-briefs-audits-frames.md:402 | BUILT (RoomAir.swift:268-710; RoomLightRig.swift; HomeWorlds.swift; HomeGem.swift) | REUSE |
| HH-33 | Light at Design's band; G30 colour through staying in the room | Room luminance 80–255 at both adaptations (Design's measure), wash guard near-half ratio < 3.5, saturation guard < 25 % of pixels > .96; room light rises from grey (saturate .32, brightness .70) to full as l follows a (G30 curve UP 2900 / DOWN 750 when held). Capture bounds in tests raised from .01–.9 to Design's (hi > 90/255, range > 70). | G4-0754, G4-0851, G7-1025, G7-0699, G1-0332, G7-0715, G7-1020 · 11-padakarshini-forms.md:304; 11-padakarshini-forms.md:548; 11-padakarshini-forms.md:624 | WRONG — measured ~11–65/255 (RD-06); tests pass dark rooms (RoomCaptureTests) | RAISE light; REWRITE bounds |
| HH-34 | Bīja-locked visual rhythm | Pulse rate, particle rhythm and light-breath locked to her syllable: period = carrier/32 Hz folded into 4–12 s; RoomAir motes and HerLight breathe on it. | G1-0046, G6-1045 · 01-homes.md:147; 18-code-homes.md:119 | NOT BUILT | NEW |
| HH-35 | Tattva modifies light and material | Tattva tints the key light and grain, never the ring hue: fire → key hue +18° at .3 mix ('warm light inside cool water'); water → key −12° .2; earth → grain +.04; air → mote count ×1.2; ether → fog ×.85; light → bloom +.15. | G1-0047 · 01-homes.md:147 | NOT BUILT (tattva sets only motion, HomeGrammar.swift:299-307) | NEW |
| HH-36 | Room words — place, name, quality, near → deep | Place '{region} · the {ordinal} āvaraṇa' 11 pt; name 28; quality 15; sentence 18.5 near → deep crossfade, read at 2 Hz, settling ≥ .25, deep > .45; presiding form + Mudrā verb named once on arrival 6 s; text recedes to .25 while dragging/looking ('the room is never behind writing'). | G6-0966, G7-0326, G1-0301, G1-0085, G5-0166, G1-0302 · 18-code-homes.md:26; 20-code-play-rooms.md:372-375; 01-homes.md:703 | BUILT (HomeWords.swift:22-129; RoomWordsView.swift); recede not built | REUSE; NEW recede + form/verb line |
| HH-37 | Portrait lines surfacing at the pace of stillness (room and Light Room) | Stillness resets on touch outside her objects/controls; line n at 4+6.5n s of unbroken stillness once a ≥ .4 (10.5, 17, 23.5, 30, 36.5 …); monotonic ratchet; source Codex Portrait sentences then Function, Somatic, Iconography, verbatim, none truncated; band left/right 44, 19 px lh 1.45 cream .9, 2600 ms reveal (opacity linear, 9 px ease-out), dark halo rgba(4,1,3,.82); beyond five, earlier lines step up to 15 px .55. | G1-0040, G1-0429, G1-0442, G6-1029, G2-0456, G1-0421, G1-0422, G1-0424 · 01-homes.md:111; 02-rite-axis-field.md:121-126; 02-rite-axis-field.md:227 | NOT BUILT (grep: none) | NEW |
| HH-38 | His Personal Connection on her walls | After her lines, her ring's personalConnection paragraph (Avaraṇa fldlcmg7wtfIxgcZu) surfaces sentence by sentence along the wall, gold italic 15 px op .62, same 6.5 s stillness cadence. Not in kp 102 (Dissolve ends in silence); ring-9 text lives in her Presence. | G1-0035, G1-0063, G6-1044, G2-0268, G2-0468, G2-0231 · 01-homes.md:100; 01-homes.md:149; 01-homes.md:165 | NOT BUILT; text exists (all-shaktis-data.js; Airtable) | NEW |
| HH-39 | Her Well letter as a folded object | Only if a letter exists for her kp: folded object 36 px wide, 14 → 27 px open over 820 ms cubic-bezier(.16,1,.3,1), right 22 bottom 150 op .85; tap shows the note italic 16 px op .66. Read-only; never fabricated (harness asserts); Design's kp 28 specimen letter never ships. Light Room: slip 48×44 at right 22 bottom 100, fades in at the rate's letter threshold (.30/.44/.60/.55). | G1-0008, G1-0088, G1-0443, G6-1028, G1-0423 · 01-homes.md:7; 01-homes.md:81; 01-homes.md:111 | NOT BUILT (grep: none) | NEW |
| HH-40 | Doors — Design's rule (family / cluster, then the circle) and the sister door | Two named doors (Room: strips 52×150 at top 34 %, 1 px gradient, vertical mono 8 px, op .5; Light Room: edges top 40 % h130 w44 2 px glow hsla(hue,70%,72%,.22+.5a)). neighbourOf: R1 within family, R2 within cluster, else ±1 within ring; single-member neighbourhood (kp 37) → around the circle; kp 102 none. Third 'sister' door to the namesake in another ring (horizontal seam at H−150). Walking a door releases the room and runs the rite to the neighbour from where you stand — no opacity swap. | G1-0005, G1-0086, G1-0444, G2-0261, G6-1025, G6-1026, G6-1066, G7-0325, G4-0855, G6-0899, G1-0330, G3-0427 · 01-homes.md:7; 01-homes.md:83; 01-homes.md:113 | BUILT DIFFERENTLY — ±1 on the garland + sister (TheBuilding.swift:35-51; HerRoomDoor.swift:84-98,126-139) | CHANGE neighbourOf; NEW continuous crossing |
| HH-41 | Activation Cycle — Knowledge → Will → Action (C-1337, C-1244) | Six element gestures: fire hold 3.0 s + haptic every .45 s · water pour 180 pt below 240 pt/s · air 10 s 4-in/6-out no touch · earth still hold 3.5 s · ether 8 s not touching · light one touch ±.22 s of a 2.4 s peak · presence (R7–9) 6 s; asks recede R1–3 ×1, R4–6 ×.6, R7–9 none; jitter .85–1.15 by kp; close on three verbatim lines (quality / family word / somatic), writes Light Entered, plays her bīja. 'Knowledge is what they receive. Will is who they are. Action is what they commit to. Light is what enters when these three close.' | G7-0329, G7-0330, G7-0331, G7-0332, G7-0333, G7-0334, G7-0335, G7-0336, G7-0337, G7-0338, G2-0220, G3-0439, G3-0505 · 20-code-play-rooms.md:384; 20-code-play-rooms.md:386-395; 20-code-play-rooms.md:396-397 | BUILT (Views/Rooms/ActivationCycle.swift:66-130) | REUSE |
| HH-42 | Trinity faces in the room | Gaia at kp 31, the Higher Self at kp 42, each once a day, standing 7.5 s in its own light (gaia (.62,.74,.42), higherSelf (.98,.82,.46)); activation start delayed 16 s where a face sits. Extended to every named archetype is the Relationship world's work (ruling 6). | G6-0832, G6-0895, G7-0994, G6-0933 · 17-code-core.md:570; 17-code-core.md:754; 22-code-tests.md:605 | PARTIAL (TrinityOfGuidance.swift:9-186; RoomGameLayer) | REUSE |
| HH-43 | 'I feel her' inside the room — the ceremony grammar | One breath (5.5 s ring) → the act (hold) → answer in her element (Ahaṅ fire 5.5 s, Nāma air 6.0, Ātma light 3.8, Amṛta water 6.5; ripples per LR_RECOG) → G39 staging name 300 ms, phrase 1100, 'she was felt here · {time}' 2600, 'and she felt you back · {time}' 4300, close hint 5400, collapse 620 ms → whisper and one warmer light, never a checkmark. Whole room ×(1+0.8k) through act 2; Shweta cream wash 2 s at .10; one peak haptic crossing_peak. Writes Shakti Recognized (Gesture Source = Room) before any light moves. | G4-0854, G4-0712, G4-0763, G4-0255, G4-0256, G4-0332, G4-0477 · 11-padakarshini-forms.md:553; 11-padakarshini-forms.md:179-196; 11-padakarshini-forms.md:505 | PARTIAL — Recognition exists only from Detail/Today | NEW in room (reuses RecognitionNature) |
| HH-44 | Her family's question and gloss | From the chakra room (Muladhara 'which of the 10 Siddhis is latent in me right now?', Svadhisthana 'Which of the 8 Matrikas is visiting you right now', Manipura 'Which of the 10 Mudra Shaktis is your body forming right now', Anahata 'which of the 16 is your heart currently magnetizing?'): her family's lights (kp 1–10, 11–18, 19–28, 29–44, 45–52); touch the one present → her Home opens with the Map's one-line gloss ('Laghima (weightless)' …) inscribed once under her name. Ask first, then show (C-1314). 52 glosses kp 1–52 also a library row. | G6-0589, G6-0520, G3-0494, G6-0003, G6-0010, G6-0017, G6-0024, G6-0031, G6-0038, G6-0045 · 15-airtable-map.md:1420; 15-airtable-map.md:359-367; 15-airtable-map.md:535 | NOT BUILT; Shakti Function not baked (Data/ChakraConstellation.json lacks it) | NEW; BAKE fld5sWbzoT3lySYgI |
| HH-45 | Heart Register in every ring | His Sa (C–F 130.81–174.61, default C♯), drone ratios .5/1/1.5/2 gains .55/.7/.45/.25, six harmonics 1/n^.8, reeds ±3 cents, four sargam phrases, note = breath/8 × .9, answer silence one breath; sound only on first touch. Offered in every ring's rooms (today ring 2 only). | G7-0540, G6-0873, G6-0818 · 21-code-layers.md:39; 21-code-layers.md:145; 17-code-core.md:732 | PARTIAL — ring 2 only (HerDeepeningSection.swift:153; HeartRegister.swift) | EXTEND |
| HH-46 | Mudrā close — her āvaraṇa's mudrā, held three breaths | Offered as a quiet end of a stay: the āvaraṇa's mudrā named with the Map's hand instruction in words only (Kṣobha 'Both hands at the heart, fingers interlaced, thumbs pointing up.'; Drāvinī 'ring finger and thumb of each hand touching lightly, the other fingers releasing'; Ākarṣaṇa 'in whatever shape your body offers'; Vaśya; Sarvonmādinī; Mahāṅkuśa; ring 7 Khecharī (ruling); Sarva-Bīja; Yoni), three breaths of 5.5 s; holding it with two thumbs on Home's glass re-opens the last room carrying it. | G6-0600, G6-0498, G6-0499, G6-0500, G6-0501, G6-0502, G6-0503, G6-0504, G6-0505, G6-0506, G6-0507, G6-0508, G6-0311, G6-0313, G6-0315, G6-0317, G6-0319, G6-0321, G6-0323, G6-0325, G6-0327, G6-0329, G6-0331, G6-0333, G6-0335, G6-0337, G6-0339, G6-0341, G6-0343, G6-0345, G6-0347, G6-0349, G6-0351, G6-0353, G6-0355, G6-0357, G6-0359, G6-0361, G6-0363, G6-0365, G6-0367, G6-0369, G6-0371, G6-0373, G6-0375 · 15-airtable-map.md:1369; 15-airtable-map.md:326-341; 15-airtable-map.md:196 | NOT BUILT (mudrā carried in bundle, unshown) | NEW |
| HH-47 | The gift lands in her Home | C-1353: at most one a day at a random time in a window (default 10–20 h), seeded by day + install salt; 'one energy to appreciate' (her Appreciation Phrase or Function); the tap lands in her Home through a compressed rite (today: on her Detail with 'the gift' back label). | G3-0517, G6-0826, G6-0905, G7-0005, G7-0156 · 07-codex.md:990-993; 07-codex.md:1269-1271; 07-codex.md:1272 | BUILT, lands on Detail (EnergyGift.swift:19-201; RootView.swift:134-138) | RE-ROUTE |
| HH-48 | Grace and gratitude returning in her room | GraceChannel speaks a past moment once, her room first ('Three nights ago, you kept a silence with …'); his Gratitude column room-matched about one day in three, never repeated; one line, bottom band, after the portrait, then rests. | G7-1001, G7-1004 · 22-code-tests.md:612; 22-code-tests.md:615 | BUILT for Rite (RiteDay; CoherenceTests) | EXTEND to room |
| HH-49 | HomeMemory — dwell, head start, compression | @Model per kp: visits, accumulatedDwell, longestDwell, lastDwell, lastVisit, deepestAdaptation; dwellCap 4000; headStart 0 below 12 s else min(dwell·.55, holdEnd(kp)−6) (221 at even); compression Room max(.36,.68^min(v,4)) · Light Room max(.36,.66^min(v−1,3)) — kept where each was designed; never shown. Restore from the ledger on an empty store (Silence Held / First Dwelling Duration) — practice data never lost. | G1-0023, G2-0228, G6-0801, G6-0847, G6-0888, G4-0773, G4-0852, G5-0161, G7-0669, G7-0984, G6-1030, G4-0870, G1-0427, G2-0329 · 01-homes.md:85; 04-briefs-audits-frames.md:354; 17-code-core.md:326 | BUILT (Models/HomeMemory.swift:14-154) — local only, not restorable | REUSE; NEW ledger restore |
| HH-50 | 'you have stood here before' once, floor traces as light, she was expecting you | On a return (prior dwell ≥ 12 s): low line 'you have stood here before' for the first 14 s after head start, never on a first visit; her core white light with steady pulse rate .22 depth .09 halo ×1.25; one trace of her gem light on her floor per earlier stay, max 7, size 1.1 op .16 y −4.1, scattered by seed (kp,n); Light Room: 7 marks on the lower third hsl(hue,60%,86%) op .16. The Climb's lights stay alike (ruling 15). No number anywhere. | G1-0024, G1-0296, G1-0327, G6-1031, G6-1068, G2-0263, G2-0282, G3-0350, G3-0538, G6-1076 · 01-homes.md:85; 01-homes.md:111; 01-homes.md:688 | NOT BUILT / REMOVED (RiteOfEnteringView.swift:65; TheBuilding.swift:139-166) | NEW |
| HH-51 | Return deepens the room | Room opens further along (head start), deeper light (+.06 farL per log2(visits) to +.18), walls recede further (shell scale ×1.04 per return to ×1.12); C-1354 'the second time I come back … a more deeper perspective'. | G3-0518 · 07-codex.md:995-998; 07-codex.md:1294; 07-codex.md:1382 | NOT BUILT | NEW |
| HH-52 | A ring drawn by hand, settling true; patina | On return her seat ring is drawn off-centre and settles over 4 s (180 segs, R·(1+wob·nz(u·2π+seed)·.055), wob = (1−trueness)·1.5+.35…); tone 1.5 % flat into tune, gain 0→.036@3.2 s→.020@6 s→0@9 s, fifth partial only when granted. Patina a = (days since first stay/1095)^.55 ages traces bone (228,220,205) → amber (208,158,72) → deep gold (164,112,38), grain .05+.14a. | G5-0065, G5-0064 · 12-padakarshini-field.md:318; 13-rupakarshini.md:212-215; 13-rupakarshini.md:987 | NOT BUILT | NEW |
| HH-53 | A third state beyond the second adaptation | Per-Śakti refinement 'without end', worth doing once the instrument runs on the phone; reserved slot c after secondEnd(kp)+600 s of accumulated dwell; authored room by room, never generated. | G1-0337, G1-0336 · 01-homes.md:832; 01-homes.md:832-834 | NOT BUILT | LATER (slot only) |
| HH-54 | The fifth — offered by relationship | grantsFifth: ring 9 always 1; else max(second-adaptation ramp 287→.5, 347→1, relationship dwell 180→0, 330→.5, 480→1); ground fifth ×.75 at .035 from the first beat. An offer, not a lock. | G7-1033, G2-0264 · 22-code-tests.md:646; 04-briefs-audits-frames.md:414 | BUILT as gating (HomeMemory.swift:111-154) | REFRAME as offer |
| HH-55 | Silence Held and First Dwelling | Silence Held once per visit at adaptEnd(kp) (was 62 s), First Dwelling once ever at holdEnd(kp), Full Circle at kp 102, Mauna at kp 102 when held; wakes, never polls; invisible; ledger Duration (sec) is his real seconds, never shown. | G6-0846, G6-0848, G2-0335, G7-0668, G2-0467 · 17-code-core.md:641; 17-code-core.md:649; 04-briefs-audits-frames.md:542 | BUILT (Services/HomeDwelling.swift:79-225) | REUSE; marks by kp |
| HH-56 | forget me | Lets every trace, dwell and compression for one Śakti (or all) go; in Settings and the library foot; ledger rows remain (practice data never lost) but local felt memory resets. | G2-0475 · 04-briefs-audits-frames.md:857 | NOT BUILT | NEW |
| HH-57 | Go deeper in the Room — the shaft of five stations, Design's solids | 46 rungs 32-gon r 5.4·.985^i at z −8−2.2i, op .05+.34·near (near = 1−clamp(\|z−depth\|/34)); key PointLight gem 900 at depth−6; 160 motes; STATION_Z [−16,−34,−52,−70,−88], dz ease .032 (.018 RM); stations visible near > .02 (/22). 1 tattva TorusKnot(1.5,.34,128,16,2,3) emissive 1.8 · 2 location 13 bars, hers lit · 3 etymology roots orbit inward 14 s r 3.4(1−draw), 'one' sprite draw³·.9 · 4 quality Icosahedron(2.1,1) · 5 phrase three tori r 2.4/3.5/4.6. Controls 'go deeper' → 'further' → 'come back up'; glissando −m3 per station; empty fields skipped. | G1-0006, G1-0089, G1-0286, G1-0287, G1-0288, G1-0289, G1-0290, G1-0291, G1-0292, G6-0967, G6-0982, G6-1023, G6-1024, G6-1067, G7-0320, G7-0694, G7-0982, G5-0165, G2-0260, G5-0305 · 01-homes.md:7; 01-homes.md:82; 01-homes.md:242 | PARTIAL — shaft and words, solids refused (HomeDescent.swift:21-43; DescentShaft.swift:163-208) | RESTORE solids |
| HH-58 | 'go deeper' always offered | DescentReach.shallow (3 of 5 until 62 s) lifted; Light Room's control appears at a ≈ .28 by Design (a visual arrival, not a lock). | G2-0387 · 04-briefs-audits-frames.md:630 | WRONG — gated (HomeDescentTests:327-339) | LIFT |
| HH-59 | The library — the floor of her | Reached by 'the library' (sheet: opacity 520 ms, translateY 30→0 620 ms cubic-bezier(.16,1,.3,1), radius 24, rgba(14,10,14,.97)→rgba(9,5,8,.99), gold hairline, 88 px tap pad) or as 'the floor of her' after the last station/chamber (overlay rgba(3,1,2,.9), 900 ms). Rows verbatim, empty omitted: quality · Function · Somatic · Iconography · tattva · bodily location · etymology · inscription · Devanāgarī · bīja · āvaraṇa · her seat · family · family gloss · presiding form · Yoginī · mental state · goddess's body region · world · clock · altitude · Mudrā verb · seed verb · related seats. Foot: 'her presence', 'the research behind her' (L-1537 / L-1533 ring 2, read-only, Q4), 'forget me'. 'rise back into her room'. Nothing deleted. | G1-0087, G1-0453, G1-0454, G6-0590, G5-0306, G6-0762, G5-0731, G5-1029, G2-0202, G1-0323, G2-0286, G1-0601, G6-0510, G6-0511, G6-0512, G6-0513, G6-0514, G6-0515, G6-0516, G6-0517, G6-0518, G6-0519 · 01-homes.md:238; 02-rite-axis-field.md:271-273; 02-rite-axis-field.md:275-277 | NOT BUILT in room (RiteLibrary orphaned; Detail is a page) | NEW sheet; MOVE Detail sections |
| HH-60 | The Light Room — Rite R-09 seat interior as the Home's second mode | Entered by a two-finger hold 1.3 s or 'her light' (after a ≥ .28); last mode remembered per kp. One-point perspective, far wall = aperture; canvas 402×874, R 330, kFar .28, kNear 2.55, VP (201, alt·874); outlines square ±1×.94 · petal 11-step sin^1.45×.58 · tri-up/down · circle 26-gon; riteApertureSpan = vy ± 330·.28·max\|y\| (room and layout from one function). Draw order: ground hsl(wallHue,34%,1.4+1.6a%) · yantra beyond · bloom 1−.55b · aperture face · floor-lit walls (hsl(wallHue,30+24f,4+(10+30f)a)) · edges .3+.5a · far outline .24+.6a · shaft radial r 1.5R · dhātu grain fractalNoise .72 ×3 oct seed 7 overlay .05+.09a · vignette 45 % → .9−.28a. farL = 20+62a; blur 2.2+5(1−a), far 3+16(1−a). Room = world (shape, wall hue, gem, clock, bīja, after); aperture = Śakti (face, altitude, rate, lines, letter, phrase). | G1-0432, G1-0433, G1-0435, G1-0436, G6-1041, G6-1065, G6-1057, G6-1060, G1-0593, G1-0457, G1-0415, G1-0446 · 02-rite-axis-field.md:156-169; 02-rite-axis-field.md:171; 02-rite-axis-field.md:182-192 | NOT BUILT, NOT REACHABLE (only SeatShape and after-kinds ported) | NEW (Canvas or Metal) |
| HH-61 | Aperture faces per Śakti | L = lum·(.34+.66a); core hsl(hue, sat·.5, min(97,L+34)); mid hsl(hue,sat,L); s = r·.66. point core .3s + mid .62s · triad 3 nodes at s(.44+.16b) spreading · tri-down outer + inner .85 · ring16/ring8 core .34s + 16/8 dots at .82s · band ellipse + bar riding sin(bπ) · lens vesica + core. Face per kp by attribute key (ruling §7 C2). | G1-0434, G2-0308 · 02-rite-axis-field.md:173-180; 04-briefs-audits-frames.md:493 | NOT BUILT | NEW |
| HH-62 | The Śrī Yantra beyond the far wall, arriving at the second adaptation | RiteYantraBeyond stroke farHot, scale .34+.5b, opacity .1+.72b: 300 square + 4 gate ticks, 16 petals 132/112 hw 20, 8 petals 104/88 hw 30, 4 up + 5 down triangles; her signature fades (1−.7b) as the yantra takes over — 'what lies beyond — the rest of the 102, arriving only on the second adaptation'. | G1-0592 · 02-rite-axis-field.md:1602-1605; 02-rite-axis-field.md:184 | NOT BUILT | NEW |
| HH-63 | Light Room threshold — no black card | Overlay radial at (50 %, alt) hsla(hue,sat,40%,.1) → rgba(4,1,3,.5) 62 % → .82, text on dark halo r 200; phrase 24 px lh 1.5; Devanāgarī 36 px + Latin name 15 px .24em uppercase hsl(hue,52%,72%) op c01((p−.55)/.45)·.62; roots 26 px gap (1−join)·split·28, last root italic when > 2, gloss 16.5 px max-width 270 ×.5; bars bottom 92 gap 9 (16×4 / 4×4, done hsl(hue,50%,76%)); hint bottom 62 10.5 px .28em; beat {2.4,3.2,2.8} s × max(.36,.66^min(v−1,3)) × 1.35 RM; reduced: writing as 500 ms fade, roots gap 14 → 0. | G1-0437, G1-0438, G1-0439 · 02-rite-axis-field.md:199-203; 02-rite-axis-field.md:206-208; 02-rite-axis-field.md:210-216 | NOT BUILT | NEW |
| HH-64 | Light Room dwelling overlay | TOP_BAND 52, BOTTOM_BAND 150, ID_H 60, overlay fades in 1800 ms; Devanāgarī cut into the wall above the light 30 px cream .62 shadow 0 0 26 px hsla(hue,60%,40%,.5); quality 11.5 px .3em hsl(hue,48%,74%) .72; portrait band (HH-37); letter slip (HH-39); edge doors (HH-40); 'go deeper' 150×46 at bottom 40, cross(a,.28,.3)·.8, over 58×1 hairline; leave chevron top 52 left 6 46×46 cream .42. 'Text is residue here: the architecture carries the recognition.' | G1-0440, G1-0441, G1-0445, G6-1042 · 02-rite-axis-field.md:219-225; 02-rite-axis-field.md:226; 02-rite-axis-field.md:230-231 | PARTIAL — RoomWordsView only | NEW |
| HH-65 | The fall through five chambers + 'the floor of her' | Chambers: 1 function — 7 copies of the room shape expand r 18→156 (phase .16/s) · 2 somatic — 15 registers from y −150 step 21.4, hers (−150+alt·300) widen 26+62near, breathing ellipse .5+.5sin(.55t) · 3 icon — point: 4 circles 140→14 'the noose: it draws the vast into the tiny' / triad: 3 seals 112→20 / tri-down: two triangles 74→2 'the womb-seal' / other face r 110 · 4 tattva — shape r 118 5°/s, r 78 fill .1, r 44 −3°/s · 5 root — roots orbit 118→0 on cyc=(sin .32t+1)/2, size 23→15, Devanāgarī 40 px at cyc·.95. Fall: target +1 per tap (max 5), dz .055 (.028 RM), render rel ∈ (−1.1,2.2), scale 2.5^(−rel), opacity rel ≥ 0 ? 1−.62rel : 1+1.5rel; shaft 8 outlines r 14·2.9^(ph·2.1); riteFall 700 ms; caption label mono 10.5 + text 19 px at bottom 148; depth marks left 20; hint 'touch to go further in'; then the floor of her (HH-59); rise chevron at any depth. | G1-0447, G1-0448, G1-0449, G1-0450, G1-0451, G1-0452 · 02-rite-axis-field.md:238-248; 02-rite-axis-field.md:251; 02-rite-axis-field.md:252 | NOT BUILT | NEW |
| HH-66 | Light Room clock | adapt 90·rate.mul (64.8 / 90 / 124.2 / 100.8 s), hold 165, second 120, a and b by smoothstep²; phases adapting → settled → second → deep; reduced 160/190/150 with a in 4 steps, b in 3; dt capped .25 s. | G1-0426, G1-0416 · 02-rite-axis-field.md:91-108; 02-rite-axis-field.md:30; 02-rite-axis-field.md:92 | NOT BUILT | NEW |
| HH-67 | Her Dance — door and space | Entered by 'her dance' (or a 1.3 s long-press on her attribute) in her room, or a long hold on her seat in the Mandala; full-screen third mode of the Home; way out returns to the exact moment of her room. Chakra dances stay in the 33. | G4-0229 · 08-dances.md:1053-1062 | NOT BUILT | NEW |
| HH-68 | Songless Score from her own tone | No Śakti has a song; nothing invented. P = Score tempo.breath ‖ 5.5 s; E = .5+.5 sin(2πt/P) scaled to sustain mode; 180 s: silence 0–4 · intro 4–30 · build 30–90 · peak 90–110 (PEAK_T 100) · descent 110–160 · outro 160–180. Data: kp → star position; ring/āvaraṇa → chakra via subtleBodyChakra → language; colour → hue; bīja → carrier interval (never stored as a Śakti Hz); mudrā/body → gesture/haptic. Writes Played; never writes Recognition (resonance_link writes_recognition stays false). | G4-0232, G4-0633, G4-0336, G4-0627, G6-0871, G6-0898, G6-0791 · 08-dances.md:1086-1104; 10-field-data-catalog.md:542; 09-field-scores.md:172 | NOT BUILT (carrier + Score reader built: HomeSoundService.swift:79-220; ShaktiFactsCache.swift:93-211) | NEW (reuses carrier/Score) |
| HH-69 | The ensemble — seven archetypes hear her, plus Neev, Shweta, Lalitā | One Dancer struct (hue, radius, presence, target, ghost ring) on Canvas/TimelineView; Gaia = ground drone (bass) · Sid = carrier held (orbit .012, r maxR(.2+sidSm·.1), squash .55) · Arch = bīja when struck (0.7 s mirror) · Karishma = silences (kT = e<.3 ? min(1,(.3−e)/.25)·.8 : 0) · Sakshi = ring position at the edge (.003 arc) · Ashrey = web to her door neighbours · Bindu = his touch (Lissajous, comet 28, freeze on tap); entry thresholds .12/.22/.32/—/.45/.65; presence lerp .04/.015; Neev t<4 s and last 2 s; Shweta at PEAK_T; Lalitā (the Mirror) after descent; names as tiny labels on long-press; colours from her palette (settled). | G4-0235, G4-0010, G4-0011, G4-0012, G4-0013, G4-0014, G4-0015, G4-0016, G4-0019, G4-0303, G4-0460, G4-0233, G4-0589 · 08-dances.md:1125; 08-dances.md:1426; 08-dances.md:128-140 | NOT BUILT in app | NEW |
| HH-70 | Bloom five stages | dot → ghost trail (every .2 s, alpha a(1−age/6)) → orbital rings on breath peaks → rays + particles + edge glow → crown = her seat's own geometry; rise .06 fall .012; thresholds .15/.3/.5/.7; ramps s1=(b−.1)/.2 … s4=(b−.7)/.3. | G4-0027, G4-0322 · 08-dances.md:184-194; 09-field-scores.md:156; 09-field-scores.md:661 | NOT BUILT | NEW |
| HH-71 | Pre-roll, seed and word | Breathing ring 140 px on her breath, 'Breathe with the field. When you are ready, the seed will arrive.', 'tap when ready', auto after 10 s; seed = her Appreciation Phrase verbatim typed at P/20 per character (≈275 ms); at PEAK_T her quality word at bottom 15 %, dissolving 4 s (scale → 1.8, tracking 30 px, α 0). | G4-0049, G4-0050, G4-0329 · 08-dances.md:339-342; 08-dances.md:344-348; 09-field-scores.md:164 | NOT BUILT | NEW |
| HH-72 | Sustain mode and adaptive bloom | Drone-class source (no onsets): breath-driven bloom scaled to her own floor/ceiling (fixes the 1,780 false hits on drones); singing-bowl decay envelope rides 20–40 s. | G4-0116 · 08-dances.md:632-636; 08-dances.md:1201 | NOT BUILT | NEW |
| HH-73 | Binaural on her tone; inverse gain | AVAudioEngine: L = her carrier, R = carrier + beat (hard pan); beat 8 → 7 → 5 → 4.5 → 7.83 at PEAK_T (3 s) → 6 → 7→9 → 10, ±.3 wobble, frozen in Karishma windows; amp = .045+.015 sin(.18t)+.025(1−E) ('They share the field; they do not compete.'); Gaia's ground = her ring technique. | G4-0164, G4-0463 · 08-dances.md:778-800; 08-dances.md:1145; 09-field-scores.md:645 | NOT BUILT | NEW |
| HH-74 | Lalitā as the Mirror — light washes | Near-white wash α 40–70 %, rise 1–2 s, hold, fade 2–4 s, at bloom crossings .5/.7/.9 (40–60 %), post-silence surge E<.1 → >.4 (50–70 %), the peak (brightest); then contrast boost 3–5 s. 'The mirror is not a dancer. It's the room remembering it's alive.' | G4-0036 · 08-dances.md:220-235 | NOT BUILT | NEW |
| HH-75 | Karishma's valley and windows | Valley heartbeat 1.2 s period, rise 100 ms, fall 500 ms, hue 345 in the longest silence; fulcrum haptic 50 bpm; a recognition pressed in the dance lands act 2 in the next window (≤ one breath). | G4-0248, G4-0619 · 08-dances.md:1153; 10-field-data-catalog.md:480 | NOT BUILT | NEW |
| HH-76 | Floor residue and the breathing floor | Residue grid 25×35, spread + decay, karishma_decay .0005, persisted per kp locally and laid on her floor next time; Cathedral Floor radial α .06+.04·breath(5.5 s) under the dance and the Light Room. | G4-0249, G4-0324, G4-0251 · 08-dances.md:1154; 09-field-scores.md:158; 09-field-scores.md:660 | NOT BUILT | NEW |
| HH-77 | Her chakra's dance language; shape by meaning | Ring → chakra via subtleBodyChakra; ring 2 → Anahata heart language (warmth map 30×40, 5 warm bands α ≤ .32, 12 lotus petals, hexagram, infinity weave, cardioid at bloom > .85, canvas breath 1+heartScale·.015; reach's ripples, permanent halos); shape: circle 'the only breath' default · heart ring 2 · infinity kp 2 · spiral on a return · none at ring-9 peak. | G4-0095, G4-0205, G4-0382 · 08-dances.md:497-516; 08-dances.md:1171; 08-dances.md:924-931 | NOT BUILT | NEW |
| HH-78 | Haptic library | Core Haptics: bell [20,30,40,30,20]×hit, mirror [8], the_strike [8,20,8,400], fulcrum [30] at 50 bpm, crossing_peak [12,40,12,40,12,60,30,12,40] at every Recognition and PEAK_T; continuous hold ramp .15 → .6. | (derived) | NOT BUILT | NEW |
| HH-79 | No figure — the Bindu dances, she is the field | Dancers are dots and traced paths; no Śakti is drawn as a dancer or body. | G4-0294 · 08-dances.md:1303 | n/a (floor) | FLOOR |
| HH-80 | The way out | Hold 2.2 s 'hold to withdraw' (Garimā 3.3 s), RM single touch 'touch to withdraw'; leading-edge swipe 22 pt edge 72 pt travel; the rope G13 / leave by the edge G38 from any chamber; Escape; let-go undoes the ending; a stay filed once. | G7-0323, G7-0324, G4-0856, G7-0322, G7-0321, G7-0489 · 20-code-play-rooms.md:359-363; 20-code-play-rooms.md:365; 11-padakarshini-forms.md:557 | BUILT (TheWayOut.swift:49-56; TheEdgeWayOut.swift; TheStay.swift) | REUSE; lift two-gesture law |
| HH-81 | After-effect — felt, never named | Her ring's kind on the whole app 180 s, e = (1−age/180)², filter transition 1200 ms: lighter brightness(1+.07e) saturate(1−.06e) translateY(−3e) · heavier brightness(1−.06e) contrast(1+.04e) scale(1+.01e) origin bottom · sharper contrast(1+.1e) saturate(1+.05e) scale(1−.014e) · wider brightness(1+.03e) scale(1+.018e); kinds R1 sharper · R2 wider · R3 lighter · R4 wider · R5 sharper · R6 heavier · R7 wider · R8 lighter · R9 wider; 3D exposure 1.04+.12(1−age/24) for 24 s. No line — 'her siddhi is still on the instrument' removed (ruling 15). | G1-0009, G1-0090, G1-0430, G6-0970, G6-1033, G6-1069, G7-0328, G7-0980, G2-0262 · 01-homes.md:7; 01-homes.md:84; 01-homes.md:114 | PARTIAL — kinds + 180 s built, line shown 12 s (HomeAfterEffect.swift:28-46,101-104; HerSiddhiLingers.swift) | DELETE line; APPLY app-wide modifier |
| HH-82 | Back to exactly where he was | Crossing out through the point (trav −= dt/2.4) to the Mandala seat at its zoom, Climb band, Today, chakra room or neighbour corridor; one router + back stack; menu and point visible in rooms (op .32, .12 while still); didSettle no longer jumps to the Portrait from a room. | G7-0163, G7-0170, G7-0183, G7-0645, G7-0714, G2-0319 · 19-code-mandala-today.md:555; 19-code-mandala-today.md:544; 19-code-mandala-today.md:562 | PARTIAL — covers hide menu; didSettle jump (RootView) | CHANGE routing |
| HH-83 | Room sound — her ring's voice and her carrier | Roots [55,61.74,69.30,73.42,82.41,92.50,98,110,123.47]; 49-syllable varṇamālā; JUST 12; carrier = root × JUST[idx%12] × 2 (Am → 110, ka → 137.5); techniques R1 drone · R2 breath · R3/6 breathy · R4/5 stepped [1,9/8,5/4,3/2] 5.2/3.4 s · R7 sourceless partials 2,3,5 .42/.26/.14 · R8 triad 1/1.26/1.5 glide 3.4 period 14 · R9 Shepard 5 voices .22; strike [1,1.5,2]; filter 220→1720; air .006→.018; Score overrides; per frame setGround/setCarrier/setRoom(smooth(t/a), grantsFifth). A room is whole with sound off; silent switch honoured; a sound control returns (ruling 10). | G1-0093, G2-0264, G6-0816, G6-0817, G6-0820, G7-0695, G7-0696, G7-0968, G6-1032, G6-1071, G2-0341, G6-0930, G1-0330, G1-0431 · 01-homes.md:250; 04-briefs-audits-frames.md:414; 17-code-core.md:439 | BUILT (HomeSoundService.swift:79-1176; HomeVoice.swift — 'no in-app volume' :50-52) | REUSE; LIFT no-controls |
| HH-84 | Bīja tap tuned by the ring roots | Her bīja sounds at her carrier (×1, fifth .6 only when granted, octave .4), not FNV-hashed onto a pentatonic; recorded bija_%02d path kept dead until his recordings exist (no generated voice). | G6-0819 · 17-code-core.md:467 | WRONG — hash pitch (BijaSoundService.swift:108-159) | CHANGE |
| HH-85 | Reduce Motion — slowed, not frozen | Room adapt 62·rate·160/90, hold 190, second 150; Light Room 160·rate/190/150; a in 4 steps, b in 3, each step crossfades 1.2 s; decorative drift stops; attribute and mechanism at .5× rendered at 15 fps; rite ×1.35 with 500 ms fades; motes static; dance .5× lerps, bloom in 5 steps; way out a touch. | G1-0416, G6-0975, G6-1046, G6-1058, G6-1070, G2-0455 · 02-rite-axis-field.md:30; 02-rite-axis-field.md:92; 02-rite-axis-field.md:105 | WRONG — render loop stops, posed once settled (RoomView.swift:29-54,322-336) | REWRITE |
| HH-86 | Accessibility and the contrast floor | Every seat speaks her name (no numeral: 'thirty-third of the one hundred and two'); Dynamic Type AX3XL with no cut; controls ≥ 43.5 pt; read text ≥ 11 pt and ≥ .3 α; contrast floor at both adaptations; additive particles clamped (Laghimā white-stack defect); VoiceOver reads portrait lines at once. | G2-0265 · 04-briefs-audits-frames.md:415 | BUILT for Detail (AccessibilityReachTests) | EXTEND to rooms |
| HH-87 | Wake lock in still phases | isIdleTimerDisabled while a stillness or eyes-closed phase runs (portrait, Light Room, dance), released on exit. | G5-0689 · 14-aistrangegame.md:957; 14-aistrangegame.md:1073 | NOT BUILT | NEW |
| HH-88 | Ruling 4 elements by kp | Explicit kp → element table for ring 2 (31 fire, 40 air, 42 light, 43 water) and a .light case in Element.parse and SensoryDoorway; re-pin CrossingRoomTests physics, RecognitionNature (light → radiate, water → pool, fire → flare, air → disperse), activation gesture and carrier. | G6-0924, G7-1029 · 17-code-core.md:802; 22-code-tests.md:642 | WRONG (Element.swift:28-36; ShaktiBootstrap.swift:53,201,235,253) | FIX |
| HH-89 | Bīja series fix and names by kp | Seeded ring-2 vowel series corrected to a ā i ī u ū ṛ ṝ ḷ ḹ e ai o au aṃ aḥ; names always from the Mandala row by kp (card/app names drifted on 61 of 102; two Kāmeśvarīs kp 88/99 kept apart). | G6-0926, G1-0246, G6-0620, G2-0278, G6-0792, G6-0648, G2-0082 · 17-code-core.md:816; 01-homes.md:482-509; 01-homes.md:576-579 | WRONG (ShaktiBootstrap.swift:151-267) | FIX |
| HH-90 | HerRoomPassage fetch | seat(_:in:) / corridor(of:) fetch one row by kp predicate, once per entry (was every row, twice per render). | G7-0313, G2-0391 · 20-code-play-rooms.md:328; 20-code-play-rooms.md:733; 04-briefs-audits-frames.md:634 | WRONG (HerRoomDoor.swift:92,102,120-139) | FIX |
| HH-91 | Room verification harness | Port homes-verify.js (66 checks, 9 registers: canon, coverage, distinction, legibility, promise, felt, coherence, brief, iconography); fingerprints 5×5 probes at [0,24,62,140,227,287,347]·rate, sister divergence > .1; Gate Laghimā vs Garimā > .5 (Design: 100 % geometry, 116 luminance); 'could this room belong to any other Śakti?'; screenshot vs Design concept frames; verify the verifier; Siddhi–Mātṛkā expected failure resolved. | G7-0620, G7-0690, G1-0045, G2-0240, G2-0267, G1-0331, G2-0273, G2-0271, G7-1019, G7-1018, G7-1034, G2-0400, G2-0406, G7-0710, G1-0311, G1-0312, G1-0313, G1-0314, G1-0315, G1-0316, G1-0317, G1-0318, G1-0319, G1-0300, G7-0713, G2-0349, G2-0466, G7-1027 · 22-code-tests.md:37; 22-code-tests.md:230-237; 22-code-tests.md:657 | PARTIAL (HomesHarnessTests; ring suites) | EXTEND |
| HH-92 | Visual tokens of Her Home | Mandala chassis + S13 Room: ground #0D0508 … ring hues, per-world wash/deep oklab mixes, per-Śakti palette from one hue + jitter(kp), breath periods, Cormorant/system/mono; 'the room is its light'. | G5-0484, G5-0517, G5-0363, G5-0438 · 13-rupakarshini.md:566-577; 13-rupakarshini.md:785-787; 13-rupakarshini.md:795-803 | PARTIAL (Color+Tokens.swift) | COMPLETE chassis (OKLab helper) |
| HH-93 | Chakra-thread doors from her room | Her room carries a door to her chakra's room in the 33 (Avaraṇa subtleBodyChakra → room; e.g. R1 → Muladhara/Svadhisthana/Manipura by family, R2 → Anahata, R3 → Vishuddha (45–48) / Ajna (49–52), R4 → Soles/Forge/Sonar, R5 → Prana/Hands/Pulse, R6 → Echo/Vision/Axis/Crow, R7 → the Mind section 21–29, R8 → Maya/Aatma/Ego Reveal, R9 → Bindu/Lalita); the chakra room's 'into <her>'s room' is its mirror. Ring facts per chakra (presiding form, Yoginī, mental state, goddess body) feed the library. | G7-0361, G2-0599, G2-0607, G2-0615, G2-0623, G2-0631, G2-0639, G2-0647, G2-0655, G2-0664, G2-0672, G2-0680, G2-0688, G2-0696, G2-0704, G2-0712, G2-0720, G2-0728, G2-0736, G2-0744, G2-0752, G2-0760, G2-0768, G2-0776, G2-0784, G2-0792, G2-0800, G2-0808, G2-0816, G2-0825, G2-0833, G2-0844, G6-0310, G6-0312, G6-0314, G6-0316, G6-0318, G6-0320, G6-0322, G6-0324, G6-0326, G6-0328, G6-0330, G6-0332, G6-0334, G6-0336, G6-0338, G6-0340, G6-0342, G6-0344, G6-0346, G6-0348, G6-0350, G6-0352, G6-0354, G6-0356, G6-0358, G6-0360, G6-0362, G6-0364, G6-0366, G6-0368, G6-0370, G6-0372, G6-0374, G6-0052, G6-0059, G6-0067, G6-0075, G6-0083, G6-0091, G6-0099, G6-0107, G6-0115, G6-0123, G6-0131, G6-0139, G6-0147, G6-0155, G6-0162, G6-0169, G6-0176, G6-0183, G6-0190, G6-0197, G6-0204, G6-0211, G6-0218, G6-0225, G6-0232, G6-0239 · 20-code-play-rooms.md:439; 05-chakra-corpus.md:558-564; 05-chakra-corpus.md:626-632 | PARTIAL — chakra room → her room door built (ChakraRoomView.swift:524-579); no return door | NEW door; BAKE Shakti Function |
| HH-94 | Navigation to her Home from Today/Rite and Chakra rooms (routes today) | Today: seat line / RiteDayDoors → room (DailyRiteView.swift:125,433); 'I feel her' pill breathing at her ring's rate; Chakra room ChakraRoomExitView → HerRoomPassage. All re-routed through one router. | G7-0104, G7-0163, G7-0170, G7-0183 · 19-code-mandala-today.md:365-369; 19-code-mandala-today.md:709; 19-code-mandala-today.md:555 | BUILT (covers) | RE-ROUTE |
| HH-95 | Code renderer files kept (Homes/) | Building/world/her layers, 64×64 height fields with 2 morph targets, 420 motes, RoomExposure HDR, Ember + HerLight, pose pure function of time, RoomApproach τ .547 s (lerp .03), release 2.2 s, RoomUnits eye at 'behind the eyes' .26, FOV 62, RoomLightPass air-light (clamp lifted, bloom on). | G6-0981, G6-0974, G6-0976, G7-0319, G2-0250, G1-0015 · 18-code-homes.md:46; 18-code-homes.md:39; 18-code-homes.md:41 | BUILT | REUSE |
| HP-01 | Her Presence — her portrait as its own world (was ShaktiDetailView) | ShaktiDetailView becomes Her Presence: hero → portrait → somatic → bīja → appreciation → embodiment → moments → go deeper → doorways/witness → Still Point → footer; the stacked Wave 5–6 sections (doorways, witness, deepening) become folds; it is no longer the gate to the Home. Kicker gains the form; portrait falls back to the ring's personalConnection. | G6-1072, G1-0488, G7-0550, G2-0178, G2-0148, G1-0574, G2-0037, G1-0680, G1-0669, G2-0156 · 18-code-homes.md:151; 02-rite-axis-field.md:678-689; 21-code-layers.md:50 | PARTIAL — matches 02 L-13 closely (ShaktiDetailView.swift:379-385 lacks form) | RESHAPE |
| HP-02 | Arriving at her Presence | Crossing through the point in her hue; dark first (0 → 0 at 22 %, 1 at 1.8 s); staged arrival identity .4 s · form line 2.2 · quality 3.4 · controls 5.6 (the Oracle's rhythm; no generated text); quality word by word at 200 ms after a 4 s breathing ring collapses (height → 0). | G5-0472, G4-0307, G5-0591 · 13-rupakarshini.md:536; 13-rupakarshini.md:911; 09-field-scores.md:63 | NOT BUILT | NEW |
| HP-03 | Her identity disc — no figure | 96 px disc in her hue with her ring's geometry glyph (the glyph is the card); bīja texture 320 px gold ~.065 behind; breathes on her own clock (Score tempo.breath ‖ ring breath); hold → 0.1 Hz heart (1 → 1.06 → 1 over 10 s, haptic 100 ms at peaks); two-finger turn shows the back face: her seat lit among the whole 102 (C-1135); pinch 1–4× focal zoom (tap 2×, snap below 1.08). One record (colour, glyph, name) read live everywhere (law 25). | G5-0475, G5-0468, G5-0443, G3-0382, G5-0474, G5-0338, G1-0667, G5-0594, G5-0660, G4-0702 · 13-rupakarshini.md:541; 13-rupakarshini.md:913; 13-rupakarshini.md:118 | NOT BUILT (RiteSigil spinning hero exists) | NEW |
| HP-04 | Form line and name | '{Ordinal} Āvaraṇa · {presiding form}' 11.5 px .3em; name lrNameSize(name,50) weight 300 glow 50 px; phonetic 12.5 px .48; hairline 54; quality 24 px accentBright; ring 2 cluster dot + label + 'She is the drawing-in of {quality} — already running in you before the app was opened.' | G1-0489, G1-0546, G6-0799 · 02-rite-axis-field.md:692-698; 02-rite-axis-field.md:1203-1209; 17-code-core.md:316 | PARTIAL (kicker lacks form) | CHANGE |
| HP-05 | The portrait at the pace of stillness | Same ratchet as HH-37 (4+6.5n s; touches on her objects are not restlessness); Codex Portrait sentences, then Function, Somatic, Iconography; gold italic 20 px lh 1.6 'the soul, leading'; verse move: each line rises 14 px while blur clears 6 → 0 over 3.2 s; never truncated. | G1-0490, G1-0040, G1-0429, G1-0442, G1-0422, G1-0424 · 02-rite-axis-field.md:699; 01-homes.md:111; 02-rite-axis-field.md:121-126 | PARTIAL — Codex Portrait shown as a static section | NEW mechanism |
| HP-06 | Her ring's Personal Connection — his voice | After her lines, the ring's personalConnection paragraph sentence by sentence at the same cadence; where she has no portrait text it is her portrait (Design fallback); ring 9's paragraph lives here, not on Praveśa. | G1-0063, G6-1044 · 01-homes.md:178-187; 18-code-homes.md:118 | NOT BUILT | NEW |
| HP-07 | The Turning — colour through staying | Rests grey: saturate(.32+.68l) brightness(.70+.30l); press-and-stay on the ∞ path 2.9 s raises l, early release drains 750 ms; words legible past l = .55; captions 'trace the loop — let the light in' → 'stay with the turning…' → 'witnessed · the light is up'; once l = 1 colour stays the visit; identity always open. | G5-0087, G5-0092 · 12-padakarshini-field.md:363-365; 13-rupakarshini.md:538-541; 13-rupakarshini.md:912 | NOT BUILT | NEW |
| HP-08 | Somatic signature and where she is felt | somaticPoetry italic 20 lh 1.65; his body as twelve regions of light (never a figure, never hers) with her bodilyLocation lit; her everyday doorway by tattva (heat / water / earth / breath / space / light) with her first somatic line. | G1-0491, G7-0539, G6-0812, G6-0904, G7-1013, G7-0719 · 02-rite-axis-field.md:700; 21-code-layers.md:38; 21-code-layers.md:148 | PARTIAL (SomaticRegion.swift:36-116; WhereSheSpeaksView) | MOVE body-of-light into Presence; ADD light |
| HP-09 | Her bīja — tap to sound her | 84 px weight 300 gold; shadow 40 px rest → 70 px accent while sounding; tap → 3.6 s at her carrier + pulse 1.4 s + three 90 px rings over 3.6 s (delays 0/.5/1 s); 'tap to sound her' → 'sounding'. | G1-0492 · 02-rite-axis-field.md:701-705 | BUILT (84 pt, rings) with hash pitch | REUSE; retune (HH-84) |
| HP-10 | Appreciation | Hairline 36 then her phrase italic 19 gold centred — 'a prayer, not a field'. | G1-0493 · 02-rite-axis-field.md:706-719 | BUILT | REUSE |
| HP-11 | go deeper — the disclosure rows | Tattva · Bodily seat · Her ring ('{av.name} — {av.subtitle}') · Form (formDescription) · Mental state · Chakra · Iconography · Function · Etymology · Śakti family; verbatim; folds closed every visit. | G1-0601 · 02-rite-axis-field.md:1615 | PARTIAL (rows differ) | CHANGE rows |
| HP-12 | Embodiment — the crossing is always his | Track mapped .22 · exploring .44 · active .76 · embodied 1.0; hold 750 ms (30 ms ticks), vibrate 12 ms, one level per hold, persisted per kp; readiness [0,1,3,7] felt-moments only makes the pill breathe (2.2 s) — never gates; no status seeded on a fresh install; level never spoken as a number. | G1-0480, G5-0170, G2-0008, G2-0009, G2-0100, G2-0110, G2-0123, G2-0436, G6-0811, G6-0935, G7-0551, G7-0604, G7-0688, G7-1032, G6-0866 · 02-rite-axis-field.md:619-631; 12-padakarshini-field.md:482; 12-padakarshini-field.md:931 | WRONG — count-gated (ShaktiDetailView.swift:521-532); bootstrap seeds statuses | CHANGE (Q1) |
| HP-13 | Her moments | Newest first: 6 px dot, 'she was felt here · {when}, {h:mm AM}' 12 px .6, '· {moon phase}' italic 13 .45, note italic 15 .68; empty 'She has not been felt here yet.'; no count. | G1-0521, G7-0552 · 02-rite-axis-field.md:937-939; 21-code-layers.md:50 | BUILT (ShaktiDetailView.swift:761-815) | REUSE |
| HP-14 | Her deepening — offered freely | what she does · what her ring sets down · what her ring gives · the root of her name · how she is known · her enclosure; all open, newest arriving slowly; seed verb always. | G7-0553, G7-0603, G7-1012 · 21-code-layers.md:51; 21-code-layers.md:146; 21-code-layers.md:163 | WRONG — one layer per return (HerDeepeningSection.swift:52-56) | LIFT gate |
| HP-15 | Doorways — doorway, seal, noticed in passing | Everyday doorway; the seal (2.4 s hold → her Appreciation Phrase); 'noticed her in passing' once a day, nothing placed, writes Wager Resolved 'noticed in passing' — re-grounded to C-1337, not C-1195. | G7-0554, G6-0837, G6-0907, G6-0940, G7-1006, G3-0530 · 21-code-layers.md:52; 17-code-core.md:604; 17-code-core.md:766 | BUILT, misread source (WagerStore.swift:77-109) | RE-GROUND copy |
| HP-16 | One-Page Answer and Witness Page | Her one line or 'the whole of her home ›' (door to Her Home); Witness Page: sealed envelope, 1.8 s hold 'ask for help' → her Function beside his perspective, kept every save (Witness Written), reseals on leaving. | G7-0555, G3-0467, G7-0999 · 21-code-layers.md:53; 07-codex.md:740-743; 07-codex.md:1296-1298 | BUILT (HerWitnessPage.swift:60-61) | REUSE |
| HP-17 | Still Point at the foot | Seven holds of 1.3 s each take something away: invitation → her Function sentence → quality description → Appreciation Phrase → quality word → only the ember, breathing → her Devanāgarī name; type grows as text shortens; 'Surface' always there; never gated. | G4-0683 · 11-padakarshini-forms.md:108; 11-padakarshini-forms.md:556 | NOT BUILT | NEW |
| HP-18 | I feel her → Recognition | Record first; timeline name .3 → phrase 1.1 → 'she was felt here · h:mm a' 2.6 → 'and she felt you back · h:mm:ss' 4.3 → 'What did you notice?' 5.4 (288 px, rows 1→3 past 40 ch, saved per keystroke) → 'TAP ANYWHERE TO CLOSE'; six natures flare/pool/disperse/bloom/settle/radiate (fy, focal, durations, ripples, motes per LR_RECOG); RecognitionLight standing light + after-glow k² 1.8 s; haptics settle heavy, flare rigid; bīja 320 px gold .065 behind; lines verbatim. | G1-0494, G1-0495, G1-0496, G5-0439, G7-0133, G7-0134, G7-0135, G7-0138, G7-0139, G2-0020, G7-0976, G7-0717, G1-0547, G1-0670, G7-0612, G7-0864, G7-0865, G7-0866, G7-0867, G7-0868, G7-0869, G7-0640, G1-0487, G6-0808 · 02-rite-axis-field.md:721-740; 02-rite-axis-field.md:742-750; 02-rite-axis-field.md:752-758 | BUILT (RecognitionMomentView.swift:270,288; RecognitionNature.swift) | REUSE; FIX kp fallback |
| HP-19 | Recognition settles into Memory as one transition | Collapse into the point (.55/.62 s, scale .84) → Memory opens with settle: her gold point flies from the bindu to her seat 0–.34 (ease-out cubic, fading gold line, head r 4.6 → 3.4, 14 px aura), halo blooms .34–1 (r 6 → 36, op .8 → 0), 3400 ms; from every place, then back to where he was. | G1-0587, G1-0497, G1-0526, G7-0137 · 02-rite-axis-field.md:1567-1571; 02-rite-axis-field.md:756-760; 02-rite-axis-field.md:993-998 | PARTIAL — settles only from Today (RootView.swift:105-106) | EXTEND |
| HP-20 | Field Connection on her presence | Only kp 31 Gaia, kp 40 Ashrey, kp 42 Ram (ruling 11): tinted card radius 12, 2 px left border, his fieldNote; a door to the Relationship Field. | G6-0792 · 17-code-core.md:192 | BUILT (ShaktiBootstrap fieldNote) | REUSE |
| HP-21 | Composition by element, relit by the hour, palette from one hue | Six plans fire→ascension · water→descent · air→horizon · ether→veil · earth→foundation · light→radiance; mood bits from kp (flip, spin, scale .86+…·.4, angle ·24°); hour tints dawn/noon/dusk/night (dh, L, S, glow, tint per row); backdrops breathe fire 11 · water 13 · air 12 · ether 9.6 · earth 15 · light 7.6 s; gradient geometry by meaning; top glow radial(130% 55% at 50% −5%), sigil 600 op .55 spin −1, 10 motes. | G5-0168, G5-0169, G5-0470, G6-0851, G5-0518 · 12-padakarshini-field.md:479-480; 13-rupakarshini.md:444-446; 13-rupakarshini.md:901 | PARTIAL (AtmosphereBackground.swift:51-61) | EXTEND |
| HP-22 | The heartbeat under her disc | Optional 72 BPM heartbeat (haptic only) under the disc for heart-ring seats (ring 2); from A Strange Voice's persistent heartbeat (the narrative goes to the Feed). | G5-0583 · 14-aistrangegame.md:316-320; 14-aistrangegame.md:1152 | NOT BUILT | NEW |
| HP-23 | Silent voice card | If neither portrait text nor ring paragraph exists: '·' at 40 px; omit empty rows; never invent. | G5-0476, G2-0202 · 13-rupakarshini.md:542; 04-briefs-audits-frames.md:318 | NOT BUILT | NEW |
| HP-24 | Footer — be with her, play with her, I feel her, position | 'be with her ›' (Her Home through the rite); '{seed verb} with her' play door (every one of 102: her game or the rosary at her bead); 'I feel her' full width h60 radius 30 gradient 135° red → mix(red 66 %, accent 34 %), shadow 0 4 48 glow + 0 4 30 rgba(139,26,42,.5), 23 px .14em cream; position as '{kp} · 102' (identity, not a measure). | G7-0235, G7-0989 · 20-code-play-rooms.md:64; 22-code-tests.md:388; 22-code-tests.md:599 | BUILT (ShaktiDetailView.swift:180-252) | REUSE; CHANGE position glyph |
| HP-25 | Wake lock while portrait lines arrive | Same as HH-87 in Her Presence. | (derived) | NOT BUILT | NEW |
| HP-26 | Presence verification | Snapshot geom baselines detail/recognition redrawn for the new world; LibraryFold tests generalised to 'nothing becomes unreachable'; accessibility reach kept; recognition lines harness kept unchanged. | G7-0630, G7-0633, G7-0649, G7-0718, G7-0646 · 22-code-tests.md:52-61; 22-code-tests.md:106; 22-code-tests.md:336 | BUILT | REWRITE baselines |
| HH-96 | The corridor after leaving the Light Room | Design's Rite corridor: ground radial hsl(hue,30%,6%) → #050205; two door glows top 34 % 180×60 (radial hsla(hue,70%,62%,.3) blur 9 px) to her neighbours; centre 'enter' (11.5 px .24em cream .42 over 46×1 hairline) re-enters her room with the threshold compressed. Shown for as long as he stays; the point, the menu and a held way out take him home (ruling 10 replaces 'no other navigation'). | G1-0455 · 02-rite-axis-field.md:279-294 | NOT BUILT | NEW |
| HH-97 | One hold engine for every hold in both worlds | G0: tick dt = min(64, t−last); p += target>p ? dt/UP : −dt/DOWN; commit at p ≥ 1, act on release; early release drains (620–750 ms), never a failure sound; haptics tick 8 ms at press, continuous .15 → .6 sharpness .3, one latch at completion; keyboard parity (Enter/Space); a11y role button named for the act + progress. One ladder of durations: 750 crossing · 1300 Light Room / Still Point stage / dance door · 1800 Witness · 2200 way out · 2400 seal · 2900 Turning · 3300 Garimā way out. | G4-0724, G7-0484 · 11-padakarshini-forms.md:235-270; 11-padakarshini-forms.md:669; 20-code-play-rooms.md:725 | PARTIAL — holds coded separately (TheWayOut, crossing pill, seal) | NEW shared HoldEngine |
| HH-98 | Stillness kept: her far wall answers accumulated stillness | Unbroken stillness of 4.6 s in the Light Room after a ≥ .4 lets the far-wall yantra arrive at op .12 ahead of b (an arrival, held once arrived — high-water); every still second he has given in her room is kept per kp and adds to the relationship ramp of the fifth (HH-54). Touch pauses, never resets the kept total. | G4-0853 · 11-padakarshini-forms.md:550 | NOT BUILT | NEW |
| HH-99 | Build order and the sample-before-batch gate | Design's order: settle names → ShaktiCard by position → Gem + RingWorld → RoomMechanism + seat → rite, library, leaving → grammar (102 rooms land together) → attribute → doors and corridor → return + descent → sound per ring last; sample-before-batch (Laghimā vs Garimā first, then ring by ring, Ring 2 first); Ring 9 built last and by hand. Here: Wave A light (HH-08, HH-09…17, HH-31, HH-33), Wave B rooms (HH-18…28), Wave C Home/Detail swap + library + Presence (HH-01, HH-59, HP-*), Wave D Light Room (HH-60…66), Wave E return + dance (HH-49…56, HH-67…79). | G1-0033, G1-0037, G1-0050, G2-0241, G1-0413, G1-0034 · 01-homes.md:98; 01-homes.md:107; 01-homes.md:149 | n/a | PLAN |
| HP-27 | Presence data defects | Lalitā's Presence keyed by kp 102 (not shaktis.last); Recognition kp from the row (not position + 28); Detail's 'I feel her' reports its real source (Today · Mandala · Field · Room · Silence · Well · Play), not always .mandala. | G7-0028, G7-0136, G2-0206 · 19-code-mandala-today.md:91; 19-code-mandala-today.md:775; 19-code-mandala-today.md:453 | WRONG (LivingMandalaView.swift:516; RecognitionMomentView.swift:499-501) | FIX |
| HP-28 | Ways into Her Presence | Today: her name, 'know her ›', the full-screen veil name on ether days ('The whole screen is the door to Her Presence'); Mandala: 'enter her presence' on the significance card (clipped text there must show whole, ruling 17) or a second tap on the focused seat; Field row; Lalitā source 'enter her presence' (kp 102); the gift; Where She Speaks chips; Leela's arrival at 33 hands to Recognition of kp 102; the library's 'her presence'; menu and search. | G1-0484, G1-0510, G1-0586, G2-0163, G7-0161, G7-0162, G7-0169, G7-0181, G7-0095, G7-0306 · 02-rite-axis-field.md:655; 02-rite-axis-field.md:837-845; 02-rite-axis-field.md:1559-1565 | BUILT as covers | RE-ROUTE through the point |

## 3 · Parity ledger

Also written as `waves/upgrade/ledger/her-home-and-presence.csv` (126 rows, same columns). Reference frames: F-numbers where Design's frame set has one (F01–F40); otherwise the Design prototype is named (Concept Board V3 frames, 01-homes:731–741; The Rite of Entering, 02:156–305; 02 L-13 Living Rite Detail). These are 2D and must be captured from the prototype with readPixels, not as WebGL screenshots (F07 is black).

| id | world | element | source | numbers_to_match | reference_frame | status_today | code_today | build_action | verify_by |
|---|---|---|---|---|---|---|---|---|---|
| HH-01a | her-home | Tap on a Śakti opens her room through the rite | HH-01; G6-1062 | every route in §5 lands in HerRoomPassage; Detail reachable only as Presence/library | — | wrong | ShaktiDetailView.swift:65-123; LivingMandalaView.swift:566-571 | move routes | ui-walk-step; unit-test |
| HH-01b | her-home | Detail sections all reachable (nothing deleted) | HH-01; G7-0649 | every ShaktiDetailView section present in library or Presence | — | partial | TheLibraryFoldUITests | reshape | ui-walk-step; unit-test |
| HH-03a | her-home | Fly-in from Mandala seat | HH-03; G7-0018 | scale 3.0 at h·.36, easeOut .72 s; log camera radii [1.38…0.06], R=min(W,H)·.335 | F04 F05 F13 F40 | built | LivingMandalaView.swift:554-613 | reuse | measure-timing; screenshot-vs-frame F13 |
| HH-03b | her-home | The point becomes her room (no cut) | HH-03; G1-0084 | chamber scale .02+.98·swallow; presences vanish past .7; bands past .96; no fullScreenCover cut | F13 | partial | TheBuilding.swift:287-307; WorldClimbView.swift:247-260 | new continuous crossing | ui-walk-step; measure-timing |
| HH-03c | her-home | Pulse Gate into the room | HH-03; G5-0675 | breath 3 s; hold 2.5 s; haptic 80 ms; ×40 scale | — | not-built | — | new | measure-timing; ui-walk-step |
| HH-04a | her-home | Beat 1 inscription | HH-04 | 23 px cream .04em; op clamp(bp/.34)·.94; fallback chain | Rite of Entering.html (02:206) | built | RiteOfEntering.swift:98-428 | reuse | unit-test; screenshot-vs-frame F40 |
| HH-04b | her-home | Beat 2 unseen hand | HH-04 | 38 px; 3 strokes; seg=min(2.999,bp·3); 72 % stroke; +7 % mask | Rite of Entering.html | built | RiteOfEntering.swift | reuse | unit-test; measure-timing |
| HH-04c | her-home | Beat 3 roots part and rejoin | HH-04 | 25 px; split /.58; join (bp−.52)/.48; gap ·30 px; gloss 16.5 px ×.6 from .6 | Rite of Entering.html | built | RiteOfEntering.swift | reuse | unit-test |
| HH-04d | her-home | Beat timing and compression | HH-04 | 2.4 s (3.4 RM) × max(.36,.68^min(v,4)) → 1/.68/.4624/.36 | — | built | HomeMemory.swift:82-131 | reuse | unit-test |
| HH-04e | her-home | Minimum dwell per beat | HH-04; G1-0411 | touch ignored until bp ≥ .99 | — | wrong | RiteOfEntering.swift | fix | unit-test; ui-walk-step |
| HH-04f | her-home | Struck tone per beat | HH-04; G1-0282 | carrier×[1,1.5,2]; 0→.05 in 20 ms; .0001 by 3.4 s; stop 3.6 s | — | built | HomeCarrier.strikeFrequency | reuse | measure-sound |
| HH-04g | her-home | Beat marks restored | HH-04; G6-1014 | 3 dots bottom 88; 4×4; current 16 wide gold; done .6; pending .25; 500 ms | Rite of Entering.html (02:210) | not-built | RiteOfEnteringView.swift:60-63 (refused) | restore | screenshot-vs-frame F40; unit-test |
| HH-04h | her-home | Prompts | HH-04; G7-0315 | 'touch to go on' / 'touch to enter'; mono 9 px .3em op .44 at bp ≥ .99 | — | built | RiteOfEntering.swift | reuse | unit-test |
| HH-05a | her-home | Body cue beat 0 | HH-05 | one verbatim cue by body region; 5.5 s | — | not-built | — | new (on his yes) | his-walk |
| HH-06a | her-home | Per-Śakti adaptation clock | HH-06; G6-1043 | adapt 62·mul (44.6/62/85.6/69.4 s); hold 165; second 120; flip b > .45 | — | partial | HomeMemory.swift:82; RoomView.swift:61-135 | change constants to f(kp) | unit-test; measure-timing |
| HH-06b | her-home | Rate per Śakti by physics rule | §7 C1; App. A | fast/even/slow/late table for all 102 | — | not-built | — | new table | unit-test |
| HH-07a | her-home | Resolution by kp | HH-07 | authored {1,2,3,4,6,27,28,102}; counts [28,16,8,14,10,10,12,3,1]; nobody at seat | — | built | HomeRooms.swift:201-269 | reuse | unit-test |
| HH-08a | her-home | Mechanism layer may hold light | HH-08 | her layer accepts emissive solids/lines/shaders; inscription kept | — | wrong | RoomMaterial.swift:17-23; RoomScene.swift:827-833 | rewrite | unit-test; measure-light |
| HH-09a | her-home | Aṇimā CONTRACT | HH-09 | walls to 34 %; aperture ×12 at b; key 900/k²; beyond z −18→−5 | Concept Board V3 · Aṇimā (01:734) | wrong | ContractRoom.swift | rewrite | screenshot-vs-frame Concept·Aṇimā; measure-light |
| HH-10a | her-home | Mahimā ENDLESS | HH-10 | 24 frames r 6+.52i; SPAN 120; 3.4 u/s; 10 behind at b | Concept Board V3 · Mahimā (01:735) | wrong | EndlessRoom.swift | rewrite | screenshot-vs-frame Concept·Mahimā; measure-timing |
| HH-11a | her-home | Laghimā RELEASE | HH-11 | cloth hems; 340 rising pts size 1–9; seat y −3.4+4.2lift; walls rise at b | Concept Board V3 · Laghimā (01:736) | wrong | ReleaseRoom.swift | rewrite | screenshot-vs-frame Concept·Laghimā; measure-light |
| HH-12a | her-home | Garimā PRESS | HH-12 | slab y 11−7.4k(+5.2b); displacement .5+1.9k(+1.4b); palm #B8263C emissive 1.4+3.4b; fog .03+.028k | Concept Board V3 · Garimā (01:737) | wrong | PressRoom.swift; GarimaSceneKitRoom.swift | rewrite from spike | screenshot-vs-frame Concept·Garimā; measure-light |
| HH-12b | her-home | The Gate: Laghimā vs Garimā | HH-91; G7-0710 | divergence > .5; Design 100 % geometry, 116 luminance | Concept Board V3 · Laghimā/Garimā | built | GateRoomTests.swift; GateLookTests.swift:53 | keep, re-baseline lit | unit-test; measure-light |
| HH-13a | her-home | Leaving Garimā costs effort | HH-13 | hold 3.3 s; slab lifts .6; drain 750 ms | — | not-built | — | new | measure-timing; his-walk |
| HH-14a | her-home | Vaśitva KNOWN | HH-14 | SpotLight 2400 angle .4 penumbra .88; Lissajous wander; converge at b angle .4−.17b ×(1+.7b) | Concept Board V3 · Vaśitva (01:741) | wrong | KnownRoom.swift | rewrite | screenshot-vs-frame Concept·Vaśitva; measure-light |
| HH-15a | her-home | Sarva-Yoni MEMBRANE | HH-15 | transmission .94 ior 1.38; 8 veins; backlights 540/420/420/320/250; breath .28 rad/s | Concept Board V3 · Sarva-Yoni (01:738) | wrong | MembraneRoom.swift | rewrite | screenshot-vs-frame Concept·Sarva-Yoni; measure-light |
| HH-16a | her-home | Sarva-Trikhaṇḍā TRIPLE | HH-16 | 3 render targets; RGB composite; sep curve; converge to white | Concept Board V3 · Trikhaṇḍā (01:739); Rooms in 3D 86\|81 → 81\|81 | wrong | TripleRoom.swift | rewrite (Metal) | screenshot-vs-frame Concept·Trikhaṇḍā; measure-light |
| HH-17a | her-home | Mahātripurasundarī DISSOLVE | HH-17 | gold line yantra op .46; scale (.94+.07br)(1+2.1b); z 7.4b; bindu z −8.4→0 | Concept Board V3 · Mahātripurasundarī (01:740) | wrong | DissolveRoom.swift:200-204 | rewrite by hand, last | screenshot-vs-frame Concept·Mahātripurasundarī; his-walk |
| HH-18a | her-home | R1 Siddhi lent | HH-18 | octahedron r 1.5 ×2.4; 6 echoes delay .6+.5i; object to 20 % at b | — | partial | SiddhiRoom.swift | upgrade | unit-test; measure-light |
| HH-19a | her-home | R1 Mātṛkā letters | HH-19 | n 5/8/11/14; turn .22; sin^8·5; stretch ×(1+3.4b); floor disc r 13 | — | partial | MatrkaRoom.swift | upgrade | unit-test; measure-light |
| HH-20a | her-home | R1 Mudrā seal | HH-20 | 5 digits on 11-pt arc; open .42b(1+.1i); held ×(1+3.6b); deep 'the seal has opened its hand' | — | partial | MudraRoom.swift; HomeGrammar.swift:686-694 | upgrade; restore line | unit-test |
| HH-21a | her-home | R2 crossed | HH-21 | 7 tori vs 7 sprites; lag 3.2 s; +.5 phase; converge at b; kp 44 key pairing | F01 (ring 2 petals) | partial | CrossingRoom.swift | upgrade | unit-test; measure-light |
| HH-22a | her-home | R3 bodiless | HH-22 | 8 sprites r 5.4; rim r 1.5; key 2200 at empty centre | F19 F21 | partial | BodilessRoom.swift | upgrade | unit-test; measure-light |
| HH-23a | her-home | R4 cosmic | HH-23 | 14 loops r 3.4+2.1i; delay .42 s/shell; amp 1+.22i; shell r 26 | — | partial | CosmicRoom.swift | upgrade | unit-test |
| HH-24a | her-home | R5 giving | HH-24 | 12 gifts r 16→1.4; u .055 (≈18 s); cup ×(1+4.2b) | — | partial | GivingRoom.swift | upgrade | unit-test; measure-timing |
| HH-25a | her-home | R6 revealing | HH-25 | 10 icosahedra ×3.2 r 6; lit veil r 9.4 op .72−.46a−.26b | — | partial | RevealingRoom.swift | upgrade | unit-test; measure-light |
| HH-26a | her-home | R7 sounding + Weapons strike | HH-26 | n = 2+(kp mod 8); amp .5+1.6b; nodes r 8.4; strike per tempo breath 95–98 | F26 | partial | SoundingRoom.swift | upgrade; new strike | unit-test; measure-sound |
| HH-27a | her-home | R8 sourcing | HH-27 | triangle R 4.6; hers 6.4 + 900; others 2.4 .2 + 90 → .2+.7b, 90+700b | F02 F27 | partial | SourcingRoom.swift | upgrade | screenshot-vs-frame F27; unit-test |
| HH-28a | her-home | Seat floor extruded shell | HH-28 | seatShell r 6 d 26 z −.62d; chamberSeat r 6.4 d 28; key 700+1500a | — | partial | RoomShell.swift:46-188 | upgrade | unit-test |
| HH-29a | her-home | Grammar four channels | HH-29 | 53 rules in order; 0 fall to breathe; 18 altitude zones; phase divisors 10/8/16/8/14/10/10 | — | built | HomeGrammar.swift:135-436 | reuse | unit-test |
| HH-30a | her-home | Every room reverses | HH-30 | answer ≠ premise for all 102; deep words verbatim | — | built | HomeBecoming.swift:122-209 | reuse | unit-test |
| HH-31a | her-home | Attribute drawn lit, tinted | HH-31 | 26 forms, 52 keys, KIN, 15 tints; mount (.5−alt)·6.4−.4 z −4.6; scale .9→3.5; opacity ×(1−.55b) once | — | partial | HomeAttribute.swift:177-722; RoomMaterial.swift:470-536 | upgrade render | unit-test; measure-light |
| HH-31b | her-home | Attribute periods | HH-31 | noose 11.1 · goad 7.7 · cup 18.2 · arrows 6.25/1.25 · bow 13.3 · rosary 1.67 · vajra 9.09 · skullcup 20.8 · plough 14.3 · garland 30 · chain 16.7 · line 7.1 s | — | built | HomeAttribute.swift | reuse | measure-timing |
| HH-32a | her-home | World air per ring | HH-32 | counts W1–W9 (90 motes … 9 lamps + 220) | F15–F33 (ring worlds) | built | RoomAir.swift:268-710 | reuse | unit-test |
| HH-32b | her-home | Gem diffusion and sourceless crown | HH-32 | topaz .20 … pearl .95 cat's-eye .10 R9 .70; R7 no key | — | built | RoomLightRig.swift:104-124 | reuse | unit-test |
| HH-33a | her-home | Room luminance at Design's band | HH-33 | 80–255 at both adaptations; hi > 90/255; range > 70; near-half ratio < 3.5; < 25 % px > .96 | Concept Board V3 (all nine) | wrong | RoomCaptureTests (.01–.9) | raise light; rewrite bounds | measure-light |
| HH-33b | her-home | Colour through staying in the room | HH-33 | grey saturate .32 brightness .70 → full with a | — | not-built | — | new | measure-light |
| HH-34a | her-home | Bīja-locked rhythm | HH-34 | period = carrier/32 folded to 4–12 s | — | not-built | — | new | unit-test; measure-timing |
| HH-35a | her-home | Tattva modifies key and grain | HH-35 | fire +18° .3 · water −12° .2 · earth grain +.04 · air motes ×1.2 · ether fog ×.85 · light bloom +.15 | — | not-built | HomeGrammar.swift:299-307 | new | unit-test; measure-light |
| HH-36a | her-home | Room words | HH-36 | place 11 · name 28 · quality 15 · sentence 18.5; 2 Hz; recede .25 while dragging; form + verb 6 s | — | partial | HomeWords.swift; RoomWordsView.swift | reuse + new recede | unit-test; ui-walk-step |
| HH-37a | her-home | Portrait lines by stillness | HH-37 | 4+6.5n s once a ≥ .4; ratchet; 19 px; 2600 ms; halo .82; none truncated | Rite of Entering.html (02:227) | not-built | — | new | measure-timing; unit-test; his-walk |
| HH-38a | her-home | Personal Connection on her walls | HH-38 | after portrait; italic 15 px .62; 6.5 s cadence; not kp 102 | — | not-built | — | new | ui-walk-step; unit-test |
| HH-39a | her-home | Well letter folded object | HH-39 | 36×14→27 px 820 ms; right 22 bottom 150 op .85; only if exists | Rite of Entering.html (02:228) | not-built | — | new | unit-test (never fabricated); ui-walk-step |
| HH-40a | her-home | Doors by family/cluster | HH-40 | neighbourOf per App. A; kp 37 → 36/38; kp 102 none; sister door | — | partial | TheBuilding.swift:35-51 | change | unit-test |
| HH-40b | her-home | Crossing to a neighbour without a cut | HH-40 | rite reruns from where he stands; no .7 s opacity swap | — | partial | HerRoomDoor.swift:84-98 | new | ui-walk-step; measure-timing |
| HH-41a | her-home | Activation cycle gestures | HH-41 | fire 3.0 s/.45 · water 180 pt <240 pt/s · air 10 s 4/6 · earth 3.5 s · ether 8 s · light ±.22/2.4 s · presence 6 s; recede ×1/.6/0 | — | built | ActivationCycle.swift:66-130 | reuse | unit-test; his-walk |
| HH-43a | her-home | I feel her in the room | HH-43 | G39 300/1100/2600/4300/5400; collapse 620; room ×(1+.8k); Shweta 2 s .10; lines verbatim; ledger first | F14 | not-built | — | new (RecognitionNature reuse) | measure-timing; unit-test; screenshot-vs-frame F14 |
| HH-44a | her-home | Family question and gloss | HH-44 | 52 glosses kp 1–52 verbatim; family lights 1–10/11–18/19–28/29–44/45–52 | — | not-built | — | new; bake Shakti Function | unit-test; ui-walk-step |
| HH-45a | her-home | Heart Register in every ring | HH-45 | Sa C–F; drone .5/1/1.5/2 gains .55/.7/.45/.25; answer one breath | — | partial | HeartRegister.swift | extend | measure-sound |
| HH-46a | her-home | Mudrā close three breaths | HH-46 | words-only hand instruction; 3 × 5.5 s; ring 7 Khecharī | — | not-built | — | new | his-walk |
| HH-47a | her-home | Gift lands in her Home | HH-47 | ≤1/day; window 10–20 h; lands through compressed rite | — | partial | EnergyGift.swift:19-201 | re-route | ui-walk-step |
| HH-49a | her-home | Head start and caps | HH-49 | 0 < 12 s; dwell·.55 capped holdEnd(kp)−6; dwellCap 4000 | — | built | HomeMemory.swift:82-131 | reuse; cap by kp | unit-test |
| HH-49b | her-home | HomeMemory restored from ledger | HH-49 | empty store → accumulatedDwell from Silence Held/First Dwelling Duration | — | not-built | — | new | unit-test |
| HH-50a | her-home | 'you have stood here before' once per return | HH-50 | first 14 s after head start; never first visit; no number | — | not-built | RiteOfEnteringView.swift:65 (removed) | new | ui-walk-step; unit-test |
| HH-50b | her-home | Floor traces as light | HH-50 | ≤ 7; size 1.1; op .16; y −4.1; seed (kp,n) | — | not-built | — | new | measure-light; unit-test |
| HH-50c | her-home | Climb lights stay alike | HH-50; ruling 15 | no met-core on the Climb | — | built | TheBuilding.swift:139-166 | keep | unit-test |
| HH-52a | her-home | Hand ring settles true | HH-52 | 4 s settle; tone 1.5 % flat → in tune; gain .036@3.2 s .020@6 s 0@9 s | — | not-built | — | new | measure-sound; measure-timing |
| HH-55a | her-home | Silence Held / First Dwelling by kp | HH-55 | Silence at adaptEnd(kp) once/visit; First Dwelling at holdEnd(kp) once ever | — | built (62/227) | HomeDwelling.swift:79-225 | marks by kp | unit-test |
| HH-57a | her-home | Shaft with Design's solids | HH-57 | 46 rungs r 5.4·.985^i; STATION_Z −16…−88; torus knot, 13 bars hers lit, roots 14 s, icosahedron, 3 tori | — | partial | HomeDescent.swift:21-43; DescentShaft.swift | restore solids | unit-test; measure-light |
| HH-58a | her-home | Go deeper always offered | HH-58 | no 62 s gate | — | wrong | HomeDescentTests:327-339 | lift | unit-test |
| HH-59a | her-home | Library sheet | HH-59 | 520/620 ms; radius 24; rows verbatim; empty omitted; foot links | Rite of Entering.html (02:271-277) | not-built | — | new | ui-walk-step; unit-test |
| HH-60a | her-home | Light Room geometry | HH-60 | 402×874; R 330; kFar .28; kNear 2.55; VP alt·874; riteApertureSpan | Rite of Entering.html (02:156-196) | not-built | — | new | screenshot-vs-frame Rite·Seat; unit-test |
| HH-60b | her-home | Light field adapts | HH-60 | farL 20+62a; blur 2.2+5(1−a), far 3+16(1−a); motes after a > .2 | Rite of Entering.html | not-built | — | new | measure-light |
| HH-61a | her-home | Aperture faces | HH-61 | 7 faces; L = lum(.34+.66a); s = r·.66; face by key (App. A) | Rite of Entering.html (02:173-180) | not-built | — | new | screenshot-vs-frame Rite·Faces; unit-test |
| HH-62a | her-home | Yantra beyond at b | HH-62 | scale .34+.5b; op .1+.72b; face ×(1−.7b) | Rite of Entering.html (02:184) | not-built | — | new | measure-light; screenshot-vs-frame Rite·Second |
| HH-63a | her-home | Light Room threshold | HH-63 | 24/36/15/26/16.5 px; bars bottom 92; {2.4,3.2,2.8}×.66 compression | Rite of Entering.html (02:199-216) | not-built | — | new | measure-timing; screenshot-vs-frame Rite·Threshold |
| HH-64a | her-home | Light Room overlay | HH-64 | name 30 px .62; go deeper at a ≈ .28; overlay 1800 ms | Rite of Entering.html (02:219-235) | not-built | — | new | screenshot-vs-frame Rite·Dwelling |
| HH-65a | her-home | Fall through five chambers | HH-65 | dz .055; scale 2.5^(−rel); 5 chambers; floor of her | Rite of Entering.html (02:238-273) | not-built | — | new | ui-walk-step; measure-timing |
| HH-66a | her-home | Light Room clock | HH-66 | 90·mul/165/120; RM 160/190/150; smoothstep² | — | not-built | — | new | unit-test |
| HH-67a | her-home | Her Dance door and return | HH-67 | long-press 1.3 s; Mandala long hold; returns to the exact room moment | — | not-built | — | new | ui-walk-step |
| HH-68a | her-home | Songless score | HH-68 | P from Score ‖ 5.5 s; 180 s phases; PEAK_T 100; no Hz stored per Śakti | — | not-built | — | new | unit-test; measure-timing |
| HH-69a | her-home | Ensemble numbers | HH-69 | entry .12/.22/.32/.45/.65; lerp .04/.015; Sid .012; Sakshi .003; Arch delay .7 s | — | not-built | — | new | unit-test; his-walk |
| HH-70a | her-home | Bloom stages | HH-70 | rise .06 fall .012; thresholds .15/.3/.5/.7 | — | not-built | — | new | unit-test |
| HH-73a | her-home | Binaural and inverse gain | HH-73 | L carrier, R carrier+beat; 7.83 at peak 3 s; amp .045+.015 sin .18t+.025(1−E) | — | not-built | — | new | measure-sound |
| HH-74a | her-home | Mirror washes | HH-74 | α 40–70 %; rise 1–2 s; fade 2–4 s; boost 3–5 s | — | not-built | — | new | measure-light; measure-timing |
| HH-79a | her-home | No figure in the dance | HH-79 | no figural geometry in any dance layer | — | n/a | — | floor | unit-test |
| HH-80a | her-home | Way out | HH-80 | hold 2.2 s (Garimā 3.3); edge 22/72 pt; RM one touch; filed once | — | built | TheWayOut.swift:49-56; TheEdgeWayOut.swift; TheStay.swift | reuse | ui-walk-step; measure-timing |
| HH-81a | her-home | After-effect felt never named | HH-81 | 180 s; e=(1−age/180)²; kinds per ring; filters per kind; no line | — | partial | HomeAfterEffect.swift:101-104; HerSiddhiLingers.swift; HomesWaveOneTests.swift:272 | delete line; app-wide modifier | unit-test (no text); measure-light |
| HH-82a | her-home | Back to where he was | HH-82 | exact prior place and zoom; no didSettle jump from a room | — | partial | RootView | change | ui-walk-step |
| HH-83a | her-home | Room sound table | HH-83 | roots [55…123.47]; JUST 12; carrier = root·JUST[idx%12]·2 (Am 110, ka 137.5); techniques per ring | — | built | HomeSoundService.swift:79-1176 | reuse | measure-sound; unit-test |
| HH-83b | her-home | Sound control returns | HH-83; ruling 10 | one sound control in room; silent switch honoured | — | wrong | HomeVoice.swift:50-52 | lift | ui-walk-step |
| HH-84a | her-home | Bīja tap at her carrier | HH-84 | no FNV pentatonic hash | — | wrong | BijaSoundService.swift:108-159 | change | measure-sound |
| HH-85a | her-home | Reduce Motion slowed | HH-85 | a 4 steps b 3; adapt ×160/90; hold 190; second 150; 15 fps .5× | — | wrong | RoomView.swift:29-54 | rewrite | unit-test; ui-walk-step |
| HH-86a | her-home | Accessibility in rooms | HH-86 | AX3XL no cut; ≥ 43.5 pt; ≥ 11 pt ≥ .3 α; names spoken without numerals | — | partial | AccessibilityReachTests | extend | ui-walk-step |
| HH-88a | her-home | Ruling 4 elements | HH-88 | 31 fire · 40 air · 42 light · 43 water; .light in parse | — | wrong | Element.swift:28-36 | fix | unit-test |
| HH-89a | her-home | Bīja series + names by kp | HH-89 | 16 vowels a…aḥ; names from row by kp | — | wrong | ShaktiBootstrap.swift:151-267 | fix | unit-test |
| HH-90a | her-home | Passage fetch | HH-90 | one predicate fetch per entry | — | wrong | HerRoomDoor.swift:120-139 | fix | unit-test |
| HH-91a | her-home | Harness port | HH-91 | 66 checks; fingerprints 5×5 at 7 times·rate; divergence > .1; verify the verifier | — | partial | HomesHarnessTests.swift | extend | unit-test |
| HH-97a | her-home | One hold engine | HH-97 | commit/act on release; drain 620–750; haptic .15→.6; keyboard parity; ladder | — | partial | various | new shared engine | unit-test; measure-timing |
| HH-98a | her-home | Stillness kept | HH-98 | 4.6 s → yantra arrives op .12; kept per kp | — | not-built | — | new | unit-test |
| HP-01a | her-presence | Her Presence as its own world | HP-01 | order hero → portrait → somatic → bīja → appreciation → embodiment → moments → deeper → doorways/witness → Still Point → footer | 02 L-13 (Living Rite Detail) | partial | ShaktiDetailView.swift | reshape | screenshot-vs-frame L-13; ui-walk-step |
| HP-02a | her-presence | Arrival staging | HP-02 | dark 0–22 % then 1.8 s; .4/2.2/3.4/5.6 s; words at 200 ms after 4 s ring | — | not-built | — | new | measure-timing |
| HP-03a | her-presence | Identity disc, no figure | HP-03 | 96 px; glyph; bīja 320 px .065; .1 Hz hold 1→1.06; back face; pinch 1–4× | — | not-built | — | new | unit-test (no figure); his-walk |
| HP-04a | her-presence | Form line | HP-04 | '{Ordinal} Āvaraṇa · {form}' 11.5 px .3em; name lrNameSize 50 | 02 L-13 (02:692) | partial | ShaktiDetailView.swift:379-385 | change | screenshot-vs-frame L-13 |
| HP-05a | her-presence | Portrait by stillness | HP-05 | 4+6.5n s ratchet; italic 20 lh 1.6 gold; rise 14 px blur 6→0 3.2 s; none truncated | — | partial | ShaktiDetailView (static codex portrait) | new mechanism | measure-timing; unit-test; his-walk |
| HP-06a | her-presence | Ring's Personal Connection | HP-06 | sentence by sentence; fallback portrait | — | not-built | — | new | unit-test |
| HP-07a | her-presence | The Turning | HP-07 | UP 2900 DOWN 750; saturate .32+.68l; brightness .70+.30l; words past .55 | — | not-built | — | new | measure-light; measure-timing |
| HP-08a | her-presence | Where she is felt | HP-08 | 12 regions; her location lit; doorway incl. light | — | partial | SomaticRegion.swift; WhereSheSpeaksView | move; add light | unit-test |
| HP-09a | her-presence | Bīja tap | HP-09 | 84 px; 3.6 s; pulse 1.4 s; 3 rings 90 px delays 0/.5/1 | 02 L-13 (02:701) | built | ShaktiDetailView.swift | reuse; retune | measure-sound; measure-timing |
| HP-11a | her-presence | go deeper rows | HP-11 | Tattva · Bodily seat · Her ring · Form · Mental state · Chakra · Iconography · Function · Etymology · family | 02 L-13 (02:706-719) | partial | ShaktiDetailView.swift | change rows | unit-test |
| HP-12a | her-presence | Embodiment crossing chosen | HP-12 | hold 750 ms; vibrate 12; readiness only breathes 2.2 s; no seeded status | — | wrong | ShaktiDetailView.swift:521-532; ShaktiBootstrap | change | unit-test; his-walk |
| HP-13a | her-presence | Her moments | HP-13 | 'she was felt here · {when}' + moon phase + note; empty line | 02 L-13 (02:937) | built | ShaktiDetailView.swift:761-815 | reuse | unit-test |
| HP-14a | her-presence | Deepening offered freely | HP-14 | all six layers open | — | wrong | HerDeepeningSection.swift:52-56 | lift gate | unit-test |
| HP-15a | her-presence | Doorways re-grounded | HP-15 | seal 2.4 s; noticed once a day; copy cites C-1337 | — | built | WagerStore.swift:77-109 | re-ground copy | unit-test |
| HP-16a | her-presence | Witness Page | HP-16 | 1.8 s hold; kept every save; reseals | — | built | HerWitnessPage.swift | reuse | ui-walk-step |
| HP-17a | her-presence | Still Point | HP-17 | 7 holds × 1.3 s; text shortens, type grows | — | not-built | — | new | ui-walk-step |
| HP-18a | her-presence | Recognition timeline | HP-18 | .3/1.1/2.6/4.3/5.4; collapse .62; after-glow 1.8 s; record first | F14 | built | RecognitionMomentView.swift:270,288 | reuse | measure-timing; unit-test; screenshot-vs-frame F14 |
| HP-18b | her-presence | Six natures | HP-18 | LR_RECOG rows fy/focal/resp/ripple/n/motes exact | — | built | RecognitionNature.swift | reuse | unit-test |
| HP-18c | her-presence | Recognition lines verbatim | HP-18 | 'she was felt here' / 'and she felt you back' | F14 | built | LawsTests.swift:728-769,1453,1483,1540 | keep unchanged | unit-test |
| HP-19a | her-presence | Settle to Memory from everywhere | HP-19 | 3400 ms; fly 0–.34; halo .34–1 r 6→36 | — | partial | RootView.swift:105-106 | extend | measure-timing; ui-walk-step |
| HP-20a | her-presence | Field Connection | HP-20 | only kp 31/40/42 | — | built | ShaktiBootstrap.swift | reuse | unit-test |
| HP-21a | her-presence | Element composition and hour relight | HP-21 | six plans; mood bits; dawn/noon/dusk/night table; backdrop breaths 11/13/12/9.6/15/7.6 s | — | partial | AtmosphereBackground.swift:51-61 | extend | measure-light |
| HP-23a | her-presence | Silent voice card | HP-23 | '·' 40 px; never invent | — | not-built | — | new | unit-test |
| HP-24a | her-presence | Footer and position | HP-24 | 'I feel her' h60 r30 23 px; '{kp} · 102'; play door for all 102 | 02 L-13 (02:672) | built | ShaktiDetailView.swift:180-252 | reuse; change glyph | unit-test |
| HP-27a | her-presence | Presence data defects | HP-27 | kp 102 by key; kp from row; real source | — | wrong | LivingMandalaView.swift:516; RecognitionMomentView.swift:499-501 | fix | unit-test |
| HP-28a | her-presence | Ways into Her Presence | HP-28 | every door in §5 reaches her Presence through the point | — | built (covers) | RootView; DailyRiteView | re-route | ui-walk-step |

## 4 · Data contract

**Airtable, ASG base `app248ZTWhYJlvQj2`.** No new fields (ruling 11). The identity of every read and write is kp.

- **Mandala table `tblrRwXJD0uP8HU8G`.** Row type `fldw33m8YqrINlvrN` (Shakti / Avaraṇa / Nityā).

  Shakti rows, read:

  | Field | Id | Used by |
  |---|---|---|
  | sanskritName | `fldJOatnYrw9l6tff` | the name shown, by kp, never the card name |
  | devanagari | `fldDhcJ1BJQCM5llO` | beat 2 and the name cut into the wall |
  | quality | `fldnwcu7zv7uV1ta2` | soul, words, gloss |
  | qualityDescription | `fldTwrtI5CyUnJV2F` | — |
  | clusterGroup | `fld1HO6HwMH8fSwS3` | ring 2 doors |
  | esotericTattva | `fldxylgY985SwqdJE` | physics, light modifier |
  | somaticSignature | `fld6CylZqbIZQIUOp` | portrait lines, somaticPoetry |
  | bodilyLocation | `fld6P1u43B0eqKU5e` | altitude, body of light |
  | bija | `fldnOqkWcvjQNxpWl` | carrier index |
  | fieldConnection | `fldsk2ATEtTVB87eb` | — |
  | status | `fldDiihcxC54WKPhT` | embodiment; advance-only PATCH, as built |
  | khadgamalaPosition | `fldI0aV1sfOeNybHI` | identity |
  | iconography | `fldXJEBCQxLdHWGuP` | attribute key, portrait lines |
  | codexPortrait | `fldlcmg7wtfIxgcZu` | portrait lines |
  | etymology | `fldXypzqrhVILCqgh` | beat 3 and the root station |
  | appreciationPhrase | `fldBqEDpBonMc2s1K` | beat 1, the dance seed, the seal |
  | function | `fldzT3dAhsAK75rKN` | portrait, function chamber, Still Point |
  | family | `fldYAlclWH7CfJhOg` | — |
  | letter | `fldgASyV031Hr4sHp` | the folded object, read only |
  | Score JSON | `fldz1vCCMpXiw8s1n` | light hue/glow, tempo breath, carrier, fifth mode |
  | phonetic | `fldadDCi4OJYEaAFX` | — |
  | seedVerb | `fldVgkRZmbc7STB7S` | play door, library |
  | related / relatedFrom | `fldQNnFoom72Nr6vh` / `fldtAau1NIP4QDZrk` | the sister door |

  Avaraṇa rows, read:

  | Field | Id | Used by |
  |---|---|---|
  | gem | `fldWlbdPNpmqPvfMj` | — |
  | dhātu | `fldVjcApdGFVrIfq1` | — |
  | timeCycle | `fldZLBoLGegod2xfy` | — |
  | beeja | `fldixnYtJ30lZEDJM` | — |
  | bodyRegion | `fld6Ucmi8YqeAbOXU` | — |
  | siddhi | `fldx9jXyTVWxp19o1` | — |
  | mudra | `fld1C14f4MsVIrA9F` | mudrā close |
  | phase | `fldKWGAI16XjdqoI3` | — |
  | notes | `fld1HR38cQAtEicFc` | — |
  | subtitle | `fldXTUBJTDlkKEzEV` | — |
  | presidingForm | `fldgHVP1LqoVJsYu8` | form line, arrival |
  | mentalState | `fld8p7FtKqEKvSy7P` | tempo, library |
  | subtleBodyChakra | `fld6deGFzModjBmoj` | chakra door, dance language |
  | geometricShape | `fldNqYFRn8x4F9jR0` | — |
  | personalConnection | `fldlcmg7wtfIxgcZu` | his voice on her walls and in her Presence |
  | yogini | `fldcqAvdN3wcP8BhT` | veil |

  Avaraṇa record ids are `rec0XhDKfxW8UVyaB … recqdC3D38TWFkf1M` (rings 1–9).
- **The Map `tblwpmyKOeMxEEHd7`.** Shakti Function `fld5sWbzoT3lySYgI` is to be **baked** into `Data/ChakraConstellation.json` (the field is absent there today). It feeds the 52 family glosses for kp 1–52 and the ring facts card (presiding form, Yoginī, mental state, the goddess's body region). The Shakti Mudra (already in the bundle, unshown) feeds the mudrā close. Chakra 32's content stays sealed: only its field names are used.
- **App Activity `tblJlBeiHnqGpYrL7`.** It is the single ledger. Source App is "Mandala".

  | Field | Id |
  |---|---|
  | Activity Name | `fldqAZ3xmkQwHaJQm` |
  | Activity Type | `fldXNRBZy6QvIP8yz` |
  | Activity Date | `fldMcikl2kbVRFv4G` |
  | Detail | `fldFWURRpDmzcSAvl` |
  | Notes | `fldVyj4hkzxcrIBoJ` (his words only) |
  | Link to Mandala | `fldzsEMInQmNIxTNu` |
  | Felt At | `fldWAR0B4pNxjTwEJ` |
  | Lunar Day | `fldJc7iCzxZOSdO4D` |
  | Moon Phase | `fldMpjvAsT64v85bh` |
  | Gesture Source | `fldP3wq8QTgxeTDuC` |
  | Duration (sec) | `fldrIOx1id7Esm2fd` |

  Types these worlds write:

  | Type | When | Gesture Source / Detail |
  |---|---|---|
  | **Shakti Recognized** | "I feel her", in the room or the Presence; written before any light moves | Room · Today · Mandala · Field · Play · Well |
  | **Silence Held** | once per visit at adaptEnd(kp), with Duration | — |
  | **First Dwelling** | once ever at holdEnd(kp) | — |
  | **Full Circle** | — | — |
  | Mauna | at kp 102 | — |
  | **Light Entered** | activation cycle close | — |
  | **Played** | Her Dance | Detail "Her Dance · {name}" |
  | **Witness Written** | the Witness Page | — |
  | **Wager Resolved** | noticed in passing | "noticed in passing" |

  Nothing about the stay is shown. Restoring the dwell from Silence Held and First Dwelling Duration rows on an empty local store is new (HH-49).
- **Learning table records** L-1537 (102 Śaktis research) and L-1533 (16 Karṣiṇīs). These are a read-only library row, behind Q4.
- **Walks · Threshold Invitations** (16-airtable-asg:190) is the body cue, behind Q2.

**Bundled assets.**

- Design's per-kp tables already in Swift, ported in `HomeAttribute.swift` (ATTRIBUTE, KIN, 15 tints) and `HomeGrammar.swift` (50 + 3 regexes, zones, letter counts, modes, corners).
- The ring tables `RING_CHARACTER` and `WORLDS` (`HomeWorlds.swift`).
- Appendix A of this file. Its rates, apertures and doors become a bundled `HerHomeTable.json` keyed by kp.
- The Concept Board V3 frames and the Rite of Entering prototype captures (2D, so captured with `readPixels`, not WebGL screenshots: F07 is black) as test references.
- **Audio.** None from GitHub is needed here. No Śakti has a song, and Her Home and Her Presence sound only her synthesized ring voice and carrier.
  - The `tree-of-life/<chakra>.mp3` recordings (aatma, ajna, anahata, manipura, maya, maya-chakra-ending, muladhara, sahasrara, svadhisthana, vishuddha) belong to the chakra dances. They are reached through this world's chakra door, never played in her room.
  - `bindu-dances-reach.mp3` = `anahata.mp3`, and it stays in the 33.
  - No `bija_%02d` recordings and no `lalita-cross-*.mp3` exist, so no voice plays (floor).

**Local stores.**

| Store | What it holds | Status |
|---|---|---|
| `HomeMemory` (SwiftData V2, per kp) | dwell, visits, longest, last, deepest | built; never synced, now restorable |
| `ShaktiLetter` by kp | — | read only here |
| `shaktiFacts.v1` (UserDefaults) | Score, phonetic, seedVerb, related | — |
| `lr_cross_<kp>` | his chosen crossing level | — |
| `homes.mode.v1` {kp: room \| light} | last mode | new |
| `herDance/<kp>.grid` (PracticeVault JSON) | the 25×35 floor residue | new |
| `homes.stillness.v1` {kp: seconds} | kept stillness | new |
| `herDeepening.visits.v1` | — | retired with the gate |
| the after-effect | — | in memory only |

## 5 · Doors

**Into Her Home** (all of them pass the Rite of Entering, compressed on return, and travel through the point):

| From | Gesture | Notes |
|---|---|---|
| Mandala seat | "be with her ›" on the significance card; long hold on a seat → Her Dance | kp 102 offers the DissolveRoom beside the Bindu descent |
| Today / the Rite | the seat line, RiteDayDoors, the Pulse Gate hold | Today is the first door from the Bindu |
| The Climb | touch a light, then a 1.1 s flight that continues | — |
| The Field (TheHundredTwoView) | onEnterRoom | — |
| The 33 | "into <her>'s room" door; the family question (kp 1–52) | — |
| Her Presence | "be with her ›", "the whole of her home ›" | — |
| The gift notification | tap | — |
| The Well | a letter to her: "go to her room" | — |
| Neighbour and sister doors | from another room | — |
| Search, the menu (constellation of world-points), the point | — | — |
| Home's glass | holding a mudrā with two thumbs | re-opens the last room carrying it |

**Out of Her Home:**

| To | By |
|---|---|
| Exactly where he was | the way out: hold 2.2 s (Garimā 3.3), edge swipe, rope, Escape |
| A neighbour (by family or cluster, then the circle) | the doors |
| Her namesake in another ring | the sister door |
| Her chakra's room in the 33 | chakra door (subtleBodyChakra) |
| Her ring world (the nine rings) | "the {ordinal} āvaraṇa" place line |
| Her Presence | the library's "her presence" |
| The Light Room ↔ the Room | two-finger hold / "her light" |
| Her Dance | "her dance" / long-press on her attribute |
| Recognition, then Memory's settle, then back | "I feel her" |
| Her game | play door |
| The Relationship Field | Trinity face / Field Connection (kp 31, 40, 42) |
| Home (the Bindu) | the point |

**Into Her Presence:**

| From | Gesture |
|---|---|
| Today | her name, "know her ›", the veil name on ether days |
| The Mandala | "enter her presence" on the card, or a second tap on the focused seat |
| The Field | a row |
| Lalitā source | "enter her presence" (kp 102) |
| The gift | — |
| Where She Speaks | a chip |
| Memory | a Portrait petal (Design: "TAP ANY PETAL · OPEN HER BIOGRAPHY"; the Memory world builds the tap) |
| Leela's arrival at 33 | → Recognition of kp 102 |
| Her Home | the library |
| — | search, the menu |

**Out of Her Presence:**

| To | By |
|---|---|
| Her Home | "be with her ›" |
| Recognition, then the Memory settle | "I feel her" |
| Her game | the play door |
| The Relationship Field | Field Connection |
| Her ring world | the form line |
| Her chakra's room | the "Chakra" row in go deeper |
| Where he came from | "‹ back" |
| Home | the point |

**Along the threads:**

- **Position (kp):** neighbours, sister, ring.
- **Chakra (1–33):** the subtleBodyChakra door.
- **The day:** Today's presiding Śakti is crowned on her light, and her room opens from Today.

## 6 · To Bindu Feed

These are story material. Each is flagged, not dropped:

| Item | Source | What goes to the Feed | What stays here |
|---|---|---|---|
| **C-1005 the FlASH Point story** (Red Rambo, Black Rey, Blue Ash, White Ram) | G3-0331 · 07-codex:60-63 | the narrative | its principle, that dark rooms integrate and are never defeated, is HH-30 together with C-1119 |
| **C-1134 the name-meaning intake** (a person's name across existence; scarf and picnic blanket as Atma and Brahman) | G3-0381 · 07-codex:310-313 | the story | its "part and whole" energy is the back face of her disc (HP-03) |
| **The three-layer reading UI** (Lalitā → seven lenses) | G4-0623 · 10-field-data-catalog:496 | the readings | lens names and colours stay as structure only |
| **A Strange Voice**, Voice II five acts | G5-0583 · 14-aistrangegame:316-320 | the narrative | only the 72 BPM heartbeat stays (HP-22) |
| **Kali — The Dark Mother**, a Learning topic | G5-1119 · 12-padakarshini-field:1504 | the fable | the Mahāvidyā presence is Beneath's question |
| **The Black Madonna Tradition** | G5-1174 · 12-padakarshini-field:1559 | the topic | — |
| **Story-flavoured lines in the Homes code**: ClimbSummit "I am what I am becoming." / "I already did." and Praveśa's four lines | G6-1077 · 18-code-homes:153-158 | flagged for the Feed question | do not drop |

## 7 · Conflicts settled and open

### Settled from the evidence

| # | Conflict | Ruling and evidence |
|---|---|---|
| C1 | **Per-Śakti adaptation speed.** Design gave rates (fast .72, even 1, slow 1.38, late 1.12) to three specimens only. | The rate follows her **physics kind**, because it is what the room is doing. **fast**: shrink, flare, dart, surge, point, assert, brighten, clarify, call, arrest, stir. **slow**: spring, well, flow, fill, settle, ground, swell, sustain, persist, land, rest, compress, lean, incline, stand. **late**: converge, merge, align, centre, dissolve, unbind, mend, thread, recur, turn, encircle, trace, tint. **even**: breathe, expand, widen, lift, draw, waver, reach, sound, rise, arrive, bloom, open. Evidence: it reproduces all three specimens (Aṇimā shrink → fast, Sarva-Yoni spring → slow, Trikhaṇḍā converge → late), and Design's locked uniqueness budget is "Rate + Aperture" (SH-06). Appendix A lists all 102. |
| C2 | **Aperture face per Śakti.** Only three specimens again. | The face follows her **attribute key** (Iconography): **point**: noose, goad, hook, seed, gem, drop, flame, lamp, vajra, gaze, fruit, radiance. **triad**: triad, trident, spear. **tri-down**: triangle, cup, skullcup, water, molten, pour. **ring16**: rosary, garland, belt, streamer, banner, chain, grain, syllable. **ring8**: lotus, flower, discus, churn, arrows. **band**: line, brush, bow, plough, sceptre, spine, stretch, ground, shield. **lens**: mirror, palm, hand, ear, veil, cleanse, boon, herb, seal. It reproduces the specimens (kp 1 noose → point, kp 27 triangle → tri-down, kp 28 triad → triad), and it varies between sisters because their attributes do. One exception: kp 102 shows the bindu point, not her arrows. |
| C3 | **Two clocks** (Homes 62/227/347; Rite 90/165/120). | Each mode keeps its own. Both share the hold of 165 and the second adaptation of 120. The rate multiplies the first adaptation in both (C4 upgrade, 18-code-homes:143). The room clock starts at the head start (ERR-05). |
| C4 | **Two compression constants** (0.68^min(v,4) and 0.66^(v−1)). | Each is kept where it was designed (G4-0870). |
| C5 | **Light Room sound used RITE_BIJA_HZ** (136.1, 144 … Hz). | The settled rule is one tuning, Design's ring roots, and the table looks invented. The Rite's voicing is kept on her ring-root carrier. |
| C6 | **After-effect.** The Axis exposure lift named itself; per-kind was unbuilt. | Both kinds of effect are applied, felt. The line is deleted (ruling 15). The kinds come from the ring column of RITE_WORLDS: "her Siddhi" is her ring's Siddhi. |
| C7 | **The met core on the Climb** vs ruling 15. | The Climb's 102 lights stay alike. The core light lives only inside her room, on return. |
| C8 | **The binding condition** vs Design's lit rooms. | Lifted for the mechanism layer, the same way Charter II lifted it for RoomAir (RD-11: "binding condition → no figural depiction"). Figures stay excluded (C23 BC-13). |
| C9 | **Reduce Motion: loops pause vs rooms stretch.** | Both stand, scoped (C21): app loops gate, Homes adaptation stretches and is never frozen. |
| C10 | **Personal Connection "does not exist"** (handoff) vs the data. | It exists for all nine rings in his base and in all-shaktis-data.js. It is shown word for word on her walls and in her Presence. For ring 9 it is not a trailing caption on Praveśa, and the Dissolve room ends in silence (MBB-05). It lives in her Presence instead. |
| C11 | **The library vs ruling 17.** | The library is the floor of the descent, which is a form, and is reached on his ask. Its rows arrive one by one at 120 ms, so even reference comes through a form. Nothing is deleted. |
| C12 | **Doors** (code ±1 plus sister vs Design family/cluster). | Design's rule, plus the sister door. A single-member neighbourhood (kp 37) goes round the circle. kp 102 has no side doors. |
| C13 | **Names.** Design keyed by name (4 rooms lost); data drifted on 61 of 102. | Everything is keyed by kp, and display names come from the row. |
| C14 | **Mudrā deep line rewritten in code.** | Design's "the seal has opened its hand" is restored. Design's lines are authored and the body-word ban is lifted. |
| C15 | **Beat pips refused as progress.** | Restored. They count the ceremony's beats, not him. |
| C16 | **Gating** (descent 3/5 before 62 s, deepening per visit, fifth withheld, embodiment 1/3/7 gate, no way out at threshold). | Lifted to offers (ruling 16, G7-1033). Exception: "no cancel at the threshold" stays (RD-11 keep). |
| C17 | **Ring 7 Weapons** treated as Vāsinīs. | A strike is added (Design: "Weapons strike"). |
| C18 | **Ruling 4 vs the base tattva.** | A kp override table, a .light case, and the physics, nature, gesture and carrier re-pinned. |
| C19 | **RITE_WORLDS gem hues vs Atmosphere.** | Mandala/Map colours win. Shapes, altitude and after-kind are kept. |
| C20 | **Trikhaṇḍā "only in stillness"** while convergence runs on elapsed time. | The line is kept verbatim (authored). The mechanism runs on time. Stillness governs arrival only (invariant 1). |
| C21 | **"{kp} of 102" matches the measuring pattern.** | It becomes "{kp} · 102" (Design's Detail nav form). Position is identity, not a measure of him. |
| C22 | **Recognition "Logged · time".** | The verbatim lines win (C18 register). |
| C23 | **RING2 grammar** gives Kāmākarṣiṇī a lotus, while the Homes ATTRIBUTE from her Iconography gives a noose. | Inside her room the Iconography-derived ATTRIBUTE wins. RING2 silhouettes are rejected (no figure). Its surfaces, motions and Field column serve the 33 and the Relationship Field. |
| C24 | **"Sound on gates only", "one sound at a time", "no sound toggle".** | Lifted (ruling 10). The room stays whole with sound off. Each room keeps its fixed tone, and a song's drone plays only in its dance. |
| C25 | **The Wager misreads C-1195.** | The copy is re-grounded to C-1337's everyday doorways. The mechanism stays. |
| C26 | **Two "go deeper"s** (Rite fall vs Living Rite disclosure). | Both, at different depths: the fall in the Light Room, the disclosure in her Presence (02:1615). |
| C27 | **"She was expecting you"** is not in the Codex. | It is a Design-authored line, felt as light and never written on screen. |
| C28 | **Authored count** (7/8/9) and **room count** (74/58). | Eight rooms by kp. Rings 3–9 hold 58 rooms. |
| C29 | **Portrait line source** (specimen lines[5] vs Codex Portrait). | Both, in order (Codex Portrait, then Function, Somatic, Iconography sentences), never capped (ruling 17). |
| C30 | **Design's kp 28 specimen letter.** | Never shipped. The Well floor says letters are never fabricated. |

### Open — genuine questions for Ashrey

1. **Q1. The embodiment ladder** (mapped → exploring → active → embodied, petal opacity .22 → 1.0). It is now crossed only by his own hold, with no count gate. Should it be shown at all, given "nothing scores him" and C-1284's "every light breathes the same"? (G6-0935, G7-1032)
2. **Q2. A body cue before her rite.** May the Walks table's Threshold Invitations (his body cues, verbatim) be reused here as the optional beat 0? (G6-0745)
3. **Q3. Ring 8 corners.** Design and the built room give kp 100 Vajreśī = Kriyā ("the act, before there is a deed") and kp 101 Bhagamālinī = Jñāna ("form, before there is a thing"). Your Map's Aatma gift (#16) names Vajreśvarī Jñāna and Bhagamālinī Kriyā. Which do the two rooms carry? Their words would swap with the answer.
4. **Q4. "The research behind her".** May the Learning records L-1537 (102 Śaktis) and L-1533 (16 Karṣiṇīs) appear read-only at the foot of her library? (The placement was a reader's judgement.)


## 8 · Coverage

Every index id in both slices (her-home.jsonl 886, her-presence.jsonl 217; 45 shared; 1,058 unique) is marked: placed (§2 row), to Bindu Feed, rejected (floor or ruling), or not this world. Ids listed under more than one §2 row are marked at their first row.

**Script check** (`python3 -I build.py` over both slice files):

```
slice ids (unique): 1058
placed in §2:       977
other marks:        81
missing:            0 []
double-marked:      0 []
by mark:            {'placed': 977, 'not this world': 70, 'to Bindu Feed': 6, 'rejected': 4, 'rejected for her rooms': 1}
§2 elements:        127 (HH 99, HP 28)
ledger rows:        126
appendix rows:      102
```

| id | title | marked |
|---|---|---|
| G1-0001 | The Axis — one continuous three.js instrument holding nine āvaraṇas as weather up the body | placed (§2 HH-03) |
| G1-0002 | Rite of entering = the travel (three self-paced beats, three surges of flight) | placed (§2 HH-04) |
| G1-0003 | Room clock: first adaptation 62 s, hold to 227 s, second adaptation reverses premise over  | placed (§2 HH-06) |
| G1-0004 | Held attribute as the room's one actor | placed (§2 HH-31) |
| G1-0005 | Doors walk the khaḍgamālā corridor without a cut | placed (§2 HH-40) |
| G1-0006 | 'Go deeper' — the descent through five stations of her card | placed (§2 HH-57) |
| G1-0007 | The library — ShaktiDetailView folded beneath the room | placed (§2 HH-01) |
| G1-0008 | Well letter rests in the room as a folded object — never fabricated | placed (§2 HH-39) |
| G1-0009 | Leaving — her Siddhi lingers on the whole app, decaying, never named | placed (§2 HH-81) |
| G1-0015 | New additive Swift layer (9 files) | placed (§2 HH-95) |
| G1-0019 | Room resolution order: authored → ring archetype tuned by card → seat floor | placed (§2 HH-07) |
| G1-0020 | Four tuning channels: physics, altitude, phase, words | placed (§2 HH-29) |
| G1-0021 | Ring 2 crossing — one sense presented, answered in the other, opposite phase | placed (§2 HH-21) |
| G1-0022 | CROSSED table (Ring 2 counterpoint pairs) | placed (§2 HH-21) |
| G1-0023 | HomeMemory: head start from accumulated dwell, compression 1.0→0.36 | placed (§2 HH-49) |
| G1-0024 | 'you have stood here before' — one line, once, on returning; nothing displayed | placed (§2 HH-50) |
| G1-0026 | Invariant 1: Time is elapsed | placed (§2 HH-06) |
| G1-0033 | Suggested build order (10 steps); Ring 9 built last and by hand | placed (§2 HH-99) |
| G1-0035 | Ashrey's Personal Connection marginalia per ring — handoff says absent but data has it | placed (§2 HH-38) |
| G1-0037 | Original brief pipeline: Chat → Design (sample before batch) → Code | placed (§2 HH-99) |
| G1-0038 | What a home is: entering, dwelling, leaving — one architecture, every room hers alone | placed (§2 HH-01) |
| G1-0039 | Dwelling: room lit by gem, built from dhātu, ring's clock, tuned to bīja, gravity toward b | placed (§2 HH-32) |
| G1-0040 | Portrait surfaces line by line at the pace of stillness — not built | placed (§2 HH-37) |
| G1-0044 | Uniqueness grammar: card field → room role | placed (§2 HH-29) |
| G1-0045 | Test for every home: could this room belong to any other Śakti? (Laghimā lifts / Garimā pr | placed (§2 HH-91) |
| G1-0046 | Bīja → visual rhythm locked to syllable — not built | placed (§2 HH-34) |
| G1-0047 | Esoteric tattva modifies dhātu light/material — not built | placed (§2 HH-35) |
| G1-0048 | Sparśa room 'no walls, only surface' — not built | placed (§2 HH-21) |
| G1-0049 | Ring 7 Weapons (95–98) should strike — treated as Vāsinīs | placed (§2 HH-26) |
| G1-0050 | Prompts P0–P12 (Design commissioning sequence) | placed (§2 HH-99) |
| G1-0055 | ATTR_TINT — 15 colour tints of her actor | placed (§2 HH-31) |
| G1-0058 | bodyAltitude from loc (feet 0.94 → crown 0.10) | placed (§2 HH-29) |
| G1-0060 | Ring appreciation phrases (rite fallback, beat 1) | placed (§2 HH-04) |
| G1-0063 | personalConnection paragraphs — per ring, verbatim (his voice in each world) | placed (§2 HH-38) |
| G1-0071 | Axis mode state machine | placed (§2 HH-01) |
| G1-0077 | beginEnter: chamber at scale 0.02, STATION [0, .30, .62, .88, 1], struck tone | placed (§2 HH-03) |
| G1-0078 | Rite beat timing: dur 2.4 s (reduced 3.4 s) × compression; trav ease .03 | placed (§2 HH-04) |
| G1-0079 | Beat 1 — her phrase (23px cream) with fallback chain | placed (§2 HH-04) |
| G1-0080 | Beat 2 — Devanāgarī written by unseen hand (3 strokes, mask sweep) | placed (§2 HH-04) |
| G1-0081 | Beat 3 — roots part and rejoin over her quality | placed (§2 HH-04) |
| G1-0082 | riteRoots fallback morphemes | placed (§2 HH-04) |
| G1-0083 | Rite prompts and beat dots | placed (§2 HH-04) |
| G1-0084 | Entering flight: trav += dt/2.2; the point becomes her room; no transition screen | placed (§2 HH-03) |
| G1-0085 | In the room: 'stay' ×14, label, 'you have stood here before' within 14 s, return to the ax | placed (§2 HH-36) |
| G1-0086 | Door strips UI and neighbourOf / walkTo | placed (§2 HH-40) |
| G1-0087 | Library sheet UI and rows | placed (§2 HH-59) |
| G1-0088 | Well letter in room: localStorage homes.well.v1, folded object 36×14→27px | placed (§2 HH-39) |
| G1-0089 | Go deeper control: 'go deeper' → 'further' → 'come back up' | placed (§2 HH-57) |
| G1-0090 | Leaving: memory.record dwell, mark met, exposure +0.12 over 24 s | placed (§2 HH-81) |
| G1-0093 | Sound wiring per frame: ground crossfade, carrier, room, withheld fifth | placed (§2 HH-83) |
| G1-0113 | H-CLOCK formulas: a = smooth(t/62); HOLD_END 227; deep = smooth((t−227)/120); label flips  | placed (§2 HH-06) |
| G1-0114 | Second adaptation reverses the room's premise; reached only by return (or 'stay' ×14 for r | placed (§2 HH-06) |
| G1-0115 | SEAT shapes per ring and seatShell extrusion | placed (§2 HH-28) |
| G1-0116 | aperture primitive (tri-down womb-seal, triad) | placed (§2 HH-28) |
| G1-0117 | chamberSeat — 'her seat, from inside' (the shared floor) | placed (§2 HH-28) |
| G1-0118 | M1 CONTRACT — Aṇimā (pos 1): walls close to 34%, point widens twelvefold | placed (§2 HH-09) |
| G1-0119 | M2 ENDLESS — Mahimā (pos 2): 24 frames recycling at 3.4 u/s, no far wall | placed (§2 HH-10) |
| G1-0120 | M3 RELEASE — Laghimā (pos 3): cloth walls with lifting hems, rising field | placed (§2 HH-11) |
| G1-0121 | M4 KNOWN — Vaśitā (pos 6): wandering spotlight pool turns to rest on you | placed (§2 HH-14) |
| G1-0122 | M5 MEMBRANE — Sarva-Yoni (pos 27): translucent breathing vessel (≈22.4 s breath) | placed (§2 HH-15) |
| G1-0123 | M6 TRIPLE — Sarva-Trikhaṇḍā (pos 28): three tinted shells slide into register | placed (§2 HH-16) |
| G1-0124 | M7 DISSOLVE — Mahātripurasundarī (pos 102): gold yantra passes behind you, bindu comes to  | placed (§2 HH-17) |
| G1-0125 | M8 PRESS — Garimā (pos 4): ceiling slab descends, displaced strata ground, palm-press embe | placed (§2 HH-12) |
| G1-0126 | BY_NAME exact-string keys make 4 of 8 authored rooms unreachable — key by position | placed (§2 HH-07) |
| G1-0127 | buildChamber resolution and withAttribute | placed (§2 HH-07) |
| G1-0128 | Mechanism grammar: ring archetypes 3–9 | placed (§2 HH-29) |
| G1-0129 | Physics classifier — 50 regex motions, first match wins (default breathe) | placed (§2 HH-29) |
| G1-0130 | Grammar altitude and phase formulas | placed (§2 HH-29) |
| G1-0131 | ARCH-R1-SIDDHI (pos 1–10): 'the capacity, lent' + six delayed echoes | placed (§2 HH-18) |
| G1-0132 | ARCH-R1-MATRKA (pos 11–18): ring of letters, one at a time comes to the point of being spo | placed (§2 HH-19) |
| G1-0133 | ARCH-R1-MUDRA (pos 19–28): a seal large enough to stand inside; digits open | placed (§2 HH-20) |
| G1-0134 | ARCH-R2-CROSSED (pos 29–44): presenting tori vs answering sprites, opposite phase | placed (§2 HH-21) |
| G1-0135 | ARCH-R3 bodiless (45–52): petals orbit an empty centre, rim of light around nothing | placed (§2 HH-22) |
| G1-0136 | ARCH-R4 cosmic (53–66): 14 nested triangle shells, one movement delayed 0.42 s per shell | placed (§2 HH-23) |
| G1-0137 | ARCH-R5 giving (67–76): 12 gifts spiral inward (≈18 s), your hands as torus cup | placed (§2 HH-24) |
| G1-0138 | ARCH-R6 revealing (77–86): ten bright truths behind a lit veil that thins | placed (§2 HH-25) |
| G1-0139 | ARCH-R7 sounding (87–98): standing-wave wall with mode number n = 2 + (pos mod 8) | placed (§2 HH-26) |
| G1-0140 | ARCH-R8 sourcing (99–101): triangle of three lamps, hers lit, others answer at second | placed (§2 HH-27) |
| G1-0141 | Grammar dispatch by ring | placed (§2 HH-07) |
| G1-0142 | Room 1 · Aṇimā (ring 1) — siddhi · lent | placed (§2 HH-09) |
| G1-0143 | Room 2 · Mahimā (ring 1) — ENDLESS (authored) | placed (§2 HH-10) |
| G1-0144 | Room 3 · Laghimā (ring 1) — RELEASE (authored) | placed (§2 HH-11) |
| G1-0145 | Room 4 · Garimā (ring 1) — PRESS (authored) | placed (§2 HH-12) |
| G1-0146 | Room 5 · Īśitva (ring 1) — siddhi · lent | placed (§2 HH-18) |
| G1-0147 | Room 6 · Vaśitva (ring 1) — siddhi · lent | placed (§2 HH-14) |
| G1-0148 | Room 7 · Prākāmya (ring 1) — siddhi · lent | placed (§2 HH-18) |
| G1-0149 | Room 8 · Bhukti (ring 1) — siddhi · lent | placed (§2 HH-18) |
| G1-0150 | Room 9 · Icchā (ring 1) — siddhi · lent | placed (§2 HH-18) |
| G1-0151 | Room 10 · Prāpti (ring 1) — siddhi · lent | placed (§2 HH-18) |
| G1-0152 | Room 11 · Brāhmī (ring 1) — mātṛkā · letters (n=5) | placed (§2 HH-19) |
| G1-0153 | Room 12 · Māheśvarī (ring 1) — mātṛkā · letters (n=8) | placed (§2 HH-19) |
| G1-0154 | Room 13 · Kaumārī (ring 1) — mātṛkā · letters (n=11) | placed (§2 HH-19) |
| G1-0155 | Room 14 · Vaiṣṇavī (ring 1) — mātṛkā · letters (n=14) | placed (§2 HH-19) |
| G1-0156 | Room 15 · Vārāhī (ring 1) — mātṛkā · letters (n=5) | placed (§2 HH-19) |
| G1-0157 | Room 16 · Indrāṇī (ring 1) — mātṛkā · letters (n=8) | placed (§2 HH-19) |
| G1-0158 | Room 17 · Cāmuṇḍā (ring 1) — mātṛkā · letters (n=11) | placed (§2 HH-19) |
| G1-0159 | Room 18 · Mahālakṣmī (ring 1) — mātṛkā · letters (n=14) | placed (§2 HH-19) |
| G1-0160 | Room 19 · Sarva-Saṅkṣobhiṇī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0161 | Room 20 · Sarva-Vidrāviṇī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0162 | Room 21 · Sarva-Ākarṣiṇī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0163 | Room 22 · Sarva-Vaśaṅkarī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0164 | Room 23 · Sarva-Onmādinī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0165 | Room 24 · Sarva-Mahāṅkuśā (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0166 | Room 25 · Sarva-Khecarī (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0167 | Room 26 · Sarva-Bīja (ring 1) — mudrā · seal you stand inside | placed (§2 HH-20) |
| G1-0168 | Room 27 · Sarva-Yoni (ring 1) — mudrā · seal you stand inside | placed (§2 HH-15) |
| G1-0169 | Room 28 · Sarva-Trikhaṇḍā (ring 1) — mudrā · seal you stand inside | placed (§2 HH-16) |
| G1-0170 | Room 29 · Kāmākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0171 | Room 30 · Buddhyākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0172 | Room 31 · Ahaṅkārākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0173 | Room 32 · Śabdākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0174 | Room 33 · Sparśākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0175 | Room 34 · Rūpākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0176 | Room 35 · Rasākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0177 | Room 36 · Gandhākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0178 | Room 37 · Cittākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0179 | Room 38 · Dhairyākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0180 | Room 39 · Smṛtyākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0181 | Room 40 · Nāmākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0182 | Room 41 · Bījākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0183 | Room 42 · Ātmākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0184 | Room 43 · Amṛtākarṣiṇī (ring 2) — crossed | placed (§2 HH-21) |
| G1-0185 | Room 44 · Śarīrākarṣiṇī (ring 2) — crossed (KEY PAIRING) | placed (§2 HH-21) |
| G1-0186 | Room 45 · Anaṅga-Kusumā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0187 | Room 46 · Anaṅga-Mekhalā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0188 | Room 47 · Anaṅga-Madanā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0189 | Room 48 · Anaṅga-Madanāturā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0190 | Room 49 · Anaṅga-Rekhā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0191 | Room 50 · Anaṅga-Veginī (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0192 | Room 51 · Anaṅga-Aṅkuśā (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0193 | Room 52 · Anaṅga-Mālinī (ring 3) — bodiless | placed (§2 HH-22) |
| G1-0194 | Room 53 · Sarva-Saṅkṣobhiṇī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0195 | Room 54 · Sarva-Vidrāviṇī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0196 | Room 55 · Sarva-Ākarṣiṇī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0197 | Room 56 · Sarva-Āhlādinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0198 | Room 57 · Sarva-Sammohinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0199 | Room 58 · Sarva-Sthambhinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0200 | Room 59 · Sarva-Jṛmbhinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0201 | Room 60 · Sarva-Vaśaṅkarī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0202 | Room 61 · Sarva-Rañjinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0203 | Room 62 · Sarva-Onmādinī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0204 | Room 63 · Sarvārthasādhikā (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0205 | Room 64 · Sarva-Sampatpūraṇī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0206 | Room 65 · Sarva-Mantramayī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0207 | Room 66 · Sarva-Dvandvakṣayaṅkarī (ring 4) — cosmic | placed (§2 HH-23) |
| G1-0208 | Room 67 · Sarva-Siddhipradā (ring 5) — giving | placed (§2 HH-24) |
| G1-0209 | Room 68 · Sarva-Sampatpradā (ring 5) — giving | placed (§2 HH-24) |
| G1-0210 | Room 69 · Sarva-Priyaṅkarī (ring 5) — giving | placed (§2 HH-24) |
| G1-0211 | Room 70 · Sarva-Maṅgalakāriṇī (ring 5) — giving | placed (§2 HH-24) |
| G1-0212 | Room 71 · Sarva-Kāmapradā (ring 5) — giving | placed (§2 HH-24) |
| G1-0213 | Room 72 · Sarva-Duḥkhavimocanī (ring 5) — giving | placed (§2 HH-24) |
| G1-0214 | Room 73 · Sarva-Mṛtyupraśamani (ring 5) — giving | placed (§2 HH-24) |
| G1-0215 | Room 74 · Sarva-Vighnanivāriṇī (ring 5) — giving | placed (§2 HH-24) |
| G1-0216 | Room 75 · Sarvāṅgasundarī (ring 5) — giving | placed (§2 HH-24) |
| G1-0217 | Room 76 · Sarva-Saubhāgyadāyinī (ring 5) — giving | placed (§2 HH-24) |
| G1-0218 | Room 77 · Sarvajñā (ring 6) — revealing | placed (§2 HH-25) |
| G1-0219 | Room 78 · Sarvaśakti (ring 6) — revealing | placed (§2 HH-25) |
| G1-0220 | Room 79 · Sarvaiśvaryapradāyinī (ring 6) — revealing | placed (§2 HH-25) |
| G1-0221 | Room 80 · Sarvajñānamayī (ring 6) — revealing | placed (§2 HH-25) |
| G1-0222 | Room 81 · Sarvavyādhivināśinī (ring 6) — revealing | placed (§2 HH-25) |
| G1-0223 | Room 82 · Sarvādhārasvarūpā (ring 6) — revealing | placed (§2 HH-25) |
| G1-0224 | Room 83 · Sarvapāpaharā (ring 6) — revealing | placed (§2 HH-25) |
| G1-0225 | Room 84 · Sarvānandamayī (ring 6) — revealing | placed (§2 HH-25) |
| G1-0226 | Room 85 · Sarvarakṣāsvarūpiṇī (ring 6) — revealing | placed (§2 HH-25) |
| G1-0227 | Room 86 · Sarvepsitaphalapradā (ring 6) — revealing | placed (§2 HH-25) |
| G1-0228 | Room 87 · Vasinī (ring 7) — sounding (mode 9) | placed (§2 HH-26) |
| G1-0229 | Room 88 · Kāmeśī (ring 7) — sounding (mode 2) | placed (§2 HH-26) |
| G1-0230 | Room 89 · Modinī (ring 7) — sounding (mode 3) | placed (§2 HH-26) |
| G1-0231 | Room 90 · Vimalā (ring 7) — sounding (mode 4) | placed (§2 HH-26) |
| G1-0232 | Room 91 · Aruṇā (ring 7) — sounding (mode 5) | placed (§2 HH-26) |
| G1-0233 | Room 92 · Jayinī (ring 7) — sounding (mode 6) | placed (§2 HH-26) |
| G1-0234 | Room 93 · Sarveśī (ring 7) — sounding (mode 7) | placed (§2 HH-26) |
| G1-0235 | Room 94 · Kaulinī (ring 7) — sounding (mode 8) | placed (§2 HH-26) |
| G1-0236 | Room 95 · Bāṇinī (ring 7) — sounding (mode 9) | placed (§2 HH-26) |
| G1-0237 | Room 96 · Cāpinī (ring 7) — sounding (mode 2) | placed (§2 HH-26) |
| G1-0238 | Room 97 · Pāśinī (ring 7) — sounding (mode 3) | placed (§2 HH-26) |
| G1-0239 | Room 98 · Aṅkuśinī (ring 7) — sounding (mode 4) | placed (§2 HH-26) |
| G1-0240 | Room 99 · Kāmeśvarī (ring 8) — sourcing corner 0 | placed (§2 HH-27) |
| G1-0241 | Room 100 · Vajreśī (ring 8) — sourcing corner 1 | placed (§2 HH-27) |
| G1-0242 | Room 101 · Bhagamālinī (ring 8) — sourcing corner 2 | placed (§2 HH-27) |
| G1-0243 | Room 102 · Mahātripurasundarī (ring 9) — DISSOLVE (authored) | placed (§2 HH-17) |
| G1-0244 | Physics distribution across the 102 (41 of 51 motions used; 3 fall to breathe) | placed (§2 HH-29) |
| G1-0245 | Attribute forms distribution across the 102 (26 of 26) | placed (§2 HH-31) |
| G1-0246 | Ring 1 Siddhi/Mudrā room names mis-paired with app names (e.g. card Mahimā / app Laghimā a | placed (§2 HH-89) |
| G1-0247 | Attribute placement and second-adaptation growth (opacity multiply defect) | placed (§2 HH-31) |
| G1-0248 | Attribute philosophy: her held object PERFORMS (aniconic) | placed (§2 HH-31) |
| G1-0249 | Attribute form: noose | placed (§2 HH-31) |
| G1-0250 | Attribute form: goad | placed (§2 HH-31) |
| G1-0251 | Attribute form: cup | placed (§2 HH-31) |
| G1-0252 | Attribute form: arrows | placed (§2 HH-31) |
| G1-0253 | Attribute form: bow | placed (§2 HH-31) |
| G1-0254 | Attribute form: mirror | placed (§2 HH-31) |
| G1-0255 | Attribute form: lotus | placed (§2 HH-31) |
| G1-0256 | Attribute form: flame | placed (§2 HH-31) |
| G1-0257 | Attribute form: rosary | placed (§2 HH-31) |
| G1-0258 | Attribute form: trident | placed (§2 HH-31) |
| G1-0259 | Attribute form: vajra | placed (§2 HH-31) |
| G1-0260 | Attribute form: skullcup | placed (§2 HH-31) |
| G1-0261 | Attribute form: plough | placed (§2 HH-31) |
| G1-0262 | Attribute form: sceptre | placed (§2 HH-31) |
| G1-0263 | Attribute form: garland | placed (§2 HH-31) |
| G1-0264 | Attribute form: seed | placed (§2 HH-31) |
| G1-0265 | Attribute form: gem | placed (§2 HH-31) |
| G1-0266 | Attribute form: grain | placed (§2 HH-31) |
| G1-0267 | Attribute form: lamp | placed (§2 HH-31) |
| G1-0268 | Attribute form: chain | placed (§2 HH-31) |
| G1-0269 | Attribute form: herb | placed (§2 HH-31) |
| G1-0270 | Attribute form: ground | placed (§2 HH-31) |
| G1-0271 | Attribute form: radiance | placed (§2 HH-31) |
| G1-0272 | Attribute form: seal | placed (§2 HH-31) |
| G1-0273 | Attribute form: palm | placed (§2 HH-31) |
| G1-0274 | Attribute form: line | placed (§2 HH-31) |
| G1-0275 | KIN substitutions (52 attribute keys → 26 forms) | placed (§2 HH-31) |
| G1-0282 | Rite struck tone per beat: carrier × [1, 1.5, 2], decay 3.4 s | placed (§2 HH-04) |
| G1-0286 | Descent: the old Rite's descent returns as continued inward travel | placed (§2 HH-57) |
| G1-0287 | Descent shaft: 46 breathing rungs | placed (§2 HH-57) |
| G1-0288 | Descent station 1 — Tattva: spinning torus knot | placed (§2 HH-57) |
| G1-0289 | Descent station 2 — Bodily location: 13 horizontal body registers (her bar unlit — defect) | placed (§2 HH-57) |
| G1-0290 | Descent station 3 — Etymology: roots orbit inward until one word (14 s) | placed (§2 HH-57) |
| G1-0291 | Descent station 4 — Quality: one icosahedron turning | placed (§2 HH-57) |
| G1-0292 | Descent station 5 — Phrase: three flat tori, the floor of the descent | placed (§2 HH-57) |
| G1-0296 | Felt return: core light, steady pulse, floor traces (max 7), 'stood here before' 14 s | placed (§2 HH-50) |
| G1-0298 | Four things named 'rite' — must not be confused | placed (§2 HH-04) |
| G1-0300 | Rooms in 3D study (superseded): 8 richer room interiors, technique reference | placed (§2 HH-91) |
| G1-0301 | Text recedes while you look (room never behind writing) | placed (§2 HH-36) |
| G1-0302 | Mechanism sentences for 8 authored rooms (verbatim) | placed (§2 HH-36) |
| G1-0303 | Study Aṇimā: fixed topaz palette, floor at 0.34, no second adaptation | placed (§2 HH-09) |
| G1-0304 | Study Mahimā: 26 thresholds, four rails ('proof you are inside') | placed (§2 HH-10) |
| G1-0305 | Study Vaśitva and Mahātripurasundarī | placed (§2 HH-14) |
| G1-0306 | Study Laghimā: no floor mesh, unclamped motes (defect 2), unmoored seat drifting up | placed (§2 HH-11) |
| G1-0307 | Study Garimā: accentRed palm-press, fog thickens 0.03 + 0.028k, 'leaving costs effort' uni | placed (§2 HH-12) |
| G1-0308 | Study Sarva-Yoni: 'moves with your breath' is actually a 0.28 rad/s sine | placed (§2 HH-15) |
| G1-0309 | Study Sarva-Trikhaṇḍā: multi-pass RGB render-target composite (convergence computed, not d | placed (§2 HH-16) |
| G1-0311 | Concept Board V3 — nine animated SVG phone frames (frozen reference) | placed (§2 HH-91) |
| G1-0312 | Concept frame 1 Aṇimā — Smallness | placed (§2 HH-09) |
| G1-0313 | Concept frame 2 Mahimā — Vastness | placed (§2 HH-10) |
| G1-0314 | Concept frame 3 Laghimā — Lightness | placed (§2 HH-11) |
| G1-0315 | Concept frame 4 Garimā — Weightedness | placed (§2 HH-12) |
| G1-0316 | Concept frame 5 Sarva-Yoni — Source | placed (§2 HH-15) |
| G1-0317 | Concept frame 6 Sarva-Trikhaṇḍā — Trinity-as-Unity | placed (§2 HH-16) |
| G1-0318 | Concept frame 7 Mahātripurasundarī — Totality | placed (§2 HH-17) |
| G1-0319 | Concept frame 8 Vaśitva — Mastery | placed (§2 HH-14) |
| G1-0321 | Concept Board logic panel: 'I built one perspective box … That is decoration.' | placed (§2 HH-01) |
| G1-0322 | Three layers: the building · the nine worlds · her mechanism | placed (§2 HH-01) |
| G1-0323 | Standing decisions: Turrell adaptation register, ~60 s mechanisms, reference matter become | placed (§2 HH-59) |
| G1-0324 | Chambers are conditioned by their world | placed (§2 HH-03) |
| G1-0327 | The return — her room begins where you left it (felt, none displayed); traces capped at 7 | placed (§2 HH-50) |
| G1-0330 | Coverage audit: 8 brief items missing then built (hues, doors, clusters, library, Well let | placed (§2 HH-40) |
| G1-0331 | P10 sample gate result: Laghimā vs Garimā differ by 100% geometry and 116 luminance | placed (§2 HH-91) |
| G1-0332 | V3 six defects (descent dropped, white motes, dark Laghimā, Ring 4 no wall, Mātṛkās flat,  | placed (§2 HH-33) |
| G1-0336 | Next: retire three superseded studies; third state beyond second adaptation (diminishing r | placed (§2 HH-53) |
| G1-0337 | Gift: a third state beyond the second adaptation | placed (§2 HH-53) |
| G1-0411 | No minimum dwell per rite beat — eager touch cuts a beat short | placed (§2 HH-04) |
| G1-0413 | Builder must-nots summary (D list) — position is identity everywhere; build order; harness | placed (§2 HH-99) |
| G1-0414 | Gift: Laghimā unmoored seat and Garimā thickening fog mined from Rooms in 3D | placed (§2 HH-11) |
| G1-0415 | Rite of Entering prototype stack and keyframes | placed (§2 HH-60) |
| G1-0416 | Rite reduced motion: decorative drift stops, adaptation continues in quantized steps over  | placed (§2 HH-66) |
| G1-0418 | RITE_WORLDS per ring: alt, room shape, gem hue/sat, wallHue (dhātu), after-effect kind | placed (§2 HH-32) |
| G1-0420 | Rates — the second uniqueness channel (fast/even/slow/late) | placed (§2 HH-06) |
| G1-0421 | Rite per-Śakti data contract (specimen schema) | placed (§2 HH-37) |
| G1-0422 | Specimen 27 Sarva-Yoni (सर्वयोनि) — tri-down, slow; five portrait lines | placed (§2 HH-37) |
| G1-0423 | Specimen 28 Sarva-Trikhaṇḍā (सर्वत्रिखण्डा) — triad, late; letter exists | placed (§2 HH-39) |
| G1-0424 | Specimen 1 Aṇimā (अणिमा) — point, fast; five portrait lines | placed (§2 HH-37) |
| G1-0426 | Rite clock: adapt 90 s, hold 165 s, second 120 s × rate (differs from Homes 62/227/120) | placed (§2 HH-66) |
| G1-0427 | Compression on return — Zero Gap (0.66^(v−1), floor .36); beat durations 2.4/3.2/2.8 s | placed (§2 HH-49) |
| G1-0429 | Portrait surfaces only while you stay put — stillness gate, 6.5 s per line, ratchet | placed (§2 HH-37) |
| G1-0430 | After-effect per Siddhi kind — filter/transform on whole instrument, 180 s, k², never name | placed (§2 HH-81) |
| G1-0431 | Rite sound: gates only, opt-in; RITE_BIJA_HZ ring bīja frequencies; fifth opens with b | placed (§2 HH-83) |
| G1-0432 | Seat Interior — room seen from inside her seat, one-point perspective, aperture as far wal | placed (§2 HH-60) |
| G1-0433 | riteApertureSpan — one function derives room and layout so they cannot drift | placed (§2 HH-60) |
| G1-0434 | Aperture faces — the uniqueness channel sisters cannot share (point, triad, tri-down, ring | placed (§2 HH-61) |
| G1-0435 | Seat draw order — ground, yantra beyond (second adaptation), bloom, aperture, floor-lit wa | placed (§2 HH-60) |
| G1-0436 | Seat light: farL 20 → 82 with adaptation; blur sharpens as eye adapts | placed (§2 HH-60) |
| G1-0437 | Threshold: no black card — ceremony in front of her already-lit room | placed (§2 HH-63) |
| G1-0438 | Threshold beats typography: phrase 24px; Devanāgarī 36px + Latin name; etymology 26px root | placed (§2 HH-63) |
| G1-0439 | Threshold progress bars and hint; tap not gated on ready | placed (§2 HH-63) |
| G1-0440 | Room dwelling layout: 'Text is residue here: the architecture carries the recognition.' | placed (§2 HH-64) |
| G1-0441 | Her name cut into the wall above the light (dev 30px + quality) | placed (§2 HH-64) |
| G1-0442 | Portrait band — five lines 19px, 2600ms reveal, dark halo | placed (§2 HH-37) |
| G1-0443 | Her letter slip — fades in as a crosses the rate's letter threshold | placed (§2 HH-39) |
| G1-0444 | Doors lit along the seat's own edges | placed (§2 HH-40) |
| G1-0445 | 'go deeper' appears only after a ≈ .28 (full by .58); opens the Descent | placed (§2 HH-64) |
| G1-0446 | Motes visible only once the eye has adjusted (a > .2) | placed (§2 HH-60) |
| G1-0447 | Descent as a fall through five chambers (function, somatic, icon, tattva, root) | placed (§2 HH-65) |
| G1-0448 | Chamber 1 ChFunction — seat form multiplying outward | placed (§2 HH-65) |
| G1-0449 | Chamber 2 ChSomatic — 15 body registers breathing at her altitude (lit) | placed (§2 HH-65) |
| G1-0450 | Chamber 3 ChIcon — attribute motion by aperture (noose converge, triad seals, womb-seal tr | placed (§2 HH-65) |
| G1-0451 | Chamber 4 ChTattva — counter-rotating forms; Chamber 5 ChRoot — roots drawn inward to one  | placed (§2 HH-65) |
| G1-0452 | Fall mechanics: target +1 per tap (max 5), dz ease .055, scale 2.5^(−rel) | placed (§2 HH-65) |
| G1-0453 | 'The floor of her' — reference rows at the bottom of the fall; 'rise back into her room' | placed (§2 HH-59) |
| G1-0454 | RiteLibrary bottom sheet — orphaned (exported, never mounted) | placed (§2 HH-59) |
| G1-0455 | The Corridor after leaving: two door glows + 'enter' | placed (§2 HH-96) |
| G1-0457 | Rite preview: any Śakti in any of the nine world rooms (world from tweak, not spec.ring) | placed (§2 HH-60) |
| G1-0480 | Embodiment ladder: Mapped → Exploring → Active → Embodied, crossing by press-and-hold | placed (§2 HP-12) |
| G1-0534 | RING2 iconography grammar — 16 Karṣiṇīs with phonetic, element, silhouette, attribute, sur | not this world (the-33) |
| G1-0538 | Grammar-built body: surface styles, attributes, silhouettes, motion | not this world (the-33) |
| G1-0546 | SEAT level: kicker cluster · element, body, name, '{phon} · {field}', 'She is the drawing- | placed (§2 HP-04) |
| G1-0584 | Turrell mechanism: one normalized value a advances so slowly nothing appears to happen; ev | placed (§2 HH-06) |
| G1-0592 | Second adaptation reveals the whole Śrī Yantra beyond the far wall while her signature fad | placed (§2 HH-62) |
| G1-0593 | Room = world, aperture = Śakti — the Rite's two-channel uniqueness contract | placed (§2 HH-60) |
| G1-0601 | The Rite's go deeper (fall) and Living Rite's go deeper (disclosure) coexist for different | placed (§2 HH-59) |
| G2-0019 | DS-18 Detail sections | placed (§2 HH-01) |
| G2-0037 | CB0-13 Detail phase 5 (bīja 108pt, Her Moments) | placed (§2 HP-01) |
| G2-0082 | FB-04 new Shakti fields | placed (§2 HH-89) |
| G2-0096 | FB-18 Detail order | placed (§2 HH-01) |
| G2-0124 | DA1-10 Call 3 Detail encyclopedia | placed (§2 HH-01) |
| G2-0161 | DA2-06 Detail buries its soul | placed (§2 HH-01) |
| G2-0202 | RBB-09 Ruling 7: graceful degradation for the 86 | placed (§2 HH-59) |
| G2-0220 | XMB-04 activation cycle four beats + six gesture families | placed (§2 HH-41) |
| G2-0223 | XMB-07 Iconography field drives nothing | placed (§2 HH-31) |
| G2-0224 | XMB-08 Iconography grammar four layers | placed (§2 HH-31) |
| G2-0228 | XMB-12 entering-ceremony compression formula | placed (§2 HH-49) |
| G2-0231 | EXP-01–15 Homes ideas | placed (§2 HH-38) |
| G2-0236 | HDP-03 what a home is: Entering/Dwelling/Library/Doors/Leaving | placed (§2 HH-01) |
| G2-0239 | HDP-06 uniqueness grammar | placed (§2 HH-29) |
| G2-0240 | HDP-07 room test: could it belong to another Śakti? | placed (§2 HH-91) |
| G2-0241 | HDP-08 Design prompts P0–P12 | placed (§2 HH-99) |
| G2-0248 | CCH-01/03 Homes extend shipped app; keep list | placed (§2 HH-01) |
| G2-0250 | CCH-04 Homes layer files | placed (§2 HH-95) |
| G2-0252 | CCH-06 gem diffusion per ring | placed (§2 HH-32) |
| G2-0253 | CCH-07 RingWorld veil + tempo | placed (§2 HH-32) |
| G2-0254 | CCH-08 room resolution chain | placed (§2 HH-07) |
| G2-0255 | CCH-09 four channels (physics/altitude/phase/words) | placed (§2 HH-29) |
| G2-0256 | CCH-10 room reverses premise at second adaptation | placed (§2 HH-06) |
| G2-0257 | CCH-11 Ring 2 crossing (one sense answers in other) | placed (§2 HH-21) |
| G2-0258 | CCH-12 Attribute actor (aniconic, 26 forms, grows 0.9→3.16) | placed (§2 HH-31) |
| G2-0259 | CCH-13 the rite is the distance (three beats) | placed (§2 HH-04) |
| G2-0260 | CCH-14 going deeper five stations | placed (§2 HH-57) |
| G2-0261 | CCH-15 doors sideways within neighbourhood | placed (§2 HH-40) |
| G2-0262 | CCH-16 Siddhi after-effect lingers, never named | placed (§2 HH-81) |
| G2-0263 | CCH-17 return: dwell head start, 227 s, 'you have stood here before' | placed (§2 HH-50) |
| G2-0264 | CCH-18 Homes sound per ring + carrier | placed (§2 HH-54) |
| G2-0265 | CCH-19 Homes invariants 1–7 | placed (§2 HH-86) |
| G2-0267 | CCH-21 Homes verification contract 66 checks | placed (§2 HH-91) |
| G2-0268 | CCH-22 Personal Connection marginalia unauthored | placed (§2 HH-38) |
| G2-0270 | THR-02 attribute actions table | placed (§2 HH-31) |
| G2-0271 | THR-03 coverage audit seven restored asks | placed (§2 HH-91) |
| G2-0272 | THR-04 physics classifier 50 patterns | placed (§2 HH-29) |
| G2-0273 | THR-05 the Gate: Laghimā vs Garimā | placed (§2 HH-91) |
| G2-0275 | THR-07 102 rooms counts + Ring 1 family archetypes | placed (§2 HH-07) |
| G2-0277 | THR-09 ring archetype deep lines R3–9 | placed (§2 HH-29) |
| G2-0278 | THR-10 Homes defects (collisions, R8 triangle, R6 veil) | placed (§2 HH-89) |
| G2-0280 | THR-12 second-adaptation reversals seven rooms | placed (§2 HH-30) |
| G2-0282 | THR-14 Return: expecting you, floor traces, forget me | placed (§2 HH-50) |
| G2-0285 | THR-17 nine room mechanisms (3D) | placed (§2 HH-08) |
| G2-0286 | THR-18 standing decisions (Turrell, tap-paced) | placed (§2 HH-59) |
| G2-0295 | MTH-06/07 one engine N tunings; build from real data | placed (§2 HH-29) |
| G2-0297 | MTH-09 time elapsed, never device-tied | placed (§2 HH-06) |
| G2-0308 | SH-06 Sept locked items incl. uniqueness budget | placed (§2 HH-61) |
| G2-0319 | AR-08 didSettleNotification jumps to Portrait | placed (§2 HH-82) |
| G2-0329 | BV2-L2 never measure; compression never skips | placed (§2 HH-49) |
| G2-0334 | BV2-R9/R10 four-channel grammar; authored Gate | placed (§2 HH-29) |
| G2-0335 | BV2-R11 Mauna reborn as dwelling 62 s | placed (§2 HH-55) |
| G2-0336 | BV2-R12/R13 Homes replace Detail top; compression floor 0.36 | placed (§2 HH-01) |
| G2-0341 | BV2-7 Ashrey's alone: letters, marginalia, bīja recordings | placed (§2 HH-83) |
| G2-0344 | ERR-03/CN-03 Rings 3–9 are 58 rooms | placed (§2 HH-07) |
| G2-0345 | ERR-04 authored map kp {1,2,3,4,6,27,28,102} | placed (§2 HH-07) |
| G2-0346 | ERR-05 R11 clock ambiguity | placed (§2 HH-06) |
| G2-0349 | ERR-08/CN-02 R10 authored gate; zero-hand-work released | placed (§2 HH-91) |
| G2-0374 | WV-08 Wave 1 Light list | placed (§2 HH-32) |
| G2-0378 | RD-01 what exists (Homes, climb, Mandala light) | placed (§2 HH-08) |
| G2-0383 | RD-06 gap cause 2: binding condition, luminance | placed (§2 HH-08) |
| G2-0385 | RD-08 gap cause 4: restraint drops | placed (§2 HH-08) |
| G2-0387 | RD-11 first-principles table (lift caps, sound, doors) | placed (§2 HH-08) |
| G2-0388 | RD-12 Homecoming list for the Homes (per-band physics) | placed (§2 HH-32) |
| G2-0391 | RD-15 fix inventory code defects | placed (§2 HH-90) |
| G2-0400 | F07 Rooms in 3D Aṇimā (black WebGL capture) | placed (§2 HH-91) |
| G2-0406 | F13 Axis seat tier entering a room | placed (§2 HH-91) |
| G2-0455 | C21 reduced motion | placed (§2 HH-85) |
| G2-0456 | C22 stillness as input | placed (§2 HH-37) |
| G2-0457 | C23 figures | placed (§2 HH-08) |
| G2-0463 | C29 room count 74 vs 58 | placed (§2 HH-07) |
| G2-0464 | C30 authored rooms count | placed (§2 HH-07) |
| G2-0466 | C32 the Gate zero hand-work vs authored | placed (§2 HH-91) |
| G2-0467 | C33 Mauna/Silence | placed (§2 HH-55) |
| G2-0468 | C34 Ring 9 personal connection placement | placed (§2 HH-38) |
| G2-0471 | C37 Detail ordering | placed (§2 HH-01) |
| G2-0475 | E must-not-miss: Siddhi after-effect ~180 s; forget me | placed (§2 HH-56) |
| G2-0599 | Room 02 Muladhara: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0607 | Room 03 Svadhisthana: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0615 | Room 04 Manipura: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0623 | Room 05 Anahata: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0631 | Room 06 Vishuddha: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0639 | Room 07 Ajna: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0647 | Room 08 Sahasrara: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0655 | Room 09 Shadow: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0664 | Room 10 Soles: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0672 | Room 11 Forge: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0680 | Room 12 Prana: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0688 | Room 13 Hands: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0696 | Room 14 Pulse: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0704 | Room 15 Sonar: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0712 | Room 16 Echo: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0720 | Room 17 Vision: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0728 | Room 18 Axis: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0736 | Room 19 Crow: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0744 | Room 20 Armin: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0752 | Room 21 Inception: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0760 | Room 22 Intention: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0768 | Room 23 Inspiration: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0776 | Room 24 Insight: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0784 | Room 25 Intuition: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0792 | Room 26 Invention: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0800 | Room 27 Incarnation: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0808 | Room 28 Innocence: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0816 | Room 29 Integration: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0825 | Room 30 Maya: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0833 | Room 31 Aatma: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G2-0844 | Room 33 Lalita: depth (Śakti, avaraṇa, mudrā, body) — thread link | placed (§2 HH-93) |
| G3-0072 | Atlas 01 Bindu | not this world (the-33) |
| G3-0331 | C-1005 FlASH Point story: his state vocabulary (LES/HES, Ram integrates) | to Bindu Feed (§6) |
| G3-0340 | C-1020 Serenity Prayer | not this world (today-rite) |
| G3-0350 | C-1060 Familiarity as welcome: she was expecting you | placed (§2 HH-50) |
| G3-0375 | C-1119 Light and dark the same: rooms hold dark Śaktis | placed (§2 HH-30) |
| G3-0385 | C-1145 Feel through the body before realigning; non-doing [KEY] | placed (§2 HH-05) |
| G3-0391 | C-1159 Gratitude is the doorway: felt, not performed | placed (§2 HH-04) |
| G3-0397 | C-1166/1168 Śakti cleansing survival fear at Mūlādhāra [KEY] | not this world (the-33) |
| G3-0425 | C-1219 No pre-framing of experiences; the app is an input diet | placed (§2 HH-04) |
| G3-0427 | C-1224 Keep him where he is; guide in place; sparkle; signs | placed (§2 HH-40) |
| G3-0437 | C-1242 Neti-neti: what remains | placed (§2 HH-30) |
| G3-0439 | C-1244 Energy follows intent | placed (§2 HH-41) |
| G3-0466 | C-1279 Two depths: one-line answer or full journey | placed (§2 HH-02) |
| G3-0467 | C-1280 Reveal opened by an intention gesture; he writes his own perspective | placed (§2 HP-16) |
| G3-0494 | C-1314 Ask his starting point before showing content | placed (§2 HH-44) |
| G3-0496 | C-1316 Spaces/rooms vocabulary of his dream home | placed (§2 HH-01) |
| G3-0505 | C-1337 DIRECT APP MANDATE: map every Sri Yantra energy as an experience; two-way practice  | placed (§2 HH-41) |
| G3-0517 | C-1353 Gift notification: one energy to appreciate, at random times [KEY] | placed (§2 HH-47) |
| G3-0518 | C-1354 Progressive disclosure by return; write/speak back; codex linking (Learning) | placed (§2 HH-51) |
| G3-0530 | MISREAD FLAG C-1195: Wager reading imported; body-honouring ask dropped | placed (§2 HP-15) |
| G3-0538 | 'She was expecting you' is not in the Codex | placed (§2 HH-50) |
| G4-0036 | The Mirror (spec): near-white light wash at four triggers + contrast boost | placed (§2 HH-74) |
| G4-0049 | cross seed: half-beat typing, {name} personalisation, pre-roll breathing ring | placed (§2 HH-71) |
| G4-0050 | Word reveal at PEAK_T (V2 centre / VX bottom 15% / cross Cinzel) | placed (§2 HH-71) |
| G4-0095 | Heart language (Anahata VX merged): warmth map, heart ghosts, motes, blush, hexagram, 12 p | placed (§2 HH-77) |
| G4-0116 | Gap categories: sustain mode (drones), decay-envelope (bowls), adaptive bloom (quiet), cha | placed (§2 HH-72) |
| G4-0164 | Binaural engine 'three archetypes holding the field' (Gaia×Sid carrier 110 Hz, Karishma in | placed (§2 HH-73) |
| G4-0167 | OL-3 Lalita voice: four lines (placeholder mp3s missing) | rejected — floor: no generated voice (no recordings exist) |
| G4-0205 | reach (LMLYD) pre-ensemble language: ripples, permanent halos, stutter, heart restart, bou | placed (§2 HH-77) |
| G4-0229 | Per-chakra dance lives as the dance strand of each room in the 33 braid; Śakti dance as 'H | placed (§2 HH-67) |
| G4-0232 | Per-Śakti songless dance from her own sound (sustain mode, 5.5 s breath bloom, seven arche | placed (§2 HH-68) |
| G4-0235 | Seven-archetype ensemble as one SwiftUI Dancer model | placed (§2 HH-69) |
| G4-0248 | Karishma valley heartbeat (~50 BPM centre pulse in the longest silence) | placed (§2 HH-75) |
| G4-0249 | Spatial memory map (threshold / warmth / burn / echo) on Her Home's floor | placed (§2 HH-76) |
| G4-0251 | Cathedral Floor: always-on breathing ground — Her Home's floor breathes with her carrier | placed (§2 HH-76) |
| G4-0255 | crossingPeakIntensity global boost (1+0.8·k) at Recognition | placed (§2 HH-43) |
| G4-0256 | Shweta / Glassine clarity wash at PEAK_T on Recognition lines | placed (§2 HH-43) |
| G4-0294 | No figure of a Śakti vs heart-shaped glyphs — no issue; Śakti stays the field | placed (§2 HH-79) |
| G4-0324 | Spatial memory grids 25×35; karishma_decay 0.0005 'nothing fades while the body is held in | placed (§2 HH-76) |
| G4-0329 | consciousness_loop contract: {name} seed typed at bpm; word_reveal at peak_t bottom 15%; i | placed (§2 HH-71) |
| G4-0332 | haptics contract: Core Haptics; missing peak haptic is 'a smell' | placed (§2 HH-43) |
| G4-0336 | resonance_link: join Bindu Field.Chakra → Mandala.Subtle Body Chakra; 'No Score may assign | placed (§2 HH-68) |
| G4-0382 | Shape vocabulary with meaning (infinity = what doesn't end; heart = patient love; circle = | placed (§2 HH-77) |
| G4-0461 | Absent-fifth carrier per room from the Scores (R2 146.8 · R3 146.8 · R4 164.8 · R5 155.6 · | not this world (the-33) |
| G4-0463 | Inverse gain law: her room's tone swells in silence ('They share the field; they do not co | placed (§2 HH-73) |
| G4-0472 | Mirror word families as room answers (48 families exist verbatim across cross/abide/thunde | not this world (the-33) |
| G4-0474 | Fruit weaves that reflect what the body did in the silence (Rite close); never grade | not this world (today-rite) |
| G4-0476 | Named seed variant '{name}, what is asking to be crossed in you?' — she asks the room's qu | rejected — floor: nothing invented / baked text verbatim |
| G4-0477 | Haptic library (crossing footsteps, bell, mirror, strike, fulcrum 50 bpm, charge 46 bpm, t | placed (§2 HH-43) |
| G4-0482 | Voice triggers OL-3 in Her Home with recorded human voice only | rejected — floor: no generated voice (no recordings exist) |
| G4-0572 | H2 subtle-body sound fields: koshas as concentric shells, nadis (ida/pingala = L/R, beat = | not this world (beneath) |
| G4-0579 | S3 lens colour signatures (one_word red, need green, holds gold, frequency blue, shape sil | not this world (the-33) |
| G4-0602 | Breath sessions with visual metronome in the Modes / Rite opening / Her Home (11 technique | not this world (modes) |
| G4-0615 | Absent-fifth carrier per Śakti / per ring derived from ring's chakra carrier (no songs) —  | rejected for her rooms — ruling: one tuning (Design's ring roots); stays with chakra dances |
| G4-0619 | Karishma windows: Recognition lines appear only inside a silence (never on a peak) | placed (§2 HH-75) |
| G4-0621 | Consciousness Loop as the Rite's skeleton (settling → focus → offering → dance → revelatio | not this world (today-rite) |
| G4-0623 | Three-layer reading UI (Lalita → toggle → seven lenses with colours) for Her Home / rooms | to Bindu Feed (§6) |
| G4-0627 | resonance_link as the bridge for sound per Śakti: seat → subtle-body chakra → chakra track | placed (§2 HH-68) |
| G4-0633 | No Śakti-level sound exists anywhere; resonance_link.shaktis empty in all 46 Scores | placed (§2 HH-68) |
| G4-0681 | Form A7 Four-section reading (SAY · WALK · HAND · OPEN), each by one of G2-G8; 'There is n | not this world (the-33) |
| G4-0683 | Form A9 Still Point: each hold takes something away (seven stages; type grows as text shor | placed (§2 HP-17) |
| G4-0690 | Way in B2 Two-door station: walk it or read it (two flames half/whole; 'now, while it is s | placed (§2 HH-02) |
| G4-0710 | Sub-template/move: verse moves | placed (§2 HH-04) |
| G4-0712 | Ceremony grammar (fixed order: one breath → beats → the act → answer in the world's materi | placed (§2 HH-43) |
| G4-0724 | G0 hold engine: commit on threshold, act on release, drain on early release; held-key pari | placed (§2 HH-97) |
| G4-0754 | Gesture G30 Colour through staying | placed (§2 HH-33) |
| G4-0759 | Gesture G35 Touch beats | placed (§2 HH-04) |
| G4-0763 | Gesture G39 Long-press to catch; recognition ceremony | placed (§2 HH-43) |
| G4-0773 | Gesture G49 Dwell (a measure) | placed (§2 HH-49) |
| G4-0776 | Corridor engine (BASE_CSS + CORRIDOR_JS): layers, step/piece arrival, --from direction, hi | not this world (spine) |
| G4-0791 | Exemplar verse.html (Gāyatrī): shirorekhā head-rule; touch the line and it breathes (lette | placed (§2 HH-04) |
| G4-0850 | Her Home: G35 touch beats replace three text slides over fog (shortened ×max(0.36, 0.66^(v | placed (§2 HH-04) |
| G4-0851 | Her Home: G30 colour through staying brings her room up to Design's light (audit 4: ~11-65 | placed (§2 HH-33) |
| G4-0852 | Her Home: G49 dwell head start (min(dwell·0.55, 221 s) above 12 s; ceremony shortened max( | placed (§2 HH-49) |
| G4-0853 | Her Home: G2 stillness gate opens her far wall (withheld fifth / deeper chamber); 4600 ms; | placed (§2 HH-98) |
| G4-0854 | Her Home: ceremony grammar for 'I feel her' with G39 timings and the two verbatim Recognit | placed (§2 HH-43) |
| G4-0855 | Her Home: map--climb approach with sideways doors to her neighbourOf positions | placed (§2 HH-40) |
| G4-0856 | Her Home: G13 rope + G38 leave by the edge from any chamber | placed (§2 HH-80) |
| G4-0870 | Two return-compression constants (G35 0.66^(visits−1) vs G49 0.68^min(visits,4)) — keep ea | placed (§2 HH-49) |
| G5-0056 | Log-scale camera for the yantra | placed (§2 HH-03) |
| G5-0064 | The patina (a piece that returns, aged) | placed (§2 HH-52) |
| G5-0065 | A ring drawn by hand, settling true | placed (§2 HH-52) |
| G5-0161 | Memory felt, never shown (G49) | placed (§2 HH-49) |
| G5-0162 | Rooms that each do one thing (eight mechanisms) | placed (§2 HH-07) |
| G5-0164 | The adaptation clock (staying opens a deeper turn) | placed (§2 HH-06) |
| G5-0165 | Going deeper: a record walked as a shaft (five stations) | placed (§2 HH-57) |
| G5-0166 | Each place's verb is its gesture | placed (§2 HH-36) |
| G5-0168 | Six compositions from one set of blocks (element layouts) | placed (§2 HP-21) |
| G5-0169 | Relit by the hour | placed (§2 HP-21) |
| G5-0170 | Readiness sensed; crossing chosen | placed (§2 HP-12) |
| G5-0180 | Rooms made by rule | placed (§2 HH-07) |
| G5-0181 | A name written by an unseen hand, split into roots (three touches in) | placed (§2 HH-04) |
| G5-0213 | Silence learning to sound (drone under a still finger) | not this world (home) |
| G5-0305 | Learning-table depth on every ring and seat (L-1537) | placed (§2 HH-57) |
| G5-0306 | The 16 Karṣiṇī as a teaching layer under ring 2 | placed (§2 HH-59) |
| G5-0307 | The Ten Mahāvidyās as a sister set | not this world (beneath) |
| G5-0308 | Lalita Sahasranāma as the garland mode | not this world (modes) |
| G5-0328 | Designed but unbuilt (app's own exports) | placed (§2 HH-08) |
| G5-0363 | S13 Room shape | placed (§2 HH-92) |
| G5-0438 | A palette from one hue (per Śakti) | placed (§2 HH-92) |
| G5-0443 | No figure of a Śakti (figure grammar for a presence excluded) | placed (§2 HP-03) |
| G5-0470 | Room hero: gradient geometry by meaning | placed (§2 HP-21) |
| G5-0472 | Dark first, then the room | placed (§2 HP-02) |
| G5-0484 | Token family Mandala (house chassis) | placed (§2 HH-92) |
| G5-0517 | Visual language for Her Home (her room): mandala per-being palette, S13 Room | placed (§2 HH-92) |
| G5-0591 | Lemuria: breath → words | placed (§2 HP-02) |
| G5-0675 | Pulse Gate (hold scales ×40 into the room) | placed (§2 HH-03) |
| G5-0731 | Topic: Śrī Yantra — Full Mandala Architecture: 102 Shaktis across 9 Avaranas (Khadgamalā S | placed (§2 HH-59) |
| G5-0978 | Topic: Lalita Sahasranama - The Thousand Names (L-1456) | not this world (modes) |
| G5-1029 | Topic: The Sixteen Karshini Shaktis — Sri Chakra Second Avarana (L-1533) | placed (§2 HH-59) |
| G5-1108 | Topic: The Ten Mahavidyas | not this world (beneath) |
| G5-1119 | Topic: Kali - The Dark Mother | to Bindu Feed (§6) |
| G6-0003 | Map · Shakti Function · 1 Bindu | placed (§2 HH-44) |
| G6-0010 | Map · Shakti Function · 2 Muladhara | placed (§2 HH-44) |
| G6-0017 | Map · Shakti Function · 3 Svadhisthana | placed (§2 HH-44) |
| G6-0024 | Map · Shakti Function · 4 Manipura | placed (§2 HH-44) |
| G6-0031 | Map · Shakti Function · 5 Anahata | placed (§2 HH-44) |
| G6-0038 | Map · Shakti Function · 6 Vishuddha | placed (§2 HH-44) |
| G6-0045 | Map · Shakti Function · 7 Ajna | placed (§2 HH-44) |
| G6-0052 | Map · Shakti Function · 8 Sahasrara | placed (§2 HH-93) |
| G6-0059 | Map · Shakti Function · 9 Shadow | placed (§2 HH-93) |
| G6-0067 | Map · Shakti Function · 10 Soles | placed (§2 HH-93) |
| G6-0075 | Map · Shakti Function · 11 Forge | placed (§2 HH-93) |
| G6-0083 | Map · Shakti Function · 12 Prana | placed (§2 HH-93) |
| G6-0091 | Map · Shakti Function · 13 Hands | placed (§2 HH-93) |
| G6-0099 | Map · Shakti Function · 14 Pulse | placed (§2 HH-93) |
| G6-0107 | Map · Shakti Function · 15 Sonar | placed (§2 HH-93) |
| G6-0115 | Map · Shakti Function · 16 Echo | placed (§2 HH-93) |
| G6-0123 | Map · Shakti Function · 17 Vision | placed (§2 HH-93) |
| G6-0131 | Map · Shakti Function · 18 Axis | placed (§2 HH-93) |
| G6-0139 | Map · Shakti Function · 19 Crow | placed (§2 HH-93) |
| G6-0147 | Map · Shakti Function · 20 Armin | placed (§2 HH-93) |
| G6-0155 | Map · Shakti Function · 21 Inception | placed (§2 HH-93) |
| G6-0162 | Map · Shakti Function · 22 Intention | placed (§2 HH-93) |
| G6-0169 | Map · Shakti Function · 23 Inspiration | placed (§2 HH-93) |
| G6-0176 | Map · Shakti Function · 24 Insight | placed (§2 HH-93) |
| G6-0183 | Map · Shakti Function · 25 Intuition | placed (§2 HH-93) |
| G6-0190 | Map · Shakti Function · 26 Invention | placed (§2 HH-93) |
| G6-0197 | Map · Shakti Function · 27 Incarnation | placed (§2 HH-93) |
| G6-0204 | Map · Shakti Function · 28 Innocence | placed (§2 HH-93) |
| G6-0211 | Map · Shakti Function · 29 Integration | placed (§2 HH-93) |
| G6-0218 | Map · Shakti Function · 30 Maya | placed (§2 HH-93) |
| G6-0225 | Map · Shakti Function · 31 Aatma | placed (§2 HH-93) |
| G6-0232 | Map · Shakti Function · 32 Ego Reveal | placed (§2 HH-93) |
| G6-0239 | Map · Shakti Function · 33 Lalita | placed (§2 HH-93) |
| G6-0310 | Map · Shakti Name · 1 Bindu | placed (§2 HH-93) |
| G6-0311 | Map · Shakti Mudra · 1 Bindu | placed (§2 HH-46) |
| G6-0312 | Map · Shakti Name · 2 Muladhara | placed (§2 HH-93) |
| G6-0313 | Map · Shakti Mudra · 2 Muladhara | placed (§2 HH-46) |
| G6-0314 | Map · Shakti Name · 3 Svadhisthana | placed (§2 HH-93) |
| G6-0315 | Map · Shakti Mudra · 3 Svadhisthana | placed (§2 HH-46) |
| G6-0316 | Map · Shakti Name · 4 Manipura | placed (§2 HH-93) |
| G6-0317 | Map · Shakti Mudra · 4 Manipura | placed (§2 HH-46) |
| G6-0318 | Map · Shakti Name · 5 Anahata | placed (§2 HH-93) |
| G6-0319 | Map · Shakti Mudra · 5 Anahata | placed (§2 HH-46) |
| G6-0320 | Map · Shakti Name · 6 Vishuddha | placed (§2 HH-93) |
| G6-0321 | Map · Shakti Mudra · 6 Vishuddha | placed (§2 HH-46) |
| G6-0322 | Map · Shakti Name · 7 Ajna | placed (§2 HH-93) |
| G6-0323 | Map · Shakti Mudra · 7 Ajna | placed (§2 HH-46) |
| G6-0324 | Map · Shakti Name · 8 Sahasrara | placed (§2 HH-93) |
| G6-0325 | Map · Shakti Mudra · 8 Sahasrara | placed (§2 HH-46) |
| G6-0326 | Map · Shakti Name · 9 Shadow | placed (§2 HH-93) |
| G6-0327 | Map · Shakti Mudra · 9 Shadow | placed (§2 HH-46) |
| G6-0328 | Map · Shakti Name · 10 Soles | placed (§2 HH-93) |
| G6-0329 | Map · Shakti Mudra · 10 Soles | placed (§2 HH-46) |
| G6-0330 | Map · Shakti Name · 11 Forge | placed (§2 HH-93) |
| G6-0331 | Map · Shakti Mudra · 11 Forge | placed (§2 HH-46) |
| G6-0332 | Map · Shakti Name · 12 Prana | placed (§2 HH-93) |
| G6-0333 | Map · Shakti Mudra · 12 Prana | placed (§2 HH-46) |
| G6-0334 | Map · Shakti Name · 13 Hands | placed (§2 HH-93) |
| G6-0335 | Map · Shakti Mudra · 13 Hands | placed (§2 HH-46) |
| G6-0336 | Map · Shakti Name · 14 Pulse | placed (§2 HH-93) |
| G6-0337 | Map · Shakti Mudra · 14 Pulse | placed (§2 HH-46) |
| G6-0338 | Map · Shakti Name · 15 Sonar | placed (§2 HH-93) |
| G6-0339 | Map · Shakti Mudra · 15 Sonar | placed (§2 HH-46) |
| G6-0340 | Map · Shakti Name · 16 Echo | placed (§2 HH-93) |
| G6-0341 | Map · Shakti Mudra · 16 Echo | placed (§2 HH-46) |
| G6-0342 | Map · Shakti Name · 17 Vision | placed (§2 HH-93) |
| G6-0343 | Map · Shakti Mudra · 17 Vision | placed (§2 HH-46) |
| G6-0344 | Map · Shakti Name · 18 Axis | placed (§2 HH-93) |
| G6-0345 | Map · Shakti Mudra · 18 Axis | placed (§2 HH-46) |
| G6-0346 | Map · Shakti Name · 19 Crow | placed (§2 HH-93) |
| G6-0347 | Map · Shakti Mudra · 19 Crow | placed (§2 HH-46) |
| G6-0348 | Map · Shakti Name · 20 Armin | placed (§2 HH-93) |
| G6-0349 | Map · Shakti Mudra · 20 Armin | placed (§2 HH-46) |
| G6-0350 | Map · Shakti Name · 21 Inception | placed (§2 HH-93) |
| G6-0351 | Map · Shakti Mudra · 21 Inception | placed (§2 HH-46) |
| G6-0352 | Map · Shakti Name · 22 Intention | placed (§2 HH-93) |
| G6-0353 | Map · Shakti Mudra · 22 Intention | placed (§2 HH-46) |
| G6-0354 | Map · Shakti Name · 23 Inspiration | placed (§2 HH-93) |
| G6-0355 | Map · Shakti Mudra · 23 Inspiration | placed (§2 HH-46) |
| G6-0356 | Map · Shakti Name · 24 Insight | placed (§2 HH-93) |
| G6-0357 | Map · Shakti Mudra · 24 Insight | placed (§2 HH-46) |
| G6-0358 | Map · Shakti Name · 25 Intuition | placed (§2 HH-93) |
| G6-0359 | Map · Shakti Mudra · 25 Intuition | placed (§2 HH-46) |
| G6-0360 | Map · Shakti Name · 26 Invention | placed (§2 HH-93) |
| G6-0361 | Map · Shakti Mudra · 26 Invention | placed (§2 HH-46) |
| G6-0362 | Map · Shakti Name · 27 Incarnation | placed (§2 HH-93) |
| G6-0363 | Map · Shakti Mudra · 27 Incarnation | placed (§2 HH-46) |
| G6-0364 | Map · Shakti Name · 28 Innocence | placed (§2 HH-93) |
| G6-0365 | Map · Shakti Mudra · 28 Innocence | placed (§2 HH-46) |
| G6-0366 | Map · Shakti Name · 29 Integration | placed (§2 HH-93) |
| G6-0367 | Map · Shakti Mudra · 29 Integration | placed (§2 HH-46) |
| G6-0368 | Map · Shakti Name · 30 Maya | placed (§2 HH-93) |
| G6-0369 | Map · Shakti Mudra · 30 Maya | placed (§2 HH-46) |
| G6-0370 | Map · Shakti Name · 31 Aatma | placed (§2 HH-93) |
| G6-0371 | Map · Shakti Mudra · 31 Aatma | placed (§2 HH-46) |
| G6-0372 | Map · Shakti Name · 32 Ego Reveal | placed (§2 HH-93) |
| G6-0373 | Map · Shakti Mudra · 32 Ego Reveal | placed (§2 HH-46) |
| G6-0374 | Map · Shakti Name · 33 Lalita | placed (§2 HH-93) |
| G6-0375 | Map · Shakti Mudra · 33 Lalita | placed (§2 HH-46) |
| G6-0498 | Mudrā chain · 1 Bindu | placed (§2 HH-46) |
| G6-0499 | Mudrā chain · 2·3·4 | placed (§2 HH-46) |
| G6-0500 | Mudrā chain · 5·8 | placed (§2 HH-46) |
| G6-0501 | Mudrā chain · 6·7 | placed (§2 HH-46) |
| G6-0502 | Mudrā chain · 9 | placed (§2 HH-46) |
| G6-0503 | Mudrā chain · 10·11·15 | placed (§2 HH-46) |
| G6-0504 | Mudrā chain · 12·13·14 | placed (§2 HH-46) |
| G6-0505 | Mudrā chain · 16·17·18·19·20 | placed (§2 HH-46) |
| G6-0506 | Mudrā chain · 21–28 | placed (§2 HH-46) |
| G6-0507 | Mudrā chain · 29·30·31·32 | placed (§2 HH-46) |
| G6-0508 | Mudrā chain · 33 | placed (§2 HH-46) |
| G6-0509 | Manipura's ten Mudrā Śaktis order matches the chain | placed (§2 HH-20) |
| G6-0510 | Yantra facts from Shakti Function · āvaraṇa 1 | placed (§2 HH-59) |
| G6-0511 | Yantra facts from Shakti Function · āvaraṇa 2 | placed (§2 HH-59) |
| G6-0512 | Yantra facts from Shakti Function · āvaraṇa 3 | placed (§2 HH-59) |
| G6-0513 | Yantra facts from Shakti Function · āvaraṇa 4 | placed (§2 HH-59) |
| G6-0514 | Yantra facts from Shakti Function · āvaraṇa 5 | placed (§2 HH-59) |
| G6-0515 | Yantra facts from Shakti Function · āvaraṇa 6 | placed (§2 HH-59) |
| G6-0516 | Yantra facts from Shakti Function · āvaraṇa 7 | placed (§2 HH-59) |
| G6-0517 | Yantra facts from Shakti Function · āvaraṇa 8 | placed (§2 HH-59) |
| G6-0518 | Yantra facts from Shakti Function · āvaraṇa 9 | placed (§2 HH-59) |
| G6-0519 | Yantra facts from Shakti Function · āvaraṇa thresholds | placed (§2 HH-59) |
| G6-0520 | 52 one-line glosses for kp 1–52 | placed (§2 HH-44) |
| G6-0572 | Map gift #16 · Aatma's trikona — claim one, receive three | placed (§2 HH-27) |
| G6-0589 | Map gift #36 · Family question that opens her seat | placed (§2 HH-44) |
| G6-0590 | Map gift #37 · The ring's facts card | placed (§2 HH-59) |
| G6-0600 | Map gift #5 · The mudrā as the room's carried gesture | placed (§2 HH-46) |
| G6-0620 | Map C13 · Two Kāmeśvarīs | placed (§2 HH-89) |
| G6-0648 | ASG table · Mandala | placed (§2 HH-89) |
| G6-0684 | Walks · Threshold Invitations (body cues) | placed (§2 HH-05) |
| G6-0722 | Learning · yantra and relationship topics | not this world (beneath) |
| G6-0744 | ASG gift #20 · Vow You / Vow I as a paired recognition | not this world (well) |
| G6-0745 | ASG gift #21 · Threshold Invitations as body cues before a room | placed (§2 HH-05) |
| G6-0761 | ASG gift #37 · Learning's Kriyā Repertoire — 'door held open, never the watch' | not this world (modes) |
| G6-0762 | ASG gift #38 · L-1537 (102 Shaktis research) and L-1533 (16 Karṣiṇīs) | placed (§2 HH-59) |
| G6-0791 | Code core · ShaktiFactsCache.swift (211) · live Score per Śakti | placed (§2 HH-68) |
| G6-0792 | Code core · ShaktiBootstrap.swift (303) · offline seed of the 16 Karṣiṇīs | placed (§2 HH-89) |
| G6-0801 | Code core · HomeMemory.swift (200) · per-kp dwell memory | placed (§2 HH-49) |
| G6-0812 | Code core · SomaticRegion.swift (130) · his body as twelve regions of light | placed (§2 HP-08) |
| G6-0816 | Code core · HomeSoundService.swift (1177) · her carrier | placed (§2 HH-83) |
| G6-0817 | Code core · HomeVoice.swift (278) | placed (§2 HH-83) |
| G6-0819 | Code core · BijaSoundService.swift (318) · bīja tones and bells | placed (§2 HH-84) |
| G6-0820 | Code core · GlissandoVoice.swift (94) | placed (§2 HH-83) |
| G6-0826 | Code core · EnergyGift.swift (202) · the random gift | placed (§2 HH-47) |
| G6-0832 | Code core · TrinityOfGuidance.swift (186) · five faces | placed (§2 HH-42) |
| G6-0846 | Code core · HomeDwelling.swift (225) | placed (§2 HH-55) |
| G6-0847 | Code core · HomeMemoryStore.swift (136) | placed (§2 HH-49) |
| G6-0848 | Code core · SilenceDwell.swift (38) + MaunaSilence.swift (46) | placed (§2 HH-55) |
| G6-0851 | Code core · AtmosphereBackground.swift (73) | placed (§2 HP-21) |
| G6-0871 | Code gift #3 · Per-Śakti carrier from the varṇamālā | placed (§2 HH-68) |
| G6-0873 | Code gift #5 · Kīrtan / bhajan heart register with call-and-response | placed (§2 HH-45) |
| G6-0888 | Code gift #20 · HomeMemory + HomeDwelling + HomeVoice | placed (§2 HH-49) |
| G6-0895 | Code gift #27 · Trinity of Guidance faces | placed (§2 HH-42) |
| G6-0898 | Code gift #30 · Live Score per Śakti | placed (§2 HH-68) |
| G6-0899 | Code gift #31 · Related Śaktis → the sister door | placed (§2 HH-40) |
| G6-0904 | Code gift #36 · SomaticRegion body map + sensory doorways | placed (§2 HP-08) |
| G6-0905 | Code gift #37 · Random gift + morning summons | placed (§2 HH-47) |
| G6-0924 | Code C-3 · Ruling 4 elements (Ahaṅ fire, Nāma air, Ātma light, Amṛta water) | placed (§2 HH-88) |
| G6-0926 | Code C-5 · Shifted bīja series in ShaktiBootstrap | placed (§2 HH-89) |
| G6-0930 | Code C-6c · Restriction still enforced: three controls / few doors | placed (§2 HH-83) |
| G6-0933 | Code C-7 · Ruling 6: Sid, Arch, Karishma, Ashrey absent | placed (§2 HH-42) |
| G6-0960 | Homes file · HomeRooms.swift (286) | placed (§2 HH-07) |
| G6-0961 | Homes file · HomeWorlds.swift (329) | placed (§2 HH-32) |
| G6-0962 | Homes file · HomeGrammar.swift (931) | placed (§2 HH-29) |
| G6-0963 | Homes file · HomeAttribute.swift (930) | placed (§2 HH-31) |
| G6-0964 | Homes file · HomeGem.swift (125) | placed (§2 HH-32) |
| G6-0965 | Homes file · HomeBecoming.swift (211) | placed (§2 HH-30) |
| G6-0966 | Homes file · HomeWords.swift (130) | placed (§2 HH-36) |
| G6-0967 | Homes file · HomeDescent.swift (345) | placed (§2 HH-57) |
| G6-0970 | Homes file · HomeAfterEffect.swift (116) | placed (§2 HH-81) |
| G6-0972 | Homes file · RoomUnits.swift (555) | placed (§2 HH-08) |
| G6-0973 | Homes file · RoomMaterial.swift (537) | placed (§2 HH-08) |
| G6-0974 | Homes file · RoomScene.swift (1242) | placed (§2 HH-08) |
| G6-0975 | Homes file · RoomView.swift (498) | placed (§2 HH-85) |
| G6-0976 | Homes file · RoomLightPass.metal (162) | placed (§2 HH-32) |
| G6-0977 | Homes file · RoomLightRig.swift (264) | placed (§2 HH-32) |
| G6-0978 | Homes file · RoomShell.swift (263) | placed (§2 HH-28) |
| G6-0979 | Homes file · RoomAir.swift (1118) | placed (§2 HH-32) |
| G6-0980 | Homes file · RoomReversal.swift (335) | placed (§2 HH-30) |
| G6-0981 | Homes file · RoomApproach.swift (200) | placed (§2 HH-95) |
| G6-0982 | Homes file · DescentShaft.swift (257) | placed (§2 HH-57) |
| G6-0983 | Homes file · ContractRoom.swift (172) | placed (§2 HH-09) |
| G6-0984 | Homes file · EndlessRoom.swift (260) | placed (§2 HH-10) |
| G6-0985 | Homes file · ReleaseRoom.swift (170) | placed (§2 HH-11) |
| G6-0986 | Homes file · PressRoom.swift (277) | placed (§2 HH-12) |
| G6-0987 | Homes file · KnownRoom.swift (244) | placed (§2 HH-14) |
| G6-0988 | Homes file · MembraneRoom.swift (337) | placed (§2 HH-15) |
| G6-0989 | Homes file · TripleRoom.swift (269) | placed (§2 HH-16) |
| G6-0990 | Homes file · DissolveRoom.swift (608) | placed (§2 HH-17) |
| G6-0991 | Homes file · RingOne.swift (322) | placed (§2 HH-29) |
| G6-0992 | Homes file · SiddhiRoom.swift (261) | placed (§2 HH-18) |
| G6-0993 | Homes file · MatrkaRoom.swift (300) | placed (§2 HH-19) |
| G6-0994 | Homes file · MudraRoom.swift (416) | placed (§2 HH-20) |
| G6-0995 | Homes file · CrossingRoom.swift (504) | placed (§2 HH-21) |
| G6-0996 | Homes file · OuterRings.swift (435) | placed (§2 HH-29) |
| G6-0997 | Homes file · BodilessRoom.swift (392) | placed (§2 HH-22) |
| G6-0998 | Homes file · CosmicRoom.swift (541) | placed (§2 HH-23) |
| G6-0999 | Homes file · GivingRoom.swift (540) | placed (§2 HH-24) |
| G6-1000 | Homes file · RevealingRoom.swift (508) | placed (§2 HH-25) |
| G6-1001 | Homes file · SoundingRoom.swift (509) | placed (§2 HH-26) |
| G6-1002 | Homes file · SourcingRoom.swift (338) | placed (§2 HH-27) |
| G6-1006 | Homes parity · Resolution order authored → grammar → seat (H-RESOLVE) | placed (§2 HH-07) |
| G6-1007 | Homes parity · Authored rooms keyed by position: 1 contract, 2 endless, 3 release, 4 press | placed (§2 HH-07) |
| G6-1008 | Homes parity · M1–M8 mechanisms as Design drew them (H-MECH) | placed (§2 HH-08) |
| G6-1009 | Homes parity · Grammar: 50 tattva motions, first match wins (H-GRAMMAR) | placed (§2 HH-29) |
| G6-1010 | Homes parity · Archetype rooms rings 1–8 (siddhi / matrka / mudra / crossed / bodiless / c | placed (§2 HH-08) |
| G6-1011 | Homes parity · Every room reverses its premise at b (H-CLOCK) | placed (§2 HH-30) |
| G6-1012 | Homes parity · Adaptation clock 62 / 227 / 347; labels flip at 0.45 | placed (§2 HH-06) |
| G6-1013 | Homes parity · Rite of Entering threshold: 3 touch-paced beats (phrase, Devanāgarī written | placed (§2 HH-04) |
| G6-1014 | Homes parity · Beat indicator pips (R-10, H-AXIS) | placed (§2 HH-04) |
| G6-1015 | Homes parity · The point becomes her room: flight from the axis, fog swallow ×1.6, presenc | placed (§2 HH-03) |
| G6-1016 | Homes parity · Nine worlds as weather W1–W9 (H-WORLDS) | placed (§2 HH-32) |
| G6-1017 | Homes parity · World tempo on the world clock only; veil ×0.55 | placed (§2 HH-32) |
| G6-1018 | Homes parity · Gem diffusion; Crown sourceless (no key) | placed (§2 HH-32) |
| G6-1019 | Homes parity · Atmosphere hue port, ±7° jitter, Ring 2 cluster seeds | placed (§2 HH-32) |
| G6-1020 | Homes parity · Seat shape per ring (rite-core `room:`) | placed (§2 HH-28) |
| G6-1021 | Homes parity · Her attribute, the room's one actor: 26 forms, 52 keys, KIN, 15 tints, moun | placed (§2 HH-31) |
| G6-1022 | Homes parity · Physics drift on the whole building | placed (§2 HH-29) |
| G6-1023 | Homes parity · Descent "go deeper": 5 stations of the card as motion (H-DESCENT) | placed (§2 HH-57) |
| G6-1024 | Homes parity · Descent station 2 lights *her* body bar (Design defect) | placed (§2 HH-57) |
| G6-1025 | Homes parity · Doors: two neighbours; Ring 1 within family, Ring 2 within cluster first (§ | placed (§2 HH-40) |
| G6-1026 | Homes parity · Crossing to a neighbour "from where you stand", no cut | placed (§2 HH-40) |
| G6-1027 | Homes parity · Library folded *beneath* the room (§4.5, H-AXIS library) | placed (§2 HH-01) |
| G6-1028 | Homes parity · Well letter as a folded object in the room (§4.5) | placed (§2 HH-39) |
| G6-1029 | Homes parity · Portrait lines surfacing "at the pace of stillness" (brief; R-06) | placed (§2 HH-37) |
| G6-1030 | Homes parity · Return: compression 0.68ⁿ floor 0.36; head start 0.55·dwell capped at 221 s | placed (§2 HH-49) |
| G6-1031 | Homes parity · "you have stood here before" (once on return); floor traces (max 7); core l | placed (§2 HH-50) |
| G6-1032 | Homes parity · Withheld fifth / per-ring sound / carrier from syllable | placed (§2 HH-83) |
| G6-1033 | Homes parity · After-effect lighter / heavier / sharper / wider, decaying over minutes, ** | placed (§2 HH-81) |
| G6-1034 | Homes parity · Today: crown on her light, "she presides today", 6am handover | not this world (climb) |
| G6-1036 | Homes parity · Axis presences: 102 points of light, authored ones larger | placed (§2 HH-03) |
| G6-1037 | Homes parity · Climb rail of nine (region words, met tick) | not this world (climb) |
| G6-1038 | Homes parity · Ring Worlds mechanisms (scatter, follow / whisper, triad union, earth-city, | not this world (climb) |
| G6-1039 | Homes parity · Gates of Release on ring crossings | not this world (climb) |
| G6-1040 | Homes parity · Ring 9 Praveśa / centre bloom / Mauna | not this world (climb) |
| G6-1041 | Homes parity · **Rite of Entering light room R-09** (one-point seat interior: farL 20 → 82 | placed (§2 HH-60) |
| G6-1042 | Homes parity · R-11 dwelling overlay: Devanāgarī cut into the wall above the light (30 px) | placed (§2 HH-64) |
| G6-1043 | Homes parity · R-02 rates (fast / even / slow / late: adaptation ×0.72–1.38) | placed (§2 HH-06) |
| G6-1044 | Homes parity · Personal Connection marginalia (the 9 paragraphs) | placed (§2 HH-38) |
| G6-1045 | Homes parity · Bīja-locked visual rhythm; tattva as light / material modifier (brief gaps) | placed (§2 HH-34) |
| G6-1046 | Homes parity · Reduced motion "longer and quantized, never disabled" (inv. 4) | placed (§2 HH-85) |
| G6-1048 | Homes view path step 1 | placed (§2 HH-01) |
| G6-1049 | Homes view path step 2 | placed (§2 HH-01) |
| G6-1050 | Homes view path step 3 | placed (§2 HH-01) |
| G6-1051 | Homes view path step 4 | placed (§2 HH-01) |
| G6-1052 | Homes view path step 5 | placed (§2 HH-01) |
| G6-1053 | Homes view path step 6 | placed (§2 HH-01) |
| G6-1054 | Homes view path step 7 | placed (§2 HH-03) |
| G6-1055 | Homes · why it looks basic (a) | placed (§2 HH-01) |
| G6-1056 | Homes · why it looks basic (b) | placed (§2 HH-08) |
| G6-1057 | Homes · why it looks basic (c) | placed (§2 HH-60) |
| G6-1058 | Homes · why it looks basic (d) | placed (§2 HH-85) |
| G6-1059 | Homes short answer · Śakti Home looks like a basic page | placed (§2 HH-01) |
| G6-1060 | Homes short answer · reachability | placed (§2 HH-60) |
| G6-1061 | Homes short answer · rooms keyed by kp | placed (§2 HH-07) |
| G6-1062 | Homes upgrade C1 · Make the room the Home and the Detail the library | placed (§2 HH-01) |
| G6-1063 | Homes upgrade C2 · Lift the binding condition in the mechanism layer | placed (§2 HH-08) |
| G6-1064 | Homes upgrade C3 · Show her attribute as a lit, aniconic performing shape | placed (§2 HH-31) |
| G6-1065 | Homes upgrade C4 · Build the Rite light room (R-09/R-11) as a mode of the Home | placed (§2 HH-60) |
| G6-1066 | Homes upgrade C5 · Doors as Design ruled | placed (§2 HH-40) |
| G6-1067 | Homes upgrade C6 · Descent: restore station objects and the Rite's chambers | placed (§2 HH-57) |
| G6-1068 | Homes upgrade C7 · Return: 'you have stood here before', floor traces, forget-me | placed (§2 HH-50) |
| G6-1069 | Homes upgrade C8 · After-effect: the 'her siddhi is still on the instrument' line | placed (§2 HH-81) |
| G6-1070 | Homes upgrade C9 · Reduce motion: quantized adaptation | placed (§2 HH-85) |
| G6-1071 | Homes upgrade C10 · Sound per room: verify the withheld fifth | placed (§2 HH-83) |
| G6-1073 | Homes gap · RoomMaterial still calls itself binding | placed (§2 HH-08) |
| G6-1074 | Homes gap · HomeRooms placeholder types dead | placed (§2 HH-07) |
| G6-1075 | Homes gap · Attribute tint computed, never rendered | placed (§2 HH-31) |
| G6-1076 | Homes gap · ClimbLights ignores met on purpose | placed (§2 HH-50) |
| G6-1077 | Homes gap · Story-flavoured lines in Homes | to Bindu Feed (§6) |
| G7-0104 | Rite foot: I feel her pill and seat door | placed (§2 HH-94) |
| G7-0163 | Route today: Rite -> Her room | placed (§2 HH-82) |
| G7-0170 | Route today: Mandala -> Her room | placed (§2 HH-82) |
| G7-0183 | Route today: Chakra room -> ChakraRoomExitView (HerRoomPassage / ChakraRingClimb / PlayFie | placed (§2 HH-82) |
| G7-0312 | HerRoomDoor: every way in passes the rite | placed (§2 HH-04) |
| G7-0313 | HerRoomPassage fetches all rows per render | placed (§2 HH-90) |
| G7-0314 | Rite of entering three beats | placed (§2 HH-04) |
| G7-0315 | Rite of entering prompts | placed (§2 HH-04) |
| G7-0316 | Rite of entering name parts | placed (§2 HH-04) |
| G7-0317 | Rite strike pitch from HomeCarrier | placed (§2 HH-04) |
| G7-0318 | Rite of entering: no beat indicator, no visit count, no welcome back | placed (§2 HH-04) |
| G7-0319 | RiteOfEnteringView layers | placed (§2 HH-95) |
| G7-0320 | TheDescent five stations | placed (§2 HH-57) |
| G7-0321 | Rooms layer two-gesture vocabulary | placed (§2 HH-80) |
| G7-0322 | TheStay bookkeeping | placed (§2 HH-80) |
| G7-0323 | TheWayOut held exit | placed (§2 HH-80) |
| G7-0324 | TheEdgeWayOut | placed (§2 HH-80) |
| G7-0325 | NeighbourDoorsView corridor | placed (§2 HH-40) |
| G7-0326 | RoomWordsView | placed (§2 HH-36) |
| G7-0327 | ScoreLightVeil | placed (§2 HH-32) |
| G7-0328 | HerSiddhiLingers after-effect | placed (§2 HH-81) |
| G7-0329 | RoomGameLayer Trinity voice and activation | placed (§2 HH-41) |
| G7-0330 | Activation cycle gesture: fire | placed (§2 HH-41) |
| G7-0331 | Activation cycle gesture: water | placed (§2 HH-41) |
| G7-0332 | Activation cycle gesture: air | placed (§2 HH-41) |
| G7-0333 | Activation cycle gesture: earth | placed (§2 HH-41) |
| G7-0334 | Activation cycle gesture: ether | placed (§2 HH-41) |
| G7-0335 | Activation cycle gesture: light | placed (§2 HH-41) |
| G7-0336 | Activation cycle gesture: presence (rings 7-9) | placed (§2 HH-41) |
| G7-0337 | Activation cycle recession and close | placed (§2 HH-41) |
| G7-0338 | Activation cycle source quote | placed (§2 HH-41) |
| G7-0340 | WorldClimbView gestures and touching a light | placed (§2 HH-03) |
| G7-0357 | Two room systems: 102 immersive, 33 text | not this world (the-33) |
| G7-0361 | Chakra room doors section | placed (§2 HH-93) |
| G7-0484 | Hold times disagree | placed (§2 HH-97) |
| G7-0489 | Restrictions still written as law in Play/Rooms code | placed (§2 HH-80) |
| G7-0540 | Heart Register ring 2 only | placed (§2 HH-45) |
| G7-0567 | Spike: GarimaCanvasRoom (renderer B) | placed (§2 HH-12) |
| G7-0568 | Spike fixture appreciation text unverified | placed (§2 HH-12) |
| G7-0569 | Spike: GarimaSceneKitRoom (renderer A) | placed (§2 HH-12) |
| G7-0570 | GarimaSceneKitRoom cluster no-op | placed (§2 HH-12) |
| G7-0571 | ATTR_TINT table for 15 positions | placed (§2 HH-12) |
| G7-0573 | Spike verdict: Design room portable both ways | placed (§2 HH-12) |
| G7-0574 | Room renderer tables lifted from the spike | placed (§2 HH-12) |
| G7-0620 | Ring fingerprints (sister divergence engine) | placed (§2 HH-91) |
| G7-0645 | UI: TheWayInUITests walk | placed (§2 HH-82) |
| G7-0668 | HomeDwellingTests | placed (§2 HH-55) |
| G7-0669 | HomeMemoryTests | placed (§2 HH-49) |
| G7-0690 | HomesHarnessTests | placed (§2 HH-91) |
| G7-0691 | HomesWaveOneTests | placed (§2 HH-32) |
| G7-0692 | HomeGrammarTests | placed (§2 HH-29) |
| G7-0693 | HomeAttributeTests | placed (§2 HH-31) |
| G7-0694 | HomeDescentTests | placed (§2 HH-57) |
| G7-0695 | HomeSoundTests | placed (§2 HH-83) |
| G7-0696 | HomeVoiceTests | placed (§2 HH-83) |
| G7-0698 | RoomSceneTests | placed (§2 HH-08) |
| G7-0699 | RoomCaptureTests | placed (§2 HH-33) |
| G7-0700 | CrossingRoomTests (Ring 2) | placed (§2 HH-21) |
| G7-0701 | SiddhiRoomTests (Ring 1 kp 1-10) | placed (§2 HH-18) |
| G7-0702 | MatrkaRoomTests (kp 11-18) | placed (§2 HH-19) |
| G7-0703 | MudraRoomTests (kp 19-28) | placed (§2 HH-20) |
| G7-0704 | BodilessRoomTests (Ring 3) | placed (§2 HH-22) |
| G7-0705 | CosmicRoomTests (Ring 4) | placed (§2 HH-23) |
| G7-0706 | GivingRoomTests (Ring 5) | placed (§2 HH-24) |
| G7-0707 | RevealingRoomTests (Ring 6) | placed (§2 HH-25) |
| G7-0708 | SoundingRoomTests (Ring 7) | placed (§2 HH-26) |
| G7-0709 | SourcingRoomTests (Ring 8) | placed (§2 HH-27) |
| G7-0710 | GateRoomTests (Laghima kp 3 and Garima kp 4 ('the Gate')) | placed (§2 HH-91) |
| G7-0711 | DissolveRoomTests (kp 102) | placed (§2 HH-17) |
| G7-0712 | WholeInstrumentTests | placed (§2 HH-07) |
| G7-0713 | RiteOfEnteringTests | placed (§2 HH-91) |
| G7-0714 | TheWayInTests reachability core | placed (§2 HH-82) |
| G7-0715 | GateLookTests | placed (§2 HH-33) |
| G7-0716 | Garima spike suites (renderer variants) | placed (§2 HH-12) |
| G7-0968 | Test gift: The full sound table | placed (§2 HH-83) |
| G7-0977 | Test gift: 102 rooms by position | placed (§2 HH-07) |
| G7-0978 | Test gift: Ring archetype rooms | placed (§2 HH-07) |
| G7-0979 | Test gift: Room reversal lines | placed (§2 HH-30) |
| G7-0980 | Test gift: HomeAfterEffect | placed (§2 HH-81) |
| G7-0981 | Test gift: 26 attribute forms and 15 tints | placed (§2 HH-31) |
| G7-0982 | Test gift: Descent beneath her room | placed (§2 HH-57) |
| G7-0983 | Test gift: Rite of entering (optional) | placed (§2 HH-04) |
| G7-0984 | Test gift: HomeMemory gentle compression | placed (§2 HH-49) |
| G7-0985 | Test gift: The Gate rooms Laghima / Garima | placed (§2 HH-30) |
| G7-0989 | Test gift: 36 games addressed to seats | placed (§2 HP-24) |
| G7-0994 | Test gift: TrinityOfGuidance faces | placed (§2 HH-42) |
| G7-1001 | Test gift: GraceChannel across sister apps | placed (§2 HH-48) |
| G7-1004 | Test gift: Gratitude, gently | placed (§2 HH-48) |
| G7-1018 | Test gift: G5 performance census and renderer spikes | placed (§2 HH-91) |
| G7-1019 | Test gift: Design's three registers as a room test | placed (§2 HH-91) |
| G7-1020 | Test gift: GateLook legibility register as per-room test | placed (§2 HH-33) |
| G7-1025 | Light bounds far below Design | placed (§2 HH-33) |
| G7-1027 | 'The Gate' means four things | placed (§2 HH-91) |
| G7-1029 | Ruling 4 elements conflict with tattva physics | placed (§2 HH-88) |
| G7-1033 | Gating surviving in mechanisms | placed (§2 HH-54) |
| G7-1034 | Open defect carried as expected failure | placed (§2 HH-91) |
| G1-0034 | Not in the Homes handoff: Mandala, Today, Portrait, Well writing, Descent film, Homecoming | placed (§2 HH-99) |
| G1-0484 | Veil name (ether): her name as full-screen backdrop door to Her Presence | placed (§2 HP-28) |
| G1-0487 | 'I feel her' CTA (red gradient pill) + '{kp} of 102 · bīja {bija}' footer | placed (§2 HP-18) |
| G1-0488 | Her Presence Detail: 'scale is reverence' — inherits the day's atmosphere, time-relit | placed (§2 HP-01) |
| G1-0489 | Detail hero: '{Ordinal} Āvaraṇa · {form}', name h1, phonetic, quality, cluster | placed (§2 HP-04) |
| G1-0490 | Detail Portrait 'the soul, leading' — description or personalConnection | placed (§2 HP-05) |
| G1-0491 | Detail Somatic signature — somaticPoetry (ring 2 only) | placed (§2 HP-08) |
| G1-0492 | Bīja glyph 84px — 'tap to sound her' with pulse and three rings | placed (§2 HP-09) |
| G1-0493 | Detail Appreciation, Embodiment pill, Her moments, 'go deeper' disclosure rows | placed (§2 HP-10) |
| G1-0494 | Recognition Moment varies by element (focal, ripple, sigil/bīja response) | placed (§2 HP-18) |
| G1-0495 | Recognition staged arrival: name → phrase → 'she was felt here · time' → 'and she felt you | placed (§2 HP-18) |
| G1-0496 | Recognition interaction: tap anywhere closes after 300ms; note saved per keystroke | placed (§2 HP-18) |
| G1-0497 | Recognition close: ceremony gathers into the point (lrCollapse .62 s), hands off to Portra | placed (§2 HP-19) |
| G1-0508 | Tap a seat: fly to seat (scale 3.0 at h×.36); tap again → Her Presence; ring 9 → descent | placed (§2 HH-03) |
| G1-0510 | Significance card on focus (kicker, name, quality, 'threaded to N sisters', bīja 'sound he | placed (§2 HP-28) |
| G1-0521 | Her Moments list — 'she was felt here · {when}' + moon phase + note | placed (§2 HP-13) |
| G1-0525 | The Memory: Portrait Mandala — 'your face in the instrument', 'she is felt, not measured' | not this world (memory) |
| G1-0526 | Memory settle: her gold point flies from the bindu to her seat, halo blooms (3400ms) | placed (§2 HP-19) |
| G1-0527 | Portrait recency warmth/cooling not implemented (DESIGN_SPEC Phase 5) | not this world (memory) |
| G1-0547 | FELT level: three rings converge inward; 'and she felt you back' at 2400ms; 'her point is  | placed (§2 HP-18) |
| G1-0555 | Direction II · The Portrait Becomes the Home — your Śrī Yantra filling in petal by petal o | not this world (memory) |
| G1-0574 | DESIGN_SPEC port targets §2.1–2.8 (Atmosphere, TimeVariant, day cycle, six archetypes, Det | placed (§2 HP-01) |
| G1-0579 | Phase 5 Portrait: 102 points near-dark brighten with felt-count, warmer when recent, cooli | not this world (memory) |
| G1-0580 | Stretch: continuous ring drone; WidgetKit today's Śakti; descent as remembered film; expor | not this world (memory) |
| G1-0586 | Every way into Her Presence and into Recognition | placed (§2 HP-28) |
| G1-0587 | Recognition → Portrait handoff as one continuous gesture (port as one transition) | placed (§2 HP-19) |
| G1-0628 | Mode Recognition — The Catch: long-press anywhere; 360px sheet; 68px catch circle | not this world (modes) |
| G1-0667 | Giant bīja texture behind the screen (280–360px gold at ~.07) | placed (§2 HP-03) |
| G1-0669 | v1 ShaktiDetail (Ātmākarṣiṇī): Quality, Somatic Signature, Bīja tap-to-hear, Esoteric Tatt | placed (§2 HP-01) |
| G1-0670 | v1 RecognitionMoment: bīja 360px behind, 4 ripples, 'Logged · 9:41 AM', 'And she felt you  | placed (§2 HP-18) |
| G1-0677 | QuickRecognition — The Catch: one tap, sheet rises; 'and she felt you back' ~1.5 s after t | not this world (modes) |
| G1-0680 | ShaktiDetailV2 Ātmākarṣiṇī — five new fields as reading experience (etymology, appreciatio | placed (§2 HP-01) |
| G1-0703 | RingTwoWorld — the Inhabited Lotus: press a petal to invoke, others mute ×0.18; release ·  | not this world (rings) |
| G1-0730 | Recognition (Catch) screen details: mandala behind, today petal glow, 68px catch circle; ' | not this world (modes) |
| G1-0742 | MEM-1 Portrait Mandala — petals lit by your memory; 'Your face in the instrument' (shows c | not this world (memory) |
| G1-0743 | MEM-2 Petal Biography — her biography with you (stat grid, moments she was here) | not this world (memory) |
| G1-0765 | REL-3 Shakti's Carriers — who carries her into your life (reverse lookup; '‹ Portrait') | not this world (relationship) |
| G1-0778 | Recognition is the spine feeding every layer (Catch → Smṛti → Portrait → Thresholds → Atla | not this world (relationship) |
| G2-0008 | DS-07 status opacity ladder | placed (§2 HP-12) |
| G2-0009 | DS-08 status transition ceremony (tap pill) | placed (§2 HP-12) |
| G2-0020 | DS-19 Recognition Moment | placed (§2 HP-18) |
| G2-0100 | FB-22 recognition write + status thresholds | placed (§2 HP-12) |
| G2-0104 | FB-26 Portrait intensity formula | not this world (memory) |
| G2-0110 | UXA-05 status pill no affordance | placed (§2 HP-12) |
| G2-0123 | DA1-09 Call 2 status pill display vs gesture | placed (§2 HP-12) |
| G2-0148 | MBB-10 calls woven in (July) | placed (§2 HP-01) |
| G2-0152 | MBB-14 Portrait 102 points, no numbers | not this world (memory) |
| G2-0156 | DA2-01 presence at scale missing | placed (§2 HP-01) |
| G2-0163 | DA2-08 Today dead end → her name a door | placed (§2 HP-28) |
| G2-0178 | FH-10 Detail soul first + crossing press-and-hold | placed (§2 HP-01) |
| G2-0206 | RBB-13 Detail always reports .mandala source | placed (§2 HP-27) |
| G2-0436 | C2 status advance | placed (§2 HP-12) |
| G3-0181 | T-ONE The One: Higher-Self naming ceremony | not this world (relationship) |
| G3-0381 | C-1134 Name meaning across existence; Atma-Brahman part and whole | to Bindu Feed (§6) |
| G3-0382 | C-1135 Two faces: individual Atman / part of the whole | placed (§2 HP-03) |
| G4-0010 | Ensemble dancer spec: Bindu (V2 template numbers) | placed (§2 HH-69) |
| G4-0011 | Ensemble dancer spec: Gaia (V2 template numbers) | placed (§2 HH-69) |
| G4-0012 | Ensemble dancer spec: Sid (V2 template numbers) | placed (§2 HH-69) |
| G4-0013 | Ensemble dancer spec: Arch (V2 template numbers) | placed (§2 HH-69) |
| G4-0014 | Ensemble dancer spec: Karishma (V2 template numbers) | placed (§2 HH-69) |
| G4-0015 | Ensemble dancer spec: Sakshi (V2 template numbers) | placed (§2 HH-69) |
| G4-0016 | Ensemble dancer spec: Ashrey (V2 template numbers) | placed (§2 HH-69) |
| G4-0019 | Karishma is inverse — 'the architecture of grace' (lesson #18) | placed (§2 HH-69) |
| G4-0027 | Bloom five stages (dot → ghost → orbital rings → rays+particles+edge glow → crown mandala) | placed (§2 HH-70) |
| G4-0233 | Lalita as the Mirror — the eighth presence (ruling 6 proposal) | placed (§2 HH-69) |
| G4-0303 | Performer state machine: elapsed, currentPhase, crescendoModulator, energy, beatPulse; arc | placed (§2 HH-69) |
| G4-0307 | Oracle listening void: idle fog 14 s; timed reply layers (Verb 0.4 s, track 2.2 s, why 3.4 | placed (§2 HP-02) |
| G4-0322 | Score bloom contract: 5 stages, rise 0.06, fall 0.012, thresholds .15/.3/.5/.7 — 'Rises fa | placed (§2 HH-70) |
| G4-0460 | Seven dancers + Shweta, Neev, Lalita as the named ensemble (ruling 6 already specified); n | placed (§2 HH-69) |
| G4-0499 | Voice: Lalita files unrecorded; Oracle uses Claude Haiku (generated text) — check against  | rejected — floor: no generated voice (no recordings exist) |
| G4-0589 | Dancing Bindu: Lissajous orbit (smoothEnergy, gain, beat Hz), beat rings from position, 28 | placed (§2 HH-69) |
| G4-0620 | Mirror times as cue for the Relationship Field's two-sided view | not this world (relationship) |
| G4-0626 | 10-stream frame data for 47 tracks as ready performance substrate (bundle or fetch; file w | not this world (the-33) |
| G4-0702 | Sub-template/move: portrait--voice | placed (§2 HP-03) |
| G5-0087 | The Turning: colour through staying + ∞ path | placed (§2 HP-07) |
| G5-0092 | Hold to witness | placed (§2 HP-07) |
| G5-0182 | A portrait made of attention | not this world (memory) |
| G5-0338 | Law 25: a presence is one identity, seen whole | placed (§2 HP-03) |
| G5-0365 | S16 Portrait shape | not this world (memory) |
| G5-0374 | A hue from a name | not this world (relationship) |
| G5-0378 | The walked block, station transition, reading sheet, station card | placed (§2 HH-02) |
| G5-0439 | Felt here, and felt back (Recognition) | placed (§2 HP-18) |
| G5-0468 | The glyph is the card | placed (§2 HP-03) |
| G5-0474 | Each voice on its own clock | placed (§2 HP-03) |
| G5-0475 | Identity header (disc, name, role, principle) | placed (§2 HP-03) |
| G5-0476 | Silent voice card | placed (§2 HP-23) |
| G5-0518 | Visual language for Her Presence (portrait): feed identity-header grammar on mandala token | placed (§2 HP-21) |
| G5-0583 | A Strange Voice (and the 72 BPM heartbeat) | placed (§2 HP-22) |
| G5-0594 | Vibrating heart at 0.1 Hz | placed (§2 HP-03) |
| G5-0660 | Cinematic viewer (focal zoom, swipe, cross-dissolve) | placed (§2 HP-03) |
| G5-0689 | Wake Lock in still phases (Guard 14) | placed (§2 HH-87) |
| G5-1174 | Topic: The Black Madonna Tradition | to Bindu Feed (§6) |
| G6-0711 | Identity Archetype declaration · Karishma | not this world (relationship) |
| G6-0712 | Identity Archetype declaration · Sid | not this world (relationship) |
| G6-0713 | Identity Archetype declaration · Bindu | not this world (relationship) |
| G6-0714 | Identity Archetype declaration · Lalita | not this world (relationship) |
| G6-0715 | Identity Archetype declaration · Arch | not this world (relationship) |
| G6-0716 | Identity Archetype declaration · Gaia | not this world (relationship) |
| G6-0717 | Identity Archetype declaration · Sakshi | not this world (relationship) |
| G6-0718 | Identity Archetype declaration · Ashrey | not this world (relationship) |
| G6-0719 | Identity Archetype declaration · Higher Self | not this world (relationship) |
| G6-0725 | ASG gift #1 · The inner ring of six (+ Neev, Shweta) | not this world (relationship) |
| G6-0729 | ASG gift #5 · Portrait depth as brightness | not this world (relationship) |
| G6-0799 | Code core · Cluster.swift (41) | placed (§2 HP-04) |
| G6-0808 | Code core · RecognitionEntry.swift (66) | placed (§2 HP-18) |
| G6-0811 | Code core · ShaktiStatus.swift (35) | placed (§2 HP-12) |
| G6-0818 | Code core · HeartRegister.swift (275) · kīrtan / bhajan register | placed (§2 HH-45) |
| G6-0837 | Code core · WagerStore.swift (124) | placed (§2 HP-15) |
| G6-0866 | Code core · ShaktiBootstrap seeds progress statuses on fresh install | placed (§2 HP-12) |
| G6-0907 | Code gift #39 · Wager → notice | placed (§2 HP-15) |
| G6-0935 | Code C-9 · 'Nothing scores him' vs ShaktiStatus ladder | placed (§2 HP-12) |
| G6-0940 | Code C-12a · WagerStore misreads C-1195 | placed (§2 HP-15) |
| G6-1072 | Her Presence parity (ShaktiDetailView vs 02 L-13) | placed (§2 HP-01) |
| G7-0005 | Global presenters at root | placed (§2 HH-47) |
| G7-0018 | Mandala tap logic and flyTo | placed (§2 HH-03) |
| G7-0028 | lalitaShakti falls back to shaktis.last | placed (§2 HP-27) |
| G7-0092 | Lalita source bloom and returning field | not this world (home) |
| G7-0093 | Lalita source words | not this world (home) |
| G7-0095 | SignificanceCard content | placed (§2 HP-28) |
| G7-0133 | Recognition timeline and the two lines | placed (§2 HP-18) |
| G7-0134 | Recognition practice data first | placed (§2 HP-18) |
| G7-0135 | Recognition close sequence | placed (§2 HP-18) |
| G7-0136 | Recognition kp fallback position + 28 | placed (§2 HP-27) |
| G7-0137 | Recognition settles to Memory only from Today | placed (§2 HP-19) |
| G7-0138 | Recognition six natures exact | placed (§2 HP-18) |
| G7-0139 | RecognitionLight beyond Design | placed (§2 HP-18) |
| G7-0156 | Route today: Root -> ShaktiDetail ('the gift') | placed (§2 HH-47) |
| G7-0161 | Route today: Rite -> RecognitionMomentView | placed (§2 HP-28) |
| G7-0162 | Route today: Rite -> ShaktiDetail ('today') | placed (§2 HP-28) |
| G7-0169 | Route today: Mandala -> ShaktiDetail | placed (§2 HP-28) |
| G7-0181 | Route today: Lalita source -> ShaktiDetail | placed (§2 HP-28) |
| G7-0208 | Move off the Mandala: Lalita source | not this world (home) |
| G7-0235 | PlayAddressBook: every one of 102 has a game door | placed (§2 HP-24) |
| G7-0306 | Leela arrival hands to Recognition of kp 102 | placed (§2 HP-28) |
| G7-0518 | Recognition the Catch not on mode door | not this world (modes) |
| G7-0519 | Portrait mandala geometry and layers | not this world (memory) |
| G7-0527 | Portrait petals not tappable | not this world (memory) |
| G7-0539 | Where She Speaks body of light | placed (§2 HP-08) |
| G7-0550 | ShaktiDetailView sections | placed (§2 HP-01) |
| G7-0551 | Embodiment readiness count-gated | placed (§2 HP-12) |
| G7-0552 | HerMomentsList uses floor line as timestamp prefix | placed (§2 HP-13) |
| G7-0553 | HerDeepening layers withheld by visit count | placed (§2 HP-14) |
| G7-0554 | HerDoorways: doorway, seal, wager | placed (§2 HP-15) |
| G7-0555 | HerWitnessPage: One-Page Answer and Witness Page | placed (§2 HP-16) |
| G7-0603 | Her deepening by his choice | placed (§2 HP-14) |
| G7-0604 | Embodiment crossing chosen by him | placed (§2 HP-12) |
| G7-0612 | RecognitionLines harness | placed (§2 HP-18) |
| G7-0630 | Snapshot baseline: detail.geom | placed (§2 HP-26) |
| G7-0633 | Snapshot baseline: recognition.geom | placed (§2 HP-26) |
| G7-0640 | UI: BinduMandalaUITests | placed (§2 HP-18) |
| G7-0646 | UI: AccessibilityReachTests | placed (§2 HP-26) |
| G7-0649 | UI: TheLibraryFoldUITests | placed (§2 HP-26) |
| G7-0670 | WaveSixMemoryTests | not this world (memory) |
| G7-0688 | ShaktiStatusTests | placed (§2 HP-12) |
| G7-0717 | RecognitionNatureTests | placed (§2 HP-18) |
| G7-0718 | TheLibraryFoldTests | placed (§2 HP-26) |
| G7-0719 | SomaticRegionTests | placed (§2 HP-08) |
| G7-0864 | Floor test: LawsTests.swift:1453 | placed (§2 HP-18) |
| G7-0865 | Floor test: LawsTests.swift:1483 | placed (§2 HP-18) |
| G7-0866 | Floor test: LawsTests.swift:1540 | placed (§2 HP-18) |
| G7-0867 | Floor test: BinduMandalaUITests.swift:38 | placed (§2 HP-18) |
| G7-0868 | Floor test: AccessibilityReachTests.swift:481 | placed (§2 HP-18) |
| G7-0869 | Floor test: RecognitionNatureTests timeline | placed (§2 HP-18) |
| G7-0975 | Test gift: DayLight Rite composition | not this world (today-rite) |
| G7-0976 | Test gift: Recognition's six natures with timeline | placed (§2 HP-18) |
| G7-0995 | Test gift: ThreePools routing | not this world (memory) |
| G7-0999 | Test gift: Witness pages, Garland Recited, Day Offered | placed (§2 HP-16) |
| G7-1006 | Test gift: The Wager | placed (§2 HP-15) |
| G7-1010 | Test gift: Living Mandala Portrait | not this world (memory) |
| G7-1012 | Test gift: HerDeepening layers offered freely | placed (§2 HP-14) |
| G7-1013 | Test gift: Somatic body map | placed (§2 HP-08) |
| G7-1032 | ShaktiStatus advance-only ladder | placed (§2 HP-12) |

## Appendix A · The 102 rooms, one line per kp

Columns from Design's H-TABLE (01-homes:482–583): card name (display uses the Mandala row's name by kp), room (authored or archetype), physics (the 50-motion classifier; kp 69, 76 and 96 use the code's three appended rules), altitude, attribute key → form, tint, syllable, carrier Hz (ring root × just interval × 2), hue (Atmosphere with ±7° jitter). Doors follow Design's rule: Ring 1 within family, Ring 2 within cluster, the other rings round their own ring. Added by this map's rulings (§7 C1, C2): rate, the first adaptation in the Room (62 × rate; the Light Room uses 90 × rate) and the aperture face. Every room's hold is 165 s and its second adaptation 120 s. Seat shape and after-effect follow the ring (R1 square · R2 petal16 · R3 petal8 · R4/6/8 tri-up · R5/7 tri-down · R9 circle; after R1 sharper · R2 wider · R3 lighter · R4 wider · R5 sharper · R6 heavier · R7 wider · R8 lighter · R9 wider).

| kp | name | ring | room | physics | rate | adapt s | alt | attribute → form | aperture | tint | syllable | carrier Hz | hue° | doors L/R | near → deep |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Aṇimā | 1 | CONTRACT (authored) (Design Axis lost it by name) | shrink | fast | 44.6 | 0.1 | noose → noose | point | 0xf2ecd8 | — | 55.00 | 38.65 | 10/2 | the walls close while you stand still → the point was a door all along |
| 2 | Mahimā | 1 | ENDLESS (authored) | widen | even | 62.0 | 0.5 | goad → goad | point | — | — | 55.00 | 35.31 | 1/3 | no far wall · it never arrives → you were never inside anything |
| 3 | Laghimā | 1 | RELEASE (authored) | lift | even | 62.0 | 0.6 | veil → palm | lens | — | — | 55.00 | 31.96 | 2/4 | the floor has let go → the room has let go of itself |
| 4 | Garimā | 1 | PRESS (authored) | settle | slow | 85.6 | 0.94 | palm → palm | lens | 0xb8263c | — | 55.00 | 28.62 | 3/5 | the ceiling is coming down → the weight was holding you all along |
| 5 | Īśitva | 1 | siddhi · lent | rise | even | 62.0 | 0.1 | sceptre → sceptre | band | — | — | 55.00 | 39.27 | 4/6 | sovereignty · lent, not shown → the capacity was never lent |
| 6 | Vaśitva | 1 | KNOWN (authored) (Design Axis lost it by name) | align | late | 69.4 | 0.34 | noose → noose | point | — | — | 55.00 | 35.92 | 5/7 | the room exists only where attention rests → it has turned, and it rests on you |
| 7 | Prākāmya | 1 | siddhi · lent | incline | slow | 85.6 | 0.6 | bow → bow | band | 0xff7a3c | — | 55.00 | 32.58 | 6/8 | irresistible will · lent, not shown → the capacity was never lent |
| 8 | Bhukti | 1 | siddhi · lent | lean | slow | 85.6 | 0.66 | cup → cup | tri-down | — | — | 55.00 | 29.23 | 7/9 | enjoyment · lent, not shown → the capacity was never lent |
| 9 | Icchā | 1 | siddhi · lent | incline | slow | 85.6 | 0.46 | lotus → lotus | ring8 | — | — | 55.00 | 39.89 | 8/10 | willingness · lent, not shown → the capacity was never lent |
| 10 | Prāpti | 1 | siddhi · lent | fill | slow | 85.6 | 0.5 | hook → goad | point | — | — | 55.00 | 36.54 | 9/1 | reach · lent, not shown → the capacity was never lent |
| 11 | Brāhmī | 1 | mātṛkā · letters (n=5) | sound | even | 62.0 | 0.34 | rosary → rosary | ring16 | — | Aṃ | 110.00 | 33.19 | 18/12 | creation · Aṃ → the letters were never separate from the voice |
| 12 | Māheśvarī | 1 | mātṛkā · letters (n=8) | open | even | 62.0 | 0.34 | trident → trident | triad | — | Kaṃ | 137.50 | 29.85 | 11/13 | witness · Kaṃ → the letters were never separate from the voice |
| 13 | Kaumārī | 1 | mātṛkā · letters (n=11) | flare | fast | 44.6 | 0.34 | spear → trident | triad | 0xffb45c | Caṃ | 183.33 | 40.50 | 12/14 | fierce youth · Caṃ → the letters were never separate from the voice |
| 14 | Vaiṣṇavī | 1 | mātṛkā · letters (n=14) | sustain | slow | 85.6 | 0.46 | discus → trident | ring8 | — | Ṭaṃ | 123.75 | 37.16 | 13/15 | preservation · Ṭaṃ → the letters were never separate from the voice |
| 15 | Vārāhī | 1 | mātṛkā · letters (n=5) | settle | slow | 85.6 | 0.66 | plough → plough | band | 0x6a5f78 | Taṃ | 165.00 | 33.81 | 14/16 | dissolution · Taṃ → the letters were never separate from the voice |
| 16 | Indrāṇī | 1 | mātṛkā · letters (n=8) | lean | slow | 85.6 | 0.46 | vajra → vajra | point | — | Paṃ | 110.00 | 30.46 | 15/17 | heart-sovereignty · Paṃ → the letters were never separate from the voice |
| 17 | Cāmuṇḍā | 1 | mātṛkā · letters (n=11) | dissolve | late | 69.4 | 0.5 | skullcup → skullcup | tri-down | 0xd8d2c4 | Yaṃ | 146.67 | 41.12 | 16/18 | liberation · Yaṃ → the letters were never separate from the voice |
| 18 | Mahālakṣmī | 1 | mātṛkā · letters (n=14) | fill | slow | 85.6 | 0.5 | lotus → lotus | ring8 | 0xffd76a | Aim | 110.00 | 37.77 | 17/11 | wholeness · Aim → the letters were never separate from the voice |
| 19 | Sarva-Saṅkṣobhiṇī | 1 | mudrā · seal you stand inside | stir | fast | 44.6 | 0.5 | seal → seal | lens | — | — | 55.00 | 34.43 | 28/20 | stirring · a seal you stand inside → the seal has opened its hand |
| 20 | Sarva-Vidrāviṇī | 1 | mudrā · seal you stand inside | flow | slow | 85.6 | 0.5 | seal → seal | lens | — | — | 55.00 | 31.08 | 19/21 | melting · a seal you stand inside → the seal has opened its hand |
| 21 | Sarva-Ākarṣiṇī | 1 | mudrā · seal you stand inside | draw | even | 62.0 | 0.46 | hand → palm | lens | — | — | 55.00 | 41.73 | 20/22 | magnetism · a seal you stand inside → the seal has opened its hand |
| 22 | Sarva-Vaśaṅkarī | 1 | mudrā · seal you stand inside | align | late | 69.4 | 0.46 | palm → palm | lens | — | — | 55.00 | 38.39 | 21/23 | yielding · a seal you stand inside → the seal has opened its hand |
| 23 | Sarva-Onmādinī | 1 | mudrā · seal you stand inside | waver | even | 62.0 | 0.26 | seal → seal | lens | — | — | 55.00 | 35.04 | 22/24 | intoxication · a seal you stand inside → the seal has opened its hand |
| 24 | Sarva-Mahāṅkuśā | 1 | mudrā · seal you stand inside | point | fast | 44.6 | 0.66 | goad → goad | point | — | — | 55.00 | 31.70 | 23/25 | direction · a seal you stand inside → the seal has opened its hand |
| 25 | Sarva-Khecarī | 1 | mudrā · seal you stand inside | open | even | 62.0 | 0.34 | seal → seal | lens | — | — | 55.00 | 28.35 | 24/26 | freedom · a seal you stand inside → the seal has opened its hand |
| 26 | Sarva-Bīja | 1 | mudrā · seal you stand inside | compress | slow | 85.6 | 0.46 | seed → seed | point | — | — | 55.00 | 39.00 | 25/27 | potential · a seal you stand inside → the seal has opened its hand |
| 27 | Sarva-Yoni | 1 | MEMBRANE (authored) (Design Axis lost it by name) | spring | slow | 85.6 | 0.66 | triangle → seal | tri-down | — | — | 55.00 | 35.66 | 26/28 | no door · you were always inside → source within source · it was never one womb |
| 28 | Sarva-Trikhaṇḍā | 1 | TRIPLE (authored) (Design Axis lost it by name) | converge | late | 69.4 | 0.1 | triad → seal | triad | — | — | 55.00 | 32.31 | 27/19 | three rooms · one seal, only in stillness → three and one, and always both |
| 29 | Kāmākarṣiṇī | 2 | crossed | settle | slow | 85.6 | 0.46 | noose → noose | point | 0xff6a7c | aṃ | 123.48 | 36.97 | 31/30 | kāma · drawn toward the centre → the drawing and the drawn are one |
| 30 | Buddhyākarṣiṇī | 2 | crossed | well | slow | 85.6 | 0.26 | flame → flame | point | — | āṃ | 131.71 | 47.62 | 29/31 | buddhi · drawn toward the centre → the drawing and the drawn are one |
| 31 | Ahaṅkārākarṣiṇī | 2 | crossed | flare | fast | 44.6 | 0.6 | hand → palm | lens | — | iṃ | 138.91 | 44.27 | 30/29 | ahaṅkāra · drawn toward the centre → the drawing and the drawn are one |
| 32 | Śabdākarṣiṇī | 2 | crossed | lift | even | 62.0 | 0.5 | ear → palm | lens | — | īṃ | 148.18 | 10.93 | 36/33 | śabda · drawn toward the centre → the drawing and the drawn are one |
| 33 | Sparśākarṣiṇī | 2 | crossed | open | even | 62.0 | 0.94 | palm → palm | lens | — | uṃ | 154.35 | 7.58 | 32/34 | sparśa · drawn toward the centre → the drawing and the drawn are one |
| 34 | Rūpākarṣiṇī | 2 | crossed | lean | slow | 85.6 | 0.26 | mirror → mirror | lens | — | ūṃ | 164.64 | 18.24 | 33/35 | form, answered in ear → the form and the ear were one sense |
| 35 | Rasākarṣiṇī | 2 | crossed | lean | slow | 85.6 | 0.34 | cup → cup | tri-down | — | ṛṃ | 173.64 | 14.89 | 34/36 | taste, answered in skin → the taste and the skin were one sense |
| 36 | Gandhākarṣiṇī | 2 | crossed | lean | slow | 85.6 | 0.5 | lotus → lotus | ring8 | — | ṝṃ | 185.22 | 11.54 | 35/32 | scent, answered in eye → the scent and the eye were one sense |
| 37 | Cittākarṣiṇī | 2 | crossed | lean | slow | 85.6 | 0.46 | gaze → radiance | point | — | ḷṃ | 197.57 | 175.20 | 36/38 (Design 37/37: single-member cluster → circle) | mind, answered in tongue → the mind and the tongue were one sense |
| 38 | Dhairyākarṣiṇī | 2 | crossed | lean | slow | 85.6 | 0.5 | spine → sceptre | band | — | ḹṃ | 205.80 | 145.85 | 41/39 | courage, answered in nose → the courage and the nose were one sense |
| 39 | Smṛtyākarṣiṇī | 2 | crossed | sound | even | 62.0 | 0.26 | gaze → radiance | point | — | eṃ | 219.52 | 142.51 | 38/40 | memory, answered in speech → the memory and the speech were one sense |
| 40 | Nāmākarṣiṇī | 2 | crossed | call | fast | 44.6 | 0.34 | syllable → radiance | ring16 | — | → radiance | 231.53 | 139.16 | 39/41 | name, answered in hand → the name and the hand were one sense |
| 41 | Bījākarṣiṇī | 2 | crossed | compress | slow | 85.6 | 0.66 | seed → seed | point | — | oṃ | 123.48 | 135.81 | 40/38 | seed, answered in foot → the seed and the foot were one sense |
| 42 | Ātmākarṣiṇī | 2 | crossed | turn | late | 69.4 | 0.5 | gaze → radiance | point | — | auṃ | 131.71 | 276.47 | 44/43 | self, answered in release → the self and the release were one sense |
| 43 | Amṛtākarṣiṇī | 2 | crossed | flow | slow | 85.6 | 0.34 | drop → cup | point | — | aṃ | 123.48 | 273.12 | 42/44 | deathless, answered in generation → the deathless and the generation were one sense |
| 44 | Śarīrākarṣiṇī | 2 | crossed (KEY PAIRING) | land | slow | 85.6 | 0.5 | palm → palm | lens | — | aḥ | 123.48 | 269.78 | 43/42 | body, answered in mind → body and mind were one point |
| 45 | Anaṅga-Kusumā | 3 | bodiless | bloom | even | 62.0 | 0.46 | flower → lotus | ring8 | 0xffb0c4 | — | 69.30 | 337.43 | 52/46 | subtle beauty · and nothing there to feel → the effect was the only body |
| 46 | Anaṅga-Mekhalā | 3 | bodiless | encircle | late | 69.4 | 0.68 | belt → garland | ring16 | — | — | 69.30 | 334.08 | 45/47 | encircling intimacy · and nothing there to feel → the effect was the only body |
| 47 | Anaṅga-Madanā | 3 | bodiless | waver | even | 62.0 | 0.34 | gaze → radiance | point | — | — | 69.30 | 344.74 | 46/48 | subtle intoxication · and nothing there to feel → the effect was the only body |
| 48 | Anaṅga-Madanāturā | 3 | bodiless | flare | fast | 44.6 | 0.46 | hand → palm | lens | — | — | 69.30 | 341.39 | 47/49 | pure longing · and nothing there to feel → the effect was the only body |
| 49 | Anaṅga-Rekhā | 3 | bodiless | trace | late | 69.4 | 0.26 | line → line | band | — | — | 69.30 | 338.05 | 48/50 | suggested form · and nothing there to feel → the effect was the only body |
| 50 | Anaṅga-Veginī | 3 | bodiless | dart | fast | 44.6 | 0.46 | streamer → garland | ring16 | — | — | 69.30 | 334.70 | 49/51 | subtle velocity · and nothing there to feel → the effect was the only body |
| 51 | Anaṅga-Aṅkuśā | 3 | bodiless | point | fast | 44.6 | 0.46 | hook → goad | point | — | — | 69.30 | 345.35 | 50/52 | subtle hook · and nothing there to feel → the effect was the only body |
| 52 | Anaṅga-Mālinī | 3 | bodiless | bloom | even | 62.0 | 0.5 | garland → garland | ring16 | — | — | 69.30 | 342.01 | 51/45 | subtle adornment · and nothing there to feel → the effect was the only body |
| 53 | Sarva-Saṅkṣobhiṇī | 4 | cosmic | stir | fast | 44.6 | 0.5 | churn → seal | ring8 | — | — | 73.42 | 350.66 | 66/54 | cosmic stirring · at the scale of worlds → the gesture had no centre to leave |
| 54 | Sarva-Vidrāviṇī | 4 | cosmic | flow | slow | 85.6 | 0.5 | molten → cup | tri-down | — | — | 73.42 | 347.32 | 53/55 | cosmic flow · at the scale of worlds → the gesture had no centre to leave |
| 55 | Sarva-Ākarṣiṇī | 4 | cosmic | draw | even | 62.0 | 0.46 | hand → palm | lens | — | — | 73.42 | 357.97 | 54/56 | universal magnetism · at the scale of worlds → the gesture had no centre to leave |
| 56 | Sarva-Āhlādinī | 4 | cosmic | swell | slow | 85.6 | 0.46 | pour → grain | tri-down | — | — | 73.42 | 354.62 | 55/57 | cosmic joy · at the scale of worlds → the gesture had no centre to leave |
| 57 | Sarva-Sammohinī | 4 | cosmic | waver | even | 62.0 | 0.26 | veil → palm | lens | — | — | 73.42 | 351.28 | 56/58 | divine bewilderment · at the scale of worlds → the gesture had no centre to leave |
| 58 | Sarva-Sthambhinī | 4 | cosmic | arrest | fast | 44.6 | 0.56 | palm → palm | lens | — | — | 73.42 | 347.93 | 57/59 | cosmic stillness · at the scale of worlds → the gesture had no centre to leave |
| 59 | Sarva-Jṛmbhinī | 4 | cosmic | expand | even | 62.0 | 0.5 | stretch → sceptre | band | — | — | 73.42 | 358.59 | 58/60 | cosmic expansion · at the scale of worlds → the gesture had no centre to leave |
| 60 | Sarva-Vaśaṅkarī | 4 | cosmic | align | late | 69.4 | 0.46 | palm → palm | lens | — | — | 73.42 | 355.24 | 59/61 | cosmic yielding · at the scale of worlds → the gesture had no centre to leave |
| 61 | Sarva-Rañjinī | 4 | cosmic | tint | late | 69.4 | 0.26 | brush → line | band | — | — | 73.42 | 351.89 | 60/62 | cosmic colouring · at the scale of worlds → the gesture had no centre to leave |
| 62 | Sarva-Onmādinī | 4 | cosmic | waver | even | 62.0 | 0.2 | cup → cup | tri-down | 0xff8ab0 | — | 73.42 | 348.55 | 61/63 | cosmic intoxication · at the scale of worlds → the gesture had no centre to leave |
| 63 | Sarvārthasādhikā | 4 | cosmic | arrive | even | 62.0 | 0.6 | gem → gem | point | — | — | 73.42 | 359.20 | 62/64 | cosmic fulfilment · at the scale of worlds → the gesture had no centre to leave |
| 64 | Sarva-Sampatpūraṇī | 4 | cosmic | fill | slow | 85.6 | 0.66 | grain → grain | ring16 | — | — | 73.42 | 355.86 | 63/65 | cosmic abundance · at the scale of worlds → the gesture had no centre to leave |
| 65 | Sarva-Mantramayī | 4 | cosmic | sound | even | 62.0 | 0.34 | syllable → radiance | ring16 | — | → radiance | 73.42 | 352.51 | 64/66 | cosmic mantra · at the scale of worlds → the gesture had no centre to leave |
| 66 | Sarva-Dvandvakṣayaṅkarī | 4 | cosmic | merge | late | 69.4 | 0.46 | triangle → seal | tri-down | — | — | 73.42 | 349.16 | 65/53 | cosmic non-duality · at the scale of worlds → the gesture had no centre to leave |
| 67 | Sarva-Siddhipradā | 5 | giving | arrive | even | 62.0 | 0.5 | boon → palm | lens | — | — | 82.41 | 24.82 | 76/68 | all-attainment · arriving, unasked → the giving and the given are one |
| 68 | Sarva-Sampatpradā | 5 | giving | fill | slow | 85.6 | 0.66 | grain → grain | ring16 | — | — | 82.41 | 21.47 | 67/69 | all-abundance · arriving, unasked → the giving and the given are one |
| 69 | Sarva-Priyaṅkarī | 5 | giving | swell (Design breathe; code rule) | slow | 85.6 | 0.46 | flower → lotus | ring8 | — | — | 82.41 | 18.13 | 68/70 | all-love · arriving, unasked → the giving and the given are one |
| 70 | Sarva-Maṅgalakāriṇī | 5 | giving | brighten | fast | 44.6 | 0.1 | lamp → lamp | point | — | — | 82.41 | 14.78 | 69/71 | all-auspiciousness · arriving, unasked → the giving and the given are one |
| 71 | Sarva-Kāmapradā | 5 | giving | arrive | even | 62.0 | 0.46 | fruit → gem | point | — | — | 82.41 | 11.43 | 70/72 | desire-fulfilling · arriving, unasked → the giving and the given are one |
| 72 | Sarva-Duḥkhavimocanī | 5 | giving | dissolve | late | 69.4 | 0.46 | chain → chain | ring16 | — | — | 82.41 | 22.09 | 71/73 | sorrow-liberation · arriving, unasked → the giving and the given are one |
| 73 | Sarva-Mṛtyupraśamani | 5 | giving | persist | slow | 85.6 | 0.5 | drop → cup | point | — | — | 82.41 | 18.74 | 72/74 | death-pacification · arriving, unasked → the giving and the given are one |
| 74 | Sarva-Vighnanivāriṇī | 5 | giving | dissolve | late | 69.4 | 0.5 | goad → goad | point | — | — | 82.41 | 15.40 | 73/75 | obstacle-removal · arriving, unasked → the giving and the given are one |
| 75 | Sarvāṅgasundarī | 5 | giving | bloom | even | 62.0 | 0.5 | radiance → radiance | point | — | — | 82.41 | 12.05 | 74/76 | complete beauty · arriving, unasked → the giving and the given are one |
| 76 | Sarva-Saubhāgyadāyinī | 5 | giving | brighten (Design breathe; code rule) | fast | 44.6 | 0.46 | boon → palm | lens | — | — | 82.41 | 22.70 | 75/67 | all-good-fortune · arriving, unasked → the giving and the given are one |
| 77 | Sarvajñā | 6 | revealing | clarify | fast | 44.6 | 0.2 | flame → flame | point | — | — | 92.50 | 195.36 | 86/78 | all-knowing · already here, behind the veil → it was never hidden · you were the veil |
| 78 | Sarvaśakti | 6 | revealing | surge | fast | 44.6 | 0.5 | radiance → radiance | point | — | — | 92.50 | 192.01 | 77/79 | all-power · already here, behind the veil → it was never hidden · you were the veil |
| 79 | Sarvaiśvaryapradāyinī | 6 | revealing | rise | even | 62.0 | 0.1 | sceptre → sceptre | band | — | — | 92.50 | 188.67 | 78/80 | all-sovereignty · already here, behind the veil → it was never hidden · you were the veil |
| 80 | Sarvajñānamayī | 6 | revealing | clarify | fast | 44.6 | 0.5 | radiance → radiance | point | — | — | 92.50 | 199.32 | 79/81 | all-knowledge · already here, behind the veil → it was never hidden · you were the veil |
| 81 | Sarvavyādhivināśinī | 6 | revealing | fill | slow | 85.6 | 0.5 | herb → herb | lens | — | — | 92.50 | 195.97 | 80/82 | all-healing · already here, behind the veil → it was never hidden · you were the veil |
| 82 | Sarvādhārasvarūpā | 6 | revealing | lean | slow | 85.6 | 0.94 | ground → ground | band | — | — | 92.50 | 192.63 | 81/83 | universal support · already here, behind the veil → it was never hidden · you were the veil |
| 83 | Sarvapāpaharā | 6 | revealing | dissolve | late | 69.4 | 0.46 | cleanse → palm | lens | — | — | 92.50 | 189.28 | 82/84 | error-dissolution · already here, behind the veil → it was never hidden · you were the veil |
| 84 | Sarvānandamayī | 6 | revealing | swell | slow | 85.6 | 0.5 | radiance → radiance | point | — | — | 92.50 | 199.94 | 83/85 | all-bliss · already here, behind the veil → it was never hidden · you were the veil |
| 85 | Sarvarakṣāsvarūpiṇī | 6 | revealing | encircle | late | 69.4 | 0.5 | shield → ground | band | — | — | 92.50 | 196.59 | 84/86 | universal protection · already here, behind the veil → it was never hidden · you were the veil |
| 86 | Sarvepsitaphalapradā | 6 | revealing | arrive | even | 62.0 | 0.46 | fruit → gem | point | — | — | 92.50 | 193.24 | 85/77 | fruit-of-desire · already here, behind the veil → it was never hidden · you were the veil |
| 87 | Vasinī | 7 | sounding (mode 9) | sound | even | 62.0 | 0.46 | rosary → rosary | ring16 | — | Aṃ | 196.00 | 317.90 | 98/88 | inner-speech-origin · Aṃ → you are inside the syllable |
| 88 | Kāmeśī | 7 | sounding (mode 2) | sound | even | 62.0 | 0.34 | bow → bow | band | — | Kaṃ | 245.00 | 328.55 | 87/89 | desire-speech · Kaṃ → you are inside the syllable |
| 89 | Modinī | 7 | sounding (mode 3) | sound | even | 62.0 | 0.34 | cup → cup | tri-down | — | Caṃ | 326.67 | 325.21 | 88/90 | joyful-speech · Caṃ → you are inside the syllable |
| 90 | Vimalā | 7 | sounding (mode 4) | sound | even | 62.0 | 0.34 | water → cup | tri-down | — | Ṭaṃ | 220.50 | 321.86 | 89/91 | pure-speech · Ṭaṃ → you are inside the syllable |
| 91 | Aruṇā | 7 | sounding (mode 5) | sound | even | 62.0 | 0.34 | noose → noose | point | 0xff7a5c | Taṃ | 294.00 | 318.51 | 90/92 | dawn-speech · Taṃ → you are inside the syllable |
| 92 | Jayinī | 7 | sounding (mode 6) | sound | even | 62.0 | 0.46 | banner → garland | ring16 | 0xffd76a | Paṃ | 196.00 | 315.17 | 91/93 | triumphant-speech · Paṃ → you are inside the syllable |
| 93 | Sarveśī | 7 | sounding (mode 7) | sound | even | 62.0 | 0.34 | sceptre → sceptre | band | — | Yaṃ | 261.33 | 325.82 | 92/94 | all-governing-speech · Yaṃ → you are inside the syllable |
| 94 | Kaulinī | 7 | sounding (mode 8) | sound | even | 62.0 | 0.34 | skullcup → skullcup | tri-down | — | Śaṃ | 326.67 | 322.48 | 93/95 | lineage-speech · Śaṃ → you are inside the syllable |
| 95 | Bāṇinī | 7 | sounding (mode 9) | surge | fast | 44.6 | 0.5 | arrows → arrows | ring8 | — | — | 98.00 | 319.13 | 94/96 | five-arrow-śakti · the room is her sound → you are inside the syllable |
| 96 | Cāpinī | 7 | sounding (mode 2) | compress (Design breathe; code rule) | slow | 85.6 | 0.5 | bow → bow | band | — | — | 98.00 | 315.78 | 95/97 | sugarcane-bow · the room is her sound → you are inside the syllable |
| 97 | Pāśinī | 7 | sounding (mode 3) | encircle | late | 69.4 | 0.46 | noose → noose | point | — | — | 98.00 | 326.44 | 96/98 | binding-love · the room is her sound → you are inside the syllable |
| 98 | Aṅkuśinī | 7 | sounding (mode 4) | point | fast | 44.6 | 0.2 | goad → goad | point | — | — | 98.00 | 323.09 | 97/87 | directing-goad · the room is her sound → you are inside the syllable |
| 99 | Kāmeśvarī | 8 | sourcing corner 0 | spring | slow | 85.6 | 0.2 | radiance → radiance | point | 0xfff6e2 | Aim | 220.00 | 359.75 | 101/100 | will, before there is anything to will → will was already act and form |
| 100 | Vajreśī | 8 | sourcing corner 1 | dart | fast | 44.6 | 0.46 | vajra → vajra | point | 0xff4a5c | Klīm | 275.00 | 356.40 | 99/101 | the act, before there is a deed → the act was already will and form |
| 101 | Bhagamālinī | 8 | sourcing corner 2 | spring | slow | 85.6 | 0.66 | garland → garland | ring16 | 0xffd76a | Sauḥ | 412.50 | 7.05 | 100/99 | form, before there is a thing → form was already will and act |
| 102 | Mahātripurasundarī | 9 | DISSOLVE (authored) | spring | slow | 85.6 | 0.5 | arrows → arrows | point (the bindu) | — | Hrīm | 246.94 | 47.71 | — (the point only) | there was never anyone here but Her → the bindu is where you are standing |

Rates across the 102: {'fast': 19, 'even': 33, 'slow': 35, 'late': 15}. Apertures across the 102: {'point': 32, 'lens': 22, 'band': 13, 'tri-down': 11, 'ring8': 8, 'ring16': 12, 'triad': 3, 'point (the bindu)': 1}.

