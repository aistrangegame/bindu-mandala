import Foundation
import CoreGraphics

// MARK: - Wave 4 · the physics of play (pure)
//
// Every game's skill lives here as plain values, so it can be tested without a
// screen, a touch or a speaker. The laws they keep (charter §3 law 7):
//
//  · **Failure is present-tense physics.** A hurried step makes the walls press
//    in; a flame starved of fuel gutters; a door pressed too hard simply does
//    not open (Wave 6, C-1357 — it no longer dims at him). Nothing
//    here ever subtracts what was already reached, resets a counter, or
//    returns a verdict.
//  · **Force is absorbed, never punished** (Bindu Feed's TouchSense): pressure
//    passes through a soft saturation, so a hard press is simply a full one.
//  · **Storage may count; the screen may not.** These types know how far he
//    has come, because physics needs it. No view turns any of it into a
//    numeral.

// MARK: TouchSense — force absorbed

enum TouchSense {
    /// The soft saturation every pressure passes through: 0 stays 0, a light
    /// touch reads light, and anything harder than "full" is still full.
    static func absorb(_ x: Double) -> Double {
        min(1, tanh(max(0, x) * 1.6) / tanh(1.6))
    }

    /// One pressure reading from what the glass can tell: a force sensor where
    /// there is one, and otherwise the size of the finger's pad — a fingertip
    /// is light, a flat thumb is heavy.
    static func pressure(force: Double, maximumForce: Double, majorRadius: Double) -> Double {
        if maximumForce > 0, force > 0 {
            return min(1, absorb(force / maximumForce))
        }
        let pad = (majorRadius - 7) / 28
        return min(1, absorb(min(max(pad, 0), 1.4)))
    }
}

// MARK: LightBody — posture

enum LightBody {
    /// The phone's roll, −1 (tipped left) … 1 (tipped right): gravity's own
    /// sideways share, so a phone lying flat reads level rather than noise.
    static func roll(gravityX: Double) -> Double {
        min(max(gravityX, -1), 1)
    }

    /// How upright the phone is held, 0 (flat on a table) … 1 (standing).
    static func uprightness(gravityZ: Double) -> Double {
        min(max(1 - abs(gravityZ), 0), 1)
    }
}

// MARK: The Corridor — pace (Shadow, the 3→4 crossing)

struct CorridorPace {
    /// The pace the body allows: one step every 800–1200 ms.
    static let window: ClosedRange<Double> = 0.8...1.2
    /// Steps at that pace to cross.
    static let stepsToCross = 24

    enum Step: Equatable { case first, inPace, hurried, lingering }

    private(set) var depth: Double = 0          // 0 … 1, never falls
    private(set) var press: Double = 0          // how close the walls stand, 0 … 1
    private var last: Double? = nil

    var crossed: Bool { depth >= 1 - 1e-9 }

    mutating func step(at t: Double) -> Step {
        defer { last = t }
        guard let prev = last else { return .first }
        let dt = t - prev
        if dt < Self.window.lowerBound {
            press = min(1, press + 0.34)
            return .hurried
        }
        if dt > Self.window.upperBound { return .lingering }
        depth = min(1, depth + 1 / Double(Self.stepsToCross))
        return .inPace
    }

    /// The walls ease back on their own.
    mutating func relax(dt: Double) {
        press = max(0, press - dt * 0.45)
    }
}

// MARK: Pulse — catching her in the act

struct HeartbeatCatch {
    private(set) var taps: [Double] = []

    mutating func tap(at t: Double) {
        if let last = taps.last, t - last > 2.4 { taps.removeAll() }   // a pause begins a new listening
        taps.append(t)
        if taps.count > 12 { taps.removeFirst(taps.count - 12) }
    }

    var intervals: [Double] {
        guard taps.count > 1 else { return [] }
        return (1..<taps.count).map { taps[$0] - taps[$0 - 1] }
    }

    /// The median interval — his heart's period as his finger has felt it.
    var period: Double? {
        let s = intervals.sorted()
        guard !s.isEmpty else { return nil }
        return s[s.count / 2]
    }

