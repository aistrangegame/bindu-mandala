# Bindu Mandala — Experience Architecture: Master Brief

*Compiled for Claude Design. Everything below is architecture and continuity — what has to be true, and why — not visual craft. Exact curves, exact renders, exact typography are Design's call.*

> **Errata (2026-09-07).** Read alongside Build Brief v2 (`BINDU-MANDALA-BUILD-BRIEF-V2.md`, this folder), which governs wherever the two differ. Four corrections established by the Sept 7 recon: **§9**'s "three rare moments" is superseded by the proximity/focus rule; **§5**'s continuous drone is superseded by the Homes' per-Śakti carrier (Brief v2 Phase 2.3); **§7** layer 1's hand-drawn postural forms are superseded by Law 4 (aniconic — forms are shapes performing actions, never figures); the companion doc `descent-experience-architecture.md` named in **§2** was never delivered. The full list of corrections is in `BUILD-BRIEF-V2-ERRATA.md`. The body below is otherwise as written in August, with one addition in §10 (entering-ceremony compression).

---

## 0. How to read this

Six pieces, in the order a practitioner would actually move through them: the nine-layer map → falling between layers → dwelling inside one → activating a single Śakti → the sound underneath all of it → the moment of being felt. Then one section on how they're the same system wearing six faces, so nothing here gets built as six unrelated features.

---

## 1. The nine-layer signature table

Pulled directly from the populated Avaraṇa rows in Airtable — not invented. Reading the `Subtle Body Chakra` field down all nine rings in order gives the seven traditional chakras plus two source-registers, in exact sequence.

| Ring | Phase | Shape | Chakra | Element | Verb (her Mudrā) | Body anchor | Mental state |
|---|---|---|---|---|---|---|---|
| 1 Trailokyamohana | Śṛṣṭi | Bhūpura | Mūlādhāra | earth | AGITATE | Feet | Jāgrat (waking) |
| 2 Sarvāśāparipūraka | Śṛṣṭi | Petal (16) | Svādhiṣṭhāna | per-Śakti tattva | LIQUEFY | Pelvis | Svapna (dreaming) |
| 3 Sarvasaṅkṣobhaṇa | Śṛṣṭi | Petal (8) | Maṇipūra | air | DRAW | Navel | Suṣupti (deep sleep) |
| 4 Sarvasaubhāgyadāyaka | Sthiti | Triangle (14) | Anāhata | water | OPEN | Heart | Turīya begins |
| 5 Sarvārthasādhaka | Sthiti | Triangle (10) | Viśuddha | fire | VOICE | Throat | Turīya deepening |
| 6 Sarvarakṣākara | Sthiti | Triangle (10) | Ājñā | ether | STILL | Forehead | Turīyātīta begins |
| 7 Sarvarogahara | Saṃhāra | Triangle (8) | Sahasrāra | air | WITNESS | Crown | Pure witness |
| 8 Sarvasiddhiprada | Saṃhāra | Triangle (1) | Bindu-Visarga | fire | SEED | Above crown | Source-consciousness |
| 9 Sarvānandamaya | Saṃhāra | Bindu | Beyond all chakras | light | ARRIVE | Totality | Pure being |

Ring 2 has no ring-level element default by design — it's the fully-authored home ring, so each of the 16 Karṣiṇīs carries her own tattva. Every other ring uses the ring-level element already encoded in the real engine (`LR_RING_ELEMENTS`).

This table is the shared vocabulary every section below draws its per-ring variation from. Nothing below invents new per-ring data — it's all reuse of this.

---

## 2. The descent — falling between layers

Full mechanics in the companion doc (`descent-experience-architecture.md`); summary of what must hold:

**Four constants that never reset across all nine crossings:** the Bindu anchor (a fixed point of light, present faintly from ring 1, everything else moves relative to it); the pulse (one continuous rhythm, tempo shifts per Mental State, never silent); sound as glissando (a continuously sliding fundamental, chimes are accents on top of it, not eight separate notes); the depth-trail (rings already passed recede but stay faintly present, never vanish).

**What makes a crossing read as passage, not a swap:** three depth layers moving at different speeds (foreground fastest, midground medium, background depth-trail slowest); geometry that swells past the frame rather than fading in at fixed size; continuous holdable velocity with per-ring easing, not discrete taps; compounding scale using the real camera tiers already in `MandalaCamera` (Tier 0 whole instrument → Tier 1 nine enclosures → Tier 2 seat).

