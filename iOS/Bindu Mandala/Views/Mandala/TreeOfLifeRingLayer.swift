import SwiftUI
import SwiftData

// MARK: - Wave 6 · B · the Tree of Life through the nine rings, on the descent
//
// As the glass falls into an enclosure, its panel meets him at the threshold:
//
//   1. **the ring-interior beat** (master brief §3) — the ring's Presiding Form
//      named once, softly, from its own Avaraṇa row, and receding;
//   2. **the panel's declaration** — his own Identity line for the ring
//      ("I press where the ground meets me…"), verbatim;
//   3. **the ring's verb**, as the gesture it answers to — and the guide's
//      words for it thinning ring by ring, none from the seventh;
//   4. **the breath arc** — the ring's own breath, its labels taking
//      themselves away (P7 breathes with no word at all);
//   5. **the light** — Progressive Luminance, warm white standing in the air
//      round the Bindu, 5 % at the first ring to 90 % at the eighth (the Bindu
//      itself is Lalitā's whole bloom);
//   6. **the collective breath** — a hold anywhere in the ring that is not a
//      seat (or, from the sixth ring, simply being still) makes every Śakti in
//      the ring breathe together once: the ring's verb at ring scale. Its
//      legibility follows the Yoginī gradient — obvious at the rim, barely
//      there at the centre.
//
// And the Om's floor follows the depth (``SoundConductor/setDepth(_:)``);
// Sakshi speaks once on the way down, at the witness ring.

@MainActor
struct TreeOfLifeRingLayer: View {
    /// The enclosure the glass has fallen into; `0` outside the yantra.
    let ring: Int
    /// Whether the threshold may speak — not under a card, the Veil or the source.
    let active: Bool
    let camera: MandalaCamera
    let seats: [MandalaWorld.Seat]
    /// How long the glass has lain untouched.
    let stillSeconds: Double
    /// When a hold in the ring last completed — the gesture catcher's
    /// `LongPressGesture` of ``TreeOfLife/holdSeconds(ring:)``.
    let heldAt: Date?
    let soundOn: Bool

    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var threshold: Int?
    @State private var formShown = false
    @State private var declarationShown = false
    @State private var breathFrom: Date?
    @State private var breathingTogether: Date?
    @State private var stillAnswered = false

    var body: some View {
        ZStack {
            luminance
            if active { collectiveBreath }
            if active, let r = threshold { thresholdWords(r) }
            if active, let r = threshold, let from = breathFrom, let arc = TreeOfLife.breath(ring: r) {
                BreathArcView(arc: arc, from: from, reduceMotion: reduceMotion)
            }
            TrinityVoiceLayer(place: active && ring == TrinityOfGuidance.witnessRing
                                ? .descent(ring: ring) : nil,
                              delay: 3.5)
        }
        .allowsHitTesting(false)
        .onChange(of: ring) { old, new in
            SoundConductor.shared.setDepth(new)
            stillAnswered = false
            guard active, new > old, (1...8).contains(new) else { return }
            Task { await arrive(at: new) }
        }
        .onChange(of: heldAt) { _, held in
            guard held != nil, active, TreeOfLife.answer(ring: ring).pressSeconds != nil else { return }
            breathe()
        }
        .onChange(of: stillSeconds) { _, s in
            guard active, !stillAnswered,
                  let needed = TreeOfLife.answer(ring: ring).stillnessSeconds,
                  s >= needed else { return }
            stillAnswered = true
            breathe()
        }
        .onAppear { SoundConductor.shared.setDepth(ring) }
    }

    // MARK: Arriving at a threshold