    /// How steady the last intervals are: 1 is a clock, 0 is scattered.
    var steadiness: Double {
        let iv = Array(intervals.suffix(7))
        guard iv.count >= 3 else { return 0 }
        let mean = iv.reduce(0, +) / Double(iv.count)
        guard mean > 0 else { return 0 }
        let variance = iv.reduce(0) { $0 + ($1 - mean) * ($1 - mean) } / Double(iv.count)
        let cv = sqrt(variance) / mean
        return max(0, min(1, 1 - cv / 0.25))
    }

    /// A heartbeat a finger could really be feeling: 40–150 beats a minute.
    var isPlausible: Bool {
        guard let p = period else { return false }
        return p >= 0.4 && p <= 1.5
    }

    /// Caught: eight beats, steady, at a heart's own pace.
    var caught: Bool { taps.count >= 8 && isPlausible && steadiness >= 0.55 }
}

// MARK: Spine Walk — attention, made visible (Axis)

struct SpineLight {
    /// The ten body chakras along the spine, Soles at the foot to Crow at the
    /// crown (The Map's Body system, in its own order). 0 is the foot.
    static let stations: [Double] = (0..<10).map { 0.05 + Double($0) * 0.1 }
    /// How long the light must rest at a station for it to light.
    static let restToLight: Double = 0.9
    /// The fastest the light can travel — a finger that rushes leaves it behind.
    static let maxSpeed: Double = 0.55   // spine-lengths a second

    private(set) var y: Double = 0.02
    private(set) var lit: Set<Int> = []
    private var rest: [Int: Double] = [:]

    var arrived: Bool { lit.count == Self.stations.count }

    mutating func follow(target: Double, dt: Double) {
        let goal = min(max(target, 0), 1)
        let step = Self.maxSpeed * max(0, dt)
        let delta = goal - y
        y += max(-step, min(step, delta))
        if let i = Self.station(near: y) {
            rest[i, default: 0] += dt
            if rest[i, default: 0] >= Self.restToLight { lit.insert(i) }
        }
    }

    static func station(near y: Double) -> Int? {
        for (i, s) in stations.enumerated() where abs(s - y) < 0.03 { return i }
        return nil
    }
}

// MARK: Echo — she answers, ending on a fifth

struct EchoExchange {
    /// The steps she climbs as he echoes her: root, second, third, fourth, fifth.
    static let ratios: [Double] = [1, 9.0 / 8, 5.0 / 4, 4.0 / 3, 3.0 / 2]
    /// The pitch of the point (charter §3 law 5), an octave up.
    static let base: Double = 272.2

    private(set) var degree = 0
    private(set) var lastAnswer: [Double] = []   // intervals she sounded

    var reachedFifth: Bool { degree >= Self.ratios.count - 1 }
    var frequency: Double { Self.base * Self.ratios[min(degree, Self.ratios.count - 1)] }

    /// He calls (`intervals` between his taps). If his call echoes her last
    /// answer she climbs a step; either way she answers his rhythm back.
    mutating func call(intervals: [Double]) -> [Double] {
        if !lastAnswer.isEmpty, Self.rhythmMatches(intervals, lastAnswer) {
            degree = min(degree + 1, Self.ratios.count - 1)
        }
        lastAnswer = intervals
        return intervals
    }

    /// Two rhythms match when they have the same number of beats and every
    /// interval is within 28% of its partner.
    static func rhythmMatches(_ a: [Double], _ b: [Double]) -> Bool {
        guard a.count == b.count, !a.isEmpty else { return false }
        for (x, y) in zip(a, b) {
            let m = max(x, y)
            guard m > 0, abs(x - y) / m <= 0.28 else { return false }
        }
        return true
    }
}

// MARK: Finger Garden — the drone swells with the garden (Hands)

enum GardenGrowth {
    /// Growth slows as the finger moves: a still finger grows, a busy one wanders.
    static func rate(fingerSpeed: Double) -> Double {
        let s = max(0, fingerSpeed)
        return 1 / (1 + s / 180)
    }

    /// The drone's gain for this many stems — Design's `min(.18, n × .014)`.
    static func droneGain(stems: Int) -> Double {
        min(0.18, Double(max(0, stems)) * 0.014)
    }

    /// The garden is in bloom.
    static let bloomStems = 12
}

// MARK: Rain — breath as wind on water (Prāṇa)

struct RainWind {
    private(set) var wind: Double = 0        // −0.6 … 0.6
    private(set) var breaths = 0             // storage may count
    private var swipeStart: Double? = nil
    private var swipeTravel: Double = 0

