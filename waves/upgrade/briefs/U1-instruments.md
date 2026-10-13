# U1 · Instruments — wave brief

Branch: built on `upgrade` (after U0). U1 builds the **shared engines** every world will use. It changes little that Ashrey sees on its own — U2 (Spine and Home) is the first wave that wears them. Four builders work in parallel, each owning its own new folder so nothing collides:

| Part | Owns (new folder) | Reads |
|---|---|---|
| **A · Router** | `iOS/Bindu Mandala/Spine/` | `worlds/spine-and-home.md` §1 "The spine in every world", §2 groups G–J (doors, search, back stack, crossings, routing), §4, §5, §7 |
| **B · Sound** | `iOS/Bindu Mandala/Sound/` | `worlds/sound.md` in full |
| **C · Look** | `iOS/Bindu Mandala/Look/` | `worlds/visual.md` §1.3–1.15 and §2; the U0 `Theme/` and `Element.swift` |
| **D · Gesture and Score** | `iOS/Bindu Mandala/Instruments/` | `worlds/the-33-architecture.md` (hold engine, Score player sections), `worlds/sound.md` §1.8, `worlds/verification.md` V25 |

Read first, in full: `waves/upgrade/briefs/U0-ground.md` (the build environment and floors apply unchanged — **no compiler here; compile-safe Swift; synchronized groups**), `waves/upgrade/UPGRADE-MAP.md`, and your Part's sources above. Read the existing code you will wrap or replace in full before writing (e.g. `Services/SoundConductor.swift`, `HomeSoundService.swift`, `Theme/*`, `Views/Root/RootView.swift`).

## Rules for every part

- **Add, don't break.** U1 creates engines with clean APIs and unit tests; it does **not** rip out existing screens (U2 does the rewiring). Where an existing engine is the right base (SoundConductor, Atmosphere, BreathClock, HomeSoundService), wrap or extend it rather than duplicating; say which in your report.
- Every public type gets a doc comment saying which world file section it implements.
- Every engine gets unit tests in `Bindu MandalaTests/U1<Part>Tests.swift` that read the numbers from the world file's sources (Design files under `Design/Corpus/` via the U0 `DesignCorpus` helper where they exist), and each test is shown able to fail.
- Floors as in U0. Nothing scores him. No TTS.

## Part A · Router (Spine/)

