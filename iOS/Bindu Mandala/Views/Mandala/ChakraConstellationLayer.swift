import SwiftUI

// MARK: - The 33 as a constellation over the yantra
//
// Wave 3 (`waves/wave-3-origin.md`). The Map's 33 chakras, each drawn at its
// address in the yantra (C-1343–45) — as light, never as a figure:
//
//   · an **energy** chakra lives at the level of a whole ring: a thread of its
//     own colour strung through the seats it holds (the ten Siddhis, the eight
//     Mātṛkās …), or, where its Śakti presides over the ring rather than sitting
//     in it, a breath of light round the whole circle;
//   · a **body**, **mind** or **summit** chakra lives at one Śakti's seat: a
//     small corona round her point;
//   · **Shadow** is the corridor between the third and fourth rings — a band
//     where the light thins and a few stars stand; **Armin** is Tripura
//     Mālinī's gate between the sixth and seventh — a garland of points, the
//     light returning ("invisible at Shadow, visible at Armin", C-1345);
//   · the **Bindu** and **Lalitā** are the same point at both ends of the walk:
//     two rings of gold round the centre.
//
// Energy chakras breathe slowly and body chakras move a little (energy wants
// stillness, the body wants movement — C-1311); the mind holds steady. The
// colour is the Map's own Color Hex. Nothing here reads practice: the layer is
// the same on the first day and the ten-thousandth.
//
// Drawn from inside `MandalaCanvasLayer`'s one `Canvas` by a single call, so it
// moves with the camera and costs no views.
enum ChakraConstellationDrawing {

    /// Draw the constellation. `focusRoad` is the chakra the Road is standing
    /// at, lit a little brighter; nil when nobody is walking.
    static func draw(_ ctx: GraphicsContext,
                     chakras: [Chakra33],
                     seats: [MandalaWorld.Seat],
                     camera: MandalaCamera,
                     size: CGSize,
                     t: TimeInterval,
                     reduceMotion: Bool,
                     focusRoad: Int?) {
        guard !chakras.isEmpty else { return }
        var points: [Int: CGPoint] = [:]
        for seat in seats { points[seat.id] = seat.point }
        var add = ctx
        add.blendMode = .plusLighter
        let zoom = min(max(camera.scale, 0.6), 2.4)

        for c in chakras {
            let colour = tone(c)
            let lit = focusRoad == c.road
            let gain: Double = lit ? 1.6 : (focusRoad == nil ? 1 : 0.55)
            switch c.address {
            case .centre:
                drawCentre(add, c: c, colour: colour, camera: camera, zoom: zoom,
                           t: t, reduceMotion: reduceMotion, gain: gain)
            case .threshold:
                drawThreshold(ctx, add, c: c, colour: colour, camera: camera, size: size,
                              zoom: zoom, t: t, reduceMotion: reduceMotion, gain: gain)
            case .ring:
                if c.kp.isEmpty {
                    drawPresiding(add, c: c, colour: colour, camera: camera, zoom: zoom,
                                  t: t, reduceMotion: reduceMotion, gain: gain)
                } else {
                    drawThread(add, c: c, colour: colour, points: points, camera: camera,
                               size: size, zoom: zoom, t: t, reduceMotion: reduceMotion, gain: gain)
                }
            case .seat:
                drawCorona(add, c: c, colour: colour, points: points, camera: camera,
                           size: size, zoom: zoom, t: t, reduceMotion: reduceMotion, gain: gain)
            }
        }
    }

    // MARK: Colour

    /// The Map's Color Hex; the instrument's gold where the cell is empty.
    ///
    /// The body's colours are deep (#060D30, #112E17 …) and additive light of
    /// that depth would vanish on the indigo sky, so each hue is carried a
    /// third of the way toward cream: still its own colour, now light.
    static func tone(_ c: Chakra33) -> Color {
        guard let hex = c.colorHex, hex.hasPrefix("#"), hex.count == 7 else { return Color.gold }
        var v: UInt64 = 0
        Scanner(string: String(hex.dropFirst())).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255
        let g = Double((v >> 8) & 0xFF) / 255
        let b = Double(v & 0xFF) / 255
        // Cream #F2E8D9.
        let lift = (r + g + b) / 3 < 0.25 ? 0.45 : 0.2
        return Color(red: r + (0.949 - r) * lift,
                     green: g + (0.910 - g) * lift,
                     blue: b + (0.851 - b) * lift)
    }

