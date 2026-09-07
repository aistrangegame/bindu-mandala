# The Homes — Design Package for Claude Design

*Companion files: `homes-shakti-cards-rings-1-2.md` and `homes-shakti-cards-rings-3-9.md` carry all 102 Śaktis' data. Attach all three to the Claude Design project. Claude Design has no Airtable access — everything it needs to know about the space is in these files.*

---

## The process

Three tools, one sequence, repeated per area:

1. **Claude Chat** (here) — architecture, continuity, the data, the prompts. Done for the homes with this package.
2. **Claude Design** — visual craft. Attach these three files as project context. Run the prompts below in order. Sample before batch: two homes first, verify the register, then a whole ring at a time.
3. **Claude Code** — build. Hand off from Design directly (Design → Claude Code handoff is built in), against `ShaktiDetailView.swift` and the Atmosphere engine.

Then the same loop for the Mandala. Then the Systems.

**What Claude Design cannot see:** the Airtable base, the live app, the Codex. What it *can* see: these files, the linked GitHub repo (link it — it extracts the real design tokens and reads `ShaktiDetailView` directly), and any device screenshots you capture. Screenshots of the current Detail screen, Today, and the Mandala at each tier would help Design more than anything else — take them before the first prompt.

---

## What a home is

Every home shares one architecture — the ceremony of entering, dwelling, and leaving. This is what makes 102 rooms feel like one building. Inside that architecture, every room is hers alone.

**Entering.** Her Appreciation Phrase is spoken once as you cross the threshold — the inscription over her door — then recedes. Her name is written in Devanagari, stroke by stroke, by an unseen hand. Her etymology breaks into its roots and recombines. Three beats, a few seconds, never skipped, never lingered on.

**Dwelling.** The room itself — lit by her ring's gem, built from her ring's dhātu, running on her ring's clock, tuned to her bīja, its gravity leaning toward where she lives in the body. Her portrait surfaces line by line at the pace of stillness. Her Well letter, if written, rests here as a folded object. The room remembers returns as depth of light and how far the walls recede — never as a number.

**The library.** Behind the room, the existing Detail screen's reference sections — kept, folded, for when you want the text.

**Doors.** Khaḍgamālā order is a circle; every home connects to its two neighbors. The homes are one building, walkable without returning to the Mandala.

**Leaving.** Her Siddhi lingers as a felt after-effect on the whole app — lighter, heavier, sharper, wider — decaying over minutes. Never named.

---

## The nine ring-worlds

Every home sits inside its ring's world. These are the shared conditions — light, material, time, sound, altitude — that her uniqueness then works within and against.

| Ring | Name | Presiding Form | Phase | Shape | Gem (light) | Dhātu (material) | Time Cycle (clock) | Beeja | Body Region | Chakra | Mental State | Yoginī (secrecy) | Mudrā verb | Siddhi | Element |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Trailokyamohana | Tripurā | Śṛṣṭi | Bhūpura (square) | Topaz — warm, amber, low | Rasa (lymph) — membranous, translucent | Day–night | Aim | Feet | Mūlādhāra | Jāgrat (waking) | Prakaṭa (manifest) | AGITATE | Aṇimā | earth |
| 2 | Sarvāśāparipūraka | Tripureśī | Śṛṣṭi | 16 petals | Sapphire — deep blue, cool | Rakta (blood) — warm, pulsing | The hour | Klīm | Pelvis | Svādhiṣṭhāna | Svapna (dreaming) | Gupta (secret) | LIQUEFY | Mahimā | per-Śakti tattva |
| 3 | Sarvasaṅkṣobhaṇa | Tripurasundarī | Śṛṣṭi | 8 petals | Coral — living, reddish, organic | Māṃsa (flesh) — soft, yielding | The day | Sauḥ | Navel | Maṇipūra | Suṣupti (deep sleep) | Guptatara (more secret) | DRAW | Laghimā | air |
| 4 | Sarvasaubhāgyadāyaka | Tripuravāsinī | Sthiti | 14 triangles | Diamond — prismatic, splitting | Medas (fat) — smooth, glossy | Lunar fortnight | Hrīm | Heart | Anāhata | Turīya begins | Sampradāya (lineage) | OPEN | Garimā | water |
| 5 | Sarvārthasādhaka | Tripuraśrī | Sthiti | Outer 10 | Emerald — green, layered | Asthi (bone) — structural, ribbed | Lunar month | Hsraim | Throat | Viśuddha | Turīya deepening | Kulottīrṇa (beyond clan) | VOICE | Īśitva | fire |
| 6 | Sarvarakṣākara | Tripuramālinī | Sthiti | Inner 10 | Ruby — deep, pooled, slow | Majjā (marrow) — glow inside structure | Season | Hsklhrīm | Forehead | Ājñā | Turīyātīta begins | Nigarbha (in the womb) | STILL | Vaśitva | ether |
| 7 | Sarvarogahara | Tripurasiddhā | Saṃhāra | 8 triangles (Vāgdevī) | Pearl — milky, diffuse, sourceless | Śukra — luminous essence | Solar half-year | Hsauḥ | Crown | Sahasrāra | Pure witness | Rahasya (secret) | WITNESS | Prākāmya | air |
| 8 | Sarvasiddhiprada | Tripurāmbā | Saṃhāra | Inner triangle | Cat's eye — one moving band of light | Ojas — radiance | Year | Aim Klīm Sauḥ | Above crown | Bindu-Visarga | Source-consciousness | Atirahasya (most secret) | SEED | Bhukti | fire |
| 9 | Sarvānandamaya | Mahātripurasundarī | Saṃhāra | Bindu | All gems / pure light | Tejas — fire, light | Kāla–Akāla | Hrīm | Totality | Beyond all chakras | Pure being | Parāparāraharasya | ARRIVE | Icchā-Prāpti-Mukti | light |

