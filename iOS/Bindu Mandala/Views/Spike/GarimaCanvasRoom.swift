// Measuring apparatus, not part of the app. The whole Spike folder is compiled
// out of Release, so nothing here can exist in a build that reaches Neev. The
// test action builds Debug, so every spike test still sees it.
#if DEBUG
import SwiftUI
import UIKit

// MARK: - Garimā · khaḍgamālā position 4 · the renderer spike, variant B
//
// Variant B of the charter §4 renderer spike: **SwiftUI `Canvas` + `TimelineView`
// only**. No SceneKit, no scene graph, no depth buffer, no shadow map. The idiom
// is the shipped `MandalaCanvasLayer`'s — one `Canvas`, re-lit each frame by one
// `TimelineView(.animation)` clock, everything mapped from world space to screen
// space by hand.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT THE ROOM IS
// ─────────────────────────────────────────────────────────────────────────────
//
// Her mechanism is Design's `chamberPress` (`homes-chambers.js`, ~line 625),
// ported rather than reinterpreted:
//
//   * a **ceiling mass that descends the whole visit** — Design's `slab`, its
//     relief `under`, and its glowing `rim`;
//   * a **floor that thickens into strata** — Design's `strataTexture()`
//     displacement/bump map, with `displacementScale` climbing 0.5 → 2.4;
//   * a **raking directional light that casts a real shadow** — Design's
//     `raking` at (9, 6, 4) with `castShadow`;
//   * an **ember point light** at the impression pressed into the ground.
//
// And past the second adaptation the premise **reverses**. Design's own line:
// *"the weight was never above you. It is what you are standing on, and it has
// been holding you the whole time."* Here that reversal is **what the pressing
// has made**, not the press undone: the mass lifts, its underside gives up its
// relief, the raking light fails — and the strata, which are the *record* of the
// press, begin to carry the light themselves. The floor becomes the source. The
// impression at its centre stops being a mark left in the ground and becomes the
// room's key light, opening upward through it.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY IT COULD BE NO OTHER ŚAKTI
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's thread records the exact failure this room has to avoid — a room that
// would serve Garimā and Mahimā equally. Everything below is *hers*:
//
//   * **Weightedness / Pṛthvī.** The room's whole content is beneath the walker:
//     a heightfield that accumulates. Mahimā's mechanism is "no far wall, depth
//     generated faster than you can cross it" — recession. Here the far wall is
//     emphatically present, in shadow, at a measurable distance, and the depth is
//     *closing*. Laghimā's is "the floor has let go"; here there is nothing but
//     floor.
//   * **Mūlādhāra / sit-bones / soles.** The one warm light in the room sits at
//     ground level, at her seat — every other Ring-1 room lights from the eye or
//     from above. `RoomLight.altitude` reads that off her `bodilyLocation`, so the
//     ember's height is hers and not a constant.
//   * **The bed table is keyed to khaḍgamālā position 4** (Law 1 — position is
//     identity), so her rock is her rock and no sister inherits it.
//   * **Ring 1's seat is the square** (Design's `SEAT` map), so the room's plan
//     is the Bhūpura, and the strata run parallel to its edges.
//   * **Ring 1's gem is topaz, diffusion 0.20** — the hardest light in the nine
//     worlds after cat's-eye. That is carried as *behaviour only*: a tight
//     penumbra, a low ambient floor, a short ember falloff. A room of hers is
//     high-contrast because of which āvaraṇa she sits in, never because a
//     gemstone was consulted for a colour.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE LIGHT IS NOT INVENTED HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// Every hue is `Theme/Atmosphere.swift`'s, read through `Atmosphere.derive(from:)`
// — her ring's seed hue, her ±7° jitter from the 2654435761 hash keyed off her
// khaḍgamālā position, her ground blend. Design made the mistake of deriving
// colour from the gemstones once and corrected it; the gem survives only as the
// light's *quality*. Nothing in this file picks a colour.
//
// A sibling branch has built `HomeGem`; this file cannot depend on it, so the
// ring's diffusion table is restated privately here and nowhere else.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHY THERE IS NO METAL SHADER IN HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// The variant was specified as Canvas + TimelineView *plus SwiftUI Metal shaders
// for the light*, and it does not have one. Not an omission — a finding, and it
// is the single hardest constraint this renderer put on the work:
//
//   * `ShaderLibrary` can only be built from a **compiled** `.metallib`
//     (`ShaderLibrary.default`, `init(url:)`, `init(data:)`). There is no
//     from-source initialiser. `MTLDevice.makeLibrary(source:)` compiles at run
//     time but hands back an `MTLLibrary`, which cannot be turned back into the
//     `Data` `ShaderLibrary` wants.
//   * So a SwiftUI shader needs a `.metal` file in a build target, and a
//     `.metal` file cannot be `#if DEBUG`-ed out: it compiles into the target's
//     `default.metallib` in **Release** as well. Spike scaffolding would reach a
//     shipped build, which is the one thing the Spike folder exists to prevent.
//
// The light here is therefore computed on the CPU and expressed through
// `GraphicsContext`'s own shadings: one Lambert term per ribbon from the surface
// normal, one inequality for the mass's shadow plane, an inverse-square ember,
// and linear/radial gradients to carry them. That is enough for this room. It
// would not be enough for a per-pixel effect — a real volumetric, a refraction,
// Sarva-Yoni's transmission — and the cost of reaching one is a `.metal` file in
// the shipping target, which is a decision for the renderer ruling and not for a
// spike to take on its own.
//
// ─────────────────────────────────────────────────────────────────────────────
// THE CLOCK
// ─────────────────────────────────────────────────────────────────────────────
//
// `SpikeMetrics.Clock` — the committed apparatus — is the injectable input, so
// the harness drives the room to 347 s in one frame instead of waiting six
// minutes. Design's constants are used verbatim: the first adaptation resolves
// over 62 s, holds to 227, and the second runs the following 120 to 347.

struct GarimaCanvasRoom: View {

    /// Her row out of the app's own model — which carries quality, tattva,
    /// bodily location, ring and position, synced from Airtable. The room reads
    /// her through this and nothing else, so handing it the live row instead of
    /// the fixture changes nothing.
    let shakti: Shakti

    /// The test-only time input. Advance its offset and the room is instantly
    /// wherever you asked for.
    let clock: SpikeMetrics.Clock

    /// A real non-animated path. Not "the same room, slower": no `TimelineView`
    /// is constructed at all, and the scene time is quantised to the nearest of
    /// the room's three resting states — Design's standing decision is that
    /// reduced motion is *quantised*, never disabled, so the room is wholly
    /// present and simply does not move.
    var reduceMotion: Bool = false

    /// When set, the room draws exactly this scene time and never reads a clock.
    /// This is what the stills are rendered through.
    var frozenSceneTime: TimeInterval?

    // MARK: Design's clock, verbatim

    /// `smooth(t / 62)` — the first adaptation.
    static let firstAdaptation: TimeInterval = 62
    /// `HOLD_END` — the long hold only a returning practitioner outlasts.
    static let holdEnd: TimeInterval = 227
    /// `SECOND` — the second adaptation runs the following 120 seconds, to 347.
    static let secondSpan: TimeInterval = 120
    static var secondAdaptationEnd: TimeInterval { holdEnd + secondSpan }