    // MARK: Breath

    /// The slow breath of a place: energy chakras on a long stillness, the body
    /// a little quicker, the mind and the thresholds held almost level.
    static func breath(_ c: Chakra33, t: TimeInterval, reduceMotion: Bool) -> Double {
        guard !reduceMotion else { return 0.5 }
        let period: Double
        switch c.kind {
        case .energy: period = 11
        case .body: period = 6
        case .mind, .summit: period = 15
        case .shadow, .armin, .bindu: period = 8
        }
        let phase = Double(c.road) * 0.37
        return 0.5 - 0.5 * cos(2 * .pi * t / period + phase)
    }

    private static func circle(_ c: CGPoint, _ r: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
    }

    private static func onGlass(_ p: CGPoint, _ size: CGSize, margin: CGFloat) -> Bool {
        p.x > -margin && p.x < size.width + margin && p.y > -margin && p.y < size.height + margin
    }

    // MARK: The point at both ends

    private static func drawCentre(_ add: GraphicsContext, c: Chakra33, colour: Color,
                                   camera: MandalaCamera, zoom: CGFloat, t: TimeInterval,
                                   reduceMotion: Bool, gain: Double) {
        let centre = camera.screen(for: .zero)
        let b = breath(c, t: t, reduceMotion: reduceMotion)
        // The origin sits just inside, the play just outside — the same point,
        // met at the start of the walk and again at its end.
        let r = (c.kind == .bindu ? 15 : 22) * zoom * CGFloat(1 + 0.06 * b)
        let a = min(1, (0.30 + 0.16 * b) * gain)
        add.stroke(circle(centre, r), with: .color(colour.opacity(a * 0.35)), lineWidth: 6 * zoom)
        add.stroke(circle(centre, r), with: .color(colour.opacity(a)), lineWidth: 0.9)
    }

    // MARK: A whole ring, presided over

    private static func drawPresiding(_ add: GraphicsContext, c: Chakra33, colour: Color,
                                      camera: MandalaCamera, zoom: CGFloat, t: TimeInterval,
                                      reduceMotion: Bool, gain: Double) {
        guard let ring = c.avarana else { return }
        let centre = camera.screen(for: .zero)
        // Just inside her ring, so it never sits on the enclosure's own band.
        let r = (MandalaWorld.ringRadius(ring) - 7) * camera.scale
        guard r > 6 else { return }
        let b = breath(c, t: t, reduceMotion: reduceMotion)
        let a = min(1, (0.10 + 0.10 * b) * gain)
        add.stroke(circle(centre, r), with: .color(colour.opacity(a)), lineWidth: 10 * zoom)
        var dash = StrokeStyle(lineWidth: 1, lineCap: .round, dash: [1, 7 * zoom])
        dash.dashPhase = reduceMotion ? 0 : CGFloat(t * 2)
        add.stroke(circle(centre, r), with: .color(colour.opacity(min(1, a * 3))), style: dash)
    }

    // MARK: A thread through the seats it holds

