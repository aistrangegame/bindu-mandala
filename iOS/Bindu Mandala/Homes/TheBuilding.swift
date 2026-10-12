import Foundation

// MARK: - Wave 2 · One building — the pure half
//
// Build Charter II, §3 law 6: *"Every place is reachable from every place that
// makes sense. You can fly into her light, open neighbour doors, or descend.
// Leaving is one gesture, never punished."*
//
// Everything in this file is numbers and words with no view, no SceneKit and no
// audio, so the whole building can be asserted without a renderer — the same
// discipline ``WorldClimb`` and ``RoomPose`` keep.
//
//   • ``Garland``       — the khaḍgamālā as a circle: her two neighbours.
//   • ``ClimbLights``   — the 102 as breathing points of light at their
//                          altitude on the climb (Design's Axis), with the
//                          four ring mechanisms reborn inside their worlds.
//   • ``ClimbRail``     — the rail of nine: place, never progress.
//   • ``TheGates``      — the Gates of Release: going in he sets down the
//                          ring's Mental State; coming out he receives its Siddhi.
//   • ``DescentReach``  — the way down is always offered; dwelling deepens it.
//   • ``Glissando``     — the descent's sound, a glide between stations.
//   • ``Mauna``         — the silence at the point, and its authored captions.
//   • ``CentreBloom``   — G17, the yantra drawn outward from the point while held.
//   • ``Pravesha``      — Ring 9's endless fall.

// MARK: - The garland is a circle

/// The khaḍgamālā as one circle of 102 seats. Design's Axis: *"the khaḍgamālā
/// is a circle: every home connects to her two neighbours, so the homes are one
/// building — walkable from inside, without returning to the axis."*
///
/// Position is identity (§4.2): a neighbour is found by position and by
/// nothing else, and the circle closes — the Bindu's neighbour onward is the
/// first seat of the Bhūpura, because the garland is recited round and round.
enum Garland {

    /// The seat `step` places along the garland from `kp`, wrapping 1…102.
    /// `nil` for a position that is not a seat.
    static func neighbour(of kp: Int, _ step: Int) -> Int? {
        let n = KhadgamalaMap.total
        guard (1...n).contains(kp) else { return nil }
        let zeroBased = ((kp - 1 + step) % n + n) % n
        return zeroBased + 1
    }

    /// The seat before and the seat after — the two doors in her corridor.
    static func neighbours(of kp: Int) -> (before: Int, after: Int)? {
        guard let before = neighbour(of: kp, -1), let after = neighbour(of: kp, 1) else { return nil }
        return (before, after)
    }
}

// MARK: - The 102 on the climb

/// The 102 Śaktis as breathing points of light at their own altitude on the
/// climb — Design's Axis, `presences`, ported as pure numbers.
///
/// Design's units are its own `WORLD_SPACING = 30`; every length here is that
/// number divided by thirty and multiplied by ``WorldClimb/spacing``, the same
/// port every other climb constant takes.
enum ClimbLights {

    /// What a light is, beyond where it stands.
    struct Seat: Equatable, Identifiable {
        /// Her khaḍgamālā position — the only key.
        let kp: Int
        /// Her name, as the base carries it ("" before the base has answered:
        /// the light still stands, and still opens her room).
        var name: String = ""
        /// Her quality, for the line beneath the weather.
        var quality: String = ""
        var id: Int { kp }
        var ring: Int { KhadgamalaMap.ringNumber(forKhadgamala: kp) }
        /// Design's `isBuilt` — an authored room carries a larger, quicker halo.
        var isAuthored: Bool { HomeRooms.authoredMechanism(atPosition: kp) != nil }
    }

    /// The whole garland with no names — the climb before the base answers.
    static var bareGarland: [Seat] { (1...KhadgamalaMap.total).map { Seat(kp: $0) } }

    /// Design's port factor: one of its units, in ours.
    static var unit: Double { WorldClimb.spacing / 30 }

    /// How many seats stand in her ring. Structure, never practice.
    static func seatsInRing(_ ring: Int) -> Int {
        let starts = (1...9).map { KhadgamalaMap.ringStartOffset($0) } + [KhadgamalaMap.total]
        guard (1...9).contains(ring) else { return 0 }
        return starts[ring] - starts[ring - 1]
    }

