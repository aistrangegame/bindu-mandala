import SwiftUI

// MARK: - The Veil · the nine āvaraṇas as light
//
// Wave 1 · Slice A. Restored from `veil-mandala.jsx` (*The Veil · The
// Descent*) and `legend-explorations.jsx`, which the July rulings removed with
// the nine worlds (commit 3244f54) and which Design's first audit had called
// *"conceptual integrity made physical"*: a veil of dark ground you pull up
// from below, the yantra dimming behind it but never hidden, and the nine
// āvaraṇas read outside-in as a column — the Bindu its own footer, not a row.
//
// **Status is light, never a lock** — Design's own words, and the reason this
// returns under the first-principles pass. Five luminosities:
//
//     here    fully lit, a gold wash behind the row, the glyph glowing
//     open    glyph and name glow gold, a solid threshold line
//     ground  warm and dimmer — the ground beneath you
//     ahead   veiled behind a scrim, a dashed, uncrossed threshold line
//     veiled  barely there
//
// **What it is read from.** Design's statuses were a progress ladder (home /
// unlocked / locked), and a ladder is exactly what the surviving law refuses:
// nothing grades him or puts him behind. So the light here is read from
// **where he is standing right now** and from nothing he has done — the ring
// the camera has fallen into, or today's ring while he stands outside the
// yantra. Fall inward and the light moves with you: what was ahead becomes
// open, what was open becomes here, what you passed becomes ground. The same
// screen on the first day and the ten-thousandth.
//
// **And nothing is gated.** Every row — ahead and veiled included — is a door:
// tap it and he crosses into that āvaraṇa's own world, the nine rings (U2 —
// never a camera moved several rings at once); the Bindu's footer crosses to
// the ninth. The sheet closes with a tap on the dimmed yantra, a drag down, or
// a tap on its edge, and is never in front of anything the Mandala needs.

/// One āvaraṇa's luminosity in the Veil.
enum VeilLight: String, CaseIterable, Equatable {
    case here, open, ground, ahead, veiled

    /// Design's `LUM.glyph` — how much light the ring's own glyph carries.
    var glyph: Double {
        switch self {
        case .here: return 0.95
        case .open: return 0.85
        case .ground: return 0.60
        case .ahead: return 0.30
        case .veiled: return 0.18
        }
    }

    /// How present the āvaraṇa's name is. Design's `LUM.name` (0.96 → 0.22),
    /// lifted where it fell under FIDELITY's legibility floor: a name is a
    /// word the walker reads, and a word keeps ≥ 0.5 however veiled its ring.
    /// The veil is carried by the glyph, the line and the wash instead.
    var nameAlpha: Double {
        switch self {
        case .here: return 0.96
        case .open: return 0.88
        case .ground: return 0.74
        case .ahead: return 0.62
        case .veiled: return 0.55
        }
    }

    /// The second line's presence — Design's `LUM.sub`, held at the floor.
    var subAlpha: Double {
        switch self {
        case .here: return 0.70
        case .open: return 0.64
        case .ground: return 0.58
        case .ahead: return 0.52
        case .veiled: return 0.50
        }
    }

    /// Whether the glyph stands in a glow (`LUM.glow`).
    var glows: Bool { self == .here || self == .open }
    /// Whether a gold wash stands behind the row (`LUM.wash`).
    var washed: Bool { self == .here }
    /// Whether the threshold line is dashed — not yet crossed on this fall.
    var dashed: Bool { self == .ahead || self == .veiled }

    /// The glyph's colour: gold for the lit, the Bhūpura's amber for the
    /// ground, cream for what is still behind the scrim.
    var accent: Color {
        switch self {
        case .here, .open: return Color.gold
        case .ground: return Color.goldWarm
        case .ahead, .veiled: return Color.cream
        }
    }

