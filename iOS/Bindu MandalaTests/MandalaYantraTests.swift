import XCTest
import SwiftUI
@testable import Bindu_Mandala

// MARK: - MandalaYantraTests — Wave 1 · Slice A, the look held to Design's numbers
//
// Build Charter II §5: *"Every visual wave adds a look check against Design's
// own frames and numbers."* These are the Mandala's: the yantra's proportions
// and true weights as `living-rite-mandala.jsx` draws them, the nine breaths
// as `Mandala App v2.html` keys them, the five hours as `home-mandala.jsx`
// tabulates them — and the Veil's light, held to the surviving law that it is
// read from where he stands and never from what he has done.

final class MandalaYantraTests: XCTestCase {

    private let R = MandalaWorld.radius

    // MARK: - The full yantra

    /// Every element Design draws is drawn: three squares, the gates, the four
    /// circles and the one that holds the star, both lotuses, nine triangles.
    func testTheWholeYantraIsDrawn() {
        let layers = SriYantraGeometry.layers
        func count(_ k: SriYantraGeometry.Kind) -> Int { layers.filter { $0.kind == k }.count }
        XCTAssertEqual(count(.bhupura), 3, "the Bhūpura is three nested squares")
        XCTAssertEqual(count(.gate), 1, "the four T-gates are one stroked path")
        XCTAssertEqual(count(.circle), 5, "four circles between the lotuses, and the one that holds the star")
        XCTAssertEqual(count(.lotus16), 1, "the sixteen-petal lotus is gone again")
        XCTAssertEqual(count(.lotus8), 1, "the eight-petal lotus is gone again")
        XCTAssertEqual(count(.triangle), 9, "the star has nine triangles")
        XCTAssertEqual(MandalaYantra.down.count, 5, "five Śakti triangles")
        XCTAssertEqual(MandalaYantra.up.count, 4, "four Śiva triangles")
    }

    /// **The triangles at 0.585, not stretched to the Bhūpura.** Every vertex
    /// of the star sits inside the 0.60 R circle that holds it — which is only
    /// true at Design's proportion; at the first port's full radius the star
    /// reached 0.99 R and sat over both lotuses.
    func testTheStarSitsAtItsTrueProportion() {
        XCTAssertEqual(SriYantraGeometry.triangleProportion, 0.585, accuracy: 1e-9)
        var furthest: CGFloat = 0
        for tri in MandalaYantra.triangles {
            for v in [tri.0, tri.1, tri.2] {
                let d = hypot(v.x, v.y)
                furthest = max(furthest, d)
                XCTAssertLessThan(d, R * 0.60 + 0.5,
                                  "a triangle reaches past the circle that holds the star — stretched again")
            }
        }
        XCTAssertGreaterThan(furthest, R * 0.55, "the star has collapsed inward")
        // The outermost down triangle's apex is Design's 1.00 × 0.585 R.
        XCTAssertEqual(MandalaYantra.triangles[0].2.y, R * 0.585, accuracy: 0.01)
        // And it is inside the eight petals, which begin at 0.615 R.
        XCTAssertLessThan(furthest, R * 0.615)
    }

    /// The lotuses stand where Design puts them: sixteen petals between 0.80 R
    /// and 0.90 R, eight between 0.615 R and 0.70 R.
    func testTheLotusesStandBetweenTheirCircles() {
        let outer16 = SriYantraGeometry.lotus16.boundingRect
        XCTAssertEqual(outer16.maxY, R * 0.90, accuracy: 1.0)
        XCTAssertEqual(outer16.minY, -R * 0.90, accuracy: 1.0)
        let outer8 = SriYantraGeometry.lotus8.boundingRect
        XCTAssertLessThanOrEqual(outer8.maxX, R * 0.70 + 1.0)
        XCTAssertGreaterThan(outer8.maxX, R * 0.60, "the eight petals have shrunk inside the star")

        // One petal, from base to tip on its own axis.
        let petal = SriYantraGeometry.petal(innerR: 100, outerR: 200, halfWidthDeg: 10, angleDeg: 0)
        let box = petal.boundingRect
        XCTAssertEqual(box.minY, -200, accuracy: 0.5, "the petal's tip is its outer radius, straight up")
        XCTAssertEqual(box.maxY, -100, accuracy: 0.5, "the petal's base is its inner radius")
        XCTAssertEqual(box.midX, 0, accuracy: 0.5, "the petal is symmetric about its axis")
    }

