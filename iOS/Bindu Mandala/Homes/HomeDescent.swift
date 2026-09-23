import Foundation

// MARK: - The descent: going deeper, as travel
//
// Build Brief v2 §3.9, handoff §4.6, and Design's `homes-descent.js`, whose own
// header is the specification: *"not a screen and not a sheet of facts, but the
// same inward movement continued. You do not leave her room — you keep going.
// Five stations, each ONE field of her card rendered as motion, drawn in her
// āvaraṇa's gem light. Self-paced: a touch carries you the next stretch."*
//
// This file is the descent as arithmetic — where the stations are, where the
// walker is between them, and which of her fields each one is. It draws nothing
// and it is the half a check can read without a renderer, exactly as
// ``RoomApproach`` is for the crossing in. ``DescentShaft`` is the only thing
// that draws it.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT GOES INTO HER MARK, AND THAT IS WHY IT BREAKS NO LAW
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's descent is five free-standing lit solids strung along a shaft: a
// torus knot for her tattva, thirteen boxes for her body, sprites for her
// roots, an icosahedron for her quality, three tori for her phrase. The binding
// condition this instrument is built on refuses every one of them — *an
// attribute is an action on the room's own material, never a free-standing lit
// solid* — and the refusal is not a stylistic preference: it is the sentence
// that keeps a hundred and two rooms from becoming a hundred and two objects on
// a plinth.
//
// So the descent is not built beside her mark. It is built **into** it. Her
// attribute has been pressing, furrowing, cracking or swelling the room's own
// material for the whole of the stay; going deeper is going into the one thing
// in the room that is hers. The shaft is that mark's own rim, repeating inward
// — which is Design's own sentence for it, *"her seat repeating inward, so the
// falling is legible"* — and every station is something that happens to those
// rims and to nothing else. There is not one solid in the whole descent, and
// `DescentShaftTests` asserts the count is zero.
//
// Design's motions are kept exactly where they can be: the roots orbit inward
// on Design's own radius and rate until they are one, the body's registers
// breathe on Design's own period, the shaft's opacity follows Design's own
// nearness band. What changed is **what** moves — a rim of the room's material
// rather than a sprite — and nothing about how.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE AXIS IS HER OWN ALTITUDE, AND THE EYE COMES TO IT
// ─────────────────────────────────────────────────────────────────────────────
//
// The shaft runs level, at the height her mark stands at, and the eye descends
// to that height over the first stretch. A Śakti felt at the soles is therefore
// gone *down* into, and one felt at the crown is gone *up* into, with no rule
// anywhere that says so — ``RoomUnits/height(forBodyAltitude:)`` is the only
// vertical conversion in the instrument and it is the one this reads. Going
// deeper is coming to her level, in the plainest sense the geometry has.
//
// ─────────────────────────────────────────────────────────────────────────────
// IT MEASURES NOTHING
// ─────────────────────────────────────────────────────────────────────────────
//
// There is no station counter, no depth gauge, no "3 of 5", and no progress
// rail. The walker knows how deep he is the way he knows how far down a
// staircase he is — by what is around him. The five stretches are not evenly
// long and the stations are not evenly spaced, for the same reason the rite's
// own stations are not (``RiteOfEntering/stations``): an approach does not feel
// evenly spaced, and a thing that did would be a progress bar with the numbers
// filed off.

/// One of the five stations of the descent, in Design's own order — the order
/// of increasing intimacy, as the rite's three beats are.
enum DescentStation: Int, CaseIterable, Equatable {
    /// What she is made of.
    case tattva = 0
    /// Where in the body she is felt.
    case location
    /// What her name is made of.
    case etymology
    /// What she does, as one word.
    case quality
    /// Her own sentence, and the floor of the descent.
    case phrase
}

/// The descent's geometry and travel, as pure numbers.
enum HomeDescent {

    // MARK: - Design's own depths

    /// `STATION_Z` in `homes-descent.js`, kept literally.
    ///
    /// They can be kept literally because Design's rooms and this one are the
    /// same size: Design's mount is `(0.5 - alt) * 6.4 - 0.4` and so is
    /// ``HomeAttribute/mount(bodyAltitude:chamberTime:)``, which makes
    /// ``RoomUnits/roomHeight`` exactly Design's `6.4`. The first station is
    /// therefore two and a half body-heights in, and the floor of the descent
    /// nearly fourteen.
    static let stationDepths: [Double] = [-16, -34, -52, -70, -88]

    /// How many rims the shaft is made of. Design's `46`.
    static let rungs = 46

    /// The first rim, and the space between them. Design's `-8 - i * 2.2`.
    static let firstRungDepth: Double = -8
    static let rungSpacing: Double = 2.2

    /// The widest rim, and how each one narrows. Design's `5.4 * 0.985^i`.
    static let rungRadius: Double = 5.4
    static let rungNarrowing: Double = 0.985

    /// How far a rim can be from the eye and still be lit at all. Design's `34`.
    static let rungBand: Double = 34

    /// A rim's own light, from dark to near. Design's `0.05 + near * 0.34`.
    static let rungFloor: Double = 0.05
    static let rungReach: Double = 0.34

