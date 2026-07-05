import SwiftUI
import SwiftData

/// The home is not a screen — it is a presence.
/// The yantra fills the surface. The hamburger is the minimum concession.
struct RootView: View {
    @Environment(\.modelContext) private var context
    @State private var destination: Destination = Self.initialDestination()
    @State private var menuOpen = false
    @State private var settingsPresented = false

    enum Destination { case mandala, rite, well, the102, memory }

    private static func initialDestination() -> Destination {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("START_TAB=mandala") { return .mandala }
        if args.contains("START_TAB=rite")    { return .rite }
        if args.contains("START_TAB=well")    { return .well }
        if args.contains("START_TAB=102")     { return .the102 }
        if args.contains("START_TAB=memory")  { return .memory }
        return .rite
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.ground.ignoresSafeArea()

            Group {
                switch destination {
                case .mandala:
                    MandalaScreenView(
                        onPetalTap: { _ in
                            // Phase 5: present Shakti Detail.
                        },
                        onBinduTap: {
                            // Phase 6: present Silence screen.
                        }
                    )
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
