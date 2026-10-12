import SwiftUI
import SwiftData
import UIKit

// MARK: - The day layer, in the Rite
//
// Wave 3 (`waves/wave-3-origin.md`, `Services/RiteDay.swift`). Four quiet things
// folded into the Rite around today's Śakti, leaving its nine-beat arrival as
// Wave 1 built it:
//
//   · **grace** — one line, low on the glass, after she has arrived;
//   · **the pulse** — a heartbeat under the thumb on "I feel her", on the days
//     she lives in rings four to eight; never named, never explained;
//   · **three doors** — under the foot, chosen by the hour, one always the
//     one-second floor;
//   · **the floor** and **the close** — the two doors that open a moment of
//     their own.

// MARK: Grace

/// Grace's one line. Arrives a breath after the foot of the Rite, never
/// tappable, and only when a real moment of hers is there to return. Once it
/// has spoken it rests (`GraceChannel.restDays`).
struct RiteGraceLine: View {
    let shakti: Shakti
    let still: Bool

    @Query(sort: \Shakti.khadgamalaPosition) private var roster: [Shakti]
    @State private var line: GraceChannel.Line?
    @State private var shown = false

    var body: some View {
        Group {
            if let line {
                Text(line.text)
                    .font(AppFont.voice(15))
                    .foregroundStyle(Color.cream.opacity(0.66))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .opacity(shown ? 1 : 0)
                    .allowsHitTesting(false)
            } else {
                // Nothing to return: a hairline that holds the listener, so the
                // task below always has a view to run on.
                Color.clear
                    .frame(width: 1, height: 0)
                    .accessibilityHidden(true)
            }
        }
        .task(id: shakti.khadgamalaPosition ?? shakti.position) { await listen() }
    }

    private func listen() async {
        guard line == nil else { return }
        // Silence first: grace never interrupts an arrival, and never speaks
        // inside its rest.
        guard GraceChannel.lastSurfaced().map({ Date().timeIntervalSince($0) > 3600 * 24 }) ?? true
        else { return }
        let rows = await AirtableService.shared.graceRows()
        guard !Task.isCancelled else { return }

        let ring = shakti.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: shakti.khadgamalaPosition ?? 0)
        var names: [String: String] = [:]
        var sisters: Set<String> = []
        for s in roster {
            guard let rec = s.airtableRecordId else { continue }
            names[rec] = s.name
            if (s.ringNumber ?? 0) == ring, rec != shakti.airtableRecordId { sisters.insert(rec) }
        }
        let fromLedger = GraceChannel.choose(rows: rows,
                                             herRecordId: shakti.airtableRecordId,
                                             sisterRecordIds: sisters,
                                             names: names,
                                             now: Date(),
                                             lastSurfaced: GraceChannel.lastSurfaced(),
                                             surfaced: GraceChannel.surfaced())
        // Wave 6.1 · on a day the ledger has nothing to return, grace may —
        // rarely — return one of his own gratitude lines (``GratitudeGrace``).
        var picked = fromLedger
        if picked == nil, GraceChannel.lastSurfaced().map({ Date().timeIntervalSince($0) > 3600 * 24 * Double(GraceChannel.restDays) }) ?? true {
            picked = await gratitudeLine()
        }
        guard let chosen = picked, !Task.isCancelled else { return }
        // Once: the moment it is chosen to be shown, it is spent.
        GraceChannel.markSurfaced(chosen)
        line = chosen
        if still {
            shown = true
        } else {
            try? await Task.sleep(for: .seconds(2.6))
            withAnimation(.easeInOut(duration: 2.2)) { shown = true }
        }
    }

    /// His own gratitude, read only, room-matched where it can be — or nil.
    /// Never counted, never dated: the line alone.
    private func gratitudeLine() async -> GraceChannel.Line? {
        let day = DailyEnergyService.practiceDayIndex()
        guard GratitudeGrace.maySpeak(practiceDay: day) else { return nil }
        let rows = await AirtableService.shared.gratitudeRows()
        guard !rows.isEmpty else { return nil }
        let room = GratitudeGrace.roomWords(name: shakti.name, shortName: shakti.shortName,
                                            bodilyLocation: shakti.bodilyLocation,
                                            tattva: shakti.tattva, quality: shakti.quality)
        guard let mine = GratitudeGrace.choose(rows: rows, roomWords: room, practiceDay: day,
                                               surfaced: GraceChannel.surfaced()) else { return nil }
        // His words, as his — in quotation, with nothing beside them.
        return GraceChannel.Line(rowId: mine.rowId, text: "“\(mine.text)”")
    }
}

