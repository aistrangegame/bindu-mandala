// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here can exist in a build that reaches Neev. The test
// action builds Debug, so every spike test still sees it.
#if DEBUG
import SwiftUI
import SceneKit
import UIKit
import QuartzCore

// MARK: - Garimā · khaḍgamālā position 4 · the room that presses
//
// The renderer spike, variant A: **SceneKit geometry under a SwiftUI Metal light
// pass.** Real meshes, a real directional light casting real shadows onto real
// strata, a real point light for the ember; then one `.colorEffect` shader
// carrying the light that is in the air rather than on the stone.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THIS ROOM IS
// ─────────────────────────────────────────────────────────────────────────────
//
// Her mechanism is `chamberPress` in Design's `homes-chambers.js`, read in full
// before a line of this was written. Its premise: **the ceiling descends the whole
// time you stand in it, and the floor thickens into strata beneath you.** Design's
// own paired example — one room must lift (Laghimā) and the other must press.
//
// And past the second adaptation every room reverses its own premise. Design
// writes Garimā's reversal out in words, in the file:
//
//     the weight was never above you. It is what you are standing on,
//     and it has been holding you the whole time.
//
// So the reversal here is **not the press undone.** The strata stay compacted —
// what the pressing made is kept. What changes is that the bedding beneath you
// rises into a plinth, the mass lifts away, and you are carried up by the very
// thing that was crushing you. The camera is lifted by the ground. Nothing is
// given back; something has been made.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY THIS ROOM COULD BELONG TO NO OTHER ŚAKTI
// ─────────────────────────────────────────────────────────────────────────────
//
// Five things are read off her, not chosen, and each of them is different for
// every sister she stands beside:
//
// * **Her hue** — `Atmosphere.derive` for khaḍgamālā 4: ring 1's 35°, jittered by
//   the repo's own `(kp * 2654435761) % 1000` hash over ±7°, giving 28.6°.
//   Mahimā (kp 2) lands at 35.3°, Laghimā (kp 3) at 32.0°. Never re-derived from
//   the gemstone; the gem contributes *diffusion only* (ring 1, topaz, 0.20),
//   which is why her shadows are hard and her shafts narrow.
// * **Her altitude** — her bodily location is the Mūlādhāra, the sit-bones and the
//   soles: Design's zone table puts her at 0.94, the lowest reading it gives.
//   Laghimā's solar plexus is 0.60, Mahimā's horizon-of-attention 0.50. The
//   room's gravity, the camera's eye height, the vignette's centre and where the
//   ember sits are all that one number.
// * **Her physics** — her tattva is Pṛthvī, earth. Design's classifier returns
//   `settle`, whose motion is `[0, -|sin(0.07 t + φ)| · amp · 1.3, 0]`: a thing
//   that only ever sinks. Laghimā's Vāyu returns `lift`, Mahimā's Mahat `widen`.
//   Put `lift` in this room and the mechanism contradicts itself in one breath.
// * **Her attribute** — position 4's iconography is the palm, and hers is the one
//   card in Ring 1 that carries a colour word for it: `ATTR_TINT[4] = 0xB8263C`,
//   her accent-red. It tints the mark in the floor and nothing else; it never
//   touches the room's light, exactly as Design keeps them apart.
// * **Her mechanism** — the press, authored for her by hand, one of Design's eight.
//
// The thing that would make this room generic is precisely the thing the spike is
// forbidden to do: paint a pretty cave and light it from the gemstone. Every
// number above comes out of the app's own model.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE LAWS, AS THEY APPLY HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// * **Aniconic.** There is no figure. The palm is not drawn — what is drawn is
//   the *mark a palm left in the ground*, which is a shape that performed an
//   action and then stopped. No mesh is loaded from a file: every vertex in this
//   room is generated in this file, so there is no `.scn`, no `.dae`, no texture,
//   and nothing for a figure to arrive inside.
// * **Never measure.** The room puts no text on screen at all. Not a label, not a
//   count, not a clock. What it knows about how long you have stood here it spends
//   entirely on light.
// * **Position is identity.** Nothing in this file looks a Śakti up by name.
//   `Ingredients.garima(from:)` takes her position and reads the model.
// * **FIDELITY.** The reduce-motion path is real: no display link, no render loop,
//   no `TimelineView`. The room is posed once, at the settled state, and rendered
//   once. See `Ingredients.settledSceneTime` for the reasoning, which is a
//   deliberate resolution of a conflict between Design's invariant 4 and the
//   charter's FIDELITY rule.

// MARK: - The room

/// Garimā's room, rendered with SceneKit and a SwiftUI Metal light pass.
///
/// The clock is injected rather than read from the wall, so the harness can place
/// the room past its second adaptation in one frame instead of waiting 347
/// seconds. `SpikeMetrics.Clock` is the committed apparatus's own time input; this
/// room does not own a second one.
struct GarimaSceneKitRoom: View {

    let ingredients: Ingredients
    let clock: SpikeMetrics.Clock
    /// Forced on for the harness; otherwise the environment decides.
    let forceReduceMotion: Bool

    @Environment(\.accessibilityReduceMotion) private var environmentReduceMotion

    init(ingredients: Ingredients = .garima(from: nil),
         clock: SpikeMetrics.Clock = SpikeMetrics.Clock(),
         forceReduceMotion: Bool = false) {
        self.ingredients = ingredients
        self.clock = clock
        self.forceReduceMotion = forceReduceMotion
    }

    private var reduceMotion: Bool { forceReduceMotion || environmentReduceMotion }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                SceneLayer(ingredients: ingredients, clock: clock, reduceMotion: reduceMotion)
                LightPassLayer(ingredients: ingredients,
                               clock: clock,
                               reduceMotion: reduceMotion,
                               size: geo.size)
                    .allowsHitTesting(false)
            }
        }
        .background(Color(uiColor: ingredients.groundDeep))
        .ignoresSafeArea()
    }
}

// MARK: - Everything the room is made of, read once

extension GarimaSceneKitRoom {

    /// Her room's ingredients, snapshotted off the model once.
    ///
    /// `Shakti` is a SwiftData `@Model` and every property read goes through the
    /// persistence accessors; the baseline bench learned the hard way that reading
    /// models inside a per-frame loop stalls the main actor hard enough for
    /// `testmanagerd` to judge the host dead. So the room reads her once, here,
    /// and never again.
    struct Ingredients: Equatable {

        /// Her position, which is the only key there is.
        let khadgamalaPosition: Int
        let ring: Int
        /// The app's own palette for her — `Theme/Atmosphere.swift`, unmodified.
        let atmosphere: Atmosphere
        /// The gem as **behaviour only**: how diffuse her āvaraṇa's light is.
        /// Ring 1 is topaz at 0.20. Hue, saturation and lightness are the
        /// Atmosphere's and are never taken from the stone.
        let diffusion: Double
        /// One of Design's motions, classified from her tattva and her quality.
        let physics: Physics
        /// Where the body feels her: feet 0.94 → crown 0.10.
        let altitude: Double
        /// Her card's colour word for her attribute, where it gives one.
        let attributeTint: UIColor
        /// Deterministic per-Śakti phase, off the same hash `Atmosphere` jitters with.
        let phase: Double

        // MARK: Derived colour — all of it from `Atmosphere`

        var accent: UIColor { UIColor(atmosphere.accent) }
        var accentBright: UIColor { UIColor(atmosphere.accentBright) }
        var ground: UIColor { UIColor(atmosphere.ground) }
        var groundDeep: UIColor { UIColor(atmosphere.groundDeep) }

        /// The dhātu — the stone the room is cut from. Design's `homes-chambers.js`
        /// derives it as `hsl(h, s * 0.55, 12)`: her own hue, desaturated and taken
        /// nearly to black. That is a *material* derived from the Atmosphere's hue,
        /// not a second opinion about what colour she is.
        var ink: UIColor {
            let h = atmosphere.hue
            return UIColor(HSL(h: h.h, s: h.s * 0.55, l: 12).color())
        }

        // MARK: The one Śakti this file exists for

