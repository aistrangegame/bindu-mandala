import SwiftUI
import SwiftData

/// **Sādhana · the Khaḍgamālā** (The Eight Modes, mode 3; expansion #40,
/// *walk the mālā*). The hundred and two names in sequence, ring by ring
/// inward, each lighting her seat in turn as it is said; at each enclosure
/// Design's crossing — *"You leave … You enter …"*; at the point, the
/// visarjana — *"the garland is offered back to the one who wove it"* — and
/// then only what remains. It ends in stillness.
///
/// The pace is the garland's own (Design's twenty-eight minutes, spread evenly)
/// and is never shown. Leaving is one word at the foot; how far the garland
/// went is kept as a place in the record (``RitesPractice``), never a count.
struct SadhanaView: View {
    let onEnd: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    private enum Stage: Equatable { case sankalpa, reciting, offered, remains }

    @State private var stage: Stage = .sankalpa
    @State private var startedAt = Date()
    @State private var shown = 0
    @State private var crossing: (leaving: Int, entering: Int, at: Date)?
    @State private var reachedRing = 1
    @State private var kept = false
    private let soundOn = (UserDefaults.standard.object(forKey: "lr_sound") as? Bool) ?? true

    var body: some View {
        ZStack {
            Color(red: 6 / 255, green: 2 / 255, blue: 5 / 255).ignoresSafeArea()
            switch stage {
            case .sankalpa: sankalpa
            case .reciting: reciting
            case .offered:  closing(Sadhana.visarjana, gold: true)
            case .remains:  closing(Sadhana.remains, gold: false)
            }
        }
        .preferredColorScheme(.dark)
        .theEdgeWayOut(onOut: { leave() })
        .task(id: stage) { await walk() }
    }

    // MARK: The saṅkalpa

