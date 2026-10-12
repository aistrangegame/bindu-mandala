import SwiftUI
import SwiftData

/// Three Codex concepts on her screen (Wave 5), each a verb rather than a page:
///
///   • **The everyday doorway** (C-1337) — her element as a plain touch of the
///     world (heat, water, earth, breath, space), and one line from her own row
///     to walk through it with. Shown only when her row holds a line.
///   • **The seal his hand holds** (C-1237) — the first meeting is the long
///     process; after that, his hand held still on her seal calls her back. His
///     hand, never hers: nothing here draws a figure — a ring of light fills
///     under his touch, and her own Appreciation Phrase arrives.
///   • **The Wager** (A12), reshaped in Wave 6 by C-1195 — "she might appear
///     today", noticed in passing if he wishes; nothing watched for, nothing
///     asked.
///
/// It stands in the scroll between her appreciation and her embodiment, above
/// the library, and is the same height whether or not she has ever been felt.
struct HerDoorwaysSection: View {
    let shakti: Shakti

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var holdProgress: CGFloat = 0
    @State private var called = false
    @State private var holding = false

    private var wagers: WagerStore { WagerStore.shared }

    private var atmo: Atmosphere { Atmosphere.derive(from: shakti) }
    private var kp: Int? { shakti.khadgamalaPosition }

    private var doorway: SensoryDoorway? { SensoryDoorway.forTattva(shakti.tattva) }
    private var doorwayLine: String? {
        SensoryDoorway.line(somaticSignature: shakti.somaticPoetry, somaticPrompt: shakti.somatic)
    }

    /// What she says when called back: her Appreciation Phrase, else her
    /// recognition phrase — her row's words either way.
    private var calledWords: String? {
        for raw in [shakti.appreciationPhrase ?? "", shakti.recognitionPhrase] {
            let t = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            if let doorway = doorway, let line = doorwayLine {
                doorwayBlock(doorway, line: line)
            }
            sealBlock
            if kp != nil { wagerBlock }
        }
        .padding(.top, 30)
    }

    // MARK: The doorway

    private func doorwayBlock(_ doorway: SensoryDoorway, line: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(doorway.words.uppercased())
                .font(AppFont.label(11))
                .tracking(2.6)
                .foregroundStyle(atmo.accentBright)
            Text(line)
                .font(AppFont.voice(17))
                .foregroundStyle(Color.cream.opacity(0.82))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: The seal

    private var sealBlock: some View {
        VStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [atmo.glow.opacity(0.9), .clear],
                                         center: .center, startRadius: 0,
                                         endRadius: 46 + 30 * holdProgress))
                    .frame(width: 120, height: 120)
                    .opacity(0.4 + 0.6 * Double(holdProgress))
                Circle()
                    .stroke(atmo.accentSoft, lineWidth: 0.8)
                    .frame(width: 64, height: 64)
                Circle()
                    .trim(from: 0, to: holdProgress)
                    .stroke(atmo.accentBright, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 64, height: 64)
                    .shadow(color: atmo.accentBright, radius: 6 * holdProgress)
                Circle()
                    .fill(called ? atmo.accentBright : atmo.accent.opacity(0.7))
                    .frame(width: called ? 14 : 8, height: called ? 14 : 8)
                    .shadow(color: atmo.accentBright, radius: called ? 14 : 4)
            }
            .frame(width: 120, height: 120)
            .contentShape(Circle())
            .onLongPressGesture(minimumDuration: 2.4, maximumDistance: 30, perform: {
                callHerBack()
            }, onPressingChanged: { pressing in
                holding = pressing
                if pressing {
                    Haptics.soft()
                    withAnimation(reduceMotion ? nil : .linear(duration: 2.4)) { holdProgress = 1 }
                } else if !called {
                    withAnimation(.easeOut(duration: 0.4)) { holdProgress = 0 }
                }
            })
            .accessibilityElement()
            .accessibilityLabel("Her seal. Hold it still to call her back.")
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { callHerBack() }

            if called, let words = calledWords {
                Text(words)
                    .font(AppFont.sanskrit(19))
                    .foregroundStyle(atmo.accentBright)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            } else {
                Text(holding ? "your hand holds her seal" : "hold her seal to call her back")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func callHerBack() {
        Haptics.medium()
        withAnimation(reduceMotion ? nil : .easeOut(duration: 1.2)) {
            called = true
            holdProgress = 1
        }
    }

    // MARK: The wager

    /// **Wave 6 · she might appear today** (C-1195). The Wager was an act of
    /// watching, and his Codex says energy recedes when it is watched — even in
    /// anticipation. So nothing here is placed and nothing asks: one line says
    /// she might appear today, and if he noticed her in passing he may say so,
    /// at any hour. No question waits for an answer, and there is no other
    /// answer to give.
    @ViewBuilder
    private var wagerBlock: some View {
        if let kp = kp {
            let noticed = wagers.noticedToday(for: kp) != nil
            VStack(alignment: .leading, spacing: 10) {
                Text("SHE MIGHT APPEAR TODAY")
                    .font(AppFont.label(11))
                    .tracking(2.6)
                    .foregroundStyle(atmo.accentBright)
                if noticed {
                    Text("You noticed her today.")
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity)
                } else {
                    Text("Not to be watched for — only, perhaps, noticed in passing.")
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                    wagerButton("I noticed her") { notice(kp) }
                }
            }
        }
    }

    private func wagerButton(_ words: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(words)
                .font(AppFont.voice(16))
                .tracking(0.6)
                .foregroundStyle(Color.gold)
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .background(Capsule().stroke(Color.gold.opacity(0.5), lineWidth: 0.6))
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func notice(_ kp: Int) {
        Haptics.soft()
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.8)) {
            _ = wagers.notice(for: kp)
        }
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }
}
