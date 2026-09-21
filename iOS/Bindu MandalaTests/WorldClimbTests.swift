import XCTest
import SceneKit
@testable import Bindu_Mandala

// MARK: - The nine worlds as one climb
//
// Build Brief v2 §3.2. What this suite has to prove is not that nine bands
// exist — that is a table, and `HomeWorldsTests` already judges it — but that
// they are one **space**:
//
//   * each band keeps its own clock, at Design's own rate, ported exactly;
//   * the climb is monotone in world units, and the two places Design's own
//     vocabulary cannot carry it are named rather than papered;
//   * the tempo scales the world's clock and can never reach an adaptation;
//   * the veil scales the fog, and nothing else;
//   * crossing between bands is **travel**, not a cut — continuous in the air,
//     in the light, in the stone and in the eye;
//   * the seventh āvaraṇa has no directional light at all;
//   * and nothing anywhere in the climb is a free-standing solid.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE RATES ARE CHECKED AGAINST DESIGN'S OWN FILE, ON DISK
// ─────────────────────────────────────────────────────────────────────────────
//
// A table of numbers typed into a test proves only that somebody typed the same
// numbers twice. `testEveryClockRateIsDesignsOwn` reads
// `Claude Design Round 2/homes/homes-worlds.js` and the working Axis off disk
// and asserts each rate's own expression is in them — the same discipline
// `LawsTests` uses, and for the same reason: a corpus that has gone stale must
// fail loudly rather than pass quietly.

final class WorldClimbTests: XCTestCase {

    // MARK: - Design's file, as the source of truth

    private static let designRoot = LawSource.repoRoot
        .appendingPathComponent("Claude Design Round 2/homes", isDirectory: true)

    private func design(_ file: String) throws -> String {
        let url = Self.designRoot.appendingPathComponent(file)
        guard let text = try? String(contentsOf: url, encoding: .utf8), text.count > 2_000 else {
            throw XCTSkip("""
                Design's `\(file)` is not at \(url.path). Every rate in the climb is a port of a \
                literal in that file, so this check has nothing to read.
                """)
        }
        return text
    }

    /// **Every clock rate is Design's own, read out of Design's own file.**
    ///
    /// The whole claim of this phase is that ring 6 feels slower than ring 2
    /// without anything being said, and that only holds if the rates are the
    /// rates. Each expression below is asserted to be *in* `homes-worlds.js`,
    /// so a typo in the port fails here rather than becoming the instrument.
    func testEveryClockRateIsDesignsOwn() throws {
        let js = try design("homes-worlds.js")

        let expressions: [(ring: Int, expression: String)] = [
            (1, "const day = (t * 0.05) % 1"),
            (2, "const bpm = t * 1.05"),
            (3, "u.uTime.value = t"),
            (4, "const fort = 0.5 + 0.5 * Math.sin(t * 0.0398)"),
            (5, "const moon = 0.5 + 0.5 * Math.sin(t * 0.0199)"),
            (6, "const season = 0.5 + 0.5 * Math.sin(t * 0.0066)"),
            (7, "const half = 0.5 + 0.5 * Math.sin(t * 0.0033)"),
            (8, "const yr = t * 0.062"),
            (9, "yantra.rotation.y = t * 0.008"),
        ]
        for entry in expressions {
            XCTAssertTrue(js.contains(entry.expression),
                          """
                          ring \(entry.ring)'s clock is ported from `\(entry.expression)` and that \
                          expression is no longer in `homes-worlds.js`. Either the port or the design \
                          has moved, and one of them is now wrong.
                          """)
        }

        // The ninth carries two, and the second is the one that does not turn.
        XCTAssertTrue(js.contains("0.9 + 0.16 * Math.sin(t * 0.13)"),
                      "Totality's akāla breath is ported from the core's own scale")

        // And the ported rates really are those numbers.
        XCTAssertEqual(WorldBands.clock(ring: 1), .cycling(rate: 0.05))
        XCTAssertEqual(WorldBands.clock(ring: 2), .pulsing(rate: 1.05))
        XCTAssertEqual(WorldBands.clock(ring: 3), .flowing(rate: 1.00))
        XCTAssertEqual(WorldBands.clock(ring: 4), .swinging(rate: 0.0398))
        XCTAssertEqual(WorldBands.clock(ring: 5), .swinging(rate: 0.0199))
        XCTAssertEqual(WorldBands.clock(ring: 6), .swinging(rate: 0.0066))
        XCTAssertEqual(WorldBands.clock(ring: 7), .swinging(rate: 0.0033))
        XCTAssertEqual(WorldBands.clock(ring: 8), .turning(rate: 0.062))
        XCTAssertEqual(WorldBands.clock(ring: 9), .turningAndBreathing(turn: 0.008, breath: 0.13))

        XCTAssertEqual(WorldBands.clocks.count, HomeWorlds.rings.count,
                       "there are nine āvaraṇas and there must be nine clocks")
        for ring in HomeWorlds.rings {
            XCTAssertNotNil(WorldBands.reading(ring: ring, at: 40),
                            "ring \(ring) has a clock but no weather")
        }
        XCTAssertNil(WorldBands.clock(ring: 10), "there is no tenth āvaraṇa")
        XCTAssertNil(WorldBands.reading(ring: 0, at: 0))
    }

