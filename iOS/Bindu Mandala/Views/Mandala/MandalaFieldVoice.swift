import SwiftUI

// MARK: - Wave 2 · the Mandala sounds
//
// The Reading's §3 row *"Sound restraint"* — *"Mandala sound opt-in and off by
// default"* — is lifted: the Mandala's sound is **on by default**, the silent
// switch is honoured (``RingFieldVoice`` sounds through an `.ambient` session),
// and the ♪ control still governs it. What sounds is the enclosure the glass has
// fallen into, in its own ring's voice — the six voices `RingAudioService` had
// carried, unheard, since the Ring Worlds were cut — and the point's own 136.1
// while the whole instrument is in view.
//
// Two of the Ring Worlds' mechanisms live here as sound, where the glass is:
//   • **Ring 7** — falling into the Vāk ring strikes the twelve-voice chord.
//   • **Ring 8** — the triad glides into one when the glass has been still a
//     while (the Tratak gaze) and opens again when he moves.
// And the fall into the Bindu sounds the Shepard tone (Ring 9, Praveśa).

/// The Mandala's voice, as one modifier on its glass.
@MainActor
struct MandalaFieldVoice: ViewModifier {
    /// The enclosure the glass has fallen into; `0` outside the yantra.
    let ring: Int
    /// The ♪ control.
    let on: Bool
    /// Whether the Bindu has opened (Lalitā's source).
    let descent: Bool
    /// How long the glass has lain untouched.
    let stillSeconds: Double

    /// How long the glass must be still before the triad glides into one.
    static let unionAfter: Double = 6

    func body(content: Content) -> some View {
        content
            .onAppear { sound() }
            .onChange(of: ring) { old, new in
                sound()
                if on, !descent, new == 7, old < 7 { RingFieldVoice.shared.chord() }
            }
            .onChange(of: on) { _, _ in sound() }
            .onChange(of: descent) { _, opened in
                if opened, on { RingFieldVoice.shared.fallThrough() }
                sound()
            }
            .onChange(of: stillSeconds >= Self.unionAfter) { _, still in
                guard on, ring == 8 else { return }
                RingFieldVoice.shared.unite(still ? 1 : 0)
            }
            .onDisappear {
                guard !AppRuntime.isUnitTesting else { return }
                RingFieldVoice.shared.silence()
            }
    }

    private func sound() {
        guard !AppRuntime.isUnitTesting else { return }
        guard on else {
            RingFieldVoice.shared.silence()
            return
        }
        // At the source the enclosures fall quiet; only the fall's Shepard
        // tone carries through, and lets go as she arrives.
        RingFieldVoice.shared.sound(descent ? [:] : RingFieldVoice.want(enteredRing: ring))
    }
}

extension View {
    /// The Mandala's voice — see ``MandalaFieldVoice``.
    @MainActor
    func mandalaFieldVoice(ring: Int, on: Bool, descent: Bool, stillSeconds: Double) -> some View {
        modifier(MandalaFieldVoice(ring: ring, on: on, descent: descent, stillSeconds: stillSeconds))
    }
}