        /// Garimā, from the app's own model where there is one, and from her
        /// position where there is not.
        ///
        /// Nothing is invented in the nil case: ring 1 comes from `KhadgamalaMap`,
        /// her element from `Element.forRing`, her hue from `Atmosphere.derive`,
        /// and her altitude from her āvaraṇa's region, which for the first ring is
        /// the Feet. A room built without a store is her room with less detail,
        /// never a different Śakti's.
        static func garima(from shakti: Shakti?) -> Ingredients {
            make(khadgamalaPosition: Self.garimaPosition, from: shakti)
        }

        /// Garimā's seat in the garland. Written once, here, so no other line in
        /// this file has to know a number.
        static let garimaPosition = 4

        static func make(khadgamalaPosition kp: Int, from shakti: Shakti?) -> Ingredients {
            let ring = shakti?.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: kp)
            let element = shakti?.element ?? Element.forRing(ring)
            let atmos: Atmosphere
            if let shakti {
                atmos = Atmosphere.derive(from: shakti)
            } else {
                atmos = Atmosphere.derive(ring: ring,
                                          cluster: ring == 2 ? nil : nil,
                                          khadgamala: kp,
                                          element: element)
            }
            let tattva = shakti?.tattva ?? ""
            let quality = shakti?.quality ?? ""
            let location = shakti?.bodilyLocation ?? ""

            return Ingredients(
                khadgamalaPosition: kp,
                ring: ring,
                atmosphere: atmos,
                diffusion: gemDiffusion(ring: ring),
                physics: Physics.classify(tattva: tattva, quality: quality, element: element),
                altitude: bodyAltitude(location: location, ring: ring),
                attributeTint: cardAttributeTint(position: kp) ?? UIColor(atmos.accent),
                phase: Double((kp &* 2_654_435_761) % 1000) / 1000)
        }

        // MARK: The clock

        /// Design's clock, from `homes-chambers.js`: the first adaptation resolves
        /// over 62 s, holds to 227 s, and the second runs over the 120 s after that.
        static let firstAdaptation: TimeInterval = 62
        static let holdEnds: TimeInterval = 227
        static let secondAdaptation: TimeInterval = 120
        static var secondEnds: TimeInterval { holdEnds + secondAdaptation }   // 347

        /// Where the reduce-motion path poses the room.
        ///
        /// Design's invariant 4 says reduced motion is *"longer and quantized,
        /// never disabled — the mechanism is perceptual adaptation; removing it
        /// removes the piece."* `iOS/FIDELITY.md` says the opposite about loops:
        /// *"the one-shot fades may stay; the loops may not."* They cannot both be
        /// obeyed, so this is a decision rather than an oversight.
        ///
        /// It goes to FIDELITY, because the charter names FIDELITY as standing law
        /// and Design's handoff as the thing FIDELITY governs. A walker with reduce
        /// motion on is given the **outcome** of the adaptation rather than nothing:
        /// the strata thick, the mass lifted, the ground risen, the weight revealed
        /// as the thing that holds. Not the piece removed — the piece arrived at.
        static let settledSceneTime: TimeInterval = 360

        /// The first adaptation, 0→1, smoothstepped — Design's `smooth(t / 62)`.
        static func first(at t: TimeInterval) -> Double { smooth(t / firstAdaptation) }

        /// The second adaptation, 0→1 — Design's `deep(t)`.
        static func second(at t: TimeInterval) -> Double {
            smooth((t - holdEnds) / secondAdaptation)
        }

        static func smooth(_ x: Double) -> Double {
            let t = min(max(x, 0), 1)
            return t * t * (3 - 2 * t)
        }
    }
}

// MARK: - Her physics

extension GarimaSceneKitRoom {

    /// A motion, classified from her tattva and her quality.
    ///
    /// **This is a subset, and says so.** Design's grammar carries fifty of these,
    /// matched by fifty regular expressions over the real tattva vocabulary, and a
    /// port of the whole table is a mechanical afternoon — the patterns and the
    /// displacement functions both already exist in `homes-grammar.js`. The spike
    /// carries the ones that can reach Ring 1's authored four, so that this room
    /// resolving to `settle` is a real classification and not an assumption, and so
    /// that a sister standing next to her demonstrably resolves elsewhere.
    ///
    /// The floor is her `Element`, which the app already computes from her tattva —
    /// never a generic "breathe", because the app knows more than that.
    enum Physics: String, Equatable {
        /// Pṛthvī. A thing that only ever sinks. Garimā's.
        case settle
        /// Vāyu. Laghimā's.
        case lift
        /// Mahat. Mahimā's.
        case widen
        /// Aṇu. Aṇimā's.
        case shrink
        /// Apas.
        case flow
        /// Agni.
        case flare
        /// Ākāśa.
        case open
        /// Light.
        case brighten

        private static let table: [(pattern: String, kind: Physics)] = [
            ("pṛthiv|pṛthv|bhūmi|bhumi|earth|weighted", .settle),
            ("vāyu|vayu|\\bair\\b|lightness", .lift),
            ("mahat|vastness", .widen),
            ("aṇu|anu-|atomic|smallness", .shrink),
            ("apaḥ|\\bjala\\b|water|fluid", .flow),
            ("tejas|agni|\\bfire\\b|fierce", .flare),
            ("ākāśa|akasa|akasha|ether|\\bsky\\b|void", .open),
        ]

        static func classify(tattva: String, quality: String, element: Element) -> Physics {
            let subject = (tattva + " " + quality).lowercased()
            for entry in table {
                if subject.range(of: entry.pattern, options: [.regularExpression]) != nil {
                    return entry.kind
                }
            }
            switch element {
            case .earth: return .settle
            case .air:   return .lift
            case .water: return .flow
            case .fire:  return .flare
            case .ether: return .open
            case .light: return .brighten
            }
        }

        /// Design's `displace`, for the kinds above. Returns a world-space offset.
        /// Garimā's `settle` is `[0, -|sin(0.07 t + φ)| · amp · 1.3, 0]` — it has no
        /// upward term at all, which is the whole of her character in one line.
        func displacement(t: TimeInterval, phase: Double, amplitude: Double) -> SIMD3<Double> {
            let p = phase * 2 * .pi
            func s(_ f: Double) -> Double { sin(t * f + p) }
            func c(_ f: Double) -> Double { cos(t * f + p) }
            func pulse(_ f: Double) -> Double { abs(sin(t * f + p)) }
            switch self {
            case .settle:   return SIMD3(0, -pulse(0.07) * amplitude * 1.3, 0)
            case .lift:     return SIMD3(s(0.12) * amplitude * 0.4, (0.5 + 0.5 * s(0.1)) * amplitude * 1.7, 0)
            case .widen:    return SIMD3(s(0.06) * amplitude * 2.2, 0, c(0.06) * amplitude * 2.2)
            case .shrink:   return SIMD3(s(0.14) * amplitude * 0.2, 0, pulse(0.1) * -amplitude * 1.4)
            case .flow:     return SIMD3(s(0.21) * amplitude, s(0.13) * amplitude * 0.5, 0)
            case .flare:    return SIMD3(s(0.6) * amplitude * 0.4, pulse(0.5) * amplitude * 0.9, 0)
            case .open:     return SIMD3(s(0.05) * amplitude * 1.8, c(0.04) * amplitude * 1.2, s(0.045) * amplitude * 1.8)
            case .brighten: return SIMD3(0, s(0.11) * amplitude * 0.6, 0)
            }
        }
    }
}

// MARK: - The three tables her room is built from

/// The gem as behaviour only, from the handoff's §4.1 table. Diffusion drives
/// shadow softness and how far the glow falls; it never touches hue.
private func gemDiffusion(ring: Int) -> Double {
    switch ring {
    case 1: return 0.20   // topaz
    case 2: return 0.30   // sapphire
    case 3: return 0.45   // coral
    case 4: return 0.15   // diamond
    case 5: return 0.25   // emerald
    case 6: return 0.55   // ruby
    case 7: return 0.95   // pearl — sourceless, no directional light at all
    case 8: return 0.10   // cat's eye
    case 9: return 0.70   // all gems
    default: return 0.30
    }
}

