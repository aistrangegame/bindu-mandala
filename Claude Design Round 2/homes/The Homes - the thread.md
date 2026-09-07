# The Homes — the thread

Three layers, not P-numbers. **The building** (one architecture all 102 share) ·
**the nine worlds** (each āvaraṇa's weather) · **her mechanism** (what her room does to you).

## Where things stand

| Piece | What it is | State |
|---|---|---|
| `Bindu Mandala - The Rite of Entering.html` | The building. Her seat's interior, the tap-paced threshold, the dwelling, the descent, doors, leaving, the after-effect. | built — the floor |
| `The Homes - Concept Board V3 (SVG).html` | Nine mechanisms as lit SVG frames. Preserved as the reference board. | frozen at V3 |
| `The Homes - Rooms in 3D.html` | **Eight** rooms as real three.js interiors, live and animated. | built |
| `homes-attribute.js` | **Her attribute, as the room's one actor** — 26 forms, each performing the single action it exists to perform. | built |
| `The Homes - Verification V3.html` | **The verification pass** — nine registers, 66 checks, all 102 Śaktis exercised, 204 rooms rendered. Built to fail; it did, eight times. | built |
| `homes-descent.js` | **Going deeper**, as travel — five stations of her card as motion, continuing inward from her room. | built |
| `homes-verify.js` | The harness: offscreen stage, geometric fingerprints, the measuring-out-loud detector. | built |
| `homes-cards.js` | **All 102 Śakti cards** — every field real. Quality, tattva, location, roots, phrase, syllable. | built |
| `homes-grammar.js` | **The mechanism grammar** — her ring gives the archetype, her own card tunes it. **102 of 102 are rooms.** | built |
| `homes-today.js` | **Who presides today** — an exact port of the shipped `DailyEnergyService`, so the instrument and the app never disagree. | built |
| `Bindu Mandala - the method.md` | **The working method** — how we open any new space here. Read it first. | written |
| `The Homes - The Axis.html` | **The fold.** One instrument: climb the nine worlds, enter any of the 102 by flying into her light, her mechanism runs in her world's weather, and her Siddhi lingers on the way out. | built |
| `The Homes - The Nine Worlds.html` | The nine āvaraṇas as **weather**, built as one continuous climb through the body — Feet to Totality. | built |
| The nine worlds | Gem→light, dhātu→material, cycle→clock, bīja→tuning, region→altitude. | **built as weather** |
| Ring batches | Ring 2 first, then Ring 1 by family, then 3–9. | not started |

## Iconography — her attribute as the room's one actor

The last card field that was being read as a note rather than an instruction. The brief is
explicit: *“every colour word, every held object, every posture is a design instruction.”*

The move: **her held object is not shown to you — it performs.** It is the only thing acting
inside a room that is otherwise a mechanism. And it stays aniconic, because a noose is a
shape, not a figure.

| Her attribute | What it does, continuously |
|---|---|
| **noose** (Aṇimā, Kāmākarṣiṇī, Pāśinī) | casts, closes, and draws the vast home into the tiny |
| **goad** (Mahimā, Aṅkuśinī) | reaches, hooks what wanders, steers it back |
| **cup** (Bhukti, Rasākarṣiṇī, Modinī) | fills to the brim, and is drunk |
| **five arrows** (Bāṇinī, Mahātripurasundarī) | strike the five sense-gates, each in its turn |
| **bow** (Prākāmya, Cāpinī) | draws, holds the tension, releases |
| **mirror** (Rūpākarṣiṇī) | turns, and returns your own light to you |
| **skull-cup** (Cāmuṇḍā, Kaulinī) | receives what has ended, and darkens as it fills |
| **plough** (Vārāhī) | turns what is buried up into the light, leaving a furrow |
| **vajra** (Indrāṇī, Vajreśī) | strikes once, hard, and is irreversible |
| **sceptre** (Īśitva, Sarveśī) | barely moves — the authority that need not raise its voice |
| **rosary** (Brāhmī, Vasinī) | tells its own beads, one at a time |
| **seed** (Sarva-Bīja, Bījākarṣiṇī) | never opens; only becomes denser |
| **chain** (Sarva-Duḥkhavimocanī) | the links fall open, one after another |
| **lamp** (Sarva-Maṅgalakāriṇī) | a steady flame that blesses what it touches |
| **gem** (Sarvārthasādhikā) | grants — a dispersing stone that gives outward |
| **grain** (Sarva-Sampatpūraṇī) | overflows, and cannot be contained |
| **herb** (Sarvavyādhivināśinī) | mends, leaf by leaf |
| **ground** (Sarvādhārasvarūpā) | does not yield; only the load breathes |
| **line** (Anaṅga-Rekhā) | draws itself in the air and suggests without saying |
| **seal** (the ten Mudrās) | five digits folding through her one gesture |

52 attributes named from the cards, 26 distinct built forms, every one of the 102 given hers.
Her card's colour word tints her actor where it gives one — Garimā's palm is her accent-red,
Vārāhī's plough storm-grey, Vajreśī's bolt ruby.

**And past the second adaptation the attribute stops being an object.** It grows into the
room — 0.9 to 3.16 — and thins, so it is no longer a thing she holds apart from you.

### The defect this pass caught

The motion check called **fifteen living attributes inert** — it sampled only position, scale
and opacity, so a sceptre's slow turn and a vajra's rare strike registered as nothing. But a
sceptre barely moving *is* its character. The check now reads rotation and emissive too, and
samples across a whole cycle rather than twice. **The verifier was wrong, not the design** —
the second time this pass that the harness needed correcting.

## What the brief asked for — the coverage audit

Re-read the original package end to end and checked every claim in it against the build.
**Seven things it asked for were missing.** All are now built, and asserted by the harness.

| From the brief | Was | Now |
|---|---|---|
| “Existing hue tokens per ring — **keep**” | I had taken hue from the gemstones, so ring 6 was ruby-red where the repo says **teal 194°**. A fidelity break against an explicit instruction. | All nine hues are `Atmosphere.swift`'s exactly. The gem now gives the light's *quality* — saturation, lightness, diffusion — so both instructions hold: pearl is sourceless, cat's eye is one hard band. |
| “Doors · every home connects to its two neighbours · **walkable without returning to the Mandala**” | Missing entirely from the Axis. | Named doors on both sides. Walking one releases her room and begins the crossing *from where you stand* — the rite runs again, and there is no cut. |
| “Cluster Group (ring 2) — homes in a cluster **share a corridor**” | Not built. | A door opens sideways within her neighbourhood first: Ring 2 by cluster, Ring 1 by family. Vārāhī's doors lead to Vaiṣṇavī and Māhendrī, her fellow Mātṛkās. |
| “The library · the existing reference sections — **kept**, folded” | Dropped in the fold to the Axis. | Folded behind the room, every field of her card plus her world's character. |
| “Her Well letter, if written, rests here as a **folded object**” | Dropped. | A folded object in her room, opening to her letter. Read from storage only — **never invented**, and the harness asserts that. |
| “Yoginī class — sets **how veiled** the world is” | Unused. | Secrecy deepens inward: Prakaṭa (manifest, veil 0) → Parāparāraharasya (veil 1). The air thickens as you climb. |
| “Mental state — **sets tempo**” · Mudrā verb · presiding Form | Unused. | Jāgrat runs at full speed, Pure being at 0.28. Her own adaptation clock is untouched — the tempo is the *world's*. Each āvaraṇa now names its presiding Form on arrival. |
| “Existing per-ring sound — **keep and extend**” | Nine copies of one sine drone. | Each ring voiced its own way: ground drone · home breath (LFO on its own amplitude) · sustained breathy voice · stepped notes · triad collapse · Shepard tone · and ring 7 sourceless — no fundamental at all, only its overtones. |

### Two findings worth your judgement

**1 · The physics classifier was mostly a default.** An audit found **78 of 102** Śaktis falling
through to one generic breath — the classifier knew a dozen words and the cards speak a whole
vocabulary. It now reads 50 patterns into 50 distinct motions: the five elements, the three
powers, the senses, dissolution, fullness, seed, speech, memory, sovereignty. Aṇu shrinks,
Mahat widens, Pṛthvī settles, Ākāśa opens, Pralaya dissolves, Bīja compresses.

**2 · The shipped data has drifted from the base — 61 of 102 names differ.** Ring 1 carries
**no Garimā at all** (Sarvakāmāvalī stands in her place) and its Mudrā slots hold Ring 4 Devī
names; Ring 2 is empty. The cards *are* the Airtable base, so identity now comes from them and
the app's own name is kept alongside wherever the two disagree. **This is reported, never
silently absorbed — it is a real reconciliation for the Code handoff, not a design choice.**

And the brief's own **sample-before-batch gate** now passes as an assertion rather than an
opinion: Laghimā and Garimā, same world, differ by **100% of their geometry and 116 of
luminance** — *“the floor has let go”* against *“the ceiling is coming down.”* Garimā's
authored descending-mass room, which existed but had never been wired into the instrument,
is now hers.

## The verification pass — V3

**V1** was “does it load”: console errors, a screenshot, click the main control. It only ever
proved nothing crashed. It could not see a room rendering black, a Śakti wired to the wrong
card, or a promise made in writing that the code never kept.

**V2** was “measure what I built”: GPU luminance reads, label uniqueness, geometry deltas. It
caught real defects all session — but it verifies the code against *itself*, checks only what
I remembered to check, and is per-piece. It is structurally blind to regressions *between*
files and to claims the record makes that the artifact does not honour.

**V3 runs backwards from what has been claimed, in seven registers**, as a harness that can
genuinely fail rather than as my judgement:

| Register | What it asserts |
|---|---|
| **canon** | every datum traces to the user's files; nothing invented; ring spans checked against `KhadgamalaMap.swift`; the bīja carrier proven root-relative and in alphabet order |
| **coverage** | all 102 resolve to a room of *her own ring* — not samples; the Kāmeśvarī collision resolves by position; nobody falls to the shared seat |
| **distinction** | the brief's own test, measured: no two sisters speak alike, every room reverses at the second adaptation, adjacent sisters diverge >10% geometrically, and the same mechanism differs by āvaraṇa |
| **legibility** | 204 real renders — every room at both adaptations: never black, never blown out, always internally contrasted, always visibly changed |
| **promise** | time is a pure function of elapsed seconds; the head start is not gameable by re-entering; the ceremony compresses but never skips; the fifth is withheld; today is a true permutation per cycle and turns at 6am |
| **felt** | nothing measures the walker — a detector for “3 of 9”, percentages, streaks, visit counts — no jargon leaks into a room, no empty labels, the climb has no gaps |
| **coherence** | one instrument, no orphans, no lost features, no stale module versions, no debug hooks, reduced motion honoured, the record and the artifact agree |

**Six real defects it found**, none of which V1 or V2 could have:

1. **The Axis had dropped the descent.** A whole feature present in the earlier Rite vanished
   in the fold and nobody noticed. Rebuilt as travel — five stations of her card as motion,
   continuing inward rather than a sheet of facts.
2. Laghimā's rising field stacked additively to **pure white** at arm's length — her room was
   unreadable and perfectly flat. Point size clamped, field pushed off the eye.
3. Laghimā then **went dark at the second adaptation**, because her walls departing left an
   empty room. Now the opening they hung from takes over as they go.
4. Ring 4's cosmic rooms **had no wall at all** — at depth the shells expanded past the frame
   and left black.
5. Ring 1's Mātṛkās read as **one flat surface** — no floor for light to fall across.
6. **The harness's own first version gave a false positive**, matching the host's injected
   editor globals instead of my debug hooks. The verifier needed verifying.

Current state: **46 checks, 0 failing** · 102 Śaktis exercised · 204 rooms rendered.

## The 102 are closed

Rings 1–2 arrived and the set is complete: **102 of 102 are rooms**, counts exact at
28 · 16 · 8 · 14 · 10 · 10 · 12 · 3 · 1. Not one seat remains.

### Ring 1 has three families, so it needed three archetypes

| Family | The room's mechanism |
|---|---|
| **Siddhis** (1–10) | A power is not demonstrated at you — it is *lent*. Her one capacity operates on the room while you stand in it, and the room answers the same motion a beat later. Deep: *the capacity was never lent.* |
| **Mātṛkās** (11–18) | The eight Mothers, each governing a row of the alphabet. Her letters stand ringed around you and come one at a time to the point of being spoken; the column of voice rises from the chest. Deep: *the letters were never separate from the voice.* |
| **Mudrās** (19–28) | Not a room containing a seal — **a seal large enough to stand inside.** Five vaulting digits perform her one gesture continuously. Deep: *the seal has opened its hand.* |

### Ring 2 — the crossing

The home ring's cards do something deliberate that no other ring does. Rūpa (form) is
given Śrotra (the ear). Rasa (taste) is given Tvak (skin). Gandha (scent) is given Cakṣus
(the eye). And Śarīra is given Manas, marked in the base as **THE KEY PAIRING** — body and
mind at the exact same point.

So her room **presents one sense and answers in the other.** Two halves run her physics in
opposite phase: the presenting half near and addressed to you, the answering half offset and
other. They are not aligned — until the second adaptation draws them into one.
*form, answered in ear* → *the form and the ear were one sense.*
*body, answered in mind* → *body and mind were one point.*

### And the bīja is no longer invented

The sound layer carried hard Hz values per ring that came from nowhere canonical — a
straight violation of §7 of `the method`. Her carrier is now **derived from her own
syllable**: the varṇamālā is an ordered series and that order is the canon, so each bīja the
cards name is located in it and its position becomes a just interval above her āvaraṇa's
root. Kaumārī's Caṃ stands in a fixed relation to Brāhmī's Aṃ because the alphabet puts it
there. The pitch and the register are ours; the interval is hers. Where the cards name no
syllable the carrier is simply the root — silence about what we do not know.

### The defect this pass caught

**Ring 2 was never on the axis at all.** `SHAKTIS_BY_RING[2]` is empty in this project's data,
so the home ring — the richest one — had been showing a single placeholder the whole time.
The roster now prefers the app's data and falls back to the cards, which *are* the base's
data. Counts verified 102.

## The grammar — 58 seats became rooms by rule

Rings 3–9's cards arrived, and the right response was **not** 58 hand-builds. Reading them,
each ring turned out to be a **verb** — so the room comes from a rule and her card tunes it:

| Ring | Family | The room's mechanism |
|---|---|---|
| 3 | the Anaṅgas · bodiless | Her effect fills the room and the centre visibly holds nothing — a rim of light around an absence. Second adaptation: *the effect was the only body.* |
| 4 | Samprādāya · the lineage | Her one gesture repeats outward through fourteen shells, delayed, until it is weather. *The gesture had no centre to leave.* |
| 5 | Kulottīrṇa · the givers | Gifts cross in from beyond the wall and settle in your hands. You never reach. *The giving and the given are one.* |
| 6 | Nigarbha · the revealers | Nothing arrives. What is already in the room burns at full strength and a lit veil thins. *It was never hidden — you were the veil.* |
| 7 | the Vāsinīs · speech | The wall is a standing wave in her own row of the alphabet, her mode number from her position. *You are inside the syllable.* |
| 8 | the Triad · the source | Her corner of the innermost triangle burns; the other two are present but dark — until the second adaptation, when they answer. |
| 9 | the Bindu | authored — the yantra turns inside out. |

**Her card is the tuning.** Tattva → physics (13 kinds: arrest, expand, flow, stir, draw, waver,
merge, dart, encircle, point, reach, trace, breathe). Body-location → altitude. Position → phase,
so no two neighbours move alike. Quality → the room's own words, which is the uniqueness test
applied to language: all eight Anaṅgas read differently.

### Four real defects this pass caught

1. **Names collide across rings.** Kāmeśvarī is both a Ring 7 Vāsinī and the Ring 8 Icchā-śakti;
   the Ring 4 Devīs repeat Ring 1 Mudrā names. Name lookup gave the Vāsinī the triad's room.
   **Her position is now authoritative; a name match from another ring is a collision, not a match.**
2. **The app's names differ from the cards** (`Anaṅgakusumā` vs `Anaṅga-Kusumā`, and Ring 6
   diverges substantively) — lookup fell silently through to the shared seat. Punctuation-tolerant
   key plus positional fallback; diacritics preserved, because they are meaning.