    /// How near a station has to be before it acts. Design's `22`, and its
    /// `near > 0.02` cutoff.
    static let stationBand: Double = 22
    static let stationCutoff: Double = 0.02

    /// The depth of the rim at index `i`.
    static func rungDepth(_ i: Int) -> Double {
        firstRungDepth - Double(i) * rungSpacing
    }

    /// The radius of the rim at index `i`.
    static func rungRadius(_ i: Int) -> Double {
        rungRadius * pow(rungNarrowing, Double(i))
    }

    /// How lit a rim is when the eye stands at `depth`. Design's own band.
    static func rungLight(_ i: Int, eyeDepth depth: Double) -> Double {
        rungFloor + nearness(of: rungDepth(i), to: depth, band: rungBand) * rungReach
    }

    /// How present a station is when the eye stands at `depth`, `0`–`1`.
    /// Below ``stationCutoff`` it is not there at all — Design's `s.visible`.
    static func presence(of station: DescentStation, eyeDepth depth: Double) -> Double {
        let near = nearness(of: stationDepths[station.rawValue], to: depth, band: stationBand)
        return near > stationCutoff ? near : 0
    }

    /// `1` at the thing, falling to `0` a band away.
    static func nearness(of place: Double, to eye: Double, band: Double) -> Double {
        guard band > 0 else { return place == eye ? 1 : 0 }
        return 1 - clamp01(abs(place - eye) / band)
    }

    // MARK: - Where the walker is

    /// The six anchors of the travel: where he stands in her room, and then
    /// Design's five stations. Five stretches, and the first is the longest,
    /// because leaving the room he is standing in is the stretch that has to be
    /// felt as leaving.
    static func anchors(standingAt eyeDepth: Double = RoomUnits.eyeZ) -> [Double] {
        [eyeDepth] + stationDepths
    }

    /// The last station's index, as a travel co-ordinate.
    static var floor: Double { Double(stationDepths.count) }

    /// The eye's depth at travel `s`, where `0` is standing in her room and each
    /// whole number is a station. Linear within a stretch, so a stretch crossed
    /// at a steady rate is crossed at a steady rate.
    static func depth(atTravel s: Double, standingAt eyeDepth: Double = RoomUnits.eyeZ) -> Double {
        let places = anchors(standingAt: eyeDepth)
        let t = min(max(0, s), floor)
        let i = min(places.count - 2, Int(t))
        let within = t - Double(i)
        return places[i] + (places[i + 1] - places[i]) * within
    }

    /// The eye's height at travel `s`: it leaves the walker's own eye-height and
    /// arrives at hers over the first stretch, and holds there.
    ///
    /// **This is the whole of "going deeper" as a statement about the body.** It
    /// is not a rule about descending — a crown Śakti's shaft is *above* the
    /// walker's eye and he rises into it. Nothing here knows which.
    static func height(atTravel s: Double, bodyAltitude: Double) -> Double {
        let hers = RoomUnits.height(forBodyAltitude: bodyAltitude)
        let arrived = HomeGrammar.smooth(clamp01(s))
        return RoomUnits.eyeY + (hers - RoomUnits.eyeY) * arrived
    }

    /// Which station the walker is standing at, or standing between. The one he
    /// has reached — `0` until the first is arrived at.
    static func station(atTravel s: Double) -> DescentStation? {
        guard s >= 1 else { return nil }
        let i = min(stationDepths.count - 1, Int(s) - 1)
        return DescentStation(rawValue: i)
    }

    // MARK: - What each station does to the rims

    /// How far the rims at the tattva's station have turned, in radians.
    /// Design's `t * 0.13`, on the shaft instead of on a knot.
    static let turnRate: Double = 0.13

    /// The body's registers — Design's thirteen bars, their spacing and their
    /// breath. `4.4 - i * 0.74` and `sin(t * 0.22 + k * 0.4)` kept exactly.
    static let registers = 13
    static let registerTop: Double = 4.4
    static let registerStep: Double = 0.74
    static let registerBreathRate: Double = 0.22
    static let registerBreathPhase: Double = 0.4

    /// Where the register at index `k` stands, relative to the shaft's axis.
    static func registerOffset(_ k: Int) -> Double {
        registerTop - Double(k) * registerStep
    }

    /// **Her own register is the one the shaft is not thrown off at.**
    ///
    /// Design's station two lights one bar of thirteen and its own arithmetic
    /// for *which* is dead — `Math.round(6 + (0.5 - 0.5) * 6)` is `6` for every
    /// Śakti in the instrument, so in the shipped Axis her body is never
    /// actually found. Here the thirteen registers are read off her altitude,
    /// and what marks hers is that the shaft runs **true** through it while it
    /// is pushed off its axis everywhere else. The room's material saying where
    /// she lives by being undisturbed there is the same sentence every room
    /// already speaks, and it cannot be `6` for everybody.
    static func herRegister(bodyAltitude: Double) -> Int {
        let k = (Int)((clamp01(bodyAltitude) * Double(registers - 1)).rounded())
        return min(registers - 1, max(0, k))
    }