    /// Design's `R = 5.6 + min(list.length, 28) * 0.1`.
    static func ringRadius(_ ring: Int) -> Double {
        (5.6 + Double(min(seatsInRing(ring), 28)) * 0.1) * unit
    }

    /// Where her ring is centred, in the climb's own frame: Design's
    /// `z = sin(a) * R - 1.4` with its camera at `z = 9` — kept as the same
    /// relation to the walker's eye, so the circle stands in front of him
    /// exactly as far as it stood in front of Design's.
    static var ringCentreZ: Double { RoomUnits.eyeZ - (9 + 1.4) * unit }

    /// Her angle round her ring. Design's `(k / n) · 2π − π/2`.
    static func angle(kp: Int) -> Double {
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
        let n = max(1, seatsInRing(ring))
        let k = KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1
        return Double(k) / Double(n) * 2 * .pi - .pi / 2
    }

    /// Where her light stands on the climb, in scene units. Design's
    /// `(cos a · R, y + 0.6 + sin(k · 1.7) · 0.5, sin a · R − 1.4)`, its
    /// `y + 0.6` read against its eye at `climb + 1.2`, so she stands just
    /// below the walker's eye-line in her own world exactly as Design drew.
    static func position(kp: Int) -> SIMD3<Double> {
        let ring = KhadgamalaMap.ringNumber(forKhadgamala: kp)
        let k = Double(KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1)
        let a = angle(kp: kp)
        let r = ringRadius(ring)
        let eye = WorldClimb.station(ring: ring) + WorldClimbScene.eyeRise
        let y = eye + (-0.6 + sin(k * 1.7) * 0.5) * unit
        return SIMD3(cos(a) * r, y, ringCentreZ + sin(a) * r)
    }

    /// Her place on the climb in bands — her world's station.
    static func fraction(kp: Int) -> Double {
        Double(max(1, KhadgamalaMap.ringNumber(forKhadgamala: kp)) - 1)
    }

    /// Design's `near`: a light is in the world when it is within 1.2
    /// spacings of where the walker stands.
    static func isNear(kp: Int, atFraction f: Double) -> Bool {
        abs(fraction(kp: kp) - f) < 1.2
    }

    // MARK: How each light breathes

    /// The light's own kind of breath.
    struct Breath: Equatable {
        /// Design's halo size, in its units: `authored ? 1.5 : 0.95`, and a
        /// Śakti he has stood with carries hers a quarter larger.
        let size: Double
        /// Design's halo opacity: `met 0.95 · authored 0.9 · 0.5`.
        let opacity: Double
        /// Design's breath rate: `met 0.22 · authored 0.9 · 0.4`. A light he
        /// knows is calmer — she was expecting you.
        let rate: Double
        /// Design's breath depth: `met 0.09 · 0.2`.
        let depth: Double
    }

    static func breath(isAuthored: Bool, met: Bool) -> Breath {
        let base = isAuthored ? 1.5 : 0.95
        return Breath(size: base * (met ? 1.25 : 1),
                      opacity: met ? 0.95 : (isAuthored ? 0.9 : 0.5),
                      rate: met ? 0.22 : (isAuthored ? 0.9 : 0.4),
                      depth: met ? 0.09 : 0.2)
    }

    /// Design's `pulse = (1 - depth) + depth · sin(t · rate + pos)` — always
    /// within `[1 − 2·depth, 1]`, never dark.
    static func pulse(_ b: Breath, kp: Int, at t: TimeInterval) -> Double {
        (1 - b.depth) + b.depth * sin(t * b.rate + Double(kp))
    }

    /// Design's core: *"she was expecting you"* — a Śakti already met carries
    /// her own core light, `0.5` across at `0.9`.
    static let coreSize: Double = 0.5
    static let coreOpacity: Double = 0.9

    /// Design's crown: *"she who presides carries her own standing light — you
    /// did not choose her"* — `3.4` across, breathing `0.86 + 0.14 · sin(0.3t)`.
    static let crownSize: Double = 3.4
    static func crownBreath(at t: TimeInterval) -> Double { 0.86 + 0.14 * sin(t * 0.3) }

