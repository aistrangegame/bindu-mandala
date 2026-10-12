import SwiftUI
import UIKit

// MARK: - Wave 6 · B · Panel 9 — the eight dissolutions, then "Now go play."
//
// The Tree of Life's ninth panel is the Bindu inverted: *"Panels 1–8 each asked
// the person to DO something … They were actually building something to
// dissolve."* (`mirror-dissolution-architecture.md`). Here, on the way from
// Lalitā's point into her field, each of the eight rings' declarations — his
// own lines — is shown once more and released by the inverse of the verb that
// built it: pressed → lifted, followed → let go, built → stilled, opened →
// folded in, spoken → silence, stilled → moved, received → offered back,
// held → released. Every gate accepts the gesture broadly (the skill's guard 8:
// it must never feel like it is rejecting the effort), and each has a fallback.
//
// **The dissolution writes nothing.** No ledger row, nothing kept.
// **The naming is the veil.** No Śakti, ring or chakra is named here; only his
// declarations leave, and the point stays.
// **The Om was always playing.** It rises through the eight on its own
// (``SoundConductor/swellOm(_:)``) and falls to nothing with the last words.
// Then the Mirror's recognition and its triangle, verbatim, and the last words
// before Lalitā's field: "Now go play."

@MainActor
struct TheEightDissolutions: View {
    let onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum Stage: Equatable {
        case station(Int)
        case recognition
        case closing(Int)
        case goPlay
        case field
    }

    @State private var stage: Stage = .station(0)
    @State private var stationBegan = Date()
    @State private var lastTouch = Date()
    @State private var touchStart: Date?
    @State private var travelled: CGFloat = 0
    @State private var taps = 0
    @State private var fold: CGFloat = 1
    @State private var releasing = false

    /// The practice day the eight were last walked — a phone-local mark of
    /// the day, never a record (the dissolution writes nothing).
    static let dissolvedDayKey = "dissolved_day"

    private static let ink = Color(red: 0.17, green: 0.17, blue: 0.17)
    private static let paper = Color(red: 0.91, green: 0.89, blue: 0.87)
    private static let point = Color(red: 0.75, green: 0.22, blue: 0.17)

    var body: some View {
        ZStack {
            if stage == .field {
                PlayFieldView(onClose: onClose)
                    .transition(.opacity)
            } else {
                ground
                content
                    .contentShape(Rectangle())
                    .gesture(hands)
                    .simultaneousGesture(pinch)
                    // Leaving is one gesture, never punished (charter law 6).
                    .theEdgeWayOut(onOut: onClose)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 1.4), value: stage)
        .onAppear {
            // The eight are walked once a practice day; after that the field
            // is reached through the last words alone.
            let today = DailyEnergyService.practiceDayIndex()
            let walked = (UserDefaults.standard.object(forKey: Self.dissolvedDayKey) as? Int) == today
            if walked {
                Task { @MainActor in await straightToPlay() }
            } else {
                UserDefaults.standard.set(today, forKey: Self.dissolvedDayKey)
                SoundConductor.shared.swellOm(0)
                beginStation()
            }
        }
        .onDisappear { SoundConductor.shared.swellOm(nil) }
    }

    // MARK: The ground — dark, warming to the panel's own near-white

    /// How far the light has come: through the eight it warms, and at the last
    /// words the ground is the panel's paper.
    private var light: Double {
        switch stage {
        case .station(let i): return 0.1 + 0.6 * Double(i) / 8
        case .recognition: return 0.75
        case .closing: return 0.85
        case .goPlay, .field: return 1
        }
    }

    private var ground: some View {
        ZStack {
            Color(red: 0.03, green: 0.02, blue: 0.03)
            Self.paper.opacity(light)
        }
        .ignoresSafeArea()
        .animation(reduceMotion ? nil : .easeInOut(duration: 3), value: light)
    }

    private var inkColour: Color { light > 0.55 ? Self.ink : Color.cream }

