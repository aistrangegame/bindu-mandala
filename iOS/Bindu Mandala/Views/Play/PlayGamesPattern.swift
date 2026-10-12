import SwiftUI

// MARK: - Wave 6 · Slice E — the pattern games: Mandala Completion, the
// Twelve, Turn, Join, Leela on the Thirty-Three

// MARK: Mandala Completion — Integration (ring 7)
//
// "The complete form already exists before it is built." A mandala of petals
// with one waiting, drawn only as a dashed ghost; he draws it from its root
// to its tip. A stroke that strays fades; the mandala waits. Three mandalas,
// each fuller than the last, and the whole ring goes quiet.

final class MandalaCompletionModel: PlayModel {
    private var round = 0
    private var stroke: [CGPoint] = []
    private var fading: [(points: [CGPoint], born: Double)] = []
    private var size: CGSize = .zero
    private var closedAt: Double? = nil
    private var finishAt: Double? = nil

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.47) }
    private var inner: CGFloat { min(size.width, size.height) * 0.10 }
    private var outer: CGFloat { min(size.width, size.height) * 0.38 }

    private var petals: Int { MandalaPetals.rounds[min(round, MandalaPetals.rounds.count - 1)] }
    private var missing: Int { MandalaPetals.missing(round: round, of: petals) }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        self.size = size
        fading.removeAll { now - $0.born > 0.8 }
        if let c = closedAt, now - c > 2.2, finishAt == nil {
            closedAt = nil
            round += 1
            if round >= MandalaPetals.rounds.count {
                round = MandalaPetals.rounds.count - 1
                finishAt = now + 0.6
            }
        }
        if let f = finishAt, now >= f { session.complete(.stillness) }
    }

    private func petalPath(_ i: Int) -> Path {
        let e = MandalaPetals.petal(i, of: petals, center: centre, inner: inner, outer: outer)
        let mid = CGPoint(x: (e.base.x + e.tip.x) / 2, y: (e.base.y + e.tip.y) / 2)
        let dx = e.tip.x - e.base.x, dy = e.tip.y - e.base.y
        let len = max(1, hypot(dx, dy))
        let w = len * 0.26 * 8 / CGFloat(petals)
        let nx = -dy / len * w, ny = dx / len * w
        var p = Path()
        p.move(to: e.base)
        p.addQuadCurve(to: e.tip, control: CGPoint(x: mid.x + nx, y: mid.y + ny))
        p.addQuadCurve(to: e.base, control: CGPoint(x: mid.x - nx, y: mid.y - ny))
        return p
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let whole = closedAt != nil || finishAt != nil
        let bloom = closedAt.map { min(1, (now - $0) / 1.2) } ?? (finishAt != nil ? 1 : 0)
        for i in 0..<petals {
            let p = petalPath(i)
            if i == missing && !whole {
                add.stroke(p, with: .color(hue.opacity(0.32)), style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
            } else {
                add.fill(p, with: .color(hue.opacity(0.10 + 0.12 * bloom)))
                add.stroke(p, with: .color(hue.opacity(0.6 + 0.3 * bloom)), lineWidth: 1.2)
            }
        }
        add.stroke(Path(ellipseIn: CGRect(x: centre.x - inner, y: centre.y - inner, width: inner * 2, height: inner * 2)),
                   with: .color(hue.opacity(0.4)), lineWidth: 1)
        if !whole {
            let e = MandalaPetals.petal(missing, of: petals, center: centre, inner: inner, outer: outer)
            let b = still ? 0.5 : 0.5 + 0.5 * sin(breath * 2.4)
            add.glow(at: e.base, radius: 16 + 4 * CGFloat(b), color: hue, alpha: 0.6)
            add.core(at: e.base, radius: 3, color: Color.cream, alpha: 0.9)
        }
        if stroke.count > 1 {
            var p = Path()
            p.move(to: stroke[0])
            for q in stroke.dropFirst() { p.addLine(to: q) }
            add.stroke(p, with: .color(Color.cream.opacity(0.55)), lineWidth: 2)
        }
        for f in fading where f.points.count > 1 {
            var p = Path()
            p.move(to: f.points[0])
            for q in f.points.dropFirst() { p.addLine(to: q) }
            add.stroke(p, with: .color(Color.cream.opacity(0.4 * max(0, 1 - (now - f.born) / 0.8))), lineWidth: 1.6)
        }
        add.glow(at: centre, radius: 40 + 200 * CGFloat(bloom), color: hue, alpha: 0.1 + 0.3 * bloom)
        add.core(at: centre, radius: 3, color: Color.cream, alpha: 0.95)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard closedAt == nil, finishAt == nil else { return }
        session.acted()
        stroke = [s.location]
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard !stroke.isEmpty else { return }
        stroke.append(s.location)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        guard !stroke.isEmpty, closedAt == nil, finishAt == nil else { stroke = []; return }
        stroke.append(s.location)
        let e = MandalaPetals.petal(missing, of: petals, center: centre, inner: inner, outer: outer)
        let width = max(18, (outer - inner) * 0.26 * 8 / CGFloat(petals) * 0.9)
        if YantraTrace.traces(stroke, edge: (e.base, e.tip), tolerance: width) {
            closedAt = s.time
            PlaySound.shared.tone(PlayModels.pointHz * 2 * [1.0, 1.25, 1.5][min(round, 2)], gain: 0.13, duration: 2.4,
                                  partials: [(1, 1), (2, 0.25), (3, 0.08)])
            PlayHaptics.bloom()
        } else {
            fading.append((points: stroke, born: s.time))
            PlayHaptics.tap(0.15)
        }
        stroke = []
    }
}

