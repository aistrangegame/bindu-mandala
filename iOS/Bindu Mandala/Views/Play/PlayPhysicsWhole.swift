import Foundation
import CoreGraphics

// MARK: - Wave 6 · Slice E — the physics of every game (pure)
//
// The skills of the twenty games Wave 6 brings home, as plain values, so each
// can be tested without a screen, a touch or a speaker. The same laws as
// Wave 4's `PlayPhysics.swift`:
//
//  · **Failure is present-tense physics.** A rushed turn slips, a hurried
//    stroke rolls back, a missed gate bounces the light up again. What was
//    reached is never taken back.
//  · **Storage may count; the screen may not.** These types know how far he
//    has come because physics needs to. No view turns any of it into a numeral.
//  · **Gains, never renunciations** (Codex C-1230): every verb here receives.

// MARK: Small shared helpers

enum PlayMath {
    static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }

    /// The shortest signed turn from `a` to `b`, −π … π.
    static func wrap(_ a: Double) -> Double {
        var x = a.truncatingRemainder(dividingBy: 2 * Double.pi)
        if x > Double.pi { x -= 2 * Double.pi }
        if x < -Double.pi { x += 2 * Double.pi }
        return x
    }

    /// A value carried toward a goal no faster than `rate` a second — the
    /// rate-limit every attention game in the corpus is built on.
    static func carry(_ value: Double, toward goal: Double, rate: Double, dt: Double) -> Double {
        let step = max(0, rate) * max(0, dt)
        return value + max(-step, min(step, goal - value))
    }

    /// A deterministic shuffle, so a scrambled board is the same board on
    /// every run of the same seed (and a test can hold it).
    static func shuffled(_ n: Int, seed: UInt64) -> [Int] {
        var out = Array(0..<n)
        var s = seed &+ 0x9E37_79B9_7F4A_7C15
        guard n > 1 else { return out }
        for i in stride(from: n - 1, to: 0, by: -1) {
            s = s &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            let j = Int((s >> 33) % UInt64(i + 1))
            out.swapAt(i, j)
        }
        return out
    }
}

// MARK: The Seed — planted, and grown by real time (Sarva-Bīja, kp 26)

enum SeedGrowth {
    /// The corpus's own stages: seed, sprout at two hours, sapling at eight,
    /// tree at a day, bloom at three days.
    enum Stage: Int, CaseIterable, Equatable {
        case seed, sprout, sapling, tree, bloom
    }

    static let bloomHours: Double = 72

    static func stage(hours h: Double) -> Stage {
        if h < 2 { return .seed }
        if h < 8 { return .sprout }
        if h < 24 { return .sapling }
        if h < bloomHours { return .tree }
        return .bloom
    }

    /// Growth 0 … 1, easing, for the drawing: quick at first, slow to bloom.
    static func growth(hours h: Double) -> Double {
        let x = PlayMath.clamp01(max(0, h) / bloomHours)
        return 1 - pow(1 - x, 2.2)
    }
}

/// Planting: the finger presses the seed into the earth, and only a still,
/// unhurried press sinks it. Lifting leaves it as deep as it went.
struct SeedPress {
    static let seconds: Double = 2.4

    private(set) var sunk: Double = 0     // never falls

    var planted: Bool { sunk >= 1 - 1e-9 }

    mutating func step(dt: Double, pressing: Bool, stillness: Double) {
        guard pressing else { return }
        sunk = min(1, sunk + max(0, dt) * PlayMath.clamp01(stillness) / Self.seconds)
    }
}

// MARK: Mandala Completion — the missing petal (Integration, ring 7)

enum MandalaPetals {
    /// Three mandalas, each fuller than the last.
    static let rounds: [Int] = [8, 12, 16]

    /// Petal `i` of `n`: its base on the inner circle, its tip on the outer.
    static func petal(_ i: Int, of n: Int, center c: CGPoint,
                      inner: CGFloat, outer: CGFloat, turn: Double = 0) -> (base: CGPoint, tip: CGPoint) {
        let a = turn - Double.pi / 2 + 2 * Double.pi * Double(i) / Double(max(1, n))
        let base = CGPoint(x: c.x + inner * CGFloat(cos(a)), y: c.y + inner * CGFloat(sin(a)))
        let tip = CGPoint(x: c.x + outer * CGFloat(cos(a)), y: c.y + outer * CGFloat(sin(a)))
        return (base, tip)
    }

