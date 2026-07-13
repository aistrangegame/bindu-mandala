import SwiftUI

/// The Bindu opens. Not a card — an arrival. The field recedes, the red point
/// blooms to fill, and She — the ground from which all 102 emerge — settles into
/// presence, the whole field gathered as a faint returning halo around Her.
/// A chosen ending (reached by tapping the Bindu), never auto-advanced.
struct LalitaSourceView: View {
    let lalita: Shakti
    let seats: [MandalaWorld.Seat]
    var onEnter: () -> Void      // enter her presence → her full detail
    var onReturn: () -> Void     // ↑ return to the field
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var appeared = false
    @State private var sounded = false

    private let gold = Color.gold
    private let cream = Color.cream
    private let red = Color.accentRed

    var body: some View {
        ZStack {
            RadialGradient(colors: [Color(red: 0.16, green: 0.04, blue: 0.07),
                                    Color(red: 0.02, green: 0.01, blue: 0.02)],
                           center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 520)
                .ignoresSafeArea()

            returningField
            presence
            words
        }
        .onAppear { withAnimation(.easeOut(duration: 1.4)) { appeared = true } }
    }

    // The 102 gathered around Her, slowly turning.
    private var returningField: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let angle = reduceMotion ? 0 : tl.date.timeIntervalSinceReferenceDate / 160 * 360
            Canvas { ctx, size in
                let c = CGPoint(x: size.width / 2, y: size.height * 0.42)
                let scale = min(size.width, size.height) / 900
                for seat in seats {
                    let rot = angle * .pi / 180
                    let x = seat.point.x * cos(rot) - seat.point.y * sin(rot)
                    let y = seat.point.x * sin(rot) + seat.point.y * cos(rot)
                    let pt = CGPoint(x: c.x + x * scale, y: c.y + y * scale)
                    ctx.fill(Path(ellipseIn: CGRect(x: pt.x - 1.2, y: pt.y - 1.2, width: 2.4, height: 2.4)),
                             with: .color(gold.opacity(0.22)))
                }
            }
            .allowsHitTesting(false)
        }
        .opacity(appeared ? 1 : 0)
    }

    private var presence: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.42)
            TimelineView(.animation(paused: reduceMotion)) { tl in
                let breath = reduceMotion ? 1 : 1 + 0.05 * sin(tl.date.timeIntervalSinceReferenceDate * 0.96)
                Circle()
                    .fill(RadialGradient(colors: [cream, gold, red.opacity(0.5), .clear],
                                         center: .center, startRadius: 0, endRadius: 86))
                    .frame(width: 172, height: 172)
                    .scaleEffect((appeared ? 1 : 0.2) * breath)
                    .position(c)
                    .blur(radius: 0.4)
            }
        }
        .allowsHitTesting(false)
    }

    private var words: some View {
        VStack(spacing: 0) {
            Spacer()
            emerge(delay: 0.15) {
                Text("NINTH ĀVARAṆA · THE BINDU")
                    .font(.system(size: 10.5)).tracking(3.2).foregroundStyle(gold)
            }
            emerge(delay: 0.3) {
                Text("the point that contains all points")
                    .font(.custom(AppFont.cormorantItalic, size: 15))
                    .foregroundStyle(Color.cream.opacity(0.62))
                    .padding(.top, 12)
            }
            emerge(delay: 0.45) {
                Text(shortName)
                    .font(.custom(AppFont.cormorant, size: 60))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.cream)
                    .shadow(color: gold.opacity(0.6), radius: 40)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            if lalita.name != shortName {
                emerge(delay: 0.6) {
                    Text(lalita.name)
                        .font(.system(size: 20)).tracking(2)
                        .foregroundStyle(Color.cream.opacity(0.82))
                        .padding(.top, 10)
                }
            }
            emerge(delay: 0.75) {
                Rectangle().fill(gold.opacity(0.6)).frame(width: 48, height: 0.5).padding(.vertical, 18)
            }
            if !lalita.quality.trimmingCharacters(in: .whitespaces).isEmpty {
                emerge(delay: 0.85) {
                    Text(lalita.quality)
                        .font(.custom(AppFont.cormorant, size: 20))
                        .foregroundStyle(gold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
            }
            emerge(delay: 1.0) {
                Text("There is nothing else here. The whole yantra breathes outward from this point — and every energy you have met is Her, turned for a moment toward you.")
                    .font(.custom(AppFont.cormorantItalic, size: 15))
                    .lineSpacing(5)
                    .foregroundStyle(Color.cream.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
                    .padding(.top, 16)
            }
            emerge(delay: 1.2) {
                Button {
                    Haptics.soft()
                    BijaSoundService.shared.playBija(lalita.bija, seed: lalita.khadgamalaPosition ?? lalita.position)
                    sounded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { sounded = false }
                } label: {
                    VStack(spacing: 5) {
                        Text("ॐ")
                            .font(.custom(AppFont.cormorant, size: 30))
                            .foregroundStyle(gold)
                            .shadow(color: sounded ? gold : .clear, radius: 22)
                        Text("SOUND THE SOURCE")
                            .font(.system(size: 10)).tracking(2).foregroundStyle(Color.cream.opacity(0.5))
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
            }
            emerge(delay: 1.35) {
                Button {
                    Haptics.medium()
                    onEnter()
                } label: {
                    Text("enter her presence")
                        .font(.custom(AppFont.cormorant, size: 19)).tracking(1.6)
                        .foregroundStyle(Color.cream)
                        .frame(maxWidth: 360)
                        .frame(height: 54)
                        .background(Capsule().fill(red).shadow(color: red.opacity(0.5), radius: 28, y: 3))
                }
                .buttonStyle(.plain)
                .padding(.top, 22)
                .padding(.horizontal, 24)
            }
            emerge(delay: 1.5) {
                Button {
                    Haptics.light()
                    onReturn()
                } label: {
                    Text("↑ return to the field")
                        .font(.custom(AppFont.cormorantItalic, size: 15))
                        .foregroundStyle(Color.cream.opacity(0.55))
                }
                .buttonStyle(.plain)
                .padding(.top, 14)
                .padding(.bottom, 30)
            }
        }
    }

    private var shortName: String {
        let s = lalita.shortName.trimmingCharacters(in: .whitespaces)
        return s.isEmpty ? lalita.name : s
    }

    @ViewBuilder
    private func emerge<Content: View>(delay: Double, @ViewBuilder _ content: () -> Content) -> some View {
        content()
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.easeOut(duration: 1.1).delay(delay), value: appeared)
    }
}
