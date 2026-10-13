import SwiftUI

// MARK: - Wave 6 · B · Leela drops
//
// a-strange-game's `leela-architecture.md` (Codex C-1330): Leela is the play
// itself, and a drop is a moment where the play drops in to talk to the player
// — **rare, unannounced, about reality and never about the game ahead, and
// ending in a real-world action**. *"The walker is playing the game in Leela
// but doing something in the real world."*
//
// Here:
//   • **Rare.** At most one in any few days: never within `minimumGapDays` of
//     the last, and even then only by chance (`chance`), once a practice day at
//     most — so it is never expected. His own rule (≥ 3 days apart, then 30 %);
//     the app-added "never in the first days" was lifted by ruling 16 (U0), so
//     the very first drop may come on any day.
//   • **Never foreshadowed.** No notification, no badge, no hint that one is
//     coming, and nothing that says one came. It simply arrives.
//   • **His words.** Each drop is two exact substrings of one of The Map's
//     Leela Stories (``GameStructure``), its lead and the action it ends in.
//     Rows that are sealed (the Reveal, the convergence) are never drawn from,
//     and no drop ever repeats the one before it.
//   • **One ledger row**, `Leela Drop`, when he answers — carried into the day,
//     or held in silence. Both are the same act; neither is a grade.

enum LeelaDrops {

    /// Never closer together than this.
    static let minimumGapDays = 3
    /// Once the gap has passed, the chance on any one day he opens the
    /// instrument. Low enough that a drop is a surprise, never a schedule.
    static let chance = 0.3

    static let lastDropDayKey = "leela_last_drop_day"
    static let lastDropIdKey = "leela_last_drop_id"
    static let lastConsideredDayKey = "leela_last_considered_day"
    static let firstSeenDayKey = "leela_first_seen_day"

    /// Pure: may a drop come today? `firstSeenDay` is kept for the callers'
    /// shape and no longer gates anything (ruling 16).
    static func shouldDrop(today: Int,
                           firstSeenDay: Int,
                           lastDropDay: Int?,
                           lastConsideredDay: Int?,
                           roll: Double) -> Bool {
        // One chance a day at most — a second opening the same day is not a
        // second draw.
        if lastConsideredDay == today { return false }
        if let last = lastDropDay {
            guard today - last >= minimumGapDays else { return false }
        }
        return roll < chance
    }

    /// Pure: which drop. Never the one before; `roll` in `0..<1`.
    static func choose(from drops: [LeelaDrop], after lastId: String?, roll: Double) -> LeelaDrop? {
        let open = drops.filter { $0.id != lastId }
        let pool = open.isEmpty ? drops : open
        guard !pool.isEmpty else { return nil }
        let i = min(pool.count - 1, max(0, Int(roll * Double(pool.count))))
        return pool[i]
    }

    /// The live draw: reads and writes the phone's own note of the last drop.
    static func draw(defaults: UserDefaults = .standard,
                     today: Int = DailyEnergyService.practiceDayIndex()) -> LeelaDrop? {
        if defaults.object(forKey: firstSeenDayKey) == nil {
            defaults.set(today, forKey: firstSeenDayKey)
        }
        let first = (defaults.object(forKey: firstSeenDayKey) as? Int) ?? today
        let last = defaults.object(forKey: lastDropDayKey) as? Int
        let considered = defaults.object(forKey: lastConsideredDayKey) as? Int
        let go = shouldDrop(today: today, firstSeenDay: first, lastDropDay: last,
                            lastConsideredDay: considered, roll: Double.random(in: 0..<1))
        defaults.set(today, forKey: lastConsideredDayKey)
        guard go, let drop = choose(from: GameStructure.leelaDrops,
                                    after: defaults.string(forKey: lastDropIdKey),
                                    roll: Double.random(in: 0..<1)) else { return nil }
        defaults.set(today, forKey: lastDropDayKey)
        defaults.set(drop.id, forKey: lastDropIdKey)
        ThreePools.noteBeing(.leelaArrived(drop.id), defaults: defaults, today: today)
        return drop
    }
}

