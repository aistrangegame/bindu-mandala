# U1 · Part C · Look — report

Branch `u1-c`, from `upgrade` at `f22eb7e`. Built from `U1-instruments.md` Part C, `U0-ground.md` (the environment and floors), `UPGRADE-MAP.md` and `worlds/visual.md` §1.3–1.15 and §2, plus the U0 `Theme/` files and `Element.swift`. There's no compiler here. Every type the new code calls was read before it was used. The Swift targets iOS 17 and Swift 5 mode, which is the project's setting.

**Nothing outside `iOS/Bindu Mandala/Look/` was edited.** No hooks were needed. The test file and this report are the only other new files. `Theme/`, `BreathClock`, `FieldBreath`, `Atmosphere`, `TimeVariant`, `Element` and `Haptics` are all unchanged. Look extends or wraps each of them, as listed below.

## Files

| File | What it holds | `visual.md` |
|---|---|---|
| `Look/LookColor.swift` | `LookColor` (sRGB + alpha, hex in and out, composite over a ground) · `OKLab` (exact `color-mix(in oklab)`) · `Contrast` (WCAG ratio, the floors, `readable(accent, on:)` lifting toward cream 1 % at a time in oklab, `paperAccent` = oklab 50 % with `#191919`) | §1.4.4, §1.9, §1.14, §2 #7 |
| `Look/LookType.swift` | `TypeFamily` (the 16 faces + Cormorant + system), `TypeFace`, `TypeToken` (size floored at 11 pt, tracking in em, caps), `.lookType(_:)`; fallback rule; `toBundle` list | §1.15, §1.4 type rows |
| `Look/LookMotion.swift` | `MotionCurve`; `LookMotion` (veilLight/-Bloom, veilDark, descent, waking, surfacing, sheetRise, boardHop, verb, verbWorld, blinkLids, lightReach, nameFade, rkOut, soft; base durations; dark-first 0.4 / rise 1.4; type swap at 45 %; `veil(into:)` light vs dark by ground luminance > .5); `LookPace`; `LookSpace` | §1.4 motion, pace, space; §2 #40–41; §5 |
| `Look/Depth.swift` | `ChromeStep` (100/80/60/25/0 %, per-world table, ring and Climb-band tables, Zero Gap labels, 4 s wake, surface mark α .25) · `DepthColour.point(depth:)` (oklab gold → ember) · `.chromeDepth(_:awake:)` · `.wakesChrome($awake)` / `ChromeWake` | §1.8, §1.9 |
| `Look/Breath.swift` | `extension BreathClock` (`livePeriod(grammar:score:)` **unsnapped**, `phase(at: Date, period:)` on the one epoch) · `BreathEnclosure` (nine periods incl. home petal **3.5 s**, peaks, petals by relationship 3.5/4.5/6/7.5/10, stagger .18, down-triangles 10–18) · `WorldBreath` (per-world period, ring × tempo, world glow 0 → .07 / 12.5 s) | §1.6 |
| `Look/ShaktiPalette.swift` | `Relight` (the settled §1.5.3 table including the new-moon row) · `ElementLayout` (six archetypes, motes, backdrop breaths, tint `hsl(h,55,68)`, ether 280°) · `ShaktiPalette` (kp → ring → cluster → element (ruling 4 table first) → seed; jitter; composition; settled windows; `atmosphere(kp:at:)`; `motes` reads moteMul; oklab grounds; ring wash/deep) | §1.5 |
| `Look/CanonColour.swift` | `ColourSource` precedence + `resolve` · `HouseTokens` (the full house set incl. ink-2, crimson-lit, gold-bright, ember, status-as-light, text ladder) · `RingLook` (§1.4.4 nine rows: hex, wash, deep, legible text, fog, density, veil, tempo, gem, breath, chrome) · `CanonColour` (Map hex per room from the bake, six-step contract, dyads 10–19, dyad light, SCENE grounds 21–33, Mind triad fills, next-colour rhyme) | §1.11, §2 #4, #6–7, #57–59 |
| `Look/WorldStyle.swift` | `StudioLanguage` (13) · `WorldColours` (roles) · `WorldTypes` · `LanguageStyle` · `WorldStyle.of(WorldID)` for all 15 worlds + inner languages (linen, play, candle, candle sheet, learning dark, ascent sky, paper) · `personHue` · `EnvironmentValues.worldStyle` / `.worldStyle(_:)` | §1.3, §1.4.1–1.4.15 |
| `Look/ThePoint.swift` | `PointLook` (§1.10 table per world; ring/mandala/climb helpers) · `TratakLight` (off / always / afterStillness: onset 20 s, full 45 s, dissolve .6 s; the C-1222 sum-of-sines path ± 7 pt; cream .55, 9 pt, blur 6) · `ThePoint` view (halo, core, cream heart, optional glows, white light behind; breath on the one epoch; tap / hold callbacks; one accessibility element "The point" with default action and a "Hold" action, identifier `the.point`; ≥ 44 pt target) | §1.10 (+ spine-and-home #18, mandala-and-rings M12) |
| `Look/ReducedMotion.swift` | `ReducedMotion` covers the seven classes: decorative loops pause; adaptation is quantized (a 4 steps, b 3) and lengthened (160 / 190 / 150 s); breath becomes an opacity step each half-period; crossings and flights become a 0.2 s cross-fade with no sound and type swapped at the midpoint; holds keep their length and fill in 4 steps; text appears whole | §1.13 |
| `Bindu MandalaTests/U1LookTests.swift` | 24 tests (below) | — |

## Wrapped or extended, never duplicated

- **Atmosphere:** `ShaktiPalette.atmosphere(kp:at:)` calls `Atmosphere.derive` and returns an `Atmosphere`, so every existing consumer can take it. With no hour, the result equals `Atmosphere.derive` exactly, and a test asserts this for all 102. With an hour, the settled relight is applied through Atmosphere's own memberwise init. The ground tint keeps `Atmosphere.timeTint`'s values. The new-moon tint `#04030C` at .18 was already the same.
- **RiteComposition:** `ShaktiPalette.composition(kp:)` is `RiteComposition.derive(kp:element:)`. Flip, spin, sigil scale and name tier are not re-implemented.
- **BreathClock:** additions are by extension only (`livePeriod`, `phase(at: Date, …)`). The epoch and the phase curve stay as they are.
- **Element:** Look reads `Element.forRing2(kp:)` and `Element.forRing(_:)`.
- **KhadgamalaMap and Cluster:** Look reads `ringNumber`, `perRingIndex` and `Cluster.forPosition`.
- **ChakraConstellation:** Look reads `colorHex` and `colorDyad` from the bake. No hex is retyped for the rooms.
- **AppFont and Hit:** type tokens resolve through `AppFont.style(forSize:)`, `.sanskrit` / `.voice` and `labelPointSize`, so Dynamic Type behaves as it does today. The point's target uses `Hit.min`.
- **DustMotesView.Motion:** `ElementLayout.motes` reuses it.

## For U2 (left untouched under "add, don't break")

1. **`FieldBreath.period(ring: 2)` is still 3 s.** It is pinned by `DayLightTests` line 287 and `WaveSixMemoryTests` line 237. Its callers should move to `BreathEnclosure` (3.5 s), and those two assertions should be rewritten.
2. **`BreathClock.period(grammar:score:)` still snaps.** Its one caller is `ScoreLightVeil`, which should switch to `BreathClock.livePeriod`.
3. **`TimeVariant.modulation.newmoon` is still Wave 1's invented row** (−16 / 1.12 / .4), pinned by `TimeVariantModulationTests` line 13. Consumers should move to `ShaktiPalette.atmosphere` / `Relight`, which use the settled −12 / .55 / .5. Then retire the old row.
4. **`LunarPhaseService.currentTimeVariant` uses the old windows** (dawn 5–10, noon 10–15, dusk 15–21). The settled C16 windows are `ShaktiPalette.timeVariant(hour:lunarPhase:)`.
5. **`Element.parse(tattva:)` still has no `light` branch.** Its words would be "light", "sat", "pure being" and "prakāśa" (§1.5.4). This was not mine to edit. Look reaches light through the ruling-4 kp table, which governs.
6. **`Atmosphere.ground` blends in sRGB.** The oklab grounds are in `ShaktiPalette.ground` / `groundDeep`.
7. **Haptics is Part D's** (Core Haptics), so Look defines no haptics.
8. **Crossing timings.** Look holds only the visual numbers: dark-first, rise, type-swap fraction and `veil(into:)`. The `Crossing` primitive is Part A's and should read these.

## API assumptions I could not verify without a compiler

- **Font PostScript names** for the faces not yet bundled follow the `Family-WeightStyle` pattern (`TypeFace.postScriptName`), e.g. `Lora-Italic` or `DMSans-Medium`. When each file is added, its real name must be checked. A wrong name only means the fallback face is drawn.
- `switch` over `Font.Weight` with `case .light:` patterns works through `Equatable` `~=`, with `default` present.
- `Atmosphere`'s implicit memberwise init (`hue:element:glowAlpha:rotation:timeKey:`) is internal. `Atmosphere.derive` already uses it.
- `ThePoint` has `@State private var` / `@Environment private var` with defaults. This keeps the memberwise init internal, the usual SwiftUI pattern.
- `ImageRenderer` (iOS 16+) renders a `TimelineView` in a hosted unit test (`testThePointRendersInEveryWorld`, `@MainActor`).
- `View.tracking(_:)`, `.textCase(nil)` and `Font.system(size:weight:design:)` are all iOS 16+.
- `accessibilityAction(named: Text(…))` is used, plus `accessibilityAddTraits(cond ? .isButton : [])`.
- Several names could collide with the parallel parts (A/B/D). Before merging, check that none of them defines `LookColor`, `OKLab`, `Contrast`, `ChromeStep`, `DepthColour`, `BreathEnclosure`, `WorldBreath`, `Relight`, `ElementLayout`, `ShaktiPalette`, `ColourSource`, `HouseTokens`, `RingLook`, `CanonColour`, `StudioLanguage`, `WorldColours`, `WorldTypes`, `LanguageStyle`, `WorldStyle`, `PointLook`, `TratakLight`, `ThePoint`, `ReducedMotion`, `MotionCurve`, `LookMotion`, `LookPace`, `LookSpace`, `TypeFamily`, `TypeFace` or `TypeToken`. The existing app defines none of them. `ThePointView` (Memory) is a different name.

## Faces still to bundle (§1.15)

The app currently ships only `CormorantGaramond-Light.ttf` and `-LightItalic.ttf`. Still to add:

- Cormorant: Regular 400, Medium 500 and Italic 400.
- Lora: 400, 400 Italic and 300 Italic.
- DM Sans: 400 and 500.
- DM Mono: 300 and 400.
- Cinzel: 400.
- EB Garamond: 400 and Italic.
- Fraunces: 300 and 400 Italic (opsz).
- Spectral: 300 and 400.
- Instrument Sans: 400 and 500.
- Instrument Serif: 400 and Italic.
- Newsreader: 300 Italic and 400.
- Gloock: 400.
- Inter: 400 and 500.
- Geist: 400.
- Geist Mono: 400.
- Space Mono: 400.
- JetBrains Mono: 300 and 400.

Until each is added, a token draws in its fallback. Cormorant weights that aren't shipped fall back to the bundled Light or Light Italic. Every other family falls back to the system face of the same design (serif, sans or mono) at the token's weight, scaled with Dynamic Type.

## Numbers the sources do not give (I chose these; they are marked in the code)

- **Game point size: 7 pt.** §1.10 gives only "9 s" and the colour. 7 pt is the common point size.
- **Candle (Pūjā) Cinzel: 13 pt.** This is the field's UI size. The candle sheet is 17 pt and EB Garamond in learning-dark is 24 pt. §1.4 names the faces but not these sizes.
- **Breath under Reduce Motion:** the opacity during the second half of the period is `1 / peak`. §1.13 says "opacity step" but not how deep.
- **The 33's six-step "+18 L"** is read as oklab L + 0.18. **The dyad's "+40 L"** is read as oklab L + 0.40.
- **The rings' "period × world tempo"** is read as the world clock running at `tempo`, so the period is `p / tempo`. A slower world breathes longer, consistent with law 7.
- **Beneath's chrome at rest** is the step nearest its point depth (.9 → 0 %). §1.8 names only "Beneath's deepest band".
- **ThePoint's hold is a 0.9 s long press** (Home's deep-zoom hold) until U2 moves it to Part D's one hold engine.
- **The home point** is drawn as a core of `size` (10 pt) with a halo of `size × 2.6` (26 pt). This matches both §1.10's "10 pt core" and spine-and-home's "26 pt".
- **The C-1222 wander** leaves out "0.3 % per-frame chance of a new drift" (non-deterministic). It is the sum-of-sines path only.