    /// **True weights, no stacked dimmer.** The opacities and widths are
    /// Design's own numbers, unmodified — the loss The Reading names was a
    /// multiplier dropped and two dimmers stacked; here there is neither.
    func testTheGeometryIsDrawnAtDesignsTrueWeights() {
        let layers = SriYantraGeometry.layers
        let squares = layers.filter { $0.kind == .bhupura }.map(\.alpha)
        XCTAssertEqual(squares, [0.5, 0.4, 0.3])
        XCTAssertTrue(layers.filter { $0.kind == .bhupura }.allSatisfy { $0.width == 1.1 })
        let gate = layers.first(where: { $0.kind == .gate })
        let lotus16 = layers.first(where: { $0.kind == .lotus16 })
        let lotus8 = layers.first(where: { $0.kind == .lotus8 })
        XCTAssertEqual(gate?.alpha ?? 0, 0.45, accuracy: 1e-9)
        XCTAssertEqual(lotus16?.alpha ?? 0, 0.34, accuracy: 1e-9)
        XCTAssertEqual(lotus8?.alpha ?? 0, 0.36, accuracy: 1e-9)
        for tri in layers where tri.kind == .triangle {
            XCTAssertEqual(tri.alpha, 0.5, accuracy: 1e-9, "a triangle is under Design's 0.5")
            XCTAssertEqual(tri.width, 1, accuracy: 1e-9)
        }
        // At noon the hour is a factor of exactly one: noon *is* Design's
        // living Mandala, so nothing at noon dims it.
        let noon = TimeVariant.noon
        XCTAssertEqual(noon.geometryGain, 1, accuracy: 1e-9)
        XCTAssertEqual(noon.bhupuraGain, 1, accuracy: 1e-9)
        XCTAssertEqual(noon.lotusGain, 1, accuracy: 1e-9)
        XCTAssertEqual(noon.innerLotusGain, 1, accuracy: 1e-9)
    }

    /// Each triangle keeps the breath of its āvaraṇa — four interlocked pairs
    /// for rings 4–7, and the innermost downward triangle alone as ring 8.
    func testEachTriangleKeepsItsRingsBreath() {
        let rings = (0..<MandalaYantra.triangles.count).map(MandalaYantra.ring(ofTriangle:))
        XCTAssertEqual(rings, [4, 5, 6, 7, 8, 4, 5, 6, 7])
        // The mūla trikoṇa is the one that holds the Bindu.
        let mula = MandalaYantra.triangles[4]
        XCTAssertLessThan(mula.0.y, 0)
        XCTAssertGreaterThan(mula.2.y, 0, "ring 8's triangle must enclose the point")
    }

    // MARK: - Nine metabolisms

    /// `Mandala App v2.html`'s table, ring for ring.
    func testTheNineBreathRatesAreDesigns() {
        XCTAssertNil(MandalaBreath.period(ring: 1), "the ground does not breathe — it holds")
        let expected: [Int: TimeInterval] = [2: 3, 3: 8, 4: 9, 5: 11, 6: 13, 7: 15, 8: 18, 9: 4]
        for (ring, seconds) in expected {
            XCTAssertEqual(MandalaBreath.period(ring: ring), seconds, "ring \(ring)'s breath")
        }
        XCTAssertNil(MandalaBreath.period(ring: 0))
        XCTAssertNil(MandalaBreath.period(ring: 10), "no tenth metabolism is invented")
        // Slower inward through the triangles, the Bindu quickening at the centre.
        for ring in 3..<8 {
            XCTAssertLessThan(MandalaBreath.period(ring: ring)!, MandalaBreath.period(ring: ring + 1)!)
        }
    }

