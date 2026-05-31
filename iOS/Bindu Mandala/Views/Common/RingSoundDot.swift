import SwiftUI

/// The discreet sound toggle that sits at the lower-left of every ring world.
/// Tap to start/stop the ring's tone. Each ring chooses its own accent color
/// and label ("ground" for Ring 1, "longing" for Ring 3, etc.).
struct RingSoundDot: View {
    @Binding var isOn: Bool
    var label: String
    var color: Color = .gold
    var onToggle: () -> Void

    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .stroke(color.opacity(isOn ? 0.70 : 0.30), lineWidth: 0.5)
                        .background(
                            Circle().fill(color.opacity(isOn ? 0.12 : 0.0))
                        )
                        .frame(width: 18, height: 18)
                    Circle()
                        .fill(isOn ? color : Color.cream.opacity(0.30))
                        .frame(width: 4, height: 4)
                }
                Text((isOn ? label : "silent").uppercased())
                    .font(.system(size: 8))
                    .tracking(2.2)
                    .foregroundStyle(Color.cream.opacity(0.40))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
