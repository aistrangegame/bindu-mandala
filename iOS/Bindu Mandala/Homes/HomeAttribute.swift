//  HomeAttribute.swift
//  Bindu Mandala
//
//  HER ATTRIBUTE — the one thing the room actually does.
//
//  Ported from `Claude Design Round 2/homes/homes-attribute.js`, with the
//  assignment and tint tables from `homes-cards.js`. Design's note holds:
//  "every colour word, every held object, every posture is a design
//  instruction." So what she holds is never *shown* to the walker — it
//  PERFORMS. A noose draws the vast into the tiny. A cup fills and is emptied.
//  Five rods strike the five gates in turn. A sceptre barely moves.
//
//  WHAT THIS FILE IS, AND IS NOT
//  -----------------------------
//  Pure logic only: types, tables and parameter curves. No SceneKit, no
//  SwiftUI, no geometry, no shaders. The renderer ruling (charter §4) decides
//  how a room is DRAWN; it does not decide what a room IS. Everything here is
//  the numbers geometry will follow, so either renderer can follow them.
//
//  THE LAWS THIS FILE STANDS UNDER
//  ------------------------------
//  · Position is identity. Every table is keyed by `khadgamalaPosition` 1–102
//    and by nothing else. Design keys its cards by position too; names are
//    never consulted here, in either direction.
//  · No bundled roster. Nothing in this file carries a Śakti's name, quality or
//    content. The only per-position data is which SHAPE acts in her room, and
//    what tints it. Everything else the actor needs — her altitude — is read
//    from the synced `Shakti` row.
//  · Aniconic. Every form is a shape performing an action, never a figure.
//    See `HomeAttributeForm` for the three renamings this cost, and
//    `HomeAttributeTests.testNoFormCarriesFiguralVocabulary` for the assertion.
//  · Never measure. Nothing here counts anything, and no string in this file is
//    walker-facing: `shape`, `action` and `movingParts` are how the renderer and
//    the next reader are told what to draw.

import Foundation

// MARK: - Private arithmetic
//
// Deliberately file-private and un-shared. Two other Homes layers are being
// built in parallel; a shared helper file would collide, so each layer keeps
// the minimum it needs. Design's own `clamp01` / `smooth` from
// `homes-3d-core.js`, ported exactly.

private let attTau = Double.pi * 2

private func attClamp01(_ x: Double) -> Double { x < 0 ? 0 : (x > 1 ? 1 : x) }

private func attSmooth(_ x: Double) -> Double {
    let t = attClamp01(x)
    return t * t * (3 - 2 * t)
}

/// The fractional part, always in `0..<1`. Stands in for JavaScript's `%` on a
/// positive clock, and stays correct if a caller ever hands back a negative one.
private func attFrac(_ x: Double) -> Double { x - floor(x) }

/// A single rise-and-fall over one turn of `u`, shaped by `power`.
private func attPulse(_ u: Double, _ power: Double) -> Double {
    pow(max(0, sin(.pi * u)), power)
}

// MARK: - What a form hands the renderer

/// One moving part's state at an instant on the chamber clock.
///
/// Position, scale, rotation, opacity and emissive intensity — the five things
/// Design's `act(t)` writes. Geometry is the renderer's; these are the numbers
/// that geometry follows.
struct AttributeMotion: Equatable {
    var x: Double
    var y: Double
    var z: Double
    var scaleX: Double
    var scaleY: Double
    var scaleZ: Double
    /// Rotation about x, y and z, in radians. These may accumulate past a full
    /// turn where Design spins a part continuously; read them modulo 2π.
    var pitch: Double
    var yaw: Double
    var roll: Double
    var opacity: Double
    var intensity: Double

    init(x: Double = 0, y: Double = 0, z: Double = 0,
         scale: Double = 1,
         pitch: Double = 0, yaw: Double = 0, roll: Double = 0,
         opacity: Double = 1, intensity: Double = 1) {
        self.x = x
        self.y = y
        self.z = z
        self.scaleX = scale
        self.scaleY = scale
        self.scaleZ = scale
        self.pitch = pitch
        self.yaw = yaw
        self.roll = roll
        self.opacity = opacity
        self.intensity = intensity
    }

    /// Uniform scale. Reading gives the x axis; writing sets all three.
    var scale: Double {
        get { scaleX }
        set {
            scaleX = newValue
            scaleY = newValue
            scaleZ = newValue
        }
    }
}

/// The colour word her card gives her attribute, where it gives one. It tints
/// her actor without touching her āvaraṇa's light; `nil` means the room's own
/// light is used unchanged.
struct AttributeTint: Equatable {
    let hex: UInt32

    init(_ hex: UInt32) { self.hex = hex }

    var red: Double { Double((hex >> 16) & 0xFF) / 255 }
    var green: Double { Double((hex >> 8) & 0xFF) / 255 }
    var blue: Double { Double(hex & 0xFF) / 255 }
}

/// Where the actor is mounted in the room, and how the mount changes past the
/// second adaptation.
struct AttributeMount: Equatable {
    /// Her own altitude, a little in front of her seat.
    var y: Double
    /// Depth. More negative is further from the walker.
    var z: Double
    var scale: Double
    /// What the second adaptation does to a transparent material's opacity:
    /// the attribute stops being an object held apart from the room.
    var opacityFactor: Double

    /// Design applies the fade multiplicatively and clamps at full opacity.
    func fading(_ base: Double) -> Double { min(1, base * opacityFactor) }
}