    /// What a voice says of it — the light, put into a word.
    var spoken: String {
        switch self {
        case .here: return "You are here."
        case .open: return "Open, just inward."
        case .ground: return "The ground beneath you."
        case .ahead: return "Further in."
        case .veiled: return "Veiled, deep in."
        }
    }
}

enum MandalaVeil {

    /// Roman numerals — Design's carved, temple-like ring index.
    static let roman = ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    /// Where the walker is standing: the enclosure the camera has fallen into,
    /// or — while he stands outside the yantra — the ring today's Śakti sits
    /// in, the day's own home. Present-tense, both of them.
    static func here(entered: Int, todayRing: Int) -> Int {
        if entered >= 1 { return min(entered, 9) }
        return min(max(todayRing, 1), 9)
    }

    /// An āvaraṇa's light, given where the walker stands. Read from position
    /// alone: outward of here is the ground, the next ring in is open, the
    /// deep two are veiled, and the rest are further in.
    static func light(ring: Int, here: Int) -> VeilLight {
        if ring == here { return .here }
        if ring < here { return .ground }
        if ring == here + 1 { return .open }
        if ring >= 8 { return .veiled }
        return .ahead
    }

    /// The āvaraṇa's name — Design's world name, which Airtable's Sanskrit
    /// Name overrides in the Homes; the table's own here.
    static func name(ring: Int) -> String {
        HomeWorlds.world(ring: ring)?.name ?? ""
    }

    /// The second line: what the yantra draws there, in words, and the state
    /// of mind the ring holds.
    static func subtitle(ring: Int) -> String {
        let form = ring < MandalaVoice.enclosureForms.count
            ? MandalaVoice.enclosureForms[ring].capitalizedFirst : ""
        guard let state = HomeWorlds.character(ring: ring)?.state, !state.isEmpty else { return form }
        return "\(form) · \(state)"
    }

    /// What a voice hears for one row — ordinal in words, never a numeral,
    /// and never the word the Mandala's seat layer is found by.
    static func spokenRow(ring: Int, here: Int) -> String {
        let form = ring < MandalaVoice.enclosureForms.count ? MandalaVoice.enclosureForms[ring] : ""
        return "\(MandalaVoice.ordinal(ring).capitalizedFirst) āvaraṇa, "
            + "\(MandalaVoice.romanised(name(ring: ring))), \(form). "
            + light(ring: ring, here: here).spoken
    }
}

// MARK: - U2 · C · the Veil at Design's numbers
//
// `mandala-and-rings.md` §1A "The Veil" (M15, M16) and `spine-and-home.md` §2
// D #42; register 19 §B3 "The Veil" (which measured the Wave 1 build against
// Design and found it wrong on five counts). The sheet is **720 pt** high and
// is always there: at rest only its top **108** shows — the peek *is* the
// sheet's edge (closed offset 612). Drag the handle (or the peek) and the
// sheet follows the finger, clamped 0…612, never animating under it. Let go:
// under **6 pt** of travel it is a tap and toggles; otherwise it snaps open if
// it is past 42 hundredths of its travel (offset < 257.04), else closed — in
// **0.52 s, cubic-bezier(.22, 1, .36, 1)**. The yantra behind dims live with
// it to **0.5 + 0.5 × offset / 612** — never hidden. A row crosses to that
// ring in **the nine rings** world (through the Router); the Bindu's footer
// crosses to the ninth. Nothing moves the camera several rings at once.
//
// On a glass shorter than the sheet, the sheet keeps its peek and stands as
// tall as the glass allows; every number above is taken in proportion.

/// The Veil — the nine āvaraṇas as light, drawn up over the held yantra.
struct MandalaVeilDrawer: View {
    /// Where the walker stands (1…9) — see ``MandalaVeil/here(entered:todayRing:)``.
    let here: Int
    /// The glass the sheet stands on.
    let size: CGSize
    let reduceMotion: Bool
    /// 0 = fully risen; ``closedOffset(in:)`` = resting at its peek.
    @Binding var offset: CGFloat
    /// A row, and where it was touched (the crossing blooms from there).
    let onRing: (Int, CGPoint?) -> Void
    /// The Bindu's footer.
    let onBindu: (CGPoint?) -> Void

