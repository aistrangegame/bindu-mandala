import Foundation

// MARK: - The nine bands, as nine clocks
//
// The moving half of `Claude Design Round 2/homes/homes-worlds.js`. The table
// half — name, gem, dhātu, clock in words, body region, fog, veil, tempo, verb,
// bīja — is already ported in ``HomeWorlds`` and is **not restated here**. What
// ports here is the thing that file does sixty times a second: the nine
// `update(t)` functions, each running on its own clock.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE CLOCK IS THE BAND
// ─────────────────────────────────────────────────────────────────────────────
//
// Design gives each āvaraṇa a different rate, and the rates are the whole of
// why the sixth reads slower than the second without a word being said:
//
//     the feet band runs a day · the pelvis a heartbeat · the navel a churn ·
//     the heart a lunar fortnight · the throat a month · the forehead a season ·
//     the crown a solar half-year · above-crown a year · totality Kāla and
//     Akāla together.
//
// They are ported to the last decimal and `WorldClimbTests` asserts every one
// against the JavaScript literal. **They are not all the same kind of number**,
// and flattening them into one would be a lie: `0.05` at the Feet is *cycles
// per second* into a modulo, `0.0398` at the Heart is *radians per second* into
// a sine, `0.062` above the Crown is an *angular velocity* of a meridian, and
// the ninth carries two at once. ``WorldBandClock`` keeps the kind beside the
// rate, and ``WorldBandClock/phase(at:)`` is what makes them comparable: how far
// round this band's own clock the world has come, `0…1`, whatever kind it is.
//
// ─────────────────────────────────────────────────────────────────────────────
// AND THE TEMPO SCALES THE CLOCK, NEVER THE STAY
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's Axis writes it in one line — `if (near) b.update(t * (WORLDS[ix].tempo || 1))`
// — and the comment beneath it says why: *"the mental state sets the world's
// tempo: waking runs at speed, pure being barely moves. Her own adaptation
// clock is untouched by this."*
//
// So every reading below is taken at ``HomeWorlds/worldClock(_:ring:)``, which
// is the only place the tempo is ever applied, and nothing in this file knows
// what a chamber clock is. Conflating the two would let a slow ring hand the
// walker a cheaper second adaptation than a fast one — depth bought by which
// āvaraṇa he happened to be standing in rather than by how long he stayed,
// which is the never-measure law (charter §2.2) at the timing layer.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT A BAND IS, UNDER THE RULED RENDERER
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's JavaScript builds each band out of objects: eleven standing stones,
// seventy-two ribs, an octahedral prism, nine glowing solids. Those are three.js
// art direction for a browser, and under the renderer ruling they are the props
// cupboard it warns about — a lit solid reads as a THING. Design's own comments
// say what each band is actually *for*, and in every case it is the light and
// the air rather than the object:
//
//   * the Feet: *"things that exist only to be raked — long shadows are the
//     weather"*;
//   * the Heart: *"light split — three spectra crawling over glossy ground"*,
//     which is the caustic, not the octahedron;
//   * the Throat: *"light arrives only in shafts between ribs"*, which is the
//     gap, not the cylinder;
//   * the Forehead: *"nothing is lit from outside"*, which is emission in the
//     material itself.
//
// So a band reduces, exactly and without loss, to four facts about a moment:
// where the light comes from, how strong it is, how much arrives from
// everywhere at once, and how much the material is its own light. The shaft's
// own stone carries the rest as relief (``WorldClimbScene``), which is the same
// vocabulary ``RoomMaterial`` gives a room and needs no new noun.
//
// This also answers the renderer ruling's own revisit condition 2 —
// *"the +6.5 MB does not stay flat with nine ring worlds resident; if nine
// lighting rigs and their maps live at once, re-measure before Phase 3.2 ships"*
// — structurally rather than by measurement. There are not nine rigs. There is
// one light, blended, and one shadow map in the whole climb.

/// How one āvaraṇa's clock runs.
///
/// The kind matters as much as the rate: Design's nine numbers are not nine of
/// the same thing, and reading them as though they were would make the Feet's
/// day and the Heart's fortnight incomparable in the wrong direction.
enum WorldBandClock: Equatable {

