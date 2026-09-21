import Foundation
import SceneKit
import Metal
import UIKit

// MARK: - The climb, assembled
//
// One space, nine bands tall, and the walker rises through it. There is no
// screen for an āvaraṇa and no door into one: Ruling 1 cut the nine worlds as
// nine screens in July and they do not come back.
//
// ─────────────────────────────────────────────────────────────────────────────
// AN OPEN WORLD WITH A VAST FLOOR, NOT NINE ROOMS STACKED
// ─────────────────────────────────────────────────────────────────────────────
//
// The Axis is an open space: a floor, fog, and the band's own weather in it.
// There are no walls, and the first picture of this phase is why that matters
// rather than being a preference. Built as a shaft — three walls running the
// whole climb with each band's condition worked into its own stretch — the
// first āvaraṇa rendered as a dark corridor with a few motes in it, sixteen
// units of unlit stone in every direction, and **every luminance check passed.**
// *"Low light raking a vast floor"* has to be a floor, and it has to be
// underfoot.
//
// So the building is one surface: the ground of the world the walker is in.
// Design builds nine bands at nine heights and shows only the near one; the
// continuous form of "only the near one" is **one ground whose material is the
// blend** — a morph over the nine band materials, weighed by
// ``WorldClimb/weights(atFraction:)``, which are the same numbers the fog, the
// veil and the light are blended over. There is no seam to cross because there
// is no join, and the material cannot develop one the weather does not have.
//
// ─────────────────────────────────────────────────────────────────────────────
// ONE LIGHT, BLENDED, AND THE SEVENTH ĀVARAṆA HAS NONE
// ─────────────────────────────────────────────────────────────────────────────
//
// Design's file gives each band its own rig — nine keys, nine ambients, two
// shadow maps. The renderer ruling named that as its own revisit condition:
// *"the +6.5 MB does not stay flat with nine ring worlds resident; if nine
// lighting rigs and their maps live at once, re-measure before Phase 3.2 ships."*
//
// It is answered structurally rather than by measurement. There is **one** key
// in the whole climb and one shadow map, and where it stands, what colour it
// is and how strong it burns are the blend of the bands the walker is between.
// So the memory is a constant, the crossing is continuous by construction, and
// the Crown's sourcelessness is what it has always been: the light is not dimmed
// as he reaches the seventh station — ``keyNode``'s light is set to `nil` and
// there is no directional light in the world at all. ``activeKeys`` is the
// number a test reads, and it is zero there.
//
// ─────────────────────────────────────────────────────────────────────────────
// WHAT IS NOT HERE
// ─────────────────────────────────────────────────────────────────────────────
//
// There is no third depth layer. Design's three are the building, the world and
// **her mechanism** — and on the axis there is no her. Nothing in this scene is
// a Śakti, so nothing in it may be a solid standing in the air, and
// `WorldClimbTests` counts what it holds. The binding condition is not weakened
// on the axis; it has nothing to act on.
//
// The whole climb is therefore **two meshes**: the ground, and the air.

/// The nine worlds as one space, on the ruled renderer.
final class WorldClimbScene {

    // MARK: - Design's depth layers, as named node roots

    /// Which layer is being asked about. Two, not three — see the header.
    enum Layer: String, CaseIterable, Equatable {
        /// The ground: the stone of the world the walker is standing in.
        case ground
        /// The world: the air, and the light it arrives by.
        case world
    }

    private let building = SCNNode()
    private let weather = SCNNode()
    private let cameraNode = SCNNode()

    private let scene = SCNScene()
    private let keyNode = SCNNode()
    private let keyLight = SCNLight()
    private let ambientNode = SCNNode()
    private let ambientLight = SCNLight()
    private let groundNode = SCNNode()
    private var motesMaterial: SCNMaterial?
    private var groundStone: SCNMaterial?
    /// Each band's own light, baked once. Nine small maps.
    private var bandLight: [CGImage?] = []
    /// Which band's light the ground is wearing. Exchanged only where the
    /// walker is equally in two, which is where it is showing none.
    private var showingBand = 1

