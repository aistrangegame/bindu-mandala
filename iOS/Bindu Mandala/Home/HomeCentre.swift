import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · A · Home, being there
//
// `waves/upgrade/worlds/spine-and-home.md` §1 "Being there" and §2 B #10–#20:
// the point at (W/2, 0.46·H) on the silence ground; back to front — the
// weather (#8), the ghost yantra lit by his walking as light (#12), the
// station ring of the fourteen worlds (#11), today's pointers (#14), the
// structural five (#17), the point (#18) and the Road Home (#15, #16); chrome
// at the corners (#10: the sound bottom-left; the Constellation's mark
// top-left is the spine's own, drawn above every world). The four movements
// of the point (§1 "Going deeper"): tap → Mauna, stillness → the gate, hold
// 0.9 s → the deep zoom, spread → Spanda into the Mandala.

/// Home itself — `spine-and-home.md` §1 "Being there".
@MainActor
struct HomeCentre: View {
    /// A gift opened: her card stands open at Home (§2 J #72).
    let cardKp: Int?

    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]
    @Query private var moments: [RecognitionEntry]

    // What the ledger says (read on arrival and when it changes).
    @State private var seatLight: [Int: Double] = [:]
    @State private var met = false
    @State private var bloom = 0.0
    @State private var seats: [MandalaWorld.Seat] = []

    // The stations and the five: the first touch opens, the second crosses.
    @State private var chosenStation: WorldID?
    @State private var chosenFive: Int?

    // The point.
    @StateObject private var hold: HoldDriver
    @State private var pressAt: Date?
    @State private var pressMoved = false
    @State private var spreading = false
    @State private var spread = BloomPress()

    // Stillness (#33): an untouched hand is an input.
    @State private var touching = false
    @State private var lastTouchAt = Date()
    @State private var still: Double = 0

    // Words that come and go.
    @State private var greeting: HomeReading.Greeting?
    @State private var greetingShown = false
    @State private var stillLine = false
    @State private var partway: String?
    @State private var leaving = false

    @AppStorage(HomeCentre.nameAtPointKey) private var nameAtPoint = false
    @AppStorage(HomeCentre.askedKey) private var askedForName = false

    static let nameAtPointKey = "home.name.at.point"
    static let askedKey = "home.essence.asked"
    static let greetedDayKey = "home.greeted.day"
    static let stillLineKey = "home.stillness.line.shown"

    private var memory: BinduMemory { BinduMemory.shared }

    init(cardKp: Int?) {
        self.cardKp = cardKp
        // The fall into the point is a 0.9 s hold on the one hold engine (#27).
        _hold = StateObject(wrappedValue: HoldDriver(rise: ThePoint.defaultHoldSeconds))
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let c = HomeLayout.point(in: size)
            ZStack {
                BinduHomeGround(met: met, todayColour: todayColour)
                figure(size: size, centre: c)
                spreadRegion(centre: c)
                stationLabels(size: size, centre: c)
                theFive(centre: c)
                thePoint(centre: c)
                roadHome(size: size, centre: c)
                words(size: size, centre: c)
                chrome(size: size)
                if let kp = cardKp { herCard(kp: kp, size: size) }
            }
            .frame(width: size.width, height: size.height)
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .simultaneousGesture(anyTouch)
        .onAppear(perform: arrive)
        .onChange(of: moments.count) { _, _ in read() }
        .onChange(of: shaktis.count) { _, _ in seats = MandalaWorld.seats(from: shaktis) }
        .task(id: spreading) { await watchSpread() }
        .task { await gatherStillness() }
    }

    // MARK: - Reading the ledger

    private var today: Int { DailyEnergyService.practiceDayIndex() }
    private static func dayOf(_ d: Date) -> Int { DailyEnergyService.practiceDayIndex(for: d) }

    private var acts: [HomeAct] {
        moments.map { HomeAct(at: $0.timestamp, kp: $0.khadgamalaPosition, felt: $0.gesture == .felt) }
    }

    private var todayKp: Int {
        AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition()
    }

    private var todayShakti: Shakti? { shaktis.first { $0.khadgamalaPosition == todayKp } }

    /// Today's colour: today's Śakti through her atmosphere (#14 a).
    private var todayColour: Color {
        todayShakti.map { Atmosphere.derive(from: $0).accentBright } ?? Color.gold
    }

    private func read() {
        let a = acts
        let now = Date()
        seatLight = HomeReading.seatLight(a, now: now, today: today, dayOf: Self.dayOf)
        met = HomeReading.isMet(a, today: today, dayOf: Self.dayOf)
        bloom = HomeReading.bloom(a, now: now, today: today, dayOf: Self.dayOf)
    }

    private func arrive() {
        read()
        seats = MandalaWorld.seats(from: shaktis)
        lastTouchAt = Date()
        HomeSound.arrive()
        greet()
    }

    /// #5: read from the ledger, once a launch, never twice a day.
    private func greet() {
        guard !HomeGreetingOnce.done else { return }
        HomeGreetingOnce.done = true
        let defaults = UserDefaults.standard
        let greetedDay = defaults.object(forKey: Self.greetedDayKey) as? Int
        let a = acts
        let d = today
        let found = HomeReading.greeting(
            today: d,
            lastActDay: HomeReading.lastActDay(a, today: d, dayOf: Self.dayOf),
            actedToday: a.contains { Self.dayOf($0.at) == d },
            greetedToday: greetedDay == d)
        guard let line = found else { return }
        defaults.set(today, forKey: Self.greetedDayKey)
        greeting = line
        withAnimation(.easeOut(duration: reduceMotion ? 0.2 : 1.2)) { greetingShown = true }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(line.seconds + 1.2))
            withAnimation(.easeIn(duration: reduceMotion ? 0.2 : 1.2)) { greetingShown = false }
        }
    }

    // MARK: - Touch: sound by first touch; stillness paused, never reset

    private var anyTouch: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                lastTouchAt = Date()
                HomeStillness.restedSinceTouch = false
                guard !touching else { return }
                touching = true
                HomeSound.touched()
            }
            .onEnded { _ in
                touching = false
                lastTouchAt = Date()
            }
    }

    /// #33: stillness accrues after 340 ms of no touch, up to 4.6 s; a touch
    /// pauses the count and never resets it. Full stillness opens Mauna by
    /// itself — stillness is his choice. One line, once ever, after 700 ms.
    private func gatherStillness() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .milliseconds(100))
            guard !Task.isCancelled, !leaving else { return }
            guard HomeStillness.gathers(touching: touching || pressAt != nil || spreading,
                                        untouchedFor: Date().timeIntervalSince(lastTouchAt),
                                        voiceOver: voiceOver,
                                        somethingOpen: cardKp != nil || chosenStation != nil || chosenFive != nil,
                                        restedSinceTouch: HomeStillness.restedSinceTouch)
            else { continue }
            still = min(HomeStillness.full, still + 0.1)
            if still >= HomeStillness.lineAfter, !UserDefaults.standard.bool(forKey: Self.stillLineKey) {
                UserDefaults.standard.set(true, forKey: Self.stillLineKey)
                withAnimation(.easeOut(duration: 1.2)) { stillLine = true }
            }
            if still >= HomeStillness.full {
                still = 0
                HomeStillness.restedSinceTouch = true
                withAnimation(.easeIn(duration: 0.6)) { stillLine = false }
                openMauna()
                return
            }
        }
    }

    // MARK: - Leaving Home for its own places

    private func openMauna() {
        guard !leaving else { return }
        // Back from the silence, Home waits for a touch before the gate can
        // open by itself again (one stillness, one arrival).
        HomeStillness.restedSinceTouch = true
        Haptics.soft()
        leaving = router.go(to: HomeSub.address(HomeSub.mauna), via: .dissolve)
    }

    private func openPravesha() {
        guard !leaving else { return }
        leaving = router.go(to: HomeSub.address(HomeSub.pravesha), via: .dissolve)
    }

    private func openSource() {
        guard !leaving else { return }
        leaving = router.go(to: HomeSub.address(HomeSub.source, kp: HomeSub.lalitaKp), via: .dissolve)
    }

    private func openEssence() {
        guard !leaving else { return }
        askedForName = true
        leaving = router.go(to: HomeSub.address(HomeSub.essence), via: .dissolve)
    }

    /// `from` nil: from the point at Home's centre (`Crossing.origin`).
    private func spandaIntoTheMandala(from c: CGPoint?) {
        guard !leaving else { return }
        HapticLibrary.shared.play(.completion)
        leaving = router.go(to: Address(.mandala), via: Crossing(kind: .spanda, origin: c))
    }

    // MARK: - Layers 1–5 drawn: the ghost yantra, the stations' marks, the five, the travelling dot

    private func figure(size: CGSize, centre c: CGPoint) -> some View {
        let light = seatLight
        let b = bloom
        let todayKp = self.todayKp
        let todayHue = todayColour
        let chosen = chosenStation
        let five = chosenFive
        let stillNow = still
        let todaysRing = KhadgamalaMap.ringNumber(forKhadgamala: todayKp)
        return TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { tl in
            let t = reduceMotion ? 0 : tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, sz in
                HomeFigure.ghostYantra(ctx, centre: c, light: light, bloom: b, todayKp: todayKp, t: t)
                HomeFigure.stations(ctx, size: sz, centre: c, todayHue: todayHue, todaysRing: todaysRing,
                                    chosen: chosen, t: t)
                HomeFigure.travellingDot(ctx, size: sz, centre: c, t: t, night: HomeLayout.isNight(tl.date))
                HomeFigure.five(ctx, centre: c, chosen: five)
                HomeFigure.stillnessRing(ctx, centre: c, still: stillNow / HomeStillness.full)
            }
            // Flattened on the GPU: Home redraws thirty times a second, and the
            // layered CPU raster kept the hand waiting (U2 walk on the Mac).
            .drawingGroup()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - #11 · The station ring

    private func stationLabels(size: CGSize, centre c: CGPoint) -> some View {
        ZStack {
            ForEach(WorldRegistry.stations, id: \.id) { entry in
                stationView(entry, at: HomeLayout.station(entry, size: size, centre: c))
            }
        }
    }

    private func stationView(_ entry: WorldEntry, at p: CGPoint) -> some View {
        let chosen = chosenStation == entry.id
        return VStack(spacing: 5) {
            Color.clear.frame(width: 12, height: 12)
            Text(entry.displayName.uppercased())
                .font(AppFont.label(11))
                .tracking(1.4)
                .foregroundStyle(Color.cream.opacity(chosen ? 0.9 : 0.5))
                .multilineTextAlignment(.center)
                // A long name takes two lines rather than run into its
                // neighbour (the Relationship Field beside Her Presence at 12).
                .frame(maxWidth: 136)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 16)
        .frame(minWidth: Hit.min, minHeight: Hit.min)
        .contentShape(Rectangle())
        .onTapGesture { touchStation(entry, at: p) }
        .accessibilityElement()
        .accessibilityLabel(Text(entry.id.title))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { cross(to: entry, from: p) }
        .accessibilityIdentifier("station.\(entry.id.rawValue)")
        .position(x: p.x, y: p.y + 10)
    }

    /// First touch opens the station (crowned ×1.4, its pitch hummed); the
    /// second crosses — two taps, never one (#11).
    private func touchStation(_ entry: WorldEntry, at p: CGPoint) {
        if chosenStation == entry.id {
            cross(to: entry, from: p)
            return
        }
        Haptics.light()
        SoundMixer.shared.hum(entry.id)
        withAnimation(.easeOut(duration: 0.4)) {
            chosenStation = entry.id
            chosenFive = nil
        }
    }

    private func cross(to entry: WorldEntry, from p: CGPoint) {
        guard !leaving else { return }
        leaving = router.go(to: stationAddress(entry), via: Crossing(kind: entry.arrival, origin: p))
    }

    /// Where a station opens: the day's threads it stands on (§5, law 21 — a
    /// world opens shaped by where he stood).
    private func stationAddress(_ entry: WorldEntry) -> Address {
        let day = Address.Day(Date())
        switch entry.id {
        case .today, .time, .memory, .well:
            return entry.address(day: day)
        case .herPresence, .herHome:
            return entry.address(kp: todayKp)
        default:
            return entry.address()
        }
    }

    // MARK: - #17 · The structural five

    private func theFive(centre c: CGPoint) -> some View {
        ZStack {
            ForEach(HomeFive.all, id: \.road) { f in
                let p = HomeLayout.five(f, centre: c)
                Color.clear
                    .frame(width: Hit.min, height: Hit.min)
                    .contentShape(Circle())
                    .onTapGesture { touchFive(f, at: p) }
                    .accessibilityElement()
                    .accessibilityLabel(Text(f.name))
                    .accessibilityValue(Text(f.line))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { crossToRoom(f, from: p) }
                    .position(p)
            }
        }
    }

    private func touchFive(_ f: HomeFive, at p: CGPoint) {
        if chosenFive == f.road {
            crossToRoom(f, from: p)
            return
        }
        Haptics.light()
        withAnimation(.easeOut(duration: 0.6)) {
            chosenFive = f.road
            chosenStation = nil
        }
    }

    private func crossToRoom(_ f: HomeFive, from p: CGPoint) {
        guard !leaving else { return }
        leaving = router.go(to: Address(.the33, chakra: f.road), via: Crossing(kind: .passage, origin: p))
    }

    // MARK: - #18 · The point, and its four movements

    private func thePoint(centre c: CGPoint) -> some View {
        ZStack {
            // The hold's light: a gold ring (r 40) filling in 0.9 s (#27).
            Circle()
                .trim(from: 0, to: CGFloat(hold.progress))
                .stroke(Color.gold.opacity(0.5), style: StrokeStyle(lineWidth: 1.2, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 80, height: 80)
                .opacity(hold.progress > 0.001 ? 1 : 0)
            ThePoint(look: .forWorld(.home), light: .always)
        }
        // One region carries the point's touch (its own 64 pt) and the spread
        // that starts within 60 pt of it (§7 settled 8), so two fingers either
        // side of the point are one gesture.
        .frame(width: HomeLayout.spreadRegion, height: HomeLayout.spreadRegion)
        .contentShape(Circle())
        .gesture(pointGesture)
        .simultaneousGesture(spreadGesture)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Home, the point"))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { openMauna() }
        .accessibilityAction(named: Text("Fall inward")) { openPravesha() }
        .accessibilityAction(named: Text("Bloom into the Mandala")) { spandaIntoTheMandala(from: c) }
        .accessibilityAction(named: Text("The source")) { openSource() }
        .accessibilityIdentifier("point.home")
        .position(c)
    }

    /// Tap → Mauna; hold 0.9 s (the one hold engine) → the deep zoom; moving
    /// past 9 pt cancels the hold and is no tap.
    private var pointGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                if pressAt == nil {
                    // Only a touch on the point itself is the point's.
                    let o = HomeLayout.spreadRegion / 2
                    let fromCentre = Double(hypot(v.startLocation.x - o, v.startLocation.y - o))
                    guard fromCentre <= Double(HomeLayout.pointTarget / 2) else {
                        pressMoved = true
                        pressAt = Date()
                        return
                    }
                    pressAt = Date()
                    pressMoved = false
                    hold.bind(onCommit: {}, onComplete: {
                        DispatchQueue.main.async { hold.reset() }
                        openPravesha()
                    })
                    hold.press(.touch)
                }
                let moved = Double(hypot(v.translation.width, v.translation.height))
                if moved > HoldLadder.cancelDistance, !pressMoved {
                    pressMoved = true
                    if hold.isHeld { hold.cancel() }
                }
            }
            .onEnded { _ in
                let held = pressAt.map { Date().timeIntervalSince($0) } ?? HoldLadder.tapMaxDuration + 1
                pressAt = nil
                let committed = hold.isCommitted
                hold.release(.touch)
                if !pressMoved, !committed, !spreading, held <= HoldLadder.tapMaxDuration {
                    openMauna()
                }
            }
    }

    // MARK: - #31 · Spanda — spread on the point, held full for .6 s

    /// A spread that starts within 60 pt of the point is Spanda (§7 settled 8).
    private func spreadRegion(centre c: CGPoint) -> some View {
        let p = spread
        let names = TheCentre.ringNames(seats, ring: 2)
        return ZStack {
            if p.isVisible(at: Date().timeIntervalSinceReferenceDate) {
                TimelineView(.animation(paused: reduceMotion)) { tl in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    let v = reduceMotion ? (p.holding ? 1 : 0) : p.value(at: t)
                    ZStack {
                        Canvas { context, size in
                            let side = min(size.width, size.height)
                            let unit = side * 0.46 / 150 * CGFloat(CentreBloom.scale(bloom: v))
                            var veil = context
                            veil.opacity = 0.55 * CentreBloom.ease(v)
                            veil.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.black))
                            CentreYantra.draw(in: context, centre: c, unit: unit,
                                              opacity: { CentreBloom.opacity($0, bloom: v) },
                                              names: names, rotation: .zero)
                        }
                        VStack(spacing: 8) {
                            Text("She breathes, and the worlds appear.")
                                .font(AppFont.voice(19))
                                .foregroundStyle(Color.cream)
                            Text("release · and they return to her")
                                .font(AppFont.label(11))
                                .tracking(1.6)
                                .foregroundStyle(Color.gold)
                        }
                        .multilineTextAlignment(.center)
                        .opacity(CentreBloom.band(v, 0.5, 0.3))
                        .position(x: c.x, y: c.y + 230)
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }

    private var spreadGesture: some Gesture {
        MagnifyGesture()
            .onChanged { v in
                lastTouchAt = Date()
                guard v.magnification > 1.06, !spreading else { return }
                spreading = true
                if hold.isHeld { hold.cancel() }
                spread = spread.changed(holding: true, at: Date().timeIntervalSinceReferenceDate)
            }
            .onEnded { _ in
                guard spreading else { return }
                spreading = false
                spread = spread.changed(holding: false, at: Date().timeIntervalSinceReferenceDate)
            }
    }

    /// Held at full for .6 s → the crossing into the Mandala; released
    /// earlier, the worlds return to the point.
    private func watchSpread() async {
        guard spreading else { return }
        var fullSince: Date?
        while !Task.isCancelled, spreading {
            try? await Task.sleep(for: .milliseconds(50))
            let v = spread.value(at: Date().timeIntervalSinceReferenceDate)
            if v >= HomeSpanda.full {
                let since = fullSince ?? Date()
                fullSince = since
                if Date().timeIntervalSince(since) >= HomeSpanda.holdAtFull {
                    spandaIntoTheMandala(from: nil)
                    return
                }
            } else {
                fullSince = nil
            }
        }
    }

    // MARK: - #15 · #16 · The Road Home, and the name at the point

    private func roadHome(size: CGSize, centre c: CGPoint) -> some View {
        let beads = router.state.beads
        let name = memory.higherSelfName
        return ZStack {
            ForEach(Array(beads.enumerated()), id: \.offset) { i, bead in
                let p = HomeLayout.bead(i, of: beads.count, centre: c)
                let entry = WorldRegistry.entry(bead.world)
                Circle()
                    .fill(entry.color.opacity(0.8))
                    .frame(width: 7, height: 7)
                    .frame(width: Hit.min, height: Hit.min)
                    .contentShape(Circle())
                    .onTapGesture { resume(bead, from: p) }
                    .accessibilityElement()
                    .accessibilityLabel(Text("You were partway down · \(bead.world.title)"))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { resume(bead, from: p) }
                    .accessibilityIdentifier("bead.\(bead.world.rawValue)")
                    .position(p)
            }
            if let name, nameAtPoint {
                Text(name)
                    .font(AppFont.voice(15))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .fixedSize()
                    .hold(for: HoldLadder.story, named: "Your higher self's name, kept", onComplete: { openEssence() })
                    .position(x: c.x, y: c.y + 30)
            }
            VStack(spacing: 10) {
                Text(name.map { "the road to \($0)" } ?? "the road home")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.5))
                    .fixedSize()
                    .frame(minHeight: Hit.min)
                    .hold(for: HoldLadder.story, named: "The road home", onComplete: { openEssence() })
                if name == nil, !askedForName {
                    Text("What name surfaced?")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.gold.opacity(0.75))
                        .fixedSize()
                        .frame(minHeight: Hit.min)
                        .contentShape(Rectangle())
                        .onTapGesture { openEssence() }
                        .accessibilityAddTraits(.isButton)
                        .accessibilityAction { openEssence() }
                }
            }
            .position(x: c.x, y: c.y + HomeLayout.beadRadius + 40)
        }
    }

    private func resume(_ bead: Address, from p: CGPoint) {
        guard !leaving else { return }
        leaving = true
        withAnimation(.easeOut(duration: 0.5)) { partway = "You were partway down" }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.3 : 1.1))
            leaving = router.go(to: bead, via: .bloom(from: p))
            if !leaving { withAnimation(.easeIn(duration: 0.4)) { partway = nil } }
        }
    }

    // MARK: - Words: the greeting, the five's lines, stillness, partway

    private func words(size: CGSize, centre c: CGPoint) -> some View {
        let y = HomeLayout.messageY(size: size, centre: c)
        return ZStack {
            if let g = greeting {
                VStack(spacing: 6) {
                    ForEach(g.lines, id: \.self) { line in
                        Text(line).font(AppFont.voice(20)).foregroundStyle(Color.cream.opacity(0.82))
                    }
                }
                .opacity(greetingShown ? 1 : 0)
            }
            if let road = chosenFive, let f = HomeFive.of(road) {
                VStack(spacing: 6) {
                    Text(f.line).font(AppFont.voice(19)).foregroundStyle(Color.cream.opacity(0.86))
                    Text(HomeFive.atThePoint).font(AppFont.voice(14)).foregroundStyle(Color.gold.opacity(0.7))
                }
                .transition(.opacity)
            }
            if stillLine {
                Text(HomeStillness.line)
                    .font(AppFont.voice(17))
                    .foregroundStyle(Color.cream.opacity(0.7))
                    .transition(.opacity)
            }
            if let partway {
                Text(partway)
                    .font(AppFont.voice(19))
                    .foregroundStyle(Color.cream.opacity(0.8))
                    .transition(.opacity)
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 28)
        .frame(width: size.width)
        .position(x: c.x, y: y)
        .allowsHitTesting(false)
    }

    // MARK: - #10 · Chrome

    private func chrome(size: CGSize) -> some View {
        SoundGlyph(settings: SoundSettings.shared)
            .frame(width: Hit.min, height: Hit.min)
            .position(x: 16 + Hit.min / 2, y: size.height - 34 - Hit.min / 2)
    }

    // MARK: - #72 · Her card, when a gift opened the instrument

    @ViewBuilder
    private func herCard(kp: Int, size: CGSize) -> some View {
        if let her = shaktis.first(where: { $0.khadgamalaPosition == kp }) {
            let accent = Atmosphere.derive(from: her).accentBright
            VStack(spacing: 12) {
                Text(her.name)
                    .font(AppFont.sanskrit(28))
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                if let phrase = her.appreciationPhrase?.trimmingCharacters(in: .whitespacesAndNewlines), !phrase.isEmpty {
                    Text(phrase)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.75))
                        .multilineTextAlignment(.center)
                } else if !her.quality.isEmpty {
                    Text(her.quality)
                        .font(AppFont.voice(17))
                        .foregroundStyle(Color.cream.opacity(0.75))
                        .multilineTextAlignment(.center)
                }
                HStack(spacing: 28) {
                    Button { _ = router.back(via: .dissolve) } label: {
                        Text("not now")
                            .font(AppFont.voice(15))
                            .foregroundStyle(Color.cream.opacity(0.55))
                            .frame(minWidth: Hit.min, minHeight: Hit.min)
                    }
                    .buttonStyle(.plain)
                    Button {
                        guard !leaving else { return }
                        leaving = router.go(to: Address(.herHome, kp: kp), via: Crossing(kind: .pulseGate))
                    } label: {
                        Text("be with her")
                            .font(AppFont.sanskrit(19))
                            .foregroundStyle(accent)
                            .frame(minWidth: Hit.min, minHeight: Hit.min)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("home.card.door")
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(RoundedRectangle(cornerRadius: 22).fill(Color.surface.opacity(0.92)))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(accent.opacity(0.35), lineWidth: 0.5))
            .padding(.horizontal, 20)
            .frame(width: size.width)
            .position(x: size.width / 2, y: size.height - 150)
        }
    }
}