    /// A cycle counted directly: `(t · rate) % 1`. The Feet's day–night.
    case cycling(rate: Double)

    /// A pulse: `bpm = t · rate`, and a systole at `sin(bpm·π)⁶`. The Pelvis.
    case pulsing(rate: Double)

    /// A flow field driven by the clock itself, which never repeats cleanly.
    /// The Navel's churn.
    case flowing(rate: Double)

    /// A swing: `0.5 + 0.5·sin(t · rate)`. The Heart, Throat, Forehead and
    /// Crown — the four long clocks.
    case swinging(rate: Double)

    /// An angle that only ever increases: `t · rate`. Above the Crown, where
    /// the whole world is one travelling meridian.
    case turning(rate: Double)

    /// Two clocks at once. Totality is `kāla–akāla`: what turns, and what does
    /// not. The turn is the yantra's own rotation and the breath is the core's,
    /// and neither is the other's harmonic — that is the point of the pair.
    case turningAndBreathing(turn: Double, breath: Double)

    /// The band's own rate — the number Design wrote down.
    var rate: Double {
        switch self {
        case .cycling(let r), .pulsing(let r), .flowing(let r),
             .swinging(let r), .turning(let r):
            return r
        case .turningAndBreathing(let turn, _):
            return turn
        }
    }

    /// The second rate, where a band has one. Only Totality does.
    var secondRate: Double? {
        if case .turningAndBreathing(_, let breath) = self { return breath }
        return nil
    }

    /// How long one whole turn of this band's clock takes, in seconds, before
    /// the tempo touches it.
    ///
    /// **Not monotone across the nine, and that is Design's.** The year above
    /// the Crown comes round in 101 s and the fortnight at the Heart takes 158:
    /// a *year* there is one sweep of a single band of light, and a *fortnight*
    /// is a swell that has to be waited out. The word names what the clock is
    /// of, not how fast it runs, and nothing here reorders them.
    var period: TimeInterval {
        guard rate > 0 else { return .infinity }
        switch self {
        case .cycling:  return 1 / rate
        case .pulsing:  return 2 / rate
        case .flowing, .swinging, .turning, .turningAndBreathing:
            return 2 * .pi / rate
        }
    }

    /// How far round this band's own clock the world has come, `0…1`.
    ///
    /// The one number that makes nine different kinds of rate comparable, and
    /// the reason it can exist: every one of Design's nine is periodic in its
    /// own units, so "how far round" is always well defined even where the
    /// underlying quantity is an angle that never resets.
    func phase(at worldTime: TimeInterval) -> Double {
        guard rate > 0 else { return 0 }
        switch self {
        case .cycling:
            return WorldBands.fract(worldTime * rate)
        case .pulsing:
            // Design's rings travel at `p = (bpm * 0.5 + phase) % 1`, so the
            // band comes round once every two of its own beats.
            return WorldBands.fract(worldTime * rate * 0.5)
        case .flowing, .swinging, .turning, .turningAndBreathing:
            return WorldBands.fract(worldTime * rate / (2 * .pi))
        }
    }
}

/// One band's weather at one moment: everything Design's `update(t)` produces,
/// in terms a ruled renderer can use and a test can read.
///
/// There is no mesh, no node and no colour here. A band is a condition, and a
/// condition is four facts about light plus what the air is doing.
struct WorldBandReading: Equatable {

    /// Āvaraṇa 1–9.
    let ring: Int

    /// How far round the band's own clock, `0…1`.
    let phase: Double

    /// The unit direction the light arrives **from**, in scene space, or `nil`
    /// where the world has no source at all.
    ///
    /// `nil` at the Crown, and it is a real absence rather than a dim light:
    /// pearl at 0.95 diffusion is *"sourceless — no directional light at all"*,
    /// which ``HomeGem/isSourceless`` already rules and this reading obeys
    /// rather than re-decides.
    let key: SIMD3<Double>?

    /// How strong the band's key stands, `0…1` of its own full strength.
    /// Exactly `0` wherever ``key`` is `nil`.
    let keyStrength: Double

    /// How much arrives from everywhere at once, `0…1` of the band's own full
    /// ambient.
    let ambientStrength: Double

