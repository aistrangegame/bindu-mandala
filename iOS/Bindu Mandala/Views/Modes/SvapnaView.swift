import SwiftUI
import SwiftData

/// **Svapna · the dream** (The Eight Modes, mode 6; expansion #41, *the
/// watching point dreams*). Design asked at first light, *"Who walked through
/// last night?"* — and here the record answers before he does: the Śaktis of
/// yesterday's record rise as dream-light over a dawn ground, drifting near
/// their seats, their names faint beside them. Nothing asks him to recall or
/// write. When the record holds no one, Design's own words: *"The night was
/// still."* It ends in stillness, and writes nothing.
struct SvapnaView: View {
    let onEnd: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \RecognitionEntry.timestamp) private var moments: [RecognitionEntry]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @State private var openedAt = Date()

    private var walked: [Int] {
        let felt = moments.filter { $0.gesture == .felt }
            .map { (kp: $0.khadgamalaPosition, at: $0.timestamp) }
        return Svapna.walkedThrough(felt, now: Date(),
                                    dayOf: { DailyEnergyService.practiceDayIndex(for: $0) })
    }

    var body: some View {
        let who = walked
        TimelineView(.animation(minimumInterval: 1.0 / 24, paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSince(openedAt)
            let arrive = reduceMotion ? 1 : min(1, t / 4)
            ZStack {
                // A dawn ground: the night's indigo with the first rose under it.
                LinearGradient(colors: [Color(red: 0.03, green: 0.03, blue: 0.09),
                                        Color(red: 0.08, green: 0.04, blue: 0.10),
                                        Color(red: 0.22, green: 0.10, blue: 0.12)],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                GeometryReader { geo in
                    let side = min(geo.size.width, geo.size.height)
                    let centre = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.5)
                    let scale = ModeGeometry.scale(side: side)
                    ZStack {
                        ModeYantraBackdrop(wake: 0.12)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .position(centre)
                        ForEach(Array(who.enumerated()), id: \.element) { n, kp in
                            let seat = ModeGeometry.screen(kp: kp, centre: centre, scale: scale)
                            let drift = reduceMotion ? CGPoint.zero
                                : CGPoint(x: 9 * sin(t * 0.21 + Double(kp)), y: 7 * cos(t * 0.17 + Double(n) * 2.1))
                            let p = CGPoint(x: seat.x + drift.x, y: seat.y + drift.y)
                            let staggered = reduceMotion ? 1 : min(1, max(0, (t - 1.2 * Double(n)) / 3))
                            ZStack {
                                Circle()
                                    .fill(RadialGradient(colors: [ModeGeometry.colour(kp: kp).opacity(0.55), .clear],
                                                         center: .center, startRadius: 0, endRadius: 22))
                                    .frame(width: 44, height: 44)
                                Circle().fill(Color.cream).frame(width: 5, height: 5)
                                    .shadow(color: Color.cream, radius: 6)
                                Text(name(kp))
                                    .font(AppFont.voice(12))
                                    .foregroundStyle(Color.cream)
                                    .fixedSize()
                                    .offset(y: 22)
                            }
                            .opacity(staggered * arrive)
                            .position(p)
                        }
                    }
                }
                VStack {
                    ModeHeading(title: TheModes.Mode.svapna.title, kicker: "before the day")
                    VStack(spacing: 2) {
                        ForEach(Array(Svapna.question.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(AppFont.sanskrit(28))
                                .foregroundStyle(Color.cream.opacity(0.88))
                        }
                    }
                    .padding(.top, 18)
                    Spacer()
                    if who.isEmpty {
                        Text(Svapna.stillNight)
                            .font(AppFont.voice(18))
                            .foregroundStyle(Color.cream.opacity(0.7))
                            .padding(.bottom, 14)
                    }
                    ModeRestButton(action: onEnd)
                        .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .theEdgeWayOut(onOut: onEnd)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(spoken(who)))
        .onAppear { openedAt = Date() }
    }

    private func name(_ kp: Int) -> String {
        let n = shaktis.first { $0.khadgamalaPosition == kp }?.name ?? ""
        return n.isEmpty ? "her seat" : n
    }

    private func spoken(_ who: [Int]) -> String {
        guard !who.isEmpty else { return Svapna.stillNight }
        return "Who walked through last night: " + SakshiClose.list(who.map(name))
    }
}
