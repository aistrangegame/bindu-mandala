import SwiftUI
import SwiftData

/// The Sri Yantra rendered as a portrait of the practitioner's own attention.
/// Every Shakti recognized glows with an intensity proportional to how many
/// times she has been felt; those recognized in the last seven days glow
/// warmer. The mandala becomes a mirror — held, still, never tapped.
///
/// Reads `RecognitionLogStore` only. Offline-safe, never depends on Airtable.
struct PortraitMandalaView: View {
    @Environment(\.modelContext) private var context
    @Query private var allEntries: [RecognitionEntry]
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    private let diameter: CGFloat = 344

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header
                Spacer(minLength: 12)
                mandala
                Spacer(minLength: 16)
                summary
                Spacer(minLength: 36)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Background

    private var background: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 6/255, green: 3/255, blue: 6/255), location: 0),
                .init(color: Color(red: 2/255, green: 0/255, blue: 1/255), location: 1)
            ]),
            center: .center, startRadius: 0, endRadius: 380
        )
        .ignoresSafeArea()
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 8) {
            Text("THE PORTRAIT MANDALA")
                .font(.system(size: 10))
                .tracking(3.2)
                .foregroundStyle(Color.gold.opacity(0.70))
            Text("your face in the instrument")
                .font(.custom(AppFont.cormorantItalic, size: 17))
                .tracking(0.3)
                .foregroundStyle(Color.cream.opacity(0.62))
        }
        .padding(.top, 8)
    }

    // MARK: - Mandala

    private var mandala: some View {
        ZStack {
            PortraitGeometryLayer(diameter: diameter)
            PortraitPetalLayer(
                shaktis: ring2Shaktis,
                stats: ring2Stats,
                diameter: diameter
            )
            PortraitBindu(diameter: diameter)
        }
        .frame(width: diameter, height: diameter)
    }

    // MARK: - Summary

    private var summary: some View {
        let met = countMet()
        let total = allEntries.count
        return Text("\(met) met · \(total) times felt")
            .font(.custom(AppFont.cormorantItalic, size: 15))
            .tracking(0.4)
            .foregroundStyle(Color.cream.opacity(0.50))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
    }

    // MARK: - Data

    private var ring2Shaktis: [Shakti] {
        shaktis.filter { ($0.ringNumber ?? 2) == 2 }
            .sorted { $0.position < $1.position }
    }

    /// Per-Ring-2-position recognition stats, computed from the local log.
    /// Phase 2: entries are keyed by `khadgamalaPosition` (1–102) +
    /// `ringNumber`. Ring 2 occupies Khaḍgamālā 29–44; we filter to
    /// `ringNumber == 2` and map back to local 1–16 for the lotus petals.
    /// (Phase 5 will elevate the Portrait to render all 102.)
    private var ring2Stats: [Int: PortraitStats] {
        var grouped: [Int: [Date]] = [:]
        for entry in allEntries where entry.ringNumber == 2 {
            let localPos = entry.khadgamalaPosition - 28
            guard (1...16).contains(localPos) else { continue }
            grouped[localPos, default: []].append(entry.timestamp)
        }
        var stats: [Int: PortraitStats] = [:]
        let now = Date()
        for (pos, dates) in grouped {
            let count = dates.count
            let last = dates.max()
            let days: Int
            if let last {
                days = Calendar.current.dateComponents([.day], from: last, to: now).day ?? 999
            } else {
                days = 999
            }
            stats[pos] = PortraitStats(count: count, daysSinceLast: days)
        }
        return stats
    }

    /// Count of distinct Ring-2 Śaktis ever felt. Will broaden to the full
    /// 102 once Phase 5 elevates the Portrait.
    private func countMet() -> Int {
        var seen = Set<Int>()
        for entry in allEntries where entry.ringNumber == 2 {
            let localPos = entry.khadgamalaPosition - 28
            guard (1...16).contains(localPos) else { continue }
            seen.insert(localPos)
        }
        return seen.count
    }
}

// MARK: - Stats per petal

struct PortraitStats {
    let count: Int
    let daysSinceLast: Int

    /// Cumulative intensity from total recognition count — saturates at 80.
    var intensity: Double { min(1.0, Double(count) / 80.0) }

    /// Slight warmth boost for recognitions within the last seven days.
    var recentBoost: Double { daysSinceLast <= 7 ? 0.12 : 0.0 }

    var glowOpacity: Double { 0.10 + intensity * 0.45 + recentBoost }
    var glowBlur: Double { 4.0 + intensity * 4.0 }
    var petalOpacity: Double { 0.18 + intensity * 0.78 }
}

// MARK: - Background geometry (nested triangles + faint rings)

private struct PortraitGeometryLayer: View {
    let diameter: CGFloat

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
                ctx.stroke(path, with: .color(Color.gold.opacity(0.20)), lineWidth: 0.4)
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

// MARK: - Petal layer

private struct PortraitPetalLayer: View {
    let shaktis: [Shakti]
    let stats: [Int: PortraitStats]
    let diameter: CGFloat

    private var scale: CGFloat { diameter / 344 }
    private let oR: CGFloat = 134, iR: CGFloat = 112, hw: CGFloat = 22
    private var sOR: CGFloat { oR * scale }
    private var sIR: CGFloat { iR * scale }
    private var sHW: CGFloat { hw * scale }
    private var labelR: CGFloat { (oR + iR) / 2 * scale }

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
            let cluster = shakti.cluster.color
            let s = stats[shakti.position] ?? PortraitStats(count: 0, daysSinceLast: 999)

            ZStack {
                // Glow halo behind — blurred, soft, intensity-driven
                PortraitPetalShape(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(cluster.opacity(s.glowOpacity))
                    .blur(radius: CGFloat(s.glowBlur))

                // Main petal — opacity scales with intensity
                PortraitPetalShape(outerR: sOR, innerR: sIR, halfW: sHW)
                    .rotation(.degrees(angle))
                    .fill(cluster.opacity(s.petalOpacity))

                // Small italic count, only when she has been felt at least once
                if s.count > 0 {
                    countLabel(i: i, count: s.count, opacity: s.intensity)
                }
            }
        }
    }

    private func countLabel(i: Int, count: Int, opacity: Double) -> some View {
        let theta = (Double(i) * 22.5 - 90) * .pi / 180
        let cx = (344 / 2) * scale
        let textOpacity: Double = opacity > 0.4 ? 0.82 : 0.34
        return Text("\(count)")
            .font(.custom(AppFont.cormorantItalic, size: 10))
            .foregroundStyle(Color.cream.opacity(textOpacity))
            .position(
                x: cx + labelR * cos(theta),
                y: cx + labelR * sin(theta)
            )
            .allowsHitTesting(false)
    }
}

/// Petal shape mirroring SriYantraMandalaView's Ring 2 geometry. Kept local
/// to PortraitMandalaView to avoid coupling to the home Mandala's internals.
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
