import Foundation

// MARK: - The climb: nine āvaraṇas as one continuous vertical space
//
// Build Brief v2 §3.2, and Ruling 1 is the whole of why it is shaped this way:
// **the nine worlds are not nine screens.** July cut those and they do not come
// back. What replaces them is one space the walker rises through, where each
// āvaraṇa is a *weather* and a *clock* rather than a place with a door.
//
// Design's Axis is the working instrument and its behaviour is the
// specification. Its whole climb is five lines, and every one of them is here:
//
//     const bands = WORLDS.map((w, i) => w.build(worldY(i)));
//     const TOP = worldY(WORLDS.length - 1);
//     climb += (target - climb) * (reduced ? 0.035 : 0.06);
//     const f = climb / WORLD_SPACING;
//     const near = Math.abs(worldY(ix) - climb) < WORLD_SPACING * 1.15;
//
// ─────────────────────────────────────────────────────────────────────────────
// TRAVEL, NEVER A CUT
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's invariant 3 allows only travel: *"no transition screens, no fades to
// black, no menus where movement will do. Every switcher is a place the
// experience stops."* So there is no such thing here as arriving in a band.
// Everything the walker is given at a height — the air's colour, its density,
// where the light comes from, how strong it is, what the material is doing — is
// a **weighted blend of the two bands he is between**, and every one of those
// weights is continuous in his height. A band is deepest at its own station and
// thins to nothing a spacing away, exactly as Design's `lerpColors(i0, i1, k)`
// already does for the fog.
//
// The Phase 3.1 review caught this class of defect in the spike — the eye
// popping 1.5 units across a seam at t = 314 — so the crossing is asserted at
// quarter-second resolution here too, against a bound, the way that check works.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE CLIMB IS KEYED BY RING, AND THAT IS A FINDING, NOT A PREFERENCE
// ─────────────────────────────────────────────────────────────────────────────
//
// ``RoomUnits/worldFloorY(ring:)`` already carries the reason and this file
// reads it rather than restating it: two of Design's nine region words fall
// outside Design's own body-zone vocabulary. `Pelvis` reaches no rule at all and
// lands at the middle of the body, and `Above crown` reaches the `crown|above`
// rule and so shares the Crown's altitude exactly. Read off those words the
// climb would put the second world *below* the first and stand the seventh and
// eighth at one height — which is not a climb. The gaps are Design's, they are
// asserted out loud rather than papered, and the fix belongs with the live rows.
//
// ─────────────────────────────────────────────────────────────────────────────
// TWO CLOCKS, AND THE TEMPO ONLY EVER TOUCHES ONE
// ─────────────────────────────────────────────────────────────────────────────
//
// Nothing in this file takes a chamber time. The only clock it knows is the
// world's, and the only way it reads one is ``WorldBands/bandTime(_:ring:)``,
// which goes through ``HomeWorlds/worldClock(_:ring:)`` — the single place the
// tempo is ever applied. A slow āvaraṇa must never hand the walker a cheaper
// second adaptation than a fast one: that would be depth bought by where he was
// standing rather than by how long he stayed, which is the never-measure law at
// the timing layer.

/// Everything the walker is given at one height of the climb, at one moment.
///
/// Pure numbers, so the whole climb is assertable without a renderer — the same
/// discipline ``RoomPose`` keeps for a room.
struct WorldWeather: Equatable {

    /// Where on the climb, in bands: `0` at the first world's station, `8` at
    /// the ninth's. Design's `f = climb / WORLD_SPACING`.
    let fraction: Double

    /// The band beneath, the band above, and how far between them. At a band's
    /// own station ``k`` is zero and ``lower`` is that band, so it is given its
    /// whole weight.
    let lower: Int
    let upper: Int
    let k: Double

    /// The Yoginī class as a number, blended: how veiled the air is here.
    let veil: Double

    /// The air's colour, `0…1` per channel.
    let fog: SIMD3<Double>

    /// The air's density, with the veil's grip already in it.
    let fogDensity: Double

    /// The unit direction the light arrives from, or `nil` where there is none.
    /// `nil` exactly when ``keyStrength`` is zero, which is what makes the
    /// seventh āvaraṇa's sourcelessness a real absence rather than a dim light.
    let key: SIMD3<Double>?