    private func arrive(at r: Int) async {
        threshold = r
        formShown = false
        declarationShown = false
        breathFrom = nil
        let ease: Animation? = reduceMotion ? nil : .easeInOut(duration: 1.6)
        // The presiding form, named once.
        withAnimation(ease) { formShown = true }
        try? await Task.sleep(for: .seconds(2.8))
        guard threshold == r else { return }
        withAnimation(ease) { formShown = false }
        // His declaration, and the ring's breath under it.
        withAnimation(ease) { declarationShown = true }
        breathFrom = Date()
        let stand = max(8, TreeOfLife.breath(ring: r)?.seconds ?? 0)
        try? await Task.sleep(for: .seconds(stand))
        guard threshold == r else { return }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 2.4)) { declarationShown = false }
        try? await Task.sleep(for: .seconds(2.6))
        guard threshold == r else { return }
        breathFrom = nil
        threshold = nil
    }

    @ViewBuilder
    private func thresholdWords(_ r: Int) -> some View {
        let tint = Atmosphere.derive(ring: r, cluster: r == 2 ? .inner : nil,
                                     khadgamala: KhadgamalaMap.ringStartOffset(r) + 1,
                                     element: Element.forRing(r)).accentBright
        let guide = TreeOfLife.guideWords(ring: r)
        VStack(spacing: 14) {
            if let form = presidingForm(r) {
                Text(form)
                    .font(AppFont.sanskrit(22)).tracking(1.4)
                    .foregroundStyle(tint)
                    .shadow(color: tint.opacity(0.7), radius: 14)
                    .opacity(formShown ? 0.9 : 0)
            }
            if let panel = GameStructure.panel(ring: r) {
                Text(panel.declaration)
                    .font(AppFont.voice(19))
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .shadow(color: .black.opacity(0.9), radius: 14)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(declarationShown ? 1 : 0)
                // The guide thins by words, not by fading below legibility:
                // the verb and how to answer it in the outer rings, the verb
                // alone in the middle three, and nothing from the seventh.
                if guide > 0, let verb = TreeOfLife.verb(ring: r) {
                    Text(verb)
                        .font(AppFont.label(11)).tracking(2.8)
                        .textCase(.uppercase)
                        .foregroundStyle(tint)
                        .opacity(declarationShown ? 0.85 : 0)
                    if guide >= 0.5 {
                        Text(answerHint(r))
                            .font(AppFont.voice(13))
                            .foregroundStyle(Color.cream.opacity(0.6))
                            .opacity(declarationShown ? 1 : 0)
                    }
                }
            }
        }
        .padding(.top, 150)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .accessibilityElement(children: .combine)
    }

    /// The guide's own instruction for the ring's answer — present only while
    /// the guide is still speaking.
    private func answerHint(_ r: Int) -> String {
        let answer = TreeOfLife.answer(ring: r)
        if answer.pressSeconds != nil { return "hold anywhere the ring is open, and it breathes with you" }
        if answer.stillnessSeconds != nil { return "be still, and it breathes with you" }
        return ""
    }

    private func presidingForm(_ r: Int) -> String? {
        let form = avaranas.first { $0.ringNumber == r }?.presidingForm?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return form.isEmpty ? nil : form
    }

    // MARK: The light

    private var luminance: some View {
        let lum = active ? TreeOfLife.luminance(ring: ring) : 0
        let c = camera.binduScreen()
        return GeometryReader { geo in
            let reach = max(geo.size.width, geo.size.height) * (0.35 + 0.65 * lum)
            RadialGradient(colors: [Color(red: 1, green: 0.96, blue: 0.86).opacity(0.34 * lum),
                                    Color(red: 1, green: 0.92, blue: 0.78).opacity(0.10 * lum),
                                    .clear],
                           center: UnitPoint(x: c.x / max(geo.size.width, 1),
                                             y: c.y / max(geo.size.height, 1)),
                           startRadius: 0, endRadius: reach)
                .blendMode(.plusLighter)
        }
        .ignoresSafeArea()
        .animation(reduceMotion ? nil : .easeInOut(duration: 3.2), value: ring)
    }

    // MARK: The ring breathing together

    private func breathe() {
        breathingTogether = Date()
        if ring <= 5 { Haptics.soft() }
        if soundOn { RingAudioService.shared.ringBija(ring) }
    }

    /// How long the ring's one shared breath takes.
    /// Wave 6.1 · three beats of the one breath clock (``BreathClock/beat``).
    static let breathSeconds: Double = BreathClock.period(beats: 3)

    @ViewBuilder
    private var collectiveBreath: some View {
        if let since = breathingTogether {
            TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { tl in
                let age = tl.date.timeIntervalSince(since)
                let k = age < Self.breathSeconds ? sin(.pi * age / Self.breathSeconds) : 0
                let amp = (reduceMotion ? 0.6 : k) * TreeOfLife.legibility(ring: ring)
                Canvas { ctx, _ in
                    guard amp > 0.001 else { return }
                    ctx.blendMode = .plusLighter
                    for seat in seats where seat.shakti.ringNumber == ring {
                        let p = camera.screen(for: seat.point)
                        let r = 10 + 26 * amp
                        let rect = CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)
                        ctx.fill(Path(ellipseIn: rect),
                                 with: .radialGradient(Gradient(colors: [Color.gold.opacity(0.75 * amp),
                                                                         Color.gold.opacity(0)]),
                                                       center: p, startRadius: 0, endRadius: r))
                    }
                }
            }
            .task(id: since) {
                try? await Task.sleep(for: .seconds(Self.breathSeconds + 0.2))
                if breathingTogether == since { breathingTogether = nil }
            }
        }
    }
}

// MARK: - The breath arc

/// One ring's guided breath: a soft circle that grows on the in-breath and
/// settles on the out, with the guide's word for each phase — until the guide
/// has none left to say.
struct BreathArcView: View {
    let arc: TreeOfLife.Breath
    let from: Date
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSince(from)
            let state = Self.moment(arc: arc, at: t)
            VStack(spacing: 10) {
                Circle()
                    .stroke(Color.cream.opacity(0.35 * state.presence), lineWidth: 1)
                    .background(Circle().fill(Color.cream.opacity(0.06 * state.presence)))
                    .frame(width: 34 + 40 * state.fill, height: 34 + 40 * state.fill)
                    .shadow(color: Color.cream.opacity(0.4 * state.presence), radius: 10)
                Text(state.label ?? " ")
                    .font(AppFont.label(11)).tracking(2.4)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.cream.opacity(0.6 * state.presence))
            }
            .padding(.bottom, 170)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .accessibilityHidden(true)
    }

    struct Moment: Equatable {
        var fill: Double
        var label: String?
        var presence: Double
    }

    /// Pure: where in the breath he is at `t` seconds — how full the circle
    /// stands, the guide's word (if any), and whether the arc is still running.
    static func moment(arc: TreeOfLife.Breath, at t: Double) -> Moment {
        let cycle = arc.phases.reduce(0) { $0 + $1.seconds }
        guard cycle > 0, t >= 0, t < cycle * Double(arc.cycles) else {
            return Moment(fill: 0, label: nil, presence: 0)
        }
        var u = t.truncatingRemainder(dividingBy: cycle)
        var fill = 0.0
        var level = 0.0
        for (i, phase) in arc.phases.enumerated() {
            if u < phase.seconds {
                let k = u / phase.seconds
                if i == 0 { fill = k }                                  // the in-breath
                else if i == arc.phases.count - 1 { fill = level * (1 - k) } // the out-breath
                else { fill = level }                                   // a hold
                return Moment(fill: fill, label: phase.label, presence: 1)
            }
            u -= phase.seconds
            level = i == 0 ? 1 : level
        }
        return Moment(fill: 0, label: nil, presence: 1)
    }
}