// MARK: The pulse

/// "I feel her", with a heartbeat under the thumb while it rests on the pill —
/// on the days the pulse lives (`RiteDay.pulseLives(inRing:)`). The tap still
/// opens the ceremony on lift, exactly as before; holding first is simply
/// catching her in the act.
struct RitePulseButtonStyle: ButtonStyle {
    let active: Bool
    let still: Bool

    func makeBody(configuration: Configuration) -> some View {
        RitePulseLabel(label: configuration.label, pressed: configuration.isPressed,
                       active: active, still: still)
    }
}

private struct RitePulseLabel: View {
    let label: ButtonStyleConfiguration.Label
    let pressed: Bool
    let active: Bool
    let still: Bool

    @State private var beat = false

    var body: some View {
        label
            .overlay(alignment: .bottom) {
                if active && pressed {
                    // A warmth at the foot of the pill, rising with each beat.
                    Capsule()
                        .fill(RadialGradient(colors: [Color(red: 0.95, green: 0.55, blue: 0.40).opacity(beat ? 0.55 : 0.25),
                                                      Color.clear],
                                             center: .bottom, startRadius: 0, endRadius: 90))
                        .frame(height: 44)
                        .offset(y: 14)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
            .task(id: active && pressed) {
                guard active && pressed else { return }
                let heart = UIImpactFeedbackGenerator(style: .soft)
                heart.prepare()
                let b = RiteDay.pulseBeat
                while !Task.isCancelled {
                    heart.impactOccurred(intensity: CGFloat(b.first))
                    if !still { withAnimation(.easeOut(duration: 0.16)) { beat = true } }
                    try? await Task.sleep(for: .seconds(b.gap))
                    heart.impactOccurred(intensity: CGFloat(b.second))
                    if !still { withAnimation(.easeIn(duration: 0.6)) { beat = false } }
                    try? await Task.sleep(for: .seconds(b.period - b.gap))
                }
            }
    }
}

// MARK: Three doors

/// Three doors under the Rite's foot, by the hour. Each is a quiet word with a
/// slit of light before it (Design's `.door`), and none of them is ever marked
/// as done.
struct RiteDayDoors: View {
    let shakti: Shakti
    let onOpenRoom: () -> Void

    @State private var floorOpen = false
    @State private var closeOpen = false
    private let hour = Calendar.current.component(.hour, from: Date())

    var body: some View {
        HStack(spacing: 6) {
            ForEach(RiteDay.doors(hour: hour), id: \.self) { door in
                Button { open(door) } label: {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.cream.opacity(0.3))
                            .frame(width: 1, height: 18)
                        Text(RiteDay.title(door, hour: hour))
                            .font(AppFont.voice(15))
                            .foregroundStyle(Color.cream.opacity(0.72))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(.horizontal, 6)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .fullScreenCover(isPresented: $floorOpen) { OneSecondFloorView(isPresented: $floorOpen) }
        .fullScreenCover(isPresented: $closeOpen) {
            SakshiCloseView(isPresented: $closeOpen, todaysShakti: shakti)
        }
    }

    private func open(_ door: RiteDay.Door) {
        Haptics.light()
        switch door {
        case .herRoom: onOpenRoom()
        case .oneSound:
            BijaSoundService.shared.playBija(shakti.bija, seed: shakti.khadgamalaPosition ?? shakti.position)
        case .oneSecond: floorOpen = true
        case .closeTheDay: closeOpen = true
        }
    }
}

// MARK: The one-second floor

/// **Blink. Breathe. Press.** One deliberate blink, one guided breath (the
/// root's 4-4-4), one press-and-hold — and the day is complete. No further
/// door, no upsell: the floor says so and lets him go.
struct OneSecondFloorView: View {
    @Binding var isPresented: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum Stage: Int { case blink, breathe, press, done }

    @State private var stage: Stage = .blink
    @State private var eyelid: CGFloat = 1        // 1 open · 0 shut
    @State private var lungs: CGFloat = 0.55      // the breath's circle
    @State private var pressing = false
    @State private var pressed: CGFloat = 0       // the hold ring, 0 → 1

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                figure
                    .frame(width: 200, height: 200)
                Text(words)
                    .font(stage == .done ? AppFont.voice(21) : AppFont.sanskrit(30))
                    .foregroundStyle(Color.cream.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                    .id(stage)
                    .transition(.opacity)
                Spacer()
                if stage == .done {
                    Button { isPresented = false } label: {
                        Text("go")
                            .font(AppFont.label(12))
                            .tracking(2.6)
                            .foregroundStyle(Color.cream.opacity(0.6))
                            .padding(.horizontal, 28)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 30)
                } else {
                    Button { isPresented = false } label: {
                        Text("not now")
                            .font(AppFont.label(11.5))
                            .tracking(2.2)
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .padding(.horizontal, 28)
                            .frame(minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(.dark)
        .task { await walk() }
    }

    private var words: String {
        switch stage {
        case .blink: return RiteDay.floorWords[0]
        case .breathe: return RiteDay.floorWords[1]
        case .press: return RiteDay.floorWords[2]
        case .done: return RiteDay.floorComplete
        }
    }

    @ViewBuilder
    private var figure: some View {
        switch stage {
        case .blink:
            // A point that closes like an eye, and opens.
            Capsule()
                .fill(Color.gold)
                .frame(width: 14, height: max(1, 14 * eyelid))
                .shadow(color: Color.gold.opacity(0.7), radius: 12)
        case .breathe:
            Circle()
                .stroke(Color.gold.opacity(0.75), lineWidth: 1)
                .background(Circle().fill(Color.gold.opacity(0.08)))
                .scaleEffect(lungs)
        case .press:
            ZStack {
                Circle().stroke(Color.cream.opacity(0.18), lineWidth: 1)
                Circle()
                    .trim(from: 0, to: pressed)
                    .stroke(Color.gold, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Circle().fill(Color.gold.opacity(pressing ? 0.5 : 0.25)).frame(width: 18, height: 18)
            }
            .contentShape(Circle())
            .onLongPressGesture(minimumDuration: RiteDay.floorPress, maximumDistance: 40,
                                perform: { complete() },
                                onPressingChanged: { down in
                                    pressing = down
                                    if down {
                                        Haptics.soft()
                                        withAnimation(.linear(duration: RiteDay.floorPress)) { pressed = 1 }
                                    } else if stage == .press {
                                        withAnimation(.easeOut(duration: 0.3)) { pressed = 0 }
                                    }
                                })
            .accessibilityElement()
            .accessibilityLabel("Press and hold")
            .accessibilityAction { complete() }
        case .done:
            Circle()
                .fill(RadialGradient(colors: [Color.gold.opacity(0.5), Color.clear],
                                     center: .center, startRadius: 0, endRadius: 100))
        }
    }

    private func walk() async {
        // Blink: the point closes and opens once — the crossing.
        try? await Task.sleep(for: .seconds(1.2))
        if !reduceMotion {
            withAnimation(.easeInOut(duration: 0.36)) { eyelid = 0 }
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.easeInOut(duration: 0.45)) { eyelid = 1 }
        }
        Haptics.soft()
        try? await Task.sleep(for: .seconds(1.6))
        guard !Task.isCancelled else { return }

        // Breathe: in four, hold four, out four.
        withAnimation(.easeInOut(duration: 0.6)) { stage = .breathe }
        let b = RiteDay.floorBreath
        if !reduceMotion { withAnimation(.easeInOut(duration: b[0])) { lungs = 1 } }
        try? await Task.sleep(for: .seconds(b[0] + b[1]))
        if !reduceMotion { withAnimation(.easeInOut(duration: b[2])) { lungs = 0.55 } }
        try? await Task.sleep(for: .seconds(b[2]))
        guard !Task.isCancelled else { return }

        // Press: the last movement is his.
        withAnimation(.easeInOut(duration: 0.6)) { stage = .press }
    }

    private func complete() {
        guard stage == .press else { return }
        Haptics.medium()
        SakshiClose.markFloorWalked()
        withAnimation(.easeInOut(duration: 1.2)) { stage = .done }
        // The floor is a complete day: it releases him.
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if stage == .done { isPresented = false }
        }
    }
}

// MARK: The Sakshi close

/// One witnessing sentence, gathered from what this phone holds of today —
/// names and places, never a number — and then the glass lets him go.
struct SakshiCloseView: View {
    @Binding var isPresented: Bool
    let todaysShakti: Shakti

    @Query(sort: \RecognitionEntry.timestamp) private var moments: [RecognitionEntry]
    @Query(sort: \Shakti.khadgamalaPosition) private var roster: [Shakti]
    @Query private var descent: [DescentState]
    @State private var shown = false

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()
            VStack(spacing: 36) {
                Spacer()
                Circle()
                    .fill(Color.gold.opacity(0.8))
                    .frame(width: 8, height: 8)
                    .shadow(color: Color.gold.opacity(0.6), radius: 10)
                Text(sentence)
                    .font(AppFont.voice(21))
                    .foregroundStyle(Color.cream.opacity(0.88))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 36)
                    .opacity(shown ? 1 : 0)
                Spacer()
                Button { isPresented = false } label: {
                    Text("rest")
                        .font(AppFont.label(12))
                        .tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.6))
                        .padding(.horizontal, 28)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 30)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // Wave 6 · B · the closing bell.
            TheBells.riteClosed()
            withAnimation(.easeInOut(duration: 2.4).delay(0.6)) { shown = true }
        }
    }

    private var sentence: String {
        SakshiClose.sentence(gathered)
    }

    /// Today, from the phone's own record: who he stopped for, whom he kept a
    /// silence with, how deep the Mandala fell, whether the floor was walked.
    private var gathered: SakshiClose.Today {
        let day = DailyEnergyService.practiceDayIndex()
        var names: [Int: String] = [:]
        for s in roster { if let kp = s.khadgamalaPosition { names[kp] = s.name } }
        var d = SakshiClose.Today()
        d.floorWalked = SakshiClose.floorWalkedToday()
        for m in moments where DailyEnergyService.practiceDayIndex(for: m.timestamp) == day {
            guard let name = names[m.khadgamalaPosition] else { continue }
            switch m.gesture {
            case .felt: d.met.append(name)
            case .silence: d.silences.append(name)
            }
        }
        // The descent's crossings are dated, not ringed, so only "today's
        // deepest" can be told — and only when today's crossing is the deepest.
        if let state = descent.first,
           let last = state.crossings.last,
           DailyEnergyService.practiceDayIndex(for: last) == day {
            d.deepestRing = state.deepestReached
        }
        d.todaysName = todaysShakti.name
        let kp = todaysShakti.khadgamalaPosition ?? todaysShakti.position
        d.todayMet = moments.contains {
            $0.gesture == .felt && $0.khadgamalaPosition == kp
                && DailyEnergyService.practiceDayIndex(for: $0.timestamp) == day
        }
        return d
    }
}
