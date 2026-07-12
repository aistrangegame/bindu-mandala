import XCTest
import SwiftUI
@testable import Bindu_Mandala

/// `SeatLighting` is the single seat-color source for the Field and the Portrait.
/// It must route through the Atmosphere engine (never `s.cluster.color`) so the
/// false `.inner` default the 86 carry never lights a seat (Ruling 7 / R3).
final class SeatLightingTests: XCTestCase {

    private func makeShakti(ring: Int, kp: Int, cluster: Cluster) -> Shakti {
        let s = Shakti(position: kp, name: "seat \(kp)", shortName: "", phonetic: "",
                       quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
                       bija: "", bodilyLocation: "", tattva: "", recognitionPhrase: "",
                       cluster: cluster, status: .mapped)
        s.ringNumber = ring
        s.khadgamalaPosition = kp
        return s
    }

    /// The adaptor is a pure pass-through to the engine — same input, same color.
    func testAccentMatchesAtmosphere() {
        let s = makeShakti(ring: 2, kp: 29, cluster: .inner)
        XCTAssertEqual(SeatLighting.accent(for: s), Atmosphere.derive(from: s).accent)
        XCTAssertEqual(SeatLighting.accentBright(for: s), Atmosphere.derive(from: s).accentBright)
        XCTAssertEqual(SeatLighting.glow(for: s), Atmosphere.derive(from: s).glow)
    }

    /// An 86 (Ring 5) carries `.inner` as `clusterRaw`'s default. Its seat must be
    /// lit by the ring-5 hue, not the inner-cluster color — the leak stays closed.
    func testThe86SeatIsNotTheInnerClusterColor() {
        let sister = makeShakti(ring: 5, kp: 70, cluster: .inner)
        let innerSeat = makeShakti(ring: 2, kp: 70, cluster: .inner)
        XCTAssertNotEqual(SeatLighting.accent(for: sister),
                          SeatLighting.accent(for: innerSeat),
                          "a Ring-5 seat must not borrow the .inner cluster color")
    }

    /// Two different 86 seats get different accents — the per-kp jitter means the
    /// Field is not a wall of one uniform default color.
    func testDistinctSeatsGetDistinctAccents() {
        let a = makeShakti(ring: 5, kp: 70, cluster: .inner)
        let b = makeShakti(ring: 5, kp: 71, cluster: .inner)
        XCTAssertNotEqual(SeatLighting.accent(for: a), SeatLighting.accent(for: b))
    }
}