---

## 3. The ring interior — inhabiting a perspective

This is the piece the descent mechanics don't cover: what it's like to actually *be* inside a ring, connected to all the energies there, before choosing one Śakti. Right now the app has no such state — you fall into a ring and land straight on individually-tappable seats. There's no moment of the ring as a whole.

**The arrival beat.** When the camera settles at Tier 1 inside a ring — before any seat has focus — give it one unhurried moment where the ring's Presiding Form is named once, softly (Tripura, Tripureśī, Tripurasundarī, Tripuravāsinī, Tripuraśrī, Tripuramālinī, Tripurasiddhā, Tripurāmbā, Mahātripurasundarī — real data, one per ring). Not a label that stays — a single breath of naming, then it recedes.

**The collective gesture.** Alongside the individual per-Śakti activation cycle (section 4), each ring gets one gesture that belongs to no single seat — a way to "connect with all the energies at that layer" as the original brief asked for. Concretely: holding anywhere inside the ring that isn't a specific seat should produce a single collective pulse — all Śaktis in that ring breathe together once. This is literally the ring's Mudrā verb performed at ring scale rather than seat scale: ring 2's collective gesture is a slow shimmer-ripple running through all 16 seats at once (LIQUEFY, together); ring 5's is a soft chord made of all ten bīja tones overlapping quietly (VOICE, together). One gesture, ring-wide, never tied to any single Śakti's data.

**Legibility gated by Yoginī class.** The Yoginī field already grades secrecy across the nine rings — Prakaṭa (Manifest) at ring 1 through Parāparāraharasya (Supreme-Most-Secret) at ring 9. Use that real gradient as the actual difficulty curve for how visible the collective gesture is: ring 1's ring-pulse is obvious and immediate; by ring 7–9 it's barely perceptible, something you only notice if you're already still. This makes the felt "secrecy" of deeper rings a property of interaction legibility, not just color and motion — and it costs no new data, since the Yoginī class is already populated on every Avaraṇa row.

---

## 4. The activation cycle — 102 rituals from six families

The piece flagged from the start as the exciting part, now actually built out. The goal was never 102 bespoke inventions — it's six real gesture families (reusing the element taxonomy already built for Today) with per-Śakti jitter doing the differentiation, the same way `RiteComposition` already varies flip/spin/scale/name-size within one archetype without needing 102 hand-authored layouts.

**The arc — four beats, roughly 2 to 3 minutes:**

1. **Knowledge (≈0:00–0:30).** Her nature revealed — an unhurried, ritualized version of what Today already composes by element. Not new content, a slower register of existing content.
2. **Will (≈0:30–1:15).** The practitioner's deliberate engagement gesture. One gesture family per element, six total, not 102:
   - *Fire* — a held pulse: press and hold, haptic intensity rising, like stoking.
   - *Water* — a slow pour: a drag gesture that must stay unhurried; rushing it doesn't register. Teaches patience through the mechanic itself, not an instruction.
   - *Air* — breath-timed: a paced inhale/exhale visual guide, no touch at all — pure attention.
   - *Earth* — press and still: the anti-gesture. Must hold completely motionless for the duration.
   - *Ether* — an absence gesture: the screen dims and simply waits for non-interaction, extending the existing Silence screen's logic down to the level of a single Śakti.
   - *Light* — one precise tap at exactly the right instant. Rewards timing, not duration.
3. **Action (≈1:15–2:00).** The gesture resolves into an embodied response. This is where per-kp jitter — duration, intensity, sigil spin, exactly the existing `RiteComposition.derive` mechanism — makes each of the, say, fourteen fire-Śaktis feel individually hers despite sharing one gesture family.
4. **Reciprocal response (≈2:00–2:30) + close (final ~15–20s).** Straight from C-1337: full engagement makes the energy play back; resistance makes it withdraw. Concretely — if the water-gesture was rushed, she doesn't fully liquefy, and the invitation is simply to try again unhurried, never a failure state, never scored. If the fire-hold ran long and steady, her flare is fuller. The response is felt, never numbered. The cycle closes the way C-1330 and C-1281 both point toward — something small carried outward, not a checkmark: an optional single line in The Well, or simply a soft dissolve back into the Mandala with her point now lit in the Portrait. No badge. No "completed."