    private static func drawThread(_ add: GraphicsContext, c: Chakra33, colour: Color,
                                   points: [Int: CGPoint], camera: MandalaCamera, size: CGSize,
                                   zoom: CGFloat, t: TimeInterval, reduceMotion: Bool,
                                   gain: Double) {
        let world = ChakraConstellation.points(of: c, seats: points)
        guard !world.isEmpty else { return }
        let screen = world.map { camera.screen(for: $0) }
        guard screen.contains(where: { onGlass($0, size, margin: 60) }) else { return }
        let b = breath(c, t: t, reduceMotion: reduceMotion)
        let a = min(1, (0.22 + 0.18 * b) * gain)

        // An energy chakra shares its ring with its sisters (the three of the
        // Bhūpura, the two halves of the eight petals). Its thread runs a hair
        // inside the seats, offset by its place in the section, so two threads
        // on one ring never lie on top of each other.
        let inset = CGFloat(4 + (c.sectionNumber ?? 1) % 3 * 3) * zoom
        let centre = camera.screen(for: .zero)
        let pulled = screen.map { p -> CGPoint in
            let dx = p.x - centre.x, dy = p.y - centre.y
            let d = max(hypot(dx, dy), 1)
            return CGPoint(x: p.x - dx / d * inset, y: p.y - dy / d * inset)
        }
        var thread = Path()
        thread.move(to: pulled[0])
        for p in pulled.dropFirst() { thread.addLine(to: p) }
        add.stroke(thread, with: .color(colour.opacity(a * 0.45)),
                   style: StrokeStyle(lineWidth: 5 * zoom, lineCap: .round, lineJoin: .round))
        add.stroke(thread, with: .color(colour.opacity(a)),
                   style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
        for p in pulled {
            let r = 2.4 * zoom
            add.fill(circle(p, r * 3),
                     with: .radialGradient(Gradient(colors: [colour.opacity(a * 0.8), colour.opacity(0)]),
                                           center: p, startRadius: 0, endRadius: r * 3))
        }
    }

    // MARK: One seat

    private static func drawCorona(_ add: GraphicsContext, c: Chakra33, colour: Color,
                                   points: [Int: CGPoint], camera: MandalaCamera, size: CGSize,
                                   zoom: CGFloat, t: TimeInterval, reduceMotion: Bool,
                                   gain: Double) {
        guard let kp = c.kp.first,
              let world = ChakraConstellation.point(kp: kp, seats: points) else { return }
        let p = camera.screen(for: world)
        guard onGlass(p, size, margin: 40) else { return }
        let b = breath(c, t: t, reduceMotion: reduceMotion)
        let r = 10 * zoom * CGFloat(1 + 0.08 * b)
        let a = min(1, (0.30 + 0.20 * b) * gain)
        add.stroke(circle(p, r), with: .color(colour.opacity(a * 0.4)), lineWidth: 4 * zoom)
        add.stroke(circle(p, r), with: .color(colour.opacity(a)), lineWidth: 0.9)
        // The body moves: one mote travels the corona on the body's quicker
        // breath. The mind and the summit hold still.
        if c.kind == .body {
            let angle = reduceMotion ? -Double.pi / 2 : t * 0.9 + Double(c.road)
            let m = CGPoint(x: p.x + CGFloat(cos(angle)) * r, y: p.y + CGFloat(sin(angle)) * r)
            add.fill(circle(m, 2.2 * zoom),
                     with: .radialGradient(Gradient(colors: [Color.cream.opacity(a), colour.opacity(0)]),
                                           center: m, startRadius: 0, endRadius: 2.2 * zoom))
        }
    }

    // MARK: The two thresholds

    private static func drawThreshold(_ ctx: GraphicsContext, _ add: GraphicsContext, c: Chakra33,
                                      colour: Color, camera: MandalaCamera, size: CGSize,
                                      zoom: CGFloat, t: TimeInterval, reduceMotion: Bool,
                                      gain: Double) {
        guard let worldR = ChakraConstellation.thresholdRadius(c) else { return }
        let centre = camera.screen(for: .zero)
        let r = worldR * camera.scale
        guard r > 6 else { return }
        let b = breath(c, t: t, reduceMotion: reduceMotion)
        if c.kind == .shadow {
            // The corridor: the light thins here. A dark band (drawn, not
            // added, so it really takes light away), with a few stars standing
            // in it — Shadow's colour is "Dark / Starfield".
            let band = max(6, (MandalaWorld.ringRadius(3) - MandalaWorld.ringRadius(4)) * camera.scale * 0.42)
            ctx.stroke(circle(centre, r), with: .color(Color.black.opacity(min(0.55, 0.32 * gain))),
                       lineWidth: band)
            for i in 0..<14 {
                let ang = Double(i) / 14 * 2 * .pi + Double(i % 3) * 0.17
                let wob = CGFloat((i * 37) % 11 - 5) / 11 * band * 0.6
                let s = CGPoint(x: centre.x + CGFloat(cos(ang)) * (r + wob),
                                y: centre.y + CGFloat(sin(ang)) * (r + wob))
                let tw = reduceMotion ? 0.5 : 0.5 + 0.5 * sin(t * 0.7 + Double(i) * 1.3)
                add.fill(circle(s, 1.1 * zoom), with: .color(Color.cream.opacity(min(1, (0.18 + 0.3 * tw) * gain))))
            }
        } else {
            // Tripura Mālinī's gate: a garland of points round the crossing,
            // turning slowly — the light returning.
            let beads = 33
            let turn = reduceMotion ? 0 : t * 0.04
            for i in 0..<beads {
                let ang = Double(i) / Double(beads) * 2 * .pi + turn
                let s = CGPoint(x: centre.x + CGFloat(cos(ang)) * r, y: centre.y + CGFloat(sin(ang)) * r)
                let rr = 1.6 * zoom
                let a = min(1, (0.30 + 0.25 * b) * gain)
                add.fill(circle(s, rr * 3),
                         with: .radialGradient(Gradient(colors: [colour.opacity(a), colour.opacity(0)]),
                                               center: s, startRadius: 0, endRadius: rr * 3))
            }
            add.stroke(circle(centre, r), with: .color(colour.opacity(min(1, 0.10 * gain))), lineWidth: 6 * zoom)
        }
    }

    // MARK: Where a chakra stands on the glass (for the spoken layer)

    /// The screen point a voice is offered for each chakra: its seat, the middle
    /// of its thread, a point on its ring or its threshold, or the centre.
    static func anchor(_ c: Chakra33, points: [Int: CGPoint], camera: MandalaCamera) -> CGPoint? {
        switch c.address {
        case .centre:
            // The Bindu just above the point and Lalitā just below, so the two
            // are two places to a finger as well as to a voice.
            let centre = camera.screen(for: .zero)
            return CGPoint(x: centre.x, y: centre.y + (c.kind == .bindu ? -30 : 30))
        case .seat:
            guard let kp = c.kp.first, let w = ChakraConstellation.point(kp: kp, seats: points) else { return nil }
            return camera.screen(for: w)
        case .ring:
            if !c.kp.isEmpty {
                let w = ChakraConstellation.points(of: c, seats: points)
                guard !w.isEmpty else { return nil }
                return camera.screen(for: w[w.count / 2])
            }
            guard let ring = c.avarana else { return nil }
            // Lower left of the ring, clear of the enclosure's own name above it.
            let r = MandalaWorld.ringRadius(ring) - 7
            let a = CGFloat.pi * 0.75
            return camera.screen(for: CGPoint(x: r * cos(a), y: r * sin(a)))
        case .threshold:
            guard let r = ChakraConstellation.thresholdRadius(c) else { return nil }
            let a: CGFloat = c.kind == .shadow ? CGFloat.pi * 0.25 : CGFloat.pi * 0.6
            return camera.screen(for: CGPoint(x: r * cos(a), y: r * sin(a)))
        }
    }
}

// MARK: - The constellation, reachable

/// One spoken element per chakra on the glass — the same idiom as
/// `MandalaAccessibilityLayer`: it draws nothing and catches nothing, sits where
/// the light is, and is one container whose priorities keep the Road's order.
/// The whole container sorts after the garland (its own priority is below the
/// field's), so the 102 are still read first, ring by ring, exactly as before.
struct ChakraConstellationVoices: View {
    let chakras: [Chakra33]
    let seats: [MandalaWorld.Seat]
    let camera: MandalaCamera
    let size: CGSize