    /// The three states the room actually rests in, for the reduce-motion path.
    /// Nothing between them is a resting state — they are the opening, the room
    /// with its first adaptation fully resolved, and the room after it has
    /// turned.
    static let restingStates: [TimeInterval] = [0, holdEnd, secondAdaptationEnd + 53]

    /// Quantised by the room's own adaptation rather than by the wall clock: a
    /// visit that is two thirds of the way through the turn belongs to the
    /// turned room, even though 227 is the nearer number.
    static func restingState(near t: TimeInterval) -> TimeInterval {
        let s = PressScene(at: t, animates: false)
        if s.b >= 0.5 { return restingStates[2] }
        if s.k >= 0.5 { return restingStates[1] }
        return restingStates[0]
    }

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            if let frozen = frozenSceneTime {
                plate(at: reduceMotion ? Self.restingState(near: frozen) : frozen, in: geo.size)
            } else if reduceMotion {
                // No TimelineView is built on this path — the room is a still.
                plate(at: Self.restingState(near: clock.sceneTime()), in: geo.size)
            } else {
                TimelineView(.animation) { tl in
                    plate(at: clock.sceneTime(now: tl.date.timeIntervalSinceReferenceDate),
                          in: geo.size)
                }
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
    }

    private func plate(at sceneTime: TimeInterval, in size: CGSize) -> some View {
        let light = RoomLight(shakti: shakti)
        let beds = Strata.beds(position: RoomLight.identity(of: shakti))
        let scene = PressScene(at: sceneTime, animates: !reduceMotion)
        return Canvas(opaque: true) { ctx, canvasSize in
            var pen = Draftsman(ctx: ctx)
            GarimaCanvasRoom.render(&pen, size: canvasSize, scene: scene, light: light, beds: beds)
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - The census
    //
    // The shipped canvas has to be *modelled* by `MandalaDrawCensus`, because
    // the spike may not edit it and `GraphicsContext` has no seam. This room has
    // no such problem: `render` draws through a `Draftsman` that tallies every
    // primitive as it issues it, and handing that Draftsman a nil context turns
    // the same code into an exact count. Not a model of the draw — the draw.

    struct Tally: Equatable {
        var air = 0
        var farWall = 0
        var sideWalls = 0
        var mass = 0
        var strata = 0
        var crests = 0
        var impression = 0
        var bloom = 0
        var dust = 0
        var veil = 0

        var total: Int {
            air + farWall + sideWalls + mass + strata + crests + impression + bloom + dust + veil
        }

        var breakdown: String {
            "total \(total) [air \(air), farWall \(farWall), sideWalls \(sideWalls),"
                + " mass \(mass), strata \(strata), crests \(crests),"
                + " impression \(impression), bloom \(bloom), dust \(dust), veil \(veil)]"
        }
    }

    /// The exact primitive count for one frame — the same walk the renderer makes,
    /// with nothing drawn.
    static func census(shakti: Shakti,
                       at sceneTime: TimeInterval,
                       in size: CGSize,
                       reduceMotion: Bool) -> Tally {
        var pen = Draftsman(ctx: nil)
        render(&pen,
               size: size,
               scene: PressScene(at: sceneTime, animates: !reduceMotion),
               light: RoomLight(shakti: shakti),
               beds: Strata.beds(position: RoomLight.identity(of: shakti)))
        return pen.tally
    }
}

// MARK: - Her light, as Atmosphere derives it

/// Every colour in the room, and nothing else. Hue, saturation and lightness are
/// `Atmosphere`'s; the gem contributes only how hard or soft the light behaves.
private struct RoomLight {
    let hue: HSL
    /// The dhātu — Design's `G.ink`, `hslHex(h, s * 0.55, 12)`, the stone the
    /// room is cut from.
    let ink: HSL
    let bright: HSL
    let ground: Color
    let groundDeep: Color
    let accent: Color
    let accentBright: Color

    /// Ring 1 is topaz at 0.20 — Design's `GEM_BEHAVIOUR`, kept as *behaviour*
    /// only (how diffuse the light is, how far it falls), never as a colour.
    let diffusion: Double

    /// Her seat in the body, 0 at the soles and 1 at the crown, read off
    /// `bodilyLocation`. Garimā's is "Mūlādhāra / sit-bones / soles" — the
    /// lowest reading in the garland, which is why her one warm light sits on
    /// the ground.
    let altitude: Double

    init(shakti: Shakti) {
        let atmosphere = Atmosphere.derive(from: shakti)
        hue = atmosphere.hue
        ink = HSL(h: atmosphere.hue.h, s: atmosphere.hue.s * 0.55, l: 12)
        bright = HSL(h: atmosphere.hue.h,
                     s: min(atmosphere.hue.s + 10, 88),
                     l: min(atmosphere.hue.l + 18, 78))
        ground = atmosphere.ground
        groundDeep = atmosphere.groundDeep
        accent = atmosphere.accent
        accentBright = atmosphere.accentBright
        diffusion = Self.gemDiffusion(ring: Self.ring(of: shakti))
        altitude = Self.altitude(of: shakti.bodilyLocation)
    }

    /// Law 1: her khaḍgamālā position is the only key this room uses.
    static func identity(of shakti: Shakti) -> Int {
        shakti.khadgamalaPosition ?? shakti.position
    }

    static func ring(of shakti: Shakti) -> Int {
        shakti.ringNumber ?? KhadgamalaMap.ringNumber(forKhadgamala: identity(of: shakti))
    }

    /// Design's `GEM_BEHAVIOUR`, diffusion column only.
    static func gemDiffusion(ring: Int) -> Double {
        switch ring {
        case 1: return 0.20   // topaz
        case 2: return 0.30   // sapphire
        case 3: return 0.45   // coral
        case 4: return 0.15   // diamond
        case 5: return 0.25   // emerald
        case 6: return 0.55   // ruby
        case 7: return 0.95   // pearl — sourceless
        case 8: return 0.10   // cat's eye — one hard band
        case 9: return 0.70   // all gems
        default: return 0.30
        }
    }

    /// Read from her own words, lowest match wins. Nothing is invented: where she
    /// names no place, the room takes the heart's height and says so by doing
    /// nothing unusual.
    static func altitude(of bodilyLocation: String) -> Double {
        let place = bodilyLocation.lowercased()
        let seats: [(String, Double)] = [
            ("sole", 0.0), ("mūlādhāra", 0.04), ("muladhara", 0.04), ("sit-bone", 0.06),
            ("sacrum", 0.14), ("belly", 0.24), ("solar plexus", 0.34), ("diaphragm", 0.38),
            ("heart", 0.5), ("chest", 0.5), ("sternum", 0.52), ("throat", 0.64),
            ("palate", 0.72), ("face", 0.78), ("eye", 0.82), ("forehead", 0.86),
            ("third eye", 0.86), ("crown", 1.0),
        ]
        var found: Double?
        for (word, height) in seats where place.contains(word) {
            found = min(found ?? height, height)
        }
        return found ?? 0.5
    }

    /// Stone, lit. `lambert` is the surface's own light, `ember` the warm term
    /// from the impression, `emissive` the strata's own light past the reversal.
    /// The ambient floor is set by the gem's diffusion: a hard gem leaves deep
    /// shadow, a diffuse one fills it.
    /// `band` is the stratum's own value. Design gives the floor a `bumpMap` as
    /// well as a displacement map, and a bump map does exactly this: it varies
    /// how much of the light a patch returns, without moving it. A 2-D canvas
    /// has no normals to perturb, so the band arrives on the light directly —
    /// which is why the strata show where the raking light reaches them and
    /// vanish where it does not.
    func stone(lambert: Double, ember: Double = 0, emissive: Double = 0, band: Double = 1) -> Color {
        let ambient = 0.05 + diffusion * 0.16
        let lit = (ambient + lambert + ember) * band
        return HSL(h: hue.h,
                   s: HSL.clamp(ink.s + lit * 20 + emissive * 14, 6, 88),
                   l: HSL.clamp(ink.l + lit * 44 + emissive * 30, 1.5, 88)).color()
    }

    /// The same, as her accent rather than as stone — used for the contacts
    /// between beds, the mass's rim and the impression.
    func flare(_ strength: Double, alpha: Double = 1) -> Color {
        HSL(h: hue.h,
            s: HSL.clamp(bright.s, 6, 90),
            l: HSL.clamp(bright.l + strength * 22, 8, 92)).color(alpha: HSL.clamp(alpha, 0, 1))
    }
}

// MARK: - The room's world, in Design's own units

private enum World {
    /// Ring 1's seat is the square — Design's `SEAT` map — so the room's plan is
    /// the Bhūpura, 17 units on a side, and the strata run parallel to its edges.
    static let halfWidth: Double = 8.5
    static let backZ: Double = -9            // the far wall
    static let nearZ: Double = 8             // the near lip: where the walls and the mass end
    static let floorNearZ: Double = 8.3      // the floor runs on, under the walker
    static let groundY: Double = -5.2        // Design's `ground.position.y`
    static let massRestY: Double = 11        // Design's `slab.position.y`
    static let massHalf: Double = 2.2        // half of the 4.4-deep slab
    static let descent: Double = 7.4         // `slab.position.y = 11 - k * 7.4`
    static let rise: Double = 5.2            // `+ b * 5.2` — the second adaptation
    static let impressionZ: Double = 2.5     // Design's press, at its own share of the depth
    static let wallTop: Double = 17
    static let emberDrop: Double = 0.9       // the ember sits just above the ground
}

/// A pinhole lens. This is the whole of "faking depth" in a renderer with no
/// depth buffer: one divide per point, painter's order for occlusion, and
/// attenuation with distance. Everything below projects through it.
private struct Lens {
    let center: CGPoint
    let focal: Double
    /// A standing walker: a little under six units above the floor, and standing
    /// at the room's near lip rather than outside it looking in.
    let eyeY: Double = 0.5
    let eyeZ: Double = 11.4

    init(size: CGSize) {
        focal = Double(size.width) * 0.84
        center = CGPoint(x: size.width / 2, y: size.height * 0.40)
    }

    /// Points-per-world-unit at a given depth. Also the atmospheric weight: the
    /// far wall is small *and* faint by the same number.
    func scale(atZ z: Double) -> Double { focal / max(eyeZ - z, 0.5) }

    func project(_ x: Double, _ y: Double, _ z: Double) -> CGPoint {
        let k = scale(atZ: z)
        return CGPoint(x: center.x + CGFloat(x * k),
                       y: center.y - CGFloat((y - eyeY) * k))
    }

    /// How flat a disc lying on the floor looks from here — the true
    /// foreshortening, taken from the lens rather than guessed at.
    func foreshortening(ofY y: Double, atZ z: Double) -> Double {
        let up = eyeY - y
        return up / max(sqrt(up * up + (eyeZ - z) * (eyeZ - z)), 0.001)
    }
}

// MARK: - The strata
//
// A verbatim port of Design's `strataTexture()`: a deterministic walk that lays
// down beds of 5…27 units, each with its own grey, the grey stepping by
// `(rnd - 0.42) * 90` and clamped to 14…232, and each bed falling from its own
// value to 0.55 of it across its thickness.
//
// In `homes-chambers.js` that table is a canvas texture handed to Three **twice**
// — as `displacementMap` and as `bumpMap` — and the two do different jobs. The
// ground plane carries 180 segments across 46 units, so a mesh vertex falls only
// about every two beds: the displacement it can actually hold is a slow swell,
// and the fine stratification is the bump map perturbing normals per pixel.
//
// That split is what ports. The swell becomes real geometry — a height field
// read far to near, every ribbon's near edge the next one's far edge, so it is a
// surface and not a stack of blades. The bump becomes a band on the light, since
// a `Canvas` has no normals to perturb. The consequence is exactly right: the
// strata show where the raking light reaches them and vanish into the mass's
// shadow, which is what a bump map does too.

/// One bed of rock, as Design's `strataTexture()` lays it down.
private struct Bed {
    /// Where its far contact sits along the floor, 0 at the wall and 1 at the lip.
    let u: Double
    /// Design's `v`, normalised — the bed's own value. This is the **bump**: the
    /// fine stratification, which in `chamberPress` is carried by `bumpMap` and
    /// not by the displacement, because the ground mesh's 180 segments cannot
    /// resolve a bed anyway. Here it modulates the light instead of the geometry,
    /// which is the same thing arriving by the only route a `Canvas` has.
    let value: Double
    /// The **displacement**: the same table smoothed over seven beds, so the
    /// floor swells and sinks the way a displaced low-poly plane does rather
    /// than standing up in blades.
    let swell: Double
}

private enum Strata {
    /// Fixed, so the primitive count is a constant of the room and not of the
    /// clock: the measurement says what it costs, not what it happened to cost.
    static let bedCount = 32

    /// A verbatim walk of Design's texture loop, made deterministic and keyed to
    /// her khaḍgamālā position: thicknesses of 5…27, the value stepping by
    /// `(rnd - 0.42) * 90` and clamped to 14…232.
    static func beds(position kp: Int) -> [Bed] {
        var rand = Rand(seed: UInt64(bitPattern: Int64(kp &* 2_654_435_761)))
        var thickness: [Double] = []
        var value: [Double] = []
        thickness.reserveCapacity(bedCount + 1)
        value.reserveCapacity(bedCount + 1)
        var v = 30.0
        for _ in 0...bedCount {
            thickness.append(5 + rand.next() * 22)
            v = min(max(v + (rand.next() - 0.42) * 90, 14), 232)
            value.append((v - 14) / 218)
        }
        let span = thickness.reduce(0, +)

        var out: [Bed] = []
        out.reserveCapacity(bedCount + 1)
        var cursor = 0.0
        for i in 0...bedCount {
            let u = cursor / span
            cursor += thickness[i]
            // Seven-bed mean: the displacement a low-poly plane could actually
            // hold.
            var sum = 0.0
            for d in -3...3 {
                sum += value[min(max(i + d, 0), bedCount)]
            }
            // Level where it meets the far wall, and level again underfoot:
            // a bed rearing up in the walker's own face is a cliff, not a floor.
            let taper = min(u * 6, 1) * min((1 - u) * 14, 1)
            out.append(Bed(u: u, value: value[i], swell: (sum / 7) * taper))
        }
        return out
    }

    /// How much of its height this bed has found, at a given pressure. No bed
    /// ever *appears* — the faint ones sharpen, in a fixed order, so nothing
    /// reshuffles between frames and the count never moves.
    static func emergence(_ bed: Bed, pressure: Double) -> Double {
        PressScene.smooth((pressure * 1.35 - (1 - bed.value) * 0.55) * 2.4)
    }

    /// The table read at a point along the floor, **by depth and not by ribbon
    /// index**. This distinction is the whole difference between a floor and a
    /// row of blades: the ribbons are laid out in equal *screen* bands, so the
    /// near ones span almost no depth at all, and a height field indexed by
    /// ribbon would put a whole bed's rise inside one of them. Read by depth, a
    /// near bed simply covers several ribbons — which is what perspective does
    /// to a stratum.
    static func sample(_ beds: [Bed], at u: Double) -> (height: Double, value: Double, index: Int) {
        let c = min(max(u, 0), 1)
        var i = 0
        while i + 1 < beds.count && beds[i + 1].u <= c { i += 1 }
        let j = min(i + 1, beds.count - 1)
        let span = max(beds[j].u - beds[i].u, 1e-6)
        let f = min(max((c - beds[i].u) / span, 0), 1)
        return (beds[i].swell + (beds[j].swell - beds[i].swell) * f, beds[i].value, i)
    }
}

/// SplitMix-flavoured, so the bed table is the same on every machine and every
/// launch — Design's `Math.random()` walk made reproducible.
private struct Rand {
    private var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E37_79B9_7F4A_7C15 }
    mutating func next() -> Double {
        state = state &+ 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        z = z ^ (z >> 31)
        return Double(z % 1_000_003) / 1_000_003
    }
}

// MARK: - The scene: a pure function of elapsed seconds

/// Everything the room is at one instant. Design's own numbers, in Design's own
/// order — the descent, the displacement, the raking fall, and then the
/// reversal written over the top of them exactly as `chamberPress.update` does.
private struct PressScene {
    /// `smooth(t / 62)` — the first adaptation.
    let k: Double
    /// `deep(t)` — 0 until 227, 1 by 347.
    let b: Double

