import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · C · the nine rings, one ring at a time
//
// `waves/upgrade/briefs/U2-spine-and-home.md` Part C 2 and
// `waves/upgrade/worlds/mandala-and-rings.md` §1B, MX05–MX07: a world that
// opens on the ring chosen — from the Veil's row, a door, or (from Home's
// station) the ring today's Śakti sits in — and shows **what exists for that
// ring today**, in its own space: the Tree of Life panel and its collective
// breath (`TreeOfLifeRingLayer`), the Gate of Release (`GatesOfReleaseLayer`:
// set down going in, received coming out), the ring 7 chord and the ring 8
// triad (`MandalaFieldVoice`), and in the ninth the fall into the point
// (Praveśa, through `MaunaView`). These used to stand on the Mandala's glass,
// all of them at once (register 19 §B2); here exactly one ring is entered.
//
// The Field (the hundred and two, ring by ring) is a place inside this world.

/// The sub-place of the nine rings that holds the Field.
extension WorldSub {
    static let field = "field"
}

struct RingsWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    private var todayKp: Int { AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition() }

    /// The ring this address stands in: named, else her ring (kp thread),
    /// else the ring today's Śakti sits in.
    private var ring: Int {
        if let r = WorldSub.ring(in: address.sub) { return r }
        if let kp = address.kp { return KhadgamalaMap.ringNumber(forKhadgamala: kp) }
        return KhadgamalaMap.ringNumber(forKhadgamala: todayKp)
    }

    var body: some View {
        HostedWorld(address: address) {
            if address.sub == WorldSub.field {
                TheHundredTwoView()
            } else {
                RingSpace(ring: ring, router: router)
            }
        }
    }
}

/// One ring, entered: its enclosure framed on the glass, its panel, its gate,
/// its voice — and the eight others a touch away.
struct RingSpace: View {
    let ring: Int
    let router: Router

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var size: CGSize = .zero
    @State private var seats: [MandalaWorld.Seat] = []
    @State private var atmos: [Int: Atmosphere] = [:]
    /// The ring the layers have been told he has entered. Starts outside (0)
    /// so the first arrival is an inward crossing, as on the descent.
    @State private var entered = 0
    @State private var heldAt: Date?
    @State private var lastTouchAt: TimeInterval = Date().timeIntervalSinceReferenceDate
    @State private var stillSeconds: Double = 0
    @State private var falling = false
    @State private var variant: TimeVariant = LunarPhaseService.currentTimeVariant()
    @State private var soundOn = (UserDefaults.standard.object(forKey: "lr_sound") as? Bool) ?? true

    private var todayKp: Int { AppRuntime.pinnedEnergyPosition ?? DailyEnergyService.todaysPosition() }

    private var dayAtmo: Atmosphere {
        atmos[todayKp] ?? Atmosphere.derive(ring: 2, cluster: .inner, khadgamala: todayKp,
                                            element: .ether, at: variant)
    }