    /// Where the walker was last stood, in bands.
    private(set) var standingAt: Double = 0
    /// The real time the climb was last put at.
    private(set) var breathedAt: TimeInterval = 0
    /// The weather he was last given.
    private(set) var weatherNow: WorldWeather

    // MARK: - Constants

    /// Vertices per side of the ground. Forty-eight is fine enough that a rib
    /// reads as a rib underfoot and coarse enough that nine of them are one
    /// mesh build rather than a wait.
    static let groundResolution = 48

    /// How many motes stand in the whole climb. Nine bands of air at the room's
    /// own density, so a band holds about what a room holds.
    static let moteCount = 900

    /// How far the eye stands above the station it is level with: exactly where
    /// the body's own eyes are in a room, read through ``RoomUnits`` rather than
    /// chosen, so the walker is the same height on the axis as in her room.
    static var eyeRise: Double { RoomUnits.eyeY - RoomUnits.floorY }

    /// How far the eye inclines toward the ground.
    ///
    /// **Not chosen — it is ``RoomUnits/gaze`` applied to the axis.** In a room
    /// the eye inclines `0.55` of the whole angle to her mark; here there is no
    /// mark, so it inclines the same fraction of the angle down to the far edge
    /// of the ground he is crossing. Level, it looks at the sky and the world he
    /// is rising through sits in the bottom fifth of the frame — which is what
    /// the first picture of the open world showed.
    static var gaze: Double { -RoomUnits.gaze * atan2(eyeRise, RoomUnits.halfExtent) }

    /// How far out the one key light stands. A whole room's width, because a
    /// directional light's shadow frustum is built around its own position: put
    /// it a body-height out and it stands *in* the world, and the ground beyond
    /// its near plane comes back unlit.
    static var keyStandOff: Double { RoomUnits.extent }

    /// Where the ground is centred, away from the walker.
    ///
    /// **The world is in front of you.** Centred on the origin, the near half of
    /// the ground is under and behind the walker's own feet and the eye can only
    /// ever see the far fifth of it, so a band's condition — eleven standing
    /// stones, nine bodies that glow, twenty-four ribs — is almost entirely
    /// behind him. Pushed out by half its own width, the ground's near edge is
    /// exactly underfoot and the whole of it is ahead.
    static var groundAhead: Double { RoomUnits.eyeZ - RoomUnits.halfExtent }

    /// Design's axis sway — `axisEye = (sin(t * 0.07) * 0.5, climb + 1.2, 9 + cos(t * 0.05) * 0.4)`.
    ///
    /// Its two amplitudes are ported as proportions of the spacing, because
    /// Design's are against its own `SPACING = 30`. It is what keeps the axis
    /// from being a slider: the walker is standing there, not being moved along
    /// a rail.
    ///
    /// **And it runs on real time, not on a world clock.** The sway is the
    /// walker's own body, so no āvaraṇa's tempo touches it — the one thing on
    /// the climb the mental state does not slow down.
    static let swayAcross: Double = 0.5 / 30
    static let swayDepth: Double = 0.4 / 30
    static let swayAcrossRate: Double = 0.07
    static let swayDepthRate: Double = 0.05

    // MARK: - Assembly

    init() {
        weatherNow = WorldClimb.weather(atFraction: 0, at: 0)

        building.name = "ground"
        weather.name = "world"

        buildGround()
        buildAir()
        buildLight()

        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(RoomUnits.fieldOfView)
        camera.zNear = RoomUnits.zNear
        camera.zFar = RoomUnits.zFar
        camera.wantsHDR = false
        cameraNode.camera = camera
        cameraNode.name = "eye"

        scene.rootNode.addChildNode(building)
        scene.rootNode.addChildNode(weather)
        scene.rootNode.addChildNode(cameraNode)
        scene.fogDensityExponent = 2

        stand(atFraction: 0, at: 0)
    }

    // MARK: - Where the walker stands

