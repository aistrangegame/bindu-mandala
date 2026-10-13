# THE REGISTER · 01 — The Homes (Design's rooms, the Axis / the Climb, the nine worlds)

*Reader 1 of 7 · written 2026-10-12 · source tree `/home/claude/design-upload/extracted/` (Claude Design export) · every assigned file read in full, line 1 to EOF, with the Read tool — see the coverage proof (§C). Nothing in the repo was modified except this file.*

**How to use this register.** §A lists every experience, room and mechanism in the Homes package, each with its source lines and exact values. §B is Design's own intentions, warnings and acceptance criteria, quoted verbatim, plus every one of the 66 verification checks; §B3 lists the conflicts and defects found while reading. §C is the coverage proof. §D is the short list a builder must not miss. Square-bracketed notes `[…]` are this reader's observations, verified against the code — they are not Design's words.

**What the package is, in one paragraph.** One continuous three.js instrument, *The Axis*, holds the nine āvaraṇas as weather stacked up the body (Feet → Totality, 30 units apart) and all 102 Śaktis as points of light standing in their rings. Tapping a light begins **the rite of entering, which is itself the travel**: three self-paced beats (her phrase · her Devanāgarī written by an unseen hand · her roots parting and rejoining over her quality) carry you in three surges of flight until her world's fog swallows everything and the point becomes her room. Each room is a **mechanism** (not a palette) that runs on real elapsed seconds — a first adaptation over 62 s, a hold to 227 s, and a **second adaptation that reverses the room's premise** over 120 s, reachable in practice only through accumulated dwell. Her held attribute performs as the room's one actor; doors walk the khaḍgamālā corridor without a cut; *go deeper* continues the travel through five stations of her card; the library folds the reference text beneath; a Well letter appears only if one exists; leaving lets her Siddhi linger; *today* opens the instrument on the energy the shipped `DailyEnergyService` names. A 66-check harness verifies it backwards from its claims. One question blocks the build: 61 of 102 names differ between the cards and the shipped app (§1 of the handoff).

**Duplicates (diffed with `cmp`, read once):** every `handoff/` file except `READ ME FIRST.md` and `source/*` is byte-identical to the top-level file of the same name (all-shaktis-data.js, homes-3d-core.js, homes-attribute.js, homes-cards.js, homes-chambers.js, homes-descent.js, homes-grammar.js, homes-memory.js, homes-sound.js, homes-today.js, homes-verify.js, homes-worlds.js, Bindu Mandala - the method.md, Claude Code Handoff - The Homes.md, The Homes - the thread.md, The Homes - The Axis.html, The Homes - Verification V3.html). `The Homes - Concept Board.html` and `The Homes - Concept Board V3 (SVG).html` are byte-identical. `homes-3d-rooms.js` and `homes-3d-rooms-2.js` exist only at top level (not in `handoff/`). The handoff folder has no copy of `The Homes - Rooms in 3D.html`, `The Nine Worlds.html` or the Concept Board.

**Entry index (§A):** H-ARCH (the handoff architecture) · H-BRIEF (the original brief) · H-CARDS · H-DATA (app data as Design saw it) · H-AXIS (the instrument: climb, presences, rite, room, doors, library, letter, descent, leaving, today, forget, sound wiring) · H-CORE · H-WORLDS (W1–W9) · H-LIGHT (Atmosphere port) · H-CLOCK · H-SEAT · H-MECH (M1–M8 authored rooms) · H-RESOLVE · H-GRAMMAR (50 motions + 8 archetypes) · H-TABLE (all 102) · H-ATTR (26 forms) · H-SOUND · H-DESCENT · H-MEMORY · H-TODAY · H-STUDY-ROOMS · H-STUDY-WORLDS · H-CONCEPT.

---

# A · Every experience, screen, room and mechanism

