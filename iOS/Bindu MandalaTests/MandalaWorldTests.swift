import XCTest
import CoreGraphics
@testable import Bindu_Mandala

/// Seat placement, enclosure radii, and family threading — pure geometry.
final class MandalaWorldTests: XCTestCase {

    private func make(ring: Int, kp: Int, cluster: Cluster = .inner) -> Shakti {
        let s = Shakti(position: kp, name: "s\(kp)", shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: cluster, status: .mapped)
        s.ringNumber = ring
        s.khadgamalaPosition = kp
        return s
    }

    /// A small but structurally complete field: ring 1 (square), several circular
    /// rings, and ring 9 (the Bindu).
    private func sampleField() -> [Shakti] {
        var out: [Shakti] = []
        var kp = 1
        for (ring, n) in [(1, 8), (2, 16), (3, 8), (5, 10), (9, 1)] {
            for _ in 0..<n {
                let cluster = Cluster.forPosition(((kp - 1) % 16) + 1)
                out.append(make(ring: ring, kp: kp, cluster: cluster))
                kp += 1
            }
        }
        return out
    }

    func testEverySeatIsPlaced() {
        let field = sampleField()
        let seats = MandalaWorld.seats(from: field)
        XCTAssertEqual(seats.count, field.count)
    }

    func testRingNineSitsAtTheBindu() {
        let seats = MandalaWorld.seats(from: sampleField())
        let bindu = seats.first { ($0.shakti.ringNumber ?? 2) == 9 }
        XCTAssertNotNil(bindu)
        XCTAssertEqual(bindu!.point.x, 0, accuracy: 0.001)
        XCTAssertEqual(bindu!.point.y, 0, accuracy: 0.001)
    }

    func testCircularRingSeatsSitOnTheirRadius() {
        let seats = MandalaWorld.seats(from: sampleField())
        for seat in seats where (seat.shakti.ringNumber ?? 2) == 5 {
            let r = hypot(seat.point.x, seat.point.y)
            XCTAssertEqual(r, MandalaWorld.ringRadius(5), accuracy: 0.001)
        }
    }

    func testRingOneSeatsRideTheSquarePerimeter() {
        let seats = MandalaWorld.seats(from: sampleField())
        let half = MandalaWorld.ringRadius(1)
        for seat in seats where (seat.shakti.ringNumber ?? 2) == 1 {
            let onEdge = abs(abs(seat.point.x) - half) < 0.001 || abs(abs(seat.point.y) - half) < 0.001
            XCTAssertTrue(onEdge, "ring-1 seat \(seat.point) must lie on the square of half \(half)")
        }
    }

    func testSquarePerimeterHitsTheCorners() {
        let H: CGFloat = 100
        let tl = MandalaWorld.squarePerimeter(t: 0, half: H)
        let tr = MandalaWorld.squarePerimeter(t: 0.25, half: H)
        let br = MandalaWorld.squarePerimeter(t: 0.5, half: H)
        let bl = MandalaWorld.squarePerimeter(t: 0.75, half: H)
        XCTAssertEqual(tl.x, -H, accuracy: 0.001); XCTAssertEqual(tl.y, -H, accuracy: 0.001)
        XCTAssertEqual(tr.x, H, accuracy: 0.001);  XCTAssertEqual(tr.y, -H, accuracy: 0.001)
        XCTAssertEqual(br.x, H, accuracy: 0.001);  XCTAssertEqual(br.y, H, accuracy: 0.001)
        XCTAssertEqual(bl.x, -H, accuracy: 0.001); XCTAssertEqual(bl.y, H, accuracy: 0.001)
    }

    func testFamilyForNonRingTwoIsTheWholeRingMinusSelf() {
        let field = sampleField()
        let ring5 = field.first { ($0.ringNumber ?? 2) == 5 }!
        let fam = MandalaWorld.family(of: ring5, in: field)
        XCTAssertEqual(fam.count, 9, "ten in ring 5, minus herself")
        XCTAssertFalse(fam.contains { $0.khadgamalaPosition == ring5.khadgamalaPosition })
        XCTAssertTrue(fam.allSatisfy { ($0.ringNumber ?? 2) == 5 })
    }

    func testFamilyForRingTwoThreadsByClusterOnly() {
        let field = sampleField()
        let anchor = field.first { ($0.ringNumber ?? 2) == 2 }!
        let fam = MandalaWorld.family(of: anchor, in: field)
        XCTAssertTrue(fam.allSatisfy { $0.cluster == anchor.cluster && ($0.ringNumber ?? 2) == 2 })
        XCTAssertFalse(fam.contains { $0.khadgamalaPosition == anchor.khadgamalaPosition })
    }
}
