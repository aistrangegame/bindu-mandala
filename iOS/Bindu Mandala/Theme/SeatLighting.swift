import SwiftUI

/// The single source for "what color is this Śakti's seat" — her Atmosphere
/// accent, derived through the engine so the false `.inner` cluster default the
/// 86 carry (`clusterRaw` defaults to `.inner`) never leaks (Ruling 7 / R3).
/// The Field and any other seat surface read from here, never `s.cluster.color`.
enum SeatLighting {
    static func accent(for s: Shakti) -> Color { Atmosphere.derive(from: s).accent }
    static func accentBright(for s: Shakti) -> Color { Atmosphere.derive(from: s).accentBright }
    static func glow(for s: Shakti) -> Color { Atmosphere.derive(from: s).glow }
}