    /// How much the band's own material is its own light, `0…1`.
    ///
    /// The Forehead is the band this exists for — *"nothing is lit from
    /// outside; every solid glows from within"* — and Totality carries it too,
    /// as the core's Akāla breath.
    let glowFromWithin: Double

    /// How fast the air moves, as Design's `driftMotes(dust, t, rate)`. Zero in
    /// the bands Design gives no dust.
    let airDrift: Double
}

/// The nine `update(t)` functions, ported.
enum WorldBands {

    // MARK: - The nine clocks, verbatim

    /// Design's own rates, one per band, read straight off `homes-worlds.js`.
    ///
    /// Every literal below appears in that file and `WorldClimbTests` asserts
    /// each one against it. The comment beside each is Design's own, from the
    /// line the number is on.
    static let clocks: [Int: WorldBandClock] = [
        // `const day = (t * 0.05) % 1;  // the day–night cycle, visible`
        1: .cycling(rate: 0.05),
        // `const bpm = t * 1.05;        // the hour, felt as pulse`
        2: .pulsing(rate: 1.05),
        // `u.uTime.value = t;` — the churn runs on the clock itself.
        3: .flowing(rate: 1.00),
        // `const fort = 0.5 + 0.5 * Math.sin(t * 0.0398);   // the lunar fortnight`
        4: .swinging(rate: 0.0398),
        // `const moon = 0.5 + 0.5 * Math.sin(t * 0.0199);   // the lunar month`
        5: .swinging(rate: 0.0199),
        // `const season = 0.5 + 0.5 * Math.sin(t * 0.0066); // the season, barely moving`
        6: .swinging(rate: 0.0066),
        // `const half = 0.5 + 0.5 * Math.sin(t * 0.0033);   // the solar half-year`
        7: .swinging(rate: 0.0033),
        // `const yr = t * 0.062;                            // the year`
        8: .turning(rate: 0.062),
        // `yantra.rotation.y = t * 0.008;` turns, and
        // `core.scale.setScalar(0.9 + 0.16 * Math.sin(t * 0.13));` does not.
        9: .turningAndBreathing(turn: 0.008, breath: 0.13),
    ]

    /// The band's clock, or `nil` outside 1–9.
    static func clock(ring: Int) -> WorldBandClock? { clocks[ring] }

    // MARK: - The tempo, applied in exactly one place

    /// The band's own clock at a moment of real time.
    ///
    /// ``HomeWorlds/worldClock(_:ring:)`` is the only thing that scales by the
    /// tempo, and this is the only door into this file. A reading cannot be
    /// taken at an unscaled time by accident, and no chamber clock can reach it
    /// at all — there is no parameter here for one.
    static func bandTime(_ seconds: TimeInterval, ring: Int) -> TimeInterval {
        HomeWorlds.worldClock(seconds, ring: ring)
    }

    /// How long one turn of the band's clock takes once its mental state has
    /// slowed it — the number a walker actually feels.
    ///
    /// This is where the phase's whole claim lives: the sixth āvaraṇa's season
    /// comes round eight hundred times slower than the second's pulse, and
    /// nothing says so out loud.
    static func feltPeriod(ring: Int) -> TimeInterval {
        guard let clock = clock(ring: ring),
              let tempo = HomeWorlds.character(ring: ring)?.tempo,
              tempo > 0 else { return .infinity }
        return clock.period / tempo
    }

    // MARK: - The nine readings

    /// One band's weather at a moment of **real** time. The tempo is applied
    /// inside, once.
    static func reading(ring: Int, at seconds: TimeInterval) -> WorldBandReading? {
        guard let clock = clock(ring: ring) else { return nil }
        let t = bandTime(seconds, ring: ring)
        let phase = clock.phase(at: t)
        switch ring {
        case 1: return feet(t, phase: phase)
        case 2: return pelvis(t, phase: phase)
        case 3: return navel(t, phase: phase)
        case 4: return heart(t, phase: phase)
        case 5: return throat(t, phase: phase)
        case 6: return forehead(t, phase: phase)
        case 7: return crown(t, phase: phase)
        case 8: return aboveCrown(t, phase: phase)
        case 9: return totality(t, phase: phase)
        default: return nil
        }
    }