Six families × per-kp jitter × the existing composition engine = 102 rituals that feel individually placed without being individually invented.

---

## 5. The continuous sonic environment

Currently unbuilt by design (`FIDELITY.md` names the ring-drone as an explicit stretch, not forgotten). This section is what fills that gap, and it's the sound-side twin of the descent's continuity spine — nothing ever hard-cuts, in sound any more than in camera motion.

- A quiet base drone runs continuously while inside the Mandala — not only during a fall. It's pitched to the current ring's fundamental (`LR_RING_FREQ`), so simply floating inside a ring, doing nothing, still has a felt tonal identity.
- The drone bends continuously with camera position even *within* a ring, not just between rings — sound tracking continuous state exactly the way the parallax fix in section 2 tracks continuous camera state, rather than firing discrete stingers on discrete triggers.
- Element sets timbre, not just pitch: earth is a low sustained pad with grit; water is a slow undulating filter sweep; air is an airy noise-bed with slow panning; fire carries a faint flickering high-partial shimmer over the drone; ether is near-silence with an occasional single harmonic ping; light is a pure sine, the simplest of all.
- The existing per-Śakti bīja tone becomes the melodic layer riding on top of this ambient bed once a seat is focused, rather than sounding in isolation against silence.
- The activation cycle's reciprocal-response beat (section 4) is the one place full harmonic richness is allowed. Everywhere else stays minimal, so the peak actually reads as a peak.
- All of it gates behind the existing `soundOn` toggle already wired in `LivingMandalaView` — additive, not a rebuild.

---

## 6. The recognition ceremony, deepened

The two locked lines — "she was felt here" / "and she felt you back" — don't change. They're non-negotiable canon and should stay exactly as they are. What changes is the felt physics around them, using C-1337's actual mechanism: full engagement makes the energy play back, resistance makes it withdraw.

- The ripple rings already in the ceremony currently play identically every time. Let their shape respond, privately, to how the practitioner approached the moment — how long they lingered before tapping "I feel her." A rushed tap produces a smaller, quicker ripple; a patient approach produces a fuller, slower bloom. This is never surfaced as a score or shown as feedback — it's a felt quality difference only, fully consistent with the app's no-streaks-no-scores canon. The physics is private; only the words are constant.
- "And she felt you back" pairs with the reciprocal sonic idea from section 5 — her bīja tone answering, same pitch as always, but with richer harmonic content than it carried on the Detail screen. As if it grew fuller for having been felt.

---

## 6a. What's actually in the current build — read directly from source

Before the sections below: two findings from reading `RiteSigil.swift`, `RingGlyph.swift`, `ShaktiDetailView.swift`, and `AirtableService.swift` directly, because they change what "improve the Rite / improve the Mandala" actually means.

**Six shapes currently carry 102 energies.** `RiteSigil` draws one backdrop per *ring* (square, 16-lotus, 8-lotus, three triangle variants, mūla-trikoṇa, bindu) — every Śakti sharing a ring shares the identical form, differing only by hue rotation and spin direction. `RingGlyph`, used in the Mandala itself, is coarser still: rings 4 through 7 all render the same "crossed triangles" icon. There is currently no per-Śakti iconography anywhere in the rendering layer.

**The data for real per-Śakti iconography already exists and is unused.** The `Iconography` field (`fldXJEBCQxLdHWGuP`) is populated for all 102 with specific, individually-written visual descriptions — color, posture, held attribute, a somatic line. It's read into the model and displayed as a paragraph of plain text behind a collapsed "go deeper" fold on the Detail screen. It has never driven a shape, a color treatment, or a motion. This is the highest-leverage gap in the whole app: real content, fully written, doing nothing.

---

## 7. The iconography grammar — 102 identities from data already written

Not 102 bespoke illustrations (unrealistic production cost) and not the current six shared ring-shapes (what exists now) — a modular grammar assembled from each Śakti's own already-written `Iconography` text.

**Four independently-combinable layers:**