    static let breathsToCalm = 4
    /// A breath is a long, slow swipe: 2.2 – 9 seconds.
    static let breathSpan: ClosedRange<Double> = 2.2...9

    var calm: Bool { breaths >= Self.breathsToCalm }

    mutating func push(dx normalised: Double) {
        wind = max(-0.6, min(0.6, wind + normalised * 0.08))
        swipeTravel += abs(normalised)
    }

    mutating func began(at t: Double) { swipeStart = t; swipeTravel = 0 }

    /// A swipe ends. It counts as a breath when it was long and travelled.
    @discardableResult
    mutating func ended(at t: Double) -> Bool {
        defer { swipeStart = nil }
        guard let s = swipeStart else { return false }
        let span = t - s
        if Self.breathSpan.contains(span), swipeTravel > 0.35 {
            breaths += 1
            return true
        }
        return false
    }

    mutating func decay(dt: Double) {
        wind *= pow(0.985, max(0, dt) * 60)
    }
}

// MARK: The Drum — earth verbs (Soles)

struct DrumBeat {
    static let period: Double = 1.0       // 60 a minute
    static let tolerance: Double = 0.18
    static let depthToWater = 20

    enum Beat: Equatable { case first, onBeat, offBeat }

    private(set) var depth = 0            // never falls
    private var last: Double? = nil

    var reachedWater: Bool { depth >= Self.depthToWater }

    mutating func strike(at t: Double) -> Beat {
        defer { last = t }
        guard let prev = last else { return .first }
        if abs((t - prev) - Self.period) <= Self.tolerance {
            depth = min(Self.depthToWater, depth + 1)
            return .onBeat
        }
        return .offBeat
    }

    /// How deep the thump goes for a press — absorbed, so a harder strike is
    /// a fuller one, never a wrong one.
    static func thump(pressure: Double) -> Double {
        0.45 + 0.55 * TouchSense.absorb(pressure)
    }
}

// MARK: Root System — hold still, grow deep (Garimā)

struct RootGrowth {
    static let depthToRoot: Double = 1

    private(set) var depth: Double = 0    // never falls

    var rooted: Bool { depth >= Self.depthToRoot }

    /// `stillness` 0 … 1 (1 = the finger has not moved). Only stillness grows.
    mutating func grow(dt: Double, stillness: Double, fingers: Int) {
        guard fingers > 0 else { return }
        let s = min(max(stillness, 0), 1)
        let reach = 1 + 0.35 * Double(min(fingers, 3) - 1)
        depth = min(Self.depthToRoot, depth + max(0, dt) * s * s * reach / 22)
    }
}

// MARK: Water Level — a restoring force, and the phone's own tilt (Vārāhī)

struct WaterVessel {
    static let stiffness: Double = 9
    static let damping: Double = 1.6
    static let maxAngle: Double = 0.45
    static let stillToSettle: Double = 12

    private(set) var angle: Double = 0
    private(set) var velocity: Double = 0
    private(set) var stillFor: Double = 0

    var settled: Bool { stillFor >= Self.stillToSettle }

    /// One step. `tilt` is the phone's roll (−1 … 1); `nudge` an impulse from
    /// a finger or from the world (a thought, a notification).
    mutating func step(dt: Double, tilt: Double, nudge: Double = 0) {
        let h = min(max(dt, 0), 1.0 / 20)
        let force = -Self.stiffness * angle - Self.damping * velocity + tilt * 6
        velocity += (force * h) + nudge
        angle = max(-Self.maxAngle, min(Self.maxAngle, angle + velocity * h))
        let isStill = abs(velocity) < 0.03 && abs(angle) < 0.04
        stillFor = isStill ? stillFor + h : 0
    }
}

// MARK: The Fire — tend a band (Forge)

struct FireBand {
    static let band: ClosedRange<Double> = 0.15...0.82
    static let tendToKindle: Double = 60

    private(set) var fuel: Double = 0.5
    private(set) var tended: Double = 0   // never falls

    var kindled: Bool { tended >= Self.tendToKindle }
    var guttering: Bool { fuel < Self.band.lowerBound }
    var roaring: Bool { fuel > Self.band.upperBound }

    mutating func burn(dt: Double) {
        let h = max(0, dt)
        fuel = max(0, fuel - h * 0.11)
        if Self.band.contains(fuel) { tended = min(Self.tendToKindle, tended + h) }
    }

