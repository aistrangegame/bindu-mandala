import SwiftUI

// MARK: - Upgrade U2 · A · Home's figure: where things stand, and how they are drawn
//
// `waves/upgrade/worlds/spine-and-home.md` §2 B #10–#14, #15, #17, #33. The
// geometry is pure (`HomeLayout`), so the station ring, the five, the beads and
// the point's place can be checked without a screen; the drawing is one
// Canvas (`HomeFigure`) under the views that take touches.

/// Where everything at Home stands — `spine-and-home.md` #10, #11, #15, #17.
enum HomeLayout {

    /// The point at (W/2, 0.46·H) (#10).
    static let pointHeight: CGFloat = 0.46
    /// The point's own touch: a little wider than its 26 pt light (#18).
    static let pointTarget: CGFloat = 64
    /// A spread that starts within 60 pt of the point is Spanda (§7 settled 8).
    static let spreadRegion: CGFloat = 120
    /// The structural five's ring (#17).
    static let fiveRadius: CGFloat = 58
    /// The Road Home's beads (#15): r 64, 210°–330° (beneath the point).
    static let beadRadius: CGFloat = 64
    static let beadArc: (from: Double, to: Double) = (210, 330)
    /// The ghost yantra: 340 pt, centred on the point (#12).
    static let yantraSide: CGFloat = 340

    static func point(in size: CGSize) -> CGPoint {
        CGPoint(x: size.width / 2, y: size.height * pointHeight)
    }

    /// #11: the station ring at r = 0.38·min(W, H) (≈148 pt at 390).
    static func stationRadius(in size: CGSize) -> CGFloat {
        0.38 * min(size.width, size.height)
    }

    /// A station's place: Today at 12 o'clock, then clockwise, 25.7° apart (#11).
    static func station(_ entry: WorldEntry, size: CGSize, centre c: CGPoint) -> CGPoint {
        let r = stationRadius(in: size)
        let a = entry.station.degrees * .pi / 180
        return CGPoint(x: c.x + r * CGFloat(sin(a)), y: c.y - r * CGFloat(cos(a)))
    }

    /// The five on the arc above the point (the beads keep the arc beneath),
    /// in the order Shadow, Axis, Armin, Maya, Aatma, left to right.
    static func five(_ f: HomeFive, centre c: CGPoint) -> CGPoint {
        let i = HomeFive.all.firstIndex(of: f) ?? 0
        let degrees = 162 - Double(i) * 36          // 162°, 126°, 90°, 54°, 18°
        let a = degrees * .pi / 180
        return CGPoint(x: c.x + fiveRadius * CGFloat(cos(a)), y: c.y - fiveRadius * CGFloat(sin(a)))
    }

    /// The i-th of n beads on the arc beneath the point (#15).
    static func bead(_ i: Int, of n: Int, centre c: CGPoint) -> CGPoint {
        let degrees: Double
        if n <= 1 {
            degrees = 270
        } else {
            degrees = beadArc.from + (beadArc.to - beadArc.from) * Double(i) / Double(n - 1)
        }
        let a = degrees * .pi / 180
        return CGPoint(x: c.x + beadRadius * CGFloat(cos(a)), y: c.y - beadRadius * CGFloat(sin(a)))
    }

    /// Where a line is spoken: above the station ring, below the top chrome.
    static func messageY(size: CGSize, centre c: CGPoint) -> CGFloat {
        max(120, c.y - stationRadius(in: size) - 62)
    }

    /// The travelling dot turns once in 64 s, 150 s at night (#11).
    static func isNight(_ date: Date, calendar: Calendar = .current) -> Bool {
        let h = calendar.component(.hour, from: date)
        return h >= 21 || h < 5
    }
}

