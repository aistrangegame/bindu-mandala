import XCTest
@testable import Bindu_Mandala

/// Status is advance-only and its opacities are strictly increasing.
final class ShaktiStatusTests: XCTestCase {

    func testAdvanceChain() {
        XCTAssertEqual(ShaktiStatus.mapped.advanced(), .exploring)
        XCTAssertEqual(ShaktiStatus.exploring.advanced(), .active)
        XCTAssertEqual(ShaktiStatus.active.advanced(), .embodied)
        XCTAssertEqual(ShaktiStatus.embodied.advanced(), .embodied, "Embodied is terminal")
    }

    func testOpacityIsMonotonic() {
        let order: [ShaktiStatus] = [.mapped, .exploring, .active, .embodied]
        for i in 1..<order.count {
            XCTAssertGreaterThan(order[i].opacity, order[i - 1].opacity)
        }
        XCTAssertEqual(ShaktiStatus.embodied.opacity, 1.0)
    }

    func testRawValueRoundTrips() {
        for s in ShaktiStatus.allCases {
            XCTAssertEqual(ShaktiStatus(rawValue: s.rawValue), s)
        }
    }
}
