import XCTest
import SwiftUI
@testable import Bindu_Mandala

/// Wave 1 · Slice B — the day's light, held in numbers.
///
/// The Reading §2.3 measured the port's losses against Design's own frames:
/// sacred geometry 2–8× too faint (Rite ≈2.6×, Recognition ≈1.9×, Field chips
/// 2–4×, threshold ≈8×), `lrBackdrop` collapsed to one gradient, the nine-beat
/// arrival collapsed to one fade. These are the look checks for what came home:
/// each asserts Design's number, and where the old number is known, that the
/// light now stands at least as far above it as the Reading measured.
final class DayLightTests: XCTestCase {

    // MARK: - The ×1.7, and no stacked dimmer

    func testEveryStrokeCarriesDesignsLift() {
        XCTAssertEqual(RiteSigil.strokeLift, 1.7, accuracy: 1e-9,
                       "`LrSigil` draws every stroke at `o * 1.7`")
        XCTAssertEqual(RiteSigil.lifted(0.20), 0.34, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.lifted(0.34), 0.578, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.lifted(0.8), 1.0, accuracy: 1e-9, "a lifted stroke never passes full")
    }

    /// The Rite: Design's layer is `0.62 + 0.85 × 0.42` over strokes at ×1.7;
    /// the port's was 0.7 × a 0.9 inside the sigil over unlifted strokes.
    func testTheRitesGeometryStandsAtDesignsLight() {
        XCTAssertEqual(DayLight.riteSigilOpacity, 0.977, accuracy: 1e-9)
        let now = DayLight.riteSigilOpacity * RiteSigil.strokeLift
        let firstPort = 0.7 * 0.9
        XCTAssertGreaterThanOrEqual(now / firstPort, 2.6,
                                    "the Rite's sigil is still dimmer than the Reading measured Design to be")
    }

    /// Recognition and Her Presence wear the sigil at 0.55; the loss there was
    /// the sigil's own (×1.7 dropped, 0.9 added), so it is gone with it.
    func testPresenceAndRecognitionRegainTheirLight() {
        let gain = (DayLight.presenceSigilOpacity * RiteSigil.strokeLift) / (0.55 * 0.9)
        XCTAssertGreaterThanOrEqual(gain, 1.88)
    }

    func testTheFieldsChipsAndRoomsStandAtDesignsLight() {
        XCTAssertEqual(DayLight.fieldChipOpacity, 1.0, accuracy: 1e-9, "`opacity={2.4}` clamps to full")
        XCTAssertEqual(DayLight.fieldRoomOpacity, 0.5, accuracy: 1e-9)
        let closedGain = (DayLight.fieldChipOpacity * RiteSigil.strokeLift) / (0.5 * 0.9)
        let openGain = (DayLight.fieldChipOpacity * RiteSigil.strokeLift) / (0.9 * 0.9)
        XCTAssertGreaterThanOrEqual(closedGain, 3.7)
        XCTAssertGreaterThanOrEqual(openGain, 2.0)
        let roomGain = (DayLight.fieldRoomOpacity * RiteSigil.strokeLift) / (0.4 * 0.9)
        XCTAssertGreaterThanOrEqual(roomGain, 2.3)
    }

    /// The old threshold drew its ring in gold at 0.045, in 0.4–0.9 pt lines.
    /// Design's draws the ring's geometry at 0.7, every stroke lifted, in the
    /// ring's own colour. Opacity alone — before line weight and colour, which
    /// make up the rest of the Reading's ≈8× — is ≥ 5.5× on every ring.
    func testTheThresholdIsNoLongerAWhisper() {
        XCTAssertEqual(DayLight.thresholdSigilOpacity, 0.7, accuracy: 1e-9)
        for ring in 1...9 {
            let strokes = SigilGeometry.strokes(for: RiteGeometry.forRing(ring), size: 620)
            let brightest = strokes.map { RiteSigil.lifted($0.opacity) }.max() ?? 0
            XCTAssertGreaterThanOrEqual(DayLight.thresholdSigilOpacity * brightest / 0.045, 5.5,
                                        "ring \(ring)'s threshold geometry is still near the old whisper")
            let widest = strokes.map(\.width).max() ?? 0
            XCTAssertGreaterThanOrEqual(widest, 1, "ring \(ring) draws no full-weight line")
        }
    }