    @State private var dragFrom: CGFloat?

    // MARK: Design's numbers

    /// The sheet's height (Design 720).
    static let designHeight: CGFloat = 720
    /// How much of the sheet shows at rest (Design 108 — closed translateY 612).
    static let peek: CGFloat = 108
    /// Movement under this is a tap (Design `< 6`).
    static let tapSlop: CGFloat = 6
    /// Released above this fraction of its travel it opens (Design 257.04 / 612).
    static let snapFraction: CGFloat = 0.42
    /// Design's sheet duration.
    static let seconds: Double = 0.52
    /// What lies behind dims to this when the sheet has fully risen.
    static let dimFloor: Double = 0.5
    /// Design's radius.
    static let radius: CGFloat = 22

    /// The sheet's height on this glass: 720, or the glass less a margin when
    /// the glass is shorter.
    static func height(in size: CGSize) -> CGFloat {
        guard size.height > 0 else { return designHeight }
        return max(peek + 120, min(designHeight, size.height - 24))
    }

    /// Resting offset: the sheet's height less its peek (612 on Design's glass).
    static func closedOffset(in size: CGSize) -> CGFloat {
        height(in: size) - peek
    }

    /// Where a release leaves the sheet: a tap (under 6 pt) toggles from where
    /// it began; a drag snaps open past 0.42 of the travel, else closed.
    static func settle(offset: CGFloat, travelled: CGFloat, from start: CGFloat, closed: CGFloat) -> CGFloat {
        if abs(travelled) < tapSlop {
            return start < closed / 2 ? closed : 0
        }
        return offset < closed * snapFraction ? 0 : closed
    }

    /// The yantra's light behind the sheet: 0.5 + 0.5 × offset / closed.
    static func dim(offset: CGFloat, closed: CGFloat) -> Double {
        guard closed > 0 else { return 1 }
        let k = Double(min(max(offset / closed, 0), 1))
        return dimFloor + (1 - dimFloor) * k
    }

    /// `cubic-bezier(.22, 1, .36, 1)` over 0.52 s; a short fade under reduce motion.
    static func animation(reduceMotion: Bool) -> Animation {
        reduceMotion ? Animation.easeOut(duration: 0.2)
                     : Animation.timingCurve(0.22, 1, 0.36, 1, duration: seconds)
    }

    private var closed: CGFloat { Self.closedOffset(in: size) }
    private var sheetHeight: CGFloat { Self.height(in: size) }
    /// 0 at rest, 1 fully risen.
    private var risen: Double { closed > 0 ? Double(1 - min(max(offset / closed, 0), 1)) : 0 }

