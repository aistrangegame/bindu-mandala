import SwiftUI

// MARK: - The room's own words, on screen
//
// Wave 1 · Slice D. ``RoomWords`` composes them; this sets them in the room the
// way Design's Axis does — where she is, her name and her quality at the top,
// and the room's own sentence low in the frame — and lets them arrive with the
// stay's own stages rather than all at once:
//
//   * **arriving** — he has just come in: the place, her name, her quality;
//   * **near** — the eye has settled: the room says what it is;
//   * **deep** — the premise has reversed: the sentence turns, and the name
//     steps back so the room can be the room.
//
// The stages are read off her chamber clock (``RoomWords/stage(chamberTime:)``)
// twice a second, and every change between them is a fade. With Reduce Motion
// on there is no timeline at all: the room is posed once at its settled instant
// (``RoomClock/stillInstant()``), and the words are the words of that instant.
//
// The room's sentence stands back while the descent speaks — the shaft has its
// own line, and two lines at once would be two voices.

struct RoomWordsView: View {

    let words: RoomWords
    let clock: RoomClock
    let reduceMotion: Bool
    /// Whether he has gone into her mark, where the descent's own line speaks.
    let descending: Bool

    @State private var shown = false

    // Design's Axis, in points: the place line 8.5 mono (raised to the 11 pt
    // floor), her name 28, her quality 13 italic (raised to 15 for the
    // phone), the room's sentence 18.5.
    private static let placeSize: CGFloat = 11
    private static let nameSize: CGFloat = 28
    private static let qualitySize: CGFloat = 15
    private static let sentenceSize: CGFloat = 18.5
    private static let placeTracking: CGFloat = placeSize * 0.32

    var body: some View {
        Group {
            if reduceMotion {
                layout(at: RoomWords.stage(chamberTime: clock.stillInstant()))
            } else {
                TimelineView(.periodic(from: .now, by: 0.5)) { timeline in
                    layout(at: RoomWords.stage(
                        chamberTime: clock.chamberTime(now: timeline.date.timeIntervalSinceReferenceDate)))
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            if reduceMotion {
                shown = true
            } else {
                withAnimation(.easeIn(duration: 2.4)) { shown = true }
            }
        }
    }

    private func layout(at stage: RoomWords.Stage) -> some View {
        VStack(spacing: 0) {
            heading
                .opacity(shown ? (stage == .deep ? 0.62 : 1) : 0)
                .padding(.top, 64)
                .padding(.horizontal, 28)
            Spacer(minLength: 0)
            sentence(at: stage)
                .padding(.horizontal, 34)
                .padding(.bottom, 190)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1.6), value: stage)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.9), value: descending)
    }

    private var heading: some View {
        VStack(spacing: 6) {
            Text(words.place)
                .font(AppFont.label(Self.placeSize))
                .textCase(.uppercase)
                .tracking(Self.placeTracking)
                .foregroundStyle(Color.gold)
                .opacity(0.85)
                .shadow(color: .black.opacity(0.9), radius: 14, y: 2)
            Text(words.name)
                .font(AppFont.sanskrit(Self.nameSize))
                .foregroundStyle(Color.cream)
                .shadow(color: .black.opacity(0.95), radius: 22, y: 2)
            if !words.quality.isEmpty {
                Text(words.quality)
                    .font(AppFont.voice(Self.qualitySize))
                    .foregroundStyle(Color.cream)
                    .opacity(0.72)
                    .shadow(color: .black.opacity(0.9), radius: 14, y: 2)
            }
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    /// The room's sentence: near and deep stand in the same place, and the turn
    /// between them is a crossfade.
    private func sentence(at stage: RoomWords.Stage) -> some View {
        let speaking = !descending
        return ZStack {
            Text(words.near)
                .font(AppFont.sanskrit(Self.sentenceSize))
                .foregroundStyle(Color.cream)
                .opacity(speaking && stage == .near ? 0.92 : 0)
                .accessibilityHidden(!(speaking && stage == .near))
            Text(words.deep)
                .font(AppFont.sanskrit(Self.sentenceSize))
                .foregroundStyle(Color.cream)
                .opacity(speaking && stage == .deep ? 0.92 : 0)
                .accessibilityHidden(!(speaking && stage == .deep))
        }
        .lineSpacing(Self.sentenceSize * 0.5)
        .multilineTextAlignment(.center)
        .shadow(color: .black.opacity(0.96), radius: 18, y: 2)
        .fixedSize(horizontal: false, vertical: true)
    }
}
