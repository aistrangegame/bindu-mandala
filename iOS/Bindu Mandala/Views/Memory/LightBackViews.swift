import SwiftUI
import SwiftData

// MARK: - Wave 6 · appreciation sent back to a moment he felt lost (C-1126)
//
// "The present can send energy back to adjust the way the past happened"
// (C-1101). Not a letter: light. He chooses the moment — a day, an hour — and
// whose light carries it (today's Śakti, unless he chooses another), holds,
// and the light travels back. A few words may go beside it, his own. Nothing
// marks the day as a bad one: in the Portrait, that day's bead simply warms.

struct SendLightBackView: View {
    let shaktis: [Shakti]

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var moment: Date = Date().addingTimeInterval(-86_400 * 30)
    @State private var kp: Int = DailyEnergyService.todaysPosition()
    @State private var words = ""
    @State private var holdStarted: Date?
    @State private var sent = false

    private static let holdSeconds: Double = 2.4

    private var her: Shakti? { shaktis.first { $0.khadgamalaPosition == kp } }
    private var accent: Color { her.map { SeatLighting.accentBright(for: $0) } ?? Color.gold }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.06, green: 0.04, blue: 0.07).ignoresSafeArea()
                RadialGradient(colors: [accent.opacity(sent ? 0.5 : 0.18), .clear],
                               center: .bottom, startRadius: 0, endRadius: 520)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 1.6), value: sent)
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("A moment you felt lost")
                            .font(AppFont.sanskrit(24))
                            .foregroundStyle(Color.cream)
                        DatePicker("The moment", selection: $moment, in: ...Date(),
                                   displayedComponents: [.date, .hourAndMinute])
                            .tint(Color.gold)
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.cream.opacity(0.85))
                        HStack {
                            Text("her light")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.7))
                            Picker("Whose light", selection: $kp) {
                                ForEach(shaktis) { s in
                                    if let p = s.khadgamalaPosition { Text(s.name).tag(p) }
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.gold)
                            Spacer(minLength: 0)
                        }
                        TextField("", text: $words,
                                  prompt: Text("a few words beside the light, if you want them")
                                    .foregroundStyle(Color.cream.opacity(0.5)),
                                  axis: .vertical)
                            .font(AppFont.voice(17))
                            .foregroundStyle(Color.cream)
                            .tint(Color.gold)
                            .lineLimit(1...4)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))

                        holdToSend
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                    }
                    .padding(22)
                }
            }
            .navigationTitle("Light, sent back")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(sent ? "done" : "not now") { dismiss() }.tint(Color.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var holdToSend: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: holdStarted == nil || reduceMotion)) { tl in
            let p = holdStarted.map { min(1, tl.date.timeIntervalSince($0) / Self.holdSeconds) } ?? (sent ? 1 : 0)
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [accent.opacity(0.25 + 0.6 * p), .clear],
                                             center: .center, startRadius: 0, endRadius: 70))
                        .frame(width: 140, height: 140)
                        .blendMode(.plusLighter)
                    Circle()
                        .trim(from: 0, to: p)
                        .stroke(accent, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 84, height: 84)
                    BinduPoint(size: 8, color: accent)
                }
                .frame(width: 140, height: 140)
                .contentShape(Circle())
                .onLongPressGesture(minimumDuration: Self.holdSeconds, maximumDistance: 40,
                                    perform: send,
                                    onPressingChanged: { pressing in
                                        holdStarted = pressing && !sent ? Date() : nil
                                    })
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Hold to send light back to that moment")
                .accessibilityAddTraits(.isButton)
                .accessibilityAction { send() }
                Text(sent ? "It has gone back. It was always going to arrive." : "hold, and send it")
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color.cream.opacity(0.72))
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func send() {
        guard !sent else { return }
        holdStarted = nil
        Haptics.medium()
        guard CorrespondenceStore.shared.sendLight(to: moment, through: kp, words: words) != nil else { return }
        sent = true
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }
}

/// One light that went back: her light, the moment, and his words if any.
struct LightSentBackCard: View {
    let light: LightSentBack
    let shakti: Shakti?

    var body: some View {
        let accent = shakti.map { SeatLighting.accentBright(for: $0) } ?? Color.gold
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [accent.opacity(0.7), .clear],
                                         center: .center, startRadius: 0, endRadius: 20))
                    .frame(width: 40, height: 40)
                Circle().fill(Color.cream).frame(width: 5, height: 5)
            }
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("to \(RiverWords.day(light.moment))")
                    .font(AppFont.sanskrit(18))
                    .foregroundStyle(Color.cream)
                Text(light.words ?? "through \(shakti?.name ?? "her")")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.65))
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(accent.opacity(0.06)))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Wave 6 · the higher self's name, kept in Bindu memory (C-1325)

/// He closes his eyes, and the name that surfaces is kept — his words, on the
/// phone and in the one ledger, editable, used only as he chooses. Every name
/// he has kept stays in the history.
struct HigherSelfNameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var name = ""
    @State private var eyesClosed = false

    private var memory: BinduMemory { BinduMemory.shared }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.03, blue: 0.06).ignoresSafeArea()
                VStack(spacing: 26) {
                    Spacer(minLength: 20)
                    BinduPoint(size: 12)
                    if eyesClosed {
                        Text("Close your eyes. Ask for the name of your higher self, and let it surface.")
                            .font(AppFont.voice(19))
                            .foregroundStyle(Color.cream.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .padding(.horizontal, 30)
                        Button("I have it") {
                            Haptics.soft()
                            eyesClosed = false
                        }
                        .font(AppFont.voice(17))
                        .tint(Color.gold)
                        .frame(minHeight: 44)
                    } else {
                        if let kept = memory.higherSelfName {
                            Text(kept)
                                .font(AppFont.sanskrit(30))
                                .foregroundStyle(Color.gold)
                        }
                        TextField("", text: $name,
                                  prompt: Text("the name that surfaced").foregroundStyle(Color.cream.opacity(0.5)))
                            .font(AppFont.sanskrit(22))
                            .foregroundStyle(Color.cream)
                            .multilineTextAlignment(.center)
                            .tint(Color.gold)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
                            .padding(.horizontal, 30)
                        Button {
                            keep()
                        } label: {
                            Text("keep it")
                                .font(AppFont.sanskrit(20))
                                .foregroundStyle(Color.cream)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 50)
                                .background(Capsule().fill(Color.accentRed))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 40)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        Button("close my eyes first") {
                            Haptics.soft()
                            eyesClosed = true
                        }
                        .font(AppFont.voice(15))
                        .tint(Color.gold.opacity(0.8))
                        .frame(minHeight: 44)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Bindu memory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("close") { dismiss() }.tint(Color.gold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func keep() {
        guard memory.keep(name: name) != nil else { return }
        Haptics.medium()
        name = ""
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }
}