    /// Which petal is missing in a round — a different one each round.
    static func missing(round: Int, of n: Int) -> Int {
        guard n > 0 else { return 0 }
        return (round * 5 + 3) % n
    }
}

// MARK: The 12 — find the order by feeling (the Vāk ring, ring 7)

/// Twelve lights round a circle, each with a tone. The order is found when
/// every neighbour sounds a fifth above the last, all the way round — the
/// circle of fifths closing on itself. Nothing is scored: two lights in their
/// true relation simply sing together.
struct TwelveCircle {
    static let size = 12

    /// `order[slot]` is the tone standing in that slot (0 … 11, its step on
    /// the circle of fifths).
    private(set) var order: [Int]

    init(seed: UInt64) {
        var o = PlayMath.shuffled(Self.size, seed: seed)
        if Self.whole(o) { o.swapAt(0, 1) }
        order = o
    }

    init(order: [Int]) { self.order = order }

    mutating func swap(_ a: Int, _ b: Int) {
        guard order.indices.contains(a), order.indices.contains(b), a != b else { return }
        order.swapAt(a, b)
    }

    /// The join after slot `i` sings when its two tones are one fifth apart
    /// (either way round).
    func sings(after i: Int) -> Bool {
        let a = order[i % Self.size], b = order[(i + 1) % Self.size]
        let d = ((b - a) % Self.size + Self.size) % Self.size
        return d == 1 || d == Self.size - 1
    }

    var isWhole: Bool { Self.whole(order) }

    static func whole(_ o: [Int]) -> Bool {
        guard o.count == size else { return false }
        let steps = (0..<size).map { ((o[($0 + 1) % size] - o[$0]) % size + size) % size }
        return steps.allSatisfy { $0 == 1 } || steps.allSatisfy { $0 == size - 1 }
    }

    /// Step `k` of the circle of fifths, folded into one octave above the
    /// point's pitch an octave up (272.2 Hz).
    static func frequency(tone k: Int) -> Double {
        var f = 272.2 * pow(1.5, Double(((k % size) + size) % size))
        while f >= 544.4 { f /= 2 }
        return f
    }
}

// MARK: Body Map — where it is felt right now (Sarvajñā, kp 77)

enum BodyMark: Equatable {
    /// Energy — a light touch, the centre warms and blooms.
    case alive
    /// Holding — a firm press, a knot of light that is simply there.
    case held
    /// Nothing there — a touch with no weight, open space.
    case open
}

enum BodyListening {
    /// How long a finger rests on a centre before the centre answers.
    static let restToMark: Double = 1.2

    /// The mark a resting finger leaves, read from its pressure (absorbed).
    /// Every mark is welcome; none is better than another.
    static func mark(meanPressure p: Double, rested: Double) -> BodyMark? {
        guard rested >= restToMark else { return nil }
        if p < 0.12 { return .open }
        if p < 0.55 { return .alive }
        return .held
    }
}

// MARK: Shadow Translator — turning the burden over (Bhagamālinī, kp 101)

/// The burden is a word with two faces: the ring's Mental State on the face
/// he sees, its Siddhi on the face beneath. He turns it with a circling
/// finger; the word follows no faster than a turn can be felt, so a rushing
/// finger simply leaves it behind. Once it has turned over it stays turned.
struct TurningWord {
    /// The fastest the word will turn, radians a second.
    static let maxRate: Double = 1.6

    private(set) var face: Double = 0        // 0 … π, never falls once turned
    private(set) var turned = false
    private var goal: Double = 0

    mutating func turn(by dTheta: Double) {
        goal = min(Double.pi, max(0, goal + abs(dTheta) * 0.75))
    }

    mutating func step(dt: Double) {
        face = max(face, PlayMath.carry(face, toward: goal, rate: Self.maxRate, dt: dt))
        goal = max(goal, face)
        if face >= Double.pi - 1e-6 { turned = true; face = Double.pi }
    }

    /// −1 … 1: the word's width as it turns (it is edge-on at π / 2).
    var width: Double { cos(face) }
}

// MARK: Mirror Maze — one word through seven lenses (Buddhyākarṣiṇī, kp 30)

/// His word falls as a light through seven lenses, steered by the phone's
/// tilt (or a finger). A lens's opening is passed; a light that misses
/// simply rises back above it and falls again.
struct MazeFall {
    static let lenses = 7
    /// How wide each opening is, 0 … 1 of the glass.
    static let opening: Double = 0.26
    static let fallRate: Double = 0.16      // glass-heights a second
    static let steerRate: Double = 0.9

