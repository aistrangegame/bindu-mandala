import SwiftUI
import SwiftData

/// Ring 1 World — Bhūpura, the Earth-City.
///
/// Three nested squares with four T-gates. 28 lights — 10 Siddhi on the outer
/// line, 8 Mātṛkā on the middle, 10 Mudrā on the inner. The ground does not
/// breathe. It holds. Only the gate-embers, the dust, and the far bindu move.
///
/// Interactions:
/// - Tap a light → meet her (name · family · quality)
/// - Tap a family in the legend → that band illumines + lived note
/// - Tap a gate → the world floods in (all 28 lit + anchor copy)
/// - Tap empty ground → release
struct RingOneWorldView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var met: Int? = nil
    @State private var focusFamily: Family? = nil
    @State private var allLit: Bool = false
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var emberPhase: CGFloat = 0
    @State private var binduPhase: CGFloat = 0

    enum Family: String {
        case siddhi, matrka, mudra

        var color: Color {
            switch self {
            case .siddhi: return Color(hex: "#D9A93C")
            case .matrka: return Color(hex: "#CF9443")
            case .mudra:  return Color(hex: "#B07F36")
            }
        }

        var label: String {
            switch self {
            case .siddhi: return "Siddhi"
            case .matrka: return "Mātṛkā"
            case .mudra:  return "Mudrā"
            }
        }

        var english: String {
            switch self {
            case .siddhi: return "the ten powers · accomplishment"
            case .matrka: return "the eight mothers · language"
            case .mudra:  return "the ten seals · gesture"
            }
        }

        var lived: String {
            switch self {
            case .siddhi:
                return "Ten powers of accomplishment. You have known these as work — the thing that got done, the will that held through the night. Every accomplishment was already hers."
            case .matrka:
                return "Eight mothers — language itself. You have known these as family, as the mother-tongue, as every name spoken in love. The world was spoken before it was seen."
            case .mudra:
                return "Ten seals — the gestures of the body. You have known these as the body — the reach, the grip, the hand that shaped a whole life. Matter became sacred in the moving."
            }
        }
    }

    /// 28 placeholder qualities mapped to Khaḍgamālā positions 1–28.
    /// Sourced from canonical aṇimādi siddhi / mātṛkā / mudrā-śakti meanings.
    private let canonicalQualities: [String] = [
        "the power to grow infinitely small — to enter the atom of a moment",
        "weightlessness — to be unburdened by what you carry",
        "the power to grow vast — to contain more than your form",
        "sovereignty — to preside over what is yours",
        "mastery — the world arranging itself around your steadiness",
        "irresistible will — a wanting that meets no wall",
        "fruition — the right to enjoy what has ripened",
        "the wish answered before it is spoken",
        "reach — to arrive anywhere without moving",
        "the garland of all desires, each one already granted",
        "the first sound — she who speaks the world into vowels",
        "the great voice — speech as sovereign power",
        "the ever-young syllable — speech before it was taught",
        "the sustaining word — language that holds the world together",
        "the rooting tongue — speech that digs into the earth of meaning",
        "the radiant utterance — language that rules from the height",
        "the fierce syllable — the word that ends what must end",
        "the abundant word — speech that pours itself into form",
        "the seal that stirs — the gesture that wakes the still",
        "the seal that scatters — the gesture that disperses what clings",
        "the seal that draws — the gesture of attraction itself",
        "the seal that gladdens — the gesture that floods with delight",
        "the seal that enchants — the gesture that suspends the mind",
        "the seal that arrests — the gesture that holds time still",
        "the seal that opens — the great yawn of space",
        "the seal that masters — the gesture that brings all under one will",
        "the seal that colours — the gesture that tints the world with feeling",
        "the seal that maddens — the gesture of divine intoxication"
    ]

    private var ring1Shaktis: [Shakti] {
        Array(allShaktis.filter { $0.ringNumber == 1 }
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
            .prefix(28))
    }

    private func family(for position: Int) -> Family {
        if position <= 10 { return .siddhi }
        if position <= 18 { return .matrka }
        return .mudra
    }

    /// Map a flat light-index (0..27) to its position on the appropriate
    /// nested square. Extracted out of the ForEach so the closure's type
    /// inference stays simple.
    private func pointFor(index: Int,
                          outerPoints: [CGPoint],
                          midPoints: [CGPoint],
                          innerPoints: [CGPoint]) -> CGPoint {
        switch index {
        case 0..<10:  return outerPoints[index]
        case 10..<18: return midPoints[index - 10]
        default:      return innerPoints[index - 18]
        }
    }

    var body: some View {
        ZStack {
            background

            GeometryReader { geo in
                let cx = geo.size.width / 2
                // Center sits a hair higher than before so the larger figure
                // still clears the encounter block and family legend below.
                let cy: CGFloat = min(372, geo.size.height * 0.44)
                let outerHalf: CGFloat = 170    // was 150 — give the 28 lights more room
                let midHalf: CGFloat = 128      // was 110
                let innerHalf: CGFloat = 90     // was 72 — tightest band needed the most relief
                let gateOut: CGFloat = 18
                let outerPoints = squarePoints(half: outerHalf, n: 10,
                                                center: CGPoint(x: cx, y: cy))
                let midPoints = squarePoints(half: midHalf, n: 8,
                                              center: CGPoint(x: cx, y: cy))
                let innerPoints = squarePoints(half: innerHalf, n: 10,
                                                center: CGPoint(x: cx, y: cy))

                ZStack {
                    ringIdentity
                        .position(x: cx, y: 96)
                        .allowsHitTesting(false)

                    // Inner geometry (the way in) + far bindu
                    innerPath(cx: cx, cy: cy)

                    // Three nested squares
                    nestedSquare(half: innerHalf, family: .mudra, cx: cx, cy: cy)
                    nestedSquare(half: midHalf, family: .matrka, cx: cx, cy: cy)
                    nestedSquare(half: outerHalf, family: .siddhi, cx: cx, cy: cy)

                    // Four T-gates
                    ForEach(0..<4, id: \.self) { i in
                        gateView(index: i, outerHalf: outerHalf, gateOut: gateOut,
                                 cx: cx, cy: cy)
                    }

                    // 28 lights
                    ForEach(0..<28, id: \.self) { i in
                        lightView(
                            position: i + 1,
                            family: family(for: i + 1),
                            at: pointFor(index: i,
                                          outerPoints: outerPoints,
                                          midPoints: midPoints,
                                          innerPoints: innerPoints)
                        )
                    }

                    // Lower composition — the encounter
                    encounterBlock
                        .frame(maxWidth: geo.size.width - 64)
                        .position(x: cx, y: geo.size.height - 220)

                    // Family legend
                    familyLegend(cx: cx, geoWidth: geo.size.width)
                        .position(x: cx, y: geo.size.height - 134)

                    // Hint
                    Text("TAP A LIGHT TO MEET HER · A GATE TO LET THE WORLD IN")
                        .font(.system(size: 11))
                        .tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.40))
                        .position(x: cx, y: geo.size.height - 96)
                        .allowsHitTesting(false)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { release() }
        .offset(y: dragOffset)
        .gesture(swipeDown)
        .overlay(alignment: .top) {
            DismissArc()
                .frame(height: 60)
                .contentShape(Rectangle())
                .highPriorityGesture(
                    TapGesture().onEnded { dismiss() }
                )
        }
        .overlay(alignment: .bottomLeading) {
            RingSoundDot(
                isOn: $soundOn,
                label: "ground",
                color: Family.siddhi.color,
                onToggle: toggleGround
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
        .onAppear { startAnimations() }
        .onDisappear {
            RingAudioService.shared.groundDroneStop()
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#0C0703"),
                    Color(hex: "#080402"),
                    Color(hex: "#060301")
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 207/255, green: 148/255, blue: 67/255).opacity(0.11), location: 0),
                    .init(color: Color(red: 139/255, green: 90/255, blue: 40/255).opacity(0.05), location: 0.46),
                    .init(color: .clear, location: 0.76)
                ]),
                center: UnitPoint(x: 0.5, y: 0.62),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }

    // MARK: - Ring identity

    private var ringIdentity: some View {
        VStack(spacing: 5) {
            Text("Trailokyamohana · the Earth-City")
                .font(.custom(AppFont.cormorantItalic, size: 14))
                .tracking(2.8)
                .foregroundStyle(Family.siddhi.color.opacity(0.78))
                .multilineTextAlignment(.center)
            Text("28 FORCES · THE OUTER GROUND")
                .font(.system(size: 11))
                .tracking(3.0)
                .foregroundStyle(Color.cream.opacity(0.45))
        }
    }

    // MARK: - Inner path + far bindu

    @ViewBuilder
    private func innerPath(cx: CGFloat, cy: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.gold.opacity(0.50), lineWidth: 0.4)
                .frame(width: 92, height: 92)
                .position(x: cx, y: cy)
            Circle()
                .stroke(Color.gold.opacity(0.40), lineWidth: 0.4)
                .frame(width: 64, height: 64)
                .position(x: cx, y: cy)
            // Far bindu — pulsing crimson ember
            Circle()
                .fill(Color.accentRed)
                .opacity(0.5 + 0.12 * Double(binduPhase))
                .frame(width: 6.8, height: 6.8)
                .position(x: cx, y: cy)
        }
        .opacity(allLit ? 0.06 : 0.12)
        .animation(.easeInOut(duration: 1.2), value: allLit)
        .allowsHitTesting(false)
    }

    // MARK: - Nested square

    @ViewBuilder
    private func nestedSquare(half: CGFloat, family: Family, cx: CGFloat, cy: CGFloat) -> some View {
        Rectangle()
            .stroke(family.color, lineWidth: 0.8)
            .frame(width: half * 2, height: half * 2)
            .opacity(squareOpacity(for: family))
            .position(x: cx, y: cy)
            .animation(.easeInOut(duration: 1.0), value: focusFamily)
            .animation(.easeInOut(duration: 1.0), value: allLit)
            .allowsHitTesting(false)
    }

    private func squareOpacity(for family: Family) -> Double {
        if allLit { return 0.50 }
        guard let focus = focusFamily else { return 0.24 }
        return family == focus ? 0.52 : 0.07
    }

    // MARK: - T-gate

    private struct GateGeometry {
        let gate: CGPoint
        let stemEnd: CGPoint
        let lintelStart: CGPoint
        let lintelEnd: CGPoint
    }

    private func gateGeometry(index: Int, outerHalf: CGFloat, gateOut: CGFloat,
                              cx: CGFloat, cy: CGFloat) -> GateGeometry {
        let direction: (CGFloat, CGFloat)
        let gatePosition: CGPoint
        switch index {
        case 0:
            direction = (0, -1)
            gatePosition = CGPoint(x: cx, y: cy - outerHalf)
        case 1:
            direction = (1, 0)
            gatePosition = CGPoint(x: cx + outerHalf, y: cy)
        case 2:
            direction = (0, 1)
            gatePosition = CGPoint(x: cx, y: cy + outerHalf)
        default:
            direction = (-1, 0)
            gatePosition = CGPoint(x: cx - outerHalf, y: cy)
        }

        let stemEnd = CGPoint(
            x: gatePosition.x + direction.0 * gateOut,
            y: gatePosition.y + direction.1 * gateOut
        )
        let perp: (CGFloat, CGFloat) = (-direction.1, direction.0)
        let halfBar: CGFloat = 15
        return GateGeometry(
            gate: gatePosition,
            stemEnd: stemEnd,
            lintelStart: CGPoint(
                x: stemEnd.x + perp.0 * halfBar,
                y: stemEnd.y + perp.1 * halfBar
            ),
            lintelEnd: CGPoint(
                x: stemEnd.x - perp.0 * halfBar,
                y: stemEnd.y - perp.1 * halfBar
            )
        )
    }

    @ViewBuilder
    private func gateView(index: Int, outerHalf: CGFloat, gateOut: CGFloat,
                          cx: CGFloat, cy: CGFloat) -> some View {
        let geometry = gateGeometry(index: index, outerHalf: outerHalf,
                                    gateOut: gateOut, cx: cx, cy: cy)
        let gatePosition = geometry.gate
        let stemEnd = geometry.stemEnd
        let lintelStart = geometry.lintelStart
        let lintelEnd = geometry.lintelEnd

        let opacity = allLit ? 0.70 : 0.40
        let color = Family.siddhi.color

        ZStack {
            // Hit area — comfortable thumb target.
            Color.clear
                .frame(width: Hit.min, height: Hit.min)

            // Stem
            Path { p in
                p.move(to: gatePosition)
                p.addLine(to: stemEnd)
            }
            .stroke(color, lineWidth: 0.9)
            .opacity(opacity)

            // Lintel
            Path { p in
                p.move(to: lintelStart)
                p.addLine(to: lintelEnd)
            }
            .stroke(color, lineWidth: 0.9)
            .opacity(opacity)

            // Threshold ember — pulses
            Circle()
                .fill(color)
                .opacity(allLit ? 0.90 : (0.5 + 0.15 * Double(emberPhase)))
                .frame(width: 4.8, height: 4.8)
                .position(stemEnd)
        }
        .contentShape(Rectangle())
        .onTapGesture { ignite() }
    }

    // MARK: - Light

    @ViewBuilder
    private func lightView(position: Int, family: Family, at point: CGPoint) -> some View {
        let isMet = (met == position)
        let radius: CGFloat = {
            if isMet { return 5.4 }
            if allLit { return 3.4 }
            if let focus = focusFamily {
                return family == focus ? 3.6 : 2.0
            }
            return 2.8
        }()
        let opacity: Double = {
            if isMet { return 1.0 }
            if allLit { return 0.96 }
            if let focus = focusFamily {
                return family == focus ? 0.92 : 0.10
            }
            return 0.52
        }()
        let glowR: CGFloat = {
            if isMet { return 13 }
            if allLit { return 9 }
            if let focus = focusFamily {
                return family == focus ? 8 : 0
            }
            return 4
        }()

        ZStack {
            if glowR > 0 {
                Circle()
                    .fill(family.color.opacity(opacity * 0.30))
                    .frame(width: (radius + 3) * 2, height: (radius + 3) * 2)
                    .blur(radius: glowR * 0.5)
            }
            Circle()
                .fill(family.color)
                .opacity(opacity)
                .frame(width: radius * 2, height: radius * 2)
            if isMet {
                Circle()
                    .stroke(family.color, lineWidth: 1)
                    .frame(width: radius * 2, height: radius * 2)
                Circle()
                    .fill(Color.cream.opacity(0.95))
                    .frame(width: radius * 0.84, height: radius * 0.84)
            }
        }
        // Visible dot stays small; only the invisible hit area grows.
        .frame(width: Hit.min, height: Hit.min)
        .contentShape(Circle())
        .position(point)
        .onTapGesture {
            Haptics.light()
            ensureSoundStarted()
            allLit = false
            met = position
            focusFamily = family
        }
        .animation(.easeInOut(duration: 0.8), value: met)
        .animation(.easeInOut(duration: 0.8), value: focusFamily)
        .animation(.easeInOut(duration: 0.8), value: allLit)
    }

    // MARK: - Encounter block

    @ViewBuilder
    private var encounterBlock: some View {
        if let metPos = met, let shakti = ring1Shaktis.first(where: { $0.khadgamalaPosition == metPos }) {
            let fam = family(for: metPos)
            VStack(spacing: 8) {
                Text(shakti.name.isEmpty ? "Light \(metPos)" : shakti.name)
                    .font(.custom(AppFont.cormorant, size: 40))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                Text("\(fam.label.uppercased()) · \(extractAccent(fam.english))")
                    .font(.system(size: 11))
                    .tracking(3.0)
                    .foregroundStyle(fam.color.opacity(0.85))
                Text(canonicalQualities[safeIndex: metPos - 1] ?? shakti.quality)
                    .font(.custom(AppFont.cormorantItalic, size: 19))
                    .tracking(0.3)
                    .lineSpacing(6)
                    .foregroundStyle(Color.cream.opacity(0.66))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else if let fam = focusFamily {
            VStack(spacing: 8) {
                Text(fam.label)
                    .font(.custom(AppFont.cormorant, size: 34))
                    .tracking(2.0)
                    .foregroundStyle(fam.color)
                Text(fam.english.uppercased())
                    .font(.system(size: 11))
                    .tracking(2.8)
                    .foregroundStyle(Color.cream.opacity(0.55))
                Text(fam.lived)
                    .font(.custom(AppFont.cormorantItalic, size: 16.5))
                    .tracking(0.2)
                    .lineSpacing(7)
                    .foregroundStyle(Color.cream.opacity(0.60))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else if allLit {
            VStack(spacing: 18) {
                Text("Thank you for the world I have walked through without knowing it was you.")
                    .font(.custom(AppFont.cormorantItalic, size: 24))
                    .tracking(0.3)
                    .lineSpacing(7)
                    .foregroundStyle(Color.cream.opacity(0.78))
                    .multilineTextAlignment(.center)
                Text("THE WHOLE GROUND, ALIGHT")
                    .font(.system(size: 11))
                    .tracking(3.0)
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else {
            Text("The ground you have walked, before you knew it was hers.")
                .font(.custom(AppFont.cormorantItalic, size: 20))
                .tracking(0.3)
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        }
    }

    private func extractAccent(_ english: String) -> String {
        // "the ten powers · accomplishment" → "ACCOMPLISHMENT"
        let parts = english.components(separatedBy: " · ")
        return parts.count > 1 ? parts[1].uppercased() : ""
    }

    // MARK: - Family legend

    @ViewBuilder
    private func familyLegend(cx: CGFloat, geoWidth: CGFloat) -> some View {
        HStack(spacing: 22) {
            ForEach([Family.siddhi, Family.matrka, Family.mudra], id: \.self) { fam in
                let isFocused = (focusFamily == fam)
                let dim = focusFamily != nil && !isFocused
                Button {
                    Haptics.light()
                    ensureSoundStarted()
                    allLit = false
                    met = nil
                    focusFamily = (focusFamily == fam) ? nil : fam
                } label: {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(fam.color)
                            .frame(width: 6, height: 6)
                            .shadow(color: isFocused ? fam.color : .clear, radius: isFocused ? 8 : 0)
                        Text(fam.label)
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(0.6)
                            .foregroundStyle(isFocused ? fam.color : Color.cream.opacity(0.55))
                    }
                    .contentShape(Rectangle())
                    .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                .opacity(dim ? 0.34 : 1.0)
                .animation(.easeInOut(duration: 0.4), value: focusFamily)
            }
        }
        .frame(maxWidth: geoWidth)
    }

    // MARK: - Interactions

    private func ignite() {
        Haptics.medium()
        ensureSoundStarted()
        met = nil
        focusFamily = nil
        allLit = true
    }

    private func release() {
        met = nil
        focusFamily = nil
        allLit = false
    }

    private func ensureSoundStarted() {
        guard !soundOn else { return }
        RingAudioService.shared.groundDroneStart()
        soundOn = true
    }

    private func toggleGround() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.groundDroneStop()
            soundOn = false
        } else {
            RingAudioService.shared.groundDroneStart()
            soundOn = true
        }
    }

    private func startAnimations() {
        guard !reduceMotion else { return }
        withAnimation(.easeInOut(duration: 5.5).repeatForever(autoreverses: true)) {
            emberPhase = 1
        }
        withAnimation(.easeInOut(duration: 9.0).repeatForever(autoreverses: true)) {
            binduPhase = 1
        }
    }

    private var swipeDown: some Gesture {
        DragGesture()
            .onChanged { v in
                if v.translation.height > 0 {
                    dragOffset = v.translation.height * 0.6
                }
            }
            .onEnded { v in
                if v.translation.height > 80 {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.4)) {
                        dragOffset = 0
                    }
                }
            }
    }
}

// MARK: - Square perimeter distribution

private func squarePoints(half: CGFloat, n: Int, center: CGPoint) -> [CGPoint] {
    let perimeter = 8 * half
    return (0..<n).map { i in
        let d = (((CGFloat(i) + 0.5) / CGFloat(n)) * perimeter).truncatingRemainder(dividingBy: perimeter)
        let x: CGFloat
        let y: CGFloat
        if d < 2 * half {
            x = -half + d
            y = -half
        } else if d < 4 * half {
            x = half
            y = -half + (d - 2 * half)
        } else if d < 6 * half {
            x = half - (d - 4 * half)
            y = half
        } else {
            x = -half
            y = half - (d - 6 * half)
        }
        return CGPoint(x: center.x + x, y: center.y + y)
    }
}