3. **Ring 8's triangle was larger than the room** — its corners fell off-screen, leaving near-black.
4. **Ring 6's veil was unlit**, so it extinguished rather than obscured. Now a lit surface.

Verified by GPU read across every ring: Anaṅga 38–84 · cosmic 47–129 · giving 31–182 ·
revealing 27–209 · sounding 78–198 · sourcing 73–204 · bindu 43–157.

**The rite now speaks from her card**: her real appreciation phrase, her Devanāgarī written by
the unseen hand, her true etymological roots — no more compound guessing for these 58.

## The second adaptation — every room reverses its own premise

Each chamber had a first adaptation and then simply held. The clock and the sound already
reached further, and the return fold made the second adaptation **reachable** — so it is now
authored for all seven. It is never more of the same. In every room it is a *reversal*:

| Śakti | First adaptation | The second — the premise turns |
|---|---|---|
| **Aṇimā** | the walls close while you stand still | *the point was a door all along* — the shell goes translucent, the aperture widens twelvefold and the beyond comes toward you. She grants entry into any place however confined. |
| **Laghimā** | the floor has let go | *the room has let go of itself* — the walls depart upward the way everything loose has been going. Nothing in this room falls, including the room. |
| **Mahimā** | no far wall · it never arrives | *you were never inside anything* — the thresholds continue **behind** you too. Vastness in both directions. |
| **Vaśitā** | only what attention rests on exists | *it has turned, and it rests on you* — the pool of knowing stops travelling and finds the observer. Mastery is being known. |
| **Sarva-Yoni** | no door · you were always inside | *source within source* — the membrane clears and she is inside a source of her own. It was never one womb. |
| **Sarva-Trikhaṇḍā** | three rooms · one seal in stillness | *three and one, and always both* — the seal stops resolving and begins to breathe between them. The trinity is one movement, not a puzzle. |
| **Mahātripurasundarī** | there was never anyone here but Her | *the bindu is where you are standing* — the yantra turns inside out and grows past you; the point arrives at your position. |

