# The Homes — Claude Code Handoff

*For review in Claude Chat before any implementation begins. Nothing here should
be built until the reconciliation in §1 is settled.*

---

## 0 · What this is

The design side of The Homes is complete: **102 of 102 rooms**, the nine ring-worlds
as one continuous climb, the rite folded into the travel, the corridor, the library,
her attribute, sound, return, and today. It runs as a working three.js instrument
(`The Homes - The Axis.html`) with a verification harness (66 checks, nine registers).

**This document is the implementation architecture, written to EXTEND the shipped app
rather than replace any of it.** Every mapping below names the real type it attaches to.

The design deliberately ported `Atmosphere.swift` verbatim rather than inventing its
own palette, so the port direction is one-way: the design already speaks the app's
colour language, including the ±7° per-Śakti jitter and Ring 2's five cluster hues.

**What Claude Chat should decide before Code starts:** §1 (blocking), then §7 (scope
and order). Everything else is mechanical.

---

## 1 · BLOCKING · The name reconciliation

**61 of 102 names differ between the Śakti cards and the shipped `ShaktiBootstrap` data.**

| Ring | Divergence |
|---|---|
| 1 | 15 of 28 absent from the app. **No Garimā at all** — `Sarvakāmāvalī` stands at her position. The Mudrā slots (19–28) hold Ring 4 Devī names: `Sarvāhladinī`, `Sarvasammohini`, `Sarvastambhinī`, `Sarvajṛmbhiṇī`, `Sarvarañjanī`, `Sarvonmādinī`. |
| 2 | **Empty.** `SHAKTIS_BY_RING[2]` has zero entries — the home ring, the richest data, is absent from the bundled roster. |
| 3 | 1 of 8 |
| 4 | 9 of 14 |
| 5 | 5 of 10 |
| 6 | 7 of 10 — e.g. card `Sarvaśakti` vs app `Sarvaśaktimayī`; card `Sarvaiśvaryapradāyinī` vs app `Sarvaaiśvaryapradā` |
| 7 | 7 of 12 |
| 8 | 1 of 3 |

The cards state they are the Airtable base. The design therefore treats **her khaḍgamālā
position as authoritative** and the name as display text, keeping the app's name alongside
where the two disagree (`appName`). That resolution works for design; it is **not** a
resolution for the app, because `Shakti` records are persisted and matched by name in places.

**Three options for Chat to choose between:**

1. **Base wins.** Re-seed `ShaktiBootstrap` from the cards; write a migration keyed on
   `khadgamalaPosition` so existing recognition entries survive the rename. Cleanest
   long-term, one migration to write carefully.
2. **App wins.** Treat the cards' names as scholarly variants and keep the shipped names.
   Requires deciding what to do about Garimā, who then does not exist — and she is the
   brief's own paired example against Laghimā.
3. **Position is the key, names are labels.** Neither wins: `khadgamalaPosition` becomes
   the sole identity everywhere, names become presentation, and both are shown. Lowest
   risk, but leaves two names visible for 61 energies.

**Recommendation: option 3 now, option 1 later.** Position-as-identity is already how the
design resolves every lookup, is provably collision-free (Kāmeśvarī appears in both Ring 7
and Ring 8 and only position separates them), and needs no migration. The re-seed can then
happen calmly, once, when the canon question is settled in Chat.

---

## 2 · What already exists and must not be rebuilt

| Shipped | Keep because |
|---|---|
| `Theme/Atmosphere.swift` | The design's light layer is a verbatim port of it. Extend, never replace. |
| `Theme/Element.swift` | `forRing` / `parse(tattva:)` already match the brief's element table. |
| `Theme/HSL.swift`, `Color+Tokens.swift`, `Fonts.swift` | The token family. |
| `Services/DailyEnergyService.swift` | Ported exactly into the design (`homes-today.js`). Verified: 102 unique per aligned cycle, reshuffles, 6am boundary. |
| `Services/DailySummons.swift` | The 6am notification. Untouched. |
| `Models/KhadgamalaMap.swift` | Ring spans verified against it: 1–28 · 29–44 · 45–52 · 53–66 · 67–76 · 77–86 · 87–98 · 99–101 · 102. |
| `Services/RingAudioService.swift` | Extend per ring (§5), do not replace. |
| `Views/Common/ShaktiDetailView.swift` | Becomes the **library** (§4.5), folded beneath the room. Its sections are kept. |
| `Views/Mandala/*`, `Views/Today/*`, `Views/Memory/*` | Out of scope for this handoff. |

---

## 3 · The new layer, in five files

Everything below is additive. No shipped file is deleted.

