import SwiftUI
import SwiftData

// MARK: - Wave 6 · two Codex concepts on her page

/// **The one-page answer** (C-1279, *Life as a One-Page Answer*: take the full
/// journey or jump to the end; *"how big that page is, is up to us"*). At the
/// head of her page, her whole answer in one line — her own Appreciation
/// Phrase, else her quality, from her row — and beside it the other size of
/// the same page: her whole Home. Both are always there; which one he takes is
/// his. Nothing is remembered about the choice.
struct OnePageAnswerSection: View {
    let shakti: Shakti
    let onWhole: () -> Void

    static func line(appreciation: String?, quality: String) -> String? {
        for raw in [appreciation ?? "", quality] {
            let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
        }
        return nil
    }

    var body: some View {
        if let line = Self.line(appreciation: shakti.appreciationPhrase, quality: shakti.quality) {
            VStack(alignment: .center, spacing: 10) {
                Text("THE ONE-PAGE ANSWER")
                    .font(AppFont.label(11))
                    .tracking(2.6)
                    .foregroundStyle(Color.gold.opacity(0.7))
                Text(line)
                    .font(AppFont.sanskrit(22))
                    .foregroundStyle(Color.cream.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Button(action: { Haptics.medium(); onWhole() }) {
                    Text("or the whole of her home ›")
                        .font(AppFont.voice(15))
                        .tracking(0.8)
                        .foregroundStyle(Color.cream.opacity(0.6))
                        .padding(.horizontal, 12)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("The whole page — enter her home"))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 26)
        }
    }
}

/// **The hidden witness page** (C-1280, *The Witness Perspective*): a page
/// sealed in her Home that opens only after an intention, or an ask for help —
/// and then he writes his own perspective beside it.
///
/// The page is hers, from her own row (her Function — how she works), never
/// generated; when her row has none, the page is not offered. The seal opens
/// to a held ask, and closes again when he leaves her: it is opened by asking,
/// each time. What he writes beside it is his practice: kept on the phone in
/// ``RitesPractice`` (every save its own entry, nothing overwritten), and
/// mirrored to the ledger as `Witness Written` with his words in `Notes`.
struct HerWitnessPage: View {
    let shakti: Shakti

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase

    @State private var asked = false
    @State private var asking: CGFloat = 0
    @State private var draft = ""
    @State private var loaded = false
    @FocusState private var writing: Bool

    private var kp: Int? { shakti.khadgamalaPosition }

    static func page(function: String?, qualityDescription: String) -> String? {
        for raw in [function ?? "", qualityDescription] {
            let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
        }
        return nil
    }

    var body: some View {
        if let kp, let page = Self.page(function: shakti.shaktiFunction,
                                        qualityDescription: shakti.qualityDescription) {
            VStack(alignment: .leading, spacing: 14) {
                Text("HER WITNESS PAGE")
                    .font(AppFont.label(11))
                    .tracking(2.6)
                    .foregroundStyle(Color.gold.opacity(0.7))
                if asked {
                    opened(page, kp: kp)
                        .transition(.opacity)
                } else {
                    sealed
                        .transition(.opacity)
                }
            }
            .padding(.top, 30)
            .onChange(of: scenePhase) { _, phase in
                if phase != .active { keep(kp) }
            }
            .onDisappear { keep(kp) }
        }
    }

    // MARK: Sealed

    private var sealed: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.cream.opacity(0.3), lineWidth: 0.8)
                    .frame(width: 54, height: 70)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0))
                    p.addLine(to: CGPoint(x: 27, y: 22))
                    p.addLine(to: CGPoint(x: 54, y: 0))
                }
                .stroke(Color.cream.opacity(0.3), lineWidth: 0.8)
                .frame(width: 54, height: 70)
                Circle()
                    .trim(from: 0, to: asking)
                    .stroke(Color.gold, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 92, height: 92)
                Circle()
                    .fill(Color.accentRed.opacity(0.8))
                    .frame(width: 12, height: 12)
                    .shadow(color: Color.accentRed, radius: 6)
            }
            .frame(width: 110, height: 110)
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 1.8, maximumDistance: 30,
                                perform: { ask() },
                                onPressingChanged: { pressing in
                                    if pressing {
                                        Haptics.soft()
                                        withAnimation(reduceMotion ? nil : .linear(duration: 1.8)) { asking = 1 }
                                    } else if !asked {
                                        withAnimation(.easeOut(duration: 0.3)) { asking = 0 }
                                    }
                                })
            .accessibilityElement()
            .accessibilityLabel(Text("Her witness page, sealed. Hold to ask for help, and it opens."))
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { ask() }
            Text("sealed — it opens when you ask for help")
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private func ask() {
        Haptics.medium()
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 1.2)) { asked = true }
        if !loaded, let kp {
            draft = RitesPractice.shared.witness(for: kp)?.body ?? ""
            loaded = true
        }
    }

    // MARK: Opened

    private func opened(_ page: String, kp: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(page)
                .font(AppFont.voice(17))
                .foregroundStyle(Color.cream.opacity(0.85))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            Text("beside it, your own")
                .font(AppFont.label(11))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(Color.cream.opacity(0.55))
            TextEditor(text: $draft)
                .font(AppFont.voice(17))
                .foregroundStyle(Color.cream)
                .scrollContentBackground(.hidden)
                .focused($writing)
                .frame(minHeight: 120)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 6).fill(Color.cream.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.cream.opacity(0.18), lineWidth: 0.6))
                .accessibilityLabel(Text("Your perspective, beside her page"))
            Button(action: {
                keep(kp)
                writing = false
                Haptics.soft()
            }) {
                Text("keep it beside her page")
                    .font(AppFont.voice(15))
                    .tracking(0.6)
                    .foregroundStyle(Color.gold)
                    .padding(.horizontal, 16)
                    .frame(minHeight: 44)
                    .background(Capsule().stroke(Color.gold.opacity(0.5), lineWidth: 0.6))
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
        }
    }

    /// His words are kept whenever he leaves them — the button, leaving her,
    /// or the app going to the background. Blank or unchanged writes nothing.
    private func keep(_ kp: Int) {
        guard asked, loaded else { return }
        guard RitesPractice.shared.write(witness: draft, for: kp) != nil else { return }
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }
}
