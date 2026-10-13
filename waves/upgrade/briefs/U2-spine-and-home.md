# U2 · Spine and Home — wave brief

Branch: `upgrade` (U0 + U1 merged). U2 is the first wave Ashrey will feel. After it:

- the app wakes through the growing white dot and arrives at **Home, the Bindu**;
- the **point** sits in every world and brings him home;
- the **menu** (the Constellation) is one touch away above every world;
- **every world is its own space** — the Mandala is cleared to the held yantra and the Veil, and everything that was drawn on it (the 33, the Road, the thresholds, Tat Tvam Asi, the dissolutions, the ways-in ring) now lives in its own world;
- **back** returns to exactly where he was; every crossing travels through the point.

Worlds whose full redesign comes later (U3–U11) are hosted in U2 with **the content that exists today, each in its own space** — never laid over another world. Nothing that exists today is lost: every screen that was reachable is reachable through the spine.

## Read first, in full

- `waves/upgrade/briefs/U0-ground.md` — the build environment (no compiler here; compile-safe Swift; synchronized groups) and the floors. They apply unchanged.
- `waves/upgrade/briefs/U1-instruments.md` and the four U1 reports `U1-A/B/C/D-report.md` — the engines you build on (Router, WorldRegistry, Address, Crossing in `Spine/`; mixer and tuning in `Sound/`; WorldStyle, palette, breath, `ThePoint` in `Look/`; HoldEngine, haptics, ScorePlayer in `Instruments/`). Use them; do not re-create them.
- `waves/upgrade/worlds/spine-and-home.md` in full — the design of this wave, second by second, with every element (§2) and its sources.
- `waves/upgrade/worlds/mandala-and-rings.md` §1A and rows MX01–MX15 — what leaves the Mandala and where it goes.
- `waves/register/19-code-mandala-today.md` §B — how navigation works today and why the Mandala overlaps (file:line).
- The existing code you touch, in full, before you touch it.

## Parts (three builders in parallel; each owns its files)

### Part A · Launch and Home — owns `iOS/Bindu Mandala/Home/` (new)

Build Home as `spine-and-home.md` §1 "Arriving", "Being there", "Going deeper" describe, using the U1 engines:
1. **The Waking** (0–2.85 s, exact timings, never blocks touch) → **Homecoming** (reuse the existing Homecoming code — find it; it plays on every launch per his ruling; first-launch-ever version as described) → **Home**. The greeting lines read from the ledger, never from a flag.
2. **Home's layout**, back to front: ghost yantra (his record as light — reuse the Portrait/LivingMandala yantra drawing and the U1 palette; whether/recency/length, never counts), the **station ring** of the fourteen worlds (Today at 12 o'clock, clockwise as listed, r ≈ 148 pt, each a small mark + name at 11 pt; touching a station crosses to that world through the Router), today's pointers, the structural five (r 58) with their lines verbatim, **the point** (`ThePoint` from U1, 26 pt, 4 s breath, white light behind), the **Road Home** beads (one per world left partway, from the Router's journey) and the line with his higher-self name (BinduMemory; ask once, changeable, keeps earlier names), chrome (top-left Constellation mark, bottom-left sound and ?, bottom-right Margin).
3. **The four movements of the point**: tap → **Mauna** (move the existing Mauna / silence view here from the Mandala; captions at 7/14/21/28 s restored), stillness 4.6 s → the stillness gate, **hold 0.9 s (U1 HoldEngine) → the deep zoom (Praveśa)** — move the existing Praveśa fall here (ruling 9), **spread** → Spanda into the Mandala (existing BloomPress). **Lalitā source** as the arrival from inside (move it here).
4. **Sound** on Home via the U1 mixer: Om floor 136.1 Hz from first touch, the day's bells once.
5. Register Home's view as the `.home` world builder in the WorldRegistry.

### Part B · The spine shell — owns `iOS/Bindu Mandala/Spine/` (extend), `BinduMandalaApp.swift`, `Views/Root/`

