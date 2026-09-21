// Measures the Debug build's spike apparatus, which is compiled out of Release.
// The scheme's test action builds Debug, so these always run; a Release-configured
// test run simply has no spike suite rather than failing to compile.
#if DEBUG
import XCTest
import SwiftUI
@testable import Bindu_Mandala

/// The bench's own foundations, asserted off-device: the synthetic field has the
/// shape the real one has, the scripted camera track goes where it says it goes,
/// and the draw census counts what the shipped canvas would actually issue.
///
/// These matter because the census is a *model* of `MandalaCanvasLayer`'s draw
/// code, not an interception of it. If someone edits the canvas and the model
/// drifts, a comparison built on it silently lies. These tests are the tripwire.
final class SpikeCensusTests: XCTestCase {

    private let size = CGSize(width: 393, height: 852)
    private lazy var field = SpikeField()

    // MARK: The field

    func testFieldSeatsAllOneHundredTwoInTheRightRings() {
        XCTAssertEqual(field.shaktis.count, 102)
        XCTAssertEqual(field.seats.count, 102)
        XCTAssertEqual(field.censusSeats.count, 102)
        XCTAssertEqual(Set(field.censusSeats.map(\.kp)).count, 102,
                       "the census snapshot is one plain value per seat, keyed by position")
        for s in field.shaktis {
            let kp = s.khadgamalaPosition ?? 0
            XCTAssertEqual(s.ringNumber, KhadgamalaMap.ringNumber(forKhadgamala: kp),
                           "kp \(kp) must sit in its canonical ring")
        }
        // Ring spans, straight off the canonical map.
        let byRing = Dictionary(grouping: field.shaktis) { $0.ringNumber ?? 0 }
        XCTAssertEqual(byRing[1]?.count, 28)
        XCTAssertEqual(byRing[2]?.count, 16)
        XCTAssertEqual(byRing[9]?.count, 1)
    }

    func testFieldHonoursTheEightySixDataShape() {
        // Only Ring 2 (and the Bindu) carry a bīja; the rest of the 86 carry none,
        // and none of them leaks the `.inner` cluster default into their hue.
        for s in field.shaktis {
            let ring = s.ringNumber ?? 2
            if ring == 2 || ring == 9 {
                XCTAssertNotNil(s.bijaSyllable, "ring \(ring) should name a seed")
            } else {
                XCTAssertNil(s.bijaSyllable, "the 86 mostly carry no bīja")
            }
        }
        // The documented felt distribution — one seat in four.
        let felt = field.countByKp.values.filter { $0 > 0 }.count
        XCTAssertEqual(felt, 26, "the bench's felt distribution is kp % 4 == 1")
        XCTAssertGreaterThan(field.countByKp[field.todayKp] ?? 0, 0, "today's seat is felt in this fixture")
    }

    /// The census now branches on a plain-value snapshot rather than on the
    /// `Shakti` models, so the snapshot is load-bearing: if it drifts from the seats
    /// it was taken from, every primitive count built on it is quietly wrong.
    func testCensusSnapshotMirrorsTheSeatsItWasTakenFrom() {
        XCTAssertEqual(field.censusSeats.count, field.seats.count)
        for (snap, seat) in zip(field.censusSeats, field.seats) {
            XCTAssertEqual(snap.kp, seat.shakti.khadgamalaPosition ?? seat.shakti.position)
            XCTAssertEqual(snap.point, seat.point)
            XCTAssertEqual(snap.ring, seat.shakti.ringNumber ?? 2)
            XCTAssertEqual(snap.hasBija, seat.shakti.bijaSyllable != nil,
                           "kp \(snap.kp): the snapshot must agree with the model about her seed")
        }
    }

    // MARK: The scripted track

    func testScriptedDescentTravelsFromFittedToTheBindu() {
        let script = SpikeScript(scene: .descent, field: field, clock: .init())
        let start = script.state(atScene: 0, in: size).camera
        let end = script.state(atScene: SpikeScript.descentFall, in: size).camera
        XCTAssertEqual(start.scale, MandalaCamera.fitted(in: size).scale, accuracy: 0.0001)
        XCTAssertEqual(end.scale, MandalaCamera.descentTarget(in: size).scale, accuracy: 0.0001)
        XCTAssertEqual(start.tier, 0, "the fall begins at the cosmic tier")
        XCTAssertEqual(end.tier, 2, "and lands inside significance")
    }

