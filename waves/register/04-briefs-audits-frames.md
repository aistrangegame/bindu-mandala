# THE REGISTER · 04 — Briefs, audits, handoffs, specs, and Design's frames

*Reader 04 of 7 · 12 October 2026 · every assigned file read line by line, and every assigned image opened and looked at. Section D gives the proof.*

**How to read the entries.**
- **Source** gives `file:line`. For the four HTML briefs, `L###` is the line in the original `.html` source. The text was extracted to `/tmp/claude-0/-home-claude-bindu-mandala/ff2da883-c9f2-5d47-817d-8a80318e2c65/scratchpad/register/*.txt`, which keeps those line tags.
- **Kind** is one of:
  - **DI**: design intention
  - **BI**: build instruction (including acceptance criteria, marked "Done when")
  - **AF**: audit finding
  - **OR**: owner ruling, meaning Ashrey's, or sealed by Chat with him
- **Status** is how the entry stands as of 12 Oct 2026, under BUILD-CHARTER II and THE READING:
  - **LIVE**: still binding.
  - **DONE**: built per the record.
  - **SUPERSEDED → x**: replaced by x.
  - **RESHAPED**: kept, with its first principle restated.
  - **RESTORABLE**: was cut, and THE READING or WAVES reopened it.
- **Abbreviations:**
  - **DU** = `/home/claude/design-upload/extracted/`
  - **R2** = `Claude Design Round 2/`
  - **CC** = `Claude Chat/`
  - **CB** = `Claude Briefs/`

**Documents in date order** (oldest first, which also gives precedence: newer wins unless an entry says otherwise):

| Order | When | Documents |
|---|---|---|
| 1 | ~20 May | `CB/CLAUDE_CODE_BRIEF.md` (the original build); DU `DESIGN_SPEC.md` (the 16-Karṣiṇī spec) |
| 2 | ~27 May | DU `Bindu-Mandala-Handoff.md` (Phases I–VII); DU `Bindu-Mandala-Handoff-II.md` (the six worlds) |
| 3 | 28 May | `CB/Bindu-Mandala-Final-Brief.md`; `CB/UX-AUDIT.md` (pre-July, three-tab app) |
| 4 | May | DU `Design Audit.html` (build `0bd9542`); DU `Refinement Brief.html` (same build) |
| 5 | ~31 May | DU `Master Build Brief.html`, with the same text in DU `Bindu Mandala - Claude Code Brief.md` |
| 6 | July | DU `Audit II.html`; DU `Final Handoff.md` (= R2 `DESIGN_SPEC.md`, byte-identical); R2 `README.md` |
| 7 | 11 Jul | R2 `RECONCILED-BUILD-BRIEF.md`; R2 `KP-ORDERING-FINDINGS.md` |
| 8 | August | DU `uploads/bindu-mandala-master-brief.md` (the Experience Architecture), with an errata header added in CC on 7 Sep; CC `bindu-mandala-expansion.md` |
| 9 | 6 Sep | the Homes package (`homes-design-package.md` and cards); `The Homes - the thread.md`; `Claude Code Handoff - The Homes.md`; `READ ME FIRST.md`; DU `github.md` (synced 6 Sep); CC `SESSION-HANDOFF`; CC `BINDU-MANDALA-AUDIT-BRIEF` |
| 10 | 6–7 Sep | CC `AUDIT-REPORT`; `DEVICE-AUDIT-BRIEF`; `AUDIT-REPORT-DEVICE` |
| 11 | 7 Sep | CC `BINDU-MANDALA-BUILD-BRIEF-V2`; `PACKAGE-START-HERE`; CC `README`; R2 homes `github.md` (adds the Ruling-7-closed note); the R2 homes method (all-shaktis line replaced); `_superseded` READMEs |
| 12 | 7–21 Sep | CC `BUILD-BRIEF-V2-ERRATA` (includes R17, sealed 20 Sep, and the carrier ruling) |
| 13 | 20 Sep | CC `CHAT-NOTE-TO-CODE-2026-09-20` |
| 14 | 12 Oct | `waves/THE-READING-2026-10-12.md`; `BUILD-CHARTER.md` (Charter II, Emergence); `WAVES.md` |

---

## A · Requirements, intentions, rulings and acceptance criteria

### A1 · DU `DESIGN_SPEC.md`, the original 16-Karṣiṇī spec (May)

Note: this is **not** the same file as R2 `DESIGN_SPEC.md`; see C27.

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| DS-01 | "A devotional companion for connecting with the 16 Karṣiṇī Śaktis of the Śrī Yantra's second avaraṇa… design source of truth for the SwiftUI build." | DESIGN_SPEC.md:3 | whole app | DI | SUPERSEDED (scope grew to 102) |
| DS-02 | Emotional register: "Devotional. Embodied. Quiet luxury. Sacred geometry precision… entering a temple through a side door — intimate, not grand… **Not** a meditation app. **Not** a wellness brand." | :7–8 | whole app | DI | LIVE (tone) |
| DS-03 | Colour tokens: groundColor #0D0508, surface #1A0C10, darkVeil #080307, silenceGround #040104, gold #C9963F, goldDeep #A07830, goldFaint α0.12, cream #F2E8D9, creamMid α0.65, creamFaint α0.35, accentRed #8B1A2A | :14–28 | Theme | BI | LIVE (token family) |
| DS-04 | Cluster colours: innerInstrument #D4A017 amber (pos 1–3); senseStreams #C4725A rose copper (4–8); citta #2A7A7A teal (9); stabilityPowers #4A7A5A sage (10–13); selfBodyImmort #7A5A9A violet (14–16) | :31–35 | Ring 2 | BI | LIVE (see C11) |
| DS-05 | Type: Sanskrit names in Cormorant Garamond Light/300, tracking 0.06–0.10em; body in SF Pro; bīja in Cormorant Light at very large sizes "as visual objects"; phonetics and labels in SF caps, tracking 0.18–0.22em; italic Cormorant is "the voice" | :42–46 | Typography | BI | LIVE |
| DS-06 | Today size scale: name 44–48pt; quality (gold) 20–22; somatic italic 18–20; phonetic/labels 12pt uppercase tracked | :48–52 | Today | BI | RESHAPED (Audit II asks 56–72; see C9) |
| DS-07 | Status opacity: Mapped 22% · Exploring 44% · Active 76% · Embodied 100% + soft glow | :58–65 | Mandala petals | BI | — |
| DS-08 | "Transitions are user-driven from the Detail screen (tap status pill to advance). Each transition should be a small ceremony — a soft animation, a held breath." | :67 | Detail | BI | SUPERSEDED → press-and-hold crossing (RBB 3.2) |
| DS-09 | The 16 with cluster, location and bīja (for example: 1 Kāmākarṣiṇī heart aṁ; 9 Citta whole lṁ; 10 Dhairya spine eṁ; 13 Bīja sacrum auṁ; 16 Śarīra whole kaṁ); field markers Gaia at 3, Ashrey at 12, Ram at 14 | :73–90 | Ring 2 data | BI | SUPERSEDED by the Airtable cards (C12) |
| DS-10 | Petal 0 at 12 o'clock; clockwise; 22.5° spacing | :92, :98 | Lotus | BI | LIVE wherever the lotus is drawn |
| DS-11 | Lotus geometry: outer radius 0.435×d; inner 0.117×d; half-width 0.087×d; cubic bezier almond; Bindu is a crimson radial with a cream core and glow; ghost geometry of the other 8 avaraṇas at ~5–7% | :98–104 | Lotus | BI | — |
| DS-12 | Today's petal: `petalBreathe` 3 s (opacity, brightness, drop-shadow in cluster colour), with a gold ray, dot and "TODAY" label | :105–106 | Mandala | BI | — |
| DS-13 | Animation table: Today name fade 1.4 s; somatic 1.4 s at +0.55; recognition name 1.8 s at +0.3; phrase 1.8 s at +0.9; Logged 1.0 s at +2.6; reciprocity 1.4 s at +4.1; ripple rings 4 s, staggered 0/1.1/2.2/3.3; Silence Bindu 6 s; names 4 s at 0.15×i; caption 7 s ramp from 65%; motes 16–30 s | :110–125 | Motion | BI | LIVE as reference values |
| DS-14 | Today has two variants: body outline and bīja texture | :134 | Today | DI | SUPERSEDED → six archetypes (Ruling 5) |
| DS-15 | Primary CTA "I feel her": full-width pill, deep red with cream text. "The core gesture." | :138 | Today | BI | LIVE |
| DS-16 | Tab bar: Today / Mandala / The Well | :139 | Nav | BI | SUPERSEDED (FB Phase 0) |
| DS-17 | Mandala shows the progress line "5 of 16 Active · 2 Embodied" | :149 | Mandala | BI | SUPERSEDED (never-measure); see C7 |
| DS-18 | Detail sections: Quality, Somatic Signature, Bīja Tap to Hear, Esoteric Tattva, Field Connection (only when present), Recognition Log | :153–164 | Detail | BI | RESHAPED → Homes library (R12) |
| DS-19 | Recognition Moment: near-black ground; bīja texture at ~6.5%; name → divider → appreciation phrase → ripples; act 1 "Logged · [time]" (sans, muted, uppercase); act 2 "And she felt you back · [time+3s]" (italic gold); optional "What did you notice?"; tap anywhere to dismiss | :166–176 | Recognition | BI | RESHAPED (lines law: "she was felt here"; see C18) |
| DS-20 | Silence: no chrome; vignette; 16 names as stars at ~16% α, tangential; Bindu 76 px with 132 px ring; ~7 s caption "All of her. Here. Always."; silence logged as its own gesture | :178–188 | Silence | BI | SUPERSEDED (retired 3244f54) → RESTORABLE (Mauna, Wave 2) |
| DS-21 | iOS: 390×844; tap targets ≥44pt; haptics light on petal, medium on "I feel her", soft on status advance; honour prefers-reduced-motion | :194–200 | All | BI | LIVE (44pt, haptics) |
| DS-22 | Core loop: Today → I feel her → Recognition → note → Today; Mandala → petal → Detail; Bindu → Silence | :206–212 | Nav | DI | SUPERSEDED |
| DS-23 | Sacred notes: single user; no social, streaks or gamification; notifications only "that *arrive with her*"; "the lunar cycle drives the daily Śakti assignment"; field connections editable in Settings; recognition log private, "never aggregated, never analyzed" | :220–223 | All | DI | Mixed (lunar SUPERSEDED by Ruling 3; "gamification" RESHAPED by Charter II "gamified app") |

### A2 · `CB/CLAUDE_CODE_BRIEF.md`, the original build brief (May)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| CB0-01 | Genesis quote ending "I love them, and would like your assistance in designing a way to love them." "Build this as if you are building a temple, not an app." | :7–9 | whole | DI | LIVE (spirit) |
| CB0-02 | iOS 17+, iPhone only, 390×844, local-first, Airtable as the remote truth | :15–20 | platform | BI | LIVE |
| CB0-03 | Offline-first: "I feel her" works without network, "Period." | :51–52 | Recognition | BI | LIVE |
| CB0-04 | She is the subject: "she was felt here", not "you logged this" | :54–55 | copy | DI | LIVE |
| CB0-05 | The always-already orientation: "where do you feel her right now?", never "where is she showing up?" | :57–58 | copy | DI | LIVE |
| CB0-06 | No social, streaks or gamification; notifications optional; "The app waits. It does not chase." | :60–61 | all | DI | RESHAPED (Charter II §4.6) |
| CB0-07 | Recognition log private; no analytics or telemetry | :63–64 | data | DI | RESHAPED (syncs per R4/R17; still not surveilled) |
| CB0-08 | "And she felt you back" is sacred: act 1 "she was felt here · [time]" in muted uppercase sans; act 2 appears 3 s later, italic Cormorant gold | :66–67 | Recognition | OR/DI | LIVE (lines verbatim); timing see C18 |
| CB0-09 | Phase 1: today's Śakti = `floor(moon_age) mod 16` | :84 | Today | BI | SUPERSEDED (Ruling 3) |
| CB0-10 | Phase 2 Today: name 46pt, quality 20pt, somatic 19pt; two variants; tab bar | :88–97 | Today | BI | SUPERSEDED |
| CB0-11 | Phase 3 Recognition: darkVeil; act timings 2.6 s and 4.1 s; ripple 4×; note card | :99–110 | Recognition | BI | timings LIVE in shipped code |
| CB0-12 | Phase 4 Mandala: geometry per DS; 76pt Bindu; progress text "N of 16 Active · N Embodied"; cluster legend | :112–130 | Mandala | BI | SUPERSEDED |
| CB0-13 | Phase 5 Detail: status pill "tap to advance… small ceremony"; bīja 108pt tap-to-hear; field connections at positions 3/12/14 editable from Settings; Her Moments | :132–142 | Detail | BI | partially SUPERSEDED |
| CB0-14 | Phase 6 Silence (as DS) | :144–155 | Silence | BI | SUPERSEDED → RESTORABLE |
| CB0-15 | Phase 7 Well: "Your Letters to Them"; placeholder "Speak to her directly. She is listening."; "Letters are local only. Never synced." | :157–166 | Well | BI | SUPERSEDED (letters sync; R17) |
| CB0-16 | Phase 8 Homecoming: shown once; "You have always felt them." / "Now you will know their names."; Bindu pulse at 6 s; "tap to enter" at 7 s | :168–177 | Homecoming | BI | RESHAPED (WAVES: Bindu Origin becomes Homecoming) |
| CB0-17 | Phase 9 Settings: notification cadence "every 3 hours, or off"; field connections; bīja source is Airtable | :179–185 | Settings | BI | SUPERSEDED (one summons a day) |
| CB0-18 | Bīja sound: sine first, recorded voice later as `bija_01…16.mp3`; Airtable `Bija` is authoritative | :259–266 | Sound | BI | RESHAPED (`bija_%02d` across 102) |

