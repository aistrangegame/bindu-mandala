import SwiftUI

// MARK: - Wave 6 · the door into a chakra's room, and the room's own light

/// A chakra's Road position, as something that can be presented.
struct ChakraSeat: Identifiable, Hashable {
    let id: Int
}

/// Presents a chakra's room for whatever Road position the binding holds.
/// Setting it to `nil` closes the room. Attached by the surface a light is
/// touched on — the Mandala's constellation, the Climb's body chakras — to a
/// view of its own, so it never shares a modifier chain with `herRoom`.
struct ChakraRoomDoor: ViewModifier {
    @Binding var road: Int?

    func body(content: Content) -> some View {
        content.fullScreenCover(item: seat) { s in
            ChakraRoomHost(road: s.id, onLeave: { road = nil })
        }
    }

    private var seat: Binding<ChakraSeat?> {
        Binding(get: { road.map { ChakraSeat(id: $0) } },
                set: { road = $0?.id })
    }
}

extension View {
    /// A chakra's room, whenever `road` holds one of the 33.
    func chakraRoom(_ road: Binding<Int?>) -> some View {
        modifier(ChakraRoomDoor(road: road))
    }
}

/// Finds the chakra by its Road position — its identity, as a Śakti's is her
/// position — and opens its room; a position the bake does not hold closes.
struct ChakraRoomHost: View {
    let road: Int
    let onLeave: () -> Void

    var body: some View {
        if let c = ChakraConstellation.all.first(where: { $0.road == road }) {
            ChakraRoomView(chakra: c, onLeave: onLeave)
        } else {
            Color.ground.ignoresSafeArea()
                .onAppear { onLeave() }
        }
    }
}

// MARK: - Ruling 2 · the sealed room's held threshold

/// A closed ring with one point of light breathing behind it, slowly (a 12 s
/// breath). Nothing opens; nothing is counted. Under reduce motion, still.
struct SealedThresholdMark: View {
    let tone: Color
    let reduceMotion: Bool

    static let breathSeconds: Double = 12

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = reduceMotion ? 0 : tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                let b = 0.5 - 0.5 * cos(2 * .pi * t / Self.breathSeconds)
                let c = CGPoint(x: size.width / 2, y: size.height / 2)
                let r = min(size.width, size.height) * 0.42
                var add = ctx
                add.blendMode = .plusLighter
                add.glow(at: c, radius: r * CGFloat(0.55 + 0.15 * b), color: tone, alpha: 0.18 + 0.12 * b)
                add.core(at: c, radius: 2.4, color: Color.cream, alpha: 0.55 + 0.3 * b)
                ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                           with: .color(tone.opacity(0.55)), lineWidth: 1)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - The room's own light

/// Each room moves as what it is (charter §3.4): an energy chakra breathes on a
/// long stillness in rings, the body moves (motes rising, the body wants
/// movement — C-1311), the mind holds still, the summit is a triangle of gold,
/// Shadow is a dark with stars standing in it, Armin a garland of points. The
/// colour is the Map's own. Atma is gold (*"Gold — deep gold, the temperature
/// of truth"*); the Gaia reveal rises from the ground.
struct ChakraRoomField: View {
    let chakra: Chakra33
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                draw(ctx, size: size, t: reduceMotion ? 0 : t)
            }
        }
        .background(Color.ground)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func draw(_ ctx: GraphicsContext, size: CGSize, t: Double) {
        let tone = ChakraConstellationDrawing.tone(chakra)
        let b = ChakraConstellationDrawing.breath(chakra, t: t, reduceMotion: reduceMotion)
        let c = CGPoint(x: size.width / 2, y: size.height * 0.30)
        let dim = max(size.width, size.height)
        var add = ctx
        add.blendMode = .plusLighter

        // The room's own ground light, warmer as it breathes.
        add.glow(at: c, radius: dim * (0.55 + 0.05 * CGFloat(b)), color: tone, alpha: 0.14 + 0.06 * b)

        switch chakra.kind {
        case .energy:
            for i in 0..<5 {
                let r = CGFloat(60 + i * 70) * CGFloat(1 + 0.05 * b)
                add.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                           with: .color(tone.opacity(0.16 - Double(i) * 0.025)), lineWidth: 1)
            }
        case .body:
            for i in 0..<28 {
                let x = size.width * CGFloat((i * 37) % 100) / 100
                let speed = 18 + Double((i * 13) % 20)
                let y = size.height - CGFloat((t * speed + Double(i * 97)).truncatingRemainder(dividingBy: Double(size.height + 40)))
                add.glow(at: CGPoint(x: x, y: y), radius: 7, color: i % 4 == 0 ? Color.cream : tone, alpha: 0.22)
            }
        case .mind:
            let r: CGFloat = 120
            add.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                       with: .color(tone.opacity(0.22)), lineWidth: 1)
        case .summit, .bindu:
            var tri = Path()
            let r: CGFloat = 130 * CGFloat(1 + 0.03 * b)
            for k in 0..<3 {
                let a = Double(k) / 3 * 2 * .pi - .pi / 2
                let p = CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
                if k == 0 { tri.move(to: p) } else { tri.addLine(to: p) }
            }
            tri.closeSubpath()
            let gold = chakra.road == ChakraTeaching.atmaRoad ? Color.gold : tone
            add.stroke(tri, with: .color(gold.opacity(0.35)), lineWidth: 1.2)
            add.core(at: c, radius: 3, color: Color.cream, alpha: 0.85)
            if chakra.road == ChakraTeaching.gaiaRevealRoad {
                // Gaia: the ground under all three trees at once, breathing.
                let earth = Color(red: 0.36, green: 0.55, blue: 0.34)
                let h = size.height * CGFloat(0.35 + 0.05 * b)
                add.fill(Path(CGRect(x: 0, y: size.height - h, width: size.width, height: h)),
                         with: .linearGradient(Gradient(colors: [earth.opacity(0), earth.opacity(0.22)]),
                                               startPoint: CGPoint(x: 0, y: size.height - h),
                                               endPoint: CGPoint(x: 0, y: size.height)))
            }
        case .shadow:
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.black.opacity(0.45)))
            for i in 0..<40 {
                let p = CGPoint(x: size.width * CGFloat((i * 53) % 100) / 100,
                                y: size.height * CGFloat((i * 29 + 11) % 100) / 100)
                let tw = 0.5 + 0.5 * sin(t * 0.7 + Double(i) * 1.3)
                add.core(at: p, radius: 1.1, color: Color.cream, alpha: 0.15 + 0.35 * tw)
            }
        case .armin:
            let beads = 33
            let r = min(size.width, size.height) * 0.36
            for i in 0..<beads {
                let a = Double(i) / Double(beads) * 2 * .pi + t * 0.04
                let p = CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
                add.glow(at: p, radius: 6, color: tone, alpha: 0.35 + 0.2 * b)
            }
        }
    }
}
