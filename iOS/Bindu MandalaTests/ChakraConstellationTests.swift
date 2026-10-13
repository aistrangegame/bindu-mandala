import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Wave 3 · the bake of The Map's 33 into the yantra, and where they stand.
///
/// The file is read twice: from the app bundle (what ships) and from the
/// source tree (what was baked), so a bundling slip and a bake slip are told
/// apart.
final class ChakraConstellationTests: XCTestCase {

    private var baked: [Chakra33] {
        let url = SourceTree.iOSRoot.appendingPathComponent("Bindu Mandala/Data/ChakraConstellation.json")
        guard let data = try? Data(contentsOf: url) else { return [] }
        return ChakraConstellation.decode(data)
    }

    // MARK: The bake

    func testTheBakeHoldsThirtyThree() {
        XCTAssertEqual(baked.count, 33, "the bake on disk should hold all 33 of the Map")
        XCTAssertEqual(ChakraConstellation.all.count, 33, "the bundled bake should load all 33")
    }

    func testTheRoadOrderIsUniqueAndWhole() {
        let roads = baked.map(\.road)
        XCTAssertEqual(roads, Array(1...33), "Road positions 1…33, each once, in order")
        XCTAssertEqual(Set(baked.map(\.recordId)).count, 33, "33 distinct Map records")
    }

    func testEveryKhadgamalaPositionIsInTheGarland() {
        for c in baked {
            for kp in c.kp {
                XCTAssertTrue((1...102).contains(kp), "\(c.name) is seated at kp \(kp), outside 1…102")
            }
            XCTAssertEqual(Set(c.kp).count, c.kp.count, "\(c.name) lists a seat twice")
        }
    }

    func testShadowStandsAtTheThreeFourCrossing() throws {
        let shadow = try XCTUnwrap(baked.first { $0.kind == .shadow })
        XCTAssertEqual(baked.filter { $0.kind == .shadow }.count, 1)
        XCTAssertEqual(shadow.name, "Shadow")
        XCTAssertEqual(shadow.crossing, [3, 4])
        XCTAssertEqual(shadow.address, .threshold)
        XCTAssertNil(shadow.avarana, "a threshold lives between rings, in none of them")
        XCTAssertTrue(shadow.kp.isEmpty)
    }

    func testArminStandsAtTheSixSevenCrossing() throws {
        let armin = try XCTUnwrap(baked.first { $0.kind == .armin })
        XCTAssertEqual(baked.filter { $0.kind == .armin }.count, 1)
        XCTAssertEqual(armin.name, "Armin")
        XCTAssertEqual(armin.crossing, [6, 7])
        XCTAssertEqual(armin.address, .threshold)
        XCTAssertNil(armin.avarana)
    }

    func testTheRoadBeginsAndEndsAtThePoint() {
        guard let first = baked.first, let last = baked.last else { return XCTFail("empty bake") }
        XCTAssertEqual(first.name, "Bindu")
        XCTAssertEqual(last.name, "Lalita")
        for c in [first, last] {
            XCTAssertEqual(c.address, .centre)
            XCTAssertEqual(c.avarana, 9)
            XCTAssertEqual(c.kp, [102], "the point is Mahātripurasundarī's seat")
        }
    }

    /// C-1344/45: energy in rings 1–3, the body in 4–6, the mind in 7, the
    /// summit in 8 (and Lalitā at 9).
    func testEachSectionLivesInItsOwnRings() {
        for c in baked {
            switch c.kind {
            case .energy: XCTAssertTrue((1...3).contains(c.avarana ?? 0), "\(c.name) ring \(String(describing: c.avarana))")
            case .body: XCTAssertTrue((4...6).contains(c.avarana ?? 0), "\(c.name)")
            case .mind: XCTAssertEqual(c.avarana, 7, "\(c.name)")
            case .summit: XCTAssertTrue((8...9).contains(c.avarana ?? 0), "\(c.name)")
            case .bindu: XCTAssertEqual(c.avarana, 9)
            case .shadow, .armin: XCTAssertNil(c.avarana)
            }
        }
        XCTAssertEqual(baked.filter { $0.kind == .energy }.count, 7)
        XCTAssertEqual(baked.filter { $0.kind == .body }.count, 10)
        XCTAssertEqual(baked.filter { $0.kind == .mind }.count, 9)
    }

