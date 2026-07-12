import XCTest
@testable import Bindu_Mandala

/// The Atmosphere engine is pure arithmetic — asserted against reference numbers.
final class AtmosphereTests: XCTestCase {

    func testDeterministic() {
        let a = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire)
        let b = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire)
        XCTAssertEqual(a, b)
    }

    func testRing2SeedsFromClusterHue() {
        // Inner cluster hue is {43,78,52}; jitter(29,14) = -6.034 → h ≈ 36.966.
        let a = Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: 29, element: .fire)
        XCTAssertEqual(a.hue.s, 78, accuracy: 0.001)
        XCTAssertEqual(a.hue.l, 52, accuracy: 0.001)
        XCTAssertEqual(a.hue.h, 36.966, accuracy: 0.01)
    }

    /// The 86-degradation at the engine level: a non-Ring-2 Śakti must seed off
    /// its ring hue, never the `.inner` cluster default (s 78) that `clusterRaw`
    /// carries for all 86.
    func testRing5UsesRingHueNotClusterInner() {
        let a = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire)
        XCTAssertEqual(a.hue.s, 62, accuracy: 0.001, "ring 5 saturation, not inner's 78")
        XCTAssertEqual(a.hue.l, 55, accuracy: 0.001)
    }

    /// `derive(from:)` must drop the false `.inner` cluster for the 86 even when
    /// the model carries it as the default — proving the leak is closed end-to-end.
    func testDeriveFromShaktiSkipsClusterForThe86() {
        let s = Shakti(position: 4, name: "Ring-5 sister", shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: .inner, status: .mapped)
        s.ringNumber = 5
        s.khadgamalaPosition = 70
        let a = Atmosphere.derive(from: s)
        XCTAssertEqual(a.hue.s, 62, accuracy: 0.001, "must use ring-5 hue, not the .inner default")
    }

    func testTerminalDefaultNeverBlank() {
        let a = Atmosphere.derive(ring: 0, cluster: nil, khadgamala: 1, element: .ether)
        XCTAssertGreaterThan(a.hue.s, 0)
        XCTAssertGreaterThan(a.hue.l, 0)
    }

    func testTimeModulationShiftsLightnessAndClampsGlow() {
        let base = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire)         // l = 55
        let noon = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire, at: .noon) // +13
        let night = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire, at: .night) // -9
        XCTAssertEqual(noon.hue.l, 68, accuracy: 0.001)
        XCTAssertEqual(night.hue.l, 46, accuracy: 0.001)
        XCTAssertEqual(base.glowAlpha, 0.36, accuracy: 0.001)
        XCTAssertEqual(noon.glowAlpha, 0.288, accuracy: 0.001)   // 0.36 * 0.8
        for v in TimeVariant.allCases {
            let g = Atmosphere.derive(ring: 5, cluster: nil, khadgamala: 70, element: .fire, at: v).glowAlpha
            XCTAssertTrue((0.12...0.5).contains(g), "glow alpha clamped for \(v)")
        }
    }

    func testHueAlwaysWrappedIntoRange() {
        for kp in 1...102 {
            for ring in [1, 2, 3, 4, 5, 6, 7, 8, 9] {
                let a = Atmosphere.derive(ring: ring, cluster: ring == 2 ? .inner : nil,
                                          khadgamala: kp, element: .ether, at: .dawn)
                XCTAssertTrue((0..<360).contains(a.hue.h), "hue out of range: \(a.hue.h)")
            }
        }
    }
}