/// One instant of a form's action: the form's own group, plus each moving part
/// in the order `HomeAttributeForm.movingParts` names them.
struct AttributeFrame: Equatable {
    var body: AttributeMotion
    var parts: [AttributeMotion]
}

/// A frame, with the mount it is drawn at.
struct AttributeState: Equatable {
    var mount: AttributeMount
    var body: AttributeMotion
    var parts: [AttributeMotion]
}

// MARK: - The twenty-six forms

/// The twenty-six shapes that act in the 102 rooms.
///
/// **Design's keys and these names.** Design names each form with the card's
/// own word. Twenty-three of those words are already shapes and are kept
/// verbatim. Three were body words, and the aniconic law is at its most exposed
/// exactly here, so the Swift identity is the shape and Design's word survives
/// as `designKey` for traceability:
///
/// | Design's key | here | what is actually drawn |
/// |---|---|---|
/// | `seal` | `foldingCapsules` | five capsules on an arc, folding in turn |
/// | `palm` | `linedDisc` | a disc bearing three lines, turning open |
/// | `skullcup` | `shell` | a hemispherical shell, open upward |
///
/// Design already draws all three abstractly — the rename only stops a reader
/// of this file from restoring the figure the drawing never had. The card words
/// that *are* figures (`hand`, `ear`, `gaze`, `spine`) live in `HomeAttribute.kin`
/// and are mapped away from the figure onto a shape; that mapping is the
/// aniconic mechanism, not a breach of it.
enum HomeAttributeForm: String, CaseIterable {
    case noose, goad, cup, arrows, bow, mirror, lotus, flame, rosary, trident
    case vajra, shell, plough, sceptre, garland, seed, gem, grain, lamp, chain
    case herb, ground, radiance, foldingCapsules, linedDisc, line
}

extension HomeAttributeForm {

    /// Design's own word for this form, as `homes-cards.js` writes it in
    /// `HomeAttribute.attributeKeys` and `HomeAttribute.kin`.
    var designKey: String {
        switch self {
        case .foldingCapsules: return "seal"
        case .linedDisc: return "palm"
        case .shell: return "skullcup"
        default: return rawValue
        }
    }

    /// What the renderer draws. Shapes only — never a figure.
    var shape: String {
        switch self {
        case .noose: return "a ring, and the mote it closes on"
        case .goad: return "a shaft with a hooked tip, and the mote it steers"
        case .cup: return "a turned bowl, and the disc of nectar in it"
        case .arrows: return "five rods, each with a bright tip"
        case .bow: return "a curved stave, and the line strung between its ends"
        case .mirror: return "a polished disc with a rim, and the light thrown back"
        case .lotus: return "eight petals around a lit centre"
        case .flame: return "an open cone inside a halo"
        case .rosary: return "twenty-seven beads on a circle"
        case .trident: return "a shaft carrying three prongs"
        case .vajra: return "a core bar with a cluster of prongs at each end"
        case .shell: return "a hemispherical shell open upward, a darkening disc, a rim"
        case .plough: return "a tilted beam, a wedge, and the marks it leaves"
        case .sceptre: return "a rod with an octahedral finial"
        case .garland: return "twenty motes strung along a slow spiral"
        case .seed: return "a closed husk with a dense core"
        case .gem: return "a refracting octahedron, and the light it gives"
        case .grain: return "a heap, and grains falling past it"
        case .lamp: return "a shallow dish with a lit wick"
        case .chain: return "seven links in a vertical run"
        case .herb: return "a stem carrying six leaves"
        case .ground: return "a hexagonal slab, and the load resting above it"
        case .radiance: return "a core and a wide halo; nothing is held"
        case .foldingCapsules: return "five capsules spread on an arc, folding in turn"
        case .linedDisc: return "a disc bearing three straight lines, turning"
        case .line: return "one drawn line, sixty samples long"
        }
    }

    /// The one thing it does. A form that only sits is not a form.
    var action: String {
        switch self {
        case .noose: return "draws the vast into the tiny"
        case .goad: return "hooks what wanders, and steers it back"
        case .cup: return "fills, and is emptied"
        case .arrows: return "strikes the five gates in turn"
        case .bow: return "draws, holds the tension, releases"
        case .mirror: return "returns your own light to you"
        case .lotus: return "opens"
        case .flame: return "burns, and never steadies"
        case .rosary: return "tells its own beads, one at a time"
        case .trident: return "holds three as one"
        case .vajra: return "strikes, and is irreversible"
        case .shell: return "receives what has ended"
        case .plough: return "turns what is buried up into the light"
        case .sceptre: return "holds level, and is unhurried"
        case .garland: return "weaves, and lengthens"
        case .seed: return "holds all potential, folded and unspent"
        case .gem: return "grants exactly what was asked"
        case .grain: return "overflows, and cannot be contained"
        case .lamp: return "blesses whatever it lights"
        case .chain: return "unbinds, and the links fall open"
        case .herb: return "mends what was broken"
        case .ground: return "bears everything without strain"
        case .radiance: return "shines; there is nothing held"
        case .foldingCapsules: return "folds, one after another, and opens again"
        case .linedDisc: return "turns open, which is also an answer"
        case .line: return "suggests without saying"
        }
    }

