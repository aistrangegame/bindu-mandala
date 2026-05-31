import SwiftUI
import SwiftData

/// The Veil — a bottom sheet that rises over the held yantra and reveals the
/// nine Avaraṇas as a descent column (Rings I–VIII as rows, Ring IX as a footer).
struct VeilView: View {
    let availableHeight: CGFloat
    @Binding var offset: CGFloat
    var onEntry: (Int) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @State private var dragStart: CGFloat?
    @State private var dragMoved: CGFloat = 0

    private var sheetHeight: CGFloat { availableHeight * 0.85 }
    private let peekHeight: CGFloat = 108
    private var closedOffset: CGFloat { sheetHeight - peekHeight }
    private var snapThreshold: CGFloat { closedOffset * 0.42 }
    private var isOpen: Bool { offset < closedOffset * 0.5 }
    private var openTransition: Animation {
        .timingCurve(0.22, 1, 0.36, 1, duration: 0.52)
    }

    var body: some View {
        VStack(spacing: 0) {
            handle
                .contentShape(Rectangle())
                .gesture(dragGesture)
            descentColumn
        }
        .frame(height: sheetHeight)
        .background(sheetBackground)
        .clipShape(TopRoundedShape(radius: 22))
        .offset(y: offset)
        .shadow(color: .black.opacity(0.7), radius: 30, y: -10)
    }

    // MARK: - Handle

    private var handle: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Color.cream.opacity(0.30))
                .frame(width: 40, height: 4)
                .padding(.top, 14)
                .padding(.bottom, 14)

            if isOpen {
                openHeader
            } else {
                peekHeader
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 12)
    }

    private var openHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("The Nine Avaraṇas")
                .font(.custom(AppFont.cormorant, size: 22))
                .tracking(0.9)
                .foregroundStyle(Color.cream)
            Spacer()
            Text("DESCEND")
                .font(.system(size: 9))
                .tracking(1.4)
                .foregroundStyle(Color.gold.opacity(0.85))
        }
        .padding(.horizontal, 24)
    }

    private var peekHeader: some View {
        VStack(spacing: 7) {
            PeekChevron(reduceMotion: reduceMotion)
            Text("THE NINE AVARAṆAS")
                .font(.system(size: 9))
                .tracking(2.2)
                .foregroundStyle(Color.gold.opacity(0.85))
        }
    }

    // MARK: - Descent column

    private var descentColumn: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(1...8, id: \.self) { ring in
                    ThresholdRow(
                        ring: ring,
                        avarana: avarana(for: ring),
                        status: status(for: ring),
                        onTap: {
                            Haptics.light()
                            onEntry(ring)
                        }
                    )
                }
                BinduFooter(
                    avarana: avarana(for: 9),
                    onTap: {
                        Haptics.light()
                        onEntry(9)
                    }
                )
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 40)
        }
        .opacity(isOpen ? 1 : 0)
        .allowsHitTesting(isOpen)
        .animation(.easeInOut(duration: 0.4), value: isOpen)
    }

    // MARK: - Background

    private var sheetBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color(red: 13/255, green: 4/255, blue: 9/255).opacity(0.92), location: 0),
                .init(color: Color(red: 11/255, green: 3/255, blue: 7/255).opacity(0.985), location: 0.3),
                .init(color: Color(red: 8/255, green: 2/255, blue: 6/255).opacity(0.995), location: 1.0)
            ],
            startPoint: .top, endPoint: .bottom
        )
        .overlay(
            Rectangle()
                .fill(Color.gold.opacity(0.22))
                .frame(height: 0.5),
            alignment: .top
        )
    }

    // MARK: - Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                if dragStart == nil {
                    dragStart = offset
                }
                dragMoved = max(dragMoved, abs(v.translation.height))
                let next = max(0, min(closedOffset, (dragStart ?? offset) + v.translation.height))
                offset = next
            }
            .onEnded { _ in
                let start = dragStart ?? offset
                let wasTap = dragMoved < 6
                dragStart = nil
                dragMoved = 0

                Haptics.light()
                withAnimation(openTransition) {
                    if wasTap {
                        offset = start < closedOffset * 0.5 ? closedOffset : 0
                    } else {
                        offset = offset < snapThreshold ? 0 : closedOffset
                    }
                }
            }
    }

    // MARK: - Helpers

    private func avarana(for ring: Int) -> Avarana? {
        avaranas.first(where: { $0.ringNumber == ring })
    }

    private func status(for ring: Int) -> RowStatus {
        switch ring {
        case 1: return .ancient
        case 2: return .home
        case 8: return .deep
        default: return .interior
        }
    }
}