    let massCentreY: Double
    let massBottomY: Double
    /// Design's `groundMat.displacementScale = 0.5 + k * 1.9 + b * 1.4`.
    let displacement: Double
    /// `raking.intensity = 3.6 - k * 2.0`, **normalised against its own opening
    /// value**, and then the reversal takes it away. Three's intensity is a
    /// photometric quantity; a canvas has no exposure to expose it against, so
    /// what carries over is the *ratio* — full at the opening, 44% once the mass
    /// is down, 19% once the room has turned — and never the number.
    let raking: Double
    /// The ember's breath — `1300 + sin(t * 0.5) * 130`, normalised.
    let ember: Double
    /// `press.scale.setScalar(1 + b * 1.8)`.
    let impressionScale: Double
    /// `press.material.emissiveIntensity = 1.4 + b * 3.4`, normalised.
    let impressionGlow: Double
    /// The strata's own light, past the reversal. This is the room's turn: what
    /// the pressing made begins to carry the light.
    let emissive: Double
    /// `rim.material.opacity = 0.32 + k * 0.4`.
    let rim: Double
    /// Design's `driftMotes(dust, t, 0.3, 1)` — falling, until the reversal
    /// turns the source upside down and the dust comes up through it.
    let settle: Double
    let sway: Double
    /// How far the beds have resolved — `k` mostly, `b` finishing the work.
    let pressure: Double