1. **New root**: the app's root becomes the spine — one world on screen at a time from the Router's current address; launch always arrives at `.home` (ruling 1); the old `RootView` tab/hamburger structure is retired (keep its data sync, gift handling and presenters' responsibilities, moved into the spine root or services so nothing stops working — list each).
2. **The point in every world** (top-right, 6 pt, 44 pt target): tap → home, hold → source (Lalitā source via Home), double-tap → the one-second practice if it exists (else nothing).
3. **The Constellation menu**: top-left 2×2 mark or a slow pull anywhere; fifteen world-points as Home's ring, threads drawing in over 2.2 s, current world glowing; a list view and the Veil on the same switch; always above every world; touching a world crosses there.
4. **Doors along the threads**: a reusable `ThreadDoors` view each world can place (52 pt discs; kp, chakra, day; neighbours) — used by Home and the hosted worlds.
5. **Search**: "Type one word you're carrying" — every Śakti (four spellings), chakra, verb, mode, game, world; results cross through the Router.
6. **Back**: left-edge swipe and the Router's back stack; returns to the exact address under a bloom of the colour he left.
7. **Crossings** from U1 played on every world change; sound carries across the seam; each world sounds its threshold pitch (U1 Sound); one ledger row per crossing (use an existing activity type or add "World Crossed" to the ledger vocabulary in `ActivityLedger.swift` — typecast covers the Airtable choice).
8. **Rewire the six NotificationCenter channels and the global presenters** to Router calls (U1-A's bridge lists them), then remove the channels.
9. **Walk steps**: extend `Bindu MandalaUITests/TheWalk.swift` so the walk reaches all fifteen worlds by the point, the menu, a station, search and back, and asserts one world on screen at a time.

### Part C · The worlds in their own spaces — owns `iOS/Bindu Mandala/Worlds/` (new) and edits under `Views/Mandala/`

1. **Clear the Mandala** to the held yantra and the Veil (`mandala-and-rings.md` §1A): remove from the Mandala glass the 33 constellation layer, the Road, the Shadow/Armin thresholds and Tat Tvam Asi overlay, the dissolutions, the ways-in ring, Mauna/Praveśa/Lalitā-source (Part A moves those to Home — coordinate by leaving them callable). Fix the **Veil** to Design's numbers (sheet 720, peek 108 as the sheet's edge, tap < 6 px, snap at 42 %, live drag tracking, 0.52 s cubic-bezier(.22,1,.36,1), yantra dims with the drag to 0.5); a Veil row crosses to that ring in **the nine rings** world (Router), never moves the camera several rings at once. Pinch to a seat keeps working (her Home door).
2. **Host every other world in its own space** with what exists today, each registered in the WorldRegistry:
   - Today · the Rite → the existing Rite/Today views.
   - The nine rings → a world that opens on the ring chosen (from the Veil or a door) and shows what exists for that ring today (Tree of Life panel, release gates, ring 7/8 sound, ring 9 fall) — one ring at a time, own space.
   - Her Home → the existing rite → room path, **room first**: tapping a Śakti anywhere opens her room (through the rite), and her text page becomes Her Presence (the room's library door leads to it).
   - Her Presence → the existing ShaktiDetailView.
   - The Climb → the existing climb view, full screen, own space.
   - The 33 → the constellation, the Road and the chakra rooms (with the thresholds and Tat Tvam Asi in the Road's crossings), in their own space.
   - A Strange Game → the existing play field, entered through the Eight Dissolutions (once a day per his ruling; later the same day "Now go play." for 3 s).
   - The Modes → the existing modes door/list as a world.
   - Time → the five clocks (`ThePointView`) moved out of the Portrait.
   - Memory → the Portrait and the Record.
   - The Well → the existing Well.
   - Beneath → the low-state door, the Shadow Translator, the river of letters door — gathered as one place.
   - The Relationship Field → the three connections (Gaia kp 31 · Ahaṅkāra, Ashrey kp 40 · Nāma, Ram kp 42 · Ātmā; Bīja kp 41 the bridge) as a simple world with doors to each Śakti (full design in U11).
3. Each hosted world gets `ThreadDoors` (Part B) where its address has kp/chakra/day, and `ThePoint` via the spine (Part B draws it — don't draw a second point).
4. Remove every in-world "back/close" control that would bypass the Router (use `router.back()`), and every overlay that sits over another world.

## Done when

- Each part's report (`waves/upgrade/briefs/U2-<A|B|C>-report.md`): every file touched, every screen moved and where it went, every API assumption.
- The session merges, builds and runs on the Mac: cold launch → Waking → Homecoming → Home; every world reached by station, menu, search and back; the Mandala shows only the yantra and the Veil; nothing overlays; the walk passes; screenshots of every world into `BinduWalk/U2/`.