    func testABreathIsARaisedCosineThatReturns() {
        for ring in 2...9 {
            let p = MandalaBreath.period(ring: ring)!
            XCTAssertEqual(MandalaBreath.phase(ring: ring, at: 0), 0, accuracy: 1e-9)
            XCTAssertEqual(MandalaBreath.phase(ring: ring, at: p / 2), 1, accuracy: 1e-9)
            XCTAssertEqual(MandalaBreath.phase(ring: ring, at: p), 0, accuracy: 1e-9)
            for t in stride(from: 0.0, through: 40.0, by: 0.37) {
                let v = MandalaBreath.phase(ring: ring, at: t)
                XCTAssertGreaterThanOrEqual(v, 0)
                XCTAssertLessThanOrEqual(v, 1)
            }
        }
        XCTAssertEqual(MandalaBreath.phase(ring: 1, at: 3.3), 0, "the Bhūpura never moves")
    }

    /// Reduce motion pauses the breath **with its light kept** — held at the
    /// middle of the breath, never at rest, and the same at every moment.
    func testReduceMotionPausesTheBreathAndKeepsTheLight() {
        for t in [0.0, 1.3, 7.7, 1000.1] {
            for ring in 2...9 {
                XCTAssertEqual(MandalaBreath.phase(ring: ring, at: t, reduceMotion: true), 0.5)
            }
            XCTAssertEqual(MandalaBreath.shimmer(at: t, reduceMotion: true), 1,
                           "the shimmer pauses at its brightest")
            XCTAssertEqual(MandalaBreath.binduScale(at: t, reduceMotion: true), 1)
            XCTAssertEqual(MandalaBreath.seatScale(ring: 4, kp: 50, at: t, reduceMotion: true), 1)
        }
    }

    /// `syShimmer`: 0.82 ↔ 1 on 8 s. `syBinduBreath`: ×1.28 on the ninth's 4 s.
    func testTheShimmerAndTheBinduSwell() {
        XCTAssertEqual(MandalaBreath.shimmerPeriod, 8)
        XCTAssertEqual(MandalaBreath.shimmer(at: 0), 0.82, accuracy: 1e-9)
        XCTAssertEqual(MandalaBreath.shimmer(at: 4), 1, accuracy: 1e-9)
        for t in stride(from: 0.0, through: 30.0, by: 0.25) {
            let s = MandalaBreath.shimmer(at: t)
            XCTAssertGreaterThanOrEqual(s, 0.82 - 1e-9)
            XCTAssertLessThanOrEqual(s, 1 + 1e-9)
        }
        XCTAssertEqual(MandalaBreath.binduSwell, 1.28)
        XCTAssertEqual(MandalaBreath.binduScale(at: 2), 1.28, accuracy: 1e-9, "full at half of the 4 s breath")
        XCTAssertEqual(MandalaBreath.binduScale(at: 0), 1, accuracy: 1e-9)
    }

    /// A seat breathes at her enclosure's rate — her position sets only where
    /// in the breath she is, never how fast or how far.
    func testASeatBreathesAtHerRingsRate() {
        XCTAssertEqual(MandalaBreath.seatScale(ring: 1, kp: 3, at: 12.3), 1, "the ground holds")
        for kp in [17, 25, 30] {
            var top = 0.0
            for t in stride(from: 0.0, through: 6.0, by: 0.01) {
                top = max(top, MandalaBreath.seatScale(ring: 2, kp: kp, at: t))
            }
            XCTAssertEqual(top, 1 + MandalaBreath.seatSwell, accuracy: 1e-3,
                           "every seat swells by the same ×1.22, whoever she is")
        }
        XCTAssertEqual(MandalaBreath.seatScale(ring: 5, kp: 40, at: 2),
                       MandalaBreath.seatScale(ring: 5, kp: 40, at: 2 + 11), accuracy: 1e-9,
                       "a ring-5 seat breathes every 11 s")
    }