    var body: some View {
        let entries = Self.entries(chakras: chakras, seats: seats, camera: camera, size: size)
        ZStack(alignment: .topLeading) {
            ForEach(entries, id: \.road) { e in
                Color.clear
                    .frame(width: MandalaAccessibilityLayer.target, height: MandalaAccessibilityLayer.target)
                    .accessibilityElement()
                    .accessibilityLabel(e.label)
                    .accessibilitySortPriority(Double(-e.road))
                    .position(e.point)
            }
        }
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .accessibilityElement(children: .contain)
        .accessibilitySortPriority(-1_000)
        .allowsHitTesting(false)
    }

    struct Entry {
        let road: Int
        let label: String
        let point: CGPoint
    }

    static func entries(chakras: [Chakra33], seats: [MandalaWorld.Seat],
                        camera: MandalaCamera, size: CGSize) -> [Entry] {
        var points: [Int: CGPoint] = [:]
        var names: [Int: String] = [:]
        for s in seats {
            points[s.id] = s.point
            names[s.id] = s.shakti.name
        }
        var out: [Entry] = []
        for c in chakras {
            guard let p = ChakraConstellationDrawing.anchor(c, points: points, camera: camera),
                  p.x > -20, p.x < size.width + 20, p.y > -20, p.y < size.height + 20 else { continue }
            let seatName: String? = c.address == .seat ? c.kp.first.flatMap { names[$0] } : nil
            out.append(Entry(road: c.road,
                             label: ChakraConstellation.spokenLabel(c, seatName: seatName),
                             point: p))
        }
        return out
    }
}
