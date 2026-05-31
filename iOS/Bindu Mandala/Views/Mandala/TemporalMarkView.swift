import SwiftUI

/// A single 6pt dot at the top of the screen, barely perceptible.
/// Color shifts with the TimeVariant. Never carries text — the practitioner
/// who looks for it knows what time the yantra is reading.
struct TemporalMarkView: View {
    let variant: TimeVariant

    var body: some View {
        Circle()
            .fill(variant.markColor)
            .opacity(0.5)
            .frame(width: 6, height: 6)
            .shadow(color: variant.markColor, radius: 4)
    }
}