Verified in geometry, not just in words: Aṇimā's beyond travels −18 → −9.4, Laghimā's walls
rise 1.4 → 11.3, Mahimā's rear thresholds fade 0.06 → 0.49, Sarva-Yoni's nested vessel
0 → 0.12, the bindu travels −8.4 → −2.9 toward where you stand.

**stay** in the Axis runs her clock 14× so this can be reviewed without a four-minute wait.
It changes nothing about the room — only how long you must be present to see it.

## Today — the instrument opens on her

**Correction on the record:** the daily summons was never missing. Three things share the
word *rite* and must not be confused again:

| | What it is | Where |
|---|---|---|
| `DailyEnergyService` | chooses who presides today — deterministic shuffled cycle, day turns 6am local | shipped |
| `DailySummons` | the 6am notification naming her; one a day, no sound, no badge, dropped if the rite is done | shipped |
| `DailyRiteView` | the daily practice screen, six archetypes | shipped |
| **The Rite of Entering** | the threshold ceremony for entering *a Śakti's room* — ours, unrelated | The Homes |

The actual gap was that **the Axis did not know about today.** Now it does:

- `homes-today.js` is an **exact port** of `DailyEnergyService.swift` — same 2020-01-01
  epoch, same 6am boundary, same SplitMix64 over true 64-bit arithmetic (BigInt), same
  downward Fisher–Yates, same cycle seed. Verified: 102 unique positions per aligned cycle,
  cycles reshuffle, stable per date. Ring spans checked against `KhadgamalaMap.swift`
  (1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102). Do not "improve" that
  arithmetic — fidelity to the device is the whole point.