/// Design's zone table, read off her bodily location. Feet 0.94 → crown 0.10.
/// Where she has no location text, her āvaraṇa's own region stands in, which for
/// Ring 1 is the Feet — position-derived, never guessed.
private func bodyAltitude(location: String, ring: Int) -> Double {
    let zones: [(String, Double)] = [
        ("soles|feet|mūlādhāra|muladhara", 0.94),
        ("belly|navel|yoni|abundance", 0.66),
        ("waist", 0.68),
        ("solar plexus", 0.60),
        ("diaphragm", 0.56),
        ("sternum|chest|heart", 0.46),
        ("throat|palate|mouth", 0.34),
        ("behind the eyes|eyes|face", 0.26),
        ("forehead|third eye|between the eyes", 0.20),
        ("crown|above", 0.10),
        ("spine|whole body|whole field|cellular|totality|converge", 0.50),
    ]
    let subject = location.lowercased()
    if !subject.isEmpty {
        for (pattern, value) in zones
        where subject.range(of: pattern, options: [.regularExpression]) != nil {
            return value
        }
    }
    // The āvaraṇa's own region, from Design's worlds table.
    switch ring {
    case 1: return 0.94   // Feet
    case 2: return 0.72   // Pelvis
    case 3: return 0.64   // Navel
    case 4: return 0.46   // Heart
    case 5: return 0.34   // Throat
    case 6: return 0.20   // Forehead
    case 7: return 0.10   // Crown
    case 8: return 0.04   // Above crown
    default: return 0.50  // Totality
    }
}

/// Her card's colour word for her attribute, where it gives one. Garimā's palm is
/// her accent-red. It tints the mark she left and nothing else — never the light.
private func cardAttributeTint(position: Int) -> UIColor? {
    let tints: [Int: UInt32] = [
        1: 0xF2ECD8, 4: 0xB8263C, 7: 0xFF7A3C, 13: 0xFFB45C, 15: 0x6A5F78,
        17: 0xD8D2C4, 18: 0xFFD76A, 29: 0xFF6A7C, 45: 0xFFB0C4, 62: 0xFF8AB0,
        91: 0xFF7A5C, 92: 0xFFD76A, 99: 0xFFF6E2, 100: 0xFF4A5C, 101: 0xFFD76A,
    ]
    guard let hex = tints[position] else { return nil }
    return UIColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                   green: CGFloat((hex >> 8) & 0xFF) / 255,
                   blue: CGFloat(hex & 0xFF) / 255,
                   alpha: 1)
}

// MARK: - The strata

/// The bedded stone the room is made of, as a height field.
///
/// Design's `strataTexture` draws random grey bands into a 32×512 canvas and hands
/// it to three.js as a displacement and a bump map. SceneKit can displace from a
/// texture too, but only through the tessellator, which is a Metal feature the
/// simulator does not carry — so the strata here are **real geometry**, generated
/// from the same idea: bands of varying thickness, each falling away toward its
/// own floor, stacked up a single axis and warped so the bedding is not ruled.
///
/// Being geometry rather than a texture is not a workaround. It is what lets the
/// mass's underside and the floor be the *same* bedding seen from two sides, and
/// it is what lets the reversal lift the ground under the walker's feet.
private struct Strata {

    /// Deterministic per-Śakti, so the room is the same room on every launch and
    /// on every machine — the same hash `Atmosphere` jitters her hue with.
    let seed: Int

    /// The floor's width, so the crater lands where the mark is without a second
    /// number to keep in step.
    static let extent: Double = 46

    /// Bands run across the room. Twenty-three of them, prime, so the bedding never
    /// lines up with the 46-unit floor into a visible repeat — one bed every two
    /// units, which is what makes a bed read as a bed at the near edge.
    private static let bandCount = 23

    /// How tall the bedding stands once it is fully compacted, in world units.
    /// The first pass used 1.0 and the beds were invisible: at 2.4 units of eye
    /// height across a 46-unit floor, a one-unit relief is a scratch. Design's own
    /// displacement runs 0.5 → 2.4 over a normalised map, which is where this comes
    /// from.
    private static let relief: Double = 1.6

    private func random(_ index: Int) -> Double {
        let mixed = (index &+ seed &* 977) &* 2_654_435_761
        return Double((mixed % 1000 + 1000) % 1000) / 1000
    }

    /// The height of the bedding at (u, v), both in 0…1.
    ///
    /// - `thickness` scales the whole relief — this is what the first adaptation
    ///   drives, and it is the floor *thickening*, not the floor moving.
    /// - `plinth` raises a broad dome centred on the palm's mark: what the pressing
    ///   made. Only the second adaptation drives it.
    func height(u: Double, v: Double, thickness: Double, plinth: Double) -> Double {
        // A low warp, so the beds bend the way real bedding bends.
        let warp = sin(u * 3.1 + Double(seed % 7)) * 0.045 + cos(u * 7.7) * 0.018
        let s = (v + warp) * Double(Self.bandCount)
        let index = Int(s.rounded(.down))
        let within = s - Double(index)

        let amplitude = 0.35 + random(index) * 0.65
        // Each bed falls away toward its own floor and then steps down hard at the
        // seam. Compaction sharpens the seam rather than deepening the bed, which is
        // what being pressed does to stone.
        let compaction = min(max(thickness, 0), 1)
        let ramp = pow(1 - within, 1.35 + compaction * 1.9)
        let step = Double(index % 3) * 0.06 - 0.06

        var y = (ramp * amplitude + step) * thickness * Self.relief

        // The bed immediately under the mark is crushed right through — this is
        // where the weight actually landed, and the beds around it have to show it
        // or the mark reads as a lozenge lying on the floor rather than a hollow
        // pressed into it.
        let dx = (u - 0.5) * Self.extent
        let dz = (v - 0.5) * Self.extent - Double(RoomScene.markPosition.z)
        let r = (dx * dx + dz * dz).squareRoot()
        y -= exp(-(r * r) / 70) * 0.62 * thickness * Self.relief

        // …and then, past the second adaptation, it is what lifts you. Two terms:
        // a mound under the mark, and a broad rise under the whole floor. The mound
        // has to be narrower than the rise or the reversal reads as the room getting
        // vaguely higher instead of as a thing you are standing on.
        y += exp(-(r * r) / 90) * 2.6 * plinth
        y += exp(-(r * r) / 900) * 2.0 * plinth

        return y
    }

    /// The bedding as a walker's foot finds it rather than as a vertex does.
    ///
    /// The beds are *stepped* — that is what a bed is, and the floor must keep every
    /// one of them. But the camera samples this field to know how high the ground
    /// under it is, and a single sample steps by a bed's whole amplitude the instant
    /// it crosses a seam: `testTheRoomPressesAndThenReversesItsOwnPremise` caught the
    /// eye jumping 1.5 units between one second and the next, at t = 314, as the
    /// reversal slid the camera back across a boundary. Design's invariant 3 is *no
    /// cuts, only travel*, and a camera that pops over a seam is a cut.
    ///
    /// So the eye reads a short running mean across its own stride. The ground keeps
    /// its steps; the walker does not trip on them.
    func footing(u: Double, v: Double, thickness: Double, plinth: Double) -> Double {
        let span = 2.6 / Self.extent      // ±2.6 world units, a little over a bed
        let samples = 9
        var total = 0.0
        for index in 0..<samples {
            let offset = (Double(index) / Double(samples - 1) - 0.5) * 2 * span
            total += height(u: u, v: min(1, max(0, v + offset)),
                            thickness: thickness, plinth: plinth)
        }
        return total / Double(samples)
    }