/// The greeting is a launch's, once per process (#5).
@MainActor
enum HomeGreetingOnce {
    static var done = false
}

// MARK: - The structural five (#17), verbatim

/// One of the five faint points round the One — `spine-and-home.md` #17.
struct HomeFive: Equatable {
    /// Its room on the Road.
    let road: Int
    let name: String
    let line: String

    /// Shadow (9), Axis (18), Armin (20), Maya (30), Aatma (31). 32 stays
    /// sealed and is not placed; 33 is not placed.
    static let all: [HomeFive] = [
        HomeFive(road: 9, name: "Shadow", line: "Shadow is Bindu distorted."),
        HomeFive(road: 18, name: "Axis", line: "Axis is Bindu turning."),
        HomeFive(road: 20, name: "Armin", line: "Armin is Bindu recognized."),
        HomeFive(road: 30, name: "Maya", line: "Maya is Bindu projected."),
        HomeFive(road: 31, name: "Aatma", line: "Aatma is Bindu remembered."),
    ]

    /// At the point.
    static let atThePoint = "Bindu is what the other five are made of."

    static func of(_ road: Int) -> HomeFive? { all.first { $0.road == road } }
}

// MARK: - The stillness gate (#33), pure

enum HomeStillness {
    /// Stillness accrues after 340 ms of no touch…
    static let after: Double = 0.34
    /// …up to 4,600 ms.
    static let full: Double = 4.6
    /// The one line, once ever, after 700 ms.
    static let lineAfter: Double = 0.7
    static let line = "It holds until you stop meaning it."

    /// The gate has opened in this stillness: it does not open twice in one
    /// stillness — Home must be touched before the point notices again (the
    /// Wave 6 law of `CentreArrival`, `restedSinceLastMove`). Without it, a
    /// return from Mauna would be carried straight back in.
    @MainActor static var restedSinceTouch = false

    /// Whether the count rises now. A touch pauses it; VoiceOver's walker is
    /// never carried off by a stillness he cannot see; an open card holds it.
    static func gathers(touching: Bool, untouchedFor: Double, voiceOver: Bool, somethingOpen: Bool,
                        restedSinceTouch: Bool = false) -> Bool {
        !touching && !voiceOver && !somethingOpen && !restedSinceTouch && untouchedFor >= after
    }
}

// MARK: - Spanda (#31)

enum HomeSpanda {
    /// Full bloom.
    static let full = 0.985
    /// Held at p = 1 for .6 s → the crossing into the Mandala.
    static let holdAtFull: Double = 0.6
}