    init(at sceneTime: TimeInterval, animates: Bool) {
        k = PressScene.smooth(sceneTime / GarimaCanvasRoom.firstAdaptation)
        b = PressScene.smooth((sceneTime - GarimaCanvasRoom.holdEnd) / GarimaCanvasRoom.secondSpan)

        massCentreY = World.massRestY - k * World.descent + b * World.rise
        massBottomY = massCentreY - World.massHalf
        displacement = 0.5 + k * 1.9 + b * 1.4
        raking = ((3.6 - k * 2.0) / 3.6) * (1 - 0.58 * b)

        let breath = animates ? sin(sceneTime * 0.5) : 0
        ember = 1 + 0.1 * breath + b * 0.75
        impressionScale = 1 + b * 1.8
        impressionGlow = (1.4 + b * 3.4) / 1.4
        emissive = b
        rim = 0.32 + k * 0.4
        // Bounded and reversible: tanh saturates, so a six-minute visit settles
        // by a fixed amount rather than pouring the dust through the floor, and
        // the sign turns with the room.
        settle = tanh(sceneTime / 110) * 3.1 * (1 - 2 * b)
        sway = animates ? sceneTime : 0
        pressure = k * 0.62 + b * 0.38
    }

    /// Design's `smooth` — `clamp01` then `t²(3 − 2t)`.
    static func smooth(_ x: Double) -> Double {
        let c = x < 0 ? 0 : (x > 1 ? 1 : x)
        return c * c * (3 - 2 * c)
    }
}

// MARK: - The raking light
//
// Design's `raking` is a `DirectionalLight` at (9, 6, 4) with `castShadow` and a
// 1024² shadow map. There is no shadow map here and none is needed: the thing
// casting the shadow is a horizontal slab, so its shadow boundary is a *plane*,
// and whether a point is lit is one inequality.
//
// Light travels along −L. From the mass's lower near edge at (·, massBottom,
// nearZ) that boundary passes through every point satisfying
//
//     z = nearZ − (L.z / L.y) · (massBottom − y)
//
// so a point is lit exactly when it lies nearer than that. As the mass descends
// the boundary sweeps toward the lip and the lit strip on the floor is squeezed
// out; as the mass lifts at the reversal it floods back. That is the whole
// shadow, exactly, for the cost of a subtraction.

private enum Rake {
    /// `normalize(9, 6, 4)`.
    static let dx = 0.780_9
    static let dy = 0.520_6
    static let dz = 0.347_1

    /// Lambert for a surface with the given normal.
    static func lambert(nx: Double, ny: Double, nz: Double) -> Double {
        max(0, nx * dx + ny * dy + nz * dz)
    }

    /// The depth at which the mass's shadow crosses a given height.
    static func boundaryZ(atY y: Double, massBottomY: Double) -> Double {
        World.nearZ - (dz / dy) * (massBottomY - y)
    }

    /// 1 in full light, 0 in the mass's shadow. The penumbra is the gem's: a
    /// hard gem draws a hard edge.
    static func lit(y: Double, z: Double, massBottomY: Double, diffusion: Double) -> Double {
        let penumbra = 0.5 + diffusion * 7
        return PressScene.smooth((z - boundaryZ(atY: y, massBottomY: massBottomY)) / penumbra + 0.5)
    }
}

// MARK: - The draughtsman
//
// One code path that either draws or counts. Every primitive the room issues
// passes through here, so the census is exact by construction rather than a
// model that can drift from the thing it models.

private struct Draftsman {
    let ctx: GraphicsContext?
    var tally = GarimaCanvasRoom.Tally()

    mutating func fill(_ path: Path,
                       _ shading: GraphicsContext.Shading,
                       blend: GraphicsContext.BlendMode = .normal,
                       _ key: WritableKeyPath<GarimaCanvasRoom.Tally, Int>) {
        tally[keyPath: key] += 1
        guard var c = ctx else { return }
        c.blendMode = blend
        c.fill(path, with: shading)
    }

