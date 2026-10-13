import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · Mauna at the point (tap the point)
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #24 and `mandala-and-rings.md`
// MX08: the silence leaves the Mandala's glass and lives at Home, as its own
// place on the stack (Home › Mauna). The silence itself is the existing
// `MaunaView` (`Views/Mandala/TheCentre.swift`) — the names on their orbits,
// the colourless Maya light, Pointy, the fall at depth .5, the ledger's
// `Silence Held` after 7 s — hosted here and no longer presented over the
// Mandala. Design's captions are restored (ruling 17, §7 settled 9) at 7 / 14
// / 21 / 28 s; no "N seconds in" indicator. A touch leaves; at depth .5 he may
// fall through to Lalitā source.

/// Mauna's captions — `spine-and-home.md` #24, verbatim.
enum MaunaCaptions {
    /// 7 s "All of her. Here. Always." → 14 s "She has not gone anywhere." →
    /// 21 s "You have not gone anywhere." → 28 s silence.
    static let beats: [(at: Double, line: String?)] = [
        (7, "All of her. Here. Always."),
        (14, "She has not gone anywhere."),
        (21, "You have not gone anywhere."),
        (28, nil),
    ]

    /// The caption standing `t` seconds into the silence (nil before 7 s and from 28 s).
    static func line(at t: Double) -> String? {
        var current: String?
        for beat in beats where t >= beat.at { current = beat.line }
        return current
    }
}

/// Home › Mauna — `spine-and-home.md` #24.
@MainActor
struct HomeMauna: View {
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @State private var openedAt = Date()
    @State private var left = false

    var body: some View {
        ZStack {
            MaunaView(seats: MandalaWorld.seats(from: shaktis),
                      soundOn: SoundSettings.shared.masterOn && SoundMixer.shared.isAwake,
                      onLeave: { leave(fellThrough: $0) })
            captions
        }
        .onAppear { openedAt = Date() }
    }

    private var captions: some View {
        TimelineView(.periodic(from: .now, by: 1)) { tl in
            let line = MaunaCaptions.line(at: tl.date.timeIntervalSince(openedAt))
            GeometryReader { geo in
                ZStack {
                    if let line {
                        Text(line)
                            .font(AppFont.voice(20))
                            .tracking(0.6)
                            .foregroundStyle(Color.cream.opacity(0.78))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)
                            .id(line)
                            .transition(.opacity)
                    }
                }
                .frame(width: geo.size.width)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.2)
                .animation(.easeInOut(duration: reduceMotion ? 0.2 : 2.4), value: line)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    /// A touch leaves (back to Home, exactly); a fall through the silence
    /// arrives at Lalitā source.
    private func leave(fellThrough: Bool) {
        guard !left else { return }
        left = true
        if fellThrough {
            _ = router.go(to: HomeSub.address(HomeSub.source, kp: HomeSub.lalitaKp), via: .dissolve)
        } else {
            _ = router.back(via: .dissolve)
        }
    }
}
