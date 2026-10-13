import SwiftUI

/// The Bindu opens. Not a card — an arrival. The field recedes, the red point
/// blooms to fill, and She — the ground from which all 102 emerge — settles into
/// presence, the whole field gathered as a faint returning halo around Her.
/// A chosen ending (reached by tapping the Bindu), never auto-advanced.
///
/// **Wave 1 · Lalitā's red bloom, restored.** Design's `LalitaSource`
/// (living-rite-mandala.jsx) opens in four movements, and the port kept only
/// the last two at the wrong pace:
///
///   1. **the red bloom** — a field of crimson light (`#8B1A2A` → 0.35 by 22% →
///      gone by 60%, 1400 across) blooming from a point to fill the glass in
///      1.6 s, flaring to full and settling at 0.55 (`syDescendBloom`). It was
///      gone entirely;
///   2. **her presence** — cream at the heart, gold by 34%, crimson by 62%,
///      gone by 78% (the port spread four stops evenly and lost the shape),
///      rising from 0.2 over 1.6 s and then breathing ×1.28 on a 6.5 s breath;
///   3. **the returning field** — the 102 at 0.82 of their seats, turning once
///      in 160 s, arriving over 2.4 s after 0.4 s;
///   4. **the words, emerging from the light** — after the bloom, not before
///      it: Design's stagger runs 1.5 s → 3.3 s.
///
/// Beyond Design, the light stands in the air: the bloom and the presence are
/// additive (`plusLighter`), and each of the 102 in the returning field carries
/// a breath of her own hue round its gold point — every energy you have met is
/// Her, turned for a moment toward you, and you can see whose light it was.
struct LalitaSourceView: View {
    let lalita: Shakti
    let seats: [MandalaWorld.Seat]
    var onEnter: () -> Void      // enter her presence → her full detail
    var onReturn: () -> Void     // ↑ return to the field
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @State private var appeared = false
    @State private var sounded = false
    /// Wave 4 · Play — Lalitā's field, opened from her own point.
    @State private var playing = false
    /// When she began to arrive — the clock the bloom and the presence read.
    @State private var arrivedAt: TimeInterval = Date().timeIntervalSinceReferenceDate
    /// Each seat's own hue, composed once on arrival, never per frame.
    @State private var hues: [Int: Color] = [:]

    private let gold = Color.gold
    private let cream = Color.cream
    private let red = Color.accentRed

    /// Design's `color-mix(in oklab, red 60%, gold 40%)` — the far end of the
    /// presence button's gradient.
    private static let redGold = Color(red: 164 / 255, green: 76 / 255, blue: 50 / 255)

    var body: some View {
        ZStack {
            ground
            bloom
            returningField
            presence
            words
        }
        .onAppear {
            arrivedAt = Date().timeIntervalSinceReferenceDate
            var h: [Int: Color] = [:]
            for seat in seats { h[seat.id] = Atmosphere.derive(from: seat.shakti).accentBright }
            hues = h
            withAnimation(.easeOut(duration: 1.4)) { appeared = true }
        }
    }

    // MARK: The ground — `radial-gradient(ellipse 90% 70% at 50% 42%, #2a0a12, #12060b 55%, #060205)`

