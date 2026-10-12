import SwiftUI
import UIKit

// MARK: - The two thresholds, crossed
//
// Charter II §2: *Shadow and Armin are the thresholds at the 3→4 and 6→7
// crossings.* Falling through either in the semantic zoom — or arriving at one
// on the Road — passes through a moment of its own. It is **light and sound,
// never a lock**: the moment draws over the field, hit-tests nothing, and the
// fall it rides on has already happened. The field under it is never held.
//
// · **Shadow · the corridor closing.** The dark comes in from both edges of the
//   glass until there is only a corridor of light down the middle; for a breath
//   it holds; then the dark *thins at one edge* — never a door rising (Chakras
//   Experience Brief §7, "corridor exit"). A few stars stand in the dark: the
//   Map's colour for Shadow is "Dark / Starfield".
// · **Armin · Tripura Mālinī's gate.** The light returns. A garland of points
//   gathers round the glass and parts at the top like a gate opening, in the
//   Map's own gold for Armin ("Spectrum / Aurora"). Tripura Mālinī is the same
//   Śakti who held the corridor, invisible there and visible here (C-1345).
//
// The words are the Map's: the chakra's name and its verb, at the foot, for a
// breath. Under reduce motion both moments are a still image that fades in and
// out — the corridor already narrow, the garland already open.
struct MandalaThresholdMoment: View {
    let chakra: Chakra33
    let reduceMotion: Bool
    /// Whether the Mandala's sound is on (the same opt-in its crossings obey).
    let soundOn: Bool
    let onDone: () -> Void

    @State private var born = Date()
    @State private var appeared = false