```
Theme/
  Gem.swift              // her light: Atmosphere + the gem's behaviour  (§4.1)
  RingWorld.swift        // the nine worlds' shared conditions           (§4.2)
Models/
  ShaktiCard.swift       // the 102 cards, as data                        (§4.0)
Rooms/
  RoomMechanism.swift    // the protocol every room implements            (§4.3)
  RoomGrammar.swift      // ring → archetype, card → tuning               (§4.3)
  Attribute.swift        // her held object, as the room's one actor      (§4.4)
Views/Rooms/
  HomeView.swift         // the rite, the dwelling, the doors, leaving    (§4.5–4.8)
  DescentView.swift      // going deeper, as travel                       (§4.6)
Services/
  HomeMemory.swift       // dwell, compression, the head start            (§4.9)
```

---

## 4 · Layer by layer

### 4.0 · The cards

`homes-cards.js` holds all 102 with: `pos`, `name`, `dev`, `quality`, `tattva`, `loc`,
`roots[]`, `phrase`, plus `SYLLABLE`, `CROSSED`, `ATTRIBUTE`, `ATTR_TINT`, `RING_START`,
`R1_FAMILY`, `R2_CLUSTER`.

Port as a `ShaktiCard` value type loaded from a bundled JSON generated from that file —
**not** hand-transcribed. Key by `pos`. Join to `Shakti` on `khadgamalaPosition`.

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

### 4.1 · Her light — `Gem.swift`

The design's `gemFor(ring:kp:)` is `Atmosphere.derive` plus one addition: the gem's
**behaviour**, which the app does not model yet.

```swift
extension Atmosphere {
    /// How her āvaraṇa's gem carries light — diffusion only. Hue, saturation and
    /// lightness stay exactly as `derive` produces them.
    var diffusion: Double {
        switch element { /* per ring, see table */ }
    }
}
```

Values, from the brief's gem column: ring 1 `0.20` topaz · 2 `0.30` sapphire ·
3 `0.45` coral · 4 `0.15` diamond · 5 `0.25` emerald · 6 `0.55` ruby ·
**7 `0.95` pearl (sourceless — no directional light at all)** · 8 `0.10` cat's eye
(one hard travelling band) · 9 `0.70` all gems.

Diffusion drives: shadow softness, whether a room has a key light or only ambient,
and how far the glow falls. Ring 7 having no directional light is not a shortcut —
"milky, diffuse, sourceless" is the instruction.

### 4.2 · The nine worlds — `RingWorld.swift`

Per-ring constants, all from the brief, none invented:

```swift
struct RingWorld {
    let n: Int
    let name, form, gem, dhatu, clock, region, bija, verb, yogini, state: String
    let veil: Double     // Yoginī class → how veiled  (0.00 → 1.00, monotone)
    let tempo: Double    // mental state → world tempo (1.00 → 0.28)
    let element: Element // == Element.forRing(n)
}
```

`veil` scales fog density (`× (1 + veil * 0.55)`); Prakaṭa is unveiled, Parāparāraharasya
is fully veiled. `tempo` scales **the world's own animation clock only** — never her
adaptation clock (§6).

### 4.3 · The mechanism — `RoomMechanism.swift` + `RoomGrammar.swift`

The single most important architectural point: **rooms are not 102 authored screens.**

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

Resolution order, exactly as `buildChamber` does it:

1. **Her own authored mechanism**, if she has one. Nine so far: Aṇimā (contract),
   Laghimā (release), Garimā (press), Mahimā (endless), Vaśitā (known), Sarva-Yoni
   (membrane), Sarva-Trikhaṇḍā (triple), Mahātripurasundarī (dissolve).
2. **Her ring's archetype**, tuned by her card. Ring 1 splits three ways by family —
   Siddhis *lend* a capacity, Mātṛkās hold a *row of the alphabet*, Mudrās are *a seal
   large enough to stand inside*. Ring 2 is **the crossing** (§4.3.1). Rings 3–8:
   bodiless · cosmic · giving · revealing · sounding · sourcing.
3. **Her seat's interior**, gem-lit — the floor nobody currently needs.

Her card tunes the archetype through four channels:

| Channel | From | Effect |
|---|---|---|
| physics | `tattva` + `quality` | one of **50** motions — 50 regex patterns over the real tattva vocabulary. Aṇu shrinks, Mahat widens, Pṛthvī settles, Ākāśa opens, Pralaya dissolves, Bīja compresses. |
| altitude | `loc` | where the room's gravity sits, feet 0.94 → crown 0.10 |
| phase | `pos` | so no two neighbours move alike |
| words | `quality` | the room's own near label, so no two sisters read alike |