    /// Energy chakras at the level of a ring; body, mind and summit at one seat
    /// each — except the presiding forms, which are not among the 102.
    func testAddressesFollowTheirKind() {
        for c in baked {
            switch c.address {
            case .seat:
                XCTAssertEqual(c.kp.count, 1, "\(c.name) sits at exactly one seat")
                XCTAssertTrue([Chakra33.Kind.body, .mind, .summit].contains(c.kind), "\(c.name)")
                XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: c.kp[0]), c.avarana,
                               "\(c.name)'s seat is in its own ring")
            case .ring:
                for kp in c.kp {
                    XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: kp), c.avarana, "\(c.name) kp \(kp)")
                }
            case .threshold:
                XCTAssertTrue(c.isThreshold)
            case .centre:
                XCTAssertEqual(c.kp, [102])
            }
        }
        // The body's ten, each at its own Śakti.
        let bodySeats = baked.filter { $0.kind == .body }.flatMap(\.kp)
        XCTAssertEqual(Set(bodySeats).count, 10)
        XCTAssertEqual(Set(bodySeats), [53, 65, 66, 69, 70, 71, 77, 80, 82, 84])
    }

    /// The truth floor: a field the Map leaves empty is absent, never an empty
    /// string or an invented value.
    func testAnEmptyMapCellIsAbsentNotInvented() {
        for c in baked {
            for v in [c.subtitle, c.sanskrit, c.shaktiName, c.mudra, c.colorHex, c.verb,
                      c.activation, c.bija, c.essence, c.bodyLocation] {
                if let v { XCTAssertFalse(v.trimmingCharacters(in: .whitespaces).isEmpty, "\(c.name)") }
            }
        }
        // The Map's one empty Sanskrit cell among the 33, as baked on 12 Oct 2026.
        XCTAssertNil(baked.first { $0.name == "Ego Reveal" }?.sanskrit)
    }

    func testAMalformedFileYieldsNothingRatherThanHalfASky() {
        XCTAssertTrue(ChakraConstellation.decode(Data("{\"chakras\": [{\"road\": 1}]}".utf8)).isEmpty)
        XCTAssertTrue(ChakraConstellation.decode(Data()).isEmpty)
    }

    // MARK: Crossing the thresholds

    func testFallingThroughTheCrossingsMeetsTheThresholds() {
        let all = baked
        XCTAssertEqual(ChakraConstellation.thresholdsCrossed(from: 3, to: 4, in: all).map(\.name), ["Shadow"])
        XCTAssertEqual(ChakraConstellation.thresholdsCrossed(from: 6, to: 7, in: all).map(\.name), ["Armin"])
        XCTAssertEqual(ChakraConstellation.thresholdsCrossed(from: 0, to: 8, in: all).map(\.name),
                       ["Shadow", "Armin"], "one fall through both meets both, outermost first")
        XCTAssertTrue(ChakraConstellation.thresholdsCrossed(from: 4, to: 6, in: all).isEmpty)
        XCTAssertTrue(ChakraConstellation.thresholdsCrossed(from: 7, to: 3, in: all).isEmpty,
                      "the moments ride the inward fall")
        // U0 rewrite (VER-L-0815): a threshold is never only behind the fall —
        // deepening is offered, never withheld. Each one is also a stop of its
        // own on the Road, a direct door beside the slow one.
        let roadStops = ChakraRoad.stops(all, seats: [:], in: CGSize(width: 390, height: 844))
        for threshold in all where threshold.isThreshold {
            XCTAssertTrue(roadStops.contains { $0.chakra.road == threshold.road },
                          "\(threshold.name) is reachable only by falling through it")
        }
    }

    func testAThresholdIsDrawnBetweenItsTwoRings() throws {
        let shadow = try XCTUnwrap(baked.first { $0.kind == .shadow })
        let r = try XCTUnwrap(ChakraConstellation.thresholdRadius(shadow))
        XCTAssertLessThan(r, MandalaWorld.ringRadius(3))
        XCTAssertGreaterThan(r, MandalaWorld.ringRadius(4))
    }

    // MARK: Where a seat stands

    func testTheCanonicalSeatIsWhereTheFieldPutsHer() {
        var shaktis: [Shakti] = []
        for kp in 1...102 {
            let s = Shakti(position: kp, name: "s\(kp)", shortName: "", phonetic: "",
                           quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                           bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                           cluster: .inner, status: .mapped)
            s.khadgamalaPosition = kp
            s.ringNumber = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            shaktis.append(s)
        }
        for seat in MandalaWorld.seats(from: shaktis) {
            let p = ChakraConstellation.canonicalPoint(kp: seat.id)
            XCTAssertNotNil(p)
            XCTAssertEqual(p?.x ?? .nan, seat.point.x, accuracy: 0.001, "kp \(seat.id)")
            XCTAssertEqual(p?.y ?? .nan, seat.point.y, accuracy: 0.001, "kp \(seat.id)")
        }
    }

    // MARK: Spoken

    /// A chakra is a place, not a rung. U0 (VER-L-0765): the no-digit clause
    /// is retired (ruling 10); the narrow floor stays, and the sealed room
    /// (ruling 2) is spoken as held and nothing more.
    func testTheSpokenConstellationNamesPlacesAndHoldsTheSealedRoom() {
        for c in baked {
            let label = ChakraConstellation.spokenLabel(c, seatName: "Sarvajñā")
            XCTAssertTrue(NeverMeasure.measuresOutLoud(label).isEmpty, label)
            XCTAssertTrue(label.hasPrefix(c.name), "her name first: \(label)")
            if c.road == ChakraConstellation.sealedRoad {
                XCTAssertTrue(label.hasSuffix(ChakraConstellation.sealedLine), label)
            }
        }
    }
}

