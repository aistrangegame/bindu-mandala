import SwiftUI
import SwiftData

/// The somatic way in to Recognition (Wave 5 · The Body as Scripture).
///
/// "Where is she speaking?" He touches a place in his own body — drawn as
/// places of light along an axis, never as a figure, and never as hers — and the
/// Śaktis whose own rows name that place light around it. Touching one of them
/// opens her screen, where she may be felt.
struct WhereSheSpeaksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var shaktis: [Shakti]

    @State private var chosen: SomaticRegion?

    /// Region → the Śaktis whose `bodilyLocation` names it, in garland order.
    private var speakers: [SomaticRegion: [Shakti]] {
        var m: [SomaticRegion: [Shakti]] = [:]
        for s in shaktis where s.khadgamalaPosition != nil {
            for r in SomaticRegion.regions(forBodilyLocation: s.bodilyLocation) {
                m[r, default: []].append(s)
            }
        }
        return m
    }

    var body: some View {
        let map = speakers
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.04, green: 0.03, blue: 0.08), Color.ground],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                    GeometryReader { geo in
                        let size = geo.size
                        ZStack {
                            BodyOfLight(chosen: chosen,
                                        lit: chosen.flatMap { map[$0] } ?? [],
                                        reduceMotion: reduceMotion)
                            ForEach(SomaticRegion.allCases) { region in
                                ForEach(Array(region.anchors.enumerated()), id: \.offset) { item in
                                    Button {
                                        Haptics.light()
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            chosen = (chosen == region) ? nil : region
                                        }
                                    } label: {
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 46, height: 46)
                                            .contentShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                    .position(x: item.element.x * size.width,
                                              y: item.element.y * size.height)
                                    .accessibilityLabel(region.words)
                                    .accessibilityHint("Lights the Śaktis who speak here")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .frame(maxHeight: .infinity)

                    speakersList(map)
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 6) {
            HStack {
                Button(action: { dismiss() }) {
                    Text("‹ back")
                        .font(AppFont.voice(16))
                        .foregroundStyle(Color.gold)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 20)
            Text("Where is she speaking?")
                .font(AppFont.sanskrit(26))
                .foregroundStyle(Color.gold)
            Text("touch the place in you where she speaks")
                .font(AppFont.voice(15))
                .foregroundStyle(Color.cream.opacity(0.6))
        }
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func speakersList(_ map: [SomaticRegion: [Shakti]]) -> some View {
        if let region = chosen {
            VStack(alignment: .leading, spacing: 8) {
                Text(region.words.uppercased())
                    .font(AppFont.label(11))
                    .tracking(2.4)
                    .foregroundStyle(Color.gold.opacity(0.85))
                    .padding(.horizontal, 22)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(map[region] ?? []) { s in
                            NavigationLink {
                                ShaktiDetailView(shakti: s, backLabel: "where she speaks", source: .mandala)
                            } label: {
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(SeatLighting.accentBright(for: s))
                                        .frame(width: 8, height: 8)
                                        .shadow(color: SeatLighting.accentBright(for: s), radius: 5)
                                    Text(s.name)
                                        .font(AppFont.sanskrit(17))
                                        .foregroundStyle(Color.cream)
                                }
                                .padding(.horizontal, 14)
                                .frame(minHeight: 44)
                                .background(Capsule().fill(Color.white.opacity(0.06)))
                                .contentShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 22)
                }
            }
            .padding(.bottom, 18)
            .transition(.opacity)
        } else {
            Text("Each place holds the Śaktis whose own words name it.")
                .font(AppFont.voice(14))
                .foregroundStyle(Color.cream.opacity(0.55))
                .padding(.bottom, 30)
        }
    }
}

/// The body as places of light: an axis, the places along it, an aura for the
/// whole field. No outline, no figure — light where he can feel.
private struct BodyOfLight: View {
    let chosen: SomaticRegion?
    let lit: [Shakti]
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: reduceMotion)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let breath = 0.5 + 0.5 * sin(t * 2 * .pi / 8)
                ctx.blendMode = .plusLighter
                func at(_ p: CGPoint) -> CGPoint { CGPoint(x: p.x * size.width, y: p.y * size.height) }

                // The whole field — an aura round everything.
                let fieldOn = chosen == .field
                let aura = CGRect(x: size.width * 0.02, y: size.height * 0.01,
                                  width: size.width * 0.96, height: size.height * 0.98)
                ctx.stroke(Path(ellipseIn: aura),
                           with: .color(Color.gold.opacity(fieldOn ? 0.55 : 0.14 + 0.06 * breath)),
                           lineWidth: fieldOn ? 2 : 1)

                // The axis.
                var axis = Path()
                axis.move(to: at(CGPoint(x: 0.5, y: 0.05)))
                axis.addLine(to: at(CGPoint(x: 0.5, y: 0.86)))
                let spineOn = chosen == .spine
                ctx.stroke(axis, with: .color(Color.cream.opacity(spineOn ? 0.6 : 0.16)),
                           lineWidth: spineOn ? 2.4 : 1)

                for region in SomaticRegion.allCases where region != .field {
                    let on = region == chosen
                    let hue = Atmosphere.ringHue(ringFor(region)).color()
                    for a in region.anchors {
                        let p = at(a)
                        let r: CGFloat = on ? 30 : 16 + 3 * CGFloat(breath)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                                 with: .radialGradient(Gradient(colors: [hue.opacity(on ? 0.9 : 0.45), .clear]),
                                                       center: p, startRadius: 0, endRadius: r))
                        let core: CGFloat = on ? 5 : 3
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - core, y: p.y - core, width: core * 2, height: core * 2)),
                                 with: .color(Color.cream.opacity(on ? 0.95 : 0.6)))
                    }
                }

                // Her lights, round the place he touched.
                if let chosen = chosen, !lit.isEmpty {
                    let centre = chosen == .field ? CGPoint(x: 0.5, y: 0.5) : (chosen.anchors.first ?? CGPoint(x: 0.5, y: 0.5))
                    let c = at(centre)
                    let ringR: CGFloat = chosen == .field ? min(size.width, size.height) * 0.46 : 44
                    for (i, s) in lit.enumerated() {
                        let a = 2 * Double.pi * Double(i) / Double(max(1, lit.count)) + t * 0.08
                        let p = CGPoint(x: c.x + ringR * CGFloat(cos(a)), y: c.y + ringR * CGFloat(sin(a)))
                        let accent = SeatLighting.accentBright(for: s)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - 7, y: p.y - 7, width: 14, height: 14)),
                                 with: .radialGradient(Gradient(colors: [accent.opacity(0.85), .clear]),
                                                       center: p, startRadius: 0, endRadius: 7))
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - 2, y: p.y - 2, width: 4, height: 4)),
                                 with: .color(accent))
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    /// Each place takes the hue of the ring whose body-chakra it is nearest —
    /// light that warms as it descends.
    private func ringFor(_ region: SomaticRegion) -> Int {
        switch region {
        case .crown:  return 7
        case .brow:   return 6
        case .senses: return 6
        case .throat: return 5
        case .heart:  return 4
        case .hands:  return 4
        case .solar:  return 3
        case .belly:  return 2
        case .root:   return 1
        case .soles:  return 1
        case .spine:  return 8
        case .field:  return 9
        }
    }
}
