import Foundation

// MARK: - U1 · D · the one hold engine (G0)
//
// `waves/upgrade/worlds/the-33-architecture.md` §2 D rows 31 (the hold engine)
// and 32 (one ladder of holds); `waves/register/11-padakarshini-forms.md:235-270`
// (gestures.md G0, every number); `waves/upgrade/worlds/verification.md` V25
// (holds need a real held press or key).
//
// The law, in the corpus's words: *"completion needs a real hold or a held key;
// an early release does nothing; the act waits for the release; there is no tap
// rate and no play-through."* And: *"Commit on the threshold, act on release."*
//
//   tick:    dt = min(64, t − last); p += target > p ? dt/UP_MS : −dt/DOWN_MS
//            p ≥ 1 && !locked → locked; onCommit()      (the visual commit)
//   press:   target = 1 (touch down, or Enter/Space down; key repeat ignored)
//   release: locked && !done → done; onComplete()        (act on release)
//            else target = 0                             (drains)
//
// *"Never a failure sound, never a jolt back to zero."* An early release drains
// over DOWN_MS (620–750 ms); pressing again while it drains rises from where
// the light is, not from nothing.
//
// This file is pure — no clock, no view, no sound. The time is handed in, so a
// test can drive it frame by frame (V25: "Engine test with driven clock").
// `HoldDriver` (HoldGesture.swift) gives it frames and a finger.

/// The durations of every hold in the app, as named constants — one ladder,
/// chosen by meaning (the-33-architecture.md §2 row 32; padakarshini G0 "Durations
/// in the corpus, choose by meaning"). Seconds.
enum HoldLadder {

    // MARK: The five named in the U1 brief (Part D item 1)

    /// Readiness — the Living Rite's embodiment crossing (G0 list: 750).
    static let readiness: TimeInterval = 0.750
    /// A gate — the Being hold ring, the Point's gate burst, the rope (G0: 1100).
    static let gate: TimeInterval = 1.100
    /// A story hold — the chakra shell's `hold_ms: 1800`
    /// (`Design/Chakra/shell/canon-adapter.js:40`, and `HOLD_DURATION = 1800`
    /// in the practice pages).
    static let story: TimeInterval = 1.800
    /// Sending — Ash's Compose, "hold to release" (G31: UP 2300 / DOWN 620).
    static let send: TimeInterval = 2.300
    /// The covenant — one breath, the Bindu's held threshold
    /// (`Design/Chakra/shell/bindu-engine.js:12` `BREATH = () => 5000 * pace()`;
    /// G0 list: 5000, "Bindu Immersive Act 0, one breath").
    static let covenant: TimeInterval = 5.000

    // MARK: The drain

    /// An early release drains at DOWN_MS 620–750 ms (G0). The gentler end is
    /// the default: the light goes back slowly, never with a jolt.
    static let drain: TimeInterval = 0.750
    /// Compose's own drain (G31: 2300 / **620**).
    static let sendDrain: TimeInterval = 0.620
    /// The band the corpus allows for a drain.
    static let drainBand: ClosedRange<TimeInterval> = 0.620...0.750

    // MARK: The room-gate ladder (the-33 §2 row 32; G3-0040…0045, G3-0212)

    /// Room gate holds fall as the body rises: Muladhara 3500 · Svadhisthana
    /// 3200 · Manipura 2800 · Anahata 2600 · Vishuddha 2400 · Ajna 2000 ·
    /// Sahasrara 1800 · Aatma/Soul 1500 ms (the gate framework,
    /// `gate-framework-all-chakras.html`, register G3-0212).
    static let roomGateLadder: [TimeInterval] = [3.500, 3.200, 2.800, 2.600, 2.400, 2.000, 1.800, 1.500]

    /// The ladder by Road number: roads 2–8 are Muladhara…Sahasrara, road 31
    /// is Aatma. Road 1, the Bindu, is one breath (`covenant`).
    static let roomGateByRoad: [Int: TimeInterval] = [
        2: 3.500, 3: 3.200, 4: 2.800, 5: 2.600, 6: 2.400, 7: 2.000, 8: 1.800, 31: 1.500,
    ]

