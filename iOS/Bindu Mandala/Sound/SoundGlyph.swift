import SwiftUI

// MARK: - Upgrade U1 · B · the sound glyph and the first touch
//
// `waves/upgrade/worlds/sound.md` S05, S06, S80. The glyph sits at Design's
// RingSoundToggle place (bottom 50, left 22): an 18 px circle with a 4 px dot,
// "silent" beneath it at 8 px, .22 opacity, .22em tracking when off; a 44 pt
// hit area. Tap: master on / off. Hold 600 ms: the Sound sheet (U2 opens it —
// `onHold`). VoiceOver: "Sound", on / off, "double-tap and hold for sound
// settings". U2 places it in every world and the constellation menu.

/// The sound glyph — `sound.md` S06.
struct SoundGlyph: View {
    @ObservedObject var settings: SoundSettings
    /// The tap (nil: the shared mixer's mute).
    var onTap: (() -> Void)? = nil
    /// The 600 ms hold: open the Sound sheet.
    var onHold: () -> Void = {}

    private func tap() {
        if let onTap { onTap() } else { SoundMixer.shared.toggleMute() }
    }

    static let hold: Double = 0.6
    static let hitArea: CGFloat = 44

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color.cream.opacity(settings.masterOn ? 0.55 : 0.22), lineWidth: 1)
                    .frame(width: 18, height: 18)
                Circle()
                    .fill(Color.cream.opacity(settings.masterOn ? 0.8 : 0.22))
                    .frame(width: 4, height: 4)
            }
            if !settings.masterOn {
                Text("silent")
                    .font(.system(size: 8))
                    .tracking(8 * 0.22)
                    .foregroundStyle(Color.cream.opacity(0.22))
            }
        }
        .frame(minWidth: Self.hitArea, minHeight: Self.hitArea)
        .contentShape(Rectangle())
        .onTapGesture { tap() }
        .onLongPressGesture(minimumDuration: Self.hold) { onHold() }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sound")
        .accessibilityValue(settings.masterOn ? "on" : "off")
        .accessibilityHint("Double-tap and hold for sound settings")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { tap() }
        .accessibilityAction(named: "Sound settings") { onHold() }
    }
}

/// Sound begins on the first touch anywhere (S05): attach once at the root.
/// The touch is only listened to — it never takes a gesture from the view.
struct SoundWakesOnFirstTouch: ViewModifier {
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            DragGesture(minimumDistance: 0).onChanged { _ in SoundMixer.shared.wakeOnFirstTouch() }
        )
    }
}

extension View {
    /// `sound.md` S05 — wake the mixer on the first touch.
    func soundWakesOnFirstTouch() -> some View { modifier(SoundWakesOnFirstTouch()) }
}