    /// **The climb's own numbers are Design's, read out of the working Axis.**
    ///
    /// The Axis is the instrument whose behaviour is the specification, so the
    /// settle, the rise and the reach a band's weather has are checked against
    /// it rather than against a memory of it.
    func testTheClimbsTravelIsDesignsOwn() throws {
        let axis = try design("The Homes - The Axis.html")

        XCTAssertTrue(axis.contains("climb += (target - climb) * (reduced ? 0.035 : 0.06)"),
                      "the settle is ported from this line")
        XCTAssertEqual(RoomApproach.climbRatePerFrame, 0.06, accuracy: 1e-12)
        XCTAssertEqual(RoomApproach.reducedClimbRatePerFrame, 0.035, accuracy: 1e-12)

        XCTAssertTrue(axis.contains("target + dt * 3.4"), "the rise is ported from this line")
        XCTAssertEqual(RoomApproach.riseBandsPerSecond, 3.4 / 30, accuracy: 1e-12,
                       "Design's 3.4 is against its own SPACING of 30, so the ported rate is in bands")

        XCTAssertTrue(axis.contains("WORLD_SPACING * 1.15"),
                      "how far a band's weather reaches is ported from this line")
        XCTAssertEqual(WorldClimb.nearReach, 1.15, accuracy: 1e-12)

        let js = try design("homes-worlds.js")
        XCTAssertTrue(js.contains("const SPACING = 30"), "Design's spacing")
        XCTAssertTrue(js.contains("worldY = (i) => i * SPACING"), "Design's station")
        XCTAssertTrue(axis.contains("(1 + veil * 0.55)"), "the veil's grip on the fog")
        XCTAssertEqual(HomeWorlds.veilFogScale, 0.55, accuracy: 1e-12)

        // The settle is the rite's own derivation, reused rather than rewritten.
        let tau = RoomApproach.tau(ratePerFrame: RoomApproach.climbRatePerFrame)
        XCTAssertEqual(tau, -1 / (60 * log(1 - 0.06)), accuracy: 1e-12)
    }

    // MARK: - Each band's own clock, and what it is worth

    /// **Nine bands, nine rates, and the sixth really is slower than the
    /// second.**
    ///
    /// The claim the phase rests on, as a number. The felt period is the band's
    /// own clock through its own tempo — the only place the tempo is ever
    /// applied — and the Forehead's season comes round some eight hundred times
    /// slower than the Pelvis's pulse. Nothing anywhere says so.
    func testTheSixthBandIsSlowerThanTheSecondAndNothingSaysSo() {
        var felt: [Int: TimeInterval] = [:]
        for ring in HomeWorlds.rings {
            felt[ring] = WorldBands.feltPeriod(ring: ring)
            print("WORLD_CLOCK {\"ring\":\(ring),"
                  + String(format: "\"rate\":%.4f,\"period\":%.1f,\"felt\":%.1f}",
                           WorldBands.clock(ring: ring)?.rate ?? 0,
                           WorldBands.clock(ring: ring)?.period ?? 0,
                           felt[ring] ?? 0))
        }

        XCTAssertGreaterThan(felt[6]!, felt[2]! * 100,
                             "the Forehead's season must be an order of magnitude slower than the Pelvis's pulse")
        XCTAssertGreaterThan(felt[7]!, felt[1]! * 100,
                             "the Crown's half-year must be far slower than the Feet's day")
        XCTAssertGreaterThan(felt[2]!, 0)

        // The tempo is doing real work: the band's own clock alone would not
        // separate them by as much as the clock and the mental state together.
        let bare6 = WorldBands.clock(ring: 6)!.period
        let bare2 = WorldBands.clock(ring: 2)!.period
        XCTAssertGreaterThan(felt[6]! / felt[2]!, bare6 / bare2,
                             "the mental state must deepen the separation the clock already makes")
    }

    /// **The periods are not monotone, and that is Design's.**
    ///
    /// A *year* above the Crown comes round faster than a *fortnight* at the
    /// Heart, because the year there is one sweep of a single band of light and
    /// the fortnight is a swell that has to be waited out. Asserted out loud so
    /// that a future tidying into a descending ramp fails the suite instead of
    /// the instrument — the same guard ``HomeWorlds/tempi`` already carries for
    /// the third āvaraṇa running slower than the fourth.
    func testTheBandPeriodsAreNotAMonotoneRamp() {
        let eight = WorldBands.clock(ring: 8)!.period
        let four = WorldBands.clock(ring: 4)!.period
        XCTAssertLessThan(eight, four,
                          """
                          above the Crown's year is no longer shorter than the Heart's fortnight. \
                          Design's rates were reordered, and the word now names how fast the clock \
                          runs rather than what it is a clock of.
                          """)
        XCTAssertLessThan(HomeWorlds.tempi[2], HomeWorlds.tempi[3],
                          "deep sleep is still the slowest thing in the outer half")
    }

    /// **A band's phase comes round, whatever kind of number its rate is.**
    ///
    /// The one fact that makes nine different kinds of clock comparable. A
    /// phase that never returned to where it started would not be a clock.
    func testEveryBandsPhaseComesRound() {
        for ring in HomeWorlds.rings {
            guard let clock = WorldBands.clock(ring: ring) else {
                return XCTFail("ring \(ring) has no clock")
            }
            let period = clock.period
            XCTAssertTrue(period.isFinite && period > 0, "ring \(ring) has no period")
            for start in [0.0, 3.0, 11.5] {
                XCTAssertEqual(clock.phase(at: start),
                               clock.phase(at: start + period),
                               accuracy: 1e-6,
                               "ring \(ring)'s clock does not come round in its own period")
            }
            // And it really moves: a clock that stood still would pass the above.
            XCTAssertNotEqual(clock.phase(at: 0), clock.phase(at: period / 3), accuracy: 1e-9)
        }
    }