    private var ground: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1), h = max(geo.size.height, 1)
            ZStack {
                Color(red: 6 / 255, green: 2 / 255, blue: 5 / 255)
                Rectangle()
                    .fill(EllipticalGradient(stops: [
                                                 .init(color: Color(red: 42 / 255, green: 10 / 255, blue: 18 / 255), location: 0),
                                                 .init(color: Color(red: 18 / 255, green: 6 / 255, blue: 11 / 255), location: 0.55),
                                                 .init(color: Color(red: 6 / 255, green: 2 / 255, blue: 5 / 255), location: 1),
                                             ],
                                             center: .center, startRadiusFraction: 0, endRadiusFraction: 0.5))
                    .frame(width: w * 1.8, height: h * 1.4)
                    .position(x: w * 0.5, y: h * 0.42)
            }
            .frame(width: w, height: h)
            .clipped()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    // MARK: 1 · The red bloom

    /// How far into the arrival she is, 0…1 over `span` seconds — finished at
    /// once under reduce motion, which is given the settled light, not a slow one.
    private func arrival(_ t: TimeInterval, span: TimeInterval, delay: TimeInterval = 0) -> Double {
        if reduceMotion { return 1 }
        return min(max((t - arrivedAt - delay) / span, 0), 1)
    }

    /// `cubic-bezier(0.2, 0.8, 0.3, 1)` — fast out of the point, long settle.
    private func settle(_ p: Double) -> Double { 1 - pow(1 - p, 3) }

    private var bloom: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let p = arrival(t, span: 1.6)
            // syDescendBloom: 0 → 1 by 34%, settling to 0.55; scale 0.05 → 1.
            let o = p < 0.34 ? p / 0.34 : 1 - 0.45 * (p - 0.34) / 0.66
            // Once settled, the bloom keeps the Bindu's own breath, faintly.
            let breath = (reduceMotion || p < 1) ? 0 : 0.04 * MandalaBreath.phase(ring: 9, at: t)
            GeometryReader { geo in
                Circle()
                    .fill(RadialGradient(stops: [
                                             .init(color: red, location: 0),
                                             .init(color: red.opacity(0.35), location: 0.22),
                                             .init(color: red.opacity(0), location: 0.60),
                                         ],
                                         center: .center, startRadius: 0, endRadius: 700))
                    .frame(width: 1400, height: 1400)
                    .scaleEffect(CGFloat((0.05 + 0.95 * settle(p)) * (1 + breath)))
                    .opacity(o)
                    .blendMode(.plusLighter)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.42)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: 3 · The 102 gathered around Her, slowly turning.

    private var returningField: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let angle = reduceMotion ? 0 : t / 160 * 360
            let arrive = settle(arrival(t, span: 2.4, delay: 0.4))
            Canvas { ctx, size in
                let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
                // Design draws the field at 0.82 of the seats on a 390-wide glass.
                let scale = 0.82 * min(max(size.width / 390, 0.8), 1.6)
                let rot = angle * .pi / 180
                var add = ctx
                add.blendMode = .plusLighter
                for seat in seats {
                    let x = seat.point.x * cos(rot) - seat.point.y * sin(rot)
                    let y = seat.point.x * sin(rot) + seat.point.y * cos(rot)
                    let pt = CGPoint(x: c.x + x * scale, y: c.y + y * scale)
                    let hue = hues[seat.id] ?? gold
                    let hr: CGFloat = 5
                    add.fill(Path(ellipseIn: CGRect(x: pt.x - hr, y: pt.y - hr, width: hr * 2, height: hr * 2)),
                             with: .radialGradient(Gradient(colors: [hue.opacity(0.30 * arrive), hue.opacity(0)]),
                                                   center: pt, startRadius: 0, endRadius: hr))
                    ctx.fill(Path(ellipseIn: CGRect(x: pt.x - 1.2, y: pt.y - 1.2, width: 2.4, height: 2.4)),
                             with: .color(gold.opacity(0.26 * arrive)))
                }
            }
            .allowsHitTesting(false)
        }
        .accessibilityHidden(true)
    }

    // MARK: 2 · Her presence — a luminous point that contains all points

    private var presence: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.42)
            TimelineView(.animation(paused: reduceMotion)) { tl in
                let t = tl.date.timeIntervalSinceReferenceDate
                let p = arrival(t, span: 1.6)
                // syPresenceIn (0.2 → 1, 0 → 1), then syBinduBreath at 6.5 s:
                // ×1.28 at the top, its light 0.75 → 1.
                let since = max(0, t - arrivedAt - 1.6)
                let ph = (reduceMotion || p < 1) ? 0 : 0.5 - 0.5 * cos(2 * .pi * since / 6.5)
                let size = (0.2 + 0.8 * settle(p)) * (1 + 0.28 * ph)
                let glow = p < 1 ? p : 0.75 + 0.25 * ph
                ZStack {
                    Circle()
                        .fill(RadialGradient(colors: [gold.opacity(0.30), red.opacity(0.18), red.opacity(0)],
                                             center: .center, startRadius: 0, endRadius: 170))
                        .frame(width: 340, height: 340)
                        .blendMode(.plusLighter)
                    Circle()
                        .fill(RadialGradient(stops: [
                                                 .init(color: cream, location: 0),
                                                 .init(color: gold, location: 0.34),
                                                 .init(color: red.opacity(0.5), location: 0.62),
                                                 .init(color: red.opacity(0), location: 0.78),
                                             ],
                                             center: .center, startRadius: 0, endRadius: 86))
                        .frame(width: 172, height: 172)
                        .blur(radius: 0.4)
                }
                .scaleEffect(CGFloat(size))
                .opacity(glow)
                .position(c)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// The Bindu's own column. Like the Rite's it is a still tableau and not a
    /// scroll view — and like the Rite's it has nowhere to grow, so above
    /// `.accessibility1` it is given somewhere. Nothing else changes: the same
    /// blocks in the same order with the same staged emergence. Below it, the
    /// `ScrollView` is never built and this is the fixed column the baselines
    /// were recorded against.
    @ViewBuilder
    private var words: some View {
        if dynamicTypeSize.isAccessibilitySize {
            GeometryReader { geo in
                ScrollView {
                    wordsColumn.frame(minHeight: geo.size.height)
                }
                .scrollIndicators(.hidden)
            }
        } else {
            wordsColumn
        }
    }

    // MARK: 4 · The words, emerging from the light (Design's 1.5 s → 3.3 s)

    private var wordsColumn: some View {
        VStack(spacing: 0) {
            Spacer()
            emerge(delay: 1.5) {
                Text("NINTH ĀVARAṆA · THE BINDU")
                    .font(AppFont.label(11.5)).tracking(3.2).foregroundStyle(gold)
            }
            emerge(delay: 1.7) {
                Text("the point that contains all points")
                    .font(AppFont.voice(15))
                    .foregroundStyle(Color.cream.opacity(0.62))
                    .padding(.top, 12)
            }
            emerge(delay: 1.95) {
                Text(shortName)
                    .font(AppFont.sanskrit(64))
                    .tracking(3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.cream)
                    .shadow(color: gold.opacity(0.8), radius: 30)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            if lalita.name != shortName {
                emerge(delay: 2.15) {
                    Text(lalita.name)
                        .font(AppFont.label(20)).tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.82))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                }
            }
            emerge(delay: 2.4) {
                Rectangle().fill(gold.opacity(0.7)).frame(width: 48, height: 0.5).padding(.vertical, 18)
            }
            if !lalita.quality.trimmingCharacters(in: .whitespaces).isEmpty {
                emerge(delay: 2.55) {
                    Text(lalita.quality)
                        .font(AppFont.sanskrit(20))
                        .foregroundStyle(gold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
            }
            emerge(delay: 2.8) {
                Text("There is nothing else here. The whole yantra breathes outward from this point — and every energy you have met is Her, turned for a moment toward you.")
                    .font(AppFont.voice(15))
                    .lineSpacing(5)
                    .foregroundStyle(Color.cream.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
                    .padding(.top, 16)
            }
            emerge(delay: 3.0) {
                Button {
                    Haptics.soft()
                    BijaSoundService.shared.playBija(lalita.bija, seed: lalita.khadgamalaPosition ?? lalita.position)
                    sounded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { sounded = false }
                } label: {
                    VStack(spacing: 5) {
                        Text("ॐ")
                            .font(AppFont.sanskrit(30))
                            .foregroundStyle(gold)
                            .shadow(color: sounded ? gold : .clear, radius: 22)
                        Text("SOUND THE SOURCE")
                            .font(AppFont.label(11.5)).tracking(2).foregroundStyle(Color.cream.opacity(0.55))
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            emerge(delay: 3.15) {
                Button {
                    Haptics.medium()
                    onEnter()
                } label: {
                    Text("enter her presence")
                        .font(AppFont.sanskrit(19)).tracking(1.6)
                        .foregroundStyle(Color.cream)
                        .frame(maxWidth: 360)
                        .frame(minHeight: 54)
                        .background(Capsule()
                            .fill(LinearGradient(colors: [red, Self.redGold],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: red.opacity(0.6), radius: 22, y: 6))
                }
                .buttonStyle(.plain)
                .padding(.top, 22)
                .padding(.horizontal, 24)
            }
            // Wave 4 · the arc's last movement — recognise, dwell, play. Every
            // game in the yantra, gathered at her point.
            emerge(delay: 3.22) {
                Button {
                    Haptics.soft()
                    // U2: A Strange Game is its own world — cross there (its entrance
                    // is the Eight Dissolutions), never a cover over Home.
                    _ = Router.shared.go(to: Address(.game))
                } label: {
                    Text("play in her field")
                        .font(AppFont.voice(17))
                        .tracking(1.2)
                        .foregroundStyle(Color.gold)
                        .frame(minWidth: 200, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
                .accessibilityLabel("Play in Lalitā's field")
            }
            emerge(delay: 3.3) {
                Button {
                    Haptics.light()
                    onReturn()
                } label: {
                    Text("↑ return to the field")
                        .font(AppFont.voice(15))
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .padding(.top, 14)
                        .padding(.bottom, 30)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var shortName: String {
        let s = lalita.shortName.trimmingCharacters(in: .whitespaces)
        return s.isEmpty ? lalita.name : s
    }

    private func emergeAnimation(delay: Double) -> Animation {
        if reduceMotion { return Animation.easeOut(duration: 0.4) }
        return Animation.timingCurve(0.2, 0.85, 0.3, 1, duration: 1.1).delay(delay)
    }

    /// `syEmerge`: up 16 pt into place over 1.1 s on
    /// `cubic-bezier(0.2, 0.85, 0.3, 1)`, after the bloom has opened. Under
    /// reduce motion the words simply arrive, in place, together.
    @ViewBuilder
    private func emerge<Content: View>(delay: Double, @ViewBuilder _ content: () -> Content) -> some View {
        content()
            .opacity(appeared ? 1 : 0)
            .offset(y: (appeared || reduceMotion) ? 0 : 16)
            .animation(emergeAnimation(delay: delay), value: appeared)
    }
}