    /// How strong that light stands, `0…1`.
    let keyStrength: Double

    /// How much arrives from everywhere at once, `0…1`.
    let ambientStrength: Double

    /// How much the material here is its own light, `0…1`.
    let glowFromWithin: Double

    /// How fast the air moves.
    let airDrift: Double

    /// Whether the walker is standing where no light has a direction.
    var isSourceless: Bool { key == nil }
}

/// The nine worlds as one climb.
enum WorldClimb {

    // MARK: - The shape of the space

    /// Design's `WORLD_SPACING`, in the room's own units.
    ///
    /// Design's is `30` three.js units; ours is one body-height, because
    /// ``RoomUnits`` builds the room as a body and the climb is the same body
    /// nine times over. Every one of Design's climb numbers is therefore ported
    /// as a **proportion of the spacing**, which is the unit-free fact, rather
    /// than as a three.js length that would mean nothing here.
    static var spacing: Double { RoomUnits.roomHeight }

    /// Design's `worldY(i)` — where a band stands. Keyed by ring; see the
    /// header for the two vocabulary gaps that is guarding against.
    static func station(ring: Int) -> Double { RoomUnits.worldFloorY(ring: ring) }

    /// The bottom of the climb: the first world's station.
    static var bottom: Double { station(ring: 1) }

    /// Design's `TOP = worldY(WORLDS.length - 1)` — the ninth world's station.
    static var top: Double { station(ring: HomeWorlds.rings.count) }

    /// The climb in bands: `0` at the first station, `8` at the ninth.
    static let fractionRange: ClosedRange<Double> = 0...Double(HomeWorlds.rings.count - 1)

    /// Design's `f = climb / WORLD_SPACING`, from a scene height.
    static func fraction(atHeight y: Double) -> Double {
        guard spacing > 0 else { return 0 }
        return (y - bottom) / spacing
    }

    /// The scene height of a point on the climb.
    static func height(atFraction f: Double) -> Double {
        bottom + f * spacing
    }

    /// The ring whose station is nearest — the āvaraṇa the walker would say he
    /// is in. Never a measure: it names an enclosure, the way a room's own
    /// label names hers.
    static func nearestRing(atFraction f: Double) -> Int {
        let clamped = min(fractionRange.upperBound, max(fractionRange.lowerBound, f))
        return Int(clamped.rounded()) + 1
    }

    // MARK: - Which bands are near

    /// Design's `WORLD_SPACING * 1.15` — how far a band's weather reaches
    /// before it is out of the world entirely.
    ///
    /// A little over one spacing, so the bands genuinely overlap and there is
    /// never a height at which nothing is near. This is what makes the climb
    /// continuous rather than a stack.
    static let nearReach: Double = 1.15

    /// Whether a band is near enough to be in the world at all. Design's
    /// `Math.abs(worldY(ix) - climb) < WORLD_SPACING * 1.15`.
    static func isNear(ring: Int, atFraction f: Double) -> Bool {
        abs(Double(ring - 1) - f) < nearReach
    }

    /// Every band near enough to matter here, with its own weight.
    ///
    /// The weight is Design's own `lerpColors(i0, i1, k)` written as what it
    /// is: a tent on each band's station, `1` at the station and `0` a spacing
    /// away. The sum over the nine is exactly `1` everywhere on the climb, so a
    /// blend is a weighted mean rather than something that can dim at a seam.
    static func weights(atFraction f: Double) -> [(ring: Int, weight: Double)] {
        let clamped = min(fractionRange.upperBound, max(fractionRange.lowerBound, f))
        let floor = clamped.rounded(.down)
        let k = clamped - floor
        let lower = Int(floor) + 1
        let upper = min(HomeWorlds.rings.count, lower + 1)
        if lower == upper { return [(lower, 1)] }
        if k <= 0 { return [(lower, 1)] }
        return [(lower, 1 - k), (upper, k)]
    }

    // MARK: - The air

    /// The veil at a height, blended. Design's own line:
    /// `const veil = WORLDS[i0].veil * (1 - k) + WORLDS[i1].veil * k`.
    static func veil(atFraction f: Double) -> Double {
        weights(atFraction: f).reduce(0) { sum, entry in
            sum + (HomeWorlds.character(ring: entry.ring)?.veil ?? 0) * entry.weight
        }
    }

