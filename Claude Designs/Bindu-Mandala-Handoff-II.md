# Bindu Mandala — Handoff II · The Six Ring-Worlds

*Companion to `Bindu-Mandala-Handoff.md`. Covers the ring-worlds designed in Phase 3b/3c — Rings 1, 3, 4, 5, 6, and 9 (the Bindu) — built as a working design canvas in `Ring Worlds II.html`. Take this to Claude Chat to settle the data schema and the build brief, then to Claude Code.*

Phase 3 (in `Ring Worlds.html`) established Rings 2, 7, 8. This phase completes the remaining six. Together the nine avaraṇas now have a designed world each.

---

## I. The Standard (what makes a ring-world finished)

Every ring-world is held to the same bar. Use these as acceptance criteria in the build:

1. **The interface *is* the teaching.** The interaction embodies what the ring *is* — it is not a screen of information about the ring. (Ring 3's plumes scatter when chased and gather in stillness *because* the Anaṅgas are bodiless desire. Ring 9's fall has no bottom *because* the Bindu contains all points.)
2. **An atmosphere, not a page.** Dark ground, warm light from within, dust motes, a single ring-identity line, generous negative space. Ride the existing tokens (`--ground`, `--gold`, `--cream`, `--accent-red`) plus one ring-specific hue.
3. **Its own breath rate.** Per the rates in Handoff I. Ring 1 is the exception — *the ground holds; it does not breathe.*
4. **A felt sub-structure.** Where a ring has families/sequence/concealment, the geometry makes it legible without labels.
5. **Sound where it serves**, always behind a discreet toggle (lower-left), always quiet, always stoppable, started only on a user gesture.
6. **Reverent copy.** Cormorant Garamond italic for sacred speech; system sans only for instrument-language (hints, labels). No metrics-speak.
7. **A still + an interactive frame** on the canvas, so a reviewer sees the resting state and the live one.

---

## II. The Six Worlds

### Ring 1 · Bhūpura — *The Earth-City* — `RingOneWorld`
- **Is:** the outer ground; the world made visible; matter become sacred. 28 forces.
- **Form:** three nested squares with four T-gates. **The three families ARE the three lines** — canonical *and* a lived life:
  - outer line — **10 Siddhi** (powers · accomplishment · *work*)
  - middle line — **8 Mātṛkā** (mothers · language · *family*)
  - inner line — **10 Mudrā** (seals · gesture · *body*)
- **Interaction:** tap a light → meet her (name · family · quality); tap a family in the legend → that band illumines + its lived note; tap a gate → the world floods in (all 28 alight + appreciation phrase). Tap ground → release.
- **Sound:** low Mūlādhāra **ground drone** (root + a fifth, ~73 Hz, slow amplitude breath).
- **Breath:** none — *the ground holds.* Only gate-embers, dust, and a far crimson bindu move.
- **Anchor copy:** *"Thank you for the world I have walked through without knowing it was you."*

### Ring 3 · Anaṅga — *The Smoke Lotus* — `RingThreeWorld`
- **Is:** eight bodyless forms of a single desire (Kāma dissolved into pure quality). One shared bīja, **hsauṁ**.
- **Form:** eight soft warm plumes (no crisp edges — *bodyless*), arranged as an 8-petal lotus around the shared seed.
- **Interaction (the teaching):** the plumes **thin and scatter when you reach (move)** and **gather into a full lotus only in stillness.** Tap a plume → her quality rises; tap the seed → all eight sound *hsauṁ* as one longing.
- **Sound:** a breathy, formless sustained voice with vibrato — the bodiless hum.
- **Breath:** 8s, slow and translucent. Maṇipūra.
- **Copy:** *"The more you reach for her, the more she thins."* ⇄ *"Be still — and the bodiless longing gathers."*

