import SwiftUI
import UIKit

// MARK: - Wave 6 · B · Knowledge — Will — Action, inside her room
//
// a-strange-game's operating mechanic: *"Knowledge is what they receive. Will is
// who they are. Action is what they commit to. Light is what enters when these
// three close."* The master brief's §4 makes it the activation cycle, one per
// Śakti, from six gesture families and no hand-authoring:
//
//   1. **Knowledge** — her nature, slower: her own Quality Description.
//   2. **Will** — one gesture, by her element:
//        fire  · a held pulse — press and hold, the haptic rising like stoking
//        water · a slow pour — a drag that must stay unhurried; rushed, it
//                does not register (and nothing says so)
//        air   · breath-timed — no touch; the point breathes and he follows
//        earth · press and still — held, and held motionless
//        ether · absence — the point dims and waits for him not to touch
//        light · one precise touch at the instant the point is brightest
//      Per-position jitter makes each of the fourteen fire-Śaktis her own.
//      **The gesture recedes as the rings deepen** (§10, C-1307): rings 1–3 ask
//      for real engagement, 4–6 for less, and 7–9 for nothing — only presence.
//   3. **Action** — the gesture resolves into her response: her light blooms,
//      her bīja answers. Patience makes it fuller (C-1337); it is never shown
//      as a number, and a rushed or unfinished gesture is not a failure — the
//      point simply waits.
//   4. **The close** — the three named, once: what was received (her Quality),
//      what was willed, and the one thing carried outward (her somatic line).
//      The act is one ledger row, `Light Entered`.
//
// Offered, never required: nothing locks behind it and leaving is still the
// one gesture it always was.

/// The six families, and the seventh state where no gesture is asked.
enum GestureFamily: String, CaseIterable, Equatable {
    case fire, water, air, earth, ether, light
    /// Rings 7–9: no gesture — witnessed presence.
    case presence

    static func forElement(_ e: Element) -> GestureFamily {
        switch e {
        case .fire: return .fire
        case .water: return .water
        case .air: return .air
        case .earth: return .earth
        case .ether: return .ether
        case .light: return .light
        }
    }

    /// The one word the close says for what was willed.
    var willed: String {
        switch self {
        case .fire: return "held"
        case .water: return "poured"
        case .air: return "breathed"
        case .earth: return "stilled"
        case .ether: return "left alone"
        case .light: return "met"
        case .presence: return "present"
        }
    }
}

/// The pure half of the cycle.
enum ActivationCycle {

    /// Her family at her ring: her element's, until the gesture recedes.
    static func family(element: Element, ring: Int) -> GestureFamily {
        ring >= 7 ? .presence : GestureFamily.forElement(element)
    }

    /// How much gesture the ring still asks for: whole in Sṛṣṭi, less in
    /// Sthiti, none in Saṃhāra.
    static func recession(ring: Int) -> Double {
        switch ring {
        case ...3: return 1
        case 4...6: return 0.6
        default: return 0
        }
    }

    /// Her own small difference within the family, `0.85…1.15`, by position.
    static func jitter(kp: Int) -> Double {
        let h = (kp &* 2654435761) & 0xffff
        return 0.85 + 0.3 * Double(h) / Double(0xffff)
    }

    /// What the will asks for, in seconds (a hold, a stillness, a waiting) or,
    /// for water, in points of unhurried pour.
    static func need(_ f: GestureFamily, ring: Int, kp: Int) -> Double {
        let k = max(0.35, recession(ring: ring)) * jitter(kp: kp)
        switch f {
        case .fire: return 3.0 * k
        case .earth: return 3.5 * k
        case .water: return 180 * k
        case .air: return 10 * k
        case .ether: return 8 * k
        case .light: return 2.4 * k        // the pulse's period
        case .presence: return 6
        }
    }

    /// The pour is unhurried below this speed (points a second).
    static let pourSpeed: Double = 240
    /// How near the brightest instant a touch must land (seconds either side).
    static let lightWindow: Double = 0.22

    /// How full her answer is, `0…1`, from how the will was given — never shown.
    /// A hold past what was asked, up to half again, is fuller; a touch at the
    /// very peak is fullest.
    static func fullness(_ f: GestureFamily, need: Double, given: Double) -> Double {
        switch f {
        case .fire, .earth:
            return min(1, 0.6 + 0.4 * max(0, (given - need) / (need * 0.5)))
        case .light:
            return max(0.4, 1 - abs(given) / lightWindow * 0.6)
        default:
            return 1
        }
    }

    /// Pure: where in the light family's pulse `t` falls — the signed seconds
    /// from the nearest brightest instant.
    static func fromPeak(t: Double, period: Double) -> Double {
        guard period > 0 else { return 0 }
        let phase = t.truncatingRemainder(dividingBy: period)
        return phase - period / 2
    }
}

