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
            d = distance(ring: r, radius: radius)
            angle = Double.pi * 0.75
        case .threshold(let from, let to):
            d = (distance(ring: from, radius: radius) + distance(ring: to, radius: radius)) / 2
            angle = Double.pi * 0.25
        case .garland:
            d = radius * 1.1
            angle = Double.pi / 2
        }
        return CGPoint(x: c.x + d * CGFloat(cos(angle)), y: c.y + d * CGFloat(sin(angle)))
    }
}

struct PlayFieldView: View {
    var onClose: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var playing: PlayGame? = nil
    @State private var arrived = false

    var body: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.47)
            let radius = min(geo.size.width * 0.40, geo.size.height * 0.34)
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
                        .position(PlayFieldLayout.point(for: game, center: c, radius: radius))
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
        .preferredColorScheme(.dark)
        .statusBarHidden()
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
                    .font(AppFont.voice(13))
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

/// Lets anything in the app open Lalitā's field or one game through
/// `PlayField.open(_:)` — attached once, at the root. Also answers the launch
/// argument `OPEN_PLAY` (the field) or `OPEN_PLAY=<game>` (one game), so a
/// test harness can walk every game.
struct PlayFieldPresenter: ViewModifier {
    @State private var fieldShown = false
    @State private var single: PlayGame? = nil

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: PlayField.openNotification)) { note in
                if let raw = note.object as? String, let game = PlayGame(rawValue: raw) {
                    single = game
                } else {
                    fieldShown = true
                }
            }
            .onAppear {
                for arg in ProcessInfo.processInfo.arguments where arg.hasPrefix("OPEN_PLAY") {
                    let parts = arg.split(separator: "=", maxSplits: 1)
                    if parts.count == 2, let game = PlayGame(rawValue: String(parts[1])) {
                        single = game
                    } else {
                        fieldShown = true
                    }
                }
            }
            .fullScreenCover(isPresented: $fieldShown) {
                PlayFieldView(onClose: { fieldShown = false })
            }
            .fullScreenCover(item: $single) { game in
                PlayGameHost(game: game, onClose: { single = nil })
            }
    }
}

extension View {
    func playFieldPresenter() -> some View { modifier(PlayFieldPresenter()) }
}
