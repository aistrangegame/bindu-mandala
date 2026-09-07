import SwiftUI

/// The whole living field drawn in one `Canvas`, re-lit each frame by a single
/// `TimelineView(.animation)` clock — no per-seat views. Everything is drawn in
/// screen space by mapping world points through the `camera`, so the 102 seats,
/// the nine enclosures, the interlocking triangles, today's ring and the focused
/// constellation all move together as one continuous space.
struct MandalaCanvasLayer: View {
    let camera: MandalaCamera
    let size: CGSize
    let seats: [MandalaWorld.Seat]
    /// Per-kp Atmosphere, precomputed by the host (derive is not cheap per frame).
    let atmos: [Int: Atmosphere]
    let dayAccent: Color
    let todayKp: Int
    let focusKp: Int?
    let familyKp: Set<Int>
    let focusAccentBright: Color
    let countByKp: [Int: Int]
    let flash: RingFlash?
    let constellation: Double        // 0…1 reveal of the family threads (fallback / reduce-motion)
    /// When the family threads began drawing, for the per-thread stagger. Nil when unfocused.
    var constellationStart: TimeInterval? = nil
    let tier: Int
    let reduceMotion: Bool

    struct RingFlash: Equatable { let ring: Int; let bornAt: TimeInterval }

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, _ in
                drawStarfield(ctx, t: t)
                drawEnclosures(ctx)
                drawTodayRing(ctx, t: t)
                drawFlash(ctx, t: t)
                drawYantra(ctx)
                drawConstellation(ctx, t: t)
                drawSeats(ctx, t: t)
                drawEnclosureNames(ctx)
                drawBinduGlow(ctx, t: t)
            }
        }
        .allowsHitTesting(false)
    }

    private func p(_ world: CGPoint) -> CGPoint { camera.screen(for: world) }
    private var scale: CGFloat { camera.scale }

    // MARK: Starfield — a fixed, deterministic scatter that drifts with the camera.

    private func drawStarfield(_ ctx: GraphicsContext, t: TimeInterval) {
        for star in MandalaStars.all {
            let s = p(star.p)
            guard s.x > -20, s.x < size.width + 20, s.y > -20, s.y < size.height + 20 else { continue }
            let twinkle = star.twinkles && !reduceMotion
                ? 0.6 + 0.4 * sin(t * 0.8 + star.phase) : 1
            let r = star.r
            ctx.fill(Path(ellipseIn: CGRect(x: s.x - r, y: s.y - r, width: r * 2, height: r * 2)),
                     with: .color((star.gold ? Color.gold : Color.cream).opacity(star.opacity * twinkle)))
        }
    }

    // MARK: Enclosures — faint circles marking each āvaraṇa (drawn behind the lines).

    private func drawEnclosures(_ ctx: GraphicsContext) {
        let c = p(.zero)
        for ring in 2...8 {
            let r = MandalaWorld.ringRadius(ring) * scale
            guard r > 4 else { continue }
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                       with: .color(Color.gold.opacity(0.06)), lineWidth: 0.5)
        }
    }

    // MARK: Enclosure names — the āvaraṇa titles, revealed at the mid zoom (tier 1+).

    private static let ordinals = ["", "First", "Second", "Third", "Fourth", "Fifth",
                                   "Sixth", "Seventh", "Eighth", "Ninth"]
    /// The invariant Śrī-Yantra enclosure forms — exactly the prototype's `av.form`
    /// values (the July prototype; Airtable is canon for names), so the tier-1 labels read as designed.
    private static let enclosureForms = [
        "", "Bhūpura", "16-Petal Lotus", "8-Petal Lotus", "14 Triangles",
        "10 Outer Triangles", "10 Inner Triangles", "Vāk Ring", "Mūla Trikoṇa", "Bindu",
    ]

    private func drawEnclosureNames(_ ctx: GraphicsContext) {
        guard tier >= 1 else { return }
        let c = p(.zero)
        for ring in 1...9 {
            guard ring < Self.ordinals.count, ring < Self.enclosureForms.count else { continue }
            let rr = MandalaWorld.ringRadius(ring) * scale
            let label = "\(Self.ordinals[ring]) · \(Self.enclosureForms[ring])"
            // Above the ring; the Bindu (ring 9) sits just below centre.
            let y = ring == 9 ? c.y + 18 : c.y - rr - 9
            guard y > -20, y < size.height + 20 else { continue }
            var text = ctx.resolve(
                Text(label.uppercased())
                    .font(.system(size: 9))
                    .tracking(1.6)
                    .foregroundStyle(Color.gold.opacity(0.6)))
            text.shading = .color(Color.gold.opacity(0.6))
            ctx.draw(text, at: CGPoint(x: c.x, y: y), anchor: .center)
        }
    }

    private func drawTodayRing(_ ctx: GraphicsContext, t: TimeInterval) {
        guard let seat = seats.first(where: { seatKp($0) == todayKp }) else { return }
        let ring = seat.shakti.ringNumber ?? 2
        let rr = MandalaWorld.ringRadius(ring)
        guard rr > 0 else { return }
        let c = p(.zero), r = rr * scale
        let pulse = reduceMotion ? 0.5 : 0.42 + 0.16 * sin(t * 1.1)
        var stroke = StrokeStyle(lineWidth: 2, dash: [2, 4])
        stroke.lineCap = .round
        ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .color(dayAccent.opacity(pulse)), style: stroke)
    }

    private func drawFlash(_ ctx: GraphicsContext, t: TimeInterval) {
        guard let flash else { return }
        let rr = MandalaWorld.ringRadius(flash.ring)
        guard rr > 0 else { return }
        let age = t - flash.bornAt
        guard age >= 0, age < 1.5 else { return }
        let fade = 1 - age / 1.5
        let c = p(.zero), r = rr * scale
        ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                   with: .color(Color.gold.opacity(0.7 * fade)), lineWidth: 2.5)
    }

    // MARK: The Śrī Yantra — nested squares + nine interlocking triangles.

    private func drawYantra(_ ctx: GraphicsContext) {
        let gold = Color.gold
        // Bhūpura — three nested squares.
        for (i, f) in [1.0, 0.94, 0.88].enumerated() {
            let h = MandalaWorld.radius * f
            var sq = Path()
            sq.move(to: p(CGPoint(x: -h, y: -h)))
            sq.addLine(to: p(CGPoint(x: h, y: -h)))
            sq.addLine(to: p(CGPoint(x: h, y: h)))
            sq.addLine(to: p(CGPoint(x: -h, y: h)))
            sq.closeSubpath()
            ctx.stroke(sq, with: .color(gold.opacity(0.5 - Double(i) * 0.1)), lineWidth: 1.1)
        }
        // Nine triangles (5 Śakti down · 4 Śiva up).
        for tri in MandalaYantra.triangles {
            var path = Path()
            path.move(to: p(tri.0))
            path.addLine(to: p(tri.1))
            path.addLine(to: p(tri.2))
            path.closeSubpath()
            ctx.stroke(path, with: .color(gold.opacity(0.34)), lineWidth: 1)
        }
    }

    // MARK: Constellation — her family threads, revealed as she is focused.

    private func drawConstellation(_ ctx: GraphicsContext, t: TimeInterval) {
        guard let focusKp,
              let focus = seats.first(where: { seatKp($0) == focusKp }),
              constellation > 0 else { return }
        let from = p(focus.point)
        // Each thread draws in on its own slight delay (0.05 + i·0.035s over 0.7s),
        // so the family lights up as a cascade rather than all at once. When
        // reduce-motion is on (or no start time), fall back to the uniform reveal.
        let family = seats.filter { familyKp.contains(seatKp($0)) }
            .sorted { seatKp($0) < seatKp($1) }
        for (i, seat) in family.enumerated() {
            let prog: Double
            if reduceMotion || constellationStart == nil {
                prog = constellation
            } else {
                let raw = (t - constellationStart! - 0.05 - Double(i) * 0.035) / 0.7
                let p01 = min(max(raw, 0), 1)
                prog = 1 - pow(1 - p01, 3)
            }
            guard prog > 0 else { continue }
            let to = p(seat.point)
            let end = CGPoint(x: from.x + (to.x - from.x) * prog,
                              y: from.y + (to.y - from.y) * prog)
            var line = Path()
            line.move(to: from)
            line.addLine(to: end)
            ctx.stroke(line, with: .color(focusAccentBright.opacity(0.55 * prog)), lineWidth: 1)
        }
    }

    // MARK: The 102 seats.

    private func drawSeats(_ ctx: GraphicsContext, t: TimeInterval) {
        for seat in seats {
            let kp = seatKp(seat)
            let screen = p(seat.point)
            guard screen.x > -40, screen.x < size.width + 40,
                  screen.y > -60, screen.y < size.height + 80 else { continue }

            let isFocus = kp == focusKp
            let isToday = kp == todayKp
            let inFamily = familyKp.contains(kp)
            let n = countByKp[kp] ?? 0
            let felt = n > 0
            let a = atmos[kp] ?? Atmosphere.derive(from: seat.shakti)

            let dimmed = focusKp != nil && !isFocus && !inFamily
            let baseR: CGFloat = isFocus ? 7 : isToday ? 6 : inFamily ? 5.5 : felt ? 4 + min(CGFloat(n), 6) * 0.4 : 3
            // Today's seat pulses stronger (syPulse, →1.35×); everyone else sways (syBreath).
            let pulse: Double
            if reduceMotion { pulse = 0 }
            else if isToday && !isFocus { pulse = 0.35 * (0.5 + 0.5 * sin(t * 2.4)) }
            else { pulse = 0.12 * sin(t * (0.9 + Double(kp % 7) * 0.12) + Double(kp)) }
            let dotR = baseR * min(max(scale, 0.7), 2.4) * (1 + pulse)

            let color: Color = (isToday || isFocus) ? .cream
                : inFamily ? focusAccentBright
                : felt ? a.accentBright : a.accent
            let lit = felt || isToday || isFocus || inFamily
            let alpha = dimmed ? 0.28 : (lit ? 1 : 0.55)

            // periodic flare — every seat blooms softly on its own long cycle (syFlare),
            // lit seats in their own light, the rest in her soft accent, so the whole
            // field feels alive rather than static.
            if !reduceMotion {
                let fDur = 8.0 + Double(kp % 13)
                let ph = (t + Double(kp) * 0.37).truncatingRemainder(dividingBy: fDur) / fDur
                let flareO: Double = ph < 0.06 ? (ph / 0.06) * 0.55
                    : ph < 0.22 ? (1 - (ph - 0.06) / 0.16) * 0.55 : 0
                if flareO > 0.001 {
                    let flareColor = lit ? color : a.accentSoft
                    let fr = dotR * (0.7 + 2.3 * min(ph / 0.22, 1))
                    ctx.fill(Path(ellipseIn: CGRect(x: screen.x - fr, y: screen.y - fr, width: fr * 2, height: fr * 2)),
                             with: .radialGradient(Gradient(colors: [flareColor.opacity(flareO * alpha), .clear]),
                                                   center: screen, startRadius: 0, endRadius: fr))
                }
            }

            // soft glow
            if lit {
                let g = dotR * 3.2
                ctx.fill(Path(ellipseIn: CGRect(x: screen.x - g, y: screen.y - g, width: g * 2, height: g * 2)),
                         with: .radialGradient(Gradient(colors: [color.opacity(0.5 * alpha), .clear]),
                                               center: screen, startRadius: 0, endRadius: g))
            }
            ctx.fill(Path(ellipseIn: CGRect(x: screen.x - dotR, y: screen.y - dotR, width: dotR * 2, height: dotR * 2)),
                     with: .color(color.opacity(alpha)))

            // today / focus halo — an expanding, fading ring (syRing); static under reduce-motion.
            if isToday || isFocus {
                if reduceMotion {
                    let hr = dotR + 5
                    ctx.stroke(Path(ellipseIn: CGRect(x: screen.x - hr, y: screen.y - hr, width: hr * 2, height: hr * 2)),
                               with: .color(color.opacity(0.5)), lineWidth: 1)
                } else {
                    // A fixed-radius ring (like the prototype's 22px syRing) scaled by the
                    // camera, so it emanates from the rim and reaches the designed extent.
                    let q = (t / 2.6).truncatingRemainder(dividingBy: 1)
                    let hbase = 11 * min(max(scale, 0.7), 2.4)
                    let hr = hbase * (0.7 + 1.7 * q)
                    ctx.stroke(Path(ellipseIn: CGRect(x: screen.x - hr, y: screen.y - hr, width: hr * 2, height: hr * 2)),
                               with: .color(color.opacity(0.6 * (1 - q))), lineWidth: 1)
                }
            }

            // name label — resolves at tier 1+, or when threaded / focused
            let showName = tier >= 1 || inFamily || isFocus
            if showName && !dimmed {
                let name = (tier >= 2 || inFamily || isFocus) ? seat.shakti.name
                    : (seat.shakti.shortName.isEmpty ? seat.shakti.name : seat.shakti.shortName)
                var text = ctx.resolve(
                    Text(name)
                        .font(.custom(AppFont.cormorant, size: 10))
                        .foregroundStyle(Color.cream.opacity(lit ? 0.85 : 0.42)))
                text.shading = .color(Color.cream.opacity(lit ? 0.85 : 0.42))
                ctx.draw(text, at: CGPoint(x: screen.x, y: screen.y + dotR + 9), anchor: .center)

                // bīja syllable at the deepest zoom — she names her seed (the 86
                // without a bīja show nothing).
                if tier >= 2 && !isFocus {
                    if let syllable = seat.shakti.bijaSyllable {
                        var bt = ctx.resolve(
                            Text("bīja \(syllable)")
                                .font(.custom(AppFont.cormorantItalic, size: 8))
                                .foregroundStyle(a.accentBright.opacity(0.85)))
                        bt.shading = .color(a.accentBright.opacity(0.85))
                        ctx.draw(bt, at: CGPoint(x: screen.x, y: screen.y + dotR + 20), anchor: .center)
                    }
                }
            }
        }
    }

    private func drawBinduGlow(_ ctx: GraphicsContext, t: TimeInterval) {
        let c = p(.zero)
        let breath = reduceMotion ? 1 : 1 + 0.06 * sin(t * 1.1)
        let r = 30 * scale * 0.34 * breath + 4
        ctx.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                 with: .radialGradient(Gradient(colors: [Color.accentRed.opacity(0.6), .clear]),
                                       center: c, startRadius: 0, endRadius: r))
    }

    private func seatKp(_ seat: MandalaWorld.Seat) -> Int {
        seat.shakti.khadgamalaPosition ?? seat.shakti.position
    }
}

