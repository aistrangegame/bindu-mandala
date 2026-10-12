import SwiftUI
import SwiftData

/// The threshold of one enclosure — the Living Rite's `AvaranaThreshold`,
/// "enter her ring".
///
/// **Wave 1 · the light comes home.** What stood here was the older Mandala
/// App's doorway: the ring's geometry drawn in gold at 4.5% opacity over a
/// fixed dark gradient, about 8× fainter than Design's own threshold, which was
/// never ported. This is that threshold. The enclosure is lit by its own
/// atmosphere — `lrBackdrop` for the ring, the ring's geometry standing at 0.7
/// with the ×1.7 in every stroke, its motes, its depth — and it names itself
/// in the Rite's staged arrival: the form, the name in its glow, the subtitle
/// in the ring's bright accent, the hairline, Ash's own Personal Connection,
/// the gratitude in gold, then the mental state and the chakra. At the foot is
/// the gesture the screen exists for: **enter her ring**, a pill of the ring's
/// own light, which returns to the Field with that enclosure open.
///
/// Pushed onto the Field's navigation stack. The system bar is hidden in favour
/// of Design's "‹ the field"; the edge swipe still goes back.
struct AvaranaThresholdView: View {
    let avarana: Avarana
    /// The ring's light, as its row in the Field wears it. Nil derives it from
    /// the ring's first Khaḍgamālā position.
    var ringAtmosphere: Atmosphere? = nil
    /// What "enter her ring" does. Nil simply steps back.
    var onEnter: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var arrived = false

    private var ring: Int { avarana.ringNumber }
    private var still: Bool { reduceMotion || AppRuntime.forcesReduceMotion }
    private var atmo: Atmosphere { ringAtmosphere ?? Self.fallbackAtmosphere(ring: ring) }

    var body: some View {
        let a = atmo
        ZStack {
            AtmosphereBackground(atmosphere: a)

            // The ring's geometry, standing at 42% of the screen at 0.7.
            GeometryReader { geo in
                let k = min(geo.size.width, geo.size.height) / RiteSigilPlacement.referenceWidth
                RiteSigil(atmosphere: a, ring: ring, size: 620 * k,
                          spin: ring % 2 == 1 ? 1 : -1, lineScale: k)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.42)
            }
            .ignoresSafeArea()
            .opacity(arrived ? DayLight.thresholdSigilOpacity : 0)
            .animation(still ? nil : StagedArrival.ease(duration: StagedArrival.sigilDuration,
                                                        delay: StagedArrival.sigilDelay),
                       value: arrived)
            .allowsHitTesting(false)

            DustMotesView(count: 12, element: a.element, accent: a.accentBright)
                .allowsHitTesting(false)
            DepthOverlay()

            VStack(spacing: 0) {
                topBar
                GeometryReader { geo in
                    ScrollView {
                        column(a)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: geo.size.height)
                    }
                    .scrollIndicators(.hidden)
                }
                enterButton(a)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .enableSwipeBack()
        .onAppear(perform: beginArrival)
    }

    // MARK: - The way back, and the count of her seats

