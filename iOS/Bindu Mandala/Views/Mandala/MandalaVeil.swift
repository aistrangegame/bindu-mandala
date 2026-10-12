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
// tap it and the camera falls to that āvaraṇa through the same continuous
// space; tap the Bindu and the descent opens. The layer is optional, closes
// with a tap on the dimmed yantra, a swipe down, or the handle, and is never
// in front of anything the Mandala needs.

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

// MARK: - The handle, at rest

/// The peek: a single breathing chevron and the Veil's name, low on the glass —
/// *"there is more below"*. Tap it, or swipe it up, and the Veil rises.
struct MandalaVeilPeek: View {
    let reduceMotion: Bool
    let onOpen: () -> Void
    @State private var lifted = false

    var body: some View {
        Button(action: onOpen) {
            VStack(spacing: 7) {
                VeilChevron()
                    .stroke(Color.gold.opacity(0.62), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                    .frame(width: 22, height: 9)
                    .shadow(color: Color.gold.opacity(0.5), radius: 4)
                    .offset(y: lifted ? -3 : 0)
                Text("THE NINE ĀVARAṆAS")
                    .font(AppFont.label(11.5))
                    .tracking(2.6)
                    .foregroundStyle(Color.gold.opacity(0.62))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 8)
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("The nine āvaraṇas")
        .accessibilityHint("Raises the veil: the nine āvaraṇas as light, from the ground to the Bindu.")
        .simultaneousGesture(
            DragGesture(minimumDistance: 12)
                .onEnded { v in if v.translation.height < -24 { onOpen() } })
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) { lifted = true }
        }
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

// MARK: - The Veil, risen

/// The sheet itself: the nine as a descending column of light, Ring I at the
/// top, the Bindu as its footer.
struct MandalaVeilSheet: View {
    /// Where the walker stands (1…9) — see ``MandalaVeil/here(entered:todayRing:)``.
    let here: Int
    let height: CGFloat
    let reduceMotion: Bool
    let onRing: (Int) -> Void
    let onBindu: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            handle
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(1...8, id: \.self) { ring in
                        row(ring)
                    }
                    binduFooter
                }
                .padding(.horizontal, 18)
                .padding(.top, 4)
                .padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(sheetGround)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 22, topTrailingRadius: 22))
        .overlay(alignment: .top) {
            UnevenRoundedRectangle(topLeadingRadius: 22, topTrailingRadius: 22)
                .stroke(Color.gold.opacity(0.22), lineWidth: 0.5)
                .allowsHitTesting(false)
        }
        .shadow(color: Color.black.opacity(0.7), radius: 30, y: -10)
        .shadow(color: Color.gold.opacity(0.10), radius: 15, y: -1)
        .gesture(
            DragGesture(minimumDistance: 16)
                .onEnded { v in if v.translation.height > 60 { onClose() } })
    }

    /// Design's veil: dark ground rising, near-opaque at the foot, a little
    /// translucent at the lip — and, beyond Design, a faint warmth standing
    /// where the walker is, so the sheet itself carries the light of *here*.
    private var sheetGround: some View {
        ZStack {
            LinearGradient(stops: [
                               .init(color: Color(red: 13/255, green: 4/255, blue: 9/255).opacity(0.93), location: 0),
                               .init(color: Color(red: 11/255, green: 3/255, blue: 7/255).opacity(0.985), location: 0.3),
                               .init(color: Color(red: 8/255, green: 2/255, blue: 6/255).opacity(0.995), location: 1),
                           ],
                           startPoint: .top, endPoint: .bottom)
            RadialGradient(colors: [Color.gold.opacity(0.08), Color.gold.opacity(0)],
                           center: UnitPoint(x: 0.5, y: 0.08 + 0.1 * CGFloat(min(max(here, 1), 9) - 1)),
                           startRadius: 0, endRadius: 260)
        }
    }

    private var handle: some View {
        Button(action: onClose) {
            VStack(spacing: 14) {
                Capsule()
                    .fill(Color.cream.opacity(0.30))
                    .frame(width: 40, height: 4)
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
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 12)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("The nine āvaraṇas")
        .accessibilityHint("Lowers the veil.")
    }

    @ViewBuilder
    private func row(_ ring: Int) -> some View {
        let light = MandalaVeil.light(ring: ring, here: here)
        Button { onRing(ring) } label: {
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(MandalaVeil.spokenRow(ring: ring, here: here))
        .accessibilityHint("Falls to this āvaraṇa.")
        .accessibilityAddTraits(.isButton)
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
    /// dashed where this fall has not yet crossed.
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

    /// Ring IX — the Bindu as the column's destination, not a row.
    private var binduFooter: some View {
        let light = MandalaVeil.light(ring: 9, here: here)
        return Button(action: onBindu) {
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Ninth āvaraṇa, the Bindu. \(light.spoken)")
        .accessibilityHint("Opens the source.")
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