    /// How the lights fade as the walker is swallowed into her light: Design's
    /// presences are gone by `swallow 0.7`, and fade as `(1 − swallow)`.
    static func visibility(swallow: Double) -> Double {
        swallow >= 0.7 ? 0 : max(0, 1 - swallow)
    }

    // MARK: The four mechanisms, reborn inside their worlds
    //
    // The Ring Worlds were nine screens; Ruling 1 made them one space, and what
    // that cost is restored here, in the rings' own lights on the climb.

    /// **Ring 3 — the bodiless longing scatters at touch and gathers in
    /// stillness.** `agitation` 0…1: her eight lights flee outward as smoke
    /// does when chased (Design's `drift 24` against a radius of ~96, a
    /// quarter of the ring), and come back when he is still.
    static func scatter(kp: Int, agitation: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 3 else { return .zero }
        let a = clamp01(agitation)
        let angle = self.angle(kp: kp)
        let outward = ringRadius(3) * 0.5 * a
        let lift = sin(Double(kp) * 2.3) * 0.8 * unit * a
        return SIMD3(cos(angle) * outward, lift, sin(angle) * outward)
    }

    /// **Ring 8 — three tones gliding into one.** While he holds, the three
    /// lights of the mūla trikoṇa draw together toward its centre; released,
    /// they open to the triangle again.
    static func gather(kp: Int, union: Double) -> SIMD3<Double> {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 8 else { return .zero }
        let p = position(kp: kp)
        let centre = SIMD3(0, p.y, ringCentreZ)
        return (centre - p) * (0.92 * clamp01(union))
    }

    /// How a mechanism's state follows the hand: toward `target` with the time
    /// constant `tau`, as a closed form so a dropped frame changes nothing.
    static func follow(_ value: Double, toward target: Double, dt: Double, tau: Double) -> Double {
        guard tau > 0 else { return target }
        let k = 1 - exp(-max(0, dt) / tau)
        return value + (target - value) * k
    }

    /// Ring 3's scatter rises fast under the hand and settles slowly in
    /// stillness — Design's smoke.
    static let scatterRise: Double = 0.35
    static let scatterSettle: Double = 2.4
    /// Ring 8's three glide into one at the triad's own pace (`setTargetAtTime
    /// … 3.4`), and open again a little quicker.
    static let unionRise: Double = 1.4
    static let unionSettle: Double = 0.9

    /// **Ring 6 — the light follows the finger, and names whisper.** Of the
    /// sisters whose screen points are given, the one nearest the moving light,
    /// if it has reached her (Design's `REVEAL = 92` on a 390-wide glass).
    static func whispered(from points: [(kp: Int, x: Double, y: Double)],
                          lightX: Double, lightY: Double,
                          reach: Double = 92) -> Int? {
        var best: Int?
        var bestD = Double.greatestFiniteMagnitude
        for p in points where KhadgamalaMap.ringNumber(forKhadgamala: p.kp) == 6 {
            let d = hypot(p.x - lightX, p.y - lightY)
            if d < bestD { bestD = d; best = p.kp }
        }
        return bestD <= reach ? best : nil
    }

    /// Design's Ring 6 glosses — *"too interior to be spoken — it fades"*.
    /// Read in her order round the ring; the whisper is her name and this.
    static let ringSixGloss = ["made of knowing", "made of power", "sovereign splendour",
                               "giver of knowledge", "remover of disease", "the support of all",
                               "remover of sorrow", "made of bliss", "the protectress",
                               "giver of the fruit"]

    static func whisperGloss(kp: Int) -> String? {
        guard KhadgamalaMap.ringNumber(forKhadgamala: kp) == 6 else { return nil }
        let i = KhadgamalaMap.perRingIndex(forKhadgamala: kp) - 1
        return ringSixGloss.indices.contains(i) ? ringSixGloss[i] : nil
    }

    /// How long a whisper stays. Design's `3200` ms.
    static let whisperSeconds: TimeInterval = 3.2

