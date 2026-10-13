import SwiftUI

// MARK: - U1 · Look · the point in every world (visual.md §1.10)
//
// "One particle, never re-made" (law 1). The same point is drawn in all fifteen
// worlds; what changes is its depth — and so its colour (§1.9), its size and
// its breath. At Home it is the slow heart with a white light wandering behind
// it, no pattern, never caught (C-1222, spine-and-home #18); on the Mandala the
// light comes only after stillness — his Tratak, beginning at 20 s and full at
// 45 s, dissolving over .6 s at a touch (mandala-and-rings M12).
//
// U1 builds the view and its look per world. The app-wide overlay that carries
// it across crossings (`PointState`, `matchedGeometryEffect`) and the tap →
// Home / hold → the source wiring are U2's: here the view takes `onTap` and
// `onHold` callbacks. The hold is a plain long press of `holdSeconds` until U2
// moves it onto Part D's one hold engine.

/// How the point looks in one world (§1.10 table). Implements `visual.md` §1.10
/// "The point in every world".
struct PointLook: Equatable {
    /// 0 surface … 1 centre.
    let depth: Double
    /// The core's colour.
    let core: LookColor
    /// The halo's colour (the Bindu's crimson at Home and on the Mandala).
    let halo: LookColor?
    /// The core's alpha (the 33's persistent dot is α .3).
    var coreAlpha: Double = 1
    /// Core diameter, pt.
    let size: CGFloat
    /// Breath period, seconds; nil = held (the caller supplies a clock where
    /// the world's breath is not one number: bīja-locked, inhale-only, follow-light).
    let breath: Double?
    /// The scale the core reaches at the top of its breath.
    var breathPeak: Double = 1.20
    /// Two outer glows, pt (the Well's ember 22 / 48).
    var glow: [CGFloat] = []

    /// The colour of the point at any depth, warming gold → ember (§1.9).
    static func colour(depth: Double) -> LookColor { DepthColour.point(depth: depth) }

    /// The point as it is in `world` at that world's resting depth.
    static func forWorld(_ world: WorldID) -> PointLook {
        switch world {
        case .home:
            return PointLook(depth: 1, core: HouseTokens.ember, halo: HouseTokens.crimson,
                             size: 10, breath: BreathEnclosure.bindu.period, breathPeak: 1.20)
        case .today:
            return PointLook(depth: 0.25, core: colour(depth: 0.25), halo: nil, size: 7, breath: 10)
        case .mandala:
            return mandala(zoomDepth: 0.25)
        case .rings:
            return ring(1)
        case .herHome:
            return PointLook(depth: ringDepth(2), core: colour(depth: ringDepth(2)), halo: nil,
                             size: 7, breath: nil)
        case .herPresence:
            return PointLook(depth: ringDepth(2), core: HouseTokens.ember, halo: nil, size: 6, breath: 3.2)
        case .climb:
            return climb(progress: 0)
        case .the33:
            return PointLook(depth: 0.3, core: HouseTokens.ember, halo: nil, coreAlpha: 0.3,
                             size: 6, breath: 6, breathPeak: 1.09)
        case .game:
            return PointLook(depth: 0, core: HouseTokens.gold, halo: nil, size: 7, breath: 9)
        case .modes:
            return PointLook(depth: 0.2, core: colour(depth: 0.2), halo: nil, size: 7, breath: 6)
        case .time:
            return PointLook(depth: 0.1, core: HouseTokens.gold, halo: nil, size: 7, breath: BreathClock.breath)
        case .memory:
            return PointLook(depth: 0.1, core: LookColor(hex: "#BE5A4E"), halo: nil, size: 6, breath: 8)
        case .well:
            return PointLook(depth: 0.75, core: LookColor(hex: "#F3B05A"), halo: nil, size: 9,
                             breath: nil, glow: [22, 48])
        case .beneath:
            return PointLook(depth: 0.9, core: LookColor(hex: "#7A2F14"), halo: LookColor(hex: "#94472C"),
                             size: 9, breath: nil)
        case .relationship:
            return PointLook(depth: 0, core: LookColor(hex: "#F9E3A7"), halo: nil, size: 7, breath: nil)
        }
    }