    func testEaseInIsMonotonicAndPinnedAtBothEnds() {
        XCTAssertEqual(SpikeScript.easeIn(0), 0, accuracy: 0.0005)
        XCTAssertEqual(SpikeScript.easeIn(1), 1, accuracy: 0.0005)
        var last: CGFloat = -1
        for i in 0...40 {
            let v = SpikeScript.easeIn(Double(i) / 40)
            XCTAssertGreaterThanOrEqual(v, last)
            last = v
        }
        // easeIn starts slow: half way through the fall, less than half the distance.
        XCTAssertLessThan(SpikeScript.easeIn(0.5), 0.5)
    }

    func testClockIsDrivenNotWaitedOn() {
        let clock = SpikeMetrics.Clock(offset: 347)
        XCTAssertGreaterThanOrEqual(clock.sceneTime(), 347, "the room is past its second adaptation immediately")
        XCTAssertLessThan(clock.sceneTime(), 348, "and no wall time was spent getting there")
        // Reference-date round trip: scene time ↔ the basis the canvas reads.
        let ref = clock.referenceTime(forScene: 400)
        XCTAssertEqual(clock.sceneTime(now: ref), 400, accuracy: 0.0001)
    }

    // MARK: The census

    /// Tier 0, reduce-motion on, no focus: the census is fully determined, so every
    /// term can be named. If the shipped canvas changes its draw structure, this is
    /// the assertion that notices.
    func testTierZeroCensusIsFullyDetermined() {
        let cam = MandalaCamera.fitted(in: size)
        XCTAssertEqual(cam.tier, 0)
        let t = MandalaDrawCensus.tally(input(camera: cam, reduceMotion: true))

        XCTAssertEqual(t.yantra, 12, "three nested squares plus nine triangles, never culled")
        XCTAssertEqual(t.binduGlow, 1)
        XCTAssertEqual(t.enclosureNames, 0, "the āvaraṇa titles only resolve at tier 1")
        XCTAssertEqual(t.seatDots, 102, "the whole instrument fits, so every seat draws")
        XCTAssertEqual(t.seatNames, 0, "no names at the cosmic tier with nothing focused")
        XCTAssertEqual(t.seatBijas, 0)
        XCTAssertEqual(t.seatFlares, 0, "reduce-motion silences the periodic flare")
        XCTAssertEqual(t.seatGlows, 26, "one soft glow per felt seat")
        XCTAssertEqual(t.seatHalos, 1, "today alone wears the halo")
        XCTAssertEqual(t.constellation, 0, "no seat is focused")
        XCTAssertEqual(t.todayRing, 1)
        XCTAssertEqual(t.enclosures, 7, "rings 2…8 at the fitted scale")
        XCTAssertEqual(t.total, t.fills + t.strokes + t.texts, "the three families account for everything")
    }

    /// Motion on: the flare is the only term that moves, and it moves within a
    /// bounded band — every seat is in its 22% flare window about a fifth of the time.
    func testFlareIsTheOnlyMovingTermAndStaysInBand() {
        let cam = MandalaCamera.fitted(in: size)
        let still = MandalaDrawCensus.tally(input(camera: cam, reduceMotion: true))
        var minFlare = Int.max, maxFlare = 0
        for step in 0..<600 {
            let t = 1_000_000 + Double(step) * 0.05
            let moving = MandalaDrawCensus.tally(input(camera: cam, reduceMotion: false, t: t))
            XCTAssertEqual(moving.total - moving.seatFlares, still.total,
                           "nothing but the flare may vary with the clock at tier 0")
            minFlare = min(minFlare, moving.seatFlares)
            maxFlare = max(maxFlare, moving.seatFlares)
        }
        XCTAssertGreaterThan(maxFlare, 0, "seats do flare")
        XCTAssertLessThanOrEqual(maxFlare, 102)
        XCTAssertLessThan(maxFlare, 60, "the flare window is 22% of each seat's cycle, never the whole field")
    }