    // MARK: - The climb itself

    /// **The climb is monotone in world units, and its two vocabulary gaps are
    /// named.**
    ///
    /// ``RoomUnits/worldFloorY(ring:)`` keys the climb by ring rather than by
    /// the region's words, and this is the reason: two of Design's nine region
    /// names fall outside Design's own body-zone vocabulary. Read off those
    /// words the second world would stand *below* the first and the seventh and
    /// eighth would stand at one height — which is not a climb at all.
    func testTheClimbIsMonotoneAndTheTwoVocabularyGapsAreNamed() {
        var last: Double?
        for ring in HomeWorlds.rings {
            let y = WorldClimb.station(ring: ring)
            if let last {
                XCTAssertGreaterThan(y, last, "ring \(ring) does not stand above ring \(ring - 1)")
                XCTAssertEqual(y - last, WorldClimb.spacing, accuracy: 1e-9,
                               "the bands are not evenly spaced — Design's SPACING is one number")
            }
            last = y
        }
        XCTAssertEqual(WorldClimb.bottom, RoomUnits.floorY, accuracy: 1e-9)
        XCTAssertEqual(WorldClimb.top, WorldClimb.station(ring: 9), accuracy: 1e-9)
        XCTAssertEqual(WorldClimb.spacing, RoomUnits.roomHeight, accuracy: 1e-9,
                       "a band is a body, because the room is a body")

        // The fraction and the height are one conversion, both ways.
        for ring in HomeWorlds.rings {
            XCTAssertEqual(WorldClimb.fraction(atHeight: WorldClimb.station(ring: ring)),
                           Double(ring - 1), accuracy: 1e-9)
            XCTAssertEqual(WorldClimb.nearestRing(atFraction: Double(ring - 1)), ring)
        }

        // ── the two gaps, out loud ──────────────────────────────────────────
        let middle = HomeGrammar.bodyAltitude(bodilyLocation: "")
        XCTAssertEqual(RoomUnits.worldRegionAltitude(ring: 2), middle, accuracy: 1e-9,
                       """
                       ring 2's region `Pelvis` now resolves to a zone of its own. The recorded gap \
                       has closed, and the note in `RoomUnits.worldFloorY` and this test are stale.
                       """)
        XCTAssertEqual(RoomUnits.worldRegionAltitude(ring: 8),
                       RoomUnits.worldRegionAltitude(ring: 7), accuracy: 1e-9,
                       """
                       ring 8's `Above crown` no longer shares the Crown's altitude. The recorded gap \
                       has changed and the climb's keying should be re-read.
                       """)

        // And the gap really would break the climb, which is why it is keyed by
        // ring rather than by the word. Altitude runs crown `0` → soles `1`, so
        // a world standing higher in the body must read *lower*. The Pelvis
        // falls through to the middle of the body at 0.5 and so reads as
        // standing above the Navel at 0.66 — the second world above the third,
        // which is the climb turned over.
        XCTAssertLessThan(RoomUnits.worldRegionAltitude(ring: 2),
                          RoomUnits.worldRegionAltitude(ring: 3),
                          """
                          read off the region words, the Pelvis no longer stands above the Navel. The \
                          gap has closed and the note in `RoomUnits.worldFloorY` is stale.
                          """)
    }

    /// **A band's weather reaches a little over one spacing, and something is
    /// always near.**
    ///
    /// Design's `|worldY(ix) - climb| < WORLD_SPACING * 1.15`. The overlap is
    /// what makes the climb continuous rather than a stack: there is no height
    /// at which no band is in the world.
    func testTheBandsOverlapSoNothingIsEverEmpty() {
        for step in 0...800 {
            let f = Double(step) / 100
            let near = HomeWorlds.rings.filter { WorldClimb.isNear(ring: $0, atFraction: f) }
            XCTAssertGreaterThanOrEqual(near.count, 2,
                                        "at f=\(f) only \(near.count) bands are near — the climb has a hole")
            XCTAssertLessThanOrEqual(near.count, 3,
                                     "at f=\(f) three bands' weather is more than the air can hold")

            let weights = WorldClimb.weights(atFraction: f)
            XCTAssertEqual(weights.reduce(0) { $0 + $1.weight }, 1, accuracy: 1e-12,
                           "the weights at f=\(f) do not sum to one, so a blend would dim at a seam")
            for entry in weights {
                XCTAssertTrue(WorldClimb.isNear(ring: entry.ring, atFraction: f),
                              "ring \(entry.ring) carries weight at f=\(f) but is not near")
            }
        }
        // A band is wholly itself at its own station and gone a spacing away.
        for ring in HomeWorlds.rings {
            let station = Double(ring - 1)
            let weights = WorldClimb.weights(atFraction: station)
            XCTAssertEqual(weights.count, 1, "ring \(ring) does not have its own station to itself")
            XCTAssertEqual(weights.first?.ring, ring)
            XCTAssertEqual(weights.first?.weight ?? 0, 1, accuracy: 1e-12)
        }
    }

    // MARK: - The veil, and only the veil, scales the fog

