import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · Lalitā source — the arrival into the Bindu
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #25 and `mandala-and-rings.md`
// MX09: how the Bindu receives an arrival from the inside — when the
// Mandala's descent lands (#32) or he falls through Mauna. The existing
// `LalitaSourceView` (`Views/Mandala/LalitaSourceView.swift`), no longer laid
// over the Mandala at zIndex 40 but standing as Home's own place (Home › the
// source), always keyed by kp 102 (never `shaktis.last`). Its doors cross
// through the Router: "enter her presence" → Her Presence kp 102; "↑ return
// to the field" → Home.

/// Home › Lalitā source — `spine-and-home.md` #25.
@MainActor
struct HomeSource: View {
    @Environment(Router.self) private var router
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @State private var left = false

    /// Lalitā: the point's own seat, kp 102.
    private var lalita: Shakti? {
        shaktis.first { $0.khadgamalaPosition == HomeSub.lalitaKp }
    }

    var body: some View {
        ZStack {
            Color(red: 6 / 255, green: 2 / 255, blue: 5 / 255).ignoresSafeArea()
            if let lalita {
                LalitaSourceView(
                    lalita: lalita,
                    seats: MandalaWorld.seats(from: shaktis),
                    onEnter: { cross(to: Address(.herPresence, kp: HomeSub.lalitaKp)) },
                    onReturn: { returnToTheField() })
            } else {
                // The field is momentarily empty (mid-resync): the point alone.
                GeometryReader { geo in
                    ThePoint(look: .forWorld(.home), light: .always)
                        .position(HomeLayout.point(in: geo.size))
                }
                .ignoresSafeArea()
            }
        }
        .theEdgeWayOut(onOut: { returnToTheField() })
        .accessibilityAction(.escape) { returnToTheField() }
    }

    private func cross(to address: Address) {
        guard !left else { return }
        left = router.go(to: address, via: .bloom())
    }

    /// "↑ return to the field" → Home, the whole ring standing round the point.
    private func returnToTheField() {
        guard !left else { return }
        left = router.home(via: .dissolve)
    }
}