    /// The deep-zoom bloom: tier 2, one focused seat, her family threaded, the rest
    /// of the field dimmed out of its names.
    func testTierTwoBloomCensus() {
        let kp = SpikeField.bloomFocusKp
        guard let seat = field.seat(kp: kp) else { return XCTFail("bloom seat missing") }
        let cam = MandalaCamera.flyTarget(to: seat.point, in: size)
        XCTAssertEqual(cam.tier, 2, "the fly-to lands in significance")
        let family = field.family(ofKp: kp)
        XCTAssertEqual(family.count, 13, "the fourteen, less herself")

        let t = MandalaDrawCensus.tally(MandalaDrawCensus.Input(
            camera: cam, size: size, seats: field.censusSeats, todayKp: field.todayKp,
            focusKp: kp, familyKp: family, countByKp: field.countByKp,
            flashRing: nil, flashBornAt: nil,
            constellation: 1, constellationStart: nil,
            reduceMotion: true, t: 1_000_000))

        XCTAssertEqual(t.constellation, 13, "one thread per family seat")
        // Worth stating plainly: the shipped canvas gates the halo on `isToday ||
        // isFocus` and never on `dimmed`, so today's seat keeps its expanding ring
        // even while it is faded to 0.28 behind a focus. Two halos, not one.
        XCTAssertEqual(t.seatHalos, 2, "the focused seat and today's both keep a halo — dimming does not remove it")
        XCTAssertGreaterThan(t.seatNames, 0, "her family names resolve")
        XCTAssertLessThanOrEqual(t.seatNames, t.seatDots, "a dimmed seat draws its dot but not its name")
    }

    /// The bloom cascade: threads arrive on a stagger, so the thread count climbs
    /// from one to the whole family across the reveal rather than snapping.
    func testConstellationCascadeArrivesOverTime() {
        let kp = SpikeField.bloomFocusKp
        guard let seat = field.seat(kp: kp) else { return XCTFail("bloom seat missing") }
        let cam = MandalaCamera.flyTarget(to: seat.point, in: size)
        let family = field.family(ofKp: kp)
        let start: TimeInterval = 1_000_000

        func threads(at t: TimeInterval) -> Int {
            MandalaDrawCensus.tally(MandalaDrawCensus.Input(
                camera: cam, size: size, seats: field.censusSeats, todayKp: field.todayKp,
                focusKp: kp, familyKp: family, countByKp: field.countByKp,
                flashRing: nil, flashBornAt: nil,
                constellation: 1, constellationStart: start,
                reduceMotion: false, t: t)).constellation
        }
        XCTAssertEqual(threads(at: start), 0, "nothing is drawn before the cascade opens")
        XCTAssertLessThan(threads(at: start + 0.1), family.count, "the family lights up as a cascade")
        XCTAssertEqual(threads(at: start + 1.2), family.count, "and is whole by the end of it")
    }

    // MARK: The deterministic half of the G5 baseline