    mutating func stroke(_ path: Path,
                         _ shading: GraphicsContext.Shading,
                         width: CGFloat,
                         blend: GraphicsContext.BlendMode = .normal,
                         _ key: WritableKeyPath<GarimaCanvasRoom.Tally, Int>) {
        tally[keyPath: key] += 1
        guard var c = ctx else { return }
        c.blendMode = blend
        c.stroke(path, with: shading, lineWidth: width)
    }
}

// MARK: - The render

extension GarimaCanvasRoom {

    /// How many ribbons the mass's underside is relieved into. Design gives it
    /// its own displacement at 0.7 against the floor's 0.5 — the same stone,
    /// read coarser, which is exactly what the reversal turns out to have meant.
    static let massReliefRibbons = 12

    /// Samples across the room's width for a contact line. Enough that the
    /// contacts undulate rather than ruling straight across, few enough that a
    /// bed is still one fill.
    static let bedSamples = 9

    /// Design's `motes(110, …)`, thinned to what a 2-D canvas can carry without
    /// the mote layer dominating the frame budget.
    static let moteCount = 72

    fileprivate static func render(_ pen: inout Draftsman,
                                   size: CGSize,
                                   scene: PressScene,
                                   light: RoomLight,
                                   beds: [Bed]) {
        guard size.width > 1, size.height > 1, beds.count > 1 else { return }
        let lens = Lens(size: size)
        let frame = CGRect(origin: .zero, size: size)

        // The impression's seat: her own altitude in the body, brought down to
        // the floor of the room. Garimā reads 0 — Mūlādhāra, sit-bones, soles.
        let emberY = World.groundY + World.emberDrop + light.altitude * 2.2

        drawAir(&pen, frame: frame, lens: lens, scene: scene, light: light, emberY: emberY)
        // ── FAR ────────────────────────────────────────────────────────────
        drawFarWall(&pen, lens: lens, scene: scene, light: light, emberY: emberY)
        // ── MID ────────────────────────────────────────────────────────────
        drawSideWalls(&pen, lens: lens, scene: scene, light: light, emberY: emberY)
        drawMass(&pen, lens: lens, scene: scene, light: light, beds: beds, emberY: emberY)
        // ── NEAR ───────────────────────────────────────────────────────────
        drawStrata(&pen, lens: lens, scene: scene, light: light, beds: beds, emberY: emberY)
        drawImpression(&pen, lens: lens, scene: scene, light: light, emberY: emberY)
        drawDust(&pen, frame: frame, lens: lens, scene: scene, light: light)
        drawVeil(&pen, frame: frame, scene: scene)
    }

    // MARK: the air

    private static func drawAir(_ pen: inout Draftsman,
                                frame: CGRect,
                                lens: Lens,
                                scene: PressScene,
                                light: RoomLight,
                                emberY: Double) {
        pen.fill(Path(frame), .color(light.groundDeep), \.air)

        let ember = lens.project(0, emberY, World.impressionZ)
        let reach = frame.width * (0.85 + 0.45 * scene.b)
        pen.fill(Path(frame),
                 .radialGradient(Gradient(colors: [light.ground.opacity(0.38 * scene.ember),
                                                   light.groundDeep.opacity(0)]),
                                 center: ember, startRadius: 0, endRadius: reach),
                 \.air)
    }

    // MARK: the far wall — in the mass's shadow the whole visit

    private static func drawFarWall(_ pen: inout Draftsman,
                                    lens: Lens,
                                    scene: PressScene,
                                    light: RoomLight,
                                    emberY: Double) {
        let z = World.backZ
        var wall = Path()
        wall.move(to: lens.project(-World.halfWidth, World.groundY, z))
        wall.addLine(to: lens.project(World.halfWidth, World.groundY, z))
        wall.addLine(to: lens.project(World.halfWidth, World.wallTop, z))
        wall.addLine(to: lens.project(-World.halfWidth, World.wallTop, z))
        wall.closeSubpath()

        // Its normal faces the walker, but the shadow plane never clears it:
        // there is no angle at which the raking light reaches the far wall once
        // the mass is overhead, which is why the room's deepest value sits here.
        let baseEmber = emberFactor(x: 0, y: World.groundY + 0.6, z: z,
                                    emberY: emberY, light: light) * scene.ember
        let topEmber = emberFactor(x: 0, y: World.wallTop * 0.4, z: z,
                                   emberY: emberY, light: light) * scene.ember * 0.4
        pen.fill(wall,
                 .linearGradient(Gradient(colors: [light.stone(lambert: 0, ember: topEmber),
                                                   light.stone(lambert: 0, ember: baseEmber,
                                                               emissive: scene.emissive * 0.55)]),
                                 startPoint: lens.project(0, World.wallTop, z),
                                 endPoint: lens.project(0, World.groundY, z)),
                 \.farWall)

        // Where the strata meet it — the one contact the ember reaches, and the
        // first thing that brightens when the floor takes the room over.
        var contact = Path()
        contact.move(to: lens.project(-World.halfWidth, World.groundY, z))
        contact.addLine(to: lens.project(World.halfWidth, World.groundY, z))
        pen.stroke(contact,
                   .color(light.flare(scene.emissive,
                                      alpha: 0.12 + 0.42 * scene.emissive + 0.25 * baseEmber)),
                   width: 1 + CGFloat(scene.emissive * 1.4),
                   blend: .plusLighter,
                   \.farWall)
    }

    // MARK: the side walls — the left one is the only lit wall in the room

    private static func drawSideWalls(_ pen: inout Draftsman,
                                      lens: Lens,
                                      scene: PressScene,
                                      light: RoomLight,
                                      emberY: Double) {
        for side in [-1.0, 1.0] {
            let x = side * World.halfWidth
            var wall = Path()
            wall.move(to: lens.project(x, World.groundY, World.backZ))
            wall.addLine(to: lens.project(x, World.groundY, World.nearZ))
            wall.addLine(to: lens.project(x, World.wallTop, World.nearZ))
            wall.addLine(to: lens.project(x, World.wallTop, World.backZ))
            wall.closeSubpath()

            // Inner normal points inward: +x on the left wall, −x on the right.
            let lambert = Rake.lambert(nx: -side, ny: 0, nz: 0)
            let ember = emberFactor(x: x, y: World.groundY + 1.4, z: World.impressionZ,
                                    emberY: emberY, light: light) * scene.ember
            pen.fill(wall,
                     .linearGradient(Gradient(colors: [light.stone(lambert: 0, ember: ember * 0.85,
                                                                   emissive: scene.emissive * 0.6),
                                                       light.stone(lambert: 0, ember: ember * 0.1)]),
                                     startPoint: lens.project(x, World.groundY, World.impressionZ),
                                     endPoint: lens.project(x, World.wallTop, World.impressionZ)),
                     \.sideWalls)

            guard lambert > 0.01 else { continue }
            // The lit region is bounded by the shadow plane and by the mass's
            // own underside: a wedge that shrinks as the mass comes down.
            let footZ = Rake.boundaryZ(atY: World.groundY, massBottomY: scene.massBottomY)
            let capY = min(scene.massBottomY, World.wallTop)
            guard footZ < World.nearZ, capY > World.groundY else { continue }
            var band = Path()
            band.move(to: lens.project(x, World.groundY, max(footZ, World.backZ)))
            band.addLine(to: lens.project(x, World.groundY, World.nearZ))
            band.addLine(to: lens.project(x, capY, World.nearZ))
            band.closeSubpath()
            let strength = lambert * scene.raking * 0.42
            pen.fill(band,
                     .linearGradient(Gradient(colors: [light.stone(lambert: strength, ember: ember),
                                                       light.stone(lambert: strength * 0.1, ember: ember * 0.25)]),
                                     startPoint: lens.project(x, World.groundY, World.nearZ),
                                     endPoint: lens.project(x, capY, max(footZ, World.backZ))),
                     \.sideWalls)
        }
    }

