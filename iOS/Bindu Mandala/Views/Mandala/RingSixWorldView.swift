import SwiftUI
import SwiftData

/// Ring 6 World — Nigarbha, the Concealed.
///
/// Ten triangles hidden in near-darkness at the center. A soft violet light
/// follows the practitioner's finger; only what is near enough is revealed.
/// Name a revealed one and she whispers — then conceals herself again.
/// *She will not stay.*
struct RingSixWorldView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Shakti.khadgamalaPosition) private var allShaktis: [Shakti]

    @State private var lightPosition: CGPoint = .zero
    @State private var whisper: Int? = nil
    @State private var whisperKey: UUID = UUID()       // forces re-render on each whisper
    @State private var soundOn: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var heartPhase: CGFloat = 0
    @State private var concealTask: Task<Void, Never>? = nil

    private let violet = Color(hex: "#9A86C4")
    private let revealRadius: CGFloat = 92

    /// Reverent glosses — placeholder until per-Shakti quality lines arrive.
    /// Order matches Khaḍgamālā positions 77–86.
    private let glosses: [String] = [
        "made of knowing", "made of power", "sovereign splendour",
        "giver of knowledge", "remover of disease", "the support of all",
        "remover of sorrow", "made of bliss", "the protectress",
        "giver of the fruit"
    ]

    private var ring6Shaktis: [Shakti] {
        Array(allShaktis.filter { $0.ringNumber == 6 }
            .sorted { ($0.khadgamalaPosition ?? 0) < ($1.khadgamalaPosition ?? 0) }
            .prefix(10))
    }

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#0A0710"), location: 0),
                    .init(color: Color(hex: "#050309"), location: 0.55),
                    .init(color: Color(hex: "#020104"), location: 1)
                ]),
                center: UnitPoint(x: 0.5, y: 0.46),
                startRadius: 0, endRadius: 420
            )
            .ignoresSafeArea()

            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy: CGFloat = min(392, geo.size.height * 0.46)
                let positions = (0..<10).map { i -> (a: Double, p: CGPoint, up: Bool) in
                    let a = (Double(i) / 10.0) * 2 * .pi - .pi / 2
                    let p = CGPoint(x: cx + 96 * CGFloat(cos(a)),
                                    y: cy + 96 * CGFloat(sin(a)))
                    return (a, p, i % 2 == 0)
                }

                ZStack {
                    // Ring identity
                    VStack(spacing: 5) {
                        Text("Sarvarakṣākara · the Nigarbhas")
                            .font(.custom(AppFont.cormorantItalic, size: 14))
                            .tracking(2.8)
                            .foregroundStyle(violet.opacity(0.78))
                            .multilineTextAlignment(.center)
                        Text("TEN · CONCEALED, TOO INTERIOR TO BE SPOKEN")
                            .font(.system(size: 10))
                            .tracking(3.0)
                            .foregroundStyle(Color.cream.opacity(0.45))
                    }
                    .position(x: cx, y: 96)
                    .allowsHitTesting(false)

                    // Moving light — soft glow follows finger
                    movingLight
                        .position(lightPosition == .zero
                            ? CGPoint(x: cx, y: cy)
                            : lightPosition)
                        .allowsHitTesting(false)

                    // 10 triangles
                    ForEach(0..<10, id: \.self) { i in
                        triangleStation(at: positions[i].p,
                                        up: positions[i].up,
                                        index: i,
                                        lightPos: lightPosition == .zero
                                            ? CGPoint(x: cx, y: cy)
                                            : lightPosition)
                    }

                    // Protected center heart
                    Circle()
                        .fill(violet)
                        .opacity(0.38 + 0.32 * Double(heartPhase))
                        .frame(width: 6.8, height: 6.8)
                        .position(x: cx, y: cy)
                        .allowsHitTesting(false)

                    // Whisper text
                    whisperBlock
                        .frame(maxWidth: geo.size.width - 72)
                        .position(x: cx, y: geo.size.height - 224)

                    // Hint
                    Text("MOVE THE LIGHT · TOUCH WHAT IT REACHES · SHE WILL NOT STAY")
                        .font(.system(size: 8.5))
                        .tracking(2.6)
                        .foregroundStyle(Color.cream.opacity(0.40))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 24)
                        .position(x: cx, y: geo.size.height - 96)
                        .allowsHitTesting(false)
                }
                .onAppear {
                    if lightPosition == .zero {
                        lightPosition = CGPoint(x: cx, y: cy)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Top 80pt is the dismiss zone — the light-follow
                            // ignores touches starting there so the arc-tap
                            // has a clean path to the touch.
                            guard value.startLocation.y > 80 else { return }
                            withAnimation(.easeInOut(duration: 0.18)) {
                                lightPosition = value.location
                            }
                            updateGain(at: value.location, positions: positions.map { $0.p })
                        }
                        .onEnded { value in
                            guard value.startLocation.y > 80 else { return }
                            withAnimation(.easeInOut(duration: 0.5)) {
                                lightPosition = CGPoint(x: cx, y: cy)
                            }
                            RingAudioService.shared.sustainedVoiceGain(0.004)
                        }
                )
            }
        }
        .contentShape(Rectangle())
        .offset(y: dragOffset)
        // `.simultaneousGesture` so swipeDown isn't blocked by the inner
        // light-follow DragGesture (which has minimumDistance:0).
        .simultaneousGesture(swipeDown)
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
                label: "within",
                color: violet,
                onToggle: toggleSound
            )
            .padding(.leading, 22)
            .padding(.bottom, 50)
        }
        .onAppear {
            ensureSoundStarted()
            startHeart()
        }
        .onDisappear {
            RingAudioService.shared.sustainedVoiceStop()
            concealTask?.cancel()
        }
    }

    // MARK: - Moving light

    private var movingLight: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: violet.opacity(0.16), location: 0),
                .init(color: violet.opacity(0.05), location: 0.40),
                .init(color: .clear, location: 0.70)
            ]),
            center: .center,
            startRadius: 0, endRadius: revealRadius * 2.1
        )
        .frame(width: revealRadius * 4.2, height: revealRadius * 4.2)
    }

    // MARK: - Triangle station

    @ViewBuilder
    private func triangleStation(at point: CGPoint, up: Bool, index: Int, lightPos: CGPoint) -> some View {
        let distance = hypot(point.x - lightPos.x, point.y - lightPos.y)
        let near = max(0.0, Double(1 - distance / revealRadius))
        let isWhisper = (whisper == index)
        let opacity = isWhisper ? 0.95 : near * 0.85

        ZStack {
            if near > 0.3 {
                RingTriangle(size: 13, up: up)
                    .fill(violet.opacity(near * 0.12))
                    .blur(radius: 4)
            }
            RingTriangle(size: 11, up: up)
                .stroke(violet, lineWidth: 0.8)
                .opacity(opacity)
            Circle()
                .fill(isWhisper ? Color.cream : violet)
                .frame(width: 3.6, height: 3.6)
                .opacity(opacity)
        }
        .frame(width: 32, height: 32)
        .contentShape(Rectangle())
        .position(point)
        .onTapGesture {
            tap(index, distance: distance)
        }
        .animation(.easeOut(duration: 0.35), value: opacity)
    }

    // MARK: - Whisper

    @ViewBuilder
    private var whisperBlock: some View {
        if let i = whisper, i < ring6Shaktis.count {
            let s = ring6Shaktis[i]
            VStack(spacing: 6) {
                Text(s.name.isEmpty ? "Concealed \(i + 1)" : s.name)
                    .font(.custom(AppFont.cormorant, size: 32))
                    .tracking(1.6)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                Text(glosses[safeIndex: i] ?? "")
                    .font(.custom(AppFont.cormorantItalic, size: 16))
                    .tracking(0.3)
                    .foregroundStyle(violet.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
            .fixedSize(horizontal: false, vertical: true)
            .id(whisperKey)
            .transition(.opacity.combined(with: .offset(y: 4)))
        } else {
            Text("What is secret because it is too interior to be spoken. Move slowly — the light reveals only what is near.")
                .font(.custom(AppFont.cormorantItalic, size: 19))
                .tracking(0.3)
                .lineSpacing(7)
                .foregroundStyle(Color.cream.opacity(0.55))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
        }
    }

    // MARK: - Interactions

    private func tap(_ i: Int, distance: CGFloat) {
        guard distance <= revealRadius else { return }    // can't name what the light hasn't reached
        Haptics.light()
        whisperKey = UUID()
        withAnimation(.easeInOut(duration: 0.4)) {
            whisper = i
        }
        concealTask?.cancel()
        concealTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.2))
            if Task.isCancelled { return }
            withAnimation(.easeInOut(duration: 0.6)) {
                whisper = nil
            }
        }
    }

    private func updateGain(at lightPos: CGPoint, positions: [CGPoint]) {
        guard soundOn else { return }
        var best: CGFloat = .greatestFiniteMagnitude
        for p in positions {
            let d = hypot(p.x - lightPos.x, p.y - lightPos.y)
            if d < best { best = d }
        }
        let gain: Float
        if best < revealRadius {
            gain = Float(0.05 * (1 - best / revealRadius))
        } else {
            gain = 0.004
        }
        RingAudioService.shared.sustainedVoiceGain(gain)
    }

    private func ensureSoundStarted() {
        guard !soundOn else { return }
        RingAudioService.shared.sustainedVoiceStart(freq: 207.65, vol: 0.02, vibrato: 3)
        soundOn = true
    }

    private func toggleSound() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.sustainedVoiceStop()
            soundOn = false
        } else {
            RingAudioService.shared.sustainedVoiceStart(freq: 207.65, vol: 0.02, vibrato: 3)
            soundOn = true
        }
    }

    private func startHeart() {
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            heartPhase = 1
        }
    }

    private var swipeDown: some Gesture {
        DragGesture()
            .onChanged { v in
                if v.translation.height > 0, abs(v.translation.width) < 30 {
                    // Only collapse to dismiss when the drag is primarily vertical
                    // — otherwise the light-follow gesture takes the drag.
                    dragOffset = v.translation.height * 0.6
                }
            }
            .onEnded { v in
                if v.translation.height > 120 && abs(v.translation.width) < 60 {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.4)) {
                        dragOffset = 0
                    }
                }
            }
    }
}
