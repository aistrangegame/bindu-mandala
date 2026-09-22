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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
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
            // Debug: `OPEN_NITYA` opens today's Nityā sheet directly.
            if ProcessInfo.processInfo.arguments.contains("OPEN_NITYA") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { nityaDetailFor = nityaSlot }
            }
        }
        .fullScreenCover(isPresented: $showRecognition) {
            if let s = today { RecognitionMomentView(shakti: s, isPresented: $showRecognition) }
        }
        .fullScreenCover(item: $detailFor) { shakti in
            NavigationStack { ShaktiDetailView(shakti: shakti, backLabel: "today") }
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

            DustMotesView(count: 16, element: atmo.element, accent: atmo.accentBright)
                .allowsHitTesting(false)
            DepthOverlay()

            column(s: s, content: content, atmo: atmo, plan: plan, comp: comp)
                .opacity(arrived ? 1 : 0)
                .offset(y: arrived ? 0 : 8)
        }
    }

    /// The Rite's own column: the strip at the top, her arrival held in the
    /// middle by two spacers, the foot at the bottom. A still tableau, and the
    /// only screen in the app that is deliberately not a scroll view.
    ///
    /// **Except at an accessibility type size.** The two `Spacer(minLength: 0)`
    /// are already at zero on the smallest screen at the default size — the foot
    /// sits twenty points off the bottom of an SE — so the column has nowhere to
    /// grow. Type that grows inside a height it cannot exceed does not overflow;
    /// SwiftUI proposes each string less room and the strings *truncate*, and at
    /// the largest size the day's question read "“Where does w…" while the moon
    /// was pushed up under the status bar. A question the walker cannot read is
    /// not a rite.
    ///
    /// So above `.accessibility1` the column is given somewhere to go, and
    /// nothing else changes: same blocks, same order, same spacers, same
    /// composition. Below it — every size a walker who has not turned on
    /// accessibility type will ever see — this is the same fixed `VStack` the
    /// baselines were recorded against, and `ScrollView` is never built.
    @ViewBuilder
    private func column(s: Shakti, content: RiteContent, atmo: Atmosphere,
                        plan: RitePlan, comp: RiteComposition) -> some View {
        let stack = VStack(spacing: 0) {
            celestialStrip(atmo: atmo)
            Spacer(minLength: 0)
            centerStack(s: s, content: content, atmo: atmo, plan: plan, comp: comp)
                .allowsHitTesting(!plan.veilName)   // the veil name is the door
            Spacer(minLength: 0)
            foot(s: s, content: content, atmo: atmo)
        }

        if dynamicTypeSize.isAccessibilitySize {
            GeometryReader { geo in
                ScrollView {
                    // The floor keeps the spacers doing their work whenever the
                    // column still fits: the tableau holds until it cannot, and
                    // only then does it scroll.
                    stack.frame(minHeight: geo.size.height)
                }
                .scrollIndicators(.hidden)
            }
        } else {
            stack
        }
    }

    // MARK: - Sigil placement (per plan)

    /// Reference width the prototype's sigil sizes / offsets were tuned against
    /// (a standard iPhone). Everything scales off this so the sigil is the same
    /// *proportion* of the screen on every device.
    private static let sigilReferenceWidth: CGFloat = 390

    private func sigilLayer(atmo: Atmosphere, plan: RitePlan, comp: RiteComposition, ring: Int) -> some View {
        let base: CGFloat = plan.sigil == .bottomBig ? 760 : plan.sigil == .centerBig ? 560 : 620

        let alignment: Alignment
        let dx: CGFloat, dy: CGFloat
        switch plan.sigil {
        case .bottom:     alignment = .bottom; dx = 0; dy = 60
        case .bottomWide: alignment = .bottom; dx = 0; dy = 150
        case .bottomBig:  alignment = .bottom; dx = 0; dy = 230
        case .side:       alignment = comp.flip ? .leading : .trailing
                          dx = comp.flip ? -220 : 220; dy = 0
        case .center, .centerBig: alignment = .center; dx = 0; dy = 0
        }

        // Device-responsive: the base sizes (620–760) and offsets (±220/+230) were
        // absolute points tuned for one ~390pt frame, so the sigil dominated small
        // phones and drifted on large ones ("zoomed"). Scale everything by the
        // device's shorter side ÷ the reference width so it holds the same
        // proportion everywhere. Overlaying on a flexible `Color.clear` pins the
        // *reported* size to the screen while the sigil overdraws to its full size,
        // so it never inflates RootView's stack and pushes the hamburger off-edge.
        return GeometryReader { geo in
            let scale = min(geo.size.width, geo.size.height) / Self.sigilReferenceWidth
            let size = base * plan.sigilScale * comp.sigilScale * scale
            let sigil = RiteSigil(atmosphere: atmo, ring: ring, size: size, spin: comp.spin)
            Color.clear
                .overlay(alignment: alignment) { sigil.offset(x: dx * scale, y: dy * scale) }
        }
        .allowsHitTesting(false)
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

    // MARK: - Celestial strip (moon · tithi · Nityā, one tappable line)

    /// One line — the moon glyph, today's tithi, and who presides — tapping opens
    /// the Nityā sheet. Ported from the prototype's celestial strip.
    private func celestialStrip(atmo: Atmosphere) -> some View {
        let slot = nityaSlot
        return VStack(spacing: -1) {
            MoonPhaseView().padding(.top, 8)
            if let label = celestialLabel(slot) {
                Button {
                    Haptics.light()
                    nityaDetailFor = slot
                } label: {
                    HStack(spacing: 8) {
                        Text(label)
                            .font(AppFont.label(11.5))
                            .tracking(1.0)
                            .foregroundStyle(Color.cream.opacity(0.62))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        Text("›")
                            .font(AppFont.label(12))
                            .foregroundStyle(atmo.accentBright.opacity(0.75))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .padding(.top, 8)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .opacity(arrived ? 1 : 0)
    }

    /// "Śukla Dvitīyā · Bhagamālinī" — paksha + tithi + who presides. Nil pre-sync
    /// (no Nityā resolved), where only the moon glyph shows.
    private func celestialLabel(_ slot: NityaSlot) -> String? {
        switch slot {
        case .nitya(let n):
            let paksha = LunarPhaseService.currentDay() <= 15 ? "Śukla" : "Kṛṣṇa"
            return "\(paksha) \(n.tithiDisplayName) · \(n.sanskritName)"
        case .lalita:
            return "Pūrṇimā · Lalitā Mahātripurasundarī"
        case .unknown:
            return nil
        }
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
                    .font(AppFont.sanskrit(23))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 60)
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
                .font(AppFont.label(11))
                .tracking(1.6)
                .foregroundStyle(Color.cream.opacity(0.55))
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
}
