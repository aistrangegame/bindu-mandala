import Foundation

// MARK: - Wave 6 · B · one sound at a time
//
// C-1350, his named failure in Bindu Field: *"Starting any new audio stops
// whatever else is playing."* The Mandala grew five voices on four engines —
// the field's ring voices (`RingFieldVoice` over `RingAudioService`), the room's
// carrier and the climb's grounds (`HomeSoundService`), the struck bīja
// (`BijaSoundService`), the games' synth (`PlaySound`) — each managing itself,
// so a room opened over the Mandala sounded on top of the ring's drone, and a
// game opened at the source sounded on top of both.
//
// This is the one place every engine asks before it sounds. It decides, and
// each engine only does what it is told:
//
//   • **The Om is the floor.** 136.1 Hz, from the first place he stands in, at
//     a level that rises with depth (``TreeOfLife/omFloor(depth:)``). It never
//     competes: under any other voice it is let almost all the way down, and it
//     is heard only when everything else falls away — the crescendo is noise
//     decreasing.
//   • **One bed at a time — it hands over.** The continuous voices are beds:
//     the field, the room, a game. Only one sounds. Which one is not who came
//     last but what is in front of him: a game over the room over the field.
//     The others are not stopped — they are held at nothing, alive, and come
//     back the instant the one in front lets go.
//   • **A struck sound ducks.** A bīja, a bell: while it rings, the bed steps
//     back and the Om goes silent, and then both return.
//
// Existing pitches keep their character: nothing here touches a frequency, only
// how loud each engine stands. The silent switch is honoured exactly as each
// engine already honours it — this file never touches the audio session.

/// The voices the conductor arbitrates between.
enum SoundVoice: String, CaseIterable, Equatable {
    /// The Om at 136.1 — the floor.
    case om
    /// The Mandala's and the climb's ring voices (`RingFieldVoice`).
    case field
    /// Her room's carrier and the climb's grounds (`HomeSoundService`).
    case room
    /// A game's synth (`PlaySound`).
    case play
    /// A struck bīja (`BijaSoundService`).
    case bija
    /// The Rite's two bells.
    case bell

    enum Role: Equatable { case floor, bed, accent }

    var role: Role {
        switch self {
        case .om: return .floor
        case .field, .room, .play: return .bed
        case .bija, .bell: return .accent
        }
    }

    /// Which bed stands in front when more than one is asking.
    var priority: Int {
        switch self {
        case .play: return 3
        case .room: return 2
        case .field: return 1
        default: return 0
        }
    }
}

/// The pure decision: given who is asking, how loud each stands (`0…1`, a
/// multiplier on the engine's own level).
enum SoundArbiter {

    /// The Om under a bed — present, barely.
    static let omUnderBed = 0.15
    /// A bed while a struck sound rings.
    static let bedUnderAccent = 0.3

    /// The bed in front, if any.
    static func holder(of beds: Set<SoundVoice>) -> SoundVoice? {
        beds.filter { $0.role == .bed }.max { $0.priority < $1.priority }
    }

    static func gains(beds: Set<SoundVoice>, accenting: Bool) -> [SoundVoice: Double] {
        let front = holder(of: beds)
        var out: [SoundVoice: Double] = [:]
        for v in SoundVoice.allCases {
            switch v.role {
            case .bed:
                if v == front { out[v] = accenting ? bedUnderAccent : 1 } else { out[v] = 0 }
            case .floor:
                if accenting { out[v] = 0 } else { out[v] = front == nil ? 1 : omUnderBed }
            case .accent:
                out[v] = 1
            }
        }
        return out
    }

    /// The Om's absolute level: its floor at this depth times what the
    /// arbitration allows — or, while Panel 9 swells it, the swell.
    static func omLevel(depth: Int, multiplier: Double, swell: Double?) -> Double {
        if let swell {
            let top = TreeOfLife.omFloor(depth: 9)
            return (top + 0.05 * max(0, min(1, swell))) * (multiplier > 0 ? 1 : 0)
        }
        return TreeOfLife.omFloor(depth: depth) * multiplier
    }
}