// MARK: - Row status & luminosity

/// All rows are accessible from day one. The gradient from Ring 2 inward
/// expresses sacred depth — interior rings are quieter, not restricted.
enum RowStatus {
    case home       // Ring 2 — most present, the practitioner's home
    case ancient    // Ring 1 — the ground, warmer amber
    case interior   // Rings 3–7 — present, each step quieter than home
    case deep       // Ring 8 — the deepest before the Bindu

    var glyphOpacity: Double {
        switch self {
        case .home:     return 0.95
        case .ancient:  return 0.60
        case .interior: return 0.78
        case .deep:     return 0.55
        }
    }
    var nameOpacity: Double {
        switch self {
        case .home:     return 0.96
        case .ancient:  return 0.66
        case .interior: return 0.82
        case .deep:     return 0.58
        }
    }
    var subOpacity: Double {
        switch self {
        case .home:     return 0.62
        case .ancient:  return 0.42
        case .interior: return 0.50
        case .deep:     return 0.36
        }
    }
    var accent: Color {
        switch self {
        case .home, .interior, .deep: return Color.gold
        case .ancient:                return Color.goldWarm
        }
    }
    var wash: Bool { self == .home }
    var glow: Bool { self == .home }
}

// MARK: - One row in the descent

private struct ThresholdRow: View {
    let ring: Int
    let avarana: Avarana?
    let status: RowStatus
    let onTap: () -> Void

    private static let romans = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                glyph
                nameBlock
                Spacer(minLength: 6)
                roman
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
            .background(washBackground)
            .overlay(borderBottom, alignment: .bottom)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var glyph: some View {
        RingGlyph(ring: ring, color: status.accent, size: 36)
            .opacity(status.glyphOpacity)
            .shadow(color: status.glow ? Color.gold.opacity(0.45) : .clear,
                    radius: status.glow ? 7 : 0)
    }

    private var nameBlock: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(displayName)
                .font(.custom(AppFont.cormorant, size: 20))
                .tracking(0.6)
                .foregroundStyle(Color.cream.opacity(status.nameOpacity))
                .lineLimit(1)
                .truncationMode(.tail)

