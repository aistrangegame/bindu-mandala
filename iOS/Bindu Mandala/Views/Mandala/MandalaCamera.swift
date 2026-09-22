import SwiftUI

/// The camera over the Śrī Yantra world — a pure `Animatable` value type. Holds a
/// scale + translation and derives every move (fit, zoom-at-point, fly-to-seat,
/// the descent toward the Bindu) as pure functions, so the whole navigation model
/// is unit-testable off-device. The view layer animates between two cameras and
/// draws the world through `screen(for:)`.
///
/// Screen = `t + (center + world) · scale`, matching the prototype's
/// `translate(tx,ty) scale(s)` over a layer whose origin is the yantra's top-left.
struct MandalaCamera: Equatable, Animatable {
    var scale: CGFloat
    var tx: CGFloat
    var ty: CGFloat

    init(scale: CGFloat, tx: CGFloat, ty: CGFloat) {
        self.scale = scale
        self.tx = tx
        self.ty = ty
    }

    // MARK: Animatable

    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(scale, AnimatablePair(tx, ty)) }
        set {
            scale = newValue.first
            tx = newValue.second.first
            ty = newValue.second.second
        }
    }

    // MARK: Constants

    private static let box = MandalaWorld.box
    private static let center = MandalaWorld.center
    static let minScale: CGFloat = 0.32
    static let maxScale: CGFloat = 5.5

    static func clamp(_ s: CGFloat) -> CGFloat { min(maxScale, max(minScale, s)) }

    // MARK: Coordinate mapping

    /// World point (Bindu at origin) → screen point.
    func screen(for world: CGPoint) -> CGPoint {
        CGPoint(x: tx + (Self.center + world.x) * scale,
                y: ty + (Self.center + world.y) * scale)
    }

    /// Screen point → world point.
    func world(forScreen p: CGPoint) -> CGPoint {
        CGPoint(x: (p.x - tx) / scale - Self.center,
                y: (p.y - ty) / scale - Self.center)
    }

    /// The Bindu's current position on screen (world origin).
    func binduScreen() -> CGPoint { screen(for: .zero) }

    // MARK: Derived moves (all pure)

    /// The whole instrument, centered and fit to the viewport.
    static func fitted(in size: CGSize) -> MandalaCamera {
        let s = clamp(min(size.width, size.height) / box * 0.94)
        return MandalaCamera(scale: s,
                             tx: (size.width - box * s) / 2,
                             ty: (size.height - box * s) / 2)
    }

    /// Zoom by `factor` while keeping the screen point `p` fixed under the finger.
    func zoomed(at p: CGPoint, factor: CGFloat) -> MandalaCamera {
        let ns = Self.clamp(scale * factor)
        let k = ns / scale
        return MandalaCamera(scale: ns,
                             tx: p.x - (p.x - tx) * k,
                             ty: p.y - (p.y - ty) * k)
    }

    /// Pan by a screen-space delta.
    func panned(by d: CGSize) -> MandalaCamera {
        MandalaCamera(scale: scale, tx: tx + d.width, ty: ty + d.height)
    }

    /// The camera that frames a seat: scale 3.0, seat placed a little above center
    /// so the significance card has room below it.
    static func flyTarget(to world: CGPoint, in size: CGSize) -> MandalaCamera {
        let s = clamp(3.0)
        let cx = size.width / 2, cy = size.height * 0.36
        return MandalaCamera(scale: s,
                             tx: cx - (center + world.x) * s,
                             ty: cy - (center + world.y) * s)
    }

    /// The camera that completes the fall into the Bindu before Lalitā emerges.
    static func descentTarget(in size: CGSize) -> MandalaCamera {
        let s = clamp(5.4)
        return MandalaCamera(scale: s,
                             tx: size.width / 2 - center * s,
                             ty: size.height * 0.44 - center * s)
    }

    // MARK: Semantic tier

    /// 0 cosmic (dots only) · 1 named (enclosures + names resolve) · 2 significance
    /// (bīja + meaning bloom).
    var tier: Int {
        if scale < 1.15 { return 0 }
        if scale < 2.3 { return 1 }
        return 2
    }

    /// How far the viewport reaches, in world units — the radius of the world
    /// the glass is currently showing.
    ///
    /// Lifted out of ``enteredRing(in:)`` unchanged, because Phase 5's veil
    /// reads the same quantity to decide how near the walker stands to an
    /// enclosure. Nearness and crossing must never disagree about where she is,
    /// and the surest way to guarantee that is for both to ask one function.
    func viewportRadius(in size: CGSize) -> CGFloat {
        (min(size.width, size.height) * 0.5) / scale
    }

    /// The deepest enclosure the viewport has fallen inside — drives inward-only
    /// ring chimes and the threshold flash. 0 means still outside ring 1.
    func enteredRing(in size: CGSize) -> Int {
        let reachLocal = viewportRadius(in: size)
        var entered = 0
        for r in 1...8 where MandalaWorld.ringRadius(r) > reachLocal { entered = r }
        return entered
    }
}