    // ── 1 · FEET · topaz · rasa · day–night ─────────────────────────────────
    //
    // *"Low warm light raking a vast floor, swinging horizon to horizon."* The
    // sun's whole track is Design's, including the `max(-4, …)` that keeps it
    // from sinking out of the world entirely at night, and the `0.6` on its
    // z term that stops the track being a plain circle.
    private static func feet(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        let ang = phase * 2 * .pi
        let alt = sin(ang)
        let night = clamp01(-alt * 2)
        let direction = normalise(SIMD3(cos(ang) * 60,
                                        max(-4, alt * 34),
                                        sin(ang * 0.6) * 26))
        return WorldBandReading(
            ring: 1,
            phase: phase,
            key: direction,
            // `sun.intensity = 6.4 * clamp01(alt * 1.6 + 0.2)`
            keyStrength: clamp01(alt * 1.6 + 0.2),
            // `amb.intensity = lerp(1.8, 0.3, night)`, as a share of its own 1.8.
            ambientStrength: lerp(1.0, 0.3 / 1.8, night),
            glowFromWithin: 0,
            // `driftMotes(dust, t, 0.5)`
            airDrift: 0.5)
    }

    // ── 2 · PELVIS · sapphire · rakta · the hour ────────────────────────────
    //
    // *"The air pulses. Blood-warm waves travel out through cold blue."* The
    // beat is a light at the centre of the world rather than a direction, so
    // the key stands overhead and beats with the systole: what the walker is
    // given is the pulse, and where it comes from is nowhere in particular.
    private static func pelvis(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        let bpm = t * 1.05
        // `const sys = Math.pow(Math.max(0, Math.sin(bpm * Math.PI)), 6)`
        let sys = pow(max(0, sin(bpm * .pi)), 6)
        return WorldBandReading(
            ring: 2,
            phase: phase,
            key: normalise(SIMD3(0, 1, 0.12)),
            // `beat.intensity = 120 + sys * 900`, as a share of its own 1020.
            keyStrength: (120 + sys * 900) / 1020,
            // `cold` is a standing hemisphere light; the cold blue does not beat.
            ambientStrength: 1,
            glowFromWithin: 0,
            // `driftMotes(dust, t, 0.4)`
            airDrift: 0.4)
    }

    // ── 3 · NAVEL · coral · māṃsa · the day ─────────────────────────────────
    //
    // *"Churn. Sarvasaṅkṣobhaṇa — the all-agitating. The air will not settle."*
    // Everything in this band is the air: the light barely moves and the curl
    // does the work, which is why ``airDrift`` is the highest in the climb.
    private static func navel(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        return WorldBandReading(
            ring: 3,
            phase: phase,
            key: normalise(SIMD3(0.2, 1, 0.3)),
            // `core.intensity = 280 + Math.sin(t * 0.4) * 90`, share of its 370.
            keyStrength: (280 + sin(t * 0.4) * 90) / 370,
            ambientStrength: 1,
            glowFromWithin: 0,
            // The curl itself: `p += v * 2.6 + flow(p * 2.1, uTime * 0.7) * 0.9`.
            // The air in this band never settles, so it moves fastest of the nine.
            airDrift: 1.0)
    }

    // ── 4 · HEART · diamond · medas · lunar fortnight ───────────────────────
    //
    // *"Light split. Caustics crawl over glossy ground in three separated
    // spectra — dispersion as the world's own condition."*
    private static func heart(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const fort = 0.5 + 0.5 * Math.sin(t * 0.0398)`
        let fort = 0.5 + 0.5 * sin(t * 0.0398)
        return WorldBandReading(
            ring: 4,
            phase: phase,
            // `key.position.set(6, y + 20, 8)`
            key: normalise(SIMD3(6, 20, 8)),
            // `key.intensity = 2.6 + fort * 4.4`, as a share of its own 7.0.
            keyStrength: (2.6 + fort * 4.4) / 7,
            ambientStrength: 1,
            // The caustics are the band's own light lying on its own ground:
            // `m.material.opacity = 0.42 + 0.4 * fort`, share of its own 0.82.
            glowFromWithin: (0.42 + 0.4 * fort) / 0.82,
            airDrift: 0)
    }

    // ── 5 · THROAT · emerald · asthi · lunar month ──────────────────────────
    //
    // *"The world has bones. Light arrives only in shafts between ribs."* The
    // ribs are relief on the shaft's own stone (``WorldClimbScene``); what this
    // reading carries is the light that falls between them and the month it
    // waxes on.
    private static func throat(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const moon = 0.5 + 0.5 * Math.sin(t * 0.0199)`
        let moon = 0.5 + 0.5 * sin(t * 0.0199)
        return WorldBandReading(
            ring: 5,
            phase: phase,
            // `above.position.set(2, y + 24, 3)`
            key: normalise(SIMD3(2, 24, 3)),
            // `above.intensity = 2.2 + moon * 3.4`, as a share of its own 5.6.
            keyStrength: (2.2 + moon * 3.4) / 5.6,
            // `hemi5` stands; what waxes is the shafts, which the key carries.
            ambientStrength: 0.6,
            glowFromWithin: 0,
            airDrift: 0)
    }

