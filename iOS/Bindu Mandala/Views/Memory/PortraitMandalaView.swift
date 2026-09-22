import SwiftUI
import SwiftData
import UIKit

/// The Portrait Mandala — the practitioner's years-long mirror of attention.
///
/// All 102 points begin nearly dark. Each brightens with the count of
/// felt-moments for that Śakti; warmer when felt recently, cooling as time
/// passes without her. The whole field fills slowly toward a fully-alight
/// yantra — *she is felt, not measured*, so the image itself is the only
/// measure.
///
/// Reads `RecognitionLogStore` only. Offline-safe, never depends on Airtable.
struct PortraitMandalaView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var allEntries: [RecognitionEntry]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    private let diameter: CGFloat = 344
    @State private var settleHighlight: Int? = nil  // khadgamalaPosition to glow
    @State private var settlePhase: CGFloat = 0
    @State private var exportedImage: Image? = nil  // stretch: long-press to hold

    private var variant: TimeVariant { LunarPhaseService.currentTimeVariant() }

    /// During a settle, the whole field rises from dark over the first ~45% of the
    /// phase while her point flies out of the bindu; 1 (fully lit) on a normal visit.
    private var fieldP: CGFloat { settleHighlight != nil ? min(1, settlePhase / 0.45) : 1 }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header.opacity(fieldP)
                Spacer(minLength: 24)
                mandala
                Spacer(minLength: 24)
                whisper.opacity(fieldP)
                Spacer(minLength: 36)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: settleIfRecent)
        .sheet(isPresented: Binding(
            get: { exportedImage != nil },
            set: { if !$0 { exportedImage = nil } }
        )) {
            if let img = exportedImage {
                ShareSheetView(image: img)
            }
        }
    }

    /// Long-press the Portrait to hold it — render to high resolution and
    /// offer it as something to keep or print. No app branding, no numbers.
    @MainActor
    private func holdToExport() {
        Haptics.medium()
        let exportSize: CGFloat = 1500
        let artwork = portraitArtwork(diameter: exportSize)
            .frame(width: exportSize, height: exportSize)
            .background(variant.bg)
            .environment(\.colorScheme, .dark)
        let renderer = ImageRenderer(content: artwork)
        renderer.scale = 1.0  // exportSize is already at full image resolution
        if let ui = renderer.uiImage {
            exportedImage = Image(uiImage: ui)
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            variant.bg.ignoresSafeArea()
            // Ambient warmth that breathes with the time of day. The 600×540 glow
            // is clamped onto a flexible Color.clear so its overdraw never inflates
            // layout — a raw fixed frame here grows RootView's top-trailing ZStack
            // past the screen and pushes the hamburger (the only exit) off-screen.
            let a = variant.ambient
            Color.clear.overlay {
                EllipticalGradient(
                    gradient: Gradient(stops: [
                        .init(color: a.inner, location: 0),
                        .init(color: .clear, location: 0.75)
                    ]),
                    center: .center,
                    startRadiusFraction: 0,
                    endRadiusFraction: 1
                )
                .frame(width: 600, height: 540)
            }
            .allowsHitTesting(false)
            DustMotesView(count: variant.motes)
                .allowsHitTesting(false)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("THE PORTRAIT MANDALA")
                .font(AppFont.label(11))
                .tracking(3.2)
                .foregroundStyle(Color.gold.opacity(0.70))
            Text("your face in the instrument")
                .font(AppFont.voice(17))
                .tracking(0.3)
                .foregroundStyle(Color.cream.opacity(0.62))
        }
        .padding(.top, 8)
    }

    // MARK: - Whisper (no numbers — only a felt invitation)

    private var whisper: some View {
        Text("she is felt, not measured")
            .font(AppFont.voice(13))
            .tracking(0.5)
            .foregroundStyle(Color.cream.opacity(0.55))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
    }

    // MARK: - Mandala

    private var mandala: some View {
        portraitArtwork(diameter: diameter)
            // Every layer inside the artwork sets `.allowsHitTesting(false)`, so
            // the ZStack has no hit-testable content of its own and the long
            // press below had nothing at all to land on — the export was
            // unreachable, not merely small. The shape is the artwork's own
            // square; it draws nothing and moves nothing.
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 0.9) { holdToExport() }
    }

    /// The mandala itself, free of any chrome — used both for the on-screen
    /// rendering and for the exported image. Diameter is parameterised so the
    /// exporter can render at high resolution.
    @ViewBuilder
    private func portraitArtwork(diameter: CGFloat) -> some View {
        ZStack {
            // The field rises from dark as her point flies out of the bindu.
            Group {
                PortraitGeometryLayer(diameter: diameter, variant: variant)
                PortraitFieldLayer(
                    points: points,
                    diameter: diameter,
                    variant: variant
                )
                PortraitPetalLayer(
                    shaktis: ring2Shaktis,
                    stats: ring2Stats,
                    diameter: diameter,
                    variant: variant
                )
            }
            .opacity(fieldP)

            // The bindu is always lit — her point departs from it.
            PortraitBindu(diameter: diameter)

            if let kp = settleHighlight, let pt = points.first(where: { $0.khadgamalaPosition == kp }) {
                PortraitSettleFlight(point: pt, diameter: diameter, phase: settlePhase)
            }
        }
        .frame(width: diameter, height: diameter)
    }

    // MARK: - Data

    private var ring2Shaktis: [Shakti] {
        shaktis.filter { ($0.ringNumber ?? 2) == 2 }
            .sorted { $0.position < $1.position }
    }

    /// Per-position stats for the Ring 2 lotus, keyed by local position 1–16.
    private var ring2Stats: [Int: PortraitStats] {
        var grouped: [Int: [Date]] = [:]
        for entry in allEntries where entry.ringNumber == 2 {
            let localPos = entry.khadgamalaPosition - 28
            guard (1...16).contains(localPos) else { continue }
            grouped[localPos, default: []].append(entry.timestamp)
        }
        return grouped.mapValues { dates in
            PortraitStats.from(dates: dates)
        }
    }

    /// One PortraitPoint per Śakti — the full 102 (or however many are seeded).
    private var points: [PortraitPoint] {
        let ringTotals = Dictionary(grouping: shaktis, by: { $0.ringNumber ?? 0 })
            .mapValues(\.count)
        var statsByKp: [Int: PortraitStats] = [:]
        var grouped: [Int: [Date]] = [:]
        for entry in allEntries {
            grouped[entry.khadgamalaPosition, default: []].append(entry.timestamp)
        }
        for (kp, dates) in grouped {
            statsByKp[kp] = PortraitStats.from(dates: dates)
        }
        return shaktis.compactMap { s in
            guard let ring = s.ringNumber, ring >= 1, ring <= 9,
                  let kp = s.khadgamalaPosition else { return nil }
            let stats = statsByKp[kp] ?? .empty
            return PortraitPoint(
                khadgamalaPosition: kp,
                ring: ring,
                position: s.position,
                ringSize: max(ringTotals[ring] ?? 0, 1),
                stats: stats,
                accent: SeatLighting.accent(for: s),
                accentBright: SeatLighting.accentBright(for: s)
            )
        }
    }

    // MARK: - Settle

    /// When the practitioner arrives here straight from a recognition (the
    /// Moment "settles into" the Portrait), the just-lit point glows with a
    /// brief halo. Threshold: a moment within the last 60 seconds.
    private func settleIfRecent() {
        let store = RecognitionLogStore(context: context)
        guard let latest = store.latest() else { return }
        guard Date().timeIntervalSince(latest.timestamp) < 60 else { return }
        settleHighlight = latest.khadgamalaPosition
        // Reduce-motion: acknowledge the moment without translation — the field is
        // simply already lit and her point rests at its seat.
        if reduceMotion {
            settlePhase = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { settleHighlight = nil }
            return
        }
        settlePhase = 0
        // Linear ramp — the cubic ease lives inside the flight's `arrive`, so the
        // fly-out (0–0.34) and halo bloom (0.34–1) stay correctly timed.
        withAnimation(.linear(duration: 3.4)) { settlePhase = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            settleHighlight = nil
        }
    }
}

