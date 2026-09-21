import Foundation
import SceneKit
import UIKit

// MARK: - The light in one room
//
// ``HomeGem`` as light rather than as palette, which is the whole reason the
// gem table exists. Design's §4.1 is a *behaviour* table — topaz 0.20 hard,
// pearl 0.95 "sourceless — no directional light at all", cat's eye 0.10 "one
// hard travelling band" — and the renderer ruling turned on it:
//
//     In SceneKit, Ring 7 having no directional light is one line. In a canvas
//     every one of those is a gradient somebody authors and a falloff somebody
//     fakes, 102 times.
//
// This file is that one line, and it is a real absence: ``key`` is `nil` in the
// seventh āvaraṇa, not dimmed. `RoomSceneTests` walks all nine rings and fails
// the build if a dim light is ever substituted for no light.
//
// ─────────────────────────────────────────────────────────────────────────────
// EVERY COLOUR IS THE APP'S, AND NONE OF IT IS THE GEMSTONE'S
// ─────────────────────────────────────────────────────────────────────────────
//
// ``HomeGem`` already carries the ruling Design made and then corrected: hue,
// saturation and lightness belong to ``Atmosphere`` and are never re-derived
// from a stone's name. So every colour below is `gem.hue`, `gem.bright` or
// `gem.ink` — her own light, her own lift, her own material — and the gem
// contributes exactly one number, `diffuse`, which decides how the light
// *behaves*.
//
// ─────────────────────────────────────────────────────────────────────────────
// ONE LAW FOR THE AMBIENT, RATHER THAN A SPECIAL CASE FOR THE SEVENTH
// ─────────────────────────────────────────────────────────────────────────────
//
// A room with no key light must still be a room. The ambient term is therefore
// written as a single law — the more diffuse the gem, the more of the room's
// light arrives from everywhere at once — so the Crown's pearl gets the most
// ambient light in the instrument *because it is the most diffuse gem*, not
// because a branch was written to rescue it. The sourcelessness is then the one
// `if` in this file, and it changes nothing except whether a key exists.

/// The lights of one room, and whether it has a source at all.
struct RoomLightRig {

    /// Her light, from ``Atmosphere`` through ``HomeGem``.
    let gem: HomeGem
    /// The world she stands in — its fog, and how veiled it is.
    let world: HomeWorld

    /// The key light, or **nothing at all** in the seventh āvaraṇa.
    ///
    /// `nil` here is the ruling: *"pearl at 0.95 is sourceless and has no
    /// directional light at all — one line here, and it must genuinely be no
    /// light rather than a dim one."*
    let key: SCNLight?
    /// The light in the mark she left. Bound to a placement, never free.
    let ember: SCNLight
    /// What arrives from everywhere at once.
    let ambient: SCNLight

    // MARK: - Constants

    /// The key's full strength before the room settles. Carried from the spike,
    /// where it was measured against a real shadow on real bedding.
    static let keyIntensity: Double = 2_600

    /// The ember at rest.
    static let emberIntensity: Double = 3_200

    /// What arrives from everywhere even in the hardest-lit room.
    static let ambientFloor: Double = 320

    /// How much of a key's worth of light a wholly diffuse gem turns into
    /// ambient. At the Crown this is the entire room.
    static let ambientFromDiffusion: Double = 0.45

    /// The key softens as the walker's eye settles — Design's rake, 3.6 → 1.6,
    /// as a fraction rather than as a second pair of numbers.
    static let keySettling: Double = 1 - 1.6 / 3.6

    /// How far a shadow's edge spreads with the gem's diffusion: a hard topaz
    /// room throws a nearly sharp edge, a ruby room a soft one.
    static func shadowRadius(diffuse: Double) -> Double { 0.5 + 6 * diffuse }

    /// What the ambient comes to for a gem. One law, no branch.
    static func ambientIntensity(diffuse: Double) -> Double {
        ambientFloor + keyIntensity * diffuse * ambientFromDiffusion
    }

    // MARK: - Derivation

    init(gem: HomeGem, world: HomeWorld) {
        self.gem = gem
        self.world = world

        let accent = Self.colour(gem.hue)
        let ink = Self.colour(gem.ink)

        if gem.hasDirectionalLight {
            let light = SCNLight()
            light.type = .directional
            light.color = accent
            light.intensity = CGFloat(Self.keyIntensity)
            light.castsShadow = true
            light.shadowMode = .forward
            light.shadowRadius = CGFloat(Self.shadowRadius(diffuse: gem.diffuse))
            light.shadowSampleCount = 8
            light.shadowMapSize = CGSize(width: 1024, height: 1024)
            light.shadowColor = ink.withAlphaComponent(0.78)
            light.orthographicScale = CGFloat(RoomUnits.halfExtent + RoomUnits.roomHeight / 2)
            light.zNear = 0.5
            light.zFar = CGFloat(RoomUnits.extent + RoomUnits.roomHeight * 2)
            key = light
        } else {
            // The Crown. There is no source, so there is no light — and with no
            // directional light there is nothing to cast, which is Design's own
            // "no shadow anywhere" without a second setting to keep in step.
            key = nil
        }

        let point = SCNLight()
        point.type = .omni
        point.color = Self.colour(gem.bright)
        point.intensity = CGFloat(Self.emberIntensity)
        point.attenuationEndDistance = CGFloat(RoomUnits.roomHeight * 3)
        point.attenuationFalloffExponent = 2
        ember = point

        let everywhere = SCNLight()
        everywhere.type = .ambient
        everywhere.color = accent
        everywhere.intensity = CGFloat(Self.ambientIntensity(diffuse: gem.diffuse))
        ambient = everywhere
    }