**Every room reverses its premise at the second adaptation.** Not more of the same — a
reversal. Aṇimā: *the point was a door all along.* Mahimā: *you were never inside
anything.* Vaśitā: *it has turned, and it rests on you.* Garimā: *the weight was holding
you all along.*

#### 4.3.1 · Ring 2 — the crossing

The home ring's cards pair a faculty with a **different** organ: Rūpa (form) with Śrotra
(the ear), Rasa with Tvak, Gandha with Cakṣus, and Śarīra with Manas — marked in the base
as *THE KEY PAIRING*. This is deliberate, not a data error.

Her room presents one sense and answers in the other: two halves running her physics in
**opposite phase**, converging only at the second adaptation.

### 4.4 · Her attribute — `Attribute.swift`

Her Iconography line becomes the room's one actor: a shape performing the single action it
exists to perform. Aniconic — a noose is a shape, not a figure.

26 forms; 52 named across the 102. `noose` draws the vast into the tiny · `cup` fills and
is drunk · `arrows` strike the five gates in turn · `mirror` returns your own light ·
`skullcup` receives what has ended · `plough` turns what is buried up · `vajra` strikes
once every nine seconds · `sceptre` barely moves · `seed` never opens, only densifies ·
`chain` falls open link by link · `ground` does not yield, only the load breathes.

Past the second adaptation the attribute **stops being an object** — it grows into the
room (0.9 → 3.16) and thins.

### 4.5 · The rite, and the library — `HomeView.swift`

**The rite is the distance.** Three beats, each carrying a stretch of travel toward her.
Beat 1 her phrase. Beat 2 her Devanāgarī written stroke by stroke. Beat 3 her roots
splitting and rejoining with her quality beneath. **Self-paced by touch — never a timer,
never skipped, compressed on return.**

The **library** is `ShaktiDetailView`'s existing sections, folded beneath the room and
reached by one control. Nothing from it is deleted.

Her **Well letter**, if one exists, rests in the room as a folded object. Read only —
**never fabricated**; the harness asserts this.

### 4.6 · Going deeper — `DescentView.swift`

Five stations, each ONE field of her card as motion, continuing inward from her room —
not a sheet of facts. Her tattva → her location → her etymology → her quality → her
phrase. Self-paced.

### 4.7 · The doors and the corridor

Khaḍgamālā order is a circle: two named doors per room. A door opens **sideways within
her neighbourhood first** — Ring 2 by cluster, Ring 1 by family — then around the circle.
Walking one releases her room and begins the crossing **from where you stand**, so the
rite runs again and there is no cut. The homes are one building.

### 4.8 · Leaving

Her Siddhi lingers on the whole app for minutes, decaying, **never named**.

### 4.9 · Return — `HomeMemory.swift`

**The head start comes from accumulated dwell, not visit count** — so it cannot be gamed
by entering and leaving. Consequence: the second adaptation, 227 seconds into a first
visit and therefore unreachable, becomes reachable only through relationship.

```swift
struct HomeMemory {
    func compression(_ pos: Int) -> Double  // 1.0 → 0.36, never 0
    func headStart(_ pos: Int) -> TimeInterval // from dwell; 0 under 12s
    func grantsFifth(_ pos: Int, ring: Int, t: TimeInterval) -> Double
}
```

Store alongside `RecognitionLogStore`. **Nothing is ever displayed:** no counters, no
percentages, no streaks. One line, once, on returning: *you have stood here before.*

---

## 5 · Sound — extend `RingAudioService`

The brief's existing techniques, kept and extended per ring:

| Ring | Technique |
|---|---|
| 1 | ground drone |
| 2 | home breath — an LFO on its own amplitude |
| 3, 6 | sustained breathy voice |
| 4, 5 | stepped notes (4 slower than 5) |
| 7 | **sourceless — no fundamental at all, only its overtones** |
| 8 | triad collapse |
| 9 | Shepard tone |

**Her carrier is derived from her syllable, never invented.** The varṇamālā is an ordered
series and that order is the canon: each bīja the cards name is located in it, and its
position becomes a just interval above her āvaraṇa's root, folded into one octave. The
pitch and register are ours; the interval is hers. Where no syllable is named, the carrier
is the root — silence about what is unknown.

**The fifth is withheld** — granted only in the ninth world, on a very long stay, or
through a long relationship.

---

## 6 · Invariants — do not violate these

1. **Time is elapsed.** Mechanisms run on real seconds. Never device motion, never
   proximity, never stillness. Stillness may govern *arrival* of a line, never its
   persistence (high-water mark, not a live reading).
