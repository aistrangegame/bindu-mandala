import SwiftUI
import SwiftData

/// The Recognition Moment — full-screen takeover after "I feel her".
/// Two acts, separated by a thin gold hairline:
///   Act 1: "she was felt here · [time]"      (muted, sans, uppercase)
///   Act 2: "and she felt you back · [time+3s]" (italic Cormorant, gold)
struct RecognitionMomentView: View {
    let shakti: Shakti
    @Binding var isPresented: Bool

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var nameVisible = false
    @State private var phraseVisible = false
    @State private var act1Visible = false
    @State private var act2Visible = false
    @State private var noteCardVisible = false
    @State private var act1Time: Date = .now
    @State private var act2Time: Date = .now.addingTimeInterval(3)
    @State private var note: String = ""
    @State private var hasLogged = false

    var body: some View {
        ZStack {
            Color.darkVeil.ignoresSafeArea()

            // Giant bīja behind everything
            Text(shakti.bija)
                .font(.custom(AppFont.cormorant, size: 360))
                .foregroundStyle(Color.gold.opacity(0.065))
                .offset(y: -8)
                .allowsHitTesting(false)

            // Ripple rings (4, staggered)
            ForEach(0..<4, id: \.self) { i in
                let delays: [Double] = [0, 1.1, 2.2, 3.3]
                let opacities: [Double] = [0.35, 0.29, 0.23, 0.17]
                RippleRingView(
                    delay: delays[i],
                    color: Color.gold.opacity(opacities[i])
                )
            }

            // Center: name + divider + appreciation phrase
            VStack(spacing: 0) {
                Spacer()

                Text(shakti.name)
                    .font(.custom(AppFont.cormorant, size: 38))
                    .foregroundStyle(Color.cream)
                    .tracking(3.8)
                    .multilineTextAlignment(.center)
                    .opacity(nameVisible ? 1 : 0)
                    .padding(.horizontal, 44)
                    .padding(.bottom, 28)

                Rectangle()
                    .fill(Color.gold.opacity(0.5))
                    .frame(width: 32, height: 0.5)
                    .opacity(phraseVisible ? 1 : 0)
                    .padding(.bottom, 28)

                Text(shakti.recognitionPhrase)
                    .font(.custom(AppFont.cormorantItalic, size: 24))
                    .foregroundStyle(Color.cream)
                    .tracking(0.5)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 44)
                    .opacity(phraseVisible ? 1 : 0)

                Spacer()
            }

            // Bottom block: two acts of recognition + optional note card
            VStack(spacing: 0) {
                Spacer()

                // Act 1
                Text("she was felt here · \(timeString(act1Time))".uppercased())
                    .font(.system(size: 11))
                    .tracking(1.8)
                    .foregroundStyle(Color.cream.opacity(0.35))
                    .padding(.bottom, 10)
                    .opacity(act1Visible ? 1 : 0)

                // Hairline divider between acts
                Rectangle()
                    .fill(Color.gold.opacity(0.4))
                    .frame(width: 22, height: 0.5)
                    .padding(.bottom, 10)
                    .opacity(act2Visible ? 1 : 0)

                // Act 2 — and she felt you back
                Text("and she felt you back · \(timeStringWithSeconds(act2Time))")
                    .font(.custom(AppFont.cormorantItalic, size: 14))
                    .foregroundStyle(Color.gold)
                    .tracking(0.7)
                    .padding(.bottom, 22)
                    .opacity(act2Visible ? 1 : 0)

                // Optional note card
                if noteCardVisible {
                    NoteCard(text: $note)
                        .frame(maxWidth: 280)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .padding(.bottom, 30)
                }

                Text("Tap anywhere to close".uppercased())
                    .font(.system(size: 10))
                    .tracking(2)
                    .foregroundStyle(Color.cream.opacity(0.18))
                    .padding(.bottom, 36)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Don't allow dismissing the ceremony before her name has arrived —
            // the recognition has already been logged in stage(), so an early
            // tap would cost the user the visual without changing the record.
            guard nameVisible else { return }
            dismiss()
        }
        .onAppear(perform: stage)
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    private func stage() {
        guard !hasLogged else { return }
        hasLogged = true
        act1Time = .now
        act2Time = act1Time.addingTimeInterval(3)

        let store = RecognitionLogStore(context: context)
        store.record(position: shakti.shaktiPositionValue, gesture: .felt)

        if reduceMotion {
            nameVisible = true; phraseVisible = true
            act1Visible = true; act2Visible = true
            noteCardVisible = true
            return
        }

        withAnimation(.easeInOut(duration: 1.8).delay(0.3)) { nameVisible = true }
        withAnimation(.easeInOut(duration: 1.8).delay(0.9)) { phraseVisible = true }
        withAnimation(.easeOut(duration: 1.0).delay(2.6))  { act1Visible = true }
        withAnimation(.easeInOut(duration: 1.4).delay(4.1)) {
            act2Visible = true
            noteCardVisible = true
        }
    }

    private func dismiss() {
        // Persist note if user wrote anything.
        if !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let store = RecognitionLogStore(context: context)
            if let latest = store.latest(), latest.shaktiPosition == shakti.shaktiPositionValue {
                latest.note = note
                try? context.save()
            }
        }
        isPresented = false
    }

    private func timeString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: d)
    }

    private func timeStringWithSeconds(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm:ss"
        return f.string(from: d)
    }
}

private struct NoteCard: View {
    @Binding var text: String
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if text.isEmpty && !focused {
                Text("What did you notice?")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .foregroundStyle(Color.cream.opacity(0.3))
                    .tracking(0.5)
            }
            TextField("", text: $text, axis: .vertical)
                .font(.custom(AppFont.cormorantItalic, size: 14))
                .foregroundStyle(Color.cream.opacity(0.85))
                .focused($focused)
                .lineLimit(1...4)
                .tint(Color.gold)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.cream.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.cream.opacity(0.12), lineWidth: 0.5)
                )
        )
        // Don't dismiss the screen when tapping inside the note card.
        .contentShape(Rectangle())
        .onTapGesture { focused = true }
    }
}

private extension Shakti {
    /// Convenience so RecognitionMomentView can record without typing `.position` everywhere.
    var shaktiPositionValue: Int { position }
}