    /// Put the walker at a height of the climb, at a moment of real time.
    ///
    /// Pure in everything but its writes: the same height and the same instant
    /// always produce the same climb, which is what lets the reduce-motion path
    /// draw once and the tests assert a rise with no renderer in the room.
    ///
    /// `seconds` is **real** time. Each band scales it by its own tempo inside
    /// ``WorldBands/reading(ring:at:)``, and no chamber clock reaches this far:
    /// there is no parameter here for one.
    func stand(atFraction f: Double, at seconds: TimeInterval) {
        let here = WorldClimbTravel.clamp(f)
        let travelled = abs(here - standingAt)
        standingAt = here
        breathedAt = seconds

        let now = WorldClimb.weather(atFraction: here, at: seconds)
        let near = WorldClimb.weights(atFraction: here)
        weatherNow = now

        // ── the eye ─────────────────────────────────────────────────────────
        // Inclined toward the ground he is crossing, and by nothing else: on
        // the axis there is no mark to look at, and a pitch that tracked one
        // would make some one band the place to be.
        cameraNode.position = SCNVector3(
            Float(sin(seconds * Self.swayAcrossRate) * Self.swayAcross * WorldClimb.spacing),
            Float(WorldClimb.height(atFraction: here) + Self.eyeRise),
            Float(RoomUnits.eyeZ + cos(seconds * Self.swayDepthRate) * Self.swayDepth * WorldClimb.spacing))
        cameraNode.eulerAngles = SCNVector3(Float(Self.gaze), 0, 0)

        // ── the air ─────────────────────────────────────────────────────────
        let fog = UIColor(red: CGFloat(now.fog.x), green: CGFloat(now.fog.y),
                          blue: CGFloat(now.fog.z), alpha: 1)
        scene.fogColor = fog
        // The same law a room's air is closed by, read from where it lives.
        let band = RoomLightRig.fogBand(density: now.fogDensity)
        scene.fogStartDistance = CGFloat(band.start)
        scene.fogEndDistance = CGFloat(band.end)
        scene.background.contents = UIColor(red: CGFloat(now.fog.x * 0.5),
                                            green: CGFloat(now.fog.y * 0.5),
                                            blue: CGFloat(now.fog.z * 0.5), alpha: 1)

        motesMaterial?.setValue(NSNumber(value: Float(seconds)), forKey: "uTime")
        motesMaterial?.setValue(NSNumber(value: Float(now.airDrift)), forKey: "uDrift")
        motesMaterial?.transparency = CGFloat(0.16 + 0.30 * now.veil)

        // ── the light ───────────────────────────────────────────────────────
        // Every colour is the app's own, through ``Atmosphere`` and ``HomeGem``:
        // her hue, her lift, her material. The gemstone's name contributes
        // nothing but behaviour, which is `diffuse`.
        let accent = Self.blendedColour(atFraction: here) { $0.hue }
        let bright = Self.blendedColour(atFraction: here) { $0.bright }
        let ink = Self.blendedColour(atFraction: here) { $0.ink }
        let diffuse = Self.blendedDiffusion(atFraction: here)
        motesMaterial?.diffuse.contents = bright

        if let direction = now.key, now.keyStrength > 0 {
            keyLight.color = accent
            keyLight.intensity = CGFloat(RoomLightRig.keyIntensity * now.keyStrength)
            keyLight.shadowRadius = CGFloat(RoomLightRig.shadowRadius(diffuse: diffuse))
            keyNode.light = keyLight
            // It stands a whole room's width out along the direction it
            // arrives from, and looks at the ground the walker is on — so the
            // rake is across the ground he is standing on rather than across
            // the floor of a band he left. A body-height would have put it in
            // among the ground it is meant to be raking, where a directional
            // light's own shadow frustum does not cover what it is lighting.
            let ground = WorldClimb.height(atFraction: here)
            let stand = direction * Self.keyStandOff
            keyNode.position = SCNVector3(Float(stand.x), Float(ground + stand.y),
                                          Float(Self.groundAhead + stand.z))
            keyNode.look(at: SCNVector3(0, Float(ground), Float(Self.groundAhead)))
        } else {
            // The seventh āvaraṇa. Not dimmed — absent, and with no directional
            // light there is nothing to cast, which is Design's *"no shadow
            // anywhere"* without a second setting to keep in step.
            keyNode.light = nil
        }

        ambientLight.color = accent
        ambientLight.intensity = CGFloat(RoomLightRig.ambientIntensity(diffuse: diffuse)
                                         * now.ambientStrength)

        // ── the ground ──────────────────────────────────────────────────────
        //
        // The ground is the climb's own height — the stations weigh
        // `station(lower)·(1-k) + station(upper)·k`, which is exactly
        // ``WorldClimb/height(atFraction:)`` — so it is never placed, and the
        // eye stands its own eye-height above it in every āvaraṇa exactly as it
        // stands in a room.
        groundNode.position = SCNVector3(0, Float(WorldClimb.height(atFraction: here)),
                                         Float(Self.groundAhead))

        // Its material is the blend, as a morph over the nine bands: the first
        // band is the base and carries whatever weight the eight targets leave.
        if let morpher = groundNode.morpher {
            var weights = [Double](repeating: 0, count: HomeWorlds.rings.count)
            for entry in near where entry.ring >= 1 && entry.ring <= weights.count {
                weights[entry.ring - 1] = entry.weight
            }
            for target in 0..<morpher.targets.count {
                morpher.setWeight(CGFloat(weights[target + 1]), forTargetAt: target)
            }
        }

        // The dhātu: the band's own hue, desaturated and taken nearly to black,
        // so the ground is made of *this* world's material rather than of a
        // neutral grey a coloured light happens to fall on.
        groundStone?.diffuse.contents = ink

        // Its own light. The pattern belongs to one band and cannot be
        // cross-faded, so it is exchanged exactly where it is showing none —
        // see ``WorldClimb/wholeness(atFraction:)``.
        let whole = WorldClimb.wholeness(atFraction: here)
        let nearest = WorldClimb.nearestRing(atFraction: here)
        // …or wherever the walker was *put* rather than walked. Half a band in
        // one call is thirty bands a second at sixty frames, which no hand can
        // do: it is a capture, a launch, or the quantized step reduce motion
        // takes, and in all three the whole frame changed anyway so there is no
        // continuity left to protect. Without this the map only ever changed
        // while passing through a midpoint, so a climb that *opened* at the
        // sixth āvaraṇa wore the first's light — which is to say none — and its
        // nine glowing bodies were simply missing.
        if nearest != showingBand, whole <= 0.0001 || travelled > 0.5 {
            showingBand = nearest
            groundStone?.emission.contents = bandLight[nearest - 1]
        }
        groundStone?.emission.intensity = CGFloat(Self.glowCeiling * now.glowFromWithin * whole)
    }