    /// Which light a touch at a screen point chose: the nearest whose
    /// projection is in front of the eye, within a finger's reach.
    static func picked(from points: [(kp: Int, x: Double, y: Double, depth: Double)],
                       atX x: Double, y: Double, reach: Double = 48) -> Int? {
        var best: Int?
        var bestD = Double.greatestFiniteMagnitude
        for p in points where p.depth > 0 && p.depth < 1 {
            let d = hypot(p.x - x, p.y - y)
            if d < bestD { bestD = d; best = p.kp }
        }
        return bestD <= reach ? best : nil
    }

    static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }
}

// MARK: - Flying into her light

/// The flight from the axis into her light — Design's `beginEnter` travel:
/// the eye leaves the axis and flies into her point and past it, the air
/// thickening until only she is left. The rite then begins inside it.
enum ClimbFlight {

    /// How long the flight takes. Design's own `entering` crossing, 2.2 s,
    /// halved: the rite's three beats carry the rest of the distance, and the
    /// flight is only the first surge of it.
    static let seconds: TimeInterval = 1.1

    /// How far along the flight is at an instant, smoothed (Design's `smooth`).
    static func progress(since start: TimeInterval, now: TimeInterval) -> Double {
        guard seconds > 0 else { return 1 }
        let p = ClimbLights.clamp01((now - start) / seconds)
        return p * p * (3 - 2 * p)
    }

    /// Where the eye is, `p` of the way from the axis to her light. Design:
    /// `HOLD = dest + (0, 0, 7.4 − swallow·7.4)` and `lerp(axisEye, HOLD, p)`.
    static func eye(from axis: SIMD3<Double>, to light: SIMD3<Double>, progress p: Double) -> SIMD3<Double> {
        let hold = light + SIMD3(0, 0, 7.4 * ClimbLights.unit * (1 - p))
        return axis + (hold - axis) * p
    }
}

// MARK: - The rail of nine

/// The rail down the right edge of the climb — nine region words, the one he
/// stands in lit. Place, never progress (§4.6): it says *where*, and the gold
/// tick on a world he has stood in says *you have stood here before*. It never
/// counts, never ranks, never fills.
enum ClimbRail {

    struct Entry: Equatable, Identifiable {
        let ring: Int
        let region: String
        let isHere: Bool
        /// He has stood in one of this world's rooms.
        let isMet: Bool
        var id: Int { ring }
    }

    /// Ninth at the top, first at the foot — the body, standing.
    static func entries(here: Int, metRings: Set<Int>,
                        live: [Int: HomeWorlds.LiveFacts] = [:]) -> [Entry] {
        HomeWorlds.rings.reversed().map { ring in
            Entry(ring: ring,
                  region: HomeWorlds.world(ring: ring, live: live[ring])?.region ?? "",
                  isHere: ring == here,
                  isMet: metRings.contains(ring))
        }
    }

    /// Which worlds he has stood in, from the seats he has met.
    static func metRings(_ met: Set<Int>) -> Set<Int> {
        Set(met.map { KhadgamalaMap.ringNumber(forKhadgamala: $0) }.filter { $0 > 0 })
    }
}

// MARK: - What the climb says at a height

/// The words of the climb, Design's `writeWorld`: the form, the ordinal and
/// the region above the name; the gem on the dhātu and the clock beneath it;
/// the weather sentence low in the frame; and *"she presides today"* where
/// today's Śakti stands.
enum ClimbWords {

    static let ordinals = ["first", "second", "third", "fourth", "fifth",
                           "sixth", "seventh", "eighth", "ninth"]

    static func ordinal(_ ring: Int) -> String {
        (1...9).contains(ring) ? ordinals[ring - 1] : ""
    }

    /// Design: `${form} · the ${ordinal} āvaraṇa · ${region}`.
    static func kicker(_ w: HomeWorld) -> String {
        "\(w.character.form) · the \(ordinal(w.ring)) āvaraṇa · \(w.region)"
    }

    /// Design: `${gem} on ${dhatu} · ${clock}`.
    static func material(_ w: HomeWorld) -> String {
        "\(w.gem) on \(w.dhatu) · \(w.clock)"
    }

    /// Design's `presides` line, where the world holds today's Śakti.
    static let presides = "she presides today"