**Existing hue tokens per ring** (from `Atmosphere.swift` — keep): 1 amber 35°, 2 gold 43° (cluster-varied), 3 rose 341°, 4 crimson 353°, 5 coral 18°, 6 teal 194°, 7 wine 322°, 8 red 2°, 9 white-gold 46°. **Existing per-ring sound** (from `RingAudioService.swift` — keep and extend): 1 ground drone, 2 home breath, 3 & 6 sustained breathy voice, 4 & 5 stepped notes, 8 triad collapse, 9 Shepard tone.

**Design tokens** (from the repo): ground `#0D0508`, gold `#C9963F`, cream `#F2E8D9`, accentRed `#8B1A2A`, Cormorant Garamond throughout.

---

## The uniqueness grammar

This is the part that matters most, and the part to push hardest. The ring-world is the floor. Every home must then be *hers* — and her uniqueness must express what she signifies and what she does to the one who meets her, not just look different. Each field on her card maps to something the room *is* or *does*:

| Her field | Becomes in the room |
|---|---|
| **Quality** (one word: Smallness, Vastness, Lightness…) | The room's soul — the single quality every other decision serves. If a design choice doesn't serve this word, it's wrong for her. |
| **Function** (what she does) | What the room *does to you*. Aṇimā "grants entry into any place no matter how confined" — her room admits you through a door that should be too small. Mahimā "holds the polarity of small/large" — her room has no far wall. The function is the room's mechanism. |
| **Somatic Signature** (how the body knows her) | The room's physics — how it acts on the practitioner. "Awareness that becomes smaller than thought" — the room contracts around you. "Sudden buoyancy, a smile arriving unbidden" — the floor lifts. This is the impact, made spatial. |
| **Bodily Location** | Where the room sits in body-space, and its gravity. Feet-rooms are low and heavy. Crown-rooms are open-sky. "Everywhere skin meets world" — a room with no walls, only surface. |
| **Iconography** | Her form, posture, attribute, and color — the figure in the room, or the room's shape when she has no figure (the Mudrā seals are hand-gestures made into rooms). Every color word, every held object, every posture is a design instruction. |
| **Esoteric Tattva** | Her element, which modifies her ring's dhātu. A fire-tattva Śakti in the sapphire/blood ring is warm light inside cool water. This is where two Śaktis in the same ring diverge most. |
| **Bīja** | The room's tuning — pulse rate, particle rhythm, light-breath all locked to her syllable. |
| **Etymology** | The threshold ritual — which roots split and recombine as you enter. |
| **Appreciation Phrase** | The inscription over her door. |
| **Devanagari** | What the unseen hand writes. |
| **Cluster Group** (ring 2 only) | Sub-neighborhood within the sixteen — Inner Instrument, Tanmātra Sense Streams, Citta, Stability Powers, Self-Body-Immortality — homes in a cluster share a corridor. |
| **Shakti Family** | Her lineage's register: Siddhis are powers, Mātṛkās are Mothers with mounts and weapons, Mudrās are living hand-seals, Karṣiṇīs pull, Anaṅgas are bodiless, Sampradāya is cosmic scale, Kulottīrṇa gives, Nigarbha reveals, Vāsinīs speak, Weapons strike, the Primordial three ring the Bindu. |

**The test for every home:** could this room belong to any other Śakti? If yes, it isn't finished. Laghimā and Garimā share a ring-world — topaz light, lymph material, the day–night clock, Mūlādhāra altitude. One room must lift and the other must press. If a stranger walked into both, they should know which is which without a name.

---

## The prompts

Run in order. Each is short by design — Claude Design's own guidance is goal / layout / content / audience, then iterate. Attach the three files once at project creation; reference them in each prompt.

