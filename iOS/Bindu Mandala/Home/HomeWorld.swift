import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · Home, the Bindu — the world
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Arriving", "Being there",
// "Going deeper". Home is one world among fifteen — the centre. Its places are
// sub-addresses of `.home`, each its own space on the Router's stack (Home ›
// Mauna, Home › the deep zoom, Home › the source), so back always returns to
// exactly where he was and nothing is ever laid over Home:
//
//   • `nil`        — Home itself (the centre, the stations, the point)
//   • `card` + kp  — Home with her card open (a gift opened, §2 J #72)
//   • `mauna`      — the silence at the point (tap the point, #24)
//   • `pravesha`   — the deep zoom (hold the point 0.9 s, #27, ruling 9)
//   • `source`     — Lalitā source, the arrival from the inside (#25)
//   • `essence`    — the higher-self name, kept (#16)
//
// Registered as the `.home` world's builder (`HomeWorldBuilder.register()`).

/// Home's sub-places — `spine-and-home.md` §2 B #24, #25, #27, #16, J #72.
enum HomeSub {
    static let card = Address.cardSub
    static let mauna = "mauna"
    static let pravesha = "pravesha"
    static let source = "source"
    static let essence = "essence"

    /// The address of a place at Home.
    static func address(_ sub: String, kp: Int? = nil) -> Address {
        Address(.home, kp: kp, sub: sub)
    }

    /// Lalitā's position: the point's seat, always (never `shaktis.last`).
    static let lalitaKp = KhadgamalaMap.total
}

/// Gives the Router Home's view — `spine-and-home.md` §2 J #71 (U1-A's
/// `WorldBuilders.register`). Called once at launch by the spine's root.
@MainActor
enum HomeWorldBuilder {
    static func register() {
        WorldBuilders.register(.home) { address in AnyView(HomeWorld(address: address)) }
    }
}

/// Home, the Bindu — `spine-and-home.md` §1.
@MainActor
struct HomeWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    /// The arrival owed this launch (#1–#4).
    enum Arrival: Equatable {
        /// Not yet decided (the first frame): the dark the Waking begins in.
        case pending
        case waking
        case homecoming
        case here
    }

    @State private var arrival: Arrival = .pending
    /// The covenant was met in the Homecoming: once Home has stood one
    /// breath, the Today door opens (#2, §7 settled 1).
    @State private var covenantMet = false

    var body: some View {
        ZStack {
            Color.silenceGround.ignoresSafeArea()
            switch arrival {
            case .pending:
                Color(hex: "#060402").ignoresSafeArea()
            case .waking:
                WakingView(onDone: { arrival = .homecoming })
            case .homecoming:
                HomecomingView(isPresented: homecomingShown,
                               onCovenant: { covenantMet = true })
            case .here:
                place
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(WorldID.home.sentinel)
        .onAppear(perform: decideArrival)
        .onChange(of: router.pendingCeremony) { _, owed in
            if owed == .homecoming { takeCeremony() }
        }
        .task(id: covenantMet) {
            guard covenantMet else { return }
            // Home stands one breath, then the first door opens — taken by stillness.
            try? await Task.sleep(for: .seconds(HomecomingScore.breath))
            guard !Task.isCancelled, arrival == .here else { return }
            covenantMet = false
            _ = router.go(to: Address(.today), via: .blink())
        }
    }

    // MARK: The places

    @ViewBuilder
    private var place: some View {
        switch address.sub {
        case .some(HomeSub.mauna):
            HomeMauna()
        case .some(HomeSub.pravesha):
            HomeDeepZoom()
        case .some(HomeSub.source):
            HomeSource()
        case .some(HomeSub.essence):
            HomeEssence()
        default:
            HomeCentre(cardKp: address.sub == HomeSub.card ? address.kp : nil)
        }
    }

    // MARK: The arrival

    private var homecomingShown: Binding<Bool> {
        Binding(get: { arrival == .homecoming },
                set: { shown in if !shown { arrival = .here } })
    }

    private func decideArrival() {
        guard arrival == .pending else { return }
        if router.pendingCeremony == .homecoming {
            takeCeremony()
            return
        }
        let owed = HomeLaunch.shared.take(wayBackIsEmpty: router.state.backStack.isEmpty)
        arrival = owed ? .waking : .here
    }

    /// Settings → "Re-enter the Homecoming": she greets him again, as on the
    /// first day (`HomecomingView.reset()` has already cleared `hasLaunched`).
    private func takeCeremony() {
        guard router.takeCeremony() == .homecoming else { return }
        arrival = .homecoming
    }
}