// MARK: The Twelve — the Vāk ring (ring 7)
//
// Find the order by feeling. Twelve lights stand round a circle, each with
// its own tone. Touch one to hear it; drag one onto another and they change
// places. Two neighbours a fifth apart sing together, and a thread of light
// joins them. When every neighbour sings, all the way round, the circle
// closes and the ring goes quiet.

final class TwelveModel: PlayModel {
    private var circle = TwelveCircle(seed: UInt64(Date().timeIntervalSince1970) & 0xFFFF)
    private var size: CGSize = .zero
    private var dragging: (slot: Int, at: CGPoint)? = nil
    private var lastSound: [Int: Double] = [:]
    private var finishAt: Double? = nil

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.47) }
    private var radius: CGFloat { min(size.width, size.height) * 0.36 }

    private func point(_ slot: Int) -> CGPoint {
        let a = -Double.pi / 2 + 2 * Double.pi * Double(slot) / Double(TwelveCircle.size)
        return CGPoint(x: centre.x + radius * CGFloat(cos(a)), y: centre.y + radius * CGFloat(sin(a)))
    }

    private func slot(near p: CGPoint) -> Int? {
        var best: Int? = nil
        var bestD = CGFloat.greatestFiniteMagnitude
        for i in 0..<TwelveCircle.size {
            let d = hypot(point(i).x - p.x, point(i).y - p.y)
            if d < bestD { bestD = d; best = i }
        }
        return bestD < 40 ? best : nil
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        self.size = size
        if finishAt == nil, circle.isWhole {
            finishAt = now + 3.0
            for k in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 * Double(k)) {
                    PlaySound.shared.tone(TwelveCircle.frequency(tone: k * 4), gain: 0.1, duration: 2.6)
                }
            }
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let whole = circle.isWhole
        for i in 0..<TwelveCircle.size where circle.sings(after: i) {
            var p = Path()
            p.move(to: point(i))
            p.addLine(to: point((i + 1) % TwelveCircle.size))
            add.stroke(p, with: .color(hue.opacity(whole ? 0.9 : 0.6)), lineWidth: whole ? 2.2 : 1.4)
        }
        for i in 0..<TwelveCircle.size {
            let p = (dragging?.slot == i) ? (dragging?.at ?? point(i)) : point(i)
            let tone = circle.order[i]
            let heard = lastSound[i].map { exp(-(now - $0) * 2.5) } ?? 0
            let shade = Color(hue: 0.62 + Double(tone) / 12 * 0.3, saturation: 0.45, brightness: 0.95)
            add.glow(at: p, radius: 22 + 18 * CGFloat(heard), color: shade, alpha: 0.4 + 0.3 * heard)
            add.core(at: p, radius: 4, color: Color.cream, alpha: 0.9)
        }
        add.glow(at: centre, radius: whole ? radius * 1.3 : 30, color: hue, alpha: whole ? 0.35 : 0.12)
        add.core(at: centre, radius: 2.5, color: Color.cream, alpha: 0.9)
    }

    private func sound(_ slot: Int, now: Double) {
        lastSound[slot] = now
        PlaySound.shared.tone(TwelveCircle.frequency(tone: circle.order[slot]), gain: 0.1, duration: 1.4)
        PlayHaptics.tap(0.35)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil, let i = slot(near: s.location) else { return }
        session.acted()
        dragging = (slot: i, at: s.location)
        sound(i, now: s.time)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let d = dragging else { return }
        dragging = (slot: d.slot, at: s.location)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        guard let d = dragging else { return }
        dragging = nil
        if let j = slot(near: s.location), j != d.slot {
            circle.swap(d.slot, j)
            sound(j, now: s.time)
            if circle.sings(after: j) || circle.sings(after: (j + TwelveCircle.size - 1) % TwelveCircle.size) {
                PlaySound.shared.tone(TwelveCircle.frequency(tone: circle.order[j]) * 1.5, gain: 0.06, duration: 1.6)
            }
        }
    }
}

