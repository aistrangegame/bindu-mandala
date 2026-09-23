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
        XCTAssertEqual(field.felt.count, 26, "the bench's felt distribution is kp % 4 == 1")
        XCTAssertTrue(field.felt.contains(field.todayKp), "today's seat is felt in this fixture")
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
        XCTAssertEqual(t.enclosures, 21,
                       "rings 2…8 at the fitted scale, three strokes each: under the light an "
                       + "enclosure is a gem-light band and not a hairline")
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
            focusKp: kp, familyKp: family, felt: field.felt,
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
                focusKp: kp, familyKp: family, felt: field.felt,
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
                        felt: field.felt,
                        // Explicit, never the default: a baseline is a fact about one
                        // configuration, and one that reads a launch argument would
                        // measure a different app on a different invocation.
                        lightOn: true,
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

    /// **The baseline describes the app that ships.**
    ///
    /// The bounds above are the *lit* canvas's. They were re-taken lit when the
    /// phase flag came off, and they mean nothing if the app then ships unlit —
    /// so the two facts are tied together here rather than left to whoever next
    /// reads the doc comment. This is the check that would have gone red for the
    /// whole of Phase 5, when `lightOn` defaulted to `false` and both the census
    /// and the on-device bench measured a canvas the walker was never going to
    /// see.
    func testTheBaselineMeasuresTheCanvasTheAppActuallyDraws() {
        XCTAssertTrue(MandalaLight.enabled,
                      "the G5 census bounds in this file are the lit canvas's, and the app now "
                      + "builds unlit — re-take the baseline or put the light back")
    }

    /// **What the light costs, per frame, in primitives.**
    ///
    /// Kept as a check rather than as a sentence in a commit message, because
    /// the whole reason the baseline drifted is that the cost of the lit path
    /// was never once measured. Three strokes per visible enclosure instead of
    /// one, and the gaze's two marks at the Bindu; every seat branch is
    /// untouched, which is why the wide tier moves and the deep zoom barely
    /// does.
    ///
    /// The bound is deliberately loose at the top and tight in kind: what would
    /// be a finding is the light turning out to cost a *multiple* rather than a
    /// margin, because the census counts primitives and not pixels and a
    /// multiple is the only thing it could see of a fill-rate problem.
    func testTheLightsCostIsAMarginAndNotAMultiple() {
        for scene in [SpikeScene.tier0AllSeats, .tier2Bloom, .descent] {
            let clock = SpikeMetrics.Clock(offset: 0, epoch: 0)
            let script = SpikeScript(scene: scene, field: field, clock: clock)
            var unlit = SpikeMetrics.CensusAccumulator()
            var lit = SpikeMetrics.CensusAccumulator()
            for frame in 0..<Self.baselineFrames {
                let sceneTime = Double(frame) / Self.baselineHz
                let t = clock.referenceTime(forScene: sceneTime)
                let st = script.state(atScene: sceneTime, in: size)
                func tally(_ on: Bool) -> MandalaDrawCensus.Tally {
                    MandalaDrawCensus.tally(MandalaDrawCensus.Input(
                        camera: st.camera, size: size, seats: field.censusSeats,
                        todayKp: field.todayKp, focusKp: st.focusKp, familyKp: st.familyKp,
                        felt: field.felt, lightOn: on,
                        flashRing: st.flash?.ring, flashBornAt: st.flash?.bornAt,
                        constellation: st.constellation, constellationStart: st.constellationStart,
                        reduceMotion: false, t: t))
                }
                unlit.add(tally(false))
                lit.add(tally(true))
            }
            let ratio = lit.mean / unlit.mean
            print(String(format:
                "SPIKE_LIGHT_COST {\"scene\":\"%@\",\"unlitMean\":%.1f,\"litMean\":%.1f,"
                + "\"delta\":%.1f,\"ratio\":%.3f,\"unlitWorst\":%d,\"litWorst\":%d}",
                scene.rawValue, unlit.mean, lit.mean, lit.mean - unlit.mean, ratio,
                unlit.worst, lit.worst))
            XCTAssertGreaterThanOrEqual(lit.mean, unlit.mean,
                "\(scene.rawValue): the lit canvas draws less than the unlit one — "
                + "the light is not being built")
            XCTAssertLessThan(ratio, 1.25,
                "\(scene.rawValue): the light costs \(Int((ratio - 1) * 100))% more primitives "
                + "per frame, which is a redesign and not a margin")
        }
    }

    private static let baselineHz = 60.0
    private static let baselineFrames = 1200   // 20 seconds

    /// **Re-taken 2026-09-23, lit**, when Phase 5's flag came off. The figures are
    /// device-independent by construction — nothing here touches a GPU or a clock —
    /// so any simulator must reproduce them exactly; the Pro Max confirmation run
    /// was cut short by an overloaded host and is worth re-running once, to prove
    /// that claim rather than assume it.
    ///
    /// | scene | mean | worst | previously (unlit) |
    /// |---|---|---|---|
    /// | tier 0, all 102 seats | 277.1 | 284 | 263.1 / 270 |
    /// | tier 2, deep-zoom bloom | 93.6 | 99 | 79.6 / 85 |
    /// | the descent | 89.8 | 284 | 75.7 / 270 |
    ///
    /// **Why it moved, and why that is not a baseline going soft.** The unlit table
    /// was captured 2026-09-21 against `MandalaCanvasLayer` at 58256d2, and it
    /// described the canvas the app drew then. The app now draws the lit canvas, so
    /// a baseline still pinned to the unlit figures would have been asserting a
    /// path the walker never sees — which is exactly the state this file was in for
    /// the whole of Phase 5, when `MandalaDrawCensus.Input.lightOn` defaulted to
    /// `false` and the bench measured a canvas that had already been superseded.
    ///
    /// **Every bound below moved by the same +14, and by nothing else.** That is
    /// the measured cost of the light and it is a constant: seven visible
    /// enclosures drawn as three-stroke gem-light bands instead of one hairline is
    /// fourteen extra strokes, in every scene, in every frame. No bound was
    /// widened to accommodate anything — the windows are exactly as tight as they
    /// were, translated. `testTheLightsCostIsAMarginAndNotAMultiple` measures that
    /// same delta from both sides each run, so if the light ever starts costing a
    /// proportion rather than a constant, it is a red and not a re-record.
    ///
    /// Ranges, not exact equalities: the per-seat flare phase reads absolute time, so
    /// one frame either side of a flare boundary moves a count by one or two and is
    /// not a regression. They are tight enough that a draw layer added to or removed
    /// from the canvas breaks them, which is what they are for.
    private static let baselineBounds: [SpikeScene: (meanLow: Double, meanHigh: Double, worstHigh: Int)] = [
        .tier0AllSeats: (meanLow: 269, meanHigh: 286, worstHigh: 294),   // was 255 / 272 / 280
        .tier2Bloom:    (meanLow: 89,  meanHigh: 99,  worstHigh: 106),   // was  75 /  85 /  92
        .descent:       (meanLow: 85,  meanHigh: 95,  worstHigh: 294),   // was  71 /  81 / 280
    ]

    // MARK: helper

    private func input(camera: MandalaCamera,
                       reduceMotion: Bool,
                       t: TimeInterval = 1_000_000) -> MandalaDrawCensus.Input {
        MandalaDrawCensus.Input(
            camera: camera, size: size, seats: field.censusSeats, todayKp: field.todayKp,
            focusKp: nil, familyKp: [], felt: field.felt,
            lightOn: true,
            flashRing: nil, flashBornAt: nil,
            constellation: 0, constellationStart: nil,
            reduceMotion: reduceMotion, t: t)
    }
}
#endif
