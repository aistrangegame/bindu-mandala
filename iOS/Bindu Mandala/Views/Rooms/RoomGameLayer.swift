import SwiftUI

// MARK: - Wave 6 · B · her room's share of the game's structure

/// What the game's own structure adds inside her room, over the room and
/// beneath every touch but her point's: the Trinity's face where one is seated
/// (Gaia at Ahaṅkārākarṣiṇī, the Higher Self at Ātmākarṣiṇī), the activation
/// cycle (``ActivationCycleLayer``), and the Om's floor at her ring.
@MainActor
struct RoomGameLayer: View {
    let shakti: Shakti
    /// The rite has ended and he is inside.
    let entered: Bool

    private var kp: Int { shakti.khadgamalaPosition ?? shakti.position }
    private var ring: Int { shakti.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: kp) }
    private var seated: Bool { TrinityOfGuidance.face(at: .room(kp: kp)) != nil }

    var body: some View {
        ZStack {
            TrinityVoiceLayer(place: entered ? .room(kp: kp) : nil, delay: 2)
            // Where a face speaks, the cycle waits for its line to pass.
            ActivationCycleLayer(shakti: shakti, entered: entered,
                                 startDelay: seated ? 16 : 5)
        }
        .onAppear { SoundConductor.shared.setDepth(ring) }
    }
}