    /// The air's density at a height, **with the veil's grip**.
    ///
    /// Design's line, exactly: the two bands' authored densities blended, and
    /// the whole scaled by `(1 + veil × 0.55)`. The scale is
    /// ``HomeWorlds/veilFogScale``, read rather than retyped, so the first
    /// āvaraṇa stands in exactly the air it was authored in and the ninth in
    /// 1.55 times as much.
    ///
    /// `entering` is the rite's own crossing, `0` at her threshold and `1`
    /// inside: Design thickens the same air until the world is swallowed and
    /// only she is left. It is one law rather than two because rising and
    /// entering are one continuous thickening — the air the walker crosses at
    /// her door is the air of the band he climbed to.
    static func fogDensity(atFraction f: Double, entering: Double = 0) -> Double {
        let base = weights(atFraction: f).reduce(0) { sum, entry in
            sum + (HomeWorlds.world(ring: entry.ring)?.fogDensity ?? 0) * entry.weight
        }
        let veiled = base * (1 + veil(atFraction: f) * HomeWorlds.veilFogScale)
        // `fog.density = baseDens * (1 + swallow * 1.6)`
        return veiled * (1 + HomeGrammar.smooth(entering) * 1.6)
    }

    /// The air's colour at a height. Design's `fog.color.lerpColors(fogCols[i0],
    /// fogCols[i1], k)`, over the same weights as everything else.
    static func fog(atFraction f: Double) -> SIMD3<Double> {
        weights(atFraction: f).reduce(SIMD3<Double>(0, 0, 0)) { sum, entry in
            guard let world = HomeWorlds.world(ring: entry.ring) else { return sum }
            return sum + SIMD3(world.fog.red, world.fog.green, world.fog.blue) * entry.weight
        }
    }

    // MARK: - The ground's own stone

    /// How far the ground stands from its resting plane, at a point of it.
    ///
    /// Blended over exactly the weights the air and the light are blended over,
    /// which is what makes the **material** continuous as the walker rises, not
    /// only the weather. The ground of the world he is in becomes the ground of
    /// the next one under his feet, and there is no height at which it changes
    /// suddenly. ``WorldClimbScene`` renders this as a morph over the nine band
    /// materials, weighed by the same numbers.
    static func relief(u: Double, v: Double, atFraction f: Double) -> Double {
        let point = SurfaceCoordinate(u: u, v: v)
        return weights(atFraction: f).reduce(0) { sum, entry in
            sum + (WorldBands.stones[entry.ring]?.relief(at: point) ?? 0) * entry.weight
        }
    }

    /// The ground's own light at a point, `0…1` — the Forehead's nine bodies,
    /// Totality's yantra, the one meridian above the Crown.
    ///
    /// It goes through ``RoomMaterial/emission(at:)``, so the binding condition
    /// holds on the axis exactly as it holds in a room: a glow is multiplied by
    /// how far the material actually moved, and ground that nothing happened to
    /// emits nothing at any brightness.
    static func emission(u: Double, v: Double, atFraction f: Double) -> Double {
        let point = SurfaceCoordinate(u: u, v: v)
        return min(1, weights(atFraction: f).reduce(0) { sum, entry in
            sum + (WorldBands.stones[entry.ring]?.emission(at: point) ?? 0) * entry.weight
        })
    }

    /// How wholly the walker is in one band: `1` standing at a station, `0`
    /// exactly between two.
    ///
    /// It exists for one thing, and it is a continuity fix rather than a
    /// flourish. A band's own light sits in a pattern that is that band's — the
    /// Forehead's nine bodies are not the Crown's five veils — and a pattern
    /// cannot be cross-faded the way a number can. So the light a band's ground
    /// carries is taken to **nothing** exactly where the walker is equally in
    /// two of them, which is the one place the pattern may be exchanged without
    /// anything being seen to change.
    static func wholeness(atFraction f: Double) -> Double {
        let top = weights(atFraction: f).map(\.weight).max() ?? 1
        return max(0, 2 * top - 1)
    }

    // MARK: - The whole weather at a height