/// The Road: the 33 in order, as stops for the Mandala's own camera.
final class ChakraRoadTests: XCTestCase {

    private let size = CGSize(width: 390, height: 844)

    private var stops: [ChakraRoad.Stop] {
        ChakraRoad.stops(ChakraConstellation.all, seats: [:], in: size)
    }

    func testTheRoadHasAStopForEachOfTheThirtyThree() {
        XCTAssertEqual(stops.count, 33)
        XCTAssertEqual(stops.map(\.chakra.road), Array(1...33))
    }

    func testTheRoadGoesOutToThePerimeterAndSpiralsHome() {
        let s = stops
        guard s.count == 33 else { return XCTFail("no road") }
        XCTAssertEqual(s.first?.world, CGPoint.zero, "it starts at the point")
        XCTAssertEqual(s.last?.world, CGPoint.zero, "it ends at the point")
        // Out: Mūlādhāra stands on the Bhūpura.
        let out = hypot(s[1].world.x, s[1].world.y)
        XCTAssertGreaterThan(out, MandalaWorld.ringRadius(2))
        // Home: the body's last place is nearer the centre than its first, and
        // the summit nearer still.
        let soles = hypot(s[9].world.x, s[9].world.y)
        let crow = hypot(s[18].world.x, s[18].world.y)
        let maya = hypot(s[29].world.x, s[29].world.y)
        XCTAssertGreaterThan(soles, crow)
        XCTAssertGreaterThan(crow, maya)
    }

    func testEveryStopIsACameraTheZoomCouldHold() {
        for stop in stops {
            XCTAssertGreaterThanOrEqual(stop.scale, MandalaCamera.minScale)
            XCTAssertLessThanOrEqual(stop.scale, MandalaCamera.maxScale)
            let cam = ChakraRoad.camera(for: stop, in: size)
            let p = cam.screen(for: stop.world)
            XCTAssertEqual(p.x, size.width / 2, accuracy: 0.01)
            XCTAssertEqual(p.y, size.height * 0.42, accuracy: 0.01)
        }
    }

    func testTheWalkRestsLongerAtTheCrossings() throws {
        let s = stops
        let shadow = try XCTUnwrap(s.first { $0.chakra.kind == .shadow })
        let soles = try XCTUnwrap(s.first { $0.chakra.name == "Soles" })
        XCTAssertGreaterThan(ChakraRoad.dwell(at: shadow), ChakraRoad.dwell(at: soles))
        for (a, b) in zip(s, s.dropFirst()) {
            let t = ChakraRoad.travel(from: a, to: b)
            XCTAssertGreaterThanOrEqual(t, 2.0)
            XCTAssertLessThanOrEqual(t, 4.0)
        }
    }
}