/// Home's silence ground and its two weathers — `spine-and-home.md` #8, #10.
struct BinduHomeGround: View {
    let met: Bool
    let todayColour: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            let s = geo.size
            ZStack {
                // 0 · The silence ground #040104 → #0D0508 at r = 0.75·H.
                RadialGradient(colors: [Color.ground, Color.silenceGround],
                               center: UnitPoint(x: 0.5, y: HomeLayout.pointHeight),
                               startRadius: 0, endRadius: s.height * 0.75)
                if met {
                    // Met: warmth low and behind — radial(at 50% 106%, #C9A07A@.26, #8A5A3C@.11 38%).
                    RadialGradient(stops: [
                        .init(color: Color(hex: "#C9A07A").opacity(0.26), location: 0),
                        .init(color: Color(hex: "#8A5A3C").opacity(0.11), location: 0.38),
                        .init(color: .clear, location: 1),
                    ], center: UnitPoint(x: 0.5, y: 1.06), startRadius: 0, endRadius: s.height * 0.7)
                } else {
                    // Unmet: today's colour washes from above, breathing 10 s (.34 ↔ .80).
                    TimelineView(.animation(minimumInterval: 1.0 / 15.0, paused: reduceMotion)) { tl in
                        let ph = reduceMotion ? 0.5 : BreathClock.phase(at: tl.date, period: 10)
                        RadialGradient(stops: [
                            .init(color: todayColour.opacity(0.36), location: 0),
                            .init(color: todayColour.opacity(0.10), location: 0.42),
                            .init(color: .clear, location: 0.74),
                        ], center: UnitPoint(x: 0.5, y: -0.08), startRadius: 0, endRadius: s.width * 1.4 / 2 + s.height * 0.25)
                        .opacity(0.34 + (0.80 - 0.34) * ph)
                        .scaleEffect(1 + 0.045 * CGFloat(ph), anchor: .top)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// Home's drawn layers, in one Canvas — `spine-and-home.md` #11, #12, #14, #17, #33.
enum HomeFigure {

    // MARK: #12 · The ghost yantra — his record as light

    /// The true label-less yantra at 340 pt round the point. Every seat he has
    /// never felt is a ghost; the ones he has felt stand at their light
    /// (`HomeReading.seatLight`: whether, how recently, how long — never how
    /// many). The day's bloom brightens the whole, and at .7 it is the crown.
    /// Today's petal breathes 3.5 s with a gold ray (r 149 → 155) and a dot
    /// (r 2.5 at r 160) pointing to it without a word.
    static func ghostYantra(_ ctx: GraphicsContext, centre c: CGPoint, light: [Int: Double],
                            bloom: Double, todayKp: Int, t: Double) {
        let unit = HomeLayout.yantraSide / 2 / SriYantraGeometry.radius
        let place = CGAffineTransform(translationX: c.x, y: c.y).scaledBy(x: unit, y: unit)
        let whole = bloom >= HomeReading.crown ? 1 : HomeReading.ghost + (0.5 - HomeReading.ghost) * bloom / HomeReading.crown
        let gold = Color.gold

        for layer in SriYantraGeometry.layers where layer.kind != .lotus16 && layer.kind != .lotus8 {
            let a = min(1, layer.alpha * 1.6 * whole)
            ctx.stroke(layer.path.applying(place), with: .color(gold.opacity(a)),
                       lineWidth: max(0.5, layer.width * unit))
        }

        let r = SriYantraGeometry.radius
        let todayRing = KhadgamalaMap.ringNumber(forKhadgamala: todayKp)
        let todayIndex = KhadgamalaMap.perRingIndex(forKhadgamala: todayKp) - 1

        // Ring 2 — the sixteen petals, kp 29–44, petal 0 at 12 o'clock.
        for i in 0..<16 {
            let kp = KhadgamalaMap.ringStartOffset(2) + i + 1
            let path = SriYantraGeometry.petal(innerR: r * 0.80, outerR: r * 0.90,
                                               halfWidthDeg: 360.0 / 16.0 / 2.4,
                                               angleDeg: Double(i) * 360.0 / 16.0)
            var a = max(light[kp] ?? HomeReading.ghost, whole * 0.5)
            if todayRing == 2, i == todayIndex {
                let ph = BreathClock.phase(at: t, period: BreathEnclosure.petals16.period)
                a = min(1, max(a, 0.5) * (1 + 0.55 * ph))
            }
            petal(ctx, path.applying(place), alpha: a, colour: gold)
        }
        // Ring 3 — the eight petals, kp 45–52, turned half a petal.
        for i in 0..<8 {
            let kp = KhadgamalaMap.ringStartOffset(3) + i + 1
            let path = SriYantraGeometry.petal(innerR: r * 0.615, outerR: r * 0.70,
                                               halfWidthDeg: 360.0 / 8.0 / 2.5,
                                               angleDeg: Double(i) * 360.0 / 8.0 + 22.5)
            var a = max(light[kp] ?? HomeReading.ghost, whole * 0.5)
            if todayRing == 3, i == todayIndex {
                let ph = BreathClock.phase(at: t, period: BreathEnclosure.petals16.period)
                a = min(1, max(a, 0.5) * (1 + 0.55 * ph))
            }
            petal(ctx, path.applying(place), alpha: a, colour: gold)
        }

        // Today's ray, wherever her seat stands on the ring of petals.
        if todayRing == 2 || todayRing == 3 {
            let degrees = todayRing == 2 ? Double(todayIndex) * 22.5 : Double(todayIndex) * 45 + 22.5
            let a = degrees * .pi / 180
            func at(_ rr: CGFloat) -> CGPoint {
                CGPoint(x: c.x + rr * CGFloat(sin(a)), y: c.y - rr * CGFloat(cos(a)))
            }
            var ray = Path()
            ray.move(to: at(149))
            ray.addLine(to: at(155))
            ctx.stroke(ray, with: .color(HouseTokens.goldBright.color.opacity(0.8)), lineWidth: 1)
            let d = at(160)
            ctx.fill(Path(ellipseIn: CGRect(x: d.x - 2.5, y: d.y - 2.5, width: 5, height: 5)),
                     with: .color(HouseTokens.goldBright.color.opacity(0.85)))
        }
    }

    private static func petal(_ ctx: GraphicsContext, _ path: Path, alpha a: Double, colour: Color) {
        ctx.fill(path, with: .color(colour.opacity(a * 0.16)))
        ctx.stroke(path, with: .color(colour.opacity(min(1, a))), lineWidth: 0.8)
    }

    // MARK: #11 · #14 · The stations' marks

    /// Each station a small mark in its world's colour; Today in today's
    /// colour, breathing 3.5 s; the Nine Rings lit when today's ring is one of
    /// theirs (it always is); a chosen station crowned ×1.4 with its ring.
    static func stations(_ ctx: GraphicsContext, size: CGSize, centre c: CGPoint, todayHue: Color,
                         todaysRing: Int, chosen: WorldID?, t: Double) {
        var add = ctx
        add.blendMode = .plusLighter
        for entry in WorldRegistry.stations {
            let p = HomeLayout.station(entry, size: size, centre: c)
            var r: CGFloat = 4.5
            var colour = entry.color
            var alpha = 0.8
            if entry.id == .today {
                colour = todayHue
                alpha = 1
                r *= 1 + 0.2 * CGFloat(BreathClock.phase(at: t, period: BreathEnclosure.petals16.period))
            }
            if entry.id == .rings, todaysRing > 0 { alpha = 1 }
            if chosen == entry.id {
                r *= 1.4
                let ring = r * 2.6
                ctx.stroke(Path(ellipseIn: CGRect(x: p.x - ring, y: p.y - ring, width: ring * 2, height: ring * 2)),
                           with: .color(colour.opacity(0.5)), lineWidth: 0.8)
            }
            add.fill(Path(ellipseIn: CGRect(x: p.x - r * 3, y: p.y - r * 3, width: r * 6, height: r * 6)),
                     with: .radialGradient(Gradient(colors: [colour.opacity(0.28 * alpha), .clear]),
                                           center: p, startRadius: 0, endRadius: r * 3))
            ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                     with: .color(colour.opacity(alpha)))
        }
    }

    /// One small travelling dot steps round the stations, a full turn in
    /// 64 s (150 s at night) — station to station, resting between (#11).
    static func travellingDot(_ ctx: GraphicsContext, size: CGSize, centre c: CGPoint, t: Double, night: Bool) {
        let turn = night ? 150.0 : 64.0
        let n = Double(WorldEntry.Station.count)
        let steps = (t.truncatingRemainder(dividingBy: turn)) / turn * n
        let whole = steps.rounded(.down)
        let f = steps - whole
        let moving = min(1, f / 0.35)
        let eased = moving * moving * (3 - 2 * moving)
        let degrees = (whole + eased) * 360 / n
        let r = HomeLayout.stationRadius(in: size) - 16
        let a = degrees * .pi / 180
        let p = CGPoint(x: c.x + r * CGFloat(sin(a)), y: c.y - r * CGFloat(cos(a)))
        ctx.fill(Path(ellipseIn: CGRect(x: p.x - 1.6, y: p.y - 1.6, width: 3.2, height: 3.2)),
                 with: .color(Color.cream.opacity(0.55)))
    }

    // MARK: #17 · The five

    /// Five faint points, each in its room's colour at .35; the one he
    /// touched lit.
    static func five(_ ctx: GraphicsContext, centre c: CGPoint, chosen: Int?) {
        for f in HomeFive.all {
            let p = HomeLayout.five(f, centre: c)
            let colour = CanonColour.room(road: f.road)?.color ?? Color.gold
            let lit = chosen == f.road
            let r: CGFloat = lit ? 3.4 : 2.4
            ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                     with: .color(colour.opacity(lit ? 0.95 : 0.35)))
            if lit {
                var line = Path()
                line.move(to: c)
                line.addLine(to: p)
                ctx.stroke(line, with: .color(colour.opacity(0.4)), lineWidth: 0.6)
            }
        }
    }

    // MARK: #33 · The stillness gate

    /// A ring opens round the point, R0·(1.10 + 1.30·still).
    static func stillnessRing(_ ctx: GraphicsContext, centre c: CGPoint, still: Double) {
        guard still > 0.01 else { return }
        let r0: CGFloat = 13
        let r = r0 * CGFloat(1.10 + 1.30 * still)
        ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .color(Color.gold.opacity(0.18 + 0.4 * still)), lineWidth: 0.8)
    }
}
