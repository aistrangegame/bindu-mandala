import SwiftUI
import SwiftData

// MARK: - Upgrade U2 · C · the Mandala, cleared, and the 33 in their own space

/// The Mandala — the held yantra and the Veil (`mandala-and-rings.md` §1A),
/// cleared of the seven worlds it used to host (`LivingMandalaView`).
struct MandalaHeldWorld: View {
    let address: Address

    @Environment(Router.self) private var router

    var body: some View {
        HostedWorld(address: address, doors: false) {
            LivingMandalaView(address: address, router: router)
        }
    }
}

/// The 33 — `mandala-and-rings.md` MX01–MX04 and register 19 §C1: the
/// constellation, the Road ("a story told by a moving point") and the chakra
/// rooms, with the Shadow and Armin thresholds and "Tat · Tvam · Asi" played
/// in the Road's crossings — on a glass of their own, so the 33 never again
/// overlap the 102 or take the Mandala's touches. A light's room is a place
/// inside this world (`chakra` + `room`), and back returns to the lights.
struct The33World: View {
    let address: Address

    @Environment(Router.self) private var router

    private var roomRoad: Int? {
        address.sub == WorldSub.room ? address.chakra : nil
    }

    var body: some View {
        HostedWorld(address: address, doors: roomRoad == nil) {
            ZStack {
                The33Field(router: router, walkTheRoad: address.sub == WorldSub.road)
                    .accessibilityHidden(roomRoad != nil)
                if let road = roomRoad {
                    ChakraRoomHost(road: road, onLeave: { _ = router.back() })
                        .transition(.opacity)
                        .id(road)
                }
            }
        }
    }
}

/// The constellation of the 33 at their addresses, drawn alone on the night —
/// no yantra, no seats beneath them — with the Road walked over it.
struct The33Field: View {
    let router: Router
    /// Begin walking the Road on arrival (the address asked for it).
    let walkTheRoad: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var camera = MandalaCamera(scale: 0.5, tx: 0, ty: 0)
    @State private var size: CGSize = .zero
    @State private var ready = false
    @State private var seats: [MandalaWorld.Seat] = []
    /// The 33 are always drawn here: this world *is* the constellation. (The
    /// phone-local switch the Mandala kept for them is not touched.)
    @State private var layer: ChakraLayerState = {
        var s = ChakraLayerState()
        s.constellationOn = true
        return s
    }()
    @State private var lastDrag: CGSize = .zero
    @State private var lastMagnify: CGFloat = 1
    @State private var variant: TimeVariant = LunarPhaseService.currentTimeVariant()
    private let soundOn = (UserDefaults.standard.object(forKey: "lr_sound") as? Bool) ?? true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                MandalaSky(variant: variant, dayGlow: WorldRegistry.entry(.the33).color.opacity(0.35))
                    .ignoresSafeArea()
                if ready {
                    TimelineView(.animation(paused: reduceMotion)) { tl in
                        let t = tl.date.timeIntervalSinceReferenceDate
                        Canvas { ctx, _ in
                            ChakraConstellationDrawing.draw(ctx, chakras: layer.drawn, seats: seats,
                                                            camera: camera, size: geo.size, t: t,
                                                            reduceMotion: reduceMotion,
                                                            focusRoad: layer.walking ? layer.focusRoad : nil)
                        }
                    }
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
                }
                // Pan and pinch over the lights (the lights' own doors sit above).
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(drag)
                    .simultaneousGesture(pinch)
                    .accessibilityHidden(true)
                if ready {
                    ChakraLayerOverlay(
                        state: $layer, camera: $camera, size: geo.size, seats: seats,
                        reduceMotion: reduceMotion, soundOn: soundOn,
                        hidden: false,
                        onBeginRoad: { },
                        onEndRoad: { fit() },
                        onOpenRoom: { road in WorldDoors.chakraRoom(road, router: router) })
                }
                header
                if !layer.walking { roadDoor }
            }
            .onAppear {
                size = geo.size
                seats = MandalaWorld.seats(from: shaktis)
                if !ready, geo.size != .zero {
                    camera = .fitted(in: geo.size)
                    ready = true
                    if walkTheRoad {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { layer.roadAsked = true }
                    }
                }
            }
            .onChange(of: geo.size) { _, s in
                size = s
                if !ready, s != .zero {
                    camera = .fitted(in: s)
                    ready = true
                }
            }
            .onChange(of: shaktis.count) { _, _ in seats = MandalaWorld.seats(from: shaktis) }
        }
    }

    private var header: some View {
        VStack(spacing: 5) {
            Text(WorldRegistry.entry(.the33).displayName)
                .font(AppFont.sanskrit(24)).tracking(1.4)
                .foregroundStyle(Color.cream)
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.top, 104)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .allowsHitTesting(false)
    }

    /// The Road, begun from its own quiet word at the foot (the ways-in ring
    /// that held it on the Mandala is retired — MX13).
    private var roadDoor: some View {
        VStack {
            Spacer()
            Button {
                Haptics.soft()
                layer.roadAsked = true
            } label: {
                Text("walk the road ›")
                    .font(AppFont.voice(16))
                    .tracking(1.0)
                    .foregroundStyle(Color.gold.opacity(0.8))
                    .padding(.horizontal, 18)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Walk the road"))
            .accessibilityIdentifier("the33.road")
            .padding(.bottom, 64)
        }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { v in
                guard !layer.walking else { return }
                let delta = CGSize(width: v.translation.width - lastDrag.width,
                                   height: v.translation.height - lastDrag.height)
                camera = camera.panned(by: delta)
                lastDrag = v.translation
            }
            .onEnded { _ in lastDrag = .zero }
    }

    private var pinch: some Gesture {
        MagnifyGesture()
            .onChanged { v in
                guard !layer.walking else { return }
                let factor = v.magnification / lastMagnify
                camera = camera.zoomed(at: v.startLocation, factor: factor)
                lastMagnify = v.magnification
            }
            .onEnded { _ in lastMagnify = 1 }
    }

    private func fit() {
        guard size != .zero else { return }
        withAnimation(.easeInOut(duration: 0.6)) { camera = .fitted(in: size) }
    }
}