    /// The parts that move, in the order `act(at:)` returns them. Parts that
    /// never move are geometry only, and are not listed.
    var movingParts: [String] {
        func run(_ stem: String, _ n: Int) -> [String] { (1...n).map { "\(stem) \($0)" } }
        switch self {
        case .noose: return ["ring", "caught"]
        case .goad: return ["pulled"]
        case .cup: return ["nectar"]
        case .arrows: return run("rod", 5)
        case .bow: return ["nock", "stave"]
        case .mirror: return ["returned light"]
        case .lotus: return run("petal", 8) + ["centre"]
        case .flame: return ["cone", "halo"]
        case .rosary: return run("bead", 27)
        case .trident: return run("prong", 3)
        case .vajra: return ["flash", "core", "cluster 1", "cluster 2"]
        case .shell: return ["held", "rim"]
        case .plough: return run("mark", 9)
        case .sceptre: return ["finial"]
        case .garland: return run("mote", 20)
        case .seed: return ["husk", "core"]
        case .gem: return ["stone", "grant"]
        case .grain: return run("fall", 26)
        case .lamp: return ["wick"]
        case .chain: return run("link", 7)
        case .herb: return run("leaf", 6)
        case .ground: return ["load", "slab"]
        case .radiance: return ["core", "halo"]
        case .foldingCapsules: return run("capsule", 5)
        case .linedDisc: return ["disc"]
        case .line: return run("sample", 60)
        }
    }

    /// The period, in chamber seconds, after which the whole form repeats.
    ///
    /// Design's action rates are kept exactly. Seven forms carried a secondary
    /// sway or spin whose rate was incommensurate with the action it sat under,
    /// which would leave the form quasi-periodic and its state unrepeatable —
    /// so for those seven the *secondary* rate alone is rounded to the nearest
    /// whole multiple of the action's own period (noose, bow, rosary, vajra,
    /// shell, garland, foldingCapsules; between 0.5% and 15% on a continuous
    /// drift nobody can time). The action itself is never retuned.
    var period: Double {
        switch self {
        case .noose: return (1 / 0.09) * 3
        case .goad: return 1 / 0.13
        case .cup: return 1 / 0.055
        case .arrows: return 1 / 0.16
        case .bow: return (1 / 0.075) * 9
        case .mirror: return attTau / 0.06
        case .lotus: return attTau / 0.07
        case .flame: return attTau / 0.1
        case .rosary: return (27 / 0.6) * 12
        case .trident: return 1 / 0.14
        case .vajra: return (1 / 0.11) * 3
        case .shell: return (1 / 0.048) * 10
        case .plough: return 1 / 0.07
        case .sceptre: return attTau / 0.002
        case .garland: return (15 / 0.5) * 5
        case .seed: return attTau / 0.01
        case .gem: return attTau / 0.01
        case .grain: return 1 / 0.28
        case .lamp: return attTau / 0.01
        case .chain: return 1 / 0.06
        case .herb: return 1 / 0.2
        case .ground: return attTau / 0.09
        case .radiance: return attTau / 0.075
        case .foldingCapsules: return (1 / 0.18) * 23
        case .linedDisc: return attTau / 0.06
        case .line: return 1 / 0.14
        }
    }

    /// Every form, indexed by Design's key.
    static let byDesignKey: [String: HomeAttributeForm] = {
        var map: [String: HomeAttributeForm] = [:]
        for form in HomeAttributeForm.allCases { map[form.designKey] = form }
        return map
    }()
}

// MARK: - The action, at an instant
//
// Design's `act(t)` bodies, one for one. Each returns the numbers, never the
// geometry: where a part is, how large, how turned, how bright, how opaque.

extension HomeAttributeForm {

    /// This form's state at `t` seconds on the chamber clock.
    ///
    /// Pure: the same `t` always gives the same frame, and no call leaves
    /// anything behind for the next one.
    func act(at t: Double) -> AttributeFrame {
        switch self {
        case .noose: return actNoose(t)
        case .goad: return actGoad(t)
        case .cup: return actCup(t)
        case .arrows: return actArrows(t)
        case .bow: return actBow(t)
        case .mirror: return actMirror(t)
        case .lotus: return actLotus(t)
        case .flame: return actFlame(t)
        case .rosary: return actRosary(t)
        case .trident: return actTrident(t)
        case .vajra: return actVajra(t)
        case .shell: return actShell(t)
        case .plough: return actPlough(t)
        case .sceptre: return actSceptre(t)
        case .garland: return actGarland(t)
        case .seed: return actSeed(t)
        case .gem: return actGem(t)
        case .grain: return actGrain(t)
        case .lamp: return actLamp(t)
        case .chain: return actChain(t)
        case .herb: return actHerb(t)
        case .ground: return actGround(t)
        case .radiance: return actRadiance(t)
        case .foldingCapsules: return actFoldingCapsules(t)
        case .linedDisc: return actLinedDisc(t)
        case .line: return actLine(t)
        }
    }

    /// The action's own phase at `t`, in `0..<1`.
    ///
    /// `turns` is how many times the action comes round in one `period`, so the
    /// phase is written against the period and wraps exactly on it, rather than
    /// a rounding error to one side — which, on an action that resets hard at
    /// the wrap, is the difference between a cast beginning and a cast landing.
    /// `turn(t, 3)` on the noose is Design's own `(t * 0.09) % 1`.
    private func turn(_ t: Double, _ turns: Double) -> Double {
        attFrac(t / period * turns)
    }

