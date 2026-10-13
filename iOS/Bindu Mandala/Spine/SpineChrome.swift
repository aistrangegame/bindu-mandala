import SwiftUI

// MARK: - U2 · B · the spine's chrome in every world
//
// `waves/upgrade/worlds/spine-and-home.md` §2 C #36–#37 (the point on every
// world), D #40 and #44 (the Constellation's 2×2 mark and its first-run
// breath). Drawn by the root above whichever world is mounted, so no world
// draws a second point or a second menu. At Home the point is Home's own
// centre (Part A's `ThePoint`), so the spine draws only the mark there.

/// The chrome the root lays on every world: the mark top-left, the point
/// top-right (not at Home).
@MainActor
struct SpineChrome: View {
    let world: WorldID
    /// The root's safe-area size; the chrome is laid in that space, so its
    /// top is already below the status bar.
    let size: CGSize

    /// Both sit on one line just below the status bar: the point at
    /// top 16 / right 16 within the safe area (#36), the mark mirrored at the
    /// left. (Design's "top 62 / left 26" is measured from the phone frame's
    /// top, status bar included.)
    static let inset: CGFloat = 16

    private var y: CGFloat { Self.inset + Hit.min / 2 }

    var body: some View {
        ZStack {
            ConstellationMark()
                .position(x: Self.inset + Hit.min / 2, y: y)
            if world != .home {
                PointHome(world: world)
                    .position(x: size.width - Self.inset - Hit.min / 2, y: y)
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

// MARK: - The point

/// The point on every world but Home — `spine-and-home.md` §2 C #36: 6 pt
/// crimson at .3, top 16 / right 16, a 44 pt target.
///   • tap → Home, crossing through the point;
///   • hold .9 s (the one hold engine) → straight to the source;
///   • double-tap → the one-second practice (Blink · Breathe · Press, #35).
/// It is one point, taking each world's colour over 1.5 s and warming from
/// gold at the surface to ember at the centre (#37; `PointLook`).
@MainActor
struct PointHome: View {
    let world: WorldID

    @Environment(Router.self) private var router
    @StateObject private var hold = HoldDriver(rise: PointHome.holdSeconds)
    @State private var frame: CGRect = .zero
    @State private var pressedAt: Date?
    @State private var moved = false
    @State private var pendingTap: Task<Void, Never>?

    static let hex = "#C0392B"
    static let opacity = 0.3
    static let diameter: CGFloat = 6
    static let target: CGFloat = 44
    /// #36: hold .9 s → the source (the deep zoom's own hold, #27).
    static let holdSeconds: TimeInterval = 0.9
    /// A second tap within this is the double-tap (#35).
    static let doubleTapWindow: TimeInterval = 0.3
    /// Shorter than this, and still, a press is a tap.
    static let tapSeconds: TimeInterval = 0.35

    /// The point as it is in this world: the world's depth colour, 6 pt, at .3.
    private var look: PointLook {
        let w = PointLook.forWorld(world)
        return PointLook(depth: w.depth, core: w.core, halo: nil, coreAlpha: Self.opacity,
                         size: Self.diameter, breath: w.breath, breathPeak: w.breathPeak)
    }

    private var centre: CGPoint { CGPoint(x: frame.midX, y: frame.midY) }

    var body: some View {
        let _ = hold.bind(onCommit: {}, onComplete: { _ = router.toSource(from: centre) })
        ThePoint(look: look)
            .animation(.easeInOut(duration: 1.5), value: world)
            .frame(width: Self.target, height: Self.target)
            .scaleEffect(CGFloat(1 + 0.5 * hold.progress))
            .contentShape(Rectangle())
            .gesture(touch)
            .background(GeometryReader { g in
                Color.clear
                    .onAppear { frame = g.frame(in: .global) }
                    .onChange(of: g.frame(in: .global)) { _, f in frame = f }
            })
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Home, the point"))
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("point.home")
            .accessibilityAction { goHome() }
            .accessibilityAction(named: Text("Fall to the source")) { _ = router.toSource(from: centre) }
            .accessibilityAction(named: Text("One second")) { router.open(place: .oneSecond) }
    }

    /// One touch, read three ways: a still, short press is a tap (and two
    /// within .3 s a double-tap); a press held .9 s is the hold, which acts on
    /// release (the one hold engine — an early release drains, never fails).
    private var touch: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                if pressedAt == nil {
                    pressedAt = Date()
                    moved = false
                    hold.press(.touch)
                }
                let d = hypot(Double(v.translation.width), Double(v.translation.height))
                if d > HoldLadder.cancelDistance, !moved {
                    moved = true
                    hold.cancel()
                }
            }
            .onEnded { _ in
                let held = pressedAt.map { Date().timeIntervalSince($0) } ?? 0
                pressedAt = nil
                let wasCommitted = hold.isCommitted
                hold.release(.touch)
                guard !moved, !wasCommitted, held < Self.tapSeconds else { return }
                tapped()
            }
    }

    private func tapped() {
        if let pending = pendingTap {
            pending.cancel()
            pendingTap = nil
            router.open(place: .oneSecond)
            return
        }
        pendingTap = Task { @MainActor in
            try? await Task.sleep(for: .seconds(Self.doubleTapWindow))
            guard !Task.isCancelled else { return }
            pendingTap = nil
            goHome()
        }
    }

    private func goHome() {
        _ = router.home(via: .bloom(from: centre))
    }
}

// MARK: - The Constellation's mark

/// The 2×2 mark that opens the Constellation from every world (§2 D #40):
/// four dots, the first crimson, a 44 pt target; on the first run it
/// breathes once — 1.6 s up after .6 s, then 1.6 s down — and is never asked
/// about again (#44). Moved from the retired hamburger, whose first-run key
/// it inherits.
@MainActor
struct ConstellationMark: View {
    @Environment(Router.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage(ConstellationMark.seenKey) private var hasSeen: Bool = ConstellationMark.seenBefore
    @State private var breath: CGFloat = 0

    /// §4 "On the phone": `hamburger_first_run_seen` becomes `menu_mark_first_run_seen`.
    static let seenKey = "menu_mark_first_run_seen"
    static let retiredSeenKey = "hamburger_first_run_seen"
    /// The hamburger's breath, once seen, is not breathed again by the mark.
    static var seenBefore: Bool { UserDefaults.standard.bool(forKey: retiredSeenKey) }

    static let crimson = "#C0392B"
    static let dot: CGFloat = 4
    static let gap: CGFloat = 5

    var body: some View {
        Button {
            Haptics.light()
            if !hasSeen { hasSeen = true }
            router.openMenu()
        } label: {
            VStack(spacing: Self.gap) {
                HStack(spacing: Self.gap) {
                    dot(Color(hex: Self.crimson))
                    dot(Color.gold)
                }
                HStack(spacing: Self.gap) {
                    dot(Color.gold)
                    dot(Color.gold)
                }
            }
            .shadow(color: Color.gold.opacity(0.7 * Double(breath)), radius: 6 * breath)
            .frame(width: Hit.min, height: Hit.min)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("The Constellation"))
        .accessibilityHint(Text("Every world"))
        .accessibilityIdentifier("spine.menu.mark")
        .onAppear(perform: firstRunBreath)
    }

    private func dot(_ c: Color) -> some View {
        Circle()
            .fill(c.opacity(0.75 + 0.25 * Double(breath)))
            .frame(width: Self.dot, height: Self.dot)
    }

    private func firstRunBreath() {
        guard !hasSeen, !reduceMotion else { return }
        withAnimation(.easeInOut(duration: 1.6).delay(0.6)) { breath = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeInOut(duration: 1.6)) { breath = 0 }
            hasSeen = true
        }
    }
}