// MARK: Turn — the three made one (ring 8)
//
// After Monument Valley, and the sketchbook's verb he found alive. Three
// rings, each with one mark; turn them until the three marks meet at the
// top. A ring flung keeps turning and slows; turning a ring carries the one
// inside it a little — that is the skill. When the marks meet and the rings
// are at rest, the point appears, and the play goes still.

final class TurnModel: PlayModel {
    private var rings = TurningRings()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var holding: [ObjectIdentifier: (ring: Int, angle: Double, time: Double)] = [:]
    private var lastClick: [Double] = [0, 0, 0]
    private var finishAt: Double? = nil

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.47) }
    private func radius(_ r: Int) -> CGFloat { min(size.width, size.height) * (0.16 + 0.11 * CGFloat(r)) }

    private func ring(at p: CGPoint) -> Int? {
        let d = hypot(p.x - centre.x, p.y - centre.y)
        var best: Int? = nil
        var bestD = CGFloat.greatestFiniteMagnitude
        for r in 0..<3 {
            let off = abs(d - radius(r))
            if off < bestD { bestD = off; best = r }
        }
        return bestD < 40 ? best : nil
    }

    private func angle(of p: CGPoint) -> Double {
        atan2(Double(p.y - centre.y), Double(p.x - centre.x))
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        rings.step(dt: dt, holding: Set(holding.values.map { $0.ring }))
        for r in 0..<3 {
            let a = rings.angles[r]
            let notch = (a / (Double.pi / 6)).rounded()
            if abs(notch - lastClick[r]) >= 1 {
                lastClick[r] = notch
                PlayHaptics.tick()
            }
        }
        if finishAt == nil, holding.isEmpty, rings.aligned {
            finishAt = now + 2.2
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.14, duration: 3.0,
                                  partials: [(1, 1), (1.5, 0.5), (2, 0.3)])
            PlayHaptics.bloom()
        }
        if let f = finishAt, now >= f { session.complete(.stillness) }
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let near = rings.nearness
        for r in 0..<3 {
            let rad = radius(r)
            add.stroke(Path(ellipseIn: CGRect(x: centre.x - rad, y: centre.y - rad, width: rad * 2, height: rad * 2)),
                       with: .color(hue.opacity(0.22 + 0.2 * near)), lineWidth: 6)
            let a = rings.angles[r] - Double.pi / 2
            let mark = CGPoint(x: centre.x + rad * CGFloat(cos(a)), y: centre.y + rad * CGFloat(sin(a)))
            add.glow(at: mark, radius: 18, color: Color.cream, alpha: 0.6)
            add.core(at: mark, radius: 4, color: Color.cream, alpha: 0.95)
        }
        // Where the marks meet.
        let top = CGPoint(x: centre.x, y: centre.y - radius(2) - 26)
        add.core(at: top, radius: 2, color: hue, alpha: 0.6)
        let shown = finishAt != nil ? 1.0 : pow(near, 6)
        add.glow(at: centre, radius: 20 + 160 * CGFloat(shown), color: hue, alpha: 0.1 + 0.4 * shown)
        add.core(at: centre, radius: 1 + 3 * CGFloat(shown), color: Color.cream, alpha: 0.3 + 0.7 * shown)
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard finishAt == nil, let r = ring(at: s.location) else { return }
        session.acted()
        holding[s.id] = (ring: r, angle: angle(of: s.location), time: s.time)
        PlaySound.shared.tone(PlayModels.pointHz * [1.0, 1.5, 2.0][r], gain: 0.06, duration: 1.0)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard let h = holding[s.id] else { return }
        let a = angle(of: s.location)
        let d = PlayMath.wrap(a - h.angle)
        rings.drag(ring: h.ring, by: d, dt: s.time - h.time)
        holding[s.id] = (ring: h.ring, angle: a, time: s.time)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        holding[s.id] = nil
    }
}