    func testTheVeilScalesTheFogDensityAndNothingElseDoes() {
        for ring in HomeWorlds.rings {
            guard let world = HomeWorlds.world(ring: ring) else { return XCTFail("no ring \(ring)") }
            let expected = world.fogDensity * (1 + world.character.veil * 0.55)
            XCTAssertEqual(world.veiledFogDensity, expected, accuracy: 1e-12)
            XCTAssertEqual(WorldClimb.fogDensity(atFraction: Double(ring - 1)),
                           expected, accuracy: 1e-12,
                           "the climb's air at ring \(ring)'s station is not that āvaraṇa's own air")
            XCTAssertEqual(WorldClimb.veil(atFraction: Double(ring - 1)),
                           world.character.veil, accuracy: 1e-12)
        }

        // The Bhūpura is unveiled and stands in exactly the air it was authored
        // in; the Bindu is wholly veiled and stands in 1.55 times as much.
        XCTAssertEqual(WorldClimb.fogDensity(atFraction: 0),
                       HomeWorlds.world(ring: 1)!.fogDensity, accuracy: 1e-12)
        XCTAssertEqual(WorldClimb.fogDensity(atFraction: 8),
                       HomeWorlds.world(ring: 9)!.fogDensity * 1.55, accuracy: 1e-12)

        // The veil rises inward and never turns back.
        var last = -1.0
        for step in 0...800 {
            let veil = WorldClimb.veil(atFraction: Double(step) / 100)
            XCTAssertGreaterThanOrEqual(veil, last - 1e-12, "the air thins going inward")
            last = veil
        }
        XCTAssertEqual(WorldClimb.veil(atFraction: 0), 0, accuracy: 1e-12)
        XCTAssertEqual(WorldClimb.veil(atFraction: 8), 1, accuracy: 1e-12)

        // Entering thickens the same air, and only in the one direction.
        let outside = WorldClimb.fogDensity(atFraction: 3, entering: 0)
        let inside = WorldClimb.fogDensity(atFraction: 3, entering: 1)
        XCTAssertEqual(inside, outside * 2.6, accuracy: 1e-9,
                       "Design's `fog.density = baseDens * (1 + swallow * 1.6)`")
    }

    // MARK: - The two clocks, and the wall between them

    /// **The tempo cannot reach an adaptation clock, and this asserts it three
    /// ways because there are three ways to break it.**
    ///
    /// A slow āvaraṇa handing the walker a cheaper second adaptation than a
    /// fast one would be depth bought by where he was standing rather than by
    /// how long he stayed. That is the never-measure law at the timing layer,
    /// and it is the one thing about this phase that could break the whole
    /// instrument quietly.
    func testTheTempoNeverReachesAnAdaptationClock() {
        // 1 · the door that exists to say so, and does nothing.
        for ring in HomeWorlds.rings {
            for t in stride(from: 0.0, through: 400.0, by: 13.0) {
                XCTAssertEqual(HomeWorlds.adaptationClock(t, ring: ring), t, accuracy: 0,
                               "the adaptation clock was scaled in ring \(ring)")
            }
            // …while the world's clock genuinely is scaled.
            let tempo = HomeWorlds.character(ring: ring)!.tempo
            XCTAssertEqual(HomeWorlds.worldClock(100, ring: ring), 100 * tempo, accuracy: 1e-9)
            XCTAssertEqual(WorldBands.bandTime(100, ring: ring), 100 * tempo, accuracy: 1e-9,
                           "the band reads its own clock through the one door that scales it")
        }

        // 2 · a stay is the same stay in every āvaraṇa. Same position, same
        // clock, nine different worlds: the two adaptations may not differ.
        let marks: [TimeInterval] = [0, 30, HomeMemory.firstAdaptation, 150,
                                     HomeMemory.holdEnd, 300, HomeMemory.secondAdaptationEnd]
        var readings: [Int: [(Double, Double)]] = [:]
        for ring in HomeWorlds.rings {
            guard let room = HomeRooms.resolve(position: 50, ring: ring,
                                               tattva: "Pṛthivī", quality: "she who attracts",
                                               bodilyLocation: "heart") else {
                return XCTFail("no room resolved in ring \(ring)")
            }
            readings[ring] = marks.map { t in
                let pose = RoomPose(sceneTime: t, room: room)
                return (pose.settling, pose.deep)
            }
        }
        for ring in HomeWorlds.rings.dropFirst() {
            for (index, mark) in marks.enumerated() {
                XCTAssertEqual(readings[ring]![index].0, readings[1]![index].0, accuracy: 1e-12,
                               "at t=\(mark) the first adaptation differs between ring \(ring) and ring 1")
                XCTAssertEqual(readings[ring]![index].1, readings[1]![index].1, accuracy: 1e-12,
                               "at t=\(mark) the second adaptation differs between ring \(ring) and ring 1")
            }
        }

        // 3 · the source. The climb's three files know nothing about a stay, so
        // there is nowhere in them for a tempo and an adaptation to meet.
        let climbFiles = ["WorldBands.swift", "WorldClimb.swift", "WorldClimbScene.swift"]
        // Qualified on purpose. `settling` is also Design's own word for the
        // climb closing on where the walker let it go — `WorldClimbTravel.settling`
        // — and a bare-name scan would flag that and teach whoever hit it to
        // weaken the check. What may not appear is a reference to the **stay's**
        // clock: its marks, its progress functions, or the object that holds it.
        let adaptationVocabulary = ["chamberTime", "HomeMemory.", "RoomClock", "RoomPose",
                                    "HomeGrammar.settling(", "HomeGrammar.deepProgress(",
                                    "adaptationClock"]
        var checked = 0
        for name in climbFiles {
            guard let file = LawSource.production.first(where: { $0.name == name }) else {
                return XCTFail("\(name) is not in the shipping tree")
            }
            checked += 1
            let code = String(file.lexed.masked)
            for word in adaptationVocabulary {
                XCTAssertFalse(code.contains(word),
                               """
                               \(name) names `\(word)` in code. The climb runs on the world's clock and \
                               must not be able to see a stay's at all — that is the wall the \
                               never-measure law needs at the timing layer.
                               """)
            }
            XCTAssertTrue(code.contains("worldClock") || code.contains("bandTime")
                          || code.contains("WorldBands.reading") || code.contains("WorldClimb."),
                          "\(name) no longer reads a world clock — this scan is proving nothing")
        }
        XCTAssertEqual(checked, climbFiles.count)

        // And the one door really is the only one: `tempo` appears in code in
        // exactly two files — where it is defined, and where a band's felt
        // period is reported.
        let pinned: Set<String> = ["HomeWorlds.swift", "WorldBands.swift"]
        var naming: Set<String> = []
        for file in LawSource.production where String(file.lexed.masked).contains("tempo") {
            naming.insert(file.name)
        }
        XCTAssertEqual(naming, pinned,
                       """
                       the tempo is named in code in \(naming.sorted()). It scales the world's clock and \
                       nothing else, so a third file reading it has to be written down here, with a \
                       reason, by whoever added it.
                       """)
    }