    // MARK: What stands on the glass

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 34) {
            Spacer()
            Circle()
                .fill(Self.point)
                .frame(width: 8, height: 8)
                .shadow(color: Self.point.opacity(0.6), radius: 8)
            switch stage {
            case .station(let i):
                station(i)
            case .recognition:
                line(TreeOfLife.recognition, size: 20)
            case .closing(let i):
                VStack(spacing: 16) {
                    ForEach(0...min(i, TreeOfLife.closing.count - 1), id: \.self) { k in
                        line(TreeOfLife.closing[k], size: 19)
                    }
                }
            case .goPlay, .field:
                line(TreeOfLife.nowGoPlay, size: 26)
            }
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private func line(_ words: String, size: CGFloat) -> some View {
        Text(words)
            .font(AppFont.voice(size))
            .lineSpacing(5)
            .multilineTextAlignment(.center)
            .foregroundStyle(inkColour)
            .transition(.opacity)
    }

    @ViewBuilder
    private func station(_ i: Int) -> some View {
        let d = TreeOfLife.dissolutions[i]
        let words = GameStructure.panel(ring: d.ring)?.declaration ?? ""
        VStack(spacing: 26) {
            TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion || !drifts(d))) { tl in
                let t = tl.date.timeIntervalSince(lastTouch)
                Text(words)
                    .font(AppFont.voice(20))
                    .tracking(d.kind == .foldIn ? 6 * fold : 0)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(inkColour)
                    .offset(x: drifts(d) && !reduceMotion ? CGFloat(min(t, 8) * 22) : 0,
                            y: releasing && d.kind == .offerUp ? -160 : 0)
                    .opacity(releasing ? 0 : 1)
                    .scaleEffect(releasing ? (d.kind == .foldIn ? 0.2 : 1.08) : 1)
                    .blur(radius: releasing ? 8 : 0)
            }
            .id(i)
            Text(d.instruction)
                .font(AppFont.voice(15))
                .foregroundStyle(inkColour.opacity(0.62))
                .opacity(releasing ? 0 : 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAction { release() }
    }

    private func drifts(_ d: TreeOfLife.Dissolution) -> Bool {
        if case .letGo = d.kind { return true }
        return false
    }

    // MARK: The hands

    private var current: TreeOfLife.Dissolution? {
        if case .station(let i) = stage, TreeOfLife.dissolutions.indices.contains(i) {
            return TreeOfLife.dissolutions[i]
        }
        return nil
    }

    private var hands: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                guard let d = current, !releasing else { return }
                if touchStart == nil { touchStart = Date() }
                lastTouch = Date()
                travelled = max(travelled, hypot(v.translation.width, v.translation.height))
                if d.kind == .offerUp, v.translation.height < -80 { release() }
                if d.kind == .move, travelled > 160 { release() }
            }
            .onEnded { _ in
                guard let d = current, !releasing else { touchStart = nil; return }
                let held = touchStart.map { Date().timeIntervalSince($0) } ?? 0
                touchStart = nil
                lastTouch = Date()
                switch d.kind {
                case .lift:
                    release()
                case .holdThenRelease(let s):
                    if held >= s { release() }
                case .offerUp:
                    // The fallback: held until it rises on its own.
                    if held >= 3 { release() }
                case .foldIn:
                    if travelled < 12 {
                        taps += 1
                        withAnimation(.easeOut(duration: 0.4)) { fold = max(0, 1 - CGFloat(taps) / 3) }
                        if taps >= 3 { release() }
                    }
                case .move:
                    if travelled > 160 { release() }
                default:
                    break
                }
                travelled = 0
            }
    }

    private var pinch: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                guard current?.kind == .foldIn, !releasing else { return }
                fold = max(0, min(1, scale))
            }
            .onEnded { scale in
                guard current?.kind == .foldIn, !releasing else { return }
                if scale < 0.8 { release() } else { withAnimation { fold = 1 } }
            }
    }

    // MARK: The sequence

    private func beginStation() {
        stationBegan = Date()
        lastTouch = Date()
        touchStart = nil
        travelled = 0
        taps = 0
        fold = 1
        releasing = false
        guard let d = current else { return }
        Task { @MainActor in await watchTheWaiting(d, began: stationBegan) }
    }

    /// The three stations whose act is not doing: let go (not following the
    /// word), be still (nothing made), silence (the absence is the action).
    private func watchTheWaiting(_ d: TreeOfLife.Dissolution, began: Date) async {
        let seconds: Double
        var touchesReset = true
        switch d.kind {
        case .letGo(let s): seconds = s
        case .beStill(let s): seconds = s
        case .silence(let s): seconds = s; touchesReset = false
        default: return
        }
        while stationBegan == began, !releasing {
            try? await Task.sleep(for: .seconds(0.25))
            guard stationBegan == began, !releasing else { return }
            let from = touchesReset ? max(lastTouch, began) : began
            if touchStart == nil, Date().timeIntervalSince(from) >= seconds {
                release()
                return
            }
        }
    }

    private func release() {
        guard case .station(let i) = stage, !releasing else { return }
        releasing = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 0.8)
        SoundConductor.shared.swellOm(0.15 + 0.6 * Double(i + 1) / 8)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.6 : 1.8))
            if i + 1 < TreeOfLife.dissolutions.count {
                stage = .station(i + 1)
                beginStation()
            } else {
                await closeTheMirror()
            }
        }
    }

    private func straightToPlay() async {
        stage = .goPlay
        try? await Task.sleep(for: .seconds(reduceMotion ? 1.2 : 3))
        stage = .field
    }

    private func closeTheMirror() async {
        let quick = reduceMotion
        stage = .recognition
        SoundConductor.shared.swellOm(1)
        try? await Task.sleep(for: .seconds(quick ? 3 : 7))
        for k in TreeOfLife.closing.indices {
            stage = .closing(k)
            try? await Task.sleep(for: .seconds(quick ? 1.5 : 3))
        }
        try? await Task.sleep(for: .seconds(quick ? 0.5 : 2))
        stage = .goPlay
        // The Om falls away with the last words: the play's own sound takes it.
        SoundConductor.shared.swellOm(0)
        try? await Task.sleep(for: .seconds(quick ? 2 : 5))
        SoundConductor.shared.swellOm(nil)
        stage = .field
    }
}
