import SwiftUI
import SwiftData

/// The home is not a screen — it is a presence.
/// The yantra fills the surface. The hamburger is the minimum concession.
struct RootView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("last_destination") private var lastDestinationRaw: String = ""
    @AppStorage("last_destination_day") private var lastDestinationDay: Int = -1
    @State private var destination: Destination = Self.initialDestination()
    @State private var menuOpen = false
    @State private var settingsPresented = false

    enum Destination: String { case mandala, rite, well, the102, memory }

    private static func initialDestination() -> Destination {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("START_TAB=mandala") { return .mandala }
        if args.contains("START_TAB=rite")    { return .rite }
        if args.contains("START_TAB=well")    { return .well }
        if args.contains("START_TAB=102")     { return .the102 }
        if args.contains("START_TAB=memory")  { return .memory }
        // Same-day restore: return to where the practitioner last was *within this
        // practice-day*. On a new day the Rite greets them with today's fresh
        // energy — the daily ritual is never skipped.
        let savedDay = UserDefaults.standard.integer(forKey: "last_destination_day")
        if savedDay == DailyEnergyService.practiceDayIndex(),
           let saved = UserDefaults.standard.string(forKey: "last_destination"),
           let d = Destination(rawValue: saved) {
            return d
        }
        return .rite
    }

    /// Each room arrives in its own way — the cosmos blooms, the Rite eases in,
    /// the lists rise, the Portrait settles into place (prototype's lrScreen*).
    private var screenTransition: AnyTransition {
        let insertion: AnyTransition
        switch destination {
        case .mandala: insertion = .opacity.combined(with: .scale(scale: 1.06))
        case .rite:    insertion = .opacity.combined(with: .scale(scale: 1.015))
        case .well, .the102: insertion = .opacity.combined(with: .scale(scale: 0.98, anchor: .top))
        case .memory:  insertion = .opacity.combined(with: .scale(scale: 0.965))
        }
        return .asymmetric(insertion: insertion, removal: .opacity)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.ground.ignoresSafeArea()

            ZStack {
                switch destination {
                case .mandala:
                    LivingMandalaView()
                case .rite:
                    DailyRiteView()
                case .well:
                    WellView()
                case .the102:
                    TheHundredTwoView()
                case .memory:
                    PortraitMandalaView()
                }
            }
            .id(destination)
            .transition(screenTransition)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.5), value: destination)

            HamburgerButton {
                withAnimation(.easeInOut(duration: 0.3)) { menuOpen = true }
            }
            .padding(.top, 16)
            .padding(.trailing, 16)

            if menuOpen {
                HamburgerMenuView(
                    destination: $destination,
                    isOpen: $menuOpen,
                    onSettings: { settingsPresented = true }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsView()
        }
        .onChange(of: destination, initial: true) { _, new in
            lastDestinationRaw = new.rawValue
            lastDestinationDay = DailyEnergyService.practiceDayIndex()
        }
        .onReceive(NotificationCenter.default.publisher(
            for: RecognitionMomentView.didSettleNotification)) { _ in
            // She has been felt. Settle into the Portrait — the practitioner
            // sees the newly-lit point in the field of their attention.
            withAnimation(.easeInOut(duration: 0.9)) {
                destination = .memory
            }
        }
        .task {
            guard !AppRuntime.isUnitTesting else { return }
            ShaktiBootstrap.seedIfNeeded(context: context)
            ShaktiBootstrap.seedDescentIfNeeded(context: context)
            RecognitionMigrator.backfillIfNeeded(context: context)
            DailySummons.migrateDefaultHourIfNeeded()
            primeSummons()                     // name mornings from seeded (16) data
            await AirtableService.shared.sync(context: context)
            primeSummons()                     // refresh with the full 102
            await DailySummons.reschedule()     // upcoming mornings now named
        }
    }

    /// Build the morning-greeting map (Khaḍgamālā position → title + line) from
    /// the local store and hand it to `DailySummons`, so each 6am summons can
    /// name the energy who presides that day.
    private func primeSummons() {
        let shaktis = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        var map: [Int: (title: String, body: String)] = [:]
        for s in shaktis {
            guard let kp = s.khadgamalaPosition else { continue }
            let quality = s.quality.trimmingCharacters(in: .whitespacesAndNewlines)
            let body = quality.isEmpty ? "She greets you this morning." : quality
            map[kp] = (title: s.name, body: body)
        }
        DailySummons.greetingProvider = { map[$0] }
    }
}

private struct HamburgerButton: View {
    var action: () -> Void

    @AppStorage("hamburger_first_run_seen") private var hasSeen: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breathPhase: CGFloat = 0   // 0 → 1 → 0 across one pulse

    var body: some View {
        Button {
            Haptics.light()
            if !hasSeen { hasSeen = true }
            action()
        } label: {
            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gold.opacity(0.45 + 0.45 * Double(breathPhase)))
                        .frame(width: 18, height: 1)
                        .shadow(color: Color.gold.opacity(0.7 * Double(breathPhase)),
                                radius: 6 * Double(breathPhase))
                }
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onAppear(perform: emitFirstRunBreath)
    }

    private func emitFirstRunBreath() {
        guard !hasSeen, !reduceMotion else { return }
        // One slow pulse — found once, then forgotten. Mark seen on the way
        // up so a quick first tap still cancels the rest of the breath
        // gracefully (and never breathes again).
        withAnimation(.easeInOut(duration: 1.6).delay(0.6)) {
            breathPhase = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeInOut(duration: 1.6)) {
                breathPhase = 0
            }
            hasSeen = true
        }
    }
}