### P0 — The shared architecture (once)

> **Goal:** Design the shared architecture every one of 102 devotional "homes" in an iOS app moves through: the ceremony of entering, the room itself, the library behind it, doors to neighbors, and leaving. Not a specific room yet — the building's grammar.
> **Layout:** Entering (three beats: a spoken inscription, a name written stroke by stroke in Devanagari, an etymology that splits and recombines). Dwelling (the room, with a portrait that surfaces at the pace of stillness and a folded letter-object). The library (the existing reference sections, folded behind). Doors (two neighbors, a circular corridor). Leaving (a felt after-effect on the whole app).
> **Content:** See "What a home is" in `homes-design-package.md`. Existing tokens: ground #0D0508, gold #C9963F, cream #F2E8D9, Cormorant Garamond. The current Detail screen is in the linked repo at `ShaktiDetailView.swift` — this replaces its top with a room and folds the rest beneath.
> **Audience:** one practitioner, alone, unhurried. Mobile, full-screen, portrait. Nothing counted, nothing celebrated.

### P1–P9 — The nine ring-worlds (one prompt each)

Template — fill from the ring-world table:

> **Goal:** Design the world that all [N] homes of the [ordinal] āvaraṇa share — the light, material, time, sound, and altitude that every room in this ring sits inside.
> **Layout:** A room-world lit through [gem] ([light quality]), built from [dhātu] ([material quality]), running on [time cycle] as a real clock the practitioner's device drives, at the altitude of [body region] in the body. Weather of [element].
> **Content:** Presiding Form [name]. Mental state [state] — sets tempo. Yoginī class [class] — sets how veiled the world is. Existing hue [hue°] and existing sound [technique] from the repo — keep, extend. Ashrey's own Personal Connection text for this ring (in `bindu-mandala-master-brief.md` section 1 context and the Avaraṇa rows) can appear as marginalia in his voice.
> **Audience:** as P0. Show the world empty — no Śakti in it yet — so the next step can place her.

Suggested order: Ring 2 first (the home ring, richest data, where the practitioner already lives), then 1, 3, 4, 5, 6, 7, 8, 9.

### P10 — The sample: two homes, one world

> **Goal:** Design two homes in the same ring-world that must be unmistakably different — Laghimā (Lightness) and Garimā (Weightedness), both 1st āvaraṇa, both Siddhis, both in topaz light on lymph, both on the day–night clock at the altitude of the feet.
> **Layout:** Two full rooms, side by side. Same entering ceremony (P0), same world (P1). Everything else from their cards.
> **Content:** Their two cards in `homes-shakti-cards-rings-1-2.md`. Laghimā: "weightless and silver-bright, half-dissolved into air, her garments lifting though there is no wind" — function "removes the burden of density" — the body knows her as "the lift that comes the moment a burden is set down." Garimā: "dark and deep-rooted, heavy as mountain stone, seated immovable with one palm pressing the earth" — function "stability at the cosmic level" — the body knows her as "the settledness no argument can shift." Apply the uniqueness grammar: Quality is the soul, Function is the mechanism, Somatic Signature is the physics.
> **Audience:** as P0. The test: a stranger entering both should know which is which without a name.

Verify register here before going further. This is the sample-before-batch gate.

### P11 — Batch by ring

Once P10 passes, one prompt per ring, all its Śaktis at once, from their cards:

> **Goal:** Design all [N] homes of the [ordinal] āvaraṇa, each unmistakably hers, inside the world from P[N].
> **Layout:** [N] rooms, sharing P0's architecture and P[N]'s world. Each differentiated by the uniqueness grammar.
> **Content:** The [N] cards for this ring in the cards file. For each: Quality → soul, Function → mechanism, Somatic Signature → physics, Bodily Location → altitude and gravity, Iconography → form and color, Tattva → element modifier, Bīja → tuning. Cluster Group (ring 2) → shared corridors.
> **Audience:** as P0. Any two rooms in this ring, side by side, must be distinguishable without names.

Ring 2 (16) is the largest batch and the most important. Rings 1 (28) may want splitting by family — Siddhis, Mātṛkās, Mudrās — into three prompts.

### P12 — Per-Śakti refinement (ongoing, no end)

The grammar gets all 102 to a real identity. It's a floor. Any single home can be taken further at any time — the ring 9 home, Mahātripurasundarī's, is the obvious first: "there was never anyone here but Her."

---

## What comes back to Chat

After Design: the room designs, the P0 architecture, the nine worlds. Bring them here for the Code handoff brief — I'll write the implementation architecture against `ShaktiDetailView.swift`, `Atmosphere.swift`, and `RingAudioService.swift` so Code extends what exists rather than rebuilding it.
