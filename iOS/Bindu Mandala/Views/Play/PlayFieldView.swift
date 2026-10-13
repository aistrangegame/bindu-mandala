import SwiftUI

// MARK: - Wave 4 · Lalitā's field
//
// Every game gathered at the Bindu as one field, so none is ever hidden. Each
// game's light stands at its own address — a seat on its ring, a ring, a
// threshold between rings — with the garland of 102 strung round the outside
// and the Śrī Yantra at the point itself. Touch a light and the game opens.
// Walk it or read it, as equals: every light is also a button a voice can
// find by its verb.

enum PlayFieldLayout {
    /// How many seats each ring holds (the khaḍgamālā's own shape).
    static func seats(inRing ring: Int) -> Int {
        let start = KhadgamalaMap.ringStartOffset(ring)
        let next = ring >= 9 ? KhadgamalaMap.total : KhadgamalaMap.ringStartOffset(ring + 1)
        return max(1, next - start)
    }

    /// Distance from the point for a ring: the Bindu at the centre, the
    /// Bhūpura at the rim.
    static func distance(ring: Int, radius: CGFloat) -> CGFloat {
        radius * CGFloat(max(0, min(8, 9 - ring))) / 8
    }

    /// Where a game's light stands, centred on `c` within `radius`.
    static func point(for game: PlayGame, center c: CGPoint, radius: CGFloat) -> CGPoint {
        let angle: Double
        let d: CGFloat
        switch game.address {
        case .seat(let kp):
            let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let i = KhadgamalaMap.perRingIndex(forKhadgamala: kp)
            let n = seats(inRing: ring)
            d = distance(ring: ring, radius: radius)
            // Two games at one seat (Pulse and Coherence) stand a little apart.
            let twin = PlayAddressBook.games(atPosition: kp)
            let nudge = twin.count > 1 ? (twin.firstIndex(of: game) == 0 ? -0.16 : 0.16) : 0
            angle = -Double.pi / 2 + 2 * Double.pi * Double(i - 1) / Double(n) + nudge
        case .ring(let r):
            // Wave 6: a ring may hold several games; they stand apart round it.
            let here = PlayAddressBook.games(at: game.address)
            let k = Double(here.firstIndex(of: game) ?? 0)
            if r == 9 {
                d = radius * 0.16
                angle = Double.pi * 0.75 + k * 0.9
            } else {
                d = distance(ring: r, radius: radius)
                angle = Double.pi * 0.75 + (k - Double(here.count - 1) / 2) * 0.32
            }
        case .threshold(let from, let to):
            let here = PlayAddressBook.games(at: game.address)
            let k = Double(here.firstIndex(of: game) ?? 0)
            d = (distance(ring: from, radius: radius) + distance(ring: to, radius: radius)) / 2
            angle = Double.pi * 0.25 + (k - Double(here.count - 1) / 2) * 0.3
        case .garland:
            d = radius * 1.1
            angle = Double.pi / 2
        }
        // The Bindu's own seat holds the Śrī Yantra on the point itself; any
        // other game there stands just beside it.
        if case .seat(let kp) = game.address, kp == KhadgamalaMap.total,
           let first = PlayAddressBook.games(atPosition: kp).first, first != game {
            return CGPoint(x: c.x + radius * 0.16, y: c.y - radius * 0.12)
        }
        return CGPoint(x: c.x + d * CGFloat(cos(angle)), y: c.y + d * CGFloat(sin(angle)))
    }