- **The instrument opens where she is**, not on a menu — the climb starts at her āvaraṇa.
- She carries a standing crown-light on the axis, breathing slowly. You did not choose her.
- *she presides today* appears only in her āvaraṇa; approaching her reads *hers is the day*.
- **today** returns you to her from anywhere. Choosing anyone else remains possible.
- **The day turns at 6am without a reload** — she hands over in place.

## The return

**Her room begins where you left it.** The head start comes from accumulated *dwell*, not
from visit count — so it cannot be gamed by entering and leaving. A room you have truly
stood in opens further along, because your eyes remember it; and because of that, the
second adaptation — unreachable on a first visit at 227 seconds in — becomes reachable
only through relationship.

What return changes, all of it felt and none of it displayed:

- **She was expecting you.** A Śakti already met carries her own core light on the axis, and
  her pulse is slow and steady rather than searching.
- **The ceremony softens**, never skips — her name is written faster because you know it.
- **Her room opens further along**, from your accumulated dwell.
- **Your traces stay.** One faint mark on her floor for every time you have stood there.
- **The fifth is granted** by the ninth world, a very long stay, *or* a long relationship.
- **The climb rail** marks āvaraṇas holding someone you have met — never how many.
- On arriving back: one line, once. *you have stood here before.* No number anywhere.
- **forget me** lets all of it go.

