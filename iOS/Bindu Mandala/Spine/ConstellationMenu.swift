import SwiftUI
import SwiftData

// MARK: - U2 · B · the Constellation — the menu above every world
//
// `waves/upgrade/worlds/spine-and-home.md` §2 D #40 (face 1, by where: the
// fifteen world-points laid out as Home's own ring, threads drawing in over
// 2.2 s, the current world glowing), #41 (face 2, by name: the list), #42
// (face 3, by depth: the Veil — the Meru), #45's coda line, F #50 (search at
// its head) and M #95 (Settings, a place, from its foot). One switch turns
// the faces; he stays where he is. Touching a world crosses there through
// the Router. The menu lies above every world and is never under a cover; it
// is drawn by `SpineRoot` and opened by the 2×2 mark or a slow pull.

/// Where the fifteen stand in the Constellation, and the threads between them
/// (pure — `U2SpineTests` holds it).
enum ConstellationLayout {

    /// #40: the field is min(92 % W, 720) × min(78 % H, 820).
    static func fieldSize(in size: CGSize) -> CGSize {
        CGSize(width: min(size.width * 0.92, 720), height: min(size.height * 0.78, 820))
    }

    /// Home's own ring: r = 0.38 · min(W, H) of the field (§2 B #11, 148 pt at 390).
    static func radius(in field: CGSize) -> CGFloat {
        0.38 * min(field.width, field.height)
    }

    /// A world's place in the field, from its station (Home at the centre).
    static func point(of world: WorldID, in field: CGSize) -> CGPoint {
        let c = CGPoint(x: field.width / 2, y: field.height / 2)
        let station = WorldRegistry.entry(world).station
        guard case .ring = station else { return c }
        let a = station.degrees * .pi / 180
        let r = radius(in: field)
        return CGPoint(x: c.x + r * CGFloat(sin(a)), y: c.y - r * CGFloat(cos(a)))
    }

    /// #82 / §1 "The Constellation's threads": seventeen poetic threads — the
    /// fourteen ring neighbours, plus Mandala ↔ Climb (one Meru), Today ↔ Time
    /// (the day), Her Home ↔ the 33 (rooms).
    static var poeticThreads: [(WorldID, WorldID)] {
        let ring = WorldRegistry.stations.map(\.id)
        var out: [(WorldID, WorldID)] = []
        for i in ring.indices { out.append((ring[i], ring[(i + 1) % ring.count])) }
        out.append((.mandala, .climb))
        out.append((.today, .time))
        out.append((.herHome, .the33))
        return out
    }

    /// The three threads in their colours (§1): kp gold, chakra red, day cream.
    static let colouredThreads: [(thread: WorldThread, hex: String, path: [WorldID])] = [
        (.kp, "#C9963F", [.today, .herPresence, .herHome, .mandala, .rings, .climb]),
        (.chakra, "#D62F29", [.the33, .climb, .game, .modes]),
        (.day, "#F2E8D9", [.today, .time, .memory, .well]),
    ]

    /// #40: a thread draws in over 2.2 s, staggered 400 + 80k ms.
    static func threadProgress(_ k: Int, at t: Double) -> Double {
        min(1, max(0, (t - (0.4 + 0.08 * Double(k))) / 2.2))
    }

    /// #40: a node arrives over .8 s, staggered 80 + 55i ms.
    static func nodeArrival(_ i: Int, at t: Double) -> Double {
        min(1, max(0, (t - (0.08 + 0.055 * Double(i))) / 0.8))
    }

    /// #40: each dot breathes 4.2 s, offset (i · .27) mod 4.2.
    static func nodeBreath(_ i: Int, at t: Double) -> Double {
        let period = 4.2
        let phase = (t + (Double(i) * 0.27).truncatingRemainder(dividingBy: period)) / period
        return 0.5 - 0.5 * cos(2 * .pi * phase)
    }
}