/// The interlocking triangles of the Śrī Yantra, as world-space vertex triples
/// (Bindu at origin). Ported from the prototype's `SY_DOWN` / `SY_UP`.
enum MandalaYantra {
    static let triangles: [(CGPoint, CGPoint, CGPoint)] = {
        let r = MandalaWorld.radius
        let down: [(CGFloat, CGFloat, CGFloat)] = [   // (topY, apexY, halfWidth) as fractions
            (-0.30, 1.00, 0.98), (-0.48, 0.80, 0.80), (-0.64, 0.58, 0.62),
            (-0.79, 0.36, 0.45), (-0.91, 0.16, 0.29),
        ]
        let up: [(CGFloat, CGFloat, CGFloat)] = [      // (botY, apexY, halfWidth)
            (0.33, -0.99, 0.92), (0.51, -0.77, 0.75), (0.67, -0.55, 0.57), (0.81, -0.31, 0.41),
        ]
        var out: [(CGPoint, CGPoint, CGPoint)] = []
        for t in down {
            out.append((CGPoint(x: -t.2 * r, y: t.0 * r),
                        CGPoint(x: t.2 * r, y: t.0 * r),
                        CGPoint(x: 0, y: t.1 * r)))
        }
        for t in up {
            out.append((CGPoint(x: -t.2 * r, y: t.0 * r),
                        CGPoint(x: t.2 * r, y: t.0 * r),
                        CGPoint(x: 0, y: t.1 * r)))
        }
        return out
    }()
}

/// A fixed starfield around the yantra — deterministic (seeded LCG), so it never
/// reshuffles between frames or launches.
enum MandalaStars {
    struct Star { let p: CGPoint; let r: CGFloat; let opacity: Double; let twinkles: Bool; let gold: Bool; let phase: Double }
    static let all: [Star] = {
        var seed: UInt64 = 20240517
        func rnd() -> Double {
            seed = seed &* 1664525 &+ 1013904223
            return Double(seed % 4_294_967_296) / 4_294_967_296
        }
        var stars: [Star] = []
        for i in 0..<120 {
            let a = rnd() * .pi * 2
            let rr = 120 + rnd() * 620
            stars.append(Star(p: CGPoint(x: cos(a) * rr, y: sin(a) * rr),
                              r: 0.5 + rnd() * 1.4,
                              opacity: 0.1 + rnd() * 0.4,
                              twinkles: rnd() > 0.6,
                              gold: i % 5 == 0,
                              phase: rnd() * 6))
        }
        return stars
    }()
}
