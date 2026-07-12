import SwiftUI
import SwiftData

/// The Daily Rite — she generates her own arrival. Her element chooses one of six
/// compositions (ascension / descent / horizon / veil / foundation / radiance);
/// her ring the geometry; the Atmosphere engine her whole palette, re-lit by the
/// hour. Nothing is hand-picked; nothing renders blank for the 86. Her name is a
/// door; "I feel her" opens the recognition ceremony.
struct DailyRiteView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]
    @Query(sort: \NityaDevi.tithiPosition) private var nityas: [NityaDevi]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    @State private var arrived = false
    @State private var showRecognition = ProcessInfo.processInfo.arguments.contains("AUTO_RECOGNIZE")
    @State private var nityaDetailFor: NityaSlot?
    @State private var detailFor: Shakti?

    // MARK: - Today's energy (all 102, 6am boundary — unchanged)

    var today: Shakti? {
        guard !shaktis.isEmpty else { return nil }
        if let arg = ProcessInfo.processInfo.arguments.first(where: { $0.hasPrefix("ENERGY_POS=") }),
           let pos = Int(arg.dropFirst("ENERGY_POS=".count)),
           let s = shaktis.first(where: { $0.khadgamalaPosition == pos }) {
            return s
        }
        let hasFull = shaktis.contains { ($0.khadgamalaPosition ?? 0) > 0 }
        if hasFull {
            let pos = DailyEnergyService.todaysPosition()
            if let s = shaktis.first(where: { $0.khadgamalaPosition == pos }) { return s }
        }
        let sorted = shaktis.sorted {
            ($0.khadgamalaPosition ?? $0.position) < ($1.khadgamalaPosition ?? $1.position)
        }
        let idx = DailyEnergyService.todaysPosition(count: sorted.count) - 1
        return sorted[min(max(0, idx), sorted.count - 1)]
    }

    var body: some View {
        ZStack {
            if let s = today {
                rite(for: s)
            } else {
                Color.ground.ignoresSafeArea()
                ProgressView().tint(Color.gold)
            }
        }
        .onAppear {
            withAnimation(reduceMotion ? nil : .easeOut(duration: 1.2)) { arrived = true }
        }
        .fullScreenCover(isPresented: $showRecognition) {
            if let s = today { RecognitionMomentView(shakti: s, isPresented: $showRecognition) }
        }
        .fullScreenCover(item: $detailFor) { shakti in
            NavigationStack { ShaktiDetailView(shakti: shakti) }
        }
        .sheet(item: $nityaDetailFor) { slot in
            NityaDetailView(slot: slot)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - The composed rite

    @ViewBuilder
    private func rite(for s: Shakti) -> some View {
        let atmo = Atmosphere.derive(from: s, at: LunarPhaseService.currentTimeVariant())
        let comp = RiteComposition.derive(kp: s.khadgamalaPosition ?? s.position, element: s.element)
        let plan = RitePlan.forElement(comp.element)
        let content = RiteContent(shakti: s, avaranaSubtitle: avaranaSubtitle(for: s))

        ZStack {
            AtmosphereBackground(atmosphere: atmo)

            sigilLayer(atmo: atmo, plan: plan, comp: comp, ring: content.ring)
                .opacity(arrived ? 0.7 : 0)

            if plan.veilName { veilName(content, atmo: atmo, onOpen: { detailFor = s }) }

            DustMotesView(count: 12).allowsHitTesting(false)

            VStack(spacing: 0) {
                celestialStrip(atmo: atmo)
                Spacer(minLength: 0)
                centerStack(s: s, content: content, atmo: atmo, plan: plan, comp: comp)
                    .allowsHitTesting(!plan.veilName)   // the veil name is the door
                Spacer(minLength: 0)
                foot(s: s, content: content, atmo: atmo)
            }
            .opacity(arrived ? 1 : 0)
            .offset(y: arrived ? 0 : 8)
        }
    }

    // MARK: - Sigil placement (per plan)

    @ViewBuilder
    private func sigilLayer(atmo: Atmosphere, plan: RitePlan, comp: RiteComposition, ring: Int) -> some View {
        let base: CGFloat = plan.sigil == .bottomBig ? 760 : plan.sigil == .centerBig ? 560 : 620
        let size = base * plan.sigilScale * comp.sigilScale
        let sigil = RiteSigil(atmosphere: atmo, ring: ring, size: size, spin: comp.spin, reduceMotion: reduceMotion)
        switch plan.sigil {
        case .bottom:
            sigil.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom).offset(y: 60)
        case .bottomWide:
            sigil.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom).offset(y: 150)
        case .bottomBig:
            sigil.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom).offset(y: 230)
        case .side:
            sigil.frame(maxWidth: .infinity, maxHeight: .infinity,
                        alignment: comp.flip ? .leading : .trailing)
                .offset(x: comp.flip ? -220 : 220)
        case .center, .centerBig:
            sigil
        }
    }

    private func veilName(_ content: RiteContent, atmo: Atmosphere, onOpen: @escaping () -> Void) -> some View {
        Button(action: { Haptics.light(); onOpen() }) {
            Text(content.name)
                .font(.custom(AppFont.cormorant, size: min(content.nameSize(cap: 120, nudge: 0) * 1.7, 150)))
                .fontWeight(.light)
                .lineSpacing(-6)
                .foregroundStyle(atmo.accentFaint)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .padding(24)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(arrived ? 1 : 0)
        .accessibilityLabel("\(content.name) — open her presence")
    }

    // MARK: - Celestial strip (moon + Nityā — unchanged behavior)

    private func celestialStrip(atmo: Atmosphere) -> some View {
        VStack(spacing: 0) {
            MoonPhaseView().padding(.top, 8).padding(.bottom, 10)
            nityaCardLayer
        }
        .opacity(arrived ? 1 : 0)
    }

    // MARK: - Center stack (plan-ordered blocks)

    private func centerStack(s: Shakti, content: RiteContent, atmo: Atmosphere,
                             plan: RitePlan, comp: RiteComposition) -> some View {
        let lean = plan.align == .lean
        let leadingEdge = !comp.flip
        let hAlign: HorizontalAlignment = lean ? (leadingEdge ? .leading : .trailing) : .center
        let tAlign: TextAlignment = lean ? (leadingEdge ? .leading : .trailing) : .center
        let nameSize = content.nameSize(cap: plan.nameCap, nudge: comp.nameSizeNudge)

        let ctx = RiteRenderContext(
            content: content, atmosphere: atmo, plan: plan, nameSize: nameSize,
            align: hAlign, textAlign: tAlign, leadingEdge: leadingEdge,
            onOpenDetail: { Haptics.light(); detailFor = s }
        )

        return VStack(alignment: hAlign, spacing: 0) {
            ForEach(Array(plan.order.enumerated()), id: \.offset) { _, block in
                RiteBlockView(kind: block, ctx: ctx)
            }
        }
        .frame(maxWidth: lean ? 320 : 360, alignment: alignment(hAlign))
        .padding(.horizontal, lean ? 26 : 28)
        .frame(maxWidth: .infinity, alignment: alignment(hAlign))
    }

    // MARK: - Foot (I feel her + position)

    private func foot(s: Shakti, content: RiteContent, atmo: Atmosphere) -> some View {
        VStack(spacing: 14) {
            Button(action: triggerRecognition) {
                Text("I feel her")
                    .font(.custom(AppFont.cormorant, size: 23))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Capsule()
                            .fill(LinearGradient(colors: [Color.accentRed,
                                                          Color.accentRed.opacity(0.7)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: atmo.glow, radius: 30, y: 4)
                            .shadow(color: Color.accentRed.opacity(0.5), radius: 26, y: 4)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("I feel her — record recognition of \(content.spokenName)")

            Text("\(content.kp) of 102" + (content.bija.map { " · bīja \($0)" } ?? ""))
                .font(.system(size: 11))
                .tracking(1.6)
                .foregroundStyle(Color.cream.opacity(0.44))
        }
        .padding(.horizontal, 26)
        .padding(.bottom, 20)
        .opacity(arrived ? 1 : 0)
    }

    // MARK: - Helpers

    private func avaranaSubtitle(for s: Shakti) -> String? {
        avaranas.first(where: { $0.ringNumber == (s.ringNumber ?? 2) })?.subtitle
    }

    private func alignment(_ h: HorizontalAlignment) -> Alignment {
        switch h {
        case .leading:  return .leading
        case .trailing: return .trailing
        default:        return .center
        }
    }

    private func triggerRecognition() {
        Haptics.medium()
        showRecognition = true
    }

    // MARK: - Nityā layer (unchanged)

    private var nityaSlot: NityaSlot {
        let f = LunarPhaseService.phaseFraction()
        if f >= 0.47 && f <= 0.53 {
            if let ring9 = avaranas.first(where: { $0.ringNumber == 9 }) { return .lalita(ring9) }
            return .unknown
        }
        let day = LunarPhaseService.currentDay()
        let position = day <= 15 ? day : 15 - (day - 15)
        let resolved = position >= 1 ? position : 1
        if let nitya = nityas.first(where: { $0.tithiPosition == resolved }) { return .nitya(nitya) }
        return .unknown
    }

    @ViewBuilder
    private var nityaCardLayer: some View {
        let slot = nityaSlot
        if case .unknown = slot { EmptyView() } else { nityaCard(slot).padding(.bottom, 6) }
    }

    private func nityaCard(_ slot: NityaSlot) -> some View {
        let display = nityaCardDisplay(slot)
        return Button { nityaDetailFor = slot } label: {
            VStack(spacing: 4) {
                Text(display.name)
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(1.2)
                    .foregroundStyle(Color.gold)
                if !display.epithet.isEmpty {
                    Text(display.epithet.uppercased())
                        .font(.system(size: 10))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream.opacity(0.55))
                }
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private struct NityaCardDisplay { let name: String; let epithet: String }

    private func nityaCardDisplay(_ slot: NityaSlot) -> NityaCardDisplay {
        switch slot {
        case .nitya(let n): return NityaCardDisplay(name: n.sanskritName, epithet: n.quality ?? "")
        case .lalita: return NityaCardDisplay(name: "Lalitā Mahātripurasundarī", epithet: "Pūrṇimā · Full Moon")
        case .unknown: return NityaCardDisplay(name: "", epithet: "")
        }
    }
}