/// The menu — `spine-and-home.md` §2 D #40–#46, F #50, M #95.
@MainActor
struct ConstellationMenu: View {
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]

    @State private var query = ""
    @State private var openedAt = Date()
    @FocusState private var searching: Bool

    /// Design's words.
    static let title = "The Constellation"
    static let coda = "The only winning move is to play."
    /// The head (mark, title, search) and the foot (Settings, the coda), pt.
    static let headAndFoot: CGFloat = 230

    private var face: Router.MenuFace { router.menuFace ?? .constellation }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ground
                VStack(spacing: 14) {
                    header
                    if query.trimmingCharacters(in: .whitespaces).isEmpty {
                        switch face {
                        case .constellation:
                            // The field takes Design's share of the screen,
                            // less the head and the foot it stands between.
                            ConstellationField(here: router.state.current.world, openedAt: openedAt,
                                               size: ConstellationLayout.fieldSize(in: CGSize(
                                                   width: geo.size.width,
                                                   height: max(320, geo.size.height - Self.headAndFoot))),
                                               cross: cross)
                                .frame(maxWidth: .infinity)
                        case .list:
                            MenuList(here: router.state.current.world, cross: cross)
                        case .veil:
                            MenuVeil(here: router.state.current, cross: cross)
                        }
                    } else {
                        results
                    }
                    Spacer(minLength: 0)
                    foot
                }
                // The reader keeps the safe area (only the ground runs under
                // the island and the home bar), so the head clears the island.
                .padding(.top, SpineChrome.inset)
                .padding(.bottom, 16)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("spine.menu")
        .onAppear { openedAt = Date() }
        .onChange(of: router.menuFace) { _, _ in openedAt = Date() }
    }

    // MARK: Parts

    /// #40: the silence radial #040104 → #0D0508, and seven stars breathing 9 s.
    private var ground: some View {
        ZStack {
            RadialGradient(colors: [Color(hex: "#0D0508"), Color(hex: "#040104")],
                           center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0, endRadius: 520)
            TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 20, paused: reduceMotion)) { ctx in
                Canvas { g, size in
                    let t = ctx.date.timeIntervalSinceReferenceDate
                    for (i, s) in Self.stars.enumerated() {
                        let b = 0.5 - 0.5 * cos(2 * .pi * (t / 9 + Double(i) / 7))
                        let p = CGPoint(x: s.x * size.width, y: s.y * size.height)
                        g.fill(Path(ellipseIn: CGRect(x: p.x - 1, y: p.y - 1, width: 2, height: 2)),
                               with: .color(Color.cream.opacity(0.10 + 0.25 * b)))
                    }
                }
            }
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .opacity(0.97)
    }

    private static let stars: [CGPoint] = [
        CGPoint(x: 0.12, y: 0.18), CGPoint(x: 0.82, y: 0.14), CGPoint(x: 0.66, y: 0.31),
        CGPoint(x: 0.21, y: 0.62), CGPoint(x: 0.9, y: 0.58), CGPoint(x: 0.38, y: 0.86),
        CGPoint(x: 0.74, y: 0.9),
    ]

    private var header: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center) {
                Button {
                    Haptics.light()
                    router.closeMenu()
                } label: {
                    MenuMarkGlyph()
                        .frame(width: Hit.min, height: Hit.min)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Close the Constellation"))
                .accessibilityIdentifier("menu.close")
                Spacer()
                Text(Self.title)
                    .font(AppFont.sanskrit(22))
                    .tracking(0.6)
                    .foregroundStyle(Color.cream.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer()
                faceSwitch
            }
            .padding(.horizontal, SpineChrome.inset)
            searchField
                .padding(.horizontal, 24)
        }
    }

    /// The three-dot switch: Constellation ⇄ List ⇄ Veil (#41).
    private var faceSwitch: some View {
        HStack(spacing: 0) {
            ForEach(Router.MenuFace.allCases, id: \.self) { f in
                Button {
                    query = ""
                    router.openMenu(f)
                } label: {
                    Circle()
                        .fill(Color.cream.opacity(f == face ? 0.9 : 0.3))
                        .frame(width: 5, height: 5)
                        .frame(width: 22, height: Hit.min)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(Self.faceName(f)))
                .accessibilityAddTraits(f == face ? .isSelected : [])
                .accessibilityIdentifier("menu.face.\(f.rawValue)")
            }
        }
        .frame(minWidth: Hit.min)
    }

    static func faceName(_ f: Router.MenuFace) -> String {
        switch f {
        case .constellation: return "The Constellation, by where"
        case .list:          return "The list, by name"
        case .veil:          return "The Veil, by depth"
        }
    }

    private var searchField: some View {
        TextField(SpineSearch.prompt, text: $query)
            .font(AppFont.voice(18))
            .foregroundStyle(Color.cream)
            .tint(Color.gold)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .focused($searching)
            .onSubmit { if let first = found.first { open(first) } }
            .padding(.vertical, 8)
            .overlay(alignment: .bottom) {
                Rectangle().fill(Color.gold.opacity(0.35)).frame(height: 0.5)
            }
            .frame(minHeight: Hit.min)
            .accessibilityIdentifier("menu.search")
    }

    // MARK: Search (#50)

    private var searchShaktis: [SpineSearchShakti] {
        shaktis.compactMap { s -> SpineSearchShakti? in
            guard let kp = s.khadgamalaPosition else { return nil }
            return SpineSearchShakti(kp: kp, title: s.name,
                                     spellings: [s.name, s.phonetic, s.shortName, s.devanagari ?? ""])
        }
    }

    private var found: [SpineSearchEntry] {
        SpineSearch.results(for: query, in: SpineSearch.index(shaktis: searchShaktis))
    }

    private var results: some View {
        let list = found
        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 4) {
                ForEach(list) { entry in
                    Button { open(entry) } label: {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(WorldRegistry.entry(entry.to.world).color)
                                .frame(width: 9, height: 9)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.title)
                                    .font(AppFont.voice(22))
                                    .foregroundStyle(Color.cream)
                                Text(WorldRegistry.entry(entry.to.world).displayName)
                                    .font(AppFont.label(11))
                                    .foregroundStyle(Color.cream.opacity(0.55))
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 28)
                        .frame(minHeight: 52)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("search.result.\(entry.id)")
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func open(_ entry: SpineSearchEntry) {
        searching = false
        cross(entry.to, nil)
    }

    // MARK: The foot

    private var foot: some View {
        VStack(spacing: 10) {
            Button {
                Haptics.light()
                router.open(place: .settings)
            } label: {
                Text("Settings")
                    .font(AppFont.voice(20))
                    .foregroundStyle(Color.cream.opacity(0.6))
                    .frame(minWidth: 120, minHeight: Hit.min)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("menu.settings")
            Text(Self.coda)
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    // MARK: Crossing

    /// Touching a world crosses there (the Router blooms from the touch).
    /// The world he is already in simply closes the menu.
    private func cross(_ to: Address, _ origin: CGPoint?) {
        Haptics.light()
        SoundMixer.shared.hum(to.world)
        if to.place == router.state.current.place || (to == Address(to.world) && to.world == router.state.current.world) {
            router.closeMenu()
            return
        }
        let kind = WorldRegistry.entry(to.world).arrival
        if !router.go(to: to, via: Crossing(kind: kind, origin: origin)) {
            router.closeMenu()
        }
    }
}

/// The 2×2 glyph, drawn (the mark's own figure, without its button).
struct MenuMarkGlyph: View {
    var body: some View {
        VStack(spacing: ConstellationMark.gap) {
            HStack(spacing: ConstellationMark.gap) {
                Circle().fill(Color(hex: ConstellationMark.crimson)).frame(width: ConstellationMark.dot, height: ConstellationMark.dot)
                Circle().fill(Color.gold.opacity(0.75)).frame(width: ConstellationMark.dot, height: ConstellationMark.dot)
            }
            HStack(spacing: ConstellationMark.gap) {
                Circle().fill(Color.gold.opacity(0.75)).frame(width: ConstellationMark.dot, height: ConstellationMark.dot)
                Circle().fill(Color.gold.opacity(0.75)).frame(width: ConstellationMark.dot, height: ConstellationMark.dot)
            }
        }
    }
}

// MARK: - Face 1 · the Constellation, by where (#40)

@MainActor
struct ConstellationField: View {
    let here: WorldID
    let openedAt: Date
    let size: CGSize
    let cross: (Address, CGPoint?) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 30, paused: reduceMotion)) { ctx in
            let t = reduceMotion ? 10 : ctx.date.timeIntervalSince(openedAt)
            ZStack {
                threads(at: t)
                ForEach(Array(WorldID.allCases.enumerated()), id: \.element) { i, w in
                    node(w, index: i, at: t)
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(width: size.width, height: size.height)
    }

    private func threads(at t: Double) -> some View {
        Canvas { g, _ in
            var k = 0
            for (a, b) in ConstellationLayout.poeticThreads {
                draw(g, from: a, to: b, p: ConstellationLayout.threadProgress(k, at: t),
                     colour: Color(red: 212 / 255, green: 169 / 255, blue: 72 / 255).opacity(0.18), dashed: true)
                k += 1
            }
            for thread in ConstellationLayout.colouredThreads {
                for j in 0..<(thread.path.count - 1) {
                    draw(g, from: thread.path[j], to: thread.path[j + 1],
                         p: ConstellationLayout.threadProgress(k, at: t),
                         colour: Color(hex: thread.hex).opacity(0.32), dashed: false)
                    k += 1
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func draw(_ g: GraphicsContext, from a: WorldID, to b: WorldID, p: Double, colour: Color, dashed: Bool) {
        guard p > 0 else { return }
        let pa = ConstellationLayout.point(of: a, in: size)
        let pb = ConstellationLayout.point(of: b, in: size)
        let end = CGPoint(x: pa.x + (pb.x - pa.x) * CGFloat(p), y: pa.y + (pb.y - pa.y) * CGFloat(p))
        var path = Path()
        path.move(to: pa)
        path.addLine(to: end)
        g.stroke(path, with: .color(colour),
                 style: StrokeStyle(lineWidth: dashed ? 0.8 : 0.6, lineCap: .round, dash: dashed ? [3, 4] : []))
    }

    private func node(_ w: WorldID, index i: Int, at t: Double) -> some View {
        let entry = WorldRegistry.entry(w)
        let at = ConstellationLayout.point(of: w, in: size)
        let arrive = ConstellationLayout.nodeArrival(i, at: t)
        let breath = reduceMotion ? 0.5 : ConstellationLayout.nodeBreath(i, at: t)
        let isHere = w == here
        let composed = !WorldBuilders.isPlaceholder(w)
        let dot: CGFloat = 11 * (isHere ? 1.4 : 1)
        // The crossing blooms through the point (the field's coordinates are
        // not the window's, so no touch origin is handed on).
        return Button {
            cross(Address(w), nil)
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    if isHere {
                        Circle().fill(entry.color.opacity(0.18)).frame(width: dot * 3.2, height: dot * 3.2)
                        Circle().fill(entry.color.opacity(0.32)).frame(width: dot * 2, height: dot * 2)
                    }
                    Circle()
                        .fill(entry.color)
                        .frame(width: dot, height: dot)
                        .scaleEffect(CGFloat(1 + 0.12 * breath))
                }
                .frame(width: 30, height: 30)
                Text(entry.displayName)
                    .font(AppFont.label(11))
                    .foregroundStyle(Color.cream.opacity(isHere ? 0.95 : 0.7))
                    .fixedSize()
            }
            .frame(minWidth: Hit.min, minHeight: Hit.min)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(arrive * (composed ? 1 : 0.42))
        .scaleEffect(CGFloat(0.6 + 0.4 * arrive))
        .blur(radius: CGFloat(4 * (1 - arrive)))
        .position(x: at.x, y: at.y + 8)
        .accessibilityLabel(Text(w.title))
        .accessibilityValue(Text(isHere ? "you are here" : (composed ? "" : WorldPlaceholder.notYet)))
        .accessibilityIdentifier("menu.node.\(w.rawValue)")
    }
}

// MARK: - Face 2 · the list, by name (#41)

@MainActor
struct MenuList: View {
    let here: WorldID
    let cross: (Address, CGPoint?) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Home first, then the stations in their ring order.
    static var order: [WorldID] { [.home] + WorldRegistry.stations.map(\.id) }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(Self.order, id: \.self) { w in
                    row(w)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func row(_ w: WorldID) -> some View {
        let entry = WorldRegistry.entry(w)
        let composed = !WorldBuilders.isPlaceholder(w)
        return Button {
            cross(Address(w), nil)
        } label: {
            HStack(spacing: 18) {
                TimelineView(.animation(minimumInterval: 1.0 / 15, paused: reduceMotion)) { ctx in
                    let b = reduceMotion ? 0.5 : 0.5 - 0.5 * cos(2 * .pi * ctx.date.timeIntervalSinceReferenceDate / 4.2)
                    ZStack {
                        Circle().fill(RadialGradient(colors: [entry.color.opacity(0.35), .clear],
                                                     center: .center, startRadius: 0, endRadius: 38))
                        Circle().fill(entry.color).frame(width: 10, height: 10)
                            .scaleEffect(CGFloat(1 + 0.15 * b))
                    }
                }
                .frame(width: 76, height: 76)
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.displayName)
                        .font(AppFont.voice(28))
                        .foregroundStyle(Color.cream.opacity(w == here ? 1 : 0.85))
                    if !composed {
                        Text(WorldPlaceholder.notYet)
                            .font(AppFont.voice(14))
                            .foregroundStyle(Color.cream.opacity(0.5))
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .contentShape(Rectangle())
            .opacity(composed ? 1 : 0.6)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(w.title))
        .accessibilityIdentifier("menu.row.\(w.rawValue)")
    }
}

// MARK: - Face 3 · the Veil, by depth (#42)

/// The index as the Meru by depth: the sky above, Today at the gates, the
/// rings I–VIII with the worlds on their terraces, the Bindu as the footer
/// IX, the Well and Beneath below the ground. Light, never locks: every row
/// opens; where he stands is "you are here".
@MainActor
struct MenuVeil: View {
    let here: Address
    let cross: (Address, CGPoint?) -> Void

    static let sky: [WorldID] = [.time, .memory]
    static let gates: [WorldID] = [.today, .mandala]
    static let terraces: [WorldID] = [.herPresence, .herHome, .the33, .climb, .game, .modes, .relationship]
    static let beneathTheGround: [WorldID] = [.well, .beneath]
    static let romans = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Self.sky, id: \.self) { worldRow($0) }
                hairline
                ForEach(Self.gates, id: \.self) { worldRow($0) }
                ForEach(1...8, id: \.self) { ringRow($0) }
                ForEach(Self.terraces, id: \.self) { worldRow($0) }
                binduFooter
                hairline
                ForEach(Self.beneathTheGround, id: \.self) { worldRow($0) }
            }
            .padding(.vertical, 8)
        }
    }

    private var hairline: some View {
        Rectangle()
            .fill(Color.gold.opacity(0.22))
            .frame(height: 0.5)
            .padding(.horizontal, 28)
            .padding(.vertical, 6)
    }

    private func worldRow(_ w: WorldID) -> some View {
        let isHere = here.world == w
        return row(title: WorldRegistry.entry(w).displayName, mark: nil, isHere: isHere,
                   colour: WorldRegistry.entry(w).color, id: "menu.veil.\(w.rawValue)") {
            cross(Address(w), nil)
        }
    }

    private func ringRow(_ n: Int) -> some View {
        let isHere = here.world == .rings && here.ringNumber == n
        return row(title: Avarana.enclosureForm(forRing: n), mark: Self.romans[n - 1], isHere: isHere,
                   colour: WorldRegistry.entry(.rings).color, id: "menu.veil.ring.\(n)") {
            cross(Address.ringPlace(n), nil)
        }
    }

    private func row(title: String, mark: String?, isHere: Bool, colour: Color, id: String,
                     action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Circle().fill(colour).frame(width: 7, height: 7)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(AppFont.sanskrit(20))
                        .foregroundStyle(Color.cream.opacity(isHere ? 0.95 : 0.85))
                    if isHere {
                        Text("you are here")
                            .font(AppFont.voice(13))
                            .foregroundStyle(Color.gold.opacity(0.9))
                    }
                }
                Spacer(minLength: 0)
                if let mark {
                    Text(mark)
                        .font(AppFont.sanskrit(19))
                        .foregroundStyle(Color.gold.opacity(0.6))
                }
            }
            .padding(.horizontal, 28)
            .frame(minHeight: 48)
            .background(isHere ? Color.gold.opacity(0.08) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(id)
    }

    /// #42: the Bindu is not a row, it is the footer IX — a hairline, a warm
    /// crimson radial, the 26 pt point pulsing 4.5 s, the name.
    private var binduFooter: some View {
        Button { cross(.home, nil) } label: {
            VStack(spacing: 8) {
                LinearGradient(colors: [.clear, Color.gold.opacity(0.45), .clear],
                               startPoint: .leading, endPoint: .trailing)
                    .frame(height: 0.5)
                    .padding(.horizontal, 40)
                ZStack {
                    RadialGradient(colors: [Color(red: 139 / 255, green: 26 / 255, blue: 42 / 255).opacity(0.20), .clear],
                                   center: .center, startRadius: 0, endRadius: 90)
                        .frame(width: 180, height: 130)
                    ThePoint(look: PointLook(depth: 1, core: HouseTokens.ember, halo: HouseTokens.crimson,
                                             size: 10, breath: 4.5))
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
                Text(WorldRegistry.entry(.home).displayName)
                    .font(AppFont.sanskrit(24))
                    .foregroundStyle(Color.cream)
                Text("THE BINDU · IX")
                    .font(AppFont.label(11))
                    .tracking(2.2)
                    .foregroundStyle(Color.gold.opacity(0.7))
                if here.world == .home {
                    Text("you have reached the center of the column")
                        .font(AppFont.voice(14))
                        .foregroundStyle(Color.cream.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("menu.veil.home")
    }
}