// MARK: Join — Invention · Jayinī (kp 92)
//
// "The third thing that appears when two things that have never touched
// finally meet." Two lights from far ends of the road stand apart, each
// carrying its name. He brings them together, one finger each or one at a
// time. Met gently, they join and the third light is born between them;
// rushed, they bounce apart and wait. When the third is born, she is felt.

final class JoinModel: PlayModel {
    private var a = CGPoint.zero
    private var b = CGPoint.zero
    private var placed = false
    private var held: [ObjectIdentifier: (which: Int, at: CGPoint, time: Double, speed: CGFloat)] = [:]
    private var joinedAt: Double? = nil
    private var bounceAt: Double = -10
    private let pair: (String, String)

    init() {
        let road = ChakraConstellation.all
        if road.count >= 33 {
            let i = Int.random(in: 1...15)
            let j = min(32, i + 16)
            pair = (road[i].name, road[j].name)
        } else {
            pair = ("", "")
        }
    }

    private var third: String {
        ChakraConstellation.all.first { $0.kp == [92] }?.essence ?? ""
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        if !placed {
            placed = true
            a = CGPoint(x: size.width * 0.18, y: size.height * 0.30)
            b = CGPoint(x: size.width * 0.82, y: size.height * 0.66)
        }
        if joinedAt == nil {
            let d = hypot(a.x - b.x, a.y - b.y)
            let closing = held.values.map { $0.speed }.max() ?? 0
            switch JoinMeeting.meet(distance: d, closingSpeed: closing) {
            case .join:
                joinedAt = now
                held.removeAll()
                PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.12, duration: 2.6)
                PlaySound.shared.tone(PlayModels.pointHz * 3, gain: 0.10, duration: 2.6)
                PlayHaptics.bloom()
            case .bounce:
                if now - bounceAt > 0.4 {
                    bounceAt = now
                    let dx = (b.x - a.x) / max(1, d), dy = (b.y - a.y) / max(1, d)
                    a = Self.inside(CGPoint(x: a.x - dx * 70, y: a.y - dy * 70), size)
                    b = Self.inside(CGPoint(x: b.x + dx * 70, y: b.y + dy * 70), size)
                    held.removeAll()
                    PlaySound.shared.thump(depth: 0.3)
                    PlayHaptics.tap(0.4)
                }
            case .apart:
                break
            }
        }
        if let j = joinedAt, now - j > 3.2 { session.complete(.recognition) }
    }

    private static func inside(_ p: CGPoint, _ size: CGSize) -> CGPoint {
        CGPoint(x: min(max(p.x, 40), max(41, size.width - 40)),
                y: min(max(p.y, 90), max(91, size.height - 90)))
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        let b2 = still ? 0.5 : 0.5 + 0.5 * sin(breath * 1.6)
        if let j = joinedAt {
            let k = min(1, (now - j) / 1.4)
            let m = CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
            add.glow(at: m, radius: 40 + 160 * CGFloat(k), color: hue, alpha: 0.5)
            add.core(at: m, radius: 5, color: Color.cream, alpha: 1)
            var t = ctx
            t.opacity = k
            t.draw(PlayInk.text(third, size: 19, alpha: 0.85), in: CGRect(x: 36, y: m.y + 70, width: size.width - 72, height: 120))
            return
        }
        let bump = exp(-(now - bounceAt) * 4)
        for (p, name) in [(a, pair.0), (b, pair.1)] {
            add.glow(at: p, radius: 34 + 6 * CGFloat(b2) + 20 * CGFloat(bump), color: hue, alpha: 0.45)
            add.core(at: p, radius: 4.5, color: Color.cream, alpha: 0.95)
            var t = ctx
            t.opacity = 0.6
            t.draw(PlayInk.text(name, size: 16, alpha: 1), at: CGPoint(x: p.x, y: p.y + 42))
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard joinedAt == nil else { return }
        let da = hypot(s.location.x - a.x, s.location.y - a.y)
        let db = hypot(s.location.x - b.x, s.location.y - b.y)
        guard min(da, db) < 60 else { return }
        session.acted()
        held[s.id] = (which: da <= db ? 0 : 1, at: s.location, time: s.time, speed: 0)
        PlayHaptics.tap(0.3)
    }

    func moved(_ s: TouchSample, session: PlaySession) {
        guard joinedAt == nil, let h = held[s.id] else { return }
        let dx = s.location.x - h.at.x, dy = s.location.y - h.at.y
        let dt = max(1.0 / 120, s.time - h.time)
        let other = h.which == 0 ? b : a
        let mine = h.which == 0 ? a : b
        let before = hypot(other.x - mine.x, other.y - mine.y)
        let moved = CGPoint(x: mine.x + dx, y: mine.y + dy)
        let after = hypot(other.x - moved.x, other.y - moved.y)
        let closing = max(0, (before - after) / CGFloat(dt))
        if h.which == 0 { a = moved } else { b = moved }
        held[s.id] = (which: h.which, at: s.location, time: s.time, speed: closing * 0.5 + h.speed * 0.5)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        held[s.id] = nil
    }
}

