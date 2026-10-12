import SwiftUI
import SwiftData

/// **Smṛti · the constellation of memory** (The Eight Modes, mode 4;
/// expansion #35, *the Portrait as night sky*). Every recognition he has made,
/// as light on the yantra: a seat he has felt is lit, and the seats felt on one
/// day are threaded together, so the days he met several of her sisters hang
/// as constellations. A state, never a count (C-1286): a seat felt once and a
/// seat felt a thousand times carry the same light, and nothing on the glass
/// says how many. Design's "23 catches" and "day 191 of 264" are not drawn.
/// It is read from this phone's own record and writes nothing.
struct SmritiView: View {
    let onEnd: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \RecognitionEntry.timestamp) private var moments: [RecognitionEntry]
    @State private var openedAt = Date()

    private var felt: [Smriti.Moment] {
        moments.filter { $0.gesture == .felt && $0.khadgamalaPosition > 0 }
            .map { Smriti.Moment(kp: $0.khadgamalaPosition,
                                 day: DailyEnergyService.practiceDayIndex(for: $0.timestamp)) }
    }

    var body: some View {
        let memory = felt
        let lit = Smriti.lit(memory)
        let threads = Smriti.threads(memory)
        TimelineView(.animation(minimumInterval: 1.0 / 20, paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSince(openedAt)
            let arrive = reduceMotion ? 1 : min(1, t / 3)
            ZStack {
                RadialGradient(colors: [Color(red: 0.05, green: 0.04, blue: 0.10), Color.black],
                               center: .center, startRadius: 0, endRadius: 520)
                    .ignoresSafeArea()
                GeometryReader { geo in
                    let side = min(geo.size.width, geo.size.height)
                    let centre = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.48)
                    let scale = ModeGeometry.scale(side: side)
                    ZStack {
                        ModeYantraBackdrop(wake: 0.2)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .position(centre)
                        Canvas { ctx, _ in
                            ctx.blendMode = .plusLighter
                            // The threads first, faint, so the lights stand on them.
                            for seats in threads {
                                var path = Path()
                                for (n, kp) in seats.enumerated() {
                                    let p = ModeGeometry.screen(kp: kp, centre: centre, scale: scale)
                                    if n == 0 { path.move(to: p) } else { path.addLine(to: p) }
                                }
                                ctx.stroke(path, with: .color(Color.gold.opacity(0.16 * arrive)),
                                           lineWidth: 0.7)
                            }
                            // Every seat waits in a breath of light; a seat he has
                            // felt is lit — one light, the same for every felt seat.
                            for kp in 1...KhadgamalaMap.total {
                                let p = ModeGeometry.screen(kp: kp, centre: centre, scale: scale)
                                if lit.contains(kp) {
                                    let twinkle = reduceMotion ? 1 : 0.82 + 0.18 * sin(t * 0.9 + Double(kp) * 1.7)
                                    ModeLight.draw(in: &ctx, at: p, colour: ModeGeometry.colour(kp: kp),
                                                   radius: 2.6, alpha: arrive * twinkle)
                                } else {
                                    ModeLight.draw(in: &ctx, at: p, colour: Color.cream,
                                                   radius: 0.9, alpha: 0.18 * arrive)
                                }
                            }
                        }
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                    }
                }
                VStack {
                    ModeHeading(title: TheModes.Mode.smriti.title, kicker: "the memory")
                    Spacer()
                    Text(lit.isEmpty ? Self.waiting : Self.alive)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                    ModeRestButton(action: onEnd)
                        .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .theEdgeWayOut(onOut: onEnd)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(lit.isEmpty ? Self.waiting : Self.alive))
        .onAppear { openedAt = Date() }
    }

    /// Design's "where she has been most alive", without the ranking.
    static let alive = "where she has been alive in you"
    static let waiting = "Every seat is waiting in its own light."
}