    /// Everything at one height of the climb, at one moment of real time.
    ///
    /// Each band is read on **its own** clock — the Feet's day, the Crown's
    /// half-year — and the results are blended by how near the walker is. That
    /// is what makes rising past a band feel like weather changing rather than
    /// like a transition playing: two clocks at two rates are running at once
    /// near a boundary, and one is fading into the other.
    static func weather(atFraction f: Double, at seconds: TimeInterval) -> WorldWeather {
        let near = weights(atFraction: f)
        let clamped = min(fractionRange.upperBound, max(fractionRange.lowerBound, f))
        let floor = clamped.rounded(.down)
        let lower = Int(floor) + 1
        let upper = min(HomeWorlds.rings.count, lower + 1)

        var keySum = SIMD3<Double>(0, 0, 0)
        var keyStrength = 0.0
        var ambient = 0.0
        var glow = 0.0
        var drift = 0.0

        for entry in near {
            guard let reading = WorldBands.reading(ring: entry.ring, at: seconds) else { continue }
            ambient += reading.ambientStrength * entry.weight
            glow += reading.glowFromWithin * entry.weight
            drift += reading.airDrift * entry.weight
            // A sourceless band contributes no direction and no strength, so
            // the light comes wholly from its neighbour and fades to nothing as
            // the walker reaches the seventh āvaraṇa's own station. The fade is
            // in the weight, which is continuous — the absence is not a cut.
            guard let direction = reading.key else { continue }
            // **Where the light comes from is blended by how near the band is,
            // and by nothing else.** How *much* light it gives is the separate
            // sum below, and the two must not be multiplied together: a band's
            // strength is a function of its own clock, and the Pelvis's beats.
            //
            // Weighted by strength, the one shadow-casting key on the axis
            // swung tens of degrees of arc every 2.3 seconds anywhere between
            // the Feet and the Pelvis — the systole dragging the direction
            // overhead and letting it fall back — so the Feet's eleven standing
            // swells, the things Design says *"exist only to be raked"*, strobed
            // from long-raked to flat and back with every heartbeat. Blended by
            // weight, the direction is a path between the two bands' own
            // directions: it moves only when the walker does, and it says where
            // he is, which is the whole premise of the climb.
            keySum += direction * entry.weight
            keyStrength += reading.keyStrength * entry.weight
        }

        return WorldWeather(
            fraction: clamped,
            lower: lower,
            upper: upper,
            k: clamped - floor,
            veil: veil(atFraction: f),
            fog: fog(atFraction: f),
            fogDensity: fogDensity(atFraction: f),
            key: keyStrength > 0 ? WorldBands.normalise(keySum) : nil,
            keyStrength: keyStrength,
            ambientStrength: ambient,
            glowFromWithin: glow,
            airDrift: drift)
    }
}

// MARK: - Rising

// Design's Axis moves the walker up the axis two ways, and both are ported: a
// steady **rise** at `target += dt * 3.4`, and a **settle** toward wherever the
// target is at `climb += (target - climb) * (reduced ? 0.035 : 0.06)`.
//
// The settle is the same per-frame lerp ``RoomApproach`` already turned into the
// exponential it is, so it is reused rather than rewritten: the derivation
// (`tau = -1 / (fps · ln(1 - r))`) lives in one file, and the climb contributes
// only Design's own two rates. The rise is a ``RoomApproach/Motion/steady(seconds:)``
// over the distance left, which is the same thing a constant speed is.
//
// Three things follow, and they are the same three the rite's crossing gets:
// the walker's height is assertable at any instant with no renderer, a dropped
// frame cannot change where he ends up, and the reduce-motion path can genuinely
// stand still instead of being a loop that has been slowed down.

extension RoomApproach {

    /// Design's climb settle: `climb += (target - climb) * 0.06`.
    ///
    /// Note that it is **not** the rite's `0.03`: the axis settles twice as
    /// fast as a walker crosses toward a door, because the axis is a place he
    /// is moving through and her threshold is a place he is arriving at.
    static let climbRatePerFrame: Double = 0.06

    /// Design's reduced climb settle: `climb += (target - climb) * 0.035`.
    ///
    /// Ported, and then **not used to animate** — see ``WorldClimbTravel``. It
    /// is kept because it is Design's number and because it is the evidence
    /// that the reduce-motion reading here is a departure taken knowingly
    /// rather than a rate nobody looked up.
    static let reducedClimbRatePerFrame: Double = 0.035