    // MARK: - Crossing a band is travel, never a cut

    /// **The eye moves continuously across every band boundary, at quarter-
    /// second resolution, with a bound.**
    ///
    /// Design's invariant 3 allows only travel, and the Phase 3.1 review caught
    /// exactly this class of defect in the spike — the eye jumping 1.5 units
    /// between one second and the next as it crossed a seam. This is that check,
    /// over the whole climb, at Design's own rise rate.
    func testTheEyeCrossesEveryBandWithoutJumping() {
        let scene = WorldClimbScene()
        let seconds = WorldClimb.fractionRange.upperBound / RoomApproach.riseBandsPerSecond
        let rise = WorldClimbTravel.rising(from: 0, to: WorldClimb.fractionRange.upperBound, at: 0)

        // The bound is the spike's own: a quarter of a scene unit between one
        // quarter-second and the next. At Design's rise rate the eye travels
        // 0.18 units in that time, so the bound has room for the sway and none
        // at all for a seam.
        let bound = 0.25
        scene.stand(atFraction: rise.value(at: 0), at: 0)
        var previous = scene.eye
        var worst = 0.0
        var worstAt = 0.0
        var step = 1
        while Double(step) * 0.25 <= seconds {
            let t = Double(step) * 0.25
            scene.stand(atFraction: rise.value(at: t), at: t)
            let now = scene.eye
            let moved = ((now.x - previous.x) * (now.x - previous.x)
                         + (now.y - previous.y) * (now.y - previous.y)
                         + (now.z - previous.z) * (now.z - previous.z)).squareRoot()
            if moved > worst { worst = moved; worstAt = t }
            XCTAssertLessThan(moved, bound,
                              "the eye jumped \(moved) units at t=\(t), f=\(rise.value(at: t))")
            previous = now
            step += 1
        }
        print(String(format: "CLIMB_CONTINUITY {\"worstEyeMove\":%.4f,\"atSeconds\":%.2f,\"bound\":%.2f}",
                     worst, worstAt, bound))

        // And it really did cross all nine: a check that never moved would pass
        // the bound trivially.
        XCTAssertEqual(rise.value(at: seconds), WorldClimb.fractionRange.upperBound, accuracy: 1e-9)
        XCTAssertGreaterThan(worst, 0.01, "the eye barely moved — the rise is not rising")
    }