    /// Whether this room has a source of light at all.
    var isSourceless: Bool { key == nil }

    // MARK: - Where the light stands

    /// Where the key stands at rest: off to one side and above, so it rakes
    /// across the material rather than flattening it. In a sourceless room it
    /// is never read.
    static func keyPosition(settling k: Double, deep b: Double) -> SIMD3<Double> {
        let swing = 1 - b
        // It comes a little lower as the eye settles, so the rake lengthens
        // across the material instead of standing still above it.
        let above = (RoomUnits.canopyY + RoomUnits.roomHeight) - RoomUnits.roomHeight * 0.25 * k
        return SIMD3(RoomUnits.halfExtent * 0.55 * swing + RoomUnits.roomHeight * 0.3 * b,
                     above * swing - RoomUnits.roomHeight * 1.2 * b,
                     RoomUnits.roomHeight * (0.9 * swing - 0.3 * b))
    }

    /// The key's strength at a moment of the stay. It softens as the eye
    /// settles, and hands its work to the mark as the room reverses.
    static func keyStrength(settling k: Double, deep b: Double) -> Double {
        keyIntensity * (1 - keySettling * k) * (1 - 0.72 * b)
    }

    /// The ember's strength: it is the mark's own light, so it rises exactly as
    /// the mark's emission does.
    static func emberStrength(settling k: Double, deep b: Double) -> Double {
        emberIntensity * (0.4 + 0.3 * k + 0.6 * b)
    }

    /// Install every light into the layer that owns it, and hand back the two
    /// nodes a stay poses.
    ///
    /// The key and the ambient belong to the **world** — they are the āvaraṇa's
    /// weather. The ember belongs to her **mechanism**, and is placed at the
    /// mark rather than anywhere of its own choosing.
    ///
    /// The nodes are returned rather than looked up afterwards, for the reason
    /// the spike wrote down: a room poses sixty times a second and must never
    /// search its own graph to do it.
    @discardableResult
    func install(world worldRoot: SCNNode,
                 mechanism: SCNNode,
                 at placement: RoomPlacement) -> (key: SCNNode?, ember: SCNNode) {
        var keyNode: SCNNode?
        if let key {
            let node = SCNNode()
            node.light = key
            node.name = "key"
            let p = Self.keyPosition(settling: 0, deep: 0)
            node.position = SCNVector3(Float(p.x), Float(p.y), Float(p.z))
            node.look(at: SCNVector3(0, Float(RoomUnits.floorY), Float(placement.depth)))
            worldRoot.addChildNode(node)
            keyNode = node
        }

        let ambientNode = SCNNode()
        ambientNode.light = ambient
        ambientNode.name = "ambient"
        worldRoot.addChildNode(ambientNode)

        let emberNode = SCNNode()
        emberNode.light = ember
        emberNode.name = "ember"
        emberNode.position = SCNVector3(0,
                                        Float(placement.height + RoomUnits.roomHeight * 0.12),
                                        Float(placement.depth))
        mechanism.addChildNode(emberNode)

        return (keyNode, emberNode)
    }

    /// The fog the world stands in — Design's own colour and density, with the
    /// veil's grip already applied by ``HomeWorld/veiledFogDensity``.
    ///
    /// SceneKit's fog is a distance band rather than a density, so the density
    /// is read as *how early the air closes*: the ninth world's veil brings the
    /// far wall almost to the walker, and the first world's leaves it in view.
    func applyFog(to scene: SCNScene) {
        let density = world.veiledFogDensity
        scene.fogColor = Self.colour(fogHSL)
        // Design's densities run 0.009 → 0.034 before the veil. Normalised
        // against that band so the fog is a proportion of the room rather than
        // a three.js exponential nobody can read.
        let closed = min(1, max(0, (density - Self.thinnestFog) / (Self.thickestFog - Self.thinnestFog)))
        scene.fogStartDistance = CGFloat(RoomUnits.roomHeight * (1.6 - 0.9 * closed))
        scene.fogEndDistance = CGFloat(RoomUnits.extent * (1.0 - 0.55 * closed))
        scene.fogDensityExponent = 2
    }

    /// The thinnest and thickest fog Design authored, read off the table rather
    /// than typed, so a retuned world arrives here.
    static let thinnestFog: Double =
        HomeWorlds.worlds.values.map(\.veiledFogDensity).min() ?? 0
    static let thickestFog: Double =
        HomeWorlds.worlds.values.map(\.veiledFogDensity).max() ?? 1

    /// The world's own fog colour, brought into her hue's saturation so a room
    /// is one light rather than a coloured mist over a different coloured stone.
    private var fogHSL: HSL {
        HSL(h: gem.hue.h,
            s: gem.hue.s * 0.4,
            l: (world.fog.red + world.fog.green + world.fog.blue) / 3 * 100)
    }

    /// An `HSL` as a platform colour. The only conversion in this file, and it
    /// derives nothing: it hands ``Atmosphere``'s numbers to SceneKit.
    static func colour(_ hsl: HSL) -> UIColor {
        let rgb = hsl.rgb
        return UIColor(red: CGFloat(rgb.r), green: CGFloat(rgb.g), blue: CGFloat(rgb.b), alpha: 1)
    }
}