    /// Ring n: depth (n − 1)/8, the depth colour, its enclosure's breath.
    static func ring(_ n: Int) -> PointLook {
        let d = ringDepth(n)
        let p = BreathEnclosure.forRing(n)?.period
        return PointLook(depth: d, core: colour(depth: d), halo: nil, size: 7,
                         breath: (p ?? 0) > 0 ? p : nil)
    }

    static func ringDepth(_ n: Int) -> Double { Double(min(max(n, 1), 9) - 1) / 8 }

    /// The Mandala: the Bindu itself, gold → ember with the zoom, 4 s × 1.28.
    static func mandala(zoomDepth: Double) -> PointLook {
        PointLook(depth: zoomDepth, core: colour(depth: zoomDepth), halo: HouseTokens.crimson,
                  size: 10, breath: BreathEnclosure.bindu.period, breathPeak: BreathEnclosure.mandalaBinduPeak)
    }

    /// The Climb: depth climb/30.
    static func climb(progress: Double) -> PointLook {
        let d = min(max(progress / 30, 0), 1)
        return PointLook(depth: d, core: colour(depth: d), halo: nil, size: 7, breath: nil)
    }
}

/// The white light behind the red point. Implements `visual.md` §1.10 with
/// spine-and-home #18 (C-1222) and mandala-and-rings M12 (Tratak).
enum TratakLight: Equatable {
    /// No light (most worlds).
    case off
    /// Always wandering (Home: the origin).
    case always
    /// His Tratak: begins after `onset` seconds of stillness, full at `full`.
    /// `since` is when stillness began (no touch, device still) — the caller
    /// owns the motion sensor; a touch on the point also restarts it.
    case afterStillness(since: Date)

    static let onset: Double = 20
    static let full: Double = 45
    /// Any touch dissolves it over .6 s.
    static let dissolve: Double = 0.6

    /// cream `#F2E8D9` at .55, 9 pt, blur 6, wandering ± 7 pt.
    static let colour = HouseTokens.cream
    static let alpha = 0.55
    static let size: CGFloat = 9
    static let blur: CGFloat = 6
    static let reach: CGFloat = 7

    /// 0…1 — how present the light is after `still` seconds of stillness.
    static func intensity(stillFor still: Double) -> Double {
        min(max((still - onset) / (full - onset), 0), 1)
    }

    /// The path with no pattern: x = sin(.3t)·.6 + cos(.17t)·.4 + sin(.53t + 1.2)·.3,
    /// y = cos(.23t)·.5 + sin(.41t + .7)·.35, in units of `reach`.
    static func offset(at t: Double) -> CGSize {
        let x = sin(0.3 * t) * 0.6 + cos(0.17 * t) * 0.4 + sin(0.53 * t + 1.2) * 0.3
        let y = cos(0.23 * t) * 0.5 + sin(0.41 * t + 0.7) * 0.35
        return CGSize(width: CGFloat(x) * reach, height: CGFloat(y) * reach)
    }
}

/// The one point, as a view. Implements `visual.md` §1.10. Accessible as one
/// element ("The point"); its tap and hold are actions a voice can take.
struct ThePoint: View {
    var look: PointLook
    var light: TratakLight = .off
    var label: String = "The point"
    var onTap: (() -> Void)? = nil
    var onHold: (() -> Void)? = nil
    /// The hold length until U2 moves it onto the one hold engine (Home's deep
    /// zoom is a 0.9 s hold).
    var holdSeconds: Double = ThePoint.defaultHoldSeconds

    static let defaultHoldSeconds: Double = 0.9
    static let identifier = "the.point"

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var lastTouch = Date()
    @State private var lightAtTouch: Double = 0

