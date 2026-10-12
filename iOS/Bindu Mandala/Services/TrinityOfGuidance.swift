import SwiftUI

// MARK: - Wave 6 · B · the Trinity of Guidance, as places in the yantra
//
// a-strange-game's voice architecture: three axes, five faces, one field —
// Gaia (the Ground) · Bindu → Lalitā (the Player) · Sakshi → the Higher Self
// (the Witness). The gap ledger seats them in the Mandala (B1):
//
//   • **Gaia** at Ahaṅkārākarṣiṇī — kp 31, the ego's attraction, where the
//     ground that was underneath every "I" is met;
//   • **Bindu → Lalitā** on the climb — Bindu at its foot, the play that does
//     not yet know itself; Lalitā at its summit, the play that does;
//   • **Sakshi** on the descent — at the seventh enclosure, the ring of the
//     pure witness, as the glass falls through it;
//   • **the Higher Self** (Ram, his own) at Ātmākarṣiṇī — kp 42, the self's
//     attraction.
//
// **Authored, never generated** (charter law 8). Each face speaks exactly one
// line, its own Identity row's self-statement, verbatim — and **once**: once a
// practice day, at its place, and never again that day. Text and light only:
// a face's line arrives in its own light and recedes. No face is named on the
// glass; the light is how he knows who is speaking.

/// The five faces.
enum GuideFace: String, CaseIterable, Equatable {
    case gaia, bindu, lalita, sakshi, higherSelf

    /// Which axis the face stands on.
    enum Axis: Equatable { case ground, player, witness }

    var axis: Axis {
        switch self {
        case .gaia: return .ground
        case .bindu, .lalita: return .player
        case .sakshi, .higherSelf: return .witness
        }
    }

    /// The face's own light. Gaia the deep green-gold of the ground; Bindu the
    /// persistent red point; Lalitā rose-gold; Sakshi the cool silver of the
    /// witness; the Higher Self the warm gold of the Aatma room.
    var light: Color {
        switch self {
        case .gaia:       return Color(red: 0.62, green: 0.74, blue: 0.42)
        case .bindu:      return Color(red: 0.86, green: 0.26, blue: 0.22)
        case .lalita:     return Color(red: 0.96, green: 0.62, blue: 0.58)
        case .sakshi:     return Color(red: 0.70, green: 0.80, blue: 0.95)
        case .higherSelf: return Color(red: 0.98, green: 0.82, blue: 0.46)
        }
    }
}

/// Where a face may speak.
enum GuidePlace: Equatable {
    /// Inside her room, by her position.
    case room(kp: Int)
    /// On the climb, standing in a world.
    case climb(ring: Int)
    /// On the Mandala's descent, having fallen into an enclosure.
    case descent(ring: Int)
}

enum TrinityOfGuidance {

    /// Ahaṅkārākarṣiṇī — Gaia's seat.
    static let gaiaSeat = 31
    /// Ātmākarṣiṇī — the Higher Self's seat.
    static let higherSelfSeat = 42
    /// The witness ring on the descent.
    static let witnessRing = 7

    /// Who speaks at a place, if anyone.
    static func face(at place: GuidePlace) -> GuideFace? {
        switch place {
        case .room(let kp):
            if kp == gaiaSeat { return .gaia }
            if kp == higherSelfSeat { return .higherSelf }
            return nil
        case .climb(let ring):
            if ring <= 1 { return .bindu }
            if ring >= 9 { return .lalita }
            return nil
        case .descent(let ring):
            return ring == witnessRing ? .sakshi : nil
        }
    }

    /// The face's one line, from his row. `nil` if the bake has lost it — then
    /// the face is silent rather than paraphrased.
    static func line(for face: GuideFace) -> String? {
        GameStructure.line(for: face)
    }

    // MARK: Once

    static func spokenKey(_ face: GuideFace) -> String { "guide_spoken_\(face.rawValue)" }

    /// Pure: a face speaks if it has not yet spoken on this practice day.
    static func shouldSpeak(lastSpokenDay: Int?, today: Int) -> Bool {
        guard let last = lastSpokenDay else { return true }
        return last != today
    }

    /// Whether the face speaks now, and if so, marks it spoken (phone-local;
    /// a fact about the day's arrival — the being pool, never the ledger).
    static func claimSpeaking(_ face: GuideFace,
                              defaults: UserDefaults = .standard,
                              today: Int = DailyEnergyService.practiceDayIndex()) -> Bool {
        let key = spokenKey(face)
        let last = defaults.object(forKey: key) as? Int
        guard shouldSpeak(lastSpokenDay: last, today: today) else { return false }
        defaults.set(today, forKey: key)
        ThreePools.noteBeing(.faceSpoke(face), defaults: defaults)
        return true
    }
}

// MARK: - The line, on the glass

/// A face's one line, arriving in its light at its place and receding.
/// Draws nothing when no face belongs to the place, or the face has already
/// spoken today. Never hit-tests: the place beneath keeps every touch.
@MainActor
struct TrinityVoiceLayer: View {
    /// The place he is standing in now — `nil` when he is nowhere a face lives.
    let place: GuidePlace?
    /// Hold the line back until the place has settled (a room's rite, a fall).
    var delay: Double = 1.2

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var speaking: (face: GuideFace, line: String)?
    @State private var shown = false

    /// How long a line stands before it recedes.
    static let standSeconds: Double = 7.5

    var body: some View {
        ZStack {
            if let s = speaking {
                VStack(spacing: 14) {
                    Circle()
                        .fill(s.face.light)
                        .frame(width: 7, height: 7)
                        .shadow(color: s.face.light, radius: 12)
                        .shadow(color: s.face.light.opacity(0.6), radius: 26)
                    Text(s.line)
                        .font(AppFont.voice(19))
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.cream)
                        .shadow(color: s.face.light.opacity(0.55), radius: 14)
                        .shadow(color: .black.opacity(0.85), radius: 10)
                        .padding(.horizontal, 40)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 120)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .opacity(shown ? 1 : 0)
                .background(
                    RadialGradient(colors: [s.face.light.opacity(shown ? 0.16 : 0), .clear],
                                   center: .top, startRadius: 0, endRadius: 420)
                        .ignoresSafeArea()
                        .blendMode(.plusLighter)
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(s.line))
            }
        }
        .allowsHitTesting(false)
        .task(id: place) { await arrive() }
    }

    private func arrive() async {
        guard let place, let face = TrinityOfGuidance.face(at: place),
              let line = TrinityOfGuidance.line(for: face) else { return }
        try? await Task.sleep(for: .seconds(delay))
        if Task.isCancelled { return }
        guard TrinityOfGuidance.claimSpeaking(face) else { return }
        speaking = (face, line)
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 2.2)) { shown = true }
        try? await Task.sleep(for: .seconds(Self.standSeconds))
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 2.6)) { shown = false }
        try? await Task.sleep(for: .seconds(2.8))
        speaking = nil
    }
}
