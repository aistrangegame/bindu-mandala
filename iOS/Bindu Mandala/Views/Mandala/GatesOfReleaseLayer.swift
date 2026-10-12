import SwiftUI
import SwiftData

// MARK: - Wave 2 · the Gates of Release, on the descent through the nine
//
// Claude Design's *The Seven Gates* (the chakra set): a descent where at each
// gate something is put down — *"hold to lay it down"*, and the words fall and
// fade (`put-down 1.7s`). Reborn over the nine āvaraṇas (WAVES.md): **going
// inward he sets down each ring's Mental State; coming out he receives its
// Siddhi.**
//
// What changed in the crossing, and why:
//   • **The words are the ring's own rows** (`Mental State`, `Siddhi`, read
//     live, the base's strings standing offline) — never typed by him into a
//     box, and never answered. The Seven Gates' gatekeeper was a generated
//     voice; Charter II law 8 refuses it, and the gate is the more silent for it.
//   • **A gate is an offer, never a toll.** It stands at the foot of the glass
//     for nine seconds as he crosses, and passes by if he does not take it.
//     Nothing is locked behind it and nothing is lost by passing.
//   • **The act stays in the record** (§4.1, §4.3): a held gate writes one
//     App Activity row — `State Set Down` / `Siddhi Received` — through
//     ``ActivityLedger``, the single ledger. The words leave the view; the act
//     does not leave the record. Nothing counts the gates he has passed.

/// The gate the glass is crossing, at the foot of the Mandala.
@MainActor
struct GatesOfReleaseLayer: View {
    /// The enclosure the glass has fallen into (`0` outside the yantra).
    let ring: Int
    /// Whether a gate may stand now — not while a seat's card, the Veil or the
    /// source holds the foot of the glass.
    let active: Bool

    @Query(sort: \Avarana.ringNumber) private var avaranas: [Avarana]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var gate: TheGates.Gate?
    @State private var offeredAt = Date()
    @State private var pressedAt: Date?
    @State private var answeredAt: Date?

    var body: some View {
        ZStack {
            if active, let gate {
                gateView(gate)
                    .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.6), value: gate)
        .onChange(of: ring) { old, new in offer(from: old, to: new) }
        .task(id: offeredAt) {
            // Unanswered, the gate lets him pass by.
            try? await Task.sleep(for: .seconds(TheGates.offeredSeconds))
            if answeredAt == nil, pressedAt == nil { gate = nil }
        }
    }

    // MARK: - The gate

    private func gateView(_ gate: TheGates.Gate) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { tl in
            let now = tl.date
            let held = pressedAt.map { min(1, now.timeIntervalSince($0) / TheGates.holdSeconds) } ?? 0
            let after = answeredAt.map { now.timeIntervalSince($0) / TheGates.putDownSeconds } ?? 0
            let motion = gate.way == .inward ? TheGates.putDown(after) : TheGates.receive(after)
            let colour = Atmosphere.derive(ring: gate.ring, cluster: gate.ring == 2 ? .inner : nil,
                                           khadgamala: KhadgamalaMap.ringStartOffset(gate.ring) + 1,
                                           element: Element.forRing(gate.ring)).accentBright
            VStack(spacing: 12) {
                Spacer()
                Text(gate.words)
                    .font(AppFont.voice(20))
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.cream)
                    .opacity(motion.opacity)
                    .scaleEffect(motion.scale)
                    .offset(y: motion.dy)
                    .shadow(color: .black.opacity(0.9), radius: 16)
                    .padding(.horizontal, 44)
                    .fixedSize(horizontal: false, vertical: true)
                    .allowsHitTesting(false)
                if answeredAt == nil {
                    ZStack {
                        Circle()
                            .stroke(colour.opacity(0.3), lineWidth: 1)
                        Circle()
                            .trim(from: 0, to: held)
                            .stroke(colour, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .shadow(color: colour, radius: 6)
                        Text(gate.instruction)
                            .font(AppFont.label(11))
                            .tracking(1.6)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.cream)
                            .opacity(0.62)
                            .multilineTextAlignment(.center)
                            .frame(width: 66)
                    }
                    .frame(width: 76, height: 76)
                    .contentShape(Circle())
                    .onLongPressGesture(minimumDuration: TheGates.holdSeconds,
                                        maximumDistance: 40,
                                        perform: { answer(gate) },
                                        onPressingChanged: { pressing in
                                            pressedAt = pressing ? Date() : nil
                                        })
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("\(gate.instruction): \(gate.words)"))
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction { answer(gate) }
                }
            }
            .padding(.bottom, 112)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Offering, and answering

    /// A crossing meets a gate: inward, the ring he entered; outward, the ring
    /// he left.
    private func offer(from old: Int, to new: Int) {
        guard active else { return }
        let next = TheGates.gate(from: old, to: new,
                                 mentalState: { r in avaranas.first { $0.ringNumber == r }?.mentalState },
                                 siddhi: { r in RingFactsCache.facts(ring: r)?.siddhi })
        guard let next else { return }
        pressedAt = nil
        answeredAt = nil
        gate = next
        offeredAt = Date()
    }

    /// He held the gate: the words are put down (or received), and the act is
    /// written to the one ledger.
    private func answer(_ g: TheGates.Gate) {
        guard answeredAt == nil else { return }
        Haptics.medium()
        answeredAt = Date()
        pressedAt = nil
        let at = Date()
        let item = g.way == .inward
            ? ActivityLedger.stateSetDown(ring: g.ring, state: g.words, at: at)
            : ActivityLedger.siddhiReceived(ring: g.ring, siddhi: g.words, at: at)
        Task { await AirtableService.shared.logActivity(item) }
        let leave = TheGates.putDownSeconds + 0.6
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(leave))
            if gate == g { gate = nil }
        }
    }
}