    var body: some View {
        VStack(spacing: 0) {
            handle
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(1...8, id: \.self) { ring in
                        VeilRingRow(ring: ring, here: here, onRing: onRing)
                    }
                    VeilBinduFooter(here: here, reduceMotion: reduceMotion, onBindu: onBindu)
                }
                .padding(.horizontal, 18)
                .padding(.top, 4)
                .padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
            .accessibilityHidden(risen < 0.5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: sheetHeight, alignment: .top)
        .background(sheetGround)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: Self.radius, topTrailingRadius: Self.radius))
        .overlay(alignment: .top) {
            UnevenRoundedRectangle(topLeadingRadius: Self.radius, topTrailingRadius: Self.radius)
                .stroke(Color.gold.opacity(0.22), lineWidth: 0.5)
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.7), radius: 30, y: -10)
        .shadow(color: Color.gold.opacity(0.10), radius: 15, y: -1)
        .offset(y: offset)
        // Only the visible part of the sheet takes touches.
        .frame(height: sheetHeight - offset, alignment: .bottom)
        .clipped()
    }

    /// Design's veil: dark ground rising, near-opaque at the foot, a little
    /// translucent at the lip — rgba(13,4,9,.92) → (11,3,7,.985) → (8,2,6,.995).
    private var sheetGround: some View {
        ZStack {
            LinearGradient(stops: [
                               .init(color: Color(red: 13/255, green: 4/255, blue: 9/255).opacity(0.92), location: 0),
                               .init(color: Color(red: 11/255, green: 3/255, blue: 7/255).opacity(0.985), location: 0.3),
                               .init(color: Color(red: 8/255, green: 2/255, blue: 6/255).opacity(0.995), location: 1),
                           ],
                           startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [Color.gold.opacity(0.08), Color.gold.opacity(0)],
                           center: UnitPoint(x: 0.5, y: 0.08 + 0.1 * CGFloat(min(max(here, 1), 9) - 1)),
                           startRadius: 0, endRadius: 260)
        }
    }

    /// The top 108 of the sheet: the handle, the breathing chevron and the
    /// Veil's name at rest, its title and "DESCEND" as it rises. The whole
    /// edge is the drag.
    private var handle: some View {
        VStack(spacing: 10) {
            Capsule()
                .fill(Color.cream.opacity(0.30))
                .frame(width: 40, height: 4)
            VeilBreathingChevron(reduceMotion: reduceMotion, pointsDown: risen > 0.5)
            ZStack {
                Text("THE NINE ĀVARAṆAS")
                    .font(AppFont.label(11.5))
                    .tracking(2.6)
                    .foregroundStyle(Color.gold.opacity(0.62))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .opacity(1 - risen)
                HStack(alignment: .firstTextBaseline) {
                    Text("The Nine Āvaraṇas")
                        .font(AppFont.sanskrit(22))
                        .tracking(0.9)
                        .foregroundStyle(Color.cream)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Spacer(minLength: 8)
                    Text("DESCEND")
                        .font(AppFont.label(11.5))
                        .tracking(1.8)
                        .foregroundStyle(Color.gold.opacity(0.6))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .opacity(risen)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .frame(maxWidth: .infinity, minHeight: Self.peek, maxHeight: Self.peek, alignment: .top)
        .contentShape(Rectangle())
        .gesture(drag)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("The nine āvaraṇas")
        .accessibilityHint(risen > 0.5 ? "Lowers the veil."
                                       : "Raises the veil: the nine āvaraṇas as light, from the ground to the Bindu.")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { toggle() }
        .accessibilityIdentifier("mandala.veil.handle")
    }

    /// The sheet follows the finger (no animation under it); the release
    /// settles by Design's rule.
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { v in
                let start = dragFrom ?? offset
                if dragFrom == nil { dragFrom = offset }
                var t = Transaction()
                t.disablesAnimations = true
                withTransaction(t) {
                    offset = min(max(start + v.translation.height, 0), closed)
                }
            }
            .onEnded { v in
                let start = dragFrom ?? offset
                dragFrom = nil
                let target = Self.settle(offset: offset, travelled: v.translation.height,
                                         from: start, closed: closed)
                if target < closed && start >= closed - 0.5 { Haptics.soft() }
                withAnimation(Self.animation(reduceMotion: reduceMotion)) { offset = target }
            }
    }

    private func toggle() {
        let target: CGFloat = offset < closed / 2 ? closed : 0
        withAnimation(Self.animation(reduceMotion: reduceMotion)) { offset = target }
    }
}

/// Design's peek chevron, breathing every 3.2 s; it turns over once the sheet
/// has risen. Still under reduce motion.
private struct VeilBreathingChevron: View {
    let reduceMotion: Bool
    let pointsDown: Bool

    static let breathSeconds: Double = 3.2

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let b = reduceMotion ? 0 : 0.5 - 0.5 * cos(2 * Double.pi * t / Self.breathSeconds)
            VeilChevron()
                .stroke(Color.gold.opacity(0.5 + 0.2 * b), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                .frame(width: 22, height: 9)
                .shadow(color: Color.gold.opacity(0.5), radius: 4)
                .rotationEffect(.degrees(pointsDown ? 180 : 0))
                .offset(y: CGFloat(-3 * b))
        }
        .frame(width: 22, height: 12)
        .accessibilityHidden(true)
    }
}