    // ── 6 · FOREHEAD · ruby · majjā · season ────────────────────────────────
    //
    // *"Nothing is lit from outside. Every solid glows from within."*
    //
    // **The one place Design's band file and Design's gem table disagree, and
    // it is resolved toward the gem table by a hair rather than by overruling
    // either.** `bandForehead` places no directional light at all — only an
    // ambient and nine point lights inside the bodies — while the gem table
    // (handoff §4.1) gives ruby 0.55 diffusion, and the ruling makes the Crown
    // the *only* sourceless āvaraṇa. Ring 6 therefore keeps a key, at the floor
    // of what a key can be: enough that a raking light has something to fall
    // across — which is the authoring defect Design's own verification pass
    // named, Ring 1's Mātṛkās reading as one flat plane — and far below the
    // glow, so the band still reads as lit from inside.
    private static func forehead(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const season = 0.5 + 0.5 * Math.sin(t * 0.0066)`
        let season = 0.5 + 0.5 * sin(t * 0.0066)
        return WorldBandReading(
            ring: 6,
            phase: phase,
            key: normalise(SIMD3(-0.3, 1, 0.4)),
            keyStrength: keyFloor,
            // `new THREE.AmbientLight(0x4a1018, 2.0)` — a dark room.
            ambientStrength: 0.5,
            // `shellMat.emissiveIntensity = 1.5 + season * 1.6`, share of its 3.1.
            glowFromWithin: (1.5 + season * 1.6) / 3.1,
            // `driftMotes(dust, t, 0.34)`
            airDrift: 0.34)
    }

    /// The least a band's key can be and still be a light.
    ///
    /// It exists for one band — the Forehead, above — and it is named rather
    /// than written inline so that a second band cannot quietly acquire a
    /// nearly-absent key and pass for sourceless. The Crown's absence is `nil`,
    /// not a small number, and nothing in this file can produce a `nil` key for
    /// any other ring.
    static let keyFloor: Double = 0.06

    // ── 7 · CROWN · pearl · śukra · solar half-year ─────────────────────────
    //
    // *"Sourceless. Luminous fog and no shadow anywhere — light from everywhere
    // at once, so there is nothing to orient by."*
    //
    // ``key`` is `nil` and ``keyStrength`` is exactly zero. This is the one
    // `if` the renderer ruling turned on — *"in SceneKit, Ring 7 having no
    // directional light is one line"* — and it is read from
    // ``HomeGem/isSourceless`` rather than from a ring number, so the fact
    // lives in one place for the whole instrument.
    private static func crown(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const half = 0.5 + 0.5 * Math.sin(t * 0.0033)`
        let half = 0.5 + 0.5 * sin(t * 0.0033)
        let sourceless = HomeGem.gemFor(ring: 7, khadgamalaPosition: nil).isSourceless
        return WorldBandReading(
            ring: 7,
            phase: phase,
            key: sourceless ? nil : normalise(SIMD3(0, 1, 0)),
            keyStrength: sourceless ? 0 : keyFloor,
            // `AmbientLight(0xf6f1e6, 2.6)` plus `HemisphereLight(…, 1.7)` —
            // the brightest ambient in the climb, because the gem is the most
            // diffuse, not because a branch was written to rescue it.
            ambientStrength: 1,
            // `s.material.opacity = 0.08 + 0.1 * half * …`, share of its own 0.18.
            glowFromWithin: (0.08 + 0.1 * half) / 0.18,
            // `driftMotes(dust, t, 0.3)`
            airDrift: 0.3)
    }