1. `WorldRegistry`: every `WorldID` (U0 `Services/WorldID.swift`) with its display name, its constellation position and colour token (from `visual.md` §1.3/1.10 and `spine-and-home.md`), its entry addresses (kp?, chakra?, day?), and its builder closure (U2 fills real views; U1 registers placeholders that show the world's name and the point, so the walk can reach all fifteen today).
2. `Address` (world + optional kp 1–102, chakra road 1–33, date, camera/scroll anchor) and `NavigationState` — one source of truth: current address, a back stack of addresses (back returns to the exact address), Codable persistence for "where you were" across launches.
3. `Router` (ObservableObject / @Observable): `go(to: Address, via: Crossing)`, `back()`, `home()`; replaces the six NotificationCenter channels **by providing a bridge**: list each channel (`spine-and-home.md` §7) and add a router call that U2 will switch callers to (do not delete channels in U1).
4. `Crossing`: the bloom-from-touch transition primitive (origin point, colour of the destination world, durations from the sources) as a SwiftUI `Transition`/overlay, plus the "Descent" and "blink" variants declared (implemented minimally).
5. Deep-link mapping for `OPEN_WORLD` and for every address (kp, road) — `OPEN_WORLD` now routes through the Router.
6. Tests: every world reachable from `home()` by `go`; back returns exact address; nothing overlays (only one world view mounted at a time — assert via the router state).

## Part B · Sound (Sound/)

1. The **mixer** of seven layers (`sound.md` §1.2): Om floor 136.1 Hz, world voice, her/room, binaural, song, bells/accents, haptics bus — additive with a summed ceiling; ducking never pulls the Om below its floor; only songs are exclusive. One owner of `AVAudioSession`.
2. **One tuning** (`sound.md` §1.4): ring roots 55–123.47 Hz + the just ratios as a single `Tuning` type every pitch is computed from; the named exceptions as constants with their source in a comment; the retired sets listed in a comment with their replacement.
3. Each world's voice and 2.6 s crossfades (§1.5); the nine enclosure bells `bell(r) = root(10−r) × 4` (§1.6); a room's fixed tone (§1.7 table as data).
4. Bundled recordings: a `Recordings` catalogue of the 40 unique mp3s (`waves/register/audio-on-github.md`, `sound.md` §1.9) with sha256 — **U1 does not download audio**; it streams from `https://aistrangegame.com/<path>` with on-device caching and verifies sha on first download. `tree-of-life/aatma.mp3` is Chase Hughes' *Aatma* (his ruling); `bindu/play.mp3` is Lalitā's dance.
5. Sound on by first touch; mute (tap) and master volume (UserDefaults convenience); Mono Audio → binaural becomes a pulse.
6. Tests: every pitch from `Tuning` matches the table; bells; mixer ceiling and Om floor (offline render of a short buffer and RMS/FFT check where feasible).

## Part C · Look (Look/)

1. Per-world **tokens** (`visual.md` §1.4) as Swift: `WorldStyle` per `WorldID` — colours (hex), fonts (family, size, weight — use only fonts bundled today or system fallbacks; list the faces still to bundle), spacing, motion curves and durations, chrome level.
2. **Palette engine** (§1.5): one hue per Śakti from her ring/cluster, jittered by kp with the existing formula, relit by the hour, element layouts with ruling 4's table (ether hue 280°).
3. **Breath** (§1.6): periods per enclosure — the single 8 s clock keeps its epoch but no longer snaps (home petal 3.5 s, Bindu 4 s …) — extend `BreathClock`.
4. **Chrome thinning** (§1.8) and **depth colour** (§1.9: `#C9963F → #C9813A → #C76B35 → #C45430 → #C0392B`).
5. **`ThePoint` view** (§1.10): the one point used in every world — size, colour by depth, breath, the white light behind the red point at rest; accessibility label; tap / hold callbacks (wired to Router in U2).
6. Canon colour order (§1.11), contrast floors (§1.14: text ≥ 4.5:1, cream ≥ 0.5 opacity), Reduce Motion behaviour (§1.13: decorative loops pause, adaptations slow and step).
7. Tests: token values against `visual.md`; contrast ratios computed; palette determinism for all 102.

## Part D · Gesture and Score (Instruments/)

1. **HoldEngine** (the one hold engine): progress rises over a duration, commits only at full and acts on release, an early release drains (rise and drain speeds from the sources); a held hardware key counts (key-repeat ignored); a tap does nothing; the durations ladder as named constants (750 ms readiness, 1,100 ms gate, 1,800 ms story, 2,300 ms send, 5,000 ms covenant; the room-gate ladder 3500 → 1500 ms). A SwiftUI modifier `.hold(...)` and an accessibility action equivalent.
2. **Haptics library** on Core Haptics (patterns named in `sound.md` §1.10 — heartbeat 60 bpm, the 50 bpm long-silence heart, recognition, crossing), with UIKit fallback.
3. **ScorePlayer**: parse Score Format v2 JSON (the format in `Design/` or the Bindu Field skill references summarised in `worlds/the-33-architecture.md` and `sound.md` §1.8; the scores live in Airtable Bindu Field `Score JSON` fldxIm6qUXLcdrRuR and the U0 snapshot) and drive time-coded cues (sound, light, motion, words, haptics, ledger writes) from one clock; validate with the 21 Score rules (V42) and refuse an invalid score.
4. Tests: hold commits only at full, drains on early release, tap does nothing; Score parsing of the snapshot's Score JSON rows; cue timing.

## Done when

Each part's report (`waves/upgrade/briefs/U1-<A|B|C|D>-report.md`) lists every file, every API assumption, and how each test can fail. The session merges the four parts, builds on the Mac, runs the tests.