2. **Never measure out loud.** No counters, percentages, progress, streaks or badges. The
   instrument may know everything about the walking and must display none of it.
3. **No cuts, only travel.** No transition screens, no fades to black, no menus where
   movement will do. Every switcher is a place the experience stops.
4. **Reduced motion is longer and quantized, never disabled.** The mechanism is perceptual
   adaptation; removing it removes the piece.
5. **Never invent canon.** No fabricated frequency, name, phrase or letter. Where a field
   is missing, degrade visibly to the shared floor — the gaps are information.
6. **Position is identity.** Names collide across rings (Kāmeśvarī is both a Ring 7 Vāsinī
   and the Ring 8 Icchā-śakti; Ring 4's Devīs repeat Ring 1's Mudrā names). Only
   `khadgamalaPosition` is unambiguous.
7. **Contrast floor.** Every room must be legible at both adaptations. Additive particles
   near the eye stack to white — clamp point size.

---

## 7 · Suggested order, for Chat to approve

| # | Step | Why first |
|---|---|---|
| 1 | Settle §1 | everything downstream encodes the answer |
| 2 | `ShaktiCard` + JSON + join on position | unblocks all 102 at once |
| 3 | `Gem` + `RingWorld` (diffusion, veil, tempo) | additive to `Atmosphere`, no view changes |
| 4 | `RoomMechanism` + the seat archetype only | one room type, proves the protocol |
| 5 | The rite, the library, leaving | replaces the top of `ShaktiDetailView`, keeps its body |
| 6 | The grammar: ring archetypes + the 50 motions | 102 rooms land together |
| 7 | Her attribute | deepens all 102 by one increment |
| 8 | The doors and the corridor | the building becomes walkable |
| 9 | Return + the descent | depth for the practitioner who stays |
| 10 | Sound per ring | last, because it is the easiest to get subtly wrong |

Ring 9 (Mahātripurasundarī) should be built last and by hand. *There was never anyone
here but Her.*

---

## 8 · The verification contract

`The Homes - Verification V3.html` runs **66 checks in nine registers** — canon, coverage,
distinction, legibility, promise, felt, coherence, brief, iconography. It exercises all
102 Śaktis and renders 204 rooms.

Port the registers as Swift tests. The ones that found real defects and would find them
again:

- every Śakti resolves to a card **of her own ring** (caught the Kāmeśvarī collision)
- no two sisters in a ring speak the same words (caught eight identical Anaṅga labels)
- every room reverses at the second adaptation
- adjacent sisters diverge > 10% geometrically
- no room renders black or blown out at **either** adaptation (caught five dark rooms and
  one pure-white one)
- the head start is not gameable by re-entering
- nothing in walker-facing copy measures her
- **no feature present in an earlier build has vanished** (caught the Axis silently
  dropping the descent)

Two cautions from experience: **the harness itself was wrong twice** — once matching the
host's injected globals instead of its own hooks, once calling fifteen living attributes
inert because it sampled position but not rotation. Verify the verifier.

---

## 9 · What is NOT in this handoff

The Mandala, Today, the Portrait, the Well's writing flow, the Descent film, Homecoming,
Settings, the Codex. Out of scope by design — this is the Homes only.

Also absent: **Ashrey's Personal Connection marginalia**, which the brief wants as
per-ring voice in his own words. No such text exists in any file given to Design. It needs
authoring in Chat before it can appear in a room.

---

## 10 · Manifest

| File | Role |
|---|---|
`homes-cards.js` | all 102 cards · attributes · syllables · clusters · families
`homes-chambers.js` | the nine authored mechanisms · the Atmosphere port · the seat floor
`homes-grammar.js` | ring archetypes · the 50 tattva motions · the crossing
`homes-attribute.js` | 26 attribute forms, each with its one action
`homes-worlds.js` | the nine worlds · ring character · veil · tempo
`homes-descent.js` | going deeper, as travel
`homes-memory.js` | dwell · compression · head start · the withheld fifth
`homes-today.js` | the `DailyEnergyService` port
`homes-sound.js` | per-ring techniques · the varṇamālā carrier
`homes-3d-core.js` | shared light, dust, geometry helpers
`homes-verify.js` | the harness
`The Homes - The Axis.html` | the working instrument
`The Homes - Verification V3.html` | the 66 checks
`The Homes - the thread.md` | every decision, and why
`Bindu Mandala - the method.md` | how the work is done here
`homes-design-package.md` | the original brief
`homes-shakti-cards-rings-1-2.md` · `...3-9.md` | the source cards
