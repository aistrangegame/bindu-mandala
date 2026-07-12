import SwiftUI
import SwiftData

/// The living Mandala — one continuous Śrī Yantra you fall through. Pinch and drag
/// to move through the field; tap a seat to fly to her and read her significance;
/// tap her again to enter her full presence; fall to the center and tap the Bindu
/// for the source, Lalitā. The nine ring-worlds are gone — they live now as the
/// Field's rows. Nothing auto-advances: the descent is always a chosen tap
/// (Ruling 1 / 2). Every seat is lit by her own Atmosphere, so the 86 are never
/// the false `.inner` gold (Ruling 7 / R3).
struct LivingMandalaView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query private var descentStates: [DescentState]

    // Camera + viewport
    @State private var camera = MandalaCamera(scale: 0.5, tx: 0, ty: 0)
    @State private var size: CGSize = .zero
    @State private var ready = false

    // Interaction state
    @State private var focus: MandalaWorld.Seat?
    @State private var descent = false
    @State private var detailFor: Shakti?
    @State private var soundOn = false
    @State private var moved = false
    @State private var animating = false
    @State private var enteredRing = 0
    @State private var flash: MandalaCanvasLayer.RingFlash?
    @State private var constellation: Double = 0

    // Gesture bases (incremental deltas so pan + pinch compose)
    @State private var lastDrag: CGSize = .zero
    @State private var lastMagnify: CGFloat = 1

    // Precomputed (rebuilt when the field changes) — derive is not free per frame.
    @State private var seats: [MandalaWorld.Seat] = []
    @State private var atmos: [Int: Atmosphere] = [:]
    @State private var countByKp: [Int: Int] = [:]

    @State private var variant: TimeVariant = LunarPhaseService.currentTimeVariant()
    @State private var appliedLaunchArgs = false

    private var todayKp: Int { AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition() }
    private var dayAtmo: Atmosphere {
        atmos[todayKp] ?? (shaktis.first { ($0.khadgamalaPosition ?? $0.position) == todayKp }
            .map { Atmosphere.derive(from: $0, at: variant) })
            ?? Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: todayKp, element: .ether, at: variant)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                background
                if ready {
                    MandalaCanvasLayer(
                        camera: camera, size: geo.size, seats: seats, atmos: atmos,
                        dayAccent: dayAtmo.accent, todayKp: todayKp,
                        focusKp: focus.map(kp), familyKp: familyKp,
                        focusAccentBright: (focus.map { atmos[kp($0)]?.accentBright } ?? nil) ?? Color.gold,
                        countByKp: countByKp, flash: flash, constellation: constellation,
                        tier: camera.tier, reduceMotion: reduceMotion)
                }
                gestureCatcher
                header
                if focus != nil { controls }
                if let seat = focus { card(for: seat) }
                if descent { lalita }
            }
            .onAppear { configure(size: geo.size) }
            .onChange(of: geo.size) { _, s in configure(size: s) }
            .onChange(of: shaktis.count) { _, _ in rebuild() }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(item: $detailFor) { s in
            NavigationStack { ShaktiDetailView(shakti: s) }
        }
    }

    // MARK: Layers

    private var background: some View {
        ZStack {
            Color.ground.ignoresSafeArea()
            RadialGradient(colors: [dayAtmo.glow.opacity(0.5), .clear],
                           center: UnitPoint(x: 0.5, y: 0.44),
                           startRadius: 0, endRadius: max(size.width, 320) * 0.9)
                .ignoresSafeArea()
        }
    }

    private var gestureCatcher: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(dragGesture)
            .simultaneousGesture(magnifyGesture)
    }

    private var header: some View {
        VStack(spacing: 5) {
            Text("Śrī Yantra")
                .font(.custom(AppFont.cormorant, size: 24)).tracking(1.4)
                .foregroundStyle(Color.cream)
            Text(tierHint)
                .font(.system(size: 9.5)).tracking(1.6)
                .foregroundStyle(Color.cream.opacity(0.42))
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .allowsHitTesting(false)
    }

    private var tierHint: String {
        switch camera.tier {
        case 0: return "the whole instrument · pinch to fall in"
        case 1: return "the nine enclosures"
        default: return "tap an energy · fall to the center for the source"
        }
    }

    @ViewBuilder
    private func card(for seat: MandalaWorld.Seat) -> some View {
        let a = atmos[kp(seat)] ?? Atmosphere.derive(from: seat.shakti, at: variant)
        VStack {
            Spacer()
            SignificanceCard(
                shakti: seat.shakti, atmo: a,
                familyCount: familyKp.count, familyLabel: familyLabel(for: seat),
                onSound: { Haptics.soft(); BijaSoundService.shared.play(forPosition: seat.shakti.position) },
                onOpenDetail: { Haptics.medium(); detailFor = seat.shakti },
                onClose: { closeFocus() })
            .padding(.horizontal, 12)
            .padding(.bottom, 14)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private var controls: some View {
        VStack(spacing: 10) {
            controlButton(soundOn ? "♪" : "♪̸", active: soundOn) { toggleSound() }
            controlButton("+", active: false) { zoomButton(1.4) }
            controlButton("−", active: false) { zoomButton(1 / 1.4) }
            controlButton("⤢", active: false) { fitCamera() }
        }
        .padding(.trailing, 16)
        .padding(.top, 70)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    private func controlButton(_ label: String, active: Bool, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 20))
                .foregroundStyle(active ? Color.gold : Color.cream.opacity(0.6))
                .frame(width: 46, height: 46)
                .background(Circle().fill(Color.ground.opacity(0.55))
                    .overlay(Circle().stroke(active ? Color.gold : dayAtmo.accentSoft, lineWidth: 1)))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var lalita: some View {
        if let l = lalitaShakti {
            LalitaSourceView(
                lalita: l, seats: seats,
                onEnter: { detailFor = l },
                onReturn: { ascend() })
            .transition(.opacity)
            .zIndex(40)
        }
    }

    /// The Bindu's Śakti (ring 9), or the deepest one present — nil only if the
    /// field is momentarily empty (mid-resync), in which case the descent no-ops.
    private var lalitaShakti: Shakti? {
        shaktis.first { ($0.ringNumber ?? 2) == 9 } ?? shaktis.last
    }

    // MARK: Gestures

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                animating = false
                let delta = CGSize(width: v.translation.width - lastDrag.width,
                                   height: v.translation.height - lastDrag.height)
                if abs(v.translation.width) + abs(v.translation.height) > 6 { moved = true }
                camera = camera.panned(by: delta)
                lastDrag = v.translation
                updateEntered()
            }
            .onEnded { v in
                if !moved { handleTap(at: v.location) }
                lastDrag = .zero
                moved = false
            }
    }

    private var magnifyGesture: some Gesture {
        MagnifyGesture()
            .onChanged { v in
                animating = false
                moved = true
                let factor = v.magnification / lastMagnify
                camera = camera.zoomed(at: v.startLocation, factor: factor)
                lastMagnify = v.magnification
                updateEntered()
            }
            .onEnded { _ in lastMagnify = 1 }
    }

    // MARK: Interaction

    private func handleTap(at location: CGPoint) {
        guard let seat = nearestSeat(to: location) else { return }
        let ring = seat.shakti.ringNumber ?? 2
        if ring == 9 { openDescent(); return }
        if let f = focus, f.id == seat.id { Haptics.medium(); detailFor = seat.shakti }
        else { flyTo(seat) }
    }

    /// Nearest tappable seat to a screen point. When a seat is focused, the dimmed
    /// (non-family) seats recede and are not tappable — matching the field's fade.
    private func nearestSeat(to point: CGPoint) -> MandalaWorld.Seat? {
        var best: MandalaWorld.Seat?
        var bestD = CGFloat.greatestFiniteMagnitude
        let focusing = focus != nil
        for seat in seats {
            if focusing {
                let k = kp(seat)
                let isFocus = focus?.id == seat.id
                if !isFocus && !familyKp.contains(k) { continue }
            }
            let s = camera.screen(for: seat.point)
            let d = hypot(s.x - point.x, s.y - point.y)
            if d < bestD { bestD = d; best = seat }
        }
        // generous target near the point; larger for the today/focus seat
        return bestD <= 34 ? best : nil
    }

    private func flyTo(_ seat: MandalaWorld.Seat) {
        Haptics.light()
        animating = true
        withAnimation(.easeOut(duration: 0.72)) {
            camera = .flyTarget(to: seat.point, in: size)
        } completion: { animating = false }
        focus = seat
        constellation = 0
        withAnimation(.easeInOut(duration: 0.8).delay(0.15)) { constellation = 1 }
    }

    private func openDescent() {
        guard lalitaShakti != nil else { return }   // nothing to arrive at yet
        Haptics.medium()
        focus = nil
        constellation = 0
        animating = true
        withAnimation(.easeIn(duration: 0.95)) {
            camera = .descentTarget(in: size)
        } completion: {
            animating = false
            recordCrossing(ring: 9)
            withAnimation(.easeOut(duration: 0.5)) { descent = true }
        }
    }

    private func ascend() {
        withAnimation(.easeInOut(duration: 0.5)) { descent = false }
        focus = nil
        constellation = 0
        fitCamera()
    }

    private func closeFocus() {
        focus = nil
        constellation = 0
        fitCamera()
    }

    private func fitCamera() {
        guard size != .zero else { return }
        animating = true
        withAnimation(.easeInOut(duration: 0.6)) {
            camera = .fitted(in: size)
        } completion: { animating = false }
    }

    private func zoomButton(_ factor: CGFloat) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        withAnimation(.easeOut(duration: 0.3)) { camera = camera.zoomed(at: c, factor: factor) }
        updateEntered()
    }

    private func toggleSound() {
        soundOn.toggle()
        UserDefaults.standard.set(soundOn, forKey: "lr_sound")
        Haptics.light()
    }

    // MARK: Crossings + chimes

    /// Track the deepest enclosure the viewport has fallen inside. Crossing inward
    /// flashes the ring, sounds a chime (opt-in), and records the descent timeline
    /// once per new depth. Silent and unrecorded on the way out.
    private func updateEntered() {
        guard size != .zero, !descent else { return }
        let e = camera.enteredRing(in: size)
        if e > enteredRing {
            flash = MandalaCanvasLayer.RingFlash(ring: e, bornAt: Date().timeIntervalSinceReferenceDate)
            if soundOn { RingAudioService.shared.ringChime(e) }
            recordCrossing(ring: e)
        }
        enteredRing = e
    }

    /// Mirror only genuinely-new deepest crossings (Ruling 8). `DescentState.enter`
    /// returns true exactly once per new depth, so the Airtable write can't double-log.
    private func recordCrossing(ring: Int) {
        guard let state = descentStates.first else { return }
        if state.enter(ring: ring) {
            Task { await AirtableService.shared.recordCrossing(ring: ring) }
        }
    }

    // MARK: Setup

    private func configure(size newSize: CGSize) {
        size = newSize
        if seats.isEmpty { rebuild() }
        if !ready, newSize != .zero {
            camera = .fitted(in: newSize)
            ready = true
            applyLaunchArgs()
        }
    }

    private func rebuild() {
        seats = MandalaWorld.seats(from: shaktis)
        var a: [Int: Atmosphere] = [:]
        var c: [Int: Int] = [:]
        for s in shaktis {
            let k = s.khadgamalaPosition ?? s.position
            a[k] = Atmosphere.derive(from: s, at: variant)
            c[k] = s.serverRecognitionCount ?? 0
        }
        atmos = a
        countByKp = c
    }

    private func applyLaunchArgs() {
        guard !appliedLaunchArgs else { return }
        appliedLaunchArgs = true
        let args = ProcessInfo.processInfo.arguments
        if args.contains("OPEN_SILENCE") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { openDescent() }
            return
        }
        if let arg = args.first(where: { $0.hasPrefix("OPEN_DETAIL=") }),
           let pos = Int(arg.dropFirst("OPEN_DETAIL=".count)),
           let seat = seats.first(where: { kp($0) == pos }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { flyTo(seat) }
        }
        if let arg = args.first(where: { $0.hasPrefix("OPEN_RING=") }),
           let ring = Int(arg.dropFirst("OPEN_RING=".count)),
           let seat = seats.first(where: { ($0.shakti.ringNumber ?? 2) == ring }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { flyTo(seat) }
        }
    }

    // MARK: Family helpers

    private var familyKp: Set<Int> {
        guard let seat = focus else { return [] }
        return Set(MandalaWorld.family(of: seat.shakti, in: shaktis).map { $0.khadgamalaPosition ?? $0.position })
    }

    private func familyLabel(for seat: MandalaWorld.Seat) -> String {
        let ring = seat.shakti.ringNumber ?? 2
        let ord = Self.ordinals[min(max(ring, 0), 9)]
        if ring == 2 { return "\(ord) Āvaraṇa · \(seat.shakti.cluster.label)" }
        return "\(ord) Āvaraṇa"
    }

    private func kp(_ seat: MandalaWorld.Seat) -> Int { seat.shakti.khadgamalaPosition ?? seat.shakti.position }

    private static let ordinals = ["", "First", "Second", "Third", "Fourth", "Fifth",
                                   "Sixth", "Seventh", "Eighth", "Ninth"]
}