// MARK: - Stats per Śakti

struct PortraitStats {
    let count: Int
    let daysSinceLast: Int

    static let empty = PortraitStats(count: 0, daysSinceLast: 999)

    /// Cumulative intensity from total recognition count — saturates at 12 felts.
    var intensity: Double { min(1.0, Double(count) / 12.0) }

    /// Warmth: 1 when felt within last 3 days, 0 when 60+ days have passed.
    var warmFactor: Double {
        if daysSinceLast >= 60 { return 0 }
        if daysSinceLast <= 3  { return 1 }
        return 1.0 - Double(daysSinceLast - 3) / 57.0
    }

    /// For Ring 2's lotus petals (back-compat with the existing layer).
    var glowOpacity: Double { 0.10 + intensity * 0.50 + warmFactor * 0.12 }
    var glowBlur: Double { 4.0 + intensity * 4.0 }
    var petalOpacity: Double { 0.18 + intensity * 0.78 }

    static func from(dates: [Date]) -> PortraitStats {
        guard let last = dates.max() else { return .empty }
        let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 999
        return PortraitStats(count: dates.count, daysSinceLast: days)
    }
}

// MARK: - One point in the field

struct PortraitPoint: Identifiable {
    let khadgamalaPosition: Int
    let ring: Int
    let position: Int
    let ringSize: Int
    let stats: PortraitStats
    /// Her own Atmosphere accent, and its bright form for the recency channel.
    let accent: Color
    let accentBright: Color
    var id: Int { khadgamalaPosition }

