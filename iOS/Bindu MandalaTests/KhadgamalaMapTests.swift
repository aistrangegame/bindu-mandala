import XCTest
@testable import Bindu_Mandala

/// The Khaḍgamālā-position → ring mapping used by both sync and selection.
final class KhadgamalaMapTests: XCTestCase {

    func testRingBoundaries() {
        let cases: [(Int, Int)] = [
            (1, 1), (28, 1),
            (29, 2), (44, 2),
            (45, 3), (52, 3),
            (53, 4), (66, 4),
            (67, 5), (76, 5),
            (77, 6), (86, 6),
            (87, 7), (98, 7),
            (99, 8), (101, 8),
            (102, 9),
        ]
        for (kp, ring) in cases {
            XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: kp), ring, "kp \(kp)")
        }
    }

    func testOutOfRangeIsZero() {
        XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: 0), 0)
        XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: 103), 0)
        XCTAssertEqual(KhadgamalaMap.ringNumber(forKhadgamala: -5), 0)
    }

    func testPerRingIndex() {
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 1), 1)   // Ring 1 first
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 28), 28) // Ring 1 last
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 29), 1)  // Ring 2 first Karṣiṇī
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 44), 16) // Ring 2 last Karṣiṇī
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 102), 1) // Lalitā, alone in Ring 9
        XCTAssertEqual(KhadgamalaMap.perRingIndex(forKhadgamala: 0), 0)   // invalid
    }

    func testEveryValidPositionMapsToARing() {
        for kp in 1...102 {
            XCTAssertTrue((1...9).contains(KhadgamalaMap.ringNumber(forKhadgamala: kp)))
            XCTAssertGreaterThanOrEqual(KhadgamalaMap.perRingIndex(forKhadgamala: kp), 1)
        }
    }
}