    // MARK: - The five hours

    func testTheNewMoonDesaturatesAndTheBinduRises() {
        let nm = TimeVariant.newmoon
        XCTAssertEqual(nm.seatSaturation, 0.30, accuracy: 1e-9, "Design: petals desaturate to 30%")
        XCTAssertEqual(nm.binduScale, 1.60, accuracy: 1e-9, "Design: the Bindu at 1.6×")
        for v in TimeVariant.allCases where v != .newmoon {
            XCTAssertGreaterThan(nm.binduGlow, v.binduGlow, "the Bindu rises most at the new moon")
            XCTAssertLessThan(nm.geometryGain, v.geometryGain, "the geometry recedes most at the new moon")
        }
        let red = HSL(h: 2, s: 68, l: 50)
        let tempered = nm.temper(red)
        XCTAssertEqual(tempered.h, red.h, "the hour never moves her hue — position stays identity")
        XCTAssertLessThan(tempered.s, red.s * 0.31)
        XCTAssertEqual(TimeVariant.noon.temper(red), red, "noon leaves her exactly as she is")
    }

    /// The hour arrives as **one** factor per line, never a dimmer stacked on
    /// another. Every gain is positive and none at dawn or noon is under one.
    func testTheHourIsOneFactorAndNeverStacks() {
        for v in TimeVariant.allCases {
            for g in [v.geometryGain, v.bhupuraGain, v.lotusGain, v.innerLotusGain] {
                XCTAssertGreaterThan(g, 0, "\(v) put a line out")
                XCTAssertLessThanOrEqual(g, 1.25, "\(v) over-lit a line")
            }
            XCTAssertGreaterThanOrEqual(v.seatBrightness, 0.75,
                                        "\(v) dimmed the seats past a quarter of Design's filter")
        }
        XCTAssertGreaterThanOrEqual(TimeVariant.dawn.bhupuraGain, 1)
    }

    // MARK: - The camera falls to a ring

    func testTheVeilsCameraStandsInsideTheRingItWasAskedFor() {
        for size in [CGSize(width: 320, height: 568), CGSize(width: 390, height: 844),
                     CGSize(width: 430, height: 932)] {
            for ring in 1...8 {
                let cam = MandalaCamera.ringTarget(ring: ring, in: size)
                XCTAssertEqual(cam.enteredRing(in: size), ring,
                               "on \(size) the Veil's fall to ring \(ring) lands somewhere else")
                let c = cam.binduScreen()
                XCTAssertEqual(c.x, size.width / 2, accuracy: 0.5, "the fall stays centred on the Bindu")
            }
        }
    }

    // MARK: - The Veil · status as light, read from where he stands

    func testExactlyOneRingIsHereWhereverHeStands() {
        for here in 1...9 {
            let lights = (1...9).map { MandalaVeil.light(ring: $0, here: here) }
            XCTAssertEqual(lights.filter { $0 == .here }.count, 1)
            XCTAssertEqual(MandalaVeil.light(ring: here, here: here), .here)
            for ring in 1..<here { XCTAssertEqual(MandalaVeil.light(ring: ring, here: here), .ground) }
            if here < 9 { XCTAssertEqual(MandalaVeil.light(ring: here + 1, here: here), .open) }
        }
        // Standing on the home lotus, Design's own picture: ground · here · open
        // · ahead ×4 · veiled.
        XCTAssertEqual((1...8).map { MandalaVeil.light(ring: $0, here: 2) },
                       [.ground, .here, .open, .ahead, .ahead, .ahead, .ahead, .veiled])
        // Outside the yantra he stands in today's ring; inside, in the camera's.
        XCTAssertEqual(MandalaVeil.here(entered: 0, todayRing: 3), 3)
        XCTAssertEqual(MandalaVeil.here(entered: 5, todayRing: 3), 5)
        XCTAssertEqual(MandalaVeil.here(entered: 0, todayRing: 0), 1)
    }