    /// How far the shaft is thrown off its axis at a rim near the body's
    /// station — zero at her own register, growing with distance from it.
    static func registerThrow(rungAt depth: Double, bodyAltitude: Double) -> Double {
        let station = stationDepths[DescentStation.location.rawValue]
        let k = Int(((station - depth) / rungSpacing).rounded())
        let here = ((k % registers) + registers) % registers
        let mine = herRegister(bodyAltitude: bodyAltitude)
        return registerOffset(here) - registerOffset(mine)
    }

    /// Her roots orbiting inward until they are one word. Design's own cycle,
    /// radius, and rate: `(t % 14) / 14`, `3.4 * (1 - draw)`, `a + t * 0.12`.
    static let rootCycle: Double = 14
    static let rootRadius: Double = 3.4
    static let rootRate: Double = 0.12

    /// Where the drawing-together stands at `t`, `0`–`1`.
    static func rootDraw(at t: TimeInterval) -> Double {
        clamp01(t.truncatingRemainder(dividingBy: rootCycle) / rootCycle)
    }

    /// Where the rim carrying root `k` of `n` stands, off the shaft's axis.
    static func rootOffset(_ k: Int, of n: Int, at t: TimeInterval) -> (x: Double, y: Double) {
        guard n > 0 else { return (0, 0) }
        let radius = rootRadius * (1 - rootDraw(at: t))
        let angle = (Double(k) / Double(n)) * .pi * 2 + t * rootRate
        return (cos(angle) * radius, sin(angle) * radius)
    }

    /// How many roots the descent can carry. Design's `max(2, min(4, …))`.
    static func rootCount(_ roots: Int) -> Int { max(2, min(4, roots)) }

    /// Her quality: one form, breathing, saying nothing else. The rim swells and
    /// compacts rather than turning, which is what tells it apart from the
    /// tattva's station without either of them being a different object.
    static let swellRate: Double = 0.19
    static let swellDepth: Double = 0.18

    /// How much the rim at the quality's station has swollen at `t`.
    static func swell(at t: TimeInterval) -> Double {
        sin(t * swellRate) * swellDepth
    }

    /// The floor of the descent: the shaft draws in toward its own centre, and
    /// **dims as it arrives**. `DissolveRoom`'s reading, which is the one reading
    /// the instrument already has for arriving at a source: a light you are
    /// inside is not a light you see.
    ///
    /// It draws in to ``floorRadius`` and **not to nothing**. A shaft that closed
    /// all the way would leave the last station of every descent a black screen
    /// with one line of her on it, which is a sheet of facts arrived at the long
    /// way round — the exact thing Design's §4.6 refuses. What is there instead is
    /// what Design puts there: rings, tight about the axis, with her sentence in
    /// them.
    static func floorClosing(eyeDepth depth: Double) -> Double {
        presence(of: .phrase, eyeDepth: depth)
    }

    /// How much of a rim's width survives the floor, and how much of its light.
    static let floorRadius: Double = 0.22
    static let floorDimming: Double = 0.35

    // MARK: - Small arithmetic

    static func clamp01(_ x: Double) -> Double { min(1, max(0, x)) }
}

// MARK: - Her five fields, as words

/// The five things the descent says, one per station — her card's own fields,
/// arriving one at a time rather than stacked into a sheet.
///
/// Composed the way ``RiteWords`` is: from plain values, so the whole corpus can
/// be driven without a row, a context or a store, and from her synced row for
/// the one real door. A field the base has not filled in is simply empty, and
/// the station then has its motion and no sentence — silence about what is not
/// known, which is the same rule the carrier follows about a missing bīja.
struct DescentWords: Equatable {

    /// In Design's own order: tattva, location, etymology, quality, phrase.
    let lines: [String]

    /// The roots her etymology station turns, never fewer than two.
    let roots: [String]

    subscript(station: DescentStation) -> String {
        lines.indices.contains(station.rawValue) ? lines[station.rawValue] : ""
    }

    /// Everything this can put in front of the walker, for the checks that read
    /// the whole corpus at once.
    var all: [String] { lines }

    static func compose(tattva: String?,
                        bodilyLocation: String?,
                        etymology: String?,
                        quality: String?,
                        appreciationPhrase: String?,
                        name: String) -> DescentWords {
        let roots = RiteWords.roots(inEtymology: etymology) ?? RiteWords.compoundParts(of: name)
        return DescentWords(
            lines: [RiteWords.trimmed(tattva) ?? "",
                    RiteWords.trimmed(bodilyLocation) ?? "",
                    roots.joined(separator: " + "),
                    RiteWords.trimmed(quality) ?? "",
                    RiteWords.trimmed(appreciationPhrase) ?? ""],
            roots: roots)
    }

    /// From her synced row.
    static func compose(shakti: Shakti) -> DescentWords {
        compose(tattva: shakti.tattva,
                bodilyLocation: shakti.bodilyLocation,
                etymology: shakti.etymology,
                quality: shakti.quality,
                appreciationPhrase: shakti.appreciationPhrase,
                name: shakti.name)
    }
}
