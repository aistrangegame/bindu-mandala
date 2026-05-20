import Foundation

enum ShaktiStatus: String, CaseIterable, Codable, Hashable {
    case mapped
    case exploring
    case active
    case embodied

    var label: String {
        switch self {
        case .mapped:    return "Mapped"
        case .exploring: return "Exploring"
        case .active:    return "Active"
        case .embodied:  return "Embodied"
        }
    }

    var opacity: Double {
        switch self {
        case .mapped:    return 0.22
        case .exploring: return 0.44
        case .active:    return 0.76
        case .embodied:  return 1.0
        }
    }

    func advanced() -> ShaktiStatus {
        switch self {
        case .mapped:    return .exploring
        case .exploring: return .active
        case .active:    return .embodied
        case .embodied:  return .embodied
        }
    }
}