/// The live conductor. Every engine calls in; nothing calls out but levels.
@MainActor
final class SoundConductor {

    static let shared = SoundConductor()

    private(set) var beds: Set<SoundVoice> = []
    private(set) var depth = 0
    private var accentUntil: Date?
    private var swell: Double?
    private var applied: [SoundVoice: Double] = [:]
    private var accentEnd: Task<Void, Never>?
    private var omLetGo: Task<Void, Never>?

    /// No sound in a unit-test host.
    private var allowed: Bool { !AppRuntime.isUnitTesting }

    private init() {}

    // MARK: What the engines say

    /// A bed is asking to sound.
    func claim(_ voice: SoundVoice) {
        guard voice.role == .bed else { return }
        if beds.insert(voice).inserted { apply() }
    }

    /// A bed has let go.
    func release(_ voice: SoundVoice) {
        if beds.remove(voice) != nil { apply() }
    }

    /// A struck sound rings for `seconds`.
    func strike(_ voice: SoundVoice, seconds: TimeInterval) {
        guard voice.role == .accent else { return }
        let until = Date().addingTimeInterval(max(0.2, seconds))
        accentUntil = max(accentUntil ?? until, until)
        apply()
        accentEnd?.cancel()
        let wait = (accentUntil ?? until).timeIntervalSinceNow
        accentEnd = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(max(0, wait)))
            guard !Task.isCancelled, let self else { return }
            self.accentUntil = nil
            self.apply()
        }
    }

    /// How deep he stands — the ring (`0` outside the yantra). The Om's floor
    /// follows it.
    func setDepth(_ ring: Int) {
        let d = max(0, min(9, ring))
        guard d != depth else { return }
        depth = d
        apply()
    }

    /// Panel 9: the Om rises on its own (`0…1`), or `nil` to give it back to
    /// its floor.
    func swellOm(_ e: Double?) {
        swell = e
        apply()
    }

    /// The app has left the foreground: let the Om go with everything else.
    func letGo() {
        beds.removeAll()
        swell = nil
        accentUntil = nil
        accentEnd?.cancel()
        omLetGo?.cancel()
        applied = [:]
        guard allowed else { return }
        RingAudioService.shared.omStop()
    }

    // MARK: Telling the engines

    private var accenting: Bool { (accentUntil.map { $0 > Date() }) ?? false }

    /// Whether he is standing anywhere the Om lives: in a place of the nine
    /// (the field, a room, the climb), or at the source while Panel 9 swells it.
    private var inPlace: Bool { beds.contains(.field) || beds.contains(.room) || swell != nil }

    private func apply() {
        let g = SoundArbiter.gains(beds: beds, accenting: accenting)
        set(.field, g[.field] ?? 1) { RingFieldVoice.shared.conductorGain = $0 }
        set(.room, g[.room] ?? 1) { HomeSoundService.shared.conductorGain = $0 }
        set(.play, g[.play] ?? 1) { PlaySound.shared.setConductorGain($0) }
        applyOm(multiplier: g[.om] ?? 1)
    }

    private func set(_ v: SoundVoice, _ value: Double, _ tell: (Double) -> Void) {
        guard applied[v] != value else { return }
        applied[v] = value
        guard allowed else { return }
        tell(value)
    }

    private func applyOm(multiplier: Double) {
        let level = SoundArbiter.omLevel(depth: depth, multiplier: multiplier, swell: swell)
        applied[.om] = level
        guard allowed else { return }
        let audio = RingAudioService.shared
        if inPlace {
            omLetGo?.cancel()
            omLetGo = nil
            if audio.omIsSounding { audio.omGain(Float(level)) } else { audio.omStart(gain: Float(level)) }
        } else if audio.omIsSounding, omLetGo == nil {
            // Between places (a room handing back to the Mandala) the Om holds;
            // only when he has stood nowhere for a few breaths does it go.
            audio.omGain(Float(level))
            omLetGo = Task { @MainActor [weak self] in
                try? await Task.sleep(for: .seconds(4))
                guard !Task.isCancelled, let self else { return }
                self.omLetGo = nil
                if !self.inPlace { RingAudioService.shared.omStop() }
            }
        }
    }
}