Standing rule, from `the method`: the instrument may know everything about your walking and
must display none of it.

## The Axis — the fold

The lens: **no cuts, only travel.** One scene holds all nine worlds and all 102 Śaktis.

**The rite IS the distance.** Entering her is not a screen — the three beats happen *while*
you cross toward her, in three self-paced surges of travel. Beat 1: her āvaraṇa's real
appreciation phrase. Beat 2: her name written stroke by stroke by an unseen hand. Beat 3:
her name opened into its true compound parts (Sarva·yoni, Mahā·tripura·sundarī), with her
quality beneath. Touch carries you the next stretch; the third touch releases you inside.
Nothing advances on a timer, and nothing is ever skipped.

**Sound** — one opt-in toggle. Nine drones, one per āvaraṇa, ascending the body; climbing
crossfades the ground continuously. Her bīja rises as a carrier as you travel into her. Her
adaptation opens the filter. **The fifth is withheld** — granted only in the ninth world, or
to a very long stay. Each beat of the rite lands as one struck tone at her bīja.

You climb the body; the Śaktis of each āvaraṇa stand in her ring at her altitude, as points
of light — real counts, 28 · 16 · 8 · 14 · 10 · 10 · 12 · 3 · 1, read from the project's own
`all-shaktis-data.js`. Tap a light and her world's air thickens and swallows the surroundings;
the point becomes her room. There is no transition screen anywhere.