1. **Silhouette archetype** — 6 to 8 hand-drawn base postural forms, built once each, not per-Śakti: enthroned/still, open-armed/expansive, dissolving/veiled, rooted/pressing, crowned/erect, dancing/whirling. Her existing prose already uses consistent postural language ("seated," "arms open," "half-dissolved," "one palm pressing," "crowned and erect") — a tagging pass assigns each of the 102 to the archetype her own text implies.
2. **Attribute glyph** — a small secondary mark for her held object, drawn from real traditional iconographic vocabulary already present in her description: noose (pāśa), goad (aṅkuśa), sceptre, mirror, rosary, lotus, blade. Perhaps 15–20 of these exist total, reused across the 102 who share an attribute.
3. **Color treatment beyond hue** — her Atmosphere hue stays as-is; layered on top is a surface quality keyed to the actual color words already in her text: luminous/pale/translucent, golden/radiant, dark/deep-rooted, silver-bright. Two Śaktis sharing a hue read differently once this layer is applied.
4. **Motion quality** — extends the existing per-kp jitter (`RiteComposition`) with a quality her own prose implies: "weightless... garments lifting though there is no wind" drifts; "immovable... palm pressing the earth" barely moves at all; "elements leaning toward her" pulls nearby particles subtly inward.

Production cost: 6–8 silhouettes, ~15–20 attribute glyphs, and one content-tagging pass — not 102 illustrations. Every energy still gets a combination that's actually hers, drawn from what's already canon.

**This is also the direct fix for the Rite.** `RiteSigil`'s backdrop has the identical generic-per-ring problem `RingGlyph` has in the Mandala — same grammar, same fix, one layer up.

---

## 8. Bindu, living on every screen

Currently Bindu exists only in `LalitaSourceView` — the destination at the end of a full descent. Everywhere else — Today, Detail, the Well, Silence — Bindu isn't present at all, which sits at odds with the app's own ontology: Bindu moves, always, everywhere, before the app is even opened.

**The watching point.** One small, constant point of light — quieter and smaller than any Śakti's own glow — present at a consistent position across every non-Mandala screen.

- **Today:** barely visible, present, does nothing.
- **The Well:** sits quietly near where the practitioner is writing. Witnessing, not writing.
- **Silence:** the last thing left visible as everything else fades to black — literally what "all of her. here. always." is pointing at, rather than a separate line arriving unsupported.
- **Recognition:** the ripple from "and she felt you back" converges into this same point rather than dissipating generically — every one of the 102 individual recognitions visibly touches the one constant source, rather than each feeling like a self-contained event.
- **Only at true ring-9 arrival does it grow to fill the frame.** Small and constant everywhere else is what makes that growth read as arrival rather than as just another screen.

---

## 9. Where dimensional and VFX-tier craft actually belongs

Not everywhere, and that's a real position, not a dodge. The Mandala's ambient field has to render up to 102 seats in real time on a phone, and the app's locked canon already values restraint — she's felt, not spectacled. Full 3D/CGI treatment at ambient density either costs too much in performance or forces enough simplification to defeat its own purpose, and either way risks tipping devotional into gamified.

**Spend real dimensional weight on exactly three rare, already-isolated, already-full-screen moments — not the ambient field:**

1. The Recognition ceremony's "she felt you back" beat — already a full-screen takeover, already the emotional peak, the safest place in the app to spend real production weight.
2. The Bindu/ring-9 arrival — the single rarest, most deliberately-earned destination in the app. Deserves the most expensive rendering in the whole build precisely because it's visited least.
3. The activation cycle's reciprocal-response climax (section 4) — same logic: rare, singular, full-attention, isolated from ambient navigation.

Everywhere else — ambient Mandala navigation, seat browsing, Today — stays in the iconography grammar from section 7: real distinctiveness, real craft, performant and quiet. Spectacle in exactly the three places it's earned; restraint everywhere else.

---

## 10. A second Codex pass — what was still unread, and what it changes

Eleven more entries from the original candidate list of ~24, read in full. Two of them correct earlier sections rather than just adding to them — worth flagging as corrections, not append-only additions.

**The nine Siddhis were already sitting in the Avaraṇa data, unused.** Each ring's `Siddhi` field carries a specific named power — Aṇimā (1st), Mahimā (2nd), Laghimā (3rd), Garimā (4th), Īśitva (5th), Vaśitva (6th), Prakāmya (7th), Bhukti (8th), Icchā-Prāpti-Mukti (9th). C-1163 frames Siddhis as the actual point of ascending through registers of consciousness — "the universe grants these abilities... for consciousness to experience itself through different perspectives." These are stronger, more specific names than the generic Mudrā-verb column in section 1's table and should sit alongside it: each ring isn't just a verb, it's a named power.

