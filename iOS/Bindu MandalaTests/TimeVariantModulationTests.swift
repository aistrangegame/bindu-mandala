import XCTest
@testable import Bindu_Mandala

/// The new time-of-day `Modulation` layer exists for all five states, and adding
/// it left the pre-existing absolute palette byte-unchanged (regression guard).
final class TimeVariantModulationTests: XCTestCase {

    func testAllStatesHaveModulation() {
        XCTAssertEqual(TimeVariant.dawn.modulation.dh, 8)
        XCTAssertEqual(TimeVariant.noon.modulation.lAdd, 13)
        XCTAssertEqual(TimeVariant.dusk.modulation.sMul, 1.16, accuracy: 0.0001)
        XCTAssertEqual(TimeVariant.night.modulation.lAdd, -9)
        XCTAssertEqual(TimeVariant.newmoon.modulation.lAdd, -16)   // invention-by-design
        // Exhaustive: every case yields a modulation without trapping.
        for v in TimeVariant.allCases { _ = v.modulation }
    }

    /// The absolute layer the held-yantra rendering depends on must be untouched.
    func testAbsolutePropsUnchanged() {
        XCTAssertEqual(TimeVariant.dawn.petalSat, 1.0)
        XCTAssertEqual(TimeVariant.noon.motes, 6)
        XCTAssertEqual(TimeVariant.dusk.triOpacity, 0.55, accuracy: 0.0001)
        XCTAssertEqual(TimeVariant.night.petalOpacityMul, 0.55, accuracy: 0.0001)
        XCTAssertEqual(TimeVariant.newmoon.binduScale, 1.60, accuracy: 0.0001)
        XCTAssertEqual(TimeVariant.newmoon.lotusInnerOp, 0.15, accuracy: 0.0001)
    }
}