### H-ARCH · The implementation architecture Design handed to Code (`Claude Code Handoff - The Homes.md` 1–411; identical copy in `handoff/`; `handoff/READ ME FIRST.md` 1–68)
**Status line (READ ME FIRST 3–4, Handoff 3–5):** "Nothing should be implemented until §1 of the handoff is settled." / "For review in Claude Chat before any implementation begins."
Reading order (READ ME): 1 the Handoff (§1 blocking) → 2 the thread ("every design decision and why, including every defect found and how. Read this to judge whether the architecture is right, not just buildable") → 3 the method ("how the work was done. Worth reading before commissioning more of it") → 4 `source/` ("the original brief and the 102 cards, unmodified. The ground truth everything was checked against").
To run: serve over http (`cd handoff && python3 -m http.server 8000`; file:// blocks ES modules; three.js from pinned CDN with integrity hashes). "What to do in it: *rise* carries you up through the nine worlds. Tap a point of light to enter that Śakti — three touches walk the rite in. Inside: *go deeper* descends through her card, *the library* folds out her reference text, the doors on either side walk the corridor to her neighbours, *today* returns to the presiding energy, *stay* runs her clock 14× so the second adaptation can be seen without a four-minute wait, *sound* turns on her ring's drone and her bīja." Verification: "66 checks in nine registers, all 102 Śaktis exercised, 204 rooms rendered. It is built to fail and has, eight times."
"It is a working instrument, not a mockup — every room is real geometry with a real mechanism, and the light layer is a verbatim port of the app's own `Atmosphere.swift`, including its ±7° per-Śakti jitter and Ring 2's five cluster hues."

**§1 BLOCKING — the name reconciliation.** "61 of 102 names differ between the Śakti cards and the shipped `ShaktiBootstrap` data." Ring 1: 15 of 28 absent; "No Garimā at all — `Sarvakāmāvalī` stands at her position. The Mudrā slots (19–28) hold Ring 4 Devī names: Sarvāhladinī, Sarvasammohini, Sarvastambhinī, Sarvajṛmbhiṇī, Sarvarañjanī, Sarvonmādinī." Ring 2: "Empty. `SHAKTIS_BY_RING[2]` has zero entries". Ring 3: 1 of 8 · Ring 4: 9 of 14 · Ring 5: 5 of 10 · Ring 6: 7 of 10 (e.g. card Sarvaśakti vs app Sarvaśaktimayī; card Sarvaiśvaryapradāyinī vs app Sarvaaiśvaryapradā) · Ring 7: 7 of 12 · Ring 8: 1 of 3. [Recomputed for this register with the harness's own nameKey: exactly **61** — R1 15 (1 Aṇimā, 4 Garimā, 5 Īśitva, 6 Vaśitva, 7 Prākāmya, 8 Bhukti, 10 Prāpti, 16 Indrāṇī, 21, 23, 24, 25, 26, 27, 28), R2 16, R3 1 (51 Anaṅga-Aṅkuśā), R4 9 (55, 56, 57, 58, 59, 61, 62, 65, 66), R5 5 (68, 69, 70, 72, 73), R6 7 (77, 78, 79, 81, 82, 83, 85), R7 7 (87 Vasinī, 88 Kāmeśī, 93 Sarveśī, 95–98 the four Weapons), R8 1 (100 Vajreśī), R9 0. Note: in the app list Sarvakāmāvalī actually sits at ring-1 slot 10 (where the cards have Prāpti), and the app's ring-1 order differs (2 Laghimā, 3 Mahimā, 4 Īśitā…), so the Axis's index-aligned `appName` is mis-paired for most of Ring 1.]
Three options: **1 Base wins** (re-seed ShaktiBootstrap from the cards; migration keyed on `khadgamalaPosition` so recognition entries survive) · **2 App wins** (cards' names as scholarly variants; then Garimā "does not exist — and she is the brief's own paired example against Laghimā") · **3 Position is the key, names are labels** (khadgamalaPosition sole identity; both names shown; "leaves two names visible for 61 energies"). **Recommendation: option 3 now, option 1 later** — "provably collision-free (Kāmeśvarī appears in both Ring 7 and Ring 8 and only position separates them), and needs no migration. The re-seed can then happen calmly, once, when the canon question is settled in Chat." README: "It is a canon question about the tradition, not a design question, which is why it comes to Chat."

**§2 What already exists and must not be rebuilt:** `Theme/Atmosphere.swift` (light layer is a verbatim port — "Extend, never replace") · `Theme/Element.swift` (`forRing` / `parse(tattva:)` match the brief's element table) · `Theme/HSL.swift`, `Color+Tokens.swift`, `Fonts.swift` (token family) · `Services/DailyEnergyService.swift` (ported exactly; "Verified: 102 unique per aligned cycle, reshuffles, 6am boundary") · `Services/DailySummons.swift` (6am notification, untouched) · `Models/KhadgamalaMap.swift` (spans 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102) · `Services/RingAudioService.swift` ("Extend per ring (§5), do not replace") · `Views/Common/ShaktiDetailView.swift` ("Becomes the **library** (§4.5), folded beneath the room. Its sections are kept.") · `Views/Mandala/*`, `Views/Today/*`, `Views/Memory/*` out of scope.

**§3 New layer, all additive ("No shipped file is deleted"):** `Theme/Gem.swift` (her light: Atmosphere + the gem's behaviour) · `Theme/RingWorld.swift` (nine worlds' shared conditions) · `Models/ShaktiCard.swift` (the 102 cards as data) · `Rooms/RoomMechanism.swift` (protocol) · `Rooms/RoomGrammar.swift` (ring → archetype, card → tuning) · `Rooms/Attribute.swift` (her held object as the room's one actor) · `Views/Rooms/HomeView.swift` (the rite, the dwelling, the doors, leaving) · `Views/Rooms/DescentView.swift` (going deeper, as travel) · `Services/HomeMemory.swift` (dwell, compression, the head start).

**§4.0 ShaktiCard:** "Port as a `ShaktiCard` value type loaded from a bundled JSON generated from that file — **not** hand-transcribed. Key by `pos`. Join to `Shakti` on `khadgamalaPosition`."
```swift
struct ShaktiCard: Codable, Equatable {
    let pos: Int            // 1...102, the identity
    let name: String        // the base's name
    let dev: String         // Devanāgarī — what the unseen hand writes
    let quality: String     // the room's soul
    let tattva: String      // the room's physics
    let loc: String         // altitude and gravity
    let roots: [String]     // the threshold ritual
    let phrase: String      // the inscription over her door
    var ring: Int { RingSpan.ring(for: pos) }
}
```
Plus SYLLABLE, CROSSED, ATTRIBUTE, ATTR_TINT, RING_START, R1_FAMILY, R2_CLUSTER from `homes-cards.js`. [The source cards also carry Function, Somatic and Iconography text and per-card Bīja notes; `homes-cards.js` does not carry Function/Somatic/Iconography — the brief maps Function → mechanism and Somatic → physics, so a ShaktiCard without them cannot be re-tuned later from the base.]

**§4.1 Gem.swift:** `extension Atmosphere { var diffusion: Double { switch element { … } } }` — "How her āvaraṇa's gem carries light — diffusion only. Hue, saturation and lightness stay exactly as `derive` produces them." Values: 1 0.20 topaz · 2 0.30 sapphire · 3 0.45 coral · 4 0.15 diamond · 5 0.25 emerald · 6 0.55 ruby · **7 0.95 pearl (sourceless — no directional light at all)** · 8 0.10 cat's eye (one hard travelling band) · 9 0.70 all gems. "Diffusion drives: shadow softness, whether a room has a key light or only ambient, and how far the glow falls. Ring 7 having no directional light is not a shortcut — 'milky, diffuse, sourceless' is the instruction." [In the JS prototype `diffuse` is carried on the gem object but **no room reads it** — it is a specification for Code, not something the prototype demonstrates. The handoff keys it by `element`, but rings 3 and 7 share element "air" and rings 5 and 8 share "fire" while their diffusions differ (0.45/0.95, 0.25/0.10) — key it by ring.]

**§4.2 RingWorld.swift:**
```swift
struct RingWorld {
    let n: Int
    let name, form, gem, dhatu, clock, region, bija, verb, yogini, state: String
    let veil: Double     // Yoginī class → how veiled  (0.00 → 1.00, monotone)
    let tempo: Double    // mental state → world tempo (1.00 → 0.28)
    let element: Element // == Element.forRing(n)
}
```
"`veil` scales fog density (`× (1 + veil * 0.55)`); Prakaṭa is unveiled, Parāparāraharasya is fully veiled. `tempo` scales **the world's own animation clock only** — never her adaptation clock (§6)."

**§4.3 RoomMechanism — "The single most important architectural point: rooms are not 102 authored screens."**
```swift
protocol RoomMechanism {
    /// What the room does to whoever stands in it, at `t` seconds elapsed.
    func state(at t: TimeInterval) -> RoomState
    /// Her near words, and her words past the second adaptation.
    func label(at t: TimeInterval) -> String
}
struct RoomState {
    var adaptation: Double     // 0→1 over 62s, the first adaptation
    var second: Double         // 0→1 over 120s after a 165s hold
    var transforms: [RoomNode: Transform]
}
```
Resolution order "exactly as `buildChamber` does it": 1 her own authored mechanism ("Nine so far" — lists eight: Aṇimā contract, Laghimā release, Garimā press, Mahimā endless, Vaśitā known, Sarva-Yoni membrane, Sarva-Trikhaṇḍā triple, Mahātripurasundarī dissolve); 2 her ring's archetype tuned by her card (Ring 1 three families — Siddhis *lend*, Mātṛkās hold *a row of the alphabet*, Mudrās *a seal large enough to stand inside*; Ring 2 the crossing; Rings 3–8 bodiless · cosmic · giving · revealing · sounding · sourcing); 3 her seat's interior, gem-lit — "the floor nobody currently needs". Four tuning channels: physics (tattva + quality → one of **50** motions), altitude (loc, feet 0.94 → crown 0.10), phase (pos, "so no two neighbours move alike"), words (quality, "so no two sisters read alike"). "**Every room reverses its premise at the second adaptation.** Not more of the same — a reversal."
[Counts: "Nine so far" lists 8; the thread says "Seven mechanisms are authored" and "authored for all seven"; the code has 8 functions; only 4 are reachable in the Axis (see H-RESOLVE). "a 165s hold" = 227 − 62.]

**§4.3.1 Ring 2 — the crossing:** "Rūpa (form) with Śrotra (the ear), Rasa with Tvak, Gandha with Cakṣus, and Śarīra with Manas — marked in the base as *THE KEY PAIRING*. This is deliberate, not a data error. Her room presents one sense and answers in the other: two halves running her physics in **opposite phase**, converging only at the second adaptation."

**§4.4 Attribute.swift:** "Her Iconography line becomes the room's one actor: a shape performing the single action it exists to perform. Aniconic — a noose is a shape, not a figure. 26 forms; 52 named across the 102." Past the second adaptation "the attribute **stops being an object** — it grows into the room (0.9 → 3.16) and thins." [Verified: ATTRIBUTE covers all 102 positions with exactly 52 distinct keys, resolving to all 26 built forms; ATTR_TINT has 15 entries. In code the scale reaches 0.9 + 2.6 = 3.5 at full second adaptation.]

**§4.5 HomeView — the rite and the library:** "**The rite is the distance.** Three beats, each carrying a stretch of travel toward her. Beat 1 her phrase. Beat 2 her Devanāgarī written stroke by stroke. Beat 3 her roots splitting and rejoining with her quality beneath. **Self-paced by touch — never a timer, never skipped, compressed on return.**" The library is ShaktiDetailView's existing sections folded beneath the room, reached by one control; "Nothing from it is deleted." Her Well letter "rests in the room as a folded object. Read only — **never fabricated**; the harness asserts this."
**§4.6 DescentView:** "Five stations, each ONE field of her card as motion, continuing inward from her room — not a sheet of facts. Her tattva → her location → her etymology → her quality → her phrase. Self-paced."
**§4.7 Doors and corridor:** "Khaḍgamālā order is a circle: two named doors per room. A door opens **sideways within her neighbourhood first** — Ring 2 by cluster, Ring 1 by family — then around the circle. Walking one releases her room and begins the crossing **from where you stand**, so the rite runs again and there is no cut. The homes are one building."
**§4.8 Leaving:** "Her Siddhi lingers on the whole app for minutes, decaying, **never named**."
**§4.9 HomeMemory:** "**The head start comes from accumulated dwell, not visit count** — so it cannot be gamed by entering and leaving. Consequence: the second adaptation, 227 seconds into a first visit and therefore unreachable, becomes reachable only through relationship." `compression(_ pos) -> Double // 1.0 → 0.36, never 0` · `headStart(_ pos) -> TimeInterval // from dwell; 0 under 12s` · `grantsFifth(_ pos, ring:, t:) -> Double`. "Store alongside `RecognitionLogStore`. **Nothing is ever displayed:** no counters, no percentages, no streaks. One line, once, on returning: *you have stood here before.*"

**§5 Sound — extend RingAudioService:** 1 ground drone · 2 home breath (LFO on its own amplitude) · 3, 6 sustained breathy voice · 4, 5 stepped notes (4 slower than 5) · **7 sourceless — no fundamental at all, only its overtones** · 8 triad collapse · 9 Shepard tone. Carrier and withheld fifth as in H-SOUND.

**§6 Invariants — "do not violate these" (verbatim):**
1. **Time is elapsed.** Mechanisms run on real seconds. Never device motion, never proximity, never stillness. Stillness may govern *arrival* of a line, never its persistence (high-water mark, not a live reading).
2. **Never measure out loud.** No counters, percentages, progress, streaks or badges. The instrument may know everything about the walking and must display none of it.
3. **No cuts, only travel.** No transition screens, no fades to black, no menus where movement will do. Every switcher is a place the experience stops.
4. **Reduced motion is longer and quantized, never disabled.** The mechanism is perceptual adaptation; removing it removes the piece.
5. **Never invent canon.** No fabricated frequency, name, phrase or letter. Where a field is missing, degrade visibly to the shared floor — the gaps are information.
6. **Position is identity.** Names collide across rings (Kāmeśvarī is both a Ring 7 Vāsinī and the Ring 8 Icchā-śakti; Ring 4's Devīs repeat Ring 1's Mudrā names). Only `khadgamalaPosition` is unambiguous.
7. **Contrast floor.** Every room must be legible at both adaptations. Additive particles near the eye stack to white — clamp point size.

**§7 Suggested order (for Chat to approve):** 1 Settle §1 ("everything downstream encodes the answer") · 2 ShaktiCard + JSON + join on position ("unblocks all 102 at once") · 3 Gem + RingWorld (diffusion, veil, tempo — "additive to Atmosphere, no view changes") · 4 RoomMechanism + the seat archetype only ("one room type, proves the protocol") · 5 The rite, the library, leaving ("replaces the top of ShaktiDetailView, keeps its body") · 6 The grammar: ring archetypes + the 50 motions ("102 rooms land together") · 7 Her attribute ("deepens all 102 by one increment") · 8 The doors and the corridor ("the building becomes walkable") · 9 Return + the descent ("depth for the practitioner who stays") · 10 Sound per ring ("last, because it is the easiest to get subtly wrong"). "Ring 9 (Mahātripurasundarī) should be built last and by hand. *There was never anyone here but Her.*"

**§9 Not in this handoff:** the Mandala, Today, the Portrait, the Well's writing flow, the Descent film, Homecoming, Settings, the Codex. "Also absent: **Ashrey's Personal Connection marginalia**, which the brief wants as per-ring voice in his own words. No such text exists in any file given to Design. It needs authoring in Chat before it can appear in a room." [Contradiction: `all-shaktis-data.js` — inside this same handoff folder — carries a `personalConnection` paragraph for every ring (quoted in H-DATA). Whether that text *is* Ashrey's own-voice marginalia is for him to say; it exists.]

**§10 Manifest:** homes-cards.js (all 102 cards · attributes · syllables · clusters · families) · homes-chambers.js (the nine authored mechanisms · the Atmosphere port · the seat floor) · homes-grammar.js (ring archetypes · the 50 tattva motions · the crossing) · homes-attribute.js (26 attribute forms) · homes-worlds.js (nine worlds · ring character · veil · tempo) · homes-descent.js · homes-memory.js (dwell · compression · head start · the withheld fifth) · homes-today.js (DailyEnergyService port) · homes-sound.js (per-ring techniques · the varṇamālā carrier) · homes-3d-core.js · homes-verify.js · The Axis (the working instrument) · Verification V3 (the 66 checks) · the thread · the method · homes-design-package.md (the original brief) · the two card files. [The manifest omits `all-shaktis-data.js`, which the Axis loads and which is in the handoff folder.]

---

### H-BRIEF · The original brief (`handoff/source/homes-design-package.md` 1–132) — what a home is
Process: "Claude Chat (architecture, continuity, the data, the prompts) → Claude Design (visual craft … Sample before batch: two homes first, verify the register, then a whole ring at a time) → Claude Code (build … against `ShaktiDetailView.swift` and the Atmosphere engine). Then the same loop for the Mandala. Then the Systems." Design "cannot see: the Airtable base, the live app, the Codex"; it can see these files, the linked GitHub repo, device screenshots ("Screenshots of the current Detail screen, Today, and the Mandala at each tier would help Design more than anything else").
**What a home is (verbatim):**
- "Every home shares one architecture — the ceremony of entering, dwelling, and leaving. This is what makes 102 rooms feel like one building. Inside that architecture, every room is hers alone."
- **Entering.** "Her Appreciation Phrase is spoken once as you cross the threshold — the inscription over her door — then recedes. Her name is written in Devanagari, stroke by stroke, by an unseen hand. Her etymology breaks into its roots and recombines. Three beats, a few seconds, never skipped, never lingered on."
- **Dwelling.** "The room itself — lit by her ring's gem, built from her ring's dhātu, running on her ring's clock, tuned to her bīja, its gravity leaning toward where she lives in the body. Her portrait surfaces line by line at the pace of stillness. Her Well letter, if written, rests here as a folded object. The room remembers returns as depth of light and how far the walls recede — never as a number." [**Not built anywhere in these files: "Her portrait surfaces line by line at the pace of stillness."** No portrait layer exists in the Axis.]
- **The library.** "Behind the room, the existing Detail screen's reference sections — kept, folded, for when you want the text."
- **Doors.** "Khaḍgamālā order is a circle; every home connects to its two neighbors. The homes are one building, walkable without returning to the Mandala."
- **Leaving.** "Her Siddhi lingers as a felt after-effect on the whole app — lighter, heavier, sharper, wider — decaying over minutes. Never named." [Prototype: exposure-only (+0.12 decaying over 24 s) and it *does* name it ("her siddhi is still on the instrument", 12 s). Per-Siddhi quality (lighter/heavier/sharper/wider) not built.]

**The nine ring-worlds (brief table, verbatim values):**
| Ring | Name | Presiding Form | Phase | Shape | Gem (light) | Dhātu (material) | Time Cycle | Beeja | Body Region | Chakra | Mental State | Yoginī | Mudrā verb | Siddhi | Element |
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
"**Existing hue tokens per ring** (from `Atmosphere.swift` — keep): 1 amber 35°, 2 gold 43° (cluster-varied), 3 rose 341°, 4 crimson 353°, 5 coral 18°, 6 teal 194°, 7 wine 322°, 8 red 2°, 9 white-gold 46°. **Existing per-ring sound** (from `RingAudioService.swift` — keep and extend): 1 ground drone, 2 home breath, 3 & 6 sustained breathy voice, 4 & 5 stepped notes, 8 triad collapse, 9 Shepard tone." **Design tokens:** ground `#0D0508`, gold `#C9963F`, cream `#F2E8D9`, accentRed `#8B1A2A`, Cormorant Garamond throughout.
[Not built from the table: Phase, Shape (only used as the seat cross-section), Chakra, Siddhi per ring, Element (except as the handoff's diffusion key). The Siddhi column is what "lingers" on leaving — the prototype does not vary the after-effect by it.]

**The uniqueness grammar (verbatim):** "This is the part that matters most, and the part to push hardest. The ring-world is the floor. Every home must then be *hers* — and her uniqueness must express what she signifies and what she does to the one who meets her, not just look different."
| Her field | Becomes in the room |
|---|---|
| Quality | The room's soul — the single quality every other decision serves. If a design choice doesn't serve this word, it's wrong for her. |
| Function | What the room *does to you*. Aṇimā "grants entry into any place no matter how confined" — her room admits you through a door that should be too small. Mahimā "holds the polarity of small/large" — her room has no far wall. The function is the room's mechanism. |
| Somatic Signature | The room's physics — how it acts on the practitioner. "Awareness that becomes smaller than thought" — the room contracts around you. "Sudden buoyancy, a smile arriving unbidden" — the floor lifts. This is the impact, made spatial. |
| Bodily Location | Where the room sits in body-space, and its gravity. Feet-rooms are low and heavy. Crown-rooms are open-sky. "Everywhere skin meets world" — a room with no walls, only surface. |
| Iconography | Her form, posture, attribute, and color — the figure in the room, or the room's shape when she has no figure (the Mudrā seals are hand-gestures made into rooms). Every color word, every held object, every posture is a design instruction. |
| Esoteric Tattva | Her element, which modifies her ring's dhātu. A fire-tattva Śakti in the sapphire/blood ring is warm light inside cool water. This is where two Śaktis in the same ring diverge most. |
| Bīja | The room's tuning — pulse rate, particle rhythm, light-breath all locked to her syllable. |
| Etymology | The threshold ritual — which roots split and recombine as you enter. |
| Appreciation Phrase | The inscription over her door. |
| Devanagari | What the unseen hand writes. |
| Cluster Group (ring 2 only) | Sub-neighborhood within the sixteen — Inner Instrument, Tanmātra Sense Streams, Citta, Stability Powers, Self-Body-Immortality — homes in a cluster share a corridor. |
| Shakti Family | Her lineage's register: Siddhis are powers, Mātṛkās are Mothers with mounts and weapons, Mudrās are living hand-seals, Karṣiṇīs pull, Anaṅgas are bodiless, Sampradāya is cosmic scale, Kulottīrṇa gives, Nigarbha reveals, Vāsinīs speak, Weapons strike, the Primordial three ring the Bindu. |
"**The test for every home:** could this room belong to any other Śakti? If yes, it isn't finished. Laghimā and Garimā share a ring-world — topaz light, lymph material, the day–night clock, Mūlādhāra altitude. One room must lift and the other must press. If a stranger walked into both, they should know which is which without a name."
[Gaps in the build against this grammar: **Bīja → "pulse rate, particle rhythm, light-breath all locked to her syllable"** — visual rhythms are not locked to the syllable anywhere (only the audio carrier and the Ring 7 mode number use it). **Esoteric tattva → "modifies her ring's dhātu" / "warm light inside cool water"** — tattva only selects a motion, never light or material. **Bodily Location "a room with no walls, only surface"** (Sparśa) — not built. **Weapons strike** — Ring 7 weapons (95–98) are treated as Vāsinīs (sounding archetype, no bīja); only their attribute differs.]

**The prompts (P0–P12) — summary of intent:** P0 shared architecture once ("Audience: one practitioner, alone, unhurried. Mobile, full-screen, portrait. Nothing counted, nothing celebrated." … "this replaces its top with a room and folds the rest beneath"). P1–P9 one world each ("running on [time cycle] as a real clock the practitioner's device drives" … "Ashrey's own Personal Connection text for this ring … can appear as marginalia in his voice" … "Show the world empty — no Śakti in it yet"); suggested order Ring 2 first, then 1, 3–9. P10 the sample: Laghimā and Garimā ("Verify register here before going further. This is the sample-before-batch gate."). P11 batch by ring ("Any two rooms in this ring, side by side, must be distinguishable without names"; Ring 1 may split by family). P12 per-Śakti refinement, ongoing, "the ring 9 home, Mahātripurasundarī's, is the obvious first: 'there was never anyone here but Her.'" Closing: "Bring them here for the Code handoff brief — I'll write the implementation architecture against `ShaktiDetailView.swift`, `Atmosphere.swift`, and `RingAudioService.swift` so Code extends what exists rather than rebuilding it."
[Note: the brief says each world's clock is "a real clock the practitioner's device drives"; the prototype runs world clocks as fast symbolic cycles (day–night every 20 s × tempo), not from the device's real date.]

### H-CARDS · The 102 cards (`homes-cards.js` 1–266; sources `handoff/source/homes-shakti-cards-rings-1-2.md` 1–367 and `…-3-9.md` 1–511)
- Tuple per card: pos, name, dev (Devanāgarī), quality, tattva, loc, roots[], phrase. Full per-Śakti values in H-TABLE (name, quality via words) — the phrase, tattva, loc and roots for every card are reproduced verbatim in the source files and in `homes-cards.js` lines 10–147; the builder must generate JSON from `homes-cards.js` (not re-type).
- **Source-only fields not carried into homes-cards.js:** Function, Somatic, Iconography, and the bīja annotations ("governs the A-row (16 vowels + anusvāra/visarga)", "the Icchā-bīja, first syllable of the Pañcadaśī", Ring 9 "Hrīm — or the full Pañcadaśī: Ka E Ī La Hrīm | Ha Sa Ka Ha La Hrīm | Sa Ka La Hrīm"). Iconography was hand-condensed into ATTRIBUTE + ATTR_TINT.
- Spelling drift between source and JS: source uses American spellings in some phrases ("recognizes", "savor", "colour/coloring", "Fulfillment") where JS uses British ("recognises", "savour", "Colouring", "Fulfilment"); source tattva for 34 includes "— esoteric cross-mapping: the attractor and the tattva operate in counterpoint"; 42/43/44 tattva notes abbreviated in JS. Port from the source of truth Chat chooses (§1).
- **R1_FAMILY:** pos ≤ 10 siddhi · ≤ 18 matrka · else mudra. **R2_CLUSTER:** ≤ 31 instrument (Inner Instrument 29–31) · ≤ 36 tanmatra (32–36) · 37 citta · ≤ 41 stability (38–41) · else self (Self-Body-Immortality 42–44).
- **CROSSED** (Ring 2's deliberate counterpoint — "Her quality names one faculty; her tattva gives a different organ"): 34 form/ear · 35 taste/skin · 36 scent/eye · 37 mind/tongue · 38 courage/nose · 39 memory/speech · 40 name/hand · 41 seed/foot · 42 self/release · 43 deathless/generation · **44 body/mind (THE KEY PAIRING)**. (29–33 are not crossed: earth, water, fire, air, ether.)
- **ATTR_TINT** (her card's colour word tints her actor "without touching her āvaraṇa's light"): 1 `0xf2ecd8` (pale, near-translucent) · 4 `0xb8263c` (Garimā's palm, accent-red family) · 7 `0xff7a3c` (flame-coloured) · 13 `0xffb45c` (fresh as new flame) · 15 `0x6a5f78` (storm-dark) · 17 `0xd8d2c4` (ash/bone) · 18 `0xffd76a` (golden) · 29 `0xff6a7c` (rosy-red) · 45 `0xffb0c4` (soft rose) · 62 `0xff8ab0` · 91 `0xff7a5c` (dawn-red) · 92 `0xffd76a` (golden) · 99 `0xfff6e2` (white-gold) · 100 `0xff4a5c` (ruby-red) · 101 `0xffd76a` (golden). [Thread says "Vārāhī's plough storm-grey, Vajreśī's bolt ruby".]
- **RING_START** {1:1, 2:29, 3:45, 4:53, 5:67, 6:77, 7:87, 8:99, 9:102}; `globalPos(ring, i)` = start + i.
- **findCard(shakti, ring, ix):** position first (CARDS[globalPos] if its ring matches) — "Her POSITION is authoritative, because names collide across rings"; else name key (`nameKey` = lower-case, strip whitespace - · . ' ’ ( ) — "Diacritics are preserved — they are meaning, not noise"; also indexes the stem without "(Devī)"); "a name match from another ring is a collision, not a match"; else null ("Returns null rather than guessing").
- **bodyAltitude(card)** from `loc` (first match; "feet 1 → crown 0"): soles|feet|mūlādhāra 0.94 · belly|navel|yoni|abundance 0.66 · solar plexus 0.60 · waist 0.68 · diaphragm 0.56 · sternum|chest|heart 0.46 · throat|palate|mouth 0.34 · behind the eyes|eyes|face 0.26 · forehead|third eye|between the eyes 0.20 · crown|above 0.10 · spine|whole body|whole field|cellular|totality|converge 0.50 · default 0.50. [Order matters: "Third eye / point-of-origin" → 0.20; "Heart / first impulse" → 0.46; Aṇimā "Bindu point at crown" → 0.10.]

### H-DATA · The app's own data as Design saw it (`all-shaktis-data.js` 1–332; identical copy in `handoff/`)
"Loaded after shakti-data.js. Extends all window globals." Declares AVARANAS, RING1/3/4/5/6/7/8_SHAKTIS, RING9_SHAKTI, SHAKTIS_BY_RING, NITYA_DEVIS and assigns them to `window`. **Ring 2 = `typeof SHAKTIS !== 'undefined' ? SHAKTIS : []`** — SHAKTIS comes from `shakti-data.js`, which the Axis never loads, hence "Ring 2 is empty".
**AVARANAS (per ring):** status · subtitle · form · formDescription · count · presidingForm · yogini · mentalState · chakra · geometry · appreciationPhrase · personalConnection.
| ring | status | subtitle | form / geometry | presidingForm | yogini | mentalState | chakra | appreciationPhrase (rite fallback, beat 1) |
|---|---|---|---|---|---|---|---|---|
| 1 | ancient | She Who Enchants All Three Worlds | Bhupura / square | Tripurā | Prakaṭa Yoginī | Jāgrat — waking consciousness | Mūlādhāra | "Thank you for the world I have walked through without knowing it was you." |
| 2 | home | She Who Fulfills All Hopes | 16-Petal Lotus / lotus16 | Tripureśī | Gupta Yoginī | Svapna — the dream state | Svādhiṣṭhāna | "Thank you for the desire that moves me and the awareness that knows it." |
| 3 | unlocked | She Who Agitates All | 8-Petal Lotus / lotus8 | Tripura Sundarī | Guptatarā Yoginī | Suṣupti — the deep sleep awareness | Maṇipūra | "Thank you for the longing that arrives without asking permission." |
| 4 | locked | She Who Grants All Auspiciousness | 14 Triangles / tri14 | Tripura Vāsinī | Sampradāya Yoginī | Turīya — the fourth state | Anāhata | "Thank you for the good fortune I did not manufacture." |
| 5 | locked | She Who Accomplishes All Goals | 10 Outer Triangles / tri10o | Tripura Śrī | Kulotīrṇā Yoginī | Turīyātīta — beyond the fourth | Viśuddha | "Thank you for the completion I did not force." |
| 6 | locked | She Who Protects All | 10 Inner Triangles / tri10i | Tripura Mālinī | Nigarbhā Yoginī | Śāmbhavī — pure Śiva-awareness | Ājñā | "Thank you for the grace I didn't know was holding me." |
| 7 | locked | She Who Removes All Disease | Vāk Ring / tri8 | Tripura Siddha | Rahasya Yoginī | Unmanā — beyond mind | Bindu | "Thank you for the word that healed what the mind could not reach." |
| 8 | deep_ghost | She Who Grants All Perfections | Mūla Trikoṇa / trikona | Mahā Tripura Sundarī | Atirahasya Yoginī | Manonmanī — the summit of mind dissolving | Sahasrāra | "Thank you for the perfection that moved through me." |
| 9 | deep_ghost | She Who Is Made of All Bliss | Bindu / bindu | Lalitā Mahā Tripura Sundarī | Parāparahasya Yoginī | Samādhi — the undivided | Brahmarandhra | "Thank you for being the place I have always already arrived." |
[Conflicts with the brief's ring table / RING_CHARACTER: mental states for rings 5–9 (app: Turīyātīta, Śāmbhavī, Unmanā, Manonmanī, Samādhi vs brief: Turīya deepening, Turīyātīta begins, Pure witness, Source-consciousness, Pure being); chakras 7–9 (app: Bindu, Sahasrāra, Brahmarandhra vs brief: Sahasrāra, Bindu-Visarga, Beyond all chakras); ring 8 presiding form (app: Mahā Tripura Sundarī vs brief: Tripurāmbā); ring-9 yoginī spelling (Parāparahasya vs Parāparāraharasya). The Axis displays the brief's values (from homes-worlds.js) and uses the app's appreciationPhrase only as a fallback when a card has no phrase (every card has one, so in practice never).]
**personalConnection (verbatim, per ring) — this is text the handoff says does not exist:**
1. "You have already been here. Every moment you moved through the world — its noise, its weight, its ten thousand enchantments — you were in her territory. The surfaces that held you, the beauty that stopped you mid-step, the ordinary gravity that kept you walking forward: all her. The 28 Shaktis of this avaraṇa are the most universal forces. They are the ground. You have been breathing them since before you knew there was breath to track."
2. "You are here now. This is your current field. The sixteen Karṣiṇīs — the forces that attract sense, intelligence, the I-sense, consciousness itself — you have been meeting them daily, learning their names, catching them in life. Some are already embodied. The game is not new. The map is simply arriving."
3. "You have already been here. You know Anaṅga — the bodiless one — as a felt sense before any word arrived for it. The longing without address. The beauty that entered through the chest before the eyes had time to process. The pull toward something you couldn't name, which was not sadness and not joy but something that preceded both. You were in this territory without the map. Now the territory is naming itself to you."
4. "You have already been here. The moments where everything converged — good fortune arriving as a current you hadn't called — she was doing that. The synchronicity that stopped you. The door that opened before you knocked. The meeting that happened because you took a different route. You didn't know her name then. Now you stand at her gate consciously, and she recognizes the practitioner who has been receiving her gifts without attribution."
5. "You have already been here. Every goal that accomplished itself through you — the work that found its form at 2am, the conversation that landed exactly right, the move that succeeded without your fully knowing why — she was behind it. The accomplishment was always hers. You are learning to let the doing be received rather than claimed."
6. "You have already been here. The grace that arrived when nothing should have worked. The softening that came from nowhere. The moment the impossible thing didn't happen, and you lived. The harm that passed around you without your understanding why. She was in every moment you emerged intact — not because you were clever or careful, but because she was already there."
7. "You have already been here. The word that arrived and moved something lodged for years. The silence that restored you better than any speaking. The sound — a voice, a tone, a name spoken in the right register — that shifted the body before the mind had time to interpret it. She works at the stratum where language is still an event, not a tool."
8. "You have already been here. In the moments when something moved perfectly through you — when will, knowing, and action were one — you were inside this triangle. The performance that transcended technique. The response that arrived before thought. The creation that felt like receiving. It was not your doing. You were the instrument she played."
9. "You have always been here. This is the only point. The whole yantra is her breathing outward from this single place. The whole game — the 102 Shaktis, the nine rings, the years of recognition — is her breathing back in. The Bindu is not the goal of the practice. It is what the practice is made of."
**App rosters (for the §1 reconciliation):** Ring 1 (ids 101–128): Animā, Laghimā, Mahimā, Īśitā, Vaśitā, Prākāmyā, Bhuktī, Icchā, Prāptiḥ, Sarvakāmāvalī | Brāhmī, Māheśvarī, Kaumārī, Vaiṣṇavī, Vārāhī, Māhendrī, Cāmuṇḍā, Mahālakṣmī | Sarvasaṅkṣobhiṇī, Sarvavidrāviṇī, Sarvākarṣiṇī, Sarvāhladinī, Sarvasammohini, Sarvastambhinī, Sarvajṛmbhiṇī, Sarvavaśaṅkarī, Sarvarañjanī, Sarvonmādinī. Ring 3 (301–308, each bīja 'hsauṁ', long-form qualities): Anaṅgakusumā, Anaṅgamekhalā, Anaṅgamadanā, Anaṅgamadanāturā, Anaṅgarekhā, Anaṅgaveginī, Anaṅgāṅkuśā, Anaṅgamālinī. Ring 4 (401–414): Sarvasaṅkṣobhiṇī, Sarvavidrāviṇī, Sarvākarṣiṇī, Sarvāhladinī, Sarvasammohini, Sarvastambhinī, Sarvajṛmbhiṇī, Sarvavaśaṅkarī, Sarvarañjanī, Sarvonmādinī, Sarvārthasādhikā, Sarvasampatpūraṇī, Sarvamantramayi, **Sarvasiddhipradā** (card 66 is Sarva-Dvandvakṣayaṅkarī). Ring 5 (501–510): Sarvasiddhipradā, Sarvasampadpradā, Sarvapriyakarī, Sarvamangalakāriṇī, Sarvakāmapradā, Sarvaduhkhavimochanī, Sarvamṛtyupraśamanī, Sarvavighnanivāriṇī, Sarvāṅgasundarī, Sarvasaubhāgyadāyinī. Ring 6 (601–610): Sarvajñānamayī, Sarvaśaktimayī, Sarvaaiśvaryapradā, Sarvajñānapradā, Sarvavyādhivinashinī, Sarvādhārasvarūpinī, Sarvapāpahara, Sarvānandamayī, Sarvarakṣakāriṇī, Sarvepsitaphalapradā. Ring 7 (701–712): Vāśinī, **Kāmeśvarī**, Modinī, Vimalā, Aruṇā, Jayinī, Sarveśvarī, Kaulinī, Sarvavāṅmayī, Sarvonmādinī, Sarvamantreśvarī, Sarvaśaktimayi (the four Weapons absent). Ring 8 (801–803): Kāmeśvarī (short "Icchā-Śakti"), Vajreśvarī (short "**Jñāna-Śakti**"), Bhagamālinī (short "**Kriyā-Śakti**") — [the app swaps Kriyā/Jñāna relative to the cards (100 Vajreśī = Kriyā, 101 Bhagamālinī = Jñāna) and the Ring 8 sourcing room keys the corner by position: 0 icchā · 1 kriyā · 2 jñāna]. Ring 9: Mahātripurasundarī (short Lalitā).
**NITYA_DEVIS** (15, tithi 1–15): Kāmeśvarī, Bhagamālinī, Nityaklinnā, Bheruṇḍā, Vahnivāsinī, Mahāvajreśvarī, Śivadūtī, Tvaritā, Kulasundarī, Nityā, Nīlapatākā, Vijayā, Sarvamaṅgalā, Jvālāmālinī, Citrā — "Distinct from the 102 Khaḍgamāla shaktis… Qualities + dhyānas flow from Airtable — DO NOT INVENT THESE FIELDS." (Not used by the Homes.)

---

### H-AXIS · The Axis — the fold (the one instrument)
**Source:** `The Homes - The Axis.html` 1–842 (identical copy at `handoff/The Homes - The Axis.html`, byte-identical by `cmp`).

**Stack / boot (1–26, 146–162, 188–214, 829–836).** three.js **0.184.0** from unpkg via importmap with **sha384 integrity hashes** (three.module.js, three.core.js, OrbitControls, OBJExporter, GLTFExporter — the latter three imported in the map but never used). Cormorant Garamond 300/400/500 + italic 300/400. Must be served over http (ES modules). Module versions pinned with `?v=`: homes-worlds v7, homes-chambers v28, homes-cards v5, homes-sound v5, homes-memory v2, homes-descent v1, homes-today v1 (3d-core unversioned). `all-shaktis-data.js` loaded as classic script first → `window.AVARANAS`, `window.SHAKTIS_BY_RING`. Boot veil `#boot` black, text "the axis" (12px, .3em tracking, uppercase, opacity .5) fades 900ms then removed after 1000ms.
- Renderer: WebGLRenderer antialias, powerPreference high-performance, pixelRatio min(dpr,2), SRGB output, **ACESFilmic tone mapping, exposure 1.04**, shadowMap PCFSoft.
- Scene: `FogExp2(0x000000, 0.014)`, background black. Camera **Perspective 60°, near 0.1, far 500**.
- Environment: 64×32 canvas linear gradient `#3a3a44 → #1a1a20 (0.5) → #0a0a0c`, equirect reflection mapping (a soft dim studio env for PBR).

**Roster (167–186).** For each ring 1–9: if cards exist for the ring, roster = cards mapped `{name: card.name, short, ring, pos: card.pos, quality, appName: app[k].name if it differs from card name else null}` (index-aligned with `SHAKTIS_BY_RING[r][k]`). If no cards → app list, or a placeholder `{name: WORLDS[r-1].name, pos:1}`. Comment: counts must come out 28·16·8·14·10·10·12·3·1. "The Śakti cards are the Airtable base… identity comes from the base, and the app's own name is kept alongside wherever the two disagree."

**Presences — the 102 as points of light (221–265).** Per world `wi`, list = RINGS[wi], `y = worldY(wi)`, gem colour `GEM[n].c`. Ring radius **R = 5.6 + min(count,28)×0.1** (Ring 1 = 8.4, Ring 9 = 5.7). Angle `a = (k/count)·2π − π/2`. Position `(cos a·R, y + 0.6 + sin(k·1.7)·0.5, sin a·R − 1.4)`. Each presence: halo sprite (radial glow white→transparent, tinted gem colour) size **1.5 if authored else 0.95**, opacity **0.9 authored / 0.5 not**; invisible pick sphere r 0.9 (8×6 segs) for raycast. **Met** → extra white core sprite size 0.5 op 0.9 ("she was expecting you"). **Presiding today** → white crown sprite size **3.4** op 0.9 ("you did not choose her").
- Pulse each frame (694–712): rate **0.22 met / 0.9 authored / 0.4 seat**; depth **0.09 met / 0.2 otherwise**; `pulse = (1−depth) + depth·sin(t·rate + pos)`; halo scale `base × (1.25 if met) × pulse × (1−swallow)`; opacity `(0.95 met / 0.9 authored / 0.5) × (1−swallow)`. Core scale 0.5·pulse; crown breath `0.86 + 0.14·sin(t·0.3)`, scale 3.4·br, op 0.85. Visible only within `WORLD_SPACING×1.2` of climb and while swallow < 0.7.

**Modes (state machine, 268–280, 634–827):** `axis` → `rite` (3 beats) → `entering` → `room` → `leaving` → `axis`. Plus descent (sub-state in room), library, letter, doors (walkTo restarts `rite` from the room).

**Travel on the axis (599–625, 665–669, 766–781).**
- Wheel: `target = clamp(0, TOP, target − deltaY×0.055)`; stops rising. Drag: yaw −= dx×0.0024, pitch −= dy×0.0016, pitch clamped ±0.5; yaw/pitch ease 0.06/frame. A tap = pointerup with movement ≤ 8px.
- **rise** toggle: `target += dt×3.4` until TOP−0.05 then auto-off; pressing rise at top resets climb to 0 (start again at the feet).
- Climb eases `climb += (target−climb)×0.06` (reduced motion 0.035).
- Axis camera eye: `(sin(t·0.07)·0.5, climb+1.2, 9 + cos(t·0.05)·0.4)` — a slow breathing drift. Look target 9 units ahead by yaw/pitch, y offset gz = −1.9 (in rooms −1.9 + swallow·1.6).
- Climb rail (right edge, 510–518): one button per world, labelled with **body region**, top = ring 9 (inserted at firstChild). Tick 14×1px, current 24×2px; opacity .32 / hover .8 / current 1; `.met` class (opacity .55, gold tick) when any Śakti of that ring is known — **marks that someone there has been met, never how many**. Click → target that world (axis mode only).
- `writeWorld(ix)` (488–500) on axis: ord line `"{form} · the {ordinal} āvaraṇa · {region}"`, name = world name, sub `"{gem} on {dhatu} · {clock}"`, mid = world's `weather` sentence; `presides` line "**she presides today**" only when the shown world is the presiding Śakti's ring. Shown world = i1 if k>0.5 else i0.
- Low line while on axis (783–791): nearest presence → `"{name} — hers is the day"` (presiding) / `"{name} — {card quality || 'her room is built'}"` (authored) / `"{name} — her seat awaits her mechanism"`. enter button reads "enter her", or **"turn to find her"** when none in view.
- `nearest()` (288–302): presences within 26 units and alignment (dot with camera forward) ≥ 0.55; score `dist × (2 − align)`.
- Hint (bottom-left): "scroll to climb · drag to turn · tap a light to enter her". Top text dims to .25 while dragging.

**Weather blending (672–692).** f = climb/WORLD_SPACING; i0,i1,k. Fog colour lerps fogCols. **Veil** = lerp of WORLDS.veil; base density = lerp(density) × **(1 + veil×0.55)**. Swallow = smooth(trav); **fog.density = base × (1 + swallow×1.6)**; background = fog colour × 0.5 × (1 − swallow×0.8). World bands visible only within WORLD_SPACING×1.15 and swallow < 0.96; each visible band updated with `t × WORLDS[ix].tempo` (tempo = world clock only).

**Entering — the rite IS the distance (304–388, 639–663).**
- `beginEnter(p)`: chamberHolder at her position, `buildChamber(world, shakti)` added, scale **0.02**; traces added (see Memory); headStart from memory; mode `rite`, beat 1, `travTo = STATION[1]`. STATION = **[0, 0.30, 0.62, 0.88, 1]**. Struck tone `voice.strike(ring, 1, syllable)`. Rite overlay fades in 700ms.
- Each touch (tap anywhere ≤8px movement, or the main button "go on"/"enter her") → `advanceRite()`: beat 2 → travTo .62, beat 3 → .88, then 4th touch: travTo 1, mode `entering`, rite overlay off. Strike tone at each beat. **Self-paced, never a timer, never skipped.**
- Trav eases `(travTo − trav)×0.03` (reduced 0.018). Beat duration **dur = 2.4s (reduced 3.4s) × memory.compression(her)** (compression 1.0 → 0.36 with dwell).
- Beat 1 — **her phrase** (`card.phrase` ‖ `AVARANAS[wi].appreciationPhrase` ‖ fallback "Thank you for what was always already here."): opacity `clamp(bp/0.34)×0.94`. 23px cream, .04em.
- Beat 2 — **her Devanāgarī** (`card.dev` ‖ her name), 38px, written by an unseen hand: 3 strokes; seg = min(2.999, bp×3); within each stroke eased = w/0.72 (stroke completes at 72% of its third); mask `linear-gradient(90deg, #000 pct%, transparent pct+7%)`.
- Beat 3 — **her roots** (`card.roots` if >1 part else `riteRoots(name)` morpheme split) as spans 25px; split = clamp(bp/0.58), join = clamp((bp−0.52)/0.48); **gap = (1−join)×split×30px** (they part and rejoin); gloss (her **quality** ‖ shakti.quality ‖ ava.subtitle) italic 16.5px fades in `clamp((bp−0.6)/0.4)×0.6`.
- riteRoots fallback morphemes — PREFIX `Sarva, Anaṅga, Mahā, Tripura, Kāmeśvarī, Vajreśvarī, Bhaga`; SUFFIX `ākarṣiṇī, karṣiṇī, mayī, pradā, kāriṇī, sundarī, mālinī, eśvarī, iṇī, inī` ("Only splits on morphemes that actually occur in the khaḍgamālā — never guessed from capitalisation").
- "touch to go on" / beat 3 "**touch to enter**" (mono 9px, .3em) appears at opacity .44 only when bp ≥ 0.99. Three beat dots bottom 88px: 4×4px; current 16px wide gold; done gold .6; pending cream .25; width/background transitions 500ms.
- During rite low line = `"{region} · {gem} on {dhatu}"`; the top shows `"{region} · the {ordinal} āvaraṇa"`, her name, her quality.
- `entering`: trav += dt/2.2 (reduced /3.4) to 1 → mode `room`, `chamberT = headStart`, enteredAt = t.
- Flight: camera lerps from axis eye to HOLD = her position with z + 7.4 − swallow×7.4, by smooth(trav); chamberHolder scale `0.02 + 0.98×swallow` — **the point becomes her room**; presences vanish past swallow .7; world bands past .96. "There is no transition screen anywhere."

**In the room (670, 714–719, 800–821).** `chamberT += dt × deepen` (deepen 1, or **14 with "stay"** → button reads "staying"). `chamber.update(chamberT)`; mid text = `chamber.label` (her near words, which change at second adaptation) whenever no descent and swallow > .5. Low line: **"you have stood here before"** if met and `chamberT − headStart < 14` s, else `"{name} · {gem} on {dhatu}"`. Main button "**return to the axis**" (also Escape key). Buttons shown in room: go deeper (only if a card), the library, doors, letter.

**Doors / corridor (390–410, 436–453, 549–556, 808–814).** Left/right vertical door strips (52×150px at top 34%, 1px gradient line, vertical mono 8px label of the neighbour's name, op .5), visible only in room with no descent and library closed. `neighbourOf(p, dir)`: Ring 2 → next sister **in the same R2_CLUSTER**, Ring 1 → next in **the same R1_FAMILY** (stepping around the ring in dir); otherwise simply ±1 around the circle. `walkTo(nb)`: closes library/letter/note, removes her room, clears descent, sets climb to neighbour's world, `beginEnter(nb)` and then **axisPos = where you were standing** (the crossing starts from inside, not from the axis) — the rite runs again; no cut.

**Library (412–426, 576–581, 78–87).** Sheet slides up (opacity 520ms linear, translateY 30→0 over 620ms cubic-bezier(.16,1,.3,1)), 88px tap-pad above closes it; radius 24px top, gradient rgba(14,10,14,.97)→rgba(9,5,8,.99), gold hairline. Label "the library". Rows (empty omitted): quality · esoteric tattva · bodily location · etymology (roots joined " + ") · inscription · devanāgarī · bīja (only if syllable known) · āvaraṇa ("n — name") · presiding form · world ("{gem} on {dhatu}") · clock · altitude · yoginī class · mental state · verb.

**Her Well letter (428–434, 557–561, 815–818, 88–96).** localStorage key **`homes.well.v1`** → JSON map `{ "<pos>": "letter text" }`. Only if present: a folded object (36px wide, 14px tall → 27px when open, 820ms cubic-bezier(.16,1,.3,1)) at right 22px / bottom 150px, op .85; tap toggles the note (italic 16px, op .66) above. Absent → nothing shown. **Never invented.**

**Go deeper (563–575, 737–741).** First press builds `buildDescent(card, GEM[ring])` inside the room, station 0, dzTo = STATION_Z[0]; each press → next station; past last → station −1, dzTo 0 (back up). dz eases 0.032 (reduced 0.018); camera z += dz; mid text = descent.words[station]. Button labels: "go deeper" → "further" → "come back up". Doors and letter hide during descent.

**Leaving (455–482, 664).** `beginLeave()` (room only): `memory.record(her, t − enteredAt)`; marks met, adds core light, marks rail; mode `leaving`; **after-effect**: top-left gold mono line "**her siddhi is still on the instrument**" fades in (1200ms) and out after 12 s; trav −= dt/2.4 → endLeave → axis. **Siddhi lingers:** tone-mapping exposure `1.04 + 0.12 × (1 − age/24)` for 24 s (lighter, decaying). [Note: brief says "never named" and "decaying over minutes"; the prototype both names it in this line and decays over 24 s — see conflicts.]

**Today (159, 224–229, 582–588, 721–735, 829–832).** `todaysPosition()` / `locate()` → presiding (wi, ix). Instrument **opens at her āvaraṇa**. "today" button → if in room/rite/entering → endLeave; climb to her world. At `Date.now() ≥ nextTurnover()` (6am) the crown moves to the new presiding Śakti in place, no reload.

**Forget me (589–597).** `memory.forget()`, removes all core lights and rail marks, headStart = 0.

**Sound wiring (533–538, 752–764).** "sound" toggle → `voice.start(); voice.wake()` / `voice.stop()`. Each frame if on: `setGround(i0,i1,k)` (crossfade by climb); with an active Śakti: `setCarrier(ring, swallow, syllable)`, `setRoom(smooth(chamberT/62), grantsFifth(her, ring, chamberT), ring, syllable)`; on axis: `setCarrier(ring_i0, 0)`, `setRoom(0.25, 0, ring_i0)`.

**Robustness (634–635, 825).** Frame wrapped in try/catch: "keep the last good frame rather than stopping". dt capped 0.05 s.

**Thumbnail (838–840):** 100×100 `#0D0508`, gold vertical line at x=50 op .5, eight cream `#FFF6DE` dots in a ring and one crown dot.

**UI CSS values (27–108):** gold `#C9963F`, cream `#F2E8D9`; top block at 32px (ord mono 8.5px .32em gold op .85; name 28px op .94; sub 13px italic op .68); mid 18.5px/1.5 bottom 120px width min(540px,86vw) op .92; presides mono 8.5px bottom 104px gold op .9; low mono 8.5px bottom 84px op .48; action buttons serif 11.5px .2em uppercase, 12×18 padding, min-height 44px, bg rgba(10,7,10,.5), border rgba(242,232,217,.18), pressed gold .9 border + gold .16 fill, blur 8px; after line gold top-left 34px.

---

### H-CORE · Shared 3D instrument (`homes-3d-core.js` 1–72; handoff copy identical)
"Nothing here decides what a room IS; it only supplies light, dust and geometry primitives."
- `clamp01`, `smooth(t) = t²(3−2t)` (smoothstep) — the easing used everywhere.
- `glowTexture(inner, outer)`: 128×128 canvas radial gradient: stop 0 = inner, **stop 0.32 = inner with alpha 0.55**, stop 1 = outer. "Stands in for bloom (no postprocessing in the pinned set)." Cached by key (`glow(key,…)`).
- `sprite(tex, color, size, opacity=1, blending=Additive)`: SpriteMaterial transparent, depthWrite false, **fog false**.
- `motes(count, spread{x,y,z}, color, size)`: real point dust (PointsMaterial, glow map, opacity **0.85**, additive, sizeAttenuation, fog false), random positions in the spread box, per-mote seed.
- `driftMotes(p, t, amp=0.5, fall=0)`: y = base + sin(t·0.14 + seed)·amp − fall·t·0.06; x = base + cos(t·0.09 + seed)·amp·0.5.
- `loop(pts2D, z, color, opacity=1)`: LineLoop, additive, depthWrite false.

### H-WORLDS · The nine worlds as weather (`homes-worlds.js` 1–563; handoff copy identical)
Header: "the nine āvaraṇas as WEATHER, not palette. One continuous vertical world: the body from Feet to Totality. Each band has its own air, its own light physics, its own material and its own clock. Shown empty — a world must be felt before any Śakti is set inside it."
**Geometry of the climb:** `WORLD_SPACING = 30`; `worldY(i) = i × 30` (Ring 1 at y=0 … Ring 9 at y=240). Axis TOP = 240.

**Full per-ring constants table (WORLDS 529–557 + RING_CHARACTER 517–527):**

| n | name | gem | dhātu | clock | region | fog colour | fog density | form | phase | yoginī | veil | state | tempo | verb | bīja |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Trailokyamohana | Topaz | Rasa | day–night | Feet | 0x1d1206 | 0.0125 | Tripurā | Śṛṣṭi | Prakaṭa — manifest | 0.00 | Jāgrat — waking | 1.00 | AGITATE | Aim |
| 2 | Sarvāśāparipūraka | Sapphire | Rakta | the hour | Pelvis | 0x0a1330 | 0.017 | Tripureśī | Śṛṣṭi | Gupta — secret | 0.12 | Svapna — dreaming | 0.82 | LIQUEFY | Klīm |
| 3 | Sarvasaṅkṣobhaṇa | Coral | Māṃsa | the day | Navel | 0x2a0c06 | 0.021 | Tripurasundarī | Śṛṣṭi | Guptatara — more secret | 0.24 | Suṣupti — deep sleep | 0.62 | DRAW | Sauḥ |
| 4 | Sarvasaubhāgyadāyaka | Diamond | Medas | lunar fortnight | Heart | 0x0b1219 | 0.014 | Tripuravāsinī | Sthiti | Sampradāya — lineage | 0.36 | Turīya begins | 0.72 | OPEN | Hrīm |
| 5 | Sarvārthasādhaka | Emerald | Asthi | lunar month | Throat | 0x06180e | 0.018 | Tripuraśrī | Sthiti | Kulottīrṇa — beyond clan | 0.48 | Turīya deepening | 0.66 | VOICE | Hsraim |
| 6 | Sarvarakṣākara | Ruby | Majjā | season | Forehead | 0x1a0409 | 0.022 | Tripuramālinī | Sthiti | Nigarbha — in the womb | 0.60 | Turīyātīta begins | 0.5 | STILL | Hsklhrīm |
| 7 | Sarvarogahara | Pearl | Śukra | solar half-year | Crown | 0xd8d2c4 | 0.034 | Tripurasiddhā | Saṃhāra | Rahasya — secret | 0.72 | Pure witness | 0.44 | WITNESS | Hsauḥ |
| 8 | Sarvasiddhiprada | Cat's eye | Ojas | year | Above crown | 0x0f0b04 | 0.015 | Tripurāmbā | Saṃhāra | Atirahasya — most secret | 0.86 | Source-consciousness | 0.36 | SEED | Aim Klīm Sauḥ |
| 9 | Sarvānandamaya | All gems | Tejas | kāla–akāla | Totality | 0x141008 | 0.009 | Mahātripurasundarī | Saṃhāra | Parāparāraharasya | 1.00 | Pure being | 0.28 | ARRIVE | Hrīm |

Weather sentences (shown as the mid line on the axis, verbatim): 1 "low light raking a vast floor, swinging horizon to horizon" · 2 "the air pulses — blood-warm waves through cold blue" · 3 "churn — the all-agitating. The air will not settle" · 4 "light split — three spectra crawling over glossy ground" · 5 "the world has bones; light arrives only in shafts between ribs" · 6 "nothing is lit from outside — every solid glows from within" · 7 "sourceless — luminous fog and no shadow anywhere" · 8 "one travelling band of light; everything else waits in the dark" · 9 "every gem at once, which is the same as no weather at all".
[Note: tempo is *not* monotone in code — ring 3 = 0.62 < ring 4 = 0.72; the handoff describes tempo "1.00 → 0.28". Veil is monotone 0 → 1.]

**W1 · FEET · bandFeet (14–66).** Floor Plane 120×120 (60×60 segs) `MeshStandard 0x8a6330 rough .96 metal .03` "topaz-ground" at y−3.2, receives shadow. **11 standing stones** (Box 1.1×h×1.1, `0x6b4a24` rough .92 "standing-stone"): angle i/11·2π+0.4, radius 11+(i%3)·6, h = 3+(i%4)·2.2, cast+receive shadow — "things that exist only to be raked — long shadows are the weather". **Sun** DirectionalLight `0xffc367` 6.4, shadow 1024², ortho ±46, near .5 far 140. Sun disc sprite (glow rgba(255,226,150)→rgba(180,110,30,0)) size 22 op .6. Hemisphere `0xffd28a / 0x2a1608` 1.8. Dust 90 motes spread 60×12×60 `0xffe0b0` size .16.
 Clock: `day = (t×0.05) mod 1` (one day–night every **20 s** of world time); ang = day·2π; alt = sin ang; sun at `(cos ang·60, y−3.2 + max(−4, alt·34), sin(ang·0.6)·26)`; night = clamp(−alt·2); sun intensity 6.4·clamp(alt·1.6+0.2); disc opacity .6·clamp(alt+.4); hemisphere lerp 1.8 → 0.3 by night; motes amp .5.

**W2 · PELVIS · bandPelvis (68–112).** 7 ring loops (72-gon, `0xff5c6e` op .5) flat at y−2.8, phase i/7. Pool Circle r30 `0x1c3059` rough .3 metal .3 "rakta-floor". Beat PointLight `0xff4d5e` 400, dist 44, decay 2 at y−2; heart sprite (rgba(255,120,130)→rgba(120,20,40,0)) size 12 op .4; cold Hemisphere `0x6f9dff/0x0a1430` 2.6; 120 motes 30×16×30 `0xbfd8ff` .13.
 Clock: bpm = t×1.05; **systole `sys = max(0, sin(bpm·π))^6`**; each ring p = (bpm·0.5 + phase) mod 1, scale 1.4 + p·27, opacity (1−p)·0.62·(0.4+0.6·sys); beat light 120 + sys·900; heart scale 10 + sys·9, op .24 + sys·.5; motes amp .4.

**W3 · NAVEL · bandNavel (114–168).** **2,600-point GPU flow field.** Positions: r = rand^0.6·20, y ±11; aSeed 0–6.28, aSize 1.6–6.0. ShaderMaterial additive, depthWrite false. Vertex: `flow(p,t) = (sin(p.y·.19 + t·.5) + cos(p.z·.14 − t·.31), sin(p.z·.16 + t·.42) + cos(p.x·.12 − t·.27), sin(p.x·.17 − t·.36) + cos(p.y·.13 + t·.29))`; `p += flow(p, uTime+aSeed)·2.6 + flow(p·2.1, uTime·.7)·.9`; vA = .35 + .65·(.5+.5 sin(uTime·.6 + aSeed·4)); `gl_PointSize = aSize·(240/−mv.z)`. Fragment: soft disc smoothstep(.5,.05,d), colour **(1.0, 0.46, 0.32)**, alpha a·vA·**0.34**. Hemisphere `0xff7a52/0x2a0a06` 1.6; core PointLight `0xff6a44` 320 dist 40; update core = 280 + sin(t·.4)·90.

**W4 · HEART · bandHeart (170–247).** Floor Circle r34 `0x223040` rough .2 metal .35 "medas-gloss" at y−3.4. **Three caustic planes** 86×86, additive, op .6, fog false, tints red `0xff4d4d` (offset 0), green `0x4dff8a` (2.1), blue `0x6a8cff` (4.2), stacked y−3.3 + i·0.02. causticTexture: 256² black canvas, 'lighter' compositing, 46 strokes rgba(255,255,255,.42) width .7–3.1, 26 segments each (`px += cos(k·.5 + i + seed)·11 ± 3.5`, `py += sin(k·.42 + i·1.7 + seed)·11 ± 3.5`), repeat wrapping. **Prism** Octahedron r2.4 MeshPhysical white rough .05 **transmission .96, thickness 2.2, ior 2.4, dispersion 4, clearcoat 1** "diamond" at (0, y+1.6, −3). Key Directional white 5.2 at (6, y+20, 8); Hemisphere `0xdff0ff/0x0a1018` 2.0.
 Clock: `fort = .5 + .5 sin(t·0.0398)` (lunar fortnight ≈158 s period); spectra map offset `(sin(t·.037·s + i)·.4, cos(t·.029·s + 2i)·.4)`, repeat s = 1 + i·0.11; opacity .42 + .4·fort; prism rotation (t·.07, t·.11, 0); key 2.6 + fort·4.4.

**W5 · THROAT · bandThroat (249–303).** **72-instance colonnade** (InstancedMesh, Cylinder r .34/.5, h 20, 12 segs; `0xd8e8d0` rough .78 metal .06 "asthi"): 3 rings × 24, radius 12 + ring·7, angle k/24·2π + ring·0.13, y ±0.8 alternating, tilt z 0.04·(ring−1), y-scale 1 − ring·0.1; cast+receive shadow. **24 shaft planes** 2.6×22 `0x8ff2b8` op .06 additive double-sided, at r12.6 between ribs (offset π/24). Above Directional `0xd6ffe4` 4.6 at (2, y+24, 3); core PointLight `0x2fe08a` 700 dist 46; Hemisphere `0x7fe0a8/0x06180e` 1.2.
 Clock: `moon = .5 + .5 sin(t·0.0199)` (lunar month ≈316 s); shaft op .06 + .16·moon·(.4 + .6·|sin(t·.13 + i·.6)|); core 380 + moon·620; above 2.2 + moon·3.4.

**W6 · FOREHEAD · bandForehead (305–354).** Shell material MeshPhysical `0x5a0a16` rough .46 **transmission .6, thickness 2.6, ior 1.76, attenuationColor 0x8b1a2a, attenuationDistance 1.4, emissive 0x8a0c1c ×2.2** "majja-shell". 9 bodies cycling Icosahedron(2.6,1)/Dodecahedron(2.2,0)/Octahedron(2.8,1), angle i/9·2π, r 9 + (i%3)·4.6, y sin(i·1.7)·5.4; **a PointLight `0xff3a52` 420 dist 22 inside each — "the marrow itself"**. Floor Circle r32 `0x1a0509` rough .86 "marrow-ground" y−3.6. Ambient `0x4a1018` 2.0. 90 motes `0xff8a9a` .13.
 Clock: `season = .5 + .5 sin(t·0.0066)` ("barely moving", ≈952 s period); emissive 1.5 + season·1.6; attenuationDistance 1.1 + season·0.9; bodies rotate (t·.04 + i, t·.03 − i), bob sin(i·1.7 + t·.07)·5.4; inner lights 240 + season·420·(.6 + .4 sin(t·.21 + i)).

**W7 · CROWN · bandCrown (356–392).** "Sourceless. Luminous fog and no shadow anywhere — light from everywhere at once, so there is nothing to orient by." 7 barely-there planes 20×20 `0xf6f1e6` op .035 at r17 ("only so the milk has something to be in front of"); 5 veil sprites (rgba(255,252,244)→rgba(220,210,190,0)) `0xfbf6ec` size 40 + i·12 op .13; **Ambient `0xf6f1e6` 2.6 + Hemisphere white/`0xe8e2d4` 1.7 — zero directional lights**; 150 motes `0xfffaf0` .14. Fog colour is light (0xd8d2c4) and densest (0.034).
 Clock: `half = .5 + .5 sin(t·0.0033)` (solar half-year ≈1904 s); veil op .08 + .1·half·(.5 + .5 sin(t·.05 + i)); scale ×(1 + .05 sin(t·.04 + i)).

**W8 · ABOVE CROWN · bandAboveCrown (394–454).** **Chatoyancy shader**: Sphere r30 (64×48) BackSide; fragment: n = normalize(pos); axis = (cos uAngle, sin uAngle); d = |dot(n.xz, axis)|; **band = (1−d)^22**; haze = max(0, 1−|n.y|)²·0.16; colour mix((0.20,0.15,0.06), (1.0,0.90,0.58), band); alpha band·0.95 + haze. Ridge Cylinder r .14 len 54 `0xfff0c0` "the-band" horizontal. Sweep PointLight `0xffe9a8` 900 dist 60; halo sprite size 30 op .28; Ambient `0x4a3a1c` 2.0; floor Circle r30 `0x2a2110` rough .3 metal .4 "ojas-ground".
 Clock: `yr = t·0.062` (one revolution ≈101 s); uAngle = yr; ridge.rotation.y = −yr; s = |sin(2yr)|; sweep at (cos yr·16, y, sin yr·16) intensity 500 + s·900; halo scale 24 + s·14.

**W9 · TOTALITY · bandTotality (456–509).** Nine gem lamps (PointLight 320 dist 54) in colours **[0xffc367 topaz, 0x6f9dff sapphire, 0xff6a44 coral, 0xdff0ff diamond, 0x2fe08a emerald, 0xff3a52 ruby, 0xfbf6ec pearl, 0xffe9a8 cat's eye, 0xffffff]** at r15, y sin(i·2.3)·8, each with a sprite size 9 op .42. Yantra: three circles r 7 / 9.4 / 12 (84-gon, `0xfff6de`, op .2/.16/.12) flat; three up-triangles (apex ay 6.4/5.1/3.8, base −2.6/−2.1/−1.5, half-width ay·0.92) and three inverted, op .34. Core sprites: (white→rgba(201,150,63,0)) `0xfff6de` 16 op .85 and (rgba(255,246,222)→rgba(120,80,20,0)) `0xffe9b8` 46 op .24. Ambient `0xfff0d0` 1.5; 220 motes `0xfff6de` .13.
 Clock: lamps orbit a + t·0.014, r 15 + sin(t·.05 + i)·3.4, intensity 240 + 180·(.5 + .5 sin(t·.19 + i·.7)); yantra.rotation.y = t·0.008; core breath .9 + .16 sin(t·.13).

All world clocks are multiplied by the ring's **tempo** in the Axis (world time only — never her adaptation clock).

---

### H-LIGHT · Her light — the Atmosphere port (`homes-chambers.js` 12–78)
"A verbatim port of Atmosphere.swift. Every number here is the repo's, not a design choice: ringHue, clusterHue, the ±7° per-Śakti jitter keyed off her khaḍgamālā position, and the 20% ground blend. Ring 2 seeds from her CLUSTER, never from a ring hue — sisters of a cluster share a light as well as a corridor. The gem's own word ('pearl — milky, diffuse, sourceless') is kept, but only as the light's BEHAVIOUR… Hue, saturation and lightness belong to the app."
[Note: the "20% ground blend" is named in the comment but not implemented anywhere in this file.]

| ring | H | S | L | gem (behaviour) | diffuse |
|---|---|---|---|---|---|
| 1 | 35 | 58 | 54 | Topaz | 0.20 |
| 2 | 43 | 78 | 52 | Sapphire | 0.30 |
| 3 | 341 | 45 | 58 | Coral | 0.45 |
| 4 | 353 | 55 | 48 | Diamond | 0.15 |
| 5 | 18 | 62 | 55 | Emerald | 0.25 |
| 6 | 194 | 42 | 46 | Ruby | 0.55 |
| 7 | 322 | 38 | 50 | Pearl | 0.95 |
| 8 | 2 | 68 | 50 | Cat's eye | 0.10 |
| 9 | 46 | 72 | 66 | All gems | 0.70 |

Ring 2 cluster seeds (by position): **inner 29–31 → [43,78,52] · tanmātra 32–36 → [13,47,56] · citta 37 → [180,49,32] · stability 38–41 → [140,24,38] · selfBody 42–44 → [270,26,48]**.
- `atmosphereJitter(kp, range)`: `frac = ((kp × 2654435761) mod 1000 + 1000) mod 1000 / 1000; return (frac − 0.5) × range` — called with **range 14 → ±7°** hue.
- `gemFor(ring, kp)` returns `c` = hsl(h, S, L); `ink` = hsl(h, S×0.55, **12**) (dark material colour); `bright` = hsl(h, min(S+10, 88), min(L+18, 78)); hue, sat, light, diffuse, gem name, cluster. Without kp → unjittered ring seed = "the world shown empty". `GEM[r] = gemFor(r)` for r = 1..9.

### H-CLOCK · Her adaptation clock (`homes-chambers.js` 80–85, used by every room)
- **First adaptation:** `a = smooth(t/62)` — 0→1 over **62 s** of real elapsed time.
- **Hold** until **HOLD_END = 227 s**; **second adaptation** `deep(t) = smooth((t − 227)/120)` — 0→1 over **120 s** (complete at 347 s).
- Label flips to the second-adaptation words when **b > 0.45**.
- "the second adaptation is never 'more of the same': in every room it REVERSES the room's own premise." Only a returning practitioner reaches it (head start from dwell) — or "stay" (×14) for review.

### H-SEAT · Seat plans & the shared floor (`homes-chambers.js` 87–166)
- SEAT shape per ring: **1 square · 2 petal · 3 petal · 4–8 tri · 9 circle** (30-gon). Square = [±1,±1]; tri = (0,1),(±0.95,−0.62); petal = 12-step lens `x = sin(πt)^1.4 × 0.62, y = −cos(πt)`.
- `seatShell(ring, r=6, depth=26, mat)`: ExtrudeGeometry of the seat shape × r, depth, no bevel, translated z −0.62·depth — "a shell whose cross-section is her seat, extruded away from you".
- `gemLight(ring, intensity, dist=40)` = PointLight in GEM colour, decay 2.
- `aperture(ring, kind, scale)`: white core sphere r 0.16·scale; gem sprites 4.4·scale op .9 and 13·scale op .28. Kind `tri-down` adds "womb-seal" downward triangle (−2.2,1.4)(2.2,1.4)(0,−2.4) `0xfff2e4` op .8; kind `triad` adds three white spheres r .42 on a 1.5 circle ("seal-0..2").
- **chamberSeat — "her seat, from inside"** (the floor every un-authored Śakti inherits; in the final build only reached if neither name nor card resolves): BackSide `MeshStandard(ink, rough .9, metal .05)` "dhatu" shell r 6.4 depth 28; aperture at z −15.6; key gemLight 1500 dist 52 at z −15; fill 260 dist 30 at (0,1.2,−3); Ambient gem 1.1; 90 motes 10×10×22 size .11; additive seam edges op .3. Update: a = smooth(t/62); key 700 + 1500a; seams .16 + .34a; aperture scale .6 + .6a. Label "**her seat, from inside**".

### H-MECH · The authored mechanisms (`homes-chambers.js` 168–714)
Each: label (first) → label (second, when deep > .45). All conditioned by world: shell colour = her ring's gem `ink`, light = gem `c`, seat shape = her ring's.

**M1 · CONTRACT · Aṇimā (168–211).** BackSide dhatu shell (rough .92) r 6.4 depth 26 + additive edges op .36; aperture at z −14.5; key gemLight 900 dist 46 at z −14; ambient .45; 110 motes. "the-beyond": white sprite 30 + gem sprite 72, both op 0, at z −18.
 Update: `k = 0.34 + 0.66 × (1 − smooth(t/62))` (walls contract to **34%**); shell scale (k, k, 1 − (1−k)·0.4); aperture scale `(0.5 + 0.5/k) × (1 + b·11)` (widens **twelvefold** at second); **key = 900/k²** (light concentrates as the room tightens); edge op (.2 + .4(1−k))·(1−b); shell goes translucent `opacity 1 − b·0.94`; beyond op b·.9 / b·.45, travels z −18 → **−5** (−18 + 13b) toward you. Words: "**the walls close while you stand still**" → "**the point was a door all along**". Comment: "she grants entry into any place however confined — so the point widens, and what you took for the far wall is the way through."

**M2 · ENDLESS · Mahimā (213–257).** 24 seat-shaped frames (r 6 + i·0.52) over SPAN 120 recycling toward you at **3.4 units/s**; opacity `sin(π·clamp((z+120)/120))·0.95 + 0.06`; ambient 1.4; haze sprite 60 op .16 at z −58; near gemLight 900; 140 motes z-spread 100. 10 "behind" frames (z 6→66) opacity `b · sin(π·clamp(1 − (z−6)/60)) · 0.75` — "there was no near wall either. They continue behind you." Words: "**no far wall · it never arrives**" → "**you were never inside anything**".

**M3 · RELEASE · Laghimā (259–366).** Four cloth walls (Plane 26×13, 26×40 segs) at ±13, y 1.4 — **GLSL vertex displacement**: hem = smoothstep(0.62, 0, uv.y); `p.y += hem·(uLift·2.4 + sin(uTime·.42 + p.x·.55)·.42·hem)`; `p.z += hem·sin(uTime·.31 + p.x·.42 + uv.y·3)·.34` ("walls end before the ground, hems lifting"). Fragment: fade smoothstep(0,.34,uv.y); grad uv.y^1.4; col mix(gem·0.05, mix(gem, white, .3), grad)·(.94 + .06 sin(uv.y·240)); out col·0.52, alpha fade·.78·(1 − hem·.45·uLift) — "the walls are cloth, not light — the brightness in this room is overhead". Lid RingGeometry 2–12.4 gem op .18 at y 8.4; sky sprite 16 op .32 at 8.4; "the-released-ground" black disc r16 op .55 at y −9.5 ("so there is a dark to rise from"); Directional gem 3.0 from above; ambient .5.
 **Rising field "nothing-falls"**: 340 points, radius 4–18 ("never inside the eye: the field begins a little way out"), span 24; y = mod(y + t·(0.34 + lift·1.5) + seed·.9 + 12, 24) − 12 (rise speeds up with lift); **gl_PointSize clamped 1.0–9.0** ("additive motes at arm's length otherwise stack to pure white"); colour mix(gem, white, .5), alpha ·0.3.
 Update: lift = smooth(t/62). Second: walls rise `y = 1.4 + b·(15 + i·2.4)`, tilt −b·.17; lid descends 8.4 − 5.4b, op .18 + .2lift + .3b, scale 1 + 1.5b; sky y 8.4 − 7.4b, scale 16 + 8lift + 30b, op .32 + .34b; above 3.0 + 3.4b; ground op .55(1−b). "as the walls go, the opening they were hanging from takes the whole room." Words: "**the floor has let go**" → "**the room has let go of itself**".

**M4 · KNOWN · Vaśitā (368–417).** Box room 16×10×30 BackSide `0x9c8ad0` "known-stone"; 6 pillars (Cyl .42/.5 h10) `0xb2a0e0` at x ±5.6, z −3, −10, −17; seat Cyl 1.9/2.3 h .5 at (0,−4.7,−11); torus ring r1.5 `0xe4d8ff` op .7. **SpotLight `0xd8caff` 2400, dist 44, angle 0.4, penumbra 0.88, decay 1.55**, shadows 1024². Halo sprite `0x9a86c4` 14 op .14; ambient `0x2e2650` 2.4; 100 motes `0xd6c8ff`. [Its colours are fixed violet — not gem-derived.]
 Update: wander target wx = sin(t·.16)·5.2 + sin(t·.058)·1.8; wz = −11 + cos(t·.125)·5.4; wy = −2.4 + sin(t·.093)·2.1. Second: the pool converges on the observer: x = wx(1−b), y = wy(1−b) − .4b, z = wz(1−b) + .8b; spot position (x·.42(1−b), 3.2 − 2.4b, z + 5.2 − 9.8b); angle .4 − .17b; intensity ×(1 + .7b). Ring opacity rises when the pool is near the seat. Words: "**the room exists only where attention rests**" → "**it has turned, and it rests on you**". ("mastery is not holding attention. It is being found by it.")

**M5 · MEMBRANE · Sarva-Yoni (419–487).** Lathe vessel (37-point profile r = max(.06, 7.6·sin(π(.10 + .82u))^.82), y −9 → 9.4, 64 segs) in **MeshPhysical `0xd4795c` rough .42 transmission .94 thickness 3.4 ior 1.38 attenuation `0x8c2e1e` @2.6 sheen .7 `0xffc9a8` sheenRough .6 clearcoat .34** (DoubleSide). 8 veins (Tube r .04 along CatmullRom) `0xffb894` op .4 additive. Aperture `tri-down` (womb-seal) at (0,−3.4,−5.4). **Backlights** `0xffb08a` at (0,6,−13) 540 · (−12,1,−6) 420 · (12,1,−6) 420 · (0,−8,−11) 320 · (0,3,13) 250; inner `0xffd9bc` 130; ambient `0x4a1a14` 1.6. Nested vessels ×1.55/2.3/3.2 additive op 0.
 Update: breath br = sin(t·0.28) (**≈22.4 s breath**): vessel scale (1 + .032br, 1 − .02br, 1 + .032br); thickness (3.4 + .7br)(1 − .72b); attenuationDistance 2.6 + .35br + 5.4b; aperture .7 + .4k + .5b; lamps ×(.62 + .5k)(1 + .5b); veins (.16 + .34k(...))(1 − .5b); nested opacity clamp(2b − .5i)·(.12 − .024i). Words: "**no door · you were always inside**" → "**source within source · it was never one womb**".

**M6 · TRIPLE · Sarva-Trikhaṇḍā (489–537).** "Three rooms in one place. In the axis this is done as three tinted shells that slide into register, so it stays single-pass and the travel never cuts." Three ghosts tinted **0xff5a52 / 0x4fe0a8 / 0x6f8fe0**, each 5 seat-shape loops (r 6.4, z −3 − k·5.4) + 4 edge lines (z 2 → −25) + a seal sphere at z −24. "one" white sprite at z −24. Ambient `0xb0b0d0` .8.
 Update: settled = 1 − smooth(t/62); breath = (.5 + .5 sin((t − 227)·0.085))·0.58; sep = settled(1−b) + breath·b; offsets [(−1,−.42),(1,−.22),(.08,1)] × sep × (1.5, 1.4), rot z off·sep·.035; loop opacity .28 + .36sep; one opacity (1−sep)·.95 + .3b, scale 3 + 5(1−sep) + 2b. Words: "**three rooms · one seal, only in stillness**" → "**three and one, and always both**". [Note: despite the label, convergence is by elapsed time, not stillness.]

**M7 · DISSOLVE · Mahātripurasundarī (539–598).** Gold `0xfff2cf` yantra of loops: 3 squares r 13/11.6/10.2 (op .3/.24/.18) at z 0/−.9/−1.8; circles r 9 and 8.1 (56-gon) op .34; **16-petal ring** (r 6.4→8.9, w .62, z −3.6) and **8-petal ring** (4.9→6.3, w .78, z −4.4); **4 upward triangles** (apex 5.5/4.4/3.4/2.3) and **5 downward** (5.5/4.7/3.9/3.0/1.9), half-width apex·0.92, op .46, staggered z −5…−7.5. Bindu: sprites 7.5 op .95 and 22 op .3 + white sphere r .2 at z −8.4. Ambient `0xfff0d0` .5; 180 motes.
 Update: br = sin(t·0.115); yantra scale (.94 + .07br)(1 + 2.1b), z = 7.4b (passes behind you), rotation z t·.0075; triangles counter-rotate −t·.014; **bindu z −8.4 → 0 (at your position)**, scale (.85 + .2 sin(t·.19))(1 + 2.8b), glow ×(1 − .55b); dust amp .55 + .8b. Words: "**there was never anyone here but Her**" → "**the bindu is where you are standing**".

**M8 · PRESS · Garimā (600–714).** strataTexture: 32×512 canvas bands 5–27px, grey value random-walk 14–232 (step (rand − .42)·90), each band gradient v → .55v; repeat 3×3. Ground Plane 46×46 **180×180 segs** with **displacementMap strata scale .5 bias −.2, bumpMap .9** at y −5.2 ("procedural displacement mapping"). Ceiling slab Box 46×4.4×46 "descending-mass" at y 11, casts shadow; underside plane (80×80) displacement .7 bias −.35 bump 1.1; gem rim op .5. Three walls (46×22) left/right/back "pressed-stone". **Palm-press** Cylinder 2.1/2.5 h .42, emissive gem ×1.4, at (0,−5.3,−7); ember sprite 9 op .42; ember PointLight 1300 dist 34; **raking Directional gem 3.6 at (9,6,4) shadow 1024², ortho ±24**; ambient gem **3.2**; 110 motes falling (driftMotes fall=1). `shadows: true`.
 Update: k = smooth(t/62): slab y = 11 − 7.4k (+5.2b at second); ground displacement .5 + 1.9k (+1.4b), bump .9 + 1.6k; rim op .32 + .4k; ember light 1300 ± 130 (sin t·.5); raking 3.6 − 2k. Second: press emissive 1.4 + 3.4b, scale 1 + 1.8b. Words: "**the ceiling is coming down**" → "**the weight was holding you all along**". ("the weight was never above you. It is what you are standing on, and it has been holding you the whole time.")

### H-RESOLVE · Resolution order (`homes-chambers.js` 716–769)
`BY_NAME` keys (exact strings): **'Animā'** → contract · **'Laghimā'** → release · **'Garimā'** → press · **'Mahimā'** → endless · **'Vaśitā'** → known · **'Sarvayoni'** → membrane · **'Sarvatrikhaṇḍā'** → triple · **'Mahātripurasundarī'** → dissolve. `AUTHORED = keys`.
`buildChamber(world, shakti)`: card = findCard(shakti, ring, __ix) → (1) if BY_NAME[shakti.name] → authored mechanism + attribute; (2) else if card and card.ring ∈ {1..8} → `buildFromCard(world, card, gemFor(ring, card.pos), BIJA[card.pos])` + attribute; (3) else chamberSeat + attribute. `isBuilt` = authored name or card in rings 1–8. `withAttribute` adds `buildAttribute(card, gemFor(ring, pos))` to the room group, chains its update, sets `chamber.attribute = key`.
**Builder warning — VERIFIED by running the resolution over all 102 cards:** the Axis roster takes names from the cards (`Aṇimā`, `Vaśitva`, `Sarva-Yoni`, `Sarva-Trikhaṇḍā`), so the exact-string keys `'Animā'`, `'Vaśitā'`, `'Sarvayoni'`, `'Sarvatrikhaṇḍā'` (which are the *app's* spellings) never match. **In the Axis as shipped, four of the eight authored mechanisms are unreachable**: Aṇimā (pos 1) and Vaśitva (pos 6) get the Ring 1 Siddhi archetype ("smallness · lent, not shown", "mastery · lent, not shown"), Sarva-Yoni (27) and Sarva-Trikhaṇḍā (28) get the Mudrā archetype ("source · a seal you stand inside", "trinity-as-unity · a seal you stand inside"). Only Laghimā (3), Garimā (4), Mahimā (2) and Mahātripurasundarī (102) actually receive their authored rooms. There is no name routing in `homes-grammar.js`. The thread's claims ("seven mechanisms authored", Aṇimā's beyond −18 → −9.4) describe the chamber functions, not what the walker meets. **Port: key authored mechanisms by khaḍgamālā position — 1 contract, 2 endless, 3 release, 4 press, 6 known, 27 membrane, 28 triple, 102 dissolve** (Invariant 6). Ring 9 is not in FAMILY_RINGS, so if the name ever failed, the Bindu would fall to the seat.

---

### H-GRAMMAR · The mechanism grammar (`homes-grammar.js` 1–831; handoff copy identical)
"Her ring gives the archetype; her own card fields tune it. This is how 58 seats become 58 rooms with a RULE, rather than 58 hand-builds — and how the room could never belong to anyone else." Ring → archetype header: 3 Anaṅgas → BODILESS (effect with no source) · 4 Sampradāya → COSMIC (one gesture at the scale of worlds) · 5 Kulottīrṇa → GIVING (something arrives, from beyond) · 6 Nigarbha → REVEALING (it was already here; the veil thins) · 7 Vāsinīs → SOUNDING (the room is made of her syllable) · 8 the Triad → SOURCING (will, act, form at the origin) · 9 the Bindu → its own room, authored. "Her tattva sets the physics; her body-location sets the altitude; her position sets the phase, so no two neighbours move alike."
Same clock as chambers: HOLD_END 227, SECOND 120; label words from `quality` lower-cased.

**Physics classifier (33–89).** Text = `(tattva + ' ' + quality).toLowerCase()`; **first match wins, in this exact order** (50 patterns; default `breathe`). "An audit found 78 of 102 falling through to one generic motion…"

| # | regex | kind | displacement [x, y, z] (p = phase·2π; s(f)=sin(tf+p), c(f)=cos(tf+p), pulse(f)=|sin(tf+p)|) |
|---|---|---|---|
| 1 | `stambha|paralyz|cosmic stillness` | arrest | [0,0,0] |
| 2 | `vik[āa]sa|jṛmbha|yawn|expansion` | expand | [0, s(.09)·1.6A, 0] |
| 3 | `mahat|vastness` | widen | [s(.06)·2.2A, 0, c(.06)·2.2A] |
| 4 | `aṇu|atomic|smallness` | shrink | [s(.14)·.2A, 0, −pulse(.1)·1.4A] |
| 5 | `dravat|liquef|melting|fluid` | flow | [s(.21)A, s(.13)·.5A, 0] |
| 6 | `apaḥ|\bjala\b|water` | well | [0, pulse(.11)·1.5A, 0] |
| 7 | `pṛthiv|pṛthv|bh[ūu]mi|earth|weighted` | settle | [0, −pulse(.07)·1.3A, 0] |
| 8 | `tejas|agni|\bfire\b|fierce` | flare | [s(.6)·.4A, pulse(.5)·.9A, 0] |
| 9 | `v[āa]yu|\bair\b|lightness` | lift | [s(.12)·.4A, (.5+.5s(.1))·1.7A, 0] |
| 10 | `[āa]k[āa][śs]a|\bkhe\b|ether|sky|void|freedom` | open | [s(.05)·1.8A, c(.04)·1.2A, s(.045)·1.8A] |
| 11 | `kṣobha|agitat|stir` | stir | [c(.42)A, s(.51)·.4A, s(.33)A] |
| 12 | `[āa]karṣaṇa|karṣaṇa|magnet|attract` | draw | [0, 0, s(.11)·1.4A] |
| 13 | `moha|bewilder|unm[āa]da|intoxicat|\bmada\b` | waver | [s(.16)·1.3A, s(.09)·.6A, 0] |
| 14 | `advaita|non-dual` | merge | [−s(.08)·.3A, 0, 0] |
| 15 | `vega|veloc|impulse|lightning|kriy[āa]` | dart | [s(.9)·.5A, 0, s(1.3)·.4A] |
| 16 | `p[āa][śs]a|\bbind\b|mekhal|embrace|encircl|rakṣa|protect` | encircle | [c(.24)A, 0, s(.24)A] |
| 17 | `aṅku[śs]a|goad|hook|direct` | point | [0, 0, −pulse(.17)A] |
| 18 | `virah|longing|separation` | reach | [0, pulse(.13)·1.2A, −pulse(.13)A] |
| 19 | `rekh|outline|suggest` | trace | [s(.19)·1.5A, c(.19)·.7A, 0] |
| 20 | `pralaya|kṣaya|\blaya\b|vin[āa][śs]|dissolution|liberation` | dissolve | [s(.3)·.6A, −pulse(.09)·.8A, c(.27)·.6A] |
| 21 | `p[ūu]rṇa|sampat|abundance|fullness|wholeness` | fill | [0, (.5+.5s(.055))·1.4A, 0] |
| 22 | `b[īi]ja|seed|potential` | compress | [s(.2)·.15A, 0, −pulse(.06)·.5A] |
| 23 | `yoni|source|bhaga` | spring | [0, pulse(.16)·1.8A, −pulse(.16)·.5A] |
| 24 | `sthiti|sustenance|preserv` | sustain | [0, s(.045)·.35A, 0] |
| 25 | `v[āa]c|[śs]abda|mantra|speech|sound` | sound | [0, s(1.6)·.3A + s(.2)·.5A, 0] |
| 26 | `jñ[āa]na|buddhi|sarvajñ|knowing|knowledge|insight` | clarify | [s(.1)·.25A, 0, −(.5+.5s(.08))A] |
| 27 | `ahaṅk[āa]ra|\bego\b|i-mak` | assert | [0, pulse(.19)·.9A, pulse(.19)·.5A] |
| 28 | `[śs]rotra|tvak|cakṣus|jihv|ghr[āa]ṇa|indriya|sense|touch|taste|scent|form\b` | lean | [s(.13)·1.1A, 0, −pulse(.13)·.7A] |
| 29 | `[āa]nanda|bliss|joy|āhl[āa]da` | swell | [s(.07)·.8A, (.5+.5c(.07))A, s(.07)·.8A] |
| 30 | `[āa]dh[āa]ra|support|foundation` | ground | [0, −.5A − pulse(.04)·.3A, 0] |
| 31 | `icch|saṅkalpa|\bwill\b|willing` | incline | [s(.1)·.5A, s(.1)·.4A, −pulse(.1)·.9A] |
| 32 | `siddhi|phala|pr[āa]pti|attain|fulfil|accomplish` | arrive | [0, 0, −A(.5+.5s(.075))] |
| 33 | `saundarya|sundarat|puṣpa|beauty|adornment` | bloom | [c(.09)·1.3A, pulse(.09)·.5A, s(.09)·1.3A] |
| 34 | `smṛti|smaraṇa|memory|recollect` | recur | [s(.24)·.9A, 0, s(.12)·.9A] |
| 35 | `n[āa]ma|\bname\b` | call | [0, s(.3)·.4A, −s(.15)·1.1A] |
| 36 | `[āa]tm|\bself\b|witness` | turn | [c(.055)·1.2A, 0, s(.055)·1.2A] |
| 37 | `amṛta|deathless|immortal|upastha` | persist | [0, s(.033)·.5A, 0] |
| 38 | `[śs]ar[īi]ra|\bmanas\b|\bbody\b` | land | [0, −(.5+.5c(.06))·1.2A, 0] |
| 39 | `dhairya|courage|steadi|fortitude` | stand | [0, s(.03)·.18A, 0] |
| 40 | `citta|mind-sub` | rest | [s(.04)·.3A, s(.035)·.2A, 0] |
| 41 | `\bkula\b|lineage` | thread | [s(.1)·.6A, c(.05)·.4A, s(.2)·.8A] |
| 42 | `[īi][śs]vara|ai[śs]varya|sovereign|lordship` | rise | [0, (.5+.5s(.05))·1.5A, 0] |
| 43 | `saṃyama|integrat|va[śs]ya|yield` | align | [s(.12)·A·(.5+.5c(.03)), 0, 0] |
| 44 | `maṅgala|auspicious` | brighten | [0, s(.11)·.6A, 0] |
| 45 | `duḥkha|p[āa]pa|sorrow|error|obstacle|vighna` | unbind | [s(.17)·1.2A, pulse(.085)·.7A, 0] |
| 46 | `[āa]rogya|healing|whole` | mend | [s(.14)·.5A, s(.07)·.5A, s(.21)·.5A] |
| 47 | `rañjana|colour|color|aesthetic` | tint | [s(.18)·.9A, c(.14)·.9A, 0] |
| 48 | `tri-eka|three-as-one|trinity` | converge | [c(.1)A(1−pulse(.05)), s(.1)A(1−pulse(.05)), 0] |
| 49 | `para-bindu|totality|source-beauty` | centre | [0,0,0] |
| 50 | `[śs]akti|s[āa]marthya|power|capacity` | surge | [0, pulse(.28)·1.3A, 0] |
| — | (no match) | breathe | [0, s(.14)·.7A, 0] |

[Note: the handoff says "50 regex patterns … 50 distinct motions"; the code has 50 patterns + a default (51 motions incl. breathe); `arrest` and `centre` are both stillness. The thread earlier also mentions "13 kinds" (an earlier version).]

**Altitude** = `bodyAltitude(card)` (homes-cards) → y = (0.5 − alt)×9 (rings 1, 2, 3) or ×8 (rings 4–7). **Phase** = (pos mod ringCount)/ringCount (R1 mod 10 or 8, R2 mod 16, R3 mod 8, R4 mod 14, R5/R6 mod 10).
Shared wall material: BackSide `MeshStandard(G.ink, rough .9, metal .05)` "dhatu".

**ARCH-R1-SIDDHI · siddhi (513–585)** — positions 1–10 (R1_FAMILY 'siddhi'). Box shell 13×11×30 + gem seams op .34. "The capacity, lent": Octahedron r1.5 detail 1, emissive gem ×2.4 + sprite 8 op .5, at (0, y, −9), moved by `displace(kind, t, ph, 2.2)`, rotating (t·.06, t·.09). Six square echo loops (r 2.4 + 1.5i, z −9 − 2.4i) repeat the same displacement delayed **0.6 + 0.5i s** ("the room's answer — it does the same thing, later"). Key 1600 dist 46; fill 320; ambient 1.4; 100 motes. Update: emissive 2.4 + 1.6k + 2.4b; echo op (.1 + .3k)(1 − i/8)(1 + 1.4b); second: seams fade (1 − .8b), shell op 1 − .7b, **lent object shrinks to 20%** (1 − .8b), key 1000 + 700k + 900b. Words: "**{quality} · lent, not shown**" → "**the capacity was never lent**" ("it was never lent. It is yours, and always was.").

**ARCH-R1-MATRKA · matrka (587–658)** — positions 11–18. Sphere shell r14; floor disc r13 (rough .6 metal .22) at y−5.4 ("a floor, so her light has somewhere to fall and the room has a bottom" — fix for defect 5). Letter count **n = 5 + ((pos − 11) mod 4)×3** → 5, 8, 11, 14 cycling. Letters: emissive slats Box .16×1.5×.16 on a ring r 6.4 facing centre; displaced with delay i·0.22; **one letter at a time comes to the point of being spoken**: turn = (t·0.22 + i/n) mod 1, emissive 1.4 + max(0, sin(π·turn))^8·5 + 1.8b; second: letters stretch y ×(1 + 3.4b). Column of voice: open Cylinder r .4/1.5 h9 additive op .06 + .12k + .22b, scale 1 + 1.1b, "rising from the chest". Key 1900; ambient .7. Words: "**{quality} · {syllable}**" (her row's syllable) or "**{quality} · the mouth before sound**" → "**the letters were never separate from the voice**".

**ARCH-R1-MUDRA · mudra (660–726)** — positions 19–28. "Not a room containing a seal: a seal large enough to stand inside." Five digit tubes (Tube r .34 on an 11-point arc, angle −0.9 … +0.9, rising y −4 → +5 − 3.4u², out to r 9) emissive gem ×0.9; sphere shell r16; held sprite 4.4 at (0, y, −7). Digits displaced with delay i·0.3, sway rot z sin(t·.12 + .7i)·.05(1 + 4b); emissive .7 + .8k + 2.2b; **second: digits open `rotation.x = b·.42·(1 + .1i)` — "the seal opens: what it held is released"**, held scale 1 + .14 sin(t·.2) + 3.6b. Key 1400; rim 400; ambient 1.5. Words: "**{quality} · a seal you stand inside**" → "**the seal has opened its hand**".

**ARCH-R2-CROSSED · crossed (728–816)** — positions 29–44. Petal sphere segment (r 11, θ 0.2→2.4). **Presenting half** — 7 thin tori (r .7 + .16i, tube .028) arced in front (x sin(a)·2.6, y+0.6, z −5) — "what she draws. Near, formed, addressed to you." **Answering half** — 7 sprites (1.4) offset lower and further (x sin(a)·3.4, y−0.8, z −6.4) — "the organ she was given. Offset, other, in counterpoint." Presenting uses `displace(kind, t, ph + i/14, 1.2)`; answering uses `displace(kind, t + 3.2, ph + 0.5 + i/14, 1.2)` — **same physics, opposite phase**; answers are pulled onto the presenting tori by `b` (converge at second). Key 1500 (+1400b if key pairing else +500b); counter light 500. **isKey = pos 44** (Śarīra/Manas). Words: with CROSSED pair `[near, far]` → "**{near}, answered in {far}**" → "**the {near} and the {far} were one sense**"; pos 44 → "**body and mind were one point**"; without a pair → "**{quality} · drawn toward the centre**" → "**the drawing and the drawn are one**".

**ARCH-R3 · bodiless (156–210)** — Sphere shell r15. 8 gem petal sprites (4.2, op .8) on r 5.4 orbiting an empty centre, each displaced (phase ph + i/8, amp 2.6). **Rim of light around nothing**: Torus r1.5 tube .02 op .5 at (0, y, −6.5), rotating t·.05. Key 2200 at that empty centre; wash 500; ambient **2.2**. Update: petal op (.42 + .5k)(1 − .4b), scale 1 + 1.6b; rim op (.3 + .3k)(1 − b); key 1400 + 1100k; second: shell op 1 − .8b ("the effect is the whole room; there was never a centre"). Words: "**{quality} · and nothing there to feel**" → "**the effect was the only body**".

**ARCH-R4 · cosmic (212–257)** — 14 nested triangle loops (r 3.4 + 2.1i, z −2 − 1.5i) + sphere shell r26 (fix for defect 4: "Ring 4's cosmic rooms had no wall at all"). Heart sprite 5; key 1200 dist 60; ambient .9; 150 motes. Update: each shell displaced by the SAME physics **delayed 0.42 s per shell** with amplitude 1 + .22i ("one movement becoming cosmic"); rot z sin(t·.05 + .3i)·.04(1 + 3b); op (.14 + .4k)(1 − i/20)(1 + .8b); scale 1 + b(.22 + .03i); heart scale 1 + .2 sin(t·.2) − .34b; key 700 + 700k + 600b. Words: "**{quality} · at the scale of worlds**" → "**the gesture had no centre to leave**".

**ARCH-R5 · giving (259–318)** — open cylinder r11 h22, floor disc r11 (rough .7 metal .2). 12 gift sprites fall inward from r16 to r1.4 along a spiral (+1.2 rad), from y+7 down 9, cycle **u = (t·0.055 + i/12) mod 1 (≈18 s)**, op sin(πu)(.4 + .4k), scale (.9 + .9u)(1 + b); "your hands": torus cup r1.9 at (0, y−1.4, −2.6), op (.2 + .35k)(1 − .8b), scale 1 + 4.2b. Key 800 above. Words: "**{quality} · arriving, unasked**" → "**the giving and the given are one**". "You never reach."

**ARCH-R6 · revealing (320–375)** — "what is already here, at full strength from the first instant": 10 icosahedra r1.4 emissive gem ×3.2 on r6; **the veil** — BackSide sphere r9.4 gem ink, opacity .72 (lit surface — fix for defect "Ring 6's veil was unlit, so it extinguished rather than obscured"). Inner light 1800; ambient 2.0. Update: veil op max(0, .72 − .46k − .26b); emissive 3.2 + 1.4k + 2.2b; truth scale 1 + .5b; inner 1200 + 900k + 900b. Words: "**{quality} · already here, behind the veil**" → "**it was never hidden · you were the veil**".

**ARCH-R7 · sounding (377–446)** — **mode number n = 2 + (pos mod 8)** ("her row's mode number"). Wall: open cylinder r9 h24 (128×64 segs) ShaderMaterial BackSide: ang = atan(z, x); **w = sin(ang·uMode + t·.5)·cos(y·.5 + t·.3)**; amp = .5 + 1.6·uDeep; p.xz *= 1 + w·.05·amp; vA = .35 + .65|w|; fragment band .5 + .5 sin(uv.y·90); colour mix(gem·.16, mix(gem, white, .5), vA)·(.8 + .2band), alpha .6 + .4vA. n node sprites (1.8) at r8.4 ("where the syllable is silent"), op (.24 + .4k)(1 − .4b), scale ×(1 + 1.2b). Key 400 + 400k. Words: "**{quality} · {bīja}**" (if BIJA[pos]) or "**{quality} · the room is her sound**" → "**you are inside the syllable**".

**ARCH-R8 · sourcing (448–510)** — corner = pos − 99 (**0 icchā · 1 kriyā · 2 jñāna**). Triangle R 4.6 at z −9.5 op .6; three lamps: hers white sprite 6.4 op .95 + white light 900; others gem sprite 2.4 op .2 + light 90. Bindu sprite 2.6 op .4 at centre ("the bindu they ring, not yet reached"); shell sphere r15 ("so her light has something to fall on" — fix for defect "Ring 8's triangle was larger than the room"). Update: others op .2 + .7b, light 90 + 700b ("past the second adaptation the other two answer"); tri op .3 + .4k + .3b, rot t·.006; bindu op .16 + .3k + .5b, scale 2.2(1 + 2.4b). Words by corner: **0 "will, before there is anything to will" → "will was already act and form"; 1 "the act, before there is a deed" → "the act was already will and form"; 2 "form, before there is a thing" → "form was already will and act"** (fallbacks "at the source" / "the three were never apart").

**Dispatch (818–831):** ring 1 → R1_FAMILY(pos): siddhi / matrka (with SYLLABLE[pos]) / mudra; ring 2 → crossed(SYLLABLE[pos], CROSSED[pos]); rings 3–8 → FAMILY; ring 9 → null (falls to seat unless authored by name).

---

### H-TABLE · All 102 — how each room resolves in the Axis (computed by running the shipped modules' own logic)

Computed from `homes-cards.js` (cards, SYLLABLE/BIJA, ATTRIBUTE/ATTR_TINT, R1_FAMILY/R2_CLUSTER, bodyAltitude), the 50 PHYSICS regexes extracted verbatim from `homes-grammar.js`, KIN/FORMS from `homes-attribute.js`, `carrierFor` from `homes-sound.js`, the Atmosphere jitter from `homes-chambers.js`, `neighbourOf` logic from the Axis, and app names index-aligned from `all-shaktis-data.js` (Ring 2 app list is empty). **Archetype column reflects the real resolution order** — exact-name BY_NAME first (only Laghimā, Garimā, Mahimā, Mahātripurasundarī match), then the grammar. `near`/`deep` are the room's words before/after the second adaptation. Carrier Hz = root × just ratio × 2 (ratio column shows carrier/root). Hue = her jittered Atmosphere hue (ring 2 seeded from cluster). Doors = left / right neighbour positions as `neighbourOf` resolves them (Ring 1 within family, Ring 2 within cluster, else ±1 around the ring).

| pos | ring | card name | app name (if differs) | family/cluster | archetype | physics | alt | attribute → form | tint | syllable | carrier Hz (carrier ÷ root, incl. the ×2 octave) | hue° | near words | deep words | doors L/R |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | Aṇimā | Animā | siddhi | siddhi · lent | shrink | 0.1 | noose → noose | 0xf2ecd8 |  | 55.00 (1.0000) | 38.65 | smallness · lent, not shown | the capacity was never lent | 10/2 |
| 2 | 1 | Mahimā | Laghimā | siddhi | ENDLESS (authored) | widen | 0.5 | goad → goad |  |  | 55.00 (1.0000) | 35.31 | no far wall · it never arrives | you were never inside anything | 1/3 |
| 3 | 1 | Laghimā | Mahimā | siddhi | RELEASE (authored) | lift | 0.6 | veil → palm |  |  | 55.00 (1.0000) | 31.96 | the floor has let go | the room has let go of itself | 2/4 |
| 4 | 1 | Garimā | Īśitā | siddhi | PRESS (authored) | settle | 0.94 | palm → palm | 0xb8263c |  | 55.00 (1.0000) | 28.62 | the ceiling is coming down | the weight was holding you all along | 3/5 |
| 5 | 1 | Īśitva | Vaśitā | siddhi | siddhi · lent | rise | 0.1 | sceptre → sceptre |  |  | 55.00 (1.0000) | 39.27 | sovereignty · lent, not shown | the capacity was never lent | 4/6 |
| 6 | 1 | Vaśitva | Prākāmyā | siddhi | siddhi · lent | align | 0.34 | noose → noose |  |  | 55.00 (1.0000) | 35.92 | mastery · lent, not shown | the capacity was never lent | 5/7 |
| 7 | 1 | Prākāmya | Bhuktī | siddhi | siddhi · lent | incline | 0.6 | bow → bow | 0xff7a3c |  | 55.00 (1.0000) | 32.58 | irresistible will · lent, not shown | the capacity was never lent | 6/8 |
| 8 | 1 | Bhukti | Icchā | siddhi | siddhi · lent | lean | 0.66 | cup → cup |  |  | 55.00 (1.0000) | 29.23 | enjoyment · lent, not shown | the capacity was never lent | 7/9 |
| 9 | 1 | Icchā | Prāptiḥ | siddhi | siddhi · lent | incline | 0.46 | lotus → lotus |  |  | 55.00 (1.0000) | 39.89 | willingness · lent, not shown | the capacity was never lent | 8/10 |
| 10 | 1 | Prāpti | Sarvakāmāvalī | siddhi | siddhi · lent | fill | 0.5 | hook → goad |  |  | 55.00 (1.0000) | 36.54 | reach · lent, not shown | the capacity was never lent | 9/1 |
| 11 | 1 | Brāhmī |  | matrka | mātṛkā · letters (n=5) | sound | 0.34 | rosary → rosary |  | Aṃ | 110.00 (2.0000) | 33.19 | creation · Aṃ | the letters were never separate from the voice | 18/12 |
| 12 | 1 | Māheśvarī |  | matrka | mātṛkā · letters (n=8) | open | 0.34 | trident → trident |  | Kaṃ | 137.50 (2.5000) | 29.85 | witness · Kaṃ | the letters were never separate from the voice | 11/13 |
| 13 | 1 | Kaumārī |  | matrka | mātṛkā · letters (n=11) | flare | 0.34 | spear → trident | 0xffb45c | Caṃ | 183.33 (3.3333) | 40.50 | fierce youth · Caṃ | the letters were never separate from the voice | 12/14 |
| 14 | 1 | Vaiṣṇavī |  | matrka | mātṛkā · letters (n=14) | sustain | 0.46 | discus → trident |  | Ṭaṃ | 123.75 (2.2500) | 37.16 | preservation · Ṭaṃ | the letters were never separate from the voice | 13/15 |
| 15 | 1 | Vārāhī |  | matrka | mātṛkā · letters (n=5) | settle | 0.66 | plough → plough | 0x6a5f78 | Taṃ | 165.00 (3.0000) | 33.81 | dissolution · Taṃ | the letters were never separate from the voice | 14/16 |
| 16 | 1 | Indrāṇī | Māhendrī | matrka | mātṛkā · letters (n=8) | lean | 0.46 | vajra → vajra |  | Paṃ | 110.00 (2.0000) | 30.46 | heart-sovereignty · Paṃ | the letters were never separate from the voice | 15/17 |
| 17 | 1 | Cāmuṇḍā |  | matrka | mātṛkā · letters (n=11) | dissolve | 0.5 | skullcup → skullcup | 0xd8d2c4 | Yaṃ | 146.67 (2.6667) | 41.12 | liberation · Yaṃ | the letters were never separate from the voice | 16/18 |
| 18 | 1 | Mahālakṣmī |  | matrka | mātṛkā · letters (n=14) | fill | 0.5 | lotus → lotus | 0xffd76a | Aim | 110.00 (2.0000) | 37.77 | wholeness · Aim | the letters were never separate from the voice | 17/11 |
| 19 | 1 | Sarva-Saṅkṣobhiṇī | Sarvasaṅkṣobhiṇī | mudra | mudrā · seal you stand inside | stir | 0.5 | seal → seal |  |  | 55.00 (1.0000) | 34.43 | stirring · a seal you stand inside | the seal has opened its hand | 28/20 |
| 20 | 1 | Sarva-Vidrāviṇī | Sarvavidrāviṇī | mudra | mudrā · seal you stand inside | flow | 0.5 | seal → seal |  |  | 55.00 (1.0000) | 31.08 | melting · a seal you stand inside | the seal has opened its hand | 19/21 |
| 21 | 1 | Sarva-Ākarṣiṇī | Sarvākarṣiṇī | mudra | mudrā · seal you stand inside | draw | 0.46 | hand → palm |  |  | 55.00 (1.0000) | 41.73 | magnetism · a seal you stand inside | the seal has opened its hand | 20/22 |
| 22 | 1 | Sarva-Vaśaṅkarī | Sarvāhladinī | mudra | mudrā · seal you stand inside | align | 0.46 | palm → palm |  |  | 55.00 (1.0000) | 38.39 | yielding · a seal you stand inside | the seal has opened its hand | 21/23 |
| 23 | 1 | Sarva-Onmādinī | Sarvasammohini | mudra | mudrā · seal you stand inside | waver | 0.26 | seal → seal |  |  | 55.00 (1.0000) | 35.04 | intoxication · a seal you stand inside | the seal has opened its hand | 22/24 |
| 24 | 1 | Sarva-Mahāṅkuśā | Sarvastambhinī | mudra | mudrā · seal you stand inside | point | 0.66 | goad → goad |  |  | 55.00 (1.0000) | 31.70 | direction · a seal you stand inside | the seal has opened its hand | 23/25 |
| 25 | 1 | Sarva-Khecarī | Sarvajṛmbhiṇī | mudra | mudrā · seal you stand inside | open | 0.34 | seal → seal |  |  | 55.00 (1.0000) | 28.35 | freedom · a seal you stand inside | the seal has opened its hand | 24/26 |
| 26 | 1 | Sarva-Bīja | Sarvavaśaṅkarī | mudra | mudrā · seal you stand inside | compress | 0.46 | seed → seed |  |  | 55.00 (1.0000) | 39.00 | potential · a seal you stand inside | the seal has opened its hand | 25/27 |
| 27 | 1 | Sarva-Yoni | Sarvarañjanī | mudra | mudrā · seal you stand inside | spring | 0.66 | triangle → seal |  |  | 55.00 (1.0000) | 35.66 | source · a seal you stand inside | the seal has opened its hand | 26/28 |
| 28 | 1 | Sarva-Trikhaṇḍā | Sarvonmādinī | mudra | mudrā · seal you stand inside | converge | 0.1 | triad → seal |  |  | 55.00 (1.0000) | 32.31 | trinity-as-unity · a seal you stand inside | the seal has opened its hand | 27/19 |
| 29 | 2 | Kāmākarṣiṇī |  | instrument | crossed | settle | 0.46 | noose → noose | 0xff6a7c | aṃ | 123.48 (2.0000) | 36.97 | kāma · drawn toward the centre | the drawing and the drawn are one | 31/30 |
| 30 | 2 | Buddhyākarṣiṇī |  | instrument | crossed | well | 0.26 | flame → flame |  | āṃ | 131.71 (2.1333) | 47.62 | buddhi · drawn toward the centre | the drawing and the drawn are one | 29/31 |
| 31 | 2 | Ahaṅkārākarṣiṇī |  | instrument | crossed | flare | 0.6 | hand → palm |  | iṃ | 138.91 (2.2500) | 44.27 | ahaṅkāra · drawn toward the centre | the drawing and the drawn are one | 30/29 |
| 32 | 2 | Śabdākarṣiṇī |  | tanmatra | crossed | lift | 0.5 | ear → palm |  | īṃ | 148.18 (2.4000) | 10.93 | śabda · drawn toward the centre | the drawing and the drawn are one | 36/33 |
| 33 | 2 | Sparśākarṣiṇī |  | tanmatra | crossed | open | 0.94 | palm → palm |  | uṃ | 154.35 (2.5000) | 7.58 | sparśa · drawn toward the centre | the drawing and the drawn are one | 32/34 |
| 34 | 2 | Rūpākarṣiṇī |  | tanmatra | crossed | lean | 0.26 | mirror → mirror |  | ūṃ | 164.64 (2.6667) | 18.24 | form, answered in ear | the form and the ear were one sense | 33/35 |
| 35 | 2 | Rasākarṣiṇī |  | tanmatra | crossed | lean | 0.34 | cup → cup |  | ṛṃ | 173.64 (2.8125) | 14.89 | taste, answered in skin | the taste and the skin were one sense | 34/36 |
| 36 | 2 | Gandhākarṣiṇī |  | tanmatra | crossed | lean | 0.5 | lotus → lotus |  | ṝṃ | 185.22 (3.0000) | 11.54 | scent, answered in eye | the scent and the eye were one sense | 35/32 |
| 37 | 2 | Cittākarṣiṇī |  | citta | crossed | lean | 0.46 | gaze → radiance |  | ḷṃ | 197.57 (3.2000) | 175.20 | mind, answered in tongue | the mind and the tongue were one sense | 37/37 |
| 38 | 2 | Dhairyākarṣiṇī |  | stability | crossed | lean | 0.5 | spine → sceptre |  | ḹṃ | 205.80 (3.3333) | 145.85 | courage, answered in nose | the courage and the nose were one sense | 41/39 |
| 39 | 2 | Smṛtyākarṣiṇī |  | stability | crossed | sound | 0.26 | gaze → radiance |  | eṃ | 219.52 (3.5556) | 142.51 | memory, answered in speech | the memory and the speech were one sense | 38/40 |
| 40 | 2 | Nāmākarṣiṇī |  | stability | crossed | call | 0.34 | syllable → radiance |  | aiṃ | 231.53 (3.7500) | 139.16 | name, answered in hand | the name and the hand were one sense | 39/41 |
| 41 | 2 | Bījākarṣiṇī |  | stability | crossed | compress | 0.66 | seed → seed |  | oṃ | 123.48 (2.0000) | 135.81 | seed, answered in foot | the seed and the foot were one sense | 40/38 |
| 42 | 2 | Ātmākarṣiṇī |  | self | crossed | turn | 0.5 | gaze → radiance |  | auṃ | 131.71 (2.1333) | 276.47 | self, answered in release | the self and the release were one sense | 44/43 |
| 43 | 2 | Amṛtākarṣiṇī |  | self | crossed | flow | 0.34 | drop → cup |  | aṃ | 123.48 (2.0000) | 273.12 | deathless, answered in generation | the deathless and the generation were one sense | 42/44 |
| 44 | 2 | Śarīrākarṣiṇī |  | self | crossed (KEY PAIRING) | land | 0.5 | palm → palm |  | aḥ | 123.48 (2.0000) | 269.78 | body, answered in mind | body and mind were one point | 43/42 |
| 45 | 3 | Anaṅga-Kusumā | Anaṅgakusumā |  | bodiless | bloom | 0.46 | flower → lotus | 0xffb0c4 |  | 69.30 (1.0000) | 337.43 | subtle beauty · and nothing there to feel | the effect was the only body | 52/46 |
| 46 | 3 | Anaṅga-Mekhalā | Anaṅgamekhalā |  | bodiless | encircle | 0.68 | belt → garland |  |  | 69.30 (1.0000) | 334.08 | encircling intimacy · and nothing there to feel | the effect was the only body | 45/47 |
| 47 | 3 | Anaṅga-Madanā | Anaṅgamadanā |  | bodiless | waver | 0.34 | gaze → radiance |  |  | 69.30 (1.0000) | 344.74 | subtle intoxication · and nothing there to feel | the effect was the only body | 46/48 |
| 48 | 3 | Anaṅga-Madanāturā | Anaṅgamadanāturā |  | bodiless | flare | 0.46 | hand → palm |  |  | 69.30 (1.0000) | 341.39 | pure longing · and nothing there to feel | the effect was the only body | 47/49 |
| 49 | 3 | Anaṅga-Rekhā | Anaṅgarekhā |  | bodiless | trace | 0.26 | line → line |  |  | 69.30 (1.0000) | 338.05 | suggested form · and nothing there to feel | the effect was the only body | 48/50 |
| 50 | 3 | Anaṅga-Veginī | Anaṅgaveginī |  | bodiless | dart | 0.46 | streamer → garland |  |  | 69.30 (1.0000) | 334.70 | subtle velocity · and nothing there to feel | the effect was the only body | 49/51 |
| 51 | 3 | Anaṅga-Aṅkuśā | Anaṅgāṅkuśā |  | bodiless | point | 0.46 | hook → goad |  |  | 69.30 (1.0000) | 345.35 | subtle hook · and nothing there to feel | the effect was the only body | 50/52 |
| 52 | 3 | Anaṅga-Mālinī | Anaṅgamālinī |  | bodiless | bloom | 0.5 | garland → garland |  |  | 69.30 (1.0000) | 342.01 | subtle adornment · and nothing there to feel | the effect was the only body | 51/45 |
| 53 | 4 | Sarva-Saṅkṣobhiṇī | Sarvasaṅkṣobhiṇī |  | cosmic | stir | 0.5 | churn → seal |  |  | 73.42 (1.0000) | 350.66 | cosmic stirring · at the scale of worlds | the gesture had no centre to leave | 66/54 |
| 54 | 4 | Sarva-Vidrāviṇī | Sarvavidrāviṇī |  | cosmic | flow | 0.5 | molten → cup |  |  | 73.42 (1.0000) | 347.32 | cosmic flow · at the scale of worlds | the gesture had no centre to leave | 53/55 |
| 55 | 4 | Sarva-Ākarṣiṇī | Sarvākarṣiṇī |  | cosmic | draw | 0.46 | hand → palm |  |  | 73.42 (1.0000) | 357.97 | universal magnetism · at the scale of worlds | the gesture had no centre to leave | 54/56 |
| 56 | 4 | Sarva-Āhlādinī | Sarvāhladinī |  | cosmic | swell | 0.46 | pour → grain |  |  | 73.42 (1.0000) | 354.62 | cosmic joy · at the scale of worlds | the gesture had no centre to leave | 55/57 |
| 57 | 4 | Sarva-Sammohinī | Sarvasammohini |  | cosmic | waver | 0.26 | veil → palm |  |  | 73.42 (1.0000) | 351.28 | divine bewilderment · at the scale of worlds | the gesture had no centre to leave | 56/58 |
| 58 | 4 | Sarva-Sthambhinī | Sarvastambhinī |  | cosmic | arrest | 0.56 | palm → palm |  |  | 73.42 (1.0000) | 347.93 | cosmic stillness · at the scale of worlds | the gesture had no centre to leave | 57/59 |
| 59 | 4 | Sarva-Jṛmbhinī | Sarvajṛmbhiṇī |  | cosmic | expand | 0.5 | stretch → sceptre |  |  | 73.42 (1.0000) | 358.59 | cosmic expansion · at the scale of worlds | the gesture had no centre to leave | 58/60 |
| 60 | 4 | Sarva-Vaśaṅkarī | Sarvavaśaṅkarī |  | cosmic | align | 0.46 | palm → palm |  |  | 73.42 (1.0000) | 355.24 | cosmic yielding · at the scale of worlds | the gesture had no centre to leave | 59/61 |
| 61 | 4 | Sarva-Rañjinī | Sarvarañjanī |  | cosmic | tint | 0.26 | brush → line |  |  | 73.42 (1.0000) | 351.89 | cosmic colouring · at the scale of worlds | the gesture had no centre to leave | 60/62 |
| 62 | 4 | Sarva-Onmādinī | Sarvonmādinī |  | cosmic | waver | 0.2 | cup → cup | 0xff8ab0 |  | 73.42 (1.0000) | 348.55 | cosmic intoxication · at the scale of worlds | the gesture had no centre to leave | 61/63 |
| 63 | 4 | Sarvārthasādhikā |  |  | cosmic | arrive | 0.6 | gem → gem |  |  | 73.42 (1.0000) | 359.20 | cosmic fulfilment · at the scale of worlds | the gesture had no centre to leave | 62/64 |
| 64 | 4 | Sarva-Sampatpūraṇī | Sarvasampatpūraṇī |  | cosmic | fill | 0.66 | grain → grain |  |  | 73.42 (1.0000) | 355.86 | cosmic abundance · at the scale of worlds | the gesture had no centre to leave | 63/65 |
| 65 | 4 | Sarva-Mantramayī | Sarvamantramayi |  | cosmic | sound | 0.34 | syllable → radiance |  |  | 73.42 (1.0000) | 352.51 | cosmic mantra · at the scale of worlds | the gesture had no centre to leave | 64/66 |
| 66 | 4 | Sarva-Dvandvakṣayaṅkarī | Sarvasiddhipradā |  | cosmic | merge | 0.46 | triangle → seal |  |  | 73.42 (1.0000) | 349.16 | cosmic non-duality · at the scale of worlds | the gesture had no centre to leave | 65/53 |
| 67 | 5 | Sarva-Siddhipradā | Sarvasiddhipradā |  | giving | arrive | 0.5 | boon → palm |  |  | 82.41 (1.0000) | 24.82 | all-attainment · arriving, unasked | the giving and the given are one | 76/68 |
| 68 | 5 | Sarva-Sampatpradā | Sarvasampadpradā |  | giving | fill | 0.66 | grain → grain |  |  | 82.41 (1.0000) | 21.47 | all-abundance · arriving, unasked | the giving and the given are one | 67/69 |
| 69 | 5 | Sarva-Priyaṅkarī | Sarvapriyakarī |  | giving | breathe | 0.46 | flower → lotus |  |  | 82.41 (1.0000) | 18.13 | all-love · arriving, unasked | the giving and the given are one | 68/70 |
| 70 | 5 | Sarva-Maṅgalakāriṇī | Sarvamangalakāriṇī |  | giving | brighten | 0.1 | lamp → lamp |  |  | 82.41 (1.0000) | 14.78 | all-auspiciousness · arriving, unasked | the giving and the given are one | 69/71 |
| 71 | 5 | Sarva-Kāmapradā | Sarvakāmapradā |  | giving | arrive | 0.46 | fruit → gem |  |  | 82.41 (1.0000) | 11.43 | desire-fulfilling · arriving, unasked | the giving and the given are one | 70/72 |
| 72 | 5 | Sarva-Duḥkhavimocanī | Sarvaduhkhavimochanī |  | giving | dissolve | 0.46 | chain → chain |  |  | 82.41 (1.0000) | 22.09 | sorrow-liberation · arriving, unasked | the giving and the given are one | 71/73 |
| 73 | 5 | Sarva-Mṛtyupraśamani | Sarvamṛtyupraśamanī |  | giving | persist | 0.5 | drop → cup |  |  | 82.41 (1.0000) | 18.74 | death-pacification · arriving, unasked | the giving and the given are one | 72/74 |
| 74 | 5 | Sarva-Vighnanivāriṇī | Sarvavighnanivāriṇī |  | giving | dissolve | 0.5 | goad → goad |  |  | 82.41 (1.0000) | 15.40 | obstacle-removal · arriving, unasked | the giving and the given are one | 73/75 |
| 75 | 5 | Sarvāṅgasundarī |  |  | giving | bloom | 0.5 | radiance → radiance |  |  | 82.41 (1.0000) | 12.05 | complete beauty · arriving, unasked | the giving and the given are one | 74/76 |
| 76 | 5 | Sarva-Saubhāgyadāyinī | Sarvasaubhāgyadāyinī |  | giving | breathe | 0.46 | boon → palm |  |  | 82.41 (1.0000) | 22.70 | all-good-fortune · arriving, unasked | the giving and the given are one | 75/67 |
| 77 | 6 | Sarvajñā | Sarvajñānamayī |  | revealing | clarify | 0.2 | flame → flame |  |  | 92.50 (1.0000) | 195.36 | all-knowing · already here, behind the veil | it was never hidden · you were the veil | 86/78 |
| 78 | 6 | Sarvaśakti | Sarvaśaktimayī |  | revealing | surge | 0.5 | radiance → radiance |  |  | 92.50 (1.0000) | 192.01 | all-power · already here, behind the veil | it was never hidden · you were the veil | 77/79 |
| 79 | 6 | Sarvaiśvaryapradāyinī | Sarvaaiśvaryapradā |  | revealing | rise | 0.1 | sceptre → sceptre |  |  | 92.50 (1.0000) | 188.67 | all-sovereignty · already here, behind the veil | it was never hidden · you were the veil | 78/80 |
| 80 | 6 | Sarvajñānamayī | Sarvajñānapradā |  | revealing | clarify | 0.5 | radiance → radiance |  |  | 92.50 (1.0000) | 199.32 | all-knowledge · already here, behind the veil | it was never hidden · you were the veil | 79/81 |
| 81 | 6 | Sarvavyādhivināśinī | Sarvavyādhivinashinī |  | revealing | fill | 0.5 | herb → herb |  |  | 92.50 (1.0000) | 195.97 | all-healing · already here, behind the veil | it was never hidden · you were the veil | 80/82 |
| 82 | 6 | Sarvādhārasvarūpā | Sarvādhārasvarūpinī |  | revealing | lean | 0.94 | ground → ground |  |  | 92.50 (1.0000) | 192.63 | universal support · already here, behind the veil | it was never hidden · you were the veil | 81/83 |
| 83 | 6 | Sarvapāpaharā | Sarvapāpahara |  | revealing | dissolve | 0.46 | cleanse → palm |  |  | 92.50 (1.0000) | 189.28 | error-dissolution · already here, behind the veil | it was never hidden · you were the veil | 82/84 |
| 84 | 6 | Sarvānandamayī |  |  | revealing | swell | 0.5 | radiance → radiance |  |  | 92.50 (1.0000) | 199.94 | all-bliss · already here, behind the veil | it was never hidden · you were the veil | 83/85 |
| 85 | 6 | Sarvarakṣāsvarūpiṇī | Sarvarakṣakāriṇī |  | revealing | encircle | 0.5 | shield → ground |  |  | 92.50 (1.0000) | 196.59 | universal protection · already here, behind the veil | it was never hidden · you were the veil | 84/86 |
| 86 | 6 | Sarvepsitaphalapradā |  |  | revealing | arrive | 0.46 | fruit → gem |  |  | 92.50 (1.0000) | 193.24 | fruit-of-desire · already here, behind the veil | it was never hidden · you were the veil | 85/77 |
| 87 | 7 | Vasinī | Vāśinī |  | sounding (mode 9) | sound | 0.46 | rosary → rosary |  | Aṃ | 196.00 (2.0000) | 317.90 | inner-speech-origin · Aṃ | you are inside the syllable | 98/88 |
| 88 | 7 | Kāmeśī | Kāmeśvarī |  | sounding (mode 2) | sound | 0.34 | bow → bow |  | Kaṃ | 245.00 (2.5000) | 328.55 | desire-speech · Kaṃ | you are inside the syllable | 87/89 |
| 89 | 7 | Modinī |  |  | sounding (mode 3) | sound | 0.34 | cup → cup |  | Caṃ | 326.67 (3.3333) | 325.21 | joyful-speech · Caṃ | you are inside the syllable | 88/90 |
| 90 | 7 | Vimalā |  |  | sounding (mode 4) | sound | 0.34 | water → cup |  | Ṭaṃ | 220.50 (2.2500) | 321.86 | pure-speech · Ṭaṃ | you are inside the syllable | 89/91 |
| 91 | 7 | Aruṇā |  |  | sounding (mode 5) | sound | 0.34 | noose → noose | 0xff7a5c | Taṃ | 294.00 (3.0000) | 318.51 | dawn-speech · Taṃ | you are inside the syllable | 90/92 |
| 92 | 7 | Jayinī |  |  | sounding (mode 6) | sound | 0.46 | banner → garland | 0xffd76a | Paṃ | 196.00 (2.0000) | 315.17 | triumphant-speech · Paṃ | you are inside the syllable | 91/93 |
| 93 | 7 | Sarveśī | Sarveśvarī |  | sounding (mode 7) | sound | 0.34 | sceptre → sceptre |  | Yaṃ | 261.33 (2.6667) | 325.82 | all-governing-speech · Yaṃ | you are inside the syllable | 92/94 |
| 94 | 7 | Kaulinī |  |  | sounding (mode 8) | sound | 0.34 | skullcup → skullcup |  | Śaṃ | 326.67 (3.3333) | 322.48 | lineage-speech · Śaṃ | you are inside the syllable | 93/95 |
| 95 | 7 | Bāṇinī | Sarvavāṅmayī |  | sounding (mode 9) | surge | 0.5 | arrows → arrows |  |  | 98.00 (1.0000) | 319.13 | five-arrow-śakti · the room is her sound | you are inside the syllable | 94/96 |
| 96 | 7 | Cāpinī | Sarvonmādinī |  | sounding (mode 2) | breathe | 0.5 | bow → bow |  |  | 98.00 (1.0000) | 315.78 | sugarcane-bow · the room is her sound | you are inside the syllable | 95/97 |
| 97 | 7 | Pāśinī | Sarvamantreśvarī |  | sounding (mode 3) | encircle | 0.46 | noose → noose |  |  | 98.00 (1.0000) | 326.44 | binding-love · the room is her sound | you are inside the syllable | 96/98 |
| 98 | 7 | Aṅkuśinī | Sarvaśaktimayi |  | sounding (mode 4) | point | 0.2 | goad → goad |  |  | 98.00 (1.0000) | 323.09 | directing-goad · the room is her sound | you are inside the syllable | 97/87 |
| 99 | 8 | Kāmeśvarī |  |  | sourcing corner 0 | spring | 0.2 | radiance → radiance | 0xfff6e2 | Aim | 220.00 (2.0000) | 359.75 | will, before there is anything to will | will was already act and form | 101/100 |
| 100 | 8 | Vajreśī | Vajreśvarī |  | sourcing corner 1 | dart | 0.46 | vajra → vajra | 0xff4a5c | Klīm | 275.00 (2.5000) | 356.40 | the act, before there is a deed | the act was already will and form | 99/101 |
| 101 | 8 | Bhagamālinī |  |  | sourcing corner 2 | spring | 0.66 | garland → garland | 0xffd76a | Sauḥ | 412.50 (3.7500) | 7.05 | form, before there is a thing | form was already will and act | 100/99 |
| 102 | 9 | Mahātripurasundarī |  |  | DISSOLVE (authored) | spring | 0.5 | arrows → arrows |  | Hrīm | 246.94 (2.0000) | 47.71 | there was never anyone here but Her | the bindu is where you are standing | —/— |

Physics distribution across the 102 (computed; 41 of the 51 motions are used, 3 Śaktis still fall to the default `breathe` — 69 Sarva-Priyaṅkarī, 76 Sarva-Saubhāgyadāyinī, 96 Cāpinī): sound 11, lean 8, fill 5, dissolve 4, waver 4, spring 4, arrive 4, settle 3, align 3, open 3, flare 3, flow 3, point 3, bloom 3, encircle 3, breathe 3, lift 2, rise 2, incline 2, stir 2, draw 2, compress 2, dart 2, swell 2, clarify 2, surge 2, shrink 1, widen 1, sustain 1, converge 1, well 1, call 1, turn 1, land 1, trace 1, arrest 1, expand 1, tint 1, merge 1, brighten 1, persist 1.

Built attribute forms across the 102 (computed): palm 16, radiance 11, cup 8, seal 8, goad 6, noose 5, sceptre 5, lotus 5, garland 5, bow 3, trident 3, grain 3, gem 3, rosary 2, vajra 2, skullcup 2, seed 2, flame 2, line 2, ground 2, arrows 2, plough 1, mirror 1, lamp 1, chain 1, herb 1 — 26 distinct forms of 26.

---

### H-ATTR · Her attribute — the room's one actor (`homes-attribute.js` 1–587; handoff copy identical)
"her held object is not shown to you — it PERFORMS. A noose draws the vast into the tiny. A cup fills and is drunk. Five arrows strike the five gates in turn. A skull-cup receives what has ended. A sceptre barely moves. Aniconic throughout: these are shapes doing one thing, never figures."
Materials: `solidMat(col, e=1.6)` = MeshStandard rough .38 metal .12 emissive col×e ("attribute"); `addMat(col, o=.6)` additive basic; `lineMat(col, o=.7)`.

**Placement (558–586):** key = ATTRIBUTE[pos]; form = FORMS[key] ‖ FORMS[KIN[key]] ‖ 'seal'; colour = **ATTR_TINT[pos] ‖ her jittered gem colour**. Holder at `(0, (0.5 − alt)×6.4 − 0.4, −4.6)`, scale **0.9** ("she holds it at her own altitude, a little in front of her seat"). **Second adaptation:** scale `0.9 + 2.6b` (→ 3.5; handoff says 0.9 → 3.16 — code reaches 3.5 at b=1; 3.16 ≈ b=0.87), z `−4.6 + 3.4b` (toward you), every transparent material's opacity ×(1 − .55b) **each frame** ("it grows into it, and stops being an object"). [Builder caution: that multiply is applied every frame to whatever opacity the form left, so forms that don't reset opacity in `act` (lotus petals, palm lines, herb… those that do reset are fine) decay toward zero rather than to 45% — port as a single factor on the base opacity.]

**The 26 forms and their one action (34–546)** — cycle periods are 1/rate:
| form | geometry | action (exact) |
|---|---|---|
| noose | Torus r1 tube .045 + caught sprite 1.6 | u=(t·.09) mod 1 (**11.1 s**): cast = smooth(u/.34), close = smooth((u−.34)/.3), draw = smooth((u−.62)/.38); r = .6 + 3.2cast − 2.2close; ring scale r(1 − .82draw); z = −3.4cast + 3.2draw; caught scale (.4 + 1.4cast)(1 − .7draw), op .2 + .6close — "cast, close, draw home" |
| goad | shaft Cyl .035/.045 h2.6 tilted .3 + hook tube + pulled sprite | u=(t·.13) mod 1 (7.7 s): reach = smooth(u/.4), pull = smooth((u−.45)/.55); rot z −.2 + .34reach − .2pull; pulled z −2.8reach + 2.6pull — "hooks what wanders and steers it back" |
| cup | Lathe bowl (emissive .7) + nectar disc | u=(t·.055) mod 1 (18.2 s): fill = smooth(u/.55), drunk = smooth((u−.62)/.38); level .1 + .44fill − .44drunk; tilt z .34drunk — "fills, and is drunk" |
| arrows | 5 rods (Cyl .02 h1.8) + tip sprites fanned −.9….9 | per arrow u=(t·.16 + i/5) mod 1 (6.25 s, staggered 1.25 s): fly = (u/.3)^.6, back = smooth((u−.42)/.58); z −4.2·fly(1−back) — "strikes the five gates in turn" |
| bow | 21-pt stave tube + 3-pt string | u=(t·.075) mod 1 (13.3 s): draw = smooth(u/.62), loose = clamp((u−.7)/.08); string pulled z 1.5draw(1−loose); stave x-scale 1 − .06draw — "draws, holds the tension, releases" |
| mirror | Circle r.78 MeshStandard white rough .06 **metal 1** + rim torus + back glow | rot y sin(t·.06)·.7; face = max(0, cos rot)^6; glow op .65face, scale 2 + 2.4face — "returns your own light to you" |
| lotus | 8 quadratic petals additive op .4 + heart | open = .5 + .5 sin(t·.07); petal rot x −.15 − 1.05open — "opens" |
| flame | open Cone r.3 h1.1 additive + halo | f = .5 sin(3.1t) + .3 sin(5.3t) + .2 sin(1.7t); flicker scale ±.08/.16 — "burns at the brow" |
| rosary | **27 beads** r .055 on r1.05 | at = (t·.6) mod 27 (one bead per 1.67 s, full round 45 s); near = max(0, 1 − d/2); emissive .5 + 4near; scale 1 + .5near; rot z −t·.012 — "tells its own beads, one at a time" |
| trident | shaft + 3 cone prongs | prong u=(t·.14 + i/3) mod 1; lift = sin(πu)³; y +.24lift; emissive 1.2 + 2.6lift — "holds three as one" |
| vajra | core Cyl + 2×4 cone prongs + white strike sprite | u=(t·.11) mod 1 → **one strike every 9.09 s**; flash = (1 − u/.06)² (first 0.55 s); strike op .9flash, scale 2 + 5flash; core emissive 1.4 + 6flash; ends counter-rotate ±t·.2 — "strikes, and is irreversible" |
| skullcup | half-sphere bowl (emissive .4) + black disc + rim | u=(t·.048) mod 1 (20.8 s): black held disc scale .6 + .5u, op .2 + .5u (darkens as it fills); rim op .24 + .4(1−u) — "receives what has ended" |
| plough | beam Box 1.9 + 4-sided cone share + 9 furrow sprites | u=(t·.07) mod 1 (14.3 s): travels x −1.4 → 1.4; furrow sprites rise behind (age), op .5 − .5age — "turns what is buried up into the light" |
| sceptre | rod Cyl h2.2 + octahedron head | rot z sin(t·.022)·**.012** (barely moves); head rot y t·.05; emissive 1.4 + .25 sin(t·.09) — "the quiet authority of the one who need not raise her voice" |
| garland | 20 flower sprites on a 1.4-turn spiral | grown = 6 + (t·.5 mod 15) flowers visible (lengthens over 30 s, restarts) — "weaves, and lengthens" |
| seed | husk sphere r .42 (emissive .5) + inner white glow | b = .5 + .5 sin(t·.05); husk 1 − .06b; inner op .2 + .34b — "it never opens; it only becomes denser" |
| gem | Octahedron .44 MeshPhysical **transmission .95, thickness 1.1, ior 2.2, dispersion 6** + grant glow | give = (.5 + .5 sin(t·.09))³; grant scale 1.2 + 4give, op .16 + .42give — "grants, exactly what was asked" |
| grain | Cone heap + 26 falling sprites | u=(t·.28 + seed) mod 1; spill outward r .14 + .7u, fall 1.2 — "overflows, and cannot be contained" |
| lamp | Lathe dish + wick sprite `0xffe2a8` | flicker 1 + .05 sin(2.6t) + .03 sin(4.1t); sway — "blesses whatever it touches" |
| chain | 7 torus links alternating | u=(t·.06) mod 1 (16.7 s): gone_i = clamp((u − i/9)·6); link falls −3.4gone², spins 2.2gone, fades — "unbinds, and the links fall open" |
| herb | stem + 6 alternating leaf discs | per leaf u=(t·.2 + i/6) mod 1; heal = sin(πu)⁴; op .3 + .5heal, scale 1 + .28heal — "mends what was broken" (leaf by leaf) |
| ground | hexagonal slab Cyl 1.1/1.2 h.16 + load glow | slab never changes; load y .7 + .1 sin(t·.09), op .22 + .12 sin — "it does not yield; only the load breathes" |
| radiance | white core sprite 1.2 + gem halo 4 | b = .5 + .5 sin(t·.075); core 1 + .4b; halo 3.4 + 2.4b, op .2 + .22b — "she is the radiance; there is nothing held" |
| seal | 5 capsule digits | per digit u=(t·.18 + i/5) mod 1; fold = sin(πu)²; rot x .9fold; emissive .6 + 1.6fold; sway — "a gesture, when her card names a gesture and not an object" |
| palm | Circle .6 additive + 3 palm lines | turn = .5 + .5 sin(t·.06); rot z −.3 + .6turn; op .24 + .28turn — "an open palm, which is also an answer" |
| line | 60-pt line drawn progressively | drawn = (t·.14) mod 1 (7.1 s); curve x sin(3.2u)·1.1, y (u−.5)·1.6 + .16 sin 6u, z .3 cos 2.4u; op .3 + .55 sin(π·drawn) — "the line that suggests without saying" |

**KIN substitutions (549–556, "chosen by kinship rather than convenience"):** hook→goad · spear→trident · discus→trident · triangle→seal · triad→seal · hand→palm · gaze→radiance · spine→sceptre · syllable→radiance · ear→palm · drop→cup · flower→lotus · belt→garland · streamer→garland · churn→seal · molten→cup · pour→grain · veil→palm · stretch→sceptre · brush→line · boon→palm · fruit→gem · water→cup · banner→garland · cleanse→palm · shield→ground · radiance→radiance. Unknown → seal.

---

### H-SOUND · The instrument's voice (`homes-sound.js` 1–218; handoff copy identical)
"Her bīja is the carrier; her āvaraṇa's drone is the ground. Climbing crossfades the ground; entering brings her carrier up; her adaptation opens the filter. The fifth is withheld until the ninth world, or until a very long stay." Opt-in: a single "sound" toggle; nothing sounds until pressed (Web Audio requires a gesture).

**Roots (one per āvaraṇa, ascending the body; "The absolute pitch is a design choice and nothing more; what is canonical is the ORDER"):** R1 **55.00** · R2 **61.74** · R3 **69.30** · R4 **73.42** · R5 **82.41** · R6 **92.50** · R7 **98.00** · R8 **110.00** · R9 **123.47** Hz (A1, B1, C♯2, D2, E2, F♯2, G2, A2, B2).

**Carrier from her syllable (10–46):** VARNA order = a ā i ī u ū ṛ ṝ ḷ ḹ e ai o au aṃ aḥ · ka kha ga gha ṅa · ca cha ja jha ña · ṭa ṭha ḍa ḍha ṇa · ta tha da dha na · pa pha ba bha ma · ya ra la va śa ṣa sa ha (49). JUST = [1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8]. `stem()` lower-cases and strips a final ṃ/ṁ and final ḥ (empty → 'a'). Index = VARNA.indexOf(stem); if not found ("a compound bīja (Aim, Klīm, Sauḥ, Hrīm) — take its first letter's place") = first VARNA entry whose first character equals the stem's first character. **carrier = root × JUST[index mod 12] × 2** ("fold into one octave above her root: the interval is hers, the register is ours, and a drone must sit low enough to be felt rather than heard"). No syllable → carrier = root ("silence about what we do not know, rather than a plausible number").
[Builder notes, verified by computation (see H-TABLE carrier column): the "mod 12" wrap means the alphabet order is **not** monotone in pitch beyond the 12th letter (e.g. Kaṃ → ka idx 16 → 16 mod 12 = 4 → 5/4; Caṃ → ca idx 21 → 9 → 5/3; Ṭaṃ → ṭa idx 26 → 2 → 9/8; Taṃ → ta idx 31 → 7 → 3/2; Paṃ → pa idx 36 → 0 → 1; Yaṃ → ya idx 41 → 5 → 4/3; Śaṃ → śa idx 45 → 9 → 5/3 — so Ṭaṃ sits *below* Kaṃ and Paṃ falls back to the root); the canon test only checks Aṃ < Kaṃ < Caṃ. 'Aim' (compound → first letter 'a'), 'aṃ' and 'aḥ' all resolve to 'a' → ratio 1 (the VARNA entries 'aṃ'/'aḥ' are never reached because the final ṃ/ḥ is stripped first); 'aiṃ' → 'ai' idx 11 → 15/8. Klīm → k → 5/4; Sauḥ → 'sau' → s → sa idx 47 → 15/8; Hrīm → h → ha idx 48 → 1.]

**Ground techniques per ring (48–134) — "Each ring's ground is voiced its own way" (the brief: "keep and extend"):** all nine grounds run continuously into a shared lowpass, each with its own gain (silent unless near).
| ring | technique | voicing (exact) |
|---|---|---|
| 1 | drone | sine f (gain 1) + sine f×1.0035 (0.8, a slow beat) + triangle 2f (0.16) |
| 2 | breath — "the home ring breathes: an LFO on its own amplitude" | sine f (1) + sine 1.5f (0.3) into an inner gain whose gain is modulated by a **0.14 Hz** sine LFO, depth 0.55 |
| 3, 6 | breathy — "a sustained voice with air in it" | sine f (0.7) + saw 1.002f (0.1) + saw 2.01f (0.05) through bandpass at 4f, Q 1.6 |
| 4, 5 | stepped — "notes that step rather than glide" | sine stepping f × [1, 9/8, 5/4, 3/2] every **5.2 s (ring 4)** / **3.4 s (ring 5)** via setValueAtTime + sine f/2 (0.4) |
| 7 | sourceless — "no fundamental at all, only its overtones" | sines 2f (0.42), 3f (0.26), 5f (0.14) |
| 8 | triad — "three that collapse toward one" | sines f (0.7), 1.26f (0.6), 1.5f (0.6); every **14 s** the upper two glide (time constant 3.4 s) to f and back |
| 9 | shepard — "a rising that never arrives" | five sines at f·2^(k−1), k = 0…4, each gain 0.22 ± 0.22 by a **0.021 Hz** LFO (detuned k×40 cents), voices detuned k×3 cents |
[The ring-9 "Shepard" here is five static octaves with slow amplitude LFOs — there is no actual pitch glide.]

**Graph & levels (61–160):** master gain 0 → `wake()` 0.5 (time constant 1.2 s); `stop()` → 0 (tc 0.5 s). Lowpass 220 Hz Q 0.7 before master. Carrier: sine (initial 136.1 Hz) gain 0. **Withheld fifth:** sine (initial 204.15) gain 0. **Air:** 4 s looped white noise ×0.5 → bandpass 460 Hz Q 0.6 → gain 0 → master (bypasses the lowpass).
- `setGround(i0, i1, k)`: ground i0 → (1−k)·**0.16**, i1 → k·0.16, others 0 (tc 0.9 s) — climbing crossfades the ground.
- `setCarrier(ring, amount, syllable)`: carrier freq → carrierFor(root, syl) (tc 0.6); gain → amount × **0.1** (tc 0.7) — amount = swallow (how far into her you have travelled).
- `setRoom(a, b, ring, syl)`: lowpass → **220 + 1500a** Hz (tc 1.4) — "her adaptation opens the filter" (a = smooth(chamberT/62)); fifth freq → carrier × 1.5, gain → (ring 9 ? 1 : b) × **0.05** (tc 2.0); air gain → 0.006 + 0.012a (tc 1.5), air band → 380 + 700a (tc 1.6). On the axis: setRoom(0.25, 0, ring).
- `strike(ring, beat, syl)` — "one struck tone as a beat of the rite lands": sine at carrier × **[1, 1.5, 2][beat−1]**, gain 0 → 0.05 in 20 ms, exponential decay to 0.0001 by **3.4 s**, stop 3.6 s; straight to master (unfiltered).
[Conflict to rule on: beat 2's strike sounds carrier × 1.5 — the very fifth that is "withheld" — on every entry, in every ring. Also the "fifth" granted by `grantsFifth` is a perfect fifth above *her carrier*, not above the ring root.]
- `get on` = ready and master gain > 0.001.
- `grantsFifth` (memory): ring 9 → 1; else max(clamp((chamberT − 227)/120), clamp((dwell − 180)/300)).
- Handoff §5: "**Her carrier is derived from her syllable, never invented.** … The pitch and register are ours; the interval is hers. Where no syllable is named, the carrier is the root — silence about what is unknown. **The fifth is withheld** — granted only in the ninth world, on a very long stay, or through a long relationship." Thread: "Sound on gates only." (standing decision) · "Nine drones, one per āvaraṇa, ascending the body; climbing crossfades the ground continuously. Her bīja rises as a carrier as you travel into her. Her adaptation opens the filter… Each beat of the rite lands as one struck tone at her bīja."
- Which Śaktis have a syllable: SYLLABLE 11–18 (Mātṛkās: Aṃ Kaṃ Caṃ Ṭaṃ Taṃ Paṃ Yaṃ Aim), 29–44 (Ring 2: aṃ āṃ iṃ īṃ uṃ ūṃ ṛṃ ṝṃ ḷṃ ḹṃ eṃ aiṃ oṃ auṃ aṃ aḥ — note 43 'aṃ' duplicates 29); BIJA 87–94 (Vāsinīs: Aṃ Kaṃ Caṃ Ṭaṃ Taṃ Paṃ Yaṃ Śaṃ), 99 Aim, 100 Klīm, 101 Sauḥ, 102 Hrīm. **All other 60 Śaktis sound at the bare root.** The ring-level bījas (Aim, Klīm, Sauḥ, Hrīm, Hsraim, Hsklhrīm, Hsauḥ…) are displayed in the library but never used for pitch. App data's Ring 3 bīja 'hsauṁ' (all eight) is not used.

---

### H-DESCENT · Going deeper, as travel (`homes-descent.js` 1–176; handoff copy identical)
"The old Rite had a descent that the Axis lost in the fold. It returns here as what it should always have been: not a screen and not a sheet of facts, but the same inward movement continued. You do not leave her room — you keep going. Five stations, each ONE field of her card rendered as motion, drawn in her āvaraṇa's gem light. Self-paced: a touch carries you the next stretch."
- **STATION_Z = [−16, −34, −52, −70, −88]** (camera travels by dz, eased 0.032/frame, reduced 0.018).
- The shaft: **46 rungs**, 32-gon circles r = 5.4·0.985^i at z = −8 − 2.2i, op .2; each frame opacity .05 + .34·near where near = 1 − clamp(|z − depth|/34) — "the shaft breathes past you". Key PointLight gem 900 dist 70 follows at depth − 6; ambient gem .9; 160 motes 12×12×96.
- Stations visible when near = 1 − clamp(|Z_i − depth|/22) > .02.
 1. **Tattva** — TorusKnot(1.5, .34, 128, 16, p2, q3) emissive gem 1.8 + glow sprite 9 op .3; spins (t·.13 + i, t·.09); emissive 1.8(.4 + near). Word: `card.tattva`.
 2. **Bodily location** — 13 horizontal bars (Box w = 3.4 − |i−6|·.16, .055 thick) y 4.4 − .74i, additive op .2; breath .5 + .5 sin(t·.22 + .4k): op (.08 + .16breath)·near, x-scale 1 + .06breath. Word: `card.loc`. **Defect to fix in port:** comment says "the body as horizontal registers, hers alight" but `mine = Math.round(6 + (0.5 − 0.5)·6)` is computed and never used — no bar is lit for her altitude. Intended: light the bar at her `bodyAltitude`.
 3. **Etymology** — n = clamp(roots.length, 2, 4) glow marks (2.2, op .7) orbiting (a + t·.12) inward: draw = (t mod 14)/14, radius 3.4(1 − draw), op .5·near(1 − .6draw); a white "one" sprite op draw³·.9·near — "the roots orbiting inward until they are one word" (14 s cycle). Word: roots joined " + ".
 4. **Quality** — Icosahedron(2.1, 1) flatShading emissive 1.2, spinning — "one form, turning, saying nothing else". Word: `card.quality`.
 5. **Phrase** — three flat tori r 2.4/3.5/4.6 op .34/.26/.18 + white sprite 3.4 op .6 — "the inscription, and the floor of the descent". Word: `card.phrase`.
- Mid text shows the station's word. Buttons: "go deeper" → "further" (×4) → "come back up" → back to room (dz 0).

### H-MEMORY · Return (`homes-memory.js` 1–77; handoff copy identical)
"depth is FELT, never displayed. No counters, no percentages, no badges. She knows everything about your walking and shows none of it. The head start comes from accumulated DWELL, not from visit count — so it cannot be gamed by entering and leaving. A room you have truly stood in opens further along, because your eyes remember it."
- Storage: localStorage **`homes.axis.memory.v1`** = `{ "<shakti.id ?? shakti.name>": { v: visits, d: dwellSeconds } }`. Writes swallow errors (private mode).
- Marks: ADAPT 62 · HOLD_END 227 · SECOND_END 347.
- `known(s)` = v > 0.
- **compression(s)** = 1 if v ≤ 0 else **max(0.36, 0.68^min(v, 4))** → 1st return .68, 2nd .4624, 3rd .3144→.36 floor. Multiplies the rite beat duration — "Never skipped — the name is simply written a little faster, because you already know it."
- **headStart(s)** = 0 if d < **12 s** else **min(d × 0.55, 227 − 6 = 221 s)** — "Capped so a first return still crosses the adaptation, and so a deeply-known room can open at the second one." Room clock starts at headStart.
- **grantsFifth(s, ring, chamberT)** = 1 if ring 9; else max(bySecond = clamp((chamberT − 227)/120), byBond = clamp((d − 180)/300)) — "the ninth world, a very long stay, or a long relationship".
- **record(s, dwell)** once on leaving: v += 1; d = min(**4000**, d + max(0, dwell)).
- `ringKnown(list)` — any met in the ring; "for the climb rail, never a count".
- `forget()` clears everything ("forget me").
- **Builder caution:** in the Axis, roster entries carry no `id`, so memory is keyed by **name** — and names repeat (e.g. pos 19 & 53 both "Sarva-Saṅkṣobhiṇī", 20 & 54 "Sarva-Vidrāviṇī", 21 & 55 "Sarva-Ākarṣiṇī", 22 & 60 "Sarva-Vaśaṅkarī", 23 & 62 "Sarva-Onmādinī"), so their dwell is shared. Port keyed by **khaḍgamālā position** (Invariant 6).
- Felt consequences (Axis): met Śakti carries a white core light and a slow steady pulse (rate .22, depth .09, halo ×1.25); one faint trace sprite on her floor per visit, max 7 (gem colour, size 1.1, op .16, at y −4.1 scattered); "you have stood here before" for the first 14 s after the head start; rail marks her ring.

### H-TODAY · Who presides today (`homes-today.js` 1–87; handoff copy identical)
"An exact port of the shipped DailyEnergyService.swift … Do not 'improve' the arithmetic: fidelity to the device is the whole point."
- DAY_BOUNDARY_HOUR **6** (local); EPOCH **2020-01-01 00:00 UTC (1577836800 s)**.
- `practiceDayIndex(date)` = round((startOfDay(date − 6h) − startOfDay(epoch − 6h)) / 86 400 000) (local startOfDay, like Calendar.startOfDay).
- SplitMix64 (BigInt, mask 2⁶⁴−1): s += 0x9E3779B97F4A7C15; z = (z ^ z>>30)·0xBF58476D1CE4E5B9; z = (z ^ z>>27)·0x94D049BB133111EB; return z ^ z>>31.
- Cycle seed = cycle XOR **0xD1B54A32D192ED03**; cycle = floor(day/102), slot = day mod 102; positions 1…102 shuffled by **downward Fisher–Yates** (i from 101 to 1, j = rng() mod (i+1)); returns shuffled[slot].
- `nextTurnover(date)` = today 06:00 local, or tomorrow's if past.
- `locate(position, ringLengths)` → [ringIndex, indexWithinRing], khaḍgamālā outward-in.
- Thread: three things share the word *rite* — `DailyEnergyService` (who presides) · `DailySummons` (6am notification; one a day, no sound, no badge, dropped if the rite is done) · `DailyRiteView` (daily practice, six archetypes) · **The Rite of Entering** (ours, the threshold into a room) — "must not be confused again".

---

### H-STUDY-ROOMS · "The Homes — Rooms in 3D" (superseded study; `The Homes - Rooms in 3D.html` 1–213, `homes-3d-rooms.js` 1–291, `homes-3d-rooms-2.js` 1–511)
Status per thread: "**Eight** rooms as real three.js interiors, live and animated" — **to be retired** ("Retire the three superseded studies … so the record cannot drift again"). It is the **richer technique reference** for four rooms whose Axis versions were simplified to stay single-pass. Not walkable: rooms are chosen from a **button rail** (a switcher — exactly what "no cuts" forbids), with speed buttons 1× / 6× / 20× ("Each mechanism runs over about a minute — real adaptation, not a loop. This lets you watch a full closing in seconds without changing what the room is."). Boot word "entering". Renderer exposure **1.06**, camera **58°** far 400. Per-room scene fog/bg and camera pos/look. Camera sway sin(t·.11)·.13 (0 if reduced) and bob sin(t·.08)·.09; wheel moves zOff −9…+6 (×0.006); drag yaw ×.0022, pitch ×.0016 clamped ±.42. **Reduced motion: `update(min(t, 62))`** — [this freezes at the first adaptation, contrary to the later rule "longer and quantized, never disabled"]. UI: Devanāgarī name 34px op .72 at top 38px; "{name} · {quality}" gold 11px .34em; the room's mechanism sentence (19px) at bottom 132px; label mono 9px at bottom 104px; meta "ring N / real 3d · live"; hint "drag to look · scroll to move"; text fades while dragging ("the text recedes while you look, so the room is never behind writing"). DEV names: anima अणिमा · mahima महिमा · vasitva वशित्व · bindu महात्रिपुरसुन्दरी · laghima लघिमा · garima गरिमा · yoni सर्वयोनि · trikhanda सर्वत्रिखण्डा. Thumbnail: gold square, inner amber square, white point on #060301.

Mechanism sentences (verbatim, `mech`):
- **Aṇimā** (Smallness, ring 1): "The door is smaller than you. You are admitted anyway — and then it keeps closing, so the longer you stay the smaller you have become. It never reaches you."
- **Mahimā** (Vastness): "Her room has no far wall. Every edge you move toward proves to be the near edge of something larger, arriving out of the haze faster than you can cross it."
- **Vaśitva** (Mastery): "The room is not lit — it is known. Only what your attention rests on exists; walls, pillars and her seat resolve inside a travelling pool and fall back to nothing behind it."
- **Mahātripurasundarī** (Totality, ring 9): "No room at all. The enclosure is gone, and the yantra you have been walking through the whole time stands revealed as the thing you are inside."
- **Laghimā** (Lightness): "The floor has released. Her walls end before they reach the ground and their hems lift though there is no wind — everything loose is already on its way up. Nothing in this room falls."
- **Garimā** (Weightedness): "Her ceiling lowers the entire time you are in it, casting its own weight as shadow, while the floor thickens into strata beneath you. Leaving costs effort no other room asks for."
- **Sarva-Yoni** (Source): "There is no entrance. The ceremony finds you already within, because no position exists from which you could have arrived. The walls are membrane rather than stone — lit from behind, veined, moving with your breath."
- **Sarva-Trikhaṇḍā** (Trinity-as-Unity): "Three rooms occupy the same place, mis-registered like a triple exposure. Move and they part into three. Hold still and they slide into register — one white room, and it was always one room."

Differences from the Axis versions (the study's fixed palettes vs the Axis's gem-conditioned ones):
- **Aṇimā** (rooms.js 8–67): Box 9×9×26 BackSide `0x7a5322` "topaz-stone" ("The bhūpura, from inside"); aperture core r .12 `0xfffdf2`, sprites (rgba(255,236,190)→rgba(255,196,90,0)) `0xffe1a4` 5.2 op .95 and `0xffcf80` 14 op .4 at z −12.4; key `0xffd18a` 900 dist 46; fill `0xffb974` 150 decay 2.2; ambient `0x4a2f10` 1.5; seams `0xffe0a8` op .34; fog `0x0a0602` @ .019, bg `0x060301`; camera (0,0,8.6) → (0,0,−6). Same contraction k = .34 + .66(1 − smooth(t/62)); z-scale 1 − (1−k)·.42; "62s of closing, then it holds. It never reaches you: floor at 0.34." No second adaptation.
- **Mahimā** (70–129): 26 square thresholds (7 + .5i) `0x9cc8ff` op .85 with halo sprites over SPAN 130, flow 3.4/s; four rails `0x6e9fe0` op .16 ("The near edges you are between — proof you are inside, not looking at"); ambient `0x2c5fa8` .7; haze; fog `0x02060f` @ .021; camera (0,0,5) → (0,0,−40).
- **Vaśitva** (131–192): identical construction to Axis M4 (fixed violet); fog `0x05040a` @ .02; camera (0,.4,9) → (0,−1.4,−8). Comment: "the pool of knowing travels; it grazes floor, pillars and her seat in turn". "Only what attention rests on exists; the rest is not dark, it is absent."
- **Mahātripurasundarī** (194–280): same yantra as Axis M7 (64-gon circles, 16-step petals); fog `0x070604` @ .012; camera (0,0,6.4) → bindu. "the nine interlocking triangles, at nine depths — you are inside them". No second adaptation.
- **Laghimā** (rooms-2 8–139): 4 walls 17×11 (30×44 segs) at ±8.2; extra vertex term `p.x += hem·cos(uTime·.27 + uv.y·2.4)·.12`; fragment fixed cold colour mix((.05,.07,.10), (.92,.96,1.0), uv.y^1.5), weave sin(uv.y·260), uOpacity .86 — "four hanging walls — they stop in mid-air; there is no floor mesh at all". Ceiling opening Ring 2.2–9.4 `0xdce7f2` op .16 at y 7.1; sky sprite 26 op .3; Directional `0xeaf2fb` 3.4; ambient `0x33414f` 1.1. **Rising field 420 points**, box 13×26×13, gl_PointSize = aSize·300/−z **unclamped** (this is the version that "stacked additively to pure white at arm's length" — defect 2; the Axis clamps 1–9 and starts the field 4 units out). **Unmoored seat** torus r1.6 white op .6 drifting up y −3.4 + 4.2lift + .22 sin(t·.21) ("her seat — untethered, drifting up off its own ground"). Fog `0x121821` @ .03; camera (0,.2,3.2) looking UP at (0,3.4,−6).
- **Garimā** (141–259): fixed earth colours — ground `0x8a6636` 220×220 segs, slab `0x241a10`, underside `0x6b4e2c` 90×90, rim `0xc08a3e`, walls `0x50381c`, **palm-press `0x8b1a2a` (accentRed) emissive `0x40060e` ×1.2**, ember `0xd8452c`, raking `0xffcf92`, ambient `0x6b4c2e` 3.2; **fog thickens 0.03 + 0.028k** ("the air thickens too"); "the light is squeezed out" (raking 3.6 − 2k). Camera (0,−.4,9.6) → (0,−2.4,−6). "Leaving costs effort no other room asks for" (not implemented as a mechanic).
- **Sarva-Yoni** (261–355): profile 41 pts, Lathe 72 segs, 9 veins with random radius .035–.065; yoni triangle (−2.4,1.5)(2.4,1.5)(0,−2.6) op .86 + glow 15; lamps (colour, power×0.6) `0xffc79e` 900 · `0xff9a70` 700 ×2 · `0xffd9bc` 520 · `0xe8845c` 420 — "every source is beyond the membrane — that is what makes it read as flesh"; yoni op .5 + .4k. Fog `0x1e0708` @ .02; camera (0,.6,5.2) → (0,−2.4,−5.4). "it moves with your own breath" (actually a 0.28 rad/s sine, not the walker's breath).
- **Sarva-Trikhaṇḍā** (357–500) — **multi-pass render targets**: one neutral room (Box 13×11×30 `0x585874`, white seams op .95, a 6.4 seat frame at z −12.6, floor grid lines −6…6 at y −5.4, three seal sprites+cores, far light plane 5.2 op .14, key white 560, wash `0xd8d8f0` 240, ambient `0xa8b0d8` 1.15). Rendered **three times** into three full-resolution WebGLRenderTargets from camera offsets `[(−1,−.42),(1,−.22),(.06,1)] × sep × (.52, .46)` with small yaw/pitch (×.014, ×.011), then composited by a full-screen shader: `sep = vec3(a.r, b.g, c.b); one = (a+b+c)/3; out = mix(one, sep, uSep)` — "separated they are three coloured rooms; identical they sum back to the one white room. Convergence to a single white room is computed, not drawn." sep = 1 − smooth(t/62); seals spread on a 1.5·sep circle. Verified asymmetry 86|81 → 81|81 at convergence. The Axis replaced this with three tinted shells "so it stays single-pass and the travel never cuts".

### H-STUDY-WORLDS · "The Homes — The Nine Worlds" (superseded study; `The Homes - The Nine Worlds.html` 1–226)
Imports `homes-worlds.js?v=6` (Axis uses v7). The worlds **shown empty** — no Śaktis. Same renderer/fog/camera/climb as the Axis (rise 3.4/s; wheel ×0.055; climb ease .06/.035 reduced; camera drift; look −1.9). Comment on the env map: "A dim neutral environment, so physically-based surfaces have something to reflect. Without it every metal and every glass in these worlds reads black." Differences from the Axis: fog density is a plain lerp (no veil), background ×0.5, worlds update at full `t` (no tempo). UI: ord "the {ordinal} āvaraṇa · {region}", name 29px, "{gem} on {dhatu}", weather sentence (19px, bottom 118px), facts row "{clock} {dhatu} {gem}" (mono 9px, bottom 78px), climb rail of regions (top = Totality), "rise" button bottom-left, hint "scroll to climb · drag to look", boot "the nine worlds". Thumbnail: eight stacked gem-colour bars on #0D0508.

---

### H-CONCEPT · "The Homes — Concept Board V3" (frozen reference; `The Homes - Concept Board.html` 1–508 = `The Homes - Concept Board V3 (SVG).html` 1–508, byte-identical by `cmp`)
`<meta name="design_doc_mode" content="canvas">`; title "The Homes — Concept Board V3". Nine 360×560 phone frames (radius 24px, black, shadow), each an animated SVG with a vignette, a mono label (9px .26em, op .5) and a caption (h3 25px + italic gold quality; mechanism sentence 16px; mono source line 10px). Thread: "Nine mechanisms as lit SVG frames. Preserved as the reference board." Reduced motion: `@media (prefers-reduced-motion: reduce) { * { animation: none !important } }` [board-only; contradicts the later rule].

Frames (label · caption · source line · animation):
1. **Aṇimā — Smallness** (56–111). Perspective box: walls `#1A0F05→#4A2E0E→#8A5E22`, floor `#0A0602→#553613→#B98A3E`, ceiling `#080401→#2A1A08→#6B4718`, far wall radial `#FFFCF2→#FFEDC4→#E8A94A→#8A5A18→#3A1F06`; `an_walls` 13 s cubic-bezier(.4,0,.6,1) scale 1.02 ↔ .8; motes drift 15/19/22 s; bindu point r2.6 `#FFFDF6`. Label "the walls close while you stand still". Caption: "The door is smaller than you, and you are admitted anyway. Then it keeps closing — walls, ceiling and floor drawing in on the topaz — so the longer you stay the smaller you have become. It never reaches you." Source: "Function · grants entry into any place no matter how confined".
2. **Mahimā — Vastness** (113–159). Deep radial `#7FB4F2/#2C5FA8/#0C1E3E/#02060F`; four 96px square thresholds pushing out `mh_push` 16 s (scale .05 → 5, staggered −4 s); converging rails `#6E9FE0`. Label "no far wall · it never arrives". Caption: "Her room has no far wall. Every edge you move toward proves to be the near edge of something larger, arriving out of the sapphire haze faster than you can cross it. The one room you cannot finish." Source: "Function · holds the polarity of small and large".
3. **Laghimā — Lightness** (161–205). Air gradient `#0E1218→#2E3A48→#7E93AA→#E6EFF8` (bright overhead); hanging walls with curved hems `lg_hem` 11 s (−9px, 1.2°); motes rising `lg_rise` 11–17 s (+20 → −190px). Label "the floor has let go". Caption: "The floor has released. Her walls end before they reach the ground and their hems lift though there is no wind; everything loose is already on its way up, and the brightness is overhead, not ahead. Nothing in this room falls." Source: "Somatic · the lift that comes the moment a burden is set down".
4. **Garimā — Weightedness** (207–251). Strata floor `#4A3418→#241906→#0A0602` with five lines thickening 1.4 → 8px; descending ceiling `gr_low` 17 s (+26px) with weight-shadow; palm-press seat `#D8452C/#8B1A2A`, `#B8263C`, `#E8654A`. Label "the ceiling is coming down". Caption: "Her ceiling lowers the entire time you are in it, casting its own weight as shadow, while the floor thickens into strata beneath you. One palm-press is set into the ground, still glowing. Leaving costs effort no other room asks for." Source: "Somatic · the settledness no argument can shift".
5. **Sarva-Yoni — Source** (253–294). Womb radial `#FFD9BC/#E8845C/#8C2E1E/#1E0708`; membrane `#F0A882/#C05438` with veins `#FFCBA8`; `yo_breath` 10 s (scale 1.05, −6px); downward triangles `#FFE2C8/#FFF2E4/#FFFFFF`. Label "no door · you were always inside". Caption: "There is no entrance. The ceremony finds you already within, because no position exists from which you could have arrived. The walls are membrane rather than stone — lit from behind, veined, moving with your own breath." Source: "Function · the receptive aperture through which Bindu emanates".
6. **Sarva-Trikhaṇḍā — Trinity-as-Unity** (296–337). Three screen-blended perspective rooms `#FF6A62 / #4FE0A8 / #6F8FE0` mis-registered by `tk_a/b/c` 12 s (±9px, ±1.6°) converging at 50%; three white seals. Label "three rooms · one seal, only in stillness". Caption: "Three rooms occupy the same place, mis-registered like a triple exposure in red, green and blue. Move and they part into three. Hold still and they slide into register — one white room, and it was always one room." Source: "Function · the structural recognition that the trinity is one movement".
7. **Mahātripurasundarī — Totality** (339–382). Glow `#FFFFFF/#FFFAEC/#F2D89A/#C9963F/#3A2A0C` breathing `bd_breathe` 16 s (.94 ↔ 1.07); yantra line drawing (two squares, two circles, 4 up + 5 down triangles) scale .72; centre `#8B1A2A` dot r7 with white bindu r2.4. Label "there was never anyone here but Her". Caption: "No room at all. No walls, no floor, no aperture — the enclosure is gone, and the yantra you have been walking through the whole time stands revealed as the thing you are inside. The one home that dissolves the building." Source: "Ring 9 · bindu · all gems, pure light · kāla–akāla".
8. **Vaśitva — Mastery** (384–428). A masked perspective room revealed only inside a 112px pool `va_sweep` 21 s (three-point path); colours `#241C3A/#4A3A72/#CDBBEF/#E4D8FF/#9A86C4`. Label "the room exists only where attention rests". Caption: "The room is not lit — it is *known*. Only what your attention rests on exists: walls, corners and her seat resolve inside a travelling pool of knowing and fall back to nothing behind it. You never see the whole room at once." Source: "Ring 6 · Nigarbha, in the womb · verb: STILL" [Vaśitva is position 6 in Ring 1; the source line cites Ring 6 because Vaśitva is Ring 6's Siddhi in the brief's table].
9. **The nine worlds — weather, not palette** (430–476). Nine vertical gem-gradient bars with a glowing band at each world's altitude (feet low → above crown high), the ninth a breathing white point. Label "nine worlds · gem, altitude, clock". Caption: "Each ring's gem is its light, its dhātu its material, its body-region its altitude — the glowing band is where each world's gravity sits, climbing feet to totality. A world should be felt before any Śakti is set inside it." Source: "Topaz · sapphire · coral · diamond · emerald · ruby · pearl · cat's eye · all gems".

**The logic panel (478–502), verbatim:**
> The Homes · concept board V3 · not a build
> **The room is the mechanism.** *Nine concepts, pushed three passes.*
> **What went wrong before** — Your package says a home's **Function** becomes "what the room *does to you*" — and names two outright: "Aṇimā 'grants entry into any place no matter how confined' — her room admits you through a door that should be too small. Mahimā 'holds the polarity of small/large' — her room has no far wall." **I built one perspective box for all of them and varied the shape of the light and the speed of the fade. That is decoration. A room whose far wall *is not there* is a mechanism. Every frame here changes what the room does.**
> **The three layers, instead of P-numbers** — 1. **The building.** One architecture all 102 share — entering, dwelling, going deeper, doors, leaving. Built. It is the floor, and it should be nearly invisible. 2. **The nine worlds.** Each āvaraṇa's conditions: gem as light, dhātu as material, cycle as clock, bīja as tuning, body-region as altitude. A world is *weather*. 3. **Her mechanism.** What her room does to whoever stands in it. This is the whole design — what makes 102 rooms instead of 102 palettes.
> **Your test** — "Could this room belong to any other Śakti? If a stranger walked into both, they should know which is which without a name." Judge every frame against that sentence. Tell me which clear it, which are still decoration, and which mechanism is wrong for her — and I keep pushing before anything gets built.
> **What these still are not** — Frames, not rooms. Each is one moment of a mechanism that only exists in time — Aṇimā's walls closing over ninety seconds, Trikhaṇḍā's three rooms sliding into register as you hold still, Vaśitva's pool of knowing following your attention. And the two summits — Mahimā's endless depth, Mahātripurasundarī's dissolution of the building — want real 3D, not SVG.

Thumbnail: gold square, gold triangle, cream point on #0D0508.

---

# B · Intentions, warnings and acceptance criteria

## B1 · Design's stated intentions and warnings — verbatim

### The warning about one perspective box (Concept Board V3, logic panel, lines 484–487)
> "Your package says a home's **Function** becomes 'what the room *does to you*' — and names two outright: Aṇimā 'grants entry into any place no matter how confined' — her room admits you through a door that should be too small. Mahimā 'holds the polarity of small/large' — her room has no far wall. **I built one perspective box for all of them and varied the shape of the light and the speed of the fade. That is decoration.** A room whose far wall *is not there* is a mechanism. Every frame here changes what the room does."
> "What these still are not — Frames, not rooms. … the two summits — Mahimā's endless depth, Mahātripurasundarī's dissolution of the building — want real 3D, not SVG."

### The three layers (thread 3–4; Concept Board 489–494)
> "Three layers, not P-numbers. **The building** (one architecture all 102 share) · **the nine worlds** (each āvaraṇa's weather) · **her mechanism** (what her room does to you)."
> "The building … It is the floor, and it should be nearly invisible." / "Her mechanism … This is the whole design — what makes 102 rooms instead of 102 palettes."

### Standing decisions (thread 371–377)
> "Register is Turrell's adaptation mechanism, not cathedral scale — mechanisms run ~60s. Uniqueness carried by what the room *does*, not by palette. Threshold is tap-paced, never skipped, compressed on return. Sound on gates only. Reduced motion is longer and quantized, never disabled. Reference matter is never deleted — it becomes the floor of the descent."
> "**Time is elapsed, never device-tied.** Locked decision, governs all eight: mechanisms run on ~62 seconds of real time, not on proximity, motion or stillness." (thread 368–369)

### The Axis — the fold (thread 302–328)
> "The lens: **no cuts, only travel.** One scene holds all nine worlds and all 102 Śaktis."
> "**The rite IS the distance.** Entering her is not a screen — the three beats happen *while* you cross toward her, in three self-paced surges of travel. … Touch carries you the next stretch; the third touch releases you inside. Nothing advances on a timer, and nothing is ever skipped."
> "Tap a light and her world's air thickens and swallows the surroundings; the point becomes her room. There is no transition screen anywhere."
> "**Chambers are conditioned by their world.** The same mechanism in a different āvaraṇa is a different room, because the gem is the light and the dhātu is the material."
> "Brighter points are Śaktis whose rooms are built. Dimmer ones are seats awaiting a mechanism." [Now all 102 are "built" → all bright.]
> [Code check: the tap on her light begins beat 1; touch 1 → beat 2, touch 2 → beat 3, touch 3 ("touch to enter") → entering. Consistent with "the third touch releases you inside".]

### The nine worlds (thread 330–348)
> "One continuous vertical world. Climbing IS the ascent of the body, and the air, light colour and fog density blend continuously between bands — no switcher, no cuts." Per-ring technique table (see H-WORLDS). "Each world's clock runs at its own real rate: the day–night cycle turns in seconds, the season and the solar half-year barely move while you stand there."

### The return (thread 279–300)
> "**Her room begins where you left it.** … What return changes, all of it felt and none of it displayed: She was expecting you … The ceremony softens, never skips … Her room opens further along … Your traces stay. One faint mark on her floor for every time you have stood there. The fifth is granted by the ninth world, a very long stay, *or* a long relationship. The climb rail marks āvaraṇas holding someone you have met — never how many. On arriving back: one line, once. *you have stood here before.* No number anywhere. **forget me** lets all of it go."
> "Standing rule, from `the method`: the instrument may know everything about your walking and must display none of it."
> [Traces are capped at 7 sprites — "one mark … for every time" holds only up to 7.]

### Today (thread 253–277)
> "**Correction on the record:** the daily summons was never missing. Three things share the word *rite* and must not be confused again" (DailyEnergyService · DailySummons · DailyRiteView · **The Rite of Entering** — "ours, unrelated").
> "The instrument opens where she is, not on a menu … She carries a standing crown-light on the axis, breathing slowly. You did not choose her. *she presides today* appears only in her āvaraṇa; approaching her reads *hers is the day*. **today** returns you to her from anywhere. Choosing anyone else remains possible. **The day turns at 6am without a reload** — she hands over in place." "Do not 'improve' that arithmetic — fidelity to the device is the whole point."

### Iconography (thread 26–71)
> "The move: **her held object is not shown to you — it performs.** It is the only thing acting inside a room that is otherwise a mechanism. And it stays aniconic, because a noose is a shape, not a figure."
> Defect caught: "The motion check called **fifteen living attributes inert** … a sceptre barely moving *is* its character. … **The verifier was wrong, not the design** — the second time this pass that the harness needed correcting."

### The coverage audit — seven things the brief asked for that were missing, now built (thread 73–107, verbatim summary)
1. Hue tokens "keep" — gem had replaced hue (ring 6 ruby vs teal 194°) → all nine hues now Atmosphere's; gem gives saturation/lightness/diffusion.
2. Doors walkable without the Mandala — missing → named doors on both sides, crossing begins where you stand.
3. Cluster Group shares a corridor — not built → doors open within neighbourhood first (e.g. "Vārāhī's doors lead to Vaiṣṇavī and Māhendrī, her fellow Mātṛkās" [card set: Vaiṣṇavī 14 and Indrāṇī 16; Māhendrī is the app's name for 16]).
4. Library kept, folded — dropped → folded behind the room.
5. Well letter as folded object — dropped → read from storage only, never invented.
6. Yoginī class sets how veiled — unused → veil 0 → 1.
7. Mental state sets tempo · Mudrā verb · presiding Form — unused → tempo 1 → 0.28; each āvaraṇa names its Form on arrival.
8. Per-ring sound keep & extend — "Nine copies of one sine drone" → each ring voiced its own way.
> "**This is reported, never silently absorbed — it is a real reconciliation for the Code handoff, not a design choice.**" (on the 61 names)
> Sample gate: "Laghimā and Garimā, same world, differ by **100% of their geometry and 116 of luminance** — '*the floor has let go*' against '*the ceiling is coming down*.' Garimā's authored descending-mass room, which existed but had never been wired into the instrument, is now hers."

### V3 — six real defects (thread 133–148)
1. "The Axis had dropped the descent." 2. Laghimā's rising field stacked additively to pure white at arm's length → point size clamped, field pushed off the eye. 3. Laghimā went dark at the second adaptation (walls departing) → the opening takes over. 4. Ring 4's cosmic rooms had no wall at all. 5. Ring 1's Mātṛkās read as one flat surface → a floor. 6. "The harness's own first version gave a false positive, matching the host's injected editor globals instead of my debug hooks. The verifier needed verifying."
### Grammar pass — four defects (thread 213–222)
1. "Names collide across rings … **Her position is now authoritative; a name match from another ring is a collision, not a match.**" 2. "The app's names differ from the cards … lookup fell silently through to the shared seat. Punctuation-tolerant key plus positional fallback; diacritics preserved, because they are meaning." 3. "Ring 8's triangle was larger than the room." 4. "Ring 6's veil was unlit, so it extinguished rather than obscured. Now a lit surface."
### Rings 1–2 pass (thread 186–191)
> "**Ring 2 was never on the axis at all.** `SHAKTIS_BY_RING[2]` is empty in this project's data, so the home ring — the richest one — had been showing a single placeholder the whole time. The roster now prefers the app's data and falls back to the cards" [code actually prefers the cards whenever they exist].
> "And the bīja is no longer invented … a straight violation of §7 of `the method`."

### The method (`Bindu Mandala - the method.md` 1–172, in the handoff folder) — rules, verbatim headings and load-bearing lines
- §0 "Read everything before making anything … **Nothing about the brief caused that. Not reading did.**" (`all-shaktis-data.js` is authoritative — never work from memory of the canon; read `github.md` to know what shipped.)
- §1 "Mechanism, never mood. A mood is unbuildable and produces decoration. A mechanism is buildable and produces design." ("Turrell: nothing appears to happen until your eyes have adjusted, and only then is it clear the room was exact the whole time" → an adaptation clock every surface reads from.) "When a direction arrives as an adjective, convert it to a mechanism **out loud** and get that confirmed before building."
- §2 "Never show the first attempt … push to V2 silently, push to V3 silently, then think twice before showing V3."
- §3 "Say the plan in plain words, and distrust your own vocabulary … the brief's *uniqueness grammar* … had been flattened into two decorative knobs, aperture shape and fade speed. The brief was more radical than the build."
- §4 "Fix the rule, not the instance … name the class before touching the code" (`riteApertureSpan`).
- §5 "**No cuts, only travel** … if the user has to choose from a list, the design isn't finished."
- §6 "One engine with N tunings, never N artefacts … **the mechanism is hers; the light, material and geometry come from her world.**"
- §7 "Build from the real data, degrade gracefully, never invent canon … The gaps are information."
- §8 "Verify what the eye can't reach — and verify backwards" (WebGL readPixels after an immediate render; V1/V2/V3). Standing technical notes: "module `<script>` imports cache — bump a `?v=` query after editing. And `Object3D.position` is read-only; `Object.assign(light, {position})` throws in a module and silently kills the whole file. Additive points at close range stack to pure white — clamp `gl_PointSize`."
- §9 "Time is elapsed, never device-tied … Stillness may govern *arrival* of something, never its *persistence* (once a line has surfaced it stays for the visit; a high-water mark, not a live reading)."
- §10 "Never measure it out loud … Depth is felt — a ceremony that runs quicker, a room that opens further along, a light already lit when you arrive."
- §11 "Register decisions where they survive the conversation … Anything that lives only in a message is already lost."
- The shape of a new space: Read → Convert → Concept three passes deep → Judge against the ask's own test ("could this room belong to any other Śakti?") → Build the engine, condition it, show the gaps → Verify by probe → Write the decisions down. "Ask when the answer changes what gets built and cannot be derived from the files."

### Next (thread 394–407)
> "The design work is done, and the bottleneck has moved off design. 1 The Claude Code handoff … 2 The name reconciliation — 61 of 102 … Ashrey's call, being taken to Claude Chat. 3 **Retire the three superseded studies (`The Rite of Entering`, `Rooms in 3D`, `The Nine Worlds`) so the record cannot drift again.** 4 Diminishing returns past here: a third state beyond the second adaptation, per-Śakti refinement without end. Worth doing only once the instrument runs on the phone."
> Thread status row: "Ring batches — Ring 2 first, then Ring 1 by family, then 3–9 — **not started**" [stale: the later sections say the 102 are closed].
> "The debt this closes: The two Śakti-card files are the **Ruling-7 content pass** — Quality / Function / Somatic / Tattva / Bīja / Etymology / Iconography for all 102 … Rings 3–9 cards still to come." [stale; they arrived].

## B2 · The verification contract — every check, verbatim

### `homes-verify.js` (1–113; handoff copy identical) — the harness primitives
Header: "Not 'does it load'. This runs BACKWARDS from what has been claimed, in six registers, against the real modules — and it is built to FAIL loudly." (CANON · COVERAGE · DISTINCTION · LEGIBILITY · PROMISE · FELT)
- `register(name)` / `check(id, fn, note)`: pass if fn returns `true` or `{pass:true}`; any other return value is the failure detail; a throw fails with "threw: …".
- `makeStage()`: offscreen WebGLRenderer **240×200**, preserveDrawingBuffer, SRGB, ACESFilmic exposure **1.04**, same 64×32 env gradient as the Axis; camera 60° at origin looking at **(0, −0.3, −9)**; scene fog FogExp2 (default 0x0a0508 @ 0.02). `shoot(chamber, t, fogDensity, fogColor)` → update(t), render, **16 `gl.readPixels` samples on a 4×4 grid** at (w·i/5, h·j/5), luminance = .2126R + .7152G + .0722B → {max, min, mean, spread, vals}.
- `fingerprint(chamber, t)`: update(t) then, for every descendant, "x,y,z|scale.x|opacity" to 2 dp. `divergence(a, b)` = fraction of unequal entries.
- **MEASURING** (forbidden walker-facing patterns): `\b\d+\s*(?:of|/)\s*\d+\b` ("3 of 9") · `\b\d+\s*%` · `\bvisit(?:s)?\s*[:=]\s*\d+` · `\bstreak\b` · `\bprogress\b` · `\blevel\s*\d` · `\bscore\b` · `\bday\s*\d+\b` · `\b\d+\s*(?:times|visits)\b`.

### `The Homes - Verification V3.html` (1–648; handoff copy identical) — **66 checks in nine registers**
Page: "Verification V3 — Run backwards from what has been claimed, in six registers, against the real modules." Roster built exactly like the Axis (cards preferred; `appName` kept). EXPECT = [28,16,8,14,10,10,12,3,1]. Totals panel: registers (prints "6" — hard-coded although nine registers run), checks, passing, failing, śaktis exercised (102), rooms rendered (204). Footer: "all {n} checks pass · 102 śaktis · 204 renders" or "{n} failing — read the red rows". `window.__V3 = {pass, fail, registers}`. Thumbnail: gold circle + green tick on #0A0810.
Sampling times used: near label at t=20, fingerprint at t=30, deep label at t=300; renders at t=20 and t=300 with fog = world density×2 and world fog colour.

**1 · canon** (6)
1. all 102 cards exist, one per khaḍgamālā position
2. every card carries quality, tattva, location, roots and phrase
3. every card carries her Devanāgarī (U+0900–097F) — *"the writing hand must write her script, not a transliteration"*
4. ring spans match KhadgamalaMap.swift {1:1, 2:29, 3:45, 4:53, 5:67, 6:77, 7:87, 8:99, 9:102} — *"checked against the shipped app, not from memory"*
5. no invented bīja frequency — the carrier derives from her syllable: carrierFor(100,'Aṃ') < (100,'Kaṃ') < (100,'Caṃ'); carrierFor(200,'Kaṃ') = 2× carrierFor(100,'Kaṃ'); carrierFor(100, null) = 100 — *"the pitch is ours, the interval is hers"*
6. the roster totals 102 at 28·16·8·14·10·10·12·3·1

**2 · coverage** (5)
7. every one of the 102 resolves to a built room (isBuilt)
8. every Śakti resolves to a card of HER OWN ring — *"names collide across rings — Kāmeśvarī is in both 7 and 8"*
9. the known collisions resolve by position, not by name (passes with "collision not present in this roster" if absent)
10. every chamber exposes update() and a label
11. no Śakti falls through to the shared seat (label ≠ "her seat, from inside")

**3 · distinction** (4)
12. no two Śaktis in one ring speak the same near words — *"could this room belong to any other Śakti?"*
13. every room reverses its premise at the second adaptation (near label ≠ deep label)
14. adjacent sisters diverge geometrically by more than a tenth (divergence ≥ 0.1) — *"aperture and rate must actually differ, not just the words"*
15. her world conditions her room — the same mechanism differs by āvaraṇa (Ring 3's first Śakti built in world 3 vs world 6: divergence > 0.02)

**4 · legibility** (5) — 204 renders
16. no room renders black at the first adaptation (max luminance ≥ 28)
17. no room blows out to white (min ≤ 232)
18. every room has internal contrast — light falls somewhere (spread ≥ 10)
19. the second adaptation is still legible (deep max ≥ 24)
20. the light visibly changes between the two adaptations (|Δmean| ≥ 2 or |Δspread| ≥ 3)

**5 · promise** (10)
21. time is elapsed, never device-tied (fingerprint(40) twice identical; ≠ fingerprint(41)) — *"locked decision, governs all 102"*
22. the head start comes from dwell, not from visit count (6 visits × 0.2 s vs one 200 s stay: earned > 4× cheap) — *"it must not be gameable by entering and leaving"*
23. the ceremony compresses on return but is never skipped (first = 1; later < first; later ≥ 0.3)
24. the second adaptation is reachable only through relationship (cold headStart 0; after 4×150 s, ≥ 200 s — "the hold ends at 227")
25. the fifth is withheld outside the ninth world (ring 3 at t=30 → 0; ring 9 → 1)
26. today matches DailyEnergyService: a true permutation per cycle (102 unique; cycles reshuffle) — *"the design and the app must never name different energies"*
27. the practice day turns at 6am local
28. today resolves to a real Śakti of the right ring (detail "day N · position P · name")
29. the body altitude of every card lies inside the body (0 < alt < 1)
30. Ring 2's crossing is real: the presented and answering halves differ (fingerprint t=30 vs t=320 divergence > 0.3) — *"THE KEY PAIRING — body and mind at one point"*

**6 · felt** (7)
31. no room label measures the walker — *"the instrument may know everything and must display none of it"*
32. no card phrase or quality measures the walker
33. every label speaks plainly — no project jargon leaks into the room (`P\d|avarana|tattva|mechanism|archetype|grammar|update(|undefined|NaN|[object`)
34. no label is empty, truncated or a placeholder (≥ 8 chars, no leading/trailing space or dangling "·", no undefined/null)
35. the nine worlds are a continuous climb — no gaps between bands — *"no cuts, only travel"*
36. each world's weather is named, and no two alike (≥ 12 chars, 9 unique)
37. every world names its gem, dhātu, clock and body-region

**7 · coherence** (9) — fetches the Axis, the Rite of Entering, Rooms in 3D, Nine Worlds, the thread, the method, homes-sound.js
38. the Axis is the instrument — it holds every layer (climb, the rite, sound, memory, today, chambers, cards)
39. no module reference is stale (no module referenced at two `?v=` versions) — *"module scripts cache — a split version silently runs old code"*
40. no debug hook of mine survives in any deliverable (`window.__probe|ax|dbg|px|grid|enter|adv|p|w|t|f|err`) — scoped to own hooks because matching host-injected editor globals was a false positive
41. the descent survives the fold into the Axis (if the Rite has a descent, the Axis must — "go deeper") — *"a feature present in an earlier piece must not vanish in the fold"*
42. reduced motion is honoured, not ignored (`prefers-reduced-motion` and a `reduced ?` branch) — *"the method requires a longer path, never a disabled one"*
43. the after-effect still lingers on the whole instrument — *"her siddhi outlasts the room"*
44. every claim of a named file in the thread resolves (soft — reports unfetched, passes)
45. the method file states its rules (≥ 2000 chars; mentions mechanism, first attempt, no cuts, elapsed, measure it out loud) and the thread records decisions (> 3000 chars)
46. nothing in the walker-facing copy measures her (all literal textContent strings in the Axis)

**8 · brief** (14)
47. the Śakti cards are treated as the base where the app has drifted — passes iff the Axis keeps `appName`; detail reports "N of 102 names differ…" — *"reported, never silently absorbed"*
48. the ring hues are the repo's own Atmosphere tokens {35, 43, 341, 353, 18, 194, 322, 2, 46} — *"the gem gives light quality, not hue"*
49. every world names its presiding Form, Yoginī class, state and verb
50. secrecy deepens inward — the veil rises monotonically, 0 → 1 — *"Prakaṭa (manifest) → Parāparāraharasya"*
51. the mental state slows the world as it deepens (ring 1 tempo 1, ring 9 < 0.4) — *"Jāgrat runs at speed; Pure being barely moves"* [checks endpoints only]
52. the doors are walkable from inside — the homes are one building (walkTo/neighbourOf) — *"khaḍgamālā order is a circle"*
53. ring 2's clusters and ring 1's families share corridors
54. the library is kept and folded, not deleted
55. her Well letter rests in the room as a folded object
56. the Well letter is never invented (letterFor reads localStorage; no "Thank you|lorem|placeholder")
57. each ring keeps its own sound technique (TECHNIQUE, shepard, triad) — *"ground drone · home breath · breathy voice · stepped notes · triad collapse · Shepard tone"*
58. the design tokens are the repo's (#0D0508, #C9963F, #F2E8D9, Cormorant Garamond)
59. the physics vocabulary reads the cards, not a dozen words (≥ 40 patterns and ≥ 40 distinct `case`s) — *"an audit found 78 of 102 sharing one default breath"*
60. the P10 gate: Laghimā and Garimā are unmistakable (different near words; geometry divergence ≥ 0.5; mean light differs ≥ 12) — *"the brief's sample-before-batch gate: one must lift, the other press"*

**9 · iconography** (6)
61. every one of the 102 is given her attribute — *"her held object is a design instruction, not a note"*
62. her attribute actually mounts in her room (a node named `attribute-*`)
63. the attributes are many shapes, not one repeated (≥ 25 named, ≥ 15 distinct built forms)
64. her attribute moves — it performs rather than sits (snapshot of position, rotation, scale, opacity, emissive at t = 8, 12, 15, 19, 24, 31, 40 must differ) — *"a noose draws; a cup fills; a sceptre barely moves but does move"*
65. the attribute is tinted by her card's colour word where it gives one (≥ 10 tints)
66. past the second adaptation the attribute stops being an object (scale at t=320 > 2× scale at t=20) — *"it grows into the room rather than being put down"*

### Handoff §8 — tests to port to Swift (the ones that found real defects)
- every Śakti resolves to a card **of her own ring** (caught the Kāmeśvarī collision)
- no two sisters in a ring speak the same words (caught eight identical Anaṅga labels)
- every room reverses at the second adaptation
- adjacent sisters diverge > 10% geometrically
- no room renders black or blown out at **either** adaptation (caught five dark rooms and one pure-white one)
- the head start is not gameable by re-entering
- nothing in walker-facing copy measures her
- **no feature present in an earlier build has vanished** (caught the Axis silently dropping the descent)
- "the harness itself was wrong twice — once matching the host's injected globals instead of its own hooks, once calling fifteen living attributes inert because it sampled position but not rotation. **Verify the verifier.**"

### Recorded GPU-read results (thread)
- Rings 3–9 luminance ranges: Anaṅga 38–84 · cosmic 47–129 · giving 31–182 · revealing 27–209 · sounding 78–198 · sourcing 73–204 · bindu 43–157.
- Rooms in 3D (eight): Aṇimā 128–240 warm topaz · Mahimā 46→255 depth gradient · Vaśitva 13→197 pool falloff · Mahātripurasundarī 24→221 radial · Laghimā 73→255 vertical · Garimā 13→204 with a real shadow band · Sarva-Yoni 82→255 backlit membrane · Trikhaṇḍā 42→255, asymmetry 86|81 → 81|81 at convergence.
- Second-adaptation geometry: Aṇimā's beyond −18 → −9.4 · Laghimā's walls 1.4 → 11.3 · Mahimā's rear thresholds 0.06 → 0.49 · Sarva-Yoni nested vessel 0 → 0.12 · bindu −8.4 → −2.9.
- P10: Laghimā vs Garimā differ by 100% of geometry and 116 of luminance.
- Thread states "Current state: 46 checks, 0 failing" (an earlier count) while the README/handoff say 66 checks; the file contains 66.

## B3 · Conflicts and defects found while reading (for the builder to rule on — not resolved here)
1. **Four authored rooms unreachable in the Axis** (name keys vs card names) — Aṇimā, Vaśitva, Sarva-Yoni, Sarva-Trikhaṇḍā. Key by position.
2. **Memory keyed by name** — repeated names (19/53, 20/54, 21/55, 22/60, 23/62) share dwell, visits, core-light and head start. Key by position.
3. **`appName` mis-paired** — index alignment against an app list in a different order (Ring 1 especially).
4. **The fifth is struck on beat 2 of every rite** (carrier × 1.5) despite "the fifth is withheld".
5. **After-effect is named** ("her siddhi is still on the instrument") and lasts 24 s, vs brief "Never named… decaying over minutes" and handoff §4.8 "never named". Per-Siddhi quality (lighter/heavier/sharper/wider) not built — only exposure +0.12.
6. **Portrait "surfaces line by line at the pace of stillness"** (brief, Dwelling) — not built.
7. **Personal Connection marginalia** — handoff says no text exists; `all-shaktis-data.js` has nine `personalConnection` paragraphs. Needs Ashrey's ruling on whether these are his voice.
8. **Descent station 2** promises "hers alight" but lights no bar (unused `mine`).
9. **Attribute opacity compounding** — ×(1 − .55b) applied every frame.
10. **Gem diffusion** is specified but read by no room in the prototype; handoff keys it by element though elements repeat across rings.
11. **Tempo not monotone** (R3 0.62 < R4 0.72) though described "1.00 → 0.28"; the harness checks only endpoints.
12. **Carrier interval wraps mod 12** — not monotone in alphabet order past the 12th letter; Paṃ = root. 60 of 102 sound at the bare root.
13. **Bīja as visual tuning** ("pulse rate, particle rhythm, light-breath all locked to her syllable") not built; **tattva as light/material modifier** not built.
14. **Weapons (95–98)** handled as Vāsinīs — sounding archetype with no bīja, mode numbers n = 2 + (pos mod 8) → 95: 9, 96: 2, 97: 3, 98: 4; the brief's register "Weapons strike" is not expressed except through the attribute.
15. **Concept Board / Rooms-in-3D reduced-motion** = animation off / clock frozen at 62 s — contradicts "longer and quantized, never disabled". The Axis honours it (slower eases, 3.4 s beats) but does not quantize.
16. **"Three rooms · one seal, only in stillness"** — Trikhaṇḍā's label promises stillness, the mechanism converges by elapsed time (correct per Invariant 1); words and mechanism disagree.
17. Counts drift across documents: authored mechanisms "seven"/"eight"/"nine"; checks "46"/"66"; registers "six"/"seven"/"nine" (the V3 page header still says six and its totals panel prints 6).
18. App vs brief ring metadata differ (mental state 5–9, chakra 7–9, ring 8 presiding form, ring 8 Kriyā/Jñāna shorts swapped in the app).
19. World clocks are symbolic fast cycles, not "a real clock the practitioner's device drives".
20. **No minimum dwell per beat:** the rite never auto-advances, and "touch to go on" only appears once the beat's animation completes (bp ≥ 0.99) — but a touch before that still advances, so an eager walker can cut a beat short. Brief: "a few seconds, never skipped, never lingered on".

---

# C · Coverage proof

Every file below was opened with the Read tool and read from line 1 to its last line (no offset/limit paging was needed — no file exceeded the reader's page, and none was minified: the longest line in any assigned file is 726 bytes (The Nine Worlds thumbnail SVG), so no pretty-printed scratch copy was required). "Total lines" = logical lines (`splitlines`) of the file on disk; "lines read" = the last line number the Read tool returned for that file.

| file | total lines | lines read | notes |
|---|---|---|---|
| The Homes - The Axis.html | 842 | 842 | the instrument; handoff copy byte-identical (cmp) |
| handoff/The Homes - The Axis.html | 842 | — | identical to above, not re-read |
| The Homes - Rooms in 3D.html | 213 | 213 | superseded study (8 rooms, switcher rail) |
| The Homes - The Nine Worlds.html | 226 | 226 | superseded study (worlds empty) |
| The Homes - Verification V3.html | 648 | 648 | 66 checks, 9 registers; handoff copy identical |
| The Homes - Concept Board.html | 508 | 508 | nine SVG frames + logic panel |
| The Homes - Concept Board V3 (SVG).html | 508 | — | byte-identical to Concept Board.html (cmp) |
| Claude Code Handoff - The Homes.md | 411 | 411 | architecture; handoff copy identical |
| The Homes - the thread.md | 407 | 407 | decisions record; handoff copy identical |
| handoff/READ ME FIRST.md | 68 | 68 | only in handoff/ |
| handoff/Bindu Mandala - the method.md | 172 | 172 | identical to top-level copy (cmp) |
| handoff/source/homes-design-package.md | 132 | 132 | the original brief |
| handoff/source/homes-shakti-cards-rings-1-2.md | 367 | 367 | 44 source cards |
| handoff/source/homes-shakti-cards-rings-3-9.md | 511 | 511 | 58 source cards |
| homes-3d-core.js | 72 | 72 | handoff copy identical |
| homes-3d-rooms.js | 291 | 291 | top level only |
| homes-3d-rooms-2.js | 511 | 511 | top level only |
| homes-attribute.js | 587 | 587 | handoff copy identical |
| homes-cards.js | 266 | 266 | handoff copy identical |
| homes-chambers.js | 769 | 769 | handoff copy identical |
| homes-descent.js | 176 | 176 | handoff copy identical |
| homes-grammar.js | 831 | 831 | handoff copy identical |
| homes-memory.js | 77 | 77 | handoff copy identical |
| homes-sound.js | 218 | 218 | handoff copy identical |
| homes-today.js | 87 | 87 | handoff copy identical |
| homes-verify.js | 113 | 113 | handoff copy identical |
| homes-worlds.js | 563 | 563 | handoff copy identical |
| all-shaktis-data.js | 332 | 332 | handoff copy identical |
| **Total distinct content read** | **9,398** | **9,398** | 26 distinct files; 18 duplicates (17 handoff copies + Concept Board V3) verified byte-identical by `cmp` instead of re-read |

`find /home/claude/design-upload -name 'homes-3d*'` returned exactly: `extracted/homes-3d-core.js`, `extracted/handoff/homes-3d-core.js`, `extracted/homes-3d-rooms.js`, `extracted/homes-3d-rooms-2.js` — all covered.
Images: none in the assignment (the only image-like content is the inline SVG `__bundler_thumbnail` templates, described under each file).
Verification by execution (not only reading): the per-Śakti table (H-TABLE), the 61-name drift count, the four unreachable authored rooms, the 52 attribute keys / 26 forms, the physics distribution and the carrier intervals were computed by running the package's own `homes-cards.js`, `homes-sound.js`, `homes-today.js` and the PHYSICS/KIN tables extracted verbatim from `homes-grammar.js` / `homes-attribute.js` under Node 22 in the scratchpad. Today's presiding position for 2026-10-12 (practice day 2477, container clock) computed as **82 — Sarvādhārasvarūpā**.

---

# D · Most important things a builder must not miss

1. **Nothing is built until §1 is ruled on.** 61 of 102 names differ between the cards (the base) and the shipped app; Ring 2 is empty in the bundled data; the app has no Garimā. Design recommends *position is the key, names are labels* now, re-seed from the base later.
2. **Position is identity — everywhere.** Look up cards, authored mechanisms, memory, letters and today by `khadgamalaPosition` (1–102), never by name. The prototype itself breaks this in two places: four authored rooms (Aṇimā 1, Vaśitva 6, Sarva-Yoni 27, Sarva-Trikhaṇḍā 28) never load because their name keys don't match, and memory is keyed by name so repeated names share dwell. Port the authored map by position: 1 contract · 2 endless · 3 release · 4 press · 6 known · 27 membrane · 28 triple · 102 dissolve.
3. **Rooms are an engine, not 102 screens.** Resolution: her authored mechanism → her ring's archetype tuned by her card (physics from tattva+quality via 50 ordered regexes; altitude from location; phase from position; words from quality) → the gem-lit seat floor.
4. **The adaptation clock is the piece:** first adaptation `smooth(t/62)`, hold to 227 s, second adaptation `smooth((t−227)/120)`; labels flip at 0.45. Time is real elapsed seconds — never device motion, proximity or stillness.
5. **Every room reverses its premise at the second adaptation** — never "more of the same". The reversal words are fixed per archetype/room (see H-MECH, H-GRAMMAR, H-TABLE).
6. **The second adaptation is reachable only through relationship:** head start = min(dwell × 0.55, 221 s), zero under 12 s of dwell; compression of the rite = max(0.36, 0.68^min(visits,4)); dwell capped at 4000 s. Not gameable by re-entering.
7. **No cuts, only travel.** The rite *is* the flight in (stations 0 / .30 / .62 / .88 / 1; fog density × (1 + 1.6·swallow); room scales 0.02 → 1); doors walk to the neighbour from where you stand; the descent continues inward; no transition screens, menus or fades to black. Ring 1 doors stay within the family, Ring 2 within the cluster.
8. **The rite is self-paced by touch, three beats, never on a timer, never skipped, compressed on return:** phrase → Devanāgarī written in three strokes (mask sweep, 72% per stroke) → roots part (to 30 px) and rejoin with her quality beneath. Beat duration 2.4 s (3.4 s reduced) × compression.
9. **Never measure out loud.** No counters, percentages, streaks, visit counts, progress. Return is felt: a core light on her point, a slow pulse, up to 7 floor traces, "you have stood here before" once for 14 s, a rail mark without a number. "forget me" clears it.
10. **Light is the app's Atmosphere, verbatim:** ring hues 35/43/341/353/18/194/322/2/46 with S/L from RING_HSL, ±7° jitter from `(pos × 2654435761) mod 1000`, Ring 2 seeded from its five cluster hues; the gem contributes only *behaviour* (diffusion 0.20…0.95 — pearl sourceless, cat's eye one hard band). Key diffusion by ring, not element.
11. **The nine worlds are weather with exact recipes** (W1–W9): fog colour/density per ring × (1 + veil × 0.55), veil 0 → 1, world tempo 1 → 0.28 applied to the world clock only, never to her adaptation clock.
12. **Ring 2 is "the crossing":** presenting and answering halves run the same physics in opposite phase and converge only at the second adaptation; pos 44 Śarīra/Manas is THE KEY PAIRING ("body and mind were one point"). Not a data error.
13. **Her attribute is the room's one actor** (52 named → 26 forms, tinted by her card's colour word where given), held at her altitude 4.6 in front; past the second adaptation it grows (×0.9 → 3.5) toward you and thins — implement the thinning as one factor, not a per-frame multiply.
14. **Sound derives from her syllable, never invented:** root per ring (55 … 123.47 Hz), carrier = root × just ratio of her varṇamālā index × 2; no syllable → the root. Ring techniques: drone · breath LFO 0.14 Hz · breathy · stepped (5.2 s / 3.4 s) · sourceless overtones · triad collapse every 14 s · Shepard. Filter opens 220 → 1720 Hz with her adaptation. **Rule needed:** the fifth is "withheld" yet beat 2's strike sounds carrier × 1.5.
15. **Never invent canon:** the Well letter is read from storage only (`homes.well.v1` keyed by position) and shown as a folded object only if it exists; missing fields degrade visibly; carriers fall silent to the root.
16. **Today opens the instrument on her** using the exact DailyEnergyService arithmetic (epoch 2020-01-01 UTC, 6 am local boundary, SplitMix64 BigInt, downward Fisher–Yates, cycle seed ^ 0xD1B54A32D192ED03); her crown light breathes; "she presides today" / "hers is the day"; the day turns at 6 am without reload. Do not "improve" it. Keep it distinct from DailySummons, DailyRiteView and the Rite of Entering.
17. **Reduced motion is longer and quantized, never disabled.** The two older studies (Concept Board, Rooms in 3D) disable/freeze — do not copy them.
18. **Contrast floor:** every room legible at both adaptations (harness: max ≥ 28 near / ≥ 24 deep, min ≤ 232, spread ≥ 10); clamp additive point size (Laghimā's field 1–9 px and kept ≥ 4 units from the eye).
19. **Extend, don't replace:** Atmosphere, Element, HSL/tokens/fonts, DailyEnergyService, DailySummons, KhadgamalaMap, RingAudioService, ShaktiDetailView (becomes the folded library — its sections kept). Five new files, all additive. Build in Design's order; Ring 9 last, by hand.
20. **Port the harness as Swift tests** — at minimum: own-ring card resolution, no two sisters' words alike, every room reverses, adjacent sisters diverge > 10%, never black/blown at either adaptation, head start not gameable, no walker-facing measurement, no feature lost from an earlier build. And verify the verifier.
21. **Gaps Design left open that the brief asked for:** the portrait surfacing "line by line at the pace of stillness"; per-Siddhi after-effect (lighter/heavier/sharper/wider, decaying over minutes, never named — the prototype names it and lasts 24 s); bīja-locked visual rhythm; tattva as a light/material modifier; Weapons that "strike"; descent station 2 must light *her* altitude bar; world clocks are symbolic, not device time.
22. **Personal Connection text exists** in `all-shaktis-data.js` (nine paragraphs) although the handoff says it doesn't — ask Ashrey whether it is his voice before any marginalia is authored or shown.
23. **Generate ShaktiCard JSON from `homes-cards.js` / the base, never hand-transcribe** — and decide whether to carry Function, Somatic and Iconography too (the brief makes them the room's mechanism and physics; the JS dropped them).
24. **Retire the superseded studies** (Rite of Entering, Rooms in 3D, Nine Worlds) as references only — but mine Rooms in 3D for the richer techniques the Axis simplified (Trikhaṇḍā's three render targets composited per channel; Laghimā's unmoored seat; Garimā's thickening fog).