    // MARK: the descending mass

    private static func drawMass(_ pen: inout Draftsman,
                                 lens: Lens,
                                 scene: PressScene,
                                 light: RoomLight,
                                 beds: [Bed],
                                 emberY: Double) {
        let bottom = scene.massBottomY
        // Design's `under` at displacementScale 0.7 against the floor's 0.5, and
        // giving it up as the room turns. Its normal points down, so the raking
        // light never touches it: everything it shows is the ember from below,
        // which is why it brightens as it descends.
        let relief = (0.7 + scene.k * 0.5) * (1 - 0.72 * scene.b)
        func sag(_ i: Int) -> Double {
            bottom - beds[(i * 2 + 6) % beds.count].swell * relief
        }
        for i in 0..<massReliefRibbons {
            let zFar = depth(atFraction: Double(i) / Double(massReliefRibbons), lens: lens)
            let zNear = depth(atFraction: Double(i + 1) / Double(massReliefRibbons), lens: lens)
            let yFar = sag(i), yNear = sag(i + 1)
            var ribbon = Path()
            ribbon.move(to: lens.project(-World.halfWidth, yFar, zFar))
            ribbon.addLine(to: lens.project(World.halfWidth, yFar, zFar))
            ribbon.addLine(to: lens.project(World.halfWidth, yNear, zNear))
            ribbon.addLine(to: lens.project(-World.halfWidth, yNear, zNear))
            ribbon.closeSubpath()

            let ember = emberFactor(x: 0, y: yNear, z: (zFar + zNear) / 2,
                                    emberY: emberY, light: light) * scene.ember
            pen.fill(ribbon,
                     .color(light.stone(lambert: 0, ember: ember * 1.2,
                                        emissive: scene.emissive * 0.2)),
                     \.mass)
        }

        // Its near face — the weight itself, arriving into the frame.
        var face = Path()
        face.move(to: lens.project(-World.halfWidth, bottom, World.nearZ))
        face.addLine(to: lens.project(World.halfWidth, bottom, World.nearZ))
        face.addLine(to: lens.project(World.halfWidth, scene.massCentreY + World.massHalf, World.nearZ))
        face.addLine(to: lens.project(-World.halfWidth, scene.massCentreY + World.massHalf, World.nearZ))
        face.closeSubpath()
        let faceEmber = emberFactor(x: 0, y: bottom, z: World.nearZ,
                                    emberY: emberY, light: light) * scene.ember
        pen.fill(face,
                 .linearGradient(Gradient(colors: [light.stone(lambert: 0, ember: faceEmber),
                                                   light.stone(lambert: 0, ember: 0)]),
                                 startPoint: lens.project(0, bottom, World.nearZ),
                                 endPoint: lens.project(0, scene.massCentreY + World.massHalf, World.nearZ)),
                 \.mass)

        // Design's `rim` — the one bright edge on the mass, and the measure of
        // how near it has come.
        var rim = Path()
        rim.move(to: lens.project(-World.halfWidth, bottom, World.nearZ))
        rim.addLine(to: lens.project(World.halfWidth, bottom, World.nearZ))
        pen.stroke(rim,
                   .color(light.accentBright.opacity(scene.rim * 0.55 * (1 - 0.5 * scene.b))),
                   width: 1.2 + CGFloat(scene.k * 1.1),
                   blend: .plusLighter,
                   \.mass)
    }

    // MARK: the strata — the floor thickening, and then carrying the light

    /// Ribbons across the floor. Laid out in equal screen bands, so the count
    /// is a constant of the room and every band is legible at phone width.
    static let floorRibbons = 30

    private static func drawStrata(_ pen: inout Draftsman,
                                   lens: Lens,
                                   scene: PressScene,
                                   light: RoomLight,
                                   beds: [Bed],
                                   emberY: Double) {
        let floorSpan = World.floorNearZ - World.backZ

        func read(_ z: Double) -> (y: Double, value: Double) {
            let r = Strata.sample(beds, at: (z - World.backZ) / floorSpan)
            let sharp = 0.3 + 0.7 * Strata.emergence(beds[r.index], pressure: scene.pressure)
            return (World.groundY + r.height * scene.displacement * sharp, r.value)
        }
        /// The contact lines are not ruled straight across the room. The wave
        /// rides on the bed's own rise, so where the floor is level — against
        /// the far wall, and underfoot — it is level all the way across and the
        /// surface closes on the frame instead of leaving a gap under itself.
        func undulation(_ z: Double, _ f: Double, _ rise: Double) -> Double {
            let phase = z * 2.9
            return (sin(f * 5.1 + phase) * 0.34 + sin(f * 11.3 + phase * 1.7) * 0.14) * rise
        }

        // A continuous height field read far to near. A surface seen from above
        // needs no depth buffer, only the right order — and every ribbon's near
        // edge is the next one's far edge, so it is a surface and not a stack.
        var far = depth(atFraction: 0, lens: lens)
        var farRead = read(far)
        for i in 0..<floorRibbons {
            let near = depth(atFraction: Double(i + 1) / Double(floorRibbons), lens: lens)
            let nearRead = read(near)

            var ribbon = Path()
            for s in 0...bedSamples {
                let f = Double(s) / Double(bedSamples)
                let x = -World.halfWidth + f * 2 * World.halfWidth
                ribbon.addLineOrMove(to: lens.project(x, farRead.y + undulation(far, f, farRead.y - World.groundY), far),
                                     first: s == 0)
            }
            for s in stride(from: bedSamples, through: 0, by: -1) {
                let f = Double(s) / Double(bedSamples)
                let x = -World.halfWidth + f * 2 * World.halfWidth
                ribbon.addLine(to: lens.project(x, nearRead.y + undulation(near, f, nearRead.y - World.groundY), near))
            }
            ribbon.closeSubpath()

            // The surface's own normal, from its slope: (0, dz, −dy) normalised.
            // This is what makes the light *rake* — a slope falling toward the
            // walker turns into the light, one rising turns away from it.
            let dy = nearRead.y - farRead.y, dz = near - far
            let len = max(sqrt(dy * dy + dz * dz), 0.0001)
            let lambert = Rake.lambert(nx: 0, ny: dz / len, nz: -dy / len)

            let zMid = (far + near) / 2
            let yMid = (farRead.y + nearRead.y) / 2
            let lit = Rake.lit(y: yMid, z: zMid, massBottomY: scene.massBottomY, diffusion: light.diffusion)
            // Design's bumpMap, as a band on the light rather than on the
            // geometry. Averaged across the ribbon so the far strata, which are
            // finer than a screen row, settle instead of flickering.
            var v = 0.0
            for s in 0..<3 {
                v += read(far + (near - far) * (Double(s) + 0.5) / 3).value
            }
            let band = 0.38 + 0.8 * (v / 3)
            let direct = lambert * scene.raking * 0.62 * lit
            let ember = emberFactor(x: 0, y: yMid, z: zMid, emberY: emberY, light: light) * scene.ember
            // Past the reversal the deepest beds carry the most light: what the
            // press drove furthest down is what now holds the room up.
            let emissive = scene.emissive * (1 - farRead.value) * 1.3

            pen.fill(ribbon,
                     .linearGradient(Gradient(colors: [light.stone(lambert: direct, ember: ember * 0.75, emissive: emissive * 0.6, band: band),
                                                       light.stone(lambert: direct * 0.7, ember: ember, emissive: emissive, band: band)]),
                                     startPoint: lens.project(0, farRead.y, far),
                                     endPoint: lens.project(0, nearRead.y, near)),
                     \.strata)

            // The contact between two beds — bright where the raking light
            // grazes it during the press, and bright again, from underneath,
            // once the strata are the source. Only the ribbon boundary that a
            // contact actually falls on carries one, so the lines land where
            // the rock changes and nowhere else.
            let step = nearRead.value - farRead.value
            let contactStrength = abs(step) * (lit * scene.raking * 0.85 + ember * 0.7) + emissive * abs(step) * 1.4
            far = near
            farRead = nearRead
            guard contactStrength > 0.03 else { continue }
            var contact = Path()
            for s in 0...bedSamples {
                let f = Double(s) / Double(bedSamples)
                let x = -World.halfWidth + f * 2 * World.halfWidth
                contact.addLineOrMove(to: lens.project(x, nearRead.y + undulation(near, f, nearRead.y - World.groundY), near),
                                      first: s == 0)
            }
            pen.stroke(contact,
                       .color(light.flare(emissive, alpha: min(contactStrength, 0.6))),
                       width: 0.7 + CGFloat(min(emissive, 1) * 0.9),
                       blend: .plusLighter,
                       \.crests)
        }
    }