    // ── 8 · ABOVE CROWN · cat's eye · ojas · year ───────────────────────────
    //
    // *"One band of light, and only one. Chatoyancy — the whole world is a
    // single travelling meridian; everything else waits in the dark."* The key
    // is horizontal and goes round: Design sweeps a light on a circle of
    // radius 16 at the band's own height, which is why this is the one band
    // whose light arrives from the side rather than from above.
    private static func aboveCrown(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const yr = t * 0.062`
        let yr = t * 0.062
        // `const s = Math.abs(Math.sin(yr * 2.0))`
        let s = abs(sin(yr * 2.0))
        return WorldBandReading(
            ring: 8,
            phase: phase,
            // `sweep.position.set(Math.cos(yr) * 16, y, Math.sin(yr) * 16)`, and
            // its own ground is at `y - 3.6` — so relative to the ground the
            // meridian stands 3.6 up at a radius of 16, which is a rake of
            // about thirteen degrees. Design's two numbers, not a chosen angle:
            // read the height as nothing and the one travelling band arrives
            // exactly parallel to the ground it is supposed to be crossing, and
            // the eighth āvaraṇa goes dark for the whole year.
            key: normalise(SIMD3(cos(yr) * 16, 3.6, sin(yr) * 16)),
            // `sweep.intensity = 500 + s * 900`, as a share of its own 1400.
            keyStrength: (500 + s * 900) / 1400,
            // `AmbientLight(0x4a3a1c, 2.0)` — everything else waits in the dark.
            ambientStrength: 0.34,
            // The meridian is *itself* light: Design's `ridge` is a bar with a
            // constant material and no fog, and its halo swells with the year —
            // `halo.scale.setScalar(24 + s * 14)`, a share of its own 38. So the
            // one band the walker can see in this āvaraṇa is a band the ground
            // is emitting, which is what the whole world is named for.
            glowFromWithin: (24 + s * 14) / 38,
            airDrift: 0)
    }

    // ── 9 · TOTALITY · all gems · tejas · kāla–akāla ────────────────────────
    //
    // *"Every gem's light at once, which is the same as no weather at all."*
    // Two clocks: the lamps and the yantra **turn** — kāla — and the core only
    // **breathes**, going nowhere, which is akāla. The key follows the first
    // lamp's own track, so what turns is a real thing turning rather than a
    // direction chosen to look like one.
    private static func totality(_ t: TimeInterval, phase: Double) -> WorldBandReading {
        // `const a = L.a + t * 0.014;` and `const r = 15 + Math.sin(t * 0.05 + i) * 3.4;`
        let a = t * 0.014
        let r = 15 + sin(t * 0.05) * 3.4
        // `L.l.position.set(Math.cos(a) * r, y + Math.sin(i * 2.3 + t * 0.03) * 8, Math.sin(a) * r)`
        let height = sin(t * 0.03) * 8
        return WorldBandReading(
            ring: 9,
            phase: phase,
            key: normalise(SIMD3(cos(a) * r, height, sin(a) * r)),
            // `L.l.intensity = 240 + 180 * (0.5 + 0.5 * Math.sin(t * 0.19 + i * 0.7))`,
            // as a share of its own 420.
            keyStrength: (240 + 180 * (0.5 + 0.5 * sin(t * 0.19))) / 420,
            // `AmbientLight(0xfff0d0, 1.5)`
            ambientStrength: 0.75,
            // The akāla half: `core.scale.setScalar(0.9 + 0.16 * Math.sin(t * 0.13))`,
            // taken about its own 0.9 so the breath is what shows rather than
            // the standing size.
            glowFromWithin: clamp01((0.9 + 0.16 * sin(t * 0.13) - 0.74) / 0.32),
            // `driftMotes(dust, t, 0.5)`
            airDrift: 0.5)
    }

    // MARK: - Small arithmetic, kept here so the readings need nothing else

    static func fract(_ x: Double) -> Double {
        let f = x - x.rounded(.down)
        return f < 0 ? f + 1 : f
    }

    static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }

    static func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double { a + (b - a) * t }

    /// A direction, or straight down where there is none to be had. Never
    /// `nil`: an absent key is `nil` at the ``WorldBandReading`` level, which is
    /// the level the ruling cares about.
    static func normalise(_ v: SIMD3<Double>) -> SIMD3<Double> {
        let length = (v.x * v.x + v.y * v.y + v.z * v.z).squareRoot()
        guard length > 0.000_1 else { return SIMD3(0, 1, 0) }
        return v / length
    }
}

// MARK: - The stone each band is cut from

// Design's nine bands are built out of objects — eleven standing stones,
// seventy-two ribs, nine glowing solids, an octahedral prism. Under the
// renderer ruling none of those may be a free-standing lit solid, and none of
// them needs to be: every one is something the world's own material is *doing*,
// and ``RoomMaterial``'s five verbs already say all of it.
//
// So a band's material is the shaft's own stone with that band's condition
// worked into it, and the vocabulary is not extended by a single word:
//
//   * the Feet's standing stones are **swells** — ground risen, so the low sun
//     has something to rake and the long shadows Design calls the weather are
//     really cast;
//   * the Pelvis's seven travelling rings are rows of **impressions**, a wave
//     that has passed through the material;
//   * the Navel's churn is **cracks**, scattered and unrepeating, because
//     agitation leaves no order behind;
//   * the Heart is almost untouched — **compactions** only, because dispersion
//     needs a surface clean enough to carry a caustic;
//   * the Throat's colonnade is stacked **furrows**: the ribs are what the
//     stone does, and the shafts of light are the gaps between them;
//   * the Forehead's bodies are **swells that glow**, which is the only band
//     where the material is genuinely its own light;
//   * the Crown is all but flat, because there is nothing to orient by;
//   * above the Crown there is **one furrow** and nothing else — one meridian,
//     and everything else waits in the dark;
//   * Totality is the yantra's own lines, faint and crossing.
//
// The counts are Design's counts. The placements are not Design's cylindrical
// layout, which does not survive being flattened onto a wall, and no attempt is
// made to pretend otherwise: what carries is how many, how deep and how ordered,
// which is what the walker reads.

extension WorldBands {

    /// How deep a band's own condition cuts into the shaft, in scene units.
    /// A twelfth of a body-height — deeper than the stone's own grain
    /// (``RoomMaterial/grainRelief``, a fortieth) so a band is legible as a
    /// condition, shallower than a room's mark so the axis never competes with
    /// a room.
    static var bandRelief: Double { RoomUnits.roomHeight / 12 }

    /// The material of one band of the shaft.
    ///
    /// Its surface is ``RoomSurfaceKind/wall``, which is the one surface
    /// ``RoomUnits`` says no attribute ever acts on — *"a wall is not where a
    /// body is felt"*. That is exactly right for the axis: nothing here is a
    /// Śakti's mark, and nothing here may be mistaken for one.
    static func stone(ring: Int) -> RoomMaterial {
        var m = RoomMaterial(surface: .wall, seed: ring &* 7 &+ 3)
        let deep = bandRelief
        switch ring {

        // ── 1 · the Feet · eleven standing stones, risen ground ────────────
        case 1:
            for i in 0..<11 {
                let u = (Double(i) + 0.5) / 11
                // Design's own modulo pattern: `r = 11 + (i % 3) * 6` sets how
                // far out a stone stands, `h = 3 + (i % 4) * 2.2` how tall.
                let v = 0.22 + Double(i % 3) * 0.24
                let tall = 1 + Double(i % 4) * 0.34
                m.receive(.swell(at: SurfaceCoordinate(u: u, v: v),
                                 reach: 0.035, depth: deep * tall))
            }

        // ── 2 · the Pelvis · seven waves that have passed through ──────────
        case 2:
            for i in 0..<7 {
                let v = (Double(i) + 0.5) / 7
                // Design's rings widen as they travel: `s = 1.4 + p * 27`.
                let spread = 0.4 + Double(i) / 7 * 0.6
                for j in 0..<5 {
                    let u = (Double(j) + 0.5) / 5
                    m.receive(.impression(at: SurfaceCoordinate(u: u, v: v),
                                          reach: 0.028 * spread,
                                          depth: deep * (1 - Double(i) / 9)))
                }
            }

        // ── 3 · the Navel · churn, which leaves no order ───────────────────
        case 3:
            // Deterministic in the ring, so the same world is the same world on
            // every launch — the principle `Atmosphere` jitters a hue by.
            var state = UInt64(3 &* 2_654_435_761) | 1
            func next() -> Double {
                state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
                return Double((state >> 33) % 100_000) / 100_000
            }
            for _ in 0..<26 {
                m.receive(.crack(at: SurfaceCoordinate(u: next(), v: next()),
                                 reach: 0.012 + next() * 0.014,
                                 depth: deep * (0.4 + next() * 0.5)))
            }

        // ── 4 · the Heart · glossy, so a caustic has somewhere to crawl ────
        case 4:
            for i in 0..<3 {
                m.receive(.compaction(at: SurfaceCoordinate(u: 0.3 + Double(i) * 0.2,
                                                            v: 0.3 + Double(i) * 0.18),
                                      reach: 0.22, depth: deep * 0.18))
            }

        // ── 5 · the Throat · the colonnade, and the light between it ───────
        case 5:
            for i in 0..<12 {
                let u = (Double(i) + 0.5) / 12
                // Design's ribs lean and shorten outward: `s.set(1, 1 - ringIx * 0.1, 1)`.
                let shorten = 1 - Double(i % 3) * 0.1
                for j in 0..<5 {
                    let v = (Double(j) + 0.5) / 5
                    m.receive(.furrow(at: SurfaceCoordinate(u: u, v: v),
                                      reach: 0.026, depth: deep * 1.1 * shorten))
                }
            }

        // ── 6 · the Forehead · nine bodies, each its own light ─────────────
        case 6:
            for i in 0..<9 {
                let a = Double(i) / 9
                m.receive(.swell(at: SurfaceCoordinate(u: a, v: 0.5 + sin(Double(i) * 1.7) * 0.34),
                                 reach: 0.05 + Double(i % 3) * 0.018,
                                 depth: deep * 0.9,
                                 // The band's whole condition: the light is in
                                 // the material, and `RoomMaterial.emission`
                                 // multiplies it by how far the material
                                 // actually moved — so a swell that does not
                                 // rise emits nothing, at any brightness.
                                 glow: 0.85))
            }

        // ── 7 · the Crown · nothing to orient by ───────────────────────────
        case 7:
            // Design's five veils are *"barely-there planes, only so the milk
            // has something to be in front of"*. Five swells at a tenth of the
            // depth: present, and not a landmark.
            for i in 0..<5 {
                m.receive(.swell(at: SurfaceCoordinate(u: (Double(i) + 0.5) / 5,
                                                       v: 0.5 + (Double(i) - 2) * 0.12),
                                 reach: 0.16, depth: deep * 0.1, glow: 0.2))
            }

        // ── 8 · above the Crown · one meridian, and the dark ───────────────
        case 8:
            m.receive(.furrow(at: .centre, reach: 0.1, depth: deep * 1.4, glow: 0.5))

        // ── 9 · Totality · the yantra's own lines ──────────────────────────
        case 9:
            // Design's three circles and three pairs of triangles, as crossing
            // lines in the stone. Faint: *"every gem at once, which is the same
            // as no weather at all."*
            for i in 0..<3 {
                let v = 0.3 + Double(i) * 0.2
                for j in 0..<4 {
                    m.receive(.impression(at: SurfaceCoordinate(u: (Double(j) + 0.5) / 4, v: v),
                                          reach: 0.06, depth: deep * 0.3, glow: 0.35))
                }
                m.receive(.furrow(at: SurfaceCoordinate(u: 0.25 + Double(i) * 0.25, v: 0.5),
                                  reach: 0.03, depth: deep * 0.4, glow: 0.35))
            }

        default:
            break
        }
        return m
    }

    /// The nine band materials, built once.
    static let stones: [Int: RoomMaterial] = {
        var out: [Int: RoomMaterial] = [:]
        for ring in HomeWorlds.rings { out[ring] = stone(ring: ring) }
        return out
    }()
}
