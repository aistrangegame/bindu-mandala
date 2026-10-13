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

    // MARK: Ruling 4 (12 Oct 2026) and C12 — the Karṣiṇīs by position
    //
    // U0 rewrite (VER-S-0686): Element has a light branch in Ring 2, and the
    // sixteen Karṣiṇīs take their element from one explicit table by kp — Ahaṅ
    // fire (31), Nāma air (40), Ātma light (42), Amṛta water (43) — never from
    // a parse of her tattva text, which for kp 34–44 names the cross-mapped organ.

    static let ring2: [Int: Element] = [
        29: .earth, 30: .water, 31: .fire, 32: .air, 33: .ether,
        34: .fire, 35: .water, 36: .earth, 37: .ether, 38: .earth,
        39: .water, 40: .air, 41: .fire, 42: .light, 43: .water, 44: .earth,
    ]

    func testRulingFourElementsByPosition() {
        // Each tattva below is chosen to *disagree* with the table, so the test
        // fails if the element is read from the text instead of the position.
        XCTAssertEqual(makeShakti(ring: 2, kp: 31, tattva: "Ākāśa (ether)").element, .fire, "Ahaṅ is fire")
        XCTAssertEqual(makeShakti(ring: 2, kp: 40, tattva: "Earth").element, .air, "Nāma is air")
        XCTAssertEqual(makeShakti(ring: 2, kp: 42, tattva: "Water").element, .light, "Ātma is light")
        XCTAssertEqual(makeShakti(ring: 2, kp: 43, tattva: "Fire").element, .water, "Amṛta is water")
    }

    func testTheSixteenKarshinisFollowTheTable() {
        XCTAssertEqual(Element.ring2ByKp, Self.ring2)
        for (kp, element) in Self.ring2 {
            XCTAssertEqual(Element.forRing2(kp: kp), element, "kp \(kp)")
            XCTAssertEqual(makeShakti(ring: 2, kp: kp, tattva: "something unmapped").element, element, "kp \(kp)")
        }
        XCTAssertNil(Element.forRing2(kp: 28))
        XCTAssertNil(Element.forRing2(kp: 45))
    }

    /// The light branch reaches what every element reaches: Recognition's
    /// nature (light radiates) — and ring 9 stays light.
    func testTheLightBranch() {
        XCTAssertTrue(Element.allCases.contains(.light))
        XCTAssertEqual(RecognitionNature.of(.light), .radiate)
        XCTAssertEqual(RecognitionNature.of(.fire), .flare)
        XCTAssertEqual(RecognitionNature.of(.air), .disperse)
        XCTAssertEqual(RecognitionNature.of(.water), .pool)
        XCTAssertEqual(Element.forRing(9), .light)
        XCTAssertEqual(makeShakti(ring: 9, kp: 102, tattva: "").element, .light)
    }

    func testShaktiElementResolvesForAllRings() {
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