    /// Depth for a fraction of the floor, placed so the ribbons land in **equal
    /// screen bands** rather than equal world steps — uniform in 1/d, which is
    /// what the projection is linear in.
    private static func depth(atFraction f: Double, lens: Lens) -> Double {
        let farInv = 1 / (lens.eyeZ - World.backZ)
        let nearInv = 1 / (lens.eyeZ - World.floorNearZ)
        return lens.eyeZ - 1 / (farInv + (nearInv - farInv) * f)
    }

    // MARK: the impression

    private static func drawImpression(_ pen: inout Draftsman,
                                       lens: Lens,
                                       scene: PressScene,
                                       light: RoomLight,
                                       emberY: Double) {
        // A disc set into the floor — Design's cylinder, seen from where the
        // walker stands. It sinks as the press continues, and opens as the room
        // turns. Nothing here is a figure: it is a shape performing an action.
        let sink = 0.3 + scene.k * 0.45 - scene.b * 0.6
        let y = World.groundY + 0.15 - sink
        let k = lens.scale(atZ: World.impressionZ)
        let centre = lens.project(0, y, World.impressionZ)
        let rx = CGFloat(1.9 * scene.impressionScale * k)
        let ry = rx * CGFloat(lens.foreshortening(ofY: y, atZ: World.impressionZ))

        // Additive light over an already-lit floor clips fast, so the glow is
        // held below the point where the room would go white: past the reversal
        // the floor is the source, and a source you cannot look into is a lamp,
        // not a room.
        let glow = min(scene.impressionGlow, 2.1)
        var disc = Path()
        disc.addEllipse(in: CGRect(x: centre.x - rx, y: centre.y - ry, width: rx * 2, height: ry * 2))
        pen.fill(disc,
                 .radialGradient(Gradient(colors: [light.flare(0.08 + glow * 0.1,
                                                               alpha: 0.13 + glow * 0.05),
                                                   light.accent.opacity(0.05)]),
                                 center: centre, startRadius: 0, endRadius: rx),
                 blend: .plusLighter,
                 \.impression)

        // Its lip, where the stone was displaced.
        pen.stroke(disc,
                   .color(light.accentBright.opacity(0.1 + 0.12 * scene.k + 0.1 * scene.b)),
                   width: 0.8 + CGFloat(scene.k * 0.6 + scene.b * 0.8),
                   blend: .plusLighter,
                   \.impression)

        // Design's two glow sprites, at 4.4 and 13 — the near bloom and the far
        // one. Additive, so they read as light and not as paint.
        for (spread, strength) in [(2.6, 0.17), (7.6, 0.07)] {
            let r = CGFloat(spread * k * (0.6 + 0.4 * scene.impressionScale))
            var bloom = Path()
            bloom.addEllipse(in: CGRect(x: centre.x - r, y: centre.y - r * 0.66,
                                        width: r * 2, height: r * 1.32))
            pen.fill(bloom,
                     .radialGradient(Gradient(colors: [light.accentBright.opacity(strength * scene.ember
                                                                                  * (0.55 + 0.45 * glow)),
                                                       light.accent.opacity(0)]),
                                     center: centre, startRadius: 0, endRadius: r),
                     blend: .plusLighter,
                     \.bloom)
        }
    }

    // MARK: the dust

    private static func drawDust(_ pen: inout Draftsman,
                                 frame: CGRect,
                                 lens: Lens,
                                 scene: PressScene,
                                 light: RoomLight) {
        var rand = Rand(seed: 0x6172_696D_4761_0004)
        for _ in 0..<moteCount {
            let bx = (rand.next() - 0.5) * 17
            let by = (rand.next() - 0.5) * 11 - 1.4
            let bz = (rand.next() - 0.5) * 16 - 1
            let seed = rand.next() * 6.283

            let x = bx + cos(scene.sway * 0.09 + seed) * 0.5
            let y = by + sin(scene.sway * 0.14 + seed) * 0.35 + scene.settle
            let p = lens.project(x, y, bz)
            guard frame.insetBy(dx: -8, dy: -8).contains(p) else { continue }

            let r = min(CGFloat(0.05 * lens.scale(atZ: bz)), 2.6)
            guard r > 0.4 else { continue }
            // The dust is only visible where light is: in the lit strip during
            // the press, and around the impression once the floor has turned.
            let lit = Rake.lit(y: y, z: bz, massBottomY: scene.massBottomY, diffusion: light.diffusion)
            let near = 1 / (1 + (x * x + (bz - World.impressionZ) * (bz - World.impressionZ)) / 60)
            let alpha = (0.05 + lit * scene.raking * 0.14 + near * scene.emissive * 0.22) * scene.ember
            guard alpha > 0.012 else { continue }
            pen.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                     .color(light.flare(scene.emissive * 0.5, alpha: min(alpha, 0.42))),
                     blend: .plusLighter,
                     \.dust)
        }
    }

    // MARK: the veil

    private static func drawVeil(_ pen: inout Draftsman, frame: CGRect, scene: PressScene) {
        // Corners darkened so the room has weight at its edges and the eye falls
        // to the floor. It thins as the floor takes the lighting over.
        let centre = CGPoint(x: frame.midX, y: frame.midY + frame.height * 0.14)
        pen.fill(Path(frame),
                 .radialGradient(Gradient(colors: [Color.clear,
                                                   Color.black.opacity(0.5 - 0.16 * scene.b)]),
                                 center: centre,
                                 startRadius: frame.width * 0.3,
                                 endRadius: frame.width * 1.05),
                 \.veil)
    }