// MARK: - The drop, when it comes

/// Lets a Leela drop arrive over the shell, rarely, unannounced.
@MainActor
struct LeelaDropPresenter: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @State private var drop: LeelaDrop?

    /// A breath after he arrives, so a drop never lands on the opening itself.
    static let settleSeconds: Double = 9

    func body(content: Content) -> some View {
        content
            .overlay {
                if let d = drop {
                    LeelaDropView(drop: d, onAnswer: { answer(d, carried: $0) })
                        .transition(.opacity)
                        .zIndex(90)
                }
            }
            .animation(.easeInOut(duration: 1.2), value: drop)
            .task(id: scenePhase == .active) {
                guard scenePhase == .active, drop == nil, !AppRuntime.isUnitTesting else { return }
                try? await Task.sleep(for: .seconds(Self.settleSeconds))
                guard !Task.isCancelled else { return }
                if let d = LeelaDrops.draw() {
                    Haptics.soft()
                    drop = d
                }
            }
    }

    private func answer(_ d: LeelaDrop, carried: Bool) {
        ThreePools.noteBeing(.leelaAnswered(d.id, carried: carried))
        let item = ActivityLedger.leelaDrop(chakra: d.chakra, carried: carried, at: Date())
        Task { await AirtableService.shared.logActivity(item) }
        drop = nil
    }
}

extension View {
    /// Rare, unannounced Leela drops — see ``LeelaDrops``.
    @MainActor
    func leelaDrops() -> some View { modifier(LeelaDropPresenter()) }
}

/// The drop on the glass: the lead, then — a breath later — the action, in the
/// light of the face the row is spoken in; then two quiet answers.
@MainActor
struct LeelaDropView: View {
    let drop: LeelaDrop
    let onAnswer: (Bool) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var leadShown = false
    @State private var actionShown = false
    @State private var answersShown = false

    private var light: Color { (GuideFace(rawValue: drop.voice) ?? .lalita).light }

    var body: some View {
        ZStack {
            Color.black.opacity(0.82).ignoresSafeArea()
            RadialGradient(colors: [light.opacity(0.22), .clear],
                           center: .center, startRadius: 0, endRadius: 360)
                .blendMode(.plusLighter)
                .ignoresSafeArea()
                .opacity(leadShown ? 1 : 0)
            VStack(spacing: 30) {
                Spacer()
                Circle()
                    .fill(light)
                    .frame(width: 8, height: 8)
                    .shadow(color: light, radius: 14)
                Text(drop.lead)
                    .font(AppFont.voice(20))
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream.opacity(0.9))
                    .opacity(leadShown ? 1 : 0)
                Text(drop.action)
                    .font(AppFont.voice(22))
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .shadow(color: light.opacity(0.5), radius: 12)
                    .opacity(actionShown ? 1 : 0)
                Spacer()
                HStack(spacing: 28) {
                    Button { onAnswer(true) } label: {
                        Text("carry it")
                            .font(AppFont.label(12)).tracking(2.4)
                            .foregroundStyle(Color.cream.opacity(0.8))
                            .frame(minWidth: 110, minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Button { onAnswer(false) } label: {
                        Text("hold in silence")
                            .font(AppFont.label(12)).tracking(2.4)
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .frame(minWidth: 110, minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .opacity(answersShown ? 1 : 0)
                .allowsHitTesting(answersShown)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 36)
        }
        .preferredColorScheme(.dark)
        .task {
            let still = reduceMotion
            withAnimation(still ? nil : .easeInOut(duration: 2.2)) { leadShown = true }
            try? await Task.sleep(for: .seconds(still ? 0.4 : 4.5))
            withAnimation(still ? nil : .easeInOut(duration: 2.2)) { actionShown = true }
            try? await Task.sleep(for: .seconds(still ? 0.4 : 4.0))
            withAnimation(still ? nil : .easeInOut(duration: 1.2)) { answersShown = true }
        }
    }
}