    // ── draws the vast into the tiny ──────────────────────────────────────
    private func actNoose(_ t: Double) -> AttributeFrame {
        let u = turn(t, 3)                     // 0.09 · cast, close, draw home
        let cast = attSmooth(attClamp01(u / 0.34))
        let close = attSmooth(attClamp01((u - 0.34) / 0.3))
        let draw = attSmooth(attClamp01((u - 0.62) / 0.38))
        let r = 0.6 + cast * 3.2 - close * 2.2
        let z = -cast * 3.4 + draw * 3.2
        let ring = AttributeMotion(z: z,
                                   scale: r * (1 - draw * 0.82),
                                   pitch: 0.3 + sin(attTau * t / period) * 0.1)
        let caught = AttributeMotion(z: z,
                                     scale: (0.4 + cast * 1.4) * (1 - draw * 0.7),
                                     opacity: 0.2 + close * 0.6)
        return AttributeFrame(body: AttributeMotion(), parts: [ring, caught])
    }

    // ── hooks what wanders, and steers it back ────────────────────────────
    private func actGoad(_ t: Double) -> AttributeFrame {
        let u = turn(t, 1)                     // Design: t * 0.13
        let reach = attSmooth(attClamp01(u / 0.4))
        let pull = attSmooth(attClamp01((u - 0.45) / 0.55))
        let body = AttributeMotion(roll: -0.2 + reach * 0.34 - pull * 0.2)
        let pulled = AttributeMotion(x: 0.7, y: 1.3, z: -reach * 2.8 + pull * 2.6,
                                     opacity: 0.2 + reach * 0.5)
        return AttributeFrame(body: body, parts: [pulled])
    }

    // ── fills, and is emptied ─────────────────────────────────────────────
    private func actCup(_ t: Double) -> AttributeFrame {
        let u = turn(t, 1)                     // Design: t * 0.055
        let fill = attSmooth(attClamp01(u / 0.55))
        let emptied = attSmooth(attClamp01((u - 0.62) / 0.38))
        let level = 0.1 + fill * 0.44 - emptied * 0.44
        let nectar = AttributeMotion(y: level,
                                     scale: 0.9 + level * 0.3,
                                     opacity: 0.3 + fill * 0.5 - emptied * 0.3)
        return AttributeFrame(body: AttributeMotion(roll: emptied * 0.34), parts: [nectar])
    }