            if let sub = avarana?.subtitle, !sub.isEmpty {
                Text(sub)
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(0.3)
                    .foregroundStyle(Color.cream.opacity(status.subOpacity))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            if let summary = formSummary {
                Text(summary)
                    .font(.system(size: 9))
                    .tracking(1.0)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var roman: some View {
        Text(Self.romans[ring])
            .font(.custom(AppFont.cormorant, size: 19))
            .tracking(1.15)
            .foregroundStyle(status.accent)
            .opacity(status.glyphOpacity)
            .frame(width: 38, alignment: .trailing)
    }

    @ViewBuilder
    private var washBackground: some View {
        if status.wash {
            LinearGradient(
                colors: [Color.gold.opacity(0.10), Color.gold.opacity(0.03)],
                startPoint: .leading, endPoint: .trailing
            )
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.gold.opacity(0.26), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
    }

    @ViewBuilder
    private var borderBottom: some View {
        if !status.wash {
            Rectangle()
                .fill(Color.gold.opacity(0.11))
                .frame(height: 0.5)
                .padding(.horizontal, 4)
        }
    }

    private var displayName: String {
        if let av = avarana, !av.sanskritName.isEmpty { return av.sanskritName }
        switch ring {
        case 1: return "1st Avaraṇa"
        case 2: return "2nd Avaraṇa"
        case 3: return "3rd Avaraṇa"
        default: return "\(ring)th Avaraṇa"
        }
    }

    private var formSummary: String? {
        guard let av = avarana else { return nil }
        let form = av.geometricShape?.trimmingCharacters(in: .whitespaces)
        let pieces = [form?.uppercased()].compactMap { $0 }.filter { !$0.isEmpty }
        return pieces.isEmpty ? nil : pieces.joined(separator: " · ")
    }
}

// MARK: - The Bindu footer (Ring IX)

private struct BinduFooter: View {
    let avarana: Avarana?
    let onTap: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var binduPhase: CGFloat = 0

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: Color.gold.opacity(0.45), location: 0.5),
                                .init(color: .clear, location: 1.0)
                            ],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(height: 0.5)
                    .padding(.horizontal, 24)

                VStack(spacing: 0) {
                    bindu
                        .padding(.top, 30)
                        .padding(.bottom, 18)
                    Text(displayName)
                        .font(.custom(AppFont.cormorant, size: 24))
                        .tracking(1.2)
                        .foregroundStyle(Color.gold)
                        .multilineTextAlignment(.center)
                    if let sub = avarana?.subtitle, !sub.isEmpty {
                        Text(sub)
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(0.4)
                            .foregroundStyle(Color.cream.opacity(0.6))
                            .padding(.top, 5)
                    }
                    Text("The Bindu · IX")
                        .font(.system(size: 9))
                        .tracking(2.2)
                        .foregroundStyle(Color.gold.opacity(0.85))
                        .padding(.top, 12)
                        .padding(.bottom, 26)
                }
            }
            .padding(.top, 14)
            .frame(maxWidth: .infinity)
            .background(
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.accentRed.opacity(0.20), location: 0),
                        .init(color: .clear, location: 1.0)
                    ]),
                    center: UnitPoint(x: 0.5, y: 0.18),
                    startRadius: 0, endRadius: 90
                )
                .allowsHitTesting(false)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onAppear {
            guard !reduceMotion else { binduPhase = 0.5; return }
            withAnimation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true)) {
                binduPhase = 1
            }
        }
    }

    private var bindu: some View {
        let scale = 1.0 + Double(binduPhase) * 0.16
        let size: CGFloat = 26
        return ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.accentRed, location: 0),
                            .init(color: Color.accentRed.opacity(0.65), location: 0.55),
                            .init(color: .clear, location: 1.0)
                        ]),
                        center: .center, startRadius: 0, endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
            Circle()
                .fill(Color.cream)
                .frame(width: 10, height: 10)
                .opacity(0.96)
                .shadow(color: Color.cream.opacity(0.6), radius: 6)
        }
        .scaleEffect(scale)
    }

    private var displayName: String {
        if let av = avarana, !av.sanskritName.isEmpty { return av.sanskritName }
        return "9th Avaraṇa"
    }
}

// MARK: - Peek chevron

private struct PeekChevron: View {
    let reduceMotion: Bool
    @State private var phase: CGFloat = 0

    var body: some View {
        let opacity = 0.45 + 0.45 * Double(phase)
        let translateY: CGFloat = 2 - 4 * phase
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: 2, y: 7))
                p.addLine(to: CGPoint(x: 11, y: 2))
                p.addLine(to: CGPoint(x: 20, y: 7))
            }
            .stroke(Color.gold.opacity(opacity),
                    style: StrokeStyle(lineWidth: 1, lineCap: .round))
        }
        .frame(width: 22, height: 9)
        .offset(y: translateY)
        .onAppear {
            guard !reduceMotion else { phase = 0.5; return }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                phase = 1
            }
        }
    }
}

// MARK: - Top-rounded shape (only top corners)

private struct TopRoundedShape: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        p.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                 radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        p.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        p.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                 radius: radius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