    /// How brightly a band's own light can show. Design's §4.4 reading, carried
    /// over from a room: the material becomes the light, so the top of this
    /// range is ground glowing rather than a lamp lying on it.
    static let glowCeiling: Double = 0.55

    // MARK: - Where the climb goes

    /// Put the climb into a view. The scene is never handed out — the same rule
    /// ``RoomScene`` keeps, for the same reason.
    func install(into view: SCNView) {
        view.scene = scene
        view.pointOfView = cameraNode
        view.backgroundColor = UIColor.black
        view.isOpaque = true
        view.antialiasingMode = .multisampling2X
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
    }

    /// The climb, rendered offscreen at one height and one moment.
    ///
    /// The ruling recorded that SwiftUI cannot screenshot a `CAMetalLayer`, so
    /// the legibility register has to go around it. This is that door for the
    /// axis: no window, no host application.
    func capture(size: CGSize, atFraction f: Double, at seconds: TimeInterval) -> CGImage? {
        stand(atFraction: f, at: seconds)
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        let renderer = SCNRenderer(device: device, options: nil)
        renderer.scene = scene
        renderer.pointOfView = cameraNode
        renderer.autoenablesDefaultLighting = false
        return renderer.snapshot(atTime: 0, with: size, antialiasingMode: .none).cgImage
    }

    // MARK: - What the graph will answer, without handing itself over

    private func root(of layer: Layer) -> SCNNode {
        switch layer {
        case .ground: return building
        case .world: return weather
        }
    }

    func layerName(_ layer: Layer) -> String? { root(of: layer).name }