    private(set) var x: Double = 0.5
    private(set) var y: Double = 0.0
    private(set) var passed = 0             // lenses passed — storage only
    private(set) var bounce: Double = 0

    var through: Bool { passed >= Self.lenses }

    /// Where lens `k` stands (its height) and its opening's centre.
    static func lens(_ k: Int) -> (y: Double, centre: Double) {
        let y = 0.16 + 0.11 * Double(k)
        let centre = 0.5 + 0.28 * sin(Double(k) * 2.1 + 0.7)
        return (y, min(0.82, max(0.18, centre)))
    }

    mutating func step(dt: Double, steer: Double) {
        guard !through else { return }
        let h = max(0, dt)
        let push: Double = min(1, abs(steer)) * (steer < 0 ? -1.0 : 1.0)
        let nextX: Double = x + push * Self.steerRate * h
        x = min(0.97, max(0.03, nextX))
        bounce = max(0, bounce - h * 1.5)
        y += Self.fallRate * h
        let gate = Self.lens(passed)
        if y >= gate.y {
            if abs(x - gate.centre) <= Self.opening / 2 {
                passed += 1
            } else {
                y = gate.y - 0.07
                bounce = 1
            }
        }
    }
}

// MARK: The Letter — written, folded, sealed (Kāmeśī, kp 88)

/// The wax warms under a press (absorbed: a harder press warms it faster,
/// never wrongly) and sets once it is warm and the finger has stayed.
struct WaxSeal {
    static let warmSeconds: Double = 2.2

    private(set) var warmth: Double = 0     // never falls
    var isSet: Bool { warmth >= 1 - 1e-9 }

    mutating func press(dt: Double, pressure: Double) {
        let rate = (0.55 + 0.45 * TouchSense.absorb(pressure)) / Self.warmSeconds
        warmth = min(1, warmth + max(0, dt) * rate)
    }
}

/// The fold: the page is drawn down over itself by a slow pull.
struct LetterFold {
    static let rate: Double = 0.7            // of a page a second, at most

    private(set) var folded: Double = 0      // 0 … 1, never falls

    var isFolded: Bool { folded >= 1 - 1e-9 }

    mutating func pull(toward goal: Double, dt: Double) {
        folded = max(folded, PlayMath.carry(folded, toward: PlayMath.clamp01(goal), rate: Self.rate, dt: dt))
    }
}

// MARK: Flash · Intuition — catch what already knows (Aruṇā, kp 91)

struct FlashCatch {
    /// How long a flash stands before it fades.
    static let shows: Double = 0.95
    static let reach: CGFloat = 70

    /// Did a tap at `tap`, `since` seconds after a flash at `flash` appeared,
    /// catch it?
    static func caught(tap: CGPoint, flash: CGPoint, since: Double) -> Bool {
        since >= 0 && since <= shows && hypot(tap.x - flash.x, tap.y - flash.y) <= reach
    }
}

// MARK: Still · Ājñā — the screen waits in the dark (Anaṅga-Aṅkuśā, kp 51)

/// The dark deepens only while he is still, and never lifts again.
struct WaitingDark {
    static let seconds: Double = 30

    private(set) var dark: Double = 0       // never falls

    var isDeep: Bool { dark >= 1 - 1e-9 }

    mutating func step(dt: Double, still: Bool) {
        guard still else { return }
        dark = min(1, dark + max(0, dt) / Self.seconds)
    }
}

// MARK: Tat Tvam Asi — three words, three breaths (Armin, 6 → 7)

struct ThreeWords {
    static let words = ["Tat", "Tvam", "Asi"]
    static let breath: Double = 2.6

    private(set) var arrived = 0            // words arrived — storage only
    private(set) var held: Double = 0
    private(set) var joined = false

    var allArrived: Bool { arrived >= Self.words.count }

    /// While held, the next word condenses.
    mutating func step(dt: Double, holding: Bool) {
        guard !allArrived else { return }
        if holding {
            held += max(0, dt)
            if held >= Self.breath {
                arrived += 1
                held = 0
            }
        } else {
            held = max(0, held - max(0, dt) * 0.5)
        }
    }

    /// Two fingers brought together join the three into one.
    mutating func bringTogether(distance: CGFloat) {
        if allArrived, distance < 70 { joined = true }
    }
}