// MARK: Leela on the Thirty-Three — Lalitā (kp 102)
//
// "In Leela you cannot lose — you can only not-yet-arrive." The 33 of The
// Map stand on the road: from the centre out to the rim and spiralling home.
// He begins unborn; a six brings him in. He holds the die and lets it go; it
// tumbles and rests. Arrows lift (an act of giving); a snake is a turn of
// the road, carrying him back to walk a square again. Square thirty-two is
// held — sealed, with nothing on it. Arriving exactly at Lalitā hands him to
// her. Each landing shows the square's own name and essence from The Map.

final class LeelaModel: PlayModel {
    private var walk = LeelaWalk()
    private var clock = FrameClock()
    private var size: CGSize = .zero
    private var shown: Double = 0               // the dot's place on the road, eased
    private var gliding: [Int] = []             // squares the dot will glide through
    private var holdingSince: Double? = nil
    private var tumbling: (until: Double, face: Int)? = nil
    private var face = 6
    private var landedAt: Double = -10
    private var arrivedAt: Double? = nil
    private let road: [Chakra33]

    init() {
        road = ChakraConstellation.all.sorted { $0.road < $1.road }
    }

    private var centre: CGPoint { CGPoint(x: size.width / 2, y: size.height * 0.44) }
    private var span: CGFloat { min(size.width, size.height) * 0.42 }

    private func point(_ i: Int) -> CGPoint {
        let s = LeelaWalk.spot(i)
        let r = span * CGFloat(0.06 + 0.94 * s.radius)
        return CGPoint(x: centre.x + r * CGFloat(cos(s.angle)), y: centre.y + r * CGFloat(sin(s.angle)))
    }