    /// How many meshes stand anywhere under one layer.
    func solids(in layer: Layer) -> Int {
        var count = 0
        func walk(_ node: SCNNode) {
            if node.geometry != nil { count += 1 }
            node.childNodes.forEach(walk)
        }
        walk(root(of: layer))
        return count
    }

    /// Every mesh in the whole climb, at any depth. The binding condition as a
    /// number: it is the ground the walker stands on and the air he stands in,
    /// and nothing else anywhere.
    var solidsInTheClimb: Int {
        var count = 0
        func walk(_ node: SCNNode) {
            if node.geometry != nil { count += 1 }
            node.childNodes.forEach(walk)
        }
        walk(scene.rootNode)
        return count
    }

    /// How many directional lights are burning. Zero at the seventh station.
    var activeKeys: Int {
        var count = 0
        func walk(_ node: SCNNode) {
            if node.light?.type == .directional { count += 1 }
            node.childNodes.forEach(walk)
        }
        walk(scene.rootNode)
        return count
    }

    /// The ground's morph, as the facts a check needs about it.
    struct GroundFacts: Equatable {
        /// How many bands it morphs *toward*. Eight: the base is the first.
        let adaptations: Int
        /// Whether they blend normalised. Additively, two bands at full weight
        /// would arrive at `first + second - base` and overshoot the ground by
        /// the whole of the band beneath it.
        let isNormalised: Bool
    }

    var groundFacts: GroundFacts? {
        guard let morpher = groundNode.morpher else { return nil }
        return GroundFacts(adaptations: morpher.targets.count,
                           isNormalised: morpher.calculationMode == .normalized)
    }

    /// How much of each band the ground is, at the height it was last stood at.
    /// Nine numbers that sum to one — the base's share is what the targets leave.
    var groundWeights: [Double] {
        guard let morpher = groundNode.morpher else { return [] }
        var out = [Double](repeating: 0, count: HomeWorlds.rings.count)
        var used = 0.0
        for target in 0..<morpher.targets.count {
            let weight = Double(morpher.weight(forTargetAt: target))
            out[target + 1] = weight
            used += weight
        }
        out[0] = max(0, 1 - used)
        return out
    }

    /// Where the eye stands, in scene units. Read-only: it is put where it goes
    /// by ``stand(atFraction:at:)`` and by nothing else anywhere.
    var eye: SIMD3<Double> {
        SIMD3(Double(cameraNode.position.x),
              Double(cameraNode.position.y),
              Double(cameraNode.position.z))
    }

    // MARK: - The ground

    /// The ground of the world the walker is in.
    ///
    /// **One surface, nine materials, and a morph between them.** Design builds
    /// nine bands at nine heights and shows only the near one; the continuous
    /// form of "only the near one" is one ground whose *material* is the blend
    /// of the bands the walker is between. So the climb has no walls and no
    /// stack of floors: it is an open world with a vast floor, exactly as the
    /// Axis is, and what changes as he rises is the ground itself under his
    /// feet, the air around him and where the light comes from.
    ///
    /// The morph's weights are ``WorldClimb/weights(atFraction:)`` — the same
    /// numbers the fog, the veil and the key are blended over — so the material
    /// cannot develop a seam the weather does not also have. Nine targets,
    /// never more than two of them non-zero.
    ///
    /// It is also the answer to the first thing a picture of this phase showed
    /// and no assertion could: with the bands on walls sixteen units away the
    /// first āvaraṇa rendered as a dark corridor with a few motes in it, and
    /// every luminance check passed. *"A vast floor raked by low light"* has to
    /// be a floor, and it has to be underfoot.
    private func buildGround() {
        let material = Self.stone()
        groundStone = material

        let shapes = HomeWorlds.rings.compactMap { WorldBands.stones[$0] }
        let geometries = shapes.map {
            RoomScene.mesh(of: $0, extent: RoomUnits.extent,
                           orientation: .floor, resolution: Self.groundResolution)
        }
        geometries.forEach { $0.materials = [material] }

        groundNode.geometry = geometries[0]
        // Base plus eight, blended normalised: the base carries whatever weight
        // the targets leave, which is the first band's own. Additively they
        // would overshoot every band by the whole of the one beneath it.
        groundNode.morpher = RoomScene.morpher(Array(geometries.dropFirst()))
        groundNode.name = "ground"
        // The stone casts on itself, and that is where the weather is: the Feet
        // band's standing stones are swells in this ground, and Design's own
        // note on them is that they *"exist only to be raked — long shadows are
        // the weather."* With no free object anywhere in the climb, a band's own
        // relief is the only thing there is to throw one.
        groundNode.castsShadow = true
        building.addChildNode(groundNode)

        bandLight = HomeWorlds.rings.map { Self.emissionMap(ring: $0) }
        showingBand = 1
        material.emission.contents = bandLight[0]
        material.emission.intensity = 0
    }