// MARK: Shadow — the scrolls (the 3 → 4 crossing)

/// Each line is unrolled by a slow pull downward. A pull faster than the
/// scroll can unroll only carries as much as the scroll can give.
struct ScrollUnroll {
    static let lines: [String] = [
        "The creativity that was called impractical.",
        "The sensitivity that was called weakness.",
        "The anger that was called unacceptable.",
        "The ambition that was called greedy.",
        "The softness that was called liability.",
        "The wildness that was called chaos.",
        "None of it was wrong.",
        "All of it was too large for the container.",
        "So it went underground.",
        "Not destroyed. Compressed. Stored.",
        "Waiting for a bigger container.",
        "You are a bigger container now.",
    ]
    /// Points of pull to unroll one line, and the fastest a scroll unrolls.
    static let pullPerLine: Double = 110
    static let maxRate: Double = 260

    private(set) var unrolled: Double = 0   // in lines; never falls

    var line: Int { min(Self.lines.count, Int(unrolled)) }
    var isOpen: Bool { unrolled >= Double(Self.lines.count) - 1e-9 }

    mutating func pull(dy: Double, dt: Double) {
        guard dy > 0, dt > 0 else { return }
        let carried = min(dy, Self.maxRate * dt)
        unrolled = min(Double(Self.lines.count), unrolled + carried / Self.pullPerLine)
    }
}

// MARK: Colour Rivers — pour, and watch them mingle (Sarva-Vidrāviṇī, kp 20)

enum RiverColours {
    /// Two colours mixed as light mixes.
    static func blend(_ a: (Double, Double, Double), _ b: (Double, Double, Double),
                      _ t: Double = 0.5) -> (Double, Double, Double) {
        let k = PlayMath.clamp01(t)
        return (a.0 + (b.0 - a.0) * k, a.1 + (b.1 - a.1) * k, a.2 + (b.2 - a.2) * k)
    }
}

struct RiverMingle {
    static let toSea: Double = 1

    private(set) var mingled: Double = 0    // never falls
    var reachedSea: Bool { mingled >= Self.toSea - 1e-9 }

    /// `overlap` 0 … 1: how much of the water is two colours meeting.
    mutating func flow(overlap: Double, dt: Double) {
        mingled = min(Self.toSea, mingled + PlayMath.clamp01(overlap) * max(0, dt) / 14)
    }
}

// MARK: The World in a Box — every practice leaves an object, never a total

enum WorldBox {
    enum Thing: String, CaseIterable, Equatable {
        case plant, cloud, drum, firefly, tree, letter, gate, stone, flame, shell
    }

    /// What a game leaves in the world.
    static func thing(forGame raw: String) -> Thing {
        switch raw {
        case "fingerGarden", "rootSystem", "colourRivers": return .plant
        case "rain", "waterLevel", "sandhya":              return .cloud
        case "drum", "pulse", "echo", "coherence", "bijaTones", "twelve": return .drum
        case "rosary", "ramJapa":                          return .firefly
        case "seed", "greatWheel":                         return .tree
        case "letter", "mirrorMaze", "flash":              return .letter
        case "corridor", "door", "shadowScrolls", "tatTvamAsi", "leela": return .gate
        case "fire", "bhakti":                             return .flame
        case "yantraTrace", "mandalaCompletion", "turn", "join": return .shell
        default:                                           return .stone
        }
    }

    /// Gifts that arrived while he was away: one for each whole day he was
    /// gone, never more than three — a gift is never a debt.
    static func gifts(lastVisit: Date?, now: Date) -> Int {
        guard let l = lastVisit else { return 1 }
        let days = Int(max(0, now.timeIntervalSince(l)) / 86_400)
        return min(3, days)
    }

    /// Where an object stands on the floor of the box, 0 … 1 each way —
    /// scattered by its own index so the world is the same world each visit.
    static func place(_ i: Int) -> (x: Double, z: Double) {
        let a = Double(i) * 2.399963
        let r = 0.18 + 0.30 * sqrt(Double(i % 37) / 37)
        return (0.5 + r * cos(a), 0.5 + r * sin(a) * 0.8)
    }
}

// MARK: Leela on the 33 — the board (Lalitā, kp 102)