    // MARK: the ember's falloff

    /// Design's `emberLight` — a point light at the impression. Inverse-square,
    /// with its reach set by the gem: a hard gem falls off fast.
    private static func emberFactor(x: Double, y: Double, z: Double,
                                    emberY: Double, light: RoomLight) -> Double {
        let dy = y - emberY
        let dz = z - World.impressionZ
        let reach = 6.0 * (1 + light.diffusion)
        return 0.45 / (1 + (x * x + dy * dy + dz * dz) / (reach * reach))
    }
}

private extension Path {
    mutating func addLineOrMove(to point: CGPoint, first: Bool) {
        if first { move(to: point) } else { addLine(to: point) }
    }
}

// MARK: - Her row
//
// The fixture the preview, the launch entry and the bench all use. Every value
// is the one Airtable holds for khaḍgamālā position 4 (Design's `homes-cards.js`
// is the same base), so a room handed the live `Shakti` renders identically.
// Law 1: she is built and found by position, never by name.

extension GarimaCanvasRoom {

    static let garimaPosition = 4

    static func garima() -> Shakti {
        Shakti(
            position: garimaPosition,
            name: "Garimā",
            shortName: "Garimā",
            phonetic: "",
            quality: "Weightedness",
            qualityDescription: "",
            somatic: "",
            somaticPoetry: "",
            bija: "",
            bodilyLocation: "Mūlādhāra / sit-bones / soles",
            tattva: "Pṛthvī — earth",
            recognitionPhrase: "",
            cluster: .inner,
            status: .mapped,
            khadgamalaPosition: garimaPosition,
            ringNumber: KhadgamalaMap.ringNumber(forKhadgamala: garimaPosition),
            devanagari: "गरिमा",
            appreciationPhrase: "Thank you for the weight that holds me here.",
            shaktiFunction: "")
    }
}

// MARK: - The launch-argument entry point
//
// `GARIMA_ROOM` shows the room over whatever is on screen, in its own window —
// the same trick `SpikeBench` uses, and for the same reason: the room must be
// drivable without the practitioner's own screens underneath it.
//
//   GARIMA_ROOM                  show the room
//   GARIMA_T=347                 open at a scene time (default 0)
//   GARIMA_REDUCE_MOTION         take the non-animated path
//
// It installs itself from here so that no file outside this one is touched —
// the sibling SceneKit variant needs the same hook in the same place, and two
// spikes editing `RootView` is exactly the collision the charter's parallelism
// rule forbids. Calling `present()` from a test drives it headlessly; one line
// in an app entry point would show it by hand.

enum GarimaRoomLaunch {

    struct Request: Equatable {
        var sceneTime: TimeInterval = 0
        var reduceMotion = false
    }

    static let flag = "GARIMA_ROOM"

    static func request(from arguments: [String] = ProcessInfo.processInfo.arguments) -> Request? {
        guard arguments.contains(flag) else { return nil }
        var r = Request()
        for a in arguments {
            if a.hasPrefix("GARIMA_T="), let v = TimeInterval(a.dropFirst("GARIMA_T=".count)) {
                r.sceneTime = v
            }
            if a == "GARIMA_REDUCE_MOTION" { r.reduceMotion = true }
        }
        return r
    }

    @MainActor
    private static var retained: UIWindow?

    /// Put the room on screen. Returns the window so a caller can take it down.
    @MainActor
    @discardableResult
    static func present(_ request: Request, shakti: Shakti) -> UIWindow {
        let clock = SpikeMetrics.Clock(offset: request.sceneTime)
        let host = UIHostingController(
            rootView: GarimaCanvasRoom(shakti: shakti,
                                       clock: clock,
                                       reduceMotion: request.reduceMotion))
        host.view.backgroundColor = .black

        let window: UIWindow
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })
            ?? UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first {
            window = UIWindow(windowScene: scene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = .alert + 1
        window.backgroundColor = .black
        window.isOpaque = true
        window.rootViewController = host
        window.makeKeyAndVisible()
        retained = window
        return window
    }

    /// The one-line hook. Nothing in the shipping tree calls it, by design.
    @MainActor
    @discardableResult
    static func presentIfRequested() -> Bool {
        guard let r = request() else { return false }
        present(r, shakti: GarimaCanvasRoom.garima())
        return true
    }

    @MainActor
    static func dismiss(_ window: UIWindow) {
        window.isHidden = true
        window.rootViewController = nil
        if retained === window { retained = nil }
    }
}

// MARK: - What the spike asserts
//
// The room's internals are file-private on purpose — every helper here belongs
// to this file and nothing else may build on them. These are the narrow readings
// `GarimaCanvasSpikeTests` needs to hold the room to Design's registers, and
// they are the only surface it gets.

extension GarimaCanvasRoom {

    /// Design's two clocks at a given moment: `smooth(t / 62)` and `deep(t)`.
    static func progressForTesting(_ t: TimeInterval) -> (first: Double, second: Double) {
        let s = PressScene(at: t, animates: false)
        return (s.k, s.b)
    }

    /// The readings that decide whether the room presses, and then turns.
    struct StateReading {
        let massBottomY: Double
        let displacement: Double
        let raking: Double
        let emissive: Double
        let impressionScale: Double
        let settle: Double
        /// How much of the floor, in world units, the raking light still reaches
        /// before the mass's shadow takes it.
        let litFloorDepth: Double
    }

    static func stateForTesting(at t: TimeInterval) -> StateReading {
        let s = PressScene(at: t, animates: false)
        let boundary = Rake.boundaryZ(atY: World.groundY, massBottomY: s.massBottomY)
        return StateReading(massBottomY: s.massBottomY,
                            displacement: s.displacement,
                            raking: s.raking,
                            emissive: s.emissive,
                            impressionScale: s.impressionScale,
                            settle: s.settle,
                            litFloorDepth: max(0, World.nearZ - max(boundary, World.backZ)))
    }

    /// Design's `GEM_BEHAVIOUR` diffusion column, as this room reads it.
    static func gemDiffusionForTesting(ring: Int) -> Double {
        RoomLight.gemDiffusion(ring: ring)
    }

    /// Her seat in the body, read from her own words.
    static func altitudeForTesting(of bodilyLocation: String) -> Double {
        RoomLight.altitude(of: bodilyLocation)
    }

    /// Her rock, keyed by khaḍgamālā position and nothing else.
    static func bedHeightsForTesting(position: Int) -> [Double] {
        Strata.beds(position: position).map(\.value)
    }
}

// MARK: - Previews

#Preview("Garimā · the press") {
    GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                     clock: SpikeMetrics.Clock(offset: 0))
}

#Preview("Garimā · the first adaptation") {
    GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                     clock: SpikeMetrics.Clock(),
                     frozenSceneTime: GarimaCanvasRoom.firstAdaptation)
}

#Preview("Garimā · past the second adaptation") {
    GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                     clock: SpikeMetrics.Clock(),
                     frozenSceneTime: GarimaCanvasRoom.secondAdaptationEnd + 53)
}

#Preview("Garimā · reduce motion") {
    GarimaCanvasRoom(shakti: GarimaCanvasRoom.garima(),
                     clock: SpikeMetrics.Clock(offset: 400),
                     reduceMotion: true)
}
#endif