/// Design's peek chevron: `M2,7 L11,2 L20,7` in a 22 × 9 box.
struct VeilChevron: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 22, sy = rect.height / 9
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + 2 * sx, y: rect.minY + 7 * sy))
        p.addLine(to: CGPoint(x: rect.minX + 11 * sx, y: rect.minY + 2 * sy))
        p.addLine(to: CGPoint(x: rect.minX + 20 * sx, y: rect.minY + 7 * sy))
        return p
    }
}

// MARK: - The column

/// One āvaraṇa's row: its glyph, name, form · state, and Roman numeral, lit by
/// where he stands. A touch crosses to that ring's own world.
private struct VeilRingRow: View {
    let ring: Int
    let here: Int
    let onRing: (Int, CGPoint?) -> Void

    @State private var frame: CGRect = .zero

    var body: some View {
        let light = MandalaVeil.light(ring: ring, here: here)
        Button { onRing(ring, frame == .zero ? nil : CGPoint(x: frame.midX, y: frame.midY)) } label: {
            HStack(spacing: 16) {
                RingGlyph(ring: ring, color: light.accent, size: 36)
                    .opacity(light.glyph)
                    .shadow(color: light.glows ? Color.gold.opacity(0.55) : Color.clear, radius: 7)
                VStack(alignment: .leading, spacing: 3) {
                    Text(MandalaVeil.name(ring: ring))
                        .font(AppFont.sanskrit(20))
                        .foregroundStyle(Color.cream)
                        .opacity(light.nameAlpha)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text(MandalaVeil.subtitle(ring: ring))
                        .font(AppFont.voice(13))
                        .foregroundStyle(Color.cream)
                        .opacity(light.subAlpha)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    // Wave 6 · where he stands, the ring's own paragraph.
                    if ring == here, let notes = RingFactsCache.facts(ring: ring)?.notes?
                        .trimmingCharacters(in: .whitespacesAndNewlines), !notes.isEmpty {
                        Text(notes)
                            .font(AppFont.voice(12.5))
                            .foregroundStyle(Color.cream.opacity(0.6))
                            .lineLimit(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 3)
                    }
                }
                Spacer(minLength: 0)
                Text(MandalaVeil.roman[ring])
                    .font(AppFont.sanskrit(19))
                    .foregroundStyle(Color.gold)
                    .opacity(max(light.glyph, 0.5))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(minWidth: 30, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .frame(minHeight: 44)
            .background(rowWash(light))
            .overlay(alignment: .bottom) { thresholdLine(light) }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(GeometryReader { g in
            Color.clear
                .onAppear { frame = g.frame(in: .global) }
                .onChange(of: g.frame(in: .global)) { _, f in frame = f }
        })
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MandalaVeil.spokenRow(ring: ring, here: here))
        .accessibilityHint("Crosses into this āvaraṇa.")
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("mandala.veil.ring.\(ring)")
    }

    @ViewBuilder
    private func rowWash(_ light: VeilLight) -> some View {
        if light.washed {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(LinearGradient(colors: [Color.gold.opacity(0.12), Color.gold.opacity(0.03)],
                                     startPoint: .leading, endPoint: .trailing))
                .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.gold.opacity(0.26), lineWidth: 0.5))
        } else {
            Color.clear
        }
    }

    /// The threshold under each row: solid where the light already stands,
    /// dashed where he has not yet crossed.
    private func thresholdLine(_ light: VeilLight) -> some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 1)
            .overlay(
                VeilThresholdLine()
                    .stroke(light.dashed ? Color.cream.opacity(0.13) : Color.gold.opacity(0.16),
                            style: StrokeStyle(lineWidth: 0.5, dash: light.dashed ? [3, 3] : []))
            )
            .padding(.horizontal, 10)
            .allowsHitTesting(false)
    }
}