    // MARK: - `LrSigil`'s geometry, path for path

    func testEachRingDrawsDesignsStrokes() {
        let expected: [(RiteGeometry, Int, Int)] = [
            // geometry, strokes, of which gold
            (.square, 3 + 4, 4),           // three squares + four T-gates
            (.lotus16, 16 + 1, 1),         // petals + the gold circle
            (.lotus8, 8 + 1, 1),
            (.tri14, 14 + 2, 2),           // triangles + two gold circles
            (.tri10o, 10 + 2, 2),
            (.tri10i, 10 + 2, 2),
            (.tri8, 8, 0),
            (.trikona, 3, 1),
            (.bindu, 2, 1),
        ]
        for (g, count, gold) in expected {
            let strokes = SigilGeometry.strokes(for: g, size: 620)
            XCTAssertEqual(strokes.count, count, "\(g) draws \(strokes.count) strokes")
            XCTAssertEqual(strokes.filter(\.gold).count, gold, "\(g) gold strokes")
            for s in strokes {
                XCTAssertGreaterThan(s.opacity, 0)
                XCTAssertFalse(s.path.isEmpty)
            }
        }
        XCTAssertNotNil(SigilGeometry.binduDot(for: .bindu, size: 620))
        XCTAssertNil(SigilGeometry.binduDot(for: .lotus16, size: 620))
    }

    func testThePetalsReachFromTheInnerRingToNearTheEdge() {
        let c: CGFloat = 310
        let petal = SigilGeometry.petal(c: c, innerR: c * 0.42, outerR: c * 0.88,
                                        halfWidthDeg: 360 / 16 / 2.6, angleDeg: 0)
        let box = petal.boundingRect
        // The petal at 0° points straight up: its tip is at c − 0.88c.
        XCTAssertEqual(box.minY, c - c * 0.88, accuracy: 0.5)
        XCTAssertEqual(box.maxY, c - c * 0.42, accuracy: 0.5)
    }

    // MARK: - The nine beats

    func testTheRiteArrivesInDesignsNineBeats() {
        XCTAssertEqual(ArrivalBeat.allCases.count, 9)
        let delays = ArrivalBeat.allCases.map(\.delay)
        XCTAssertEqual(delays, [0.10, 0.25, 0.40, 0.55, 0.70, 0.80, 0.90, 1.05, 1.25])
        XCTAssertEqual(delays, delays.sorted(), "the beats arrive in their declared order")
        XCTAssertEqual(StagedArrival.duration, 1.3, accuracy: 1e-9)
        XCTAssertEqual(StagedArrival.rise, 10)
        XCTAssertEqual(StagedArrival.sigilDelay, 0.2, accuracy: 1e-9)
        XCTAssertEqual(StagedArrival.sigilDuration, 2.4, accuracy: 1e-9)
        XCTAssertEqual(StagedArrival.settled, 2.6, accuracy: 1e-9,
                       "the sigil's 0.2 + 2.4 outlasts the foot's 1.25 + 1.3")
    }

    /// A beat is keyed by what arrives, not where it sits: in fire's ascension
    /// the prompt stands above her name, and her name still arrives first.
    func testABeatBelongsToTheBlockNotItsPlace() {
        XCTAssertEqual(ArrivalBeat(.name), .name)
        XCTAssertEqual(ArrivalBeat(.nameSmall), .name)
        let fire = RitePlan.forElement(.fire).order
        XCTAssertLessThan(fire.firstIndex(of: .prompt)!, fire.firstIndex(of: .name)!)
        XCTAssertLessThan(ArrivalBeat(.name).delay, ArrivalBeat(.prompt).delay)
    }

