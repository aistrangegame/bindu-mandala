import XCTest
@testable import Bindu_Mandala

/// The Daily Rite's composition engine: element → archetype (all six), and
/// per-kp variance is deterministic. The 86-degradation lives in `RiteContent`.
final class RiteCompositionTests: XCTestCase {

    func testEveryElementMapsToItsArchetype() {
        XCTAssertEqual(RitePlan.forElement(.fire).archetype, "ascension")
        XCTAssertEqual(RitePlan.forElement(.water).archetype, "descent")
        XCTAssertEqual(RitePlan.forElement(.air).archetype, "horizon")
        XCTAssertEqual(RitePlan.forElement(.ether).archetype, "veil")
        XCTAssertEqual(RitePlan.forElement(.earth).archetype, "foundation")
        XCTAssertEqual(RitePlan.forElement(.light).archetype, "radiance")
    }

    func testPlanStructureMatchesElement() {
        // ether alone makes her name the vast backdrop; air alone drifts (side sigil + horizon).
        XCTAssertTrue(RitePlan.forElement(.ether).veilName)
        XCTAssertFalse(RitePlan.forElement(.fire).veilName)
        XCTAssertEqual(RitePlan.forElement(.air).sigil, .side)
        XCTAssertEqual(RitePlan.forElement(.fire).align, .center)
        XCTAssertTrue(RitePlan.forElement(.air).horizonLine)
        // fire rises: name is the climax (comes after the prompt/quality).
        let fire = RitePlan.forElement(.fire).order
        XCTAssertTrue(fire.firstIndex(of: .prompt)! < fire.firstIndex(of: .name)!)
    }

    func testCompositionDeterministicAndInRange() {
        let a = RiteComposition.derive(kp: 70, element: .fire)
        let b = RiteComposition.derive(kp: 70, element: .fire)
        XCTAssertEqual(a, b)
        for kp in 1...102 {
            let comp = RiteComposition.derive(kp: kp, element: .water)
            XCTAssertTrue((0.86...1.26).contains(comp.sigilScale), "sigilScale out of range at \(kp)")
            XCTAssertTrue((0...3).contains(comp.nameTier))
            XCTAssertTrue(comp.spin == 1 || comp.spin == -1)
        }
    }

    func testRiteContentDegradesForThe86() {
        // A Ring-5 Śakti carrying the default `.inner` cluster must NOT surface it.
        let s = Shakti(position: 4, name: "Ring-5", shortName: "", phonetic: "",
                       quality: "She who accomplishes", qualityDescription: "", somatic: "",
                       somaticPoetry: "a line of her poetry\nsecond line", bija: "",
                       bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: .inner, status: .mapped)
        s.ringNumber = 5
        s.khadgamalaPosition = 70
        let c = RiteContent(shakti: s)
        XCTAssertFalse(c.hasCluster, "the 86 must never show a cluster")
        XCTAssertNil(c.cluster)
        XCTAssertNil(c.phonetic, "empty phonetic hidden")
        XCTAssertNil(c.bija, "empty bīja hidden")
        XCTAssertEqual(c.prompt, "a line of her poetry", "prompt falls back to poetry's first line")
        XCTAssertEqual(c.quality, "She who accomplishes")
    }

    func testRiteContentRing2KeepsCluster() {
        let s = Shakti(position: 1, name: "Kāmākarṣiṇī", shortName: "", phonetic: "KAH·mah",
                       quality: "", qualityDescription: "", somatic: "Where does desire pull you?",
                       somaticPoetry: "", bija: "aṁ", bodilyLocation: "heart", tattva: "Fire",
                       recognitionPhrase: "", cluster: .inner, status: .mapped)
        s.ringNumber = 2
        s.khadgamalaPosition = 29
        let c = RiteContent(shakti: s)
        XCTAssertTrue(c.hasCluster)
        XCTAssertEqual(c.cluster, .inner)
        XCTAssertEqual(c.phonetic, "KAH·mah")
        XCTAssertEqual(c.bija, "aṁ")
        XCTAssertEqual(c.prompt, "Where does desire pull you?")
    }
}
