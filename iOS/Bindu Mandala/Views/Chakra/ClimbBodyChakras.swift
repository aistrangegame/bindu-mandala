import SwiftUI

// MARK: - Wave 6 · the ten body chakras on the Climb
//
// Charter II §2: *the Climb (the body). The ten body chakras are touchable
// places at their own heights.* They stand on the axis — the climb turns about
// it, and the spine is the axis — each at its height (`ClimbChakras.heights`,
// canon A: Soles at the first band, Crow at Sahasrāra's), and rise and fall
// past the eye with the walker's own hand: one band of the climb is one
// `pointsPerBand` of glass, exactly as the drag that carries him. Each is the
// Map's own colour, breathing on the body's quicker breath; a touch opens its
// chakra's room. Only the lights near where he stands are present, so the
// climb's own gesture is everywhere else on the glass.
struct ClimbBodyChakras: View {
    let source: WorldClimbSource
    let reduceMotion: Bool

    /// The room open from the climb (a Road position).
    @State private var openRoad: Int? = nil

    private let bodies: [Chakra33]
    private let heights: [Int: Double]

    init(source: WorldClimbSource, reduceMotion: Bool) {
        self.source = source
        self.reduceMotion = reduceMotion
        self.bodies = ClimbChakras.bodies()
        self.heights = ClimbChakras.heights()
    }

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation(minimumInterval: reduceMotion ? 0.25 : 1.0 / 30.0)) { tl in
                let here = source.value()
                let t = reduceMotion ? 0 : tl.date.timeIntervalSinceReferenceDate
                let eye = Double(geo.size.height) * 0.5
                ZStack(alignment: .topLeading) {
                    Canvas { ctx, _ in
                        var add = ctx
                        add.blendMode = .plusLighter
                        for c in bodies {
                            guard let h = heights[c.road],
                                  let y = ClimbChakras.screenY(height: h, here: here, eyeY: eye) else { continue }
                            let k = ClimbChakras.presence(height: h, here: here)
                            let tone = ChakraConstellationDrawing.tone(c)
                            let b = ChakraConstellationDrawing.breath(c, t: t, reduceMotion: reduceMotion)
                            let p = CGPoint(x: geo.size.width / 2, y: CGFloat(y))
                            add.glow(at: p, radius: 46 + 10 * CGFloat(b), color: tone, alpha: (0.30 + 0.18 * b) * k)
                            add.stroke(Path(ellipseIn: CGRect(x: p.x - 16, y: p.y - 16, width: 32, height: 32)),
                                       with: .color(Color.cream.opacity(0.55 * k)), lineWidth: 0.9)
                            add.core(at: p, radius: 3.2, color: Color.cream, alpha: 0.9 * k)
                        }
                    }
                    .allowsHitTesting(false)

                    ForEach(bodies) { c in
                        if let h = heights[c.road],
                           let y = ClimbChakras.screenY(height: h, here: here, eyeY: eye) {
                            let k = ClimbChakras.presence(height: h, here: here)
                            Button {
                                Haptics.medium()
                                openRoad = c.road
                            } label: {
                                VStack(spacing: 3) {
                                    Color.clear.frame(width: 64, height: 44)
                                    Text(c.name)
                                        .font(AppFont.label(11.5))
                                        .tracking(2)
                                        .textCase(.uppercase)
                                        .foregroundStyle(Color.cream.opacity(0.85))
                                    if let v = c.verb {
                                        Text(v)
                                            .font(AppFont.label(11))
                                            .tracking(2.4)
                                            .foregroundStyle(Color.cream.opacity(0.6))
                                    }
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .opacity(k)
                            .allowsHitTesting(k > 0.35)
                            .position(x: geo.size.width / 2, y: CGFloat(y) + 14)
                            .accessibilityLabel(ChakraConstellation.spokenLabel(c, seatName: nil))
                            .accessibilityHint("Opens its room.")
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
            }
        }
        .ignoresSafeArea()
        // U2 · C · a body chakra's room is in the 33 — crossed to, never
        // raised over the Climb.
        .crossesToChakraRoom($openRoad)
    }
}