    /// **Nothing the walker is given jumps at a band boundary — and halving the
    /// step halves the change, which is what continuity actually means.**
    ///
    /// A generous absolute bound can be satisfied by a small cut. A quantity
    /// that is genuinely continuous changes half as much over half the distance;
    /// one with a step in it changes the same amount however finely it is
    /// sampled. Both are asserted.
    func testEveryWeatherQuantityIsContinuousAcrossTheWholeClimb() {
        func sweep(_ step: Double) -> [String: Double] {
            var worst: [String: Double] = [:]
            func note(_ name: String, _ delta: Double) {
                worst[name] = max(worst[name] ?? 0, abs(delta))
            }
            let top = WorldClimb.fractionRange.upperBound
            var f = 0.0
            var previous = WorldClimb.weather(atFraction: 0, at: 90)
            var previousRelief = WorldClimb.relief(u: 0.42, v: 0.58, atFraction: 0)
            while f < top {
                f = min(top, f + step)
                let now = WorldClimb.weather(atFraction: f, at: 90)
                note("veil", now.veil - previous.veil)
                note("fogDensity", now.fogDensity - previous.fogDensity)
                note("fogRed", now.fog.x - previous.fog.x)
                note("fogGreen", now.fog.y - previous.fog.y)
                note("fogBlue", now.fog.z - previous.fog.z)
                note("keyStrength", now.keyStrength - previous.keyStrength)
                note("ambient", now.ambientStrength - previous.ambientStrength)
                note("glow", now.glowFromWithin - previous.glowFromWithin)
                note("airDrift", now.airDrift - previous.airDrift)
                let relief = WorldClimb.relief(u: 0.42, v: 0.58, atFraction: f)
                note("relief", relief - previousRelief)
                previous = now
                previousRelief = relief
            }
            return worst
        }

        // Two steps, one half the other. The coarse step is fine enough that
        // every feature in the stone is sampled dozens of times over, so a
        // continuous quantity's largest change per step must halve with the
        // step. A quantity with a cut in it does not: the jump is the jump
        // however finely it is sampled, and the ratio stays at one.
        let step = 0.002
        let coarse = sweep(step)
        let fine = sweep(step / 2)
        for (name, value) in coarse.sorted(by: { $0.key < $1.key }) {
            let ratio = value > 0 ? (fine[name] ?? 0) / value : 0
            print(String(format: "CLIMB_SEAM {\"quantity\":\"%@\",\"perStep\":%.6f,\"perBand\":%.4f,\"halvingRatio\":%.3f}",
                         name, value, value / step, ratio))
            XCTAssertLessThan(value / step, 25,
                              """
                              \(name) changes at \(value / step) per band. Nothing on the climb moves \
                              that fast; either a band boundary is a cut or a quantity is unbounded.
                              """)
            XCTAssertLessThan(ratio, 0.75,
                              """
                              halving the step did not halve \(name)'s largest change (\(value) → \
                              \(fine[name] ?? 0), ratio \(ratio)). A quantity with a step in it changes \
                              the same amount however finely it is sampled, which is what a cut is.
                              """)
        }
        XCTAssertEqual(coarse.count, 10, "the sweep stopped reading some of the weather")
        XCTAssertGreaterThan(coarse["fogRed"] ?? 0, 0,
                             "the air's colour never changes over the whole climb — the sweep is not reading")
        XCTAssertGreaterThan(coarse["relief"] ?? 0, 0,
                             "the stone never changes over the whole climb — the bands have no condition")
    }

    // MARK: - The seventh āvaraṇa

    /// **Ring 7 has no key light. Not a dim one — none.**
    ///
    /// Design's pearl at 0.95 diffusion is *"sourceless — no directional light
    /// at all"*, and the renderer ruling turned on it. On the climb it has to
    /// hold in three registers: the band's own reading, the blended weather at
    /// its station, and the scene graph the walker is standing in.
    func testTheSeventhAvaranaHasNoDirectionalLightAnywhere() {
        for t in stride(from: 0.0, through: 900.0, by: 31.0) {
            guard let reading = WorldBands.reading(ring: 7, at: t) else {
                return XCTFail("the Crown has no weather at t=\(t)")
            }
            XCTAssertNil(reading.key, "the Crown was given a direction to be lit from at t=\(t)")
            XCTAssertEqual(reading.keyStrength, 0, accuracy: 0,
                           "the Crown's key is dim rather than absent at t=\(t)")
            XCTAssertGreaterThan(reading.ambientStrength, 0.9,
                                 "a sourceless room must still be a room")

            let here = WorldClimb.weather(atFraction: 6, at: t)
            XCTAssertNil(here.key, "standing at the Crown's own station there is still a direction")
            XCTAssertEqual(here.keyStrength, 0, accuracy: 1e-12)
            XCTAssertTrue(here.isSourceless)
        }

        // Every other āvaraṇa does have one, so this is a fact about the
        // seventh rather than about the climb.
        for ring in HomeWorlds.rings where ring != 7 {
            guard let reading = WorldBands.reading(ring: ring, at: 40) else {
                return XCTFail("ring \(ring) has no weather")
            }
            XCTAssertNotNil(reading.key, "ring \(ring) lost its light")
            XCTAssertGreaterThan(reading.keyStrength, 0, "ring \(ring)'s key is not burning")
        }

        // And it is read from the gem rather than from a ring number, so the
        // fact lives in one place for the whole instrument.
        XCTAssertEqual(HomeGem.sourcelessRing, 7)
        XCTAssertTrue(HomeGem.gemFor(ring: 7, khadgamalaPosition: nil).isSourceless)

        // The scene graph itself.
        let scene = WorldClimbScene()
        scene.stand(atFraction: 6, at: 120)
        XCTAssertEqual(scene.activeKeys, 0,
                       """
                       there is a directional light burning in the seventh āvaraṇa. `keyNode.light` must \
                       be `nil` there — with no directional light there is nothing to cast, which is \
                       Design's "no shadow anywhere" without a second setting to keep in step.
                       """)
        for ring in HomeWorlds.rings where ring != 7 {
            scene.stand(atFraction: Double(ring - 1), at: 120)
            XCTAssertEqual(scene.activeKeys, 1, "ring \(ring) has \(scene.activeKeys) keys, not one")
        }

        // The absence arrives by travel: the light fades to nothing as the
        // walker comes to the station and returns as he leaves. It is a place he
        // passes through, not a switch that is thrown.
        var strengths: [Double] = []
        for step in 0...40 {
            let f = 5.0 + Double(step) / 20
            strengths.append(WorldClimb.weather(atFraction: f, at: 120).keyStrength)
        }
        XCTAssertEqual(strengths[20], 0, accuracy: 1e-12, "the station itself")
        XCTAssertGreaterThan(strengths[0], 0.05, "a spacing below, there is light")
        XCTAssertGreaterThan(strengths[40], 0.05, "a spacing above, there is light again")
        for i in 1...20 {
            XCTAssertLessThanOrEqual(strengths[i], strengths[i - 1] + 1e-9,
                                     "the light must only fade on the way to the Crown")
        }
    }