    /// A stick laid on — its size absorbed from the press.
    mutating func feed(pressure: Double) {
        fuel = min(1, fuel + 0.12 + 0.14 * TouchSense.absorb(pressure))
    }
}

// MARK: Shake to Clear — clearing the field (Crow)

struct ShakeClear {
    static let threshold: Double = 0.9     // g of user acceleration that counts as a shake

    private(set) var energy: Double = 0
    private(set) var cleared: Double = 0  // 0 … 1, never falls

    var isClear: Bool { cleared >= 1 - 1e-9 }

    mutating func feel(acceleration g: Double, dt: Double) {
        if g > Self.threshold { energy = min(1, energy + (g - Self.threshold) * 0.6) }
        energy = max(0, energy - max(0, dt) * 0.9)
        cleared = min(1, cleared + energy * max(0, dt) * 0.22)
    }

    /// A tap is a small shake, for a phone lying still or a walker who cannot.
    mutating func tapShake() { energy = min(1, energy + 0.5) }
}

// MARK: The Door — the become-small hold (Kaulinī)

struct DoorHold {
    static let seconds: Double = 2.8
    /// Above this pressure the door does not open: she is entered lightly.
    ///
    /// **Wave 6 · force is absorbed, never corrected** (C-1357, the wound of
    /// *"you are doing something wrong"*). Wave 4 dimmed the door under a hard
    /// press — a reaction aimed at him, a correction. Now a hard press simply
    /// does not open it: the door stays exactly as it was, neither brighter nor
    /// dimmer, and the force goes nowhere. It pauses the opening; it takes
    /// nothing back and says nothing.
    static let gentle: Double = 0.62

    private(set) var opened: Double = 0   // never falls
    /// The door resting while no finger is on it — the waiting of a door, never
    /// an answer to how he pressed.
    private(set) var dim: Double = 0

    var isOpen: Bool { opened >= 1 - 1e-9 }

    mutating func step(dt: Double, holding: Bool, pressure: Double) {
        let h = max(0, dt)
        if holding && pressure <= Self.gentle {
            opened = min(1, opened + h / Self.seconds)
            dim = max(0, dim - h * 2)
        } else if holding {
            // Absorbed: nothing changes under a hard press.
        } else {
            dim = min(0.6, dim + h * 0.4)
        }
    }
}

// MARK: Śrī Yantra — her address, line by line (the Bindu)

enum YantraTrace {
    /// The nine triangles in the order the yantra draws itself outward from
    /// the point (G17): the mūla trikoṇa first, then up and down alternating,
    /// innermost first. Indices are `MandalaYantra.triangles`' own.
    static let triangleOrder: [Int] = [4, 8, 3, 7, 2, 6, 1, 5, 0]

    /// Every edge, in drawing order, in the yantra's own world units (centre
    /// at the origin).
    static func edges(_ triangles: [(CGPoint, CGPoint, CGPoint)]) -> [(CGPoint, CGPoint)] {
        var out: [(CGPoint, CGPoint)] = []
        for i in triangleOrder where i < triangles.count {
            let t = triangles[i]
            out.append((t.0, t.1))
            out.append((t.1, t.2))
            out.append((t.2, t.0))
        }
        return out
    }

    static func distance(_ p: CGPoint, toSegment a: CGPoint, _ b: CGPoint) -> CGFloat {
        let ab = CGPoint(x: b.x - a.x, y: b.y - a.y)
        let len2 = ab.x * ab.x + ab.y * ab.y
        guard len2 > 0 else { return hypot(p.x - a.x, p.y - a.y) }
        var u = ((p.x - a.x) * ab.x + (p.y - a.y) * ab.y) / len2
        u = min(max(u, 0), 1)
        let q = CGPoint(x: a.x + u * ab.x, y: a.y + u * ab.y)
        return hypot(p.x - q.x, p.y - q.y)
    }

