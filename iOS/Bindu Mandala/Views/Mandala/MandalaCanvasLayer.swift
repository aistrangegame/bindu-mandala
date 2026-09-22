import SwiftUI

/// The whole living field drawn in one `Canvas`, re-lit each frame by a single
/// `TimelineView(.animation)` clock — no per-seat views. Everything is drawn in
/// screen space by mapping world points through the `camera`, so the 102 seats,
/// the nine enclosures, the interlocking triangles, today's ring and the focused
/// constellation all move together as one continuous space.
///
/// **Phase 5, behind `lightOn`.** With the flag off this draws exactly what it
/// has always drawn: flat per-seat Atmosphere colour, hairline gold enclosure
/// circles, a red Bindu. With it on, every mark is a refraction of one source —
/// see ``MandalaLight``. The two paths are separated at the top of each `draw*`
/// method rather than woven together, so the shipped drawing stays readable as
/// itself and can be compared against `main` line by line.
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
    /// Who has been felt. A set, not a tally — see ``felt``.
    let felt: Set<Int>
    let flash: RingFlash?
    let constellation: Double        // 0…1 reveal of the family threads (fallback / reduce-motion)
    /// When the family threads began drawing, for the per-thread stagger. Nil when unfocused.
    var constellationStart: TimeInterval? = nil
    let tier: Int
    let reduceMotion: Bool
    /// Phase 5's one switch, read by the host and passed through here.
    var lightOn: Bool = false
    /// When the glass was last touched — the veil's second input, present-tense
    /// and reset by every gesture.
    var lastMoveAt: TimeInterval = 0
    /// How long the glass has lain untouched, ticked once a second by the host.
    /// Tratak's clock, and deliberately *not* the frame clock: see ``field(at:)``.
    var stillSeconds: Double = 0

    struct RingFlash: Equatable { let ring: Int; let bornAt: TimeInterval }

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, _ in
                let light = field(at: t)
                drawStarfield(ctx, t: t)
                drawEnclosures(ctx, light)
                drawTodayRing(ctx, t: t)
                drawFlash(ctx, t: t)
                drawYantra(ctx, light)
                drawConstellation(ctx, t: t)
                drawSeats(ctx, t: t, light)
                drawEnclosureNames(ctx, light)
                drawBinduGlow(ctx, t: t, light)
            }
        }
        .allowsHitTesting(false)
    }

    private func p(_ world: CGPoint) -> CGPoint { camera.screen(for: world) }
    private var scale: CGFloat { camera.scale }

    /// The light over the field this frame, or `nil` when the phase flag is off.
    ///
    /// **Two clocks, each right for its job.** The veil settles over four
    /// seconds and wants the frame clock, which is smooth; under reduce motion
    /// the timeline is paused and the frame clock is frozen, so the veil is
    /// handed its settled value outright — a real still state, not an animation
    /// run at zero duration. Tratak is earned over tens of seconds and must be
    /// earned *identically* under reduce motion, so it reads `stillSeconds`,
    /// which the host ticks once a second whether the timeline runs or not. A
    /// walker who asked for less movement waits exactly as long as everyone
    /// else; what she is given at the end of the wait does not move.
    private func field(at t: TimeInterval) -> MandalaLightField? {
        guard lightOn else { return nil }
        let dt = reduceMotion ? MandalaLight.stillnessSpan : max(0, t - lastMoveAt)
        return MandalaLightField(
            viewportRadius: Double(camera.viewportRadius(in: size)),
            stillness: MandalaLight.stillness(untouchedFor: dt, reduceMotion: reduceMotion),
            tratak: MandalaLight.tratak(untouchedFor: stillSeconds,
                                        reduceMotion: reduceMotion))
    }

    private func circle(_ c: CGPoint, _ r: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
    }

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

    private func drawEnclosures(_ ctx: GraphicsContext, _ light: MandalaLightField?) {
        guard let light else {
            let c = p(.zero)
            for ring in 2...8 {
                let r = MandalaWorld.ringRadius(ring) * scale
                guard r > 4 else { continue }
                ctx.stroke(circle(c, r), with: .color(Color.gold.opacity(0.06)), lineWidth: 0.5)
            }
            return
        }
        drawEnclosureBands(ctx, light)
    }

    /// Idea 28 — *made of light, not lines*. Each enclosure is a band of its own
    /// gem-light rather than a hairline: a bright core with a soft flank either
    /// side, so falling in passes through light of changing colour rather than
    /// across a drawn circle.
    ///
    /// The band's **width** is the gem's `diffuse` and nothing else — the Crown's
    /// pearl (0.95) stands as a broad haze you cross rather than meet, the
    /// eighth's cat's eye (0.10) as a taut bright line. Its **brightness** falls
    /// with distance from the source, and its **colour** is the ring's own hue
    /// pulled toward the Bindu by however little its gem scatters. Its
    /// **presence** is what the veil has not taken (idea 30): from the fitted
    /// camera the deep enclosures are barely there, and they come up as the
    /// walker falls toward them and holds still.
    private func drawEnclosureBands(_ ctx: GraphicsContext, _ light: MandalaLightField) {
        let c = p(.zero)
        for ring in 2...8 {
            let r = MandalaWorld.ringRadius(ring) * scale
            guard r > 4 else { continue }
            let l = light.light(ring: ring)
            let col = l.bandColor.color()
            let w = CGFloat(l.bandWidth) * min(max(scale, 0.6), 2.0)
            let core = l.veiledMark(0.30 * (0.45 + 0.55 * l.reach))
            ctx.stroke(circle(c, r), with: .color(col.opacity(core)), lineWidth: w)
            ctx.stroke(circle(c, r - w * 0.8), with: .color(col.opacity(core * 0.38)), lineWidth: w * 1.6)
            ctx.stroke(circle(c, r + w * 0.8), with: .color(col.opacity(core * 0.38)), lineWidth: w * 1.6)
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

    private func drawEnclosureNames(_ ctx: GraphicsContext, _ light: MandalaLightField?) {
        guard tier >= 1 else { return }
        let c = p(.zero)
        for ring in 1...9 {
            guard ring < Self.ordinals.count, ring < Self.enclosureForms.count else { continue }
            let rr = MandalaWorld.ringRadius(ring) * scale
            let label = "\(Self.ordinals[ring]) · \(Self.enclosureForms[ring])"
            // Above the ring; the Bindu (ring 9) sits just below centre.
            let y = ring == 9 ? c.y + 18 : c.y - rr - 9
            guard y > -20, y < size.height + 20 else { continue }
            // A name is a legend, not a thing standing in the mist: the veil
            // reaches it far more shallowly than it reaches a mark, and never
            // past FIDELITY §4's legibility floor.
            let alpha = light.map { $0.light(ring: ring).veiledText(0.6) } ?? 0.6
            var text = ctx.resolve(
                Text(label.uppercased())
                    .font(.system(size: 11.5))
                    .tracking(1.6)
                    .foregroundStyle(Color.gold.opacity(alpha)))
            text.shading = .color(Color.gold.opacity(alpha))
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
        ctx.stroke(circle(c, r), with: .color(dayAccent.opacity(pulse)), style: stroke)
    }

    private func drawFlash(_ ctx: GraphicsContext, t: TimeInterval) {
        guard let flash else { return }
        let rr = MandalaWorld.ringRadius(flash.ring)
        guard rr > 0 else { return }
        let age = t - flash.bornAt
        guard age >= 0, age < 1.5 else { return }
        let fade = 1 - age / 1.5
        let c = p(.zero), r = rr * scale
        ctx.stroke(circle(c, r), with: .color(Color.gold.opacity(0.7 * fade)), lineWidth: 2.5)
    }

    // MARK: The Śrī Yantra — nested squares + nine interlocking triangles.

    /// With the light on, the yantra's own geometry is lit from the Bindu too:
    /// the Bhūpura's three squares take the first enclosure's light, and each
    /// triangle is drawn in the source's own colour at the strength that
    /// reaches its mean radius. The lines do not become a different shape; they
    /// stop being flat gold and start being *far from the centre* or *near it*.
    private func drawYantra(_ ctx: GraphicsContext, _ light: MandalaLightField?) {
        let squareColor: Color = light.map { $0.light(ring: 1).bandColor.color() } ?? Color.gold
        for (i, f) in [1.0, 0.94, 0.88].enumerated() {
            let h = MandalaWorld.radius * f
            var sq = Path()
            sq.move(to: p(CGPoint(x: -h, y: -h)))
            sq.addLine(to: p(CGPoint(x: h, y: -h)))
            sq.addLine(to: p(CGPoint(x: h, y: h)))
            sq.addLine(to: p(CGPoint(x: -h, y: h)))
            sq.closeSubpath()
            let base = 0.5 - Double(i) * 0.1
            let alpha = light.map { $0.light(ring: 1).veiledMark(base) } ?? base
            ctx.stroke(sq, with: .color(squareColor.opacity(alpha)), lineWidth: 1.1)
        }
        let sourceColor: Color = light == nil ? Color.gold : MandalaLight.source.color()
        for tri in MandalaYantra.triangles {
            var path = Path()
            path.move(to: p(tri.0))
            path.addLine(to: p(tri.1))
            path.addLine(to: p(tri.2))
            path.closeSubpath()
            var alpha = 0.34
            if light != nil {
                let mean = (hypot(tri.0.x, tri.0.y) + hypot(tri.1.x, tri.1.y)
                            + hypot(tri.2.x, tri.2.y)) / 3
                // 0.62 rather than 0.5 at the floor: the source's hue is a
                // brighter gold than the flat token these lines used to be
                // drawn in, and a straight reach multiplier would have dimmed
                // the whole yantra to buy the gradient. This keeps the inner
                // triangles where they were and lets the outer ones fall away.
                alpha = 0.34 * (0.62 + 0.5 * MandalaLight.reach(atRadius: mean))
            }
            ctx.stroke(path, with: .color(sourceColor.opacity(alpha)), lineWidth: 1)
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

    /// How large a seat's dot is drawn.
    ///
    /// **This used to be a seven-step ramp keyed to how many times she had been
    /// felt** — `felt ? 4 + min(n, 6) * 0.4 : 3`, saturating at six recognitions
    /// — which is a practice count drawn as geometry. One seat is a state; the
    /// whole field side by side is a readout, and a walker could count his own
    /// practice off the radii. `LawsTests` could not see it, because every
    /// never-measure check there reads strings and interpolations, and a radius
    /// is a number that never becomes text.
    ///
    /// It is gone, on **both** sides of the phase flag. The flag gates the
    /// light; it does not gate a law. Felt is one size and unfelt is another,
    /// and there is nothing in between to read.
    private static let feltRadius: CGFloat = 4.4
    private static let unfeltRadius: CGFloat = 3

    private func drawSeats(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let quiet = 1 - (light?.tratak ?? 0)      // Tratak: the field holds still.
        for seat in seats {
            let kp = seatKp(seat)
            let screen = p(seat.point)
            guard screen.x > -40, screen.x < size.width + 40,
                  screen.y > -60, screen.y < size.height + 80 else { continue }

            let isFocus = kp == focusKp
            let isToday = kp == todayKp
            let inFamily = familyKp.contains(kp)
            let wasFelt = felt.contains(kp)
            let a = atmos[kp] ?? Atmosphere.derive(from: seat.shakti)
            let ring = seat.shakti.ringNumber ?? 2
            let l = light?.light(ring: ring)

            let dimmed = focusKp != nil && !isFocus && !inFamily
            let baseR: CGFloat = isFocus ? 7 : isToday ? 6 : inFamily ? 5.5
                : wasFelt ? Self.feltRadius : Self.unfeltRadius
            // Today's seat pulses stronger (syPulse, →1.35×); everyone else sways (syBreath).
            let pulse: Double
            if reduceMotion { pulse = 0 }
            else if isToday && !isFocus { pulse = 0.35 * (0.5 + 0.5 * sin(t * 2.4)) * quiet }
            else { pulse = 0.12 * sin(t * (0.9 + Double(kp % 7) * 0.12) + Double(kp)) * quiet }
            let dotR = baseR * min(max(scale, 0.7), 2.4) * (1 + pulse)

            // Her colour. With the light on it is her own Atmosphere hue arriving
            // through her enclosure's gem — one source, ninety-nine facets and
            // the source itself — rather than a lamp of her own.
            let own: Color
            if let l { own = l.seatColor(own: a.hue, felt: wasFelt).color() }
            else { own = wasFelt ? a.accentBright : a.accent }
            let color: Color = (isToday || isFocus) ? .cream
                : inFamily ? focusAccentBright : own
            let lit = wasFelt || isToday || isFocus || inFamily
            var alpha = dimmed ? 0.28 : (lit ? 1 : 0.55)
            if let l { alpha = l.veiledMark(alpha) }

            // periodic flare — every seat blooms softly on its own long cycle (syFlare),
            // lit seats in their own light, the rest in her soft accent, so the whole
            // field feels alive rather than static.
            if !reduceMotion && quiet > 0.001 {
                let fDur = 8.0 + Double(kp % 13)
                let ph = (t + Double(kp) * 0.37).truncatingRemainder(dividingBy: fDur) / fDur
                let flareO: Double = (ph < 0.06 ? (ph / 0.06) * 0.55
                    : ph < 0.22 ? (1 - (ph - 0.06) / 0.16) * 0.55 : 0) * quiet
                if flareO > 0.001 {
                    let soft: Color = l.map { $0.seatColor(own: a.hue, felt: false).color(alpha: 0.62) }
                        ?? a.accentSoft
                    let flareColor = lit ? color : soft
                    let fr = dotR * (0.7 + 2.3 * min(ph / 0.22, 1))
                    ctx.fill(circle(screen, fr),
                             with: .radialGradient(Gradient(colors: [flareColor.opacity(flareO * alpha), .clear]),
                                                   center: screen, startRadius: 0, endRadius: fr))
                }
            }

            // soft glow — how far it spreads is the gem's scattering, and how
            // strongly it burns is how much of the source reached her.
            if lit {
                let spread = l.map { CGFloat($0.glowSpread) } ?? 3.2
                let strength = l.map { 0.6 + 0.4 * $0.reach } ?? 1
                let g = dotR * spread
                ctx.fill(circle(screen, g),
                         with: .radialGradient(Gradient(colors: [color.opacity(0.5 * alpha * strength), .clear]),
                                               center: screen, startRadius: 0, endRadius: g))
            }
            ctx.fill(circle(screen, dotR), with: .color(color.opacity(alpha)))

            // today / focus halo — an expanding, fading ring (syRing); static under reduce-motion.
            if isToday || isFocus {
                if reduceMotion || quiet < 0.001 {
                    let hr = dotR + 5
                    ctx.stroke(circle(screen, hr), with: .color(color.opacity(0.5)), lineWidth: 1)
                } else {
                    // A fixed-radius ring (like the prototype's 22px syRing) scaled by the
                    // camera, so it emanates from the rim and reaches the designed extent.
                    let q = (t / 2.6).truncatingRemainder(dividingBy: 1)
                    let hbase = 11 * min(max(scale, 0.7), 2.4)
                    let hr = hbase * (0.7 + 1.7 * q)
                    ctx.stroke(circle(screen, hr),
                               with: .color(color.opacity(0.6 * (1 - q) * quiet)), lineWidth: 1)
                }
            }

            // name label — resolves at tier 1+, or when threaded / focused
            let showName = tier >= 1 || inFamily || isFocus
            if showName && !dimmed {
                let name = (tier >= 2 || inFamily || isFocus) ? seat.shakti.name
                    : (seat.shakti.shortName.isEmpty ? seat.shakti.name : seat.shakti.shortName)
                let nameBase = lit ? 0.85 : 0.55
                let nameAlpha = l.map { $0.veiledText(nameBase) } ?? nameBase
                var text = ctx.resolve(
                    Text(name)
                        .font(.custom(AppFont.cormorant, size: 11.5))
                        .foregroundStyle(Color.cream.opacity(nameAlpha)))
                text.shading = .color(Color.cream.opacity(nameAlpha))
                ctx.draw(text, at: CGPoint(x: screen.x, y: screen.y + dotR + 9), anchor: .center)

                // bīja syllable at the deepest zoom — she names her seed (the 86
                // without a bīja show nothing).
                if tier >= 2 && !isFocus {
                    if let syllable = seat.shakti.bijaSyllable {
                        let bijaAlpha = l.map { $0.veiledText(0.85) } ?? 0.85
                        let bijaColor = l.map { $0.seatColor(own: a.hue, felt: true).color() } ?? a.accentBright
                        var bt = ctx.resolve(
                            Text("bīja \(syllable)")
                                .font(.custom(AppFont.cormorantItalic, size: 11.5))
                                .foregroundStyle(bijaColor.opacity(bijaAlpha)))
                        bt.shading = .color(bijaColor.opacity(bijaAlpha))
                        ctx.draw(bt, at: CGPoint(x: screen.x, y: screen.y + dotR + 24), anchor: .center)
                    }
                }
            }
        }
    }

    /// The Bindu — and, when the gaze has held, Tratak.
    ///
    /// Idea 38, the origin practice (C-1222): the Mandala holds still, the Bindu
    /// is a red dot for gazing, and after sustained stillness white light moves
    /// behind the red point. It is drawn **here, in the same canvas**, rather
    /// than as a mode with a screen of its own — the expansion says it is earned
    /// by stillness and *"never triggered by a tap"*, and a thing you cannot
    /// tap into does not need a door. It is also why the RootView oversized-child
    /// trap cannot be sprung by it: there is no new layer to be oversized.
    ///
    /// Under reduce motion the white light is **present and still** — sitting a
    /// little off the point, where its drift would have carried it — rather than
    /// absent or frozen mid-animation. The wait is the same length either way:
    /// Tratak is earned, and it is not handed over early.
    private func drawBinduGlow(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let c = p(.zero)
        let gaze = light?.tratak ?? 0
        let breath = (reduceMotion || gaze > 0.999) ? 1 : 1 + 0.06 * sin(t * 1.1) * (1 - gaze)
        let r = 30 * scale * 0.34 * breath + 4

        // The white light behind the red point — drawn first, so it is behind it.
        if gaze > 0.001 {
            let drift: CGPoint
            if reduceMotion {
                drift = CGPoint(x: c.x - r * 0.22, y: c.y - r * 0.16)
            } else {
                let a = t * 0.11
                drift = CGPoint(x: c.x + cos(a) * r * 0.26, y: c.y + sin(a * 0.73) * r * 0.20)
            }
            let wr = r * 1.5
            ctx.fill(circle(drift, wr),
                     with: .radialGradient(Gradient(colors: [Color.cream.opacity(0.28 * gaze), .clear]),
                                           center: drift, startRadius: 0, endRadius: wr))
        }

        ctx.fill(circle(c, r),
                 with: .radialGradient(Gradient(colors: [Color.accentRed.opacity(0.6), .clear]),
                                       center: c, startRadius: 0, endRadius: r))

        // The point itself firms as the gaze holds — a red dot to rest on,
        // rather than a haze.
        if gaze > 0.001 {
            let dot = max(3.0, r * 0.18)
            ctx.fill(circle(c, dot), with: .color(Color.accentRed.opacity(0.35 + 0.5 * gaze)))
        }
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