enum LeelaBoard {
    static let squares = 33
    /// Square 32 is held: sealed, with no content (the skill's own ruling).
    static let held = 32
    /// Arrows: an act of giving lifts him (first draft, as authored).
    static let arrows: [Int: Int] = [5: 8, 12: 18, 13: 20, 26: 29]
    /// Snakes: a turn of the road — the square's practice, made small.
    static let snakes: [Int: Int] = [15: 6, 19: 10, 28: 21, 30: 9]

    enum Move: Equatable {
        /// Unborn, and the die did not show a six: the die rests.
        case unbornRests
        /// A six: born onto the first square.
        case born
        /// The throw would carry past the last square: the die rests.
        case rests
        case walked(to: Int)
        case arrow(from: Int, to: Int)
        case snake(from: Int, to: Int)
        case arrived
    }
}

struct LeelaWalk {
    /// `nil` is unborn — at the start, before the first six.
    private(set) var square: Int? = nil

    var arrived: Bool { square == LeelaBoard.squares }

    @discardableResult
    mutating func throwDie(_ n: Int) -> LeelaBoard.Move {
        guard (1...6).contains(n), !arrived else { return .rests }
        guard let at = square else {
            if n == 6 { square = 1; return .born }
            return .unbornRests
        }
        let to = at + n
        if to > LeelaBoard.squares { return .rests }
        if to == LeelaBoard.squares { square = to; return .arrived }
        if let up = LeelaBoard.arrows[to] { square = up; return .arrow(from: to, to: up) }
        if let down = LeelaBoard.snakes[to] { square = down; return .snake(from: to, to: down) }
        square = to
        return .walked(to: to)
    }

    /// Where road square `i` (1 … 33) lies on the board: centre → perimeter →
    /// spiralling back to the centre, 0 … 1 of the board's radius.
    static func spot(_ i: Int) -> (angle: Double, radius: Double) {
        let u = Double(max(1, min(LeelaBoard.squares, i)) - 1) / Double(LeelaBoard.squares - 1)
        return (angle: -Double.pi / 2 + u * 2 * Double.pi * 1.5, radius: sin(u * Double.pi))
    }
}

// MARK: Turn — three rings turned until their marks meet (ring 8)

struct TurningRings {
    static let tolerance: Double = 0.09
    static let friction: Double = 1.8
    /// Turning a ring carries its inner neighbour a little — the skill.
    static let coupling: Double = 0.3

    private(set) var angles: [Double]
    private(set) var velocities: [Double] = [0, 0, 0]

    init(angles: [Double] = [2.1, -1.4, 0.9]) { self.angles = angles }

    mutating func drag(ring r: Int, by dTheta: Double, dt: Double) {
        guard angles.indices.contains(r) else { return }
        angles[r] += dTheta
        if r > 0 { angles[r - 1] += dTheta * Self.coupling }
        if dt > 0 { velocities[r] = dTheta / dt }
    }

    mutating func release(ring r: Int) {}

    mutating func step(dt: Double, holding: Set<Int>) {
        let h = max(0, dt)
        for i in angles.indices where !holding.contains(i) {
            angles[i] += velocities[i] * h
            velocities[i] *= exp(-Self.friction * h)
            if abs(velocities[i]) < 0.01 { velocities[i] = 0 }
        }
    }

    /// The three marks meet at the top, and the rings have come to rest.
    var aligned: Bool {
        angles.allSatisfy { abs(PlayMath.wrap($0)) <= Self.tolerance }
            && velocities.allSatisfy { abs($0) < 0.05 }
    }

    /// 0 … 1: how near the marks stand to meeting, for the light.
    var nearness: Double {
        let worst = angles.map { abs(PlayMath.wrap($0)) }.max() ?? Double.pi
        return PlayMath.clamp01(1 - worst / Double.pi)
    }
}

// MARK: Join — two that never touched (Jayinī, kp 92)

enum JoinMeeting {
    enum Outcome: Equatable { case apart, bounce, join }
    static let touch: CGFloat = 34
    /// The gentlest meeting still joins; a collision bounces them apart.
    static let gentle: CGFloat = 260

    static func meet(distance: CGFloat, closingSpeed: CGFloat) -> Outcome {
        guard distance <= touch else { return .apart }
        return closingSpeed <= gentle ? .join : .bounce
    }
}

// MARK: Ram japa — a mālā of the name with his breath (the Bindu, his own)