    /// A grid mesh of the bedding at one setting, for use as a morph target.
    func geometry(resolution n: Int,
                  extent: Double,
                  thickness: Double,
                  plinth: Double,
                  facingDown: Bool = false) -> SCNGeometry {
        var vertices = [SCNVector3]()
        var normals = [SCNVector3]()
        var texcoords = [CGPoint]()
        vertices.reserveCapacity(n * n)
        normals.reserveCapacity(n * n)
        texcoords.reserveCapacity(n * n)

        let span = 1.0 / Double(n - 1)
        let worldStep = extent * span
        let flip: Double = facingDown ? -1 : 1

        for j in 0..<n {
            for i in 0..<n {
                let u = Double(i) * span
                let v = Double(j) * span
                let y = height(u: u, v: v, thickness: thickness, plinth: plinth) * flip
                vertices.append(SCNVector3(Float((u - 0.5) * extent),
                                           Float(y),
                                           Float((v - 0.5) * extent)))

                let hx = height(u: min(1, u + span), v: v, thickness: thickness, plinth: plinth)
                    - height(u: max(0, u - span), v: v, thickness: thickness, plinth: plinth)
                let hz = height(u: u, v: min(1, v + span), thickness: thickness, plinth: plinth)
                    - height(u: u, v: max(0, v - span), thickness: thickness, plinth: plinth)
                var nx = -hx * flip
                var ny = 2 * worldStep * flip
                var nz = -hz * flip
                let len = (nx * nx + ny * ny + nz * nz).squareRoot()
                if len > 0 { nx /= len; ny /= len; nz /= len }
                normals.append(SCNVector3(Float(nx), Float(ny), Float(nz)))
                texcoords.append(CGPoint(x: u, y: v))
            }
        }

        var indices = [Int32]()
        indices.reserveCapacity((n - 1) * (n - 1) * 6)
        for j in 0..<(n - 1) {
            for i in 0..<(n - 1) {
                let a = Int32(j * n + i)
                let b = a + 1
                let c = a + Int32(n)
                let d = c + 1
                if facingDown {
                    indices.append(contentsOf: [a, b, c, b, d, c])
                } else {
                    indices.append(contentsOf: [a, c, b, b, c, d])
                }
            }
        }

        let geometry = SCNGeometry(
            sources: [SCNGeometrySource(vertices: vertices),
                      SCNGeometrySource(normals: normals),
                      SCNGeometrySource(textureCoordinates: texcoords)],
            elements: [SCNGeometryElement(indices: indices, primitiveType: .triangles)])
        return geometry
    }
}

// MARK: - The scene

/// Every node the room has, kept as values so the driver can pose them without
/// searching the graph by name each frame.
private final class RoomScene {

    let scene = SCNScene()
    let cameraNode = SCNNode()
    let groundNode = SCNNode()
    let massNode = SCNNode()
    let massUndersideNode = SCNNode()
    let rimNode = SCNNode()
    let markNode = SCNNode()
    let emberLightNode = SCNNode()
    let rakingLightNode = SCNNode()
    let dustNode = SCNNode()
    let wallNodes: [SCNNode]

    let ingredients: GarimaSceneKitRoom.Ingredients
    private let dustMaterial: SCNMaterial

    /// The world point the palm's mark sits at. The light pass projects it.
    /// At your feet, not across the room. She is felt at the soles: put the mark
    /// nine units out and the bedding it crushed stands between you and it, and the
    /// only thing left on screen is its glow.
    static let markPosition = SCNVector3(0, -5.05, -6)
    /// The mark's place along the bedding axis, in the strata's own 0…1 coordinates.
    static var markV: Double { 0.5 + Double(markPosition.z) / extent }
    static let floorY: Double = -5.2
    static let extent: Double = 46
    /// Vertices per side of the strata. 96 × 96 is 9,216 vertices and 18,050
    /// triangles — enough that a bed reads as a bed at the near edge of the floor,
    /// and small enough that three of them (base plus two morph targets) is a
    /// megabyte rather than ten.
    static let strataResolution = 96
    static let undersideResolution = 56