    // MARK: - The binding condition, on the axis

    /// **The whole climb is two meshes — the ground and the air — and neither
    /// is a free-standing solid.**
    ///
    /// Design's third depth layer is her mechanism, and on the axis there is no
    /// her — so the climb has two layers and nothing in it may stand in space.
    /// What it holds is the ground the walker is on and the air he is in.
    func testTheClimbHoldsNothingStandingInTheAir() {
        let scene = WorldClimbScene()
        XCTAssertEqual(scene.layerName(.ground), "ground")
        XCTAssertEqual(scene.layerName(.world), "world")
        XCTAssertEqual(WorldClimbScene.Layer.allCases.count, 2,
                       "a third layer appeared on the axis — there is no Śakti here to have one")

        XCTAssertEqual(scene.solids(in: .ground), 1,
                       "the building is one ground; \(scene.solids(in: .ground)) meshes were found")
        XCTAssertEqual(scene.solids(in: .world), 1, "the world's only mesh is the air itself")
        XCTAssertEqual(scene.solidsInTheClimb, 2,
                       """
                       the climb holds \(scene.solidsInTheClimb) meshes. It may hold the ground the \
                       walker stands on and the air he stands in, and nothing else: a lit solid \
                       standing in the space is exactly what the renderer ruling's binding condition \
                       exists to prevent, and on the axis there is not even a Śakti for it to belong to.
                       """)
    }

    /// **The ground is the blend, and the morph is how it is drawn.**
    ///
    /// Eight targets over a base — the nine bands — blended *normalised*, so the
    /// first band carries whatever weight the targets leave rather than the
    /// ground overshooting every band by the whole of the one beneath it. The
    /// weights are the climb's own, so the material cannot develop a seam the
    /// weather does not also have.
    func testTheGroundMorphsOverTheNineBandsOnTheClimbsOwnWeights() {
        let scene = WorldClimbScene()
        guard let facts = scene.groundFacts else { return XCTFail("the ground carries no morph") }
        XCTAssertEqual(facts.adaptations, HomeWorlds.rings.count - 1,
                       "the ground morphs over \(facts.adaptations + 1) bands, not nine")
        XCTAssertTrue(facts.isNormalised,
                      """
                      the ground's morph is additive. Two bands at full weight would then arrive at \
                      `first + second - base`, overshooting the ground by the whole of the first — \
                      which is the same defect `RoomScene` records for a room's two adaptations.
                      """)

        for ring in HomeWorlds.rings {
            scene.stand(atFraction: Double(ring - 1), at: 100)
            let weights = scene.groundWeights
            XCTAssertEqual(weights.count, HomeWorlds.rings.count)
            for (index, weight) in weights.enumerated() {
                XCTAssertEqual(weight, index + 1 == ring ? 1 : 0, accuracy: 1e-9,
                               "at ring \(ring)'s own station the ground is not wholly that band's")
            }
        }

        // Between two stations it is exactly the blend the air is.
        scene.stand(atFraction: 3.25, at: 100)
        let between = scene.groundWeights
        XCTAssertEqual(between[3], 0.75, accuracy: 1e-9, "ring 4 at three quarters")
        XCTAssertEqual(between[4], 0.25, accuracy: 1e-9, "ring 5 at one quarter")
        XCTAssertEqual(between.reduce(0, +), 1, accuracy: 1e-9)
    }

    /// **A band's own light is exchanged only where it is showing none.**
    ///
    /// The pattern a band's ground glows in belongs to that band — the
    /// Forehead's nine bodies are not the Crown's five veils — and a pattern
    /// cannot be cross-faded the way a number can. ``WorldClimb/wholeness(atFraction:)``
    /// takes it to nothing exactly where the walker is equally in two bands,
    /// which is the one height at which the map may be swapped invisibly.
    func testABandsOwnLightIsExchangedWhereItIsShowingNone() {
        for ring in HomeWorlds.rings {
            XCTAssertEqual(WorldClimb.wholeness(atFraction: Double(ring - 1)), 1, accuracy: 1e-9,
                           "at ring \(ring)'s station the walker is not wholly in it")
        }
        for boundary in 0..<(HomeWorlds.rings.count - 1) {
            XCTAssertEqual(WorldClimb.wholeness(atFraction: Double(boundary) + 0.5), 0, accuracy: 1e-9,
                           "halfway between two stations a band's light is still showing")
        }
        // And it is continuous everywhere in between, so nothing is ever seen
        // to change at the moment the map does.
        var last = WorldClimb.wholeness(atFraction: 0)
        for step in 1...4000 {
            let now = WorldClimb.wholeness(atFraction: Double(step) / 500)
            XCTAssertLessThan(abs(now - last), 0.01, "wholeness jumped at f=\(Double(step) / 500)")
            last = now
        }
    }