    private var drawn: CGFloat { look.size * 2.6 }
    private var target: CGFloat { max(Hit.min, drawn, (look.glow.max() ?? 0)) }

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 0.25 : 1.0 / 30.0, paused: false)) { tl in
            let now = tl.date
            ZStack {
                whiteLight(now)
                glows
                halo
                core(now)
            }
        }
        .frame(width: target, height: target)
        .contentShape(Circle())
        .onTapGesture { touched(); onTap?() }
        .onLongPressGesture(minimumDuration: holdSeconds) { touched(); onHold?() }
        .allowsHitTesting(onTap != nil || onHold != nil)
        .accessibilityElement()
        .accessibilityLabel(Text(label))
        .accessibilityAddTraits(onTap != nil ? .isButton : [])
        .accessibilityAction { onTap?() }
        .accessibilityAction(named: Text("Hold")) { onHold?() }
        .accessibilityIdentifier(Self.identifier)
    }

    // MARK: Layers

    private var halo: some View {
        let c = (look.halo ?? look.core).color
        return Circle()
            .fill(RadialGradient(stops: [
                .init(color: c.opacity(look.coreAlpha), location: 0),
                .init(color: c.opacity(0.65 * look.coreAlpha), location: 0.55),
                .init(color: c.opacity(0), location: 1),
            ], center: .center, startRadius: 0, endRadius: drawn / 2))
            .frame(width: drawn, height: drawn)
    }

    @ViewBuilder private var glows: some View {
        ForEach(Array(look.glow.enumerated()), id: \.offset) { _, d in
            Circle()
                .fill(RadialGradient(colors: [look.core.color.opacity(0.35 * look.coreAlpha), .clear],
                                     center: .center, startRadius: 0, endRadius: d / 2))
                .frame(width: d, height: d)
                .blendMode(.plusLighter)
        }
    }

    private func core(_ now: Date) -> some View {
        let b = breathValue(now)
        return ZStack {
            Circle()
                .fill(look.core.color.opacity(look.coreAlpha))
                .frame(width: look.size, height: look.size)
            Circle()
                .fill(HouseTokens.cream.color.opacity(look.coreAlpha))
                .frame(width: look.size * 0.42, height: look.size * 0.42)
                .shadow(color: HouseTokens.cream.color.opacity(0.6 * look.coreAlpha), radius: look.size * 0.6)
        }
        .scaleEffect(b.scale)
        .opacity(b.opacity)
    }

    @ViewBuilder private func whiteLight(_ now: Date) -> some View {
        let i = lightIntensity(now)
        if i > 0 {
            let t = reduceMotion ? 0 : BreathClock.seconds(at: now)
            Circle()
                .fill(TratakLight.colour.color.opacity(TratakLight.alpha * i))
                .frame(width: TratakLight.size, height: TratakLight.size)
                .blur(radius: TratakLight.blur)
                .offset(TratakLight.offset(at: t))
        }
    }

    // MARK: Clocks

    /// The breath on the one epoch. Reduce Motion: no scale, an opacity step
    /// each half-period, period unchanged (§1.13).
    private func breathValue(_ now: Date) -> (scale: CGFloat, opacity: Double) {
        guard let p = look.breath, p > 0 else { return (1, 1) }
        if reduceMotion {
            return (1, ReducedMotion.breathOpacity(at: BreathClock.seconds(at: now), period: p, peak: look.breathPeak))
        }
        let phase = BreathClock.phase(at: now, period: p)
        return (CGFloat(1 + (look.breathPeak - 1) * phase), 1)
    }

    private func lightIntensity(_ now: Date) -> Double {
        let rising: Double
        switch light {
        case .off:
            return 0
        case .always:
            rising = 1
        case .afterStillness(let since):
            let start = max(since, lastTouch)
            let i = TratakLight.intensity(stillFor: now.timeIntervalSince(start))
            rising = reduceMotion ? (i > 0 ? 1 : 0) : i   // Reduce Motion: on / off only
        }
        let sinceTouch = now.timeIntervalSince(lastTouch)
        let fading = reduceMotion ? 0 : lightAtTouch * max(0, 1 - sinceTouch / TratakLight.dissolve)
        return max(rising, fading)
    }

    private func touched() {
        if case .afterStillness = light {
            lightAtTouch = lightIntensity(Date())
        }
        lastTouch = Date()
    }
}