    private func chakra(_ i: Int) -> Chakra33? {
        road.first { $0.road == i }
    }

    func advance(now: Double, size: CGSize, session: PlaySession, motion: PlayMotion) {
        let dt = clock.tick(now)
        self.size = size
        if let t = tumbling {
            if now < t.until {
                if Int(now * 14) % 2 == 0 { face = Int.random(in: 1...6) }
            } else {
                tumbling = nil
                face = t.face
                land(t.face, now: now)
            }
        }
        // A shake of the phone is a throw too.
        if tumbling == nil, holdingSince == nil, arrivedAt == nil, motion.shake > 1.4 {
            session.acted()
            throwDie(now: now, strength: 1)
        }
        if let next = gliding.first {
            shown = PlayMath.carry(shown, toward: Double(next), rate: 3.5, dt: dt)
            if abs(shown - Double(next)) < 0.01 {
                gliding.removeFirst()
                PlayHaptics.tick()
                PlaySound.shared.tone(PlayModels.pointHz * 2 * (1 + Double(next) / 33), gain: 0.05, duration: 0.6)
            }
        }
        if let a = arrivedAt, gliding.isEmpty, now - a > 2.6 { session.complete(.recognition) }
    }

    private func land(_ n: Int, now: Double) {
        let from = walk.square
        let move = walk.throwDie(n)
        landedAt = now
        switch move {
        case .unbornRests, .rests:
            PlayHaptics.tap(0.2)
        case .born:
            shown = 1
            PlaySound.shared.tone(PlayModels.pointHz * 2, gain: 0.12, duration: 2.0)
            PlayHaptics.bloom()
        case .walked(let to):
            gliding = Array(((from ?? 1) + 1)...to)
        case .arrow(let mid, let to):
            gliding = Array(((from ?? 1) + 1)...mid) + [to]
            PlaySound.shared.tone(PlayModels.pointHz * 3, gain: 0.1, duration: 1.8)
        case .snake(let mid, let to):
            gliding = Array(((from ?? 1) + 1)...mid) + Array((to...(mid - 1)).reversed())
            PlaySound.shared.tone(PlayModels.pointHz, gain: 0.08, duration: 2.2, partials: [(1, 1), (0.5, 0.4)])
        case .arrived:
            gliding = Array(((from ?? 1) + 1)...LeelaBoard.squares)
            arrivedAt = now
            PlayHaptics.bloom()
        }
    }

    private func throwDie(now: Double, strength: Double) {
        tumbling = (until: now + 0.6 + 0.8 * PlayMath.clamp01(strength), face: Int.random(in: 1...6))
        PlaySound.shared.thump(depth: 0.4)
    }