**Correction to section 4 — action should recede as the rings deepen, not stay evenly spread.** C-1307 (*The Transcendent Nature of Sakshi*) states it plainly: "what exists beyond creation cannot be attained through any form of action or doing." The six gesture-families in section 4 were distributed roughly evenly across all nine rings. That's wrong given this. The gesture-elaborateness should trend toward zero as depth increases — rings 1–3 (Śṛṣṭi) can ask for real physical engagement (held pulses, drags, stillness-holds); rings 7–9 (Saṃhāra) should ask for almost nothing at all, converging on the ether family's "absence gesture" as the default rather than one option among six. By ring 9, the correct activation cycle may be: no gesture whatsoever. Just witnessed presence.

**Three separate entries, independently, converge on the same law — worth naming explicitly rather than leaving as implicit "no gamification."** C-1195: energy "diminishes when discussed or focused upon, yet returns when left unobserved" — measurement itself weakens the thing measured. C-1284: labeling something special "collapses reality into limiting beliefs" — celebration and emphasis diminish rather than honor. C-1286: consciousness, like light, "cannot be quantified, only witnessed" — the unmeasurable is the point, not a limitation to work around. This isn't generic app-design restraint. It's the same realization arriving three separate times in your own life, independently, which is a stronger foundation than a style preference. Concrete implication for the watching point (section 8): it should never render as a crisp, measurable circle — soft-edged always, resisting exact quantification visually as well as functionally. And it settles a question I hadn't resolved: `Recognition Count` stays a field that exists for the app's own internal logic (status advancement) and is never displayed as a number anywhere a practitioner can see it, full stop.