    /// Wave 6 · every light at its address, then eased apart until no two
    /// stand closer than a finger — so thirty-six games can share one field
    /// and each can still be touched. The Śrī Yantra stays pinned to the
    /// point; everything else moves only as far as it must.
    static func relaxed(center c: CGPoint, radius: CGFloat,
                        minimum: CGFloat = 50, passes: Int = 80) -> [PlayGame: CGPoint] {
        let games = PlayGame.allCases
        var pts = games.map { point(for: $0, center: c, radius: radius) }
        let pinned = games.firstIndex(of: .yantraTrace)
        let limit = radius * 1.18
        for _ in 0..<max(0, passes) {
            var moved = false
            for i in 0..<pts.count {
                for j in (i + 1)..<pts.count {
                    var dx = pts[j].x - pts[i].x
                    var dy = pts[j].y - pts[i].y
                    var d = hypot(dx, dy)
                    guard d < minimum else { continue }
                    if d < 0.001 {
                        let a = Double(i * 7 + j * 3)
                        dx = CGFloat(cos(a)); dy = CGFloat(sin(a)); d = 1
                    }
                    let push = (minimum - d) / 2 + 0.5
                    let ux = dx / d, uy = dy / d
                    if i != pinned { pts[i] = CGPoint(x: pts[i].x - ux * push, y: pts[i].y - uy * push) }
                    if j != pinned { pts[j] = CGPoint(x: pts[j].x + ux * push, y: pts[j].y + uy * push) }
                    moved = true
                }
            }
            for i in 0..<pts.count where i != pinned {
                let dx = pts[i].x - c.x, dy = pts[i].y - c.y
                let d = hypot(dx, dy)
                if d > limit {
                    pts[i] = CGPoint(x: c.x + dx / d * limit, y: c.y + dy / d * limit)
                }
            }
            if !moved { break }
        }
        var out: [PlayGame: CGPoint] = [:]
        for (i, g) in games.enumerated() { out[g] = pts[i] }
        return out
    }
}

struct PlayFieldView: View {
    var onClose: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var playing: PlayGame? = nil
    @State private var arrived = false
    /// Wave 6.1 · the modes, reached from the field.
    @State private var modesOpen = false
    /// The season the field is opened in (Wave 6 · the seasonal yantra).
    let season = Panchanga.rtu(at: Date())