### A3 · DU `Bindu-Mandala-Handoff.md`, Design Handoff I (Phases I–VII, May)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| HO1-01 | "This is **not an app for the practice of recognition.** It is the practice… the interface *is* the work." | :11 | whole | DI | LIVE |
| HO1-02 | "The Sri Yantra… is the entire ontology… The phone becomes a temple." | :13 | whole | DI | LIVE |
| HO1-03 | Five dimensions: Depth (inward, nine avaraṇas), Time (cyclical), Memory (accumulation; "the yantra becomes a portrait of your consciousness"), Relationship (radial), Practice (eight modes) | :21–27 | architecture | DI | Relationship DEAD (FB §9); the rest LIVE/RESTORABLE |
| HO1-04 | Eight Modes and their gestures: Darśana (hold vertical, still); Recognition (long-press anywhere); Sādhana (pinch outward from Bindu, ~28 min Khaḍgamālā with Visarjana); Smṛti (long-press a ring); Mauna (tap centre); Svapna (first open of the day, voice and text); Pūjā (swipe down from top); Saṅgha (two-finger tilt) | :33–42 | Modes | DI | RESTORABLE (RD §4; Saṅgha's outer layer dead) |
| HO1-05 | "**There is no menu. The yantra is the navigation.**" Gesture table: tap ring → descend; tap Bindu → Mauna; long-press ring → Smṛti; pinch out → Sādhana; hold still → Darśana; swipe up from edge → today's pull; swipe down → Pūjā; two-finger hold petal → invoke; long-press anywhere → Recognition | :46–58 | Nav | DI | RESHAPED (hamburger exists; RD restores "there is no menu" grammar as an option) |
| HO1-06 | Seven design phases mapped to HTML: Codex, Home Mandala, Ring Worlds, Eight Modes, Temporal Layer, Memory Layer, Relationship Field | :66–74 | Design corpus | DI | reference |
| HO1-07 | Inviolable 1: "Sacred content flows from Airtable. The app never invents." Show a placeholder ("her quality flows from Airtable") rather than invent | :82–84 | Data | DI | LIVE (Charter II §3.8, §4.2) |
| HO1-08 | Inviolable 2: "No tab bar. No menu. No hamburger." | :86–88 | Nav | DI | SUPERSEDED (FB Phase 0 hamburger) |
| HO1-09 | Inviolable 3: "Lifetime is the default… Storage is forever unless the practitioner explicitly releases." | :90–92 | Data | DI | LIVE (Charter II §4.1) |
| HO1-10 | Inviolable 4: time and location are device-local; sandhyās from latitude sunrise/sunset; hemisphere-aware seasons; tithi and nakṣatra by ephemeris | :94–96 | Temporal | DI | RESTORABLE (Wave 5 "with a real ephemeris") |
| HO1-11 | Inviolable 5: ring worlds, lunar phases, seasons and sandhyās are "the live home under a different sky", overlays rather than destination pages | :98–100 | Mandala | DI | RESHAPED (RD: Ring World mechanisms reborn inside the zoom) |
| HO1-12 | Inviolable 6: "No invented relationships, no fake practitioners." | :102–104 | Relationship | DI | LIVE (relationships dropped) |
| HO1-13 | Inviolable 7: reverent voice; "No metrics-speak. No 'you've earned X.' Numbers when they appear are factual and named in lifetime context." | :106–108 | Copy | DI | RESHAPED (Charter II §4.6) |
| HO1-14 | Colour: --ground **#060104**; --gold #C9963F; --gold-warm #CF9443; --cream #F2E8D9; --accent-red #8B1A2A ("The Bindu, always") | :121–127 | Theme | BI | C10 |
| HO1-15 | Cluster colours: Antaḥkaraṇa **#7A5A9A violet** (Citta, Buddhi, Manas, Ahaṅkāra); Indriya #C4725A; Citta #2A7A7A; Sthairya #4A7A5A; Ātmā **#D4A017 gold** | :131–137 | Ring 2 | BI | CONFLICTS with DS (C11) |
| HO1-16 | Breath rates: R1 none ("the ground holds"); R2 3 s (today's petal 3.5 s); R3 8 s; R4–7 9/11/13/15 s; R8 18 s; R9 4 s "always alive" | :141–146 | Mandala | BI | RESTORABLE (Wave 1 "nine breath rates") |
| HO1-17 | Spacing: 390×844; status bar 60 px; padding 20–40 px around geometry; yantra always has ≥200 px negative space | :150–153 | Layout | BI | reference |
| HO1-18 | Data contracts: device / ephemeris / Airtable (102 · 15 Nityā · 9 Avaraṇa) / on-device profile (recognition, dreams, beloved, tweaks, home location) | :161–166 | Data | DI | partially LIVE |
| HO1-19 | Target schema: Shakti; NityaDevi; Avarana; Recognition; Beloved; Encounter; ThresholdCrossing | :170–178 | Data | BI | partially SUPERSEDED |
| HO1-20 | Settled: the seven phases; principles; Saṅgha two-layer; temporal architecture; Sādhana arc (Saṅkalpa → Station → Transition → Bindu → Visarjana); Svapna voice and text; lifetime memory | :184–194 | — | OR | partially dead |
| HO1-21 | Deferred: the other six ring worlds; cluster lineages; sound beyond Ring 7; notification language; gesture timings | :196–202 | — | DI | — |
| HO1-22 | Still to surface: empty-state spec; state machine; persistence contract; final schema | :204–209 | — | DI | — |
| HO1-23 | "This is not a product to ship. It is an instrument to live with." | :215–216 | whole | DI | LIVE |

### A4 · DU `Bindu-Mandala-Handoff-II.md`, the Six Ring Worlds (May)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| HO2-01 | The ring-world standard (acceptance): (1) the interface *is* the teaching; (2) an atmosphere, not a page, riding the tokens plus one ring hue; (3) its own breath rate, except R1 ("the ground holds"); (4) a felt sub-structure without labels; (5) sound behind a discreet lower-left toggle, quiet, stoppable, started only by a gesture; (6) reverent copy; (7) a still frame plus an interactive frame | :11–19 | Ring worlds | BI | RESHAPED into Charter II §3 |
| HO2-02 | **R1 Bhūpura, the Earth-City:** 28 forces on three nested squares; outer line 10 Siddhi (work), middle 8 Mātṛkā (family), inner 10 Mudrā (body); tap a light → name/family/quality; tap a family in the legend → band illumines; tap a gate → all 28 alight plus the appreciation phrase; ground drone ~73 Hz plus a fifth; no breath; anchor copy "Thank you for the world I have walked through without knowing it was you." | :25–34 | Ring 1 world | DI | RESTORABLE (Wave 2 "mechanisms reborn") |
| HO2-03 | **R3 Anaṅga, the Smoke Lotus:** 8 bodiless warm plumes; scatter when reached for, gather in stillness; tap plume → quality; tap seed → all sound *hsauṁ*; breathy voice; 8 s breath; copy "The more you reach for her, the more she thins." ⇄ "Be still — and the bodiless longing gathers." | :36–42 | Ring 3 world | DI | RESTORABLE |
| HO2-04 | **R4 Sampradāya, the Lineage:** a 14-station garland; a transmission light travels with a stepped note; "the garland is unbroken"; tap centre to resend; tap a station → "the Nth of fourteen — received, and passed on"; 9 s; Anāhata green-gold | :44–49 | Ring 4 world | DI | RESTORABLE |
| HO2-05 | **R5 Kulottīrṇa, the Overflow:** 10 triangles in a boundary circle; touch → light spills past; centre → all overflow, boundary dissolves; "the accomplishment overflows the one who sought it."; swell; 11 s; Viśuddha gold→cream | :51–56 | Ring 5 world | DI | RESTORABLE |
| HO2-06 | **R6 Nigarbha, the Concealed:** 10 triangles hidden; a light follows the touch; naming → she whispers, then conceals ("she will not stay"); near-subliminal tone; 13 s; Ājñā **deep violet** | :58–63 | Ring 6 world | DI | RESTORABLE; hue C14 |
| HO2-07 | **R9 Praveśa ★ chosen:** press and hold to fall through self-similar yantras with the 102 names rushing past; hold past the falling → stillness → recognition: "You did not arrive. You were the arriving. Thank you for being the place I have always already arrived."; Shepard tone; 4 s. Spanda (Direction A) preserved as the alternative | :65–71 | Ring 9 | DI/OR | RESTORABLE (Wave 2 "Shepard fall") |
| HO2-08 | Sound table: R1 drone 73 Hz plus fifth; R3 ~116 Hz voice; R4 stepped; R5 swell; R6 subliminal; R9 7-octave Shepard. Gain ~0.05–0.07, lazy, toggleable; replace with produced audio natively | :75–86 | Sound | BI | RESHAPED (Charter II §3.5) |
| HO2-09 | Data contract: R4/5/6 run on designer placeholder glosses, "to be replaced, not shipped as canon"; per-ring field asks | :90–105 | Content | BI | CLOSED (R14) |
| HO2-10 | Implementation: canvas `Ring Worlds II.html`; components; rAF plus refs for continuous motion; ≥44pt; reduce-motion aware | :109–118 | Code | BI | reference |
| HO2-11 | R2 Inhabited Lotus: press a petal → she rises, the others mute, home-breath tone (root plus fifth), "she remains" on release | :136 | Ring 2 world | DI | RESTORABLE |
| HO2-12 | **"Ring 7 · Vāk Chamber"** extended from 8 to **12 Vāk-devatās**; at ≥7 voiced: "The word that healed what the mind could not reach." | :137 | Ring 7 | DI | CONFLICTS with the cards (C13) |
| HO2-13 | **"Ring 8 · Mūla Trikoṇa"**: tap a vertex → the three tones glide into one; dissolve → Bindu fundamental | :138 | Ring 8 | DI | RESTORABLE |

### A5 · `CB/Bindu-Mandala-Final-Brief.md` (28 May; the brief that built the May app)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| FB-01 | "Do not begin a phase until the prior phase passes verification with Ash. Do not write code from memory." | :19–20 | Process | BI | RESHAPED (Charter II waves) |
| FB-02 | Sacred core: "she was felt here" → "and she felt you back"; "Anything that dilutes it gets cut." | :31–34 | Recognition | OR | LIVE |
| FB-03 | Airtable ids: base app248ZTWhYJlvQj2; Mandala table tblrRwXJD0uP8HU8G; Row Type fldw33m8YqrINlvrN; choice ids; never the legacy Type fldcPbTpARaSSAEY2 | :106–129 | Data | BI | LIVE (ids) |
| FB-04 | New Shakti fields and ids: Devanagari, Iconography, Codex Portrait (polymorphic: Personal Connection on Avaraṇa rows), Etymology, Appreciation Phrase, Khaḍgamālā Position, Function, Shakti Family, Field Connection | :131–151 | Data | BI | LIVE |
| FB-05 | Nine Avaraṇa record ids; Nityā fields; 15 records; position 16 = Lalitā = Ring 9 | :165–190 | Data | BI | LIVE |
| FB-06 | Write contract field ids (Last Felt, Recognition Count, Status, Letter, Of Shakti, Felt At, Notes, Duration, Lunar Day, Moon Phase, Source) | :192–211 | Data | BI | RESHAPED (R17: events go to App Activity) |
| FB-07 | Relationship Field: "DO NOT BUILD. Out of scope entirely." | :243, :380 | Scope | OR | LIVE |
| FB-08 | Principles: home is a presence; yantra is the navigation; "The hamburger menu is the minimum concession to discoverability — one whisper in the corner."; lifetime default; reverent voice; never invent | :251–264 | All | DI | LIVE |
| FB-09 | Nine ring atmospheres: R1 warm amber, still; R2 cream and cluster, 3 s; R3 translucent smoke 8 s; R4 **cool blue-violet** crystalline 9 s; R5 **luminous green-gold** 11 s; R6 **rose-violet deep** 13 s; R7 Vāk resonant gold 15 s; R8 pure cream on black 18 s; R9 4 s | :272–282 | Mandala | DI | C14 |
| FB-10 | Five temporal states with exact values: bg, ambient gradient, petalSat, brightness, opacityMul, lotusInnerOp, triStroke, triOpacity, bhupuraColor, binduScale (newmoon 1.6), binduColor, motes (dawn 8, noon 6, dusk 9, night 12, newmoon 3) | :291–332 | Mandala time | BI | RESTORABLE (RD §4 "five time states") |
| FB-11 | Time windows: Dawn 5–8, Noon 11–2, Dusk 5–8 pm, Night 9 pm–5 am, New moon at phase <0.03 | :335 | Time | BI | gaps (C16) |
| FB-12 | TemporalMark: a single 6 px dot, colour by time, no text | :337 | Mandala | BI | — |
| FB-13 | Nine-ring geometry at d=344: BH 161/149 gate 11 #CF9443; R2 147/116/28; R3 114/91/34; R4–7 d/u 87/79 … 40/33 with stroke 0.70→0.55; MT_R 24; Bindu 22 | :343–368 | Mandala geometry | BI | RESTORABLE (full yantra) |
| FB-14 | R2 labels 7.5pt cluster-coloured; R3 labels 6.5pt at 30% ("not yet formally met") | :370–371, :680–684 | Mandala | BI | SUPERSEDED (legibility floor) |
| FB-15 | Locked scope: relationships dropped; the Well is Ash's ("Never auto-generate. Never seed. Never suggest phrases."); no streaks, gamification, social or missed-day notifications; Last Felt and Count fill from use only; no legacy Type; offline-first; "Never truncate the Codex Portrait"; empty field → show nothing | :378–387 | Scope | OR | LIVE (gamification reshaped) |
| FB-16 | Phase 0: remove the tab bar; launch into the full-screen Mandala; hamburger: three hairlines 18×1pt, 5pt apart, gold α0.45, top-right 16pt inset, 44×44 target; menu overlay #0D0508, Cormorant Light Italic 28pt, active gold, 0.3 s fade; items Mandala · Today · Well · Settings | :397–445 | Nav | BI | DONE (then evolved) |
| FB-17 | Phase 1: model surgery; ring map kp 1–28 / 29–44 / 45–52 / 53–66 / 67–76 / 77–86 / 87–98 / 99–101 / 102; `unlockedRings` UserDefaults default [1,2]; reads silent on failure | :449–539 | Data | BI | DONE; unlock SUPERSEDED |
| FB-18 | Phase 2 Detail order: header (name 34pt, etymology 12.5pt cluster α0.55, phonetic, "Pos. 14 · 102" 10pt α0.28) → Devanagari (system font, never Cormorant) → Quality → Somatic → Appreciation Phrase ("a prayer, not a field") → Iconography → **Codex Portrait** ("the soul… Render as poetry… Never truncate") → Lineage → Function → Bīja 108pt → Tattva → Field Connection → Her Moments; verification set kp examples (Sparśa, Brāhmī, Sarva-Mantramayī, Bāṇinī, Mahātripurasundarī) | :543–597 | Detail | BI | RESHAPED (go-deeper fold; library) |
| FB-19 | Phase 3 Avaraṇa Threshold: staggered reveal (0.3 s name 34pt … 5.6 s Personal Connection 15.5pt … 6.4 s button "Enter this Avaraṇa", 54pt accentRed); Ring 9 slower (2 s); unlock on tap | :601–652 | Threshold | BI | unlock SUPERSEDED; ceremony RESHAPED (acb14d6, gratitude) |
| FB-20 | Phase 4 nine-ring Mandala: SriYantraMandalaView components; locked ring → threshold; Ring 2 petal → Detail; Bindu → Silence; 9-dot ring indicator on Today; remove the hardcoded heading; temporal states | :656–718 | Mandala | BI | SUPERSEDED (3244f54); RESTORABLE look |
| FB-21 | Phase 5 Ring Worlds: R2 long-press invocation (others to 18%, gold halo blur 11 px); R3 Anaṅga reveals then dissolves; **R7 Vāk 8 Vāgdevatās** with Hz (Vāśinī 220, Kāmeśvarī 246.94, Modinī 261.63, Vimalā 293.66, Aruṇā 329.63, Jayinī 349.23, Sarveśvarī 392, Kaulinī 440), centre plays the chord staggered by 60 ms; R8 vertices Icchā #C45050 apex, Jñāna #9A8FC4 bottom-left, Kriyā #5A9A8B bottom-right, name at 76pt, "The three were never three."; R1/4/5/6/9 as atmospheric seed screens; swipe down to return | :722–767 | Ring worlds | BI | SUPERSEDED (Ruling 1) → RESTORABLE inside the zoom |
| FB-22 | Phase 6: "I feel her" writes to Airtable; status thresholds Mapped→Exploring at 1st, Active at 3rd, Embodied at 7th; advance-only; **"Remove the free-tap-to-advance… The pill is display-only."**; offline queue, "Never lose a recognition" | :771–802 | Recognition | BI | thresholds LIVE; display-only SUPERSEDED (deliberate crossing) |
| FB-23 | Phase 7 Silence write (≥1.0 s); Mauna expansion: R3 names at 108pt orbit; four captions at 7/14/21/28 s ("All of her. Here. Always." / "She has not gone anywhere." / "You have not gone anywhere." / silence) | :806–845 | Silence | BI | RESTORABLE |
| FB-24 | Phase 8 Well sync: autosave every 5 s; offline queue; NEVER generate | :849–866 | Well | BI | DONE (dirty-on-load bug later; see AR-D) |
| FB-25 | Phase 9 Nityā: tithi mapping (waxing 1–15; full moon = Lalitā; waning mirrored); a compact Nityā card above the Śakti; verification: new moon → Kāmeśvarī; full → Lalitā; day 8 → Tvaritā | :870–899 | Today | BI | DONE (Nityā of the tithi) |
| FB-26 | Phase 10 Portrait: `intensity = min(1, count/80)`; glow α 0.10+0.45i; petal α 0.18+0.78i; 7-day warmth, softening, 30-day baseline; "The Memory" in the menu; last 5 from Airtable; polish (body arms, TODAY clipping, anusvara, petal label size, bīja voice files) | :903–938 | Portrait | BI | RESHAPED |
| FB-27 | Cross-cutting: 126 records cached; 5-min refresh; silent errors; no analytics or third-party SDKs; Sanskrit needs English VoiceOver labels; state survives force-quit | :984–994 | All | BI | LIVE |

### A6 · `CB/UX-AUDIT.md` (pre-July; audits the deleted three-tab views; DA1 called it stale)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| UXA-01 | Hard fails ≤10pt and ≤0.22α: Mandala hint 9pt/0.22; Silence "Tap to return" 9pt/0.14; Silence names 11pt/0.16; Homecoming "tap to enter" 10pt/0.18; Recognition close 10pt/0.18 | :19–27 | Readability | AF | historical; class persists (AR H2) |
| UXA-02 | Lotus petal labels ≈7.2pt (`diameter*0.021`) at α0.38 name the primary navigation | :35, :50 | Mandala | AF | historical |
| UXA-03 | Dead-end risk: faint hints on Silence, Homecoming and Recognition; swipe-back disabled on Detail and LetterEditor | :81–85 | Nav | AF | AR H3: no dead ends at HEAD |
| UXA-04 | Recognition can be dismissed mid-ceremony (0–4 s) after the log is already written | :76, :151 | Recognition | AF | fixed (nameVisible guard; AR H3) |
| UXA-05 | Status pill has no affordance; the status model is undiscoverable | :145, :213 | Detail | AF | resolved by crossing pill |
| UXA-06 | `LotusMandalaView.shakti(at:)` crashes on an empty array | :118, :155 | Mandala | AF | moot (view deleted) |
| UXA-07 | Empty states: Today spinner forever; empty somatic shows `""`; empty bīja dash | :111–115 | Today | AF | resolved by degradation guards (AR B3) |
| UXA-08 | "Today's 'I feel her' red capsule is the only saturated red CTA in the entire app… Don't dilute it elsewhere." | :212 | Today | AF/DI | LIVE as advice (Wave 1 puts her hue in the pill; watch this) |
| UXA-09 | Recommend 3 spatial tabs plus modal ceremonies; re-decide swipe-back; empty-state polish | :217–226 | Nav | AF | superseded |

### A7 · DU `Bindu Mandala - Design Audit.html`, "From My Eyes" (May 2026, build `0bd9542`)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| DA1-01 | The build grew from one avaraṇa, sixteen petals and three tabs to "the whole nine-ring Śrī Yantra… and it kept its soul"; the problem is abundance | L289 | whole | AF | context |
| DA1-02 | Tokens exact hex-for-hex; type three-register system honoured; "It never once becomes a wellness app" | L309, L314, L319 | Theme | AF | praise; keep |
| DA1-03 | **Best move:** the time-of-day variant system (dawn/noon/dusk/night/new moon; at new moon petals desaturate to 30% and the Bindu swells 1.6×) | L331 | Mandala | AF | RESTORABLE (deleted with the held yantra) |
| DA1-04 | **The Veil as navigation** is "thematically exact"; the held yantra dims behind the sheet; the closed handle breathes a chevron | L336 | Nav | AF | RESTORABLE (Wave 2 "the Veil"; RD §4 Veil/Legend) |
| DA1-05 | The ring worlds are each "a complete small meditation" | L341 | Ring worlds | AF | RESTORABLE |
| DA1-06 | Writing voice and Portrait praised ("the yantra rendered as a mirror of your own attention") | L346 | Portrait | AF | LIVE |
| DA1-07 | "The work from here is editing, not adding." | L350 | — | AF | RESHAPED (Charter II: fuller) |
| DA1-08 | Call 1, the daily spine vs the museum: "Decide, on purpose, what opening the app should put in front of you." | L360–361 | Launch | AF | see C1 |
| DA1-09 | Call 2: the status pill looks like a button but is display-only; pick a plain state **or** a deliberate gesture | L366–367 | Detail | AF | resolved: crossing gesture |
| DA1-10 | Call 3: Detail is "tipping toward encyclopedia" (≈12 sections; codex portrait 7th); lead with portrait and somatic; "go deeper" fold | L372–373 | Detail | AF | DONE (go-deeper); then Homes library |
| DA1-11 | Call 4: two hidden doors; give the hamburger a first-run breath | L378–379 | Nav | AF | DONE (`hamburger_first_run_seen` on device) |
| DA1-12 | Call 5, legibility table: petal labels ~7.5pt/0.38; Silence stars 10–11pt/0.11–0.16; Ring 1 hint 8.5pt/0.40; tracked captions 9pt/0.4–0.55; decide **label or texture**; if label, ≥11pt and ≥0.3α | L384–394 | Readability | AF | RESHAPED (FIDELITY ≥0.5α) |
| DA1-13 | Smaller: Bindu breath unified as a language, "slower the deeper you descend" (4 s yantra / 2.25 s Veil / 6 s Silence / still in Portrait) | L402 | Motion | AF | open (RD §9 paradox "one clock and many tempos") |
| DA1-14 | Smaller: the Mandala nav plumbing is straining (sheet vs cover vs push) | L403 | Nav | AF | — |
| DA1-15 | Smaller: retire the stale UX-AUDIT | L404 | Docs | AF | — |
| DA1-16 | "Protect the daily gesture before anything else" | L413 | Today | AF | LIVE |

### A8 · DU `Bindu Mandala - Refinement Brief.html` (build `0bd9542`)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| RFB-01 | Part I restates the five calls; "None are bugs — they're decisions the app has drifted into"; Part I needs Ashrey's decision before code | L141, L188, L270 | — | AF | — |
| RFB-02 | Shared touch fix: grow each energy's hit area to ≥44pt and scale figures up | L193 | Ring worlds | BI | SUPERSEDED (worlds cut) → applies to any reborn mechanism |
| RFB-03 | **R1:** 26pt targets; 28 lights with the inner square ~144pt holding 10; fix with ≥44pt contentShape, enlarged squares, nearest-light resolution | L198–200 | R1 world | AF/BI | SUPERSEDED / RESTORABLE |
| RFB-04 | **R3:** three regressions: `.brightness(0.15)` vs CSS `brightness(1.5)`; no DustMotes(7); gradient ends at 92 against plume 116. Restore the ladder active→unified→gathered→scattered (glow 1.0/0.9/0.55/0.30), `.blendMode(.screen)` | L207–210 | R3 world | AF/BI | RESTORABLE — note this is the same *port-loss* class RD §2.3 names |
| RFB-05 | **R6:** 32pt targets; reveal gate `distance <= revealRadius` plus the light following the finger make three precision tests; relax the gate (any `near > 0.3`), widen orbit 96→~120 | L225–227 | R6 world | AF/BI | RESTORABLE |
| RFB-06 | **"Ring 8" (file RingSeven), the Vāk Chamber:** 12 voices at 45° → voices 9–12 (Vāṅmayī, Onmādinī, Mantreśī, Śaktimayī) sit on 1–4; fix with 30° or a second outer ring; confirm the world↔number mapping | L234–242 | Vāk | AF/BI | RESTORABLE; numbering C13 |
| RFB-07 | **R9:** remove the `personalConnection` text appended after r>0.6; end on "You did not arrive. You were the arriving." plus the gold benediction, "and then nothing. The silence after is the point." | L250–253 | R9 descent | AF/BI | LIVE as an intention for any reborn Praveśa |
| RFB-08 | Suggested order: minutes (R9, R8) → afternoon (R1, R6) → session (R3) → Part I decisions | L267–270 | — | BI | historical |

### A9 · DU `Bindu Mandala - Master Build Brief.html` and DU `Bindu Mandala - Claude Code Brief.md`

These are the same brief in HTML and in markdown. The `.md`'s H1 reads "Master Build Brief". Line refs are `.html` L / `.md` :.

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| MBB-01 | Practitioner is single ("Ash's own instrument"); governing idea "Time is the medium"; governing rule "Readiness is sensed; crossing is chosen… Never auto-advance." | L118–121 / :5–7 | whole | DI/OR | RESHAPED (RBB: rule applies to embodiment, not descent) |
| MBB-02 | Six principles: interface is the teaching; atmosphere not page ("never introduce new colors"); she is felt, not measured; readiness sensed, crossing chosen; the floor (≥44pt; read text ≥11pt and ≥0.3α); respect the breath (reduce-motion; persist place) | L143–148 / :28–35 | All | DI | RESHAPED (Charter II; α0.5 per FIDELITY) |
| MBB-03 | Repo orientation: content fully authored only for the 16; Rite launches on the 16; Descent gates on content | :63 | Data | AF | SUPERSEDED (R14: all 102 authored) |
| MBB-04 | 1.0: `enum Hit { static let min: CGFloat = 44 }`; "Fix the class, not the instances." | L155 / :71–77 | Touch | BI | LIVE as a principle (method §4) |
| MBB-05 | 1.1–1.5 ring repairs as in RFB with Done-when criteria (R9 ends in silence; twelve Vāk legible; every R1 light hit first try; R6 names reliably; R3 plume visibly glows; "Compare side-by-side with Ring Worlds II.html → Ring 3") | L157–202 / :81–150 | Ring worlds | BI | SUPERSEDED (Ruling 1) |
| MBB-06 | Phase 2 migration: RecognitionEntry gets `khadgamalaPosition` 1–102 plus `ringNumber`; lossless; all existing Ring 2; update writers and readers; "the archive belongs to her" | L208–223 / :154–177 | Data | BI | DONE (RecognitionMigrator) |
| MBB-07 | Daily Rite: today's Śakti from the lunar assignment scoped to descended rings; moon and tithi hushed; encounter order name → phonetic → quality → hairline → somatic → location/bīja at the DS size scale; one full-width "I feel her" pill (deep red on cream, medium haptic); reciprocity "Logged · [time]" → "And she felt you back · [time]"; lights a Portrait point; optional note | L229–242 / :185–193 | Today | BI | lunar SUPERSEDED; rest DONE/RESHAPED |
| MBB-08 | Daily whisper: one local notification a day at a chosen hour, **default early evening**; copy "She is waiting." / "Someone in the field would like to be felt today."; no count, streak or badge; skip or soften if the rite is done; Settings toggle on by default | L244–250 / :195–201 | Summons | BI | RESHAPED (shipped default 6 am; C17) |
| MBB-09 | Done when: "Opening the app lands on (or one deliberate tap from) today's Śakti and the gesture; 'I feel her' logs and lights a point; at most one tender summons…" | L250 / :201 | Today | BI | DONE |
| MBB-10 | Calls woven in: Rite as launch destination; status crossing as a deliberate tap/ceremony from Detail (or strip the button styling); Detail hierarchy plus go-deeper; hamburger first-run breath; legibility pass (petal labels → ≥11pt/0.3α) | L258–263 / :209–213 | Multi | BI | DONE in July |
| MBB-11 | "Everything above makes the app whole. Everything below makes it monumental." | L266 | — | DI | — |
| MBB-12 | Descent: `DescentState` (currentRing, deepestReached, crossings[], enteredCurrentAt); Veil as a ladder; the next ring is a breathing threshold; crossing by press-and-hold or worded invitation; readiness hinted by dwell; content gates the path ("not yet — she is still becoming words"); daily Śakti follows the descent | L271–286 / :217–238 | Descent | BI | gating SUPERSEDED (Ruling 2); DescentState DONE as memory |
| MBB-13 | Threshold ceremony (md only): the held yantra dims; the current ring completes and dissolves inward as the next rises; the invitation fades up; the tone shifts one interval; one haptic; record the crossing date | :240–246 | Descent | DI | RESTORABLE ("Gates of Release", Wave 2) |
| MBB-14 | Portrait: 102 points brighten with felt count and warm with recency (TimeVariant warmth); a second home; one gesture from the Rite; "No numbers, no percentages — the image itself is the only measure… showing, never counting." Done when every felt moment lights its correct point, with not one number on screen | L292–300 / :250–261 | Portrait | BI | DONE (PR-6/9); WAVES: Portrait as Living Mandala |
| MBB-15 | Stretch (md §9): widget; descent film; exportable Portrait ("no app branding, no numbers"); deepening ring drone; a true timed Silence logged `.silence` | :265–275 | Stretch | DI | film and export DONE; widget parked; drone superseded by carrier then RESHAPED (Charter II sound everywhere); Silence → R11 |
| MBB-16 | PR sequence PR-1…PR-8+ | :279–288 | Process | BI | historical |
| MBB-17 | Definition of done: "It is a practice you are inside of… with not a number anywhere, because *she is felt, not measured*." | :292–296 | whole | DI | RESHAPED (numbers may describe her) |

### A10 · DU `Bindu Mandala - Audit II.html`, State of the App (July 2026)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| DA2-01 | "What's missing is presence at scale… 102 distinct energies currently receive one identical, small, centered treatment… faithful to its tokens and unfaithful to its premise: that she arrives differently every day." | L148 | whole | AF | led to six archetypes |
| DA2-02 | **High, scale crisis:** 9–12px tracked labels; body 13.5–16; Detail name 34px; tracking 2.0–3.2 at 10px harms legibility; "A devotional app read at 6am in bed needs display sizes" (DailyRiteView, ShaktiDetailView, TheHundredTwoView, Portrait header 11px) | L160–161 | Type | AF | partially addressed (Phase 4 felt register) |
| DA2-03 | **High, one atmosphere for 102:** same ground #0D0508, same crimson radial at 38%; "ring geometry, element, cluster, bīja — is unused as a design input" | L169–170 | Today | AF | DONE (Atmosphere engine) |
| DA2-04 | **High:** screens share tokens, not composition; cluster colour appears only as 5–7px dots | L178 | All | AF | partially addressed |
| DA2-05 | **Med:** system sans at 9–11px reads as "UI debris" | L187 | Type | AF | open (ARD-also: sans slips on quality description and Settings title) |
| DA2-06 | **Med:** Detail buries its soul; codex at 16px italic; Devanagari (44) outranks the name (34) | L196 | Detail | AF | RESHAPED → Homes |
| DA2-07 | **Low:** the Nityā card (17px) is cramped between moon and name | L205 | Today | AF | celestial strip |
| DA2-08 | **High, Today is a dead end:** her name does nothing; requested fix: tap her name to open her detail | L218–219 | Today | AF/OR | DONE ("know her ›", name opens Presence) |
| DA2-09 | **Med:** The 102 gives no sense of place (one flat list) | L227 | Field | AF | partially (ring accordions) |
| DA2-10 | **Med:** menu order is accidental; Settings sits before Memory; the menu should express arrive → feel → remember | L236 | Menu | AF | C9 accepted (Settings last) |
| DA2-11 | **Low:** unexplained boundaries (the Well only for 16; ceremonies cannot be revisited; Portrait wordless) | L245 | Well/Portrait | AF | Well → 102 (Phase 2.1) |
| DA2-12 | **Direction, The Living Rite:** (1) "She arrives differently every day": ring geometry is the ground; element drives the air (fire rises, air drifts, water settles); hue threaded through every screen until 6 am; deterministic per date. (2) "Scale is reverence": name 56–72px; body 18–22; labels ≥12–13. (3) "One thread through every room": the day's hue and sigil persist across Detail, Field, Well and menu. (4) "Her name is a door"; the 102 as a descent | L253–272 | Rite + all | DI | (1) DONE; (2) open (C9); (3) Wave 1 "menu and sheets lit by the day"; (4) DONE/partial |
| DA2-13 | The interactive prototype "The Living Rite" demonstrates the four principles | L275 | — | DI | reference (the R2 prototype) |

### A11 · DU `Bindu Mandala - Final Handoff.md` (= R2 `DESIGN_SPEC.md`), the Living Rite

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| FH-01 | Supersedes `Claude Code Brief.md`, `Bindu-Mandala-Handoff.md` and `-Handoff-II.md`; "Where they conflict, this wins." | :9 | — | DI | itself superseded by RBB |
| FH-02 | Two artifacts: the native app and the reference prototype, which is "the design source of truth for everything in §2… encodes hundreds of small decisions (composition, timing, easing, atmosphere)" | :15–18 | — | DI | LIVE (look, motion, behaviour per RBB §0) |
| FH-03 | Principles 1–6 (as MBB) | :26–33 | All | DI | RESHAPED |
| FH-04 | Module map: core (engines), today (six archetypes), detail, mandala, field, more (thresholds and letters), app (router plus `lr_nav`); ios-frame and tweaks are not ported | :41–50 | — | BI | reference |
| FH-05 | "Nothing in this app is a static screen. Every surface is generated from the Śakti herself — her ring, cluster, tattva/element, and the hour of day." | :52 | All | DI | LIVE (Charter II §3.1 room test) |
| FH-06 | 2.1 Atmosphere: one hue seed (Ring 2 from cluster `LR_CLUSTER_HUES`; others `LR_RING_HUES`); `lrJitter(kp,14)`; element from tattva or `LR_RING_ELEMENTS` (1 earth, 3 air, 4 water, 5 fire, 6 ether, 7 air, 8 fire, 9 light); derived glow/ground/groundDeep/accent family; "**Do not hand-pick colors per screen.**"; `lrBackdrop` places the light per element (fire low, water pooled, air high-asymmetric, ether pervasive, earth grounded, light central) | :54–64 | Theme | BI | DONE; backdrop layers lost in port (RD §2.3) → Wave 1 restore |
| FH-07 | 2.2 Time relighting: dawn warms and violets; noon clarifies and cools; dusk deepens; night darkens and saturates; shifts hue, luminance, saturation, glow, ground and mote density; dawn 5–9, noon 9–16, dusk 16–20, night otherwise; thread through every atmosphere consumer | :66–70 | Time | BI | DONE (deltas); C16 |
| FH-08 | 2.3 Day cycle: prototype seeded shuffle with the day boundary at −6 h; "keep the native one" (lunar); match moon math | :72–75 | Today | BI | SUPERSEDED (Ruling 3 chose the shuffle) |
| FH-09 | 2.4 Six archetypes: fire = ascension ("she rises"), water = descent ("she settles"), air = horizon ("she drifts"), ether = veil ("her name *is* the vast backdrop"), earth = foundation ("she grounds"), light = radiance ("name held *inside* a dominant living sigil"); shared block list; per-kp jitter (lean, sigil spin/scale, name tier, gradient angle); "Port the six archetypes as six SwiftUI layout branches"; one constant "I feel her" pill | :77–92 | Today | BI | DONE (d5fdeb6); RD: air-lean and staged arrival lost → Wave 1 |
| FH-10 | 2.5 Detail: soul first (name, quality, somatic, ring-geometry hero spinning, element-lit); embodiment track Mapped→Exploring→Active→Embodied with readiness against [0,1,3,7] and **crossing by deliberate press-and-hold**, persisted per kp; bīja below the fold; "go deeper" | :94–101 | Detail | BI | DONE |
| FH-11 | 2.6 Recognition ceremony: a full-screen takeover responding in her nature (fire flares up, water pools, air disperses, ether blooms once, earth settles slowly, light radiates); 1 "She was felt here · [time]" → 2 held beat → "and she felt you back · [time]" → 3 optional note (tapping it never dismisses) → 4 collapse inward (`lrCollapse`) into the Portrait | :103–112 | Recognition | BI | partially DONE; RD: six natures flattened to one breath → Wave 1 |
| FH-12 | 2.7 Living Mandala: semantic zoom cosmic → mid → seat; fly-to-seat guarded by `moved`; constellation threading (Ring 2 by cluster, others by ring; family lit, others dim to ~28%; "threaded to N sisters · [family]"; non-scaling strokes); Bindu → Lalitā descent (red point blooms to fill the screen, Lalitā / Mahātripurasundarī "Ninth Āvaraṇa · The Bindu", 102 as a returning field, words rise in slow stagger "remembering, not loading", exits "↑ return to the field" / "enter her presence", `animating` guard, auto-descent on deep zoom near centre); ring-entry chimes (deeper rings lower; one-directional; opt-in, `lr_sound` default **off**) | :114–123 | Mandala | BI | DONE (3244f54); RD: red bloom and gates lost → Wave 1 |
| FH-13 | 2.8 Field (calm grid lit by atmosphere); Well (private notes, first-line previews, local-only); Portrait ("Not a stats screen"); audio: `lrPlayBija` 3.6 s drone and `lrRingChime` 1.7 s bell, kept distinct | :125–131 | Field/Well/Portrait | BI | partially DONE |
| FH-14 | Phase 1 repairs with `enum Hit`; Done when all nine worlds hold the bar | :139–140 | Ring worlds | BI | SUPERSEDED (Ruling 1) |
| FH-15 | Phase 2 migration (as MBB-06) | :142–143 | Data | BI | DONE |
| FH-16 | Phase 3 Daily Rite plus `Services/DailySummons.swift` ("She is waiting."; no count, streak or badge); calls woven in | :145–146 | Today | BI | DONE |
| FH-17 | Phase 4 Descent: DescentState; Veil ladder; content gate `contentReady(ring:)` (all that ring's Śaktis have somatic and recognitionPhrase); Bindu → Lalitā as the finale | :148–149 | Descent | BI | gate SUPERSEDED (Ruling 2) |
| FH-18 | Phase 5 Portrait: "No numbers, ever" | :151–152 | Portrait | BI | DONE; law RESHAPED |
| FH-19 | §4 Reaching further: a continuous ring drone; a home-screen widget; the descent as a remembered film; plus the exportable Portrait and a timed Silence | :156–164 | Stretch | DI | film DONE; drone → carrier → Charter II; widget parked |
| FH-20 | PR sequence PR-1…PR-10+ | :168–179 | Process | BI | historical |
| FH-21 | Definition of done: "opens to *her*… the way inward has an order, a sound, and a destination — the Bindu, where Lalitā waits — that you cross by choice…" | :183–187 | whole | DI | LIVE in spirit |

### A12 · R2 `README.md`, the Living Rite handoff

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| R2R-01 | The prototype is "not production code to copy — it is the source of truth for *look, motion, and behavior*… match the values, not the HTML." "**Fidelity: high.**" | :20–35 | — | DI | LIVE (Charter II "Design is the floor") |
| R2R-02 | Run over HTTP (`python3 -m http.server`); state persists in `lr_*` localStorage | :41–52 | — | BI | reference |
| R2R-03 | File map; `_superseded/all-shaktis-data.js` is still loaded for `AVARANAS` metadata only; "never diff against it" | :56–74 | — | BI | LIVE |
| R2R-04 | Engines: `lrAtmosphere`, `lrElement`, `LR_ARCHETYPE_BY_ELEMENT`, `lrTimeVariant`/`lrApplyTime`, `LR_STATUS`/`THRESH`, `LR_RECOG`, `lrPlayBija`/`lrRingChime` ("each of the 8 enclosures rings a bell that *descends*… gate behind the sound toggle"), `lrTodaysShakti` (6 am) | :80–102 | Engine | BI | reference |
| R2R-05 | Screen index (Today; Her Presence; Recognition with six "felt back" motions; Mandala; Field; Well; Memory; Threshold/Letter) | :108–126 | — | DI | parity list |
| R2R-06 | Tokens: ground #0D0508; page backdrop #161013; gold #C9963F; cream; cluster hues (inner h43 s78 l52, tanmatra h13 s47 l56); `LR_SAFE_TOP = 54`; legibility ≥11pt and ≥0.3α; reduce-motion | :132–143 | Theme | BI | LIVE (α reshaped) |
| R2R-07 | Approach: run it; read core end to end; Atmosphere and TimeVariant first, then Rite, Detail/Recognition, Mandala/Descent, Portrait; "she is felt, not measured… no numbers on the Portrait" | :154–163 | — | BI | RESHAPED |

### A13 · R2 `RECONCILED-BUILD-BRIEF.md` (July; Rulings 1–8 sealed with Ash)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| RBB-01 | "Single source of truth for the rebuild"; supersedes R2 README and DESIGN_SPEC; "when this brief and the shipped code disagree, treat it as a bug in this brief and reconcile up to the code" | :3–8 | — | OR | SUPERSEDED as roadmap by BV2 (Rulings stand, per BV2 header), then reshaped by Charter II |
| RBB-02 | Governing rule amended: readiness/crossing applies to status and embodiment; "It does **not** gate the descent: the instrument is fully open"; "She is felt, not surveilled" | :11–13 | — | OR | LIVE |
| RBB-03 | **Ruling 1:** the semantic-zoom Mandala replaces the nine worlds; they survive as Field rows; Round 2 Phase 1 repairs cut | :24 | Mandala | OR | RESHAPED (RD/WAVES: mechanisms reborn *inside* the zoom or Homes, honouring Ruling 1's reason) |
| RBB-04 | **Ruling 2:** the open instrument is permanent; delete the `.threshold`/`.becoming`/`.unseen` hold-to-cross machinery in VeilView; DescentState is memory only | :25 | Descent | OR | LIVE as "open"; Veil/Legend RESTORABLE as status light (no gate) |
| RBB-05 | **Ruling 3:** the all-102 shuffle (`DailyEnergyService`) is canonical; strike lunar | :26 | Today | OR | LIVE |
| RBB-06 | **Ruling 4:** Airtable sync plus the App Activity ledger govern; "private-facing, not surveilled"; `serverRecognitionCount` is the readiness source | :27 | Data | OR | LIVE (R17 extends) |
| RBB-07 | **Ruling 5:** six archetypes; retire `.body`/`.bija` and `today_variant_raw` | :28 | Today | OR | DONE |
| RBB-08 | **Ruling 6:** element from a per-ring table; Ring 2 from tattva | :29 | Theme | OR | DONE |
| RBB-09 | **Ruling 7:** graceful degradation for the 86 (suppress cluster, poem as invitation, hide empty phonetic); author content later | :30 | Content | OR | content part CLOSED (R14); guards stay; RD: phonetic field and somatic prose still absent for the 86 |
| RBB-10 | **Ruling 8:** mirror `DescentState.crossings` to Airtable | :31 | Data | OR | DONE (now as `Ring Crossed` in App Activity, R17) |
| RBB-11 | §2.1–2.5 engine foundation: Atmosphere.derive pure and testable; element; TimeVariant as deltas, **keep `newmoon`** (5 states); schema safety guard first; kp-ordering verification | :53–81 | Engine | BI | DONE |
| RBB-12 | §3.1 Rite: name 44–48 / quality 20–22 / somatic 18–20; one "I feel her"; 86 degradation | :87–95 | Today | BI | DONE |
| RBB-13 | §3.2 Detail embodiment from `serverRecognitionCount`; press-and-hold; bottom "I feel her" (source `.mandala`) stays | :97–104 | Detail | BI | DONE (RD: Detail always reports `.mandala`, a defect to fix) |
| RBB-14 | §3.3 Ceremony: "felt back" phrase chain `recognition` → `appreciationPhrase`; writes and syncs | :106–113 | Recognition | BI | DONE |
| RBB-15 | §3.4 Mandala: fly-to-seat, threading, Bindu→Lalitā, chimes default off; **auto-descent decision: recommend a chosen tap** (honours never-auto-advance) | :115–126 | Mandala | BI/OR | built per code; LIVE question |
| RBB-16 | §3.5 Field holds the nine worlds now; Portrait "No numbers, ever." | :128–132 | Field | BI | RESHAPED |
| RBB-17 | §5 Doc hygiene: DESIGN_SPEC = Final Handoff, delete one (done 2026-09-07, Final Handoff deleted in the repo; **the DU upload still carries both**); prototype entry is `index.html`; field remaps (`short`→`shortName` etc.); "Eight modules" undercounts | :146–153 | Docs | BI | DONE in repo |
| RBB-18 | Definition of done: "the Mandala is one continuous space you fall through to the Bindu where Lalitā waits… with not a number anywhere" | :168–171 | whole | DI | RESHAPED |

### A14 · R2 `KP-ORDERING-FINDINGS.md` (PR-0, July)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| KP-01 | Verdict: NOT ALIGNED; engines seed off the stored `khadgamalaPosition`, never prototype `pos` | :7 | Engine | AF/OR | LIVE (position is identity) |
| KP-02 | Ring divergences: R1 swaps (Laghimā/Mahimā, Icchā) plus 18 name differences; R7 name set differs substantially (Airtable has the weapon-śaktis); R8 Vajreśī spelling; R9 aligned | :12–21 | Data | AF | LIVE fact |
| KP-03 | "Airtable is the source of truth for names/content of the 86 — the prototype is NOT." | :29–35 | Data | OR | LIVE |
| KP-04 | `Descent Ring` field created (fld225xgYl2Rs3TP6); the `Crossing` option is created via `typecast: true` | :38–46 | Data | BI | RESHAPED by R17 (App Activity `Descent Ring` fldi7SOuep57UoXzi) |

### A15 · DU `uploads/bindu-mandala-master-brief.md`, the Experience Architecture (August; CC copy adds the 7 Sep errata header and an §10 paragraph)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| XMB-00 | (CC copy only) Errata header: §9's three rare moments are superseded by the proximity/focus rule; §5's drone is superseded by the per-Śakti carrier; §7 layer 1 postural forms are superseded by Law 4 (aniconic); `descent-experience-architecture.md` was never delivered | CC master-brief:5 | — | OR | LIVE, though §5 is reshaped again by Charter II |
| XMB-01 | Nine-layer signature table (phase, shape, chakra, element, Mudrā verb AGITATE/LIQUEFY/DRAW/OPEN/VOICE/STILL/WITNESS/SEED/ARRIVE, body anchor, mental state); **lists R7 "Triangle (8)" and R8 "Triangle (1)"** | :17–27 | All rings | DI | LIVE vocabulary; counts C13 |
| XMB-02 | Descent: four constants that never reset (Bindu anchor, one pulse, sound as glissando, depth-trail); passage via three depth layers at different speeds, geometry swelling past the frame, continuous holdable velocity, compounding scale on `MandalaCamera` tiers 0/1/2 | :39–41 | Descent | DI | RESTORABLE / Wave 2 |
| XMB-03 | Ring interior: an arrival beat naming the Presiding Form once (Tripurā … Mahātripurasundarī); a collective gesture (hold off-seat → the ring breathes together as its Mudrā verb); legibility of the collective gesture graded by Yoginī class (obvious at R1, barely perceptible at R7–9) | :47–53 | Mandala ring | DI | open → Wave 2/3 |
| XMB-04 | Activation cycle: four beats over ~2–3 min (Knowledge → Will → Action → Reciprocal response and close); six gesture families (fire held pulse; water slow pour; air breath-timed; earth press and still; ether absence; light precise tap); "never a failure state, never scored"; close by a Well line or a dissolve into a lit Portrait point | :59–74 | Per-Śakti | DI | open (WAVES "Rite as six stations" is a different but adjacent idea) |
| XMB-05 | Continuous sonic environment: a drone at the ring fundamental, bending with camera position; element sets timbre (earth gritty pad … light pure sine); bīja rides on top; full harmonic richness only at the reciprocal response; behind `soundOn` | :80–87 | Sound | DI | SUPERSEDED (BV2) → RESHAPED (Charter II: sound everywhere) |
| XMB-06 | Recognition deepened: the two lines unchanged ("non-negotiable canon"); ripple shape responds privately to linger time; "she felt you back" pairs with a richer bīja tone | :93–96 | Recognition | DI | LIVE / open |
| XMB-07 | Finding: six ring shapes carry 102 (`RiteSigil` per ring; `RingGlyph` gives rings 4–7 one icon); the `Iconography` field (fldXJEBCQxLdHWGuP), written for all 102, drives nothing | :102–106 | Rite/Mandala | AF | partially (Homes attribute) |
| XMB-08 | Iconography grammar: four layers (6–8 silhouette archetypes, **superseded: aniconic**; 15–20 attribute glyphs; colour treatment from her colour words; motion quality) | :112–123 | Seats | DI | attribute layer DONE in Homes; silhouettes dead |
| XMB-09 | Bindu on every screen as "the watching point", small and constant; grows only at true ring-9 arrival; ripples converge into it; never a crisp, measurable circle | :129–137, :163 | All | DI | open (Feed's single BinduParticle cited in RD §5) |
| XMB-10 | VFX only on three moments (felt-back, Bindu arrival, activation climax) | :143–151 | Render | DI | SUPERSEDED (proximity/focus; then Charter II "light stands in the air") |
| XMB-11 | Codex pass: nine Siddhis per ring (Aṇimā … Icchā-Prāpti-Mukti); action recedes with depth (C-1307); never-measure from C-1195/1284/1286, with Recognition Count never displayed; the Zero Gap chrome-density gradient (labels at R1, none at R9); crawling haptic for R1/earth (C-1170); never scarcity-framed, so DailySummons stays an invitation (C-1169); collective gesture deepens privately (C-1274) | :159–171 | All | DI | mostly LIVE; display law RESHAPED |
| XMB-12 | (CC copy) Entering-ceremony compression: factor 1.0 first, then `max(0.36, 0.68^min(visits,4))`; head start 0 under 12 s, else `min(dwell×0.55, 221 s)`; never displayed | CC master-brief:168–169 | Homes | BI | DONE (HomeMemory) |
| XMB-13 | Throughline: one taxonomy (element) in four bodies (Today, ring atmosphere, gesture family, drone timbre); "everything… should get quieter, not louder, as it goes deeper" | :179–189 | All | DI | RESHAPED (Charter II fuller; RD §9 paradox) |

### A16 · CC `bindu-mandala-expansion.md` (44 ideas)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| EXP-00 | Avaraṇa table of gem / dhātu / time cycle / beeja / body region for all nine, "never rendered" | :11–21 | Data | AF | LIVE; RD: typed into Swift, not read live (Wave 0) |
| EXP-01–15 | Homes ideas: a place, not a page; lit through her gem; built from her dhātu; a real clock per ring (R1 day–night … R9 Kāla–Akāla); the inscription; the name written stroke by stroke; the etymology breaking and remaking; tuned to her bīja; gravity per somatic; remembers without counting; the letter as an object; the portrait at the pace of stillness; doors and corridor; the Siddhi after-effect; Personal Connection marginalia on the walls | :29–57 | Homes | DI | BV2 Phase 6: "Built by the Homes"; RD: letter object, after-effect, corridor, traces "composed but displayed nowhere" → Wave 1/2 |
| EXP-16–25 | Rite ideas: six stations; dawn and dusk as different rites; co-presiding Nityā; a 102-day liturgical year; tempo matching; can't be rushed; sometimes she doesn't dance; ends outward (C-1330); same-day return continues; Śarad Navarātri | :63–81 | Rite | DI | Design-first queue (BV2 Phase 6) |
| EXP-26–38 | Mandala ideas: breathes as one body; lit from the Bindu (#27, "the most consequential single visual change"); made of light, not lines; the ascent as its own passage; veiled by secrecy (mist); the fall speaks the mantra; her seat carries her form; diurnal; the moon's ring; Portrait as night sky; each ring a weather; sound has altitude; Tratak (C-1222) | :87–111 | Mandala | DI | 27/28/30/31/32/38 → Phase 5 (built per RD §1) |
| EXP-39–44 | Systems: the body map (BodyOutlineView seed); walk the mālā; the watching point dreams; a nightstand lamp; Siddhi as instrument state; seasons of the rings | :117–127 | Systems | DI | queue |

### A17 · Homes package: DU `uploads/homes-design-package.md` (= CC, = R2 `homes/source/`)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| HDP-01 | Process: Chat (architecture) → Design (visual craft, sample before batch) → Code (against ShaktiDetailView and Atmosphere); "Then the same loop for the Mandala. Then the Systems." | :9–15 | Process | DI | LIVE pattern |
| HDP-02 | Design can't see Airtable, the app or the Codex; device screenshots help most | :17 | Process | DI | — |
| HDP-03 | What a home is: **Entering** (appreciation phrase spoken once; Devanagari written stroke by stroke; etymology splits and recombines; "never skipped, never lingered on"); **Dwelling** (gem light, dhātu material, ring clock, bīja tuning, gravity toward her body place; portrait line by line at the pace of stillness; Well letter as a folded object; returns remembered as light and depth, "never as a number"); **Library** (Detail kept, folded); **Doors** (circle of neighbours, walkable without the Mandala); **Leaving** (Siddhi as a felt after-effect over minutes, "Never named") | :23–33 | Homes | DI | LIVE (Wave 1/2 complete the missing parts) |
| HDP-04 | Nine ring-worlds table: presiding form, phase, shape, gem, dhātu, clock, beeja, body region, chakra, mental state, Yoginī, Mudrā verb, Siddhi, element | :41–51 | Homes worlds | DI | LIVE data |
| HDP-05 | Keep existing hue tokens per ring (Atmosphere): 1 amber 35°, 2 gold 43° (cluster-varied), 3 rose 341°, 4 crimson 353°, 5 coral 18°, 6 teal 194°, 7 wine 322°, 8 red 2°, 9 white-gold 46°. Keep and extend per-ring sound | :53 | Theme | BI | LIVE (C14) |
| HDP-06 | Uniqueness grammar: Quality → the room's soul; Function → mechanism; Somatic → physics; Location → altitude and gravity; Iconography → form, posture, attribute, colour; Tattva → element modifier; Bīja → tuning; Etymology → threshold ritual; Phrase → inscription; Devanagari → the unseen hand; Cluster (R2) → shared corridor; Family → lineage register | :63–76 | Homes | DI | LIVE (R9 four-channel engine plus refinement) |
| HDP-07 | **The test: "could this room belong to any other Śakti? If yes, it isn't finished."** Laghimā must lift, Garimā must press; a stranger should tell them apart without a name | :78 | Homes | DI | LIVE (Charter II §3.1) |
| HDP-08 | Prompts P0 (architecture), P1–9 (worlds, Ring 2 first), P10 (the sample gate: two homes), P11 (batch by ring; Ring 1 by family), P12 (endless refinement; Ring 9 first: "there was never anyone here but Her") | :86–126 | Design | BI | done on the design side |

### A18 · The 102 cards: DU `uploads/homes-shakti-cards-rings-1-2.md` and `-3-9.md` (= CC = R2 source)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| CRD-01 | "Every field is real, from the Airtable base… this is the data." Field key as in HDP | 1-2:3–5; 3-9:3 | Content | DI | LIVE (canon for names) |
| CRD-02 | Ring 1: Siddhis 1–10 (Aṇimā, Mahimā, Laghimā, Garimā, Īśitva, Vaśitva, Prākāmya, Bhukti, Icchā, Prāpti); Mātṛkās 11–18 with bīja rows (Brāhmī Aṃ … Mahālakṣmī Aim); Mudrās 19–28 | 1-2:9–239 | Ring 1 | data | LIVE |
| CRD-03 | Ring 2 (29–44) with own tattva per Karṣiṇī; cross-mapped organs (Rūpa↔Śrotra, Rasa↔Tvak, Gandha↔Cakṣus; Śarīra↔Manas "THE KEY PAIRING"); bīja 29 aṃ … 37 ḷṃ, 38 ḹṃ, 39 eṃ, 40 aiṃ, 41 oṃ, 42 auṃ, 43 aṃ, 44 aḥ | 1-2:243–367 | Ring 2 | data | LIVE; conflicts with DS-09 (C12) |
| CRD-04 | Ring 3 Anaṅgas 45–52 | 3-9:7–73 | Ring 3 | data | LIVE |
| CRD-05 | Ring 4 Sampradāya 53–66; several are Devī forms of the R1 Mudrās | 3-9:77–191 | Ring 4 | data | LIVE |
| CRD-06 | Ring 5 Kulottīrṇa 67–76; Ring 6 Nigarbha 77–86 | 3-9:195–363 | Rings 5–6 | data | LIVE |
| CRD-07 | **Ring 7 = 12: eight Vāsinīs (87–94: Vasinī, Kāmeśī, Modinī, Vimalā, Aruṇā, Jayinī, Sarveśī, Kaulinī) plus four Weapons (95–98: Bāṇinī, Cāpinī, Pāśinī, Aṅkuśinī)** | 3-9:367–469 | Ring 7 | data | LIVE (C13) |
| CRD-08 | Ring 8 Triad 99–101 (Kāmeśvarī Aim, Vajreśī Klim, Bhagamālinī Sauh); Ring 9 102 Mahātripurasundarī, phrase "Thank you for being. Thank you for being everything. Thank you for being me." | 3-9:473–511 | Rings 8–9 | data | LIVE |

### A19 · R2 `homes/Claude Code Handoff - The Homes.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| CCH-01 | Written to EXTEND the shipped app; the light layer is a verbatim port of `Atmosphere.swift` | :15–20 | Homes | DI | LIVE |
| CCH-02 | §1 BLOCKING: 61 of 102 names differ from the bundled roster; options base-wins / app-wins / position-is-key; recommend 3 now, 1 later | :27–62 | Data | AF/BI | RESOLVED: position is identity; ghost roster quarantined (BV2 Law 1) |
| CCH-03 | Keep Atmosphere, Element, HSL/tokens/fonts, DailyEnergyService, DailySummons (6 am), KhadgamalaMap (spans verified), RingAudioService; ShaktiDetailView becomes the library | :66–78 | Homes | BI | LIVE |
| CCH-04 | New layer files: Gem, RingWorld, ShaktiCard, RoomMechanism, RoomGrammar, Attribute, HomeView, DescentView, HomeMemory | :86–101 | Homes | BI | built (BV2 names differ) |
| CCH-05 | ShaktiCard loaded from bundled JSON generated from `homes-cards.js`, "not hand-transcribed"; key by pos | :113–128 | Data | BI | — |
| CCH-06 | Gem diffusion per ring: 1 0.20 topaz · 2 0.30 sapphire · 3 0.45 coral · 4 0.15 diamond · 5 0.25 emerald · 6 0.55 ruby · **7 0.95 pearl, no directional light** · 8 0.10 cat's eye (one hard band) · 9 0.70 | :145–152 | Light | BI | LIVE (Wave 1 light) |
| CCH-07 | RingWorld: `veil` from Yoginī (fog × (1 + veil×0.55)); `tempo` from mental state (1.00 → 0.28), the world clock only, never her adaptation clock | :156–170 | Worlds | BI | LIVE |
| CCH-08 | Rooms are not 102 authored screens. Resolution: authored mechanism → ring archetype tuned by the card → seat interior. "Nine so far" (lists eight names). Ring 1 splits by family; R2 is "the crossing"; R3–8 bodiless · cosmic · giving · revealing · sounding · sourcing | :174–200 | Homes | BI | built; RD: all rooms the same four-surface box → Wave 1 seat-shaped shells |
| CCH-09 | Four channels: physics (tattva+quality → one of 50 motions); altitude (loc, feet 0.94 → crown 0.10); phase (pos); words (quality) | :202–209 | Homes | BI | DONE (R9) |
| CCH-10 | "Every room reverses its premise at the second adaptation" (Aṇimā: "the point was a door all along"; Mahimā: "you were never inside anything"; Vaśitā; Garimā: "the weight was holding you all along") | :211–214 | Homes | DI | LIVE |
| CCH-11 | Ring 2 crossing: presents one sense, answers in the other, opposite phase, converging at the second adaptation | :216–223 | Ring 2 rooms | DI | LIVE |
| CCH-12 | Attribute: her iconography line becomes the room's one actor, "Aniconic — a noose is a shape, not a figure"; 26 forms, 52 named; past the second adaptation it grows 0.9 → 3.16 and thins | :225–237 | Homes | DI | LIVE |
| CCH-13 | The rite is the distance: three beats (phrase, Devanāgarī, roots with quality); "Self-paced by touch — never a timer, never skipped, compressed on return." Library folded; letter "Read only — never fabricated" | :239–250 | Homes | DI/BI | LIVE |
| CCH-14 | Going deeper: five stations (tattva → location → etymology → quality → phrase) | :252–256 | Homes | DI | DONE |
| CCH-15 | Doors open sideways within her neighbourhood first (R2 by cluster, R1 by family), then around the circle; walking a door reruns the rite from where you stand, "no cut" | :258–263 | Homes | DI | RD: never built → Wave 2 |
| CCH-16 | Leaving: her Siddhi lingers for minutes, never named | :265–267 | Homes | DI | RD: not displayed → Wave 1 |
| CCH-17 | Return: head start from accumulated dwell, not visits; second adaptation at 227 s, reachable only through relationship; "Nothing is ever displayed"; one line, once: "you have stood here before." | :269–284 | Homes | DI | RD: "returning line" dropped by restraint → Wave 1 |
| CCH-18 | Sound: R1 drone; R2 home breath (LFO); R3/6 breathy; R4/5 stepped (4 slower than 5); **R7 sourceless, overtones only**; R8 triad collapse; R9 Shepard. Carrier derived from her syllable's varṇamālā position as a just interval above the ring root; the fifth withheld | :288–309 | Sound | DI/BI | DONE (HomeSoundService per ERR roots) |
| CCH-19 | Invariants: (1) time is elapsed (never motion, proximity or stillness; stillness governs arrival only); (2) never measure out loud; (3) no cuts, only travel; (4) **reduced motion is longer and quantized, never disabled**; (5) never invent canon; (6) position is identity (Kāmeśvarī R7/R8 collision); (7) contrast floor at both adaptations; clamp additive particles | :313–330 | Homes | BI | (2) RESHAPED; the rest LIVE |
| CCH-20 | Suggested order 1–10; "Ring 9 (Mahātripurasundarī) should be built last and by hand." | :334–350 | Process | BI | done |
| CCH-21 | Verification contract: 66 checks in nine registers; port as Swift tests; key checks (own-ring card, no two sisters alike, reversal, >10% divergence, never black or blown at either adaptation, head start not gameable, no measuring copy, "no feature present in an earlier build has vanished"); "Verify the verifier." | :354–376 | Tests | BI | LIVE; Charter II adds the look check against Design's frames |
| CCH-22 | Out of scope: Mandala, Today, Portrait, Well writing, Descent film, Homecoming, Settings, Codex; Personal Connection marginalia absent, "needs authoring in Chat" | :380–387 | — | DI | ERR open item |

### A20 · R2 `homes/The Homes - the thread.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| THR-01 | The table of pieces and states (Rite of Entering, Concept Board V3, Rooms in 3D, attribute, Verification V3, descent, harness, cards, grammar, today, method, Axis, Nine Worlds) | :6–24 | Design corpus | DI | parity list |
| THR-02 | Attribute actions table (noose casts and draws; goad hooks; cup fills and is drunk; five arrows strike the five gates; bow; mirror returns your light; skull-cup darkens as it fills; plough; vajra strikes once; sceptre barely moves; rosary; seed densifies; chain falls open; lamp; gem; grain overflows; herb mends; ground does not yield; line; seal of five digits); colour tint from card words (Garimā's palm accent-red, Vārāhī's plough storm-grey, Vajreśī ruby) | :35–60 | Homes | DI | LIVE |
| THR-03 | Coverage audit restored seven missing asks: Atmosphere hues kept (ring 6 teal 194°, not ruby); doors; cluster corridor; library; letter object; Yoginī veil; mental-state tempo plus the presiding Form named on arrival; per-ring sound | :75–87 | Homes | AF | Code later dropped several (RD) |
| THR-04 | The physics classifier had 78 of 102 on a default; now 50 patterns | :91–95 | Homes | AF | DONE |
| THR-05 | The Gate passes as an assertion: Laghimā vs Garimā differ in 100% of geometry and 116 of luminance ("the floor has let go" / "the ceiling is coming down") | :103–107 | Gate | AF | R10: authored gate accepted |
| THR-06 | V1/V2/V3 verification; six defects found (Axis dropped the descent; Laghimā blew to white; Laghimā went dark at the second adaptation; Ring 4 had no wall; R1 Mātṛkās flat; harness false positive); "46 checks, 0 failing" | :111–148 | Tests | AF | — |
| THR-07 | 102 of 102 rooms, counts 28·16·8·14·10·10·12·3·1; Ring 1 family archetypes (Siddhis lent; Mātṛkās a row of letters; Mudrās "a seal large enough to stand inside") | :152–161 | Homes | DI | LIVE |
| THR-08 | The bīja carrier is derived, never invented | :176–184 | Sound | DI | LIVE |
| THR-09 | Ring archetypes R3–9 with their deep lines ("the effect was the only body"; "The gesture had no centre to leave"; "The giving and the given are one"; "you were the veil"; "You are inside the syllable"; R8 corners answer; R9 authored) | :195–206 | Homes | DI | LIVE |
| THR-10 | Defects: name collisions across rings → position is authoritative; app vs card names; R8 triangle larger than the room; R6 veil unlit | :213–222 | Homes | AF | — |
| THR-11 | GPU luminance ranges per archetype (Anaṅga 38–84 … bindu 43–157) | :224–225 | Light | AF | **parity numbers** (RD: Code room means ~11–65) |
| THR-12 | Second-adaptation reversals for the seven authored rooms, with geometry deltas | :230–248 | Homes | DI | LIVE |
| THR-13 | Today: three things share the word "rite"; `homes-today.js` is an exact port of DailyEnergyService (2020-01-01 epoch, 6 am, SplitMix64, Fisher–Yates); the instrument opens where she is; crown light; "she presides today"; **today** returns; the day turns in place | :255–277 | Today in Axis | DI | Wave 2 "Today's crown light" |
| THR-14 | Return: "She was expecting you" core light; ceremony softens; opens further along; **floor traces** (one faint mark per stay); fifth granted; climb rail marks āvaraṇas holding someone met, "never how many"; "you have stood here before" once; **forget me** lets all go | :281–300 | Homes | DI | RD: rail, traces, returning line → Wave 1/2 |
| THR-15 | The Axis: no cuts; the rite is the distance (three self-paced surges); sound as nine drones crossfading with the climb; tapping a light → "her world's air thickens and swallows the surroundings" | :302–328 | Climb | DI | Wave 2 (fly into her light) |
| THR-16 | Nine worlds as weather (R1 low raking light on a day–night arc; R2 systolic ring waves blood-warm through cold blue; R3 2,600-point curl flow; R4 three caustics plus diamond; R5 72-instance colonnade with shafts; R6 transmissive shells lit inside; R7 sourceless luminous fog, zero directional; R8 a chatoyancy band; R9 nine-gem rig converging) | :330–348 | Climb | DI | RD §4 restore list (Wave 1) |
| THR-17 | Nine mechanisms (Aṇimā contracts; Mahimā has no far wall; Vaśitva is known; Mahātripurasundarī no room; Laghimā floor lets go with GLSL displacement; Garimā ceiling descends; Sarva-Yoni membrane transmission; Trikhaṇḍā three mis-registered rooms merging in stillness) | :350–366 | Rooms | DI | RD: Rooms in 3D techniques → Wave 1 |
| THR-18 | Standing decisions: Turrell register; uniqueness by what a room does, not palette; threshold tap-paced, never skipped, compressed on return; sound on gates only; reduced motion longer and quantized; reference matter never deleted | :371–376 | Homes | OR | "sound on gates only" RESHAPED (Charter II) |
| THR-19 | WebGL capture is black, so verify by `gl.readPixels` (the luminance list) | :378–386 | Tests | AF | explains frame 3d-01-anima |

### A21 · R2 `homes/READ ME FIRST.md` and the `_superseded` READMEs

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| RMF-01 | Read order: Handoff → thread → method → source; nothing implemented until §1 is settled | :6–16 | — | BI | settled |
| RMF-02 | How to run the Axis (http, three.js CDN); controls: rise, tap a light, three touches in, go deeper, the library, doors, today, **stay** (clock ×14), sound | :18–34 | Axis | DI | parity of controls (thumbnail frame) |
| RMF-03 | Verification V3: 66 checks, 102 Śaktis, 204 rooms; "built to fail and has, eight times" | :36–38 | Tests | AF | — |
| RMF-04 | Not in scope: Mandala, Today, Portrait, Well writing, Settings, Codex; Personal Connection marginalia absent | :62–68 | — | DI | — |
| SUP-01 | `all-shaktis-data.js` is a never-shipped draft roster (empty Ring 2; Ring 4 names in R1 Mudrā slots); "Never diff against this file"; a third copy sits in `Claude Designs/` | homes/_superseded/README:1–6; prototype/_superseded/README:1–11 | Data | OR | LIVE |

### A22 · `Bindu Mandala - the method.md` (DU version, plus the R2 homes version that differs only at :20–21)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| MTH-00 | Read everything before making anything. **DU :20–21:** "`all-shaktis-data.js` is authoritative". **R2 :20–21:** "The 102 cards (from Airtable) are authoritative; `all-shaktis-data.js` is superseded." | DU:8–22 / R2:20–21 | Process | OR | R2 wording LIVE |
| MTH-01 | Mechanism, never mood; convert adjectives to mechanisms out loud | :24–36 | Design | DI | LIVE |
| MTH-02 | "Never show the first attempt… push to V2 silently, push to V3 silently" | :38–45 | Design | DI | LIVE |
| MTH-03 | Say the plan in plain words; distrust labels | :47–58 | Process | DI | LIVE |
| MTH-04 | "Fix the rule, not the instance" | :60–68 | Code | DI | LIVE |
| MTH-05 | **"No cuts, only travel… if the user has to choose from a list, the design isn't finished."** | :70–82 | All | DI | LIVE (Charter II §3.6) |
| MTH-06 | One engine with N tunings; un-authored rooms inherit the shared floor | :84–92 | Homes | DI | LIVE |
| MTH-07 | Build from real data; degrade gracefully; never invent canon; "The gaps are information." | :94–99 | Data | DI | LIVE |
| MTH-08 | Verify what the eye can't reach: V1 / V2 / V3 (canon, coverage, distinction, legibility, promise, felt, coherence); "the verifier needs verifying too"; `?v=` cache-bust; clamp `gl_PointSize` | :101–132 | Tests | DI | LIVE |
| MTH-09 | Time is elapsed, never device-tied; stillness governs arrival, never persistence | :134–139 | Homes | OR | LIVE |
| MTH-10 | "Never measure it out loud" (no counters, percentages, "3 of 9", bars or badges) | :141–146 | All | DI | RESHAPED (Charter II §4.6) |
| MTH-11 | Register decisions where they survive (the thread, the same turn) | :148–152 | Process | DI | LIVE (DECISIONS.md) |
| MTH-12 | Shape of a new space: read, convert, three-pass concept, judge against the ask's own test, build the engine, verify by probe, write it down. Ask only what the data can't answer | :156–172 | Process | DI | LIVE |

### A23 · `github.md` (DU 83 lines; R2 homes copy adds :84–87)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| GH-01 | Repo follows `RECONCILED-BUILD-BRIEF.md`, which supersedes this project's Master Build Brief | :7–10 | — | DI | historical |
| GH-02 | Three Atmosphere divergences corrected on the design side (per-ring HSL; ±7° kp jitter; Ring 2 from five cluster hues) | :18–23 | Theme | AF | DONE |
| GH-03 | Bundled roster diverges from the cards for 61 of 102 | :33–35 | Data | AF | resolved (position) |
| GH-04 | Screen map of app surface → repo files (Daily Rite, Recognition, Living Mandala, Field, Detail, Threshold, Well, Portrait plus Descent film, Nityā, Homecoming, Settings, sound, daily engine, tokens, data spines, Homes mapping) | :39–57 | Code | BI | reference (pre-Homes build) |
| GH-05 | "Note for the Code handoff": calls the Homes package the Ruling-7 content pass and says the nine ring-worlds return as "conditions inside a room" | :59–67 | Content | DI | SUPERSEDED by the R2 addendum |
| GH-06 | Sync history: the app pivoted to Reconciled (nine worlds cut; **descent fully open**; six archetypes); MBB "largely historical" | :78–83 | — | AF | — |
| GH-07 | (R2 copy) "Ruling 7 is CLOSED — all 102 carry full content in Airtable (verified live 2026-09-06)… any blank on device is sync staleness." | R2 github:84–87 | Content | OR | LIVE (but RD §1 data gaps) |

### A24 · CC `SESSION-HANDOFF-2026-09-06.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| SH-01 | Found that the nine worlds were cut in July (Ruling 1); corrected course | :39 | — | AF | — |
| SH-02 | Descent prototype corrected after "you've shown me a button that changes an icon" → three depth layers, passed *through*, Bindu anchor, glissando | :45 | Descent | OR | LIVE intent |
| SH-03 | VFX: a place-count cap replaced by a proximity/focus principle | :47 | Render | OR | RESHAPED (Charter II) |
| SH-04 | Never-measure final form: "unlimited as feeling, never as a digit"; the two lines never in question; "interpret requests tightly" | :49 | All | OR | RESHAPED 12 Oct |
| SH-05 | Ruling 7 stale, data complete; the 61-name conflict traced to `all-shaktis-data.js` | :51–53 | Data | AF | LIVE |
| SH-06 | Locked (do not re-litigate): aniconic; never-measure final form; lines out of scope; VFX by proximity; entering brisk, dwelling adapts; a floor state with any deeper state never surfaced; **uniqueness budget Rate + Aperture, not Material or Proportion/Gravity**; all-shaktis superseded; Ruling 7 closed | :63–73 | Homes | OR | several RESHAPED by 12 Oct ("no rule stands because it came first") |

### A25 · CC `BINDU-MANDALA-AUDIT-BRIEF.md` (6 Sep) and `DEVICE-AUDIT-BRIEF.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| AB-01 | READ-ONLY; evidence-preservation law (never delete or reinstall the app on the phone) | AB:5–21 | Process | OR | LIVE (Charter II §4.1) |
| AB-02 | Position is identity; never diff against the ghost roster | AB:31–34 | Data | OR | LIVE |
| AB-03 | Sections A–H ask list (ledger forensics; the 86 on device; build health; history; rulings drift; repair list; Homes-readiness incl. G5 perf baseline; felt UX: H2 readability at **≥~11pt and ≥~0.5α**, H4 ≥44×44, H5 VoiceOver/Dynamic Type/reduce-motion, H6 ceremony felt, H8 the "6am whisper") | AB:51–210 | Audit | BI | executed |
| DAB-01 | Sequencing law: capture the phone as it is before any dev build | DAB:50–61 | Process | OR | LIVE (method) |
| DAB-02 | H6 corrected script: 2.6 s / 4.1 s / note 5.1 s; act 2 in the element's `accentBright` | DAB:125 | Recognition | AF | LIVE fact |

### A26 · CC `AUDIT-REPORT.md` (Session 1, 7 Sep) and `AUDIT-REPORT-DEVICE.md` (Session 2)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| AR-01 | Ledger hypothesis refuted as a mechanism (the field exists); zero Mandala rows because no eligible event ever happened; the Mandala table received nothing after 13 Jul | AR:13–23 | Data | AF | resolved |
| AR-02 | Retry queues self-destroy (3-strike, even with a nil PAT) | AR:23, :71–73 | Sync | AF | fixed (no-PAT holds) |
| AR-03 | Two-phase write: local record at ceremony appear, Airtable at close | AR:107 | Recognition | AF | LIVE fact |
| AR-04 | D2: 3244f54 deleted 15 files (−5,992 lines): MandalaScreenView, VeilView, nine worlds, RingWorldView, SriYantraMandalaView, TemporalMarkView | AR:274 | History | AF | key to RD §2.1 |
| AR-05 | D3: Mauna's life in code 20 May → 11 Jul; `.silence` enum kept | AR:278–285 | Silence | AF | → R11 |
| AR-06 | E: Rulings 1–8 drift check (1, 2, 3, 5, 6, 7, 8 confirmed; 4 partial) | AR:303–316 | Rulings | AF | — |
| AR-07 | G1: pure SwiftUI Canvas; no Metal, SceneKit or shaders at that time | AR:362 | Render | AF | changed (Homes: SceneKit plus Metal) |
| AR-08 | G2: ShaktiDetailView census and the state couplings a top replacement must preserve (incl. `didSettleNotification` → RootView lands on `.memory`) | AR:364 | Detail | AF | LIVE (RD defect: didSettle jumps to the Portrait even from a room) |
| AR-09 | H2: 31 sub-threshold text sites (table); H4: 8 touch violations (worst "↑ return to the field" ≈19pt) | AR:393–445 | A11y | AF | Phase 4 done per RD |
| AR-10 | H5: no Dynamic Type; the canvas Mandala is silent to VoiceOver | AR:448 | A11y | AF | done per RD §1 |
| AR-11 | H8: summons default **6 am**; title is the presiding Śakti's name, body her quality; fallback "She is waiting." | AR:454 | Summons | AF | LIVE fact |
| AR-12 | Also observed: `lr_sound` never restored; Detail source always `.mandala`; PAT in Info.plist; dead views; hamburger order | AR:462–481 | Misc | AF | partially fixed |
| ARD-01 | "Usage never stopped. The pipe broke." 74 local RecognitionEntry rows; 29 fault-era recognitions only on the phone, incl. notes "Ram Japa", "I feel you Mommy", "I appreciate you the most" | ARD:16–24 | Data | AF | recovered (Phase 0) |
| ARD-02 | Letters: the KP29 clear never landed; KP44 rewrite never landed; KP40 local-only | ARD:76–89 | Well | AF | C3–C5 |
| ARD-03 | **WellView dirty-on-load bug**: viewing a letter for 5 s writes | ARD:97, :138 | Well | AF | fixed (0.2) |
| ARD-04 | Device: "Neev", iPhone 16 Plus (A18); build 34 | ARD:4 | Device | AF | parity device |
| ARD-05 | SE-width Well header collision; Mandala z-order under zoom controls; sans slips on the quality paragraph and Settings title; staged first paint | ARD:141–144 | UI | AF | partially fixed |

### A27 · CC `BINDU-MANDALA-BUILD-BRIEF-V2.md` (7 Sep), with `PACKAGE-START-HERE.md` and CC `README.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| BV2-L1 | Law 1: position is identity; Airtable is truth; the ghost file is archived | :19–21 | Data | OR | LIVE |
| BV2-L2 | Law 2: never measure, final form; return compression never skips | :22–23 | All | OR | RESHAPED (Charter II §4.6) |
| BV2-L3 | Law 3: the two lines are verbatim at every site | :24–25 | Recognition | OR | LIVE |
| BV2-L4 | Law 4: aniconic ("Forms are shapes performing actions") | :26–27 | All | OR | RESHAPED to "no figural depiction" (Charter II §4.5) |
| BV2-L5 | Law 5: additive to the July architecture | :28–31 | Code | OR | LIVE |
| BV2-L6 | Law 6: schema changes only under the BinduSchema plan | :32–33 | Data | OR | LIVE |
| BV2-L7 | Law 7: verify before dispatch; device test between phases | :34–36 | Process | OR | RESHAPED (waves; he walks every wave) |
| BV2-L8 | Law 8: FIDELITY rules (readability, reduce-motion gating, one spine owner, 86 degradation, Pro-Max plus small device) | :37–38 | UI | OR | LIVE |
| BV2-L9 | Law 9: read Design's handoff docs before any Homes step | :39–41 | Process | OR | LIVE |
| BV2-R9 | Four-channel grammar accepted; Somatic and Function reserved for refinement | :47 | Homes | OR | LIVE |
| BV2-R10 | Authored Gate accepted | :48 | Homes | OR | LIVE |
| BV2-R11 | Mauna reborn as the dwelling (62 s → `.silence`, once per visit, never displayed) | :49 | Homes | OR | LIVE (as `Silence Held`, R17) |
| BV2-R12 | The Homes replace Detail's top; Detail becomes the library | :50 | Detail | OR | LIVE |
| BV2-R13 | Ceremony brisk, dwelling adapts; compression floor 0.36 | :51 | Homes | OR | LIVE |
| BV2-R14 | Ruling 7 closed | :52 | Content | OR | LIVE (RD lists remaining data gaps) |
| BV2-R15 | Recovery is Phase 0 | :53 | Data | OR | DONE |
| BV2-R16 | Ten cleanup rulings plus three ledger events | :54 | Data | OR | DONE |
| BV2-C | C1–C10 (incl. **C8**: bīja footer syllable-only; **C9**: Settings last; **C10**: PAT accepted for now) | :60–69 | Misc | OR | DONE |
| BV2-P0–P6 | Phases 0–6 (recovery, hygiene, foundations, Homes 3.1–3.10, felt register 4.1–4.5 with FIDELITY rule 4 at ≥11pt/≥0.5α, the Mandala's light, systems triage) | :73–244 | — | BI | done through Phase 5 per RD §1 |
| BV2-P6 | **"Dead — stays dead: Relationships/Saṅgha/Beloved, lunar-today, ring gating/unlocks, the old Mauna screen (reborn as R11), the ring drone (superseded by the Homes' carrier)"** | :244 | Scope | OR | partially REOPENED by RD/WAVES (Mauna, Veil, the Shepard fall, ring voices on the climb) |
| BV2-7 | Ashrey's alone: the 102 letters; nine Personal Connection marginalia texts; 102 bīja recordings | :246–251 | Content | OR | LIVE |
| BV2-9 | Session protocol: declare / built / surfaced / left behind; never advance a phase alone | :258–263 | Process | OR | RESHAPED (Charter II waves) |
| PSH-01 | Laws in one breath; never delete or reinstall; fix the Well bug before any letter is opened | PSH:12–28 | Process | OR | LIVE |
| CR-01 | The CC docs govern *how the instrument is built*, not what she says | CR:3–5 | — | DI | LIVE |

### A28 · CC `BUILD-BRIEF-V2-ERRATA.md` (7–21 Sep)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| ERR-01 | Build 34 was a token-less Cloud build (ci_scripts in the wrong place); fixed in #26 | :16 | CI | AF | DONE |
| ERR-02 | Backfill as executed: 42 Recognition, 6 Crossing, 9 Silence, 41 App Activity | :24 | Data | AF | DONE (then migrated, R17) |
| ERR-03 | Rings 3–9 are **58** rooms, not 74 | :89, :133–135 | Homes | AF/OR | LIVE |
| ERR-04 | Authored map keyed by kp {1,2,3,4,6,27,28,102} | :89 | Homes | BI | LIVE |
| ERR-05 | R11 clock ambiguity (the chamber clock starts at the head start) | :89 | Homes | AF | open → check DECISIONS |
| ERR-06 | Ruling 2026-09-07: events go in the ledger. Six new App Activity fields (Felt At fldWAR0B4pNxjTwEJ, Lunar Day fldJc7iCzxZOSdO4D, Moon Phase fldMpjvAsT64v85bh, Gesture Source fldP3wq8QTgxeTDuC, Descent Ring fldi7SOuep57UoXzi, Duration fldrIOx1id7Esm2fd); types Shakti Recognized / Ring Crossed / Silence Held / Letter Written | :111–117 | Data | OR | LIVE |
| ERR-07 | **R17 sealed 20 Sep:** App Activity is the single record; Mandala-table event rows stay at zero forever; the letter words stay on the Śakti row; HomeMemory phone-only; `Deepest Ring Reached` redundant | :121–127 | Data | OR | LIVE (Charter II §4.3) |
| ERR-08 | R10 restated: the zero-hand-work lock was released 6 Sep | :129–131 | Gate | OR | LIVE |
| ERR-09 | Carrier ruling: Design's ROOTS 55.0 · 61.74 · 69.30 · 73.42 · 82.41 · 92.50 · 98.00 · 110.00 · 123.47 Hz ("what is canonical is the ORDER"); one air layer; **the descent is silent; no glissando invented**; cancellable tasks; interruption handling; `homes-sound.js` tabled and asserted | :137–184 | Sound | OR | descent-silent RESHAPED by Charter II ("sound the descent", RD §3) |

### A29 · CC `CHAT-NOTE-TO-CODE-2026-09-20.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| CN-01 | Amends BV2: R17 sealed (event table) | :15–32 | Data | OR | LIVE |
| CN-02 | Gate: R10 is the authored gate | :39–43 | Homes | OR | LIVE |
| CN-03 | 58, not 74 | :45–47 | Homes | OR | LIVE |
| CN-04 | One branch at a time; recover the four worktrees and report first; order phase-2a (gate: four letters at kp 29/39/40/44 byte-identical against a **fresh** container) → 2b-sound → spike-baseline → renderer ruling → phase-4 | :49–70 | Process | OR | done (Homes built Sept 21–23 per RD) |
| CN-05 | Laws carried forward (evidence, position, never measure, lines, aniconic, schema, device test) | :72–80 | — | OR | RESHAPED partly |

### A30 · `BUILD-CHARTER.md`, Charter II: Emergence (12 Oct; standing law)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| BC-00 | Replaces the restraint charter of 20 Sep. Five causes of the Design–build gap: tiebreaker, "no light in the air", ports that "matched numbers but lost light", refused interfaces, checks that proved strings not pictures | :3–15 | — | OR | LIVE |
| BC-01 | "No rule stands because it came first." A rule survives only if its first principle survives "what does this protect, and what ceiling does it put on the app?" | :17 | — | OR | LIVE |
| BC-02 | "Push the design limits on everything. Create an immersive experience that is unique at every level… this gamified app." | :19 | — | OR | LIVE |
| BC-03 | **Tiebreaker: "When in doubt, build the fuller version. Design is the floor, never the ceiling."** "When a frame washes out, the answer is better light, not less light." | :25–29 | All | OR | LIVE |
| BC-04 | One yantra, three ways (Mandala appreciate with 102 seats plus 33 chakras; Climb; Road) with play at the centre; arc recognise → appreciate and dwell → play | :35–45 | Architecture | OR | LIVE |
| BC-05 | Law 1: the room test at every level | :51 | All | OR | LIVE |
| BC-06 | Law 2: motion carries meaning; the Bindu-light is a character (curious, hesitant, delighted, a gaze) | :52 | All | OR | LIVE |
| BC-07 | Law 3: **light stands in the air** (glows, cores, additive lines, membranes, transmission, caustics, gems, bloom, HDR; colour warms with depth; each world its own light) | :53 | Render | OR | LIVE |
| BC-08 | Law 4: every place moves as what it is (tempo, breath, sound) | :54 | All | OR | LIVE |
| BC-09 | Law 5: sound is everywhere; existing pitches keep their character; new sound may take 136.1 Hz and 110 Hz; begins on first touch; silent switch honoured | :55 | Sound | OR | LIVE |
| BC-10 | Law 6: one building, no cuts; leaving is one gesture, never punished | :56 | Nav | OR | LIVE |
| BC-11 | Law 7: play is a physical verb with a skill; failure is present-tense physics; no congratulating end screen | :57 | Play | OR | LIVE |
| BC-12 | Law 8: her voice is authored, never generated; the Well is his alone | :58 | Content | OR | LIVE |
| BC-13 | Surviving walls: practice data sacred (never lost, duplicated or reordered; never reinstall); position is identity; App Activity single ledger; the two lines verbatim; no figural depiction (light, glow, gems, geometry are welcome; words naming a hand or body are language); **nothing grades him or puts him behind; numbers may describe *her*, the structure, the place and the day; the rail of nine, "met" light, "you have stood here before" and gem colours are welcome; he may ask to see his own record** | :66–71 | All | OR | LIVE |
| BC-14 | Waves workflow: Xcode Cloud "Waves — test"; green, then main; he walks every wave; DECISIONS.md; **every visual wave adds a look check against Design's own frames and numbers**; halt only for data loss or an impossible principle | :77–83 | Process | OR | LIVE (this register's Section B feeds it) |

### A31 · `WAVES.md` (12 Oct)

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| WV-01 | Shape: Recognise (Bindu) → appreciate and dwell → play (Lalitā; C-1330) | :6–8 | Architecture | OR | LIVE |
| WV-02 | Mandala carries the 33 as a constellation (canon B: energy chakras at ring level; body/mind/summit at a Śakti seat; Shadow and Armin at the 3→4 and 6→7 crossings); Climb = canon A, with body chakras touchable (Soles, Forge, Prāṇa, Hands, Pulse, Sonar, Echo, Vision, Axis, Crow) and Spine Walk; Road = the 33 in order, centre → perimeter → back | :12–19 | Architecture | OR | LIVE |
| WV-03 | The Bindu Origin becomes Homecoming (G17: the light condenses, blinks, the yantra draws outward); one breath on return; the covenant touch hands into Recognition | :21 | Homecoming | OR | Wave 3 |
| WV-04 | Game homes table (Corridor at Shadow; Pulse; Spine Walk; Echo; Finger Garden; Rain; Drum/Root; Water Level; Fire; Shake; the Door; Śrī Yantra trace; **102-bead rosary**; Mantra tuner retuned; Coherence) | :29–45 | Play | OR | Wave 4 |
| WV-05 | Every game: failure as physics; no congratulation; no live AI voices; every verb is an App Activity event | :47–51 | Play | OR | LIVE |
| WV-06 | Landings: Living Mandala → layers of the Portrait (strokes mirrored n-fold by ring; the year accretes; exportable as the Record); Seven Gates → Gates of Release over nine āvaraṇas; Correspondence → river Well; Body as Scripture → somatic way in; Mirror → Bindu gaze; Field → the 102 on one clock; the day layer folds into the Rite (three doors, one-second floor, pulse haptic, grace, Sakshi close) | :53–60 | Multi | OR | Waves 3–5 |
| WV-07 | Wave 0 Ground (charter; margin; defects; data; ring fields live; retool tests; visual-fidelity harness against Design's frames; **HDR and bloom on**; skills) | :66–75 | — | OR | open |
| WV-08 | Wave 1 Light: full yantra on the **indigo** sky; nine breath rates; time states; sacred geometry at true brightness; layered backdrops; staged arrivals; six natures of Recognition; Lalitā's bloom; "Enter her ring"; Homes in Design's light (seat-shaped shells, per-band physics); the room's words, after-effect, traces, the returning line | :76–81 | — | OR | open |
| WV-09 | Wave 2 One building: Climb with 102 lights; fly into her light; the rail; today's crown light; neighbour doors; sound on the Climb with ring voices; Gates of Release; **Ring Worlds' mechanisms reborn inside the rings; Mauna, the centre bloom, the Shepard fall, the Veil** | :82–88 | — | OR | open |
| WV-10 | Waves 3–5 and endless refinement (Origin and the 33; Play; Memory and words incl. Temporal Layer five clocks with a real ephemeris and a random gift notification; seed ledger; per-Śakti Score JSON) | :89–111 | — | OR | open |
| WV-11 | Small canon questions (Soles band 1 vs āv 4; Anāhata and Sahasrāra both on the 16-petal ring; room 32 Gaia reveal; āv 7 mudrā; Svādhiṣṭhāna verbs; the rows win) | :113–120 | Canon | DI | open |

### A32 · `waves/THE-READING-2026-10-12.md`

| ID | Statement | Source | Scope | Kind | Status |
|---|---|---|---|---|---|
| RD-01 | What exists: 102 Homes (SceneKit plus Metal; eight authored, kp 1/2/3/4/6/27/28/102); rite in three beats; nine-band climb as one shaft; Gate; descent of five stations; carrier with the fifth; return memory; held way out 2.2 s; felt register (Dynamic Type, VoiceOver 102); library; Mandala light (Bindu source, gem bands, stillness veil, Tratak, crossing bīja) | :34–45 | State | AF | LIVE fact |
| RD-02 | Unmerged: `practitioner-notes` (the margin, Schema V3, `Note Left`); ring-4/5/9 checkpoints | :49–51 | Branches | AF | Wave 0 |
| RD-03 | Live data gaps: Function empty on the 16; Bīja filled 36/102; no Phonetic field; count drift 51 vs 59; spellings; legacy schema; Lunar Day 0–29 vs 1–30; Khaḍgamālā description says 1–108; ring fields never read live | :53–63 | Data | AF | Wave 0 |
| RD-04 | Usage: Rite and Recognition steady; ring crossings only in July; rings 1, 2 and 8 never crossed in the camera; rooms reachable only since 22 Sep | :65–69 | Usage | AF | — |
| RD-05 | Gap cause 1: his July rulings (3244f54 deleted the Veil, nine worlds, Silence and the held yantra, which Design Audit I had praised) | :77 | History | AF | — |
| RD-06 | Gap cause 2: the **binding condition** (Code's invention: no free-standing light) applied to all light; HDR/bloom off; all 102 rooms one four-surface box; the climb has one light; Design room luminance ~80–255 vs Code means ~11–65 | :79–88 | Render | AF | Wave 0/1 |
| RD-07 | Gap cause 3, **port losses**: stroke ×1.7 never applied plus 0.9/0.7 dimmers (geometry 2–8× fainter: Rite ~2.6×, Recognition ~1.9×, Field chips 2–4×, Threshold ~8×); lrBackdrop collapsed; motes invisible on fire/water days and the Portrait; staged arrivals collapsed; six recognition natures flattened; yantra lost gates, both lotus rings, inner circles and shimmer, triangle star stretched to the Bhūpura; **indigo night sky became crimson-black**; Lalitā's red bloom gone; "enter her ring" threshold never ported | :90–99 | Parity | AF | Wave 1 |
| RD-08 | Gap cause 4, restraint: dropped returning line, beat pips, rail, Mudrā line, gem hues; refused her form at seat zoom; veil can't lift; never built 102 climb lights, corridor, letter object, after-effect, traces, room words; climb silent; six RingAudio voices dead; ~15 of 44 ideas built | :101–108 | Parity | AF | Waves 1–2 |
| RD-09 | Gap cause 5: checks proved numbers, not pictures | :110 | Tests | AF | Wave 0 harness |
| RD-10 | Code got the same handoff; the upload adds studies Code never saw (Rooms in 3D, the older Rite of Entering, Nine Worlds, Concept Boards; "I built one perspective box for all of them… That is decoration.") | :112 | Corpus | AF | — |
| RD-11 | First-principles table: lift the tiebreaker; reshape the binding condition to "no figural depiction"; keep aniconic; reshape never-measure; keep lines, position, R17, data; **lift "one door into a room"** (reachable from Mandala seat, Rite, Field, Climb); keep "threshold has no cancel"; keep the 2.2 s hold out and add Escape/left-edge; **reshape "descent gated until 62 s" to always offered, deeper with dwell**; keep the withheld fifth; retire the composition lock (1pt) and replace it with a visual fidelity check against Design's frames; retool LawsTests; **lift light caps** (clamp 0.86, wash ×0.09, veil −45%) and turn on HDR/bloom; **lift sound restraint** (wire ring voices, sound the descent, continuous field); lift "nothing remembered on her screen"; keep "level 4 of 4" unless he prefers | :120–140 | Rules | OR (his 12 Oct ruling; table is the build's call) | LIVE |
| RD-12 | Homecoming list for the Homes: light in the air; per-band physics (Pelvis seven expanding red rings on cold blue; Navel 2,600-point curl; Heart RGB caustics and diamond prism; Throat 72-rib colonnade with shafts; Forehead nine translucent ruby bodies lit from within; Crown pearl fog; Above-crown chatoyant band; Totality nine gem lamps orbiting); seat-shaped shells; Rooms in 3D techniques; the climb as the Axis (102 breathing lights, "she was expecting you", crown light, fly into her light, rail, weather sentences, drag to turn); in-room words, letter, traces, returning line once, doors, after-effect (exposure lift); older Rite adds the yantra beyond the far wall and a 180 s lighter/heavier/sharper/wider after-effect | :148–169 | Homes | OR | Waves 1–2 |
| RD-13 | Mandala/Rite list: full yantra (gates, two lotus rings, circles, **triangles at 0.585**, **8 s shimmer**, **Bindu breathing ×1.28**, **indigo night ground**); five time states (new moon desaturation, Bindu 1.6×); nine breath rates **3/8/9/11/13/15/18 s and 4 s at the Bindu**; lrBackdrop layer for layer; ×1.7 strokes without dimmers; Rite staged arrival (**nine beats**), air-lean, her hue in the pill; Recognition's six natures; Lalitā's red bloom with words from the light; Living Rite threshold "enter her ring"; menu and sheets lit by the day | :171–180 | Mandala/Rite | OR | Wave 1 |
| RD-14 | Restorable: Veil/Legend (status as light: here · open · ground · ahead · veiled); Ring Worlds' mechanisms inside the zoom or Homes (R3 scatter/gather; R6 finger light and whispers; R7 twelve-voice chord; R8 tones gliding into one); R9 Praveśa Shepard and G17 centre bloom; Eight Modes (Mauna: tap the centre); Temporal Layer (five clocks, sandhyās, Great Wheel, real ephemeris); Memory Layer instruments and the Codex gesture grammar | :182–188 | Multi | OR | Waves 2–5 |
| RD-15 | Fix inventory: code defects (motes, `hasBeenFelt` server-only, silences counted as felt, didSettle jump, queue drops, Detail `.mandala`, letter editor scenePhase save, ENERGY_POS, field connections hard-coded, ring data typed in Swift, logVerification every sync, spike .metal in Release, Siddhi↔Mātṛkā expected failure, kp43 tautology, texture seams/hard horizon); data; skills | :347–387 | Fix | AF | Wave 0 |
| RD-16 | His to rule: chakras (two canons); the surviving principles; the Embodiment line | :406–412 | — | OR | WAVES says chakras ruled in |
| RD-17 | Retool list: LawsTests, the composition lock, binding-condition types, TheWayInTests regexes, RiteOfEnteringTests returning vocabulary, the Destination enum, the pinned asset catalogue; "does it look like Design, and better?" | :416–426 | Tests | OR | Wave 0 |

---

## B · THE FRAMES (the parity ledger's picture list)

Every image was opened and looked at. Byte-identical duplicates are marked (=) after an md5 check, and were opened anyway.

### B1 · DU `uploads/` (Ashrey's own 27 May screenshots of Design's canvases)

| # | Path | What it shows | Key visible values | Reference frame for |
|---|---|---|---|---|
| F01 | `uploads/Screenshot 2026-05-27 at 6.58.14 PM.png` | Ring 2 lotus close-up (Mandala App or Ring Worlds "Inhabited Lotus"), with Sparśa as today's petal | 16 almond petals on near-black; labels italic Cormorant inside each petal. Clockwise from 12 o'clock: Kāma (gold, brightest), Buddhi, Ahaṅ (amber golds), Śabda, **Sparśa (rose-copper, glowing halo, white label = today)**, Rūpa, Rasa, Gandha (terracotta→brown), Citta (teal, at 6 o'clock), Dhairya, Smṛti, Nāma, Bīja (sages; Nāma and Bīja nearly black = mapped 22%), Ātma, Amṛta, Śarīra (violets). Centre: faint gold interlaced triangles, crimson ring Bindu with a cream core. Dust motes. | Ring 2 petal colours by cluster (confirms the DS-04 mapping, not HO1-15); status opacity ladder; today's-petal glow |
| F02 | `uploads/Screenshot 2026-05-27 at 6.58.45 PM.png` | Ring 8 Mūla Trikoṇa, three vertex states side by side | Black ground; thin dashed triangle. **Icchā** (red/rose #C45050-ish, "WILL", "the wanting before want has an object"), **Jñāna** (lavender, "KNOWLEDGE", "the knowing before knowledge has content"), **Kriyā** (sea-green, "ACTION", "the doing before doing has direction"). The tapped vertex glows; centre crimson Bindu; large italic Cormorant name ~60px; small tracked sans gloss. | Ring 8 triad mechanism (reborn per WV-09); triad colours (FB-21) |
| F03 | `uploads/Screenshot 2026-05-27 at 7.59.20 PM.png` | Temporal Layer · "The Cosmic Now" (iPhone frame, 9:41) | Header "THE COSMIC NOW" in gold tracked caps; "where you are, inside time" in italic. Five faint concentric wheels; crimson Bindu with cream core; five gold glowing bodies. **Defect: ring labels collide** ("HOUR NAKṢATRA SEASON SŪRYA" overprinted left; "Vṛścika Śarad Anurādhā Trayodaśī … PM" overprinted right). Bottom "THIS MOMENT": "Sandhyā · the evening junction. Anurādhā watches the moon waxing." Footer "ŚUKLA PAKṢA · DAY 13 · THE MOON IS 78% FULL" (a number describing *the day*, allowed under BC-13). | Temporal Layer five clocks (Wave 5); shows the label-collision defect to avoid |

### B2 · DU `screenshots/` (Design's verification captures: the Axis, the Living Mandala, the Lalitā finale)

| # | Path | What it shows | Key visible values | Reference frame for |
|---|---|---|---|---|
| F04 | `screenshots/01-axis-states.png` | The Homes Axis (390-wide frame in a desktop canvas), seat state | Dark warm-grey shaft, faint radial; one small glowing coral-red point at centre; right-edge rail of small gold dots with the label **"THE SEAT"** beside the lit one; sparse motes | Climb/Axis rail ("THE SEAT" tier); the near-empty first state |
| F05 | `screenshots/02-axis-states.png` | Same, ring state | Point slightly brighter red-orange; the rail reads **"THE RING"**; otherwise as F04 | Axis rail tier labels |
| F06 | `screenshots/03-axis-states.png` (= F05) | Identical to F05 | — | duplicate |
| F07 | `screenshots/3d-01-anima.png` | Rooms in 3D · Aṇimā | **Pure black** with only "ENTERING" (spaced Cormorant caps) and "DRAG TO LOOK · SCROLL TO MOVE" top-left | Shows the WebGL screenshot limitation (MTH-08, THR-19). Not a look reference; parity must use readPixels or device capture |
| F08 | `screenshots/01-mandala-chime.png` | Living Mandala, cosmic tier, ring-chime state | iPhone frame. Title "Śrī Yantra" (Cormorant, cream), sub "THE WHOLE INSTRUMENT · PINCH TO FALL IN" (tracked sans), hamburger top-right (gold three lines). Ground deep **blue-indigo night** with stars. Full yantra: Bhūpura square with gates, petal rings drawn as outlined loops, gold triangle star, seats as small coloured dots (rose, gold, teal), a dotted circle of seats, a soft red glow off-centre, two bright seats (white, pink) | **Wave 1 "full yantra on the indigo sky"** (RD-13); chime flash reference |
| F09 | `screenshots/02-mandala-chime.png` | Same, zoomed further (mid tier) | Bhūpura edge band fills the width with gold seat dots and a gate notch; triangles larger and brighter; 16-loop petal ring visible; red glow; indigo ground | Semantic zoom tier 1; ring flash |
| F10 | `screenshots/chime-flash.png` | Bindu → Lalitā finale | Ground **deep crimson-red bloom** filling the frame (Lalitā's red bloom); a large gold-white glow behind the text; "NINTH ĀVARAṆA · THE BINDU" (gold tracked caps); "the point that contains all points" (italic); **"Lalitā"** huge Cormorant cream (~70px); "Mahātripurasundarī" spaced; hairline; "She who is made of all bliss — the…" in gold Cormorant | **Lalitā's red bloom** (RD-07, RD-13, Wave 1); name scale |
| F11 | `screenshots/01-ring.png` | Axis, Ring 2 tier | Warm crimson-brown ground; 16 coloured seat dots in a circle (gold, amber, rose-copper, teal, sage, violet) with truncated italic names (Kām, Buddhy, Ahaṅkār, Śabd, Sparś, Rūp, **Ras** (white, larger dot = selected/today), Gandh, Citt, Dhairy, Smṛty, Nām, Bīj, Ātm, Amṛt, Śarī); centre Bindu glow; rail "THE RING". **Labels sit offset from their dots by about half a slot**, a visible alignment defect | Climb Ring 2 band with 102 lights at altitude (Wave 2); colour family per cluster |
| F12 | `screenshots/02-ring.png` | Same as F11 plus a debug overlay | Green "alt=ring? btns=17" top-left (harness overlay) | duplicate state; harness evidence |
| F13 | `screenshots/01-seat.png` | Axis, seat tier, entering a room | Warm umber-brown wash with a darker vertical shaft; single small coral point; rail "THE SEAT"; debug overlay | Fly-into-her-light approach (Wave 2) |
| F14 | `screenshots/02-seat.png` | Axis, recognition at the seat | Near-black; **"she was felt here · 01:31"** (cream system sans, ~15px) above **"and she felt you back · 01:31"** (italic gold Cormorant, ~24px); a glowing Bindu-light between; rail state **"FELT"**; debug overlay. Both lines show the same time | The two lines verbatim (BV2-L3); Recognition takeover typography; rail "FELT" mark (allowed as place, BC-13) |

### B3 · DU `scratch/` (Design's working captures of Ring Worlds II, the Veil and the May Mandala)

| # | Path | What it shows | Key visible values | Reference frame for |
|---|---|---|---|---|
| F15 | `scratch/01-r3-gather.png` | Ring Worlds II canvas with the Ring 4 Lineage frame on top (resting) | Header "Ring 4 · The Lineage" with gloss "the fourteen Sampradāya Śaktis · the teaching travels teacher → student · TOUCH A STATION · the center to send the teaching · lineage-tone". Phone: deep **green** radial ground; "Sarvasaubhāgyadāyaka · the Sampradāya" / "FOURTEEN · THE TEACHING TRAVELS THE LINE"; a 14-station garland of small triangles joined by inward-bowing arcs; centre dot; "The garland is unbroken — every name still passed, hand to hand." Behind: Ring 1 frames (three nested gold squares; "The ground you have walked, before you knew it was hers."; Vārāhī "MĀTṚKĀ · LANGUAGE", "the rooting tongue — speech that digs into the earth of meaning") | R4 garland mechanism (reborn, WV-09); HO2-04 |
| F16 | `scratch/02-r3-gather.png` (= F15) | identical | — | duplicate |
| F17 | `scratch/03-r3-gather.png` (= F15) | identical | — | duplicate |
| F18 | `scratch/01-r3-states.png` | Same canvas with the ring dropdown open | Menu lists Ring 1 Earth-City, Ring 3 Smoke Lotus, **Ring 4 The Lineage (selected)**, Ring 5 Overflow, Ring 6 Concealed, Ring 9 "The Bindu — Praveśa, the Endless Indwelling" (the six worlds of Handoff II) | Inventory of the six worlds |
| F19 | `scratch/02-r3-states.png` | Ring 3 Smoke Lotus, gathered (dropdown on Ring 3) | Gloss "the eight Anaṅgas · bodyless desire · TOUCH A PLUME (it never hardens) · the seed for all eight · longing-tone (lower-left)". Phone: dark wine ground; eight soft blurred **rose-copper plumes** in a ring; centre "hsauṁ" italic rose; footer hint "BE STILL TO LET HER GATHER · TOUCH A PLUME · THE SEED FOR ALL EIGHT"; silent toggle lower-left | **R3 gathered state**, the "Ring Worlds II → Ring 3" comparison target named in MBB-05/RFB-04 |
| F20 | `scratch/03-r3-states.png` (= F19) | identical | — | duplicate |
| F21 | `scratch/r3-live.png` | Ring 3, one plume touched | One plume (right) **glows bright warm cream-gold**; the others dim and blurred; caption "One longing felt · Anaṅgamadanā 2/2"; hint "TOUCH A PLUME · THE SEED TO FEEL ALL EIGHT" | **R3 active glow ladder** (active brightest vs dim others, RFB-04 Done-when) |
| F22 | `scratch/r3-r4-v2.png` | Ring 4, transmission in flight | Green ground; garland stations as faint triangles (arcs not yet drawn); one **bright travelling comet light** at the right station; caption "The Lineage · interactive · a transmission travels the line 1/2" | R4 transmission mid-flight |
| F23 | `scratch/r4-live.png` | Ring 4, partway | Arcs drawn from the top station clockwise to about the 5 o'clock station, which glows; caption "One station · received, and passed on 2/2" | R4 transmission progress |
| F24 | `scratch/r5-flood.png` | Ring 5 Overflow, all ten flooding | Gloss "the ten Kulottīrṇa Śaktis · overflowing what contains them · TOUCH ONE TO OVERFLOW · the center to transcend the kula · overflow-tone". Phone: dark **amber-gold** radial; ten outlined gold triangles pointing inward/outward around the centre; **long light rays spilling past** (no visible boundary circle); "Sarvārthasādhaka · the Kulottīrṇas / TEN · OVERFLOWING WHAT CONTAINS THEM"; caption "Transcending the kula · all ten overflow 2/2" (also in `.design-canvas.state.json`) | R5 overflow state |
| F25 | `scratch/r6-one.png` | Ring 6 Concealed, the light reaching one | Gloss "MOVE THE LIGHT (it reveals only what is near) · touch what it reaches · she will not stay". Phone: near-black **indigo/violet**; a soft violet glow reveals three small outlined triangles left of centre; caption "The light reaches one · she whispers, then conceals 2/2" | R6 concealment; ring 6 hue in Design = violet (C14) |
| F26 | `scratch/r7-twelve.png` | Ring 7 Vāk Sound Chamber, twelve voices | Gloss "Sarvarogahara · sound that heals · TAP A SYLLABLE TO HEAR HER · tap center for the chord". Phone: dark gold radial; **12 circles evenly at 30°** with bīja and name: aṁ Vāśinī (top), āṁ Kāmeśvarī, iṁ Modinī, īṁ Vimalā, uṁ Aruṇā, ūṁ Jayinī, eṁ Sarveśvarī, aiṁ Kaulinī, oṁ Vāṅmayī, auṁ Onmādinī, aṃ Mantreśī, aḥ Śaktimayī; centre ring; "tap a syllable · tap center for the chord"; counter **"2 OF 12 VOICES SOUNDED"**. Behind: Ring 2 Inhabited Lotus with the Sparśākarṣiṇī "uṁ / She who attracts Touch" invocation | Even-twelve fix target (RFB-06). **Names are Design's set, not the Airtable Ring 7** (C13); the counter is measuring copy (graded? it describes the chamber, borderline under BC-13) |
| F27 | `scratch/r8-check.png` | Ring 8 Mūla Trikoṇa resting | "Sarvasiddhiprada · the Mūla Trikoṇa"; triangle with **Icchā WILL** (red, apex), **Jñāna KNOWLEDGE** (violet, bottom-left), **Kriyā ACTION** (teal, bottom-right); centre red point; "The root triangle. Will, knowledge, action — one undivided power."; hairline; "TAP A VERTEX"; silent toggle; 1/5 | R8 resting frame |
| F28 | `scratch/r9-descent.png` | Ring 9 Praveśa (Direction B, chosen), start | "Sarvānandamaya · the Bindu / THE RING THAT IS NOT A RING"; deep **indigo-violet** vertical glow; a single small red point with white core; "Press and hold — fall inward."; 3/3 "B · Praveśa — the Endless Indwelling · hold to fall inward" | R9 Praveśa (WV-09 "Shepard fall") |
| F29 | `scratch/r9-full.png` | Ring 9 Spanda (Direction A), full bloom | "THE POINT THAT CONTAINS ALL POINTS"; full yantra in a square: an outer ring of 16 outlined gold petal loops with names, nested **red glowing triangles**, white Bindu; "She breathes, and the worlds appear." / "release · and they return to her"; 2/3 | **G17 centre bloom** (WV-03, RD-14): "the yantra drawn outward from the point while held" |
| F30 | `scratch/ring1-overview.png` | Ring 1 Earth-City, three frames (v1) | Warm umber-black. "Trailokyamohana · the Earth-City" (gold italic, tracked) / "28 FORCES · THE OUTER GROUND". Three nested gold-hairline squares with T-gates at the cardinals, 28 gold lights, a tiny crimson Bindu. Frame 1: "The ground you have walked, before you knew it was hers." Frame 2 **"Mātṛkā"** (gold Cormorant) / "THE EIGHT MOTHERS · LANGUAGE", middle square's 8 lights bright: "Eight mothers — language itself. You have known these as family, as the mother-tongue, as every name spoken in love. The world was spoken before it was seen." Frame 3 **"Vārāhī"** (cream) / "MĀTṚKĀ · LANGUAGE", one light ringed: "the rooting tongue — speech that digs into the earth of meaning" | **R1 Earth-City**: family band illumination and meeting a Śakti |
| F31 | `scratch/ring1-v2.png` | Same, v2 | Nearly identical; slight mote and position differences | iteration |
| F32 | `scratch/ring1-v3.png` | Same, v3 | Squares moved up and tighter; text sits higher with no clipping at the frame bottom | **latest R1 composition** |
| F33 | `scratch/ring1-focus.png` | Ring 1 (dropdown on Ring 1) zoomed on the Mātṛkā frame | Legend row "• Siddhi · ● Mātṛkā (lit) · • Mudrā"; hint "TAP A LIGHT TO MEET HER · A GATE TO LET THE WORLD IN"; caption "A family illumined · the eight Mothers (language) 2/4" | R1 family legend |
| F34 | `scratch/ring2-fix.png` | Ring 2 Inhabited Lotus: default and invocation | Left: "Sarvāśā-Paripūraka · the Sixteen"; 16 petals as F01, Sparśa glowing. Right (long-press today's petal): all others dimmed to ~18%, Sparśa bright, large "**Sparśākarṣiṇī**" (cream Cormorant) / "**uṁ**" (gold italic) / "She who attracts Touch" | R2 invocation (HO2-11, FB-21) |
| F35 | `scratch/ring8-fix.png` | **Mislabelled**: shows Ring 2 again (as F34) with more motes and a stronger Sparśa halo | — | R2 invocation, later pass. Filename does not match content |
| F36 | `scratch/current-mandala.png` | **The May-era shipped Mandala** (Mandala App v2) with tab bar | "2ND AVARANA · SARVĀŚĀ-PARIPŪRAKA" (gold caps) / "Home · Ring 3 Open · Rings 4–9 Ahead". 16 petals plus ring-3 leaf flanks in cluster colours; gold double triangles; crimson Bindu. **"5 of 16 Active · 2 Embodied"** progress line; five-cluster legend; hint "TAP TO ENTER · HOLD TO CATCH · BINDU FOR SILENCE"; tab bar TODAY / **MANDALA** (gold) / THE WELL | Historical "before" frame (DS-17 progress count, tab bar); **not a target** |
| F37 | `scratch/veil-rest.png` | The Veil, closed (the held yantra) | Black; header "2ND AVARAṆA · SARVĀŚĀ-PARIPŪRAKA"; full held yantra (Bhūpura square, 16 cluster-coloured petals with ring-3 leaf flanks, faint triangles, glowing red-white Bindu); bottom sheet handle with chevron "︿" and "THE NINE AVARANAS" (tracked gold caps) | **The Veil** (DA1-04; RESTORABLE Wave 2) |
| F38 | `scratch/veil-open.png` | The Veil sheet rising | Sheet up: "The Nine Avaraṇas" (cream Cormorant) with "DESCEND" (gold caps) on the right; yantra behind with a **red inner-triangle glow**; caption "the instrument · look, do not operate" (italic, faint) | Veil open state; held yantra dims behind |
| F39 | `scratch/veil-descent.png` | Veil, descending | As F38, with a larger diffuse red Bindu glow and motes | Veil descent transition |

### B4 · Extra, not assigned but viewed: DU `.thumbnail` (WebP, converted to PNG in scratch)

| # | Path | What it shows | Key visible values | Reference frame for |
|---|---|---|---|---|
| F40 | `DU/.thumbnail` | The Homes · the Axis (desktop) | "TRIPURĀ · THE FIRST ĀVARAṆA · FEET" / **"Trailokyamohana"** / "Topaz on Rasa · day–night"; canvas black (WebGL); rail TOTALITY · ABOVE CROWN · CROWN · FOREHEAD · THROAT · HEART · NAVEL · PELVIS · FEET; weather sentence "low light raking a vast floor, swinging horizon to horizon"; "SHE PRESIDES TODAY"; buttons ENTER HER · RISE · SOUND · GO DEEPER · THE LIBRARY · TODAY · STAY · FORGET ME; the hint "SCROLL TO CLIMB · DRAG TO TURN · TAP A LIGHT TO ENTER HER" **overlaps the ENTER HER button** | Climb chrome: rail of nine by body region, weather sentence, "she presides today", control vocabulary (Wave 2) |

**Gaps in the picture list** (no frame exists in my assignment for these; other readers' HTML may hold them):
- the six-archetype Today
- Her Presence
- the Recognition element natures
- the Field
- the Well
- the Portrait
- the Living Rite threshold "enter her ring"
- any room interior (the 3D captures are black by construction)

---

## C · Contradictions between documents (and which is newer)

| # | Topic | Older says | Newer says | Newest / governing |
|---|---|---|---|---|
| C1 | What opening the app shows | DS-16/CB0: Today tab first. HO1-08: no menu at all | FB-16 (28 May): the Mandala is home, Today in the hamburger. MBB-10/FH-16: the Daily Rite is the launch spine. THR-13: open where she is | WAVES WV-03: the Bindu Origin as Homecoming hands into Recognition; then appreciate → play |
| C2 | Status advance | DS-08/CB0-13: tap the pill to advance | FB-22: auto by thresholds, pill display-only. DA1/RFB: decide. MBB/FH/RBB: readiness sensed (1/3/7 from `serverRecognitionCount`) and a deliberate press-and-hold | RBB (built). RD-11: the "level 4 of 4" VoiceOver line stays unless he prefers otherwise |
| C3 | Ring gating | FB-19: rings 3–9 locked until "Enter this Avaraṇa" | MBB-12/FH-17: gated by content plus a deliberate crossing | RBB Ruling 2: open, permanently. BV2-P6: gating dead. RD-11: rooms' "descent gated until 62 s" reshaped to always offered |
| C4 | Nine ring worlds | HO2/FB-21 build; MBB/RFB repair | RBB Ruling 1: cut (3244f54). BV2-P6: dead | RD-14/WV-09: mechanisms reborn *inside* the rings, no separate screens (newest, 12 Oct) |
| C5 | Today's Śakti | DS-23 lunar; CB0-09 `floor(moon_age) mod 16`; MBB-07/FH-08 keep native lunar, scoped to descended rings | — | RBB Ruling 3: DailyEnergyService all-102 shuffle, 6 am boundary |
| C6 | Recognition storage | CB0-07, CB0-15, DS-23, MBB-02: local only, never synced | FB-22 Airtable rows. RBB Ruling 4: sync plus ledger | ERR-07 R17: App Activity is the single record; Mandala-table event rows zero forever; letter words stay on the Śakti row |
| C7 | Numbers and measurement | DS-17 and frame F36: "5 of 16 Active · 2 Embodied". HO1-13: factual numbers in lifetime context | MBB/FH/RBB/MTH: no numbers, ever. SH-04/BV2-L2: felt unlimited, never a digit | BC-13 (12 Oct): numbers may describe her, the structure, the place and the day; nothing grades him; he may ask to see his record. Frames F03 "78% FULL" and F26 "2 OF 12 VOICES SOUNDED" must be judged under this |
| C8 | Legibility floor | UXA: <11pt and <0.28α is a hard fail | DA1-12, MBB-02, FH-03, R2R-06: ≥11pt and ≥**0.3**α | AB-03 and BV2-P4 (FIDELITY rule 4): ≥11pt and ≥**0.5**α (newest; built in Phase 4) |
| C9 | Today name size | DS-06/RBB-12: 44–48pt | DA2-12 (July): 56–72px display | RBB (11 Jul) kept 44–48 and was built. DA2's "scale is reverence" is unresolved; Charter II "fuller" favours the larger |
| C10 | Ground colour | HO1-14: --ground #060104 | DS-03/CB0/R2R: #0D0508 (shipped). FB-10: noon bg #060104, dawn #0A0610, night #020308 | RD-07/WV-08: **Design's Mandala ground is indigo night**; crimson-black was a port loss. The Mandala sky is indigo (frames F08/F09); other grounds are per the Atmosphere engine |
| C11 | Cluster colours | HO1-15: Antaḥkaraṇa (Citta, Buddhi, Manas, Ahaṅkāra) violet #7A5A9A, Ātmā gold #D4A017; Citta appears in two clusters | DS-04/CB0: inner instrument (1–3) amber #D4A017, self·body·immortality (14–16) violet #7A5A9A | DS mapping, confirmed by frames F01/F34 (Kāma gold, Ātma violet). The Atmosphere engine now seeds from five cluster hues. HO1's table is wrong |
| C12 | Ring 2 bījas and locations | DS-09: 9 lṁ, 10 eṁ, 11 aiṁ, 12 oṁ, 13 auṁ, 14 aṃ, 15 aḥ, 16 kaṁ; Kāma heart; Bīja sacrum; Ātma heart | CRD-03 (Airtable): 37 ḷṃ, 38 ḹṃ, 39 eṃ … 44 aḥ; Kāma pelvic basin/gut/chest; Bīja deep belly; Ātma body's centre | Cards and Airtable win (BV2-L1). The F26 Vāk bīja labels follow a third (design) scheme |
| C13 | Ring 7/8 composition and numbering | HO2-12/RFB-06/F26: Ring 7 = 12 Vāk-devatās incl. Vāṅmayī, Onmādinī, Mantreśī, Śaktimayī. FB-21: 8 Vāgdevatās with Hz. XMB-01: R7 "Triangle (8)", R8 "Triangle (1)". RFB: the practitioner calls the Vāk chamber "Ring 8" | CRD-07/08 and KP-02: R7 = 8 Vāsinīs + 4 Weapons (87–98); R8 = 3 (99–101) | Airtable: 28·16·8·14·10·10·**12**·**3**·1. Any reborn "twelve-voice chord" (RD-14) must voice the Airtable twelve, not Design's names |
| C14 | Per-ring hue | HO2: R4 green-gold, R5 gold→cream, **R6 deep violet**; frames F22–F25 show R4 green, R5 amber, R6 violet. FB-09: R4 blue-violet, R5 green-gold, R6 rose-violet | HDP-05/THR-03/CCH-01: Atmosphere hues (R4 crimson 353°, R5 coral 18°, R6 **teal 194°**, R7 wine 322°); gem light gives quality, not hue. RD-08: "gem hues" were dropped by restraint ("the gem bends; it never colours") | Atmosphere hues stand. RD-08/RD-11 return gem colour as light. A reborn Ring World mechanism should take light from Atmosphere plus its gem, not the May world palettes |
| C15 | Breath rates | DA1-13: Bindu at 4 s, 2.25 s, 6 s and still, inconsistent; wants "slower the deeper" | HO1-16: R2 3 s with today 3.5 s; R1 none | RD-13: restore 3/8/9/11/13/15/18 and 4 s. RD §9 paradox: one clock vs many tempos (held, not resolved) |
| C16 | Time-state windows | FB-11: dawn 5–8, noon 11–2, dusk 5–8, night 9–5, with **gaps at 8–11, 2–5 and 8–9**; new moon at phase <0.03 | FH-07: dawn 5–9, noon 9–16, dusk 16–20, night otherwise (4 states) | RBB 2.3: keep five states including `newmoon`; FH windows |
| C17 | Daily summons | CB0-17: every 3 hours. MBB-08/FH-16: one a day, default early evening, "She is waiting." | AR-11/CCH-03: shipped 6 am, title her name, body her quality; THR-13 | Shipped 6 am stands; WV-10 adds a random gift notification (Wave 5) |
| C18 | Ceremony lines and timing | DS-19: act 1 "**Logged** · [time]", act 2 at +3 s, gold. CB0-08: "she was felt here", act 2 three seconds later | FH-11/RBB-14: "She was felt here" (capitalised) / "and she felt you back". AR/DAB-02: shipped 2.6 s / 4.1 s / 5.1 s, accentBright | BV2-L3/BC-13: the lines verbatim in lower case, "she was felt here" / "and she felt you back". "Logged" is dead. Frame F14 shows the same time on both lines |
| C19 | Sound policy | HO2-01: only on a gesture, a discreet toggle, quiet. FH-12: chimes opt-in, default off. THR-18: sound on gates only | XMB-05: continuous drone. BV2-P6: ring drone dead. ERR-09: descent silent | BC-09 (12 Oct): sound is everywhere, begins on the first touch; ring voices wired; the descent sounded (RD-11) |
| C20 | Restraint vs fullness | Charter I (20 Sep, in history): choose the more restrained option. XMB-10: VFX at three moments only. DA1-07: editing, not adding | SH-03: proximity/focus | BC-03: build the fuller version; light stands in the air; HDR and bloom on |
| C21 | Reduced motion | MBB-02/FH-03/DS-21: honour it (loops pause) | CCH-19(4)/THR-18: "longer and quantized, never disabled" for the Homes | Both stand, scoped: app loops gate (FIDELITY); Homes adaptation stretches rather than disappearing |
| C22 | Stillness as input | HDP-03/EXP-12: the portrait surfaces "at the pace of stillness"; fidget and it waits. XMB-03: noticed only if you're still. HO2-03: R3 gathers in stillness | MTH-09/CCH-19(1): time is elapsed, never stillness; stillness may govern arrival only | Method's rule is locked for the Homes. Reborn R3 "gathers in stillness" and Tratak "earned by stillness" are arrival uses, which is allowed. THR-17 Trikhaṇḍā "only in stillness" is an internal tension inside the thread |
| C23 | Figures | XMB-08: 6–8 hand-drawn postural silhouettes | SH-06/BV2-L4: aniconic, shapes performing actions | BC-13: no *figural* depiction; light, glow, gems and geometry welcome; words naming a hand are fine. RD-08: "her form at seat zoom" was refused, now returnable only aniconically |
| C24 | Content completeness (Ruling 7) | RBB-09/MBB-03: the 86 are ~{name, ring, pos}. GH-05: the Homes cards are the content pass | GH-07/BV2-R14: closed, all 102 complete | RD-03 (12 Oct live read): Function empty on the 16; Bīja 36/102; no Phonetic field; somatic prose only for the 16. "Closed" was too strong; Wave 0 fixes the data |
| C25 | `all-shaktis-data.js` | DU MTH:20–21: "authoritative". FB §4 lists it as data. THR-15: counts read from it | KP-03: non-canon. R2 MTH:20–21: superseded | SUP-01/BV2-L1: a ghost, never read. **The DU upload still carries the old method line and an unquarantined copy at the top level** |
| C26 | Which brief governs | FH-01 supersedes CCB, HO1 and HO2. GH-01: RBB supersedes MBB | RBB-01 supersedes R2 README and DESIGN_SPEC. BV2 supersedes RBB as roadmap (Rulings 1–8 stand). CN amends BV2 | Charter II plus WAVES plus THE READING (12 Oct). "No rule stands because it came first" |
| C27 | The name `DESIGN_SPEC.md` | DU `DESIGN_SPEC.md` = the May 16-Karṣiṇī spec (md5 1c04f75d75) | R2 `DESIGN_SPEC.md` = Final Handoff (md5 fbb07a6432; also DU `design_handoff_living_rite/DESIGN_SPEC.md`) | Two different files share one name. FB and CB0 mean the May one; R2 README means the Living Rite one. Cite by path |
| C28 | Missing brief | FH:137 refers to "`Bindu Mandala - Claude Code Brief.md` §3" for Phase-1 line detail | RBB-17: "does not exist by that name" | It **does** exist in DU (its H1 reads "Master Build Brief"). Moot, since Phase 1 was cut |
| C29 | Room count | BV2 Phase 3.6: "Rings 3–9 (74 rooms)" | ERR-03/CN-03: 58 | 58 |
| C30 | Authored rooms | CCH-08: "Nine so far" (eight named). THR: "Seven mechanisms are authored"; "nine mechanisms" table with eight rows; "All eight are Ring 1" | ERR-04: kp {1,2,3,4,6,27,28,102} | Eight (RD-01) |
| C31 | Harness size | THR-06: "46 checks, 0 failing"; MTH/THR: six defects found | CCH-21/RMF-03: 66 checks; "failed eight times" | 66 checks (later docs) |
| C32 | The Gate | SH lock: Laghimā/Garimā unmistakable "with zero hand-work" | BV2-R10/ERR-08/CN-02: authored gate accepted (released 6 Sep) | Authored |
| C33 | Mauna/Silence | DS-20/FB-23: a Silence screen from a Bindu tap, four captions | 3244f54 retired it. BV2-R11: reborn as the dwelling (62 s → `.silence`). BV2-P6: the old screen dead | RD-14/WV-09: Mauna "tap the centre for silence" restorable (Wave 2), alongside R11's `Silence Held`. RD-15: silences must not count as "felt" |
| C34 | Ring 9 personal connection | FB-19: Personal Connection on the threshold; the R9 world appended it | MBB-05/RFB-07: delete it from the R9 descent; end in silence | HDP/EXP-15/BV2-3.10: Personal Connection as marginalia on ring walls. ERR open: existing field or new text? Never as a trailing caption on Praveśa |
| C35 | Hamburger | HO1-08: no hamburger | FB-16: minimal hamburger. DA1/MBB: first-run breath. DA2-10: order | BV2-C9: Settings last. Charter II/RD: "there is no menu" grammar restorable alongside |
| C36 | Auto-descent at deep zoom | FH-12: auto-fires on deep zoom near centre | RBB-15: recommends a chosen tap (never auto-advance) | Unresolved in my files; check DECISIONS/code |
| C37 | Detail ordering | FB-18: codex portrait 6th, Devanagari 1st | DA1-10/RFB/DA2-06: lead with portrait and somatic; go-deeper fold | BV2-R12: the Homes room replaces the top; Detail is the library |
| C38 | Carrier roots | CCH-18: from varṇamālā order above the ring root | BV2 2.3: the ring root from RingAudioService constants | ERR-09: Design's ROOTS table 55 → 123.47 Hz |
| C39 | The "Ring 7 Vāk" bell/chime counts | R2R-04: "each of the 8 enclosures rings a bell" | FH-12: chime per enclosure | Counts should follow the nine āvaraṇas (minor) |
| C40 | The DU upload vs the repo | DU still holds `Final Handoff.md` (deleted in the repo per RBB-17), the old method, the old github.md and an unquarantined `all-shaktis-data.js` | Repo R2 has the corrected copies | Treat the repo copies as current. RD-10 confirms the handoff Code received is byte-identical apart from those fixes |

---

## D · COVERAGE PROOF

Line counts come from `wc -l`. Read's numbering can show one more line where the file lacks a trailing newline. Duplicates were proven with md5 (first 10 hex shown) and are counted as read once their twin was read in full.

| File | Total lines | Lines read | Notes |
|---|---|---|---|
| DU `Bindu Mandala - Master Build Brief.html` | 311 | 311 → 125 text lines, all read | extracted via `python3 -I` `h2t.py`; tags keep source lines |
| DU `Bindu Mandala - Refinement Brief.html` | 282 | 282 → 100 text lines, all read | same |
| DU `Bindu Mandala - Design Audit.html` | 419 | 419 → 87 text lines, all read | same; includes the legibility table |
| DU `Bindu Mandala - Audit II.html` | 279 | 279 → 58 text lines, all read | same |
| DU `Bindu Mandala - Final Handoff.md` | 187 | 1–187 | md5 fbb07a6432 = R2 `DESIGN_SPEC.md` |
| DU `Bindu Mandala - Claude Code Brief.md` | 296 | 1–296 | H1 says "Master Build Brief" |
| DU `Bindu Mandala - the method.md` | 172 | 1–172 | R2 copy differs only at :20–21 (diff read) |
| DU `Bindu-Mandala-Handoff.md` | 224 | 1–224 | |
| DU `Bindu-Mandala-Handoff-II.md` | 144 | 1–144 | |
| DU `DESIGN_SPEC.md` | 223 | 1–223 | the May spec (md5 1c04f75d75), not the R2 one |
| DU `github.md` | 83 | 1–83 | R2 copy adds :84–87 (diff read) |
| DU `uploads/bindu-mandala-master-brief.md` | 199 | 1–199 | CC copy = this plus :5–6 errata and :168–169 (diff read) |
| DU `uploads/homes-design-package.md` | 132 | 1–132 | = CC = R2 `homes/source/` (md5 a849437787) |
| DU `uploads/homes-shakti-cards-rings-1-2.md` | 367 | 1–367 | = `-978c247c.md` = CC = R2 source (md5 38a8e7023c) |
| DU `uploads/homes-shakti-cards-rings-1-2-978c247c.md` | 367 | identical | md5 match |
| DU `uploads/homes-shakti-cards-rings-3-9.md` | 511 | 1–511 | = CC = R2 source (md5 27871df293) |
| DU `uploads/Screenshot 2026-05-27 at 6.58.14 PM.png` | image viewed | — | F01 |
| DU `uploads/Screenshot 2026-05-27 at 6.58.45 PM.png` | image viewed | — | F02 |
| DU `uploads/Screenshot 2026-05-27 at 7.59.20 PM.png` | image viewed | — | F03 |
| DU `screenshots/` 11 files | 11 images viewed | — | F04–F14 (03-axis = 02-axis, md5 f101eaf20a) |
| DU `scratch/` 25 files | 25 images viewed | — | F15–F39 (01/02/03-r3-gather identical; 02/03-r3-states identical) |
| DU `.thumbnail` (extra) | image viewed | — | F40 (WebP → PNG) |
| `CB/Bindu-Mandala-Final-Brief.md` | 1023 | 1–1023 | two reads (1–520, 520–1023) |
| `CB/CLAUDE_CODE_BRIEF.md` | 304 | 1–304 | |
| `CB/UX-AUDIT.md` | 227 | 1–227 | |
| `CC/README.md` | 35 | 1–35 | |
| `CC/PACKAGE-START-HERE.md` | 36 | 1–36 | |
| `CC/SESSION-HANDOFF-2026-09-06.md` | 105 | 1–105 | |
| `CC/BINDU-MANDALA-BUILD-BRIEF-V2.md` | 270 | 1–270 | |
| `CC/BUILD-BRIEF-V2-ERRATA.md` | 184 | 1–184 | |
| `CC/BINDU-MANDALA-AUDIT-BRIEF.md` | 221 | 1–221 | |
| `CC/AUDIT-REPORT.md` | 501 | 1–502 | two reads (1–335, 336–502) |
| `CC/DEVICE-AUDIT-BRIEF.md` | 137 | 1–137 | |
| `CC/AUDIT-REPORT-DEVICE.md` | 169 | 1–169 | |
| `CC/CHAT-NOTE-TO-CODE-2026-09-20.md` | 93 | 1–93 | |
| `CC/bindu-mandala-expansion.md` | 140 | 1–140 | |
| `CC/bindu-mandala-master-brief.md` | 203 | 1–203 | 199 shared lines read in the DU copy, plus the 4 added lines from the diff |
| `CC/homes-design-package.md` | 132 | identical | md5 match to DU |
| `CC/homes-shakti-cards-rings-1-2.md` | 367 | identical | md5 match |
| `CC/homes-shakti-cards-rings-3-9.md` | 511 | identical | md5 match |
| `R2/README.md` | 163 | 1–163 | |
| `R2/KP-ORDERING-FINDINGS.md` | 46 | 1–46 | |
| `R2/RECONCILED-BUILD-BRIEF.md` | 171 | 1–171 | |
| `R2/DESIGN_SPEC.md` | 187 | identical | md5 = DU Final Handoff |
| `R2/homes/READ ME FIRST.md` | 68 | 1–68 | |
| `R2/homes/Claude Code Handoff - The Homes.md` | 411 | 1–411 | = DU copy (md5 12df41d0f3) |
| `R2/homes/The Homes - the thread.md` | 407 | 1–407 | = DU copy (md5 380b24454b) |
| `R2/homes/Bindu Mandala - the method.md` | 172 | 1–172 | DU read plus a diff at :20–21 |
| `R2/homes/github.md` | 87 | 1–87 | DU 83 plus diff :84–87 |
| `R2/homes/_superseded/README.md` | 6 | 1–6 | |
| `R2/prototype/_superseded/README.md` | 11 | 1–11 | |
| `R2/homes/source/*.md` (3) | 132 / 367 / 511 | identical | md5 matches |
| `BUILD-CHARTER.md` | 85 | 1–85 | |
| `WAVES.md` | 120 | 1–120 | |
| `waves/THE-READING-2026-10-12.md` | 426 | 1–426 | |

**Totals:** 52 text files (34 distinct contents after md5 dedup, each read in full); 40 images (36 distinct, every file opened). Nothing was sampled.

**Not in my assignment and not read:** DU `design_handoff_living_rite/` (its README differs from R2's, md5 a15ec04 vs 4468ec5; its DESIGN_SPEC = Final Handoff), DU `handoff/`, all `.jsx`/`.js`/other `.html`, R2 JS modules and HTML, `Claude Designs/`. They belong to the other readers.

---

## E · Must-not-miss

1. **Charter II overrides everything older.** "When in doubt, build the fuller version. Design is the floor, never the ceiling." No rule stands because it came first (BC-01, BC-03).
2. **Six walls survive:**
   - practice data sacred (never reinstall; install over)
   - position (`khadgamalaPosition`) is identity
   - App Activity is the single ledger (R17), with zero event rows in the Mandala table
   - the two lines verbatim, lower case: "she was felt here" / "and she felt you back"
   - no figural depiction
   - nothing grades him; numbers may describe her, the place and the day
3. **The parity targets are Design's frames, not the shipped app.** Every visual wave needs a look check against them (BC-14). Frame F36 is the May app's "before", not a target.
4. **The Mandala sky is indigo night, not crimson-black** (F08, F09; RD-07). Lalitā's finale is a full-frame red bloom (F10).
5. **Port losses are the class to fix**: stroke ×1.7 never applied plus the 0.9/0.7 dimmers; lrBackdrop collapsed; motes invisible; staged arrivals; six recognition natures flattened; the yantra lost its gates, lotus rings, circles and shimmer. Design room luminance is ~80–255 against Code's ~11–65 (RD-06, RD-07). The same class was found in May for the Ring 3 brightness port (RFB-04): fix the rule, not the instance.
6. **Ring Worlds return inside the rings, not as nine screens** (WV-09). Their Done-when criteria still apply:
   - R3's active plume visibly glows warm against the dim others (F21)
   - R7's voices are evenly distributed with none overlapping (F26)
   - R6 names reliably without pixel-hunting
   - R1's 28 lights are hittable at ≥44pt
   - R9 ends on "You did not arrive. You were the arriving." and then silence, with no trailing Airtable text
7. **Ring 7 has twelve in Airtable: 8 Vāsinīs plus 4 Weapons.** Design's twelve-voice chamber names (Vāṅmayī, Onmādinī, Mantreśī, Śaktimayī) and the master brief's "Triangle (8)/(1)" are non-canon. Voice the Airtable rows (C13).
8. **Two files are called `DESIGN_SPEC.md` and they differ.** The DU one is the May spec; the R2 one is the Living Rite Final Handoff (C27). The DU upload also carries the stale method line "all-shaktis-data.js is authoritative". The ghost roster is never data.
9. **Cluster colours follow DESIGN_SPEC and the screenshots**: inner instrument amber, self·body·immortality violet. Handoff I's cluster table is wrong (C11).
10. **Ring 2 bīja and body locations come from the Airtable cards**, not the May spec list (C12).
11. **Readability floor is ≥11pt and ≥0.5α** (FIDELITY), not the 0.3α in the Design briefs. Touch targets are ≥44pt everywhere (C8).
12. **Breath rates to restore**: 3/8/9/11/13/15/18 s, with the Bindu at 4 s; R1 does not breathe. Also five time states including new moon (desaturate, Bindu 1.6×), triangles at 0.585, 8 s shimmer, Bindu ×1.28 (RD-13, FB-10).
13. **Gem light per ring is a behaviour (diffusion)**: R7 pearl is sourceless with no directional light; R8 is one travelling chatoyant band; the hue comes from Atmosphere (CCH-06, THR-16). The per-band physics list in RD-12 is the Homes parity checklist.
14. **Homes features composed but never shown**: rail of nine, crown light, 102 lights on the climb, fly into her light, neighbour doors (cluster/family first), the letter as a folded object, floor traces, "you have stood here before" (once), the Siddhi after-effect (~180 s), and "forget me" (THR-14, RD-08, RD-12).
15. **Recognition ceremony responds in her element**: fire flares up, water pools, air disperses, ether blooms once and holds, earth settles, light radiates. The note never dismisses the moment; it collapses inward into the Portrait. Shipped timing is 2.6/4.1/5.1 s (FH-11, DAB-02).
16. **Sound is everywhere now** (BC-09): ring voices wired, the descent sounded, existing pitches kept, new sound at 136.1/110 Hz. This reverses BV2 "drone dead" and ERR "descent silent". The carrier roots table (55 → 123.47 Hz) and "the fifth withheld" stay.
17. **The rite of entering is never skipped and has no cancel.** It compresses on return to a floor of 0.36. The 2.2 s held way out stays, with Escape/left-edge added. The descent from a room is always offered; dwell deepens it (RD-11).
18. **Time is elapsed, never stillness-tied** for the Homes; stillness may govern arrival only. Reduced motion in rooms is longer and quantized, never disabled (CCH-19, MTH-09).
19. **Data gaps still open** despite "Ruling 7 closed": Function empty on the 16; Bīja 36/102; no Phonetic field; count mirror drift 51 vs 59; Lunar Day 0–29 vs 1–30; ring fields typed into Swift rather than read live (RD-03).
20. **Known defects to fix in Wave 0** (RD-15):
    - motes invisible on fire/water days and in the Portrait
    - silences counted as "felt"
    - `didSettle` jumps to the Portrait from a room
    - Detail always sends `.mandala`
    - the letter editor loses words on a background kill
    - the offline queue drops after 3 failures
21. **The WebGL captures are black by construction** (F07, F40). Homes parity must use readPixels luminance (THR-11 ranges) or device captures, not DOM screenshots.
22. **Frame defects to avoid repeating**: the Cosmic Now label collisions (F03); the Axis ring labels offset from their dots (F11); the Axis hint overlapping the ENTER HER button (F40). `scratch/ring8-fix.png` actually shows Ring 2.
23. **Personal Connection never trails the Ring 9 fall.** It belongs on ring walls as his marginalia, in his own words. Whether that text is the existing Avaraṇa field or new is still open (ERR "Open").
24. **"I feel her" is the only saturated red CTA** (UXA-08). Wave 1 puts "her hue in the pill" (RD-13); keep it unmistakable as the primary gesture.
25. **Embodiment readiness thresholds are 1/3/7 from `serverRecognitionCount`**, crossed by a deliberate press-and-hold. "Readiness is sensed; crossing is chosen" governs status, not the descent (RBB-02).