### Ring 4 · Sampradāya — *The Lineage* — `RingFourWorld`
- **Is:** 14 forces of tradition; the teaching traveling teacher → student across generations.
- **Form:** a **garland (mālā)** of 14 stations on a ring, joined by curved threads bowing inward.
- **Interaction:** a luminous transmission-light travels station to station (comet glow), sounding a stepped note at each; once it completes, the whole garland stays lit — *"the garland is unbroken."* Tap the center to send the teaching again; tap a station to read her (name · gloss · *"the Nth of fourteen — received, and passed on"*).
- **Sound:** a stepped ascending note per station as the transmission passes.
- **Breath:** 9s. Anāhata (heart); green-gold.

### Ring 5 · Kulottīrṇa — *The Overflow* — `RingFiveWorld`
- **Is:** ten forces that transcend the kula (family/tradition); overflowing what contains them.
- **Form:** ten triangles inside a containing boundary circle.
- **Interaction:** touch one → her light **spills past the boundary** (rays beyond the frame); touch the center → all ten overflow at once, the boundary dissolves, light floods — *"the accomplishment overflows the one who sought it."*
- **Sound:** a swell that crescendos past a threshold (the overflow).
- **Breath:** 11s. Viśuddha; luminous gold → cream.

### Ring 6 · Nigarbha — *The Concealed* — `RingSixWorld`
- **Is:** ten concealed forces; secret because too interior to be spoken; the protection that holds you unseen.
- **Form:** ten triangles hidden in near-darkness at the center.
- **Interaction (the teaching):** a soft light **follows your touch** and reveals only what is near. Name a revealed one → she **whispers, then conceals herself again** (the name fades — *she will not stay*).
- **Sound:** a near-subliminal tone that rises only as the light approaches a concealed one.
- **Breath:** 13s. Ājñā; deep violet.

### Ring 9 · Bindu — *Praveśa, the Endless Indwelling* — `RingNineDescent` ★ chosen
- **Is:** Sarvānandamaya / Lalitā Mahātripurasundarī. The point that contains all points; the ring that is not a ring.
- **Form:** self-similar Śrī Yantras emerging from the center forever, each carrying its own bindu, slowly spiralling; the 102 names rush past as you fall.
- **Interaction (arc):** press and hold to fall; hold *past the falling* and the descent settles into stillness, the point swells into a luminous presence, and the seeker dissolves — the **recognition**: *"You did not arrive. You were the arriving. Thank you for being the place I have always already arrived."*
- **Sound:** a true **Shepard tone** — octave-stacked voices gliding down endlessly (a fall with no bottom).
- **Breath:** 4s base, always alive.
- **Alternative explored & preserved:** `RingNineSpanda` — *the World-Breath*: hold and the whole yantra blooms from the point, release and it dissolves back. Kept on the canvas as Direction A. **Direction B (Praveśa) is the chosen one.**

---

## III. Sound Design (consolidate in the build)

| Ring | Voice | Notes |
|---|---|---|
| 1 | sustained ground drone | root ~73 Hz + a fifth; slow LFO on amplitude |
| 3 | sustained breathy voice | ~116 Hz, vibrato; gain rises on touch |
| 4 | discrete stepped notes | one per station as the transmission passes |
| 5 | discrete swell | crescendo past the overflow threshold |
| 6 | near-subliminal sustained | gain rises only as the light nears a concealed one |
| 9 | **Shepard tone** | 7 octave-stacked sines descending; bell amplitude over the range; intensity tracks fall speed |