    // ── strikes the five gates in turn ────────────────────────────────────
    private func actArrows(_ t: Double) -> AttributeFrame {
        var parts: [AttributeMotion] = []
        for i in 0..<5 {
            let a = -0.9 + (Double(i) / 4) * 1.8
            let u = attFrac(turn(t, 1) + Double(i) / 5)   // Design: t * 0.16
            let fly = pow(attClamp01(u / 0.3), 0.6)
            let back = attSmooth(attClamp01((u - 0.42) / 0.58))
            parts.append(AttributeMotion(x: sin(a) * 0.42,
                                         y: cos(a) * 0.2,
                                         z: -fly * 4.2 * (1 - back),
                                         yaw: a * 0.5,
                                         opacity: (0.3 + fly * 0.6) * (1 - back * 0.7)))
        }
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── draws, holds the tension, releases ────────────────────────────────
    private func actBow(_ t: Double) -> AttributeFrame {
        let u = turn(t, 9)                     // Design: t * 0.075
        let draw = attSmooth(attClamp01(u / 0.62))
        let loose = attClamp01((u - 0.7) / 0.08)
        let body = AttributeMotion(yaw: sin(attTau * t / period) * 0.14)
        let nock = AttributeMotion(z: draw * 1.5 * (1 - loose))
        var stave = AttributeMotion()
        stave.scaleX = 1 - draw * 0.06 * (1 - loose)
        return AttributeFrame(body: body, parts: [nock, stave])
    }

    // ── returns your own light to you ─────────────────────────────────────
    private func actMirror(_ t: Double) -> AttributeFrame {
        let yaw = sin(t * 0.06) * 0.7
        let face = pow(max(0, cos(yaw)), 6)
        let returned = AttributeMotion(z: 0.5, scale: 2 + face * 2.4, opacity: face * 0.65)
        return AttributeFrame(body: AttributeMotion(yaw: yaw), parts: [returned])
    }

    // ── opens ─────────────────────────────────────────────────────────────
    private func actLotus(_ t: Double) -> AttributeFrame {
        let open = 0.5 + 0.5 * sin(t * 0.07)
        var parts: [AttributeMotion] = []
        for i in 0..<8 {
            parts.append(AttributeMotion(pitch: -0.15 - open * 1.05,
                                         yaw: (Double(i) / 8) * attTau))
        }
        parts.append(AttributeMotion(scale: 0.6 + open * 0.8, opacity: 0.3 + open * 0.5))
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── burns, and never steadies ─────────────────────────────────────────
    private func actFlame(_ t: Double) -> AttributeFrame {
        let f = sin(t * 3.1) * 0.5 + sin(t * 5.3) * 0.3 + sin(t * 1.7) * 0.2
        var cone = AttributeMotion(y: 0.5, roll: f * 0.06)
        cone.scaleX = 1 + f * 0.08
        cone.scaleY = 1 + f * 0.16
        cone.scaleZ = 1 + f * 0.08
        let halo = AttributeMotion(y: 0.5, scale: 2 + f * 0.4,
                                   opacity: 0.34 + abs(f) * 0.14)
        return AttributeFrame(body: AttributeMotion(), parts: [cone, halo])
    }

    // ── tells its own beads, one at a time ────────────────────────────────
    private func actRosary(_ t: Double) -> AttributeFrame {
        let n = 27.0
        let at = n * turn(t, 12)          // Design: (t * 0.6) % 27
        var parts: [AttributeMotion] = []
        for i in 0..<27 {
            let a = (Double(i) / n) * attTau
            let raw = abs(Double(i) - at)
            let d = min(raw, n - raw)
            let near = max(0, 1 - d / 2)
            parts.append(AttributeMotion(x: cos(a) * 1.05, y: sin(a) * 1.05,
                                         scale: 1 + near * 0.5,
                                         intensity: 0.5 + near * 4))
        }
        return AttributeFrame(body: AttributeMotion(roll: -attTau * t / period), parts: parts)
    }

    // ── holds three as one ────────────────────────────────────────────────
    private func actTrident(_ t: Double) -> AttributeFrame {
        let xs = [-0.34, 0.0, 0.34]
        var parts: [AttributeMotion] = []
        for i in 0..<3 {
            let u = attFrac(turn(t, 1) + Double(i) / 3)   // Design: t * 0.14
            let lift = attPulse(u, 3)
            parts.append(AttributeMotion(x: xs[i], y: 1.5 + lift * 0.24,
                                         intensity: 1.2 + lift * 2.6))
        }
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── strikes, and is irreversible ──────────────────────────────────────
    private func actVajra(_ t: Double) -> AttributeFrame {
        let u = turn(t, 3)                     // Design: t * 0.11
        let flash = pow(attClamp01(1 - u / 0.06), 2)
        let spin = attTau * t / period
        let strike = AttributeMotion(scale: 2 + flash * 5, opacity: flash * 0.9)
        let core = AttributeMotion(intensity: 1.4 + flash * 6)
        let clusterA = AttributeMotion(pitch: -spin)
        let clusterB = AttributeMotion(pitch: spin)
        return AttributeFrame(body: AttributeMotion(),
                              parts: [strike, core, clusterA, clusterB])
    }

    // ── receives what has ended ───────────────────────────────────────────
    private func actShell(_ t: Double) -> AttributeFrame {
        let u = turn(t, 10)                    // Design: t * 0.048
        let held = AttributeMotion(y: -0.06, scale: 0.6 + u * 0.5,
                                   pitch: -.pi / 2, opacity: 0.2 + u * 0.5)
        let rim = AttributeMotion(pitch: .pi / 2, opacity: 0.24 + (1 - u) * 0.4)
        return AttributeFrame(body: AttributeMotion(yaw: attTau * t / period),
                              parts: [held, rim])
    }

    // ── turns what is buried up into the light ────────────────────────────
    private func actPlough(_ t: Double) -> AttributeFrame {
        let u = turn(t, 1)                     // Design: t * 0.07
        var parts: [AttributeMotion] = []
        for i in 0..<9 {
            let age = attFrac(u - Double(i) / 12)
            parts.append(AttributeMotion(x: -0.85 - (u * 2.8) + Double(i) * 0.3,
                                         y: -0.4 + age * 0.9,
                                         scale: 0.4 + age * 0.5,
                                         opacity: max(0, 0.5 - age * 0.5)))
        }
        return AttributeFrame(body: AttributeMotion(x: -1.4 + u * 2.8), parts: parts)
    }

    // ── holds level, and is unhurried ─────────────────────────────────────
    private func actSceptre(_ t: Double) -> AttributeFrame {
        // the quiet authority of the one who need not raise her voice
        let body = AttributeMotion(roll: sin(t * 0.022) * 0.012)
        let finial = AttributeMotion(y: 1.24, yaw: t * 0.05,
                                     intensity: 1.4 + 0.25 * sin(t * 0.09))
        return AttributeFrame(body: body, parts: [finial])
    }

    // ── weaves, and lengthens ─────────────────────────────────────────────
    private func actGarland(_ t: Double) -> AttributeFrame {
        let grown = 6 + 15 * turn(t, 5)      // Design: 6 + (t * 0.5) % 15
        var parts: [AttributeMotion] = []
        for i in 0..<20 {
            let on = Double(i) < grown
            let a = (Double(i) / 20) * attTau * 1.4
            parts.append(AttributeMotion(x: cos(a) * 1.05,
                                         y: sin(a) * 0.5 - Double(i) * 0.012,
                                         z: sin(a) * 0.3,
                                         scale: on ? 0.42 : 0.01,
                                         opacity: on ? 0.5 : 0))
        }
        let body = AttributeMotion(roll: sin(attTau * t / period) * 0.1)
        return AttributeFrame(body: body, parts: parts)
    }

    // ── holds all potential, folded and unspent ───────────────────────────
    private func actSeed(_ t: Double) -> AttributeFrame {
        // it never opens; it only becomes denser
        let b = 0.5 + 0.5 * sin(t * 0.05)
        let husk = AttributeMotion(scale: 1 - b * 0.06)
        let core = AttributeMotion(scale: 0.5 + b * 0.34, opacity: 0.2 + b * 0.34)
        return AttributeFrame(body: AttributeMotion(yaw: t * 0.02), parts: [husk, core])
    }

    // ── grants exactly what was asked ─────────────────────────────────────
    private func actGem(_ t: Double) -> AttributeFrame {
        let give = pow(0.5 + 0.5 * sin(t * 0.09), 3)
        let stone = AttributeMotion(pitch: t * 0.08, yaw: t * 0.12)
        let grant = AttributeMotion(scale: 1.2 + give * 4, opacity: 0.16 + give * 0.42)
        return AttributeFrame(body: AttributeMotion(), parts: [stone, grant])
    }

    // ── overflows, and cannot be contained ────────────────────────────────
    private func actGrain(_ t: Double) -> AttributeFrame {
        var parts: [AttributeMotion] = []
        for i in 0..<26 {
            // Design seeds each grain with `Math.random()` at build time, which
            // would make the frame depend on when the room was made. The two
            // irrationals below scatter the same way and keep `act` pure.
            let seed = attFrac(Double(i) * 0.618_033_988_749_894_8)
            let a = attFrac(Double(i) * 0.754_877_666_246_692_7) * attTau
            let u = attFrac(turn(t, 1) + seed)   // Design: t * 0.28
            let r = 0.14 + u * 0.7
            parts.append(AttributeMotion(x: cos(a) * r,
                                         y: 0.7 - u * 1.2,
                                         z: sin(a) * r,
                                         scale: 0.2,
                                         opacity: 0.7 * (1 - u * 0.7)))
        }
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── blesses whatever it lights ────────────────────────────────────────
    private func actLamp(_ t: Double) -> AttributeFrame {
        let f = 1 + sin(t * 2.6) * 0.05 + sin(t * 4.1) * 0.03
        let wick = AttributeMotion(x: sin(t * 1.9) * 0.012, y: 0.34, scale: f)
        return AttributeFrame(body: AttributeMotion(yaw: sin(t * 0.03) * 0.24),
                              parts: [wick])
    }

    // ── unbinds, and the links fall open ──────────────────────────────────
    private func actChain(_ t: Double) -> AttributeFrame {
        let u = turn(t, 1)                     // Design: t * 0.06
        var parts: [AttributeMotion] = []
        for i in 0..<7 {
            let gone = attClamp01((u - Double(i) / 9) * 6)
            parts.append(AttributeMotion(y: 0.9 - Double(i) * 0.3 - gone * gone * 3.4,
                                         yaw: i % 2 == 1 ? .pi / 2 : 0,
                                         roll: gone * 2.2,
                                         opacity: 1 - gone))
        }
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── mends what was broken ─────────────────────────────────────────────
    private func actHerb(_ t: Double) -> AttributeFrame {
        var parts: [AttributeMotion] = []
        for i in 0..<6 {
            let u = attFrac(turn(t, 1) + Double(i) / 6)   // Design: t * 0.2
            let heal = attPulse(u, 4)
            parts.append(AttributeMotion(x: i % 2 == 1 ? 0.18 : -0.18,
                                         y: -0.4 + Double(i) * 0.24,
                                         scale: 1 + heal * 0.28,
                                         roll: i % 2 == 1 ? -0.6 : 0.6,
                                         opacity: 0.3 + heal * 0.5))
        }
        return AttributeFrame(body: AttributeMotion(), parts: parts)
    }

    // ── bears everything without strain ───────────────────────────────────
    private func actGround(_ t: Double) -> AttributeFrame {
        // it does not yield; only the load breathes
        let sway = sin(t * 0.09)
        let load = AttributeMotion(y: 0.7 + sway * 0.1, opacity: 0.22 + 0.12 * sway)
        var slab = AttributeMotion()
        slab.scaleY = 1
        return AttributeFrame(body: AttributeMotion(), parts: [load, slab])
    }

    // ── shines; there is nothing held ─────────────────────────────────────
    private func actRadiance(_ t: Double) -> AttributeFrame {
        let b = 0.5 + 0.5 * sin(t * 0.075)
        let core = AttributeMotion(scale: 1 + b * 0.4, opacity: 0.85)
        let halo = AttributeMotion(scale: 3.4 + b * 2.4, opacity: 0.2 + b * 0.22)
        return AttributeFrame(body: AttributeMotion(), parts: [core, halo])
    }

    // ── folds, one after another, and opens again ─────────────────────────
    // Design's `seal`: five capsules on an arc. Abstract in the drawing, and
    // named here for the shape so it stays abstract in the reading too.
    private func actFoldingCapsules(_ t: Double) -> AttributeFrame {
        var parts: [AttributeMotion] = []
        for i in 0..<5 {
            let a = -0.7 + (Double(i) / 4) * 1.4
            let u = attFrac(turn(t, 23) + Double(i) / 5)  // Design: t * 0.18
            let fold = attPulse(u, 2)
            parts.append(AttributeMotion(x: sin(a) * 0.5,
                                         y: 0.4 + cos(a) * 0.16,
                                         pitch: fold * 0.9,
                                         roll: -a * 0.8,
                                         intensity: 0.6 + fold * 1.6))
        }
        let body = AttributeMotion(yaw: sin(attTau * t / period) * 0.2)
        return AttributeFrame(body: body, parts: parts)
    }

    // ── turns open, which is also an answer ───────────────────────────────
    // Design's `palm`: a disc bearing three lines. Same ruling as above.
    private func actLinedDisc(_ t: Double) -> AttributeFrame {
        let turning = 0.5 + 0.5 * sin(t * 0.06)
        let disc = AttributeMotion(pitch: -0.4, opacity: 0.24 + turning * 0.28)
        return AttributeFrame(body: AttributeMotion(roll: -0.3 + turning * 0.6),
                              parts: [disc])
    }

    // ── suggests without saying ───────────────────────────────────────────
    private func actLine(_ t: Double) -> AttributeFrame {
        let drawn = turn(t, 1)                     // Design: t * 0.14
        var parts: [AttributeMotion] = []
        for i in 0..<60 {
            let u = (Double(i) / 59) * drawn
            parts.append(AttributeMotion(x: sin(u * 3.2) * 1.1,
                                         y: (u - 0.5) * 1.6 + sin(u * 6) * 0.16,
                                         z: cos(u * 2.4) * 0.3))
        }
        let body = AttributeMotion(opacity: 0.3 + 0.55 * sin(.pi * drawn))
        return AttributeFrame(body: body, parts: parts)
    }
}

// MARK: - Who acts in which room

/// The assignment, the aliases, the tints and the mount.
///
/// Every table here is keyed by `khadgamalaPosition`. Design's cards are keyed
/// by position too, so the port is one-to-one and no name is ever consulted:
/// Kāmeśvarī is a Ring 7 Vāsinī *and* the Ring 8 Icchā-śakti, and the Ring 4
/// Devīs repeat Ring 1's Mudrā names, so a name could never decide this.
enum HomeAttribute {

    /// The attribute word her card gives her, by position — Design's
    /// `ATTRIBUTE` from `homes-cards.js`, verbatim.
    ///
    /// These are *card words*, not forms: `hook`, `veil`, `gaze` and the rest
    /// resolve through `kin` onto one of the twenty-six shapes.
    static let attributeKeys: [Int: String] = {
        let rows: [(Int, String)] = [
            (1, "noose"), (2, "goad"), (3, "veil"), (4, "palm"), (5, "sceptre"),
            (6, "noose"), (7, "bow"), (8, "cup"), (9, "lotus"), (10, "hook"),
            (11, "rosary"), (12, "trident"), (13, "spear"), (14, "discus"),
            (15, "plough"), (16, "vajra"), (17, "skullcup"), (18, "lotus"),
            (19, "seal"), (20, "seal"), (21, "hand"), (22, "palm"), (23, "seal"),
            (24, "goad"), (25, "seal"), (26, "seed"), (27, "triangle"), (28, "triad"),
            (29, "noose"), (30, "flame"), (31, "hand"), (32, "ear"), (33, "palm"),
            (34, "mirror"), (35, "cup"), (36, "lotus"), (37, "gaze"), (38, "spine"),
            (39, "gaze"), (40, "syllable"), (41, "seed"), (42, "gaze"), (43, "drop"),
            (44, "palm"),
            (45, "flower"), (46, "belt"), (47, "gaze"), (48, "hand"), (49, "line"),
            (50, "streamer"), (51, "hook"), (52, "garland"),
            (53, "churn"), (54, "molten"), (55, "hand"), (56, "pour"), (57, "veil"),
            (58, "palm"), (59, "stretch"), (60, "palm"), (61, "brush"), (62, "cup"),
            (63, "gem"), (64, "grain"), (65, "syllable"), (66, "triangle"),
            (67, "boon"), (68, "grain"), (69, "flower"), (70, "lamp"), (71, "fruit"),
            (72, "chain"), (73, "drop"), (74, "goad"), (75, "radiance"), (76, "boon"),
            (77, "flame"), (78, "radiance"), (79, "sceptre"), (80, "radiance"),
            (81, "herb"), (82, "ground"), (83, "cleanse"), (84, "radiance"),
            (85, "shield"), (86, "fruit"),
            (87, "rosary"), (88, "bow"), (89, "cup"), (90, "water"), (91, "noose"),
            (92, "banner"), (93, "sceptre"), (94, "skullcup"), (95, "arrows"),
            (96, "bow"), (97, "noose"), (98, "goad"),
            (99, "radiance"), (100, "vajra"), (101, "garland"), (102, "arrows"),
        ]
        return Dictionary(uniqueKeysWithValues: rows)
    }()

    /// Forms that stand in for the rest, chosen by kinship rather than
    /// convenience — Design's `KIN`, verbatim.
    ///
    /// This map is also where the aniconic law does its work: a card that names
    /// a `hand`, an `ear`, a `gaze` or a `spine` is answered by a shape — a
    /// lined disc, light, a rod — and never by the figure.
    static let kin: [String: String] = {
        let rows: [(String, String)] = [
            ("hook", "goad"), ("spear", "trident"), ("discus", "trident"),
            ("triangle", "seal"), ("triad", "seal"), ("hand", "palm"),
            ("gaze", "radiance"), ("spine", "sceptre"), ("syllable", "radiance"),
            ("ear", "palm"), ("drop", "cup"), ("flower", "lotus"),
            ("belt", "garland"), ("streamer", "garland"), ("churn", "seal"),
            ("molten", "cup"), ("pour", "grain"), ("veil", "palm"),
            ("stretch", "sceptre"), ("brush", "line"), ("boon", "palm"),
            ("fruit", "gem"), ("water", "cup"), ("banner", "garland"),
            ("cleanse", "palm"), ("shield", "ground"), ("radiance", "radiance"),
        ]
        return Dictionary(uniqueKeysWithValues: rows)
    }()

    /// The colour word her card gives her attribute, where it gives one —
    /// Design's `ATTR_TINT`. Fifteen of the 102; the rest take the room's light.
    static let tints: [Int: AttributeTint] = {
        let rows: [(Int, UInt32)] = [
            (1, 0xf2ecd8), (4, 0xb8263c), (7, 0xff7a3c), (13, 0xffb45c),
            (15, 0x6a5f78), (17, 0xd8d2c4), (18, 0xffd76a), (29, 0xff6a7c),
            (45, 0xffb0c4), (62, 0xff8ab0), (91, 0xff7a5c), (92, 0xffd76a),
            (99, 0xfff6e2), (100, 0xff4a5c), (101, 0xffd76a),
        ]
        return Dictionary(uniqueKeysWithValues: rows.map { ($0.0, AttributeTint($0.1)) })
    }()

    /// The card word at this position, or `nil` outside 1–102.
    static func designKey(atPosition position: Int) -> String? {
        attributeKeys[position]
    }

    /// The shape a card word resolves to — directly, or through `kin`.
    ///
    /// Design falls back to its `seal` for an unknown word. There is no
    /// fallback here: every one of the 102 words resolves, and a silent default
    /// would be the one way a room could end up belonging to anyone.
    static func resolve(designKey key: String) -> HomeAttributeForm? {
        if let direct = HomeAttributeForm.byDesignKey[key] { return direct }
        if let alias = kin[key] { return HomeAttributeForm.byDesignKey[alias] }
        return nil
    }

    /// The shape that acts in the room at this position.
    static func form(atPosition position: Int) -> HomeAttributeForm? {
        guard let key = attributeKeys[position] else { return nil }
        return resolve(designKey: key)
    }

    /// The tint her card gives her actor, or `nil` for the room's own light.
    static func tint(atPosition position: Int) -> AttributeTint? {
        tints[position]
    }
}

// MARK: - Altitude and mount

extension HomeAttribute {

    /// Where the body feels her — normalised, soles `1` → crown `0`.
    ///
    /// **One table, not two.** This layer and the grammar each ported Design's
    /// `bodyAltitude` while being built on parallel branches, so each carried
    /// its own copy of the eleven zones. They are unified here at the resolve:
    /// ``HomeGrammar/bodyZones`` is the single table — it is the faithful port,
    /// keeping each zone's JavaScript literal beside its pattern — and this
    /// forwards to it so the attribute can never drift from the room it acts
    /// in. The ASCII `muladhara` this layer used to carry alone moved there
    /// with it, so nothing was lost in the merge.
    ///
    /// The default is the middle of the field — a location the base has not
    /// filled in is a blank to be guarded, never an assumption to be made.
    static func bodyAltitude(forBodilyLocation location: String) -> Double {
        HomeGrammar.bodyAltitude(bodilyLocation: location)
    }

    /// Where the actor rests before the second adaptation.
    static let restingDepth: Double = -4.6
    static let restingScale: Double = 0.9

    /// How far into the second adaptation the chamber clock has come, `0`–`1`.
    /// `HomeMemory` already holds both marks, so they are not restated here.
    static func deep(atChamberTime t: TimeInterval) -> Double {
        let span = HomeMemory.secondAdaptationEnd - HomeMemory.holdEnd
        return attSmooth((t - HomeMemory.holdEnd) / span)
    }

    /// She holds it at her own altitude, a little in front of her seat.
    ///
    /// Past the second adaptation the attribute is no longer held apart from
    /// the room — it grows into it, comes toward the walker, and stops being an
    /// object: at full depth the scale is `3.5`, the depth `-1.2`, and every
    /// transparent material is at `0.45` of what it was.
    static func mount(bodyAltitude altitude: Double,
                      chamberTime t: TimeInterval) -> AttributeMount {
        let b = deep(atChamberTime: t)
        return AttributeMount(y: (0.5 - altitude) * 6.4 - 0.4,
                              z: restingDepth + b * 3.4,
                              scale: restingScale + b * 2.6,
                              opacityFactor: 1 - b * 0.55)
    }
}

// MARK: - The actor

/// Her attribute, resolved for one room: which shape acts, what tints it, and
/// where it is mounted. Pure — it holds no name, no content, and no renderer.
struct HomeAttributeActor: Equatable {
    /// `khadgamalaPosition` 1–102. The only key.
    let position: Int
    let form: HomeAttributeForm
    /// Design's card word for this position, kept for traceability.
    let designKey: String
    /// `nil` means the room's own light, untinted.
    let tint: AttributeTint?
    let bodyAltitude: Double

    /// Where it rests before the second adaptation.
    var restingMount: AttributeMount {
        HomeAttribute.mount(bodyAltitude: bodyAltitude, chamberTime: 0)
    }

    /// The whole actor at `t` seconds on the chamber clock.
    func state(atChamberTime t: TimeInterval) -> AttributeState {
        let frame = form.act(at: t)
        return AttributeState(mount: HomeAttribute.mount(bodyAltitude: bodyAltitude,
                                                         chamberTime: t),
                              body: frame.body,
                              parts: frame.parts)
    }
}

extension HomeAttribute {

    /// The actor for a position, given the body location her row carries.
    static func actor(atPosition position: Int,
                      bodilyLocation: String) -> HomeAttributeActor? {
        guard let key = attributeKeys[position],
              let form = resolve(designKey: key) else { return nil }
        return HomeAttributeActor(position: position,
                                  form: form,
                                  designKey: key,
                                  tint: tints[position],
                                  bodyAltitude: bodyAltitude(forBodilyLocation: bodilyLocation))
    }

    /// The actor for a Śakti, read from her synced row.
    ///
    /// Her position is the key and her body location the only other field read;
    /// nothing is bundled and no name is consulted. A row that has not yet been
    /// given a Khaḍgamālā position has no room, and gets no actor.
    static func actor(for shakti: Shakti) -> HomeAttributeActor? {
        guard let position = shakti.khadgamalaPosition else { return nil }
        return actor(atPosition: position, bodilyLocation: shakti.bodilyLocation)
    }
}