    private var topBar: some View {
        HStack {
            Button {
                Haptics.light()
                dismiss()
            } label: {
                Text("‹ the field")
                    .font(AppFont.voice(17))
                    .foregroundStyle(Color.gold)
                    .padding(.trailing, 12)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back to the Field")

            Spacer(minLength: 12)

            Text("\(avarana.shaktiCount) śakti\(avarana.shaktiCount == 1 ? "" : "s")".uppercased())
                .font(AppFont.label(11))
                .tracking(2.4)
                .foregroundStyle(Color.cream.opacity(0.55))
        }
        .padding(.horizontal, 22)
        .padding(.top, 6)
    }

    // MARK: - The enclosure names itself

    private func column(_ a: Atmosphere) -> some View {
        let nameSize = Self.nameSize(avarana.sanskritName)
        return VStack(spacing: 0) {
            Text("\(Self.ordinal(ring)) Āvaraṇa · \(avarana.enclosureForm)".uppercased())
                .font(AppFont.label(11.5))
                .tracking(3.4)
                .foregroundStyle(a.accentBright)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .arrives(arrived, after: 0.20, still: still)

            Text(avarana.sanskritName)
                .font(AppFont.sanskrit(nameSize))
                .tracking(nameSize * 0.05)
                .foregroundStyle(Color.cream)
                .shadow(color: a.glow, radius: 25)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 18)
                .arrives(arrived, after: 0.35, still: still)

            if let sub = avarana.subtitle, !sub.isEmpty {
                Text(sub)
                    .font(AppFont.voice(22))
                    .foregroundStyle(a.accentBright)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 14)
                    .arrives(arrived, after: 0.50, still: still)
            }

            Rectangle()
                .fill(a.accentSoft)
                .frame(width: 48, height: 1)
                .padding(.vertical, 24)
                .arrives(arrived, after: 0.70, still: still)

            if let conn = avarana.personalConnection, !conn.isEmpty {
                Text(conn)
                    .font(AppFont.voice(18.5))
                    .lineSpacing(8)
                    .foregroundStyle(Color.cream.opacity(0.82))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .arrives(arrived, after: 0.80, still: still)
            }

            if !avarana.appreciationPhrase.isEmpty {
                Text("\u{201C}\(avarana.appreciationPhrase)\u{201D}")
                    .font(AppFont.voice(18))
                    .lineSpacing(5)
                    .foregroundStyle(Color.gold)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)
                    .arrives(arrived, after: 0.95, still: still)
            }

            if let state = Self.joined([avarana.mentalState, avarana.subtleBodyChakra]) {
                Text(state)
                    .font(AppFont.voice(14.5))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)
                    .arrives(arrived, after: 1.05, still: still)
            }

            // What the older doorway carried and Design's left out — kept, at
            // the foot of the reading, so nothing he could read here is lost.
            if let lineage = Self.joined([avarana.geometricShape, avarana.presidingForm, avarana.yogini]) {
                Text(lineage)
                    .font(AppFont.voice(14.5))
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
                    .arrives(arrived, after: 1.15, still: still)
            }
        }
    }

    // MARK: - Enter her ring

    private func enterButton(_ a: Atmosphere) -> some View {
        Button(action: enter) {
            Text("enter her ring")
                .font(AppFont.sanskrit(20))
                .tracking(2.0)
                .foregroundStyle(Color(hex: "#0D0508"))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
                .background(
                    Capsule()
                        .fill(LinearGradient(colors: [a.accent, a.accentBright],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: a.glow, radius: 22, y: 4)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Enter her ring — open \(avarana.sanskritName) in the Field")
        .padding(.horizontal, 30)
        .padding(.top, 10)
        .padding(.bottom, 22)
        .arrives(arrived, after: 1.25, still: still)
    }

    private func enter() {
        if let onEnter {
            onEnter()
        } else {
            Haptics.medium()
            dismiss()
        }
    }

    private func beginArrival() {
        guard !arrived else { return }
        if still {
            arrived = true
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + StagedArrival.lead) { arrived = true }
    }

    // MARK: - Helpers

    /// `lrNameSize(av.name, 46)` — the enclosure's name, tapered by length.
    static func nameSize(_ name: String) -> Double {
        let n = name.count
        if n <= 15 { return 46 }
        if n <= 18 { return 42 }
        return 37
    }

    /// The light of a ring with no row to read it from: its first seat's.
    static func fallbackAtmosphere(ring: Int) -> Atmosphere {
        let firstKp = [1: 1, 2: 29, 3: 45, 4: 53, 5: 67, 6: 77, 7: 87, 8: 99, 9: 102][ring] ?? 1
        return Atmosphere.derive(ring: ring, cluster: ring == 2 ? .inner : nil,
                                 khadgamala: firstKp, element: Element.forRing(ring))
    }

    static func joined(_ parts: [String?]) -> String? {
        let kept = parts.compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return kept.isEmpty ? nil : kept.joined(separator: " · ")
    }

    /// "First" … "Ninth" for the āvaraṇa kicker.
    static func ordinal(_ n: Int) -> String {
        let names = ["", "First", "Second", "Third", "Fourth", "Fifth",
                     "Sixth", "Seventh", "Eighth", "Ninth"]
        return (1...9).contains(n) ? names[n] : "\(n)th"
    }
}
