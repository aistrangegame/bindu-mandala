import SwiftUI

enum Cluster: String, CaseIterable, Codable, Hashable {
    case inner      // Inner Instrument (positions 1–3)
    case tanmatra   // Sense Streams (4–8)
    case citta      // Citta (9)
    case stability  // Stability Powers (10–13)
    case selfBody   // Self · Body · Immortality (14–16)

    var label: String {
        switch self {
        case .inner:     return "Inner Instrument"
        case .tanmatra:  return "Sense Streams"
        case .citta:     return "Citta"
        case .stability: return "Stability Powers"
        case .selfBody:  return "Self · Body · Immortality"
        }
    }

    var color: Color {
        switch self {
        case .inner:     return .clusterInner
        case .tanmatra:  return .clusterSense
        case .citta:     return .clusterCitta
        case .stability: return .clusterStability
        case .selfBody:  return .clusterSelf
        }
    }

    /// Position 1–16 → cluster
    static func forPosition(_ pos: Int) -> Cluster {
        switch pos {
        case 1...3:   return .inner
        case 4...8:   return .tanmatra
        case 9:       return .citta
        case 10...13: return .stability
        case 14...16: return .selfBody
        default:      return .inner
        }
    }
}