    /// Design's `low` line for the light nearest the eye.
    static func near(_ seat: ClimbLights.Seat, isToday: Bool) -> String {
        let name = seat.name.isEmpty ? "her seat" : seat.name
        if isToday { return "\(name) — hers is the day" }
        let q = seat.quality.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? name : "\(name) — \(q)"
    }

    /// Design's hint, in the climb's own two gestures and the third this wave
    /// adds: *"scroll to climb · drag to turn · tap a light to enter her"*.
    static let hint = "drag to rise · across to turn · touch a light to enter her"
}

// MARK: - The Gates of Release

/// The Seven Gates (Claude Design, the chakra set) reborn over the nine
/// āvaraṇas. Going inward through an enclosure he **sets down** its Mental
/// State; coming out he **receives** its Siddhi. The gesture is the Gates'
/// own: hold, and the words are put down — they fall and fade from the view,
/// and the act stays in the record.
///
/// The words are the ring's own rows (`Mental State`, `Siddhi`), read live,
/// with the base's own strings standing as the offline fallback. No
/// gatekeeper speaks: the Seven Gates' generated voice is refused by law 8.
enum TheGates {

    enum Way: Equatable { case inward, outward }

    struct Gate: Equatable {
        let ring: Int
        let way: Way
        /// What the gate holds out: the Mental State going in, the Siddhi
        /// coming out.
        let words: String
        /// The gesture's own line — Design's *"hold to lay it down"*.
        var instruction: String { way == .inward ? TheGates.setDownWords : TheGates.receiveWords }
    }

    static let setDownWords = "hold to set it down"
    static let receiveWords = "hold to receive it"

    /// The Gates' own hold, `2600` ms.
    static let holdSeconds: TimeInterval = 2.6
    /// How long a gate stands open, unanswered, before it lets him pass by.
    /// Nothing is lost by passing: a gate is an offer, never a toll.
    static let offeredSeconds: TimeInterval = 9
    /// How long the words take to be put down — Design's `put-down 1.7s`.
    static let putDownSeconds: TimeInterval = 1.7

    /// The base's own Siddhi strings (`fldx9jXyTVWxp19o1`, read 12 Oct 2026),
    /// standing only where the live row has not been reached.
    static let authoredSiddhi: [Int: String] = [
        1: "Anima (atomic smallness)",
        2: "Mahima (greatness / vastness)",
        3: "Laghima (lightness)",
        4: "Garima (heaviness / gravitas)",
        5: "Ishitva (lordship / sovereignty)",
        6: "Vashitva (control / mastery)",
        7: "Prakamya (irresistible will / unimpeded movement)",
        8: "Bhukti (complete enjoyment including liberation)",
        9: "Iccha-Prapti-Mukti (Will, Attainment, Liberation as one)",
    ]

    /// Which way a crossing went, or `nil` for none.
    static func way(from old: Int, to new: Int) -> Way? {
        if new > old { return .inward }
        if new < old { return .outward }
        return nil
    }

    /// The gate a crossing meets. Going in from `old` to `new`, the gate is the
    /// enclosure he has just entered; coming out, it is the one he has just
    /// left. `mentalState` and `siddhi` are the live rows' words for that ring.
    static func gate(from old: Int, to new: Int,
                     mentalState: (Int) -> String?,
                     siddhi: (Int) -> String?) -> Gate? {
        guard let way = way(from: old, to: new) else { return nil }
        let ring = way == .inward ? new : old
        guard (1...9).contains(ring) else { return nil }
        let words: String
        switch way {
        case .inward:
            words = preferring(mentalState(ring),
                               over: HomeWorlds.character(ring: ring)?.state ?? "")
        case .outward:
            words = preferring(siddhi(ring), over: authoredSiddhi[ring] ?? "")
        }
        guard !words.isEmpty else { return nil }
        return Gate(ring: ring, way: way, words: words)
    }