    /// Light, never a lock — and a word is still a word. However veiled a ring
    /// is, its name and line stay above FIDELITY's 0.5 floor; the veil is
    /// carried by the glyph, which may go as faint as Design drew it.
    func testTheVeilDimsGlyphsNeverWords() {
        for light in VeilLight.allCases {
            XCTAssertGreaterThanOrEqual(light.nameAlpha, 0.5, "\(light)'s name is under the floor")
            XCTAssertGreaterThanOrEqual(light.subAlpha, 0.5, "\(light)'s line is under the floor")
            XCTAssertGreaterThan(light.glyph, 0, "\(light) put a ring out entirely")
        }
        let order: [VeilLight] = [.here, .open, .ground, .ahead, .veiled]
        for (a, b) in zip(order, order.dropFirst()) {
            XCTAssertGreaterThan(a.glyph, b.glyph, "the luminosities must fall in Design's order")
        }
    }

    /// **U0 rewrite (verification.md §2.2, VER-L-0796).** "A veil that cannot
    /// learn" is lifted: the Veil may know where he has been — what he felt,
    /// how deep he has gone, which rings he crossed. The narrow floor is what
    /// stays: **never a completion meter** — no count of his practice reaches
    /// the Veil or the breath, and nothing it says is a fraction or a
    /// percentage of the rings.
    func testTheVeilIsNeverACompletionMeter() {
        guard let veil = LawSource.production("MandalaVeil.swift"),
              let breath = LawSource.production("MandalaBreath.swift") else {
            return XCTFail("the Veil or the breath is not in the shipping corpus")
        }
        for file in [veil, breath] {
            let code = String(file.lexed.masked)
            for forbidden in ["recognitionCount", "serverRecognitionCount", "countByKp", "feltCount",
                              "visitCount", "visits", "streak", "percent", "Percent"] {
                XCTAssertFalse(code.contains(forbidden),
                               "\(file.name) reaches \(forbidden) — the Veil may know where he has "
                               + "been, never how much")
            }
        }
        for ring in 1...9 {
            for here in 1...9 {
                let spoken = MandalaVeil.spokenRow(ring: ring, here: here)
                XCTAssertNil(Rx.first(#"(?i)\b\d+\s*(?:of|/)\s*\d+\b|%|\bof (?:the )?nine\b"#, spoken),
                             "the Veil speaks a fraction of the rings: \(spoken)")
                XCTAssertTrue(NeverMeasure.measuresOutLoud(spoken).isEmpty, spoken)
                XCTAssertFalse(spoken.lowercased().contains("enclosure"),
                               "the Veil's rows must not be mistaken for the field's spoken seats")
            }
        }
    }

    // MARK: - The felt state as warm light

    func testTheFeltHaloIsWarmerAndStillHers() {
        for ring in 1...9 {
            let own = Atmosphere.ringHue(ring)
            let warm = MandalaLight.feltWarmth(own)
            let toSource = Self.arc(own.h, MandalaLight.source.h)
            let moved = Self.arc(own.h, warm.h)
            XCTAssertLessThanOrEqual(moved, toSource * MandalaLight.feltWarmthPull + 1e-9,
                                     "ring \(ring): the halo leaned further than its pull")
            XCTAssertLessThan(moved, toSource / 2 + 1e-9, "ring \(ring): the halo is more source than her")
            XCTAssertGreaterThanOrEqual(warm.l, own.l, "a felt halo is light, not shade")
            XCTAssertEqual(MandalaLight.feltWarmth(own), warm, "the halo is a state: the same every time")
        }
    }

    private static func arc(_ a: Double, _ b: Double) -> Double {
        var d = abs(HSL.wrap(b - a))
        if d > 180 { d = 360 - d }
        return d
    }
}