    func draw(in ctx: GraphicsContext, size: CGSize, now: Double, breath: Double, hue: Color, still: Bool) {
        var add = ctx
        add.blendMode = .plusLighter
        // The road.
        var path = Path()
        for i in 1...LeelaBoard.squares {
            if i == 1 { path.move(to: point(i)) } else { path.addLine(to: point(i)) }
        }
        add.stroke(path, with: .color(hue.opacity(0.14)), lineWidth: 1)
        // Arrows (gold) and snakes (a soft violet turn).
        for (from, to) in LeelaBoard.arrows {
            var p = Path(); p.move(to: point(from)); p.addLine(to: point(to))
            add.stroke(p, with: .color(Color.gold.opacity(0.45)), lineWidth: 1.4)
        }
        for (from, to) in LeelaBoard.snakes {
            let f = point(from), t = point(to)
            var p = Path(); p.move(to: f)
            p.addQuadCurve(to: t, control: CGPoint(x: (f.x + t.x) / 2 + 30, y: (f.y + t.y) / 2 - 30))
            add.stroke(p, with: .color(Color(red: 0.66, green: 0.55, blue: 0.92).opacity(0.4)),
                       style: StrokeStyle(lineWidth: 1.2, dash: [2, 4]))
        }
        for i in 1...LeelaBoard.squares {
            let p = point(i)
            let colour = (chakra(i)?.colorHex).map { Color(hex: $0) } ?? hue
            if i == LeelaBoard.held {
                add.stroke(Path(ellipseIn: CGRect(x: p.x - 6, y: p.y - 6, width: 12, height: 12)),
                           with: .color(Color.cream.opacity(0.2)), lineWidth: 0.8)
            } else {
                add.glow(at: p, radius: 12, color: colour, alpha: 0.45)
                add.core(at: p, radius: 2.4, color: colour, alpha: 0.9)
            }
        }
        // The dot — peacock, as he first played it.
        if walk.square != nil || !gliding.isEmpty {
            let lo = max(1, min(LeelaBoard.squares, Int(shown.rounded(.down))))
            let hi = min(LeelaBoard.squares, lo + 1)
            let u = CGFloat(shown - Double(lo))
            let p = CGPoint(x: point(lo).x + (point(hi).x - point(lo).x) * u,
                            y: point(lo).y + (point(hi).y - point(lo).y) * u)
            let peacock = Color(red: 0.06, green: 0.62, blue: 0.60)
            add.glow(at: p, radius: 26, color: peacock, alpha: 0.7)
            add.core(at: p, radius: 5, color: Color.cream, alpha: 1)
        } else {
            let b = still ? 0.5 : 0.5 + 0.5 * sin(breath)
            add.glow(at: point(LeelaBoard.squares), radius: 30 + 10 * CGFloat(b), color: hue, alpha: 0.25)
        }
        // The die: pips of light, never a numeral.
        let die = CGPoint(x: size.width / 2, y: size.height * 0.86)
        let held = holdingSince.map { min(1, (now - $0) / 1.2) } ?? 0
        let r: CGFloat = 28 + 6 * CGFloat(held)
        add.stroke(Path(roundedRect: CGRect(x: die.x - r, y: die.y - r, width: r * 2, height: r * 2), cornerRadius: 9),
                   with: .color(hue.opacity(0.5 + 0.3 * held)), lineWidth: 1.2)
        for pip in Self.pips(face) {
            add.core(at: CGPoint(x: die.x + pip.x * r * 0.55, y: die.y + pip.y * r * 0.55), radius: 3.2,
                     color: Color.cream, alpha: 0.9)
        }
        // Where he stands: the square's own words.
        if let sq = walk.square, gliding.isEmpty, sq != LeelaBoard.held, let c = chakra(sq) {
            let k = min(1, (now - landedAt) / 1.2)
            var t = ctx
            t.opacity = k
            t.draw(PlayInk.text(c.name, size: 22, alpha: 0.9, sanskrit: true), at: CGPoint(x: size.width / 2, y: size.height * 0.08))
            if let e = c.essence {
                t.draw(PlayInk.text(e, size: 15, alpha: 0.6), in: CGRect(x: 30, y: size.height * 0.08 + 18, width: size.width - 60, height: 60))
            }
        }
    }

    static func pips(_ n: Int) -> [CGPoint] {
        let c = CGPoint.zero
        let tl = CGPoint(x: -1, y: -1), tr = CGPoint(x: 1, y: -1)
        let bl = CGPoint(x: -1, y: 1), br = CGPoint(x: 1, y: 1)
        let ml = CGPoint(x: -1, y: 0), mr = CGPoint(x: 1, y: 0)
        switch n {
        case 1: return [c]
        case 2: return [tl, br]
        case 3: return [tl, c, br]
        case 4: return [tl, tr, bl, br]
        case 5: return [tl, tr, c, bl, br]
        default: return [tl, tr, ml, mr, bl, br]
        }
    }

    func began(_ s: TouchSample, session: PlaySession) {
        guard tumbling == nil, gliding.isEmpty, arrivedAt == nil else { return }
        session.acted()
        holdingSince = s.time
        PlayHaptics.tap(0.3)
    }

    func ended(_ s: TouchSample, session: PlaySession) {
        guard let h = holdingSince else { return }
        holdingSince = nil
        throwDie(now: s.time, strength: min(1, (s.time - h) / 1.2))
    }
}
