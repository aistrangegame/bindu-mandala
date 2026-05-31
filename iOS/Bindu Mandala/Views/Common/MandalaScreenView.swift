import SwiftUI
import SwiftData

/// The home — the held Śrī Yantra with the Veil rising from below.
///
/// Navigation contract (Session C):
/// - Direct Ring 2 petal tap on the held yantra → NavigationStack push to ShaktiDetail
/// - Bindu tap → fullScreenCover for Silence
/// - All Veil-driven entries → sheet or fullScreenCover, never a nav push
///
/// The Veil is a `.sheet`; pushing onto MandalaScreenView's NavigationStack from
/// inside the Veil would auto-dismiss the sheet and leave the practitioner on
/// the bare yantra. Modal presentations sit on top of the sheet so closing them
/// returns to the still-open Veil — except that SwiftUI auto-collapses the Veil
/// when a fullScreenCover/sheet covers it, which is the correct iOS behavior:
/// the practitioner explicitly left the descent column to enter a ring.
struct MandalaScreenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    /// Optional external taps (kept for RootView compatibility).
    var onPetalTap: ((Int) -> Void)? = nil
    var onBinduTap: (() -> Void)? = nil

    // Direct-from-yantra navigation (uses MandalaScreenView's NavigationStack).
    @State private var detailFor: Shakti?

    // Modal entries from the Veil — never nav pushes. Every ring now has its
    // own world view (Session D); the AvaranaThreshold ceremony stays as a
    // fallback for rings without a dedicated world (none after Session D).
    @State private var thresholdAvarana: Avarana?
    @State private var showRingOne = false
    @State private var showRingTwo = false
    @State private var showRingThree = false
    @State private var showRingFour = false
    @State private var showRingFive = false
    @State private var showRingSix = false
    @State private var showRingSeven = false
    @State private var showRingEight = false
    @State private var showRingNine = false
    @State private var showSilence = false

    @State private var hasAppliedLaunchArgs = false
    @State private var variant: TimeVariant = LunarPhaseService.currentTimeVariant()

    // Veil state — initialized lazily once the geometry is known.
    @State private var veilOffset: CGFloat = 0
    @State private var veilInitialized = false

    // First-launch acknowledgment ripple — single, gentle, one-shot.
    @State private var rippleActive = false
    @State private var rippleSize: CGFloat = 22
    @State private var rippleOpacity: Double = 0.4
    @State private var hasPulsed: Bool = UserDefaults.standard.bool(forKey: "hasSeenMandalaPulse")

    private var todayIndex: Int {
        LunarPhaseService.todayPetalIndex()
    }

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $detailFor) { shakti in
                    ShaktiDetailView(shakti: shakti)
                }
        }
        // Scrollable threshold fallback (currently unused after Session D,
        // since every ring has its own world. Kept for emergency routing.)
        .sheet(item: $thresholdAvarana) { avarana in
            AvaranaThresholdView(avarana: avarana)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.ground)
        }
        // Immersive ring worlds — fullScreenCovers, each with its own gestures.
        .fullScreenCover(isPresented: $showRingOne) {
            RingOneWorldView()
        }
        .fullScreenCover(isPresented: $showRingTwo) {
            NavigationStack { RingTwoWorldView() }
        }
        .fullScreenCover(isPresented: $showRingThree) {
            RingThreeWorldView()
        }
        .fullScreenCover(isPresented: $showRingFour) {
            RingFourWorldView()
        }
        .fullScreenCover(isPresented: $showRingFive) {
            RingFiveWorldView()
        }
        .fullScreenCover(isPresented: $showRingSix) {
            RingSixWorldView()
        }
        .fullScreenCover(isPresented: $showRingSeven) {
            RingSevenWorldView()
        }
        .fullScreenCover(isPresented: $showRingEight) {
            RingEightWorldView()
        }
        .fullScreenCover(isPresented: $showRingNine) {
            RingNineDescentView()
        }
        .fullScreenCover(isPresented: $showSilence) {
            SilenceView(isPresented: $showSilence)
        }
        .onAppear {
            applyLaunchArgsIfNeeded()
            variant = LunarPhaseService.currentTimeVariant()
            scheduleFirstLaunchRipple()
        }
    }

    private func applyLaunchArgsIfNeeded() {
        guard !hasAppliedLaunchArgs else { return }
        hasAppliedLaunchArgs = true
        let args = ProcessInfo.processInfo.arguments
        if args.contains("OPEN_SILENCE") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showSilence = true }
            return
        }
        if let arg = args.first(where: { $0.hasPrefix("OPEN_DETAIL=") }),
           let pos = Int(arg.dropFirst("OPEN_DETAIL=".count)),
           let s = shaktis.first(where: { $0.position == pos && ($0.ringNumber ?? 2) == 2 }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { detailFor = s }
        }
        // OPEN_RING=N — debug launch into a specific ring's modal, mirrors
        // the Veil's row-tap behavior. Lets a developer screenshot each
        // navigation target without driving the UI manually.
        if let arg = args.first(where: { $0.hasPrefix("OPEN_RING=") }),
           let ring = Int(arg.dropFirst("OPEN_RING=".count)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                handleVeilEntry(ring)
            }
        }
    }

    private var content: some View {
        GeometryReader { geo in
            let sheetH = geo.size.height * 0.85
            let peekH: CGFloat = 108
            let closedOff = sheetH - peekH
            let currentOffset = veilInitialized ? veilOffset : closedOff
            let isVeilOpen = currentOffset < closedOff * 0.5
            let dim = 0.5 + 0.5 * Double(max(0, min(closedOff, currentOffset)) / max(1, closedOff))

            let offsetBinding = Binding<CGFloat>(
                get: { veilInitialized ? veilOffset : closedOff },
                set: { veilOffset = $0; veilInitialized = true }
            )

            ZStack(alignment: .bottom) {
                variant.bg.ignoresSafeArea()

                heldYantraLayer(geo: geo)
                    .opacity(dim)
                    .allowsHitTesting(!isVeilOpen)

                if isVeilOpen {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.timingCurve(0.22, 1, 0.36, 1, duration: 0.52)) {
                                veilOffset = closedOff
                            }
                        }
                        .ignoresSafeArea()
                }

                VeilView(
                    availableHeight: geo.size.height,
                    offset: offsetBinding,
                    onEntry: handleVeilEntry
                )
            }
        }
    }

    private func heldYantraLayer(geo: GeometryProxy) -> some View {
        ZStack {
            // Ambient ellipse
            let a = variant.ambient
            EllipticalGradient(
                gradient: Gradient(stops: [
                    .init(color: a.inner, location: 0),
                    .init(color: .clear, location: 0.7)
                ]),
                center: .center,
                startRadiusFraction: 0,
                endRadiusFraction: 1
            )
            .frame(width: geo.size.width * a.widthFraction,
                   height: geo.size.height * a.heightFraction)
            .position(x: geo.size.width * a.center.x,
                      y: geo.size.height * a.center.y)
            .allowsHitTesting(false)

            DustMotesView(count: variant.motes)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                TemporalMarkView(variant: variant)
                    .padding(.top, 6)
                Spacer(minLength: 0)

                ZStack {
                    SriYantraMandalaView(
                        shaktis: shaktis,
                        todayIndex: shaktis.isEmpty ? nil : todayIndex,
                        variant: variant,
                        diameter: 344,
                        onShaktiTap: { shakti in
                            detailFor = shakti
                            onPetalTap?(shakti.position)
                        },
                        onBinduTap: handleBinduTap
                    )

                    if rippleActive {
                        Circle()
                            .stroke(Color.gold.opacity(rippleOpacity), lineWidth: 0.8)
                            .frame(width: rippleSize, height: rippleSize)
                            .allowsHitTesting(false)
                    }
                }
                .frame(maxWidth: .infinity)

                Spacer(minLength: 0)

                // Reserve space for the peek so the yantra sits comfortably above it.
                Color.clear.frame(height: 124)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func handleVeilEntry(_ ring: Int) {
        // Every ring opens its own world after Session D.
        switch ring {
        case 1: showRingOne = true
        case 2: showRingTwo = true
        case 3: showRingThree = true
        case 4: showRingFour = true
        case 5: showRingFive = true
        case 6: showRingSix = true
        case 7: showRingSeven = true
        case 8: showRingEight = true
        case 9: showRingNine = true
        default:
            // Defensive fallback — should be unreachable given the 1–9 routing.
            if let av = avaranas.first(where: { $0.ringNumber == ring }) {
                thresholdAvarana = av
            }
        }
    }

    private func handleBinduTap() {
        showSilence = true
        onBinduTap?()
    }

    private func scheduleFirstLaunchRipple() {
        guard !hasPulsed, !reduceMotion else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            rippleActive = true
            withAnimation(.easeOut(duration: 2.8)) {
                rippleSize = 338
                rippleOpacity = 0
            }
            UserDefaults.standard.set(true, forKey: "hasSeenMandalaPulse")
            hasPulsed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                rippleActive = false
            }
        }
    }
}