    /// Radius from centre on the 344-diameter base.
    var radiusBase: CGFloat {
        switch ring {
        case 1: return 158
        case 2: return 123
        case 3: return 95
        case 4: return 78
        case 5: return 65
        case 6: return 52
        case 7: return 40
        case 8: return 26
        case 9: return 0
        default: return 0
        }
    }

    /// Angle in radians from 12 o'clock, clockwise.
    var angleRadians: Double {
        guard ringSize > 0 else { return -.pi / 2 }
        return (Double(position - 1) * (2 * .pi / Double(ringSize))) - .pi / 2
    }
}

// MARK: - Background geometry

private struct PortraitGeometryLayer: View {
    let diameter: CGFloat
    let variant: TimeVariant

    private var scale: CGFloat { diameter / 344 }

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // Four faint nested triangles — atmospheric, no breath.
            let pairs: [(r: CGFloat, up: Bool)] = [
                (90 * scale, false),
                (70 * scale, true),
                (50 * scale, false),
                (32 * scale, true)
            ]
            for (r, up) in pairs {
                let path = trianglePath(at: CGPoint(x: cx, y: cy), R: r, up: up)
                ctx.stroke(path,
                           with: .color(variant.triStroke.opacity(0.22 * variant.triOpacity / 0.55)),
                           lineWidth: variant.triStrokeWidth)
            }

            // Nine concentric circle hints — the rings of the descent.
            // Very faint; the points themselves are the figure, the circles are scaffolding.
            let radii: [CGFloat] = [158, 123, 95, 78, 65, 52, 40, 26]
            for r in radii {
                let rect = CGRect(x: cx - r * scale, y: cy - r * scale,
                                  width: 2 * r * scale, height: 2 * r * scale)
                let path = Path(ellipseIn: rect)
                ctx.stroke(path,
                           with: .color(variant.triStroke.opacity(0.05)),
                           lineWidth: 0.4)
            }
        }
        .allowsHitTesting(false)
    }

    private func trianglePath(at c: CGPoint, R: CGFloat, up: Bool) -> Path {
        let h = R * sqrt(3) / 2
        let half = R / 2
        var p = Path()
        if up {
            p.move(to: CGPoint(x: c.x, y: c.y - R))
            p.addLine(to: CGPoint(x: c.x + h, y: c.y + half))
            p.addLine(to: CGPoint(x: c.x - h, y: c.y + half))
        } else {
            p.move(to: CGPoint(x: c.x, y: c.y + R))
            p.addLine(to: CGPoint(x: c.x + h, y: c.y - half))
            p.addLine(to: CGPoint(x: c.x - h, y: c.y - half))
        }
        p.closeSubpath()
        return p
    }
}

// MARK: - The 102-point field (every ring but the Ring 2 lotus)

private struct PortraitFieldLayer: View {
    let points: [PortraitPoint]
    let diameter: CGFloat
    let variant: TimeVariant