All are Web Audio, lazily created on first gesture, quiet (~0.05–0.07 gain), and toggle off cleanly. In the native build, replace synthesised tones with recorded/produced sound where it matters (especially Ring 9's descent and the bījas).

---

## IV. Content / Data Contract — *the one thing that raises these another level*

The forms are finished; **Rings 4, 5, 6 currently run on reverent glosses of each name's literal meaning** (e.g. "the stirring," "grants abundance," "made of knowing"). Rings 1 and 3 use canonical/known meanings. Ring 9 uses appreciation/recognition lines.

To finish, Airtable should supply, per Shakti (matching the `Shakti` record type in Handoff I):

- **Ring 1 (28):** quality, bīja, somatic line, tattva — and confirmation of the 3-family / 3-line assignment.
- **Ring 3 (8):** already has quality + shared bīja `hsauṁ`; add somatic/dhyāna if desired.
- **Ring 4 (14):** **quality, bīja, dhyāna** — and the *lineage note* (each one's place in the transmission), which the garland surfaces.
- **Ring 5 (10):** **quality, bīja** — and a line on *what each one overflows*.
- **Ring 6 (10):** **quality, bīja** — kept deliberately brief (she whispers); a single interior line each.
- **Ring 9 (1):** confirm the recognition/appreciation copy is canonical or approved.

Also confirm/extend the **Avaraṇa** records (presiding form, yoginī, mental state, chakra, appreciation phrase, personal connection) for Rings 1/3/4/5/6 — several are already in `all-shaktis-data.js`.

Until Airtable is wired, the principle from Handoff I holds: **render placeholders, never invent.** The current glosses are flagged as designer-placeholder and should be replaced, not shipped as canon.

---

## V. Implementation Notes (for Claude Code)

- **Canvas:** `Ring Worlds II.html` (a `DesignCanvas` of 390×844 iPhone frames). Loads `shakti-data.js`, `all-shaktis-data.js`, `design-canvas.jsx`, `screens.jsx`, then the world files.
- **World components:**
  - `ring-worlds-2.jsx` → `RingOneWorld`
  - `ring-nine.jsx` → `RingNineDescent` (chosen), `RingNineSpanda` (alt), `FullYantra`
  - `ring-worlds-3.jsx` → `RingThreeWorld`, `RingFourWorld`, `RingFiveWorld`, `RingSixWorld`
- **Shared chrome:** `DustMotes`, `StatusBar`, `HomeIndicator` (from `screens.jsx`); `COLORS` + the `RINGn_SHAKTIS` arrays (from the data scripts).
- **Patterns to reuse in the native build:** rAF + refs (no React re-render) for continuous motion (Ring 9 descent, Ring 1 layout, Ring 3 gather); CSS-transition state toggles for discrete reveals (Rings 4/5/6).
- All worlds are **390×844, ≥44pt tap targets, `prefers-reduced-motion`-aware in the native build.**

---

## VI. What to take to Claude Chat

1. **Finalise the Airtable schema** for the fields in §IV (quality, bīja, dhyāna, lineageNote, "what she overflows," interior line) across Rings 1/4/5/6.
2. **Confirm the Ring 1 family/line assignment** (10 Siddhi · 8 Mātṛkā · 10 Mudrā) against the source tradition.
3. **Approve or replace** the placeholder glosses and the Ring 9 recognition copy.
4. **Sound brief** — decide which tones become produced audio vs. synthesised (§III).
5. Then → Claude Code, using §V as the component map.

---

## VII. Rings 2, 7, 8 — raised to the §I standard (Phase 3 revisited)

The three Phase-3 worlds were brought up to the bar:

- **Ring 2 · Inhabited Lotus** — now **interactive invocation**: press any petal and that Śakti rises into presence (name · bīja · quality), the others mute, and a low **home-breath tone** (root + a fifth) swells; release and *she remains*, then settles. (`RingTwoWorld`, `rwHome*` audio.)
- **Ring 7 · Vāk Chamber** — extended from 8 to the full **12 Vāk-devatās**; once seven or more voices have sounded, the recognition arrives — *"The word that healed what the mind could not reach."* (`RingSevenWorld`, `VAK_FREQS` ×12.)
- **Ring 8 · Mūla Trikoṇa** — now fully **interactive with sound that embodies the collapse**: tap a vertex and the **three tones glide into one pitch**; tap to dissolve and they settle to a single Bindu fundamental; begin again and the triad returns. (`RingEightWorld`, `r8*` audio / `R8_FREQS`.)

All nine avaraṇas now sit at one level. **The instrument is coherent end-to-end** — ready for Claude Chat (schema/content, §IV–VI) and then Claude Code (§V map).

---

*End of Handoff II. Nine worlds designed and leveled. The forms are done — content and sound are the remaining depth.*