    func testAirLeans() {
        let air = RitePlan.forElement(.air)
        XCTAssertEqual(air.align, .lean, "Design's horizon plan is `align: 'lean'`")
        XCTAssertEqual(air.nameCap, 66, accuracy: 1e-9, "the lean cap is 66")
        for e in [Element.fire, .water, .ether, .earth, .light] {
            XCTAssertEqual(RitePlan.forElement(e).align, .center, "\(e) stays centred")
        }
    }

    // MARK: - Where the sigil stands

    func testTheSigilStandsWhereTdSigilPutsIt() {
        let box = CGSize(width: 390, height: 844)
        // bottom: unscaled box 40 below the floor → centre at h + 40 − 310.
        let bottom = RiteSigilPlacement.frame(for: .bottom, planScale: 1, compScale: 1, flip: false, in: box)
        XCTAssertEqual(bottom.center.x, 195, accuracy: 0.001)
        XCTAssertEqual(bottom.center.y, 844 + 40 - 310, accuracy: 0.001)
        XCTAssertEqual(bottom.size, 620, accuracy: 0.001)

        // Scale grows the sigil about its own centre — the centre does not move.
        let scaled = RiteSigilPlacement.frame(for: .bottom, planScale: 1, compScale: 1.2, flip: false, in: box)
        XCTAssertEqual(scaled.center.y, bottom.center.y, accuracy: 0.001)
        XCTAssertEqual(scaled.size, 744, accuracy: 0.001)
        XCTAssertEqual(scaled.lineScale, 1.2, accuracy: 0.001, "strokes thicken with the scale")

        // Air: words lean left (flip false) → the sigil stands off the right edge.
        let right = RiteSigilPlacement.frame(for: .side, planScale: 1, compScale: 1, flip: false, in: box)
        let left = RiteSigilPlacement.frame(for: .side, planScale: 1, compScale: 1, flip: true, in: box)
        XCTAssertEqual(right.center.x, 390 + 220 - 310, accuracy: 0.001)
        XCTAssertEqual(left.center.x, -220 + 310, accuracy: 0.001)
        XCTAssertEqual(right.center.y, 844 * 0.40, accuracy: 0.001)

        // Ether's veil is 0.95 of its scale; radiance is the small 560 point.
        let veil = RiteSigilPlacement.frame(for: .center, planScale: 0.9, compScale: 1, flip: false, in: box)
        XCTAssertEqual(veil.size, 620 * 0.9 * 0.95, accuracy: 0.001)
        XCTAssertEqual(RiteSigilPlacement.baseSize(.centerBig), 560)
        XCTAssertEqual(RiteSigilPlacement.baseSize(.bottomBig), 760)
    }

    func testThePlacementHoldsItsProportionOnEveryPhone() {
        let se = RiteSigilPlacement.frame(for: .bottomBig, planScale: 1.3, compScale: 1, flip: false,
                                          in: CGSize(width: 375, height: 667))
        let max = RiteSigilPlacement.frame(for: .bottomBig, planScale: 1.3, compScale: 1, flip: false,
                                           in: CGSize(width: 440, height: 956))
        XCTAssertEqual(se.size / 375, max.size / 440, accuracy: 0.001)
    }

    // MARK: - `lrBackdrop`, layer for layer