    private var scale: CGFloat { diameter / 344 }
    private var centre: CGFloat { diameter / 2 }

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            for pt in points where pt.ring != 2 && pt.ring != 9 {
                draw(pt, ctx: &ctx, cx: cx, cy: cy)
            }
        }
        .allowsHitTesting(false)
    }

    private func draw(_ pt: PortraitPoint, ctx: inout GraphicsContext, cx: CGFloat, cy: CGFloat) {
        let r = pt.radiusBase * scale
        let x = cx + r * CGFloat(cos(pt.angleRadians))
        let y = cy + r * CGFloat(sin(pt.angleRadians))
        let intensity = pt.stats.intensity
        let warmth = pt.stats.warmFactor

        // Dim baseline so unfelt points still hint at the field's totality.
        let baseOpacity = 0.10 + intensity * 0.65
        let modulated = baseOpacity * variant.petalBrightness

        // Her own accent, brightening toward her bright form when felt recently
        // (the explicit recency channel: accent ↔ accentBright).
        let color = blend(warm: pt.accentBright, cool: pt.accent, warmFactor: warmth)

        // Halo — wider when felt more / more recently
        let haloR: CGFloat = 4 + CGFloat(intensity) * 6 + CGFloat(warmth) * 2
        let halo = Path(ellipseIn: CGRect(x: x - haloR, y: y - haloR,
                                          width: haloR * 2, height: haloR * 2))
        let haloFill = GraphicsContext.Shading.color(color.opacity(0.22 * modulated))
        let haloShadow = GraphicsContext.Filter.shadow(color: color.opacity(0.30 * modulated),
                                                       radius: 4 + intensity * 4,
                                                       x: 0, y: 0, blendMode: .normal,
                                                       options: .shadowAbove)
        var haloCtx = ctx
        haloCtx.addFilter(haloShadow)
        haloCtx.fill(halo, with: haloFill)

        // Core dot
        let coreR: CGFloat = 1.6 + CGFloat(intensity) * 1.6
        let core = Path(ellipseIn: CGRect(x: x - coreR, y: y - coreR,
                                          width: coreR * 2, height: coreR * 2))
        ctx.fill(core, with: .color(color.opacity(modulated)))
    }

    private func blend(warm: Color, cool: Color, warmFactor: Double) -> Color {
        guard let w = warm.cgColor?.components, let c = cool.cgColor?.components,
              w.count >= 3, c.count >= 3 else { return warm }
        let f = max(0, min(1, warmFactor))
        let r = w[0] * f + c[0] * (1 - f)
        let g = w[1] * f + c[1] * (1 - f)
        let b = w[2] * f + c[2] * (1 - f)
        return Color(red: r, green: g, blue: b)
    }
}

// MARK: - Settle flight (her point flies out of the bindu, then blooms)

/// The recognition settles into the Portrait: her point flies out of the bindu
/// along a gold thread to its seat (phase 0–0.34), then a gold halo blooms there
/// (phase 0.34–1). Ported from the prototype's single-`settlePhase` choreography.
private struct PortraitSettleFlight: View {
    let point: PortraitPoint
    let diameter: CGFloat
    let phase: CGFloat

    private var scale: CGFloat { diameter / 344 }

    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = point.radiusBase * scale
            let sx = c.x + r * CGFloat(cos(point.angleRadians))
            let sy = c.y + r * CGFloat(sin(point.angleRadians))

            func ease(_ x: Double) -> Double { 1 - pow(1 - min(max(x, 0), 1), 3) }
            let arrive = ease(Double(phase) / 0.34)
            let hx = c.x + (sx - c.x) * arrive
            let hy = c.y + (sy - c.y) * arrive

            // Trailing gold thread from the bindu, fading as she arrives.
            if arrive < 1 {
                var thread = Path()
                thread.move(to: c)
                thread.addLine(to: CGPoint(x: hx, y: hy))
                ctx.stroke(thread, with: .color(Color.gold.opacity((1 - arrive) * 0.5)),
                           style: StrokeStyle(lineWidth: 1.1, lineCap: .round))
            }

            // The flying head — a gold point with a soft glow, while in flight.
            if phase < 0.34 {
                let gr: CGFloat = 9
                ctx.fill(Path(ellipseIn: CGRect(x: hx - gr, y: hy - gr, width: gr * 2, height: gr * 2)),
                         with: .radialGradient(Gradient(colors: [Color.gold.opacity(0.5), .clear]),
                                               center: CGPoint(x: hx, y: hy), startRadius: 0, endRadius: gr))
                let hr: CGFloat = 3
                ctx.fill(Path(ellipseIn: CGRect(x: hx - hr, y: hy - hr, width: hr * 2, height: hr * 2)),
                         with: .color(Color.gold))
            }