    /// The draw-primitive census over a scripted 20 seconds at 60 Hz, for every
    /// scene, at the room's opening and past a second adaptation.
    ///
    /// This is the part of the G5 baseline that is **not** a measurement. It is a
    /// pure function of the shipped canvas's branch structure, the field and the
    /// clock: no simulator, no GPU, no host load, no frame scheduling. So unlike the
    /// millisecond figures it can be reproduced exactly, on any machine, and a later
    /// renderer variant can be held to it rather than merely compared against it.
    ///
    /// It prints one `SPIKE_CENSUS` line per scene and window, and asserts the
    /// bounds those lines sat in when the baseline was taken (2026-09-21). If an
    /// edit to `MandalaCanvasLayer` changes how much it draws, this fails — which is
    /// the point.
    func testCensusBaselineForEveryScene() {
        for (window, offset) in [("A · t=0", 0.0), ("B · t=347s", 347.0)] {
            for scene in [SpikeScene.tier0AllSeats, .tier2Bloom, .descent] {
                // A pinned epoch: the flare term reads absolute time, so a wall-clock
                // epoch would make this drift between runs.
                let clock = SpikeMetrics.Clock(offset: offset, epoch: 0)
                let script = SpikeScript(scene: scene, field: field, clock: clock)
                var census = SpikeMetrics.CensusAccumulator()
                for frame in 0..<Self.baselineFrames {
                    let sceneTime = offset + Double(frame) / Self.baselineHz
                    let t = clock.referenceTime(forScene: sceneTime)
                    let st = script.state(atScene: sceneTime, in: size)
                    census.add(MandalaDrawCensus.tally(MandalaDrawCensus.Input(
                        camera: st.camera, size: size, seats: field.censusSeats,
                        todayKp: field.todayKp, focusKp: st.focusKp, familyKp: st.familyKp,
                        countByKp: field.countByKp,
                        flashRing: st.flash?.ring, flashBornAt: st.flash?.bornAt,
                        constellation: st.constellation, constellationStart: st.constellationStart,
                        reduceMotion: false, t: t)))
                }
                print(String(format:
                    "SPIKE_CENSUS {\"scene\":\"%@\",\"window\":\"%@\",\"frames\":%d,"
                    + "\"primitivesMean\":%.1f,\"primitivesWorst\":%d,\"worstBreakdown\":\"%@\"}",
                    scene.rawValue, window, Self.baselineFrames,
                    census.mean, census.worst, census.worstBreakdown))

                let bounds = Self.baselineBounds[scene]!
                XCTAssertGreaterThanOrEqual(census.mean, bounds.meanLow,
                    "\(scene.rawValue)/\(window): the canvas now draws less than the G5 baseline")
                XCTAssertLessThanOrEqual(census.mean, bounds.meanHigh,
                    "\(scene.rawValue)/\(window): the canvas now draws more than the G5 baseline")
                XCTAssertLessThanOrEqual(census.worst, bounds.worstHigh,
                    "\(scene.rawValue)/\(window): a worse frame than the G5 baseline ever saw")
            }
        }
    }

    private static let baselineHz = 60.0
    private static let baselineFrames = 1200   // 20 seconds

    /// Captured 2026-09-21 against `MandalaCanvasLayer` at 58256d2, on the iPhone 17
    /// simulator. The figures are device-independent by construction — nothing here
    /// touches a GPU or a clock — so any simulator must reproduce them exactly; the
    /// Pro Max confirmation run was cut short by an overloaded host and is worth
    /// re-running once, to prove that claim rather than assume it.
    ///
    /// | scene | mean | worst |
    /// |---|---|---|
    /// | tier 0, all 102 seats | 263.1 | 270 |
    /// | tier 2, deep-zoom bloom | 79.6 | 85 |
    /// | the descent | 75.7 | 270 |
    ///
    /// Ranges, not exact equalities: the per-seat flare phase reads absolute time, so
    /// one frame either side of a flare boundary moves a count by one or two and is
    /// not a regression. They are tight enough that a draw layer added to or removed
    /// from the canvas breaks them, which is what they are for.
    private static let baselineBounds: [SpikeScene: (meanLow: Double, meanHigh: Double, worstHigh: Int)] = [
        .tier0AllSeats: (meanLow: 255, meanHigh: 272, worstHigh: 280),
        .tier2Bloom:    (meanLow: 75,  meanHigh: 85,  worstHigh: 92),
        .descent:       (meanLow: 71,  meanHigh: 81,  worstHigh: 280),
    ]

    // MARK: helper

    private func input(camera: MandalaCamera,
                       reduceMotion: Bool,
                       t: TimeInterval = 1_000_000) -> MandalaDrawCensus.Input {
        MandalaDrawCensus.Input(
            camera: camera, size: size, seats: field.censusSeats, todayKp: field.todayKp,
            focusKp: nil, familyKp: [], countByKp: field.countByKp,
            flashRing: nil, flashBornAt: nil,
            constellation: 0, constellationStart: nil,
            reduceMotion: reduceMotion, t: t)
    }
}
#endif
