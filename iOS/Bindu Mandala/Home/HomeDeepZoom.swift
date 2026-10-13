import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · the deep zoom into the Bindu — Praveśa (ruling 9)
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #27 and `mandala-and-rings.md`
// MX08: the fall that lived inside Mauna on the Mandala's glass now has its own
// place under Home, entered by holding the point 0.9 s (the one hold engine).
// It is the existing fall — `Pravesha`'s numbers, `PraveshaClock`, Design's
// `FullYantra` (`CentreYantra`) and the Shepard tone (`RingFieldVoice.fall`) —
// driven as Design drives it: seven nested yantras, each carrying sixteen of
// the names, rising from seed to engulfing and turning slowly; a press
// anywhere falls faster and accumulates the held time; released, it decays
// ×1.4. Past 6.5 s held, recognition ramps in and is full at 8.7 s: "You did
// not arrive. / You were the arriving." It never reaches a bottom (law,
// `OneBuildingTests`). A light touch rises back out to Home, where the whole
// ring stands round the point: the zoom out shows he never left the centre.

/// Home › the deep zoom — `spine-and-home.md` #27.
@MainActor
struct HomeDeepZoom: View {
    @Environment(Router.self) private var router
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var fall = PraveshaClock()
    @State private var holding = false
    @State private var pressAt: Date?
    /// The longest he has held into it — the ledger's `Silence Held` (§4).
    @State private var deepest: TimeInterval = 0
    @State private var openedAt = Date()
    @State private var firstTime = !UserDefaults.standard.bool(forKey: HomeDeepZoom.seenKey)
    @State private var left = false

    static let seenKey = "home.pravesha.seen"
    /// A press shorter than this, with almost nothing held, is a touch: he rises out.
    static let touch: TimeInterval = 0.25

    /// Design's authored words (#27), as `Pravesha` keeps them.
    static let restLines = ["Press and hold —", "fall inward."]
    static let recognisedLines = ["You did not arrive.", "You were the arriving."]
    static let firstTimeLine = "dark room · full screen · unhurried"

    private var soundOn: Bool { SoundSettings.shared.masterOn && SoundMixer.shared.isAwake }

    var body: some View {
        let names = TheCentre.ringNames(MandalaWorld.seats(from: shaktis), ring: 2)
        return TimelineView(.animation(minimumInterval: reduceMotion ? 0.25 : nil, paused: false)) { tl in
            let now = tl.date
            let state = fall.advance(now: now.timeIntervalSinceReferenceDate, holding: holding)
            ZStack {
                Color(red: 2 / 255, green: 0, blue: 1 / 255)
                yantras(state, names: names)
                words(state, since: now.timeIntervalSince(openedAt))
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .gesture(press)
        .theEdgeWayOut(onOut: { rise() })
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("The deep zoom into the Bindu"))
        .accessibilityAction(named: Text("Fall inward")) { holding.toggle() }
        .accessibilityAction { rise() }
        .accessibilityAction(.escape) { rise() }
        .onAppear {
            openedAt = Date()
            UserDefaults.standard.set(true, forKey: Self.seenKey)
            RingFieldVoice.shared.hush()
        }
        .task {
            // The Shepard tone follows the fall's speed, ten times a second.
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                deepest = max(deepest, fall.held)
                guard soundOn else { continue }
                RingFieldVoice.shared.fall(intensity: Pravesha.shepard(speed: fall.speed))
            }
        }
        .onDisappear {
            RingFieldVoice.shared.stopFalling()
            if soundOn { RingFieldVoice.shared.resume() }
        }
    }

    // MARK: The press — fall faster while held; a light touch rises out

    private var press: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard pressAt == nil else { return }
                pressAt = Date()
                holding = true
            }
            .onEnded { _ in
                let length = pressAt.map { Date().timeIntervalSince($0) } ?? 1
                pressAt = nil
                holding = false
                if length < Self.touch, fall.held < 0.3 { rise() }
            }
    }

    /// Back out to Home: the whole ring stands round the point again.
    private func rise() {
        guard !left else { return }
        left = true
        MaunaSilence.record(seconds: max(deepest, fall.held), context: context)
        _ = router.back(via: .dissolve)
    }

    // MARK: The seven yantras

    private func yantras(_ state: PraveshaClock.Snapshot, names: [String]) -> some View {
        Canvas { context, size in
            let centre = CGPoint(x: size.width / 2, y: size.height * HomeLayout.pointHeight)
            let base = min(size.width, size.height) / 390
            var ctx = context
            ctx.blendMode = .plusLighter
            for i in 0..<Pravesha.layers {
                let d = Pravesha.depth(layer: i, clock: state.clock)
                let unit = base * CGFloat(Pravesha.scale(depth: d))
                let rot = Angle.degrees(Double((i * 47) % 360) + state.clock * 6)
                let o = Pravesha.opacity(depth: d)
                // Each layer carries its own sixteen of the names (offset i·13).
                let slice = Self.slice(names, layer: i)
                CentreYantra.draw(in: ctx, centre: centre, unit: unit,
                                  opacity: { layer in
                                      layer == .names ? 0.42 * o : o * CentreYantra.restOpacity(layer)
                                  },
                                  names: slice, rotation: rot)
            }
            CentreYantra.drawBindu(in: context, centre: centre,
                                   radius: 9 * (1 + 1.7 * CGFloat(state.recognition)))
        }
        .allowsHitTesting(false)
    }

    /// Sixteen names for layer `i`, starting at `i × 13` round the garland.
    static func slice(_ names: [String], layer i: Int) -> [String] {
        guard !names.isEmpty else { return [] }
        return (0..<16).map { names[(i * 13 + $0) % names.count] }
    }

    // MARK: The words — Design's, never generated, never a clock shown

    private func words(_ state: PraveshaClock.Snapshot, since t: TimeInterval) -> some View {
        VStack(spacing: 14) {
            if firstTime, t >= 2.6, state.held < 0.05 {
                Text(Self.firstTimeLine)
                    .font(AppFont.label(11))
                    .tracking(2)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.bottom, 10)
            }
            Spacer()
            if state.recognition > 0.01 {
                VStack(spacing: 4) {
                    ForEach(Self.recognisedLines, id: \.self) { line in
                        Text(line).font(AppFont.sanskrit(27)).foregroundStyle(Color.cream)
                    }
                }
                .opacity(state.recognition)
                .offset(y: CGFloat(8 * (1 - state.recognition)))
                Rectangle().fill(Color.gold.opacity(0.6 * state.recognition)).frame(width: 48, height: 0.5)
                Text(Avarana.appreciationPhrase(forRing: 9))
                    .font(AppFont.voice(16))
                    .foregroundStyle(Color.gold.opacity(0.82))
                    .opacity(state.recognition)
            } else if state.held > 0.05 {
                Text(Pravesha.falling)
                    .font(AppFont.voice(21))
                    .foregroundStyle(Color.cream.opacity(0.8))
                Text(Pravesha.fallingBeneath)
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.gold.opacity(0.7))
            } else {
                VStack(spacing: 2) {
                    ForEach(Self.restLines, id: \.self) { line in
                        Text(line).font(AppFont.voice(19)).foregroundStyle(Color.cream)
                    }
                }
                .opacity(max(0, 1 - state.held / 0.7) * 0.75)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
        .padding(.top, 90)
        .padding(.bottom, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}