/// The name is his, not a Śakti's (Codex C-1222, C-1325). A bead moves on a
/// whole breath: held while the breath comes in, let go as it leaves. A
/// flick is not a breath and moves nothing.
struct JapaMala {
    static let beads = 108
    static let breathIn: ClosedRange<Double> = 1.8...14

    private(set) var bead = 0                // never falls; storage only
    private var inhaleAt: Double? = nil

    var roundWhole: Bool { bead >= Self.beads }

    mutating func inhale(at t: Double) { inhaleAt = t }

    @discardableResult
    mutating func exhale(at t: Double) -> Bool {
        defer { inhaleAt = nil }
        guard let s = inhaleAt, !roundWhole, Self.breathIn.contains(t - s) else { return false }
        bead += 1
        return true
    }
}

// MARK: Bhakti at Maṇipūra — the ārati offered at the navel (kp 24)

/// Offering, not fire-tending (C-1230: something to get, not something to
/// give up). The lamp circles her point clockwise at an even pace; each whole
/// circle comes back to the lamp as light received. A rushed circle only makes
/// the flame flicker; a circle the other way simply does not gather.
struct Arati {
    static let gentle: ClosedRange<Double> = 0.3...2.4    // rad/s
    static let circlesToOffer = 7

    private(set) var swept: Double = 0
    private(set) var circles = 0             // storage only
    private(set) var flicker: Double = 0
    private var lastAngle: Double? = nil

    var offered: Bool { circles >= Self.circlesToOffer }

    /// The lamp at `angle` (screen coordinates: positive is clockwise).
    @discardableResult
    mutating func follow(angle: Double, dt: Double) -> Bool {
        defer { lastAngle = angle }
        flicker = max(0, flicker - max(0, dt) * 1.4)
        guard let last = lastAngle, dt > 0 else { return false }
        let d = PlayMath.wrap(angle - last)
        let rate = abs(d) / dt
        if rate > Self.gentle.upperBound { flicker = min(1, flicker + 0.12); return false }
        guard d > 0, rate >= Self.gentle.lowerBound * 0.5 else { return false }
        swept += d
        if swept >= 2 * Double.pi, !offered {
            swept -= 2 * Double.pi
            circles += 1
            return true
        }
        return false
    }

    mutating func lift() { lastAngle = nil }
}

// MARK: The sandhyās — dawn, noon, dusk as small practices

enum SandhyaPractice: Equatable, CaseIterable {
    case dawn, noon, dusk

    /// The Temporal Layer's own invitation (temporal.jsx, Instrument 3).
    var invitation: String {
        switch self {
        case .dawn: return "Open the eyes\nbefore the world opens them for you."
        case .noon: return "The sun has nothing to hide.\nNeither do you."
        case .dusk: return "What you carried today\nyou may set down here."
        }
    }

    var junction: String {
        switch self {
        case .dawn: return "Prātaḥ sandhyā"
        case .noon: return "Madhyāhna sandhyā"
        case .dusk: return "Sāyaṃ sandhyā"
        }
    }

    /// The junction nearest to `now`, by the day's own sun (Wave 5's
    /// ephemeris). At a junction it is that junction; between them, the one
    /// the day is nearest.
    static func nearest(to now: Date, sun: Panchanga.SunTimes) -> SandhyaPractice {
        let candidates: [(SandhyaPractice, Date?)] = [(.dawn, sun.rise), (.noon, sun.noon), (.dusk, sun.set)]
        var best = SandhyaPractice.noon
        var bestD = Double.greatestFiniteMagnitude
        for (p, t) in candidates {
            guard let when = t else { continue }
            let d = abs(now.timeIntervalSince(when))
            if d < bestD { bestD = d; best = p }
        }
        // Deep night belongs to the dusk that began it, or the dawn ahead.
        if let set = sun.set, now > set { return .dusk }
        if let rise = sun.rise, now < rise { return .dawn }
        return best
    }
}

/// The light a junction practice carries — dawn's horizon opening, noon's
/// sun overhead, dusk's light set down — at the pace of a breath.
struct JunctionLight {
    static let rate: Double = 0.12           // of the whole, a second at most

    private(set) var level: Double = 0       // never falls

    var isWhole: Bool { level >= 1 - 1e-9 }

    mutating func carry(toward goal: Double, dt: Double) {
        level = max(level, PlayMath.carry(level, toward: PlayMath.clamp01(goal), rate: Self.rate, dt: dt))
    }

