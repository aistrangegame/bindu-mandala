import SwiftUI
import SwiftData

// MARK: - Wave 6 · the Rite's openings (Arrival), its close (Offering · Carry),
// and the low-state door. See `Services/RiteOpenings.swift` for the law.

/// **Arrival** — the first of the six stations. The hour's call (dawn's Śṛṣṭi,
/// dusk's Saṃhāra), then his own *"Stop. Breathe. Remember."* (C-1303), then
/// the Sacred Pause's three breaths (C-1160). Then the nine beats begin. A
/// touch anywhere passes it — leaving is one gesture, never punished.
struct RiteOpeningView: View {
    let kind: RiteOpening.Kind
    /// Where the day stands in the year of a hundred and two, as light.
    let yearLight: Double
    let still: Bool
    let onDone: () -> Void
    /// Wave 6.1 · a way the hour offers (``RiteOpening/ways(_:)``), taken.
    var onWay: ((RiteOpening.HourWay) -> Void)? = nil

    private enum Step: Equatable { case call, stop, breath(Int), leaving }

    @State private var step: Step = .call
    @State private var lungs: CGFloat = 0.55
    @State private var shown = false
    @State private var done = false

    var body: some View {
        ZStack {
            ground
            Circle()
                .fill(RadialGradient(colors: [tint.opacity(0.32 * yearLight), tint.opacity(0)],
                                     center: .center, startRadius: 0, endRadius: 150))
                .frame(width: 300, height: 300)
                .scaleEffect(lungs)
                .accessibilityHidden(true)
            Circle()
                .stroke(Color.cream.opacity(0.5), lineWidth: 0.8)
                .frame(width: 150, height: 150)
                .scaleEffect(lungs)
                .opacity(isBreath ? 1 : 0)
                .accessibilityHidden(true)
            VStack(spacing: 14) {
                if let phase = RiteOpening.phaseWord(kind) {
                    Text(phase)
                        .font(AppFont.label(11))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.gold.opacity(0.75))
                }
                Spacer()
                Text(words)
                    .font(AppFont.sanskrit(28))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .opacity(shown ? 1 : 0)
                    .id(words)
                    .transition(.opacity)
                Spacer()
                // Wave 6.1 · a mode at its hour: the dawn's dream, the dusk's
                // offering, the junction's Sandhyā — found here, at the hour.
                if onWay != nil, !RiteOpening.ways(kind).isEmpty {
                    HStack(spacing: 20) {
                        ForEach(RiteOpening.ways(kind)) { way in
                            Button {
                                Haptics.light()
                                finish()
                                onWay?(way)
                            } label: {
                                Text(way.word)
                                    .font(AppFont.voice(15))
                                    .tracking(1.1)
                                    .foregroundStyle(Color.gold.opacity(0.72))
                                    .padding(.horizontal, 10)
                                    .frame(minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(way.spoken)
                        }
                    }
                    .opacity(shown ? 1 : 0)
                }
                Text("a touch passes")
                    .font(AppFont.label(11))
                    .tracking(2)
                    .foregroundStyle(Color.cream.opacity(0.5))
                    .padding(.bottom, 40)
            }
            .padding(.top, 70)
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { finish() }
        .accessibilityElement(children: .contain)
        .accessibilityAction(named: Text("Pass")) { finish() }
        .task { await walk() }
    }

    private var isBreath: Bool {
        if case .breath(_) = step { return true }
        return false
    }

    private var words: String {
        switch step {
        case .call: return RiteOpening.call(kind) ?? RiteOpening.stop
        case .stop: return RiteOpening.stop
        case .breath(let i): return RiteOpening.pause[min(max(0, i), RiteOpening.pause.count - 1)]
        case .leaving: return RiteOpening.pause[RiteOpening.pause.count - 1]
        }
    }

    /// Dawn warm, dusk cool — the phase of the day as the phase of the rings.
    private var tint: Color {
        switch kind {
        case .dawn:  return Color(red: 0.95, green: 0.62, blue: 0.40)
        case .dusk:  return Color(red: 0.48, green: 0.40, blue: 0.78)
        case .day:   return Color.gold
        case .night: return Color.accentRed
        }
    }

    private var ground: some View {
        let top: Color
        switch kind {
        case .dawn:  top = Color(red: 0.12, green: 0.05, blue: 0.06)
        case .dusk:  top = Color(red: 0.05, green: 0.04, blue: 0.10)
        case .day:   top = Color(red: 0.07, green: 0.04, blue: 0.04)
        case .night: top = Color(red: 0.03, green: 0.01, blue: 0.02)
        }
        return LinearGradient(colors: [top, Color.silenceGround], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }

    private func walk() async {
        RiteHooks.openingBegan()
        withAnimation(.easeInOut(duration: still ? 0.01 : 1.6)) { shown = true }
        if RiteOpening.call(kind) != nil {
            try? await Task.sleep(for: .seconds(4))
            guard !Task.isCancelled, !done else { return }
            withAnimation(.easeInOut(duration: 1)) { step = .stop }
        } else {
            step = .stop
        }
        try? await Task.sleep(for: .seconds(4))
        guard !Task.isCancelled, !done else { return }
        let half = RiteOpening.breathSeconds / 2
        for i in RiteOpening.pause.indices {
            withAnimation(.easeInOut(duration: 1)) { step = .breath(i) }
            if !still { withAnimation(.easeInOut(duration: half)) { lungs = 1 } }
            Haptics.soft()
            try? await Task.sleep(for: .seconds(half))
            guard !Task.isCancelled, !done else { return }
            if !still { withAnimation(.easeInOut(duration: half)) { lungs = 0.55 } }
            try? await Task.sleep(for: .seconds(half))
            guard !Task.isCancelled, !done else { return }
        }
        finish()
    }

    private func finish() {
        guard !done else { return }
        done = true
        onDone()
    }
}

// MARK: - Offering · Carry

/// The last two of the six stations, after she has been felt: her own
/// Appreciation Phrase returned to her (**Offering**), then her somatic line
/// handed into his day (**Carry**). Low on the glass, over the composed Rite,
/// and then gone — the Rite rests in Being-with.
struct RiteClosingStations: View {
    let offering: String?
    let carry: String?
    let still: Bool
    let onDone: () -> Void

    @State private var station: RiteStation = .offering
    @State private var shown = false

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(station == .offering ? "offering" : "carry")
                .font(AppFont.label(11))
                .tracking(3)
                .textCase(.uppercase)
                .foregroundStyle(Color.gold.opacity(0.75))
            if station == .offering {
                Text(offering ?? "")
                    .font(AppFont.sanskrit(24))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
                    .transition(.opacity)
            } else {
                Text(carry ?? "")
                    .font(AppFont.voice(18))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
                    .transition(.opacity)
            }
            if station == .carry {
                Text("into your day")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.6))
            }
            Spacer().frame(height: 210)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [.clear, Color.black.opacity(0.72)], startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .opacity(shown ? 1 : 0)
        .contentShape(Rectangle())
        .onTapGesture { onDone() }
        .accessibilityElement(children: .combine)
        .accessibilityAction(named: Text("Rest")) { onDone() }
        .task { await walk() }
    }

