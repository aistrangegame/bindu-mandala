import SwiftUI

/// Wave 6 · the voice door on every page that takes his own word. One touch
/// begins keeping his voice; a second sets it down — the sound kept, and the
/// words he said laid onto the page for him to read, correct or keep.
struct VoiceWordButton: View {
    @ObservedObject var capture: SpeechCapture
    /// The kept file and the words heard in it.
    let onSetDown: (_ file: String, _ words: String) -> Void

    var body: some View {
        Button {
            Haptics.medium()
            Task { @MainActor in
                if capture.state == .recording {
                    if let kept = await capture.end() { onSetDown(kept.file, kept.words) }
                } else {
                    _ = await capture.begin()
                }
            }
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(Color.gold.opacity(0.6), lineWidth: 0.8)
                        .frame(width: 26, height: 26)
                    Circle()
                        .fill(capture.state == .recording ? Color.accentRed : Color.gold.opacity(0.55))
                        .frame(width: capture.state == .recording ? 14 : 8,
                               height: capture.state == .recording ? 14 : 8)
                }
                Text(label)
                    .font(AppFont.voice(15))
                    .foregroundStyle(Color.cream.opacity(0.78))
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(capture.state == .settingDown)
        .accessibilityLabel(label)
    }

    private var label: String {
        switch capture.state {
        case .idle:        return "speak it"
        case .recording:   return "set my voice down"
        case .settingDown: return "listening for your words…"
        case .refused:     return "the microphone is closed — write it"
        }
    }
}

/// His own voice, played back. Nothing else is ever heard here.
struct VoicePlayButton: View {
    let file: String
    @StateObject private var playback = VoicePlayback()

    var body: some View {
        Button {
            Haptics.light()
            if playback.playing { playback.stop() } else { playback.play(file) }
        } label: {
            Text(playback.playing ? "stop your voice" : "hear your voice")
                .font(AppFont.voice(14))
                .tracking(0.6)
                .foregroundStyle(Color.gold.opacity(0.85))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onDisappear { playback.stop() }
    }
}
