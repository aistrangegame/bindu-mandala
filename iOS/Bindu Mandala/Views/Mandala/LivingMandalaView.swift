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
    @State private var soundOn = UserDefaults.standard.bool(forKey: "lr_sound")   // toggleSound() writes it; read it back so the choice survives relaunch
    @State private var moved = false
    @State private var animating = false
    @State private var enteredRing = 0
    @State private var flash: MandalaCanvasLayer.RingFlash?
    @State private var constellation: Double = 0
    @State private var constellationStart: TimeInterval?   // clock for the per-thread stagger

    // Gesture bases (incremental deltas so pan + pinch compose)
    @State private var lastDrag: CGSize = .zero
    @State private var lastMagnify: CGFloat = 1

    // Precomputed (rebuilt when the field changes) — derive is not free per frame.
    @State private var seats: [MandalaWorld.Seat] = []
    @State private var atmos: [Int: Atmosphere] = [:]
    @State private var feltKp: Set<Int> = []
    /// What each seat says to a voice, composed when the field changes (§4.4).
    @State private var voices: [Int: MandalaVoice.Spoken] = [:]

    @State private var variant: TimeVariant = LunarPhaseService.currentTimeVariant()

    // MARK: Phase 5 — the light, and the two clocks it stands on
    //
    // `MandalaLight.enabled` is read **here and nowhere else in the app**. One
    // switch for the whole phase: the lit canvas, the enclosure's bīja on a
    // crossing, and the gaze clock Tratak is earned on are one instrument, and a
    // descent that speaks the mantra while the enclosures are still thin gold
    // strokes is a half-instrument nobody should see.
    private let lightOn = MandalaLight.enabled
    /// When the glass was last touched. Every camera change resets it, so both
    /// clocks below are present-tense and neither can accumulate.
    @State private var lastMoveAt: TimeInterval = Date().timeIntervalSinceReferenceDate
    /// How long it has lain untouched, ticked once a second.
    ///
    /// Tratak is earned over tens of seconds and must be earned identically
    /// under reduce motion — where the canvas's own `TimelineView` is paused and
    /// its frame clock is frozen. A one-second state tick is not animation: it
    /// is a value changing, driving a drawing that does not move.
    @State private var stillSeconds: Double = 0
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
                        felt: feltKp, flash: flash, constellation: constellation,
                        constellationStart: constellationStart,
                        tier: camera.tier, reduceMotion: reduceMotion,
                        lightOn: lightOn,
                        lastMoveAt: lastMoveAt, stillSeconds: stillSeconds)

                    // The drawing has no accessibility tree; this is it. It
                    // draws nothing and hit-tests nothing — the gesture catcher
                    // below is still the only thing a finger reaches — and it
                    // goes out of the tree entirely once the Bindu has opened,
                    // so a voice is never offered a field that is no longer
                    // there.
                    MandalaAccessibilityLayer(
                        camera: camera, size: geo.size, seats: seats, voices: voices,
                        reachable: reachableKp, onActivate: activate)
                        .accessibilityHidden(descent)
                }
                gestureCatcher
                header
                // Controls are always reachable — the sound toggle governs the ring
                // chimes that fire during unfocused navigation, so it can't be
                // hidden behind a focused seat.
                controls
                if let seat = focus { card(for: seat) }
                if descent { lalita }
            }
            .onAppear { configure(size: geo.size) }
            .onChange(of: geo.size) { _, s in configure(size: s) }
            .onChange(of: shaktis.count) { _, _ in rebuild() }
            .onChange(of: camera) { _, _ in
                lastMoveAt = Date().timeIntervalSinceReferenceDate
                // Written only when it changes: a drag is sixty camera changes a
                // second, and assigning an unchanged `@State` still invalidates.
                if stillSeconds != 0 { stillSeconds = 0 }
            }
            .task {
                guard lightOn else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(1))
                    // Clamped at the gaze's own end, so once Tratak is whole the
                    // value stops changing and the tick stops re-rendering the
                    // field. Nothing past that point looks any different.
                    let held = max(0, Date().timeIntervalSinceReferenceDate - lastMoveAt)
                    let clamped = min(MandalaLight.tratakFull, held)
                    if clamped != stillSeconds { stillSeconds = clamped }
                }
            }
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
            .simultaneousGesture(doubleTapGesture)
    }

    /// Double-tap empty space to zoom in (1.7×) at that point — the prototype's
    /// quick way to fall deeper. On a seat, the single-tap fly-to/focus governs.
    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { v in
                guard nearestSeat(to: v.location) == nil else { return }
                Haptics.light()
                animating = false
                withAnimation(.easeOut(duration: 0.42)) {
                    camera = camera.zoomed(at: v.location, factor: 1.7)
                }
                updateEntered()
            }
    }

    private var header: some View {
        VStack(spacing: 5) {
            Text("Śrī Yantra")
                .font(AppFont.sanskrit(24)).tracking(1.4)
                .foregroundStyle(Color.cream)
            Text(tierHint)
                .font(AppFont.label(11.5)).tracking(1.6)
                .foregroundStyle(Color.cream.opacity(0.55))
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
                onSound: { Haptics.soft(); BijaSoundService.shared.playBija(seat.shakti.bija, seed: seat.shakti.khadgamalaPosition ?? seat.shakti.position) },
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
                .background(Circle().fill(controlWash)
                    .overlay(Circle().stroke(active ? Color.gold : dayAtmo.accentSoft, lineWidth: 1)))
        }
        .buttonStyle(.plain)
    }

    /// The ground under the zoom column. A flat disc — one opacity all the way
    /// out to its rim — stamps a hard dark circle over any seat lit behind the
    /// column (device audit, Also-observed 5). This is dense under the glyph,
    /// where it has to be for the glyph to read against a lit seat, and reaches
    /// *nothing* at the rim, so her light carries through the column instead of
    /// ending at an edge.
    private var controlWash: RadialGradient {
        RadialGradient(
            stops: [
                .init(color: Color.ground.opacity(0.72), location: 0.0),
                .init(color: Color.ground.opacity(0.64), location: 0.5),
                .init(color: Color.ground.opacity(0.26), location: 0.82),
                .init(color: Color.ground.opacity(0.0), location: 1.0),
            ],
            center: .center, startRadius: 0, endRadius: 23)
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
        activate(seat)
    }

    /// What arriving at a seat does — the fall to the Bindu at ring 9, her
    /// significance on a first arrival, her full presence on a second.
    ///
    /// Lifted out of `handleTap(at:)` because a tap is no longer the only way
    /// to arrive. VoiceOver does not hit-test: it activates an element's own
    /// action, so `MandalaAccessibilityLayer` calls this directly. One function,
    /// so the two ways in cannot drift into two different instruments.
    private func activate(_ seat: MandalaWorld.Seat) {
        let ring = seat.shakti.ringNumber ?? 2
        if ring == 9 { openDescent(); return }
        if let f = focus, f.id == seat.id { Haptics.medium(); detailFor = seat.shakti }
        else { flyTo(seat) }
    }

    /// Which seats answer right now. When a seat is focused the field dims and
    /// only she and her family are tappable; `nearestSeat(to:)` reads this set
    /// and so does the spoken layer — so a voice is never offered a hundred
    /// seats that have stopped responding.
    ///
    /// A set rather than a predicate, and computed once rather than per seat:
    /// `familyKp` filters all 102 rows every time it is read, and both callers
    /// ask about every seat there is. As a predicate that is ten thousand
    /// comparisons per frame of a drag, for a fact that changes only when the
    /// focus does.
    private var reachableKp: Set<Int> {
        guard let focused = focus else { return Set(seats.map(\.id)) }
        return familyKp.union([focused.id])
    }

    /// Nearest tappable seat to a screen point. When a seat is focused, the dimmed
    /// (non-family) seats recede and are not tappable — matching the field's fade.
    private func nearestSeat(to point: CGPoint) -> MandalaWorld.Seat? {
        var best: MandalaWorld.Seat?
        var bestD = CGFloat.greatestFiniteMagnitude
        let reachable = reachableKp
        for seat in seats where reachable.contains(seat.id) {
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
        constellationStart = Date().timeIntervalSinceReferenceDate + 0.15
        withAnimation(.easeInOut(duration: 0.8).delay(0.15)) { constellation = 1 }
    }

    private func openDescent() {
        guard lalitaShakti != nil else { return }   // nothing to arrive at yet
        Haptics.medium()
        focus = nil
        constellation = 0
        constellationStart = nil
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
        constellationStart = nil
        fitCamera()
    }

    private func closeFocus() {
        focus = nil
        constellation = 0
        constellationStart = nil
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
            // Idea 31 — the fall speaks the mantra. The same opt-in hook, the
            // same inward-only crossing; what changes is that the enclosure now
            // sounds its own bīja rather than a bell. Sounded, never written.
            if soundOn {
                if lightOn { RingAudioService.shared.ringBija(e) }
                else { RingAudioService.shared.ringChime(e) }
            }
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
        var f: Set<Int> = []
        var v: [Int: MandalaVoice.Spoken] = [:]
        for s in shaktis {
            let k = s.khadgamalaPosition ?? s.position
            a[k] = Atmosphere.derive(from: s, at: variant)
            if s.hasBeenFelt { f.insert(k) }
            v[k] = MandalaVoice.spoken(for: s)
        }
        atmos = a
        feltKp = f
        voices = v
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { detailFor = seat.shakti }
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