    private func walk() async {
        if offering == nil { station = .carry }
        withAnimation(.easeInOut(duration: still ? 0.01 : 1.6)) { shown = true }
        if station == .offering {
            try? await Task.sleep(for: .seconds(6))
            guard !Task.isCancelled else { return }
            if carry != nil {
                withAnimation(.easeInOut(duration: 1.2)) { station = .carry }
            } else {
                withAnimation(.easeInOut(duration: 1.6)) { shown = false }
                try? await Task.sleep(for: .seconds(1.7))
                if !Task.isCancelled { onDone() }
                return
            }
        }
        try? await Task.sleep(for: .seconds(8))
        guard !Task.isCancelled else { return }
        withAnimation(.easeInOut(duration: 1.6)) { shown = false }
        try? await Task.sleep(for: .seconds(1.7))
        if !Task.isCancelled { onDone() }
    }
}

// MARK: - The low-state door

/// One quiet line at the Rite's foot. It never changes, never counts, and is
/// there on every day — a door, not a diagnosis.
struct LowStateDoorButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: { Haptics.soft(); action() }) {
            Text(LowStateDoor.doorWords)
                .font(AppFont.voice(14))
                .tracking(0.8)
                .foregroundStyle(Color.cream.opacity(0.55))
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("I am low — your own words"))
    }
}

/// **The low-state door** (C-1002, C-1120). His own words, one at a time, from
/// everything he has written in the instrument: margin notes, the letters he
/// wrote her in the Well, river letters that may be read, the words he set
/// beside her witness pages. A sealed letter stays sealed — nothing here peeks.
/// Nothing asks him anything. A touch brings the next line; one word leaves.
/// It reads and writes nothing about his state.
struct LowStateDoorView: View {
    let onClose: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \ShaktiLetter.updatedAt) private var wellLetters: [ShaktiLetter]
    @State private var lines: [String] = []
    @State private var index = 0
    @State private var shown = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.09, green: 0.05, blue: 0.04), Color.silenceGround],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 18) {
                Text(LowStateDoor.heading)
                    .font(AppFont.label(11))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.gold.opacity(0.7))
                    .padding(.top, 70)
                Spacer()
                Circle()
                    .fill(Color.gold.opacity(0.85))
                    .frame(width: 7, height: 7)
                    .shadow(color: Color.gold.opacity(0.7), radius: 10)
                    .accessibilityHidden(true)
                Text(currentLine)
                    .font(AppFont.sanskrit(25))
                    .foregroundStyle(Color.cream.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 34)
                    .opacity(shown ? 1 : 0)
                    .id(index)
                Spacer()
                if lines.count > 1 {
                    Text("a touch, and another")
                        .font(AppFont.label(11))
                        .tracking(2)
                        .foregroundStyle(Color.cream.opacity(0.5))
                }
                ModeRestButton(action: onClose)
                    .padding(.bottom, 30)
            }
        }
        .preferredColorScheme(.dark)
        .contentShape(Rectangle())
        .onTapGesture { another() }
        .theEdgeWayOut(onOut: onClose)
        .accessibilityElement(children: .contain)
        .accessibilityAction(named: Text("Another")) { another() }
        .onAppear {
            lines = LowStateDoor.lines(from: sources(),
                                       practiceDay: DailyEnergyService.practiceDayIndex())
            withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 2)) { shown = true }
        }
    }

    /// The line standing now — his own words, or the door's one sentence when
    /// he has written nothing yet.
    private var currentLine: String {
        guard !lines.isEmpty else { return LowStateDoor.empty }
        return lines[index % lines.count]
    }

    private func another() {
        guard lines.count > 1 else { return }
        Haptics.soft()
        withAnimation(.easeInOut(duration: reduceMotion ? 0.01 : 1.2)) { index += 1 }
    }

    /// Everything he has written that may be read now.
    private func sources() -> [String] {
        var out: [String] = []
        out += MarginNoteStore(context: context).all().map(\.body)
        out += wellLetters.map(\.body)
        let now = Date()
        out += CorrespondenceStore.shared.letters.filter { $0.isReadable(at: now) }.map(\.body)
        out += RitesPractice.shared.allWitness.map(\.body)
        return out
    }
}