    /// The ground's stone. Its colour and its own light are set as the walker
    /// rises; what is fixed here is that it is stone.
    static func stone() -> SCNMaterial {
        let m = SCNMaterial()
        m.lightingModel = .blinn
        m.isLitPerPixel = true
        m.isDoubleSided = true
        m.specular.contents = UIColor(white: 0.08, alpha: 1)
        m.shininess = 0.04
        m.diffuse.contents = UIColor(white: 0.1, alpha: 1)
        return m
    }

    /// One band's own light, as a small map.
    ///
    /// It goes through ``RoomMaterial/emission(at:)``, so the binding condition
    /// holds here exactly as it holds in a room: a glow is multiplied by how far
    /// the material actually moved, and ground that nothing happened to emits
    /// nothing at any brightness. Four bands carry one at all — the Forehead's
    /// nine bodies, the Crown's veils, the one meridian above it, Totality's
    /// yantra — and the other five are dark maps, which is not a special case
    /// but the arithmetic answering honestly.
    ///
    /// Four channels rather than one for the reason `RoomScene` records: a
    /// single-channel 8-bit `CGImage` reaches Metal as `r8Unorm_sRGB`, which the
    /// simulator's device rejects with a hard assertion and takes the process
    /// down with it.
    static func emissionMap(ring: Int, side: Int = 64) -> CGImage? {
        guard let stone = WorldBands.stones[ring] else { return nil }
        // The light in the ground is **this world's** light, not white. Her
        // lift, through `Atmosphere` and `HomeGem`, the same colour her key and
        // her ambient are — so a band that glows from within glows its own
        // colour rather than turning its own stone grey.
        let bright = HomeGem.gemFor(ring: ring, khadgamalaPosition: nil).bright.rgb
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        for j in 0..<side {
            for i in 0..<side {
                let point = SurfaceCoordinate(u: Double(i) / Double(side - 1),
                                              v: Double(j) / Double(side - 1))
                let lit = stone.emission(at: point)
                let offset = (j * side + i) * 4
                pixels[offset] = UInt8(min(255, max(0, lit * bright.r * 255)))
                pixels[offset + 1] = UInt8(min(255, max(0, lit * bright.g * 255)))
                pixels[offset + 2] = UInt8(min(255, max(0, lit * bright.b * 255)))
                pixels[offset + 3] = 255
            }
        }
        guard let provider = CGDataProvider(data: Data(pixels) as CFData) else { return nil }
        return CGImage(width: side, height: side, bitsPerComponent: 8, bitsPerPixel: 32,
                       bytesPerRow: side * 4,
                       space: CGColorSpaceCreateDeviceRGB(),
                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
                       provider: provider, decode: nil, shouldInterpolate: true,
                       intent: .defaultIntent)
    }

    // MARK: - The air

