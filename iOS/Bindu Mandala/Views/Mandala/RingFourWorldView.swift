import SwiftUI
import SwiftData

/// Ring 4 World — Sampradāya, the Lineage.
///
/// Fourteen forces of tradition arrayed as a garland (mālā). A luminous
/// transmission-light travels station to station 900ms after the view opens,
/// sounding a stepped note as it passes each bead. Once the circuit completes,
/// the garland stays lit — *the teaching is unbroken*.
struct RingFourWorldView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var lit: Int = -1
    @State private var selected: Int? = nil
    @State private var fullyLit: Bool = false
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var transmissionTask: Task<Void, Never>? = nil

    /// One per Ring-4 station — reverent gloss of her name's literal meaning,
    /// flagged as placeholder until Airtable supplies a per-Shakti quality.
    /// Order matches Khaḍgamālā positions 53–66.
    private let glosses: [String] = [
        "the stirring", "the scattering", "the drawing",
        "the gladdening", "the enchanting", "the stilling",
        "the opening", "the mastering", "the colouring",
        "the maddening", "the accomplishing", "the fulfilling",
        "made of mantra", "the perfecting"
    ]

    private let green = Color(hex: "#6FA37E")

    private var ring4Shaktis: [Shakti] {
        Array(allShaktis.filter { $0.ringNumber == 4 }
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
            .prefix(14))
    }

    var body: some View {
        ZStack {
            // Ground
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#07120C"), location: 0),
                    .init(color: Color(hex: "#050B07"), location: 0.55),
                    .init(color: Color(hex: "#040603"), location: 1)
                ]),
                center: UnitPoint(x: 0.5, y: 0.47),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()

            // Green ambient
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: green.opacity(0.10), location: 0),
                    .init(color: .clear, location: 0.74)
                ]),
                center: UnitPoint(x: 0.5, y: 0.47),
                startRadius: 0, endRadius: 380
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy: CGFloat = min(396, geo.size.height * 0.47)
                let R: CGFloat = 150
                let nodes = stationPositions(count: 14, R: R, cx: cx, cy: cy)

                ZStack {
                    // Ring identity
                    VStack(spacing: 5) {
                        Text("Sarvasaubhāgyadāyaka · the Sampradāya")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(2.8)
                            .foregroundStyle(green.opacity(0.78))
                            .multilineTextAlignment(.center)
                        Text("FOURTEEN · THE TEACHING TRAVELS THE LINE")
                            .font(.system(size: 10))
                            .tracking(3.0)
                            .foregroundStyle(Color.cream.opacity(0.45))
                    }
                    .position(x: cx, y: 96)
                    .allowsHitTesting(false)

                    // Garland threads — curved between adjacent stations
                    GarlandPath(nodes: nodes, cx: cx, cy: cy, fullyLit: fullyLit, lit: lit)
                        .stroke(green.opacity(0.55), lineWidth: 1.1)
                        .opacity(fullyLit ? 1 : 0.55)
                        .allowsHitTesting(false)
                    GarlandPath(nodes: nodes, cx: cx, cy: cy, fullyLit: false, lit: -1)
                        .stroke(green.opacity(0.14), lineWidth: 0.5)
                        .allowsHitTesting(false)

                    // 14 station triangles
                    ForEach(0..<14, id: \.self) { i in
                        stationView(at: i, position: nodes[i], up: i % 2 == 0)
                    }

                    // Traveling light
                    if lit >= 0 && lit < nodes.count {
                        travelingLight(at: nodes[lit])
                            .allowsHitTesting(false)
                    }

                    // Center source — tap to send the teaching again
                    centerSource(at: CGPoint(x: cx, y: cy))

                    // Caption
                    captionBlock
                        .frame(maxWidth: geo.size.width - 72)
                        .position(x: cx, y: geo.size.height - 224)

                    // Hint
                    Text("TOUCH A STATION · THE CENTER TO SEND THE TEACHING")
                        .font(.system(size: 8.5))
                        .tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.40))
                        .position(x: cx, y: geo.size.height - 96)
                        .allowsHitTesting(false)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { selected = nil }
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
                label: "lineage",
                color: green,
                onToggle: toggleSound
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
        .onAppear {
            startTransmission(fromTap: false)
        }
        .onDisappear {
            transmissionTask?.cancel()
        }
    }

    // MARK: - Station view

    @ViewBuilder
    private func stationView(at i: Int, position: CGPoint, up: Bool) -> some View {
        let isLit = (lit == i)
        let wasLit = fullyLit || (lit >= 0 && i <= lit)
        let isSelected = (selected == i)
        let opacity: Double = isSelected ? 1.0
            : isLit ? 1.0
            : wasLit ? 0.72
            : 0.30
        ZStack {
            if isLit || isSelected {
                RingTriangle(size: 11, up: up)
                    .fill(green.opacity(0.30))
                    .blur(radius: 5)
            }
            RingTriangle(size: 8.5, up: up)
                .stroke(green, lineWidth: 0.9)
                .opacity(opacity)
            Circle()
                .fill(isLit || isSelected || wasLit ? Color.cream : green)
                .frame(width: (isLit ? 6 : 4), height: (isLit ? 6 : 4))
                .opacity(opacity)
        }
        .frame(width: 30, height: 30)
        .contentShape(Rectangle())
        .position(position)
        .onTapGesture {
            Haptics.light()
            selected = i
        }
        .animation(.easeInOut(duration: 0.4), value: lit)
        .animation(.easeInOut(duration: 0.4), value: selected)
    }

    // MARK: - Traveling light

    @ViewBuilder
    private func travelingLight(at position: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(green.opacity(0.28))
                .frame(width: 34, height: 34)
                .blur(radius: 8)
            Circle()
                .fill(Color.cream.opacity(0.96))
                .frame(width: 8.4, height: 8.4)
                .shadow(color: Color.cream.opacity(0.85), radius: 9)
        }
        .position(position)
        .transition(.opacity)
    }

    // MARK: - Center source

    @ViewBuilder
    private func centerSource(at position: CGPoint) -> some View {
        ZStack {
            Circle()
                .stroke(green.opacity(0.40), lineWidth: 0.6)
                .frame(width: 12, height: 12)
            Circle()
                .fill(green.opacity(0.85))
                .frame(width: 5.2, height: 5.2)
        }
        .frame(width: 44, height: 44)
        .contentShape(Circle())
        .onTapGesture {
            Haptics.light()
            startTransmission(fromTap: true)
        }
        .position(position)
    }

    // MARK: - Caption

    @ViewBuilder
    private var captionBlock: some View {
        if let i = selected, i < ring4Shaktis.count {
            let s = ring4Shaktis[i]
            VStack(spacing: 5) {
                Text(s.name.isEmpty ? "Station \(i + 1)" : s.name)
                    .font(.custom(AppFont.cormorant, size: 34))
                    .tracking(1.7)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                Text(glosses[safeIndex: i] ?? "")
                    .font(.custom(AppFont.cormorantItalic, size: 17))
                    .tracking(0.3)
                    .foregroundStyle(green.opacity(0.85))
                    .multilineTextAlignment(.center)
                Text("THE \(ringOrdinal(i + 1).uppercased()) OF FOURTEEN · RECEIVED, AND PASSED ON")
                    .font(.system(size: 9.5))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .padding(.top, 8)
            }
            .fixedSize(horizontal: false, vertical: true)
            .transition(.opacity)
        } else if fullyLit {
            Text("The garland is unbroken — every name still passed, hand to hand.")
                .font(.custom(AppFont.cormorantItalic, size: 22))
                .tracking(0.3)
                .lineSpacing(6)
                .foregroundStyle(Color.cream.opacity(0.78))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        } else {
            Text("The teaching travels the line — teacher to student, across the generations.")
                .font(.custom(AppFont.cormorantItalic, size: 19))
                .tracking(0.3)
                .lineSpacing(6)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        }
    }

    // MARK: - Transmission

    private func startTransmission(fromTap: Bool) {
        transmissionTask?.cancel()
        selected = nil
        fullyLit = false
        lit = 0

        // Sound is silent during the auto-transmission. Once Ash taps the
        // center to "send the teaching again", subsequent transmissions play.
        let withSound = fromTap

        if withSound, !soundOn {
            soundOn = true
        }

        transmissionTask = Task { @MainActor in
            // 900ms intro delay before the light arrives at station 0
            try? await Task.sleep(for: .seconds(0.9))
            if Task.isCancelled { return }
            lit = 0
            if withSound {
                playNote(for: 0)
            }
            for step in 1..<14 {
                try? await Task.sleep(for: .milliseconds(340))
                if Task.isCancelled { return }
                lit = step
                if withSound {
                    playNote(for: step)
                }
            }
            try? await Task.sleep(for: .milliseconds(340))
            if Task.isCancelled { return }
            fullyLit = true
            lit = -1
        }
    }

    private func playNote(for station: Int) {
        let freq = 174.6 * pow(2.0, Double(station) / 24.0)
        RingAudioService.shared.playSteppedNote(freq: freq, duration: 1.2, volume: 0.05)
    }

    private func toggleSound() {
        Haptics.light()
        soundOn.toggle()
        // Sound is per-transmission; toggle just controls whether future
        // transmissions will fire notes (no continuous tone here).
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

// MARK: - Garland geometry

private func stationPositions(count: Int, R: CGFloat, cx: CGFloat, cy: CGFloat) -> [CGPoint] {
    (0..<count).map { i in
        let a = (Double(i) / Double(count)) * 2 * .pi - .pi / 2
        return CGPoint(x: cx + R * CGFloat(cos(a)),
                       y: cy + R * CGFloat(sin(a)))
    }
}

private struct GarlandPath: Shape {
    let nodes: [CGPoint]
    let cx: CGFloat
    let cy: CGFloat
    let fullyLit: Bool
    let lit: Int

    func path(in rect: CGRect) -> Path {
        var p = Path()
        guard nodes.count > 1 else { return p }
        for i in 0..<nodes.count {
            let a = nodes[i]
            let b = nodes[(i + 1) % nodes.count]
            let isPassed = fullyLit || (lit >= 0 && i < lit)
            // Only include passed segments in this path. Two GarlandPath
            // instances render — one passed (bright), one full circuit (faint).
            if (fullyLit || lit >= 0) ? isPassed : true {
                let mx = (a.x + b.x) / 2
                let my = (a.y + b.y) / 2
                let cxControl = cx + (mx - cx) * 0.84
                let cyControl = cy + (my - cy) * 0.84
                p.move(to: a)
                p.addQuadCurve(to: b, control: CGPoint(x: cxControl, y: cyControl))
            }
        }
        return p
    }
}

// Shared RingTriangle, ringOrdinal, and Array[safeIndex:] live in
// Views/Common/RingShapes.swift so multiple ring worlds can reuse them.
