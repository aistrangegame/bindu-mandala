import SwiftUI

// MARK: - The Road: the 33 in their order, as one camera path over the yantra
//
// Charter II §2: *the Road (the 33 in order). Centre → perimeter → spiralling
// back to the centre.* The Map's Book Position is exactly that walk: the Bindu
// at the centre; out to the Bhūpura for Mūlādhāra and the energy rings; the
// Shadow corridor between the third and fourth; the body in rings four to six;
// Armin's gate; the mind in the seventh; the summit in the eighth; Lalitā at
// the centre again. This file turns that order into stops for the Mandala's own
// camera — the same `MandalaCamera` the pinch drives, so the Road is a way
// *through* the one yantra, never a second screen.
//
// Pure: a stop is a world point and a scale, computed from the bake and the
// seats on the phone. `ChakraRoadTests` walks it.
enum ChakraRoad {

    struct Stop: Equatable {
        let chakra: Chakra33
        /// Where the camera looks, in world coordinates (Bindu at the origin).
        let world: CGPoint
        /// How near it stands. Seats are met close; rings and thresholds wide.
        let scale: CGFloat
    }

    /// Scales, chosen so a stop frames what it is: a seat and its neighbours;
    /// a ring's arc; the whole of a crossing; the point.
    static let seatScale: CGFloat = 2.5
    static let centreScale: CGFloat = 3.0

    /// The stops, in Road order. A chakra with nowhere to stand (a malformed
    /// row) is passed over rather than invented a place.
    static func stops(_ chakras: [Chakra33], seats: [Int: CGPoint], in size: CGSize) -> [Stop] {
        var out: [Stop] = []
        // The angle the walk is at — rings and thresholds are met where the
        // spiral has carried it, so the path keeps turning rather than jumping
        // back to twelve o'clock.
        var heading: CGFloat = -.pi / 2
        let fitRadius = max(min(size.width, size.height) * 0.42, 1)

        for c in chakras.sorted(by: { $0.road < $1.road }) {
            switch c.address {
            case .centre:
                out.append(Stop(chakra: c, world: .zero, scale: MandalaCamera.clamp(centreScale)))
            case .seat:
                guard let kp = c.kp.first,
                      let p = ChakraConstellation.point(kp: kp, seats: seats) else { continue }
                heading = atan2(p.y, p.x)
                out.append(Stop(chakra: c, world: p, scale: MandalaCamera.clamp(seatScale)))
            case .ring:
                guard let ring = c.avarana else { continue }
                let r = MandalaWorld.ringRadius(ring)
                if !c.kp.isEmpty {
                    let pts = ChakraConstellation.points(of: c, seats: seats)
                    guard !pts.isEmpty else { continue }
                    let mid = pts[pts.count / 2]
                    heading = atan2(mid.y, mid.x)
                    // Frame the arc it holds: its span, with air round it.
                    let xs = pts.map(\.x), ys = pts.map(\.y)
                    let span = max((xs.max() ?? 0) - (xs.min() ?? 0),
                                   (ys.max() ?? 0) - (ys.min() ?? 0), 90)
                    out.append(Stop(chakra: c, world: mid,
                                    scale: MandalaCamera.clamp(fitRadius * 1.6 / span)))
                } else {
                    // A presiding form: the whole ring, seen from its centre.
                    out.append(Stop(chakra: c, world: .zero,
                                    scale: MandalaCamera.clamp(fitRadius / max(r, 1))))
                }
            case .threshold:
                guard let r = ChakraConstellation.thresholdRadius(c) else { continue }
                // Stand on the crossing, a quarter turn on from where the walk was.
                heading += .pi / 2
                let p = CGPoint(x: r * cos(heading), y: r * sin(heading))
                out.append(Stop(chakra: c, world: p,
                                scale: MandalaCamera.clamp(fitRadius * 0.9 / max(r * 0.55, 1))))
            }
        }
        return out
    }

    /// The camera that stands at a stop: the point a little above the middle of
    /// the glass, so the Road's words have the foot of it.
    static func camera(for stop: Stop, in size: CGSize) -> MandalaCamera {
        let s = stop.scale
        let c = MandalaWorld.center
        return MandalaCamera(scale: s,
                             tx: size.width / 2 - (c + stop.world.x) * s,
                             ty: size.height * 0.42 - (c + stop.world.y) * s)
    }

    /// How long the camera travels between two stops: longer for a longer way,
    /// never shorter than a breath's out-breath, never longer than a full breath.
    static func travel(from a: Stop?, to b: Stop) -> Double {
        guard let a else { return 1.8 }
        let d = hypot(a.world.x - b.world.x, a.world.y - b.world.y)
        let zoom = abs(log(Double(max(a.scale, 0.01) / max(b.scale, 0.01))))
        return min(4.0, max(2.0, 2.0 + Double(d) / 260 + zoom * 0.6))
    }

    /// How long the walk rests at a stop: one breath, and a little longer at
    /// the two thresholds and at the point — the places that are crossings.
    static func dwell(at stop: Stop) -> Double {
        switch stop.chakra.kind {
        case .shadow, .armin, .bindu: return 6.5
        default: return stop.chakra.road == 33 ? 7.0 : 5.0
        }
    }
}