            // Halo bloom at the seat, once she has landed.
            let haloP = min(max((Double(phase) - 0.34) / 0.66, 0), 1)
            if haloP > 0 {
                let hr = 6 + 30 * CGFloat(haloP)
                ctx.stroke(Path(ellipseIn: CGRect(x: sx - hr, y: sy - hr, width: hr * 2, height: hr * 2)),
                           with: .color(Color.gold.opacity((1 - haloP) * 0.8)), lineWidth: 1)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Petal layer (Ring 2 — the lotus, kept)

private struct PortraitPetalLayer: View {
    let shaktis: [Shakti]
    let stats: [Int: PortraitStats]
    let diameter: CGFloat
    let variant: TimeVariant

    private var scale: CGFloat { diameter / 344 }
    private let oR: CGFloat = 134, iR: CGFloat = 112, hw: CGFloat = 22
    private var sOR: CGFloat { oR * scale }
    private var sIR: CGFloat { iR * scale }
    private var sHW: CGFloat { hw * scale }

    var body: some View {
        ZStack {
            ForEach(0..<16, id: \.self) { i in
                petal(at: i)
            }
        }
    }

    @ViewBuilder
    private func petal(at i: Int) -> some View {
        if let shakti = shaktis.first(where: { $0.position == i + 1 }) {
            let angle = Double(i) * 22.5
            let seat = SeatLighting.accent(for: shakti)
            let s = stats[shakti.position] ?? .empty
            let mod = variant.petalBrightness

            ZStack {
                // Glow halo behind — blurred, soft, intensity-driven
                PortraitPetalShape(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(seat.opacity(s.glowOpacity * mod))
                    .blur(radius: CGFloat(s.glowBlur))

                // Main petal — opacity scales with intensity
                PortraitPetalShape(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(seat.opacity(s.petalOpacity * mod))
            }
        }
    }
}

private struct PortraitPetalShape: Shape {
    let outerR: CGFloat
    let innerR: CGFloat
    let halfW: CGFloat

    func path(in rect: CGRect) -> Path {
        let cx = rect.midX, cy = rect.midY
        let c1y = -innerR * 1.85
        let c2y = -outerR * 0.85
        let c2x = halfW * 0.95
        var p = Path()
        p.move(to: CGPoint(x: cx, y: cy - innerR))
        p.addCurve(
            to: CGPoint(x: cx, y: cy - outerR),
            control1: CGPoint(x: cx + halfW, y: cy + c1y),
            control2: CGPoint(x: cx + c2x, y: cy + c2y)
        )
        p.addCurve(
            to: CGPoint(x: cx, y: cy - innerR),
            control1: CGPoint(x: cx - c2x, y: cy + c2y),
            control2: CGPoint(x: cx - halfW, y: cy + c1y)
        )
        p.closeSubpath()
        return p
    }
}

// MARK: - Share sheet (stretch — exportable Portrait)

private struct ShareSheetView: View {
    let image: Image
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280, maxHeight: 280)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.gold.opacity(0.18), radius: 18)
                .padding(.top, 24)

            Text("a portrait of your attention")
                .font(AppFont.voice(16))
                .tracking(0.4)
                .foregroundStyle(Color.cream.opacity(0.60))

            ShareLink(item: image, preview: SharePreview("Bindu Mandala Portrait", image: image)) {
                Text("hold this image".uppercased())
                    .font(AppFont.label(11))
                    .tracking(2.4)
                    .foregroundStyle(Color.cream)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Color.accentRed))
                    .padding(.bottom, 4)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button("close") { dismiss() }
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.55))
                .frame(minHeight: 44)
                .contentShape(Rectangle())
                .buttonStyle(.plain)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ground.ignoresSafeArea())
        .presentationDetents([.medium, .large])
        .preferredColorScheme(.dark)
    }
}

// MARK: - Bindu (held still — the Portrait does not breathe)

private struct PortraitBindu: View {
    let diameter: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.accentRed, location: 0),
                            .init(color: Color.accentRed.opacity(0.65), location: 0.52),
                            .init(color: .clear, location: 1)
                        ]),
                        center: .center, startRadius: 0, endRadius: 12
                    )
                )
                .frame(width: 24, height: 24)
            Circle()
                .fill(Color.cream)
                .frame(width: 8, height: 8)
                .shadow(color: Color.cream.opacity(0.55), radius: 9)
        }
        .allowsHitTesting(false)
    }
}