**Chambers are conditioned by their world.** The same mechanism in a different āvaraṇa is a
different room, because the gem is the light and the dhātu is the material. Seven mechanisms
are authored; the other 95 inherit **her seat's interior**, gem-lit — which is exactly the
P0 floor doing its job, and an honest picture of where the content pass stands.

Brighter points are Śaktis whose rooms are built. Dimmer ones are seats awaiting a mechanism.

## The nine worlds — weather, not palette

One continuous vertical world. Climbing IS the ascent of the body, and the air, light
colour and fog density blend continuously between bands — no switcher, no cuts.

| Ring | Region | Weather | Technique |
|---|---|---|---|
| 1 Trailokyamohana | Feet | Low light raking a vast floor, swinging horizon to horizon | sun on a real day–night arc, long cast shadows |
| 2 Sarvāśāparipūraka | Pelvis | The air pulses — blood-warm waves through cold blue | expanding ring waves on a systolic curve |
| 3 Sarvasaṅkṣobhaṇa | Navel | Churn. The all-agitating; the air will not settle | 2,600-point GPU flow field, pseudo-curl in GLSL |
| 4 Sarvasaubhāgyadāyaka | Heart | Light split — three spectra crawling over glossy ground | three procedural caustic textures + a dispersing diamond |
| 5 Sarvārthasādhaka | Throat | The world has bones; light arrives only in shafts | 72-instance colonnade (InstancedMesh) + shaft planes |
| 6 Sarvarakṣākara | Forehead | Nothing is lit from outside — every solid glows from within | transmissive shells with lights *inside* them |
| 7 Sarvarogahara | Crown | Sourceless — luminous fog, no shadow anywhere | ambient + hemisphere only, luminous fog, zero directional |
| 8 Sarvasiddhiprada | Above crown | One travelling band; everything else waits in the dark | chatoyancy shader — a single meridian on a sky shell |
| 9 Sarvānandamaya | Totality | Every gem at once, which is the same as no weather | nine-gem light rig converging on the bindu |