    private var sankalpa: some View {
        VStack(spacing: 0) {
            ModeHeading(title: TheModes.Mode.sadhana.title, kicker: "Saṅkalpa")
            Spacer()
            VStack(spacing: 8) {
                ForEach(Array(Sadhana.sankalpa.enumerated()), id: \.offset) { _, line in
                    Text(line)
                        .font(AppFont.sanskrit(26))
                        .foregroundStyle(Color.cream.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }
            Text(Sadhana.sankalpaNote)
                .font(AppFont.voice(15))
                .foregroundStyle(Color.cream.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 28)
            Spacer()
            Button {
                Haptics.medium()
                startedAt = Date()
                shown = 0
                withAnimation(.easeInOut(duration: 1.2)) { stage = .reciting }
            } label: {
                Text("Begin")
                    .font(AppFont.sanskrit(22))
                    .tracking(2)
                    .foregroundStyle(Color.gold)
                    .padding(.horizontal, 36)
                    .frame(minHeight: 52)
                    .background(Capsule().stroke(Color.gold.opacity(0.5), lineWidth: 0.8))
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            ModeRestButton(words: "not now", action: onEnd)
                .padding(.bottom, 30)
        }
    }

    // MARK: The recitation

    private var reciting: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 30, paused: false)) { tl in
            let now = tl.date
            let i = min(shown, KhadgamalaMap.total - 1)
            let kp = Sadhana.order[i]
            let into = now.timeIntervalSince(startedAt) - Double(i) * Sadhana.perName
            let arrive = reduceMotion ? 1 : min(1, max(0, into / 1.6))
            ZStack {
                GeometryReader { geo in
                    let side = min(geo.size.width, geo.size.height)
                    let centre = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.46)
                    let scale = ModeGeometry.scale(side: side)
                    ZStack {
                        ModeYantraBackdrop(wake: 0.35)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .position(centre)
                        Canvas { ctx, _ in
                            ctx.blendMode = .plusLighter
                            // Every name already said keeps a quiet light at her
                            // seat; the one being said burns.
                            for j in 0...i {
                                let seat = Sadhana.order[j]
                                let p = ModeGeometry.screen(kp: seat, centre: centre, scale: scale)
                                let isNow = j == i
                                ModeLight.draw(in: &ctx, at: p, colour: ModeGeometry.colour(kp: seat),
                                               radius: isNow ? 4.5 : 2,
                                               alpha: isNow ? 0.4 + 0.6 * arrive : 0.5)
                            }
                        }
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                    }
                }
                VStack(spacing: 10) {
                    ModeHeading(title: TheModes.Mode.sadhana.title,
                                kicker: ringWords(KhadgamalaMap.ringNumber(forKhadgamala: kp)))
                    Spacer()
                    if let c = crossing, now.timeIntervalSince(c.at) < 6 {
                        crossingWords(c)
                            .transition(.opacity)
                    }
                    Text(name(kp))
                        .font(AppFont.sanskrit(34))
                        .foregroundStyle(Color.cream)
                        .multilineTextAlignment(.center)
                        .opacity(arrive)
                        .padding(.horizontal, 30)
                        .id(kp)
                    if let q = quality(kp) {
                        Text(q)
                            .font(AppFont.voice(16))
                            .foregroundStyle(Color.gold.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .opacity(arrive)
                            .padding(.horizontal, 36)
                    }
                    Spacer().frame(height: 40)
                    ModeRestButton(action: { leave() })
                        .padding(.bottom, 30)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("The garland — \(name(Sadhana.order[min(shown, KhadgamalaMap.total - 1)]))"))
    }

    private func crossingWords(_ c: (leaving: Int, entering: Int, at: Date)) -> some View {
        VStack(spacing: 4) {
            Text("You leave the \(enclosure(c.leaving)).")
                .font(AppFont.voice(15))
                .foregroundStyle(Color.cream.opacity(0.62))
            Text("You enter \(enclosure(c.entering)).")
                .font(AppFont.voice(17))
                .foregroundStyle(Color.cream.opacity(0.8))
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 30)
        .padding(.bottom, 18)
    }

    // MARK: The offering, and what remains

    private func closing(_ lines: [String], gold: Bool) -> some View {
        VStack(spacing: 10) {
            ModeHeading(title: TheModes.Mode.sadhana.title, kicker: gold ? "Visarjana" : "")
            Spacer()
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color.accentRed.opacity(0.8), .clear],
                                         center: .center, startRadius: 0, endRadius: 40))
                    .frame(width: 90, height: 90)
                Circle().fill(Color.cream).frame(width: 12, height: 12)
                    .shadow(color: Color.cream, radius: 14)
            }
            .accessibilityHidden(true)
            .padding(.bottom, 20)
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(AppFont.sanskrit(23))
                    .foregroundStyle(gold ? Color.gold : Color.cream.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            Spacer()
            ModeRestButton(action: { leave() })
                .padding(.bottom, 30)
        }
        .transition(.opacity)
    }

    // MARK: The walk

    private func walk() async {
        switch stage {
        case .sankalpa:
            return
        case .reciting:
            sound(Sadhana.order[0])
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.25))
                guard !Task.isCancelled else { return }
                let elapsed = Date().timeIntervalSince(startedAt)
                guard let next = Sadhana.index(elapsed: elapsed) else {
                    keep(whole: true)
                    withAnimation(.easeInOut(duration: 2)) { stage = .offered }
                    return
                }
                if next != shown {
                    let before = Sadhana.order[shown]
                    let now = Sadhana.order[next]
                    if let c = Sadhana.crossing(from: before, to: now) {
                        withAnimation(.easeInOut(duration: 1.2)) { crossing = (c.leaving, c.entering, Date()) }
                        Haptics.medium()
                    } else {
                        Haptics.soft()
                    }
                    shown = next
                    reachedRing = max(reachedRing, KhadgamalaMap.ringNumber(forKhadgamala: now))
                    sound(now)
                }
            }
        case .offered:
            try? await Task.sleep(for: .seconds(14))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 3)) { stage = .remains }
        case .remains:
            return
        }
    }

    private func sound(_ kp: Int) {
        guard soundOn, let s = shaktis.first(where: { $0.khadgamalaPosition == kp }) else { return }
        BijaSoundService.shared.playBija(s.bija, seed: kp)
    }

    /// Keep the sitting once — whole when he stayed to the offering, otherwise
    /// the enclosure the garland had reached. A sitting that never began
    /// writes nothing.
    private func keep(whole: Bool) {
        guard !kept, stage != .sankalpa else { return }
        kept = true
        RitesPractice.shared.recite(startedAt: startedAt, reachedRing: reachedRing, whole: whole)
        let ctx = context
        Task { await PracticeLedger.flush(context: ctx) }
    }

    private func leave() {
        if stage == .reciting { keep(whole: false) }
        onEnd()
    }

    // MARK: Words from her rows

    private func name(_ kp: Int) -> String {
        let n = shaktis.first { $0.khadgamalaPosition == kp }?.name ?? ""
        return n.isEmpty ? "her seat" : n
    }

    private func quality(_ kp: Int) -> String? {
        let q = (shaktis.first { $0.khadgamalaPosition == kp }?.quality ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? nil : q
    }

    private func enclosure(_ ring: Int) -> String {
        if let a = avaranas.first(where: { $0.ringNumber == ring }), !a.sanskritName.isEmpty {
            return a.sanskritName
        }
        return "\(ChakraConstellation.ordinal(ring)) enclosure"
    }

    private func ringWords(_ ring: Int) -> String {
        let a = avaranas.first { $0.ringNumber == ring }
        return a?.subtitle ?? enclosure(ring)
    }
}