/// Ring IX — the Bindu as the column's destination, not a row.
private struct VeilBinduFooter: View {
    let here: Int
    let reduceMotion: Bool
    let onBindu: (CGPoint?) -> Void

    @State private var frame: CGRect = .zero

    var body: some View {
        let light = MandalaVeil.light(ring: 9, here: here)
        Button { onBindu(frame == .zero ? nil : CGPoint(x: frame.midX, y: frame.midY)) } label: {
            VStack(spacing: 0) {
                LinearGradient(colors: [Color.gold.opacity(0), Color.gold.opacity(0.45), Color.gold.opacity(0)],
                               startPoint: .leading, endPoint: .trailing)
                    .frame(height: 0.5)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 26)
                VeilBinduPoint(reduceMotion: reduceMotion, lit: light == .here)
                    .padding(.bottom, 18)
                Text(MandalaVeil.name(ring: 9))
                    .font(AppFont.sanskrit(24))
                    .tracking(1.1)
                    .foregroundStyle(Color.gold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(HomeWorlds.character(ring: 9)?.state ?? "")
                    .font(AppFont.voice(14))
                    .foregroundStyle(Color.cream.opacity(0.62))
                    .padding(.top, 5)
                Text("THE BINDU · IX")
                    .font(AppFont.label(11.5))
                    .tracking(2.6)
                    .foregroundStyle(Color.gold.opacity(0.6))
                    .padding(.top, 12)
            }
            .padding(.top, 14)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .background(
                RadialGradient(colors: [Color.accentRed.opacity(0.22), Color.accentRed.opacity(0)],
                               center: UnitPoint(x: 0.5, y: 0.35), startRadius: 0, endRadius: 110)
                    .allowsHitTesting(false))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(GeometryReader { g in
            Color.clear
                .onAppear { frame = g.frame(in: .global) }
                .onChange(of: g.frame(in: .global)) { _, f in frame = f }
        })
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Ninth āvaraṇa, the Bindu. \(light.spoken)")
        .accessibilityHint("Crosses into the ninth āvaraṇa.")
        .accessibilityAddTraits(.isButton)
    }
}

/// A horizontal line across its box, for the threshold under a row.
private struct VeilThresholdLine: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }
}

/// The Bindu at the foot of the Veil: the red point with its cream core,
/// breathing on the Bindu's own 4 s and ×1.28 — the same breath it has at the
/// centre of the yantra, so the signature glyph keeps one rhythm everywhere
/// (Design's audit: *"the bindu's breath isn't unified"*).
private struct VeilBinduPoint: View {
    let reduceMotion: Bool
    let lit: Bool

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let s = MandalaBreath.binduScale(at: t, reduceMotion: reduceMotion)
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color.accentRed.opacity(lit ? 0.55 : 0.4), Color.accentRed.opacity(0)],
                                         center: .center, startRadius: 0, endRadius: 30))
                    .frame(width: 60, height: 60)
                    .blendMode(.plusLighter)
                Circle()
                    .fill(RadialGradient(stops: [
                                             .init(color: Color.accentRed, location: 0),
                                             .init(color: Color.accentRed.opacity(0.65), location: 0.55),
                                             .init(color: Color.accentRed.opacity(0), location: 1),
                                         ],
                                         center: .center, startRadius: 0, endRadius: 13))
                    .frame(width: 26, height: 26)
                Circle()
                    .fill(Color.cream.opacity(0.96))
                    .frame(width: 10, height: 10)
                    .shadow(color: Color.cream.opacity(0.6), radius: 6)
            }
            .scaleEffect(CGFloat(s))
        }
        .frame(width: 60, height: 60)
        .accessibilityHidden(true)
    }
}