    /// Noon's stillness adds light while the phone lies open to the sky.
    mutating func gather(dt: Double, rate: Double) {
        level = min(1, level + max(0, dt) * max(0, rate))
    }
}

// MARK: The seasonal yantra and the Great Wheel

enum SeasonLight {
    /// The ṛtu's own light for the yantra, (r, g, b) 0 … 1 — from the
    /// Temporal Layer's seasonal glows, with Śiśira and Varṣā between.
    static func colour(_ r: Panchanga.Rtu) -> (Double, Double, Double) {
        switch r {
        case .shishira: return (0.62, 0.68, 0.86)
        case .vasanta:  return (0.71, 0.79, 0.48)
        case .grishma:  return (0.91, 0.59, 0.31)
        case .varsha:   return (0.47, 0.66, 0.78)
        case .sharad:   return (0.83, 0.63, 0.40)
        case .hemanta:  return (0.55, 0.63, 0.78)
        }
    }

    /// How brightly the yantra stands in the season (`yantraIntensity`).
    static func intensity(_ r: Panchanga.Rtu) -> Double {
        switch r {
        case .shishira: return 0.75
        case .vasanta:  return 0.95
        case .grishma:  return 1.3
        case .varsha:   return 1.1
        case .sharad:   return 1.0
        case .hemanta:  return 0.65
        }
    }

    /// The season's own two lines (temporal.jsx, Instrument 4); Śiśira and
    /// Varṣā take their neighbour's.
    static func poetry(_ r: Panchanga.Rtu) -> String {
        switch r {
        case .vasanta:            return "after the long silence,\nthe field begins to remember itself."
        case .grishma, .varsha:   return "the heat is her presence.\nthe brightness is her presence."
        case .sharad:             return "the sky is cool. the air is exact.\nshe shows herself without ornament."
        case .hemanta, .shishira: return "she is in the seed now.\nyou keep her warm inside you."
        }
    }
}

enum GreatWheel {
    /// Where a day stands on the year's wheel, radians, with Śiśira's opening
    /// (the winter solstice) at the top.
    static func angle(of date: Date) -> Double {
        let fromSolstice = Ephemeris.normalized(Ephemeris.sunLongitude(date) - 270)
        return -Double.pi / 2 + fromSolstice / 360 * 2 * Double.pi
    }

    /// The wheel, flung and let go. It slows by friction; near rest, today's
    /// mark is drawn the last little way to the point at the top.
    struct Spin {
        static let friction: Double = 0.9
        static let catchWithin: Double = 0.35
        static let tolerance: Double = 0.04

        private(set) var turn: Double
        private(set) var velocity: Double = 0

        init(turn: Double) { self.turn = turn }

        mutating func drag(by d: Double, dt: Double) {
            turn += d
            if dt > 0 { velocity = d / dt }
        }

        /// `today` is today's angle on the wheel; the wheel is at rest with
        /// today at the top when `turn + today` is −π/2.
        mutating func step(dt: Double, holding: Bool, today: Double) {
            guard !holding else { return }
            let h = max(0, dt)
            turn += velocity * h
            velocity *= exp(-Self.friction * h)
            let off = PlayMath.wrap(turn + today + Double.pi / 2)
            if abs(velocity) < 0.6, abs(off) < Self.catchWithin {
                velocity -= off * 3.2 * h * 4
                velocity *= exp(-3 * h)
            }
            if abs(velocity) < 0.002 { velocity = 0 }
        }

        func resting(today: Double) -> Bool {
            abs(velocity) < 0.03 && abs(PlayMath.wrap(turn + today + Double.pi / 2)) <= Self.tolerance
        }
    }
}

// MARK: Ring 2 — the lotus following the sun

enum LotusSun {
    /// How open the lotus is at `now`: resting at night, opening from the
    /// sunrise, full at the noon, closing to the sunset.
    static func openness(at now: Date, sun: Panchanga.SunTimes) -> Double {
        let rest = 0.35
        guard let rise = sun.rise, let set = sun.set, set > rise else { return 0.7 }
        if now <= rise || now >= set { return rest }
        let noon = sun.noon
        let u: Double
        if now <= noon {
            u = now.timeIntervalSince(rise) / max(1, noon.timeIntervalSince(rise))
        } else {
            u = set.timeIntervalSince(now) / max(1, set.timeIntervalSince(noon))
        }
        let k = PlayMath.clamp01(u)
        return rest + (1 - rest) * (k * k * (3 - 2 * k))
    }
}
