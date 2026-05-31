import SwiftUI
import SwiftData

/// The Today screen — the daily companion.
/// Two variants per DESIGN_SPEC: V1 with body outline · V2 with bīja texture.
struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.position) private var shaktis: [Shakti]
    @Query(sort: \NityaDevi.tithiPosition) private var nityas: [NityaDevi]
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]

    enum Variant { case body, bija }
    @AppStorage("today_variant_raw") private var variantRaw: String = Variant.body.storage
    private var variant: Variant {
        get { variantRaw == Variant.bija.storage ? .bija : .body }
    }

    @State private var nameVisible = false
    @State private var promptVisible = false
    @State private var showRecognition = ProcessInfo.processInfo.arguments.contains("AUTO_RECOGNIZE")
    @State private var nityaDetailFor: NityaSlot?

    var today: Shakti? {
        let pos = LunarPhaseService.todayPosition()
        return shaktis.first(where: { $0.position == pos && ($0.ringNumber ?? 2) == 2 }) ?? shaktis.first
    }

    var body: some View {
        ZStack {
            Color.ground.ignoresSafeArea()

            // Warm crimson radial behind the name
            RadialGradient(
                gradient: Gradient(colors: [Color.accentRed.opacity(0.18), Color.clear]),
                center: UnitPoint(x: 0.5, y: 0.38),
                startRadius: 0, endRadius: 320
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // V2 bīja background texture
            if let s = today, variant == .bija {
                Text(s.bija)
                    .font(.custom(AppFont.cormorant, size: 280))
                    .foregroundStyle(Color.gold.opacity(0.07))
                    .tracking(-12)
                    .offset(y: -8)
                    .allowsHitTesting(false)
            }

            DustMotesView(count: 9)

            if let s = today {
                content(for: s)
            } else {
                ProgressView().tint(Color.gold)
            }
        }
        .onAppear(perform: animateIn)
        .fullScreenCover(isPresented: $showRecognition) {
            if let s = today { RecognitionMomentView(shakti: s, isPresented: $showRecognition) }
        }
        .sheet(item: $nityaDetailFor) { slot in
            NityaDetailView(slot: slot)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func content(for s: Shakti) -> some View {
        VStack(spacing: 0) {
            // Moon at top
            MoonPhaseView()
                .padding(.top, 8)
                .padding(.bottom, 12)

            // Nityā — compact card just below the moon.
            // Hidden entirely when no data resolves (.unknown).
            nityaCardLayer

            // Center column
            VStack(spacing: 0) {
                Spacer(minLength: 0)

                ClusterDotView(cluster: s.cluster)
                    .padding(.bottom, variant == .bija ? 20 : 16)

                Text(s.name)
                    .font(.custom(AppFont.cormorant, size: variant == .bija ? 48 : 44))
                    .foregroundStyle(Color.cream)
                    .tracking(3.4)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 24)
                    .opacity(nameVisible ? 1 : 0)
                    .offset(y: nameVisible ? 0 : 8)
                    .padding(.bottom, variant == .bija ? 12 : 10)
                    .accessibilityLabel("\(s.phonetic), \(s.quality)")

                Text(s.phonetic.uppercased())
                    .font(.system(size: 12, weight: .regular))
                    .tracking(2.4)
                    .foregroundStyle(Color.cream.opacity(0.45))
                    .padding(.bottom, variant == .bija ? 22 : 18)

                Text(s.quality)
                    .font(.custom(AppFont.cormorant, size: variant == .bija ? 22 : 20))
                    .foregroundStyle(Color.gold)
                    .tracking(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, variant == .bija ? 28 : 20)

                Rectangle()
                    .fill(Color.gold.opacity(0.4))
                    .frame(width: 48, height: 0.5)
                    .padding(.bottom, variant == .bija ? 28 : 20)

                Text("\u{201C}\(s.somatic)\u{201D}")
                    .font(.custom(AppFont.cormorantItalic, size: variant == .bija ? 20 : 19))
                    .foregroundStyle(Color.cream.opacity(0.78))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 32)
                    .opacity(promptVisible ? 1 : 0)
                    .offset(y: promptVisible ? 0 : 6)
                    .padding(.bottom, variant == .bija ? 36 : 28)

                if variant == .body {
                    BodyOutlineView(clusterColor: s.cluster.color, size: 90)
                        .opacity(0.9)
                        .padding(.bottom, 8)
                    Text(bodyLocationLabel(s.bodilyLocation).uppercased())
                        .font(.system(size: 10))
                        .tracking(1.8)
                        .foregroundStyle(Color.cream.opacity(0.55))
                        .padding(.bottom, 12)
                } else {
                    Text(s.bija)
                        .font(.custom(AppFont.cormorant, size: 42))
                        .foregroundStyle(Color.gold.opacity(0.85))
                        .tracking(2)
                }

                Spacer(minLength: 0)
            }

            // I feel her — primary CTA
            VStack(spacing: 12) {
                Button(action: triggerRecognition) {
                    Text("I feel her")
                        .font(.custom(AppFont.cormorant, size: 20))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Capsule().fill(Color.accentRed)
                                .shadow(color: Color.accentRed.opacity(0.45), radius: 32, y: 4)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("I feel her — record recognition of \(s.phonetic)")

                Text("Today's Bīja \u{2014} \(s.bija)")
                    .font(.system(size: 11))
                    .tracking(1.65)
                    .foregroundStyle(Color.cream.opacity(0.50))

                RingPositionIndicatorView()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Nityā layer (Phase 9)

    /// What presides over today, resolved at view evaluation time. New moon
    /// (waning day 15 → mirror position 0) wraps to Nityā 1 per brief's
    /// "New moon day → Kāmeśvarī" verification rule.
    private var nityaSlot: NityaSlot {
        let f = LunarPhaseService.phaseFraction()

        // Full moon window — Lalitā via the Ring 9 Avaraṇa
        if f >= 0.47 && f <= 0.53 {
            if let ring9 = avaranas.first(where: { $0.ringNumber == 9 }) {
                return .lalita(ring9)
            }
            return .unknown
        }

        // Daily tithi → Nityā position (waxing direct, waning mirror)
        let day = LunarPhaseService.currentDay()
        let position: Int
        if day <= 15 {
            position = day                    // waxing 1→1 … 15→15
        } else {
            position = 15 - (day - 15)        // waning 16→14 … 29→1; 30→0
        }
        let resolved = position >= 1 ? position : 1
        if let nitya = nityas.first(where: { $0.tithiPosition == resolved }) {
            return .nitya(nitya)
        }
        return .unknown
    }

    @ViewBuilder
    private var nityaCardLayer: some View {
        let slot = nityaSlot
        if case .unknown = slot {
            EmptyView()
        } else {
            nityaCard(slot)
                .padding(.bottom, 12)
        }
    }

    private func nityaCard(_ slot: NityaSlot) -> some View {
        let display = nityaCardDisplay(slot)
        return Button {
            nityaDetailFor = slot
        } label: {
            VStack(spacing: 4) {
                Text(display.name)
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(1.2)
                    .foregroundStyle(Color.gold)
                if !display.epithet.isEmpty {
                    Text(display.epithet.uppercased())
                        .font(.system(size: 10))
                        .tracking(2.4)
                        .foregroundStyle(Color.cream.opacity(0.55))
                }
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private struct NityaCardDisplay {
        let name: String
        let epithet: String
    }

    private func nityaCardDisplay(_ slot: NityaSlot) -> NityaCardDisplay {
        switch slot {
        case .nitya(let n):
            return NityaCardDisplay(name: n.sanskritName,
                                    epithet: n.quality ?? "")
        case .lalita(_):
            // Pūrṇimā = Lalitā, named directly. Ring 9's sanskritName is the
            // chakra ("Sarvānandamaya Chakra"), not the presiding goddess.
            return NityaCardDisplay(name: "Lalitā Mahātripurasundarī",
                                    epithet: "Pūrṇimā · Full Moon")
        case .unknown:
            return NityaCardDisplay(name: "", epithet: "")
        }
    }

    // MARK: - Recognition

    private func triggerRecognition() {
        Haptics.medium()
        showRecognition = true
    }

    private func animateIn() {
        let nameAnim: Animation = reduceMotion ? .linear(duration: 0.01)
                                               : .easeInOut(duration: 1.4)
        let promptAnim: Animation = reduceMotion ? .linear(duration: 0.01)
                                                 : .easeInOut(duration: 1.4)
        withAnimation(nameAnim) { nameVisible = true }
        withAnimation(promptAnim.delay(reduceMotion ? 0 : 0.55)) { promptVisible = true }
    }

    private func bodyLocationLabel(_ raw: String) -> String {
        switch raw.lowercased() {
        case "skin":   return "Skin Surface"
        case "heart":  return "Heart Center"
        case "head":   return "Head"
        case "solar":  return "Solar Plexus"
        case "ears":   return "Ears"
        case "eyes":   return "Eyes"
        case "tongue": return "Tongue"
        case "nose":   return "Nose"
        case "whole":  return "Whole Body"
        case "spine":  return "Spine"
        case "temples":return "Temples"
        case "throat": return "Throat"
        case "sacrum": return "Sacrum"
        case "crown":  return "Crown"
        default:       return raw.capitalized
        }
    }
}

private extension TodayView.Variant {
    var storage: String { self == .body ? "body" : "bija" }
}