    func testEveryElementGroundHasDesignsLayers() {
        let counts: [(Element, Int, Int)] = [
            // element, layers, of which lights
            (.fire, 3, 2), (.water, 2, 1), (.air, 2, 1), (.ether, 3, 2), (.earth, 2, 1), (.light, 2, 1),
        ]
        for (e, n, lights) in counts {
            let atmo = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: e)
            let layers = Backdrop.layers(for: atmo)
            XCTAssertEqual(layers.count, n, "\(e) has \(layers.count) layers, Design has \(n)")
            XCTAssertEqual(layers.filter(\.isLight).count, lights, "\(e) lights")
            XCTAssertFalse(layers[0].isLight, "\(e)'s first layer is its ground")
        }
    }

    func testTheLightsStandWhereDesignPutThem() {
        func center(_ l: LightLayer) -> UnitPoint? {
            switch l {
            case .ellipse(let c, _, _, _), .circle(let c, _), .shade(let c, _, _, _): return c
            default: return nil
            }
        }
        let fire = Backdrop.layers(for: Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire))
        XCTAssertEqual(center(fire[2])?.y ?? 0, 1.04, accuracy: 1e-9, "fire's updraft rises from below the floor")
        XCTAssertEqual(center(fire[1])?.y ?? 0, -0.10, accuracy: 1e-9, "and her colour crowns the top")

        let air = Atmosphere.derive(ring: 3, cluster: nil, khadgamala: 50, element: .air)
        XCTAssertEqual(center(Backdrop.layers(for: air, flipLeft: false)[1])?.x ?? 0, 0.18, accuracy: 1e-9)
        XCTAssertEqual(center(Backdrop.layers(for: air, flipLeft: true)[1])?.x ?? 0, 0.82, accuracy: 1e-9)

        if case .ellipse(_, let rx, let ry, _) = Backdrop.layers(
            for: Atmosphere.derive(ring: 1, cluster: nil, khadgamala: 3, element: .earth))[1] {
            XCTAssertEqual(rx, 1.40, accuracy: 1e-9, "earth's band is wider than the screen")
            XCTAssertEqual(ry, 0.48, accuracy: 1e-9)
        } else {
            XCTFail("earth's light is an ellipse")
        }

        if case .circle(_, let stops) = Backdrop.layers(
            for: Atmosphere.derive(ring: 9, cluster: nil, khadgamala: 102, element: .light))[1] {
            XCTAssertEqual(stops.map(\.location), [0, 0.26, 0.62], "a hot core, a halo, a falloff")
        } else {
            XCTFail("light's point is a circle")
        }
    }

    func testTheFieldsCrownIsAnEllipseNotACircle() {
        let atmo = Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: 29, element: .fire)
        guard case .ellipse(let c, let rx, let ry, _) = Backdrop.crown(atmo)[1] else {
            return XCTFail("the Field's crown is `ellipse 130% 40%`")
        }
        XCTAssertEqual(c.y, -0.05, accuracy: 1e-9)
        XCTAssertEqual(rx, 1.30, accuracy: 1e-9)
        XCTAssertEqual(ry, 0.40, accuracy: 1e-9)
        XCTAssertEqual(Backdrop.veil(atmo).count, 2)
        XCTAssertEqual(Backdrop.sheet(atmo).count, 2)
        XCTAssertEqual(Backdrop.memory(atmo).count, 2)
    }

    func testCSSGradientGeometry() {
        let box = CGSize(width: 390, height: 844)
        XCTAssertEqual(LightLayer.linearLength(angle: 180, in: box), 844, accuracy: 0.001)
        XCTAssertEqual(LightLayer.linearLength(angle: 90, in: box), 390, accuracy: 0.001)
        XCTAssertEqual(LightLayer.linearLength(angle: 120, in: box),
                       390 * sin(120 * .pi / 180) + 844 * 0.5, accuracy: 0.001)
        XCTAssertEqual(LightLayer.farthestCorner(from: CGPoint(x: 195, y: 422), in: box),
                       sqrt(195 * 195 + 422 * 422), accuracy: 0.001)
    }

    // MARK: - The day's tint, and her hue in the pill

    func testTheHourTintsTheGround() {
        let timeless = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire)
        XCTAssertNil(timeless.timeKey)
        let night = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire, at: .night)
        XCTAssertEqual(night.timeKey, .night)
        // Night's indigo pulls the ground toward blue.
        let before = night.groundRGB, untinted = Atmosphere.mix((13 / 255, 5 / 255, 8 / 255), night.hue.rgb, 0.20)
        XCTAssertGreaterThan(before.b - before.r, untinted.b - untinted.r)
        for v in TimeVariant.allCases {
            let t = Atmosphere.timeTint(v)
            XCTAssertTrue((0.05...0.2).contains(t.amount), "\(v)'s tint is a tint, not a repaint")
        }
        XCTAssertEqual(Atmosphere.timeTint(.dawn).amount, 0.12, accuracy: 1e-9)
        XCTAssertEqual(Atmosphere.timeTint(.noon).amount, 0.07, accuracy: 1e-9)
        XCTAssertEqual(Atmosphere.timeTint(.dusk).amount, 0.14, accuracy: 1e-9)
        XCTAssertEqual(Atmosphere.timeTint(.night).amount, 0.16, accuracy: 1e-9)
    }

    func testIFeelHerCarriesAThirdOfHerHue() {
        let atmo = Atmosphere.derive(ring: 6, cluster: nil, khadgamala: 80, element: .ether)
        let end = DayLight.feelHerEndRGB(atmo)
        let red = (r: 139.0 / 255, g: 26.0 / 255, b: 42.0 / 255)
        let hue = atmo.hue.rgb
        XCTAssertEqual(end.r, red.r * 0.66 + hue.r * 0.34, accuracy: 1e-9)
        XCTAssertEqual(end.g, red.g * 0.66 + hue.g * 0.34, accuracy: 1e-9)
        XCTAssertEqual(end.b, red.b * 0.66 + hue.b * 0.34, accuracy: 1e-9)
        // A teal ring's pill is not the same red as a crimson ring's.
        let crimson = DayLight.feelHerEndRGB(Atmosphere.derive(ring: 4, cluster: nil, khadgamala: 60,
                                                               element: .water))
        XCTAssertNotEqual(end.g, crimson.g, accuracy: 0.01)
    }

    // MARK: - Each ring breathes at its own rate

    func testTheNineMetabolisms() {
        XCTAssertNil(FieldBreath.period(ring: 1), "the Bhūpura holds")
        XCTAssertEqual((2...9).compactMap { FieldBreath.period(ring: $0) }, [3, 8, 9, 11, 13, 15, 18, 4])
        XCTAssertEqual(FieldBreath.phase(at: 0, period: 8), 0, accuracy: 1e-9)
        XCTAssertEqual(FieldBreath.phase(at: 4, period: 8), 1, accuracy: 1e-9)
        XCTAssertEqual(FieldBreath.phase(at: 8, period: 8), 0, accuracy: 1e-9)
    }

    // MARK: - The threshold

    func testTheThresholdTapersHerNameAsDesignDoes() {
        XCTAssertEqual(AvaranaThresholdView.nameSize("Bindu"), 46)
        XCTAssertEqual(AvaranaThresholdView.nameSize(String(repeating: "a", count: 15)), 46)
        XCTAssertEqual(AvaranaThresholdView.nameSize(String(repeating: "a", count: 18)), 42)
        XCTAssertEqual(AvaranaThresholdView.nameSize("Trailokya Mohana Cakra"), 37)
        XCTAssertEqual(AvaranaThresholdView.joined(["a", nil, "  ", "b"]), "a · b")
        XCTAssertNil(AvaranaThresholdView.joined([nil, ""]))
        for ring in 1...9 {
            let a = AvaranaThresholdView.fallbackAtmosphere(ring: ring)
            XCTAssertNil(a.timeKey, "a ring's threshold wears the ring's own light, not the hour's")
            XCTAssertEqual(a.element, Element.forRing(ring))
        }
    }

    func testTheSigilTurnsOnDesignsClock() {
        XCTAssertEqual(RiteSigil.period(hue: 30), 170, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.period(hue: 359), 140 + 59, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.turn(at: 0, hue: 0, spin: 1), 0, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.turn(at: 70, hue: 0, spin: 1), 180, accuracy: 1e-9)
        XCTAssertEqual(RiteSigil.turn(at: 70, hue: 0, spin: -1), -180, accuracy: 1e-9)
    }
}
