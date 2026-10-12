import SwiftUI
import SwiftData

/// The Daily Rite — she generates her own arrival. Her element chooses one of six
/// compositions (ascension / descent / horizon / veil / foundation / radiance);
/// her ring the geometry; the Atmosphere engine her whole palette, re-lit by the
/// hour. Nothing is hand-picked; nothing renders blank for the 86. Her name is a
/// door; "I feel her" opens the recognition ceremony.
///
/// **Wave 1 · the light comes home.** She arrives in Design's nine beats — the
/// strip, the kicker, her name, its sound, the door, the rule, her quality, the
/// question, the foot (`ArrivalBeat`) — each rising ten points over 1.3 s on its
/// own delay, while her ring's geometry comes up beneath them over 2.4 s to the
/// brightness Design drew it (`DayLight.riteSigilOpacity`, ≈2.6× the first
/// port). The ground is `lrBackdrop` layer for layer; air leans; "I feel her"
/// carries a third of her hue and breathes at her ring's rate.
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
    /// Wave 2 · today's room, opened from her seat in the foot.
    @State private var roomKp: Int?
    /// Wave 6 · the Rite's opening (Arrival): the hour's call, "Stop. Breathe.
    /// Remember.", the Sacred Pause. Set while it stands; the nine beats wait.
    @State private var opening: RiteOpening.Kind?
    /// Wave 6 · Offering and Carry, after she has been felt.
    @State private var closing = false
    /// Wave 6 · the low-state door.
    @State private var lowOpen = false

    /// UI tests and captures read the Rite as Wave 1 composed it: no opening
    /// in front of it and no close over it.
    private static let openingsSkipped: Bool = AppRuntime.isUnitTesting
        || ProcessInfo.processInfo.arguments.contains("SKIP_HOMECOMING")
        || ProcessInfo.processInfo.arguments.contains("SKIP_OPENING")

    // MARK: - Today's energy (all 102, 6am boundary — unchanged)

    var today: Shakti? {
        guard !shaktis.isEmpty else { return nil }
        // One rule for the pin, app-wide: the last `ENERGY_POS` wins (Wave 0 · B8).
        if let pos = AppRuntime.pinnedEnergyPosition,
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

    /// Reduce motion — the system's, read live, or the launch argument's.
    private var still: Bool { reduceMotion || AppRuntime.forcesReduceMotion }

    var body: some View {
        ZStack {
            if let s = today {
                rite(for: s)
                    .onAppear(perform: beginArrival)
                // Wave 6 · Offering and Carry close the Rite once she is felt.
                if closing {
                    let words = RiteStation.closing(
                        appreciation: s.appreciationPhrase, recognition: s.recognitionPhrase,
                        somaticLine: SensoryDoorway.line(somaticSignature: s.somaticPoetry,
                                                         somaticPrompt: s.somatic))
                    RiteClosingStations(offering: words.offering, carry: words.carry, still: still,
                                        onDone: { withAnimation(.easeInOut(duration: 0.6)) { closing = false } })
                        .transition(.opacity)
                        .zIndex(5)
                }
                // Wave 6 · Arrival: the opening stands before the nine beats.
                if let kind = opening {
                    RiteOpeningView(kind: kind,
                                    yearLight: RiteOpening.yearLight(practiceDay: DailyEnergyService.practiceDayIndex()),
                                    still: still,
                                    onDone: { finishOpening() })
                        .transition(.opacity)
                        .zIndex(10)
                }
            } else {
                Color.ground.ignoresSafeArea()
                ProgressView().tint(Color.gold)
            }
        }
        // Wave 6 · when the ceremony closes, the Rite's last two stations.
        .onChange(of: showRecognition) { was, now in
            if was && !now { beginClosing() }
        }
        .fullScreenCover(isPresented: $lowOpen) {
            LowStateDoorView(onClose: { lowOpen = false })
        }
        .onAppear {
            // Debug: `OPEN_NITYA` opens today's Nityā sheet directly.
            if ProcessInfo.processInfo.arguments.contains("OPEN_NITYA") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { nityaDetailFor = nityaSlot }
            }
        }
        .fullScreenCover(isPresented: $showRecognition) {
            if let s = today { RecognitionMomentView(shakti: s, isPresented: $showRecognition) }
        }
        .fullScreenCover(item: $detailFor) { shakti in
            NavigationStack { ShaktiDetailView(shakti: shakti, backLabel: "today", source: .today) }
        }
        .herRoom($roomKp)
        .sheet(item: $nityaDetailFor) { slot in
            NityaDetailView(slot: slot)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    /// The staged arrival begins a breath after she is on the glass (the
    /// prototype's 60 ms), so the first frame is the empty ground and every
    /// beat after it is seen rising. Under reduce motion she is simply there.
    private func beginArrival() {
        // Wave 6 · B · the day's opening bell (once a practice day).
        TheBells.riteOpened()
        guard !arrived, opening == nil else { return }
        // Wave 6 · Arrival comes first: once in the light half of a practice
        // day and once in the dark half, the opening stands before the beats.
        let hour = Calendar.current.component(.hour, from: Date())
        let day = DailyEnergyService.practiceDayIndex()
        if !Self.openingsSkipped,
           RiteOpening.opens(lastKey: UserDefaults.standard.string(forKey: RiteOpening.lastOpeningKey),
                             practiceDay: day, hour: hour) {
            UserDefaults.standard.set(RiteOpening.key(practiceDay: day, hour: hour),
                                      forKey: RiteOpening.lastOpeningKey)
            opening = RiteOpening.kind(hour: hour)
            return
        }
        if still {
            arrived = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + StagedArrival.lead) { arrived = true }
    }

    /// The opening has passed: the nine beats begin.
    private func finishOpening() {
        withAnimation(.easeInOut(duration: still ? 0.01 : 1.2)) { opening = nil }
        beginArrival()
    }

    /// Offering and Carry, once a practice day — a same-day return continues
    /// rather than repeats (expansion #24).
    private func beginClosing() {
        guard !Self.openingsSkipped else { return }
        let day = DailyEnergyService.practiceDayIndex()
        guard UserDefaults.standard.object(forKey: RiteStation.closedDayKey) == nil
                || UserDefaults.standard.integer(forKey: RiteStation.closedDayKey) != day else { return }
        UserDefaults.standard.set(day, forKey: RiteStation.closedDayKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: still ? 0.01 : 1.2)) { closing = true }
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
            AtmosphereBackground(atmosphere: atmo, flipLeft: comp.flip)

            // Her ring's geometry comes up under the words, slower than they do,
            // to the light Design drew it at — no stacked dimmer on top.
            sigilLayer(atmo: atmo, plan: plan, comp: comp, ring: content.ring)
                .opacity(arrived ? DayLight.riteSigilOpacity : 0)
                .animation(still ? nil : StagedArrival.ease(duration: StagedArrival.sigilDuration,
                                                            delay: StagedArrival.sigilDelay),
                           value: arrived)

            if plan.veilName { veilName(content, atmo: atmo, onOpen: { detailFor = s }) }

            DustMotesView(count: 16, element: atmo.element, accent: atmo.accentBright)
                .allowsHitTesting(false)
            DepthOverlay()

            column(s: s, content: content, atmo: atmo, plan: plan, comp: comp)

            // Wave 6 · the low-state door (C-1002, C-1120): his own words come
            // back. In the top corner the hamburger leaves free, outside the
            // column, so the composed Rite does not move for it.
            LowStateDoorButton(action: { lowOpen = true })
                .padding(.leading, 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .arrives(arrived, after: ArrivalBeat.foot.delay, still: still)
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

    /// The sigil stands where `TdSigil` puts it (`RiteSigilPlacement`), sized
    /// to the device by the same proportion everywhere. The layer reports the
    /// screen's size while the sigil overdraws past it, so it never inflates
    /// RootView's stack and pushes the hamburger off-edge. Air's horizon line
    /// crosses at 43%.
    private func sigilLayer(atmo: Atmosphere, plan: RitePlan, comp: RiteComposition, ring: Int) -> some View {
        GeometryReader { geo in
            let f = RiteSigilPlacement.frame(for: plan.sigil, planScale: plan.sigilScale,
                                             compScale: comp.sigilScale, flip: comp.flip,
                                             in: geo.size)
            ZStack {
                Color.clear
                RiteSigil(atmosphere: atmo, ring: ring, size: f.size, spin: comp.spin,
                          lineScale: f.lineScale)
                    .position(f.center)
                if plan.horizonLine {
                    LinearGradient(stops: [
                        .init(color: atmo.accentSoft.opacity(0), location: 0),
                        .init(color: atmo.accentSoft, location: 0.28),
                        .init(color: atmo.accentSoft, location: 0.72),
                        .init(color: atmo.accentSoft.opacity(0), location: 1),
                    ], startPoint: .leading, endPoint: .trailing)
                    .frame(width: geo.size.width, height: 1)
                    .position(x: geo.size.width / 2, y: geo.size.height * RiteSigilPlacement.horizonY)
                }
            }
        }
        .ignoresSafeArea()
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
        // Her name as the vast ground rises with her geometry (`opacity: sigilO`).
        .opacity(arrived ? DayLight.riteSigilOpacity : 0)
        .animation(still ? nil : StagedArrival.ease(duration: StagedArrival.sigilDuration,
                                                    delay: StagedArrival.sigilDelay),
                   value: arrived)
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
        .arrives(arrived, after: ArrivalBeat.strip.delay, still: still)
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

        // Each block arrives on its own beat. Air leans: the stack hugs one
        // edge (30 pt in, 94% wide — `padding: '0 30px'`, `maxWidth: '94%'`)
        // while her sigil stands off the other.
        return VStack(alignment: hAlign, spacing: 0) {
            ForEach(Array(plan.order.enumerated()), id: \.offset) { _, block in
                RiteBlockView(kind: block, ctx: ctx)
                    .arrives(arrived, after: ArrivalBeat(block).delay, still: still)
            }
        }
        .frame(maxWidth: lean ? .infinity : 360, alignment: alignment(hAlign))
        .padding(.leading, lean && !leadingEdge ? 20 : 0)
        .padding(.trailing, lean && leadingEdge ? 20 : 0)
        .padding(.horizontal, lean ? 30 : 28)
        .frame(maxWidth: .infinity, alignment: alignment(hAlign))
    }

    // MARK: - Foot (I feel her + position)

    private func foot(s: Shakti, content: RiteContent, atmo: Atmosphere) -> some View {
        VStack(spacing: 12) {
            // Wave 3 · grace: one real moment of hers, read back once, then rest.
            RiteGraceLine(shakti: s, still: still)

            Button(action: triggerRecognition) {
                Text("I feel her")
                    .font(AppFont.sanskrit(23))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 60)
                    .background(FeelHerPill(atmosphere: atmo, ring: content.ring, still: still))
            }
            // Wave 3 · the pulse: a heartbeat under the thumb, rings four to eight.
            .buttonStyle(RitePulseButtonStyle(active: RiteDay.pulseLives(inRing: content.ring), still: still))
            .accessibilityLabel("I feel her — record recognition of \(content.spokenName)")

            // Wave 2 · her seat is a door: the position is her identity, and
            // it opens her room, through her rite (``HerRoomDoor``).
            Button {
                Haptics.medium()
                roomKp = content.kp
            } label: {
                Text("\(content.kp) of 102" + (content.bija.map { " · bīja \($0)" } ?? ""))
                    .font(AppFont.label(11))
                    .tracking(1.6)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Her seat — enter her room"))

            // Wave 3 · three doors, by the hour; one is always the floor. The
            // room door is the same one her seat opens (one building).
            RiteDayDoors(shakti: s, onOpenRoom: { Haptics.light(); roomKp = content.kp })
        }
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
        .arrives(arrived, after: ArrivalBeat.foot.delay, still: still)
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

// MARK: - "I feel her"

/// The red gesture, carrying her. Design's pill runs from the instrument's red
/// to a mix of that red with a third of her hue
/// (`linear-gradient(135deg, red, color-mix(red 66%, accent 34%))`), so no two
/// days' pills are the same red. Her glow stands under it, and — beyond
/// Design — that glow breathes at her ring's own rate (the Bhūpura holds).
private struct FeelHerPill: View {
    let atmosphere: Atmosphere
    let ring: Int
    let still: Bool

    var body: some View {
        let period = FieldBreath.period(ring: ring)
        TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: still || period == nil)) { context in
            let b = period.map { FieldBreath.phase(at: context.date.timeIntervalSinceReferenceDate,
                                                   period: $0) } ?? 1
            Capsule()
                .fill(LinearGradient(colors: [Color.accentRed, DayLight.feelHerEnd(atmosphere)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(Capsule().strokeBorder(atmosphere.accentBright.opacity(0.22), lineWidth: 0.6))
                .shadow(color: atmosphere.glow.opacity(0.7 + 0.3 * b), radius: 24 + 8 * b, y: 4)
                .shadow(color: Color.accentRed.opacity(0.5), radius: 26, y: 4)
        }
    }
}
