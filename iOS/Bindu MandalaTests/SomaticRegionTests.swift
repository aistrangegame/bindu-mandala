import XCTest
@testable import Bindu_Mandala

/// Wave 5 · the somatic way in. Her own row's `bodilyLocation` decides where in
/// his body she lights. The fixtures are the base's own words (Mandala table,
/// field `fld6P1u43B0eqKU5e`, read 2026-10-12), not paraphrases.
final class SomaticRegionTests: XCTestCase {

    private func regions(_ s: String) -> Set<SomaticRegion> {
        SomaticRegion.regions(forBodilyLocation: s)
    }

    func testTheBasesOwnWordsFindTheirPlaces() {
        XCTAssertEqual(regions("Heart / hands"), [.heart, .hands], "kp 100")
        XCTAssertEqual(regions("Mūlādhāra / soles of feet"), [.root, .soles], "kp 82 — diacritics folded")
        XCTAssertEqual(regions("Mūlādhāra / sit-bones / soles"), [.root, .soles], "kp 4")
        XCTAssertEqual(regions("Third eye / direct-seeing point"), [.brow], "kp 77 — the third eye is the brow, not the senses")
        XCTAssertEqual(regions("Solar plexus / center of action"), [.solar], "kp 63")
        XCTAssertEqual(regions("Throat (luminous)"), [.throat], "kp 91")
        XCTAssertEqual(regions("Bridge of nose"), [.senses], "kp 36")
        XCTAssertEqual(regions("Back-body, spine"), [.spine], "kp 38")
        XCTAssertEqual(regions("Belly / yoni / point-of-manifestation"), [.belly, .root], "kp 101")
        XCTAssertEqual(regions("Wherever healing is needed"), [.field], "kp 81")
        XCTAssertTrue(regions("Bindu point at crown / single point of attention").contains(.crown), "kp 1")
        let behind = regions("Behind the eyes / soft palate")
        XCTAssertTrue(behind.contains(.brow) && behind.contains(.throat), "kp 47")
        XCTAssertTrue(regions("Mouth / belly / whole body").isSuperset(of: [.throat, .belly, .field]), "kp 8")
    }

    func testTheBootstrapWordsFindTheirPlacesToo() {
        for word in ["heart", "head", "solar", "ears", "skin", "eyes", "tongue", "nose",
                     "whole", "spine", "temples", "throat", "sacrum", "crown"] {
            XCTAssertFalse(regions(word).isEmpty, word)
        }
        XCTAssertEqual(regions("skin"), [.field], "skin is everywhere skin meets world")
    }

    func testNowhereKnownIsTheWholeField() {
        XCTAssertEqual(regions(""), [.field])
        XCTAssertEqual(regions("xyz"), [.field])
    }

    func testEveryPlaceStandsOnTheMap() {
        for r in SomaticRegion.allCases {
            XCTAssertFalse(r.anchors.isEmpty, "\(r) has nowhere to stand")
            for a in r.anchors {
                XCTAssertTrue((0...1).contains(a.x) && (0...1).contains(a.y), "\(r) stands off the map")
            }
            XCTAssertFalse(r.words.isEmpty)
        }
    }

    // MARK: The everyday doorway

    func testHerElementOpensItsDoorway() {
        XCTAssertEqual(SensoryDoorway.forTattva("Air (Vāyu)"), .breath)
        XCTAssertEqual(SensoryDoorway.forTattva("Fire (Agni)"), .heat)
        XCTAssertEqual(SensoryDoorway.forTattva("Water (Jala)"), .water)
        XCTAssertEqual(SensoryDoorway.forTattva("Earth (Pṛthvī)"), .earth)
        XCTAssertEqual(SensoryDoorway.forTattva("Ether (Ākāśa)"), .space)
        XCTAssertNil(SensoryDoorway.forTattva(""))
    }

    func testTheDoorwaysLineIsHerFirstLine() {
        XCTAssertEqual(SensoryDoorway.line(somaticSignature: "\n  the first line\nthe second", somaticPrompt: "p"),
                       "the first line")
        XCTAssertEqual(SensoryDoorway.line(somaticSignature: "  ", somaticPrompt: "Where is she landing?"),
                       "Where is she landing?")
        XCTAssertNil(SensoryDoorway.line(somaticSignature: "", somaticPrompt: ""),
                     "no line in her rows, no doorway — nothing is written for her")
    }
}