    var body: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.47)
            let radius = min(geo.size.width * 0.42, geo.size.height * 0.36)
            let spots = PlayFieldLayout.relaxed(center: c, radius: radius)
            ZStack {
                Color(red: 6 / 255, green: 2 / 255, blue: 5 / 255).ignoresSafeArea()

                TimelineView(.animation(paused: reduceMotion)) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    Canvas { ctx, _ in
                        drawField(ctx, center: c, radius: radius, t: t)
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .accessibilityHidden(true)

                ForEach(PlayGame.allCases) { game in
                    lightButton(game)
                        .position(spots[game] ?? PlayFieldLayout.point(for: game, center: c, radius: radius))
                        .opacity(arrived ? 1 : 0)
                        .animation(reduceMotion ? .easeOut(duration: 0.3)
                                   : .easeOut(duration: 1.2).delay(0.2 + 0.05 * Double(game.address.ring)),
                                   value: arrived)
                }

                VStack(spacing: 6) {
                    HStack {
                        Button {
                            PlayHaptics.tap(0.3)
                            onClose()
                        } label: {
                            Text("‹ return")
                                .font(AppFont.voice(16))
                                .foregroundStyle(Color.cream.opacity(0.6))
                                .frame(minWidth: 64, minHeight: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 14)
                        .accessibilityLabel("Return from Lalitā's field")
                        Spacer()
                    }
                    Text("LALITĀ · THE PLAY THAT KNOWS ITSELF")
                        .font(AppFont.label(11.5))
                        .tracking(2.6)
                        .foregroundStyle(Color.gold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    Spacer()
                    // Wave 6.1 · Lalitā's field is the one place everything is
                    // gathered: every game above, and at its foot a quiet way to
                    // the modes and to the Road.
                    HStack(spacing: 22) {
                        fieldWay("the modes", label: TheModes.doorLabel) { modesOpen = true }
                        fieldWay("the road", label: "Walk the road") {
                            onClose()
                            MandalaWays.ask(.road)
                        }
                    }
                    .opacity(arrived ? 1 : 0)
                    .padding(.bottom, 18)
                }
                .padding(.top, 8)
            }
        }
        .onAppear {
            withAnimation { arrived = true }
        }
        .fullScreenCover(item: $playing) { game in
            PlayGameHost(game: game, onClose: { playing = nil })
        }
        .fullScreenCover(isPresented: $modesOpen) {
            ModesDoorView(onClose: { modesOpen = false })
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }

    /// One quiet word at the field's foot — a way, not a list.
    private func fieldWay(_ word: String, label: String, _ action: @escaping () -> Void) -> some View {
        Button {
            PlayHaptics.tap(0.3)
            action()
        } label: {
            Text(word)
                .font(AppFont.voice(15))
                .tracking(1.2)
                .foregroundStyle(Color.cream.opacity(0.55))
                .padding(.horizontal, 12)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    private func lightButton(_ game: PlayGame) -> some View {
        Button {
            PlayHaptics.tap(0.45)
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.08, duration: 1.2)
            playing = game
        } label: {
            VStack(spacing: 4) {
                Circle()
                    .fill(RadialGradient(colors: [Color.cream, game.hue.opacity(0.85), game.hue.opacity(0)],
                                         center: .center, startRadius: 0, endRadius: 15))
                    .frame(width: 30, height: 30)
                    .blendMode(.plusLighter)
                Text(game.verb)
                    .font(AppFont.voice(12))
                    .foregroundStyle(Color.cream.opacity(0.72))
                    .fixedSize()
            }
            .frame(minWidth: 52, minHeight: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(game.title) — \(game.verb)")
    }

    private func drawField(_ ctx: GraphicsContext, center c: CGPoint, radius: CGFloat, t: Double) {
        var add = ctx
        add.blendMode = .plusLighter
        // The rings, breathing at the Bindu's pace.
        let b = reduceMotion ? 0.5 : 0.5 - 0.5 * cos(2 * .pi * t / 9)
        for ring in 2...8 {
            let d = PlayFieldLayout.distance(ring: ring, radius: radius)
            add.stroke(Path(ellipseIn: CGRect(x: c.x - d, y: c.y - d, width: d * 2, height: d * 2)),
                       with: .color(Color.gold.opacity(0.07 + 0.03 * Double(ring) / 8)), lineWidth: 0.7)
        }
        let rim = radius
        add.stroke(Path(CGRect(x: c.x - rim, y: c.y - rim, width: rim * 2, height: rim * 2)),
                   with: .color(Color.gold.opacity(0.10)), lineWidth: 0.7)
        // Wave 6 · the seasonal yantra: the field stands in the ṛtu's light.
        let rgb = SeasonLight.colour(season)
        add.glow(at: c, radius: radius * 1.05, color: Color(red: rgb.0, green: rgb.1, blue: rgb.2),
                 alpha: 0.09 * SeasonLight.intensity(season))
        // The garland: 102 beads strung round everything, turning once in
        // three minutes.
        let g = radius * 1.1
        let turn = reduceMotion ? 0 : t / 180 * 2 * Double.pi
        for kp in 1...KhadgamalaMap.total {
            let a = turn + 2 * Double.pi * Double(kp - 1) / Double(KhadgamalaMap.total)
            let p = CGPoint(x: c.x + g * CGFloat(cos(a)), y: c.y + g * CGFloat(sin(a)))
            add.core(at: p, radius: kp == KhadgamalaMap.total ? 2.4 : 1.3, color: Color.gold, alpha: 0.5)
        }
        // Her point.
        add.glow(at: c, radius: 120 + 20 * CGFloat(b), color: Color.accentRed, alpha: 0.35)
        add.glow(at: c, radius: 40 + 8 * CGFloat(b), color: Color.gold, alpha: 0.4)
    }
}

// MARK: - The shell's door into play
//
// U2 · the global presenter (`.playFieldPresenter()`, two covers over the
// whole shell) is retired. `PlayField.open(_:)` crosses through the Router to
// A Strange Game — its own space, at the game named (`Address.sub` = the
// game's raw value) — and the launch argument `OPEN_PLAY` / `OPEN_PLAY=<game>`
// is read as an address by `DeepLink.launchAddress`.