    /// The whole moment, in seconds.
    static func duration(reduceMotion: Bool) -> Double { reduceMotion ? 2.4 : 4.2 }

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { tl in
            let age = reduceMotion ? 1.4 : tl.date.timeIntervalSince(born)
            Canvas { ctx, size in
                if chakra.kind == .shadow {
                    drawCorridor(ctx, size: size, age: age)
                } else {
                    drawGate(ctx, size: size, age: age)
                }
            }
        }
        .overlay(alignment: .bottom) { words }
        .opacity(appeared ? 1 : 0)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear(perform: begin)
    }

    private var words: some View {
        VStack(spacing: 6) {
            Text(chakra.name)
                .font(AppFont.sanskrit(26))
                .tracking(1.2)
                .foregroundStyle(Color.cream.opacity(0.85))
            if let verb = chakra.verb {
                Text(verb)
                    .font(AppFont.label(11.5))
                    .tracking(3.2)
                    .foregroundStyle(Color.cream.opacity(0.6))
            }
            // Wave 6 · these thresholds are the phase boundaries: Shadow opens
            // Sthiti, Armin opens Saṃhāra — named from the rings' own rows.
            if let phase = RingFactsCache.phaseWords(
                RingFactsCache.facts(ring: chakra.kind == .shadow ? 4 : 7)?.phase) {
                Text("into \(phase)")
                    .font(AppFont.voice(14))
                    .italic()
                    .foregroundStyle(Color.cream.opacity(0.5))
            }
        }
        .padding(.bottom, 132)
    }

    private func begin() {
        born = Date()
        withAnimation(.easeOut(duration: reduceMotion ? 0.4 : 0.6)) { appeared = true }
        // The body hears it first: Shadow one long, soft press; Armin three
        // light beads, a garland under the thumb.
        if chakra.kind == .shadow {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.9)
        } else {
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18 * Double(i)) {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.6)
                }
            }
        }
        if soundOn {
            // Rooms about him take 110 Hz; worlds and the point take 136.1
            // (Charter II §3.5). The corridor sounds low and alone; the gate
            // sounds the point with its octave, the light come back.
            if chakra.kind == .shadow {
                BijaSoundService.shared.playVakBija(frequency: 110, duration: 3.2, volume: 0.07)
            } else {
                BijaSoundService.shared.playVakChord(frequencies: [136.1, 204.15, 272.2],
                                                     duration: 3.4, volume: 0.04, stagger: 0.12)
            }
        }
        UIAccessibility.post(notification: .announcement,
                             argument: ChakraConstellation.spokenLabel(chakra, seatName: nil))
        let whole = Self.duration(reduceMotion: reduceMotion)
        DispatchQueue.main.asyncAfter(deadline: .now() + whole - 0.7) {
            withAnimation(.easeIn(duration: 0.7)) { appeared = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + whole) { onDone() }
    }

    // MARK: Shadow — the corridor closing, then thinning at one edge

    private func drawCorridor(_ ctx: GraphicsContext, size: CGSize, age: Double) {
        let w = size.width, h = size.height
        // 0 → 1.2 s the walls come in; hold to 2.6 s; then the left wall thins.
        let close = smooth(min(1, age / 1.2))
        let thin = smooth(min(1, max(0, (age - 2.6) / 1.2)))
        let corridor = w * (0.5 - 0.36 * close)       // half-width of the light left
        let leftEdge = w / 2 - corridor
        let rightEdge = w / 2 + corridor
        let dark = Color(red: 0.03, green: 0.02, blue: 0.03)

        // Left wall: thins away (its opacity falls) as the dark lifts at one edge.
        let leftAlpha = 0.92 * (1 - thin)
        ctx.fill(Path(CGRect(x: 0, y: 0, width: max(0, leftEdge), height: h)),
                 with: .linearGradient(Gradient(colors: [dark.opacity(leftAlpha), dark.opacity(leftAlpha * 0.7)]),
                                       startPoint: .zero, endPoint: CGPoint(x: max(1, leftEdge), y: 0)))
        ctx.fill(Path(CGRect(x: rightEdge, y: 0, width: max(0, w - rightEdge), height: h)),
                 with: .linearGradient(Gradient(colors: [dark.opacity(0.92 * 0.7), dark.opacity(0.92)]),
                                       startPoint: CGPoint(x: rightEdge, y: 0), endPoint: CGPoint(x: w, y: 0)))
        // Stars in the dark.
        var add = ctx
        add.blendMode = .plusLighter
        for i in 0..<18 {
            let fx = Double((i * 53) % 100) / 100
            let fy = Double((i * 29 + 11) % 100) / 100
            let x = fx < 0.5 ? CGFloat(fx * 2) * max(0, leftEdge) : rightEdge + CGFloat((fx - 0.5) * 2) * (w - rightEdge)
            let onLeft = fx < 0.5
            let a = (onLeft ? (1 - thin) : 1) * (0.25 + 0.35 * (0.5 + 0.5 * sin(age * 1.7 + Double(i))))
            let p = CGPoint(x: x, y: CGFloat(fy) * h)
            add.fill(Path(ellipseIn: CGRect(x: p.x - 1, y: p.y - 1, width: 2, height: 2)),
                     with: .color(Color.cream.opacity(a * close)))
        }
        // The corridor's own light: a faint gold seam down the middle.
        let seam = Path(CGRect(x: w / 2 - corridor, y: 0, width: corridor * 2, height: h))
        add.fill(seam, with: .linearGradient(
            Gradient(colors: [Color.gold.opacity(0), Color.gold.opacity(0.06 * close), Color.gold.opacity(0)]),
            startPoint: CGPoint(x: w / 2 - corridor, y: 0), endPoint: CGPoint(x: w / 2 + corridor, y: 0)))
        // The thinning edge lets the next colour in before the walker arrives:
        // Soles' red, the first body room, at the left horizon.
        if thin > 0 {
            let soles = Color(red: 0.48, green: 0.08, blue: 0.08)
            add.fill(Path(CGRect(x: 0, y: 0, width: w * 0.35, height: h)),
                     with: .linearGradient(Gradient(colors: [soles.opacity(0.22 * thin), soles.opacity(0)]),
                                           startPoint: .zero, endPoint: CGPoint(x: w * 0.35, y: 0)))
        }
    }

    // MARK: Armin — the garland gathers, and the gate opens

    private func drawGate(_ ctx: GraphicsContext, size: CGSize, age: Double) {
        let w = size.width, h = size.height
        let centre = CGPoint(x: w / 2, y: h * 0.44)
        let gather = smooth(min(1, age / 1.4))
        let open = smooth(min(1, max(0, (age - 1.6) / 1.6)))
        let gold = Color(red: 0.79, green: 0.66, blue: 0.30)        // the Map's #C9A84C
        var add = ctx
        add.blendMode = .plusLighter

        // The light returning: a wide warm wash from the centre.
        let wash = max(w, h) * 0.7
        add.fill(Path(ellipseIn: CGRect(x: centre.x - wash, y: centre.y - wash, width: wash * 2, height: wash * 2)),
                 with: .radialGradient(Gradient(colors: [gold.opacity(0.16 * gather), gold.opacity(0)]),
                                       center: centre, startRadius: 0, endRadius: wash))

        // The garland: beads drawn in from beyond the glass to a circle, then
        // parting at the top as the gate opens.
        let beads = 33
        let r = min(w, h) * 0.38
        for i in 0..<beads {
            let base = Double(i) / Double(beads) * 2 * .pi - .pi / 2
            // Opening: beads either side of twelve o'clock slide down and away.
            let side: Double = i == 0 ? 0 : (i <= beads / 2 ? 1 : -1)
            let nearTop = 1 - min(1, abs(Double(min(i, beads - i))) / Double(beads / 2))
            let angle = base + side * open * 0.55 * nearTop
            let far = r * (1 + 1.4 * (1 - gather))
            let p = CGPoint(x: centre.x + CGFloat(cos(angle)) * far,
                            y: centre.y + CGFloat(sin(angle)) * far)
            let br: CGFloat = 2.2
            let a = gather * (i == 0 ? (1 - open) : 1) * 0.85
            add.fill(Path(ellipseIn: CGRect(x: p.x - br * 3, y: p.y - br * 3, width: br * 6, height: br * 6)),
                     with: .radialGradient(Gradient(colors: [gold.opacity(a), gold.opacity(0)]),
                                           center: p, startRadius: 0, endRadius: br * 3))
            add.fill(Path(ellipseIn: CGRect(x: p.x - br * 0.6, y: p.y - br * 0.6, width: br * 1.2, height: br * 1.2)),
                     with: .color(Color.cream.opacity(a)))
        }
        // Through the open gate, a seam of light rising.
        if open > 0 {
            let top = CGPoint(x: centre.x, y: centre.y - r)
            var seam = Path()
            seam.move(to: top)
            seam.addLine(to: CGPoint(x: centre.x, y: top.y - r * 0.9 * open))
            add.stroke(seam, with: .color(gold.opacity(0.35 * open)), lineWidth: 6)
            add.stroke(seam, with: .color(Color.cream.opacity(0.6 * open)), lineWidth: 1)
        }
    }

    private func smooth(_ x: Double) -> Double { x * x * (3 - 2 * x) }
}