    /// Did this stroke draw the edge? It must begin near one end, finish near
    /// the other, and never stray from the line by more than `tolerance`.
    static func traces(_ stroke: [CGPoint], edge: (CGPoint, CGPoint), tolerance: CGFloat) -> Bool {
        guard stroke.count >= 3, let first = stroke.first, let last = stroke.last else { return false }
        let (a, b) = edge
        let reach = tolerance * 1.8
        let forward = hypot(first.x - a.x, first.y - a.y) <= reach && hypot(last.x - b.x, last.y - b.y) <= reach
        let backward = hypot(first.x - b.x, first.y - b.y) <= reach && hypot(last.x - a.x, last.y - a.y) <= reach
        guard forward || backward else { return false }
        return stroke.allSatisfy { distance($0, toSegment: a, b) <= tolerance }
    }
}

// MARK: The Garland — 102 beads, every bead a Śakti

struct Rosary {
    /// A pull faster than this slips: the bead does not move, nothing is lost.
    static let slipInterval: Double = 0.35
    /// Resting on a bead this long hands to her.
    static let restToFeel: Double = 1.6

    private(set) var bead: Int              // khaḍgamālā position, 1 … 102
    private(set) var started: Int
    private(set) var turned = 0             // beads moved this round; storage only
    private var lastPull: Double? = nil

    init(startingAt kp: Int) {
        let k = (1...KhadgamalaMap.total).contains(kp) ? kp : 1
        bead = k
        started = k
    }

    /// The round is whole when every bead has passed and he is home again.
    var roundComplete: Bool { turned >= KhadgamalaMap.total }

    static func next(after kp: Int) -> Int { kp >= KhadgamalaMap.total ? 1 : kp + 1 }

    /// A pull of the thread. Returns true when a bead moved.
    @discardableResult
    mutating func pull(at t: Double) -> Bool {
        if let l = lastPull, t - l < Self.slipInterval { return false }
        lastPull = t
        bead = Self.next(after: bead)
        turned += 1
        return true
    }

    /// Where bead `kp` hangs on the loop, 0 … 1 of the way round, with the
    /// current bead always at the bottom where the thumb is.
    func phase(of kp: Int) -> Double {
        let n = Double(KhadgamalaMap.total)
        var d = Double(kp - bead).truncatingRemainder(dividingBy: n)
        if d < 0 { d += n }
        return d / n
    }
}

// MARK: Bīja tones — the walk's own Awakening table

enum AwakeningTones {
    /// Ring → tone (Hz). The walk-canon's Awakening sounds, P1 … P8; the
    /// Bindu's P9 is silence — "the Om was always playing".
    static let table: [Int: Double] = [
        1: 174, 2: 210, 3: 320, 4: 341, 5: 384, 6: 426, 7: 480, 8: 528,
    ]

    static func frequency(ring: Int) -> Double? { table[ring] }

    /// The pulse the tone asks to be tapped at, in seconds between taps:
    /// one beat for every five cycles a second — 174 Hz asks for a slow pulse,
    /// 528 Hz a quick one.
    static func pulsePeriod(ring: Int) -> Double? {
        guard let f = frequency(ring: ring) else { return nil }
        return 60 / (f / 5)
    }

    /// Tuned: the last six taps land within 6% of the asked pulse.
    static func isTuned(taps: [Double], ring: Int) -> Bool {
        guard let p = pulsePeriod(ring: ring), taps.count >= 7 else { return false }
        let recent = Array(taps.suffix(7))
        for i in 1..<recent.count {
            if abs((recent[i] - recent[i - 1]) - p) / p > 0.06 { return false }
        }
        return true
    }
}

// MARK: Coherence — heart and breath meeting (Pulse; the Rite's breath)

enum Coherence {
    /// How near the breath holds a whole number of heartbeats: 1 when it is
    /// exact, 0 when it falls halfway between.
    static func meeting(breathPeriod: Double, heartPeriod: Double) -> Double {
        guard breathPeriod > 0, heartPeriod > 0 else { return 0 }
        let ratio = breathPeriod / heartPeriod
        let off = abs(ratio - ratio.rounded())
        return max(0, 1 - off * 2)
    }

    /// A breath the Rite would recognise: slow, 5 – 14 seconds.
    static let breathSpan: ClosedRange<Double> = 5...14

    /// Three slow breaths in a row in which heart and breath meet.
    static func met(breaths: [Double], heartPeriod: Double?) -> Bool {
        guard let h = heartPeriod, breaths.count >= 3 else { return false }
        return breaths.suffix(3).allSatisfy {
            breathSpan.contains($0) && meeting(breathPeriod: $0, heartPeriod: h) >= 0.7
        }
    }
}