    init(ingredients: GarimaSceneKitRoom.Ingredients) {
        self.ingredients = ingredients

        let ink = ingredients.ink
        let accent = ingredients.accent
        let strata = Strata(seed: ingredients.khadgamalaPosition)

        // ── the ground: bedded stone that thickens under you ────────────────
        let groundBase = strata.geometry(resolution: Self.strataResolution,
                                         extent: Self.extent,
                                         thickness: 0.10, plinth: 0)
        let groundPressed = strata.geometry(resolution: Self.strataResolution,
                                            extent: Self.extent,
                                            thickness: 1.0, plinth: 0)
        let groundRisen = strata.geometry(resolution: Self.strataResolution,
                                          extent: Self.extent,
                                          thickness: 1.0, plinth: 1.0)
        let groundMaterial = Self.stone(ink, roughnessLike: 0.95)
        groundMaterial.name = "strata"
        groundBase.materials = [groundMaterial]
        groundNode.geometry = groundBase
        groundNode.name = "thickening-ground"
        groundNode.position = SCNVector3(0, Float(Self.floorY), 0)
        groundNode.castsShadow = false
        let groundMorpher = SCNMorpher()
        groundMorpher.targets = [groundPressed, groundRisen]
        groundMorpher.calculationMode = .additive
        groundNode.morpher = groundMorpher

        // ── the mass: a slab that comes down the whole time you are here ────
        let massBox = SCNBox(width: CGFloat(Self.extent), height: 4.4,
                             length: CGFloat(Self.extent), chamferRadius: 0)
        let massMaterial = Self.stone(ink, roughnessLike: 0.98)
        massMaterial.name = "descending-mass"
        massBox.materials = [massMaterial]
        massNode.geometry = massBox
        massNode.name = "ceiling"
        massNode.castsShadow = true
        massNode.position = SCNVector3(0, 11, 0)

        // Its underside is the same bedding seen from beneath — the mass and the
        // floor are one stone, which is the reversal's whole argument.
        let underBase = strata.geometry(resolution: Self.undersideResolution,
                                        extent: Self.extent,
                                        thickness: 0.12, plinth: 0, facingDown: true)
        let underPressed = strata.geometry(resolution: Self.undersideResolution,
                                           extent: Self.extent,
                                           thickness: 1.0, plinth: 0, facingDown: true)
        let underMaterial = Self.stone(ink, roughnessLike: 0.97)
        underMaterial.name = "mass-relief"
        underBase.materials = [underMaterial]
        massUndersideNode.geometry = underBase
        massUndersideNode.name = "mass-underside"
        massUndersideNode.castsShadow = false
        let underMorpher = SCNMorpher()
        underMorpher.targets = [underPressed]
        underMorpher.calculationMode = .additive
        massUndersideNode.morpher = underMorpher

        // The lit seam where the mass meets the walls — the one edge you can always
        // find, and the thing that tells you how far down the mass has come.
        //
        // Three bars, not a plate. The first pass used Design's own 46.4 × 0.16 ×
        // 46.4 box, which in a three.js room you never see the underside of; here the
        // eye is under it, and an unlit-model box that size renders as a flat sheet of
        // her accent across the whole top of the frame.
        let rimMaterial = SCNMaterial()
        rimMaterial.lightingModel = .constant
        rimMaterial.diffuse.contents = Self.mix(.black, accent, 0.55)
        rimMaterial.emission.contents = Self.mix(.black, accent, 0.55)
        rimMaterial.name = "mass-rim"
        rimNode.name = "mass-rim"
        rimNode.castsShadow = false
        for (index, bar) in [(w: 30.4, l: 0.5, x: 0.0, z: -19.8),
                             (w: 0.5, l: 40.0, x: -14.9, z: 0.0),
                             (w: 0.5, l: 40.0, x: 14.9, z: 0.0)].enumerated() {
            let box = SCNBox(width: CGFloat(bar.w), height: 0.14,
                             length: CGFloat(bar.l), chamferRadius: 0)
            box.materials = [rimMaterial]
            let node = SCNNode(geometry: box)
            node.name = "mass-rim-\(index)"
            node.position = SCNVector3(Float(bar.x), 0, Float(bar.z))
            node.castsShadow = false
            rimNode.addChildNode(node)
        }

        // ── the walls ───────────────────────────────────────────────────────
        var walls: [SCNNode] = []
        let wallMaterial = Self.stone(ink, roughnessLike: 0.94)
        wallMaterial.name = "pressed-stone"
        wallMaterial.isDoubleSided = true
        for (index, spec) in [(x: -1.0, z: 0.0), (x: 1.0, z: 0.0), (x: 0.0, z: -1.0)].enumerated() {
            let plane = SCNPlane(width: CGFloat(Self.extent), height: 22)
            plane.materials = [wallMaterial]
            let node = SCNNode(geometry: plane)
            node.name = "wall-\(index)"
            node.castsShadow = false
            if spec.x != 0 {
                node.position = SCNVector3(Float(spec.x * 15), 0, 0)
                node.eulerAngles = SCNVector3(0, Float(-spec.x * .pi / 2), 0)
            } else {
                node.position = SCNVector3(0, 0, Float(spec.z * 20))
            }
            walls.append(node)
        }
        wallNodes = walls

        // ── the mark: one palm-press, set into the ground, still glowing ────
        //
        // Not a palm. The *mark a palm left* — a shape that performed an action
        // and stopped. Her card's colour word tints it; her āvaraṇa's light does
        // not, and it never tints her āvaraṇa's light back.
        // Flat. It is a hollow with a floor, not a plug sitting in one: a shallow
        // disc that the bedding closes over, which is what a palm leaves behind.
        let mark = SCNCone(topRadius: 1.15, bottomRadius: 1.35, height: 0.30)
        let markMaterial = SCNMaterial()
        markMaterial.lightingModel = .blinn
        // Dark stone that *holds* her colour rather than a disc painted in it. The
        // first pass handed the same full-strength red to both diffuse and emission
        // and the mark came out as a flat slab filling the bottom of the frame —
        // a thing lying on the floor instead of a hollow pressed into it.
        markMaterial.diffuse.contents = Self.mix(ink, ingredients.attributeTint, 0.24)
        markMaterial.emission.contents = Self.mix(.black, ingredients.attributeTint, 0.5)
        markMaterial.emission.intensity = 0.26
        markMaterial.name = "palm-press"
        mark.materials = [markMaterial]
        markNode.geometry = mark
        markNode.name = "press"
        markNode.position = Self.markPosition
        markNode.castsShadow = false   // it is a hollow, and a hollow throws nothing

        // ── the light ───────────────────────────────────────────────────────
        // Raking, hard, from the side: ring 1 is topaz at 0.20 diffusion, so the
        // shadows it throws are nearly sharp. A pearl room at 0.95 would get no
        // directional light at all; that difference is the gem's whole job.
        let raking = SCNLight()
        raking.type = .directional
        raking.color = accent
        raking.intensity = 2_600
        raking.castsShadow = true
        raking.shadowMode = .forward
        raking.shadowRadius = CGFloat(0.5 + 6 * ingredients.diffusion)
        raking.shadowSampleCount = 8
        raking.shadowMapSize = CGSize(width: 1024, height: 1024)
        raking.shadowColor = ink.withAlphaComponent(0.78)
        raking.orthographicScale = 26
        raking.zNear = 0.5
        raking.zFar = 70
        rakingLightNode.light = raking
        rakingLightNode.name = "raking"
        rakingLightNode.position = SCNVector3(14, 9, 6)
        rakingLightNode.look(at: SCNVector3(0, Float(Self.floorY), -6))

        let ember = SCNLight()
        ember.type = .omni
        ember.color = accent
        ember.intensity = 3_200
        ember.attenuationEndDistance = 34
        ember.attenuationFalloffExponent = 2
        emberLightNode.light = ember
        emberLightNode.name = "ember"
        emberLightNode.position = SCNVector3(0, -4.2, -7)

        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = accent
        ambientLight.intensity = 520
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        ambientNode.name = "ambient"

        // ── dust, suspended in the raking light ─────────────────────────────
        let (dustGeometry, dustMat) = Self.dust(count: 460,
                                                accent: accent,
                                                phase: ingredients.phase)
        dustMaterial = dustMat
        dustNode.geometry = dustGeometry
        dustNode.name = "motes"
        dustNode.position = SCNVector3(0, -1, -4)
        dustNode.castsShadow = false

        // ── the camera: her eye height is her altitude ──────────────────────
        let camera = SCNCamera()
        camera.fieldOfView = 62
        camera.zNear = 0.1
        camera.zFar = 140
        camera.wantsHDR = false
        cameraNode.camera = camera
        cameraNode.name = "eye"
        cameraNode.position = SCNVector3(0, Float(Self.eyeHeight(altitude: ingredients.altitude)), 8)

        // ── assembly ────────────────────────────────────────────────────────
        scene.background.contents = ingredients.groundDeep
        scene.fogColor = ingredients.ground
        scene.fogStartDistance = 12
        scene.fogEndDistance = 58
        scene.fogDensityExponent = 2

        let root = scene.rootNode
        root.addChildNode(groundNode)
        root.addChildNode(massNode)
        root.addChildNode(massUndersideNode)
        root.addChildNode(rimNode)
        walls.forEach(root.addChildNode)
        root.addChildNode(markNode)
        root.addChildNode(rakingLightNode)
        root.addChildNode(emberLightNode)
        root.addChildNode(ambientNode)
        root.addChildNode(dustNode)
        root.addChildNode(cameraNode)
    }

    /// Her altitude decides where the eye sits.
    ///
    /// Not literally — a first draft put the eye at `(1 - altitude) · 8.4` above the
    /// floor, which for her 0.94 is 1.4 units, and 1.4 units above the floor is
    /// lying on it. `testTheLightPassFollowsTheMarkDownAndThenUp` caught it: with
    /// the eye that low the mark she left was almost at eye level, and the moment
    /// the camera tipped toward the ground the mark climbed into the *upper* half of
    /// the frame — the opposite of a Śakti felt at the soles.
    ///
    /// So: a standing eye, 3.2 above the floor, which her altitude then modulates by
    /// 3.6. Garimā stands at 3.4; a crown Śakti at 0.10 would stand at 6.4, up near
    /// the mass. The altitude still decides, and the room still reads as hers, but
    /// the walker is on their feet and can see over their own bedding.
    ///
    /// This is the *standing* height only. Where the walker actually is comes from
    /// `Pose`, which adds the height of the ground underneath them — so when the
    /// plinth rises at the reversal, it carries them.
    static func eyeHeight(altitude: Double) -> Double {
        floorY + 3.2 + (1 - altitude) * 3.6
    }

    /// Blend two colours in plain RGB. Used only for materials — never for a hue,
    /// which belongs to `Atmosphere` alone.
    static func mix(_ a: UIColor, _ b: UIColor, _ t: CGFloat) -> UIColor {
        var ar: CGFloat = 0, ag: CGFloat = 0, ab: CGFloat = 0, aa: CGFloat = 0
        var br: CGFloat = 0, bg: CGFloat = 0, bb: CGFloat = 0, ba: CGFloat = 0
        a.getRed(&ar, green: &ag, blue: &ab, alpha: &aa)
        b.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
        return UIColor(red: ar + (br - ar) * t, green: ag + (bg - ag) * t,
                       blue: ab + (bb - ab) * t, alpha: 1)
    }

    private static func stone(_ ink: UIColor, roughnessLike: Double) -> SCNMaterial {
        let m = SCNMaterial()
        m.lightingModel = .blinn
        m.diffuse.contents = ink
        // Stone that rough has almost no highlight; what it has is the seam catching
        // the rake, which is the whole reason this room has a directional light.
        m.specular.contents = UIColor(white: CGFloat(max(0, 1 - roughnessLike)) * 0.5, alpha: 1)
        m.shininess = 0.04
        m.isLitPerPixel = true
        return m
    }

