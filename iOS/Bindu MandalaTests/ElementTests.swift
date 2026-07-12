import XCTest
@testable import Bindu_Mandala

/// Element derivation — the per-ring table for the 86, tattva parse for Ring 2,
/// always resolving (never nil).
final class ElementTests: XCTestCase {

    func testPerRingTable() {
        XCTAssertEqual(Element.forRing(1), .earth)
        XCTAssertEqual(Element.forRing(3), .air)
        XCTAssertEqual(Element.forRing(4), .water)
        XCTAssertEqual(Element.forRing(5), .fire)
        XCTAssertEqual(Element.forRing(6), .ether)
        XCTAssertEqual(Element.forRing(7), .air)
        XCTAssertEqual(Element.forRing(8), .fire)
        XCTAssertEqual(Element.forRing(9), .light)
        XCTAssertEqual(Element.forRing(2), .ether)   // no tattva → default
        XCTAssertEqual(Element.forRing(0), .ether)   // indeterminate → default
    }

    func testTattvaParse() {
        XCTAssertEqual(Element.parse(tattva: "Air (Vāyu)"), .air)
        XCTAssertEqual(Element.parse(tattva: "Fire"), .fire)
        XCTAssertEqual(Element.parse(tattva: "Water (Jala)"), .water)
        XCTAssertEqual(Element.parse(tattva: "Earth (Pṛthvī)"), .earth)
        XCTAssertEqual(Element.parse(tattva: "Ether / Ākāśa"), .ether)
        XCTAssertEqual(Element.parse(tattva: "something unmapped"), .ether)
    }

    func testShaktiElementResolvesForAllRings() {
        // Ring 2 reads her tattva.
        let s2 = makeShakti(ring: 2, kp: 33, tattva: "Fire (Agni)")
        XCTAssertEqual(s2.element, .fire)
        let s2blank = makeShakti(ring: 2, kp: 34, tattva: "")
        XCTAssertEqual(s2blank.element, .ether)
        // The 86 take the ring table regardless of tattva.
        let s5 = makeShakti(ring: 5, kp: 70, tattva: "irrelevant")
        XCTAssertEqual(s5.element, .fire)
        // Every ring resolves.
        for ring in 1...9 {
            let s = makeShakti(ring: ring, kp: 1, tattva: "")
            XCTAssertTrue(Element.allCases.contains(s.element))
        }
    }

    private func makeShakti(ring: Int, kp: Int, tattva: String) -> Shakti {
        let s = Shakti(position: 1, name: "x", shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: tattva, recognitionPhrase: "",
                       cluster: .inner, status: .mapped)
        s.ringNumber = ring
        s.khadgamalaPosition = kp
        return s
    }
}