    private static func preferring(_ live: String?, over authored: String) -> String {
        let t = (live ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? authored : t
    }

    /// The put-down: Design's `translateY(0 → 34) scale(1 → 0.9) opacity(1 → 0)`.
    static func putDown(_ p: Double) -> (dy: Double, scale: Double, opacity: Double) {
        let k = ClimbLights.clamp01(p)
        return (34 * k, 1 - 0.1 * k, 1 - k)
    }

    /// The receiving: the Siddhi rises toward him and brightens as it is held.
    static func receive(_ p: Double) -> (dy: Double, scale: Double, opacity: Double) {
        let k = ClimbLights.clamp01(p)
        return (-18 * k, 1 + 0.06 * k, 0.72 + 0.28 * k)
    }
}

// MARK: - The way down, always offered

/// Charter §3 and the Reading's §3 row *"Descent gated until 62 s of dwell"*,
/// reshaped by padakarshini law 5: *staying opens things; nothing new is
/// locked.* The way down is offered the moment he is in her room. What
/// dwelling does is make it **deeper**: before her room has adapted, the shaft
/// reaches the first three of her five stations — what she is made of, where
/// she is felt, what her name is made of — and its floor is the third; once the
/// room has adapted (or his accumulated dwell opened it there on arrival), it
/// reaches all five, to her quality and her own sentence.
enum DescentReach {

    /// How many stations the shaft reaches before her room has adapted.
    static let shallow = 3

    /// How many stations the shaft reaches at this moment of the stay.
    static func stations(atChamberTime t: TimeInterval) -> Int {
        HomeMemory.adaptation(atChamberTime: t) >= 1 ? TheDescent.stations : shallow
    }
}

// MARK: - The descent's sound

/// *"Sound the descent (a glissando)"* — Build Brief v2 named it and nothing in
/// Design built it. Each station is a glide downward from her carrier by a
/// minor third per station, so the floor of the descent sounds a little over
/// an octave beneath her: falling into her mark is heard as falling. Coming
/// back up glides up the same path. Her carrier keeps its pitch (rupakarshini
/// law 10); the glide only travels from it.
enum Glissando {

    /// A just minor third down, per station.
    static let stepRatio: Double = 5.0 / 6.0

    /// The pitch at a station of the descent, from her carrier.
    static func pitch(carrier: Double, station: Int) -> Double {
        carrier * pow(stepRatio, Double(max(0, station)))
    }

    /// The glide for a move between two stations.
    static func glide(carrier: Double, from: Int, to: Int) -> (from: Double, to: Double) {
        (pitch(carrier: carrier, station: from), pitch(carrier: carrier, station: to))
    }

    /// How long a glide sounds — the station rate, near enough: long enough
    /// to be heard as travel, short enough to finish before the next touch.
    static let seconds: TimeInterval = 2.4
}

// MARK: - Mauna, the silence at the point

/// The Eight Modes' fifth: tap the centre for silence. Design's captions
/// arrive at 7, 14 and 21 seconds, successively deeper, and at 28 there is
/// only silence. They are Design's authored words, never generated.
///
/// Design's depth line ("7 seconds in") is **not** drawn: a count of how long
/// he has been silent is a measure of him (§4.6). The ledger keeps the
/// duration; the glass never says it.
enum Mauna {

    static let captions: [(at: TimeInterval, words: String)] = [
        (7, "All of her. Here. Always."),
        (14, "She has not gone anywhere."),
        (21, "You have not gone anywhere."),
        (28, ""),
    ]

    /// The caption showing at `t` seconds into the silence, or `nil` before
    /// the first and `""` once only silence is left.
    static func caption(at t: TimeInterval) -> String? {
        var current: String?
        for c in captions where t >= c.at { current = c.words }
        return current
    }

    /// A silence is recorded once it has been held at least this long — the
    /// same seven seconds Design waits before its first word. A tap in and out
    /// is not a silence held, and writes nothing.
    static let recordedAfter: TimeInterval = 7

    /// Design's `maunaBinduBreath`: ×1.10 on a 6 s breath.
    static func binduBreath(at t: TimeInterval) -> Double {
        1 + 0.10 * (0.5 - 0.5 * cos(t * 2 * .pi / 6))
    }
}

// MARK: - G17 · the centre bloom

/// Ring 9's Spanda — *"Hold, and the whole Śrī Yantra blooms outward from the
/// single point; release, and the cosmos dissolves back into it."* Design's
/// layers arrive in order as the bloom `p` rises: the mūla trikoṇa, the
/// triangles, the eight petals, the sixteen, the Bhūpura, the names.
enum CentreBloom {