## The tests (`Bindu MandalaTests/U1LookTests.swift`) and how each can fail

Each comparison goes through a checker that returns its failures. Each test also runs that checker on a planted defect and asserts that it complains (marked "born red").

| Test | Reads | Fails when | Planted defect |
|---|---|---|---|
| `testHouseTokensAreDesignSpecs` | `Design/Corpus/DESIGN_SPEC.md` (parsed) | any house token ≠ the spec's hex | ground `#0D0509` |
| `testMandalaSkyIsDesignsIndigoWell` | `living-rite-mandala.jsx` (regex on the radial) | well centre / 60 % / rim ≠ `WorldStyle.mandala` | the house ground is not the well |
| `testSeedsAreDesignsRingAndClusterHues` | `living-rite-core.jsx` `LR_RING_HUES`, `LR_CLUSTER_HUES` | any seed for ring 1, 3–9 or the five clusters differs | ring 6 hue 195 |
| `testJitterAndCompositionAreDesignsFormulas` | the formula text in `living-rite-core.jsx` + independent evaluation for kp 1–102 | frac, jitter, flip, spin, sigil scale, name tier differ | wrong multiplier 2654435769 |
| `testRelightIsDesignsFourHoursAndTheSettledNewMoon` | `LR_TIME_VARIANTS` parsed; new moon typed from §1.5.3 | any delta, tint, tintA or moteMul differs | Design text with dawn dh 9 |
| `testTheSettledWindowsAndTheNewMoon` | §1.5.3 / C16 | an hour lands in the wrong window, new moon overrides day, moteMul unread | dusk count must change |
| `testPaletteIsDeterministicForAll102AtEveryHour` | — | any of 102 × 6 derivations non-deterministic, outside ±7°, out of clamp, ≠ `Atmosphere.derive`, or neighbours share a hue | (built-in: the neighbour and ±7° clauses) |
| `testRuling4ElementsAndEtherAt280` | §1.5.4 | kp 31/40/42/43 elements, archetypes, breaths, tint hexes | soul 265 ≠ ether's hex |
| `testTheNineRingsWashDeepAndLegibleText` | §1.4.4 table (computed in oklab this session; reproduced exactly) | any hex/wash/deep/text/fog/weather/breath/chrome differs, or text < 4.5 : 1 | rose left unlifted (4.48 : 1) |
| `testThePointWarmsGoldToEmber` | §1.9 five stops | oklab mix differs | an sRGB midpoint is not the oklab one |
| `testChromeThinsWithDepth` | §1.8 | any step/world/ring/band chrome wrong | the table is not flat |
| `testEnclosureBreathIsDesignsUnsnapped` | `Home Mandala.html`, `Mandala App v2.html`, `home-mandala.jsx` CSS periods | any period ≠ Design's | the old `3s` home petal |
| `testTheOneClockNoLongerSnaps` | §1.6 | `livePeriod` snaps; epoch phase differs; glow peak ≠ .07 | the old `period(grammar:)` does move 9.3 and 3.5 |
| `testMotionCurvesAreTheWorldFiles` | §1.4 table | any control point or duration differs | descent at 2.0 s |
| `testEachWorldWearsItsLanguage` | §1.3 | a world wears the wrong language or one of 13 is unused | — (exact map) |
| `testEveryWorldsInkReadsOnItsGround` | — | any world or inner ink / ink-2 < 4.5 : 1 on its ground or rim; any type < 11 pt | cream at α .3 as ink |
| `testStatedContrastRatios` | 31 ratios stated in §1.4 / §1.14 | computed ≠ stated ± .015 | cream α .3 vs the 4.55 claim |
| `testReadableAlwaysReachesTheFloor` | — | `readable` leaves any of the 102 accents under 4.5 on five night grounds; paper accent drifts > 2.2° | — |
| `testBundledFacesAreExactlyTheFilesOnDisk` | `Fonts/` and `Info.plist` via `SourceTree` | the bundled list ≠ the files / UIAppFonts; PostScript names drift | Medium ≠ Light |
| `testCanonColoursWinAndTheDyadsAreTheBake` | `ChakraConstellation.json` (bundle) | precedence wrong; a dyad ≠ the Map's hex / dyad; < 33 hexes | site's `#A82828` loses |
| `testReduceMotionPausesLoopsAndKeepsMechanisms` | §1.13 | anything but decorative loops pauses; quantize, opacity step, durations wrong | holds are not stripped |
| `testThePointInEveryWorldAndHisTratak` | §1.10, M12, #18 | depth/size/breath table, Tratak 20/45 s, wander bounds, 44 pt | — |
| `testThePointRendersInEveryWorld` | — | the view fails to render in any world | — |
| `testPersonHueIsTheFormula` | §1.4.15 | `personHue` ≠ the formula | — |

## How the numbers were checked here

With no Swift, I reproduced the oklab and contrast arithmetic in Python with the same matrices and the same 1 % lift. It matches visual.md exactly:

- **The nine rings:** all washes, deeps and lifted text colours: `#C56583`, `#CC5D61`, `#BB6597`, `#DE5244`.
- **The point's colours:** gold → ember at the five depths: `#C9963F`, `#C9813A`, `#C76B35`, `#C45430`, `#C0392B`.
- **The element tints:** `#DAA681`, `#81ADDA`, `#81C4DA`, `#BC81DA`, `#DA9781`, `#DACB81`.
- **Every stated contrast ratio** in the test table.

Every world's ink and ink-2 measure ≥ 4.5 : 1 on its ground and its rim.
