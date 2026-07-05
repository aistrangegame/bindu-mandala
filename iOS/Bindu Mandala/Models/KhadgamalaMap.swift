import Foundation

/// The canonical mapping between a Śakti's Khaḍgamālā position (1–102) and her
/// place in the nine āvaraṇas. Pure and deterministic — no SwiftData, no
/// Airtable — so both `AirtableService` reconcile and the test suite share one
/// source of truth for the ring geometry.
///
/// Ring spans (Khaḍgamālā order):
///   Ring 1  Bhūpura           1–28   (28 forces)
///   Ring 2  16-Petal Lotus    29–44  (16 Karṣiṇīs)
///   Ring 3  8-Petal Lotus     45–52  (8 Anaṅgas)
///   Ring 4  14 Triangles      53–66  (14)
///   Ring 5  10 Outer Tris     67–76  (10)
///   Ring 6  10 Inner Tris     77–86  (10)
///   Ring 7  Vāk Chamber       87–98  (12)
///   Ring 8  Mūla Trikoṇa      99–101 (3)
///   Ring 9  Bindu             102    (Lalitā)
enum KhadgamalaMap {

    /// Total Khaḍgamālā forces across all nine āvaraṇas.
    static let total = 102

    /// Ring 1–9 for a Khaḍgamālā position, or 0 when out of range.
    static func ringNumber(forKhadgamala kp: Int) -> Int {
        switch kp {
        case 1...28:   return 1
        case 29...44:  return 2
        case 45...52:  return 3
        case 53...66:  return 4
        case 67...76:  return 5
        case 77...86:  return 6
        case 87...98:  return 7
        case 99...101: return 8
        case 102:      return 9
        default:       return 0
        }
    }

    /// The Khaḍgamālā position immediately *before* a ring begins — subtract it
    /// from a global position to get the per-ring index (1-based).
    static func ringStartOffset(_ ring: Int) -> Int {
        switch ring {
        case 1: return 0
        case 2: return 28
        case 3: return 44
        case 4: return 52
        case 5: return 66
        case 6: return 76
        case 7: return 86
        case 8: return 98
        case 9: return 101
        default: return 0
        }
    }

    /// Per-ring index (1-based) for a Khaḍgamālā position, or 0 when out of range.
    static func perRingIndex(forKhadgamala kp: Int) -> Int {
        let ring = ringNumber(forKhadgamala: kp)
        guard ring > 0 else { return 0 }
        return kp - ringStartOffset(ring)
    }
}
