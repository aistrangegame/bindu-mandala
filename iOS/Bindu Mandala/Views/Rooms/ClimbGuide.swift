import SwiftUI

// MARK: - Wave 6 · B · the Player axis on the climb
//
// Bindu → Lalitā, the same first-person voice at two stages of awakeness: at
// the foot of the climb the play that does not yet know itself (*"I am play
// before play knows itself as play"*), at its summit the play that does (*"I
// am the play that knows it is play"*). Each speaks its own Identity line once
// a practice day (``TrinityOfGuidance``). While her room is open over the climb
// the climb says nothing — the room is where he is.

@MainActor
struct ClimbGuide: View {
    /// The world he is standing in.
    let ring: Int
    /// Her room is open over the climb.
    let roomOpen: Bool

    var body: some View {
        TrinityVoiceLayer(place: roomOpen ? nil : .climb(ring: ring), delay: 2.4)
            .onAppear { SoundConductor.shared.setDepth(ring) }
            .onChange(of: ring) { _, r in SoundConductor.shared.setDepth(r) }
    }
}
