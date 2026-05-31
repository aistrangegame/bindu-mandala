import SwiftUI

/// Ring 8 World — the Mūla Trikoṇa teaching arc.
/// Four states: triangle → collapsed (icchaa / jnaana / kriyaa) → dissolved → triangle.
/// Each transition uses a 1.4s ease — the teaching is ceremonial.
struct RingEightWorldView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var state: MulaState = .triangle
    @State private var dragOffset: CGFloat = 0

    @State private var soundOn: Bool = false

    private let R: CGFloat = 132
    private let triangleY: CGFloat = 330

    private struct Vertex {
        let name: String
        let english: String
        let sub: String
        let color: Color
    }

    private let vertices: [Vertex] = [
        .init(name: "Icchā", english: "Will",
              sub: "the wanting before want has an object",
              color: Color(hex: "#C45050")),
        .init(name: "Jñāna", english: "Knowledge",
              sub: "the knowing before knowledge has content",
              color: Color(hex: "#9A8FC4")),
        .init(name: "Kriyā", english: "Action",
              sub: "the doing before doing has direction",
              color: Color(hex: "#5A9A8B")),
    ]

    enum MulaState: Equatable {
        case triangle
        case collapsed(Int)  // 0/1/2 → Icchā / Jñāna / Kriyā
        case dissolved

        var isCollapsed: Bool { if case .collapsed = self { return true }; return false }
        var collapsedIndex: Int? { if case .collapsed(let i) = self { return i }; return nil }
    }

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .offset(y: dragOffset)
            .gesture(swipeDown)
            .overlay(alignment: .bottomLeading) {
                RingSoundDot(
                    isOn: $soundOn,
                    label: "three",
                    color: Color.gold,
                    onToggle: toggleSound
                )
                .padding(.leading, 22)
                .padding(.bottom, 50)
            }
            .onChange(of: state) { _, newState in
                applyAudio(for: newState)
            }
            .onDisappear {
                RingAudioService.shared.r8Stop()
            }
    }

    /// Set the triad's audio to match the current state. Lazy-starts the
    /// triad on the first state change; if no sound toggle is active, the
    /// gain stays silent.
    private func applyAudio(for state: MulaState) {
        if soundOn {
            ensureTriadStarted()
        }
        guard soundOn else { return }
        switch state {
        case .triangle:
            RingAudioService.shared.r8Set(.triad)
        case .collapsed(let i):
            RingAudioService.shared.r8Set(.vertex(i))
        case .dissolved:
            RingAudioService.shared.r8Set(.bindu)
        }
    }

    private func ensureTriadStarted() {
        RingAudioService.shared.r8Start()
    }

    private func toggleSound() {
        Haptics.light()
        if soundOn {
            RingAudioService.shared.r8Stop()
            soundOn = false
        } else {
            RingAudioService.shared.r8Start()
            soundOn = true
            applyAudio(for: state)
        }
    }

    private var content: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = triangleY
            let verts = vertexPositions(cx: cx, cy: cy)

            ZStack {
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0A0608"), location: 0),
                        .init(color: Color(hex: "#020001"), location: 1)
                    ]),
                    center: UnitPoint(x: 0.5, y: 0.4),
                    startRadius: 0, endRadius: 600
                )
                .ignoresSafeArea()

                DustMotesView(count: 4)
                    .allowsHitTesting(false)

                returnArcLight(width: geo.size.width)
                    .allowsHitTesting(false)

                Text("Sarvasiddhiprada · the Mūla Trikoṇa")
                    .font(.custom(AppFont.cormorantItalic, size: 13))
                    .tracking(2.3)
                    .foregroundStyle(Color.cream.opacity(0.55))
                    .position(x: cx, y: 100)
                    .allowsHitTesting(false)

                // Triangle line — ghosts when collapsed, hidden when dissolved
                trianglePath(verts: verts)
                    .stroke(Color.cream.opacity(triangleOpacity),
                            style: StrokeStyle(lineWidth: 1, lineJoin: .round))
                    .opacity(triangleOpacity)
                    .allowsHitTesting(false)

                // Collapse dashed lines — only in collapsed states
                if let chosen = state.collapsedIndex {
                    collapseDashedLines(verts: verts, chosen: chosen)
                        .allowsHitTesting(false)
                }

                // Vertices — hidden when dissolved
                ForEach(0..<3, id: \.self) { i in
                    vertexNode(at: i, position: verts[i])
                }

                // Central bindu — swells huge when dissolved
                centralBindu()
                    .position(x: cx, y: cy)
                    .allowsHitTesting(false)

                // State-specific overlays
                switch state {
                case .triangle:
                    triangleStateOverlay(verts: verts, width: geo.size.width)
                case .collapsed(let i):
                    collapsedStateOverlay(meta: vertices[i], width: geo.size.width)
                case .dissolved:
                    dissolvedStateOverlay(width: geo.size.width)
                }
            }
            .animation(.easeInOut(duration: 1.4), value: state)
        }
    }

    // MARK: - Vertex layout & nodes

    private func vertexPositions(cx: CGFloat, cy: CGFloat) -> [CGPoint] {
        let h = R * sqrt(3) / 2
        let half = R / 2
        return [
            CGPoint(x: cx, y: cy - R),               // 0 — Icchā (apex)
            CGPoint(x: cx - h, y: cy + half),        // 1 — Jñāna (bottom-left)
            CGPoint(x: cx + h, y: cy + half),        // 2 — Kriyā (bottom-right)
        ]
    }

    private func vertexNode(at i: Int, position: CGPoint) -> some View {
        let meta = vertices[i]
        let isChosen = (state.collapsedIndex == i)
        let isDissolved = (state == .dissolved)
        let isCollapsed = state.isCollapsed
        let opacity: Double = {
            if isDissolved { return 0 }
            if isCollapsed && !isChosen { return 0.22 }
            return 1.0
        }()
        let haloR: CGFloat = isChosen ? 24 : 12
        let fillR: CGFloat = isChosen ? 7 : 5
        let coreR: CGFloat = isChosen ? 3 : 2

        return ZStack {
            Circle()
                .fill(meta.color.opacity(0.20))
                .frame(width: haloR * 2, height: haloR * 2)
                .blur(radius: 8)
            Circle()
                .fill(meta.color)
                .frame(width: fillR * 2, height: fillR * 2)
            Circle()
                .fill(Color.cream)
                .frame(width: coreR * 2, height: coreR * 2)
        }
        .opacity(opacity)
        .frame(width: 56, height: 56)
        .contentShape(Circle())
        .onTapGesture {
            if state == .triangle {
                Haptics.medium()
                state = .collapsed(i)
            }
        }
        .position(position)
        .allowsHitTesting(!isDissolved)
    }

    // MARK: - Triangle + dashed lines

    private var triangleOpacity: Double {
        switch state {
        case .triangle: return 0.85
        case .collapsed: return 0.10
        case .dissolved: return 0
        }
    }

    private func trianglePath(verts: [CGPoint]) -> Path {
        var p = Path()
        p.move(to: verts[0])
        p.addLine(to: verts[1])
        p.addLine(to: verts[2])
        p.closeSubpath()
        return p
    }

    private func collapseDashedLines(verts: [CGPoint], chosen: Int) -> some View {
        let target = verts[chosen]
        let others = (0..<3).filter { $0 != chosen }
        return ZStack {
            ForEach(others, id: \.self) { i in
                Path { p in
                    p.move(to: verts[i])
                    p.addLine(to: target)
                }
                .stroke(vertices[chosen].color.opacity(0.55),
                        style: StrokeStyle(lineWidth: 0.5, dash: [2, 5]))
            }
        }
    }

    // MARK: - Central bindu

    private func centralBindu() -> some View {
        let isDissolved = (state == .dissolved)
        let outerR: CGFloat = isDissolved ? 52 : 7
        let creamR: CGFloat = isDissolved ? 20 : 3
        return ZStack {
            Circle()
                .fill(Color.accentRed)
                .opacity(isDissolved ? 0.92 : 0.7)
                .frame(width: outerR * 2, height: outerR * 2)
                .shadow(color: Color.accentRed.opacity(isDissolved ? 0.8 : 0.4),
                        radius: isDissolved ? 44 : 8)
            Circle()
                .fill(Color.cream)
                .opacity(isDissolved ? 1.0 : 0.9)
                .frame(width: creamR * 2, height: creamR * 2)
                .shadow(color: Color.cream.opacity(isDissolved ? 0.95 : 0.7),
                        radius: isDissolved ? 24 : 4)
        }
    }

    // MARK: - State-specific overlays

    @ViewBuilder
    private func triangleStateOverlay(verts: [CGPoint], width: CGFloat) -> some View {
        // Vertex labels
        ForEach(0..<3, id: \.self) { i in
            let meta = vertices[i]
            let dy: CGFloat = i == 0 ? -36 : 30
            let dx: CGFloat = i == 0 ? 0 : (i == 1 ? -10 : 10)
            VStack(spacing: 3) {
                Text(meta.name)
                    .font(.custom(AppFont.cormorantItalic, size: 24))
                    .tracking(0.96)
                    .foregroundStyle(meta.color)
                    .shadow(color: meta.color.opacity(0.5), radius: 14)
                Text(meta.english.uppercased())
                    .font(.system(size: 10))
                    .tracking(2.0)
                    .foregroundStyle(Color.cream.opacity(0.55))
            }
            .position(x: verts[i].x + dx, y: verts[i].y + dy)
            .allowsHitTesting(false)
        }

        // Teaching block below
        VStack(spacing: 22) {
            Text("The root triangle.\nWill, knowledge, action —\none undivided power.")
                .font(.custom(AppFont.cormorantItalic, size: 21))
                .tracking(0.4)
                .lineSpacing(8)
                .foregroundStyle(Color.cream.opacity(0.72))
                .multilineTextAlignment(.center)

            Rectangle()
                .fill(Color.cream.opacity(0.22))
                .frame(width: 36, height: 0.5)

            Text("TAP A VERTEX")
                .font(.system(size: 10))
                .tracking(3.2)
                .foregroundStyle(Color.cream.opacity(0.50))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 36)
        .position(x: width / 2, y: 600)
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func collapsedStateOverlay(meta: Vertex, width: CGFloat) -> some View {
        VStack(spacing: 0) {
            Button(action: dissolve) {
                Text(meta.name)
                    .font(.custom(AppFont.cormorantItalic, size: 76))
                    .tracking(3.8)
                    .foregroundStyle(meta.color)
                    .shadow(color: meta.color.opacity(0.66), radius: 40)
                    .padding(.bottom, 14)
            }
            .buttonStyle(.plain)

            Text(meta.english.uppercased())
                .font(.system(size: 11))
                .tracking(3.5)
                .foregroundStyle(Color.cream.opacity(0.55))
                .padding(.bottom, 32)

            Text(meta.sub)
                .font(.custom(AppFont.cormorantItalic, size: 19))
                .tracking(0.3)
                .lineSpacing(9)
                .foregroundStyle(Color.cream.opacity(0.66))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .padding(.bottom, 36)

            Text("THE OTHER TWO HAVE COLLAPSED IN")
                .font(.system(size: 10))
                .tracking(2.7)
                .foregroundStyle(Color.cream.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .position(x: width / 2, y: 620)
    }

    @ViewBuilder
    private func dissolvedStateOverlay(width: CGFloat) -> some View {
        ZStack {
            // Tap-anywhere catcher (behind text)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { reset() }

            VStack(spacing: 0) {
                Text("The three were never three.")
                    .font(.custom(AppFont.cormorantItalic, size: 38))
                    .tracking(1.5)
                    .lineSpacing(8)
                    .foregroundStyle(Color.cream)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 28)

                Rectangle()
                    .fill(Color.gold.opacity(0.4))
                    .frame(width: 40, height: 0.5)
                    .padding(.bottom, 28)

                Text("Will, knowing, doing — three motions of the same hand. The hand was always whole.")
                    .font(.custom(AppFont.cormorantItalic, size: 18))
                    .tracking(0.4)
                    .lineSpacing(10)
                    .foregroundStyle(Color.cream.opacity(0.50))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                    .padding(.bottom, 44)

                Text("TAP TO BEGIN AGAIN")
                    .font(.system(size: 10))
                    .tracking(3.2)
                    .foregroundStyle(Color.cream.opacity(0.50))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 36)
            .position(x: width / 2, y: 620)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
    }

    // MARK: - Actions

    private func dissolve() {
        Haptics.soft()
        state = .dissolved
    }

    private func reset() {
        Haptics.light()
        state = .triangle
    }

    // MARK: - Return arc + swipe

    private func returnArcLight(width: CGFloat) -> some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: 11))
            p.addQuadCurve(to: CGPoint(x: 80, y: 11),
                           control: CGPoint(x: 40, y: 3))
        }
        .stroke(Color.cream.opacity(0.25),
                style: StrokeStyle(lineWidth: 0.7, lineCap: .round))
        .frame(width: 80, height: 14)
        .position(x: width / 2, y: 60)
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