    /// Motes, as real points rather than a texture. The screen-space radius is
    /// clamped at both ends: Design's invariant 7 — additive particles near the eye
    /// stack to white, so the point size may never grow without bound.
    private static func dust(count: Int,
                             accent: UIColor,
                             phase: Double) -> (SCNGeometry, SCNMaterial) {
        var points = [SCNVector3]()
        points.reserveCapacity(count)
        var state = UInt64(bitPattern: Int64(phase * 1_000_000)) | 1
        func next() -> Double {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            return Double((state >> 33) % 100_000) / 100_000
        }
        for _ in 0..<count {
            points.append(SCNVector3(Float((next() - 0.5) * 30),
                                     Float((next() - 0.5) * 13),
                                     Float((next() - 0.5) * 30)))
        }
        let source = SCNGeometrySource(vertices: points)
        let element = SCNGeometryElement(indices: (0..<Int32(count)).map { $0 },
                                         primitiveType: .point)
        element.pointSize = 2.6
        element.minimumPointScreenSpaceRadius = 0.6
        element.maximumPointScreenSpaceRadius = 3.0
        let geometry = SCNGeometry(sources: [source], elements: [element])

        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = accent
        material.blendMode = .add
        material.writesToDepthBuffer = false
        material.transparency = 0.42
        material.name = "motes"
        // Her physics, in the air: `settle` has no upward term, so the dust only
        // ever comes down. Run on the GPU because there are 460 of them and the
        // CPU has strata to think about.
        material.shaderModifiers = [
            .geometry: """
            #pragma arguments
            float uTime;
            float uFall;
            float uPhase;
            #pragma body
            float s = _geometry.position.x * 12.9898 + _geometry.position.z * 78.233;
            float ph = fract(sin(s) * 43758.5453) * 6.2831853 + uPhase;
            _geometry.position.y += sin(uTime * 0.14 + ph) * 0.5 - uFall;
            _geometry.position.x += cos(uTime * 0.09 + ph) * 0.28;
            """
        ]
        material.setValue(NSNumber(value: 0.0), forKey: "uTime")
        material.setValue(NSNumber(value: 0.0), forKey: "uFall")
        material.setValue(NSNumber(value: Float(phase * 6.283)), forKey: "uPhase")
        return (geometry, material)
    }

    // MARK: - Posing

    /// Put the whole room at one instant. Pure in everything but its writes: the
    /// same scene time always produces the same room, which is what lets the
    /// harness jump to 347 s and the reduce-motion path render exactly once.
    func pose(at sceneTime: TimeInterval) {
        let pose = GarimaSceneKitRoom.Pose(sceneTime: sceneTime, ingredients: ingredients)

        // The mass comes down through the first adaptation, and lifts away through
        // the second — Design's `11 - k * 7.4 + b * 5.2`.
        massNode.position.y = Float(pose.massY)
        massUndersideNode.position.y = Float(pose.massY - 2.21)
        rimNode.position.y = Float(pose.massY - 2.2)
        massUndersideNode.morpher?.setWeight(CGFloat(pose.thickening), forTargetAt: 0)

        // The floor thickens into strata; past the second adaptation it rises into
        // the thing that has been holding you.
        groundNode.morpher?.setWeight(CGFloat(pose.thickening), forTargetAt: 0)
        groundNode.morpher?.setWeight(CGFloat(pose.plinth), forTargetAt: 1)
        // Her physics, on the room itself: `settle` only ever sinks.
        groundNode.position.y = Float(RoomScene.floorY + pose.settleOffset)

        // The mark brightens and widens as the room reverses.
        markNode.scale = SCNVector3(Float(pose.markScale), Float(pose.markScale), Float(pose.markScale))
        markNode.position.y = Float(pose.markY)
        if let material = markNode.geometry?.firstMaterial {
            // Scaled, because `markEmission` is Design's own 1.4 → 4.8 written for
            // three.js, where it multiplies a far dimmer base. Handed straight to a
            // SceneKit emission it bleaches her red to pink.
            material.emission.intensity = CGFloat(pose.markEmission) * 0.2
        }
        emberLightNode.light?.intensity = CGFloat(pose.emberIntensity)
        emberLightNode.position.y = Float(pose.markY + 0.8)

        // The rake softens as the mass arrives, then swings low and becomes the
        // light coming up out of the ground.
        rakingLightNode.light?.intensity = CGFloat(pose.rakingIntensity)
        rakingLightNode.position = SCNVector3(Float(pose.rakingPosition.x),
                                             Float(pose.rakingPosition.y),
                                             Float(pose.rakingPosition.z))
        rakingLightNode.look(at: SCNVector3(0, Float(RoomScene.floorY), -6))

        rimNode.childNodes.first?.geometry?.firstMaterial?.transparency = CGFloat(pose.rimOpacity)

        // You are carried up by what pressed you.
        cameraNode.position = SCNVector3(0, Float(pose.eyeY), Float(pose.eyeZ))
        cameraNode.eulerAngles = SCNVector3(Float(pose.eyePitch), 0, 0)

        dustMaterial.setValue(NSNumber(value: Float(sceneTime)), forKey: "uTime")
        dustMaterial.setValue(NSNumber(value: Float(pose.dustFall)), forKey: "uFall")
    }
}

// MARK: - The pose, as a value

extension GarimaSceneKitRoom {

    /// The whole room at one instant, as numbers. Pure, so it can be asserted
    /// without a renderer: the reversal is a property of this struct, not of a
    /// screenshot.
    struct Pose: Equatable {

        let sceneTime: TimeInterval
        /// The first adaptation, 0→1 over 62 s.
        let thickening: Double
        /// The second adaptation, 0→1 over the 120 s after 227 s.
        let plinth: Double

        let massY: Double
        let markY: Double
        let markScale: Double
        let markEmission: Double
        let emberIntensity: Double
        let rakingIntensity: Double
        let rakingPosition: SIMD3<Double>
        let rimOpacity: Double
        let eyeY: Double
        let eyeZ: Double
        let eyePitch: Double
        let settleOffset: Double
        let dustFall: Double

        init(sceneTime: TimeInterval, ingredients: Ingredients) {
            let k = Ingredients.first(at: sceneTime)
            let b = Ingredients.second(at: sceneTime)
            self.sceneTime = sceneTime
            self.thickening = k
            self.plinth = b

            // Design's own numbers, from `chamberPress.update`.
            self.massY = 11 - k * 7.4 + b * 5.2
            // 1 → 1.9. Design's own 1 → 2.8 is written for a camera further back;
            // at this eye height and this field of view, 2.8 puts the disc wider than
            // the frame and it stops reading as a mark at all.
            self.markScale = 1 + b * 0.9
            self.markEmission = 1.4 + b * 3.4
            self.emberIntensity = 3_200 + sin(sceneTime * 0.5) * 320
            self.rimOpacity = (0.26 + k * 0.30) * (1 - b * 0.55)

            // The rake dims as the mass arrives (Design: 3.6 → 1.6), then hands its
            // job to the ground: past the second adaptation it is below the floor,
            // and what lights the room is what you are standing on.
            self.rakingIntensity = (2_600 - k * 1_300) * (1 - b * 0.72)
            let swing = (1 - b)
            self.rakingPosition = SIMD3(14 * swing + 2 * b,
                                        9 * swing - 7.4 * b,
                                        6 * swing - 2 * b)

            // Her physics, applied to the room and to the dust. `settle`'s vertical
            // term is the only one either of them uses, because it is the only one
            // she has.
            let motion = ingredients.physics.displacement(t: sceneTime,
                                                          phase: ingredients.phase,
                                                          amplitude: 0.18)
            self.settleOffset = motion.y
            self.dustFall = max(0, -motion.y) * 3 + sceneTime * 0.018 * (1 - b)

            // The mark is *in* the ground, so it is placed by asking the ground how
            // high it is at that point rather than by a hand-tuned offset. A first
            // pass guessed the offset and the mark floated half a unit above the
            // crater it had crushed — a lozenge lying on a terrace. Now it sinks as
            // the bed is crushed and rides up on the plinth's crest at the reversal,
            // because it is the same arithmetic in both cases.
            let bedding = Strata(seed: ingredients.khadgamalaPosition)
                .height(u: 0.5, v: RoomScene.markV, thickness: k, plinth: b)
            self.markY = RoomScene.floorY + bedding + 0.10 + motion.y

            // The eye. Back, as well as up. At the reversal you are standing on what the
            // pressing built, and the only way to *see* that you are standing on it
            // is to be far enough off it to take it in. Closing the distance instead
            // puts the mark under your chin and off the bottom of the frame.
            let eyeZ = 3.4 - k * 0.8 + b * 3.0
            self.eyeZ = eyeZ
            // The eye stands on the ground, and the ground is what moves. Rather
            // than lifting the camera by a number chosen to look right, ask the
            // bedding how high it is *under the walker* and stand on that. The
            // reversal then lifts you by exactly as much as the plinth built, which
            // is the whole claim the room is making.
            let bedUnderEye = Strata(seed: ingredients.khadgamalaPosition)
                .footing(u: 0.5,
                         v: 0.5 + eyeZ / RoomScene.extent,
                         thickness: k, plinth: b)
            let stand = RoomScene.eyeHeight(altitude: ingredients.altitude) - RoomScene.floorY
            self.eyeY = RoomScene.floorY + stand + bedUnderEye + motion.y
            // Tipped a little toward the floor from the first frame, because her
            // gravity is at the soles; tipped further as the mass arrives; and then
            // opened again as the plinth carries you up. The whole range is small on
            // purpose — the descent is told by the mass filling the top of the frame,
            // not by the camera swinging, and a hard pitch takes her mark off the
            // floor and puts it in the sky.
            self.eyePitch = -0.05 - 0.07 * k + 0.07 * b
        }
    }
}