    /// Design's rise: `target = Math.min(TOP, target + dt * 3.4)`, as a
    /// proportion of the spacing, because Design's `3.4` is against its own
    /// `SPACING = 30`. One band takes 8.8 seconds to rise through.
    static let riseBandsPerSecond: Double = 3.4 / 30
}

/// Where the walker stands on the climb, as a function of the clock.
///
/// The value is in **bands** — `0` at the first world's station and `8` at the
/// ninth's — because that is the unit the whole climb is written in and it is
/// free of any renderer's idea of a length.
struct WorldClimbTravel: Equatable {

    /// The stretch the walker is on.
    private(set) var stretch: RoomApproach

    init(_ stretch: RoomApproach) { self.stretch = stretch }

    /// Standing at a band's station, going nowhere.
    static func standing(atFraction f: Double) -> WorldClimbTravel {
        WorldClimbTravel(.standing(at: WorldClimbTravel.clamp(f)))
    }

    /// At the bottom of the climb, where the body begins.
    static let atTheFeet = WorldClimbTravel.standing(atFraction: 0)

    /// Where the walker stands at an instant, in bands.
    func value(at now: TimeInterval) -> Double {
        Self.clamp(stretch.value(at: now))
    }

    /// The settle: he has let go, and the climb closes on where he left it.
    /// Design's `0.06`, through ``RoomApproach``'s own derivation.
    static func settling(from here: Double, to there: Double,
                         at now: TimeInterval) -> WorldClimbTravel {
        WorldClimbTravel(RoomApproach(
            from: clamp(here), to: clamp(there), since: now,
            motion: .easing(tau: RoomApproach.tau(ratePerFrame: RoomApproach.climbRatePerFrame))))
    }

    /// The rise: a steady climb at Design's own pace, to wherever he is going.
    static func rising(from here: Double, to there: Double,
                       at now: TimeInterval) -> WorldClimbTravel {
        let from = clamp(here), to = clamp(there)
        let seconds = abs(to - from) / RoomApproach.riseBandsPerSecond
        guard seconds > 0 else { return .standing(atFraction: to) }
        return WorldClimbTravel(RoomApproach(from: from, to: to, since: now,
                                             motion: .steady(seconds: seconds)))
    }

    /// The reduce-motion path: he **steps** to the next station and stands
    /// there.
    ///
    /// Design's invariant 4 asks for reduced motion *"longer and quantized,
    /// never disabled"* and `iOS/FIDELITY.md` — standing law under charter
    /// §2.10 — forbids the loop a glide needs. Quantized satisfies both, and it
    /// is the same reading the render spine took for the room and the rite took
    /// for the crossing: the stations are still Design's stations, and every
    /// band is still passed through. What is dropped is the frame loop between
    /// them, not a band.
    static func stepping(from here: Double, by bands: Int) -> WorldClimbTravel {
        .standing(atFraction: (here.rounded() + Double(bands)))
    }

    /// The climb has ends. A walker cannot rise past Totality or sink below the
    /// Feet, and clamping here rather than at each caller is what keeps the
    /// blend's weights summing to one at both ends.
    static func clamp(_ f: Double) -> Double {
        min(WorldClimb.fractionRange.upperBound,
            max(WorldClimb.fractionRange.lowerBound, f))
    }
}

/// The walker's height on the climb, held where the scene's driver can read it
/// every frame.
///
/// A reference for the same reason ``RoomApproachSource`` is one: the gesture
/// changes it on the main thread a few times a climb, and the driver reads it
/// sixty times a second on SceneKit's own thread. Passing it as a value would
/// mean re-rendering the SwiftUI tree every frame to move the eye, which is the
/// one thing a render spine must never need.
final class WorldClimbSource: @unchecked Sendable {

    private(set) var travel: WorldClimbTravel

    init(_ travel: WorldClimbTravel = .atTheFeet) { self.travel = travel }

    func set(_ travel: WorldClimbTravel) { self.travel = travel }

    func value(at now: TimeInterval = Date().timeIntervalSinceReferenceDate) -> Double {
        travel.value(at: now)
    }
}
