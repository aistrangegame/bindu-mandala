import CoreGraphics
import Foundation

/// The static geometry of the Śrī Yantra as a coordinate space — where each of
/// the 102 seats sits, how wide each enclosure is, and who is threaded to whom.
///
/// World coordinates are centered on the Bindu at the origin `(0, 0)`; seats fall
/// within roughly `[-320, 320]`. `MandalaCamera` maps world → screen. Ported from
/// the `living-rite-mandala.jsx` prototype (`SY_*`), but seats are ordered by the
/// stored `khadgamalaPosition` (Airtable is the source of truth for the 86, per
/// the kp-ordering findings) rather than the prototype's data-file order.
enum MandalaWorld {
    /// Yantra radius in world px (the outer square reaches this).
    static let radius: CGFloat = 320
    /// The square wrapper the camera fits; the Bindu sits at its center.
    static let box: CGFloat = 760
    static let center: CGFloat = box / 2   // 380

    /// Per-enclosure radius (ring 1 outermost … ring 9 the Bindu at the center).
    static func ringRadius(_ ring: Int) -> CGFloat {
        switch ring {
        case 1: return 306
        case 2: return 268
        case 3: return 224
        case 4: return 178
        case 5: return 145
        case 6: return 116
        case 7: return 88
        case 8: return 52
        case 9: return 0
        default: return 0
        }
    }

    /// A seated Śakti and her world position.
    struct Seat: Identifiable {
        let shakti: Shakti
        let point: CGPoint
        var id: Int { shakti.khadgamalaPosition ?? shakti.position }
    }

    /// Place every Śakti in her enclosure. Within a ring, seats are ordered by
    /// `khadgamalaPosition` so the layout is deterministic and matches the "today"
    /// cycle. Ring 1 rides the outer square's perimeter; ring 9 is the Bindu;
    /// every other ring is evenly spaced on its circle from 12 o'clock clockwise.
    static func seats(from shaktis: [Shakti]) -> [Seat] {
        let byRing = Dictionary(grouping: shaktis) { $0.ringNumber ?? 2 }
        var out: [Seat] = []
        for (ring, members) in byRing {
            let sorted = members.sorted {
                ($0.khadgamalaPosition ?? $0.position) < ($1.khadgamalaPosition ?? $1.position)
            }
            let n = sorted.count
            for (idx, s) in sorted.enumerated() {
                let p: CGPoint
                if ring == 1 {
                    p = squarePerimeter(t: (CGFloat(idx) + 0.5) / CGFloat(n), half: ringRadius(1))
                } else if ring == 9 {
                    p = .zero
                } else {
                    let a = (CGFloat(idx) / CGFloat(n)) * 2 * .pi - .pi / 2
                    let r = ringRadius(ring)
                    p = CGPoint(x: r * cos(a), y: r * sin(a))
                }
                out.append(Seat(shakti: s, point: p))
            }
        }
        return out.sorted { $0.id < $1.id }
    }

    /// A point at fraction `t` (0…1) around the perimeter of a square of the given
    /// half-extent, starting at the top edge's left and going clockwise.
    static func squarePerimeter(t: CGFloat, half H: CGFloat) -> CGPoint {
        let frac = (t.truncatingRemainder(dividingBy: 1) + 1).truncatingRemainder(dividingBy: 1)
        let p = frac * 4
        let side = H * 2
        if p < 1 {
            let x = -H + p * side
            return CGPoint(x: x, y: -H)          // top edge: left → right
        } else if p < 2 {
            let y = -H + (p - 1) * side
            return CGPoint(x: H, y: y)           // right edge: top → bottom
        } else if p < 3 {
            let x = H - (p - 2) * side
            return CGPoint(x: x, y: H)           // bottom edge: right → left
        } else {
            let y = H - (p - 3) * side
            return CGPoint(x: -H, y: y)          // left edge: bottom → top
        }
    }

    /// The energies a Śakti is threaded to for the constellation. Ring 2 gathers by
    /// cluster (Inner Instrument, Sense Streams, …); every other ring is its own
    /// family. Excludes herself. Ring 2's cluster taxonomy is legitimate here — she
    /// is one of the 16 who carry it (Ruling 7).
    static func family(of shakti: Shakti, in shaktis: [Shakti]) -> [Shakti] {
        let ring = shakti.ringNumber ?? 2
        let myKp = shakti.khadgamalaPosition ?? shakti.position
        let cluster = shakti.cluster
        return shaktis.filter { other in
            let otherRing: Int = other.ringNumber ?? 2
            let otherKp: Int = other.khadgamalaPosition ?? other.position
            guard otherRing == ring, otherKp != myKp else { return false }
            // Ring 2 threads by cluster family; every other ring threads whole.
            return ring == 2 ? (other.cluster == cluster) : true
        }
    }
}
