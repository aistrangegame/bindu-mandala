import SwiftUI
import SwiftData

/// The Veil — a bottom sheet that rises over the held yantra and presents
/// the nine āvaraṇas as a descent ladder.
///
/// Phase 4 reframe: this is no longer a free menu. Rings ≤ `deepestReached`
/// stay revisitable. The next ring (deepestReached + 1) appears as a
/// breathing threshold — content-gated. Rings beyond it are not yet glimpsed.
struct VeilView: View {
    let availableHeight: CGFloat
    @Binding var offset: CGFloat
    var onEntry: (Int) -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Query private var descentStates: [DescentState]
    @State private var dragStart: CGFloat?
    @State private var dragMoved: CGFloat = 0
    @State private var crossingMessage: String? = nil

    private var sheetHeight: CGFloat { availableHeight * 0.85 }
    private let peekHeight: CGFloat = 108
    private var closedOffset: CGFloat { sheetHeight - peekHeight }
    private var snapThreshold: CGFloat { closedOffset * 0.42 }
    private var isOpen: Bool { offset < closedOffset * 0.5 }
    private var openTransition: Animation {
        .timingCurve(0.22, 1, 0.36, 1, duration: 0.52)
    }

    /// Single-row state, lazily seeded by `ShaktiBootstrap.seedDescentIfNeeded`.
    private var descent: DescentState? { descentStates.first }
    private var currentRing: Int { descent?.currentRing ?? 2 }
    private var deepestReached: Int { descent?.deepestReached ?? 2 }
    /// The instrument is fully open — every one of the nine āvaraṇas is walkable
    /// from the first launch. The ladder always renders all nine.
    private var maxRenderedRing: Int { 9 }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                handle
                    .contentShape(Rectangle())
                    .gesture(dragGesture)
                descentColumn
            }
            crossingOverlay
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
            Text("The Descent")
                .font(.custom(AppFont.cormorant, size: 22))
                .tracking(0.9)
                .foregroundStyle(Color.cream)
            Spacer()
            Text("DESCEND")
                .font(.system(size: 11))
                .tracking(1.4)
                .foregroundStyle(Color.gold.opacity(0.85))
        }
        .padding(.horizontal, 24)
    }

    private var peekHeader: some View {
        VStack(spacing: 7) {
            PeekChevron(reduceMotion: reduceMotion)
            Text("THE NINE AVARAṆAS")
                .font(.system(size: 11))
                .tracking(2.2)
                .foregroundStyle(Color.gold.opacity(0.85))
        }
    }

    // MARK: - Descent column

    private var descentColumn: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(1...maxRenderedRing, id: \.self) { ring in
                    if ring == 9 {
                        BinduFooter(
                            kind: kind(for: ring),
                            avarana: avarana(for: ring),
                            reduceMotion: reduceMotion,
                            onEnter: { handleOpen(ring: ring) },
                            onCross: { handleCross(ring: ring) }
                        )
                    } else {
                        DescentRow(
                            ring: ring,
                            kind: kind(for: ring),
                            avarana: avarana(for: ring),
                            reduceMotion: reduceMotion,
                            onEnter: { handleOpen(ring: ring) },
                            onCross: { handleCross(ring: ring) }
                        )
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 40)
        }
        .opacity(isOpen ? 1 : 0)
        .allowsHitTesting(isOpen)
        .animation(.easeInOut(duration: 0.4), value: isOpen)
    }

    // MARK: - Crossing overlay

    @ViewBuilder
    private var crossingOverlay: some View {
        if let msg = crossingMessage {
            VStack {
                Spacer(minLength: 60)
                Text(msg)
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(0.7)
                    .foregroundStyle(Color.gold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .shadow(color: Color.gold.opacity(0.4), radius: 10)
                    .transition(.opacity)
                Spacer()
            }
            .allowsHitTesting(false)
        }
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

    // MARK: - Descent helpers

    private func avarana(for ring: Int) -> Avarana? {
        avaranas.first(where: { $0.ringNumber == ring })
    }

    /// The instrument is fully open: the ring you're in reads as home, every
    /// other is open and immediately enterable on a tap. `DescentState` still
    /// records where you've been — it feeds the Portrait and the Descent Film —
    /// but it never gates entry. No thresholds, no hold-to-cross, nothing unseen.
    private func kind(for ring: Int) -> DescentRowKind {
        ring == currentRing ? .home : .open
    }

    /// Visiting a ring already inside the descent — no crossing, just re-entry.
    private func handleOpen(ring: Int) {
        Haptics.light()
        let crossed = descent?.enter(ring: ring) ?? false
        try? context.save()
        if crossed { Task { await AirtableService.shared.recordCrossing(ring: ring) } }
        onEntry(ring)
    }

    /// Crossing into the next ring — a chosen act. Updates state, fades up the
    /// invitation, then opens the ring.
    private func handleCross(ring: Int) {
        guard let d = descent else { return }
        Haptics.medium()
        let invitation = avarana(for: ring)?.subtitle ?? "The way opens."
        let crossed = d.enter(ring: ring)
        try? context.save()
        if crossed { Task { await AirtableService.shared.recordCrossing(ring: ring) } }

        let appearDur: Double = reduceMotion ? 0.01 : 0.9
        let holdDur:   Double = reduceMotion ? 0.01 : 1.6
        let fadeDur:   Double = reduceMotion ? 0.01 : 1.1

        withAnimation(.easeInOut(duration: appearDur)) {
            crossingMessage = invitation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + appearDur + holdDur) {
            withAnimation(.easeInOut(duration: fadeDur)) { crossingMessage = nil }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + appearDur + holdDur + fadeDur * 0.6) {
            onEntry(ring)
        }
    }
}

// MARK: - Descent kinds

enum DescentRowKind {
    case home        // currentRing
    case open        // reached, revisitable
    case threshold   // deepestReached + 1, content ready, awaiting a chosen crossing
    case becoming    // deepestReached + 1, not yet authored
    case unseen      // beyond the next threshold; not rendered

    var nameOpacity: Double {
        switch self {
        case .home:      return 0.96
        case .open:      return 0.78
        case .threshold: return 0.66
        case .becoming:  return 0.36
        case .unseen:    return 0
        }
    }
    var glyphOpacity: Double {
        switch self {
        case .home:      return 0.95
        case .open:      return 0.70
        case .threshold: return 0.55
        case .becoming:  return 0.22
        case .unseen:    return 0
        }
    }
    var subOpacity: Double {
        switch self {
        case .home:      return 0.62
        case .open:      return 0.50
        case .threshold: return 0.42
        case .becoming:  return 0.28
        case .unseen:    return 0
        }
    }
    var isHomeWash: Bool { self == .home }
}

// MARK: - One row in the descent

private struct DescentRow: View {
    let ring: Int
    let kind: DescentRowKind
    let avarana: Avarana?
    let reduceMotion: Bool
    let onEnter: () -> Void
    let onCross: () -> Void

    private static let romans = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    @State private var holdProgress: CGFloat = 0
    @State private var breath: CGFloat = 0

    var body: some View {
        Group {
            switch kind {
            case .home, .open:
                Button(action: onEnter) { rowBody }
                    .buttonStyle(.plain)
            case .threshold:
                rowBody
                    .scaleEffect(1 + Double(holdProgress) * 0.02)
                    .contentShape(Rectangle())
                    .onLongPressGesture(
                        minimumDuration: 0.9,
                        maximumDistance: 50,
                        perform: completeHold,
                        onPressingChanged: pressingChanged
                    )
                    .onAppear(perform: startBreath)
            case .becoming:
                rowBody
                    .contentShape(Rectangle())
                    .accessibilityLabel("\(displayName). She is still becoming words.")
            case .unseen:
                EmptyView()
            }
        }
    }

    private var rowBody: some View {
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
    }

    private var glyph: some View {
        let breathAmp = (kind == .threshold) ? Double(breath) * 0.3 : 0
        return RingGlyph(ring: ring, color: Color.gold, size: 36)
            .opacity(kind.glyphOpacity + breathAmp)
            .shadow(color: kind.isHomeWash ? Color.gold.opacity(0.45) : .clear,
                    radius: kind.isHomeWash ? 7 : 0)
            .shadow(color: kind == .threshold ? Color.gold.opacity(0.35 * Double(breath)) : .clear,
                    radius: kind == .threshold ? 6 : 0)
    }

    private var nameBlock: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(displayName)
                .font(.custom(AppFont.cormorant, size: 20))
                .tracking(0.6)
                .foregroundStyle(Color.cream.opacity(kind.nameOpacity))
                .lineLimit(1)
                .truncationMode(.tail)

            if let sub = subline {
                Text(sub)
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(0.3)
                    .foregroundStyle(Color.cream.opacity(kind.subOpacity))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            if let summary = formSummary {
                Text(summary)
                    .font(.system(size: 11))
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
            .foregroundStyle(Color.gold)
            .opacity(kind.glyphOpacity)
            .frame(width: 38, alignment: .trailing)
    }

    @ViewBuilder
    private var washBackground: some View {
        if kind.isHomeWash {
            LinearGradient(
                colors: [Color.gold.opacity(0.10), Color.gold.opacity(0.03)],
                startPoint: .leading, endPoint: .trailing
            )
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.gold.opacity(0.26), lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        } else if kind == .threshold {
            // The hold's progress fills the row with gold.
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.gold.opacity(0.18 * Double(holdProgress)))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(Color.gold.opacity(0.20 + 0.35 * Double(breath)), lineWidth: 0.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
    }

    @ViewBuilder
    private var borderBottom: some View {
        if !kind.isHomeWash && kind != .threshold {
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

    private var subline: String? {
        if kind == .becoming {
            return "she is still becoming words"
        }
        if kind == .threshold {
            return "hold to cross"
        }
        return avarana?.subtitle?.isEmpty == false ? avarana?.subtitle : nil
    }

    private var formSummary: String? {
        guard let av = avarana else { return nil }
        let form = av.geometricShape?.trimmingCharacters(in: .whitespaces)
        let pieces = [form?.uppercased()].compactMap { $0 }.filter { !$0.isEmpty }
        return pieces.isEmpty ? nil : pieces.joined(separator: " · ")
    }

    // MARK: - Threshold gesture

    private func pressingChanged(_ pressing: Bool) {
        if pressing {
            Haptics.soft()
            withAnimation(.linear(duration: 0.9)) { holdProgress = 1 }
        } else {
            withAnimation(.easeOut(duration: 0.3)) { holdProgress = 0 }
        }
    }

    private func completeHold() {
        holdProgress = 0
        onCross()
    }

    private func startBreath() {
        guard !reduceMotion else { breath = 0.5; return }
        withAnimation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true)) {
            breath = 1
        }
    }
}

// MARK: - The Bindu footer (Ring IX)

private struct BinduFooter: View {
    let kind: DescentRowKind
    let avarana: Avarana?
    let reduceMotion: Bool
    let onEnter: () -> Void
    let onCross: () -> Void

    @State private var binduPhase: CGFloat = 0
    @State private var holdProgress: CGFloat = 0

    var body: some View {
        Group {
            switch kind {
            case .home, .open:
                Button(action: onEnter) { body(extra: 0) }
                    .buttonStyle(.plain)
            case .threshold:
                body(extra: Double(holdProgress) * 0.25)
                    .scaleEffect(1 + Double(holdProgress) * 0.02)
                    .contentShape(Rectangle())
                    .onLongPressGesture(
                        minimumDuration: 1.1,
                        maximumDistance: 50,
                        perform: { holdProgress = 0; onCross() },
                        onPressingChanged: { p in
                            if p {
                                Haptics.soft()
                                withAnimation(.linear(duration: 1.1)) { holdProgress = 1 }
                            } else {
                                withAnimation(.easeOut(duration: 0.35)) { holdProgress = 0 }
                            }
                        }
                    )
            case .becoming:
                body(extra: -0.4)
                    .accessibilityLabel("The Bindu. She is still becoming words.")
            case .unseen:
                EmptyView()
            }
        }
        .onAppear {
            guard !reduceMotion else { binduPhase = 0.5; return }
            withAnimation(.easeInOut(duration: 2.25).repeatForever(autoreverses: true)) {
                binduPhase = 1
            }
        }
    }

    private func body(extra: Double) -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: Color.gold.opacity(0.45 + extra), location: 0.5),
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
                    .foregroundStyle(Color.gold.opacity(kind.nameOpacity + extra * 0.4))
                    .multilineTextAlignment(.center)
                if let sub = subline {
                    Text(sub)
                        .font(.custom(AppFont.cormorantItalic, size: 14))
                        .tracking(0.4)
                        .foregroundStyle(Color.cream.opacity(kind.subOpacity))
                        .padding(.top, 5)
                }
                Text("The Bindu · IX")
                    .font(.system(size: 11))
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
                    .init(color: Color.accentRed.opacity(0.20 + extra * 0.5), location: 0),
                    .init(color: .clear, location: 1.0)
                ]),
                center: UnitPoint(x: 0.5, y: 0.18),
                startRadius: 0, endRadius: 90
            )
            .allowsHitTesting(false)
        )
        .contentShape(Rectangle())
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
                .opacity(kind == .becoming ? 0.45 : 0.96)
                .shadow(color: Color.cream.opacity(0.6), radius: 6)
        }
        .scaleEffect(scale)
        .opacity(kind == .becoming ? 0.45 : 1.0)
    }

    private var displayName: String {
        if let av = avarana, !av.sanskritName.isEmpty { return av.sanskritName }
        return "9th Avaraṇa"
    }

    private var subline: String? {
        switch kind {
        case .home, .open:
            return avarana?.subtitle?.isEmpty == false ? avarana?.subtitle : nil
        case .threshold:
            return "hold to cross"
        case .becoming:
            return "she is still becoming words"
        case .unseen:
            return nil
        }
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