    /// The gate hold of a room, or nil where the room's gate is an instrument
    /// (Body and Mind rooms; the-33 §2 row 32: "Body and Mind rooms' gates are
    /// instruments (no hold)").
    static func roomGate(road: Int) -> TimeInterval? {
        if road == 1 { return covenant }
        return roomGateByRoad[road]
    }

    // MARK: The rest of the ladder (the-33 §2 row 32), for the worlds to come

    /// The Veil (1800).
    static let veil: TimeInterval = 1.800
    /// The wake-up opening (5000).
    static let wakeUpOpening: TimeInterval = 5.000
    /// The forms-of-time ring (1100).
    static let formsOfTimeRing: TimeInterval = 1.100
    /// Withdraw from a room (2200; "hold to withdraw").
    static let withdraw: TimeInterval = 2.200
    /// A story beat in the corridor engine (1500).
    static let storyBeat: TimeInterval = 1.500
    /// Carve (≈ 2200; Lalita Mirror +0.05 / 110 ms).
    static let carve: TimeInterval = 2.200
    /// Lay down (G33: 2600).
    static let layDown: TimeInterval = 2.600
    /// The die (G29: 2200).
    static let die: TimeInterval = 2.200
    /// A Shadow corridor step held (700).
    static let shadowCorridorStep: TimeInterval = 0.700

    // MARK: The touch's geometry and the engine's frame (gestures.md :11–17)

    /// One frame never advances a hold by more than 64 ms (`dt = min(64, …)`),
    /// so a stalled frame cannot complete a hold the hand did not give.
    static let frameClamp: TimeInterval = 0.064
    /// Movement beyond 9 points cancels a hold.
    static let cancelDistance: Double = 9
    /// …the Door uses 7.
    static let doorCancelDistance: Double = 7
    /// …a still touch allows 24.
    static let stillTouchDistance: Double = 24
    /// A tap: moved < 9 points and lifted within 700 ms. A tap never completes
    /// a hold.
    static let tapMaxDistance: Double = 9
    static let tapMaxDuration: TimeInterval = 0.700

    // MARK: The hold's feel (G0 haptics; sound.md S78)

    /// The continuous ramp while held: intensity 0.15 → 0.6 …
    static let rampRange: ClosedRange<Double> = 0.15...0.60
    /// … at sharpness ≈ 0.3 (warm, never sharp).
    static let rampSharpness: Double = 0.30

    /// The ramp's intensity at progress `p` (0…1).
    static func rampIntensity(at p: Double) -> Double {
        let k = min(1, max(0, p))
        return rampRange.lowerBound + (rampRange.upperBound - rampRange.lowerBound) * k
    }
}

/// What is holding: a finger, or a hardware key (Enter / Space).
/// (the-33 §2 row 31: "Held Enter/Space with key-repeat ignored".)
enum HoldSource: Equatable {
    case touch
    case key
}

/// What a step of the engine reports (the-33 §2 row 31).
enum HoldEvent: Equatable {
    /// A real press began (touch down or key down; never a key repeat).
    case pressed
    /// The light reached full: the visual commit, at the threshold. Nothing is
    /// acted yet.
    case committed
    /// Released after the commit: the act. Permissions, sound, navigation and
    /// anything sent wait for this.
    case completed
    /// Released (or cancelled) before full: the light begins to drain. Nothing
    /// is said, nothing is felt.
    case letGo
    /// The drain reached nothing.
    case drained
}

/// The one hold engine — G0 (the-33-architecture.md §2 row 31). Pure: every
/// call takes the time, so a test drives it with a clock of its own.
struct HoldEngine: Equatable {

    /// How long a held press takes to fill (UP_MS), seconds.
    let rise: TimeInterval
    /// How long a full light takes to drain after an early release (DOWN_MS).
    let drain: TimeInterval