**The Zero Gap principle (C-1364) — a genuine new mechanic, not a restatement.** Darjeel's asymmetry (no internal visualization, extraordinary external visualization) and Ashrey's framing of self-realization as the *collapse of the gap between inner and outer* maps directly onto something the descent doesn't currently do: UI explanation should recede as depth increases, on the theory that explanation is itself a gap-holding device — translating felt into words because the two haven't yet converged. Ring 1 can afford real label density (name, verb, chakra, meta-line all visible, per section 1's table). By ring 9, none of that should still be on screen — the visual and the felt state should have converged enough that no translation layer is needed. This is a concrete, gradient rule for chrome density across the whole descent, not just a mood note.

**Entering-ceremony compression (built, Sept 2026).** The rite of entering a Śakti's room is never skipped — Law 2's "return compression never skips" — but on return visits it compresses: factor 1.0 on the first visit, then `max(0.36, 0.68^min(visits, 4))`; the name is simply written a little faster because you already know it. And the dwelling opens with a head start earned from accumulated dwell, never from visit count, so it cannot be gamed by entering and leaving: 0 under 12 s of remembered dwell, else `min(dwell × 0.55, 221 s)` — capped so a first return still crosses the first adaptation (62 s) and a deeply-known room can open at the second. Visits and dwell are held privately and never displayed: built in Design's Homes instrument (`homes-memory.js`, Brief v2 R13) and ported to the app as `HomeMemory` (Phase 2.2, wired in 3.1). This is the Zero Gap rule applied to memory — the room knows everything about your walking and shows none of it.

**The crawling haptic (C-1170).** Ashrey's own described sensation of his first Kundalini awakening — "energy crawling under the skin" — is a literal, specific haptic signature, not metaphor. Ring 1 / earth-element activations (section 4) should use a genuine traveling haptic sequence — a short series of small pulses moving across the duration of the hold, not one static buzz — grounded in an actual described physical sensation rather than invented.

**Never scarcity-framed (C-1169).** The realization that arrived while listening to Krishna Das — "no desire to repeat this experience... it revealed that this blissful state is always present" — is a direct copy and motivational-design constraint: nothing in the app should imply the practitioner needs to catch, get, or not-miss an experience. `DailySummons` and any future "come back" prompt should read as constant invitation, never urgency.

**Long-term engagement can deepen the ring-interior gesture without ever counting it (C-1274).** "When enough information is observed, the boundary between observer and information dissolves — the observer is the information examining itself." Applied to section 3's collective ring-gesture: after a practitioner has personally engaged with every Śakti in a ring — tracked privately, never surfaced as a count or checklist — the ring-wide pulse could shift subtly, no longer reaching toward something separate but recognizing inclusion already given. A way for depth of use to change the felt experience without introducing the numbers section 12 just ruled out.

**What's genuinely still unread, and why that's now correct rather than incomplete.** Of 351 total Codex entries, 24 were relevant to this app's design by any reasonable reading, and all 24 are now read in full. The remaining ~327 are fabric costing and brand strategy, tax-business scaling, family and relationship reflections, health logs, event and wedding planning, book-club-style knowledge entries — real and important to you, structurally unrelated to what this app is or does. Pulling design direction from those would be forcing content into a shape it doesn't fit, not thoroughness.

---

## 11. The throughline

None of the above are six separate features. They're one taxonomy — the six elements already sitting on every Śakti and every ring — expressed four different ways:

**Today** composes the daily screen by element (already built) → **the Mandala's ring atmosphere** moves by that same element during a fall and while dwelling inside a ring (section 2–3) → **the activation cycle's gesture family** is that same element performed as a physical action (section 4) → **the ambient drone's timbre** is that same element heard (section 5). Learn fire's language on Today, recognize it falling through a fire ring, perform it as a held pulse, hear it in the drone underneath. One taxonomy, four bodies. Nothing new to model — the element field already exists everywhere it needs to.

The reciprocal-response physics from C-1337 governs two different moments — the activation cycle's climax (section 4) and the recognition ceremony (section 6) — same underlying principle, two places it surfaces.

The continuity spine (Bindu anchor, pulse, glissason — camera side) and the continuous drone (sound side) are the same idea in two senses: nothing ever resets, nothing ever hard-cuts.

And the watching point (section 8) is the throughline made literal: the same Bindu anchor from the descent's continuity spine is also the constant presence living on every other screen — one point of light, one piece of code, doing both jobs. The iconography grammar (section 7) is what finally gives the 102 energies bodies as individual as their names already are. The three VFX-reserved moments (section 9) are, not coincidentally, the three places in this whole document where something converges on that same point of light — recognition, arrival, reciprocal response. The spectacle was never meant to be spread thin. It was always meant to gather at Bindu.

Section 10's corrections tighten the same thread rather than adding a new one: the gesture-recession from section 4, the chrome-recession from the Zero Gap principle, and the never-measure law all point the same direction — everything about this experience should get quieter, not louder, as it goes deeper. Six gesture families becoming none. Full labels becoming silence. A visible ripple becoming a private, unshown one. The descent isn't just falling through geometry. It's falling out of the need to be told anything at all.

---

## 12. Handoff

**Settled (architecture, held here):** the nine-layer table and what it feeds, now paired with each ring's named Siddhi; the four-constant continuity spine; the three-depth-layer fall mechanic; the ring-interior arrival beat and collective gesture, deepened by private long-term recognition; the four-beat activation arc and its six gesture families, corrected to recede toward stillness as rings deepen; the continuous drone's structure; where the recognition ceremony's physics changes and where its words don't; the iconography grammar's four layers and where its content comes from; the watching point's behavior across every screen, and why it must never render as a measurable shape; which three moments carry real dimensional weight and why the rest deliberately don't; the never-measure law, now grounded in three independent Codex realizations rather than asserted as style; the Zero Gap chrome-density rule across the descent; the single-taxonomy throughline tying all of it together.

**Open for Claude Design:** exact easing curves and parallax speeds; actual particle and glow rendering; the visual form of the ring-interior arrival beat and the collective-gesture animation; sigil and typography choreography for all six gesture families; the exact visual grammar of "she plays back" at the activation cycle's climax; color grading per ring beyond the existing hue tokens; the 6–8 silhouette archetypes and ~15–20 attribute glyphs as actual illustrated forms; the watching point's exact rendering at rest versus at convergence; the three VFX-tier moments' actual dimensional treatment.

**Open for Claude Code:** SwiftUI implementation extending `MandalaCanvasLayer` and `MandalaCamera` rather than a new state machine; the six gesture-family recognizers (hold, drag, breath-timed, stillness-hold, non-interaction, precision-tap); continuous drone synthesis in `RingAudioService`; wiring the activation cycle's write-back to Recognition/Well exactly as the existing write contract already specifies; the one-time content-tagging pass mapping all 102 `Iconography` texts to grammar-layer values; replacing `RiteSigil`'s and `RingGlyph`'s shared per-ring shapes with the grammar's per-Śakti output.