    /// **The stone's own light obeys the binding condition on the axis too.**
    ///
    /// A band's glow goes through ``RoomMaterial/emission(at:)``, which
    /// multiplies it by how far the material actually moved — so stone that
    /// nothing happened to emits nothing, at any brightness. The Forehead is
    /// the band that proves it: nine swells that glow, and untouched stone
    /// between them that does not.
    func testTheStonesLightCannotExistWithoutItsRelief() {
        guard let forehead = WorldBands.stones[6] else { return XCTFail("no Forehead stone") }
        XCTAssertFalse(forehead.isUndisturbed)

        var lit = 0, dark = 0, litWithNoRelief = 0
        for i in 0...40 {
            for j in 0...40 {
                let point = SurfaceCoordinate(u: Double(i) / 40, v: Double(j) / 40)
                let emission = forehead.emission(at: point)
                let moved = abs(forehead.relief(at: point) - forehead.grain(at: point))
                if emission > 0.01 {
                    lit += 1
                    if moved < 1e-9 { litWithNoRelief += 1 }
                } else {
                    dark += 1
                }
            }
        }
        XCTAssertGreaterThan(lit, 20, "the Forehead's bodies do not glow at all")
        XCTAssertGreaterThan(dark, 20, "the whole Forehead glows — there is no material between them")
        XCTAssertEqual(litWithNoRelief, 0,
                       """
                       \(litWithNoRelief) points of the Forehead emit light where nothing happened to \
                       the material. That is the binding condition broken on the axis.
                       """)

        // The four bands Design gives no light of their own have none.
        for ring in [1, 2, 3, 5] {
            guard let stone = WorldBands.stones[ring] else { return XCTFail("no ring \(ring) stone") }
            for i in 0...12 {
                for j in 0...12 {
                    let point = SurfaceCoordinate(u: Double(i) / 12, v: Double(j) / 12)
                    XCTAssertEqual(stone.emission(at: point), 0, accuracy: 1e-12,
                                   "ring \(ring)'s stone is emitting, and Design gives it no light of its own")
                }
            }
        }

        // Every band's stone is on the one surface no attribute ever acts on.
        for ring in HomeWorlds.rings {
            XCTAssertEqual(WorldBands.stones[ring]?.surface, .wall,
                           "ring \(ring)'s band is not on a wall — it could be mistaken for a Śakti's mark")
        }
    }

    // MARK: - Rising

    /// **The rise is a closed form, so a dropped frame cannot change where the
    /// walker ends up.**
    func testTheRiseIsAClosedFormAndTheStationsAreDesignsOwn() {
        let seconds = 1 / RoomApproach.riseBandsPerSecond
        let rise = WorldClimbTravel.rising(from: 0, to: 1, at: 0)
        XCTAssertEqual(rise.value(at: 0), 0, accuracy: 1e-12)
        XCTAssertEqual(rise.value(at: seconds / 2), 0.5, accuracy: 1e-9,
                       "a steady rise is steady")
        XCTAssertEqual(rise.value(at: seconds), 1, accuracy: 1e-12)
        XCTAssertEqual(rise.value(at: seconds * 4), 1, accuracy: 1e-12, "and it stops where it arrives")

        // The settle closes and never overshoots.
        let settle = WorldClimbTravel.settling(from: 2, to: 5, at: 0)
        var last = settle.value(at: 0)
        XCTAssertEqual(last, 2, accuracy: 1e-9)
        for step in 1...200 {
            let now = settle.value(at: Double(step) / 20)
            XCTAssertGreaterThanOrEqual(now, last - 1e-12, "the settle went backwards")
            XCTAssertLessThanOrEqual(now, 5 + 1e-12, "the settle overshot its target")
            last = now
        }
        XCTAssertEqual(last, 5, accuracy: 0.01)

        // The climb has ends, and clamping is what keeps the blend's weights
        // summing to one at both of them.
        XCTAssertEqual(WorldClimbTravel.standing(atFraction: -4).value(at: 0), 0, accuracy: 0)
        XCTAssertEqual(WorldClimbTravel.standing(atFraction: 99).value(at: 0), 8, accuracy: 0)
        XCTAssertEqual(WorldClimbTravel.rising(from: 0, to: 40, at: 0).value(at: 1e6), 8, accuracy: 0)
    }

    /// **Under reduced motion he steps to a station and stands there — and
    /// every band is still passed through.**
    ///
    /// Design's invariant 4 asks for quantized rather than disabled, and
    /// FIDELITY forbids the loop a glide would need. What is dropped is the
    /// frame loop between the stations, never a world.
    func testTheReducedPathIsQuantizedAndSkipsNoBand() {
        var here = 0.0
        var visited: Set<Int> = [1]
        for _ in 1...8 {
            let step = WorldClimbTravel.stepping(from: here, by: 1)
            let next = step.value(at: 0)
            XCTAssertEqual(next, here + 1, accuracy: 1e-12,
                           "a step under reduced motion crossed more than one band")
            XCTAssertEqual(next, next.rounded(), accuracy: 1e-12, "a step did not land on a station")
            here = next
            visited.insert(WorldClimb.nearestRing(atFraction: here))
        }
        XCTAssertEqual(visited, Set(HomeWorlds.rings),
                       "stepping the whole climb did not pass through every āvaraṇa")
        XCTAssertEqual(here, 8, accuracy: 1e-12)

        // It is genuinely still: a station reached under reduced motion does not
        // move afterwards, at any instant, ever.
        let standing = WorldClimbTravel.stepping(from: 3, by: 1)
        for t in stride(from: 0.0, through: 600.0, by: 17.0) {
            XCTAssertEqual(standing.value(at: t), 4, accuracy: 0,
                           "the reduced path is a slowed-down loop rather than a standing still")
        }
    }
}