    /// 0…1.
    private(set) var progress: Double = 0
    private(set) var target: Double = 0
    /// Reached full while held (the "locked" of the source).
    private(set) var committed: Bool = false
    /// Released after the commit — done; the engine is inert until `reset()`.
    private(set) var completed: Bool = false
    /// Who is holding, if anyone.
    private(set) var heldBy: HoldSource?
    private var last: TimeInterval?
    private var draining: Bool = false

    init(rise: TimeInterval, drain: TimeInterval = HoldLadder.drain) {
        self.rise = max(0.001, rise)
        self.drain = max(0.001, drain)
    }

    var isHeld: Bool { heldBy != nil }

    /// Whether the engine still needs frames (held, or draining).
    var needsFrames: Bool { !completed && (heldBy != nil || draining || progress > 0) }

    /// A press. A key repeat, a second press while held, or a press after the
    /// act are ignored.
    @discardableResult
    mutating func press(at t: TimeInterval, by source: HoldSource, isRepeat: Bool = false) -> [HoldEvent] {
        guard !completed, !isRepeat, heldBy == nil else { return [] }
        var out = tick(at: t)
        heldBy = source
        target = 1
        draining = false
        last = t
        out.append(.pressed)
        return out
    }

    /// One frame. Advances by at most `HoldLadder.frameClamp`.
    @discardableResult
    mutating func tick(at t: TimeInterval) -> [HoldEvent] {
        guard let l = last else {
            last = t
            return []
        }
        let dt = min(HoldLadder.frameClamp, max(0, t - l))
        last = t
        guard !completed else { return [] }
        var out: [HoldEvent] = []
        if target > progress {
            progress = min(1, progress + dt / rise)
            if progress >= 1 - 1e-9 { progress = 1 }
        } else if target < progress {
            progress = max(0, progress - dt / drain)
            if progress <= 1e-9 { progress = 0 }
        }
        if progress >= 1, heldBy != nil, !committed {
            committed = true
            out.append(.committed)
        }
        if draining, progress <= 0 {
            draining = false
            out.append(.drained)
        }
        return out
    }

    /// The hand lifts (or the key comes up). After the commit this is the act;
    /// before it, the light drains. A release by a source that is not holding
    /// is ignored (a key coming up does not end a finger's hold).
    @discardableResult
    mutating func release(at t: TimeInterval, by source: HoldSource) -> [HoldEvent] {
        guard heldBy == source else { return [] }
        var out = tick(at: t)
        heldBy = nil
        if committed, !completed {
            completed = true
            target = 1
            out.append(.completed)
        } else {
            target = 0
            draining = true
            out.append(.letGo)
            if progress <= 0 {
                draining = false
                out.append(.drained)
            }
        }
        return out
    }

    /// The finger moved beyond the cancel distance (or the touch was taken
    /// away). It is a release that never acts, even after the commit: the act
    /// waits for a clean lift. The light drains.
    @discardableResult
    mutating func cancel(at t: TimeInterval) -> [HoldEvent] {
        guard heldBy != nil, !completed else { return [] }
        var out = tick(at: t)
        heldBy = nil
        committed = false
        target = 0
        draining = true
        out.append(.letGo)
        if progress <= 0 {
            draining = false
            out.append(.drained)
        }
        return out
    }

    /// The accessibility action: *"A voice performs an action; it never holds
    /// one"* (`Views/Rooms/TheWayOut.swift`). Commits and completes at once.
    @discardableResult
    mutating func performByVoice() -> [HoldEvent] {
        guard !completed else { return [] }
        var out: [HoldEvent] = []
        progress = 1
        target = 1
        heldBy = nil
        draining = false
        if !committed {
            committed = true
            out.append(.committed)
        }
        completed = true
        out.append(.completed)
        return out
    }

    /// Ready for another hold.
    mutating func reset() {
        progress = 0
        target = 0
        committed = false
        completed = false
        heldBy = nil
        last = nil
        draining = false
    }

    /// The progress as VoiceOver says it while held ("progressbar value while
    /// held", the-33 §2 row 31). A share of the hold, never a count of him.
    static func spokenProgress(_ p: Double) -> String {
        "\(Int((min(1, max(0, p)) * 100).rounded())) percent"
    }
}