    enum Layer: Int, CaseIterable { case trikona, triangles, lotus8, lotus16, bhupura, names }

    /// Design's `set(ref, lo, max)` table.
    static func opacity(_ layer: Layer, bloom p: Double) -> Double {
        switch layer {
        case .trikona:   return band(p, 0.06) * 0.95
        case .triangles: return band(p, 0.24) * 0.82
        case .lotus8:    return band(p, 0.42) * 0.62
        case .lotus16:   return band(p, 0.54) * 0.85
        case .bhupura:   return band(p, 0.66) * 0.52
        case .names:     return band(p, 0.80) * 1.0
        }
    }

    /// Design's `0.05 + 0.95 · ease(p)`.
    static func scale(bloom p: Double) -> Double { 0.05 + 0.95 * ease(p) }

    /// Design's per-frame `p += (target − p) · 0.06`, as the exponential it is.
    static func approach(_ p: Double, holding: Bool, idle: Double, dt: Double) -> Double {
        let target = holding ? 1 : idle * 0.62
        let tau = -1 / (60 * log(1 - 0.06))
        return ClimbLights.follow(p, toward: target, dt: dt, tau: tau)
    }

    /// Design's idle breath, a 12 s period, gentle.
    static func idle(at t: TimeInterval) -> Double { 0.5 - 0.5 * cos(t * 2 * .pi / 12) }

    static func ease(_ p: Double) -> Double { let k = ClimbLights.clamp01(p); return k * k * (3 - 2 * k) }
    static func band(_ p: Double, _ lo: Double, _ w: Double = 0.18) -> Double {
        ClimbLights.clamp01((p - lo) / w)
    }
}

// MARK: - Ring 9 · Praveśa, the endless fall

/// *"You fall into the point and never reach a bottom: self-similar yantras
/// emerge from the center forever, each carrying its own bindu. Hold to
/// descend faster."* Design's `RingNineDescent`, as pure numbers.
enum Pravesha {

    /// How many nested yantras are in the fall at once. Design's `N = 7`.
    static let layers = 7

    /// Design's recognition threshold — held past this, the frantic fall
    /// settles into a drift and the recognition arrives.
    static let recognitionAfter: TimeInterval = 6.5

    /// The depth of one layer, 0…1, at the fall's clock.
    static func depth(layer i: Int, clock: Double) -> Double {
        let d = (clock + Double(i) / Double(layers)).truncatingRemainder(dividingBy: 1)
        return d < 0 ? d + 1 : d
    }

    /// Design's `0.03 · 2^(d · 6.4)` — seed to engulfing.
    static func scale(depth d: Double) -> Double { 0.03 * pow(2, d * 6.4) }

    /// Design's fade in over the first tenth and out over the last 28%.
    static func opacity(depth d: Double) -> Double {
        if d < 0.1 { return d / 0.1 * 0.72 }
        if d > 0.72 { return max(0, (1 - d) / 0.28) * 0.72 }
        return 0.72
    }

    /// How far the recognition has arrived, 0…1, after `held` seconds.
    static func recognition(held: TimeInterval) -> Double {
        ClimbLights.clamp01((held - recognitionAfter) / 2.2)
    }

    /// The fall's speed: Design's `isHold ? 3.0 − 2.2·recog : 0.85`.
    static func speed(holding: Bool, recognition: Double) -> Double {
        holding ? 3.0 - 2.2 * recognition : 0.85
    }

    /// The Shepard tone's intensity from the fall's speed — Design's
    /// `0.25 + 0.75 · clamp((speed − 0.6) / 2.4)`.
    static func shepard(speed: Double) -> Double {
        0.25 + 0.75 * ClimbLights.clamp01((speed - 0.6) / 2.4)
    }

    /// Design's authored words for the fall, never generated.
    static let rest = "Press and hold — fall inward."
    static let falling = "There is no bottom."
    static let fallingBeneath = "only further in"
    static let recognised = "You did not arrive. You were the arriving."
}