// MARK: - The SceneKit layer

private struct SceneLayer: UIViewRepresentable {

    let ingredients: GarimaSceneKitRoom.Ingredients
    let clock: SpikeMetrics.Clock
    let reduceMotion: Bool

    func makeCoordinator() -> Driver {
        Driver(ingredients: ingredients, clock: clock, reduceMotion: reduceMotion)
    }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = context.coordinator.room.scene
        view.pointOfView = context.coordinator.room.cameraNode
        view.backgroundColor = ingredients.groundDeep
        view.isOpaque = true
        view.antialiasingMode = .multisampling2X
        view.preferredFramesPerSecond = 60
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
        view.delegate = context.coordinator
        context.coordinator.attach(to: view)
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.setReduceMotion(reduceMotion, on: view)
    }

    static func dismantleUIView(_ view: SCNView, coordinator: Driver) {
        coordinator.detach(from: view)
    }
}

/// Poses the room. `SCNSceneRendererDelegate` runs on SceneKit's own thread, which
/// is where posing belongs — it is the only place a frame can be prepared without
/// racing the frame being drawn.
private final class Driver: NSObject, SCNSceneRendererDelegate {

    let room: RoomScene
    private let clock: SpikeMetrics.Clock
    private var reduceMotion: Bool

    /// When the first frame actually reached the screen, as a reference date. The
    /// room's own cold open: view built → first frame presented.
    private(set) var firstFrameAt: TimeInterval?
    let builtAt: TimeInterval

    init(ingredients: GarimaSceneKitRoom.Ingredients,
         clock: SpikeMetrics.Clock,
         reduceMotion: Bool) {
        let started = CACurrentMediaTime()
        self.room = RoomScene(ingredients: ingredients)
        self.clock = clock
        self.reduceMotion = reduceMotion
        self.builtAt = started
        super.init()
    }

    func attach(to view: SCNView) {
        setReduceMotion(reduceMotion, on: view)
    }

    func detach(from view: SCNView) {
        view.delegate = nil
        view.isPlaying = false
        view.rendersContinuously = false
    }

    /// The reduce-motion path, and the whole reason it is real.
    ///
    /// It does not slow the animation down and it does not shorten it. It **stops
    /// the render loop**: no `CADisplayLink`, no `TimelineView`, no continuous
    /// rendering, no per-frame work of any kind. The room is posed once at the
    /// settled state and drawn once, and then the GPU is idle until something
    /// external asks for another frame. That is the difference between a
    /// reduce-motion path and a slow-motion path, and it is checkable: with this on,
    /// the frame sampler records no frames at all.
    func setReduceMotion(_ on: Bool, on view: SCNView) {
        reduceMotion = on
        if on {
            view.isPlaying = false
            view.rendersContinuously = false
            view.scene?.isPaused = true
            room.pose(at: GarimaSceneKitRoom.Ingredients.settledSceneTime)
            view.setNeedsDisplay()
        } else {
            view.scene?.isPaused = false
            view.isPlaying = true
            view.rendersContinuously = true
            room.pose(at: clock.sceneTime())
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !reduceMotion else { return }
        room.pose(at: clock.sceneTime())
    }

    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard firstFrameAt == nil else { return }
        let now = CACurrentMediaTime()
        firstFrameAt = now
        GarimaSceneKitRoom.ColdOpen.shared.milliseconds = (now - builtAt) * 1000
    }
}

// MARK: - The light pass

/// The SwiftUI Metal shader that carries the light in the air.
///
/// Everything on the stone is SceneKit's: the rake's real shading, the real
/// shadow the mass throws across the bedding, the ember's real falloff. What this
/// layer adds is the part that is not on any surface — the shafts in the dust, the
/// bloom around the mark, and the gradient that says the weight is at the feet.
/// Composited with `.screen`, so it can only ever add light and can never drive a
/// pixel past white.
private struct LightPassLayer: View {

    let ingredients: GarimaSceneKitRoom.Ingredients
    let clock: SpikeMetrics.Clock
    let reduceMotion: Bool
    let size: CGSize

    var body: some View {
        Group {
            if reduceMotion {
                // No timeline, no animation: one evaluation at the settled state.
                pass(at: GarimaSceneKitRoom.Ingredients.settledSceneTime)
            } else {
                TimelineView(.animation) { timeline in
                    pass(at: clock.sceneTime(now: timeline.date.timeIntervalSinceReferenceDate))
                }
            }
        }
        .blendMode(.screen)
    }

    private func pass(at sceneTime: TimeInterval) -> some View {
        let pose = GarimaSceneKitRoom.Pose(sceneTime: sceneTime, ingredients: ingredients)
        let ember = GarimaSceneKitRoom.emberScreenPoint(pose: pose, size: size)
        let rake = GarimaSceneKitRoom.rakeDirection(pose: pose)
        return Rectangle()
            .fill(.white)
            .colorEffect(
                ShaderLibrary.garimaLightPass(
                    .float2(size.width, size.height),
                    .float2(ember.x, ember.y),
                    .float2(rake.x, rake.y),
                    .float4(Float(pose.thickening),
                            Float(pose.plinth),
                            Float(ingredients.altitude),
                            Float(ingredients.phase)),
                    .float4(Float(ingredients.diffusion),
                            Float(GarimaSceneKitRoom.emberRadius(size: size)),
                            0, 0),
                    .color(ingredients.atmosphere.accent),
                    .color(ingredients.atmosphere.accentBright)))
    }

}

// MARK: - Where the light falls, as arithmetic

extension GarimaSceneKitRoom {

    /// The ember's radius at the room's opening, in points — a fraction of the
    /// short edge, so it is the same size on a small phone and a large one.
    static func emberRadius(size: CGSize) -> CGFloat {
        max(18, min(size.width, size.height) * 0.085)
    }

    /// Where the mark lands on screen.
    ///
    /// Projected here rather than asked of the `SCNView`, deliberately: the camera
    /// track is a pure function of the pose, so the light pass can be evaluated for
    /// any scene time without a renderer in the room — which is what lets the tests
    /// assert it and the harness drive it.
    static func emberScreenPoint(pose: Pose, size: CGSize) -> CGPoint {
        guard size.width > 0, size.height > 0 else { return .zero }
        // Into camera space: translate, then pitch.
        let dx = 0.0
        // `pose.markY`, not the mark's rest height: past the second adaptation the
        // plinth carries the mark up 2.3 units with it, and a projection off the
        // rest height put the bloom below the bottom of the frame while the ember it
        // is supposed to be blooming from was in plain sight.
        let dy = pose.markY - pose.eyeY
        let dz = Double(RoomScene.markPosition.z) - pose.eyeZ
        let c = cos(-pose.eyePitch), s = sin(-pose.eyePitch)
        let y = dy * c - dz * s
        let z = dy * s + dz * c
        guard z < -0.05 else { return CGPoint(x: size.width / 2, y: size.height) }
        // SceneKit's `fieldOfView` is the larger of the two axes; in portrait that
        // is the vertical one.
        let fov = 62.0 * .pi / 180
        let focal = 1 / tan(fov / 2)
        let ndcX = (dx * focal / -z) / max(0.0001, size.width / size.height)
        let ndcY = y * focal / -z
        return CGPoint(x: (ndcX * 0.5 + 0.5) * size.width,
                       y: (0.5 - ndcY * 0.5) * size.height)
    }