Each world's clock runs at its own real rate: the day–night cycle turns in seconds, the
season and the solar half-year barely move while you stand there.

## The nine mechanisms

Aniconic throughout — no devotional figures. Each room *does* something:

| Śakti | Mechanism | Technique |
|---|---|---|
| **Aṇimā** | Walls, ceiling and floor contract while you stand still. Never reach you. | interior perspective shell + coupled light |
| **Mahimā** | No far wall. Depth generated faster than you can cross it. | recycling threshold stream in exponential fog |
| **Vaśitva** | Not lit — *known*. Only what attention rests on exists. | travelling spotlight, real shadow maps |
| **Mahātripurasundarī** | No room. The enclosure is gone; the yantra is what you are inside. | yantra as geometry at nine depths |
| **Laghimā** | The floor has let go. Walls end before the ground, hems lifting. Nothing falls. | **GLSL vertex displacement** + GPU rising field |
| **Garimā** | The ceiling descends the whole visit. Floor thickens into strata. | **procedural displacement mapping** + real shadow |
| **Sarva-Yoni** | No entrance. Membrane walls lit from behind, moving with your breath. | **physical transmission + thickness** |
| **Sarva-Trikhaṇḍā** | Three rooms mis-registered. They slide into one only in stillness. | **multi-pass render targets**, per-channel composite |

All eight are Ring 1 — one world, eight unmistakable rooms. That *is* the uniqueness
test passing: nothing here is carried by palette.

**Time is elapsed, never device-tied.** Locked decision, governs all eight: mechanisms
run on ~62 seconds of real time, not on proximity, motion or stillness.

## Standing decisions

Register is Turrell's adaptation mechanism, not cathedral scale — mechanisms run ~60s.
Uniqueness carried by what the room *does*, not by palette. Threshold is tap-paced, never
skipped, compressed on return. Sound on gates only. Reduced motion is longer and quantized,
never disabled. Reference matter is never deleted — it becomes the floor of the descent.

## Verification note

WebGL canvases cannot be captured by the screenshot pipeline (DOM re-render, not pixel
capture) — the 3D piece is verified by `gl.readPixels` luminance grids instead. Last pass,
all eight rooms: Aṇimā 128–240 warm topaz · Mahimā 46→255 depth gradient · Vaśitva 13→197
pool falloff · Mahātripurasundarī 24→221 radial · Laghimā 73→255 vertical (dark ground-less
floor, light overhead) · Garimā 13→204 with a real shadow band and the press glowing ·
Sarva-Yoni 82→255 backlit membrane · Trikhaṇḍā 42→255 mid-tone, and its asymmetry resolves
86|81 → 81|81 at convergence, confirming the three exposures merge into one. No errors.

## The debt this closes

The two Śakti-card files are the **Ruling-7 content pass** — Quality / Function / Somatic /
Tattva / Bīja / Etymology / Iconography for all 102, not just Ring 2's sixteen. Rings 3–9 cards
still to come.

## Next

The design work is done, and the bottleneck has moved off design.

1. **The Claude Code handoff** — the brief's own closing ask. Every mechanism mapped to the
   shipped types: the grammar as a Swift protocol, the veil and tempo as `Atmosphere`
   extensions, the attribute layer, the corridor against the real navigation,
   `RingAudioService` extended per ring rather than replaced.
2. **The name reconciliation** — 61 of 102 differ between the base and the shipped data.
   Ashrey's call, being taken to Claude Chat.
3. Retire the three superseded studies (`The Rite of Entering`, `Rooms in 3D`,
   `The Nine Worlds`) so the record cannot drift again.
4. Diminishing returns past here: a third state beyond the second adaptation, per-Śakti
   refinement without end. Worth doing only once the instrument runs on the phone.