// MARK: - The cycle, on the glass

@MainActor
struct ActivationCycleLayer: View {
    let shakti: Shakti
    /// He is inside her room (the rite has ended).
    let entered: Bool
    /// How long after entering the cycle is offered.
    let startDelay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum Phase: Equatable { case waiting, knowledge, will, action, close, done }

    @State private var phase: Phase = .waiting
    @State private var cycleBegan: Date?
    @State private var willBegan = Date()
    @State private var pressStart: Date?
    @State private var pressMoved = false
    @State private var poured: Double = 0
    @State private var pourBegan: Date?
    @State private var etherSince = Date()
    @State private var fullness: Double = 1
    @State private var bloomAt: Date?
    @State private var stoking: Task<Void, Never>?

    private var kp: Int { shakti.khadgamalaPosition ?? shakti.position }
    private var ring: Int { shakti.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: kp) }
    private var family: GestureFamily { ActivationCycle.family(element: shakti.element, ring: ring) }
    private var need: Double { ActivationCycle.need(family, ring: ring, kp: kp) }
    private var hue: Color { Atmosphere.derive(from: shakti).accentBright }

    var body: some View {
        ZStack {
            if phase == .knowledge || phase == .will { knowledgeWords }
            if phase == .will || phase == .action { point }
            if phase == .close { closeWords }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 1.6), value: phase)
        .task(id: entered) { await offer() }
        .onDisappear { stoking?.cancel() }
    }

    // MARK: Offering

    private func offer() async {
        guard entered, phase == .waiting else { return }
        try? await Task.sleep(for: .seconds(startDelay))
        guard !Task.isCancelled, entered else { return }
        cycleBegan = Date()
        phase = .knowledge
        try? await Task.sleep(for: .seconds(reduceMotion ? 1.5 : 5))
        guard !Task.isCancelled else { return }
        willBegan = Date()
        etherSince = Date()
        phase = .will
        // The families that ask nothing of the hand complete by themselves.
        switch family {
        case .air, .ether, .presence:
            await waitWithoutTouch()
        default:
            break
        }
    }

    /// Air, ether and presence: the will is given by being here. Ether's clock
    /// starts again whenever the point is touched — the absence is the act.
    private func waitWithoutTouch() async {
        while !Task.isCancelled, phase == .will {
            try? await Task.sleep(for: .seconds(0.25))
            let from = family == .ether ? etherSince : willBegan
            if Date().timeIntervalSince(from) >= need { complete(fullness: 1); return }
        }
    }

    // MARK: Knowledge

    private var knowledge: String {
        let d = shakti.qualityDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        return d.isEmpty ? shakti.quality : d
    }

    private var knowledgeWords: some View {
        Text(knowledge)
            .font(AppFont.voice(18))
            .lineSpacing(5)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.cream.opacity(phase == .knowledge ? 0.92 : 0.5))
            .shadow(color: .black.opacity(0.9), radius: 12)
            .padding(.horizontal, 40)
            .padding(.top, 110)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .allowsHitTesting(false)
            .transition(.opacity)
    }

    // MARK: Will — her point

    private var point: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { tl in
            let t = tl.date.timeIntervalSince(willBegan)
            let glow = pointGlow(at: tl.date, t: t)
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [hue.opacity(0.55 * glow), hue.opacity(0)],
                                         center: .center, startRadius: 0, endRadius: 44 + 120 * bloom(at: tl.date)))
                    .frame(width: 88 + 240 * bloom(at: tl.date), height: 88 + 240 * bloom(at: tl.date))
                    .blendMode(.plusLighter)
                Circle()
                    .fill(Color.cream.opacity(0.4 + 0.6 * glow))
                    .frame(width: 9 + 5 * glow, height: 9 + 5 * glow)
                    .shadow(color: hue, radius: 10 + 16 * glow)
            }
            .frame(width: 120, height: 120)
            .contentShape(Circle())
            .gesture(willGesture, including: phase == .will ? .all : .none)
        }
        .padding(.top, 250)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(shakti.quality))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { if phase == .will { complete(fullness: 1) } }
    }

    /// How bright her point stands now, `0…1`, by family.
    private func pointGlow(at now: Date, t: Double) -> Double {
        if phase == .action { return 1 }
        switch family {
        case .fire, .earth:
            guard let p = pressStart else { return 0.45 }
            return min(1, 0.45 + 0.55 * now.timeIntervalSince(p) / max(0.1, need))
        case .water:
            return min(1, 0.4 + 0.6 * poured / max(1, need))
        case .air:
            // A breath of four in and six out, the point following it.
            let u = t.truncatingRemainder(dividingBy: 10)
            return u < 4 ? 0.3 + 0.7 * u / 4 : 1 - 0.7 * (u - 4) / 6
        case .ether:
            return max(0.12, 0.5 - 0.38 * min(1, now.timeIntervalSince(etherSince) / max(1, need)))
        case .light:
            let d = abs(ActivationCycle.fromPeak(t: t, period: need))
            return max(0.2, 1 - d / (need / 2))
        case .presence:
            return 0.55 + 0.15 * sin(t * 0.8)
        }
    }

    private func bloom(at now: Date) -> Double {
        guard let b = bloomAt else { return 0 }
        let k = min(1, now.timeIntervalSince(b) / 2.4)
        return k * fullness
    }

    private var willGesture: AnyGesture<Void> {
        switch family {
        case .fire, .earth:
            return AnyGesture(DragGesture(minimumDistance: 0)
                .onChanged { v in
                    if pressStart == nil { beginPress() }
                    if family == .earth, hypot(v.translation.width, v.translation.height) > 6 {
                        // Moving is not stillness: the hold begins again.
                        pressStart = Date()
                    }
                }
                .onEnded { _ in endPress() }
                .map { _ in () })
        case .water:
            return AnyGesture(DragGesture(minimumDistance: 4)
                .onChanged { v in pour(v) }
                .onEnded { _ in
                    pourBegan = nil
                    if poured >= need { complete(fullness: 1) }
                }
                .map { _ in () })
        case .light:
            return AnyGesture(TapGesture().onEnded { touchTheLight() })
        case .ether:
            return AnyGesture(TapGesture().onEnded { etherSince = Date() })
        case .air, .presence:
            return AnyGesture(TapGesture().onEnded { })
        }
    }

    private func beginPress() {
        pressStart = Date()
        guard family == .fire else { return }
        stoking?.cancel()
        stoking = Task { @MainActor in
            var k = 0.2
            while !Task.isCancelled {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: k)
                k = min(1, k + 0.12)
                try? await Task.sleep(for: .seconds(0.45))
            }
        }
    }

    private func endPress() {
        stoking?.cancel()
        stoking = nil
        defer { pressStart = nil }
        guard let p = pressStart else { return }
        let held = Date().timeIntervalSince(p)
        guard held >= need else { return }     // not yet — the point simply eases back
        complete(fullness: ActivationCycle.fullness(family, need: need, given: held))
    }

    private func pour(_ v: DragGesture.Value) {
        let now = Date()
        if pourBegan == nil { pourBegan = now; poured = 0 }
        let travelled = Double(hypot(v.translation.width, v.translation.height))
        let elapsed = max(0.05, now.timeIntervalSince(pourBegan ?? now))
        if travelled / elapsed > ActivationCycle.pourSpeed {
            // Rushed: the pour does not take. Nothing says so.
            pourBegan = now
            poured = 0
            return
        }
        poured = travelled
    }

    private func touchTheLight() {
        let t = Date().timeIntervalSince(willBegan)
        let off = ActivationCycle.fromPeak(t: t, period: need)
        guard abs(off) <= ActivationCycle.lightWindow else { return }
        complete(fullness: ActivationCycle.fullness(.light, need: need, given: off))
    }

    // MARK: Action, and the close

    private func complete(fullness f: Double) {
        guard phase == .will else { return }
        fullness = f
        bloomAt = Date()
        phase = .action
        if f > 0.7 {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            Haptics.soft()
        }
        // Her bīja answers — a struck sound, so the room steps back for it.
        BijaSoundService.shared.playBija(shakti.bija, seed: kp)
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(reduceMotion ? 1 : 3.2))
            phase = .close
            close()
            try? await Task.sleep(for: .seconds(reduceMotion ? 6 : 9))
            phase = .done
        }
    }

    private func close() {
        let at = Date()
        let seconds = at.timeIntervalSince(cycleBegan ?? at)
        ThreePools.noteBeing(.lightEntered(kp: kp))
        let item = ActivityLedger.lightEntered(shaktiRecordId: shakti.airtableRecordId ?? "",
                                               name: shakti.name,
                                               family: family.rawValue,
                                               seconds: seconds, at: at)
        Task { await AirtableService.shared.logActivity(item) }
    }

    private var closeWords: some View {
        VStack(spacing: 18) {
            closeLine("knowledge", shakti.quality)
            closeLine("will", family.willed)
            closeLine("action", shakti.somatic)
        }
        .padding(.horizontal, 40)
        .padding(.top, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .allowsHitTesting(false)
        .transition(.opacity)
    }

    private func closeLine(_ label: String, _ words: String) -> some View {
        VStack(spacing: 5) {
            Text(label)
                .font(AppFont.label(11)).tracking(2.6)
                .textCase(.uppercase)
                .foregroundStyle(hue)
            Text(words)
                .font(AppFont.voice(17))
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.cream.opacity(0.9))
                .shadow(color: .black.opacity(0.9), radius: 10)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