    /// The direction the rake travels across the frame, from the light's own
    /// position. It swings as the light swings, so the shafts and the shadows
    /// always agree about where the light is.
    static func rakeDirection(pose: Pose) -> CGPoint {
        // Into the frame's own axes: screen x runs with world x, and screen y runs
        // *against* world y. Getting that second sign wrong mirrors the wash onto
        // the side the light is not on, and the shafts then contradict the shadows
        // the SceneKit light is actually throwing.
        let x = pose.rakingPosition.x
        let y = -pose.rakingPosition.y
        let length = max(0.0001, (x * x + y * y).squareRoot())
        return CGPoint(x: x / length, y: y / length)
    }
}

// MARK: - The census

extension GarimaSceneKitRoom {

    /// A per-frame draw census for a SceneKit room.
    ///
    /// **Unlike `MandalaDrawCensus`, this is not a model.** It walks the live scene
    /// graph and counts what is actually in it, so it cannot drift from the room it
    /// is counting. What it counts is the number of *draws SceneKit must issue*:
    /// one per geometry element on each visible node in the colour pass, plus one
    /// per shadow-casting element for each shadow-casting light, plus the single
    /// full-screen draw the SwiftUI light pass costs.
    ///
    /// **It is not comparable, number for number, with the canvas baseline.** The
    /// G5 figures (263 at tier 0, 80 at the deep-zoom bloom) count `GraphicsContext`
    /// primitives — a gradient fill and a one-pixel line are one each. A SceneKit
    /// draw submits a whole indexed mesh. Twelve draws here move far more geometry
    /// than 263 canvas fills do, and 263 canvas fills touch far more of the screen.
    /// Both numbers are reported, with the triangle count beside them, because the
    /// only honest comparison is the frame time and the CPU per frame.
    struct Census: Equatable {
        var colourPassDraws = 0
        var shadowPassDraws = 0
        var lightPassDraws = 0
        var triangles = 0
        var points = 0
        var shadowCastingLights = 0
        var visibleNodes = 0

        var total: Int { colourPassDraws + shadowPassDraws + lightPassDraws }

        var breakdown: String {
            "total \(total) = colour \(colourPassDraws) · shadow \(shadowPassDraws)"
                + " · light-pass \(lightPassDraws)"
                + " [nodes \(visibleNodes), triangles \(triangles), points \(points),"
                + " shadow-casting lights \(shadowCastingLights)]"
        }
    }

    /// Count a scene as it stands. Called off the render loop, after a window
    /// closes — never inside the measurement it is counting.
    static func census(of scene: SCNScene) -> Census {
        var out = Census()
        out.lightPassDraws = 1   // the SwiftUI `.colorEffect` full-screen pass

        var shadowLights = 0
        scene.rootNode.enumerateHierarchy { node, _ in
            if let light = node.light, light.castsShadow, light.type != .ambient {
                shadowLights += 1
            }
        }
        out.shadowCastingLights = shadowLights

        scene.rootNode.enumerateHierarchy { node, _ in
            guard !node.isHidden, let geometry = node.geometry else { return }
            out.visibleNodes += 1
            for element in geometry.elements {
                out.colourPassDraws += 1
                if node.castsShadow { out.shadowPassDraws += shadowLights }
                switch element.primitiveType {
                case .triangles:  out.triangles += element.primitiveCount
                case .triangleStrip: out.triangles += element.primitiveCount
                case .point:      out.points += element.primitiveCount
                default: break
                }
            }
        }
        return out
    }
}

// MARK: - The room's own cold open

extension GarimaSceneKitRoom {

    /// How long the most recently built room took from the moment its scene began
    /// to be assembled to the moment its first frame was presented.
    ///
    /// This is **not** the app's cold launch. `SpikeColdLaunchTests` measures that
    /// for the shipped Mandala by relaunching the process, which needs a UI test;
    /// this spike may not add one. What this measures is the part a renderer is
    /// actually responsible for — building the geometry, uploading it, compiling
    /// the shaders and getting a first frame out — and it is the figure that
    /// changes when the renderer changes.
    final class ColdOpen: @unchecked Sendable {
        static let shared = ColdOpen()
        private let lock = NSLock()
        private var stored: Double?

        var milliseconds: Double? {
            get { lock.lock(); defer { lock.unlock() }; return stored }
            set { lock.lock(); stored = newValue; lock.unlock() }
        }

        func reset() { milliseconds = nil }
    }
}

// MARK: - Entry points

extension GarimaSceneKitRoom {

    /// What the launch arguments ask for, if they ask for anything.
    ///
    /// * `SPIKE_ROOM=garima-scenekit` — show this room.
    /// * `SPIKE_T=<seconds>` — open it at that scene time. `347` and up is past the
    ///   second adaptation; the default is the room's opening.
    /// * `SPIKE_REDUCE_MOTION` — take the non-animated path.
    struct LaunchRequest: Equatable {
        var sceneTime: TimeInterval = 0
        var reduceMotion = false

        /// The room this spike answers to. Any other value is another variant's.
        static let token = "SPIKE_ROOM=garima-scenekit"

        static func parse(_ arguments: [String]) -> LaunchRequest? {
            guard arguments.contains(token) else { return nil }
            var request = LaunchRequest()
            for argument in arguments {
                if argument.hasPrefix("SPIKE_T="),
                   let t = TimeInterval(argument.dropFirst("SPIKE_T=".count)) {
                    request.sceneTime = t
                }
                if argument == "SPIKE_REDUCE_MOTION" { request.reduceMotion = true }
            }
            return request
        }
    }

    static var launchRequest: LaunchRequest? {
        LaunchRequest.parse(ProcessInfo.processInfo.arguments)
    }

    /// Put the room on screen in its own window, above whatever is already there.
    ///
    /// The same technique `SpikeBench` uses, for the same reason: a spike must be
    /// able to occupy the screen without any shipped view knowing it exists. No
    /// file outside `Views/Spike` is touched, which is why this is a function
    /// something else calls rather than a hook the app runs at launch — one line in
    /// `AppRoot` would make it the latter, and this spike may not write that line.
    @MainActor
    @discardableResult
    static func present(request: LaunchRequest,
                        shakti: Shakti? = nil,
                        clock: SpikeMetrics.Clock? = nil) -> UIWindow? {
        let clock = clock ?? SpikeMetrics.Clock(offset: request.sceneTime)
        let room = GarimaSceneKitRoom(ingredients: .garima(from: shakti),
                                      clock: clock,
                                      forceReduceMotion: request.reduceMotion)
        let host = UIHostingController(rootView: room.statusBarHidden(true))
        host.view.backgroundColor = .black

        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        let window = scene.map { UIWindow(windowScene: $0) } ?? UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert + 1
        window.backgroundColor = .black
        window.isOpaque = true
        window.rootViewController = host
        window.makeKeyAndVisible()
        return window
    }

    /// Show the room if this process was launched asking for it.
    @MainActor
    @discardableResult
    static func presentIfRequested(shakti: Shakti? = nil) -> UIWindow? {
        guard let request = launchRequest else { return nil }
        return present(request: request, shakti: shakti)
    }
}

// MARK: - Preview

#Preview("Garimā · the first adaptation") {
    GarimaSceneKitRoom(clock: SpikeMetrics.Clock(offset: 62))
}

#Preview("Garimā · past the second adaptation") {
    GarimaSceneKitRoom(clock: SpikeMetrics.Clock(offset: 347))
}

#Preview("Garimā · reduce motion, settled, not animating") {
    GarimaSceneKitRoom(clock: SpikeMetrics.Clock(offset: 0), forceReduceMotion: true)
}
#endif
