import SwiftUI

/// The whole living field drawn in one `Canvas`, re-lit each frame by a single
/// `TimelineView(.animation)` clock — no per-seat views. Everything is drawn in
/// screen space by mapping world points through the `camera`, so the 102 seats,
/// the nine enclosures, the full Śrī Yantra, today's ring and the focused
/// constellation all move together as one continuous space.
///
/// **Wave 1 · the light comes home.** The yantra is Design's whole yantra again
/// (``SriYantraGeometry``): the Bhūpura with its four T-gates, the four circles,
/// both lotus rings, the triangles at their true 0.585 proportion, the Bindu's
/// red glow. It shimmers on Design's 8 s (`syShimmer`), every ring keeps its own
/// breath (``MandalaBreath``), the Bindu swells ×1.28, and the hour re-lights
/// all of it (``TimeVariant/sky`` and the gains beside it). With the light on,
/// lines and seats stand in the air — each line carries an additive glow, felt
/// seats a warm halo, the gates a light in each doorway.
///
/// **Phase 5's switch still gates the *light*, not the yantra.** With
/// `MANDALA_LIGHT=off` the canvas draws the same full yantra at Design's weights
/// but builds no ``MandalaLightField`` and stands no additive glow in the air:
/// that path remains the control the reach tests compare the lit one against.
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
    /// The hour the yantra is read in — one of Design's five time states.
    /// Noon is Design's living Mandala exactly, so a caller that does not know
    /// the hour (the spike bench) draws the prototype unchanged.
    var variant: TimeVariant = .noon
    /// Wave 3 · the 33 at their addresses (`ChakraConstellationLayer.swift`).
    /// Empty — and so nothing drawn — unless the host has turned them on.
    var chakras: [Chakra33] = []
    /// The chakra the Road is standing at, lit a little brighter.
    var roadFocus: Int? = nil

    struct RingFlash: Equatable { let ring: Int; let bornAt: TimeInterval }

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, _ in
                let light = field(at: t)
                drawStarfield(ctx, t: t, light)
                drawMotes(ctx, t: t, light)
                drawEnclosures(ctx, light)
                drawTodayRing(ctx, t: t, light)
                drawFlash(ctx, t: t, light)
                drawYantra(ctx, t: t, light)
                drawBinduGlow(ctx, t: t, light)
                drawConstellation(ctx, t: t)
                ChakraConstellationDrawing.draw(ctx, chakras: chakras, seats: seats, camera: camera,
                                                size: size, t: t, reduceMotion: reduceMotion,
                                                focusRoad: roadFocus)
                drawSeats(ctx, t: t, light)
                drawEnclosureNames(ctx, light)
                drawTratak(ctx, t: t, light)
            }
        }
        .allowsHitTesting(false)
    }

    private func p(_ world: CGPoint) -> CGPoint { camera.screen(for: world) }
    private var scale: CGFloat { camera.scale }

    /// World → screen as one affine map, so a precomputed world path is placed
    /// with a single `applying` per frame rather than rebuilt point by point.
    private var worldToScreen: CGAffineTransform {
        let o = p(.zero)
        return CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: o.x, ty: o.y)
    }

    /// A Design stroke width, in world units, as drawn on the glass. Design's
    /// strokes sat inside its scaled layer and grew with the zoom, and that is
    /// kept; the floor (three-quarters of the authored width) keeps a line
    /// present at the widest view, and the ceiling keeps the deepest zoom a
    /// line rather than a bar.
    private func lineWidth(_ w: CGFloat) -> CGFloat {
        min(max(w * scale, w * 0.75), 4.0)
    }

    /// A copy of the context that adds light rather than covering it —
    /// `plusLighter`, so glows that overlap brighten as light does.
    private func additive(_ ctx: GraphicsContext) -> GraphicsContext {
        var add = ctx
        add.blendMode = .plusLighter
        return add
    }

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

    private func onGlass(_ s: CGPoint, margin: CGFloat) -> Bool {
        s.x > -margin && s.x < size.width + margin && s.y > -margin && s.y < size.height + margin
    }

    // MARK: Starfield — the space the yantra floats in, drifting with the camera.

    /// Design's `SY_STARS`: points scattered round the yantra, every fifth gold,
    /// four in ten twinkling between 0.15 and 0.7 on their own 5–11 s clocks.
    /// They sit inside the scaled world, so they grow a little as you fall in,
    /// and with the light on the brighter ones carry a soft additive halo.
    private func drawStarfield(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let add = additive(ctx)
        let zoom = min(max(scale, 0.6), 2.2)
        for star in MandalaStars.all {
            let s = p(star.p)
            guard onGlass(s, margin: 20) else { continue }
            let alpha: Double
            if star.twinkles {
                if reduceMotion {
                    alpha = 0.42
                } else {
                    let period = 5 + star.phase
                    let x = 0.5 - 0.5 * cos(2 * .pi * t / period + star.phase)
                    alpha = 0.15 + 0.55 * x
                }
            } else {
                alpha = min(0.7, star.opacity * 1.25)
            }
            let r = max(0.45, star.r * 0.6 * zoom)
            let col: Color = star.gold ? Color.gold : Color.cream
            ctx.fill(circle(s, r), with: .color(col.opacity(alpha)))
            if light != nil && r > 0.8 {
                let hr = r * 3.4
                add.fill(circle(s, hr),
                         with: .radialGradient(Gradient(colors: [col.opacity(alpha * 0.32), col.opacity(0)]),
                                               center: s, startRadius: 0, endRadius: hr))
            }
        }
    }

    // MARK: Motes — the air the hour carries.

    /// Design's `DustMotes`: a few gold motes rising slowly through the screen,
    /// as many as the hour carries (`TimeVariant.motes` — three at the new moon,
    /// twelve at night). They are air, not world: they rise through the glass
    /// whatever the camera is doing. Under reduce motion they stand still where
    /// they are.
    private func drawMotes(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let add = additive(ctx)
        let travel = size.height + 24
        for i in 0..<variant.motes {
            let seed = (i * 73 + 17) % 100
            let left = Double(8 + (seed * 7) % 84) / 100
            let drift = Double(-10 + (seed * 13) % 20)
            let dia = 1.4 + Double((seed * 3) % 22) / 10
            let duration = Double(16 + (seed * 5) % 14)
            let delay = Double(seed % 80) / 8
            let peak = 0.18 + Double((seed * 11) % 28) / 100
            var q = ((t - delay) / duration).truncatingRemainder(dividingBy: 1)
            if q < 0 { q += 1 }
            // moteRise: 0 → 1 by 8%, easing to 0.5 by 92%, gone at 100%.
            let envelope: Double
            if q < 0.08 { envelope = q / 0.08 }
            else if q < 0.92 { envelope = 1 - 0.5 * (q - 0.08) / 0.84 }
            else { envelope = 0.5 * (1 - (q - 0.92) / 0.08) }
            let a = peak * envelope
            guard a > 0.004 else { continue }
            let c = CGPoint(x: CGFloat(left) * size.width + CGFloat(drift * q),
                            y: size.height + 12 - CGFloat(q) * travel)
            let r = CGFloat(dia / 2)
            ctx.fill(circle(c, r), with: .color(Color.gold.opacity(a)))
            let hr = r * (light == nil ? 3 : 5)
            add.fill(circle(c, hr),
                     with: .radialGradient(Gradient(colors: [Color.gold.opacity(a * 0.5), Color.gold.opacity(0)]),
                                           center: c, startRadius: 0, endRadius: hr))
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
        let add = additive(ctx)
        for ring in 2...8 {
            let r = MandalaWorld.ringRadius(ring) * scale
            guard r > 4 else { continue }
            let l = light.light(ring: ring)
            let col = variant.temper(l.bandColor).color()
            let w = CGFloat(l.bandWidth) * min(max(scale, 0.6), 2.0)
            let core = l.veiledMark(0.30 * (0.45 + 0.55 * l.reach))
            add.stroke(circle(c, r), with: .color(col.opacity(core)), lineWidth: w)
            add.stroke(circle(c, r - w * 0.8), with: .color(col.opacity(core * 0.38)), lineWidth: w * 1.6)
            add.stroke(circle(c, r + w * 0.8), with: .color(col.opacity(core * 0.38)), lineWidth: w * 1.6)
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

    private func drawTodayRing(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        guard let seat = seats.first(where: { seatKp($0) == todayKp }) else { return }
        let ring = seat.shakti.ringNumber ?? 2
        let rr = MandalaWorld.ringRadius(ring)
        guard rr > 0 else { return }
        let c = p(.zero), r = rr * scale
        let pulse = reduceMotion ? 0.5 : 0.42 + 0.16 * sin(t * 1.1)
        var stroke = StrokeStyle(lineWidth: 2, dash: [2, 4])
        stroke.lineCap = .round
        ctx.stroke(circle(c, r), with: .color(dayAccent.opacity(pulse)), style: stroke)
        // Today's enclosure, softly lit (Design: "today's enclosure, softly
        // lit") — with the light on, the day's ring holds a breath of its own
        // colour in the air beside the dashes.
        if light != nil {
            additive(ctx).stroke(circle(c, r), with: .color(dayAccent.opacity(pulse * 0.16)), lineWidth: 9)
        }
    }

    /// Design's `syRingFlash`: up to 0.85 in the first 18% of a second and a
    /// half, then gone — a threshold crossed, lit once.
    private func drawFlash(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        guard let flash else { return }
        let rr = MandalaWorld.ringRadius(flash.ring)
        guard rr > 0 else { return }
        let age = t - flash.bornAt
        guard age >= 0, age < 1.5 else { return }
        let rise = 0.27
        let a = age < rise ? 0.85 * age / rise : 0.85 * (1 - (age - rise) / (1.5 - rise))
        let c = p(.zero), r = rr * scale
        ctx.stroke(circle(c, r), with: .color(Color.gold.opacity(a)), lineWidth: 2.5)
        if light != nil {
            additive(ctx).stroke(circle(c, r), with: .color(Color.gold.opacity(a * 0.3)), lineWidth: 12)
        }
    }

    // MARK: The Śrī Yantra — the whole of it, breathing.

    /// Design's `SriYantraGeometry`, every element at its true weight, each
    /// keeping its ring's breath under one 8 s shimmer and re-toned by the hour.
    ///
    /// With the light on each line is drawn three times — a wide faint glow, a
    /// nearer glow, and the line — the two glows additive, so the geometry is
    /// light standing in the air rather than ink on the ground, and lines that
    /// cross brighten where they cross. Each line is also lit by how much of
    /// the Bindu reaches it: the inner star a little brighter than the outer
    /// square, the yantra lit from its own centre.
    ///
    /// When the gaze has held (Tratak), the breath and the shimmer settle to
    /// their middle and stay — the field holds still, and keeps its light.
    private func drawYantra(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let m = worldToScreen
        let add = additive(ctx)
        let held = light?.tratak ?? 0
        let shimmer = MandalaBreath.shimmer(at: t, reduceMotion: reduceMotion) * (1 - held) + held
        for (index, layer) in SriYantraGeometry.layers.enumerated() {
            let phase = MandalaBreath.phase(ring: layer.ring, at: t,
                                            offset: Double(index % 5) * 0.06,
                                            reduceMotion: reduceMotion)
            let settled = phase * (1 - held) + 0.5 * held
            let breath = 1 + MandalaBreath.lift(ring: layer.ring) * settled
            let reach = light.map { _ in 0.82 + 0.36 * MandalaLight.reach(atRadius: layer.meanRadius) } ?? 1
            let alpha = min(1, layer.alpha * timeGain(layer) * shimmer * breath * reach)
            guard alpha > 0.003 else { continue }
            let lineTone = tone(layer.kind)
            let path = layer.path.applying(m)
            let w = lineWidth(layer.width)
            if light != nil {
                add.stroke(path, with: .color(lineTone.opacity(alpha * 0.10)),
                           style: StrokeStyle(lineWidth: w * 5, lineCap: .round, lineJoin: .round))
                add.stroke(path, with: .color(lineTone.opacity(alpha * 0.22)),
                           style: StrokeStyle(lineWidth: w * 2.2, lineCap: .round, lineJoin: .round))
            }
            ctx.stroke(path, with: .color(lineTone.opacity(alpha)),
                       style: StrokeStyle(lineWidth: w, lineCap: .round, lineJoin: .round))
        }
        if light != nil { drawGateLights(add, shimmer: shimmer) }
    }

    /// A soft light standing in each of the Bhūpura's four doorways — the
    /// gates are where the world is entered, so they hold a little of the
    /// day's light open. (Beyond Design: its gates were lines; here they are
    /// also thresholds you can see from across the field.)
    private func drawGateLights(_ add: GraphicsContext, shimmer: Double) {
        let tone = variant.bhupuraTone
        let a = min(1, 0.20 * variant.bhupuraGain * shimmer)
        let r = max(8, SriYantraGeometry.radius * SriYantraGeometry.gateHalfWidth * 0.9 * scale)
        for mouth in SriYantraGeometry.gateMouths {
            let s = p(mouth)
            guard onGlass(s, margin: r) else { continue }
            add.fill(circle(s, r),
                     with: .radialGradient(Gradient(colors: [tone.opacity(a), tone.opacity(0)]),
                                           center: s, startRadius: 0, endRadius: r))
        }
    }

    /// The hour's tone for each kind of line: the Bhūpura in its amber (silver
    /// at night), the lotuses and circles in gold, the triangles in the hour's
    /// own stroke colour.
    private func tone(_ kind: SriYantraGeometry.Kind) -> Color {
        switch kind {
        case .bhupura, .gate: return variant.bhupuraTone
        case .circle, .lotus16, .lotus8: return Color.gold
        case .triangle: return variant.triangleTone
        }
    }

    /// The hour's strength for one line, as a ratio against noon — one factor,
    /// never a second dimmer stacked on Design's weight.
    private func timeGain(_ layer: SriYantraGeometry.Layer) -> Double {
        switch layer.kind {
        case .bhupura, .gate: return variant.bhupuraGain
        case .lotus16: return variant.lotusGain
        case .lotus8: return variant.innerLotusGain
        case .triangle: return variant.geometryGain
        case .circle:
            if layer.ring <= 2 { return variant.lotusGain }
            if layer.ring == 3 { return variant.innerLotusGain }
            return variant.geometryGain
        }
    }

    // MARK: The Bindu — the red point, breathing at the centre of everything.

    /// Design's Bindu glow (`SY_R * 0.10`, red 0.6 → 0) on the ninth ring's
    /// 4 s breath: ×1.28 at the top, its light 0.75 → 1 (`syBinduBreath`).
    /// The hour sets its colour and its size — at the new moon it stands at
    /// 1.6× and glows brighter while everything else recedes. With the light
    /// on a wide additive halo stands round it: the source, visibly a source.
    private func drawBinduGlow(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let c = p(.zero)
        let gaze = light?.tratak ?? 0
        let swell = MandalaBreath.binduScale(at: t, reduceMotion: reduceMotion)
        let breath = 1 + (swell - 1) * (1 - gaze)
        let glowPhase = MandalaBreath.phase(ring: 9, at: t, reduceMotion: reduceMotion)
        let strength = (0.75 + 0.25 * glowPhase) * variant.binduGlow
        let r = max(SriYantraGeometry.binduGlowRadius * scale, 10)
            * CGFloat(variant.binduScale * breath)
        let red = variant.binduColor
        ctx.fill(circle(c, r),
                 with: .radialGradient(Gradient(colors: [red.opacity(min(1, 0.6 * strength)), red.opacity(0)]),
                                       center: c, startRadius: 0, endRadius: r))
        if light != nil {
            let halo = r * 2.6
            additive(ctx).fill(circle(c, halo),
                               with: .radialGradient(Gradient(colors: [Color.accentRed.opacity(min(1, 0.26 * strength)),
                                                                       Color.accentRed.opacity(0)]),
                                                     center: c, startRadius: 0, endRadius: halo))
        }
    }

    // MARK: Constellation — her family threads, revealed as she is focused.

    private func drawConstellation(_ ctx: GraphicsContext, t: TimeInterval) {
        guard let focusKp,
              let focus = seats.first(where: { seatKp($0) == focusKp }),
              constellation > 0 else { return }
        let from = p(focus.point)
        let add = additive(ctx)
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
            add.stroke(line, with: .color(focusAccentBright.opacity(0.14 * prog)), lineWidth: 5)
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
        let add = additive(ctx)
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
            // Today's seat pulses stronger (syPulse, →1.35× every 2.6 s);
            // everyone else breathes on her enclosure's own clock (syBreath,
            // ×1.22) — nine metabolisms, the Bhūpura holding still.
            let swell: Double
            if reduceMotion { swell = 0 }
            else if isToday && !isFocus { swell = 0.35 * (0.5 + 0.5 * sin(t * 2.4)) * quiet }
            else { swell = (MandalaBreath.seatScale(ring: ring, kp: kp, at: t) - 1) * quiet }
            let dotR = baseR * min(max(scale, 0.7), 2.4) * CGFloat(1 + swell)

            // Her colour. With the light on it is her own Atmosphere hue arriving
            // through her enclosure's gem — one source, ninety-nine facets and
            // the source itself — rather than a lamp of her own. Either way the
            // hour tempers it: at the new moon the field goes nearly grey.
            let ownHSL: HSL
            if let l { ownHSL = l.seatColor(own: a.hue, felt: wasFelt) }
            else if wasFelt { ownHSL = HSL(h: a.hue.h, s: min(a.hue.s + 10, 88), l: min(a.hue.l + 18, 78)) }
            else { ownHSL = a.hue }
            let own = variant.temper(ownHSL).color()
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
                    let softHSL: HSL = l.map { $0.seatColor(own: a.hue, felt: false) } ?? a.hue
                    let soft: Color = variant.temper(softHSL).color(alpha: 0.62)
                    let flareColor = lit ? color : soft
                    let fr = dotR * (0.7 + 2.3 * min(ph / 0.22, 1))
                    add.fill(circle(screen, fr),
                             with: .radialGradient(Gradient(colors: [flareColor.opacity(flareO * alpha), flareColor.opacity(0)]),
                                                   center: screen, startRadius: 0, endRadius: fr))
                }
            }

            // The felt state as warm light: a soft halo standing in the air
            // round a seat that has been felt, her hue leaning toward the
            // source. Asked of a set — whether, never how often — so every
            // felt seat wears the same light.
            if wasFelt && !dimmed {
                let warm = variant.temper(MandalaLight.feltWarmth(a.hue)).color()
                let hr = dotR * 4.2
                add.fill(circle(screen, hr),
                         with: .radialGradient(Gradient(colors: [warm.opacity(0.30 * alpha), warm.opacity(0)]),
                                               center: screen, startRadius: dotR * 0.5, endRadius: hr))
            }

            // soft glow — how far it spreads is the gem's scattering, and how
            // strongly it burns is how much of the source reached her.
            if lit {
                let spread = l.map { CGFloat($0.glowSpread) } ?? 3.2
                let strength = l.map { 0.6 + 0.4 * $0.reach } ?? 1
                let g = dotR * spread
                let glow = light == nil ? ctx : add
                glow.fill(circle(screen, g),
                          with: .radialGradient(Gradient(colors: [color.opacity(0.5 * alpha * strength), color.opacity(0)]),
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
                        let bijaHSL: HSL = l.map { $0.seatColor(own: a.hue, felt: true) }
                            ?? HSL(h: a.hue.h, s: min(a.hue.s + 10, 88), l: min(a.hue.l + 18, 78))
                        let bijaColor = variant.temper(bijaHSL).color()
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

    // MARK: Tratak — the white light behind the red point.

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
    private func drawTratak(_ ctx: GraphicsContext, t: TimeInterval, _ light: MandalaLightField?) {
        let gaze = light?.tratak ?? 0
        guard gaze > 0.001 else { return }
        let c = p(.zero)
        let r = max(SriYantraGeometry.binduGlowRadius * scale, 10) * CGFloat(variant.binduScale)

        // The white light behind the red point — drawn first, so it is behind it.
        let drift: CGPoint
        if reduceMotion {
            drift = CGPoint(x: c.x - r * 0.22, y: c.y - r * 0.16)
        } else {
            let a = t * 0.11
            drift = CGPoint(x: c.x + cos(a) * r * 0.26, y: c.y + sin(a * 0.73) * r * 0.20)
        }
        let wr = r * 1.5
        additive(ctx).fill(circle(drift, wr),
                           with: .radialGradient(Gradient(colors: [Color.cream.opacity(0.28 * gaze), Color.cream.opacity(0)]),
                                                 center: drift, startRadius: 0, endRadius: wr))

        // The point itself firms as the gaze holds — a red dot to rest on,
        // rather than a haze.
        let dot = max(3.0, r * 0.18)
        ctx.fill(circle(c, dot), with: .color(Color.accentRed.opacity(0.35 + 0.5 * gaze)))
    }

    private func seatKp(_ seat: MandalaWorld.Seat) -> Int {
        seat.shakti.khadgamalaPosition ?? seat.shakti.position
    }
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