    private func buildAir() {
        var points = [SCNVector3]()
        points.reserveCapacity(Self.moteCount)
        var state = UInt64(0x9E37_79B9_7F4A_7C15)
        func next() -> Double {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            return Double((state >> 33) % 100_000) / 100_000
        }
        let climb = WorldClimb.spacing * Double(HomeWorlds.rings.count - 1)
        for _ in 0..<Self.moteCount {
            points.append(SCNVector3(Float((next() - 0.5) * RoomUnits.extent * 0.7),
                                     Float(WorldClimb.bottom + next() * climb),
                                     Float((next() - 0.5) * RoomUnits.extent * 0.7)))
        }
        let source = SCNGeometrySource(vertices: points)
        let element = SCNGeometryElement(indices: (0..<Int32(Self.moteCount)).map { $0 },
                                         primitiveType: .point)
        element.pointSize = 2.4
        // Design's invariant 7: additive particles near the eye stack to white,
        // so the screen-space radius is clamped. Carried from the spike, where
        // it was measured rather than guessed.
        element.minimumPointScreenSpaceRadius = 0.6
        element.maximumPointScreenSpaceRadius = 3.0

        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = UIColor(white: 0.85, alpha: 1)
        material.blendMode = .add
        material.writesToDepthBuffer = false
        material.name = "motes"
        // A Swift string SceneKit compiles at run time — no build-target file
        // and nothing in the shipping binary.
        material.shaderModifiers = [
            .geometry: """
            #pragma arguments
            float uTime;
            float uDrift;
            #pragma body
            float s = _geometry.position.x * 12.9898 + _geometry.position.y * 78.233;
            float ph = fract(sin(s) * 43758.5453) * 6.2831853;
            _geometry.position.y += sin(uTime * 0.11 * uDrift + ph) * 0.42;
            _geometry.position.x += cos(uTime * 0.07 * uDrift + ph) * 0.24;
            """
        ]
        // Seeded as `Float`: SceneKit keys a shader argument by the type it
        // first sees, and a `Double` seed makes every later `Float` write a
        // type switch that animates wrong.
        material.setValue(NSNumber(value: Float(0)), forKey: "uTime")
        material.setValue(NSNumber(value: Float(1)), forKey: "uDrift")
        motesMaterial = material

        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.materials = [material]
        let node = SCNNode(geometry: geometry)
        node.name = "motes"
        node.castsShadow = false
        weather.addChildNode(node)
    }

    // MARK: - The light

    private func buildLight() {
        keyLight.type = .directional
        keyLight.castsShadow = true
        keyLight.shadowMode = .forward
        keyLight.shadowSampleCount = 8
        keyLight.shadowMapSize = CGSize(width: 1024, height: 1024)
        // Wide enough to cover the whole floor of a band at any angle, and deep
        // enough that nothing the walker can see falls outside the frustum and
        // renders as though it were in shadow.
        keyLight.orthographicScale = CGFloat(RoomUnits.extent)
        keyLight.zNear = 0.5
        keyLight.zFar = CGFloat(Self.keyStandOff * 2 + RoomUnits.extent)
        keyNode.name = "key"
        keyNode.light = keyLight
        weather.addChildNode(keyNode)

        ambientLight.type = .ambient
        ambientNode.name = "ambient"
        ambientNode.light = ambientLight
        weather.addChildNode(ambientNode)
    }

    // MARK: - Colour, blended over the same weights as everything else

    /// The gem's light of the bands the walker is between.
    ///
    /// Every colour here is ``Atmosphere``'s through ``HomeGem``, and the gem
    /// is asked for the world **shown empty** — `khadgamalaPosition: nil`, the
    /// ring's own unjittered seed — because there is no Śakti on the axis and a
    /// world must be felt before any Śakti is set inside it.
    static func blendedColour(atFraction f: Double, _ pick: (HomeGem) -> HSL) -> UIColor {
        var r = 0.0, g = 0.0, b = 0.0
        for entry in WorldClimb.weights(atFraction: f) {
            let rgb = pick(HomeGem.gemFor(ring: entry.ring, khadgamalaPosition: nil)).rgb
            r += rgb.r * entry.weight
            g += rgb.g * entry.weight
            b += rgb.b * entry.weight
        }
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
    }

    /// How diffuse the light is here — Design's gem behaviour table, blended.
    static func blendedDiffusion(atFraction f: Double) -> Double {
        WorldClimb.weights(atFraction: f).reduce(0) { sum, entry in
            sum + HomeGem.gemFor(ring: entry.ring, khadgamalaPosition: nil).diffuse * entry.weight
        }
    }

}