    var body: some View {
        GeometryReader { geo in
            let camera = MandalaCamera.ringTarget(ring: min(ring, 8), in: geo.size)
            ZStack {
                MandalaSky(variant: variant, dayGlow: dayAtmo.glow)
                    .ignoresSafeArea()
                if !seats.isEmpty, ring <= 8 {
                    MandalaCanvasLayer(
                        camera: camera, size: geo.size, seats: seats, atmos: atmos,
                        dayAccent: dayAtmo.accent, todayKp: todayKp,
                        focusKp: nil, familyKp: [],
                        focusAccentBright: Color.gold,
                        felt: Set(shaktis.filter { $0.hasBeenFelt }.compactMap { $0.khadgamalaPosition }),
                        flash: nil, constellation: 0,
                        tier: camera.tier, reduceMotion: reduceMotion,
                        variant: variant)
                }
                // A touch on one of her seats in this ring opens her room; a
                // hold anywhere answers the ring's verb (the collective breath).
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture(coordinateSpace: .local) { p in
                        lastTouchAt = Date().timeIntervalSinceReferenceDate
                        stillSeconds = 0
                        if let seat = seat(near: p, camera: camera) {
                            Haptics.medium()
                            WorldDoors.herHome(seat.id, router: router, from: p)
                        }
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: TreeOfLife.holdSeconds(ring: entered),
                                         maximumDistance: 14)
                            .onEnded { _ in heldAt = Date() })
                    .accessibilityHidden(true)
                if ring <= 8 {
                    TreeOfLifeRingLayer(ring: entered, active: !falling, camera: camera, seats: seats,
                                        stillSeconds: stillSeconds, heldAt: heldAt, soundOn: soundOn)
                    GatesOfReleaseLayer(ring: entered, active: !falling)
                } else {
                    theNinth
                }
                header
                foot
                if falling {
                    MaunaView(seats: seats, soundOn: soundOn, onLeave: { fellThrough in
                        falling = false
                        guard fellThrough else { return }
                        _ = router.go(to: Address(.home, kp: KhadgamalaMap.total, sub: WorldSub.source),
                                      via: Crossing(kind: .pravesha))
                    })
                    .transition(.opacity)
                }
            }
            .onAppear {
                size = geo.size
                rebuild()
                arrive()
            }
            .onChange(of: ring) { _, _ in arrive() }
            .onChange(of: shaktis.count) { _, _ in rebuild() }
        }
        .mandalaFieldVoice(ring: entered, on: soundOn, descent: falling, stillSeconds: stillSeconds)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                let held = max(0, Date().timeIntervalSinceReferenceDate - lastTouchAt)
                if held != stillSeconds { stillSeconds = held }
            }
        }
    }

    // MARK: The ring

    /// Enter the ring: the layers hear one crossing — inward from outside on
    /// arrival, or from the ring he was in when he moves between rings.
    private func arrive() {
        let target = min(max(ring, 1), 9)
        guard target != entered else { return }
        if reduceMotion || entered != 0 {
            entered = target
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { entered = target }
        }
    }

    private func seat(near p: CGPoint, camera: MandalaCamera) -> MandalaWorld.Seat? {
        var best: MandalaWorld.Seat?
        var bestD = CGFloat.greatestFiniteMagnitude
        for s in seats where (s.shakti.ringNumber ?? 2) == ring {
            let q = camera.screen(for: s.point)
            let d = hypot(q.x - p.x, q.y - p.y)
            if d < bestD { bestD = d; best = s }
        }
        return bestD <= 34 ? best : nil
    }

    private func rebuild() {
        seats = MandalaWorld.seats(from: shaktis)
        var a: [Int: Atmosphere] = [:]
        for s in shaktis { a[s.khadgamalaPosition ?? s.position] = Atmosphere.derive(from: s, at: variant) }
        atmos = a
    }

    // MARK: The ninth — the point, and the fall into it

    private var theNinth: some View {
        VStack(spacing: 26) {
            Spacer()
            Circle()
                .fill(RadialGradient(colors: [Color.accentRed, Color.accentRed.opacity(0.65), .clear],
                                     center: .center, startRadius: 0, endRadius: 22))
                .frame(width: 44, height: 44)
                .overlay(Circle().fill(Color.cream.opacity(0.95)).frame(width: 12, height: 12))
                .accessibilityHidden(true)
            // Design's words at rest ask for a hold, so the fall is a hold
            // (0.9 s, the fall to the source); a voice performs it at once.
            Text(Pravesha.rest)
                .font(AppFont.voice(18))
                .foregroundStyle(Color.cream.opacity(0.78))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
                .onLongPressGesture(minimumDuration: 0.9, maximumDistance: 24) { fall() }
                .accessibilityAddTraits(.isButton)
                .accessibilityAction { fall() }
                .accessibilityIdentifier("rings.nine.fall")
            Spacer()
        }
    }

    private func fall() {
        Haptics.medium()
        withAnimation(.easeInOut(duration: reduceMotion ? 0.2 : 1.2)) { falling = true }
    }

    // MARK: Where he stands, and the eight others

    private var header: some View {
        VStack(spacing: 6) {
            Text(MandalaVeil.name(ring: ring))
                .font(AppFont.sanskrit(28))
                .tracking(1.2)
                .foregroundStyle(Color.cream)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .accessibilityAddTraits(.isHeader)
            Text(MandalaVeil.subtitle(ring: ring))
                .font(AppFont.voice(15))
                .foregroundStyle(Color.cream.opacity(0.62))
                .lineLimit(2)
                .multilineTextAlignment(.center)
            ringChooser
                .padding(.top, 10)
        }
        .padding(.horizontal, 28)
        .padding(.top, 104)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    /// I … IX: the ring he stands in lit; a touch crosses to another ring
    /// (one ring at a time — never several at once).
    private var ringChooser: some View {
        HStack(spacing: 2) {
            ForEach(1...9, id: \.self) { r in
                Button {
                    guard r != ring else { return }
                    Haptics.light()
                    _ = router.go(to: Address(.rings, sub: WorldSub.ring(r)), via: .dissolve)
                } label: {
                    Text(MandalaVeil.roman[r])
                        .font(AppFont.sanskrit(15))
                        .foregroundStyle(r == ring ? Color.gold : Color.cream.opacity(0.5))
                        .frame(minWidth: 34, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("\(MandalaVoice.ordinal(r).capitalizedFirst) āvaraṇa"))
                .accessibilityAddTraits(r == ring ? .isSelected : [])
                .accessibilityIdentifier("rings.ring.\(r)")
            }
        }
    }

    /// Two quiet doors at the foot: the hundred and two, ring by ring (the
    /// Field), and the Climb rising from this ring.
    private var foot: some View {
        VStack {
            Spacer()
            HStack(spacing: 22) {
                footDoor("the hundred and two ›", id: "rings.field") {
                    _ = router.go(to: Address(.rings, sub: WorldSub.field), via: .dissolve)
                }
                footDoor("rise through them ›", id: "rings.climb") {
                    WorldDoors.climb(ring: min(ring, 9), router: router)
                }
            }
            .padding(.bottom, 64)
        }
    }

    private func footDoor(_ words: String, id: String, _ action: @escaping () -> Void) -> some View {
        Button {
            Haptics.light()
            action()
        } label: {
            Text(words)
                .font(AppFont.voice(15))
                .tracking(1.0)
                .foregroundStyle(Color.gold.opacity(0.75))
                .padding(.horizontal, 10)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(id)
    }
}
