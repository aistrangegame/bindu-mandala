import SwiftUI
import SwiftData

/// **Pūjā · the evening offering** (The Eight Modes, mode 7; expansion #17,
/// the dusk rite). *"At day's end. The day's catches witnessed. Offered.
/// Released."* The Śaktis he caught today stand as lights at their seats; he
/// holds, and they draw in to the point, rise, and are gone into it — *"The
/// day is received. Tomorrow opens again."* A day with no catch is offered
/// whole. Design's "five recognitions, this day" is not drawn: the lights are
/// the day, and nothing counts them. The offering is one row in the ledger
/// (``RitesPractice``), and the glass ends in stillness.
struct PujaView: View {
    let onEnd: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \RecognitionEntry.timestamp) private var moments: [RecognitionEntry]

    @State private var holding = false
    @State private var held: CGFloat = 0
    @State private var offeredAt: Date?

    private var gathered: [Int] {
        let felt = moments.filter { $0.gesture == .felt }
            .map { (kp: $0.khadgamalaPosition, at: $0.timestamp) }
        return Puja.gathered(felt, now: Date(), dayOf: { DailyEnergyService.practiceDayIndex(for: $0) })
    }

    var body: some View {
        let lights = gathered
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion && offeredAt == nil)) { tl in
            let since = offeredAt.map { tl.date.timeIntervalSince($0) } ?? 0
            let r: (gather: Double, rise: Double, light: Double) = offeredAt == nil
                ? (gather: 0, rise: 0, light: 1)
                : Puja.release(reduceMotion ? (since >= 3 ? 1.0 : 0.0) : since / 6)
            ZStack {
                RadialGradient(colors: [Color(red: 0.10, green: 0.04, blue: 0.05), Color(red: 0.02, green: 0, blue: 0.01)],
                               center: .center, startRadius: 0, endRadius: 520)
                    .ignoresSafeArea()
                GeometryReader { geo in
                    let side = min(geo.size.width, geo.size.height)
                    let centre = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.46)
                    let scale = ModeGeometry.scale(side: side)
                    ZStack {
                        ModeYantraBackdrop(wake: 0.25 + 0.5 * r.rise)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .position(centre)
                        Canvas { ctx, _ in
                            ctx.blendMode = .plusLighter
                            for kp in lights {
                                let seat = ModeGeometry.screen(kp: kp, centre: centre, scale: scale)
                                let g = CGFloat(r.gather)
                                let p = CGPoint(x: seat.x + (centre.x - seat.x) * g,
                                                y: seat.y + (centre.y - seat.y) * g - CGFloat(r.rise) * 160)
                                ModeLight.draw(in: &ctx, at: p, colour: ModeGeometry.colour(kp: kp),
                                               radius: 3.2, alpha: r.light)
                            }
                            // The point receives them.
                            let glow = 26 + 40 * CGFloat(r.gather)
                            ctx.fill(Path(ellipseIn: CGRect(x: centre.x - glow, y: centre.y - glow,
                                                            width: glow * 2, height: glow * 2)),
                                     with: .radialGradient(Gradient(colors: [Color.accentRed.opacity(0.85), .clear]),
                                                           center: centre, startRadius: 0, endRadius: glow))
                            let heart: CGFloat = 5
                            ctx.fill(Path(ellipseIn: CGRect(x: centre.x - heart, y: centre.y - heart,
                                                            width: heart * 2, height: heart * 2)),
                                     with: .color(Color.cream))
                        }
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                    }
                }
                VStack(spacing: 12) {
                    ModeHeading(title: TheModes.Mode.puja.title, kicker: "the offering")
                    Spacer()
                    if offeredAt != nil {
                        ForEach(Array(Puja.received.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(AppFont.sanskrit(26))
                                .foregroundStyle(Color.cream.opacity(0.9))
                        }
                        .opacity(min(1, max(0, (since - 2.5) / 2)))
                        Spacer().frame(height: 30)
                        ModeRestButton(words: "sleep with the field", action: onEnd)
                            .padding(.bottom, 30)
                    } else {
                        if lights.isEmpty {
                            Text(Puja.emptyDay)
                                .font(AppFont.voice(17))
                                .foregroundStyle(Color.cream.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 36)
                        }
                        offerControl
                        ModeRestButton(words: "not now", action: onEnd)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .theEdgeWayOut(onOut: onEnd)
    }

    /// Hold to offer — the ring fills under his hand, and on the full hold the
    /// day is given.
    private var offerControl: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().stroke(Color.gold.opacity(0.3), lineWidth: 1)
                Circle()
                    .trim(from: 0, to: held)
                    .stroke(Color.gold, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Circle().fill(Color.gold.opacity(holding ? 0.5 : 0.25)).frame(width: 16, height: 16)
            }
            .frame(width: 72, height: 72)
            .contentShape(Circle())
            .onLongPressGesture(minimumDuration: Puja.holdSeconds, maximumDistance: 40,
                                perform: { offer() },
                                onPressingChanged: { down in
                                    holding = down
                                    if down {
                                        Haptics.soft()
                                        withAnimation(.linear(duration: Puja.holdSeconds)) { held = 1 }
                                    } else if offeredAt == nil {
                                        withAnimation(.easeOut(duration: 0.3)) { held = 0 }
                                    }
                                })
            .accessibilityElement()
            .accessibilityLabel(Text(Puja.offer))
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { offer() }
            Text(Puja.offer)
                .font(AppFont.label(12))
                .tracking(2.4)
                .textCase(.uppercase)
                .foregroundStyle(Color.cream.opacity(0.62))
        }
        .padding(.bottom, 10)
    }

    private func offer() {
        guard offeredAt == nil else { return }
        Haptics.medium()
        offeredAt = Date()
        RitesPractice.shared.offerTheDay(todayPosition: AppRuntime.pinnedEnergyPosition
                                            ?? DailyEnergyService.todaysPosition())
        RiteHooks.dayClosed()
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }
}
