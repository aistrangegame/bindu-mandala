import SwiftUI

// MARK: - Wave 6.1 · one "ways in" mark (the Mandala carries three quiet controls)
//
// Gameplan §1: *"If all 36 games, 33 rooms, 8 modes, 4 doors and 3 toggles
// appear as buttons, the instrument becomes a menu."* The answer has three
// parts, and this file is the second: **the Mandala carries at most three quiet
// controls — sound, the Veil handle and one "ways in" mark.**
//
// The five slices each added a switch to the Mandala's glass: Wave 3's ✦
// constellation and ☉ Road, Wave 6 C's ◌ mode door, and the zoom column that
// was already there. They are folded here into one mark. Touched, it opens a
// small quiet ring of ways round itself — the constellation, the Road, the
// modes, Lalitā's field, the Climb, and the whole yantra again — and closes
// on the next touch, anywhere. Nothing in the ring is a list of contents: each
// is a *way*, and what it leads to is found where it lives (a game at its
// address, a room at its light, a mode at its hour).
//
// Pinch and double-tap still fall in and rise out on the glass; a voice has
// the same as named actions on the mark itself, so nothing a finger can do is
// lost to VoiceOver.

/// The ways the mark opens, in the ring's order (from beside the mark,
/// sweeping down).
enum WayIn: String, CaseIterable, Identifiable, Equatable {
    case constellation
    case road
    case modes
    case field
    case climb
    case whole

    var id: String { rawValue }

    /// The glyph in the ring — the same marks the slices drew on the glass.
    var glyph: String {
        switch self {
        case .constellation: return "✦"
        case .road:          return "☉"
        case .modes:         return "◌"
        case .field:         return "✧"
        case .climb:         return "⇡"
        case .whole:         return "⤢"
        }
    }

    /// The one quiet word under the glyph.
    var word: String {
        switch self {
        case .constellation: return "the chakras"
        case .road:          return "the road"
        case .modes:         return "the modes"
        case .field:         return "her field"
        case .climb:         return "the climb"
        case .whole:         return "the whole"
        }
    }

    /// What a voice hears. The constellation and the Road keep the labels
    /// their own switches carried (Wave 3), so a walker who knew them by ear
    /// still finds them.
    func spoken(constellationOn: Bool, walking: Bool) -> String {
        switch self {
        case .constellation:
            return constellationOn ? "Hide the thirty-three chakras" : "Show the thirty-three chakras"
        case .road:          return walking ? "Leave the road" : "Walk the road"
        case .modes:         return TheModes.doorLabel
        case .field:         return "Lalitā's field — every game, gathered"
        case .climb:         return "Rise through the nine"
        case .whole:         return "The whole yantra"
        }
    }

    var hint: String {
        switch self {
        case .constellation: return "Draws the chakras as light at their places in the yantra."
        case .road:          return "The thirty-three in their order, from the centre out and home again."
        case .modes:         return "Darśana, Sādhana, Smṛti, Svapna and Pūjā."
        case .field:         return "Every game, gathered at the point."
        case .climb:         return "The body, rising, from the enclosure you stand in."
        case .whole:         return "Returns to the whole instrument."
        }
    }
}

/// A way asked for from somewhere other than the Mandala — Lalitā's field's
/// quiet way to the Road. The shell turns to the Mandala, and the Mandala takes
/// the way once it stands (`take()` empties the request, so it is taken once).
enum MandalaWays {
    static let notification = Notification.Name("BinduMandalaWayAsked")
    private(set) static var pending: WayIn?

    static func ask(_ way: WayIn) {
        pending = way
        NotificationCenter.default.post(name: notification, object: way.rawValue)
    }

    static func take() -> WayIn? {
        defer { pending = nil }
        return pending
    }
}

enum WaysInRing {
    /// The mark's own name, for a voice and for the suites.
    static let markLabel = "Ways in"
    static let markGlyph = "✶"
    /// How far the ring stands from the mark.
    static let radius: CGFloat = 150
    /// The ring sweeps from straight left of the mark (180°) to straight
    /// beneath it (90°), so from the top-trailing column it opens into the
    /// glass and never off its edge.
    static func angle(index i: Int, of n: Int) -> Double {
        guard n > 1 else { return .pi }
        return .pi - (.pi / 2) * Double(i) / Double(n - 1)
    }

    static func point(index i: Int, of n: Int, around centre: CGPoint) -> CGPoint {
        let a = angle(index: i, of: n)
        return CGPoint(x: centre.x + radius * CGFloat(cos(a)),
                       y: centre.y + radius * CGFloat(sin(a)))
    }
}

/// The ring itself, laid over the Mandala while the mark is open.
struct WaysInRingView: View {
    /// Where the mark stands, in this view's coordinates.
    let centre: CGPoint
    let constellationOn: Bool
    let walking: Bool
    let reduceMotion: Bool
    let onChoose: (WayIn) -> Void
    let onClose: () -> Void

    @State private var open = false

    var body: some View {
        ZStack {
            // The glass dims a little; a touch anywhere closes the ring.
            Color.black.opacity(open ? 0.35 : 0)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { onClose() }
                .accessibilityHidden(true)
            let ways = WayIn.allCases
            ForEach(Array(ways.enumerated()), id: \.element.id) { i, way in
                let p = WaysInRing.point(index: i, of: ways.count, around: centre)
                Button {
                    Haptics.light()
                    onChoose(way)
                } label: {
                    VStack(spacing: 2) {
                        Text(way.glyph)
                            .font(AppFont.label(17))
                            .foregroundStyle(active(way) ? Color.gold : Color.cream.opacity(0.8))
                            .frame(minWidth: 46, minHeight: 46)
                            .background(Circle().fill(Color.black.opacity(0.4)))
                            .overlay(Circle().stroke(active(way) ? Color.gold : Color.cream.opacity(0.3),
                                                     lineWidth: 1))
                        Text(way.word)
                            .font(AppFont.label(11))
                            .tracking(1.3)
                            .foregroundStyle(Color.cream.opacity(0.62))
                            .fixedSize()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(way.spoken(constellationOn: constellationOn, walking: walking))
                .accessibilityHint(way.hint)
                .position(open ? p : centre)
                .opacity(open ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(reduceMotion ? .easeOut(duration: 0.15)
                                       : .spring(response: 0.42, dampingFraction: 0.86)) { open = true }
        }
    }

    private func active(_ way: WayIn) -> Bool {
        (way == .constellation && constellationOn) || (way == .road && walking)
    }
}
